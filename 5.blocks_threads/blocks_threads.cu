#include<cuda.h>
#include<iostream>
// To use the hardware resources efficiently, we have to give the grid and thread count in a way we map the data to the threads.
using std::cout;
using std::endl;

int main()
{
  // dim3 are CUDA 3D vectors which have x,y and z coordinates. These are used to access particular threads inside particular blocks.
  //By defaults dim3 are initialized with 1,1,1 by the compiler.
  dim3 n_threads, n_blocks;
  cout<<"Threads Default: "<<n_threads.x<<", "<<n_threads.y<<", "<<n_threads.z<<", "<<" Blocks Default: "<<n_blocks.x<<", "<<n_blocks.y<<", "<<n_blocks.z<<", "<<endl;
  // We here having given a grid with 1 X 2 X 3 = 6 blocks and each block will have 3 X 4 X 5  = 60 threads so in total we'll have:
  // Total threads = no. of threads per block * no. of blocks in grid = 6 * 60 = 360 Threads
  n_blocks = {1,2,3};
  n_threads = {3,4,5};
  cout<<"Threads: "<<n_threads.x<<", "<<n_threads.y<<", "<<n_threads.z<<", "<<" Blocks: "<<n_blocks.x<<", "<<n_blocks.y<<", "<<n_blocks.z<<", "<<endl;
  //The number of threads in a block times the number of blocks gives the total number of threads that the kernel is executed in
  long total_threads = ( n_threads.x * n_threads.y * n_threads.z) * (n_blocks.x * n_blocks.y * n_blocks.z);
  cout<<"Total Threads: "<<total_threads;
  
  //The above n_threads and n_blocks can be passed to the kernel call to specify with hows many threads and blocks , that kernel will run on the GPU
  return 0;
}