*&---------------------------------------------------------------------*
*& Include          ZBC405_A06_ALV_EXAM01_CLASS
*&---------------------------------------------------------------------*
" b. class 정의
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
                                  IMPORTING e_object,
                   on_user_command FOR EVENT user_command OF cl_gui_alv_grid
                                  IMPORTING e_ucomm,
                   " data changed 이후에 실행(둘 다 사용할 경우)
                   on_data_changed_finish FOR EVENT data_changed_finished OF cl_gui_alv_grid
                                  IMPORTING e_modified et_good_cells.
ENDCLASS.

" c. methods 정의
CLASS lcl_handler IMPLEMENTATION.
  " d. event 정의
  METHOD on_toolbar.
    DATA ls_button TYPE stb_button.

    CLEAR: ls_button.
    ls_button-butn_type = '3'.                        " button seperator
    INSERT ls_button INTO TABLE e_object->mt_toolbar. " seperator 추가

    CLEAR : ls_button.
    ls_button-butn_type = '0'.                        "normal button
    ls_button-function = 'CARRID'.                    "flight name.
    ls_button-icon     = ICON_Flight.
    ls_button-quickinfo = 'Get Airline Name'.
    ls_button-text = 'Flight'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR : ls_button.
    ls_button-butn_type = '0'.                        "normal button
    ls_button-function = 'EXPORT_P'.                  "call abap memory.
    ls_button-quickinfo = 'Go To Flight List Info'.
    ls_button-text = 'FlightInfo'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR : ls_button.
    ls_button-butn_type = '0'.                        "normal button
    ls_button-function = 'CALL_TR'.                   "call transaction(sap m).
    ls_button-quickinfo = 'Go To Flight List Info'.
    ls_button-text = 'Flight Data'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.
  ENDMETHOD.

  METHOD on_user_command.
    DATA: lv_text TYPE c LENGTH 20.

    DATA: lt_rows TYPE lvc_t_roid,      " 선택된 row 정보를 쌓을 table
          ls_rows TYPE lvc_s_roid.

    DATA : lv_col_id TYPE lvc_s_col,    " selected cell
           lv_row_id TYPE lvc_s_row.

    " user command는 위치와 필드명을 알려주지 않기 때문에 추가 method call이 필요
    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*        e_row     =
*        e_value   =
*        e_col     =
        es_row_id =  lv_row_id
        es_col_id = lv_col_id
*        es_row_no = lv_row_id
         .

    CLEAR lv_text.
    CASE e_ucomm.
      WHEN 'CARRID'.
        IF lv_col_id-fieldname = 'CARRID'.
          READ TABLE gt_spfli INTO gs_spfli INDEX lv_row_id-index. " 선택한 cell의 row index

          IF sy-subrc EQ 0. " 결과값이 있음
            SELECT SINGLE carrname
              INTO lv_text
              FROM scarr
              WHERE carrid = gs_spfli-carrid.

            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH lv_text.
            ELSE.
              MESSAGE i000(zt03_msg) WITH 'Not Found!'.
            ENDIF.
          ELSE.
            MESSAGE i075(bc405_408). " internal error
            EXIT.
          ENDIF.
        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Select Airline'.
        ENDIF.
      WHEN 'EXPORT_P'.
        DATA: xt_spfli TYPE TABLE OF spfli,
              xs_spfli TYPE spfli.

        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
*            et_index_rows =
            et_row_no     = lt_rows.

        IF  lines( lt_rows ) > 0.   " lt_rows table line 개수
          LOOP AT lt_rows INTO ls_rows.
            READ TABLE gt_spfli INTO gs_spfli INDEX lv_row_id-index.

            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING gs_spfli TO xs_spfli.
              APPEND xs_spfli TO xt_spfli.
            ENDIF.
          ENDLOOP.
        ENDIF.

        EXPORT mem_it_spfli FROM xt_spfli TO MEMORY ID 'BC405'.
        SUBMIT bc405_call_flights AND RETURN.
      WHEN 'CALL_TR'.
        CALL METHOD go_alv_grid->get_current_cell
          IMPORTING
*            e_row     =
*            e_value   =
*            e_col     =
            es_row_id = lv_row_id
*            es_col_id =
*            es_row_no = lv_row_id
              .

        READ TABLE gt_spfli into gs_spfli INDEX lv_row_id-index.

        IF sy-subrc = 0.
          SET PARAMETER: ID 'car' FIELD gs_spfli-carrid,
                         ID 'con' FIELD gs_spfli-connid.

         	CALL TRANSACTION 'SAPBC410A_INPUT_FIEL'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

   METHOD on_data_changed_finish.
    DATA ls_mod_cells TYPE lvc_s_modi.

    CHECK e_modified = 'X'. " check: 수정된 사항이 있을 경우에만(조건이 참일 경우에만) 밑에 로직 수행
                            "        거짓일 경우 method를 빠져나감?
    " 변경된 필드의 값을 저장할 필드를 추가. 저장된 필드만 업데이트 되도록 함
    " et_good_cells는 자체가 테이블이기 때문에 직접 가져와 쓸 수 있다. er_data_changed는 instance를 가져와 슬 수 있음
    LOOP AT et_good_cells INTO ls_mod_cells.
      perform modify_check using ls_mod_cells.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
