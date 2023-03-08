CLASS lhc_Market DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Market RESULT result.

    METHODS confirm FOR MODIFY
      IMPORTING keys FOR ACTION Market~confirm RESULT result.

    METHODS checkDuplicates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Market~checkDuplicates.

    METHODS validateMarket FOR VALIDATE ON SAVE
      IMPORTING keys FOR Market~validateMarket.

    METHODS valideEndDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Market~valideEndDate.

    METHODS valideStartDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Market~valideStartDate.

ENDCLASS.

CLASS lhc_Market IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD confirm.
  ENDMETHOD.

  METHOD checkDuplicates.
  ENDMETHOD.

  METHOD validateMarket.



  READ ENTITIES OF zbm_i_product IN LOCAL MODE
     ENTITY Market
       FIELDS ( Mrktid ) WITH CORRESPONDING #( keys )
     RESULT DATA(Markets).


    DATA Marknames TYPE SORTED TABLE OF zbm_i_market_t WITH UNIQUE KEY Mrktid.



      Marknames = CORRESPONDING #( Markets DISCARDING DUPLICATES MAPPING MrktId = MrktId EXCEPT * ).
      DELETE Marknames WHERE MrktId IS INITIAL.

      IF Marknames IS NOT INITIAL.

            SELECT FROM zbm_i_market_t FIELDS Mrktid
             FOR ALL ENTRIES IN @Marknames
             WHERE Mrktid = @Marknames-Mrktid
             INTO TABLE @DATA(NamesDB).

     ENDIF.

    LOOP AT Markets INTO DATA(Market).


    APPEND VALUE #(  %tky        = Market-%tky
                     %state_area = 'VALIDATE_MARKET')
                     TO reported-Market.

   IF Market-Mrktid IS INITIAL OR NOT line_exists( NamesDB[ Mrktid = Market-Mrktid ] ).
   APPEND VALUE #( %tky = Market-%tky ) TO failed-Market.

     APPEND VALUE #(  %tky = Market-%tky
                      %state_area     = 'VALIDATE_MARKET'
                      %msg            = NEW ZCM_RAP_BM(
                        severity = if_abap_behv_message=>severity-error
                        textid   = ZCM_RAP_BM=>market_unknown
                        Marketid  = Market-Mrktid )
                      %element-MrktId = if_abap_behv=>mk-on )
                      TO reported-Market.



   ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD valideEndDate.
 READ ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Market
     FIELDS ( MrktId Enddate Startdate ) WITH CORRESPONDING #( keys )
    RESULT DATA(EndDates).


 LOOP AT EndDates INTO DATA(Enddate).

 APPEND VALUE #( %tky = Enddate-%tky
                 %state_area = 'VALIDATE_END_DATE' )
                 TO reported-Market.



 IF Enddate-Enddate < Enddate-Startdate.
 APPEND VALUE #( %tky = Enddate-%tky ) TO failed-Market.

 APPEND VALUE #( %tky        = Enddate-%tky
                 %state_area = 'VALIDATE_END_DATE'
                 %msg        = NEW ZCM_RAP_BM(
                                 severity = if_abap_behv_message=>severity-error
                                 textid   = ZCM_RAP_BM=>end_date_before_start_day
                                 enddate  = Enddate-Enddate )
                 %element-Enddate = if_abap_behv=>mk-on ) TO reported-Market.

 ELSEIF Enddate-Enddate < cl_abap_context_info=>get_system_date( ).
 APPEND VALUE #( %tky = Enddate-%tky ) TO failed-Market.

 APPEND VALUE #( %tky        = Enddate-%tky
                 %state_area = 'VALIDATE_END_DATE'
                 %msg        = NEW ZCM_RAP_BM(
                                 severity = if_abap_behv_message=>severity-error
                                 textid   = ZCM_RAP_BM=>end_date_before_today
                                 enddate  = Enddate-Enddate )
                 %element-Enddate = if_abap_behv=>mk-on ) TO reported-Market.


 ENDIF.

 ENDLOOP.




  ENDMETHOD.

  METHOD valideStartDate.

  READ ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Market
    FIELDS ( MrktId Startdate ) WITH CORRESPONDING #( keys )
    RESULT DATA(StartDates).



  LOOP AT StartDates INTO DATA(Startdate).

  APPEND VALUE #( %tky        = startdate-%tky
                  %state_area = 'VALIDATE_START_DATE' )
                  TO reported-Market.

  IF Startdate-Startdate < cl_abap_context_info=>get_system_date( ).
  APPEND VALUE #( %tky = startdate-%tky ) TO failed-Market.

  APPEND VALUE #( %tky         = startdate-%tky
                  %state_area  = 'VALIDATE_START_DATE'
                  %msg         = NEW ZCM_RAP_BM(
                                           severity      = if_abap_behv_message=>severity-error
                                           textid        = ZCM_RAP_BM=>start_date_before_today
                                           startdate     = Startdate-Startdate )
                         %element-Startdate = if_abap_behv=>mk-on )
          TO reported-Market.
    ENDIF.
  ENDLOOP.

    .

  ENDMETHOD.

ENDCLASS.
