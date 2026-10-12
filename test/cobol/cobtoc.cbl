       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBTOC.
      *    COBOL calls C: CFMT through the stub CCFMT.
       DATA DIVISION.
       LINKAGE SECTION.
       01  L-N       PIC S9(9) COMP.
       01  L-TEXT    PIC X(12).
       PROCEDURE DIVISION USING L-N L-TEXT.
       MAIN-PARA.
           CALL 'CCFMT' USING L-N L-TEXT.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
