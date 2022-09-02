*&---------------------------------------------------------------------*
*& Report ZBC400_06_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_06_01.

PARAMETERS: pa_num1 TYPE i,
            pa_num2 TYPE i,
            pa_op TYPE c. " +, -, /, *

DATA gv_result TYPE i.

CASE pa_op.
  WHEN '+'.
    gv_result = pa_num1 + pa_num2.
  WHEN '-'.
    gv_result = pa_num1 - pa_num2.
  WHEN '/'.
    gv_result = pa_num1 / pa_num2.
  WHEN '*'.
    gv_result = pa_num1 * pa_num2.
  WHEN OTHERS.
    WRITE 'You entered the wrong operation.'.
ENDCASE.

WRITE: 'result is ', gv_result.
CLEAR gv_result.
