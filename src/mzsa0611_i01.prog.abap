*&---------------------------------------------------------------------*
*& Include          MZSA0610_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.   " sy-ucomm
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      " Get Connection Info
      " carrid와 connid가 없을 때 메시지를 띄우기 위해 순서 변경
      PERFORM get_conn_info USING zssa0680-carrid zssa0680-connid
                            CHANGING zssa0682
                                     gv_subrc.
      IF gv_subrc <> 0.
        MESSAGE i016(pn) WITH 'Data is not found'.
        RETURN.
      ENDIF.

      " Get Airline Info
      PERFORM get_airline_info.
    WHEN 'ENTER'.
      MESSAGE s016(pn) WITH 'input enter'.
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
