*&---------------------------------------------------------------------*
*& Report ZBC401_A06_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a06_main3.

*--------- 내가 만든 글로벌 클래스 참조해서 만들기
* 객체 변수 생성
DATA: go_airplane TYPE REF TO zcl_airplane_a06,
      gt_airplanes TYPE TABLE OF REF TO zcl_airplane_a06.

START-OF-SELECTION.

* 객체 호출
 CALL METHOD zcl_airplane_a06=>display_n_o_airplanes. " lcl_airplane=>display_n_o_airplanes.와 동일
 WRITE /.


*  객체 생성 및 객체 테이블에 추가
 CREATE OBJECT go_airplane EXPORTING iv_name = 'LH Berlin'
                                     iv_planetype = 'A321'
                           EXCEPTIONS wrong_planetype = 1.
  IF sy-subrc EQ 0.
     APPEND go_airplane TO gt_airplanes.
  ENDIF.

 CREATE OBJECT go_airplane EXPORTING iv_name = 'AA New York'
                                     iv_planetype = '747-400'
                           EXCEPTIONS wrong_planetype = 1.
  IF sy-subrc EQ 0.
     APPEND go_airplane TO gt_airplanes.
  ENDIF.

 CREATE OBJECT go_airplane EXPORTING iv_name = 'US Hercules'
                                     iv_planetype = '747-200F'
                           EXCEPTIONS wrong_planetype = 1.
  IF sy-subrc EQ 0.
     APPEND go_airplane TO gt_airplanes.
  ENDIF.


 LOOP AT gt_airplanes INTO go_airplane.
   CALL METHOD go_airplane->display_attributes.
 ENDLOOP.

*  객체 호출
WRITE /.
CALL METHOD zcl_airplane_a06=>display_n_o_airplanes.
