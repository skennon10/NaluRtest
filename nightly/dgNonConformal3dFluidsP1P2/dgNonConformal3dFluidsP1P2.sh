#!/bin/bash
. ../../pass_fail.sh

CWD=$(pwd)
didSimulationDiffAnywhere=0

# determine tolerance
testTol=0.00002
platform=`uname`
if [ "$platform" == 'Linux' ]; then
    testTol=0.0000000000000001
fi

# set the global diff
GlobalMaxSolutionDiff=-1000000000.0

if [ -f $CWD/PASS ]; then
    # already ran this test
    didSimulationDiffAnywhere=0
else
    mpiexec -np 8 ../../naluX -i dgNonConformal3dFluidsP1P2.i -o dgNonConformal3dFluidsP1P2.log
    determine_pass_fail $testTol "dgNonConformal3dFluidsP1P2.log" "dgNonConformal3dFluidsP1P2.norm" "dgNonConformal3dFluidsP1P2.norm.gold"
    didSimulationDiffAnywhere="$?"
fi

# write the file based on final status
if [ "$didSimulationDiffAnywhere" -gt 0 ]; then
    PASS_STATUS=0
else
    PASS_STATUS=1
    echo $PASS_STATUS > PASS
fi

# report it; 30 spaces
GlobalPerformanceTime=`grep "STKPERF: Total Time" dgNonConformal3dFluidsP1P2.log  | awk '{print $4}'`
if [ $PASS_STATUS -ne 1 ]; then
    echo -e "..dgNonConformal3dFluidsP1P2.. FAILED":" " $GlobalPerformanceTime " s " " max diff: " $GlobalMaxSolutionDiff
else
    echo -e "..dgNonConformal3dFluidsP1P2.. PASSED":" " $GlobalPerformanceTime " s " 
fi

exit
