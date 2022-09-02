*&---------------------------------------------------------------------*
*& Report YCL106_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YCL106_001.

INCLUDE YCL106_001_TOP.
INCLUDE YCL106_001_CLS.
INCLUDE YCL106_001_SCR.
INCLUDE YCL106_001_PBO.
INCLUDE YCL106_001_PAI.
INCLUDE YCL106_001_F01.

INITIALIZATION.
  TEXTT01 = '검색조건'.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM SELECT_DATA.  " 실행하면 바로 검색이 실행되도록

END-OF-SELECTION.
  IF GT_SCARR[] IS INITIAL.
    MESSAGE 'Data not found' TYPE 'S' DISPLAY LIKE 'W'.
  ELSE.
    CALL SCREEN 0100.
  ENDIF.
