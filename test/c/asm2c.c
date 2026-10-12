/* ASM2C -- assembler calls C: ASMTOC, an OS-linkage routine with a
** static save area, calls the C function CTWICE through the stub CCTWICE
** and LIBC/370's @@CCALL. The main program is C because @@CCALL needs a
** C program on the task (without one: U3101). */
#include <mbtcheck.h>

#define VL(p) ((void *)((unsigned)(p) | 0x80000000))

extern int asmtoc(void *n) asm("ASMTOC");
int ctwice(int *n) asm("CTWICE");

/* doubles *n, rc 7; rc 99 when the pointer still carries the X'80' */
int ctwice(int *n)
{
    if ((unsigned)n & 0x80000000)
        return 99;
    *n *= 2;
    return 7;
}

int main(void)
{
    int n = 21;

    CHECK(asmtoc(VL(&n)) == 7, "C's return code comes back through assembler");
    CHECK(n == 42, "C doubled what assembler passed on");
    return mbt_test_summary("ASM2C");
}
