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
  composition [0..*] of ZBM_I_ORDER as _Orrder
{

    key prod_uuid as ProdUuid,
    key mrkt_uuid as MrktUuid,
    mrkt_id       as MrktId,
    
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
    
    /* Public Assosiations */
    _Product,
    _Market_t,
    _Market_t.Imageurl as Img,
    _Orrder
}
