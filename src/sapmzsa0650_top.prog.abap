*&---------------------------------------------------------------------*
*& Include SAPMZSA0650_TOP                          - Module Pool      SAPMZSA0650
*&---------------------------------------------------------------------*
PROGRAM sapmzsa0650.

" Common Variable
DATA ok_code TYPE sy-ucomm.

" Condition
TABLES zssa06ven01.
DATA gv_cond TYPE zssa06ven01.

" Flight Info
TABLES zssa06ven02.
DATA gv_fli TYPE zssa06ven02.

" Vendor Info
TABLES zssa06ven03.
DATA gv_ven TYPE zssa06ven03.

" Tab Strip
CONTROLS ts_info TYPE TABSTRIP.
