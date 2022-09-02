*&---------------------------------------------------------------------*
*& Report ZBC405_A06_ALV4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_alv4.

* 1. resource 선언
* 1-1. type 선언
TABLES ztsflight_a06.

TYPES: BEGIN OF type_flight.
      INCLUDE TYPE ztsflight_a06.
TYPES: END OF type_flight.

* 1-2. internal table, structure 선언
DATA: gt_flight TYPE TABLE OF type_flight,
      gs_flight TYPE type_flight.

* 3-1-1. ok_code 선언
DATA ok_code TYPE sy-ucomm. " screen > element list에도 선언 필요

* 2. selection screen(1000) 구성
* 2-1. 사용자 입력값 설정(select-options / parameters)
* 2-1-1. memory id, text element(dic ref) 설정
SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car,
                so_con FOR gs_flight-connid MEMORY ID con,
                so_date FOR gs_flight-fldate.

* 3-6. container 얹기
* 3-6-1-1. container 생성
DATA go_container TYPE REF TO cl_gui_custom_container.

* 3-7. grid 얹기
* 3-7-1-1. grid 생성
DATA go_alv_grid TYPE REF TO cl_gui_alv_grid.

* -----------------------------------------------------------------------
START-OF-SELECTION. " Main
* 3. alv 만들기
* 3-1. screen(100) 생성 : create > screen
* 3-1-1. screen > element list에 ok_code 선언

* 3-4. table data 설정: 데이터를 먼저 담고 스크린 불러오기
PERFORM get_data.

* 3-3. layout 설정
* 3-3-1. custom control 설정
* 3-3-2. call screen 호출
CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&  3-2. status 설정
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
* 3-2-1. pf-status 설정
* 3-2-1-1. application toolbar 설정
* 3-2-1-2. function key 설정: functional type e
* 3-2-1-4. excluding: mode/user에 따라 toolbar 숨기기 여부 설정
 SET PF-STATUS 'S100'.
* 3-2-2. titlebar 설정
 SET TITLEBAR 'T100' WITH sy-datum sy-uname.  " flight alv report &1 &2 &3
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text 3-2-1-3. user_command에 exit 설정
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
  WHEN 'EXIT'.
    LEAVE PROGRAM.
  WHEN 'CANCEL'.
    LEAVE TO SCREEN 0.
  ENDCASE.
  " 프로그램 종료 시 call & free

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
* 3-4-1. 사용자 입력 조건에 맞는 데이터 가져오기
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_flight
    FROM ztsflight_a06
    WHERE carrid IN so_car AND
          connid IN so_con AND
          fldate IN so_date.
ENDFORM.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
  IF go_container IS INITIAL.
*   3-5-1. 처음 화면 생성 시
*   3-6-2. container object 생성
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

*   3-7-2. grid object 생성
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

*   3-7-3. Set table for first display
    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*        i_buffer_active               =
*        i_bypassing_buffer            =
*        i_consistency_check           =
        i_structure_name              = 'SFLIGHT'     " 참조하고 있는 structure
*        is_variant                    = gv_variant
*        i_save                        = gv_save
        i_default                     = 'X'
*        is_layout                     = gs_layout
*        is_print                      =
*        it_special_groups             =
*        it_toolbar_excluding          =
*        it_hyperlink                  =
*        it_alv_graphics               =
*        it_except_qinfo               =
*        ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_flight      " 뿌려주는 table, 보여주는 table
*        it_fieldcatalog               = gt_fcat       " field 추가 가능
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
*   3-5-2. 그 이후엔 업데이트 된 부분만 refresh
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
