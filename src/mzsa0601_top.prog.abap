*&---------------------------------------------------------------------*
*& Include MZSA0601_TOP                             - Module Pool      SAPMZSA0601
*&---------------------------------------------------------------------*
PROGRAM sapmzsa0601.

" Codition
 DATA gv_pernr TYPE ztsa0001-pernr.

 " employee info
* DATA gs_info TYPE zssa0031.
TABLES zssa0031.            " DATA zssa0031 TYPE zssa0031. 와 동일
                            " TABLES + 일반 structure(nested/deep x)
