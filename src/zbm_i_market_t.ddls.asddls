@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Market Name view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBM_I_MARKET_T as select from zbm_d_market as MarketT {
    key mrkt_id as Mrktid,
    mrkt_name as Mrktname,
    code as Code,
    imageurl as Imageurl
    }
