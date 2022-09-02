*&---------------------------------------------------------------------*
*& Include BC405_SCREEN_S1B_E01                                        *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&   Event INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
*Initialize push button state
  push_btn = 'Hide''t'.
  gv_change = 1.    " toggle state: 1(show)

* Initialize select-options for CARRID" OPTIONAL
  MOVE: 'AA' TO so_car-low,
        'QF' TO so_car-high,
        'BT' TO so_car-option,
        'I'  TO so_car-sign.
  APPEND so_car.

  CLEAR so_car.
  MOVE: 'AZ' TO so_car-low,
        'EQ' TO so_car-option,
        'E'  TO so_car-sign.
  APPEND so_car.

* Set texts for tabstrip pushbuttons
  tab1 = 'Connections'(tl1).
  tab2 = 'Date'(tl2).
  tab3 = 'Type of flight'(tl3).
  " 추가
  tab4 = 'Country From'.

* Set second tab page as initial tab
  airlines-activetab = 'TYPE'.
  airlines-dynnr     = '1300'.

* push button
AT SELECTION-SCREEN.        " PAI: 이벤트 등 처리로직
  " push btn toggle(state change) logic
  CASE sscrfields-ucomm.
    WHEN 'DETAILS'.
      CHECK sy-dynnr = '1400'.  " true일 때 다름 logic 실행
      IF gv_change = '1'.
        gv_change = '0'.
      ELSE.
        gv_change = '1'.
      ENDIF.
    WHEN OTHERS.
    MESSAGE i100(zt03_asg) WITH 'This is push button'.
  ENDCASE.


at SELECTION-SCREEN OUTPUT.   " PBO: 화면이 바뀌었을 때 결과
  IF sy-dynnr = '1400'.
    " 화면 상태 modify
    LOOP AT SCREEN.                 " screen element에 접근하려면 사용
      IF screen-group1 = 'DET'.
        screen-active = gv_change.  " 1: active, 0: inactive.
        MODIFY SCREEN.              " 적용
      ENDIF.
    ENDLOOP.
    " ptn text change
    IF gv_change = '1'.
      push_btn = 'Hide'.
    else.
      push_btn = 'Show'.
    ENDIF.

  ENDIF.
*----------------------------------------------------------------------*
START-OF-SELECTION.
* Checking the output parameters
  CASE gc_mark.
    WHEN pa_all.
*     Radiobutton ALL is marked
      SELECT * FROM dv_flights INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          " 조건 추가
          AND countryfr IN s_confr
          AND cityfrom IN s_cityfr.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom,
                 gs_flight-airpfrom,
                 gs_flight-countryto,
                 gs_flight-cityto,
                 gs_flight-airpto,
                 gs_flight-seatsmax,
                 gs_flight-seatsocc.
      ENDSELECT.
    WHEN pa_nat.
*     Radiobutton NATIONAL is marked
      SELECT * FROM dv_flights INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto = dv_flights~countryfr.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom,
                 gs_flight-airpfrom,
                 gs_flight-countryto,
                 gs_flight-cityto,
                 gs_flight-airpto,
                 gs_flight-seatsmax,
                 gs_flight-seatsocc.
      ENDSELECT.
    WHEN pa_int.
*     Radiobutton INTERNAT is marked
      SELECT * FROM dv_flights INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto <> dv_flights~countryfr.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom,
                 gs_flight-airpfrom,
                 gs_flight-countryto,
                 gs_flight-cityto,
                 gs_flight-airpto,
                 gs_flight-seatsmax,
                 gs_flight-seatsocc.
      ENDSELECT.
  ENDCASE.
