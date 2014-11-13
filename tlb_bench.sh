#!/bin/bash

# your profiler options here
PROF='/opt/intel/vtune_amplifier_xe_2015/bin64/amplxe-cl'
FLAGS='-collect general-exploration'
POST='| grep -i tlb'

EXE='./tlb_benchmark'

make clean
make

sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/defrag'

echo "With THP disabled:"
echo "  Reads only:"
eval $PROF $FLAGS $EXE reads $POST
echo "  Writes only:"
eval $PROF $FLAGS $EXE writes $POST
echo "  Reads and writes:"
eval $PROF $FLAGS $EXE reads_and_writes $POST

#/opt/intel/vtune_amplifier_xe_2015/bin64/amplxe-cl -collect general-exploration ./tlb_benchmark reads_and_writes | grep -i tlb


sudo sh -c 'echo always > /sys/kernel/mm/transparent_hugepage/enabled'
sudo sh -c 'echo always > /sys/kernel/mm/transparent_hugepage/defrag'

echo "With THP enabled:"
echo "  Reads only:"
eval $PROF $FLAGS $EXE reads $POST
echo "  Writes only:"
eval $PROF $FLAGS $EXE writes $POST
echo "  Reads and writes:"
eval $PROF $FLAGS $EXE reads_and_writes $POST
