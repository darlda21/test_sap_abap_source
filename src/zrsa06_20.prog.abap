*&---------------------------------------------------------------------*
*& Report ZRSA06_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_20.

"1. define variable
TYPES: BEGIN OF ts_info,          " types 먼저 선언
        carrid TYPE c LENGTH 3,
        carrname TYPE scarr-carrname,
        connid TYPE spfli-connid,
        countryfr TYPE spfli-countryfr,
        countryto TYPE spfli-countryto,
        atype,                    " D, I
        atype_t TYPE c LENGTH 10, "Domestic, International
       END OF ts_info.
DATA gt_info  TYPE TABLE OF ts_info.  " table 먼저 선언
DATA gs_info LIKE LINE OF gt_info.    " structure 선언 시 line of

"or
*data: gs_info TYPE ts_info,          " sturcture 먼저 선언
*      gt_info LIKE TABLE OF gs_info. " table 선언 시 table of

"mine
*DATA: BEGIN OF gs_info,
*        carrid TYPE spfli-carrid,
*        carrname TYPE scarr-carrname,
*        connid TYPE spfli-connid,
*        countryfr TYPE spfli-countryfr,
*        countryto TYPE spfli-countryto,
*        atype TYPE c LENGTH 10,
*      END OF gs_info.
*DATA gt_info LIKE TABLE OF gs_info.

"2. append
PERFORM add_info USING 'AA' '0017' 'US' 'US'.
PERFORM add_info USING 'AA' '0064' 'US' 'US'.
PERFORM add_info USING 'AZ' '0055' 'IT' 'DE'.

"mine
*gs_info-carrid = 'AA'.
*gs_info-connid = '0017'.
*gs_info-countryfr = 'US'.
*gs_info-countryto = 'US'.
*APPEND gs_info TO gt_info.
*
*gs_info-carrid = 'AA'.
*gs_info-connid = '0064'.
*gs_info-countryfr = 'US'.
*gs_info-countryto = 'US'.
*APPEND gs_info TO gt_info.
*
*gs_info-carrid = 'AZ'.
*gs_info-connid = '0555'.
*gs_info-countryfr = 'IT'.
*gs_info-countryto = 'DE'.
*APPEND gs_info TO gt_info.
*
*PERFORM app_info.
*
*CLEAR gs_info.

"3. modify in loop
LOOP AT gt_info INTO gs_info.
  "3-1. domestic vs. international
   IF gs_info-countryfr = gs_info-countryto.
     gs_info-atype = 'D'.
   ELSE.
     gs_info-atype = 'I'.
   ENDIF.

  MODIFY gt_info FROM gs_info TRANSPORTING atype. " atype값만 업데이트

  "3-2. carrname append
  SELECT SINGLE carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF gs_info
    WHERE carrid = gs_info-carrid.

  MODIFY gt_info FROM gs_info TRANSPORTING carrname atype.
  CLEAR gs_info.
ENDLOOP.

"sort
SORT gt_info BY atype ASCENDING.

"mine
*LOOP AT gt_info INTO gs_info.
*  "3-1. domestic vs. international
*  IF gs_info-countryfr = gs_info-countryto.
*    gs_info-atype = TEXT-t01. " 'Domestic'
*  ELSE.
*    gs_info-atype = TEXT-t02. " 'International'
*  ENDIF.
*
*  MODIFY gt_info FROM gs_info.
*
*  "3-2. carrname append
*  SELECT SINGLE carrname
*    FROM scarr
*    INTO CORRESPONDING FIELDS OF gs_info
*    WHERE carrid = gs_info-carrid.
*
*  MODIFY gt_info FROM gs_info.
*
*  CLEAR gs_info.
*ENDLOOP.

cl_demo_output=>display_data( gt_info ).

*&---------------------------------------------------------------------*
*& Form app_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_info USING VALUE(p_carrid) VALUE(p_connid) VALUE(p_fr) VALUE(p_to).
  DATA ls_info LIKE LINE OF gt_info.  " structure는 local, table은 ...?

  ls_info-carrid = p_carrid.
  ls_info-connid = p_connid.
  ls_info-countryfr = p_fr.
  ls_info-countryto = p_to.
  APPEND ls_info TO gt_info.
ENDFORM.
