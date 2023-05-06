CLASS lhc_Orrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateAmount FOR DETERMINE ON SAVE
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



   READ ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Orrder
   FIELDS ( Netamount Grossamount Quantity  ) WITH CORRESPONDING #( keys )
   RESULT DATA(Orders).

   LOOP AT Orders INTO DATA(order).

   READ ENTITIES OF zbm_i_product IN LOCAL MODE
   ENTITY  Orrder BY \_Product
   FIELDS ( Price Taxrate PriceCurrency ) WITH VALUE #( ( %tky = order-%tky ) )
   RESULT DATA(Products).

   LOOP AT Products INTO DATA(Product).

    Order-Netamount = Product-price * Order-Quantity.

    Order-Grossamount = Order-Netamount + (  Order-Netamount * product-Taxrate / 100 ).


    MODIFY ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Orrder
   UPDATE FIELDS ( Netamount Grossamount Amountcurr ) WITH VALUE #( ( %tky        = Order-%tky
                                                           Netamount   = Order-Netamount
                                                           Grossamount = Order-Grossamount
                                                           Amountcurr  = Product-PriceCurrency

*                                                           %control-netamount = if_abap_behv=>mk-on
*                                                           %control-grossamount = if_abap_behv=>mk-on
*                                                           %control-amountcurrency = if_abap_behv=>mk-on
 ) )
                                                           REPORTED DATA(update_reported).



   reported = CORRESPONDING #( DEEP update_reported ).

   ENDLOOP.


   ENDLOOP.


  ENDMETHOD.

  METHOD calculateOrderId.

   DATA max_orderid TYPE zbam_order_id.
   DATA new_order TYPE TABLE FOR UPDATE zbm_i_product\\Orrder.

   READ ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY  Market BY \_Orrder
   FIELDS ( Orderid ) WITH CORRESPONDING #( keys )
   RESULT DATA(Orders).



*   SELECT MAX( orderid )  FROM ZBM_D_MRKT_ORDER WHERE mrkt_uuid = Orders~
*   INTO @DATA(new_orde1).
*
   Max_orderid = '0000000'.
   LOOP AT Orders INTO DATA(Order).
    IF Order-Orderid > max_orderid.
       max_orderid   = Order-OrderId.
    ENDIF.
   ENDLOOP.


     LOOP AT Orders INTO Order WHERE Orderid IS INITIAL.
          Max_orderid += 1.
        APPEND VALUE #( %tky = Order-%tky
                        OrderId  = max_orderid ) TO new_order.
     ENDLOOP.

     MODIFY ENTITIES OF zbm_i_product IN LOCAL MODE
     ENTITY Orrder
       UPDATE FIELDS ( Orderid ) WITH new_order
       REPORTED DATA(update_reported).


    reported = CORRESPONDING #( DEEP update_reported ).



  ENDMETHOD.

  METHOD setCalendarYear.
  READ ENTITIES OF zbm_i_product IN LOCAL MODE
   ENTITY Orrder
   FIELDS ( CalendarYear ) WITH CORRESPONDING #( keys )
   RESULT DATA(CalendarYears).


   DELETE calendaryears WHERE CalendarYear IS NOT INITIAL.
   CHECK Calendaryears IS NOT INITIAL.


  MODIFY ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Orrder
    UPDATE FIELDS ( CalendarYear )
    WITH VALUE #( FOR calendaryear IN CalendarYears
                  ( %tky           = calendaryear-%tky
                  CalendarYear     = cl_abap_context_info=>get_system_date( ) ) )

   REPORTED DATA(update_reported).
  ENDMETHOD.


  METHOD validateDeliveyDate.

   READ ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Orrder
     FIELDS ( MrktUuid Orderid DeliveryDate  ) WITH CORRESPONDING #( keys )
    RESULT DATA(EndDates).

*
 LOOP AT EndDates INTO DATA(Enddate).

 APPEND VALUE #( %tky = Enddate-%tky
                 %state_area = 'VALIDATE_DELIVERY_DATE' )
                 TO reported-Market.

SELECT FROM zbm_d_prod_mrkt FIELDS startdate, mrkt_uuid
WHERE mrkt_uuid = @Enddate-MrktUuid
INTO TABLE @DATA(StartDates).

*READ ENTITIES OF zbm_i_product IN LOCAL MODE
*    ENTITY Orrder BY \_Market
*    FIELDS ( Startdate MrktUuid ) WITH CORRESPONDING #( keys )
*    RESULT DATA(StartDates).

    LOOP AT StartDates INTO DATA(Startdate).

 IF Startdate-StartDate > Enddate-DeliveryDate.
 APPEND VALUE #( %tky = Enddate-%tky ) TO failed-Orrder.

 APPEND VALUE #( %tky        = Enddate-%tky
                 %state_area = 'VALIDATE_DELIVERY_DATE'
                  %path       = VALUE #( product-%is_draft = Enddate-%is_draft
                                        Product-produuid  = Enddate-produuid
                                        market-%is_draft  = Enddate-%is_draft
                                        market-produuid   = Enddate-produuid )
                 %msg        = NEW ZCM_RAP_BM(
                                 severity = if_abap_behv_message=>severity-error
                                 textid   = ZCM_RAP_BM=>delivery_bfore_start_date
                                 deliverydate  = enddate-DeliveryDate )
                 %element-DeliveryDate = if_abap_behv=>mk-on ) TO reported-Orrder.

 ELSEIF Startdate-StartDate = Enddate-DeliveryDate.
 APPEND VALUE #( %tky = Enddate-%tky ) TO failed-Orrder.

 APPEND VALUE #( %tky        = Enddate-%tky
                 %state_area = 'VALIDATE_DELIVERY_DATE'
                 %path       = VALUE #( product-%is_draft = Enddate-%is_draft
                                        Product-produuid  = Enddate-produuid
                                        market-%is_draft  = Enddate-%is_draft
                                        market-produuid   = Enddate-produuid )
                 %msg        = NEW ZCM_RAP_BM(
                                 severity = if_abap_behv_message=>severity-error
                                 textid   = ZCM_RAP_BM=>delivery_equal_start_date
                                 deliverydate  = Enddate-DeliveryDate )
                 %element-deliverydate = if_abap_behv=>mk-on ) TO reported-Orrder.


 ENDIF.

    ENDLOOP.
 ENDLOOP.


  ENDMETHOD.

ENDCLASS.
