*&---------------------------------------------------------------------*
*& Report ZC1R060007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r060007_top                          .    " Global Data

INCLUDE ZC1R060007_s01                          .  " Screen
INCLUDE ZC1R060007_c01                          .  " Class
INCLUDE zc1r060007_o01                          .  " PBO-Modules
INCLUDE zc1r060007_i01                          .  " PAI-Modules
INCLUDE zc1r060007_f01                          .  " FORM-Routines

START-OF-SELECTION. " 스크린 시작하기 전 한 번
  PERFORM get_data.

  CALL SCREEN '0100'.
