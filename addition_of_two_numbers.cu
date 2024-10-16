#include<stdio.h>
#include<iostream>

using std::cout;
using std::cin;
using std::endl;

// Kernel to Add two numbers
__global__ void Add(int *a, int *b, int *c)
{
  *c = *a + *b;
}  

//Main function starts here
int main(void) {
  int a, b, c; // host copies of a, b, c
  int *d_a, *d_b, *d_c; // device copies of a, b, c
  int size = sizeof(int);
  
  // Allocate space for device copies of a, b, c
  cudaMalloc((void **)&d_a, size);
  cudaMalloc((void **)&d_b, size);
  cudaMalloc((void **)&d_c, size);
  
  cout<<"Enter the two numbers to add:"<<endl;
  cin>>a>>b;
  
  // Addition on the Device: main()
  // Copy inputs to device
  cudaMemcpy(d_a, &a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, &b, size, cudaMemcpyHostToDevice);
  
  // Launch add() kernel on GPU
  Add<<<1,1>>>(d_a, d_b, d_c);
  
  // Copy result back to host
  cudaMemcpy(&c, d_c, size, cudaMemcpyDeviceToHost);
  
  // Cleanup
  cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
  
  cout<<c;
  return 0;
}