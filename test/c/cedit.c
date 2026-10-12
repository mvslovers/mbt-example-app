/* CEDIT -- a C function for a COBOL main (COBM2C): *n as decimal digits
** into text, PIC X(12), left-justified, and a line on stdout, which
** reaches SYSPRINT when COBOL calls CCTERM. */
#include <stdio.h>
#include <string.h>

int cedit(int *n, char *text) asm("CEDIT");

int cedit(int *n, char *text)
{
    char buf[13];
    int len;

    if ((unsigned)text & 0x80000000)
        return 99;
    len = sprintf(buf, "%d", *n);
    memset(text, ' ', 12);
    memcpy(text, buf, len);
    printf("COBM2C: CEDIT %d\n", *n);
    return 0;
}
