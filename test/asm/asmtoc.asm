*        ASMTOC -- OS-linkage routine that calls the C function CTWICE
*        through the stub CCTWICE.  R1 is passed on as it came; R15 is
*        C's return code.
ASMTOC   CSECT
         SAVE  (14,12)
         LR    12,15
         USING ASMTOC,12
         LA    2,SAVE
         ST    13,4(,2)
         ST    2,8(,13)
         LR    13,2
         L     15,=V(CCTWICE)
         BALR  14,15
         L     13,4(,13)
         RETURN (14,12),RC=(15)
SAVE     DS    18F
         LTORG
*        the stub: C function CTWICE through LIBC/370's @@CCALL
CCTWICE  CCALL CTWICE
         END
