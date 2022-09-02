*&---------------------------------------------------------------------*
*& Report ZRSA06_33
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA06_33.

DATA gs_dep TYPE zssa0606.      " dep info
DATA: gt_emp TYPE table of zssa0605,  " emp info
      gs_emp like LINE OF gt_emp.

PARAMETERS pa_dep TYPE ztsa0602-dpid.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa0602
    into CORRESPONDING FIELDS OF gs_dep
    where dpid = pa_dep.

  cl_demo_output=>display_data( gs_dep ).

  SELECT *
    from ztsa0601
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE depid = gs_dep-depid.

  cl_demo_output=>display_data( gt_emp ).
