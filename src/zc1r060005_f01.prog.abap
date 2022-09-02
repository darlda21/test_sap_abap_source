*&---------------------------------------------------------------------*
*& Include          ZC1R260002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_param
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM init_param .
*
*  pa_carr = 'KA'.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR   gs_data.
  REFRESH gt_data.

  SELECT pernr ename entdt gender depid carrid
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM ztsa0601
   WHERE pernr IN so_pernr.

  " 이걸 빼면 데이터가 없어도 call screen
*  IF sy-subrc NE 0.
*    MESSAGE s001.
*    LEAVE LIST-PROCESSING. "STOP.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'D'.
*  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING :
    'X'   'PERNR'      ' '   'ZTSA0601' 'PERNR'   'X' 10,
    ' '   'ENAME'      ' '   'ZTSA0601' 'ENAME'   'X' 20,
    ' '   'ENTDT'      ' '   'ZTSA0601' 'ENTDT'   'X' 10,
    ' '   'GENDER'     ' '   'ZTSA0601' 'GENDER'  'X' 5,
    ' '   'DEPID'      ' '   'ZTSA0601' 'DEPID'   'X' 8,
    ' '   'CARRID'     ' '   'ZTSA0601' 'CARRID'  'X' 10.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field pv_edit
                    pv_length.

  gs_fcat = VALUE #( key       = pv_key
                     fieldname = pv_field
                     coltext   = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field
                     edit      = pv_edit
                     outputlen = pv_length ).

*  gs_fcat-key       = pv_key.
*  gs_fcat-fieldname = pv_field.
*  gs_fcat-coltext   = pv_text.
*  gs_fcat-ref_table = pv_ref_table.
*  gs_fcat-ref_field = pv_ref_field.
*
  APPEND gs_fcat TO gt_fcat.
*  CLEAR  gs_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

*  IF gcl_container IS INITIAL.
  IF gcl_container IS NOT BOUND.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
*       side      = cl_gui_docking_container=>dock_at_left
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .
  CLEAR gs_data.

  APPEND gs_data TO gt_data.

  PERFORM refresh_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .
  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space
*    EXCEPTIONS
*     finished       = 1
*     others         = 2
    .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .
  DATA: lt_save  TYPE TABLE OF ztsa0601,
        lv_error.

  REFRESH lt_save.

  CALL METHOD gcl_grid->check_changed_data
*    IMPORTING
*      e_valid   =
*    CHANGING
*      c_refresh = 'X'
    .

  CLEAR lv_error.
  LOOP AT gt_data INTO gs_data.
    IF gs_data-pernr IS INITIAL.
      MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
      lv_error = 'X'.
      EXIT.
    ENDIF.

    lt_save = VALUE #( BASE lt_save
                        (
                          pernr   = gs_data-pernr
                          ename   = gs_data-ename
                          entdt   = gs_data-entdt
                          gender  = gs_data-gender
                          depid   = gs_data-depid
                          carrid  = gs_data-carrid
                         )
                        ).

  ENDLOOP.

  IF lv_error IS NOT INITIAL.
    EXIT.
  ENDIF.

  IF lt_save IS NOT INITIAL.
    MODIFY ztsa0601 FROM TABLE lt_save.

    IF sy-dbcnt > 0.
      COMMIT WORK AND WAIT.
      MESSAGE s002.
    ENDIF.

  ENDIF.

ENDFORM.
