*&---------------------------------------------------------------------*
*& Include          SAPMZSA0650_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_vendor_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA06VEN01_CARRID
*&      --> ZSSA06VEN01_MEALNUMBER
*&      <-- ZSSA06VEN03
*&---------------------------------------------------------------------*
FORM get_vendor_info  USING    VALUE(p_carrid)
                               VALUE(p_mealnumber)
                      CHANGING ps_info TYPE zssa06ven03.
  CLEAR: ps_info.

  SELECT SINGLE *
    FROM ztsa06ven
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = p_carrid
      AND mealnumber = p_mealnumber.

  SELECT SINGLE *
    from t005t
    into CORRESPONDING FIELDS OF ps_info
    WHERE land1 = ps_info-land1.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_fmeal_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA06VEN01
*&      <-- ZSSA06VEN02
*&---------------------------------------------------------------------*
FORM get_fmeal_info  USING    VALUE(ps_carrid)
                              VALUE(ps_mealnumber)
                     CHANGING ps_info TYPE zssa06ven02.
  CLEAR ps_info.

  SELECT SINGLE *
  FROM ztsa06ven
  INTO CORRESPONDING FIELDS OF ps_info
  WHERE carrid = ps_carrid
    AND mealnumber = ps_mealnumber.

  SELECT SINGLE carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = ps_carrid.

  SELECT SINGLE mealtype
    FROM smeal
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = ps_carrid
      AND mealnumber = ps_mealnumber.

  SELECT SINGLE text
    FROM smealt
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = ps_carrid
      AND mealnumber = ps_mealnumber.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_fvalue
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA06VEN01_MEALTYPE
*&      <-- ZSSA06VEN01_MEALTYPET
*&---------------------------------------------------------------------*
FORM get_fvalue  USING    p_mealtype
                 CHANGING p_mealtypet.
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname               = p_mealtype
*     TEXT                  = 'X'
*     FILL_DD07L_TAB        = ' '
*   TABLES
     VALUES_TAB            = p_mealtypet
*     VALUES_DD07L          =
   EXCEPTIONS
     NO_VALUES_FOUND       = 1
     OTHERS                = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
