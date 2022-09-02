*&---------------------------------------------------------------------*
*& Report ZRSA06_40
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA06_40_TOP                           .    " Global Data

* INCLUDE ZRSA06_40_O01                           .  " PBO-Modules
* INCLUDE ZRSA06_40_I01                           .  " PAI-Modules
 INCLUDE ZRSA06_40_F01                           .  " FORM-Routines

 INITIALIZATION.                " runtime에 딱 한번 실행(TYPE '1')
  " 1. 조건: 기본값 'D220101' 설정


 AT SELECTION-SCREEN OUTPUT.    " PBO(Process Beford Output)
 AT SELECTION-SCREEN.           " PAI(Process After Input)

 START-OF-SELECTION.            " event block 시작
