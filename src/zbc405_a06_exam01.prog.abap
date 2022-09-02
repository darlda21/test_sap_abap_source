*&---------------------------------------------------------------------*
*& Report ZBC405_A06_EXAM01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_exam01.

TABLES ztspfli_a06.

" for fields
TYPES: BEGIN OF type_spfli.
      INCLUDE TYPE ztspfli_a06.
      TYPES: light TYPE c LENGTH 1.               " exception handling
      TYPES: ind TYPE c LENGTH 1.                 " I: International, D: Domestic
      TYPES: fltype_icon TYPE icon-id.            " fltype field by icon
      TYPES: tzone_from TYPE sairport-time_zone.  " airfrom 필드에 해당하는 time_zone
      TYPES: tzone_to TYPE sairport-time_zone.    " airto 필드에 해당하는 time_zone

      TYPES: it_color TYPE lvc_t_scol.            " Table for cell coloring

      TYPES: modified TYPE c LENGTH 1.            " is modified
TYPES: END OF type_spfli.

" for table
DATA: gt_spfli TYPE TABLE OF type_spfli,
      gs_spfli TYPE type_spfli.

DATA: gs_sairport TYPE sairport,
      gt_sairport LIKE TABLE OF gs_sairport.

DATA ok_code TYPE sy-ucomm.
DATA p_answer TYPE c LENGTH 1.

* 2. selection screen(1000) 구성
SELECTION-SCREEN BEGIN OF BLOCK condition WITH FRAME TITLE TEXT-00a.
  SELECT-OPTIONS: so_car FOR gs_spfli-carrid MEMORY ID car,
                  so_con FOR gs_spfli-connid MEMORY ID con.
SELECTION-SCREEN END OF BLOCK condition.

SELECTION-SCREEN BEGIN OF BLOCK mode WITH FRAME.
 SELECTION-SCREEN BEGIN OF LINE.
   SELECTION-SCREEN COMMENT 1(31) TEXT-00b.          " Choose layout
   PARAMETERS pa_layo TYPE disvariant-variant.
   SELECTION-SCREEN COMMENT pos_high(10) TEXT-00c.   " Edit mode
   PARAMETERS pa_edit AS CHECKBOX.
 SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK mode.

" for alv
DATA go_container TYPE REF TO cl_gui_custom_container.
DATA go_alv_grid TYPE REF TO cl_gui_alv_grid.

" for alv option(grid option)
DATA: gs_variant TYPE disvariant,         " layout variant
      gs_layout TYPE lvc_s_layo,          " layout
      gt_fcat TYPE lvc_t_fcat,            " field catagory table
      gs_fcat TYPE lvc_s_fcat,            " field category structure
      gs_color TYPE lvc_s_scol,           " cell color를 담아두는 임시공간
      gt_exct TYPE ui_functions.         " excluding toolbars

" for class
INCLUDE zbc405_a06_alv_exam01_class.

* -----------------------------------------------------------------------
" layout variant 설정
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_layo.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'       "F: F4
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_layo  =  gs_variant-variant.  " variant 선택 시 return
  ENDIF.

* -----------------------------------------------------------------------
INITIALIZATION.
  gs_variant-report = sy-cprog.     " 현재 프로그램

* -----------------------------------------------------------------------
START-OF-SELECTION. " Main

PERFORM get_data.

CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&  3-2. status 설정
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
* 3-2-1-2. function key 설정: functional type e
* 3-2-1-4. excluding: mode/user에 따라 toolbar 숨기기 여부 설정
 IF pa_edit = 'X'.
   SET PF-STATUS 'S100'.
 ELSE.
   SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
 ENDIF.
 SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
  WHEN 'BACK'.
    PERFORM free_alv.
    LEAVE TO SCREEN 0.
  WHEN 'SAVE'.
    CLEAR p_answer.

    " databas 접근 및 저장 전 한 번 더 확인하는 로직
    CALL FUNCTION 'POPUP_TO_CONFIRM'  " popup 시 yes면 다음 로직으로 갈 수 있는 function module
      EXPORTING
       titlebar                    = 'Data Save'
*       DIAGNOSE_OBJECT             = ' '
        text_question               = 'Do you want to save?'
       text_button_1               = 'Yes'(001) " yes
*       ICON_BUTTON_1               = ' '
       text_button_2               = 'No'(002) " cancel
*       ICON_BUTTON_2               = ' '
*       DEFAULT_BUTTON              = '1'  " yes
       display_cancel_button       = ' '
*       USERDEFINED_F1_HELP         = ' '
*       START_COLUMN                = 25
*       START_ROW                   = 6
*       POPUP_TYPE                  =
*       IV_QUICKINFO_BUTTON_1       = ' '
*       IV_QUICKINFO_BUTTON_2       = ' '
     IMPORTING " yes/no를 눌렀는지 결과 알려주는 것
       answer                      = p_answer
*     TABLES
*       PARAMETER                   =
     EXCEPTIONS
       text_not_found              = 1
       OTHERS                      = 2
              .
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ELSE.
      IF p_answer = '1'.  "yes
        PERFORM data_save.
      ENDIF.
    ENDIF.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text 3-2-1-3. user_command에 exit 설정
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
  WHEN 'EXIT'.
    CLEAR p_answer.

    " databas 접근 및 저장 전 한 번 더 확인하는 로직
    CALL FUNCTION 'POPUP_TO_CONFIRM'  " popup 시 yes면 다음 로직으로 갈 수 있는 function module
      EXPORTING
       titlebar                    = 'ALV exit'
*       DIAGNOSE_OBJECT             = ' '
        text_question               = 'Do you want to exit?'
       text_button_1               = 'Yes'(001) " yes
*       ICON_BUTTON_1               = ' '
       text_button_2               = 'No'(002) " cancel
*       ICON_BUTTON_2               = ' '
*       DEFAULT_BUTTON              = '1'  " yes
       display_cancel_button       = ' '
*       USERDEFINED_F1_HELP         = ' '
*       START_COLUMN                = 25
*       START_ROW                   = 6
*       POPUP_TYPE                  =
*       IV_QUICKINFO_BUTTON_1       = ' '
*       IV_QUICKINFO_BUTTON_2       = ' '
     IMPORTING " yes/no를 눌렀는지 결과 알려주는 것
       answer                      = p_answer
*     TABLES
*       PARAMETER                   =
     EXCEPTIONS
       text_not_found              = 1
       OTHERS                      = 2
              .
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ELSE.
      IF p_answer = '1'.  "yes
        PERFORM free_alv.
        LEAVE PROGRAM.
      ENDIF.
    ENDIF.
  WHEN 'CANCEL'.
    PERFORM free_alv.
    LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text 조건에 맞는 데이터 가져오기
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  " 사용자 입력 조건 조회 data
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_spfli
    FROM ztspfli_a06
    WHERE carrid IN so_car AND
          connid IN so_con.

  SELECT *
       FROM sairport
       INTO CORRESPONDING FIELDS OF TABLE gt_sairport.

   LOOP AT gt_spfli INTO gs_spfli.
     " exception handling field data 연결: period에 따라 light 설정
     IF gs_spfli-period >= 2.
       gs_spfli-light = 1. " red
     ELSEIF gs_spfli-period = 1.
       gs_spfli-light = 2.  " yellow
     ELSEIF gs_spfli-period = 0.
       gs_spfli-light = 3.  " green
     ENDIF.

     " I&D field data 연결: International / Domestic
     " I&D field cell color data 연결: D=yellow, I=green
     IF gs_spfli-countryfr = gs_spfli-countryto.
       gs_spfli-ind = 'D'.

       gs_color-fname = 'IND'.
       gs_color-color-col = col_total.
       APPEND gs_color TO gs_spfli-it_color.
     ELSE.
       gs_spfli-ind = 'I'.

       gs_color-fname = 'IND'.
       gs_color-color-col = col_positive.
       APPEND gs_color TO gs_spfli-it_color.
     ENDIF.

     " FLIGHT field data 연결: 전세기에만 icon 표시
     IF gs_spfli-fltype = 'X'.
       " 전세기
       gs_spfli-fltype_icon = icon_flight.
     ELSE.
       gs_spfli-fltype_icon = icon_space.
     ENDIF.

     " Arrival Time field cell color data 연결: 강조 및 색 변경
     " Days field cell color data 연결: 강조 및 색 변경
     gs_color-fname = 'ARRTIME'.
     gs_color-color-col = col_group.
     gs_color-color-int = '1'.
     gs_color-color-inv = '0'.
     APPEND gs_color TO gs_spfli-it_color.

     gs_color-fname = 'PERIOD'.
     gs_color-color-col = col_group.
     gs_color-color-int = '1'.
     gs_color-color-inv = '0'.
     APPEND gs_color TO gs_spfli-it_color.

     " tzone data 연결
     CLEAR gs_sairport.
     READ TABLE gt_sairport INTO gs_sairport WITH KEY id = gs_spfli-airpfrom.
     gs_spfli-tzone_from = gs_sairport-time_zone.

     CLEAR gs_sairport.
     READ TABLE gt_sairport INTO gs_sairport WITH KEY id = gs_spfli-airpto.
     gs_spfli-tzone_to = gs_sairport-time_zone.

     " 한 개의 row data 모든 변경사항 반영
     MODIFY gt_spfli FROM gs_spfli.
   ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
  IF go_container IS INITIAL.
*    container 생성
    CREATE OBJECT go_container
     EXPORTING
*       parent                      =
       container_name              = 'MY_CONTROL_AREA'     " 얹어지는 곳
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
       OTHERS                      = 6
       .
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*    grid 생성
    CREATE OBJECT go_alv_grid
      EXPORTING
*        i_shellstyle      = 0
*        i_lifetime        =
        i_parent          = go_container  " 얹어지는 곳
*        i_appl_events     = SPACE
*        i_parentdbg       =
*        i_applogparent    =
*        i_graphicsparent  =
*        i_name            =
*        i_fcat_complete   = SPACE
*        o_previous_sral_handler =
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5
        .
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    " alv option(grid option)
    PERFORM set_variant.
    PERFORM set_layout.
    PERFORM set_fieldcatalog.

    " edit event 시 변경되는 순간 값이 반영
    CALL METHOD go_alv_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.    " 변경되는 순간(enter) 반영
*---                                "mc_evt_enter

    " hiding application toolbar: edit mode일 경우
    IF pa_edit = 'X'.
      APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_mb_paste TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO gt_exct.

      APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.
    ENDIF.

    " e. event trigger
    SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.

*    set alv
    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*        i_buffer_active               =
*        i_bypassing_buffer            =
*        i_consistency_check           =
        i_structure_name              = 'ZTSPFLI_A06'     " 참조하고 있는 structure
        is_variant                    = gs_variant        " layout variant 설정
        i_save                        = 'A'
        i_default                     = 'X'
        is_layout                     = gs_layout         " layout 설정
*        is_print                      =
*        it_special_groups             =
        it_toolbar_excluding          = gt_exct           " excluding toolbar
*        it_hyperlink                  =
*        it_alv_graphics               =
*        it_except_qinfo               =
*        ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_spfli          " 뿌려주는 table, 보여주는 table
        it_fieldcatalog               = gt_fcat           " field 추가 가능
*        it_sort                       = gt_sort
*        it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4
            .
    IF sy-subrc <> 0.
*     Implement suitable error handling here.
    ENDIF.
  ELSE.
*   업데이트 된 부분만 refresh: 현재 작업중이던 화면 그대로 불러오기
    DATA: gs_stable TYPE lvc_s_stbl,      " low, coloumn
          gv_soft_refresh TYPE abap_bool.

    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
    CALL METHOD go_alv_grid->refresh_table_display
        EXPORTING
          is_stable      = gs_stable
          i_soft_refresh = gv_soft_refresh
        EXCEPTIONS
          finished       = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.
*      CALL METHOD cl_gui_cfw=>flush.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text f4 기능을 사용하지 않고 사용자가 직접 variant layout 입력 시 pa값 저장
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .
  gs_variant-variant = pa_layo.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  " 기본 설정
  gs_layout-sel_mode = 'D'.               " selection mode: all
  gs_layout-zebra = 'X'.                  " row pattern: zebra

  " light 설정
  gs_layout-excp_fname = 'LIGHT'.         " light field 설정. 설정 안해도 col_pos=1
  gs_layout-excp_led = 'X'.               " 신호등 1개짜리

  " color 설정
*  gs_layout-info_fname = 'IND'.           " line color field 설정
*  gs_layout-info_fname = 'IND'.           " column color field 설정
  gs_layout-ctab_fname = 'IT_COLOR'.      " cell color field 설정
*  gs_layout-stylefname = 'EQ'.            " cell style field 설정
ENDFORM.
*&---------------------------------------------------------------------*
*& Form free_alv
*&---------------------------------------------------------------------*
*& text 프로그램 종료 후 m 확보
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_alv .
  CALL METHOD go_alv_grid->free.
  CALL METHOD go_container->free.
  FREE: go_alv_grid, go_container.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fieldcatalog .
  " light field 추가
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Exception Handling'.
  APPEND gs_fcat TO gt_fcat.

  " I&D field 추가
  CLEAR:gs_fcat.
  gs_fcat-fieldname = 'IND'.
  gs_fcat-coltext = 'I&D'.
  gs_fcat-col_pos = 5.
  APPEND gs_fcat TO gt_fcat.

  " FLIGHT field 추가
  CLEAR:gs_fcat.
  gs_fcat-fieldname = 'FLTYPE_ICON'.
  gs_fcat-coltext = 'FLIGHT'.
  gs_fcat-col_pos = 9.
  APPEND gs_fcat TO gt_fcat.

  " From TZone field 추가
  CLEAR:gs_fcat.
  gs_fcat-fieldname = 'TZONE_FROM'.
  gs_fcat-coltext = 'From TZone'.
  gs_fcat-ref_table = 'SAIRPORT'.
  gs_fcat-ref_field = 'TIME_ZONE'.
  gs_fcat-col_pos = 17.
  APPEND gs_fcat TO gt_fcat.

  " To TZone field 추가
  CLEAR:gs_fcat.
  gs_fcat-fieldname = 'TZONE_TO'.
  gs_fcat-coltext = 'To TZone'.
  gs_fcat-ref_table = 'SAIRPORT'.
  gs_fcat-ref_field = 'TIME_ZONE'.
  gs_fcat-col_pos = 18.
  APPEND gs_fcat TO gt_fcat.

  " Charter flt field 숨기기
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLTYPE'.
  gs_fcat-no_out = 'X'.       " 화면에서 사라짐, 사전에 담겨져있음
*  gs_fcat-edit = 'X'.        " 편집모드(입력창)로 바뀜
  APPEND gs_fcat TO gt_fcat.

  " Flight Time field edit mode로 바꾸기
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'FLTIME'.
  gs_fcat-edit     = pa_edit.    " 'X'.
  APPEND gs_fcat TO gt_fcat.

  " Departure Time field edit mode로 바꾸기
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'DEPTIME'.
  gs_fcat-edit     = pa_edit.    " 'X'.
  APPEND gs_fcat TO gt_fcat.
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
  LOOP AT gt_spfli INTO gs_spfli WHERE modified = 'X'.
    UPDATE ztspfli_a06
      SET fltime = gs_spfli-fltime
          arrtime = gs_spfli-arrtime
          period = gs_spfli-period
      WHERE carrid = gs_spfli-carrid AND
            connid = gs_spfli-connid.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM modify_check  USING    p_mod_cells TYPE lvc_s_modi.
  READ TABLE gt_spfli INTO gs_spfli INDEX p_mod_cells-row_id.
  IF sy-subrc EQ 0.
    gs_spfli-modified = 'X'.

    MODIFY gt_spfli FROM gs_spfli INDEX p_mod_cells-row_id.
  ENDIF.
ENDFORM.
