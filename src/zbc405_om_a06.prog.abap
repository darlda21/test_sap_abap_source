*&---------------------------------------------------------------------*
*& Report ZBC405_OM_A06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_om_a06.

TABLES spfli.

SELECT-OPTIONS: so_car FOR spfli-carrid MEMORY ID car,
                so_con FOR spfli-connid MEMORY ID con.

DATA: gt_spflight TYPE TABLE OF spfli,
      gs_spflight TYPE spfli.

DATA: go_alv TYPE REF TO cl_salv_table, " Main. ref to를 쓰면 table type과 관련된 class 쓸 수 있음
      go_function TYPE REF TO cl_salv_functions_list,
      go_display TYPE REF TO cl_salv_display_settings,
      go_columns TYPE REF TO cl_salv_columns_table,
      go_column TYPE REF TO cl_salv_column_table,
      go_cols TYPE REF TO cl_salv_column,           " 뭐 할 컬럼...?
      go_layout TYPE REF TO cl_salv_layout,
      go_selections TYPE REF TO cl_salv_selections.

START-OF-SELECTION.
  " 1. internal table의 데이터를 채움
  SELECT *
    INTO TABLE gt_spflight
    FROM spfli
    WHERE carrid IN so_car
      AND connid IN so_con.

  " 2. salv object 뿌리기 = salv 만들기
  " 2-1. factory: go_alv 만들기
  TRY.
    CALL METHOD cl_salv_table=>factory
    EXPORTING
      list_display   = ' ' " 화면 모양 : x=리스트, ' '/IF_SALV_C_BOOL_SAP=>FALSE= 원래 모습
*      r_container    =
*      container_name =
    IMPORTING
      r_salv_table   =  go_alv        " 여기에 만들어라
    CHANGING
      t_table        =  gt_spflight.  " 여기 테이블을 써라
    CATCH cx_salv_msg.               " 클래스를 사용할 때 의도치 않은 dump 방지 가능
  ENDTRY.

  " 3. function: 모양 하나씩 만들어주기, get으로 현재 상태를 받아와 현재 object에 하나씩 덧붙여주기
  " 3-1. get: salv 테이블 결과를 go_alv로 get
  CALL METHOD go_alv->get_functions
    RECEIVING
      value  = go_function. " 현재 버튼들의 정보를 알려줌. class type

  " 3-2. set: get의 결과 class에 원하는 설정 set
*  CALL METHOD go_function->set_filter
**    EXPORTING
**      value  = IF_SALV_C_BOOL_SAP=>TRUE
*      .
*  CALL METHOD go_function->set_sort_asc
**    EXPORTING
**      value  = IF_SALV_C_BOOL_SAP=>TRUE
*      .
*  CALL METHOD go_function->set_sort_desc
**    EXPORTING
**      value  = IF_SALV_C_BOOL_SAP=>TRUE
*      .

  CALL METHOD go_function->set_all
*    EXPORTING
*      value  = IF_SALV_C_BOOL_SAP=>TRUE
      .
  " 4. display setting
  " 4-1. get display
  CALL METHOD go_alv->get_display_settings
    RECEIVING
      value  = go_display.

  " 4-2. set display
  CALL METHOD go_display->set_list_header " salv title
   EXPORTING
     value  =  'Title'.

  CALL METHOD go_display->set_striped_pattern " zebra pattern
    EXPORTING
      value  =  'X'.

  " 5. column setting
  " 5-1. get column
  CALL METHOD go_alv->get_columns   " columns 정보 get
    RECEIVING
      value  =  go_columns.

  " 5-2. set column
  CALL METHOD go_columns->set_optimize  " col_opt 기능과 같다
*    EXPORTING
*      value  = IF_SALV_C_BOOL_SAP~TRUE
      .

  " 5-3. mandt column setting; get column
  TRY.
  CALL METHOD go_columns->get_column  " column 정보 get
    EXPORTING
      columnname =  'MANDT'
    RECEIVING
      value      =  go_cols.        " 결과를 go_cols에 줌
    CATCH cx_salv_not_found.
  ENDTRY.

  go_column ?= go_cols. " casting: set technical = CL_SALV_COLUMN_TABLE <> go cols = CL_SALV_COLUMNS_TABLE(같은 부모 밑에 있으므로)

  " 5-4. set mandt column: 숨기기
  CALL METHOD go_column->set_technical  " column을 안보이게 함
*   EXPORTING
*     value  = IF_SALV_C_BOOL_SAP=>TRUE
     .

  " 6. set color
  " 6-1. get column
  TRY.
  CALL METHOD go_columns->get_column  " column 정보 get
    EXPORTING
      columnname =  'FLTIME'
    RECEIVING
      value      =  go_cols.        " 결과를 go_cols에 줌
    CATCH cx_salv_not_found.
  ENDTRY.

  " 6-2. set color
  go_column ?= go_cols. " casting

  DATA: g_color TYPE lvc_s_colo.  " color 설정

  g_color-col = '5'.
  g_color-int = '1'.
  g_color-inv = '0'.

  CALL METHOD go_column->set_color
    EXPORTING
      value  =  g_color.

  " 7. layout 변경
  " 7-1. layout get
  CALL METHOD go_alv->get_layout
    RECEIVING
      value  = go_layout.

  " 7-2. layout setting
  DATA: g_program TYPE salv_s_layout_key.

  g_program-report = sy-cprog. " 프로그램을 key로 주고 layout 결정. alv가 많아지면 handler를 설정하여 선택해서 제어 가능

  CALL METHOD go_layout->set_key
    EXPORTING
      value  =  g_program.

  CALL METHOD go_layout->set_save_restriction
    EXPORTING
      value  = if_salv_c_layout=>restrict_none. " i_save = 'A'와 동일한 설정
                                                " dependant / independant 설정 가능(상수)

  CALL METHOD go_layout->set_default  " i_save = 'X' 와 동일? default가 생김
    EXPORTING
      value  = 'X'.

  " 8. selection button, cell mode
  " 8-1. get selections
  CALL METHOD go_alv->get_selections
    RECEIVING
      value  =  go_selections.

  " 8-2. set selections
  CALL METHOD go_selections->set_selection_mode
    EXPORTING
      value  = if_salv_c_selection_mode=>row_column.  " row_colum selection 추가

  CALL METHOD go_selections->set_selection_mode
    EXPORTING
      value  = if_salv_c_selection_mode=>cell.        " cell selection 추가

  " 2-2. display: go_alv 뿌리기
  CALL METHOD go_alv->display.
