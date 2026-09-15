#!/bin/zsh

export GIT_ROOT=$(git rev-parse --show-toplevel)

verilator --binary \
  --timing \
  --trace \
  --coverage \
  -Wno-WIDTH \
  -Wno-STMTDLY \
  -Wno-lint \
  -Wno-fatal \
  -F $GIT_ROOT/hardware/common/common_rtl.f \
  -F $GIT_ROOT/hardware/cores/rv64_single_cycle/rtl/rv64_single_rtl.f \
  -F $GIT_ROOT/verification/rv64_single_cycle_tb_legacy/legacy_tb.f \
  --top-module rv64_single_cycle_tb_legacy \

obj_dir/Vrv64_single_cycle_tb_legacy \
  +MEMDATA=$GIT_ROOT/software/legacy_tests/custom_data.mem \
  +MEMPROG=$GIT_ROOT/software/legacy_tests/custom_prog.mem
#  +MEMDATA=$GIT_ROOT/software/legacy_tests/arithtest_data.mem \
#  +MEMPROG=$GIT_ROOT/software/legacy_tests/arithtest_prog.mem 
