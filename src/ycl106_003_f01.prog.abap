*&---------------------------------------------------------------------*
*& Include          YCL106_002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form REFRESH_GRID_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_GRID_0100 .

  CHECK GR_ALV IS BOUND.

  DATA LS_STABLE TYPE LVC_S_STBL. " 새로고침시 행열 위치 유지
  LS_STABLE-ROW = ABAP_ON.
  LS_STABLE-COL = ABAP_ON.

  CALL METHOD GR_ALV->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE      = LS_STABLE        " With Stable Rows/Columns
      I_SOFT_REFRESH = SPACE            " SPACE: 설정된 필터나, 정렬정보 초기화
      " X: 설정된 필터나 정렬정보 유지
    EXCEPTIONS
      FINISHED       = 1                " Display was Ended (by Export)
      OTHERS         = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  GR_CON = NEW CL_GUI_CUSTOM_CONTAINER(
    CONTAINER_NAME          = 'MY_CONTAINER'
  ).

  CREATE OBJECT GR_ALV
    EXPORTING
      I_PARENT          = GR_CON           " Parent Container
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1                " Error when creating the control
      ERROR_CNTL_INIT   = 2                " Error While Initializing Control
      ERROR_CNTL_LINK   = 3                " Error While Linking Control
      ERROR_DP_CREATE   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  REFRESH GT_SCARR.

  RANGES LR_CARRID FOR SCARR-CARRID.      " SELECT-OPTION과 동일하지만 화면에는 출력되지 않음.
  " HEADER LINE을 가지고 있는 ITAB으로 선언됨
  RANGES LR_CARRNAME FOR SCARR-CARRNAME.

  IF SCARR-CARRID IS INITIAL AND
     SCARR-CARRNAME IS INITIAL.
    " 모두 공란인 경우
  ELSEIF SCARR-CARRID IS INITIAL.
    " 이름은 공란이 아닌 경우
    LR_CARRNAME-SIGN = 'I'.
    LR_CARRNAME-OPTION = 'EQ'.
    LR_CARRNAME-LOW = SCARR-CARRNAME.

    APPEND LR_CARRNAME.
    CLEAR  LR_CARRNAME.

  ELSEIF SCARR-CARRNAME IS INITIAL.
    " ID가 공란이 아닌 경우
    LR_CARRID-SIGN = 'I'.
    LR_CARRID-OPTION = 'EQ'.
    LR_CARRID-LOW = SCARR-CARRID.

    APPEND LR_CARRID.
    CLEAR  LR_CARRID.

  ELSE.
    " 모두 값이 있는 경우
    LR_CARRNAME-SIGN = 'I'.
    LR_CARRNAME-OPTION = 'EQ'.
    LR_CARRNAME-LOW = SCARR-CARRNAME.

    APPEND LR_CARRNAME.
    CLEAR  LR_CARRNAME.

    LR_CARRID-SIGN = 'I'.
    LR_CARRID-OPTION = 'EQ'.
    LR_CARRID-LOW = SCARR-CARRID.

    APPEND LR_CARRID.
    CLEAR  LR_CARRID.

  ENDIF.

  SELECT *
    FROM SCARR
    WHERE CARRID IN @S_CARRID AND
          CARRNAME IN @S_CARRNM
    INTO TABLE @GT_SCARR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA = ABAP_ON.
  GS_LAYOUT-SEL_MODE = 'D'.
  GS_LAYOUT-CWIDTH_OPT = ABAP_ON.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  DATA LT_FIELDCAT TYPE KKBLO_T_FIELDCAT.

  REFRESH GT_FIELDCAT.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID         " Internal table declaration program
*     I_TABNAME              =                  " Name of table to be displayed
      I_STRUCNAME            = 'SCARR'
      I_INCLNAME             = SY-REPID
      I_BYPASSING_BUFFER     = ABAP_ON          " Ignore buffer while reading
      I_BUFFER_ACTIVE        = ABAP_OFF
    CHANGING
      CT_FIELDCAT            = LT_FIELDCAT      " Field Catalog with Field Descriptions
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      OTHERS                 = 2.

  IF LT_FIELDCAT[] IS INITIAL.
    MESSAGE 'ALV FIELDCAT 구성 실패' TYPE 'E'.
  ELSE.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        IT_FIELDCAT_KKBLO = LT_FIELDCAT  " 서로 가지고 있는 속성 정보가 다르기 때문에 변환 필요
      IMPORTING
        ET_FIELDCAT_LVC   = GT_FIELDCAT
      EXCEPTIONS
        IT_DATA_MISSING   = 1
        OTHERS            = 2.

    IF SY-SUBRC <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  CALL METHOD GR_ALV->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT       = GS_LAYOUT
    CHANGING
      IT_OUTTAB       = GT_SCARR[]
      IT_FIELDCATALOG = GT_FIELDCAT[].

ENDFORM.
