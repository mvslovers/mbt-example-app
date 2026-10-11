/* C2COB -- C calls COBOL: the formatters, through their C wrappers */
#include <string.h>
#include <mbtcheck.h>
#include "mvsinfo.h"

int main(void)
{
    char out[13];

    CHECK(strcmp(mi_fmtdate(0x0126284F, out), "2026.284") == 0, "0CYYDDDF -> YYYY.DDD");
    CHECK(strcmp(mi_fmtdate(0x0099001F, out), "1999.001") == 0, "a 19xx date");
    CHECK(strcmp(mi_fmtnum(-1234567, out), "  1,234,567-") == 0, "edited picture, negative");
    CHECK(strcmp(mi_fmtnum(0, out), "          0 ") == 0, "zero: Z suppressed, the sign position blank");
    return mbt_test_summary("C2COB");
}
