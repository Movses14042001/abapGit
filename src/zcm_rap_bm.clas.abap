CLASS zcm_rap_bm DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    INTERFACES if_abap_behv_message.


   CONSTANTS:
       BEGIN OF prodgroup_unknown,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '001',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF prodgroup_unknown.

      CONSTANTS:
       BEGIN OF market_unknown,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '003',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF market_unknown.
      CONSTANTS:
       BEGIN OF prodid_known,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '002',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF prodid_known.
      CONSTANTS:
       BEGIN OF start_date_before_today,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '004',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF start_date_before_today.
      CONSTANTS:
       BEGIN OF end_date_before_today,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '005',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF end_date_before_today.
      CONSTANTS:
       BEGIN OF end_date_before_start_day,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '006',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF end_date_before_start_day.
      CONSTANTS:
       BEGIN OF assigned_market,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '007',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF assigned_market.
      CONSTANTS:
       BEGIN OF delivery_bfore_start_date,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '008',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF delivery_bfore_start_date.
      CONSTANTS:
       BEGIN OF delivery_equal_start_date,
           msgid TYPE symsgid VALUE 'ZRAP_MSG_BM',
           msgno TYPE symsgno VALUE '009',
           attr1 TYPE scx_attrname VALUE '',
           attr2 TYPE scx_attrname VALUE '',
           attr3 TYPE scx_attrname VALUE '',
           attr4 TYPE scx_attrname VALUE '',
      END OF delivery_equal_start_date.

    METHODS constructor
      IMPORTING
        severity TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid   LIKE if_t100_message=>t100key OPTIONAL
        previous TYPE REF TO cx_root           OPTIONAL
        productgroup TYPE zbam1_pg_id          OPTIONAL
        prodid       TYPE zbam1_product_id     OPTIONAL
        marketid     TYPE zbam1_market_id      OPTIONAL
        startdate    TYPE zbam1_start_date     OPTIONAL
        enddate      TYPE zbam1_end_date       OPTIONAL
        deliverydate TYPE zbam1_delivery_date  OPTIONAL.




    DATA   productgroup  TYPE zbam1_pg_id         READ-ONLY.
    DATA   prodid        TYPE zbam1_product_id    READ-ONLY.
    DATA   marketid      TYPE zbam1_market_id     READ-ONLY.
    DATA   startdate     TYPE zbam1_start_date    READ-ONLY.
    DATA   enddate       TYPE zbam1_end_date      READ-ONLY.
    DATA   deliverydate  TYPE zbam1_delivery_date READ-ONLY.
        .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_rap_bm IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.



      me->if_abap_behv_message~m_severity = severity.


    me->productgroup = |{ prodid       ALPHA = OUT }|.
    me->prodid       = |{ productgroup ALPHA = OUT }|.
    me->marketid     = |{ marketid     ALPHA = OUT }|.
    me->startdate    = startdate.
    me->enddate      = enddate.
    me->deliverydate  = deliverydate.


  ENDMETHOD.
ENDCLASS.
