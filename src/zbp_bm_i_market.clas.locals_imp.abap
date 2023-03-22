CLASS lhc_Market DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

  CONSTANTS:
      BEGIN OF Conf_data,
        Confirmed  TYPE c LENGTH 1 VALUE 'X',
      END OF Conf_data.


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

  READ ENTITIES OF zbm_i_product IN LOCAL MODE
  ENTITY Market
  FIELDS ( Status ) WITH CORRESPONDING #( keys )
  RESULT DATA(Statuses) FAILED failed.

  result =
    VALUE #( FOR status in Statuses
    LET Stat_Conf = COND #( WHEN status-Status = conf_data-confirmed
                            THEN if_abap_behv=>fc-o-disabled
                             ELSE if_abap_behv=>fc-o-enabled )


    IN
            ( %tky                = status-%tky
              %action-confirm = Stat_Conf ) ).

  ENDMETHOD.

  METHOD confirm.



     READ ENTITIES OF zbm_i_product IN LOCAL MODE
         ENTITY Market
            FIELDS ( Status ) WITH CORRESPONDING #( keys )
         RESULT DATA(Statuses).



   MODIFY ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Market
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR Status IN Statuses
                    ( %tky      = Status-%tky
                      Status   = Conf_data-Confirmed ) )
   REPORTED DATA(update_reported).

  ENDMETHOD.




  METHOD checkDuplicates.

    READ ENTITIES OF zbm_i_product IN LOCAL MODE
        ENTITY Product BY \_Market
          FIELDS ( MrktId ) WITH CORRESPONDING #( keys )
        RESULT DATA(Markets).

    DATA ProdMarkt TYPE SORTED TABLE OF zbm_d_prod_mrkt WITH UNIQUE KEY mrkt_id.


     ProdMarkt = CORRESPONDING #( Markets DISCARDING DUPLICATES MAPPING mrkt_id = MrktId  EXCEPT * ).
    DELETE Markets WHERE MrktId IS INITIAL.
    IF Markets IS NOT INITIAL.

      SELECT FROM zbm_d_prod_mrkt FIELDS mrkt_id
        FOR ALL ENTRIES IN @prodmarkt
        WHERE mrkt_id = @ProdMarkt-mrkt_id
        INTO TABLE @DATA(Marktdb).
  ENDIF.

*    LOOP AT Markets INTO DATA(Markts).
*
*      APPEND VALUE #(  %tky        = Markts-%tky
*                       %state_area = 'Duplicates' )
*        TO reported-Product.
*
*      IF Markts-MrktId IS INITIAL OR line_exists( Marktdb[ prod_id = Prod-ProdId ] ).
*       APPEND VALUE #(  %tky = Prod-%tky )
*           TO failed-Product.
*
*
*        APPEND VALUE #(  %tky        = Markts-%tky
*                         %state_area = 'Duplicates'
*                         %msg        = NEW ZCM_RAP_BM(
*                                           severity   = if_abap_behv_message=>severity-error
*                                           textid     = ZCM_RAP_BM=>prodid_known
*                                           prodid     = Prod-ProdId )
*                         %element-ProdId = if_abap_behv=>mk-on )
*          TO reported-Product.
*      ENDIF.
*    ENDLOOP.


  ENDMETHOD.

  METHOD validateMarket.



    READ ENTITIES OF zbm_i_product IN LOCAL MODE
       ENTITY Market
         FIELDS ( Mrktid ) WITH CORRESPONDING #( keys )
       RESULT DATA(Markets).


    DATA Marknames TYPE SORTED TABLE OF zbm_d_market WITH UNIQUE KEY mrktid.



    Marknames = CORRESPONDING #( Markets DISCARDING DUPLICATES MAPPING mrktid = MrktId EXCEPT * ).
    DELETE Marknames WHERE mrktid IS INITIAL.

    IF Marknames IS NOT INITIAL.

      SELECT FROM zbm_d_market FIELDS mrktid
       FOR ALL ENTRIES IN @Marknames
       WHERE mrktid = @Marknames-mrktid
       INTO TABLE @DATA(NamesDB).

    ENDIF.

    LOOP AT Markets INTO DATA(Market).


      APPEND VALUE #(  %tky        = Market-%tky
                       %state_area = 'VALIDATE_MARKET')
                       TO reported-Market.

      IF Market-Mrktid IS INITIAL OR NOT line_exists( NamesDB[ mrktid = Market-MrktId ] ).
        APPEND VALUE #( %tky = Market-%tky ) TO failed-Market.

        APPEND VALUE #(  %tky = Market-%tky
                         %state_area     = 'VALIDATE_MARKET'
                         %msg            = NEW zcm_rap_bm(
                           severity = if_abap_behv_message=>severity-error
                           textid   = zcm_rap_bm=>market_unknown
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
                        %msg        = NEW zcm_rap_bm(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = zcm_rap_bm=>end_date_before_start_day
                                        enddate  = Enddate-Enddate )
                        %element-Enddate = if_abap_behv=>mk-on ) TO reported-Market.

      ELSEIF Enddate-Enddate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky = Enddate-%tky ) TO failed-Market.

        APPEND VALUE #( %tky        = Enddate-%tky
                        %state_area = 'VALIDATE_END_DATE'
                        %msg        = NEW zcm_rap_bm(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = zcm_rap_bm=>end_date_before_today
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
                        %msg         = NEW zcm_rap_bm(
                                                 severity      = if_abap_behv_message=>severity-error
                                                 textid        = zcm_rap_bm=>start_date_before_today
                                                 startdate     = Startdate-Startdate )
                               %element-Startdate = if_abap_behv=>mk-on )
                TO reported-Market.
      ENDIF.
    ENDLOOP.

    .

  ENDMETHOD.

ENDCLASS.
