*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_CL1_T03_CLASS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS :

      on_doubleclick FOR EVENT
        double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,
      on_toolbar FOR EVENT
        toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      on_usercommand FOR EVENT
        user_Command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_data_changed FOR EVENT
        data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,
      on_data_changed_finish FOR EVENT            " data changed 이후에 실행(둘 다 사용할 경우)
        data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.


ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
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

  METHOD on_data_changed.
     FIELD-SYMBOLS : <fs> LIKE gt_sbook.

    DATA : ls_mod_cells TYPE lvc_s_modi,
           ls_ins_cells TYPE lvc_s_moce,
           ls_del_line  TYPE lvc_s_moce,
           ls_del_cells TYPE lvc_s_moce.

*-- data change parts
    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cells. " mt_good_cells: 변경사항

      CASE ls_mod_cells-fieldname.
        WHEN 'CUSTOMID'.
          PERFORM customer_change_part USING er_data_changed
                                       ls_mod_cells.
        WHEN 'CANCELLED'.
      ENDCASE.
    ENDLOOP.



*-- inserted parts
    IF  er_data_changed->mt_inserted_rows IS NOT INITIAL.

      ASSIGN  er_data_changed->mp_mod_rows->* TO <fs>.  " <fs>: field symbol, 테이블과 같은 타입 생성
                                                        " 원래는 data type(string)으로 쌓여있으나 fs를 통해 table 타입으로 추가됨
      IF sy-subrc EQ 0.
        APPEND LINES OF <fs> TO gt_sbook. " 빈 열 삽입
        LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_cells.  " 빈공간에 들어오면 빈공간을 돌면서

          READ TABLE gt_sbook INTO gs_sbook INDEX ls_ins_cells-row_id.
          IF sy-subrc EQ 0.
*           " 변경된 데이터 삽입
            PERFORM insert_parts USING er_data_changed
                                          ls_ins_cells.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

**-- delete parts
    IF  er_data_changed->mt_DELETED_rows IS NOT INITIAL.  " 선택된 값이 있으면 루프를 돌겠다

      LOOP AT er_data_changed->mt_DELETED_rows INTO ls_DEL_cells.

        READ TABLE gt_sbook INTO gs_sbook INDEX ls_DEL_cells-row_id.
        IF sy-subrc EQ 0.
          MOVE-CORRESPONDING gs_sbook to ds_sbook.
          APPEND ds_sbook TO dl_sbook. " dl_sbook(global): delte 할 임시 데이터. 화면에서만 사라진 것이기 때문에 따로 담아논다
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.



  METHOD on_usercommand.
    DATA : ls_col  TYPE   lvc_s_col,
           ls_roid TYPE  lvc_s_roid.


    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_col_id = ls_col
        es_row_no = ls_roid.



    CASE e_ucomm.
      WHEN 'GOTOFL'.
        READ TABLE gt_sbook INTO gs_sbook
             INDEX ls_roid-row_id.
        IF sy-subrc EQ 0.
          SET PARAMETER ID 'CAR' FIELD gs_sbook-carrid.
          SET PARAMETER ID 'CON' FIELD gs_sbook-connid.

          CALL TRANSACTION 'SAPBC405CAL'.

        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD on_toolbar.
    DATA : wa_button TYPE stb_button.

    wa_button-butn_type = '3'.     "seperator
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

    CLEAR : wa_button.
    wa_button-butn_type = '0'.    "normal button
    wa_button-function = 'GOTOFL'.   "flight connection.
    wa_button-icon     = ICON_Flight.
    wa_button-quickinfo = 'Go to flight connection!'.
    wa_button-text = 'Flight'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.


  ENDMETHOD.



  METHOD on_doubleclick.
    DATA : carrname TYPE scarr-carrname.
    CASE e_column-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_sbook INTO gs_sbook
             INDEX e_row-index.
        IF sy-subrc EQ 0.

          SELECT SINGLE carrname INTO carrname
                FROM scarr WHERE carrid = gs_sbook-carrid.
          IF sy-subrc EQ 0.
            MESSAGE i000(zt03_msg) WITH carrname.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
