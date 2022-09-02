*&---------------------------------------------------------------------*
*& Include SAPMZSA0602_TOP                          - Module Pool      SAPMZSA0602
*&---------------------------------------------------------------------*
PROGRAM sapmzsa0602.

DATA: BEGIN OF gs_cond,
        carrid TYPE sflight-carrid,
        connid TYPE sflight-connid,
      END OF gs_cond.

" condition
TABLES zssa0650.            " use screen
*DATA gs_cond TYPE zssa0650. " use abap

DATA ok_code LIKE sy-ucomm.
