#!/bin/bash

export GIT_ROOT=$(git rev-parse --show-toplevel)
REPO_ROOT="${GIT_TOP:-$(git rev-parse --show-toplevel)}"
WORK_DIR=$(pwd)
TOP_MODULE="rv64_single_cycle_tb_legacy"
FILE_LIST="${REPO_ROOT}/hardware/common/common_rtl.f"

echo "=================================================="
echo " Running Vivado Simulator (xsim)"
echo " Workdir:   ${WORK_DIR}"
echo " Filelist:  ${FILE_LIST}"
echo " Memory:    "
echo "=================================================="

# --- 2. Step 1: Parse Filelist & Compile (xvlog) ---
echo "[1/3] Compiling SystemVerilog source files (xvlog)..."

envsubst < "${FILE_LIST}" > "${WORK_DIR}/resolved_filelist.f"

xvlog -sv \
  -f $GIT_ROOT/hardware/common/common_rtl.f \
  -f $GIT_ROOT/hardware/cores/rv64_single_cycle/rtl/rv64_single_rtl.f \
  -f $GIT_ROOT/verification/rv64_single_cycle_tb_legacy/legacy_tb.f \
  -log xvlog.log

echo "[2/3] Elaborating simulation snapshot (xelab)..."

# xelab creates a compiled binary snapshot named 'sim_snapshot'
xelab "${TOP_MODULE}" \
  -s sim_snapshot \
  -timescale 1ns/1ps \
  -debug typical \
  -log xelab.log

echo "[3/3] Executing simulation (xsim)..."

# Pass testplusargs via xsim's -testplusarg switch
xsim sim_snapshot \
  -runall \
  -log sim.log \
  -testplusarg "MEMDATA=$GIT_ROOT/software/legacy_tests/arithtest_data.mem" \
  -testplusarg "MEMPROG=$GIT_ROOT/software/legacy_tests/arithtest_prog.mem"
  