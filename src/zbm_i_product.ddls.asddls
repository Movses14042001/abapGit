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
//  association [0..*] to ZBM_I_ORDER as _Orrder on $projection.ProdUuid  = _Orrder.ProdUuid
  association to I_Currency as _Currency on $projection.PriceCurrency = _Currency.Currency
  association to ZBM_I_PROD_GROUP as _PGroup  on $projection.PgId = _PGroup.PgId 
  association to ZBM_I_PHASE as _Phase on $projection.PhaseId = _Phase.PhaseId
 
  
  
{
    key prod_uuid  as ProdUuid,
    prod_id        as ProdId,
    pg_id          as PgId,
    phase_id       as PhaseId,
    height         as Height,
    depth          as Depth,
    width          as Width,
    
    concat(cast( height as abap.char( 20 ) ), concat_with_space(' X ', concat('',  
                                              concat(cast( depth as abap.char( 20 ) ), 
                                              concat(' X', concat_with_space('', cast( width as abap.char( 20 ) ), 1  ) ))), 1)) as Mesurement,
    size_uom       as SizeUom,
    @Semantics.amount.currencyCode : 'PriceCurrency'
    price          as Price,
    price_currency as PriceCurrency,
    taxrate        as Taxrate,
    @Semantics.user.createdBy: true
    created_by     as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    creation_time  as CreationTime,
    @Semantics.user.lastChangedBy: true
    changed_by     as ChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    change_time    as ChangeTime,
    
    /* Public assosiations */
    
    
    _Market,
//    _Orrder,
    _Currency,
    _Phase,
    _PGroup,
    _PGroup.ImageUrl as ImageUrl

}
