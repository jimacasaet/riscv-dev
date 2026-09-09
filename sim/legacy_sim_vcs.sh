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

echo    "=================================================="
echo    " Running VCS Sim"
echo    " Workdir:   ${WORK_DIR}"
echo    " Filelist:  ${FILE_LIST}"
echo -e " Memory:    ${TESTNAME}_data.mem\t${TESTNAME}_data.mem"
echo    "=================================================="

# --- Step 1: Parse Filelist & Compile (vcs) ---
if [[ "${ACTION}" == "all" || "${ACTION}" == "compile" ]]; then
  echo "Compiling SystemVerilog source files..."
  vcs -sverilog \
    -full64 \
    -kdb \
    -licqueue \
    -f $GIT_ROOT/hardware/common/common_rtl.f \
    -f $GIT_ROOT/hardware/cores/rv64_single_cycle/rtl/rv64_single_rtl.f \
    -f $GIT_ROOT/verification/rv64_single_cycle_tb_legacy/legacy_tb.f \
    -top rv64_single_cycle_tb_legacy \
    -timescale=1ns/1ps \
    -debug_access+all \
    -l compile.log \
    +error+100
fi

# --- Step 2: Run Simulation Batch Mode (simv) ---
if [[ "${ACTION}" == "all" || "${ACTION}" == "run" ]]; then
  echo "Executing simulation (simv)..."
  ./simv \
    -licqueue \
    +MEMDATA=$GIT_ROOT/software/legacy_tests/${TESTNAME}_data.mem \
    +MEMPROG=$GIT_ROOT/software/legacy_tests/${TESTNAME}_prog.mem
fi

echo "=================================================="
echo " Script completed successfully"
echo "=================================================="  