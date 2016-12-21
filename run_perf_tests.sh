#!/bin/bash

# possible flag passed in
typeOfTesting=$1

globalPerformanceTime=-1

echo "Performance Rtest Begin: " $typeOfTesting

NaluRtestCWD=$(pwd)

cd ..
baseGitHubCWD=$(pwd)

# create the directory in which the tests will be run (if it does not exist)
if [ ! -d "$baseGitHubCWD/runNaluRtest" ]; then
    mkdir $baseGitHubCWD/runNaluRtest
fi
# now check for performance
if [ ! -d "$baseGitHubCWD/runNaluRtest/performance" ]; then
    mkdir $baseGitHubCWD/runNaluRtest/performance
fi

# look for file that defines the path to naluX
if [ ! -f $NaluRtestCWD/NaluProjectPath.txt ]; then
    if [ "$typeOfTesting" == "DEBUG" ]; then
        cp $baseGitHubCWD/Nalu/build_debug/naluXd $baseGitHubCWD/runNaluRtest/naluX
    else
        cp $baseGitHubCWD/Nalu/build/naluX $baseGitHubCWD/runNaluRtest/naluX
    fi
else
    NaluProjectPathFile="$NaluRtestCWD/NaluProjectPath.txt"
    projectPathName=$(cat $NaluProjectPathFile)
    if [ "$typeOfTesting" == "DEBUG" ]; then
        cp $projectPathName/build_debug/naluXd $baseGitHubCWD/runNaluRtest/naluX
    else
        cp $projectPathName/build/naluX $baseGitHubCWD/runNaluRtest/naluX
    fi
fi

# copy pass_fail script
cp $NaluRtestCWD/pass_fail.sh $baseGitHubCWD/runNaluRtest

#=============================================================================
# waleElemXflowMixFrac3.5m test
#=============================================================================
if [ ! -d "$baseGitHubCWD/runNaluRtest/performance/waleElemXflowMixFrac3.5m" ]; then
    mkdir $baseGitHubCWD/runNaluRtest/performance/waleElemXflowMixFrac3.5m
fi

cd $baseGitHubCWD/runNaluRtest/performance/waleElemXflowMixFrac3.5m
cp $NaluRtestCWD/performance/waleElemXflowMixFrac3.5m/waleElemXflowMixFrac3.5m.i $baseGitHubCWD/runNaluRtest/performance/waleElemXflowMixFrac3.5m
cp $NaluRtestCWD/xml/milestone_aspect_ratio_smooth.xml $baseGitHubCWD/runNaluRtest/performance/waleElemXflowMixFrac3.5m
cp $NaluRtestCWD/performance/waleElemXflowMixFrac3.5m/*.g.* $baseGitHubCWD/runNaluRtest/performance/waleElemXflowMixFrac3.5m
cp $NaluRtestCWD/performance/waleElemXflowMixFrac3.5m/waleElemXflowMixFrac3.5m.sh $baseGitHubCWD/runNaluRtest/performance/waleElemXflowMixFrac3.5m
cp $NaluRtestCWD/performance/waleElemXflowMixFrac3.5m/waleElemXflowMixFrac3.5m.norm.gold* $baseGitHubCWD/runNaluRtest/performance/waleElemXflowMixFrac3.5m
# run it...  
./waleElemXflowMixFrac3.5m.sh

#=============================================================================
# uqSlidingMeshDG test
#=============================================================================
if [ ! -d "$baseGitHubCWD/runNaluRtest/performance/uqSlidingMeshDG" ]; then
    mkdir $baseGitHubCWD/runNaluRtest/performance/uqSlidingMeshDG
fi

cd $baseGitHubCWD/runNaluRtest/performance/uqSlidingMeshDG
cp $NaluRtestCWD/performance/uqSlidingMeshDG/uqSlidingMeshDG.i $baseGitHubCWD/runNaluRtest/performance/uqSlidingMeshDG
cp $NaluRtestCWD/xml/milestone_aspect_ratio_smooth.xml $baseGitHubCWD/runNaluRtest/performance/uqSlidingMeshDG
cp $NaluRtestCWD/mesh/uqvawt_corrected.exo.* $baseGitHubCWD/runNaluRtest/performance/uqSlidingMeshDG
cp $NaluRtestCWD/performance/uqSlidingMeshDG/uqSlidingMeshDG.sh $baseGitHubCWD/runNaluRtest/performance/uqSlidingMeshDG
cp $NaluRtestCWD/performance/uqSlidingMeshDG/uqSlidingMeshDG.norm.gold* $baseGitHubCWD/runNaluRtest/performance/uqSlidingMeshDG
# run it...  
./uqSlidingMeshDG.sh

#=============================================================================
# oversetHybrid test
#=============================================================================
if [ ! -d "$baseGitHubCWD/runNaluRtest/performance/oversetHybrid" ]; then
    mkdir $baseGitHubCWD/runNaluRtest/performance/oversetHybrid
fi

cd $baseGitHubCWD/runNaluRtest/performance/oversetHybrid
cp $NaluRtestCWD/performance/oversetHybrid/oversetHybrid.i $baseGitHubCWD/runNaluRtest/performance/oversetHybrid
cp $NaluRtestCWD/xml/milestone.xml $baseGitHubCWD/runNaluRtest/performance/oversetHybrid
cp $NaluRtestCWD/performance/oversetHybrid/hybrid_sphere.g.* $baseGitHubCWD/runNaluRtest/performance/oversetHybrid
cp $NaluRtestCWD/performance/oversetHybrid/oversetHybrid.sh $baseGitHubCWD/runNaluRtest/performance/oversetHybrid
cp $NaluRtestCWD/performance/oversetHybrid/oversetHybrid.norm.gold* $baseGitHubCWD/runNaluRtest/performance/oversetHybrid
# run it...  
./oversetHybrid.sh

echo "Performance Rtest End"
