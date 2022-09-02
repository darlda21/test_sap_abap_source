*&---------------------------------------------------------------------*
*& Include ZBC405_A06_SOL_TOP                       - Report ZBC405_A06_SOL
*&---------------------------------------------------------------------*
REPORT zbc405_a06_sol.

DATA gs_flight TYPE dv_flights. " gs_flight: line type, dv_flights: db view type(여러 테이블이 join 되어 있음)

PARAMETERS p_car TYPE dv_flights-carrid  " type, like 사용 가능. 숫자인 경우 decimal option 사용 가능
                 MEMORY ID car           " parameter id option(sap M), 같은 M을 쓰는 p은 M을 공유할 수 있다
                 VALUE CHECK.            " value check: foreign key > domain > value table에 없는 값은 입력할 수 없다

PARAMETERS p_con TYPE s_conn_id
                 MEMORY ID con
                 OBLIGATORY       " obligatory: 필수값. 입력하지 않으면 실행 불가. 입력창에 체크표시
                 DEFAULT 'LH'.    " default

SET PARAMETER ID 'Z01' FIELD p_car. " parameter id(M) 생성 및 설정
GET PARAMETER ID 'Z01' FIELD p_car. " 해당 id의 M을 가져옴

PARAMETERS p_str TYPE string LOWER CASE.  " lower case: case sensititve, 소문자 인식 가능, enter를 쳐도 대문자로 바뀌지 않는다.

PARAMETERS p_chk AS CHECKBOX DEFAULT 'X' " 'x': true
                 MODIF ID mod.           "

PARAMETERS: p_rad1 RADIOBUTTON GROUP rd,
            p_rad2 RADIOBUTTON GROUP rd,
            p_rad3 RADIOBUTTON GROUP rd.

SELECT-OPTIONS: s_fldate FOR dv_flights-fldate.

" radio buttion이 눌렸을 때 제어
CASE 'X'.
  WHEN p_rad1.
  WHEN p_rad2.
  WHEN p_rad3.
ENDCASE.

" p가 실행되면서 자동 실행되는 screen internal table(structure)의 component가 modif id
" id를 주고 screen modify(보이게/안보이게) 가능
" 화면 수정 가능
*INITIALIZATION.
*
*LOOP AT SCREEN.
*  IF screen-group1 = 'MOD'. "'MOD'란 id를 가진 컴포넌트는 항상 output만 가능
*    screen-input = 0.       "inactive
*    screen-output = 1.      " active
*    MODIFY SCREEN.
*  ENDIF.
*ENDLOOP.

INITIALIZATION.
  s_fldate-low = sy-datum.
  s_fldate-high = sy-datum + 30.

  s_fldate-sign = 'I'.
  s_fldate-option = 'BT'.

  APPEND s_fldate. " 자신을 append. 스스로가 work area가 될 수 있다는 뜻
