*&---------------------------------------------------------------------*
*& Report ZC1R260002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R060005_TOP.
*INCLUDE ZC1R060002_TOP.
*INCLUDE zc1r260002_top                          .    " Global Data

INCLUDE ZC1R060005_S01.
*INCLUDE ZC1R060002_S01.
*INCLUDE zc1r260002_s01                          .  " Selection Screen
INCLUDE ZC1R060005_O01.
*INCLUDE ZC1R060002_O01.
*INCLUDE zc1r260002_o01                          .  " PBO-Modules
INCLUDE ZC1R060005_I01.
*INCLUDE ZC1R060002_I01.
*INCLUDE zc1r260002_i01                          .  " PAI-Modules
INCLUDE ZC1R060005_F01.
*INCLUDE ZC1R060002_F01.
*INCLUDE zc1r260002_f01                          .  " FORM-Routines

*INITIALIZATION.
*  PERFORM init_param.


START-OF-SELECTION.
  PERFORM get_data.

  CALL SCREEN '0100'.
