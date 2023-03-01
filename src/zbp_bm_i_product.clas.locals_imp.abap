CLASS lhc_Product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.



    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Product RESULT result.

    METHODS makeCopy FOR MODIFY
      IMPORTING keys FOR ACTION Product~makeCopy RESULT result.

    METHODS moveToNextPhase FOR MODIFY
      IMPORTING keys FOR ACTION Product~moveToNextPhase RESULT result.

    METHODS setFirstPhase FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Product~setFirstPhase.

    METHODS prodId FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~prodId.

    METHODS validatePG FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~validatePG.

ENDCLASS.

CLASS lhc_Product IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD makeCopy.
  ENDMETHOD.

  METHOD moveToNextPhase.
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
  ENDMETHOD.

  METHOD validatePG.
  ENDMETHOD.

ENDCLASS.
