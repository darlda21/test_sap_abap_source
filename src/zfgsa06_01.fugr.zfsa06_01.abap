FUNCTION ZFSA06_01.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PERNR) TYPE  ZSSA0073-PERNR
*"  EXPORTING
*"     REFERENCE(EV_ENAME) TYPE  ZSSA0073-ENAME
*"----------------------------------------------------------------------
  CLEAR ev_ename.
  SELECT SINGLE ename
    FROM ztsa0001
    INTO ev_ename
    WHERE pernr = iv_pernr.
ENDFUNCTION.
