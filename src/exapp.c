/* exapp.c — example application */
#include "exlib.h"
#include "exlibadd.h"
#include <stdio.h>

int main() {
  int rc = 0;

  int sum = 0;
  int dif = 0;

  sum = exlib_add(42, 0);
  dif = exlib_sub(84, 42);

  printf("EXAPP: Hello from mbt-example-app.\n");
  printf("EXAPP: %d\n", sum);
  printf("EXAPP: %d\n", dif);

  exlib_hello("FOO BAR BAZ");

  return 0;
}
