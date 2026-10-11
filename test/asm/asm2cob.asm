*        ASM2COB -- assembler calls COBOL (MIFMTD), OS linkage.  RC 0.
ASM2COB  CSECT
         STM   14,12,12(13)
         LR    12,15
         USING ASM2COB,12
         LA    11,SAVE
         ST    13,4(,11)
         ST    11,8(,13)
         LR    13,11
         LA    1,PLIST
         L     15,=V(MIFMTD)
         BALR  14,15
         LA    15,8
         CLC   TEXT,=CL8'2026.284'
         BNE   RET
         SR    15,15
RET      L     13,4(,13)
         L     14,12(,13)
         LM    0,12,20(13)
         BR    14
SAVE     DS    18F
PLIST    DC    A(DATE)
         DC    X'80',AL3(TEXT)
DATE     DC    X'0126284F'
TEXT     DC    CL8' '
         LTORG
         END   ASM2COB
