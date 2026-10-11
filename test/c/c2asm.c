/* C2ASM -- C calls assembler: pointer arguments, no VL bit needed */
#include <string.h>
#include <mbtcheck.h>
#include "mvsinfo.h"

int main(void)
{
    char job[9] = { 0 };
    unsigned t = 0, d = 0;

    CHECK(mi_jobname(job) == 0 && job[0] != ' ' && job[0] != 0, "a job name from the TIOT");
    CHECK(mi_time(&t, &d) == 0, "MITIME returns 0");
    CHECK((d & 0xF) == 0xF && ((d >> 4) & 0xFFF) >= 1, "TIME DEC date is packed 0CYYDDDF");
    return mbt_test_summary("C2ASM");
}
