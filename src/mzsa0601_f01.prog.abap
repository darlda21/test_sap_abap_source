*&---------------------------------------------------------------------*
*& Include          MZSA0601_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_PERNR
*&      <-- ZSSA0031
*&---------------------------------------------------------------------*
FORM get_data  USING    VALUE(p_pernr)
               CHANGING ps_info TYPE zssa0031.
  " get emp / dep table
  CLEAR ps_info.
  SELECT SINGLE *
    FROM ztsa0001 AS a INNER JOIN ztsa0002 AS b
      ON a~depid = b~depid
    INTO CORRESPONDING FIELDS OF ps_info " structure variable
   WHERE a~pernr = gv_pernr.

  IF sy-subrc IS NOT INITIAL.
    RETURN. " 결과가 없으면 영역(form)을 빠져나간다.(아래 select문 실행x)
  ENDIF.

  " get dep text(dtext) table
  SELECT SINGLE dtext
    FROM ztsa0002_t
    INTO ps_info-dtext
    WHERE depid = ps_info-depid   " 정확하게 설정하려면 모든 key가 where 조건에 설정되어 있어야 함
      AND spras = sy-langu.       " 언어에 맞춰서 설정

  " get gender text
  " pattern > get_domain_values
  DATA: lt_domain TYPE TABLE OF dd07v,
        ls_domain LIKE LINE OF lt_domain.

  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING                                   " 주는 값
      domname               = 'zdgender_a00'
*     TEXT                  = 'X'
*     FILL_DD07L_TAB        = ' '
   TABLES                                       " = changing??
     values_tab            = lt_domain          " internal table = local table
                                                " lt_domain에는  result가 있다
*     VALUES_DD07L          =
   EXCEPTIONS                                   " 기본적으로 주석 풀기
     no_values_found       = 1
     OTHERS                = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

   READ TABLE lt_domain WITH KEY domvalue_l = ps_info-gender
   INTO ls_domain.
   ps_info-gender_t = ls_domain-ddtext.

*  CASE ps_info-gender.
*    WHEN '1'.
*      ps_info-gender_t = 'Man'(t01).
*    WHEN '2'.
*      ps_info-gender_t = 'Woman'(t02).
*    WHEN OTHERS.
*      ps_info-gender_t = 'None'(t03).
*  ENDCASE.

ENDFORM.
