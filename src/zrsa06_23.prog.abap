*&---------------------------------------------------------------------*
*& Report ZRSA06_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa06_23_top                           .    " Global Data

* INCLUDE ZRSA06_23_O01                           .  " PBO-Modules
* INCLUDE ZRSA06_23_I01                           .  " PAI-Modules
 INCLUDE zrsa06_23_f01                           .  " FORM-Routines

 " Event
 INITIALIZATION.                " runtime에 딱 한번 실행(TYPE '1')
  IF sy-uname = 'KD-A-06'.      " 대부분 default 설정
    pa_car = 'AA'.
    pa_con = '0017'.
  ENDIF.

*  SELECT SINGLE carrid connid
*    FROM spfli
*    into ( pa_car, pa_con ).

 AT SELECTION-SCREEN OUTPUT.    " PBO(Process Beford Output)
 AT SELECTION-SCREEN.           " PAI(Process After Input)
   IF pa_con is INITIAL.
     MESSAGE e016(pn) with 'Check'. " 주로 e/w message
   ENDIF.

 START-OF-SELECTION.            " event block 시작
                                " 주로 i/s message

 CLEAR gt_info.
 SELECT *
   FROM sflight
   INTO CORRESPONDING FIELDS OF TABLE gt_info
   WHERE carrid = pa_car
     AND connid = pa_con.

   CLEAR gs_info.
   LOOP AT gt_info INTO gs_info.
     " get airline name
     SELECT SINGLE carrname
       FROM scarr
       INTO gs_info-carrname
       WHERE carrid = gs_info-carrid.


     " get connection info
     SELECT SINGLE cityfrom cityto
       FROM spfli
       INTO CORRESPONDING FIELDS OF gs_info " (gs_info-cityfrom, gs_info-cityto)
       WHERE carrid = gs_info-carrid
         AND connid = gs_info-connid.

     MODIFY gt_info FROM gs_info. " INDEX sy-tabix.(생략)
     CLEAR gs_info.
   ENDLOOP.

   WRITE 'Test'.

   IF gt_info IS INITIAL.
     MESSAGE s016(pn) WITH 'Data is not found'. " message class 16번에 있는 i타입 message를 뿌려라
     RETURN.                                    " start-of-selection 구문을 빠져나감
   ENDIF.

   cl_demo_output=>display( gt_info ).
