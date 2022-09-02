*&---------------------------------------------------------------------*
*& Include          ZC1R060007_S01
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK bl WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: so_carid FOR scarr-carrid,
                  so_conid FOR sflight-connid,
                  so_pltyp FOR sflight-planetype NO INTERVALS NO-EXTENSION. " parameter처럼

SELECTION-SCREEN END OF BLOCK bl.
