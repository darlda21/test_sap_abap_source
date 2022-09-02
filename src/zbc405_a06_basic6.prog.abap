*&---------------------------------------------------------------------*
*& Report ZBC405_A06_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_basic6.

TABLES: mast.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01. " Selection
  PARAMETERS pa_werks TYPE mkal-werks OBLIGATORY DEFAULT '1010'.
  SELECT-OPTIONS so_matnr FOR mast-matnr.
SELECTION-SCREEN END OF BLOCK bl1.

START-OF-SELECTION.

  DATA: BEGIN OF gs_data,
          matnr TYPE mast-matnr,
          maktx TYPE makt-maktx,
          stlan TYPE mast-stlan,
          stlnr TYPE mast-stlnr,
          stlal TYPE mast-stlal,
          mtart TYPE mara-mtart,
          matkl TYPE mara-matkl,
        END OF gs_data,
        gt_data LIKE TABLE OF gs_data.

  SELECT a~matnr b~maktx a~stlan a~stlnr a~stlal c~mtart c~matkl
    FROM mast AS a INNER JOIN makt AS b
    ON   a~matnr = b~matnr AND
         b~spras = sy-langu
         INNER JOIN mara AS c
         ON   a~matnr = c~matnr
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    WHERE a~matnr IN so_matnr.

  cl_demo_output=>display_data( gt_data ).
