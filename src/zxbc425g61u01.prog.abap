*&---------------------------------------------------------------------*
*& Include          ZXBC425G61U01
*&---------------------------------------------------------------------*

IF flight-fldate < sy-datum.
  MESSAGE i011(bc425) with sy-datum.
ENDIF.