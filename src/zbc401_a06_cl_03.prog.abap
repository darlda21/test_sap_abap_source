*&---------------------------------------------------------------------*
*& Report ZBC401_T03_CL_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a06_cl_03.
" 강사님꺼 다시 복사하기. 추가된 내용 있음

CLASS cl_1 DEFINITION.
  PUBLIC SECTION.
    DATA: num1 TYPE i.
    METHODS: pro IMPORTING num2 TYPE i.
    EVENTS: cutoff. " event 정의, 설정
ENDCLASS.


CLASS cl_1 IMPLEMENTATION.
  METHOD pro.
    num1 = num2.
    IF num2 >= 2.
      RAISE EVENT cutoff. " event trigger 시점
    ENDIF.
  ENDMETHOD.
ENDCLASS.


CLASS CL_event DEFINITION.
  PUBLIC SECTION.
    METHODS: handling_CUTOFF FOR EVENT cutoff OF cl_1. " 이벤트를 재정의, 가져가 쓰는 부분
ENDCLASS.


CLASS CL_event IMPLEMENTATION.
  METHOD handling_CUTOFF.
    WRITE: 'Handling the CutOff'.
    WRITE: / 'Event has been processed'.
  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  DATA: main1 TYPE REF TO cl_1.
  DATA: eventh1 TYPE REF TO CL_event.

  CREATE OBJECT main1.
  CREATE OBJECT eventh1.

  SET HANDLER eventh1->handling_CUTOFF FOR main1. " 이벤트 등록
  main1->PRO( 4 ).
