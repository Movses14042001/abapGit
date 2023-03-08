CLASS lhc_Orrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Orrder~calculateAmount.

    METHODS calculateOrderId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Orrder~calculateOrderId.

    METHODS setCalendarYear FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Orrder~setCalendarYear.

    METHODS validateDeliveyDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Orrder~validateDeliveyDate.

ENDCLASS.

CLASS lhc_Orrder IMPLEMENTATION.

  METHOD calculateAmount.
  ENDMETHOD.

  METHOD calculateOrderId.
  ENDMETHOD.

  METHOD setCalendarYear.
  ENDMETHOD.

  METHOD validateDeliveyDate.

*   READ ENTITIES OF zbm_i_product IN LOCAL MODE
*    ENTITY Orrder
*     FIELDS ( Orderid DeliveryDate  ) WITH CORRESPONDING #( keys )
*    RESULT DATA(EndDates).
*
*
* LOOP AT EndDates INTO DATA(Enddate).
*
* APPEND VALUE #( %tky = Enddate-%tky
*                 %state_area = 'VALIDATE_END_DATE' )
*                 TO reported-Market.
*
*
*
* IF Enddate-Enddate < Enddate-Startdate.
* APPEND VALUE #( %tky = Enddate-%tky ) TO failed-Market.
*
* APPEND VALUE #( %tky        = Enddate-%tky
*                 %state_area = 'VALIDATE_END_DATE'
*                 %msg        = NEW ZCM_RAP_BM(
*                                 severity = if_abap_behv_message=>severity-error
*                                 textid   = ZCM_RAP_BM=>end_date_before_start_day
*                                 enddate  = Enddate-Enddate )
*                 %element-Enddate = if_abap_behv=>mk-on ) TO reported-Market.
*
* ELSEIF Enddate-Enddate < cl_abap_context_info=>get_system_date( ).
* APPEND VALUE #( %tky = Enddate-%tky ) TO failed-Market.
*
* APPEND VALUE #( %tky        = Enddate-%tky
*                 %state_area = 'VALIDATE_END_DATE'
*                 %msg        = NEW ZCM_RAP_BM(
*                                 severity = if_abap_behv_message=>severity-error
*                                 textid   = ZCM_RAP_BM=>D
*                                 enddate  = Enddate-Enddate )
*                 %element-Enddate = if_abap_behv=>mk-on ) TO reported-Market.
*
*
* ENDIF.
*
* ENDLOOP.


  ENDMETHOD.

ENDCLASS.
