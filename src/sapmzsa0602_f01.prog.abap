*&---------------------------------------------------------------------*
*& Include          SAPMZSA0602_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_default .
  CLEAR zssa0650.
  SELECT SINGLE *
    FROM spfli
    INTO CORRESPONDING FIELDS OF zssa0650.
ENDFORM.
