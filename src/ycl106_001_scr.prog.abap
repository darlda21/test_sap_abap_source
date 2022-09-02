*&---------------------------------------------------------------------*
*& Include          YCL106_001_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXTT01. " textt01 변수 처리

  SELECT-OPTIONS S_CARRID FOR GS_SCARR-CARRID.
  SELECT-OPTIONS S_CARRNM FOR SCARR-CARRNAME.

SELECTION-SCREEN END OF BLOCK B01.
