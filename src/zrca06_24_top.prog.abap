*&---------------------------------------------------------------------*
*& Include ZRCA06_24_TOP                            - Report ZRSA06_24
*&---------------------------------------------------------------------*
REPORT zrsa06_24.

"sflight info
TYPES: BEGIN OF ts_info,
        carrid TYPE sflight-carrid,         " key
        carrname TYPE scarr-carrname,       " key
        connid TYPE sflight-connid,         " key
        cityfrom TYPE spfli-cityfrom,
        cityto TYPE spfli-cityto,
        fldate TYPE sflight-fldate,
        price TYPE sflight-price,
        currency TYPE sflight-currency,
        seatsmax TYPE sflight-seatsmax,
        seatsocc TYPE sflight-seatsocc,
        seatremain TYPE i,
        seatsmax_b TYPE sflight-seatsmax_b,
        seatsocc_b TYPE sflight-seatsocc_b,
        seatremain_b TYPE i,
        seatsmax_f TYPE sflight-seatsmax_f,
        seatsocc_f TYPE sflight-seatsocc_f,
        seatremain_f TYPE i,
      END OF ts_info,
      tt_info TYPE TABLE OF ts_info.        " table type

DATA: gt_info type TABLE OF zssa0602,       " structure type
*      gt_info TYPE tt_info,
      gs_info LIKE LINE OF gt_info.

" mine
*DATA: gs_info TYPE ts_info,
*      gt_info LIKE TABLE OF gs_info.

"paramaters(selection screen)
PARAMETERS: pa_car LIKE gs_info-carrid,     " 항공사 코드
            pa_con1 LIKE gs_info-connid,    " 항공편 번호1
            pa_con2 LIKE gs_info-connid.    " 항공편 번호2

*SELECT-OPTIONS so_con FOR gs_info-connid. " internal table(so_con), variable(gs_info-connid)
