/*
 * Coroutine vs Thread Performance Benchmark (Java 21+)
 *
 * 对比 Virtual Threads (JEP 444, 有栈协程) 与 Platform Threads (传统线程) 在高并发
 * I/O 密集型场景下的性能差异。
 *
 * 编译 & 运行：
 *     javac --release 21 CoroutineBenchmark.java
 *     java -Xms256m -Xmx2g CoroutineBenchmark
 *
 * 推荐 JVM 参数（观察内存差异）：
 *     java -Xms256m -Xmx2g -XX:+PrintGC CoroutineBenchmark
 */

import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Supplier;

public class CoroutineBenchmark {

    // ── 实验配置 ──────────────────────────────

    static final long TASK_DURATION_MS = 100;          // 每个任务模拟 I/O 的阻塞时间
    static final int[] CONCURRENCY_LEVELS = {100, 500, 1_000, 5_000, 10_000, 50_000};
    static final int[] PLATFORM_POOL_SIZES = {200, 500, 1_000};

    // ── 结果结构 ──────────────────────────────

    record BenchResult(
        String name,
        int n,
        int poolSize,          // 0 = 无限制
        long durationMs,
        long heapDeltaBytes,    // 堆内存增量
        long peakHeapBytes,     // 峰值堆内存
        boolean success,
        String error
    ) {
        double heapDeltaMB() { return heapDeltaBytes / (1024.0 * 1024.0); }
        double peakHeapMB()   { return peakHeapBytes / (1024.0 * 1024.0); }
        double throughput()   { return success ? (double) n / (durationMs / 1000.0) : 0; }

        @Override
        public String toString() {
            if (!success) return "FAIL: " + error;
            return String.format("time=%6dms | heap_Δ=%8.2f MB | peak=%8.2f MB | throughput=%10.0f t/s",
                durationMs, heapDeltaMB(), peakHeapMB(), throughput());
        }
    }

    // ── 内存测量工具 ──────────────────────────

    static long getUsedHeap() {
        Runtime rt = Runtime.getRuntime();
        return rt.totalMemory() - rt.freeMemory();
    }

    static void forceGC() {
        System.gc();
        try { Thread.sleep(100); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
    }

    // ── 测量脚手架 ────────────────────────────

    static BenchResult measure(String name, int n, int poolSize, ExceptionalRunnable fn) {
        forceGC();
        long heapBefore = getUsedHeap();

        // 启动后台采样线程捕获峰值堆内存
        AtomicInteger peakHolder = new AtomicInteger();
        Thread sampler = new Thread(() -> {
            while (!Thread.currentThread().isInterrupted()) {
                long current = getUsedHeap();
                int currentMB = (int) (current / (1024 * 1024));
                peakHolder.updateAndGet(prev -> Math.max(prev, currentMB));
                try { Thread.sleep(10); } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        });
        sampler.setDaemon(true);
        sampler.start();

        Instant start = Instant.now();
        try {
            fn.run();
            long elapsed = Duration.between(start, Instant.now()).toMillis();
            sampler.interrupt();
            sampler.join(500);

            forceGC();
            long heapAfter = getUsedHeap();

            return new BenchResult(name, n, poolSize, elapsed,
                Math.max(0, heapAfter - heapBefore),
                Math.max(0, peakHolder.get() * 1024L * 1024L - heapBefore),
                true, null);

        } catch (OutOfMemoryError oom) {
            sampler.interrupt();
            return new BenchResult(name, n, poolSize, -1, -1, -1, false,
                "OutOfMemoryError: " + oom.getMessage());
        } catch (Exception e) {
            sampler.interrupt();
            return new BenchResult(name, n, poolSize, -1, -1, -1, false,
                e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }

    @FunctionalInterface
    interface ExceptionalRunnable {
        void run() throws Exception;
    }

    // ── 通用 I/O 任务 ─────────────────────────

    static Callable<Integer> ioTask(int id) {
        return () -> {
            Thread.sleep(TASK_DURATION_MS);  // 模拟 I/O 阻塞
            return id;
        };
    }

    // ── 方案 A: Virtual Threads（有栈协程）───
    // 每个任务一个虚拟线程，无限制并发。虚拟线程在 sleep 期间卸载出 carrier thread，
    // 所以 OS 线程不会被阻塞，可以服务其他虚拟线程。

    static BenchResult runVirtualThreadBenchmark(int n) {
        return measure("VirtualThread", n, 0, () -> {
            try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
                var futures = new ArrayList<Future<Integer>>(n);
                for (int i = 0; i < n; i++) {
                    final int id = i;
                    futures.add(executor.submit(ioTask(id)));
                }
                // 等待全部完成
                for (var f : futures) {
                    f.get();
                }
            }
        });
    }

    // ── 方案 B: Platform Threads（固定线程池）─
    // 传统线程池，线程数 = poolSize。当 N > poolSize 时，多余任务排队等待，
    // 总耗时 ≈ ceil(N / poolSize) × TASK_DURATION_MS

    static BenchResult runPlatformPoolBenchmark(int n, int poolSize) {
        return measure("PlatformThread(P=" + poolSize + ")", n, poolSize, () -> {
            var executor = Executors.newFixedThreadPool(poolSize);
            try {
                var futures = new ArrayList<Future<Integer>>(n);
                for (int i = 0; i < n; i++) {
                    final int id = i;
                    futures.add(executor.submit(ioTask(id)));
                }
                for (var f : futures) {
                    f.get();
                }
            } finally {
                executor.shutdown();
                executor.awaitTermination(10, TimeUnit.SECONDS);
            }
        });
    }

    // ── 方案 C (危险测试): 线程即任务模式 ─────
    // 尝试为每个任务创建独立的平台线程 (thread-per-task)。
    // 平台线程栈默认 ~1MB, N=50000 需要 ~50GB 虚拟内存 → 几乎必然 OOM/崩溃。

    static BenchResult runThreadPerTaskBenchmark(int n) {
        return measure("ThreadPerTask", n, 0, () -> {
            var threads = new ArrayList<Thread>(n);
            var latch = new CountDownLatch(n);

            for (int i = 0; i < n; i++) {
                Thread t = Thread.ofPlatform().unstarted(() -> {
                    try {
                        Thread.sleep(TASK_DURATION_MS);
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                    } finally {
                        latch.countDown();
                    }
                });
                threads.add(t);
            }

            // 分段启动，避免瞬时压力
            for (Thread t : threads) {
                t.start();
            }

            boolean finished = latch.await(60, TimeUnit.SECONDS);
            if (!finished) {
                throw new RuntimeException(
                    "Timeout: only " + (n - latch.getCount()) + "/" + n + " completed");
            }
        });
    }

    // ── 汇总表格 ──────────────────────────────

    static void printSummary(List<BenchResult> results) {
        System.out.println();
        System.out.println("=".repeat(105));
        System.out.printf("%-28s %6s %6s | %10s | %12s | %12s | %12s | %s%n",
            "Method", "N", "Pool", "Time(ms)", "HeapΔ(MB)", "Peak(MB)", "Thru(t/s)", "Status");
        System.out.println("-".repeat(105));
        for (var r : results) {
            System.out.printf("%-28s %6d %6d | %10s | %12s | %12s | %12s | %s%n",
                r.name(), r.n(), r.poolSize(),
                r.success() ? String.valueOf(r.durationMs()) : "N/A",
                r.success() ? String.format("%.2f", r.heapDeltaMB()) : "N/A",
                r.success() ? String.format("%.2f", r.peakHeapMB()) : "N/A",
                r.success() ? String.format("%.0f", r.throughput()) : "N/A",
                r.success() ? "OK" : r.error());
        }
        System.out.println("=".repeat(105));
    }

    // ── Main ──────────────────────────────────

    public static void main(String[] args) {
        System.out.println("=".repeat(70));
        System.out.println("  协程 vs 线程 性能对比基准测试 (Java 21)");
        System.out.println("  任务: 模拟 I/O 阻塞 (" + TASK_DURATION_MS + "ms sleep 每个任务)");
        System.out.println("  Java: " + System.getProperty("java.version"));
        System.out.println("  可用 CPU: " + Runtime.getRuntime().availableProcessors());
        System.out.println("=".repeat(70));

        var results = new ArrayList<BenchResult>();

        for (int n : CONCURRENCY_LEVELS) {
            System.out.println("\n--- N = " + String.format("%,d", n) + " 并发任务 ---");

            // Virtual Threads
            var r1 = runVirtualThreadBenchmark(n);
            results.add(r1);
            System.out.println("  [VirtualThread]         " + r1);

            // Platform Threads (bounded pool)
            for (int p : PLATFORM_POOL_SIZES) {
                if (p >= n) {
                    continue;
                }
                var r2 = runPlatformPoolBenchmark(n, p);
                results.add(r2);
                System.out.println("  [PlatformThread(P=" + p + ")]   " + r2);
            }

            // Thread-per-task (危险 — 仅对小 N 尝试)
            if (n <= 5_000) {
                var r3 = runThreadPerTaskBenchmark(n);
                results.add(r3);
                System.out.println("  [ThreadPerTask]         " + r3);
            }
        }

        printSummary(results);

        System.out.println("\n  结论提示:");
        System.out.println("  ┌──────────────────────────────────────────────────────────────┐");
        System.out.println("  │ VirtualThread:    总耗时 ≈ 100ms (恒定), 不随 N 增长          │");
        System.out.println("  │ PlatformThread:   总耗时 ≈ ceil(N/P) × 100ms, 随 N 线性增长   │");
        System.out.println("  │ ThreadPerTask:    N > 1000 时极易 OOM (每线程栈 ~1MB)         │");
        System.out.println("  │ 内存: VirtualThread ~1KB, PlatformThread ~1MB (约 1000×)      │");
        System.out.println("  └──────────────────────────────────────────────────────────────┘");
    }
}
