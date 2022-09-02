*&---------------------------------------------------------------------*
*& Include          ZBC405_SCREEN_A06_SOLE01
*&---------------------------------------------------------------------*

INITIALIZATION.

  MOVE: 'AA' TO so_car-low,
        'QF' TO so_car-high,
        'BT' TO so_car-option,
        'I' TO so_car-sign.
  APPEND so_car.

  CLEAR so_car.
  MOVE: 'AZ' TO so_car-low,
       'EQ' TO so_car-option,
       'E' TO so_car-sign.
  APPEND so_car.

  " dafalt 값 추가
  CLEAR so_fdt.
  so_fdt-sign = 'I'.
  so_fdt-option = 'BT'.
*  so_fdt-low = sy-datum - 900.
*  so_fdt-high = sy-datum .
  APPEND so_fdt.


START-OF-SELECTION.

  CASE gc_mark.
    WHEN pa_all.
      SELECT *
        FROM dv_flights
        INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom.
      ENDSELECT.
    WHEN pa_nat.
      SELECT *
        FROM dv_flights
        INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto = dv_flights~countryfr.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom.
      ENDSELECT.
    WHEN pa_int.
      SELECT *
        FROM dv_flights
        INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto <> dv_flights~countryfr.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom.
      ENDSELECT.
  ENDCASE.
