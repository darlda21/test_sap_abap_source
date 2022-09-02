*&---------------------------------------------------------------------*
*& Include ZBC405_SCREEN_A06_S1A_TOP                - Report ZBC405_SCREEN_A06_S1A
*&---------------------------------------------------------------------*
REPORT zbc405_screen_a06_s1a.

* Work Area fo data fetch
DATA: gs_flight TYPE dv_flights.

CONSTANTS gc_mark VALUE 'X'.

SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car,
                so_con FOR gs_flight-connid MEMORY ID con.

SELECT-OPTIONS so_fdt FOR gs_flight-fldate NO-EXTENSION.

SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
  PARAMETERS: pa_all RADIOBUTTON GROUP rd1,
              pa_nat RADIOBUTTON GROUP rd1,
              pa_int RADIOBUTTON GROUP rd1 DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK radio.
