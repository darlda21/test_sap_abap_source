*&---------------------------------------------------------------------*
*& Report ZBC401_T03_CL_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a06_cl_01.
*
*
*Calls a static method of a superclass using the name of a subclass.
*Before the method is executed, the static constructor of the superclass is executed,
*but not the static constructor of the subclass.
*The method returns the value that is set in the superclass.

CLASS c1 DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA     a1 TYPE string.
    CLASS-METHODS: class_constructor,
      m1 RETURNING VALUE(r1) LIKE a1.
ENDCLASS.

CLASS c1 IMPLEMENTATION.
  METHOD class_constructor.
    a1 = 'c1'.
    WRITE : / a1.
  ENDMETHOD.
  METHOD m1.
    r1 = a1.
  ENDMETHOD.
ENDCLASS.

CLASS c2 DEFINITION INHERITING FROM c1.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.

    CLASS-METHODS:
      m2 RETURNING VALUE(r2) LIKE a1.


ENDCLASS.

CLASS c2 IMPLEMENTATION.
  METHOD class_constructor.
    a1 = 'c2'.
    WRITE : / a1.
  ENDMETHOD.

  METHOD m2.
    r2 = a1.
  ENDMETHOD.


ENDCLASS.

DATA v1 TYPE string.

DATA v2 TYPE string.

START-OF-SELECTION.

*----

*  v1 = c2=>m1( ).
*
*  WRITE : / v1.


*------

  v2 = c2=>m2( ).

  WRITE : / v2.



*
*  c2=>a1 = 'Hello everyone'.
*
*  MESSAGE c2=>a1 TYPE 'I'.
