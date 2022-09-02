*&---------------------------------------------------------------------*
*& Include          MZSA06023_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      PERFORM get_airline_name USING gv_carrid
                               CHANGING gv_carrname.
      SET SCREEN 200.
      LEAVE SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
*      SET SCREEN 100.
      MESSAGE i000(zmcsa06) WITH 'BACK'.
*      LEAVE SCREEN.           " 목적지를 바꿨을 때 위의 코드는 실행 후 스크린을 떠나라. 아래는 실행할 필요가 없다
      LEAVE TO SCREEN 100.        " leave screen + set screen = 목적지를 정하자마자 바로 떠나세요.
*  	WHEN .
*  	WHEN OTHERS.
  ENDCASE.
ENDMODULE.
