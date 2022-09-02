*&---------------------------------------------------------------------*
*& Include          ZBC405_A03_SOLE01
*&---------------------------------------------------------------------*

START-OF-SELECTION.

SELECT *
  FROM dv_flights
  INTO gs_flight
  WHERE carrid = p_car
    AND connid = p_con
    AND fldate IN s_fldate.   " select절에 option을 쓸 땐 in

  WRITE: /10(5) gs_flight-carrid,                              " 시작 위치(차지하는 공간)
          16(5) gs_flight-connid,
          22(10) gs_flight-fldate,
          gs_flight-countryfr,
          gs_flight-price CURRENCY gs_flight-currency,         " currency: option
          gs_flight-currency.
ENDSELECT.
