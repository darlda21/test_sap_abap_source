*&---------------------------------------------------------------------*
*& Include          YCL106_002_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.
  SAVE_OK = OK_CODE. CLEAR OK_CODE.

  CASE SAVE_OK.
    WHEN 'EXIT'. LEAVE PROGRAM.     " 프로그램 종료
    WHEN 'CANC'. LEAVE TO SCREEN 0. " 뒤로가기
    WHEN OTHERS. OK_CODE = SAVE_OK.
  ENDCASE.

  CLEAR SAVE_OK.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  SAVE_OK = OK_CODE. CLEAR OK_CODE.

  CASE SAVE_OK.
    WHEN 'BACK'. LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      PERFORM SELECT_DATA.
      PERFORM SET_ALV_LAYOUT_0100.
      PERFORM SET_ALV_FIELDCAT_0100.
      PERFORM DISPLAY_ALV_0100.
    WHEN OTHERS. OK_CODE = SAVE_OK.
  ENDCASE.

  CLEAR SAVE_OK.

ENDMODULE.
