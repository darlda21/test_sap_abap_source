*&---------------------------------------------------------------------*
*& Report ZBC405_A06_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_basic4.

TABLES: sflight, sbook.

SELECTION-SCREEN BEGIN OF BLOCK bl_selection WITH FRAME TITLE TEXT-t01.
  PARAMETERS     pa_carr TYPE sflight-carrid OBLIGATORY.
  SELECT-OPTIONS so_conn FOR sflight-connid OBLIGATORY.
  PARAMETERS     pa_pltyp TYPE sflight-planetype AS LISTBOX VISIBLE LENGTH 10.
  SELECT-OPTIONS so_bkid FOR sbook-bookid.
SELECTION-SCREEN END OF BLOCK bl_selection.

" f4 기능 추가

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_carr.
  PERFORM f4_carrid.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_bkid-low.
START-OF-SELECTION.

  DATA:
    " itab1
    BEGIN OF gs_data,
      carrid    TYPE sflight-carrid,
      connid    TYPE sflight-connid,
      fldate    TYPE sflight-fldate,
      planetype TYPE sflight-planetype,
      currency  TYPE sflight-currency,
      bookid    TYPE sbook-bookid,
      customid  TYPE sbook-customid,
      custtype  TYPE sbook-custtype,
      class     TYPE sbook-class,
      agencynum TYPE sbook-agencynum,
    END OF gs_data,
    gt_data LIKE TABLE OF gs_data,
    "itab2
    BEGIN OF gs_result,
      carrid    TYPE sflight-carrid,
      connid    TYPE sflight-connid,
      fldate    TYPE sflight-fldate,
      bookid    TYPE sbook-bookid,
      customid  TYPE sbook-customid,
      custtype  TYPE sbook-custtype,
      agencynum TYPE sbook-agencynum,
    END OF gs_result,
    gt_result LIKE TABLE OF gs_result,
    " system 변수
    gv_tabix  TYPE sy-tabix.

  REFRESH: gt_data, gt_result.

  SELECT DISTINCT a~carrid a~connid a~fldate a~planetype a~currency
         b~bookid b~customid b~custtype b~class b~agencynum
    FROM sflight AS a INNER JOIN sbook AS b
    ON   a~carrid = b~carrid AND
         a~connid = b~connid AND
         a~fldate = b~fldate
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    WHERE a~carrid = pa_carr AND
          a~connid IN so_conn AND
          a~planetype = pa_pltyp AND
  b~bookid IN so_bkid.

  IF sy-subrc NE 0.
    MESSAGE e016(pn) WITH 'No data found'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  LOOP AT gt_data INTO gs_data.
    IF gs_data-custtype = 'B'.
      MOVE-CORRESPONDING gs_data TO gs_result. " 필드명이 같으면 가능
      APPEND gs_result TO gt_result.
      CLEAR gs_result.
    ENDIF.
  ENDLOOP.

  SORT gt_result BY carrid connid fldate.
  DELETE ADJACENT DUPLICATES FROM gt_result COMPARING carrid connid fldate. " 중복 제거는 반드시 정렬 순서대로

  cl_demo_output=>display_data( gt_result ).

*&---------------------------------------------------------------------*
*& Form f4_carrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_carrid .
  DATA: BEGIN OF ls_carrid,
          carrid   TYPE scarr-carrid,
          carrname TYPE scarr-carrname,
          currcode TYPE scarr-currcode,
          url      TYPE scarr-url,
        END OF ls_carrid,
        lt_carrid LIKE TABLE OF ls_carrid.

  REFRESH lt_carrid.

  SELECT carrid carrname currcode url
    INTO CORRESPONDING FIELDS OF TABLE lt_carrid
  FROM scarr.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CARRID'      " 더블 클릭 시 세팅될 return field(강조표시됨)
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'PA_CARR'      " 더블 클릭 시 어느 field에 세팅될 것인가
      window_title    = 'Airline List'
      value_org       = 'S'            " 더블 클릭 시 뜨게 한다
*      display         = 'X'            " 선택한 데이터가 세팅될 화면의 필드에 세팅되는 것 막음(필드가 disabled여서 display 전용으로 바꿈)
* IMPORTING
*     USER_RESET      =
    TABLES
      value_tab       = lt_carrid      " 내가 만든 테이블
*     FIELD_TAB       =
*     RETURN_TAB      =
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
