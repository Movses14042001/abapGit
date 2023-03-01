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
  ENDMETHOD.

  METHOD valideEndDate.
  ENDMETHOD.

  METHOD valideStartDate.
  ENDMETHOD.

ENDCLASS.
