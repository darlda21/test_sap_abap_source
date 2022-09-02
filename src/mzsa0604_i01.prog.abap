*&---------------------------------------------------------------------*
*& Include          MZSA0604_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
*  MESSAGE i016(pn) WITH sy-ucomm.   " 어떤 명령(sy-ucomm)에 들어와 있는지
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      " get employee name
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.
    WHEN 'SEARCH'.
      " error 처리 방법 중 하나
*      IF zssa0073-pernr is INITIAL.
*        MESSAGE i016(pn) WITH 'Must input personal number'.
*        RETURN. " 제일 가까운 반복문을 빠져나간다. 아래 문자을 실행하지 않을 수 있다.
*      ENDIF.

      " get employee name
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.
      " get empoyee info
      PERFORM get_emp_info USING zssa0073-pernr
                           CHANGING zssa0070.
    WHEN 'DEP'.  " Popup
      " get dep info
      """

      CALL SCREEN 0101 STARTING AT 10 10.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  CASE sy-ucomm.
    WHEN 'CLOSE'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
