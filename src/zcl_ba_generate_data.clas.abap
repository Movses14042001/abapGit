CLASS zcl_ba_generate_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
*
*
*
CLASS ZCL_BA_GENERATE_DATA IMPLEMENTATION.
*
*
  METHOD if_oo_adt_classrun~main.
*
*    DATA:
*          lt_prod_grs  TYPE TABLE OF zbm_d_prod_group,
*          lt_prod      TYPE TABLE OF zbm_d_product,
*          lt_phases    TYPE TABLE OF zbm_d_phase,
*          lt_markets   TYPE TABLE OF zbm_d_market,
*          lt_uom       TYPE TABLE OF zbm_d_uom.
*
**** PRODUCT GROUPS
***   fill internal table (itab)
**
*    lt_prod_grs = VALUE #(
*        ( pg_id  = '1' pg_name = 'Microwave'      image_url = 'https://png.pngtree.com/png-clipart/20190517/original/pngtree-vector-microwave-oven-icon-png-image_4015182.jpg' )
*        ( pg_id  = '2' pg_name = 'Coffee Machine' image_url = 'https://icon-library.com/images/coffee-maker-icon/coffee-maker-icon-13.jpg' )
*        ( pg_id  = '3' pg_name = 'Waffle Iron'    image_url = 'https://previews.123rf.com/images/anatolir/anatolir1810/anatolir181004863/110698658-waffle-maker-icon-outline-style.jpg' )
*        ( pg_id  = '4' pg_name = 'Blender'        image_url = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRSLnFTOSs5ZV0d8pwhPzs4KANsvq1oZ7hyrg&usqp=CAU' )
*        ( pg_id  = '5' pg_name = 'Cooker'         image_url = 'https://st4.depositphotos.com/18657574/22404/v/1600/depositphotos_224044856-stock-illustration-stove-concept-vector-linear-icon.jpg' )
*     ).
*
**   Delete the possible entries in the database table - in case it was already filled
*    DELETE FROM zbm_d_prod_group.
**   insert the new table entries
*    INSERT zbm_d_prod_group FROM TABLE @lt_prod_grs.
*
**   check the result
**    SELECT * FROM zbm_d_prod_group INTO TABLE @lt_prod_grs.
*    out->write( sy-dbcnt ).
*    out->write( 'product groups data inserted successfully!').
*
**** PHASES
**   fill internal table (itab)
*    lt_phases = VALUE #(
*        ( phaseid  = '1' phase = 'PLAN' )
*        ( phaseid  = '2' phase = 'DEV' )
*        ( phaseid  = '3' phase = 'PROD' )
*        ( phaseid  = '4' phase = 'OUT' )
*     ).
*
**   Delete the possible entries in the database table - in case it was already filled
*    DELETE FROM zbm_d_phase.
**   insert the new table entries
*    INSERT zbm_d_phase FROM TABLE @lt_phases.
*
**   check the result
*    SELECT * FROM zbm_d_phase INTO TABLE @lt_phases.
*    out->write( sy-dbcnt ).
*    out->write( 'phases data inserted successfully!').
*
**** MARKETS
**   fill internal table (itab)
*    lt_markets = VALUE #(
*        ( mrktid  = '1'  mrktname = 'Russia'          code = 'RU' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940426/russia-flag-image-free-download.jpg' )
*        ( mrktid  = '2'  mrktname = 'Belarus'         code = 'RU' imageurl = 'https://cdn.countryflags.com/thumbs/belarus/flag-400.png' )
*        ( mrktid  = '3'  mrktname = 'United Kingdom'  code = 'EN' imageurl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Flag_of_the_United_Kingdom.svg/640px-Flag_of_the_United_Kingdom.svg.png' )
*        ( mrktid  = '4'  mrktname = 'France'          code = 'FR' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54002660/france-flag-image-free-download.jpg' )
*        ( mrktid  = '5'  mrktname = 'Germany'         code = 'DE' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54006402/germany-flag-image-free-download.jpg' )
*        ( mrktid  = '6'  mrktname = 'Italy'           code = 'IT' imageurl = 'https://cdn.countryflags.com/thumbs/italy/flag-400.png' )
*        ( mrktid  = '7'  mrktname = 'USA'             code = 'EN' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54958906/the-united-states-flag-image-free-download.jpg' )
*        ( mrktid  = '8'  mrktname = 'Japan'           code = 'EN' imageurl = 'https://image.freepik.com/free-vector/illustration-japan-flag_53876-27128.jpg' )
*        ( mrktid  = '9'  mrktname = 'Poland'          code = 'EN' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg' )
*        ( mrktid  = '10' mrktname = 'Spain'           code = 'ES' imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg' )
*     ).
*
**   Delete the possible entries in the database table - in case it was already filled
*    DELETE FROM zbm_d_market.
**   insert the new table entries
*    INSERT zbm_d_market FROM TABLE @lt_markets.
*
**   check the result
*    SELECT * FROM zbm_d_market INTO TABLE @lt_markets.
*    out->write( sy-dbcnt ).
*    out->write( 'markets data inserted successfully!').
*
**** UOM
**   fill internal table (itab)
*    lt_uom = VALUE #(
*        ( msehi = 'CM'  dimid = 'LENGTH' isocode = 'CMT')
*        ( msehi = 'DM'  dimid = 'LENGTH' isocode = 'DMT')
*        ( msehi = 'FT'  dimid = 'LENGTH' isocode = 'FOT')
*        ( msehi = 'IN'  dimid = 'LENGTH' isocode = 'INH')
*        ( msehi = 'KM'  dimid = 'LENGTH' isocode = 'KMT')
*        ( msehi = 'M'   dimid = 'LENGTH' isocode = 'MTR')
*        ( msehi = 'MI'  dimid = 'LENGTH' isocode = 'SMI')
*        ( msehi = 'MIM' dimid = 'LENGTH' isocode = '4H')
*        ( msehi = 'MM'  dimid = 'LENGTH' isocode = 'MMT')
*        ( msehi = 'NAM' dimid = 'LENGTH' isocode = 'C45')
*        ( msehi = 'YD'  dimid = 'LENGTH' isocode = 'YRD')
*     ).
*
**   Delete the possible entries in the database table - in case it was already filled
*    DELETE FROM zbm_d_uom.
**   insert the new table entries
*    INSERT zbm_d_uom FROM TABLE @lt_uom.
*
*    lt_prod = VALUE #( ( width = '11' depth = '11' height = '11' pg_id = '1' phase_id = '1' prod_id = '1' ) ).
*
*
*     DELETE FROM zbm_d_product.
**   insert the new table entries
*    INSERT zbm_d_product FROM TABLE @lt_prod.
*
*
**   check the result
*    SELECT * FROM zbm_d_uom INTO TABLE @lt_uom.
*    out->write( sy-dbcnt ).
*    out->write( 'uom data inserted successfully!').
*
  ENDMETHOD.
ENDCLASS.
