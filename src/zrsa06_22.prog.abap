*&---------------------------------------------------------------------*
*& Report ZRSA06_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA06_22.

" 1. define variable
types: BEGIN OF ts_info,
        carrid type zsinfo-carrid,
        carrname type zsinfo-carrname,
        connid type zsinfo-connid,
        cityfrom type zsinfo-cityfrom,
        cityto type zsinfo-cityto,
      END OF ts_info.
DATA: gs_info TYPE ts_info,
      gt_info LIKE TABLE OF gs_info.

" 2. get airlinecode by using parameters
PARAMETERS: pa_ac1 like zsinfo-carrid,  " start airline code
            pa_ac2 like pa_ac1.         " end airline code

"
