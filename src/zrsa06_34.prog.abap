*&---------------------------------------------------------------------*
*& Report ZRSA06_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_34.

" dep info
DATA gs_dep TYPE zssa0611.
DATA dt_dep LIKE TABLE OF gs_dep.

" Emp info (structure variable)
DATA gs_emp LIKE LINE OF gs_dep-emp_list.

PARAMETERS pa_dep TYPE ztsa0602-dpid.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa0602   "Dep table
    INTO CORRESPONDING FIELDS OF gs_dep
    WHERE dpid = pa_dep.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  "get employee list
  SELECT *
    FROM ztsa0601   "Employee table
    INTO CORRESPONDING FIELDS OF TABLE gs_dep-emp_list
    WHERE depid = gs_dep-depid.

  LOOP AT gs_dep-emp_list INTO gs_emp.
    MODIFY gs_dep-emp_list FROM gs_emp.
    CLEAR gs_emp.
  ENDLOOP.
