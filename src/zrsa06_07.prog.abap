*&---------------------------------------------------------------------*
*& Report ZRSA06_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_07.

PARAMETERS pa_code TYPE c LENGTH 4 DEFAULT 'SYNC'.
PARAMETERS pa_date TYPE sy-datum.
DATA gc_today LIKE pa_date.

gc_today = sy-datum. " today

CASE pa_code.
  WHEN 'SYNC'.
  WHEN OTHERS.
    WRITE TEXT-t02. "Next time...
ENDCASE.

IF + pa_date > gc_today + 10.
  WRITE '취업'..
ELSEIF + pa_date = gc_today + 7.
  WRITE TEXT-t01. " ABAP Dictionary
ELSEIF + pa_date <= gc_today - 7.
  WRITE 'SAPUI5'.
ELSEIF + pa_date <= + '20220620'.
  WRITE '교육 준비중'.
ELSE.
  WRITE 'ABAP Workbench'.
ENDIF.
