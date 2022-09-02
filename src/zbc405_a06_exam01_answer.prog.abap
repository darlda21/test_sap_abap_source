*&---------------------------------------------------------------------*
*& Report ZSYPALV002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_exam01_answer.


TABLES : ZTSPFLI_a06.

DATA : ok_code TYPE sy-ucomm.

TYPES : BEGIN OF t_tab.
    INCLUDE TYPE   ZTSPFLI_a06.
    TYPES : timezoneFR TYPE s_tzone.
    TYPES : timezoneto TYPE s_tzone.
    TYPES : id_ind TYPE c LENGTH 1.
    TYPES : btn_text TYPE c LENGTH 10.
    TYPES : fltype_icon  TYPE icon-id.
    TYPES : ct TYPE lvc_t_styl.
    TYPES : lights TYPE c LENGTH 1.
    TYPES : col_row TYPE c LENGTH 4.
    TYPES : it_col TYPE lvc_t_scol.
    TYPES : chg.
TYPES : END OF t_tab.

DATA : gt_tab TYPE TABLE OF t_tab.
DATA : ls_tab TYPE t_tab.

TYPES : BEGIN OF rty_carrid.
    TYPES : sign TYPE ddsign.
    TYPES : option TYPE ddoption.
    TYPES : low TYPE s_carr_id.
    TYPES : high TYPE s_carr_id.
TYPES : END OF rty_carrid.

DATA : wa_carr TYPE rty_carrid.
DATA : rt_carr TYPE TABLE OF rty_carrid.

TYPES : BEGIN OF rty_connid.
   TYPES : sign TYPE ddsign.
   TYPES : option TYPE ddoption.
   TYPES : low TYPE s_conn_id.
   TYPES : high TYPE s_conn_id.
TYPES : END OF rty_connid.

DATA : wa_conn TYPE rty_connid.
DATA : rt_conn TYPE TABLE OF rty_connid.


DATA : gt_air TYPE TABLE OF sairport,
       gs_air TYPE  sairport.


*--/ ALV obj
DATA : go_container  TYPE REF TO cl_gui_custom_container.
DATA : go_alv_grid     TYPE REF TO cl_gui_alv_grid,
       gs_stable       TYPE          lvc_s_stbl,
       gv_soft_refresh TYPE          abap_bool.


DATA : gv_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo.

DATA : gt_sort TYPE lvc_t_sort,
       gs_sort TYPE lvc_s_sort.

DATA : ls_col TYPE lvc_s_scol.
DATA : gt_exclude TYPE ui_functions.

DATA : gs_fcat TYPE lvc_s_fcat,
       gt_fcat TYPE lvc_t_fcat.

DATA : gs_ct TYPE lvc_s_styl.
*--.

INCLUDE zbc405_a06_exam01_answer_class.
*INCLUDE zsypalv002_class.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : s_car FOR ztspfli_a06-carrid MEMORY ID car,
                   s_con FOR ztspfli_a06-connid.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) TEXT-008.        " Choose layout
    PARAMETERS : pa_lv TYPE disvariant-variant.
    SELECTION-SCREEN COMMENT pos_high(10) TEXT-009. " Edit mode
    PARAMETERS : p_edit   AS CHECKBOX.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

PARAMETERS : p_screen AS CHECKBOX.

* ------------------------------------------------------------------------
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.

  gv_variant-report = sy-cprog.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'       " F4
    CHANGING
      cs_variant  = gv_variant.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_lv =  gv_variant-variant.          " variant 선택 시 return
  ENDIF.

* --------------------------------------------------------------------------
START-OF-SELECTION.

  SELECT * INTO TABLE gt_air FROM sairport.

  PERFORM get_data.

  IF p_screen = 'X'.
    CLEAR : ztspfli_a06.
    CALL SCREEN 100.
  ELSE.
    CALL SCREEN 200.
  ENDIF.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CLEAR : ok_code.

  IF p_edit = 'X'.
    SET PF-STATUS 'S100'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
  ENDIF.


  SET TITLEBAR 'T10'  WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

  DATA : gv_result .
  PERFORM ask_save USING TEXT-001 TEXT-002  " exit " do you want to exit?
                   CHANGING gv_result.
  IF gv_result = '1'. " yes
    CALL METHOD go_alv_grid->free.
    CALL METHOD go_container->free.
    FREE : go_alv_grid, go_container.

    LEAVE TO SCREEN 0.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJ OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_obj OUTPUT.

  IF go_container IS INITIAL.
    " container 생성
    CREATE OBJECT go_container
      EXPORTING
*       parent                      =
        container_name              = 'MY_CONTROL_AREA'
*       style                       =
*       lifetime                    = lifetime_default
*       repid                       =
*       dynnr                       =
*       no_autodef_progid_dynnr     =
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    " grid 생성
    CREATE OBJECT go_alv_grid
      EXPORTING
*       i_shellstyle      = 0
*       i_lifetime        =
        i_parent          = go_container
*       i_appl_events     = SPACE
*       i_parentdbg       =
*       i_applogparent    =
*       i_graphicsparent  =
*       i_name            =
*       i_fcat_complete   = SPACE
*       o_previous_sral_handler =
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    " alv option(grid option)
    PERFORM make_layout.             " set layout
*    PERFORM make_sort.              " set sort
    PERFORM make_exclude_fc.         " set exclude

    gv_variant-report = sy-cprog.    " set layout variant: 사용자 입력 layout 설정
    gv_variant-variant = pa_lv.

    PERFORM make_fieldcat_catalog.   " set field catalog



    CALL METHOD go_alv_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.


    " event trigger
    SET HANDLER : lcl_handler=>on_double_click FOR go_alv_grid,
                  lcl_handler=>on_toolbar      FOR go_alv_grid,
                  lcl_handler=>on_user_command FOR go_alv_grid.

    SET HANDLER lcl_handler=>on_DATA_CHANGED FOR go_alv_grid.


    CALL METHOD go_alv_grid->set_toolbar_interactive.
    CALL METHOD Go_alv_GRID->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.

    CALL METHOD cl_gui_control=>set_focus
      EXPORTING
        control = go_alv_grid.

    CALL METHOD cl_gui_cfw=>flush.


    " set alv(grid)
    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name              = 'ZTSPFLI_T03'   " 참조하고 있는 structure
        is_variant                    = gv_variant      " layout variant 설정
        i_save                        = 'A'             " A : alll X: defautl(global) u: user specific
        i_default                     = 'X'             " Q: default의 의미?
        is_layout                     = gs_layout       " layout 설정
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exclude      " excluding toolbar
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_tab          " 뿌려주는 table, 보여주는 table
        it_fieldcatalog               = gt_fcat         " field 추가
        it_sort                       = gt_sort         " sort
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


  ELSE.
    " 업데이트 된 부분만 refresh: 현재 작업중이던 화면 그대로 불러오기
    ON CHANGE OF gt_tab.

      gv_soft_refresh = 'X'.
      gs_stable-row = 'X'.
      gs_stable-col = 'X'.
      CALL METHOD go_alv_grid->refresh_table_display
        EXPORTING
          is_stable      = gs_stable        " Q: stable의 의미?
          i_soft_refresh = gv_soft_refresh
        EXCEPTIONS
          finished       = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
*     Implement suitable error handling here
      ENDIF.
*    CALL METHOD cl_gui_cfw=>flush.

    ENDON.



*  DATA :  l_scroll     TYPE lvc_s_stbl.
*  l_scroll-row = 'X'.
*  l_scroll-col = 'X'.
*
*  IF NOT g_grid IS INITIAL.
**    SORT GT_SI BY SERNO.
*    CALL METHOD g_grid->refresh_table_display
*      EXPORTING
*        i_soft_refresh = 'X'
*        is_stable      = l_scroll.     "í˜„ìž¬ ê·¸ëŒ€ë¡œ ìž…ë ¥í•œ refresh
*
*    CALL METHOD cl_gui_cfw=>flush.
*
*    CALL METHOD g_grid->set_selected_rows
*      EXPORTING
*        it_index_rows = lt_rows.
*
*
*  ENDIF.



  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_DATA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_data INPUT.



  CLEAR : rt_conn. REFRESH : rt_conn.
  CLEAR : rt_carr. REFRESH : rt_carr.
  IF ztspfli_a06-carrid IS NOT INITIAL.
    wa_carr-low = ztspfli_a06-carrid.
    wa_carr-option = 'EQ'.
    wa_carr-sign = 'I'.
    APPEND wa_carr TO rt_carr.
  ELSE.
    CLEAR : rt_carr. REFRESH : rt_carr.
  ENDIF.

  IF ztspfli_a06-connid IS NOT INITIAL.
    wa_conn-low = ztspfli_a06-connid.
    wa_conn-option = 'EQ'.
    wa_conn-sign = 'I'.
    APPEND wa_conn TO rt_conn.
  ELSE.
    CLEAR : rt_conn. REFRESH : rt_conn.
  ENDIF.




  SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_tab
                 FROM ZTSPFLI_t03
       WHERE carrid IN rt_carr AND
             connid IN rt_conn.


  PERFORM make_get_tab.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CREATE_DROPDOWN_BOX  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_dropdown_box INPUT.


  TYPES: BEGIN OF conn_line,
           conn TYPE spfli-connid,
         END OF conn_line.


  DATA conn_list TYPE STANDARD TABLE OF conn_line.


  SELECT connid
    FROM ZTSPFLI_a06
    INTO TABLE conn_list
    WHERE carrid = ztspfli_a06-carrid.


  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'  " f4 기능을 강제로 넣고 싶을 때
    EXPORTING
      retfield        = 'CONNID'
      value_org       = 'S'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZTSPFLI_T03-CONNID'    " 선택한 필드의 값이 입력될 화면의 필드
    TABLES
      value_tab       = conn_list
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.



ENDMODULE.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
  " 기본 설정
  gs_layout-grid_title = 'Flight Schedule Report'.
  gs_layout-zebra = 'X'.
*  gs_layout-cwidth_opt = 'X'.     " width option
  gs_layout-sel_mode = 'D'.       " A:  m-row m-col  B: M-col S-row, C, D
*    gs_layout-no_headers = 'X'.   " header 제거
*    gs_layout-no_toolbar = 'X'.   " toolbar 제거

  " light 설정
  gs_layout-excp_fname = 'LIGHTS'.  " Field name with exception coding
  gs_layout-excp_led = 'X'.         " 신호등 1개짜리

  " color 설정
*  gs_layout-info_fname = 'COL_ROW'. " Field name with simple row color coding
  gs_layout-ctab_fname = 'IT_COL'.  " Field name with complex cell color coding
*  gs_layout-stylefname = 'CT'.      " Field name of internal table field

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcat_catalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcat_catalog .
  " I&D field 추가 및 설정: 순서 설정, 최적화 설정
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'ID_IND'.
  gs_fcat-tooltip = 'Domestic/International'.
  gs_fcat-coltext = 'I&D'.
  gs_fcat-col_opt = 'X'.                      " Entry for Optional Column Optimization
  gs_fcat-col_pos = 5.
  APPEND gs_fcat TO gt_fcat.

  " Flight time field 설정: edit mode 설정
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLTIME'.
  gs_fcat-edit = p_edit.     "'X'.
  gs_fcat-tooltip = '분단위입력가능합니다'.
  APPEND gs_fcat TO gt_fcat.

  " Departure time field 설정: edit mode 설정
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'DEPTIME'.
  gs_fcat-edit = p_edit.    "'X'.
  APPEND gs_fcat TO gt_fcat.

  " Arrival time field 설정: 강조 및 색 변경
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'ARRTIME'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.

  " Days field 설정: 강조 및 색 변경
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PERIOD'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.

  " Charter flt field 설정: 숨기기
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLTYPE'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  " FLIGHT field 추가 및 설정: icon field로 변경, 순서 설정
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLTYPE_ICON'.
  gs_fcat-icon = 'X'.               " Output as icon
  gs_fcat-coltext = 'FLIGHT'.       " Column heading
  gs_fcat-col_pos =  9.
  APPEND gs_fcat TO gt_fcat.

  " From TZone field 추가 및 설정: 참조 테이블, 순서 설정
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'TIMEZONEFR'.
  gs_fcat-ref_field = 'TIME_ZONE'.
  gs_fcat-ref_table = 'SAIRPORT'.           " Reference Table Name for Internal Table Field
  gs_fcat-coltext  = 'From TZONE'.
  gs_fcat-col_pos = 18.
  APPEND gs_fcat TO gt_fcat.

  " To TZone field 추가 및 설정: 참조 테이블, 순서 설정
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'TIMEZONETO'.
  gs_fcat-ref_field = 'TIME_ZONE'.
  gs_fcat-ref_table = 'SAIRPORT'.           " Reference Table Name for Internal Table Field
  gs_fcat-coltext = 'To TZONE'.
  gs_fcat-col_pos = 19.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_exclude_fc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_exclude_fc .

*  APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exclude.
*  APPEND cl_gui_alv_grid=>mc_mb_sum    TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_info   TO gt_exclude.


  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row   TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy   TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row   TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut   TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row   TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row   TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_move_row  TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste  TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row  TO gt_exclude.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FLTIME_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM FLTIME_change_part USING rr_data_changed TYPE REF TO cl_alv_changed_data_protocol
                              rs_mod_cells TYPE lvc_s_modi.

  DATA : l_fltime TYPE s_fltime.
  DATA : l_deptime TYPE s_dep_time.

  DATA : ev_arrtime TYPE s_arr_time.
  DATA : ev_period TYPE n.

  READ TABLE gt_tab INTO ls_tab  INDEX rs_mod_cells-row_id.

  CALL METHOD rr_data_changed->get_cell_value
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'FLTIME'
    IMPORTING
      e_value     = l_fltime.

  CHECK sy-subrc EQ 0.

  CALL METHOD rr_data_changed->get_cell_value
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'DEPTIME'
    IMPORTING
      e_value     = l_deptime.

  CHECK sy-subrc EQ 0.


  CALL FUNCTION 'ZBC405_CALC_ARRTIME'
    EXPORTING
      iv_fltime       = l_fltime
      iv_deptime      = l_deptime
      iv_utc          = ls_tab-timezonefr
      iv_utc1         = ls_tab-timezoneto
    IMPORTING
      ev_arrival_time = ev_arrtime
      ev_period       = ev_period.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'ARRTIME'
      i_value     = ev_arrtime.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'PERIOD'
      i_value     = ev_period.

  ls_tab-period  = ev_period.
  ls_Tab-arrtime = ev_arrtime.


  IF ls_tab-period >= 2.
    ls_tab-lights = '1'.     "red
  ELSEIF ls_tab-period = 1.
    ls_tab-lights  = '2'.   "yellow
  ELSE.
    ls_tab-lights  = '3'.   "green
  ENDIF.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'LIGHTS'
      i_value     = ls_tab-lights.


*  lw_tab-carrid = ls_tab-carrid.
*  lw_tab-connid = ls_tab-connid.
*
*  APPEND lw_tab TO st_tab.

  ls_tab-chg = 'X'.              "변경확인
  MODIFY gt_tab FROM ls_tab INDEX rs_mod_cells-row_id.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_tab
    FROM ZTSPFLI_a06
    WHERE carrid IN s_car AND
          connid IN s_con.

  PERFORM make_get_tab.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_get_tab
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_get_tab .

  LOOP AT gt_tab INTO ls_tab.

    " exception handling field data 연결: period에 따라 light 설정
    IF ls_tab-period >= 2.
      ls_tab-lights = '1'.    " red
    ELSEIF ls_tab-period = 1.
      ls_tab-lights  = '2'.   " yellow
    ELSE.
      ls_tab-lights  = '3'.   " green
    ENDIF.

    " I&D field data 연결: international / domestic
    IF ls_tab-countryfr = ls_tab-countryto.
      ls_tab-id_ind = 'D'.    "domestic
    ELSE.
      ls_tab-id_ind = 'I'.     "international.
    ENDIF.

    " I&D field cell color data 연결: D = yellow, I = green
    IF ls_tab-id_ind  = 'D'.
      ls_col-fname = 'ID_IND'.
      ls_col-color-col = col_TOTAL.
      ls_col-color-int = '1'.
      ls_col-color-inv = 0.
      APPEND ls_col TO ls_tab-it_col.
    ENDIF.

    IF ls_tab-id_ind  = 'I'.
      ls_col-fname = 'ID_IND'.
      ls_col-color-col = col_positive.
      ls_col-color-int = '1'.
      ls_col-color-inv = 0.
      APPEND ls_col TO ls_tab-it_col.
    ENDIF.

    " FLIGHT field data 연결: 전세기에만 icon 표시
    IF ls_tab-fltype = 'X'. " 전세기
      ls_tab-fltype_icon  = icon_ws_plane.
    ENDIF.

    " TZone field data 연결: SAIRPOT table에서 AIRFROM field의 time zone 조회
    " From TZone
    READ TABLE gt_air INTO gs_air WITH KEY id = ls_tab-airpfrom.

    IF sy-subrc EQ 0.
      ls_tab-timezonefr = gs_air-time_zone.
    ENDIF.

    " To TZone
    READ TABLE gt_air INTO gs_air WITH KEY id = ls_tab-airpto.

    IF sy-subrc EQ 0.
      ls_tab-timezoneto = gs_air-time_zone.
    ENDIF.


    MODIFY gt_tab FROM ls_tab.

  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.


  DATA : g_result .


  CASE ok_code.
    WHEN 'SAVE'.

      PERFORM ask_save USING TEXT-003 TEXT-004
                CHANGING g_result.
      IF g_result = '1'.
        PERFORM data_save.
      ENDIF.




  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form ask_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> TEXT_003
*&      --> TEXT_004
*&      <-- G_RESULT
*&---------------------------------------------------------------------*
FORM ask_save USING pv_text1 pv_text2
              CHANGING cv_result TYPE c.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar      = pv_text1
      text_question = pv_text2
    IMPORTING
      answer        = cv_result.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .

  LOOP AT gt_tab INTO ls_tab WHERE chg = 'X'.

    UPDATE ztspfli_a06 SET fltime = ls_tab-fltime
                           deptime = ls_tab-deptime
                           arrtime = ls_tab-arrtime
                           period  = ls_tab-period
                     WHERE carrid = ls_tab-carrid
                       AND connid = ls_tab-connid.

  ENDLOOP.



ENDFORM.
