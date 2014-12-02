#include <iostream>
#include <cstdlib>
#include <cassert>
#include <cstring>

#define MB 1048576

enum AnalysisType {
  READS_ONLY,
  WRITES_ONLY,
  READS_AND_WRITES
};

using namespace std;

char *allocMem(unsigned long long size) {
  void *vptr = NULL;
  char *a = NULL;
  posix_memalign(static_cast<void**>(&vptr), 2*MB, size);

  assert(vptr);
  a = static_cast<char*>(vptr);

  memset(a, 124, sizeof(a));

  return a;
}

void randProbe(char *data, unsigned long long size, unsigned long long nProbes, AnalysisType a) {
  char sum;

  while (nProbes--) {
    unsigned long long probe_idx = rand() % size;

    switch (a) {
      case (READS_AND_WRITES):
        data[probe_idx] = rand() % 256;
      case (READS_ONLY):
        sum += data[probe_idx];
        break;
      case (WRITES_ONLY):
        data[probe_idx] = rand() % 256;
        break;
    }
  }
}

/*
* @argv[1] - analysis type
* @argv[2] - allocation size (in MB)
*/
int main(int argc, char **argv) {
  //unsigned long long dataSize = MB << 10;
  unsigned long long dataSize = MB << 10;
  dataSize *= 4;

  AnalysisType a = READS_ONLY;

  if (argc > 1) {
    if (!strcmp(argv[1], "reads")) {}
    else if (!strcmp(argv[1], "writes"))
      a = WRITES_ONLY;
    else if (!strcmp(argv[1], "reads_and_writes"))
      a = READS_AND_WRITES;
    else
      cerr << "WARNING: unrecognized analysis type" << endl;
  }

  if (argc > 2) {
    dataSize = MB * atoi(argv[2]);   
  }

  cout << (dataSize >> 20) << "MB allocated" << endl;

  char *data = allocMem(dataSize);
  memset(data, 1, sizeof(data));
  assert(data);
  randProbe(data, dataSize, 500000000, a);

  return 0;
}
