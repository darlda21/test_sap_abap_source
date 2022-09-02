*&---------------------------------------------------------------------*
*& Include MZSA0604_TOP                             - Module Pool      SAPMZSA0604
*&---------------------------------------------------------------------*
PROGRAM sapmzsa0604.

" condition: 한 개의 조건만 쓰이는 경우는 거의 없으므로 되도록이면 structure로 사용.
" 같은 변수지만 용도가 다르므로 두 가지 다 정의하는 것을 추천
TABLES zssa0073.
DATA gs_cond TYPE zssa0073.

" emp info
TABLES zssa0070.
DATA gs_emp TYPE zssa0070.

" dep info
TABLES zssa0071.
DATA gs_dep TYPE zssa0071.
