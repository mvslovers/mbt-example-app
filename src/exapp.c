/* exapp.c — example application */
#include "exlib.h"
#include <stdio.h>

int main() {
  int rc = 0;

  int sum = 0;

  sum = exlib_add(42, 0);

  printf("EXAPP: Hello from mbt-example-app. The answer is always %d !!!\n");

  return 0;
}
