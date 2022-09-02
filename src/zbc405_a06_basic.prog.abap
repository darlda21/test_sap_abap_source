*&---------------------------------------------------------------------*
*& Report ZBC405_A06_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_basic.

TABLES sbuspart.

START-OF-SELECTION.
  SELECTION-SCREEN BEGIN OF BLOCK bl_part WITH FRAME TITLE TEXT-t01.
    PARAMETERS pa_num TYPE sbuspart-buspartnum OBLIGATORY.
    SELECT-OPTIONS so_con FOR sbuspart-contact NO INTERVALS.

    SELECTION-SCREEN SKIP 1.  " ULINE: 구분선,

    PARAMETERS: pa_ta RADIOBUTTON GROUP rbg DEFAULT 'X',
                pa_fc RADIOBUTTON GROUP rbg.
  SELECTION-SCREEN END OF BLOCK bl_part.

  DATA: gt_sbuspart TYPE TABLE OF sbuspart,
        gv_type     TYPE sbuspart-buspatyp.

  REFRESH gt_sbuspart.

  " 방법1-if
  IF pa_ta = 'X'. " pa_ta is not initial, pa_ta ne space, pa_ta eq 'X'
    SELECT mandant buspartnum contact contphono buspatyp
      FROM sbuspart
      INTO CORRESPONDING FIELDS OF TABLE gt_sbuspart
      WHERE buspartnum = pa_num AND
            contact IN so_con AND
            buspatyp = 'TA'.
  ELSEIF pa_fc = 'X'.
    SELECT mandant buspartnum contact contphono buspatyp
      FROM sbuspart
      INTO CORRESPONDING FIELDS OF TABLE gt_sbuspart
      WHERE buspartnum = pa_num AND
            contact IN so_con AND
            buspatyp = 'FC'.
  ENDIF.

  " 방법1-case
  CASE 'X'.
    WHEN pa_ta.
      SELECT mandant buspartnum contact contphono buspatyp
        FROM sbuspart
        INTO CORRESPONDING FIELDS OF TABLE gt_sbuspart
        WHERE buspartnum = pa_num AND
              contact IN so_con AND
              buspatyp = 'TA'.
    WHEN pa_fc.
      SELECT mandant buspartnum contact contphono buspatyp
        FROM sbuspart
        INTO CORRESPONDING FIELDS OF TABLE gt_sbuspart
        WHERE buspartnum = pa_num AND
              contact IN so_con AND
              buspatyp = 'FC'.
    WHEN OTHERS.
  ENDCASE.

  " 방법2-select문 한번만 쓰기
  CASE 'X'.
    WHEN pa_ta.
      gv_type = 'TA'.
    WHEN pa_fc.
      gv_type = 'FC'.
    WHEN OTHERS.
  ENDCASE.

  SELECT mandant buspartnum contact contphono buspatyp
    FROM sbuspart
    INTO CORRESPONDING FIELDS OF TABLE gt_sbuspart
    WHERE buspartnum = pa_num AND
          contact IN so_con AND
          buspatyp = gv_type. "???
