/* mvsinfoa.c — MVS system information report (batch program)
**
** Demonstrates using mbt-example-lib to query and display
** MVS system information from a batch job.
**
** Expected output on SYSPRINT:
**
**   MVSINFO  MVS SYSTEM INFORMATION REPORT
**   -------- -----------------------------------
**   JOB      MVSINFO
**   SYSTEM   MVS1
**   IPL DATE 2025.042
**   -------- -----------------------------------
**   CVT AT 00FD4810
**     00FD4810  00000000 00FE1234 ...  *............*
**     ...
**   -------- -----------------------------------
**   JES2 QUEUE: 3 JOBS
**     MVSINFO  JOB00042  IBMUSER   EXECUTING
**     ...
*/
#include <stdio.h>
#include <stdlib.h>
#include <cvt.h>
#include "hexdump.h"
#include "sysinfo.h"
#include "jesinf.h"

#define SEPARATOR "-------- -----------------------------------"

static const char *status_name(unsigned char st)
{
    switch (st) {
    case JESINF_ST_INPUT:   return "INPUT";
    case JESINF_ST_EXEC:    return "EXECUTING";
    case JESINF_ST_OUTPUT:  return "OUTPUT";
    default:                return "UNKNOWN";
    }
}

/* format packed decimal IPL date 0x0CYYDDDF to readable string */
static void format_ipldate(unsigned packed, char *buf, int buflen)
{
    unsigned yy  = (packed >> 16) & 0xFF;
    unsigned ddd = (packed >> 4) & 0xFFF;

    sprintf(buf, "20%02X.%03X", yy, ddd);
}

int main()
{
    const char *jobname;
    const char *sysid;
    unsigned ipldate;
    char datebuf[16];
    CVT *cvt;
    JESINF_ENTRY *jobs;
    int njobs;
    int i;

    printf("MVSINFO  MVS SYSTEM INFORMATION REPORT\n");
    printf("%s\n", SEPARATOR);

    /* system info from control blocks */
    jobname = sysinfo_jobname();
    sysid   = sysinfo_sysid();
    ipldate = sysinfo_ipldate();
    format_ipldate(ipldate, datebuf, sizeof(datebuf));

    printf("JOB      %s\n", jobname);
    printf("SYSTEM   %s\n", sysid);
    printf("IPL DATE %s\n", datebuf);

    /* CVT hex dump (first 64 bytes) */
    printf("%s\n", SEPARATOR);
    cvt = CVTPTR;
    printf("CVT AT %08X\n", (unsigned)cvt);
    hexdump(cvt, 64);

    /* JES2 job queue */
    printf("%s\n", SEPARATOR);
    jobs = jesinf_list(&njobs);
    if (jobs != 0) {
        printf("JES2 QUEUE: %d JOBS\n", njobs);
        for (i = 0; i < njobs; i++) {
            printf("  %-8s %-8s  %-8s  %s\n",
                   jobs[i].jobname,
                   jobs[i].jobid,
                   jobs[i].owner,
                   status_name(jobs[i].status));
        }
        free(jobs);
    } else {
        printf("JES2 QUEUE: NOT AVAILABLE\n");
    }

    printf("%s\n", SEPARATOR);

    return 0;
}
