*&---------------------------------------------------------------------*
*& Report ZRSA06_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_08.

DATA gv_cnt TYPE i.

DO 10 TIMES.
  WRITE sy-index.
  gv_cnt = gv_cnt + 1.
  DO 5 TIMES.
    WRITE sy-index.
  ENDDO.
  NEW-LINE.
ENDDO.