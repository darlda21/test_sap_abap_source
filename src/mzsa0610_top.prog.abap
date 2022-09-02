*&---------------------------------------------------------------------*
*& Include MZSA0610_TOP                             - Module Pool      SAPMZSA0610
*&---------------------------------------------------------------------*
PROGRAM sapmzsa0610.

" Common Variable
DATA ok_code TYPE sy-ucomm.   " 일반적으로 기본적으로 선언
DATA gv_subrc TYPE sy-subrc.  " 0 성공 / 0<> 실패

" Condition
TABLES zssa0680.             " use screen: dictionary 기능 사용. 속성을 바꾸지 않는다.
*data gs_cond type zssa0680.  " use abap: 사용자 편의에 맞춰 얼마든지 수정 및 활용할 수 있다.

" Airline Info
TABLES zssa0681.
*DATA gs_airline TYPE zssa0681.

" Connection Info
TABLES zssa0682.
*DATA gs_conn TYPE zssa0682.
