// Coroutine vs Thread Performance Benchmark (Go)
//
// 对比无限制 Goroutine（有栈协程模型）与信号量限流模型（模拟线程池）的性能差异。
//
// 运行：
//
//	go run main.go
//	go run main.go -v    # 详细输出
//
// 编译后运行：
//
//	go build -o benchmark main.go && ./benchmark

package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"runtime"
	"strings"
	"sync"
	"sync/atomic"
	"time"
)

// ──────────────────────────────────────────────
// 实验配置
// ──────────────────────────────────────────────

const taskDuration = 100 * time.Millisecond // 每个任务模拟的 I/O 延迟

var (
	concurrencyLevels = []int{100, 500, 1_000, 5_000, 10_000, 50_000}
	threadPoolSizes   = []int{200, 500, 1_000} // 平台线程池大小
)

// ──────────────────────────────────────────────
// 结果结构
// ──────────────────────────────────────────────

type BenchResult struct {
	Name       string // "Goroutine" | "ThreadPool(P=N)"
	N          int    // 并发任务数
	PoolSize   int    // 0 = 无限制
	DurationMs int64  // 总耗时
	MemBefore  uint64 // 运行前 Alloc (bytes)
	MemAfter   uint64 // 运行后 Alloc (bytes)
	MemPeak    uint64 // 峰值 Alloc (运行结束时)
	NumGC      uint32
	Success    bool
	ErrMsg     string
}

func (r BenchResult) MemDeltaMB() float64 {
	return float64(r.MemAfter-r.MemBefore) / (1024 * 1024)
}

func (r BenchResult) String() string {
	if !r.Success {
		return fmt.Sprintf("FAIL: %s", r.ErrMsg)
	}
	return fmt.Sprintf("time=%6dms | heap_Δ=%7.2f MB | peak=%7.2f MB | GC=%d",
		r.DurationMs, r.MemDeltaMB(), float64(r.MemPeak)/(1024*1024), r.NumGC)
}

// ──────────────────────────────────────────────
// 通用测量脚手架
// ──────────────────────────────────────────────

// measure 运行 fn 并采集时间和内存指标
func measure(name string, n int, poolSize int, fn func() error) BenchResult {
	runtime.GC() // 运行前强制 GC，获得干净基线
	time.Sleep(50 * time.Millisecond)

	var memBefore, memAfter runtime.MemStats
	runtime.ReadMemStats(&memBefore)

	start := time.Now()
	err := fn()
	elapsed := time.Since(start).Milliseconds()

	runtime.ReadMemStats(&memAfter)

	// 尝试捕获峰值（在 fn 内通过采样获取）
	// 这里取 max(before, after) 作为下界近似
	peak := memBefore.HeapAlloc
	if memAfter.HeapAlloc > peak {
		peak = memAfter.HeapAlloc
	}

	return BenchResult{
		Name:       name,
		N:          n,
		PoolSize:   poolSize,
		DurationMs: elapsed,
		MemBefore:  memBefore.HeapAlloc,
		MemAfter:   memAfter.HeapAlloc,
		MemPeak:    peak,
		NumGC:      memAfter.NumGC - memBefore.NumGC,
		Success:    err == nil,
		ErrMsg:     func() string { if err != nil { return err.Error() }; return "" }(),
	}
}

// ──────────────────────────────────────────────
// 方案 A: 无限制 Goroutine（有栈协程模型）
// ──────────────────────────────────────────────

func runGoroutineBenchmark(n int) BenchResult {
	return measure("Goroutine", n, 0, func() error {
		var wg sync.WaitGroup
		wg.Add(n)

		for i := 0; i < n; i++ {
			go func() {
				defer wg.Done()
				time.Sleep(taskDuration) // 模拟 I/O 阻塞
			}()
		}

		wg.Wait()
		return nil
	})
}

// ──────────────────────────────────────────────
// 方案 B: 信号量限流 Goroutine（模拟固定线程池）
// ──────────────────────────────────────────────

func runThreadPoolBenchmark(n, poolSize int) BenchResult {
	return measure(
		fmt.Sprintf("ThreadPool(P=%d)", poolSize),
		n, poolSize,
		func() error {
			sem := make(chan struct{}, poolSize) // 信号量 = 线程池容量
			var wg sync.WaitGroup
			wg.Add(n)

			for i := 0; i < n; i++ {
				sem <- struct{}{} // 获取"线程"
				go func() {
					defer func() { <-sem }() // 释放"线程"
					defer wg.Done()
					time.Sleep(taskDuration)
				}()
			}

			wg.Wait()
			return nil
		},
	)
}

// ──────────────────────────────────────────────
// 方案 C (可选): 尝试创建真正的 OS 线程
// ──────────────────────────────────────────────

func runOSThreadAttempt(n int) BenchResult {
	return measure("OSThread", n, 0, func() error {
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()

		done := make(chan struct{})
		var created int32

		go func() {
			var wg sync.WaitGroup
			for i := 0; i < n; i++ {
				wg.Add(1)
				go func() {
					defer wg.Done()
					// LockOSThread 将当前 goroutine 绑定到 OS 线程
					// 这强制创建新的 OS 线程（而非复用 goroutine 调度器的线程池）
					runtime.LockOSThread()
					defer runtime.UnlockOSThread()
					time.Sleep(taskDuration)
					atomic.AddInt32(&created, 1)
				}()
			}
			wg.Wait()
			close(done)
		}()

		select {
		case <-done:
			return nil
		case <-ctx.Done():
			return fmt.Errorf("timed out after 30s (OS thread creation bottleneck); created %d/%d",
				atomic.LoadInt32(&created), n)
		}
	})
}

// ──────────────────────────────────────────────
// 汇总输出
// ──────────────────────────────────────────────

func printSummary(results []BenchResult) {
	fmt.Println()
	fmt.Println(strings.Repeat("=", 90))
	fmt.Printf("%-22s %6s %6s | %10s | %14s | %14s | %3s | %s\n",
		"Method", "N", "Pool", "Time(ms)", "HeapΔ(MB)", "Peak(MB)", "GC", "Throughput(tasks/s)")
	fmt.Println(strings.Repeat("-", 90))
	for _, r := range results {
		throughput := float64(r.N) / (float64(r.DurationMs) / 1000.0)
		label := fmt.Sprintf("%-22s %6d %6d", r.Name, r.N, r.PoolSize)
		if !r.Success {
			fmt.Printf("%s | %10s | %14s | %14s | %3s | FAIL: %s\n",
				label, "-", "-", "-", "-", r.ErrMsg)
		} else {
			fmt.Printf("%s | %10d | %14.2f | %14.2f | %3d | %12.0f\n",
				label, r.DurationMs, r.MemDeltaMB(), float64(r.MemPeak)/(1024*1024),
				r.NumGC, throughput)
		}
	}
	fmt.Println(strings.Repeat("=", 90))
}
// ──────────────────────────────────────────────
// Main
// ──────────────────────────────────────────────

func main() {
	verbose := flag.Bool("v", false, "详细输出")
	flag.Parse()

	fmt.Println(strings.Repeat("=", 70))
	fmt.Println("  协程 vs 线程 性能对比基准测试 (Go)")
	fmt.Printf("  任务: 模拟 I/O 阻塞 (%v sleep 每个任务)\n", taskDuration)
	fmt.Printf("  GOMAXPROCS = %d | CPU 核心数 = %d\n", runtime.GOMAXPROCS(0), runtime.NumCPU())
	fmt.Println(strings.Repeat("=", 70))

	var results []BenchResult

	for _, n := range concurrencyLevels {
		fmt.Printf("\n━━━ N = %d 并发任务 ━━━\n", n)

		// 方案 A: 无限制 Goroutine
		r := runGoroutineBenchmark(n)
		results = append(results, r)
		fmt.Printf("  [Goroutine]            %s\n", r)

		// 方案 B: 固定线程池
		for _, p := range threadPoolSizes {
			if p >= n {
				if *verbose {
					fmt.Printf("  [ThreadPool(P=%d)]    (跳过: pool >= N)\n", p)
				}
				continue
			}
			r := runThreadPoolBenchmark(n, p)
			results = append(results, r)
			fmt.Printf("  [ThreadPool(P=%d)]     %s\n", p, r)
		}

		// 方案 C (可选): OS 线程尝试（仅对小 N）
		if n <= 1000 {
			r := runOSThreadAttempt(n)
			results = append(results, r)
			fmt.Printf("  [OSThread(Lock)]       %s\n", r)
		}
	}

	printSummary(results)

	fmt.Println("\n📊 结论提示:")
	fmt.Println("  - Goroutine (有栈协程): 总耗时 ≈ max(所有 task 的耗时) = ~100ms, 不随 N 增长")
	fmt.Println("  - ThreadPool (模拟线程池): 总耗时 ≈ ceil(N/P) × 100ms, 随 N/P 线性增长")
	fmt.Println("  - OSThread (真实线程): 即使 N=500 也可能因 OS 线程创建瓶颈而超时")
	fmt.Println("  - 内存: Goroutine 初始栈 ~2KB, OS 线程栈 ~1MB+ (约 500× 差异)")

	os.Exit(0)
}
