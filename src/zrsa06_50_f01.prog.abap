*&---------------------------------------------------------------------*
*& Include          ZRSA06_50_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_init .
  pa_car = 'AA'.
  pa_con = '0017'.

  CLEAR: so_dat[], so_dat.     " internal table, structure variable
  so_dat-sign = 'I'.          " include
  so_dat-option = 'BT'.       " between
  so_dat-low = sy-datum - 365.
  so_dat-high = sy-datum.
  APPEND so_dat TO so_dat[].  " header line이 있는 internal table.
*  APPEND so_dat to so_dat.    " 대괄호는 생략 가능
*  APPEND so_dat.               " 이름이 같을 경우 to 이하 생략 가능
  CLEAR so_dat.
ENDFORM.
