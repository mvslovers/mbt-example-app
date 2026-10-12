/* COB2C -- COBOL calls C: the COBOL subprogram COBTOC calls the C
** function CFMT through the stub CCFMT and LIBC/370's @@CCALL. The main
** program is C because @@CCALL needs a C program on the task (without
** one: U3101). CFMT uses sprintf, so C's runtime works in there too. */
#include <stdio.h>
#include <string.h>
#include <mbtcheck.h>

#define VL(p) ((void *)((unsigned)(p) | 0x80000000))

extern int cobtoc(void *n, void *text) asm("COBTOC");
int cfmt(int *n, char *text) asm("CFMT");

/* *n as decimal digits into text, PIC X(12), left-justified */
int cfmt(int *n, char *text)
{
    char buf[13];
    int len;

    if ((unsigned)text & 0x80000000)
        return 99;
    len = sprintf(buf, "%d", *n);
    memset(text, ' ', 12);
    memcpy(text, buf, len);
    return 0;
}

int main(void)
{
    int n = -1234567;
    char text[13];

    memset(text, 'X', 12);
    text[12] = '\0';
    CHECK(cobtoc(&n, VL(text)) == 0, "COBTOC returns 0");
    CHECK(strcmp(text, "-1234567    ") == 0, "C formatted what COBOL passed on");
    return mbt_test_summary("COB2C");
}
