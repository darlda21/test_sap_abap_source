*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0604
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA0605_TOP.
*INCLUDE mzsa0604_top                            .    " Global Data

INCLUDE MZSA0605_O01.
* INCLUDE mzsa0604_o01                            .  " PBO-Modules
INCLUDE MZSA0605_I01.
* INCLUDE mzsa0604_i01                            .  " PAI-Modules
INCLUDE MZSA0605_F01.
* INCLUDE mzsa0604_f01                            .  " FORM-Routines

 LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.
