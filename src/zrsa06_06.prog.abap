*&---------------------------------------------------------------------*
*& Report ZRSA06_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_06.

PARAMETERS pa_i TYPE i.
DATA gv_result LIKE pa_i.

PARAMETERS pa_class TYPE c LENGTH 1. "a, b, c, d 중 1

CASE pa_class.
  WHEN 'A'.
    gv_result = pa_i + 100.
  WHEN OTHERS.
    IF pa_i > 20.
      gv_result = pa_i + 10.
    ELSEIF pa_i > 10.
      gv_result = pa_i.
    ENDIF.
ENDCASE.

"1번
*IF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*ELSE.
*  IF pa_i > 10.
*    WRITE pa_i.
*  ENDIF.
*ENDIF.

"2번
*IF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*ENDIF.
*IF pa_i > 10.
*  WRITE pa_i.
*ENDIF.

"3번
*IF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*ELSEIF pa_i > 10.
*  WRITE pa_i.
*ENDIF.

"내 풀이
*IF pa_i > 10.
*  IF pa_i > 20.
*    DATA gv_i TYPE i.
*    MOVE pa_i TO gv_i.
*    gv_i = gv_i + 10.
*    WRITE gv_i.
*  ELSE.
*    WRITE pa_i.
*  ENDIF.
*ENDIF.
