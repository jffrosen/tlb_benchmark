tlb_benchmark: tlb_benchmark.cc
	g++ tlb_benchmark.cc -std=c++0x -o tlb_benchmark

all: tlb_benchmark.cc
	tlb_benchmark

clean:
	rm -rf tlb_benchmark
