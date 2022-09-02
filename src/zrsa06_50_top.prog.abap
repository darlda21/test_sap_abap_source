*&---------------------------------------------------------------------*
*& Include ZRSA06_50_TOP                            - Report ZRSA06_50
*&---------------------------------------------------------------------*
REPORT zrsa06_50.

TABLES: scarr, spfli, sflight.  " 일반적인 구조를 가지고 있는 structure
                                " data scarr type scarr. 타입과 이름이 같은 변수

PARAMETERS: pa_car LIKE scarr-carrid,
            pa_con LIKE spfli-connid.

SELECT-OPTIONS so_dat FOR sflight-fldate.
