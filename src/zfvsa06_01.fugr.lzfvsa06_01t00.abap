*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA0604........................................*
TABLES: ZVSA0604, *ZVSA0604. "view work areas
CONTROLS: TCTRL_ZVSA0604
TYPE TABLEVIEW USING SCREEN '0020'.
DATA: BEGIN OF STATUS_ZVSA0604. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA0604.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA0604_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA0604.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA0604_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA0604_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA0604.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA0604_TOTAL.

*...processing: ZVSA06PRO.......................................*
TABLES: ZVSA06PRO, *ZVSA06PRO. "view work areas
CONTROLS: TCTRL_ZVSA06PRO
TYPE TABLEVIEW USING SCREEN '0030'.
DATA: BEGIN OF STATUS_ZVSA06PRO. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA06PRO.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA06PRO_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA06PRO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA06PRO_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA06PRO_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA06PRO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA06PRO_TOTAL.

*...processing: ZVSA06VEN01.....................................*
TABLES: ZVSA06VEN01, *ZVSA06VEN01. "view work areas
CONTROLS: TCTRL_ZVSA06VEN01
TYPE TABLEVIEW USING SCREEN '0040'.
DATA: BEGIN OF STATUS_ZVSA06VEN01. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA06VEN01.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA06VEN01_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA06VEN01.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA06VEN01_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA06VEN01_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA06VEN01.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA06VEN01_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA0602                       .
TABLES: ZTSA0602_T                     .
TABLES: ZTSA06PRO                      .
TABLES: ZTSA06PRO_T                    .
TABLES: ZTSA06VEN01                    .
