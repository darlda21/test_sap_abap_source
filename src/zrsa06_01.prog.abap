*&---------------------------------------------------------------------*
*& Report ZRSA06_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_01.

PARAMETERS pa_carr TYPE scarr-carrid.

DATA gs_scarr TYPE scarr.

PERFORM get_data.

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT SINGLE * FROM  scarr
  INTO gs_scarr
  WHERE carrid = pa_carr.

  IF sy-subrc = 0.
    NEW-LINE.

    WRITE: gs_scarr-carrid,
           gs_scarr-carrname,
           gs_scarr-url.
  ELSE.
    WRITE TEXT-m01. "'Sorry, no data found!'
*    MESSAGE 'Sorry, no data found!' TYPE 'I'.
  ENDIF.
ENDFORM.
