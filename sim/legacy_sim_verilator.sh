#!/bin/zsh

export GIT_ROOT=$(git rev-parse --show-toplevel)
REPO_ROOT="${GIT_TOP:-$(git rev-parse --show-toplevel)}"
WORK_DIR=$(pwd)
TOP_MODULE="rv64_single_cycle_tb_legacy"
FILE_LIST="${REPO_ROOT}/verification/rv64_single_cycle_tb_legacy/legacy_tb.f"
TESTNAME="arithtest"

ACTION="all"
RUN="-runall"

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
         -cov|-v)
            ACTION="run"
            shift
            ;;
         -gui|-g)
            RUN="-gui"
            shift
            ;;
        *)
            # Assume first non-flag argument is the test name
            TESTNAME="$1"
            shift
            ;;
    esac
done

echo    "=================================================="
echo    " Running Verilator Simulator"
echo    " Workdir:   ${WORK_DIR}"
echo    " Filelist:  ${FILE_LIST}"
echo -e " Memory:    ${TESTNAME}_prog.mem\t${TESTNAME}_data.mem"
echo    "=================================================="

if [[ "${ACTION}" == "all" || "${ACTION}" == "compile" ]]; then
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
  --top-module rv64_single_cycle_tb_legacy 
fi

if [[ "${ACTION}" == "all" || "${ACTION}" == "run" ]]; then
obj_dir/Vrv64_single_cycle_tb_legacy \
  +MEMDATA=$GIT_ROOT/software/legacy_tests/${TESTNAME}_data.mem \
  +MEMPROG=$GIT_ROOT/software/legacy_tests/${TESTNAME}_prog.mem
fi

echo "=================================================="
echo " Script completed successfully"
echo "=================================================="