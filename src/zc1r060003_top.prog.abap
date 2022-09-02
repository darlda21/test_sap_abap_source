*&---------------------------------------------------------------------*
*& Include ZC1R260004_TOP                           - Report ZC1R260004
*&---------------------------------------------------------------------*
REPORT zc1r260004 MESSAGE-ID zc226.

CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES : mast.

DATA : BEGIN OF gs_data,
         matnr TYPE mast-matnr,
         maktx TYPE makt-maktx,
         stlan TYPE mast-stlan,
         stlnr TYPE mast-stlnr,
         stlal TYPE mast-stlal,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data.

* ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler   TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

DATA : gv_okcode TYPE sy-ucomm.

DEFINE _clear.

  CLEAR   &1.
  REFRESH &1.

END-OF-DEFINITION.
