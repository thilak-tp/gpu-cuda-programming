#include<cuda.h>
#include<iostream>
#include<time.h>
using std::cout;
using std::endl;

//Function to run on CPU for vector addition
void CPUVectorAdd(float *h_vector_a, float *h_vector_b, float *h_sum_ab, long long *n)
{
  for(int i=0;i<*n;i++)
  {
    h_sum_ab[i] = h_vector_a[i] + h_vector_b[i];
  }

}

//Kernel to run on GPU for vector addition
__global__ void GPUVectorAdd(float *d_vector_a, float *d_vector_b, float *d_sum_ab, long long *n)
{
  long long id = blockIdx.x*blockDim.x+threadIdx.x;
  if(id < *n)
    d_sum_ab[id] = d_vector_a[id] + d_vector_b[id];
}


int main()
{

  // Number of elements in the arrays. A and B.
  long long n = 1000000000;
  float *h_vector_a,*h_vector_b, *h_sum_ab, *h_gpu_op;
  float *d_vector_a,*d_vector_b, *d_sum_ab;
  long long *N;
  
  //Calcutate the size of the vectors in terms of space required
  long long size = n * sizeof(float);

  clock_t tic2  = clock();
  //Allocation of Host (CPU) memory for vectors
  h_vector_a = (float*)malloc(size);
  h_vector_b = (float*)malloc(size);
  h_sum_ab = (float*)malloc(size);
  h_gpu_op = (float*)malloc(size);
  clock_t toc2 = clock();
  float host_dyn_mem_time = float(toc2 - tic2)/CLOCKS_PER_SEC;
  cout<<"Time of Host dynamic allocation of memory: "<<host_dyn_mem_time<<endl;
  //cout<<"Reached before cuda malloc";
  //Allocation of Device (GPU) memory for vectors
  
  clock_t tic3  = clock();
  cudaMalloc(&d_vector_a,size);
  cudaMalloc(&d_vector_b,size);
  cudaMalloc(&d_sum_ab,size);
  cudaMalloc(&N,sizeof(long long));
  clock_t toc3 = clock();
  float device_dyn_mem_time = float(toc3 - tic3)/CLOCKS_PER_SEC;
  cout<<"Time of Device dynamic allocation of memory: "<<device_dyn_mem_time<<endl;

  clock_t tic4  = clock();
  for(int i = 0;i < n; i++)
  {
    h_vector_a[i] = 1.5;
    h_vector_b[i] = 5.5;
    h_sum_ab[i] = 0;
    h_gpu_op[i] = 0;
  }
  clock_t toc4 = clock();
  float host_init_time = float(toc4 - tic4)/CLOCKS_PER_SEC;
  cout<<"Time of for host initialization of vectors: "<<host_init_time<<endl;

  clock_t tic = clock();
  CPUVectorAdd(h_vector_a, h_vector_b, h_sum_ab,&n);
  clock_t toc = clock();
  float cpu_time = float(toc - tic) / CLOCKS_PER_SEC;
  cout<<"CPU Time for execution: "<<cpu_time<<endl;
  //for(int i=0 ;i <n;i++)
  // cout<<h_sum_ab[i]<<endl;



  //cout<<"Reached after CPU time execution";
  //Copy the vectors A and B into the GPU memories
  clock_t tic5 = clock();
  cudaMemcpy(d_vector_a,h_vector_a,size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_vector_a,h_vector_a,size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_sum_ab,h_sum_ab,size, cudaMemcpyHostToDevice);
  cudaMemcpy(N,&n,sizeof(long long),cudaMemcpyHostToDevice);
  clock_t toc5 = clock();
  float host_to_device_cpy = float(toc5 - tic5)/CLOCKS_PER_SEC;
  cout<<"Host to device Copy time: "<<host_to_device_cpy<<endl;
  
  int n_Threads = 1024;
  int n_blocks = (float)n/n_Threads;
  clock_t tic6 = clock();
  cudaMemcpy(h_gpu_op,d_sum_ab,size,cudaMemcpyDeviceToHost);
  clock_t toc6 = clock();
  float device_to_host_cpy = float(toc6 - tic6)/CLOCKS_PER_SEC;
  cout<<"Device to host Copy time: "<<device_to_host_cpy<<endl;

  //cout<<"Reached after op copy";
  clock_t tic1 = clock();
  GPUVectorAdd<<<n_blocks,n_Threads>>>(d_vector_a, d_vector_b, d_sum_ab, N);
  clock_t toc1 = clock();
  float gpu_time = float(toc1 - tic1) / CLOCKS_PER_SEC;
  cout<<"GPU Time for execution: "<<gpu_time<<endl;
  // for(int i=0;i<n;i++)
  //   cout<<h_gpu_op[i]<<endl;

  free(h_gpu_op);
  free(h_sum_ab);
  free(h_vector_a);
  free(h_vector_b);
  cudaFree(d_sum_ab);
  cudaFree(d_vector_a);
  cudaFree(d_vector_b);
  cudaFree(N);
  
  return 0;
}

