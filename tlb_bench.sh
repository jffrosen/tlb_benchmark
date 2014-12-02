#!/bin/bash

# your profiler options here
#PROF='/opt/intel/vtune_amplifier_xe_2015/bin64/amplxe-cl'
PROF='time'
#FLAGS='-collect general-exploration'
FLAGS=''
#POST='| grep -i tlb'
POST=''

EXE='./tlb_benchmark'

make clean
make

sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/defrag'

echo "With THP disabled:"
echo "  Reads only:"
#eval $PROF $FLAGS $EXE reads $POST
echo "  Writes only:"
#eval $PROF $FLAGS $EXE writes $POST
echo "  Reads and writes:"
eval $PROF $FLAGS $EXE reads_and_writes $POST

#/opt/intel/vtune_amplifier_xe_2015/bin64/amplxe-cl -collect general-exploration ./tlb_benchmark reads_and_writes | grep -i tlb


sudo sh -c 'echo always > /sys/kernel/mm/transparent_hugepage/enabled'
sudo sh -c 'echo always > /sys/kernel/mm/transparent_hugepage/defrag'

echo "With THP enabled:"
echo "  Reads only:"
#eval $PROF $FLAGS $EXE reads $POST
echo "  Writes only:"
#eval $PROF $FLAGS $EXE writes $POST
echo "  Reads and writes:"
eval $PROF $FLAGS $EXE reads_and_writes $POST
