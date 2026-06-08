#!/bin/sh
# =============================================================================
# qsub_mpi.sh — PBS job script for MPI IVF-SIMD ANN benchmark
#
# Compile on master node BEFORE submitting:
#   cd ~/ann
#   mpicxx main_mpi.cc -o main_mpi -O2 -std=c++11 -lm
#
# Submit:
#   qsub qsub_mpi.sh
#
# To sweep process counts, change nodes/ppn/np together:
#
#   P=1 :  nodes=1, ppn=1, -np 1    (single-process baseline)
#   P=2 :  nodes=1, ppn=2, -np 2
#   P=4 :  nodes=1, ppn=4, -np 4
#   P=8 :  nodes=1, ppn=8, -np 8    ← default below
#   P=16:  nodes=2, ppn=8, -np 16
#
# Rule from guide:  np <= nodes × ppn,  nodes <= 4,  ppn <= 8
# Without intra-process multithreading, set np = nodes × ppn exactly.
# =============================================================================
#PBS -N qsub_mpi
#PBS -e test.e
#PBS -o test.o
#PBS -l nodes=1:ppn=8

# ── 【修改 1/2】接收外部传参，未传则默认使用 hybrid ─────────────────────────
MODE=${MODE:-hybrid}
NPROBE=${NPROBE:-8}
EF_SEARCH=${EF_SEARCH:-24}
NSUBGRAPHS=${NSUBGRAPHS:-2}
NSUBPROBE=${NSUBPROBE:-0}

# ── Derive actual resource counts from PBS ────────────────────────────────────
# NP   = total cores allocated = lines in nodefile = nodes × ppn
# NNODES = distinct nodes
NP=$(cat $PBS_NODEFILE | wc -l)
NNODES=$(cat $PBS_NODEFILE | sort | uniq | wc -l)
PPN=$(( NP / NNODES ))
NODES_LIST=$(cat $PBS_NODEFILE | sort | uniq)

echo "======== PBS resource info ========" 1>&2
echo "  nodes   = $NNODES" 1>&2
echo "  ppn     = $PPN" 1>&2
echo "  np (NP) = $NP   (mpiexec will launch $NP processes)" 1>&2
echo "  threads = 1     (no intra-process OMP/Pthread)" 1>&2
echo "  nodefile entries:" 1>&2
cat $PBS_NODEFILE 1>&2
echo "===================================" 1>&2

# ── Distribute binary and index cache to every allocated node ─────────────────
for node in $NODES_LIST; do
    scp master_ubss1:/home/${USER}/ann/main_mpi ${node}:/home/${USER}/ 1>&2
    scp -r master_ubss1:/home/${USER}/ann/files  ${node}:/home/${USER}/ 1>&2
done

# ── Run MPI job ───────────────────────────────────────────────────────────────
# -np derived from nodefile: always equals nodes × ppn (no oversubscription)
# HNSW 族模式传 --ef，IVF/Flat 族模式传 --nprobe

case "$MODE" in
    hnsw|hnsw_simd|hnsw_blocking|hnsw_nonblocking|hnsw_p2p|hnsw_onesided)
        /usr/local/bin/mpiexec -np $NP -machinefile $PBS_NODEFILE \
            /home/${USER}/main_mpi --mode "$MODE" --ef "$EF_SEARCH"
        ;;
    multi_hnsw)
        /usr/local/bin/mpiexec -np $NP -machinefile $PBS_NODEFILE \
            /home/${USER}/main_mpi --mode "$MODE" \
            --ef "$EF_SEARCH" \
            --nsubgraphs "$NSUBGRAPHS" \
            --nsubprobe "$NSUBPROBE"
        ;;
    ivf_hnsw)
        /usr/local/bin/mpiexec -np $NP -machinefile $PBS_NODEFILE \
            /home/${USER}/main_mpi --mode "$MODE" \
            --nprobe "$NPROBE" --ef "$EF_SEARCH" --nlist "${NLIST:-256}"
        ;;
    *)
        /usr/local/bin/mpiexec -np $NP -machinefile $PBS_NODEFILE \
            /home/${USER}/main_mpi --mode "$MODE" --nprobe "$NPROBE"
        ;;
esac

# ── Sync newly written index cache files back to master ───────────────────────
scp -r /home/${USER}/files/ master_ubss1:/home/${USER}/ann/ 2>&1

# ── Clean up compute node local storage ──────────────────────────────────────
rm    /home/${USER}/main_mpi
rm -r /home/${USER}/files/