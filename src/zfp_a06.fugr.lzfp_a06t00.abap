*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAPLANE_A06.....................................*
DATA:  BEGIN OF STATUS_ZAPLANE_A06                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAPLANE_A06                   .
CONTROLS: TCTRL_ZAPLANE_A06
            TYPE TABLEVIEW USING SCREEN '0050'.
*...processing: ZSCARR_A06......................................*
DATA:  BEGIN OF STATUS_ZSCARR_A06                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSCARR_A06                    .
CONTROLS: TCTRL_ZSCARR_A06
            TYPE TABLEVIEW USING SCREEN '0034'.
*...processing: ZSFLIGHT_A06....................................*
DATA:  BEGIN OF STATUS_ZSFLIGHT_A06                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSFLIGHT_A06                  .
CONTROLS: TCTRL_ZSFLIGHT_A06
            TYPE TABLEVIEW USING SCREEN '0030'.
*...processing: ZSPFLI_A06......................................*
DATA:  BEGIN OF STATUS_ZSPFLI_A06                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSPFLI_A06                    .
CONTROLS: TCTRL_ZSPFLI_A06
            TYPE TABLEVIEW USING SCREEN '0032'.
*.........table declarations:.................................*
TABLES: *ZAPLANE_A06                   .
TABLES: *ZSCARR_A06                    .
TABLES: *ZSFLIGHT_A06                  .
TABLES: *ZSPFLI_A06                    .
TABLES: ZAPLANE_A06                    .
TABLES: ZSCARR_A06                     .
TABLES: ZSFLIGHT_A06                   .
TABLES: ZSPFLI_A06                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
