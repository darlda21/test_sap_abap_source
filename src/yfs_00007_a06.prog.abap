*&---------------------------------------------------------------------*
*& Report YTEST0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfs_00007_a06.

TABLES : ztspfli_t03.

SELECT-OPTIONS : s_car FOR ztspfli_t03-carrid,
                 s_con FOR ztspfli_t03-connid.

TYPES: BEGIN OF ty_type.
    INCLUDE TYPE ztspfli_t03.
    TYPES : sum_amt TYPE ztspfli_t03-wtg001.
TYPES: END OF ty_type.



DATA : gt_tab TYPE TABLE OF ty_type.
DATA : wa_tab TYPE ty_type.
*DATA : fname(20).
DATA : nn(3) TYPE n.
FIELD-SYMBOLS : <fs> TYPE any.

DATA: gt_nametab TYPE TABLE OF dntab,
      gs_nametab TYPE dntab,
      lt_fcat TYPE TABLE OF lvc_s_fcat,
      ls_fcat LIKE LINE OF lt_fcat.
FIELD-SYMBOLS : <lf> TYPE lvc_s_fcat.

DATA go_alv_grid TYPE REF TO cl_gui_alv_grid.

START-OF-SELECTION.


  SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_tab
     FROM ztspfli_t03
     WHERE carrid IN s_car AND
           connid IN s_con.

  CALL FUNCTION 'NAMETAB_GET'
     EXPORTING
       langu                     = sy-langu
*       ONLY                      = ' '
       tabname                   = 'ZTSPFLI_T03'
*     IMPORTING
*       HEADER                    =
*       RC                        =
      TABLES
        nametab                   = gt_nametab
     EXCEPTIONS
       internal_error            = 1
       table_has_no_fields       = 2
       table_not_activ           = 3
       no_texts_found            = 4
       OTHERS                    = 5.

  LOOP AT gt_nametab INTO gs_nametab WHERE fieldname NE 'MANDT'.
    ls_fcat-fieldname = gs_nametab-fieldname.
    ls_fcat-ref_table = 'ZTSPFLI_T03'.
    ls_fcat-ref_field = gs_nametab-fieldtext.
    ls_fcat-coltext = gs_nametab-fieldtext.

    IF gs_nametab-fieldname(3) CS 'WTG'.
      ls_fcat-cfieldname = gs_nametab-reffield.
    ENDIF.

    APPEND ls_fcat TO lt_fcat.
  ENDLOOP.

  IF sy-subrc EQ 0.
    ls_fcat-fieldname = 'SUM_AMT'.
    ls_fcat-cfieldname = 'WAERS'.
    ls_fcat-coltext = 'SumAmt'.

    APPEND ls_fcat TO lt_fcat.
  ENDIF.

  DATA l_tabix LIKE sy-tabix.
  LOOP AT gt_tab INTO wa_tab.
    l_tabix = sy-tabix.
    CLEAR: nn, wa_tab-sum_amt.

    LOOP AT lt_fcat ASSIGNING <lf>.
      IF <lf>-fieldname CS 'WTG'.
        ASSIGN COMPONENT <lf>-fieldname OF STRUCTURE wa_tab TO <fs>.
        wa_tab-sum_amt = wa_tab-sum_amt + <fs>.
      ENDIF.
    ENDLOOP.

    MODIFY gt_tab FROM wa_tab INDEX l_tabix.
  ENDLOOP.

  WRITE space. " cl_gui_container=>screen0.에는 write 필요. write 스크린위에 얹기 위해

  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent          = cl_gui_container=>screen0. " 스크린 생성 없이 alv object 생성
                                                     " container attributes 중에 screen 있음
  CALL METHOD go_alv_grid->set_table_for_first_display
    CHANGING
      it_outtab                     = gt_tab
      it_fieldcatalog               = lt_fcat.
