*&---------------------------------------------------------------------*
*& Include          MZSA0610_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_info.
  CLEAR zssa0681.
  SELECT SINGLE *
    FROM  scarr
    INTO CORRESPONDING FIELDS OF zssa0681
    WHERE carrid = zssa0680-carrid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_conn_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA0680_CARRID
*&      --> ZSSA0680_CONNID
*&      <-- ZSSA0682
*&---------------------------------------------------------------------*
FORM get_conn_info  USING    VALUE(p_carrid)
                             VALUE(p_connid)
                    CHANGING ps_info TYPE zssa0682
                             p_subrc.
  CLEAR: p_subrc, zssa0681, ps_info.
  SELECT SINGLE *
    FROM spfli
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = p_carrid
      AND connid = p_connid.
  IF sy-subrc <> 0.
    p_subrc = 4.  "4: error
    RETURN.
  ENDIF.
ENDFORM.
