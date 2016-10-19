#!/bin/bash
. ../../../NaluRtest/pass_fail.sh

CWD=$(pwd)
didSimulationDiffAnywhere=0

# determine tolerance
testTol=0.000000000001
theGoldNorm=uqSlidingMeshDG.norm.gold.remote
platform=`uname`
if [ "$platform" == 'Linux' ]; then
    testTol=0.0000000000000001
    theGoldNorm=uqSlidingMeshDG.norm.gold
fi

# set the global diff
GlobalMaxSolutionDiff=-1000000000.0

if [ -f $CWD/PASS ]; then
    # already ran this test
    didSimulationDiffAnywhere=0
else
    mpiexec -np 8 ../../naluX -i uqSlidingMeshDG.i -o uqSlidingMeshDG.log
    determine_pass_fail $testTol "uqSlidingMeshDG.log" "uqSlidingMeshDG.norm" "$theGoldNorm"
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
GlobalPerformanceTime=`grep "STKPERF: Total Time" uqSlidingMeshDG.log  | awk '{print $4}'`
if [ $PASS_STATUS -ne 1 ]; then
    echo -e "..uqSlidingMeshDG............. FAILED":" " $GlobalPerformanceTime " s" " max diff: " $GlobalMaxSolutionDiff
else
    echo -e "..uqSlidingMeshDG............. PASSED":" " $GlobalPerformanceTime " s"
fi

exit