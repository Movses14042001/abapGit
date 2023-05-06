CLASS lhc_Product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

   CONSTANTS:
      BEGIN OF Conf_data,
        Confirmed  TYPE c LENGTH 1 VALUE 'X',
      END OF Conf_data.



    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Product RESULT result.

    METHODS moveToNextPhase FOR MODIFY
      IMPORTING keys FOR ACTION Product~moveToNextPhase RESULT result.

    METHODS setFirstPhase FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Product~setFirstPhase.

    METHODS prodId FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~prodId.

    METHODS validatePG FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~validatePG.

    METHODS makeCopy FOR MODIFY
      IMPORTING keys FOR ACTION Product~makeCopy.



ENDCLASS.

CLASS lhc_Product IMPLEMENTATION.

  METHOD get_instance_features.

   READ ENTITIES OF zbm_i_product IN LOCAL MODE
      ENTITY Product
        FIELDS ( PhaseId ) WITH CORRESPONDING #( keys )
      RESULT DATA(Phases)
      FAILED failed.

    result =
      VALUE #(
        FOR Phase IN Phases
          LET set_phase =   COND #( WHEN Phase-PhaseId = 4
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled
                                        )



          IN
            ( %tky                = Phase-%tky
              %action-moveToNextPhase = set_phase

               ) ).

  ENDMETHOD.




  METHOD setFirstPhase.

   READ ENTITIES OF zbm_i_product IN LOCAL MODE
         ENTITY Product
            FIELDS ( PhaseId ) WITH CORRESPONDING #( keys )
         RESULT DATA(Phases).



   DELETE Phases WHERE PhaseId IS NOT INITIAL.
   CHECK Phases IS NOT INITIAL.



   MODIFY ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Product
        UPDATE FIELDS ( PhaseId )
        WITH VALUE #( FOR Phase IN Phases
                    ( %tky      = Phase-%tky
                      PhaseId   = 1 ) )
   REPORTED DATA(update_reported).


   reported = CORRESPONDING #( DEEP update_reported ).




  ENDMETHOD.

  METHOD prodId.
    READ ENTITIES OF zbm_i_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( ProdId ) WITH CORRESPONDING #( keys )
        RESULT DATA(Product).

    DATA Products TYPE SORTED TABLE OF zbm_d_product WITH UNIQUE KEY prod_id.


     Products = CORRESPONDING #( Product DISCARDING DUPLICATES MAPPING prod_id = ProdId  EXCEPT * ).
    DELETE Products WHERE prod_id IS INITIAL.
    IF Product IS NOT INITIAL.

      SELECT FROM zbm_d_product FIELDS prod_id
        FOR ALL ENTRIES IN @Products
        WHERE prod_id = @Products-prod_id
        INTO TABLE @DATA(prod_db).
  ENDIF.

    LOOP AT Product INTO DATA(Prod).

      APPEND VALUE #(  %tky        = Prod-%tky
                       %state_area = 'VALIDATE_PRODUCT' )
        TO reported-Product.

      IF Prod-ProdId IS INITIAL OR line_exists( prod_db[ prod_id = Prod-ProdId ] ).
       APPEND VALUE #(  %tky = Prod-%tky )
           TO failed-Product.


        APPEND VALUE #(  %tky        = Prod-%tky
                         %state_area = 'VALIDATE_PRODUCT'
                         %msg        = NEW ZCM_RAP_BM(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = ZCM_RAP_BM=>prodid_known
                                           prodid     = Prod-ProdId )
                         %element-ProdId = if_abap_behv=>mk-on )
          TO reported-Product.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validatePG.

     READ ENTITIES OF zbm_i_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( PgId ) WITH CORRESPONDING #( keys )
        RESULT DATA(Products).

    DATA Groups TYPE SORTED TABLE OF zbm_d_prod_group WITH UNIQUE KEY pg_id.


     Groups = CORRESPONDING #( Products DISCARDING DUPLICATES MAPPING pg_id = PgId EXCEPT * ).
    DELETE Groups WHERE pg_id IS INITIAL.
    IF Groups IS NOT INITIAL.

      SELECT FROM zbm_d_prod_group FIELDS pg_id
        FOR ALL ENTRIES IN @Groups
        WHERE pg_id = @Groups-pg_id
        INTO TABLE @DATA(GroupDB).
  ENDIF.

    LOOP AT Products INTO DATA(Product).

      APPEND VALUE #(  %tky        = Product-%tky
                       %state_area = 'VALIDATE_PG' )
        TO reported-Product.

      IF Product-PgId IS INITIAL OR NOT line_exists( GroupDB[ pg_id = Product-PgId ] ).
        APPEND VALUE #(  %tky = Product-%tky ) TO failed-Product.

        APPEND VALUE #(  %tky        = Product-%tky
                         %state_area = 'VALIDATE_PG'
                         %msg        = NEW ZCM_RAP_BM(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = ZCM_RAP_BM=>prodgroup_unknown
                                           productgroup = Product-PgId )
                         %element-PgId = if_abap_behv=>mk-on )
          TO reported-Product.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD makeCopy.

  DATA:


      Products  TYPE TABLE FOR CREATE zbm_i_product\\Product.

   " remove travel instances with initial %cid (i.e., not set by caller API)
   READ TABLE keys WITH KEY %cid = '' INTO DATA(key_with_inital_cid).
   ASSERT key_with_inital_cid IS INITIAL.

   " read the data from the travel instances to be copied
   READ ENTITIES OF zbm_i_product IN LOCAL MODE
      ENTITY Product
      ALL FIELDS WITH CORRESPONDING #( keys )
   RESULT DATA(product_read_result)
   FAILED failed.

   LOOP AT product_read_result ASSIGNING FIELD-SYMBOL(<product>).
      " fill in travel container for creating new travel instance
      APPEND VALUE #( %cid      = keys[ KEY entity %key = <product>-%key ]-%cid
                     %is_draft = keys[ KEY entity %key = <product>-%key ]-%param-%is_draft
                     %data     = CORRESPONDING #( <product> EXCEPT prodid )
                  )
      TO Products ASSIGNING FIELD-SYMBOL(<new_product>).

      <new_product>-PhaseId  = 1.

   ENDLOOP.

   " create new BO instance
   MODIFY ENTITIES OF zbm_i_product IN LOCAL MODE
      ENTITY Product
      CREATE FIELDS ( PgId PhaseId Depth Height ImageUrl Price
                      PriceCurrency ProdId  SizeUom Taxrate Width )
         WITH Products
      MAPPED DATA(mapped_create).

   " set the new BO instances
   mapped-product   =  mapped_create-Product .

  ENDMETHOD.

   METHOD moveToNextPhase.




     READ ENTITIES OF zbm_i_product IN LOCAL MODE
         ENTITY Product
            FIELDS ( Produuid PhaseId ) WITH CORRESPONDING #( keys )
         RESULT DATA(Products).

   LOOP AT Products INTO DATA(Product).


   CASE Product-PhaseId.

   WHEN 1.

   READ ENTITIES OF zbm_i_product IN LOCAL MODE
         ENTITY Product BY \_Market
            FIELDS ( Produuid ) WITH VALUE #( ( %tky = Product-%tky
                                                Produuid = Product-ProdUuid ) )
         RESULT DATA(Markets).

    LOOP AT Markets INTO DATA(Market).

         IF Market IS NOT INITIAL.

         Product-PhaseId = '2'.

         ENDIF.
    ENDLOOP.



WHEN 2.


READ ENTITIES OF zbm_i_product IN LOCAL MODE
         ENTITY Product BY \_Market
            FIELDS (  Status ) WITH VALUE #( ( %tky = Product-%tky
                                                Produuid = Product-ProdUuid ) )
         RESULT DATA(Statuses).

LOOP AT Statuses INTO DATA(status).
IF Status-Status = 'X'.
 Product-PhaseId = '3'.
ENDIF.
ENDLOOP.

 ENDCASE.

    ENDLOOP.
.



   MODIFY ENTITIES OF zbm_i_product IN LOCAL MODE
    ENTITY Product
        UPDATE FIELDS ( PhaseId )
        WITH VALUE #( ( %tky      = product-%tky
                      PhaseId   = Product-PhaseId ) )
   REPORTED DATA(update_reported).









  ENDMETHOD.


ENDCLASS.
