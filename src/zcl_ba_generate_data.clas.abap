CLASS zcl_ba_generate_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BA_GENERATE_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA:
          lt_prod_grs  TYPE TABLE OF zbm_d_prod_group,
          lt_prod      TYPE TABLE OF zbm_d_product,
          lt_phases    TYPE TABLE OF zbm_d_phase,
          lt_markets   TYPE TABLE OF zbm_d_market,
          lt_marketsd  TYPE TABLE OF zbm_d_prod_mrkt,
          lt_uom       TYPE TABLE OF zbm_d_uom,
          it_ord       TYPE TABLE OF zbm_d_mrkt_order.

*** PRODUCT GROUPS
**   fill internal table (itab)


    lt_marketsd = VALUE #(
    ( mrkt_id = '3' mrkt_uuid = '72AD846C0C401EEDAF844F5302769A59'  status = '' prod_uuid = 'B6EF623455A21EDDAF833300F97C672C' ) ).
*
    lt_prod_grs = VALUE #(
        ( pg_id  = '1' pg_name = 'Microwave'      image_url = 'https://png.pngtree.com/png-clipart/20190517/original/pngtree-vector-microwave-oven-icon-png-image_4015182.jpg' )
        ( pg_id  = '2' pg_name = 'Coffee Machine' image_url = 'https://icon-library.com/images/coffee-maker-icon/coffee-maker-icon-13.jpg' )
        ( pg_id  = '3' pg_name = 'Waffle Iron'    image_url = 'https://previews.123rf.com/images/anatolir/anatolir1810/anatolir181004863/110698658-waffle-maker-icon-outline-style.jpg' )
        ( pg_id  = '4' pg_name = 'Blender'        image_url = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRSLnFTOSs5ZV0d8pwhPzs4KANsvq1oZ7hyrg&usqp=CAU' )
        ( pg_id  = '5' pg_name = 'Cooker'         image_url = 'https://st4.depositphotos.com/18657574/22404/v/1600/depositphotos_224044856-stock-illustration-stove-concept-vector-linear-icon.jpg' )
     ).

*   Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zbm_d_prod_group.
*   insert the new table entries
    INSERT zbm_d_prod_group FROM TABLE @lt_prod_grs.

*   check the result
*    SELECT * FROM zbm_d_prod_group INTO TABLE @lt_prod_grs.
    out->write( sy-dbcnt ).
    out->write( 'product groups data inserted successfully!').

*** PHASES
*   fill internal table (itab)
    lt_phases = VALUE #(
        ( phaseid  = '1' phase = 'PLAN' )
        ( phaseid  = '2' phase = 'DEV' )
        ( phaseid  = '3' phase = 'PROD' )
        ( phaseid  = '4' phase = 'OUT' )
     ).

*   Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zbm_d_phase.
*   insert the new table entries
    INSERT zbm_d_phase FROM TABLE @lt_phases.

*   check the result
    SELECT * FROM zbm_d_phase INTO TABLE @lt_phases.
    out->write( sy-dbcnt ).
    out->write( 'phases data inserted successfully!').

** MARKETS
*   fill internal table (itab)
    lt_markets = VALUE #(
        ( mrkt_id  = '1'  mrkt_name = 'Russia'          code = 'RU' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940426/russia-flag-image-free-download.jpg' )
        ( mrkt_id  = '2'  mrkt_name = 'Belarus'         code = 'RU' imageurl = 'https://cdn.countryflags.com/thumbs/belarus/flag-400.png' )
        ( mrkt_id  = '3'  mrkt_name = 'United Kingdom'  code = 'EN' imageurl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Flag_of_the_United_Kingdom.svg/640px-Flag_of_the_United_Kingdom.svg.png' )
        ( mrkt_id  = '4'  mrkt_name = 'France'          code = 'FR' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54002660/france-flag-image-free-download.jpg' )
        ( mrkt_id  = '5'  mrkt_name = 'Germany'         code = 'DE' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54006402/germany-flag-image-free-download.jpg' )
        ( mrkt_id  = '6'  mrkt_name = 'Italy'           code = 'IT' imageurl = 'https://cdn.countryflags.com/thumbs/italy/flag-400.png' )
        ( mrkt_id  = '7'  mrkt_name = 'USA'             code = 'EN' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54958906/the-united-states-flag-image-free-download.jpg' )
        ( mrkt_id  = '8'  mrkt_name = 'Japan'           code = 'EN' imageurl = 'https://image.freepik.com/free-vector/illustration-japan-flag_53876-27128.jpg' )
        ( mrkt_id  = '9'  mrkt_name = 'Poland'          code = 'EN' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg' )
        ( mrkt_id  = '10' mrkt_name = 'Spain'           code = 'ES' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg' )
     ).

*   Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zbm_d_market.
*   insert the new table entries
   INSERT zbm_d_market FROM TABLE @lt_markets.
*
**   check the result
    SELECT * FROM zbm_d_market INTO TABLE @lt_markets.
    out->write( sy-dbcnt ).
    out->write( 'markets data inserted successfully!').

*** UOM
*   fill internal table (itab)
    lt_uom = VALUE #(
        ( msehi = 'CM'  dimid = 'LENGTH' isocode = 'CMT')
        ( msehi = 'DM'  dimid = 'LENGTH' isocode = 'DMT')
        ( msehi = 'FT'  dimid = 'LENGTH' isocode = 'FOT')
        ( msehi = 'IN'  dimid = 'LENGTH' isocode = 'INH')
        ( msehi = 'KM'  dimid = 'LENGTH' isocode = 'KMT')
        ( msehi = 'M'   dimid = 'LENGTH' isocode = 'MTR')
        ( msehi = 'MI'  dimid = 'LENGTH' isocode = 'SMI')
        ( msehi = 'MIM' dimid = 'LENGTH' isocode = '4H')
        ( msehi = 'MM'  dimid = 'LENGTH' isocode = 'MMT')
        ( msehi = 'NAM' dimid = 'LENGTH' isocode = 'C45')
        ( msehi = 'YD'  dimid = 'LENGTH' isocode = 'YRD')
     ).

*   Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zbm_d_uom.
*   insert the new table entries
    INSERT zbm_d_uom FROM TABLE @lt_uom.

    lt_prod = VALUE #( ( width = '11' depth = '11' price_currency = 'USD' price = '121' taxrate = '3' size_uom = 'CM'  height = '11' pg_id = '1' phase_id = '1' prod_id = '1' prod_uuid = 'B6EF623455A21EDDAF833300F97C672C' ) ).


    it_ord  =  VALUE #( ( orderid = 1  mrkt_uuid = ''  order_uuid = '72AD846C0C401EEDAF844F5302768' prod_uuid =  'B6EF623455A21EDDAF833300F97C672C' amountcurr = 'USD' ) ).

*    DELETE FROM zbm_d_product.
*    DELETE FROM zbm_d_mrkt_order.
*    DELETE FROM zbm_d_dproduct.
*    DELETE FROM zbm_d_dmarket.
*   insert the new table entries
  .  INSERT zbm_d_product FROM TABLE @lt_prod.

     INSERT zbm_d_mrkt_order FROM TABLE @it_ord.



*    DELETE FROM zbm_d_prod_mrkt.
*   insert the new table entries
    INSERT zbm_d_prod_mrkt FROM TABLE @lt_marketsd.


*   check the result
    SELECT * FROM zbm_d_uom INTO TABLE @lt_uom.
    out->write( sy-dbcnt ).
    out->write( 'uom data inserted successfully!').

  ENDMETHOD.
ENDCLASS.
