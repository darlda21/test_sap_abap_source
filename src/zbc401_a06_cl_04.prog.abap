*&---------------------------------------------------------------------*
*& Report ZBC401_T03_CL_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a06_cl_04.


CLASS cl1 DEFINITION.

  PUBLIC SECTION.
    EVENTS evt1.      "event 선언

    METHODS : met_evt FOR EVENT evt1 OF cl1 .

    METHODS : trig_met.

ENDCLASS.

CLASS cl1 IMPLEMENTATION.

  METHOD : met_evt.
    WRITE : / 'execute event method'.
  ENDMETHOD.

  METHOD trig_met.
    WRITE : / 'execute trigger event'.
    RAISE EVENT evt1.
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.

  DATA : obj TYPE REF TO cl1.

  CREATE OBJECT obj.

  SET HANDLER obj->met_evt FOR obj.

  CALL METHOD obj->trig_met.
