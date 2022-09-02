*&---------------------------------------------------------------------*
*& Include          YCL106_001_CLS
*&---------------------------------------------------------------------*
" container
DATA: GR_CON     TYPE REF TO CL_GUI_DOCKING_CONTAINER,
      GR_SPLIT   TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      GR_CON_TOP TYPE REF TO CL_GUI_CONTAINER,
      GR_CON_ALV TYPE REF TO CL_GUI_CONTAINER.

DATA: GR_ALV      TYPE REF TO CL_GUI_ALV_GRID,
      GS_LAYOUT   TYPE LVC_S_LAYO,
      GT_FIELDCAT TYPE LVC_T_FCAT,
      GS_FIELDCAT TYPE LVC_S_FCAT,

      GS_VARIANT  TYPE DISVARIANT,
      GS_SAVE     TYPE C.
