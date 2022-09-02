*&---------------------------------------------------------------------*
*& Include          ZC1R060007_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR gs_data.
  REFRESH gt_data. " header line이 있는 internal table clear = clear gt_data[]

  SELECT a~carrid a~carrname a~url
         b~connid b~fldate b~planetype b~price b~currency
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM scarr AS a INNER JOIN sflight AS b
    ON   a~carrid = b~carrid
    WHERE a~carrid IN so_carid AND
          b~connid IN so_conid AND
          b~planetype IN so_pltyp.

  IF sy-subrc NE 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING.
  ENDIF.

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
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING :
    'X'   'CARRID'    ' '   'SCARR'     'CARRID'   ,
    ' '   'CARRNAME'  ' '   'SCARR'     'CARRNAME' ,
    'X'   'CONNID'    ' '   'SFLIGHT'   'CONNID'   ,
    'X'   'FLDATE'    ' '   'SFLIGHT'   'FLDATE'   ,
    ' '   'PLANETYPE' ' '   'SFLIGHT'   'PLANETYPE',
    ' '   'PRICE'     ' '   'SFLIGHT'   'PRICE'    ,
    ' '   'CURRENCY'  ' '   'SFLIGHT'   'CURRENCY' ,
    ' '   'URL'       ' '   'SCARR'     'URL'      .

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
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.
  gs_fcat = VALUE #(
                     key = pv_key
                     fieldname = pv_field
                     coltext   = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field
                    ).

  CASE pv_field.
    WHEN 'PRICE'.
      gs_fcat = VALUE #( BASE  gs_fcat
                         cfieldname = 'CUTTENCY' ).
    WHEN 'PLANETYPE'.
      gs_fcat-hotspot = 'X'.
    WHEN OTHERS.
  ENDCASE.

  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_screen OUTPUT.
  IF gcl_container IS NOT BOUND.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid  " 현재 시스템 id
        dynnr     = sy-dynnr  " 현재 스크린 번호
*       side      = gcl_container->dock_at_left
        side      = cl_gui_docking_container=>dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

*    gs_variant-report = sy-repid.
*
*    IF gcl_handler IS NOT BOUND.
*      CREATE OBJECT gcl_handler.
*    ENDIF.
*
*    SET HANDLER : gcl_handler->handle_double_click FOR gcl_grid,
*                  gcl_handler->handle_hotspot      FOR gcl_grid.

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
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING    ps_row_id TYPE lvc_s_row
                              ps_column_id TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'PLANETYPE'.
      IF gs_data-planetype IS INITIAL.
        EXIT.
      ENDIF.

      PERFORM get_planetype_info USING gs_data-planetype. " saplane keyfield
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_planetype_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_DATA_PLANETYPE
*&---------------------------------------------------------------------*
FORM get_planetype_info  USING    pv_gs_data_planetype TYPE saplane-planetype.
  CLEAR gs_saplane.
  REFRESH gt_saplane.




ENDFORM.
