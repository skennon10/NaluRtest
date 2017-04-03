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

if [ -f $CWD/PASS_NP1 ]; then
    # already ran this test
    didSimulationDiffAnywhere=0
else
    mpiexec -np 2 ../../naluX -i variableDensNonUniform.i -o variableDensNonUniform.log
    determine_pass_fail $testTol "variableDensNonUniform.log" "variableDensNonUniform.norm" "variableDensNonUniform.norm.gold"
    didSimulationDiffAnywhere="$?"
fi

# write the file based on final status
if [ "$didSimulationDiffAnywhere" -gt 0 ]; then
    PASS_STATUS=0
else
    PASS_STATUS=1
    echo $PASS_STATUS > PASS_NP1
fi

# report it; 30 spaces
GlobalPerformanceTime=`grep "STKPERF: Total Time" variableDensNonUniform.log  | awk '{print $4}'`
if [ $PASS_STATUS -ne 1 ]; then
    echo -e "..variableDensNonUniform...... FAILED":" " $GlobalPerformanceTime " s" " max diff: " $GlobalMaxSolutionDiff
else
    echo -e "..variableDensNonUniform...... PASSED":" " $GlobalPerformanceTime " s"
fi

exit
