*&---------------------------------------------------------------------*
*& Report ZBC405_ALV_CL1_T03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_alv2_cl1_a06.


TABLES : ztsbook_a06.
*---------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_car FOR ztsbook_a06-carrid OBLIGATORY
                              MEMORY ID car,
                   so_con FOR ztsbook_a06-connid
                              MEMORY ID con,
                   so_fld FOR ztsbook_a06-fldate,
                   so_cus FOR ztsbook_a06-customid.


  SELECTION-SCREEN SKIP.

  PARAMETERS : p_edit AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP.

PARAMETERS : p_layout TYPE disvariant-variant.

DATA : gt_custom TYPE TABLE OF ztscustom_a06,
       gs_custom TYPE          ztscustom_a06.


*-------------------------------
TYPES : BEGIN OF gty_sbook.
          INCLUDE TYPE ztsbook_a06.
TYPES :   light TYPE c LENGTH 1.
TYPES :   telephone TYPE ztscustom_a06-telephone.
TYPES :   email     TYPE ztscustom_a06-email.
TYPES :   row_color TYPE c LENGTH 4.
TYPES :   it_color  TYPE lvc_t_scol.
TYPES :   bt        TYPE lvc_t_styl.
TYPES :   modified  TYPE c LENGTH 1.  " 해당 필드의 레코드가 변경됐는지 확인
TYPES : END OF gty_sbook.

DATA : gt_sbook TYPE TABLE OF gty_sbook,
       gs_sbook TYPE          Gty_sbook,
*       dl_sbook TYPE TABLE OF gty_sbook.  " for deleted records
       dl_sbook TYPE TABLE OF ztsbook_a06,
       ds_sbook TYPE ztsbook_a06.

DATA : ok_code TYPE sy-ucomm.

*-- FOR ALV 변수
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv       TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gt_sort    TYPE lvc_t_sort,
       gs_sort    TYPE lvc_s_sort,
       gs_color   TYPE lvc_s_scol,
       gt_exct    TYPE ui_functions,
       gt_fcat    TYPE lvc_t_fcat,
       gs_fcat    TYPE lvc_s_fcat.

DATA : rt_tab TYPE zz_range_type,
       rs_tab TYPE zst03_carrid.

INCLUDE zbc405_alv2_cl1_a06_class.
*INCLUDE ZBC405_ALV_CL1_T03_class.


*------------------------------------------------------
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'       "S :save, L :load  F: F4
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_layout  =  gs_variant-variant.
  ENDIF.



INITIALIZATION.
  gs_variant-report = sy-cprog.

  rs_tab-low = 'AA'.
  rs_tab-sign = 'I'.
  rs_tab-option = 'EQ'.
  APPEND rs_tab TO rt_tab.

  rs_tab-low = 'LH'.
  rs_tab-sign = 'I'.
  rs_tab-option = 'EQ'.
  APPEND rs_tab TO rt_tab.

  rs_tab-low = 'AZ'.
  rs_tab-sign = 'I'.
  rs_tab-option = 'EQ'.
  APPEND rs_tab TO rt_tab.  " range table을 어떻게 쓰는가...

  so_car[] = rt_tab[]. " 억지...

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  DATA : gt_temp TYPE TABLE OF gty_sbook.

  SELECT *  INTO CORRESPONDING FIELDS OF
            TABLE gt_sbook FROM ztsbook_t03
        WHERE carrid IN so_car AND
              connid IN so_con AND
              fldate IN so_fld AND
              customid IN so_cus.

  IF sy-subrc EQ 0.

    gt_temp = gt_sbook.
    DELETE gt_temp WHERE customid = space.

    SORT gt_temp BY customid.
    DELETE ADJACENT DUPLICATES FROM gt_temp COMPARING customid.

    SELECT  * INTO TABLE gt_custom
          FROM ztscustom_a06
           FOR ALL ENTRIES IN gt_temp
          WHERE id = gt_temp-customid.
  ENDIF.

  LOOP AT gt_sbook INTO gs_sbook.
    READ TABLE gt_custom INTO gs_custom
             WITH KEY id = gs_sbook-customid.
    IF sy-subrc EQ 0.
      gs_sbook-telephone = gs_custom-telephone.
      gs_sbook-email     = gs_custom-email.
    ENDIF.


*--/ exception handling
    IF gs_sbook-luggweight > 25.
      gs_sbook-light = 1.    "red
    ELSEIF gs_sbook-luggweight > 15.
      gs_sbook-light = 2.   "yellow
    ELSE.
      gs_sbook-light = 3.  "green.
    ENDIF.
*--/

    IF gs_sbook-class = 'F'.    "first clase
      gs_sbook-row_color = 'C710'.
    ENDIF.

    IF gs_sbook-smoker = 'X'.
      gs_color-fname = 'SMOKER'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_sbook-it_color.
    ENDIF.


    MODIFY gt_sbook FROM gs_sbook.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF p_edit = 'X'.
    SET PF-STATUS 'T100'.
  ELSE.
    SET PF-STATUS 'T100' EXCLUDING 'SAVE'.  " editing mode일때만 save 버튼이 보이도록
  ENDIF.

  SET TITLEBAR 'T10' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.

  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.


    IF sy-subrc EQ 0.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.

      IF sy-subrc EQ 0.
*- .
        PERFORM set_variant.
        PERFORM set_layout.
        PERFORM set_sort_table.
        PERFORM make_fieldcatalog.

*---
        " edit event 시 변경되는 순간 값이 반영
        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.    "변경되는순간반영
*---                                "mc_evt_enter   "enter 치는순간

*        APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
*        APPEND cl_gui_alv_grid=>mc_fc_info   TO gt_exct.
*        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.  "appendrow
*        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.


        SET HANDLER lcl_handler=>on_doubleclick FOR go_alv.
        SET HANDLER lcl_handler=>on_toolbar     FOR go_alv.
        SET HANDLER lcl_handler=>on_usercommand FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed_finish FOR go_alv.



        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSBOOK_A06'
            is_variant           = gs_variant
            i_save               = 'A'              "i_save : ' '  A X U
            i_default            = 'X'
            is_layout            = gs_layout
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_exct
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_sbook
            it_fieldcatalog      = gt_fcat
            it_sort              = gt_sort
*           it_filter            =
*           EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*          Implement suitable error handling here
        ENDIF.

      ENDIF.
    ENDIF.
  ELSE.

*-- refresh alv methodd 올자리: screen100 안에서 이벤트가 실행됐을 때, pai/pbo를 탈 때, update된 부분만 새로고침
  DATA: gs_stable TYPE lvc_s_stbl,
        gv_soft_refresh TYPE abap_bool.

  gv_soft_refresh = 'X'.
  gs_stable-row = 'X'.
  gs_stable-col = 'X'.
  CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
*    CALL METHOD cl_gui_cfw=>flush.


  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .
  gs_variant-variant = p_layout .


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


  gs_layout-sel_mode = 'D'.   "A, B, C, D
  gs_layout-excp_fname = 'LIGHT'.    "exception handling
  gs_layout-excp_led   = 'X'.        "icon 모양 변경
  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt  = 'X'.

  gs_layout-info_fname = 'ROW_COLOR'.      "row color 필드 설정
  gs_layout-ctab_fname = 'IT_COLOR'.
  gs_layout-stylefname = 'BT'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort_table .

  CLEAR : gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up       = 'X'.
  gs_sort-spos     = '1'.
  APPEND gs_sort TO gt_sort.

  CLEAR : gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up       = 'X'.
  gs_sort-spos     = '2'.
  APPEND gs_sort TO gt_sort.

  CLEAR : gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down       = 'X'.
  gs_sort-spos     = '3'.
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

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SMOKER'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'INVOICE'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CANCELLED'.
  gs_fcat-checkbox = 'X'.
  gs_fcat-edit     = p_edit.    " 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'TELEPHONE'.
  gs_fcat-ref_table = 'ZTSCUSTOM_T03'.
  gs_fcat-ref_field = 'TELEPHONE'.
  gs_fcat-col_pos   = '30'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'EMAIL'.
  gs_fcat-ref_table = 'ZTSCUSTOM_T03'.
  gs_fcat-ref_field = 'EMAIL'.
  gs_fcat-col_pos = '31'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CUSTOMID'.
*  gs_fcat-emphasize = 'C400'.
  gs_fcat-edit      = p_edit.     "'X'.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form customer_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM customer_change_part  USING per_data_changed
                            TYPE REF TO cl_alv_changed_data_protocol
                                 ps_mod_cells TYPE lvc_s_modi.


  DATA : l_customid TYPE ztsbook_a06-customid.
  DATA : l_phone    TYPE ztscustom_a06-telephone.
  DATA : l_email TYPE ztscustom_a06-email,
         l_name  TYPE ztscustom_a06-name.

  READ TABLE gt_sbook INTO gs_sbook  INDEX ps_mod_cells-row_id.

  " instance: per_data_changed
  " class: cl_alv_changed_data_protocol
  " method: get_cell_value
  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    = ps_mod_cells-row_id " customid field에서 row-id도 던져줬었음
*     i_tabix     =
      i_fieldname = 'CUSTOMID'
    IMPORTING
      e_value     = l_customid.         " 내가 입력한 값이 담기는 곳


  IF l_customid IS NOT INITIAL.

    " 기존 get_data에서 gt_custom에 customid가 없으면 db에서 읽어오기
    READ TABLE gt_custom INTO gs_custom
              WITH KEY id = l_customid.
    IF sy-subrc EQ 0.
      l_phone = gs_custom-telephone.
      l_email = gs_custom-eMAIL.
      l_name  = gs_custom-name.
    ELSE.
      " db접근은 성능을 위해 줄이는 것이 좋다
      SELECT SINGLE telephone email name INTO
            (l_phone, l_email, l_name)
               FROM ztscustom_a06
             WHERE id = l_customid.
    ENDIF.
  ELSE.
    CLEAR : l_email, l_phone, l_name.
  ENDIF.

  " db접근은 성능을 위해 줄이는 것이 좋다
  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'TELEPHONE'
      i_value     = l_phone.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'EMAIL'
      i_value     = l_email.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'PASSNAME'
      i_value     = l_NAME.


  gs_sbook-email = l_email.
  gs_sbook-telephone = l_phone.
  gs_sbook-passname = l_name.

  MODIFY gt_sbook FROM gs_sbook INDEX ps_mod_cells-row_id.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form insert_parts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_INS_CELLS
*&---------------------------------------------------------------------*
FORM insert_parts  USING rr_data_changed TYPE REF TO
                             cl_alv_changed_data_protocol
                            Rs_ins_cells TYPE lvc_s_moce.

  " selection 조건에 있는 값을 받아옴
  gs_sbook-carrid = so_car-low. "so_car-sign = 'I' so_car-option = 'eq'
                                "header line을 갖고있기 때문에 바로 쓸 수 있다. into 안해도 됨
  gs_sbook-connid = so_con-low.
  gs_sbook-fldate = so_fld-low.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CARRID'
      i_value     = gs_sbook-carrid.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CONNID'
      i_value     = gs_sbook-connid.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'FLDATE'
      i_value     = gs_sbook-fldate.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'ORDER_DATE'
      i_value     = sy-datum.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_value     = 'P'.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = 'CLASS'
      i_value     = 'C'.

  PERFORM modify_style USING rr_data_changed  " data 변경 가능하게 함
                             Rs_ins_cells
                             'CONNID'.
  PERFORM modify_style USING rr_data_changed  " data 변경 가능하게 함
                             Rs_ins_cells
                             'FLDATE'.

  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CUSTTYPE'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'CLASS'.
  PERFORM modify_style USING rr_data_changed
                             Rs_ins_cells
                             'DISCOUNT'.
  PERFORM modify_style USING rr_data_changed
                            Rs_ins_cells
                            'SMOKER'.
  PERFORM modify_style USING rr_data_changed
                           Rs_ins_cells
                           'LUGGWEIGHT'.
  PERFORM modify_style USING rr_data_changed
                           Rs_ins_cells
                           'WUNIT'.
  PERFORM modify_style USING rr_data_changed
                          Rs_ins_cells
                          'INVOICE'.
  PERFORM modify_style USING rr_data_changed
                          Rs_ins_cells
                          'FORCURAM'.
  PERFORM modify_style USING rr_data_changed
                         Rs_ins_cells
                         'FORCURKEY'.
  PERFORM modify_style USING rr_data_changed
                       Rs_ins_cells
                       'LOCCURAM'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'LOCCURKEY'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'ORDER_DATE'.
  PERFORM modify_style USING rr_data_changed
                        Rs_ins_cells
                        'AGENCYNUM'.




  MODIFY gt_sbook FROM gs_sbook INDEX Rs_ins_cells-row_id .

*


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_STYLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> RR_DATA_CHANGED
*&      --> RS_INS_CELLS
*&      --> P_
*&---------------------------------------------------------------------*
FORM modify_style  USING  rr_data_changed  TYPE REF TO
                             cl_alv_changed_data_protocol
                            Rs_ins_cells TYPE lvc_s_moce
                            VALUE(p_val).

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = Rs_ins_cells-row_id
      i_fieldname = p_val
      i_style     = cl_gui_alv_grid=>mc_style_enabled.  " ready for input: 입력 가ㅡㄴㅇ


ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM modify_check  USING    p_mod_cells TYPE lvc_s_modi.
  READ TABLE gt_sbook INTO gs_sbook INDEX p_mod_cells-row_id.
  IF sy-subrc EQ 0.
    gs_sbook-modified = 'X'.

    MODIFY gt_sbook FROM gs_sbook INDEX p_mod_cells-row_id.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'SAVE'.
        DATA p_answer TYPE c LENGTH 1.

        " databas 접근 및 저장 전 한 번 더 확인하는 로직
        CALL FUNCTION 'POPUP_TO_CONFIRM'  " popup 시 yes면 다음 로직으로 갈 수 있는 function module
          EXPORTING
           titlebar                    = 'Data Save'
*           DIAGNOSE_OBJECT             = ' '
            text_question               = 'Do you want to save?'
           text_button_1               = 'Yes'(001) " yes
*           ICON_BUTTON_1               = ' '
           text_button_2               = 'No'(002) " cancel
*           ICON_BUTTON_2               = ' '
*           DEFAULT_BUTTON              = '1'  " yes
           display_cancel_button       = ' '
*           USERDEFINED_F1_HELP         = ' '
*           START_COLUMN                = 25
*           START_ROW                   = 6
*           POPUP_TYPE                  =
*           IV_QUICKINFO_BUTTON_1       = ' '
*           IV_QUICKINFO_BUTTON_2       = ' '
         IMPORTING " yes/no를 눌렀는지 결과 알려주는 것
           answer                      = p_answer
*         TABLES
*           PARAMETER                   =
         EXCEPTIONS
           text_not_found              = 1
           OTHERS                      = 2
                  .
        IF sy-subrc <> 0.
*       Implement suitable error handling here
        ELSE.
          IF p_answer = '1'.  "yes
            PERFORM data_save.
          ENDIF.
        ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .

  " update 대상
  LOOP AT gt_sbook INTO gs_sbook WHERE modified = 'X'.
    UPDATE ztsbook_a06
      SET customid = gs_sbook-customid
          cancelled = gs_sbook-cancelled
          passname = gs_sbook-passname
      WHERE carrid = gs_sbook-carrid AND
            connid = gs_sbook-connid AND
            fldate = gs_sbook-fldate AND
            bookid = gs_sbook-bookid.
  ENDLOOP.

  " booking 번호가 없으면 신규 예약. insert 대상
  " number range를 따서 삽입. number range object 필요
  " insert 부분
  DATA: ins_sbook TYPE TABLE OF ztsbook_a06,
        wa_sbook TYPE ztsbook_a06.

  CLEAR : ins_sbook. REFRESH : ins_sbook.

  DATA: next_number TYPE s_book_id,  " range object에서 가져옴
        ret_code TYPE inri-returncode.  " function에서 참조

  DATA l_tabix LIKE sy-tabix. " internal table 자체의 index를 기억하여 루프를 돌 때 활용해야 함

  LOOP AT gt_sbook INTO gs_sbook WHERE bookid IS INITIAL.

    l_tabix = sy-tabix. " 현재 테이블 위치 기억

   CALL FUNCTION 'NUMBER_GET_NEXT'
     EXPORTING
       nr_range_nr                   =  '01'
       object                        =  'ZBOOKIDA06'
*      QUANTITY                      = '1'
      subobject                     = gs_sbook-carrid
*      TOYEAR                        = '0000'
      ignore_buffer                 = ' '
    IMPORTING
      number                        = next_number
*      QUANTITY                      =
      returncode                    = ret_code
    EXCEPTIONS
      interval_not_found            = 1
      number_range_not_intern       = 2
      object_not_found              = 3
      quantity_is_0                 = 4
      quantity_is_not_1             = 5
      interval_overflow             = 6
      buffer_overflow               = 7
      OTHERS                        = 8
             .
   IF sy-subrc <> 0.
*    Implement suitable error handling here
   ENDIF.

   IF next_number IS NOT INITIAL.
     gs_sbook-bookid = next_number. " bookid insert
     MOVE-CORRESPONDING gs_sbook TO wa_sbook. " temp table에 insert한 값들 넣어두기
     APPEND wa_sbook TO ins_sbook.

     MODIFY gt_sbook FROM gs_sbook INDEX l_tabix TRANSPORTING bookid.  " bookid만 수정
   ENDIF.

  ENDLOOP.

  IF ins_sbook IS NOT INITIAL.
    INSERT ztsbook_a06 FROM TABLE ins_sbook.  " 쌓은 internal 테이블 실제 db 반영
  ENDIF.

  " delete
  IF dl_sbook IS NOT INITIAL.
    DELETE ztsbook_a06 FROM TABLE dl_sbook.
    CLEAR: dl_sbook.    " line 하나/통으로 지우는 역할
    REFRESH: dl_sbook.  " header line까지 내용을 통으로 지우는 역할

  ENDIF.

ENDFORM.
