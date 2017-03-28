NaluRtest
=========

Regression test suite for Nalu

## Preliminary building tasks

Please proceed with following the build instructions under [Nalu.wiki](https://github.com/NaluCFD/Nalu/wiki/Build_instructions)

The NaluRtest repository is cloned via,

	git clone https://github.com/NaluCFD/NaluRtest.git
	
## Directions

Thus far, both the Nalu and NaluRtest git repository should have been cloned. Moreover, the build process has been completed with a `naluX` executable created in the `Nalu/build` location.

Within the `NaluRtest` directory is a file by the name of run_tests.sh. Executing this bash script,

	./run_test.sh
	
will result in a temporary directory called runNaluRtest created in the ../ location.

The script also searches for a `NaluProjectPath.txt` file that specifies the specific location in which the Nalu cloned repository resides should the default name of `Nalu` not be in use.

Executing the script will provide the set of individual test PASSED/FAILED status. Code changes that result in any FAILED status is not to be pushed unless the formal reason for a fail are understood. At this point, the test gold copy norm file can be "re-blessed".

The PASSED/FAILED status is based on a set of integrated norms, time step and time step count at the end of time step. Simulations will report a FAILED status if any single time step has a set of results that are off by the test tolerance. Test tolerances are specified in the particular test `theTest.sh` file.

Re-running the run_test.sh script will check if directories are already in existance. If a previous test voucher provides a PASSED status, the successful test will not be run again. 

## Sample Output

	Rtest Begin
	..concentricRad............... PASSED
	..edgeContact3D............... PASSED
	..fluidsPmrChtPeriodic........ PASSED
	..edgePipeCHT................. PASSED
	..elemBackStepLRSST........... FAILED
	..heliumPlume................. PASSED
	Rtest End
