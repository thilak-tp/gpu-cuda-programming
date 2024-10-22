#include<cuda.h>
#include<time.h>
#include<iostream>
#include<stdio.h>

// Using only standard couts and endls
using std::cout;
using std::endl;


// GPU kernel to count from 1 to a billion
__global__ void GPUCountBillion(int *i)
{
  
  for(*i=0; (*i) < 1000000000; (*i)++);
   // printf("%d\n",*i);

}

// CPU function to count from 1 to a billion
void CPUCountBillion()
{
  for(int i =0; i < 1000000000; i++);
    //cout<<i<<endl;
    
}

// Main function 
int main()
{
  //Allocation GPU memoery for i interator
  int *i;
  cudaMalloc((void **)&i,sizeof(int));
  
  //Before CPU function call timestamp
  clock_t tic = clock();
 
  //CPU function call
  CPUCountBillion();

  //After CPU function call timestamp
  clock_t toc = clock();
  //Difference between after and before gives the total seconds taken for the CPU function to be executed
  double cpu_time = double (toc - tic ) / CLOCKS_PER_SEC;
  
  //Before GPU Kernel call timestamp
  clock_t tic1 = clock();

  //GPU kernel call with 1 block each of a single thread
  GPUCountBillion<<<1,1>>>(i);
  
  //After GPU Kernel call timestamp
  clock_t toc1 = clock();
  //Difference between after and before gives the total seconds taken for the GPU kernel to be executed
  double gpu_time = double (toc1 - tic1 ) / CLOCKS_PER_SEC;

  cout<<"CPU Time for Execution "<<cpu_time<<endl;
  cout<<"GPU Time for Execution "<<gpu_time;

}