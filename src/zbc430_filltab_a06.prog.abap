*&---------------------------------------------------------------------*
*& Report  SAPBC430S_FILL_CLUSTER_TAB                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  zbc430_filltab_a06                                  .

DATA wa_sbook  TYPE sbook.
DATA wa_spfli  TYPE spfli.
DATA wa_custo TYPE scustom.
DATA wa_sfli TYPE sflight.

DATA my_error TYPE i VALUE 0.


START-OF-SELECTION.

* Replace # by Your user-number and remove all * from here

*  DELETE FROM ztspfli_a06.
*  DELETE FROM ztsbook_a06.
*  DELETE FROM ztscustom_a06.
DELETE FROM ztsflight_a06.

  SELECT * FROM sflight INTO wa_sfli.
    INSERT INTO ztsflight_a06 VALUES wa_sfli.
  ENDSELECT.

*  SELECT * FROM sbook INTO wa_sbook.
*    INSERT INTO ztsbook_a06 VALUES wa_sbook.
*  ENDSELECT.
*
*  IF sy-subrc = 0.
*    SELECT * FROM spfli INTO wa_spfli.
*      INSERT INTO ztspfli_a06 VALUES wa_spfli.
*    ENDSELECT.
*
*    IF sy-subrc = 0.
*
*      SELECT * FROM scustom INTO wa_custo.
*        INSERT INTO ztscustom_a06 VALUES wa_custo.
*      ENDSELECT.
*      IF sy-subrc <> 0.
*        my_error = 1.
*      ENDIF.
*    ELSE.
*      my_error = 2.
*    ENDIF.
*  ELSE.
*    my_error = 3.
*  ENDIF.

  IF my_error = 0.
    WRITE / 'Data transport successfully finished'.
  ELSE.
    WRITE: / 'ERROR:', my_error.
  ENDIF.
