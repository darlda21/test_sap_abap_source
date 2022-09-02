*&---------------------------------------------------------------------*
*& Include ZRSA06_31_TOP                            - Report ZRSA06_31
*&---------------------------------------------------------------------*
REPORT zrsa06_31.

" employee list
DATA: gs_emp TYPE zssa0004,
      gt_emp LIKE TABLE OF gs_emp.

" selection screen
PARAMETERS: pa_ent_b LIKE gs_emp-entdt,
            pa_ent_e LIKE gs_emp-entdt.
