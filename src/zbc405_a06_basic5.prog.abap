*&---------------------------------------------------------------------*
*& Report ZBC405_A06_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a06_basic5.

TABLES: mara, marc.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01. " Selection
  PARAMETERS: pa_wekrs TYPE mkal-werks DEFAULT '1010',
              pa_berid TYPE pbid-berid DEFAULT '1010',
              pa_pbdnr TYPE pbid-pbdnr,
              pa_versb TYPE pbid-versb DEFAULT '00'.
SELECTION-SCREEN END OF BLOCK bl1.

" mode 선택
SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02. " Display Option
  PARAMETERS: pa_crt  RADIOBUTTON GROUP rbg DEFAULT 'X' USER-COMMAND mod, " user-command: mod라는 event 발생
                                                                          " 발생 시 at selection-screen outpu으로 이동
                                                                          " check box, radio button 등의 클릭 이벤트에서만 이벤트 걸 수 있다
                                                                          " user-command가 없으면 element 값에 접근할 수 없다
              pa_disp RADIOBUTTON GROUP rbg.
SELECTION-SCREEN END OF BLOCK bl2.

SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-t03. " Input Option
  SELECT-OPTIONS: so_matnr FOR mara-matnr MODIF ID mar, " screen 1000 element group1에 들어감
                  so_mtart FOR mara-mtart MODIF ID mar,
                  so_matkl FOR mara-matkl MODIF ID mar,
                  so_ekgrp FOR marc-ekgrp MODIF ID mac.
  PARAMETERS: pa_dispo TYPE marc-dispo    MODIF ID mac,
              pa_dismm TYPE marc-dismm    MODIF ID mac.
SELECTION-SCREEN END OF BLOCK bl3.

*--- PBO
AT SELECTION-SCREEN OUTPUT.
  PERFORM modify_screen.
*&---------------------------------------------------------------------*
*& Form modify_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_screen .
  LOOP AT SCREEN. " screen의 element를 돌려봄
    CASE screen-name.
      WHEN 'PA_PBDNR' OR 'PA_VERSB'.
        screen-input = '0'. " display mode
        MODIFY SCREEN.
    ENDCASE.

    CASE 'X'.
      WHEN pa_crt.
        CASE screen-group1.
          WHEN 'MAC'.
            screen-active = 0. " active mode(hide)'
            MODIFY SCREEN.
        ENDCASE.
      WHEN pa_disp.
        CASE screen-group1.
          WHEN 'MAR'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.
    ENDCASE.
  ENDLOOP.
ENDFORM.
