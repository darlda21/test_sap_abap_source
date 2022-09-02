*&---------------------------------------------------------------------*
*& Report ZRSA06_50
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa06_50_top                           .    " Global Data

 INCLUDE zrsa06_50_o01                           .  " PBO-Modules
 INCLUDE zrsa06_50_i01                           .  " PAI-Modules
 INCLUDE zrsa06_50_f01                           .  " FORM-Routines

INITIALIZATION.
  " 기본값 설정
  PERFORM set_init.


AT SELECTION-SCREEN OUTPUT.                         "PBO: selection screen을 띄울 때마다 실행됨. enter를 찍어도 실행됨.
  MESSAGE s000(zmcsa06) WITH 'PBO'.

AT SELECTION-SCREEN.                                "PAT

START-OF-SELECTION.

  SELECT SINGLE *
    FROM sflight
*    INTO sflight
    WHERE carrid = pa_car
      AND connid = pa_con
      AND fldate IN so_dat.       "so_dat : 대괄호 생략된 internal table(so_dat[])

  CALL SCREEN 100.
  MESSAGE s000(zmcsa00) WITH 'After call screen'.
