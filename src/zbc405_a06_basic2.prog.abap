*&---------------------------------------------------------------------*
*& Report ZBC405_A06_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_basic2.

TABLES sbook.

SELECTION-SCREEN BEGIN OF BLOCK bl_sbook WITH FRAME TITLE TEXT-t01.
  PARAMETERS      pa_carr   TYPE sbook-carrid OBLIGATORY DEFAULT 'AA'.
  SELECT-OPTIONS  so_conn   FOR sbook-connid OBLIGATORY.
  PARAMETERS      pa_custy  TYPE sbook-custtype OBLIGATORY
                            AS LISTBOX VISIBLE LENGTH 20 DEFAULT 'B'.
  SELECT-OPTIONS: so_fldat  FOR sbook-fldate DEFAULT sy-datum,
                  so_bkid   FOR sbook-bookid,
                  so_cusid  FOR sbook-customid NO INTERVALS NO-EXTENSION. " param처럼
SELECTION-SCREEN END OF BLOCK bl_sbook.

DATA: BEGIN OF gs_sbook,
        carrid   TYPE sbook-carrid,
        connid   TYPE sbook-connid,
        fldate   TYPE sbook-fldate,
        bookid   TYPE sbook-bookid,
        customid TYPE sbook-customid,
        custtype TYPE sbook-custtype,
        invoice  TYPE sbook-invoice,
        class    TYPE sbook-class,
      END OF gs_sbook,
      gt_sbook LIKE TABLE OF gs_sbook.

SELECT carrid connid fldate bookid customid custtype invoice class
  FROM sbook
  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
  WHERE carrid = pa_carr AND
        connid IN so_conn AND
        custtype = pa_custy AND
        fldate IN so_fldat AND
        bookid IN so_bkid AND
        customid IN so_cusid.

IF sy-subrc NE 0.
  MESSAGE e016(pn) WITH 'No data found'.
  LEAVE LIST-PROCESSING.
ENDIF.

LOOP AT gt_sbook INTO gs_sbook.
  IF gs_sbook-invoice = 'X'.
    gs_sbook-class = 'F'.
    MODIFY gt_sbook FROM gs_sbook INDEX sy-tabix TRANSPORTING class.

    IF sy-subrc NE 0.
      MESSAGE e016(pn) WITH 'modify error'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.
ENDLOOP.

cl_demo_output=>display_data( gt_sbook ).
