       IDENTIFICATION DIVISION.
       PROGRAM-ID. COB2ASM.
      *    COBOL calls assembler (MIJOBN, MITIME).  RC 0 = passed.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY MIPARMS.
       01  W-TIME    PIC S9(9) COMP.
       01  W-DATE    PIC S9(7) COMP-3.
       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE SPACES TO MI-JOBNAME.
           MOVE 0 TO W-DATE.
           CALL 'MIJOBN' USING MI-JOBNAME.
           CALL 'MITIME' USING W-TIME W-DATE.
           IF MI-JOBNAME NOT = SPACES AND W-DATE > 0
               DISPLAY 'COB2ASM PASS job ' MI-JOBNAME
               MOVE 0 TO RETURN-CODE
           ELSE
               DISPLAY 'COB2ASM FAIL job [' MI-JOBNAME ']'
               MOVE 8 TO RETURN-CODE.
           STOP RUN.
