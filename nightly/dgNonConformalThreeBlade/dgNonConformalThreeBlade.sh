#!/bin/bash
. ../../pass_fail.sh

CWD=$(pwd)
didSimulationDiffAnywhere=0
didSimulationDiffAnywhereFirst=0
didSimulationDiffAnywhereSecond=0
localDiffOne=0.0;
localDiffTwo=0.0;

# determine tolerance
testTol=0.000000001
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
    # run the first case
    mpiexec -np 4 ../../naluX -i dgNonConformalThreeBlade.i -o dgNonConformalThreeBlade.log
    determine_pass_fail $testTol "dgNonConformalThreeBlade.log" "dgNonConformalThreeBlade.norm" "dgNonConformalThreeBlade.norm.gold"
    didSimulationDiffAnywhereFirst="$?"
    localDiffOne=$GlobalMaxSolutionDiff
    if [ "$didSimulationDiffAnywhereFirst" -gt 0 ]; then
        didSimulationDiffAnywhere=1
    fi

    # run the second case
    mpiexec -np 4 ../../naluX -i dgNonConformalThreeBlade_rst.i -o dgNonConformalThreeBlade_rst.log
    determine_pass_fail $testTol "dgNonConformalThreeBlade_rst.log" "dgNonConformalThreeBlade_rst.norm" "dgNonConformalThreeBlade_rst.norm.gold"
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
    echo $PASS_STATUS > PASS
fi

# report it; 30 spaces
GlobalPerformanceTimeFirst=`grep "STKPERF: Total Time" dgNonConformalThreeBlade.log  | awk '{print $4}'`
GlobalPerformanceTimeSecond=`grep "STKPERF: Total Time" dgNonConformalThreeBlade_rst.log  | awk '{print $4}'`
totalPerfTime=`echo "$GlobalPerformanceTimeFirst + $GlobalPerformanceTimeSecond" | bc `
if [ $PASS_STATUS -ne 1 ]; then
    echo -e "..dgNonConformalThreeBlade.... FAILED":" " $totalPerfTime " s " " max diff: " $GlobalMaxSolutionDiff
else
    echo -e "..dgNonConformalThreeBlade.... PASSED":" " $totalPerfTime " s " 
fi

exit
