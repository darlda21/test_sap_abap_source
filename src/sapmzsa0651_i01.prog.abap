*&---------------------------------------------------------------------*
*& Include          SAPMZSA0651_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      " Get Airline Name
      PERFORM get_airline_name USING zssa06ven04-carrid
                               CHANGING zssa06ven04-carrname.
      " Get Meal
      PERFORM get_meal_text USING zssa06ven04-carrid        " 세 개의 키가 필요하다. 다른 테이블에 있는 경우
                                  zssa06ven04-mealnumber
                                  sy-langu                  " 언어 키를 어떻게 가져올 지
                            CHANGING zssa06ven04-mealnumber_t.
    WHEN 'SEARCH'.
      PERFORM get_meal_info USING zssa06ven04-carrid
                                  zssa06ven04-mealnumber
                            CHANGING zssa06ven05.

      PERFORM get_vendor_info USING 'M'
                                    zssa06ven04-carrid
                                    zssa06ven04-mealnumber
                              CHANGING zssa06ven06.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
  WHEN 'EXIT'.
    LEAVE PROGRAM.
  WHEN 'CANCEL'.
    LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
