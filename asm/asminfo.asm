*        ASMINFO -- the assembler main program: assembler and COBOL of
*        mvsinfo, the result to the console with WTO.
ASMINFO  CSECT
         STM   14,12,12(13)
         LR    12,15
         USING ASMINFO,12
         LA    11,SAVE
         ST    13,4(,11)
         ST    11,8(,13)
         LR    13,11
*        assembler -> assembler: the job name
         LA    1,PJOB
         L     15,=V(MIJOBN)
         BALR  14,15
*        assembler -> assembler: TIME DEC
         LA    1,PTIME
         L     15,=V(MITIME)
         BALR  14,15
*        assembler -> COBOL: OS linkage, the last address flagged
         LA    1,PFMT
         L     15,=V(MIFMTD)
         BALR  14,15
         MVC   MJOB,JOB
         MVC   MDATE,DATETXT
         WTO   MF=(E,WTOL)
         L     13,4(,13)
         LM    14,12,12(13)
         SR    15,15
         BR    14
SAVE     DS    18F
PJOB     DC    X'80',AL3(JOB)
PTIME    DC    A(HHMMSS)
         DC    X'80',AL3(YYDDD)
PFMT     DC    A(YYDDD)
         DC    X'80',AL3(DATETXT)
JOB      DC    CL8' '
HHMMSS   DC    F'0'
YYDDD    DC    F'0'
DATETXT  DC    CL8' '
WTOL     DC    AL2(WTOE-WTOL,0)
         DC    C'ASMINFO job '
MJOB     DC    CL8' '
         DC    C' today '
MDATE    DC    CL8' '
WTOE     EQU   *
         LTORG
         END   ASMINFO
