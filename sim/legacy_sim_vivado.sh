#!/bin/bash
set -e # Exit immediately when a command exits with non-zero status

# --- 1. Environment and Path Setup ---
export GIT_ROOT=$(git rev-parse --show-toplevel)
REPO_ROOT="${GIT_TOP:-$(git rev-parse --show-toplevel)}"
WORK_DIR=$(pwd)
TOP_MODULE="rv64_single_cycle_tb_legacy"
FILE_LIST="${REPO_ROOT}/verification/rv64_single_cycle_tb_legacy/legacy_tb.f"
TESTNAME="arithtest"

ACTION="all"

# Parse arguments for flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        -compile|-c)
            ACTION="compile"
            shift
            ;;
        -run|-r)
            ACTION="run"
            shift
            ;;
        *)
            # Assume first non-flag argument is the test name
            TESTNAME="$1"
            shift
            ;;
    esac
done

echo "=================================================="
echo " Running Vivado Simulator (xsim)"
echo " Workdir:   ${WORK_DIR}"
echo " Filelist:  ${FILE_LIST}"
echo " Memory:    ${TESTNAME}_data.mem\t${TESTNAME}_data.mem"
echo "=================================================="

# --- 2. Compilation and Elaboration ---

if [[ "${ACTION}" == "all" || "${ACTION}" == "compile" ]]; then
  echo -e "\n\n[1/2] Compiling SystemVerilog source files (xvlog)..."
  xvlog -sv \
    -f $GIT_ROOT/hardware/common/common_rtl.f \
    -f $GIT_ROOT/hardware/cores/rv64_single_cycle/rtl/rv64_single_rtl.f \
    -f $GIT_ROOT/verification/rv64_single_cycle_tb_legacy/legacy_tb.f \
    -log xvlog.log

  echo -e "\n\n[2/2] Elaborating simulation snapshot (xelab)..."
  xelab "${TOP_MODULE}" \
    -s sim_snapshot \
    -timescale 1ns/1ps \
    -debug typical \
    -cov_db_dir ./cov_db \
    -cc_type sbct \
    -log xelab.log

fi

# --- 3. Execution ---
if [[ "${ACTION}" == "all" || "${ACTION}" == "run" ]]; then
  echo "Executing simulation (xsim)..."
  xsim sim_snapshot \
    -runall \
    -cov_db_dir ./cov_db \
    -cov_db_name "${TESTNAME}_cov" \
    -log sim.log \
    -testplusarg "MEMDATA=$GIT_ROOT/software/legacy_tests/${TESTNAME}_data.mem" \
    -testplusarg "MEMPROG=$GIT_ROOT/software/legacy_tests/${TESTNAME}_prog.mem"
fi

echo "=================================================="
echo " Script completed successfully"
echo "=================================================="  