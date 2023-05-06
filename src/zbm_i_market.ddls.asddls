@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Market view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBM_I_MARKET as select from zbm_d_prod_mrkt as Market

  /* Assosiations */
  association to parent ZBM_I_PRODUCT as _Product   on $projection.ProdUuid = _Product.ProdUuid
  association to ZBM_I_MARKET_T as _Market_t on $projection.MrktId  = _Market_t.Mrktid
  association  to ZBM_I_ORDER_R as _Order_r on $projection.MrktUuid  = _Order_r.RMrktUuid
   composition [0..*] of ZBM_I_ORDER as _Orrder
{

    key prod_uuid as ProdUuid,
    key mrkt_uuid as MrktUuid,
    mrkt_id       as MrktId,
    iso_code      as IsoCode,
    
    
    status        as Status,
    //Add Criticality information
    case status 
       when 'X'  then 3
        else 1
    end as StatCriticality,
    
    startdate     as Startdate,
    enddate       as Enddate,
    @Semantics.user.createdBy: true
    created_by    as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    creation_time as CreationTime,
    @Semantics.user.lastChangedBy: true
    changed_by    as ChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    change_time   as ChangeTime,
   @Semantics.amount.currencyCode: 'TotalAmountcurr'
    _Order_r.TotalNetamount,
    @Semantics.amount.currencyCode: 'TotalAmountcurr'
    _Order_r.TotalGrossamount,
    _Order_r.TotalQuantity,
    _Order_r.TotalAmountcurr,
    
    
    /* Public Assosiations */
    _Product,
    _Market_t,
    _Market_t.Imageurl as Img,
    _Order_r,
    _Orrder
}
