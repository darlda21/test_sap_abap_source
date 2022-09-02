*&---------------------------------------------------------------------*
*& Include ZC1R260002_TOP                           - Report ZC1R260002
*&---------------------------------------------------------------------*
REPORT zc1r260002 MESSAGE-ID zc226.

TABLES : ztsa0601.

DATA : gs_data type ztsa0601,
       gt_data LIKE TABLE OF gs_data.

* ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.

DATA : gv_okcode TYPE sy-ucomm.
