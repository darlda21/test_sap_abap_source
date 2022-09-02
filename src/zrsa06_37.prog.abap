*&---------------------------------------------------------------------*
*& Report ZRSA06_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_37.


DATA: gs_info TYPE zvsa0601,   " Database View(Sructure Type)
      gt_info LIKE TABLE OF gs_info.

*PARAMETERS pa_dep LIKE gs_info-depid.

START-OF-SELECTION.
  " Inner Join
*  SELECT *
*    FROM ztsa0601 INNER JOIN ztsa0602
*      ON ztsa0601~depid = ztsa0602~dpid               " 잘 못찾는 경우가 많아 ~을 사용
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*    WHERE ztsa0601~depid = pa_dep.                    " 주로 첫번째 테이블 사용

*  SELECT a~pernr a~ename a~depid b~dpcall             " 주로 ~로 갖고 온다
*    FROM ztsa0601 AS a INNER JOIN ztsa0602 AS b       " 별명(alias)
*      ON a~depid = b~dpid                             " 연결고리, 연결조건
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*    WHERE a~depid = pa_dep.

  SELECT *
    FROM ztsa0601 AS emp LEFT OUTER JOIN ztsa0602 AS dep
      ON  emp~depid = dep~dpid
    INTO CORRESPONDING FIELDS OF TABLE gt_info.


   " Open SQL
*  SELECT *
*    FROM zvsa0601
*    INTO CORRESPONDING FIELDS OF TABLE gt_info.
*    WHERE depid = pa_dep.

  cl_demo_output=>display_data( gt_info ).
