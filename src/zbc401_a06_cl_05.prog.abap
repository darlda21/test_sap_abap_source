*&---------------------------------------------------------------------*
*& Report ZBC401_T03_CL_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a06_cl_05.

TABLES : sflight.

SELECT-OPTIONS : so_car FOR sflight-carrid.

CLASS c1 DEFINITION.


  PUBLIC SECTION.
    TYPES : BEGIN OF t_sflight,
              carrid TYPE sflight-carrid,
              connid TYPE sflight-connid,
              fldate TYPE sflight-fldate.

    TYPES : END OF t_sflight.

    DATA : gt_itab TYPE TABLE OF t_sflight.
    DATA :gs_itab TYPE t_sflight.

*-- event 선언.
    EVENTS : evt1.

    METHODS : get_data,
              display_data.

*-- handler method선언.
    METHODS : no_data FOR EVENT evt1 OF c1.


ENDCLASS.

CLASS c1 IMPLEMENTATION.


  METHOD : get_data.
    SELECT carrid connid fldate INTO TABLE gt_itab
          FROM sflight WHERE carrid IN so_car.

    IF sy-subrc NE 0.

*-- event trigger
      RAISE EVENT evt1.
    ELSE.
      CALL METHOD display_data.
    ENDIF.

  ENDMETHOD.


  METHOD display_data.

    LOOP AT gt_itab INTO gs_itab.
      WRITE : / gs_itab-carrid, gs_itab-connid, gs_itab-fldate.

    ENDLOOP.
  ENDMETHOD.

  METHOD no_data.
    WRITE : / 'There is no data!'.
  ENDMETHOD.

ENDCLASS.


DATA : go_obj TYPE REF TO c1.

START-OF-SELECTION.

  CREATE OBJECT go_obj.

*--handler method register등록
  SET HANDLER go_obj->no_data FOR go_obj.


  CALL METHOD go_obj->get_data.
