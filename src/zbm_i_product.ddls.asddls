@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Product view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root  view entity ZBM_I_PRODUCT as select from zbm_d_product as Product 


  /* Associations */
  composition [0..*] of ZBM_I_MARKET as _Market
  composition [0..*] of ZBM_I_ORDER as _Orrder
  association to I_Currency as _Currency on $projection.PriceCurrency = _Currency.Currency
  association to ZBM_I_PROD_GROUP as _PGroup  on $projection.PgId = _PGroup.Pgid
  association to ZBM_I_PHASE as _Phase on $projection.PhaseId = _Phase.PhaseId
 
  
  
{
    key prod_uuid  as ProdUuid,
    prod_id        as ProdId,
    pg_id          as PgId,
    phase_id       as PhaseId,
    height         as Height,
    depth          as Depth,
    width          as Width,
    size_uom       as SizeUom,
    @Semantics.amount.currencyCode : 'PriceCurrency'
    price          as Price,
    price_currency as PriceCurrency,
    taxrate        as Taxrate,
    created_by     as CreatedBy,
    creation_time  as CreationTime,
    changed_by     as ChangedBy,
    change_time    as ChangeTime,
    
    /* Public assosiations */
    
    _Market,
    _Orrder,
    _Currency,
    _Phase,
    _PGroup

}
