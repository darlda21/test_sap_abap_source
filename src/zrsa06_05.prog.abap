*&---------------------------------------------------------------------*
*& Report ZRSA06_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_05.

"text symbol
WRITE TEXT-t01. "last name
WRITE 'First Name'(t02).
WRITE 'Over Write'(t02). "overwrite: 출력은 'First Name'. 더블클릭 시 바꾸겠는지 물어봄


"constants: 값을 변경할 수 없음
*CONSTANTS gc_ecode TYPE c LENGTH 4 VALUE 'SYNC'.
*DATA gv_ecode TYPE c LENGTH 4 VALUE 'SYNC'.
*
*WRITE gv_ecode.

"한 가지 타입을 여러 군데서 쓸 때 type을 미리 '정의'
"유지보수가 힘들기 때문에 좁은 범위 내에서만 사용(확실할 때)
"local type: 해당 범위 내에서만 쓸 수 있음
*TYPES t_name TYPE c LENGTH 20.
*t_name = 'Kang'. "type은 value를 가질 수 없음(오류)
*
*DATA gv_name TYPE t_name.
*DATA gv_cname TYPE t_name.
*
*DATA: gv_name TYPE c LENGTH 20,
*      gv_cname LIKE gv_name.



*DATA gv_d1 TYPE d.
*DATA gv_d2 TYPE sy-datum.
*
*WRITE: gv_d1, gv_d2.
