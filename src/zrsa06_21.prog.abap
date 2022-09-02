*&---------------------------------------------------------------------*
*& Report ZRSA06_21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_21.

DATA: gs_list TYPE scarr,
      gt_list LIKE TABLE OF gs_list.

" endselect도 반복문이다. 되도록이면 사용하지 말 것
*clear: gt_list, gs_list.
*SELECT *
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF gs_list
*  WHERE carrid BETWEEN 'ZZ' AND 'UA'.
*
*  APPEND gs_list TO gt_list.
*  CLEAR gs_list.
*ENDSELECT.

" into table
SELECT *
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE gt_list
  WHERE carrid BETWEEN 'AA' AND 'UA'.


WRITE sy-subrc. " 값이 있는가 (0/etc)
WRITE sy-dbcnt. " 읽은 건 수

cl_demo_output=>display_data( gt_list ).
