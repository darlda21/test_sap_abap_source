*&---------------------------------------------------------------------*
*& Report ZBC401_A06_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a06_main2.

TYPE-POOLS icon. " type group에 정의된 icon type. 그냥 가져와서 상수처럼 쓸 수 있다

* 클래스 정의
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    " constructor: set_attributes와 동일한 기능
    METHODS: constructor IMPORTING iv_name TYPE string
                                   iv_planetype TYPE saplane-planetype
                         EXCEPTIONS wrong_planetype.

    " instance method: go_ -> method
    METHODS: set_attributes
      IMPORTING iv_name TYPE string
                iv_planetype TYPE saplane-planetype,
             display_attributes.
    " static method: lcl_ => method
    CLASS-METHODS: display_n_o_airplanes,
                   get_n_o_airplanes RETURNING VALUE(rv_count) TYPE i. " functional method
    " static constructor: 프로그램 실행되자마자 1회 자동 실행                                                                   " returning value로 값이 return
    CLASS-METHODS class_constructor.  " param 없음
  PRIVATE SECTION.
    DATA: mv_name TYPE string,
          mv_planetype TYPE saplane-planetype,
          mv_weight TYPE saplane-weight,
          mv_tankcap TYPE saplane-tankcap.

    TYPES: ty_planetype TYPE TABLE OF saplane.

    " static data
    CLASS-DATA: gv_n_o_airplanes TYPE i,
                gv_planetypes TYPE ty_planetype.
    CONSTANTS: c_pos_1 TYPE i VALUE 30. " 출력할 위치

    CLASS-METHODS get_technical_attributes IMPORTING iv_type TYPE saplane-planetype
                                           EXPORTING ev_weight TYPE saplane-weight
                                                     ev_tankcap TYPE saplane-tankcap
                                           EXCEPTIONS wrong_planetype.

ENDCLASS.

* 클래스 속성 정의: 메소드 정의
CLASS lcl_airplane IMPLEMENTATION.
  METHOD get_technical_attributes.
    DATA ls_planetype TYPE saplane.

    READ TABLE gv_planetypes INTO ls_planetype WITH KEY planetype = iv_type.

    IF sy-subrc EQ 0.
      ev_weight = ls_planetype-weight.
      ev_tankcap = ls_planetype-tankcap.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.
  ENDMETHOD.

  METHOD class_constructor.
    SELECT *
      INTO TABLE gv_planetypes
      FROM saplane.
  ENDMETHOD.

  METHOD constructor.
    " 기종과 이름을 받아서 count
    DATA ls_planetype TYPE saplane.

    mv_name = iv_name.
    mv_planetype = iv_planetype.

    " 이 부분을 perform(get_technical_attributes)으로 바꿔서 class_constructor에서도 적용
*    SELECT SINGLE *
*      INTO ls_planetype
*      FROM saplane
*      WHERE planetype = iv_planetype.
*
*    IF sy-subrc NE 0.
*      RAISE wrong_planetype.
*    ELSE.
*      mv_weight = ls_planetype-weight.
*      mv_tankcap = ls_planetype-tankcap.
*      gv_n_o_airplanes = gv_n_o_airplanes + 1.
*    ENDIF.

    CALL METHOD get_technical_attributes
      EXPORTING
        iv_type = iv_planetype
      IMPORTING
        ev_weight = mv_weight
        ev_tankcap = mv_tankcap
      EXCEPTIONS
        wrong_planetype = 1.

    IF sy-subrc EQ 0.
      gv_n_o_airplanes = gv_n_o_airplanes + 1.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.
  ENDMETHOD.

  METHOD set_attributes.
    " 기종과 이름을 받아서 count
    mv_name = iv_name.
    mv_planetype = iv_planetype.

    gv_n_o_airplanes = gv_n_o_airplanes + 1.
  ENDMETHOD.

  METHOD display_attributes.
    " 결과 출력: 항공사 이름, 비행기 타입
    WRITE: / icon_ws_plane AS ICON,
           / 'Name of Airplane', AT c_pos_1 mv_name,
           / 'Type of Airplane: ', AT c_pos_1 mv_planetype,
           / 'Weight: ', AT c_pos_1 mv_weight,
           / 'Tank capacity: ', AT c_pos_1 mv_tankcap.
  ENDMETHOD.

  METHOD display_n_o_airplanes.
    " 결과 출력: 비행기 개수
    SKIP.
    WRITE: / 'Number of airplanes: ', AT c_pos_1 gv_n_o_airplanes LEFT-JUSTIFIED.
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    " 현재 가지고 있는 비행기 대수 get
    rv_count = gv_n_o_airplanes.
  ENDMETHOD.
ENDCLASS.

* 객체 변수 생성
DATA: go_airplane TYPE REF TO lcl_airplane,
      gt_airplanes TYPE TABLE OF REF TO lcl_airplane.

START-OF-SELECTION.

* 객체 호출
 CALL METHOD lcl_airplane=>display_n_o_airplanes( ). " lcl_airplane=>display_n_o_airplanes.와 동일
 WRITE /.


*  객체 생성 및 객체 테이블에 추가
 CREATE OBJECT go_airplane EXPORTING iv_name = 'LH Berlin'
                                     iv_planetype = 'A321'
                           EXCEPTIONS wrong_planetype = 1.
  IF sy-subrc EQ 0.
     APPEND go_airplane TO gt_airplanes.
  ENDIF.
 " set attribute
* CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name = 'LH Berlin'
*      iv_planetype = 'A321'.

 CREATE OBJECT go_airplane EXPORTING iv_name = 'AA New York'
                                     iv_planetype = '747-400'
                           EXCEPTIONS wrong_planetype = 1.
  IF sy-subrc EQ 0.
     APPEND go_airplane TO gt_airplanes.
  ENDIF.
 " set attribute
* CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name = 'AA New York'
*      iv_planetype = '747-400'.

 CREATE OBJECT go_airplane EXPORTING iv_name = 'US Hercules'
                                     iv_planetype = '747-200F'
                           EXCEPTIONS wrong_planetype = 1.
  IF sy-subrc EQ 0.
     APPEND go_airplane TO gt_airplanes.
  ENDIF.
 " set attribute
* CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name = 'US Hercules'
*      iv_planetype = '747-200F'.


 LOOP AT gt_airplanes INTO go_airplane.
   CALL METHOD go_airplane->display_attributes.
 ENDLOOP.

*  객체 호출
  DATA: gv_count TYPE i.
  gv_count = lcl_airplane=>get_n_o_airplanes( ). " 변수에 바로 return
  WRITE: /,/ 'Number of airplanes: ', gv_count.
