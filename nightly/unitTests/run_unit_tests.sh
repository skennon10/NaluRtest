#!/bin/bash

exe=../../unittestX

for p in 1 2 ; do
  output_file=unit_test_output.np${p}
  printf "..unit_tests-np%s....." ${p}
  mpirun -np ${p} ${exe} >& ${output_file}
  if [ "$?" -ne 0 ]
  then
    printf "......... FAILED, output is in %s\n" ${output_file}
  else
    printf "......... PASSED\n"
  fi
done

