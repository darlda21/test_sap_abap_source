*&---------------------------------------------------------------------*
*& Include          MZSA06023_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_CARRID
*&      <-- GV_CARRNAME
*&---------------------------------------------------------------------*
FORM get_airline_name  USING    value(p_carrid)
                       CHANGING value(p_carrname).
  clear p_carrname.
  SELECT SINGLE carrname
    FROM scarr
    into p_carrname
    WHERE carrid = p_carrid.
ENDFORM.
