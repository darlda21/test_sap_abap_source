*&---------------------------------------------------------------------*
*& Report ZRSA06_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_15.

DATA: BEGIN OF gs_std,
        stdno TYPE n LENGTH 8, " initial: '00000000'
        sname TYPE c LENGTH 40,
        gender TYPE c LENGTH 1,
        gender_t TYPE c LENGTH 10, " 사용자를 위한 text. 실제 db엔 없음. 주로 loop에서 처리
      END OF  gs_std.
DATA gt_std LIKE TABLE OF gs_std. " internal table

"Append
gs_std-stdno = '20220001'.
gs_std-sname = 'KANG'.
gs_std-gender = 'M'.
APPEND gs_std TO gt_std. " gt_std: 20220001,KANG,M append

gs_std-sname = 'HAN'.
APPEND gs_std TO gt_std. " gt_std: 20220001,HAN,M append

CLEAR gs_std.
gs_std-sname = 'DA'.
APPEND gs_std TO gt_std. " gt_std: 00000000,DA, append

"read table
CLEAR gs_std.
*READ TABLE gt_std INDEX 1 INTO gs_std.
*READ TABLE gt_std WITH KEY stdno = '20220001' gender = 'M'.      " comma(,)가 필요없으며 자동으로 AND로 연결됨

cl_demo_output=>display_data( gt_std ).

"modify(in loop)
*LOOP AT gt_std INTO gs_std.
*  gs_std-gender_t = TEXT-t01. " 'Male'
*  MODIFY gt_std FROM gs_std.  " INDEX sy-tabix 생략
*  CLEAR gs_std.
*ENDLOOP.
*
*MODIFY gt_std FROM gs_std INDEX 2.

"loop at
*LOOP AT gt_std INTO gs_std.           " gt_std(table) 레코드 값을 gs_std(structure)에 한 줄씩 삽입
*  WRITE: sy-tabix, gs_std-stdno,      " 전체 레코드를 담아가며 structure 출력
*         gs_std-sname, gs_std-gender.
*  NEW-LINE.
*ENDLOOP.
*
*WRITE: / sy-tabix, gs_std-stdno,      " 마지막 structure 값 출력
*         gs_std-sname, gs_std-gender.
