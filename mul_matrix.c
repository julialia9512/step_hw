#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

double get_time()
{
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_sec + tv.tv_usec * 1e-6;
}

double calc(int n)
{
  // if (argc != 2) {
  //   printf("usage: %s N\n", argv[0]);
  //   return -1;
  // }

  // int n = atoi(argv[1]);
  double* a = (double*)malloc(n * n * sizeof(double)); // Matrix A
  double* b = (double*)malloc(n * n * sizeof(double)); // Matrix B
  double* c = (double*)malloc(n * n * sizeof(double)); // Matrix C

  // Initialize the matrices to some values.
  int i, j;
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      a[i * n + j] = i * n + j; // A[i][j]
      b[i * n + j] = j * n + i; // B[i][j]
      c[i * n + j] = 0; // C[i][j]
    }
  }

  double begin = get_time();

  /**************************************/
  int k;
  double each_sum = 0;
  for (i = 0; i < n; i++){
    for (j = 0; j < n; j ++){
      for(k = 0; k < n; k ++){
        each_sum += a[i * n + k] * b[k * n + j];
      }
      c[i * n + j] = each_sum;
      each_sum = 0;
    }
  }
  /* Write code to calculate C = A * B. */
  /**************************************/

  double end = get_time();
  double calctime = end - begin;
  printf("time: %.6lf sec for N = %d\n", calctime, n);

  // Print C for debugging. Comment out the print before measuring the execution time.
  // N=100 time=0.006773sec
  // N=1000 time=6.101440sec
  // double sum = 0;
  // for (i = 0; i < n; i++) {
  //   for (j = 0; j < n; j++) {
  //     sum += c[i * n + j];
  //     printf("c[%d][%d]=%lf\n", i, j, c[i * n + j]);
  //   }
  // }
  // Print out the sum of all values in C.
  // This should be 450 for N=3, 3680 for N=4, and 18250 for N=5.
  // printf("sum: %.6lf\n", sum);


  free(a);
  free(b);
  free(c);
  return calctime;
}
int main (int argc, char** argv) {
  int n = atoi(argv[1]);
  FILE *gp;
  gp = popen("gnuplot -persist","w");
  fprintf(gp, "set xrange [0:500]\n");
  fprintf(gp, "set yrange [0:1]\n");
  fprintf(gp, "set xlabel 'N'\n");
  fprintf(gp, "set ylabel 'time(sec)'\n");

  fprintf(gp, "set grid \n");
  fprintf(gp, "plot '-' w lp lw 1\n");
  int i;
  for(i=0; i<n; i++){
    fprintf(gp,"%d\t %f\n", i, calc(i));
        // データの書き込み
  }

  fprintf(gp,"e\n");
  pclose(gp);
}
