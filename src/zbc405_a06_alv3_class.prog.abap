*&---------------------------------------------------------------------*
*& Include          ZBC405_A06_ALV2_CLASS
*&---------------------------------------------------------------------*
" 11. class 정의
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    " 4 events
    CLASS-METHODS : on_doubleclick FOR EVENT double_click OF cl_gui_alv_grid  " 어디의 이벤트
                                   IMPORTING e_row e_column es_row_no,        " 결과를 받아올 곳, 내가 활용할 obj/ event
                    on_hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
                                   IMPORTING e_row_id e_column_id es_row_no,
                    on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
                                   IMPORTING e_object,                   " toolbar type을 알려주는 class. object 생성과 동일
                    on_user_command FOR EVENT user_command OF cl_gui_alv_grid
                                   IMPORTING e_ucomm,                   " toolbar 와 user command는 쌍
                    on_button_click FOR EVENT button_click OF cl_gui_alv_grid
                                   IMPORTING es_col_id es_row_no,
                    on_context_menu_request FOR EVENT context_menu_request OF cl_gui_alv_grid
                                   IMPORTING e_object,
                    on_before_user_comm FOR EVENT before_user_command OF cl_gui_alv_grid  " 설정한다면 user command 실행되기 전에 실행
                                   IMPORTING e_ucomm.
ENDCLASS.

" 22. methods 정의
CLASS lcl_handler IMPLEMENTATION.
  " before user command 정의
  METHOD on_before_user_comm.
    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail. " 현재 detail button은 stadard button
        CALL METHOD go_alv_grid->set_user_command " 이제부턴 detail을 누르면 i_ucomm에 있는 function code 실행
                                                  " function code는 기존의 user command event에 추가
          EXPORTING
            i_ucomm = 'SCHE'. " flight schedule report
    ENDCASE.
  ENDMETHOD.

  " context menu 기능 정의
  METHOD on_context_menu_request.
    " staus에 있는 메뉴 불러오기
   CALL METHOD cl_ctmenu=>load_gui_status
      EXPORTING
        program    =  sy-cprog
        status     =  'CT_MENU'
*        disable    =
        menu       =  e_object
      EXCEPTIONS
        read_error = 1
        OTHERS     = 2
            .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    " seperator 추가
    CALL METHOD e_object->add_separator
        .
    " column이 airline인 경우에만
    DATA : lv_col_id TYPE lvc_s_col,  " selected cell
           lv_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell "위치와 필드명을 알려주지 않기 때문에 추가 method call이 필요
      IMPORTING
*        e_row     =
*        e_value   =
*        e_col     =
        es_row_id =  lv_row_id
        es_col_id = lv_col_id
*        es_row_no =
         .

    IF lv_col_id-fieldname = 'CARRID'.
      " menu 추가하기
      CALL METHOD e_object->add_function
        EXPORTING
          fcode             = 'CARRID'
          text              = 'Display Airline2'
*          icon              =
*          ftype             =
*          disabled          =
*          hidden            =
*          checked           =
*          accelerator       =
*          insert_at_the_top = SPACE
          .
    ENDIF.
  ENDMETHOD.

  " button click 기능 정의
  METHOD on_button_click.
    READ TABLE gt_flight INTO gs_flight INDEX es_row_no-row_id.

    IF ( gs_flight-seatsmax NE gs_flight-seatsocc ) OR
       ( gs_flight-seatsmax_f NE gs_flight-seatsocc_f ).
      " 하나라도 자리가 있다면
      MESSAGE i000(zt03_msg) WITH 'Select another seat.'.
    ELSE.
      " 자리가 없다면
      MESSAGE i000(zt03_msg) WITH 'Full of reservation.'.
    ENDIF.
  ENDMETHOD.
  " toolbar event 등록을 위한 user command 정의
  METHOD on_user_command.
    DATA: lv_occp TYPE i,
          lv_capa TYPE i,
          lv_perct TYPE p LENGTH 8 DECIMALS 1,
          lv_text(20).

    DATA: lt_rows TYPE lvc_t_roid, " 선택된 row 정보를 쌓을 table
          ls_rows TYPE lvc_s_roid.

    DATA : lv_col_id TYPE lvc_s_col,  " selected cell
           lv_row_id TYPE lvc_s_row.

    " user command는 위치와 필드명을 알려주지 않기 때문에 추가 method call이 필요
    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*        e_row     =
*        e_value   =
*        e_col     =
        es_row_id =  lv_row_id
        es_col_id = lv_col_id
*        es_row_no =
         .

     " toolbar 기능 정의
    CLEAR lv_text.
    CASE e_ucomm.
      WHEN 'PERCENTAGE'.
        LOOP AT gt_flight INTO gs_flight.
          lv_occp = lv_occp + gs_flight-seatsocc.
          lv_capa = lv_capa + gs_flight-seatsmax.
        ENDLOOP.

        lv_perct = lv_occp / lv_capa * 100.
        lv_text = lv_perct.
        CONDENSE lv_text.

        MESSAGE i000(zt03_msg) WITH 'Percentage of occupied seats : ' lv_text ' %'.
      WHEN 'PERCENTAGE_MARKED'.
        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
*            et_index_rows =
            et_row_no     = lt_rows.

        IF  lines( lt_rows ) > 0.   " lt_rows table line 개수
          LOOP AT lt_rows INTO ls_rows.
            READ TABLE gt_flight INTO gs_flight INDEX ls_rows-row_id.

            IF sy-subrc EQ 0.
              lv_occp = lv_occp + gs_flight-seatsocc.
              lv_capa = lv_capa + gs_flight-seatsmax.
            ENDIF.
          ENDLOOP.

          lv_perct = lv_occp / lv_capa * 100.
          lv_text = lv_perct.
          CONDENSE lv_text.

          MESSAGE i000(zt03_msg) WITH 'Percentage of occupied seats : ' lv_text ' %'.
        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Please select at least 1 line!'.
        ENDIF.
      WHEN 'CARRID'.
        IF lv_col_id-fieldname = 'CARRID'.
          READ TABLE gt_flight INTO gs_flight INDEX lv_row_id-index. " 선택한 cell의 row index

          IF sy-subrc EQ 0.                                       " 결과값이 있음
            SELECT SINGLE carrname
              INTO lv_text
              FROM scarr
              WHERE carrid = gs_flight-carrid.

            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH lv_text.
            ELSE.
              MESSAGE i000(zt03_msg) WITH 'Not Found!'.
            ENDIF.
          ELSE.
            MESSAGE i075(bc405_408).             " internal error
            EXIT.
          ENDIF.
        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Select Airline'.
        ENDIF.
      WHEN 'SCHE'.  " goto flight schedule report
        READ TABLE gt_flight INTO gs_flight INDEX lv_row_id-index.
        IF sy-subrc EQ 0.
          SUBMIT bc405_event_d4 AND RETURN      " 다른 program 불러오기
                WITH so_car EQ gs_flight-carrid
                WITH so_con EQ gs_flight-connid.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  " toolbar 기능 정의
  METHOD on_toolbar.
    DATA ls_button TYPE stb_button.

    CLEAR: ls_button.
    ls_button-butn_type = '3'.          " button seperator
    INSERT ls_button INTO TABLE e_object->mt_toolbar. " seperator 추가

    CLEAR: ls_button.
    ls_button-function = 'PERCENTAGE'.
*    ls_button-icon = ?
    ls_button-quickinfo = 'Occupied Total Percentage'.
    ls_button-butn_type = '0'.          " normal button
    ls_button-text = 'Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar. " button 추가

    CLEAR: ls_button.
    ls_button-function = 'PERCENTAGE_MARKED'.
*    ls_button-icon = ?
    ls_button-quickinfo = 'Occupied Marked Percentage'.
    ls_button-butn_type = '0'.          " normal button
    ls_button-text = 'Marked Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar. " burron 추가

    CLEAR: ls_button.
    ls_button-function = 'CARRID'.
*    ls_button-icon = ?
    ls_button-quickinfo = 'Display Airline'.
    ls_button-butn_type = '0'.          " normal button
    ls_button-text = 'Carrid'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar. " burron 추가

  ENDMETHOD.

  " on_hotspot 기능 정의
  METHOD on_hotspot.
    DATA carr_name TYPE scarr-carrname.

    CASE e_column_id-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_flight INTO gs_flight INDEX es_row_no-row_id. " 선택한 cell의 row index

        IF sy-subrc EQ 0.                                       " 결과값이 있음
          SELECT SINGLE carrname
            INTO carr_name
            FROM scarr
            WHERE carrid = gs_flight-carrid.

          IF sy-subrc EQ 0.
            MESSAGE i000(zt03_msg) WITH carr_name.
          ELSE.
            MESSAGE i000(zt03_msg) WITH 'Not Found!'.
          ENDIF.
        ELSE.
          MESSAGE i075(bc405_408).                              " internal error
          EXIT.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  " on_doubleclick의 기능 정의
  METHOD on_doubleclick.
    DATA: lv_total_occ TYPE i,
          lv_total_occ_c TYPE c LENGTH 10.                  " message는 c 타입이어야 됨

  CASE e_column-fieldname.                                " 필드별로 다르게 설정
    WHEN 'CHANGES_POSSIBLE'.
      " 기능: eco + bus + fir = total booked seats
      READ TABLE gt_flight INTO gs_flight INDEX es_row_no-row_id.   " 더블클릭한 위치(es_row_no) 가져오기
      IF sy-subrc EQ 0.                                       " 결과값이 있음
        lv_total_occ = gs_flight-seatsocc +
                       gs_flight-seatsocc_b +
                       gs_flight-seatsocc_f.
        lv_total_occ_c = lv_total_occ.
        CONDENSE lv_total_occ_c.                                 " 왼쪽 정렬
        MESSAGE i000(zt03_msg) WITH 'Total Number of Bookings: ' lv_total_occ_c.
      ELSE.
        MESSAGE i075(bc405_408).                              " internal error
        EXIT.
      ENDIF.
    WHEN OTHERS.
   ENDCASE.
  ENDMETHOD.
ENDCLASS.
