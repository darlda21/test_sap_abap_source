*&---------------------------------------------------------------------*
*& Report ZBC405_A06_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_alv2.

" light가 추가된 type 생성 및 type 변경(조직)
TYPES: BEGIN OF typ_flt.
        INCLUDE TYPE sflight.           " 단독으로 types 없이 쓴다. 하나의 문장
        TYPES: light TYPE c LENGTH 1.  " 신호등 구조 추가
*        TYPES: btn_text type c LENGTH 10.
        TYPES: row_color TYPE c LENGTH 4. " row별 색상 구조 추가
        TYPES: it_color TYPE lvc_t_scol.    " cell별 색상 구조 추가(table type)
        TYPES: changes_possible TYPE icon-id. " icon type. 추가하지 않으면 안보임
        TYPES: btn_text TYPE c LENGTH 10.
        TYPES: it_styl TYPE lvc_t_styl.     " cell style
TYPES: END OF typ_flt.

DATA: gt_flight TYPE TABLE OF typ_flt,  " internal table
      gs_flight TYPE typ_flt,           " work area
      ok_code LIKE sy-ucomm.

" 4. container를 얹는다
" 4-1. container 생성
DATA: go_container TYPE REF TO cl_gui_custom_container. " ref to + class type

" 5. grid를 얹는다(alv)
" 5-1. grid 생성
DATA: go_alv_grid TYPE REF TO cl_gui_alv_grid.

" grid option
DATA: gv_variant TYPE disvariant,
      gv_save TYPE c LENGTH 1,
      gs_layout TYPE lvc_s_layo,
      gt_sort TYPE lvc_t_sort,  " internal table
      gs_sort TYPE lvc_s_sort,  " 쌍으로 움직인다
      gs_color TYPE lvc_s_scol, " cell color을 넣어주는 중간다리 역할의 work area
      gt_exct TYPE ui_functions, "TOOLBAR EXCLUDING
      gt_fcat TYPE lvc_t_fcat,  " field catalog
      gs_fcat TYPE lvc_s_fcat,  " field catalog
      gs_styl TYPE lvc_s_styl.  " button style

" refresh
DATA: gs_stable TYPE lvc_s_stbl,      " column, row값 이 들어있음
      gv_soft_refresh TYPE abap_bool. " boolean: 'X' or ''


" 00. class 생성(global 변수를 사용해야 하므로 위치 중요) 및 local로 가져오기
INCLUDE ZBC405_A06_ALV2_class.

* Selection Screen
SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car,
                so_con FOR gs_flight-connid MEMORY ID con,
                so_dat FOR gs_flight-fldate.

" variant input field
SELECTION-SCREEN SKIP 1.
PARAMETERS: p_date TYPE sy-datum DEFAULT '20211001'.  " changes_possible 조작을 위한 param
PARAMETERS pa_lv TYPE disvariant-variant.

" value request(f4: possible entry), function module 이용: f4 기능을 사용 시에만 실행
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.

  gv_variant-report = sy-cprog.           " event라 부를 때만 들어가기 때문에 다시 assign

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
   EXPORTING
     i_save_load                 = 'F'    " s: f: possible l:
    CHANGING
      cs_variant                  = gv_variant
   EXCEPTIONS
     not_found                   = 1
     wrong_input                 = 2
     fc_not_complete             = 3
     OTHERS                      = 4
            .
   IF sy-subrc <> 0.              " variant가 없으면 그냥 실행
*  Implement suitable error handling here
   ELSE.
     pa_lv = gv_variant-report.   " variant 선택 시 return
   ENDIF.



START-OF-SELECTION. " Main
  " 1. Data를 읽어 internal table에 삽입
  PERFORM get_data.   " data handling


  " 2. 결과가 출력될 screen 생성 및 호출
  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100' WITH sy-datum sy-uname.    " &1 &2 &3에 dynamic title 설정
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.

      " 프로그램이 종료되면 어차피 method가 삭제되지만 m확보를 위해 call, free를 원칙으로 한다.
      " junk m이 떠돌아다님을 방지
      " 내가 만든 release되면 새로운 method가 생긴다(없어진다).
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.
      FREE: go_alv_grid, go_container.

      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.

" 3. custom container 지정(screen area)

*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.
  " 4-3. container를 참조하는 instance object 만들기
    " 4-3-1. class/interface에서 drag n drop
    " 4-3-2. pattern 이용
  IF go_container IS INITIAL.     " 화면 생성 시 한번만 만들어준다.

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

    " 5-3. grid를 참조하는 instance object 만들기
      " 5-3-1. class/interface에서 drag n drop
      " 5-3-2. pattern 이용
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


    " 6. method 생성 및 뿌리기

    " lvc option
    PERFORM make_variant.
    PERFORM make_layout.
    PERFORM make_sort.
    PERFORM make_fieldcatalog.

    " exclude
    APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct. " => : attribute를 class에서 직접 참조
    APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.   " class => attributes

*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exct.  " 전체 toolbar 제거

    " 33. event trigger
    SET HANDLER lcl_handler=>on_doubleclick FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_hotspot FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_button_click FOR go_alv_grid.

    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*        i_buffer_active               =
*        i_bypassing_buffer            =
*        i_consistency_check           =
        i_structure_name              = 'SFLIGHT'   " 참조하고 있는 structure
        is_variant                    = gv_variant
        i_save                        = gv_save
        i_default                     = 'X'
        is_layout                     = gs_layout
*        is_print                      =
*        it_special_groups             =
*        it_toolbar_excluding          =
*        it_hyperlink                  =
*        it_alv_graphics               =
*        it_except_qinfo               =
*        ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_flight      " 뿌려주는 table, 보여주는 table
        it_fieldcatalog               = gt_fcat               " field 추가 가능
        it_sort                       = gt_sort
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
    " refresh
    " pattern 불러와서 사용
    " on change of gt_flt.
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.

    CALL METHOD go_alv_grid->refresh_table_display
      EXPORTING
        is_stable      =  gs_stable
        i_soft_refresh =  gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2
            .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.


  ENDIF.

ENDMODULE.
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
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flight  " gt_flight에 field가 추가되면서 일치하지 않으므로 corresponding 추가
    WHERE carrid IN so_car
      AND connid IN so_con
      AND fldate IN so_dat.

  LOOP AT gt_flight INTO gs_flight.
    IF gs_flight-seatsocc < 5.
      gs_flight-light = 1.   "red
    ELSEIF gs_flight-seatsocc < 100.
      gs_flight-light = 2.   "yellow
    ELSE.
      gs_flight-light = 2.   "green
    ENDIF.

   " 뭐가 같으면 색깔을 준다(row)
   IF gs_flight-fldate+4(2) = sy-datum+4(2).  "월 = 월
     gs_flight-row_color = 'C311'.  "c:color, 3:color, 1:intensified, 1:inverse
   ENDIF.

   " 뭐가 해당하면 색깔을 준다(cell)
   IF gs_flight-planetype = '747-400'.
     gs_color-fname = 'PLANETYPE'.
     gs_color-color-col = col_total.
     gs_color-color-int = '1'.
     gs_color-color-inv = '0'.
     APPEND gs_color TO gs_flight-it_color.
   ENDIF.

   IF gs_flight-seatsmax_b = 0.
     gs_color-fname = 'SEATSMAX_B'.
     gs_color-color-col = col_negative.
     gs_color-color-int = '1'.
     gs_color-color-inv = '0'.
     APPEND gs_color TO gs_flight-it_color.
   ENDIF.

   " 뭐하면 아이콘을 보여준다.
   IF gs_flight-fldate < p_date.
     gs_flight-changes_possible = icon_space.
   ELSE.
     gs_flight-changes_possible = icon_okay.
   ENDIF.

   " 뭐랑 뭐가 같으면 버튼을 보여준다.
   IF gs_flight-seatsmax_b = gs_flight-seatsocc_b.
     gs_flight-btn_text = 'FullSeats!'.

     gs_styl-fieldname = 'BTN_TEXT'.
     gs_styl-style = cl_gui_alv_grid=>mc_style_button.
     APPEND gs_styl TO gs_flight-it_styl.

   ENDIF.

   MODIFY gt_flight FROM gs_flight.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .
  gv_variant-report = sy-cprog.
  gv_save = 'U'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'. " 'x' = checked, field cat-opt 역할
  gs_layout-sel_mode = 'D'.   " A: multiple row and cell, B, C, D: A + 일부 cell 선택, space

  gs_layout-excp_fname = 'LIGHT'.       " light field name 설정
  gs_layout-excp_led = 'X'.   " 신호등 1개짜리

  gs_layout-info_fname = 'ROW_COLOR'.   " line color field name 설정
  gs_layout-ctab_fname = 'IT_COLOR'.            " cell color field name 설정

  gs_layout-stylefname = 'IT_STYL'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .
  CLEAR gs_sort.        " 같은 work area 사용시 값이 중복되지 않도록 clear
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.     " ascending
  gs_sort-spos = 1.     " sort 순서
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 2.     " sort 순서
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.   " descending
  gs_sort-spos = 3.     " sort 순서

  APPEND gs_sort TO gt_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .
  " btㅜ_text 필드에 ?
  CLEAR:gs_fcat.
  gs_fcat-fieldname = 'BTN_TEXT'.
  gs_fcat-coltext = 'Status'.
  gs_fcat-col_pos = 10.
  APPEND gs_fcat TO gt_fcat.

  " carrid 필드에 hotspot 설정
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
*  gs_fcat-hotspot = 'X'.    " 수정 carrid 필드에 밑줄+손모양의 레이아웃(모양) 설정
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'. " 수정 : light to info
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PRICE'.
  gs_fcat-no_out = 'X'.     " 수정: 화면에서 사라짐, 사전에 담겨져있음
*  gs_fcat-edit = 'X'.        " 편집모드(입력창)로 바뀜
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CHANGES_POSSIBLE'.
  gs_fcat-coltext = 'Chang.Poss'. " 수정 : 아이콘을 보이게
  gs_fcat-col_pos = 5.             " 5번째에 보이게
  APPEND gs_fcat TO gt_fcat.
ENDFORM.
