#!/bin/bash
. ../../pass_fail.sh

CWD=$(pwd)
didSimulationDiffAnywhere=0
didSimulationDiffAnywhereFirst=0
didSimulationDiffAnywhereSecond=0
localDiffOne=0.0;
localDiffTwo=0.0;

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
    mpiexec -np 8 ../../naluX -i cvfemHC.i -o cvfemHC.log
    determine_pass_fail $testTol "cvfemHC.log" "cvfemHC.norm" "cvfemHC.norm.gold"
    didSimulationDiffAnywhereFirst="$?"
    localDiffOne=$GlobalMaxSolutionDiff
    if [ "$didSimulationDiffAnywhereFirst" -gt 0 ]; then
        didSimulationDiffAnywhere=1
    fi

    # run the second case
    mpiexec -np 8 ../../naluX -i cvfemHC_nodebal.i -o cvfemHC_nodebal.log
    determine_pass_fail $testTol "cvfemHC_nodebal.log" "cvfemHC_nodebal.norm" "cvfemHC_nodebal.norm.gold"
    didSimulationDiffAnywhereSecond="$?"
    localDiffTwo=$GlobalMaxSolutionDiff
    if [ "$didSimulationDiffAnywhereSecond" -gt 0 ]; then
        didSimulationDiffAnywhere=1
    fi

    # check who is greater
    if [ $(echo " $localDiffOne > $localDiffTwo " | bc) -eq 1 ]; then
        GlobalMaxSolutionDiff=$localDiffOne
    else
        GlobalMaxSolutionDiff=$localDiffTwo
    fi
fi

# write the file based on final status
if [ "$didSimulationDiffAnywhere" -gt 0 ]; then
    PASS_STATUS=0
else
    PASS_STATUS=1
    echo $PASS_STATUS > PASS_NP1
fi

# report it; 30 spaces
GlobalPerformanceTimeFirst=`grep "STKPERF: Total Time" cvfemHC.log  | awk '{print $4}'`
GlobalPerformanceTimeSecond=`grep "STKPERF: Total Time" cvfemHC_nodebal.log | awk '{print $4}'`
totalPerfTime=`echo "$GlobalPerformanceTimeFirst + $GlobalPerformanceTimeSecond" | bc `
if [ $PASS_STATUS -ne 1 ]; then
    echo -e "..cvfemHC..................... FAILED":" " $totalPerfTime " s" " max diff: " $GlobalMaxSolutionDiff
else
    echo -e "..cvfemHC..................... PASSED":" " $totalPerfTime " s"
fi

exit
