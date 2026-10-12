       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBM2C.
      *    A COBOL main calls C.  No C program is on the task: the
      *    first call builds the C environment, the second finds it,
      *    and CCTERM ends it (flushes C's output).  RC 0 = passed.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  W-N       PIC S9(9) COMP.
       01  W-TEXT    PIC X(12).
       01  W-FAIL    PIC 9 VALUE 0.
       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE -1234567 TO W-N.
           MOVE SPACES TO W-TEXT.
           CALL 'CCEDIT' USING W-N W-TEXT.
           IF W-TEXT NOT = '-1234567    '
               DISPLAY 'COBM2C FAIL call 1 [' W-TEXT ']'
               MOVE 1 TO W-FAIL.
           MOVE 42 TO W-N.
           MOVE SPACES TO W-TEXT.
           CALL 'CCEDIT' USING W-N W-TEXT.
           IF W-TEXT NOT = '42          '
               DISPLAY 'COBM2C FAIL call 2 [' W-TEXT ']'
               MOVE 1 TO W-FAIL.
           CALL 'CCTERM'.
           IF W-FAIL = 0
               DISPLAY 'COBM2C PASS'
               MOVE 0 TO RETURN-CODE
           ELSE
               MOVE 8 TO RETURN-CODE.
           STOP RUN.
