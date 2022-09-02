*&---------------------------------------------------------------------*
*& Report ZRSA06_31
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa06_31_top                           .    " Global Data

* INCLUDE ZRSA06_31_O01                           .  " PBO-Modules
* INCLUDE ZRSA06_31_I01                           .  " PAI-Modules
 INCLUDE zrsa06_31_f01                           .  " FORM-Routines

INITIALIZATION.
  PERFORM set_default.

START-OF-SELECTION.
  SELECT *
    FROM ztsa0601
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE entdt BETWEEN pa_ent_b AND pa_ent_e.

  IF sy-subrc IS NOT INITIAL.
*    MESSAGE i...
    RETURN.
  ENDIF.

cl_demo_output=>display_data( gt_emp ).
