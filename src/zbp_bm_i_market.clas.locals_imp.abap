CLASS lhc_Market DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF Conf_data,
        Confirmed TYPE c LENGTH 1 VALUE 'X',
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

    METHODS setIsoCode FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Market~setIsoCode.






ENDCLASS.

CLASS lhc_Market IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Market
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(Statuses) FAILED failed.

    result =
      VALUE #( FOR status IN Statuses
      LET Stat_Conf = COND #( WHEN status-Status = conf_data-confirmed
                              THEN if_abap_behv=>fc-o-disabled
                               ELSE if_abap_behv=>fc-o-enabled )

        Ord_create = COND #( WHEN status-Status = conf_data-confirmed
                              THEN if_abap_behv=>fc-o-enabled
                              ELSE if_abap_behv=>fc-o-disabled )

      IN
              ( %tky                = status-%tky
                %action-confirm = Stat_Conf
                %assoc-_Orrder = Ord_create
                 ) ).

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
        ENTITY Market
          FIELDS ( ProdUuid MrktId ) WITH CORRESPONDING #( keys )
        RESULT DATA(Markets).

    DATA ProdMarkt TYPE SORTED TABLE OF zbm_d_prod_mrkt WITH UNIQUE KEY mrkt_id.


    ProdMarkt = CORRESPONDING #( Markets DISCARDING DUPLICATES MAPPING mrkt_id = MrktId  EXCEPT * ).
    DELETE ProdMarkt WHERE mrkt_id IS INITIAL.

    IF Markets IS NOT INITIAL.

      SELECT FROM zbm_d_prod_mrkt FIELDS mrkt_id
        FOR ALL ENTRIES IN @prodmarkt
        WHERE mrkt_id = @ProdMarkt-mrkt_id
        INTO TABLE @DATA(Marktdb).
    ENDIF.

    LOOP AT Markets INTO DATA(Markt).

      APPEND VALUE #(  %tky        = Markt-%tky
                       %state_area = 'DUPLICATES')
                         TO reported-Market.

      IF Markt-MrktId IS INITIAL OR line_exists( Marktdb[ mrkt_id = Markt-MrktId ] ).
        APPEND VALUE #(  %tky = Markt-%tky )
            TO failed-Market.


        APPEND VALUE #(  %tky        = Markt-%tky
                         %state_area = 'DUPLICATES'
                         %path                = VALUE #( Product-%is_draft  = Markt-%is_draft
                                                    Product-produuid = Markt-produuid )
                         %msg        = NEW zcm_rap_bm(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_rap_bm=>assigned_market
                                           marketid     = Markt-MrktId )
                         %element-MrktId = if_abap_behv=>mk-on )
          TO reported-Market.

      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD validateMarket.

    READ ENTITIES OF zbm_i_product IN LOCAL MODE
           ENTITY Market
             FIELDS ( MrktId ) WITH CORRESPONDING #( keys )
           RESULT DATA(Markets).

    DATA Marknames TYPE SORTED TABLE OF zbm_d_market WITH UNIQUE KEY mrkt_id.


    Marknames = CORRESPONDING #( Markets DISCARDING DUPLICATES MAPPING mrkt_id = MrktId  EXCEPT * ).
    DELETE Marknames WHERE mrkt_id IS INITIAL.
    IF Markets IS NOT INITIAL.

      SELECT FROM zbm_d_market FIELDS mrkt_id
        FOR ALL ENTRIES IN @Marknames
        WHERE mrkt_id = @Marknames-mrkt_id
        INTO TABLE @DATA(mark_db).
    ENDIF.

    LOOP AT Markets INTO DATA(Market).

      APPEND VALUE #(  %tky        = Market-%tky
                       %state_area = 'VALIDATE_MARKET' )
        TO reported-Market.

      IF Market-MrktId IS INITIAL OR NOT line_exists( mark_db[ mrkt_id = Market-MrktId ] ).
        APPEND VALUE #(  %tky = Market-%tky )
            TO failed-Market.


        APPEND VALUE #(  %tky        = Market-%tky
                         %state_area = 'VALIDATE_MARKET'
                         %path                = VALUE #( Product-%is_draft  = Market-%is_draft
                                                    Product-produuid = Market-produuid )
                         %msg        = NEW zcm_rap_bm(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_rap_bm=>market_unknown
                                           marketid     = Market-MrktId )
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
                        %path                = VALUE #( Product-%is_draft  = Enddate-%is_draft
                                                    Product-produuid = Enddate-produuid )
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
      FIELDS ( Startdate ) WITH CORRESPONDING #( keys )
      RESULT DATA(StartDates).



    LOOP AT StartDates INTO DATA(Startdate).

      APPEND VALUE #( %tky        = startdate-%tky
                      %state_area = 'VALIDATE_START_DATE' )
                      TO reported-Market.




      IF Startdate-Startdate < cl_abap_context_info=>get_system_date(  ).
        APPEND VALUE #( %tky = startdate-%tky ) TO failed-Market.

        APPEND VALUE #( %tky         = startdate-%tky
                        %state_area  = 'VALIDATE_START_DATE'
                        %path                = VALUE #( Product-%is_draft  = startdate-%is_draft
                                                    Product-produuid = startdate-produuid )
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

  METHOD setisocode.


  READ ENTITIES OF zbm_i_product IN LOCAL MODE
         ENTITY Market
            FIELDS ( MrktId ) WITH CORRESPONDING #( keys )
         RESULT DATA(Markets).










    TRY.

    data(destination) = cl_soap_destination_provider=>create_by_url( 'http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso' ).
    data(proxy) = new zsc_co_country_info_service_so(
                    destination = destination
                  ).



    LOOP AT Markets INTO DATA(Market).




        SELECT FROM ZBM_D_MARKET FIELDS mrkt_id, mrkt_name
        WHERE mrkt_id = @Market-MrktId
        INTO @DATA(newcountry).
        ENDSELECT.




    data(request) = value zsc_country_isocode_soap_reque( s_country_name = newcountry-mrkt_name ).
    proxy->country_isocode(
      exporting
        input = request
      importing
        output = data(response)
    ).


    MODIFY ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Market
        UPDATE FIELDS ( IsoCode )
        WITH VALUE #(
                    ( %tky      = Market-%tky
                      IsoCode   = response-country_isocode_result ) )

   REPORTED DATA(update_reported).


   reported = CORRESPONDING #( DEEP update_reported ).




   ENDLOOP.
   ENDTRY.


  ENDMETHOD.



ENDCLASS.
