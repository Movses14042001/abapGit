@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Market view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBM_I_MARKET as select from zbm_d_prod_mrkt 

  /* Assosiations */
  association to parent ZBM_I_PRODUCT as _Product   on $projection.ProdUuid = _Product.ProdUuid
  association to ZBM_I_MARKET_T as _Market_t on $projection.MrktId  = _Market_t.Mrktid
{

    key prod_uuid as ProdUuid,
    key mrkt_uuid as MrktUuid,
    mrkt_id       as MrktId,
    status        as Status,
    startdate     as Startdate,
    enddate       as Enddate,
    created_by    as CreatedBy,
    creation_time as CreationTime,
    changed_by    as ChangedBy,
    change_time   as ChangeTime,
    
    /* Public Assosiations */
    _Product,
    _Market_t
}
