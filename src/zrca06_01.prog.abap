*&---------------------------------------------------------------------*
*& Report ZRCA06_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca06_01.

DATA: BEGIN OF gs_data,
        ktopl TYPE ska1-ktopl,
        ktplt TYPE t004t-ktplt,
        saknr TYPE ska1-saknr,
        txt20 TYPE skat-txt20,
        ktoks TYPE ska1-ktoks,
        txt30 TYPE t077z-txt30,
      END OF gs_data,
      gt_data LIKE TABLE OF gs_data,

      BEGIN OF gs_t004t,
        ktopl TYPE t004t-ktopl,
        ktplt TYPE t004t-ktplt,
      END OF gs_t004t,
      gt_t004t LIKE TABLE OF gs_t004t,

      BEGIN OF gs_skat,
        ktopl type skat-ktopl,
        saknr TYPE skat-saknr,
        txt20 TYPE skat-txt20,
      END OF gs_skat,
      gt_skat LIKE TABLE OF gs_skat,

      BEGIN OF gs_t077z,
        ktopl type t077z-ktopl,
        ktoks TYPE t077z-ktoks,
        txt30 TYPE t077z-txt30,
      END OF gs_t077z,
      gt_t077z LIKE TABLE OF gs_t077z,

      lv_tabix TYPE sy-tabix.

SELECT ktopl saknr ktoks
  FROM ska1
  INTO CORRESPONDING FIELDS OF TABLE gt_data
  WHERE ktopl = 'WEG'.

SELECT ktopl ktplt
  FROM t004t
  INTO CORRESPONDING FIELDS OF TABLE gt_t004t
  WHERE spras = sy-langu.

SELECT ktopl saknr txt20
  FROM skat
  INTO CORRESPONDING FIELDS OF TABLE gt_skat
  WHERE spras = sy-langu.

SELECT ktopl ktoks txt30
  FROM t077z
  INTO CORRESPONDING FIELDS OF TABLE gt_t077z
  WHERE spras = sy-langu.

LOOP AT gt_data INTO gs_data.
  lv_tabix = sy-tabix.

  READ TABLE gt_t004t INTO gs_t004t WITH KEY ktopl = gs_data-ktopl.

  IF sy-subrc EQ 0.
    gs_data-ktplt = gs_t004t-ktplt.
    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING ktplt.

    READ TABLE gt_skat INTO gs_skat WITH KEY ktopl = gs_data-ktopl
                                             saknr = gs_data-saknr.

    IF sy-subrc EQ 0.
      gs_data-txt20 = gs_skat-txt20.
      MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING txt20.

      READ TABLE gt_t077z INTO gs_t077z WITH KEY ktopl = gs_data-ktopl
                                                 ktoks = gs_data-ktoks.

      IF sy-subrc EQ 0.
        gs_data-txt30 = gs_t077z-txt30.
        MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING txt30.
      ENDIF.
    ENDIF.
  ENDIF.

  CLEAR gs_data.
ENDLOOP.

cl_demo_output=>display_data( gt_data ).

** do
*data gv_num type i.
*DO 6 TIMES.
*  gv_num = gv_num + 1.
*  WRITE sy-index.   " structure 변수
*  IF gv_num > 3.
*    EXIT.
*  ENDIF.
*  WRITE gv_num.
*  NEW-LINE.
*ENDDO.
*
** if vs. case
*DATA gv_gender TYPE c LENGTH 1.   " M, F
*
*gv_gender = 'X'.
*
*IF gv_gender = 'M'.
*
*  ELSEIF gv_gender = 'F'.
*
*  ELSE.
*
*ENDIF.
*
*CASE  gv_gender.
*  WHEN 'M'.
*
*  WHEN 'F'.
*
*  WHEN OTHERS.
*
*ENDCASE.
