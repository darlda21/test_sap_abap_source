*&---------------------------------------------------------------------*
*& Include          MZSA0601_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE  sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.      " 이전 화면 0 으로 떠나라
*      SET SCREEN 0.
*      LEAVE SCREEN.
    WHEN 'SEARCH'.
*      MESSAGE i000(zmsa06) WITH sy-ucomm.    " test

*      CLEAR zssa0031.                        " 이전 검색 정보가 남아있지 않도록
*      SELECT SINGLE *
*        FROM ztsa0001 "emp table
*        INTO CORRESPONDING FIELDS OF zssa0031 " structure variable
*       WHERE pernr = gv_pernr.

      " 부서 정보 연결해서 데이터 불러오기 (budget, wares)
      " 1. 부서 테이블 select
      " 2. inner join
      PERFORM get_data using gv_pernr
                       CHANGING zssa0031.
      " 3. database view
  ENDCASE.
ENDMODULE.
