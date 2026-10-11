       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBINFO.
      *    the COBOL main program: assembler and COBOL of mvsinfo
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY MIPARMS.
       01  W-TIME    PIC S9(9) COMP.
       01  W-DATE    PIC S9(7) COMP-3.
       PROCEDURE DIVISION.
       MAIN-PARA.
      *    COBOL -> assembler: pointers only, the VL bit is dropped
           CALL 'MIJOBN' USING MI-JOBNAME.
           CALL 'MITIME' USING W-TIME W-DATE.
      *    COBOL -> COBOL
           CALL 'MIFMTD' USING W-DATE MI-DATE-TEXT.
           MOVE 16777216 TO MI-NUM.
           CALL 'MIFMTN' USING MI-NUM MI-NUM-TEXT.
           DISPLAY 'COBINFO job ' MI-JOBNAME ' today ' MI-DATE-TEXT.
           DISPLAY 'COBINFO ' MI-NUM-TEXT ' bytes in 16 MB'.
           MOVE 0 TO RETURN-CODE.
           STOP RUN.
