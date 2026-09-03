#!/bin/bash
set -e # Exit immediately when a command exits with non-zero status

export GIT_ROOT=$(git rev-parse --show-toplevel)

# --- Step 1: Parse Filelist & Compile (vcs) ---
echo "[1/2] Compiling SystemVerilog source files (vcs)..."

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

# --- Step 2: Run Simulation Batch Mode (simv) ---
echo "[2/2] Executing simulation (simv)..."

./simv \
  -licqueue \
  +MEMDATA=$GIT_ROOT/software/legacy_tests/arithtest_data.mem \
  +MEMPROG=$GIT_ROOT/software/legacy_tests/arithtest_prog.mem
  