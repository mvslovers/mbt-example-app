/* CINFO -- the C main program: C, assembler and COBOL of mvsinfo */
#include <stdio.h>
#include <ibm/mvs/cvt.h>
#include "mvsinfo.h"

int main(void)
{
    char job[9] = { 0 }, ipl[9], num[13];
    unsigned hhmmssth, yyddd;

    mi_jobname(job);                              /* C -> assembler */
    mi_time(&hhmmssth, &yyddd);                   /* C -> assembler */
    printf("CINFO   job %s on %s\n", job, mi_sysid());
    printf("CINFO   IPL %s, now %s %06X\n",
           mi_fmtdate(mi_ipldate(), ipl),         /* C -> COBOL */
           mi_fmtdate(yyddd, num), hhmmssth >> 8);
    printf("CINFO   %s bytes in a 16 MB address space\n", mi_fmtnum(16 * 1024 * 1024, num));
    printf("CINFO   the first 32 bytes of the CVT:\n");
    mi_hexdump(CVTPTR, 32);
    return 0;
}
