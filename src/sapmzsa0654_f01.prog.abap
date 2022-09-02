*&---------------------------------------------------------------------*
*& Include          SAPMZSA0654_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA06VEN07_CARRID
*&      <-- ZSSA06VEN07_CARRNAME
*&---------------------------------------------------------------------*
FORM get_airline_name  USING    VALUE(p_carrid)
                       CHANGING p_carrname.
  CLEAR p_carrname.           " 공백에 enter 실행 시 이전 값이 남아있지 않도록
  SELECT SINGLE carrname
    FROM scarr
    INTO p_carrname
    WHERE carrid = p_carrid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_mealnum_txt
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA06VEN07_CARRID
*&      --> ZSSA06VEN07_MEALNUMBER
*&      --> SY_LANGU
*&      <-- ZSSA06VEN07_MEALNUMBER_T
*&---------------------------------------------------------------------*
FORM get_mealnum_txt  USING    VALUE(p_carrid)
                               VALUE(p_mealnumber)
                               VALUE(p_langu)
                      CHANGING p_mealnumber_t.
  CLEAR p_mealnumber_t.
  SELECT SINGLE text
    FROM smealt
    INTO p_mealnumber_t
    WHERE carrid = p_carrid         " smealt의 3개의 키값이 전부 일치하는 결과값을 도출
      AND mealnumber = p_mealnumber
      AND sprache = p_langu.
ENDFORM.
