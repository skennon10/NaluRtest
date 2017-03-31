#!/bin/bash

CWD=$(pwd)
didSimulationPassConvergenceTest=0
if [ -f $CWD/PASS ]; then
    # already ran this test
    didSimulationPassConvergenceTest=0
else
    mpiexec -np 8 ../../naluX -i steadyTaylorVortex_P4_R0.i -o steadyTaylorVortex_P4_R0.log && \
    mpiexec -np 8 ../../naluX -i steadyTaylorVortex_P4_R1.i -o steadyTaylorVortex_P4_R1.log && \
    mpiexec -np 8 ../../naluX -i steadyTaylorVortex_P4_R2.i -o steadyTaylorVortex_P4_R2.log
    python norms.py
    didSimulationPassConvergenceTest=$?
fi

if [ "$didSimulationPassConvergenceTest" -gt 0 ]; then
    PASS_STATUS=0
else
    PASS_STATUS=1
    echo $PASS_STATUS > PASS
fi

# report it; 30 spaces
time0=`grep "STKPERF: Total Time" steadyTaylorVortex_P4_R0.log  | awk '{print $4}'`
time1=`grep "STKPERF: Total Time" steadyTaylorVortex_P4_R1.log  | awk '{print $4}'`
time2=`grep "STKPERF: Total Time" steadyTaylorVortex_P4_R2.log  | awk '{print $4}'`
GlobalPerformanceTime=$(echo $time0 + $time1 + $time2 | bc)

if [ $PASS_STATUS -ne 1 ]; then
    echo -e "..steadyTaylorVortex_P4....... FAILED":" " $GlobalPerformanceTime " s"
else
    echo -e "..steadyTaylorVortex_P4....... PASSED":" " $GlobalPerformanceTime " s"
fi

exit $PASS_STATUS
