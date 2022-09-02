*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0604
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa0604_top                            .    " Global Data

 INCLUDE mzsa0604_o01                            .  " PBO-Modules
 INCLUDE mzsa0604_i01                            .  " PAI-Modules
 INCLUDE mzsa0604_f01                            .  " FORM-Routines

 LOAD-OF-PROGRAM.                                   " 1번 프로그램 만들 때 initialization과 동일
  PERFORM set_default CHANGING zssa0073.
  CLEAR: gv_r1, gv_r2, gv_r3.   " radio button reset
  gv_r2 = 'X'.                  " set default radio button
