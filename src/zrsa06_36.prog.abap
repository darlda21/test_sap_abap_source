*&---------------------------------------------------------------------*
*& Report ZRSA06_36
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_36.

TYPES: BEGIN OF ts_dep,
         budget TYPE ztsa0602-budget,
         waers TYPE ztsa0602-waers,
       END OF ts_dep.

DATA: gs_dep TYPE zssa0620,       "ts_dep "ztsa0602
      gt_dep LIKE TABLE OF gs_dep.

*PARAMETERS pa_dep LIKE gs_dep-dpid.

DATA go_salv TYPE REF TO cl_salv_table.

START-OF-SELECTION.

   SELECT *
     FROM ztsa0602
     INTO CORRESPONDING FIELDS OF TABLE gt_dep.

   cl_salv_table=>factory(
     IMPORTING r_salv_table = go_salv
     CHANGING t_table = gt_dep
   ).
   go_salv->display( ).

*   cl_demo_output=>display_data( gt_dep ).

*  SELECT SINGLE *
*    FROM ztsa0602
*    INTO CORRESPONDING FIELDS OF gs_dep
*    WHERE dpid = pa_dep.
*
*
*
*   currenct k.w 사용(권장 x)
*  WRITE: gs_dep-budget CURRENCY gs_dep-waers,
*         gs_dep-waers.
