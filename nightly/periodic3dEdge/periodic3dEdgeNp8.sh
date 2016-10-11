#!/bin/bash
. ../../pass_fail.sh

CWD=$(pwd)
didSimulationDiffAnywhere=0

# determine tolerance
testTol=0.000000000001
platform=`uname`
if [ "$platform" == 'Linux' ]; then
    testTol=0.0000000000000001
fi

# set the global diff
GlobalMaxSolutionDiff=-1000000000.0

if [ -f $CWD/PASS_NP8 ]; then
    # already ran this test
    didSimulationDiffAnywhere=0
else
    mpiexec -np 8 ../../naluX -i periodic3dEdge.i -o periodic3dEdgeNp8.log
    determine_pass_fail $testTol "periodic3dEdgeNp8.log" "periodic3dEdgeNp8.norm" "periodic3dEdgeNp8.norm.gold"
    didSimulationDiffAnywhere="$?"
fi

# write the file based on final status
if [ "$didSimulationDiffAnywhere" -gt 0 ]; then
    PASS_STATUS=0
else
    PASS_STATUS=1
    echo $PASS_STATUS > PASS_NP8
fi

# report it; 30 spaces
GlobalPerformanceTime=`grep "STKPERF: Total Time" periodic3dEdgeNp8.log  | awk '{print $4}'`
if [ $PASS_STATUS -ne 1 ]; then
    echo -e "..periodic3dEdgeNp8........... FAILED":" " $GlobalPerformanceTime " s" " max diff: " $GlobalMaxSolutionDiff
else
    echo -e "..periodic3dEdgeNp8........... PASSED":" " $GlobalPerformanceTime " s"
fi

exit