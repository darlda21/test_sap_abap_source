*&---------------------------------------------------------------------*
*& Report ZRCA06_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca06_02.

DATA gv_step TYPE i.    " 곱할 수
DATA gv_cal TYPE i.     " 곱한 값(결과)
DATA gv_lev TYPE i.     " 단

PARAMETERS pa_lev LIKE gv_lev. " 입력 단
PARAMETERS pa_syear(1) TYPE c.  " 입력 학년

** 학년 입력 및 단수 계산
CASE pa_syear.
  WHEN '1'.
    IF pa_lev >= 3.
      pa_lev = 3.
    ENDIF.
  WHEN '2'.
    IF pa_lev >= 5.
      pa_lev = 5.
    ENDIF.
   WHEN '3'.
    IF pa_lev >= 7.
      pa_lev = 7.
    ENDIF.
   WHEN '4' OR '5'.
   WHEN '6'.
    pa_lev = 9.
  WHEN OTHERS.
    MESSAGE 'Message Test' TYPE 'A'.
ENDCASE.

** 구구단 계산 및 출력
WRITE 'Times Tables'.
NEW-LINE.

DO pa_lev TIMES.
  gv_lev = gv_lev + 1.

  DO 9 TIMES.
    gv_step = gv_step + 1.

    gv_cal = gv_lev * gv_step.

    WRITE: gv_lev, ' * ', gv_step, ' = ', gv_cal.
    NEW-LINE.

    CLEAR gv_cal.
  ENDDO.

  WRITE '======================================================'.
  NEW-LINE.

  CLEAR gv_step.
ENDDO.

CLEAR gv_lev.
