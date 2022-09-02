*&---------------------------------------------------------------------*
*& Include          SAPMZSA0602_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_DEFAULT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_default OUTPUT.
*  IF is initial.
*    zssa0650-carrid = 'AA'.
*    zssa0650-connid = '0017'.
*  ENDIF.
  zssa0650-carrid = 'AA'.
  zssa0650-connid = '0017'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.
  LOOP AT SCREEN.
    CASE screen-group1.   "4개까지 있음
      WHEN 'GR1'.
        screen-active = 0.
*      WHEN 'GR2'.
*      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

*  LOOP AT SCREEN.
*    CASE screen-name.
*      WHEN 'ZSSA0650-CARRID'.
*        IF sy-uname <> 'KD-A-06'. " 권한(신분)에 따른 설정 시 유용
*          screen-input = 0.   " display mode
*          screen-active = 0.   "screen에 보이지 않음.
*        ELSE.
*          screen-input = 1.   " input mode
*          screen-active = 1.  "screen에 보임
*        ENDIF.
*    ENDCASE.
*
*    MODIFY SCREEN.
*    CLEAR screen.
*  ENDLOOP.
ENDMODULE.
