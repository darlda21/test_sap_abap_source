*&---------------------------------------------------------------------*
*& Report ZRSA06_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrca06_24_top                           .    " Global Data

* INCLUDE ZRCA06_24_O01                           .  " PBO-Modules
* INCLUDE ZRCA06_24_I01                           .  " PAI-Modules
 INCLUDE zrca06_24_f01                           .  " FORM-Routines

 " Event
 INITIALIZATION.                " runtime에 딱 한번 실행(TYPE '1')

 AT SELECTION-SCREEN OUTPUT.    " PBO(Process Beford Output)
 AT SELECTION-SCREEN.           " PAI(Process After Input)

 START-OF-SELECTION.            " event block 시작

 CLEAR gt_info.
 SELECT carrid connid fldate price currency seatsocc seatsmax seatsocc_b seatsmax_f seatsocc_f
   FROM sflight
   INTO CORRESPONDING FIELDS OF TABLE gt_info
   WHERE carrid = pa_car
     AND connid BETWEEN pa_con1 AND pa_con2.
*      AND connid IN so_con.

 CLEAR gs_info.
   LOOP AT gt_info INTO gs_info.
     " get carr name
     SELECT SINGLE carrname
       FROM scarr
       INTO CORRESPONDING FIELDS OF gs_info
       WHERE carrid = gs_info-carrid.


     " get connection info
     SELECT SINGLE cityfrom cityto
       FROM spfli
       INTO CORRESPONDING FIELDS OF gs_info " (gs_info-cityfrom, gs_info-cityto)
       WHERE carrid = gs_info-carrid
         AND connid = gs_info-connid.

     " get seat remain
*     SELECT

     MODIFY gt_info FROM gs_info. " INDEX sy-tabix.(생략)
     CLEAR gs_info.
   ENDLOOP.

 cl_demo_output=>display_data( gt_info ).
