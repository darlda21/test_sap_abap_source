*&---------------------------------------------------------------------*
*& Report ZBC405_A06_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_basic3.

TABLES: sflight, sbook.

SELECTION-SCREEN BEGIN OF BLOCK bl_selection WITH FRAME TITLE TEXT-t01.
  PARAMETERS     pa_carr TYPE sflight-carrid OBLIGATORY.
  SELECT-OPTIONS so_conn FOR sflight-connid OBLIGATORY.
  PARAMETERS     pa_pltyp TYPE sflight-planetype AS LISTBOX VISIBLE LENGTH 10.
  SELECT-OPTIONS so_bkid FOR sbook-bookid.
SELECTION-SCREEN END OF BLOCK bl_selection.

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
