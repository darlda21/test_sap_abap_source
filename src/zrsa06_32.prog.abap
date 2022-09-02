*&---------------------------------------------------------------------*
*& Report ZRSA06_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa06_32_top                           .    " Global Data

* INCLUDE ZRSA06_32_O01                           .  " PBO-Modules
* INCLUDE ZRSA06_32_I01                           .  " PAI-Modules
* INCLUDE ZRSA06_32_F01                           .  " FORM-Routines

INITIALIZATION.
  pa_pernr = '22020001'.

START-OF-SELECTION.
  SELECT SINGLE *
      FROM ztsa0601     " employee table
      INTO CORRESPONDING FIELDS OF gs_emp
      WHERE pernr = pa_pernr.

  IF sy-subrc <> 0.
     MESSAGE i001(zmcsa06).   " Data is not found
     RETURN.
  ENDIF.

*  WRITE gs_emp-depid.
*  NEW-LINE.
*  WRITE gs_emp-dep-depid.     " Nested Structure Variable

  SELECT SINGLE *
    FROM ztsa0602
    INTO CORRESPONDING FIELDS OF gs_emp-dep
    WHERE dpid = gs_emp-depid.

  cl_demo_output=>display_data( gs_emp-dep ).
