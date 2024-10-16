// A Simple CUDA Program that prints Hello world after processing it in the GPU instead of the CPU
#include<cuda.h>  //Add CUDA library
#include<stdio.h> //For printf function

//kernel to print Hello World!
__global__ void HelloFromGPU()
{
  printf("Hello World from GPU!\n");
}


int main(){
  
  // Launch the kernel
  HelloFromGPU<<<1, 1>>>(); 
  // Wait for GPU to finish before continuing to CPU
  cudaDeviceSynchronize();
  return 0;
}   