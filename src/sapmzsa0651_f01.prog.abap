*&---------------------------------------------------------------------*
*& Include          SAPMZSA0651_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA06VEN04_CARRID
*&      <-- ZSSA06VEN05_CARRNAME
*&---------------------------------------------------------------------*
FORM get_airline_name  USING    p_carrid
                       CHANGING p_carrname.
  CLEAR p_carrname.
    SELECT SINGLE carrname
      FROM scarr
      INTO p_carrname " 필드가 다르거나 여러개일 때는 ()를 사용할 수 있다
      WHERE carrid = p_carrid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA06VEN04_CARRID
*&      --> ZSSA06VEN04_MEALNUMBER
*&      --> SY_LANGU
*&      <-- ZSSA06VEN04_MEALNUMBER_T
*&---------------------------------------------------------------------*
FORM get_meal_text  USING    VALUE(p_carrid)
                             VALUE(p_mealnumber)
                             VALUE(p_langu)
                    CHANGING VALUE(p_mealnumber_t).
  CLEAR p_mealnumber_t.
  SELECT SINGLE text
    FROM smealt
    INTO p_mealnumber_t
    WHERE carrid = p_carrid
      AND mealnumber = p_mealnumber
      AND sprache = p_langu.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_meal_info USING VALUE(p_carrid)
                         VALUE(p_mealnumber)
                   CHANGING ps_meal_info TYPE zssa06ven05.
  CLEAR ps_meal_info.
  " Meal Info
  SELECT SINGLE *
    FROM smeal
    INTO CORRESPONDING FIELDS OF ps_meal_info
    WHERE carrid = p_carrid
      AND mealnumber = p_mealnumber.

  " Airline Name
  PERFORM get_airline_name USING ps_meal_info-carrid
                           CHANGING ps_meal_info-carrname.

  " Meal Text
  PERFORM get_meal_text USING ps_meal_info-carrid
                              ps_meal_info-mealnumber
                              sy-langu
                        CHANGING ps_meal_info-mealnumber_t.

  " Get Price
  " Flag(V, M), Vendor ID, Airline Code, Meal Number
  DATA ls_vendor_info TYPE zssa06ven06.             " Vendor Info Structure
  PERFORM get_vendor_info USING 'M'                 " Meal Number
                                ps_meal_info-carrid
                                ps_meal_info-mealnumber
                          CHANGING ls_vendor_info.

  ps_meal_info-price = ls_vendor_info-price.
  ps_meal_info-waers = ls_vendor_info-waers.

*  SELECT SINGLE price waers
*    FROM ztsa06ven01  " Vendor Table
*    INTO ( ps_meal_info-price, ps_meal_info-waers )
*    WHERE carrid = ps_meal_info-carrid
*      AND mealnumber = ps_meal_info-mealnumber.
  " Meal Type Text
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_vendor_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> PS_MEAL_INFO_CARRID
*&      --> PS_MEAL_INFO_MEALNUMBER
*&      <-- LS_VENDOR_INFO
*&---------------------------------------------------------------------*
FORM get_vendor_info  USING    VALUE(p_flag)
                               VALUE(p_code1)
                               VALUE(p_code2)
                      CHANGING ps_info TYPE zssa06ven06.
  DATA: BEGIN OF ls_cond,
          lifnr TYPE ztsa06ven01-lifnr,
          carrid TYPE ztsa06ven01-carrid,
          mealno TYPE ztsa06ven01-mealnumber,
        END OF ls_cond.

  CASE p_flag.
    WHEN 'V'. " Vendor
      ls_cond-lifnr = p_code1.  " type 맞추기
    WHEN 'M'. " Meal Number
      ls_cond-carrid = p_code1.
      ls_cond-mealno = p_code2.
      SELECT SINGLE *
        FROM ztsa06ven01
        INTO CORRESPONDING FIELDS OF ps_info
        WHERE carrid = ls_cond-carrid
          AND mealnumber = ls_cond-mealno.
    WHEN OTHERS.
      RETURN.
  ENDCASE.
ENDFORM.
