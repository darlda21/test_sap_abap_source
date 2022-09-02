*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0602
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE sapmzsa0602_top                         .    " Global Data

 INCLUDE sapmzsa0602_o01                         .  " PBO-Modules
 INCLUDE sapmzsa0602_i01                         .  " PAI-Modules
 INCLUDE sapmzsa0602_f01                         .  " FORM-Routines

 LOAD-OF-PROGRAM.
  PERFORM set_default.
