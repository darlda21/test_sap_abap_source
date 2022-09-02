*&---------------------------------------------------------------------*
*& Include          SAPMZSA0650_I01
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
    WHEN 'SEARCH'.
      " Get Flight Meal Info
      PERFORM get_fmeal_info USING zssa06ven01-carrid zssa06ven01-mealnumber
                             CHANGING zssa06ven02.

      " Get Vendor Info
      PERFORM get_vendor_info USING zssa06ven01-carrid zssa06ven01-mealnumber
                              CHANGING zssa06ven03.
      " Get Fixed Value
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
