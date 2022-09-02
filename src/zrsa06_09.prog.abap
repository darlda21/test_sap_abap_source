*&---------------------------------------------------------------------*
*& Report ZRSA06_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa06_09.

DATA: gv_a TYPE i,
      gv_b LIKE gv_a,
      gv_r LIKE gv_b.

gv_a = 10.
gv_b = 20.

" Subroutine
PERFORM cal USING gv_a gv_b
            CHANGING gv_r.

WRITE gv_r.

" call by value and result
" using: gv_a의 value값을 가져와 value(p_a)에 저장
" changing: result인 value(p_r)값을 전달
FORM cal USING VALUE(p_a)
               VALUE(p_b)
         CHANGING
               VALUE(p_r).
  p_r = p_a + p_b.
ENDFORM.
