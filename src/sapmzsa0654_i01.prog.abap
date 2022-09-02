*&---------------------------------------------------------------------*
*& Include          SAPMZSA0654_I01
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
      PERFORM get_airline_name USING zssa06ven07-carrid
                               CHANGING zssa06ven07-carrname.

      " Get MealNumber Text
      PERFORM get_mealnum_txt USING zssa06ven07-carrid zssa06ven07-mealnumber sy-langu
                              CHANGING zssa06ven07-mealnumber_t.

    WHEN 'SEARCH'.
      " Get Flight Meal Info
      " Get Meal Info
      SELECT SINGLE *
        FROM smeal
        INTO CORRESPONDING FIELDS OF zssa06ven08
        WHERE carrid = zssa06ven07-carrid
          AND mealnumber = zssa06ven07-mealnumber.

      " Get Airline Name
      PERFORM get_airline_name USING zssa06ven07-carrid
                               CHANGING zssa06ven08-carrname.

      " Get Meal Number Text
      PERFORM get_mealnum_txt USING zssa06ven07-carrid zssa06ven07-mealnumber sy-langu
                              CHANGING zssa06ven08-mealnumber_t.

      " Get Meal Type Text
      " Get Meal Price Info

      " Get Vendor Info
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
