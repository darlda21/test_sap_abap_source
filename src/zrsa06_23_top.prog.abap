*&---------------------------------------------------------------------*
*& Include ZRSA06_23_TOP                            - Report ZRSA06_23
*&---------------------------------------------------------------------*
REPORT zrsa06_23.

" schedule data info
DATA: gt_info TYPE TABLE OF zsinfo00,
      gs_info LIKE LINE OF gt_info.

" selection screen(global variable)
" 여기서 DEFAULT로 default value를 설정할 수도 있지만 주로 INITIALIZATION에서 설정
PARAMETERS: pa_car LIKE sbook-carrid,
            pa_con LIKE sbook-connid.
