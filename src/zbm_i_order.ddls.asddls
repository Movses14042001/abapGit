@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Order view'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}


define view entity ZBM_I_ORDER as select from zbm_d_mrkt_order as Orrder


  /* Associations */
association to parent ZBM_I_MARKET as _Market on $projection.MrktUuid = _Market.MrktUuid
                                               and $projection.ProdUuid = _Market.ProdUuid
association to I_Currency as _Currency on $projection.Amountcurr = _Currency.Currency
association to ZBM_I_PRODUCT as _Product on $projection.ProdUuid = _Product.ProdUuid

 {
    key prod_uuid as ProdUuid,
    key mrkt_uuid as MrktUuid,
    key order_uuid as OrderUuid,
    orderid as Orderid,
    quantity as Quantity,
    calendar_year as CalendarYear,
    delivery_date as DeliveryDate,
    @Semantics.amount.currencyCode : 'Amountcurr'
    netamount as Netamount,
    @Semantics.amount.currencyCode : 'Amountcurr'
    grossamount as Grossamount,
    amountcurr as Amountcurr,
    
    @Semantics.user.createdBy: true    
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    creation_time as CreationTime,
    @Semantics.user.lastChangedBy: true
    changed_by as ChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    change_time as ChangeTime,
    
    /* Public associations */
    _Product,
    _Currency,
    _Market
    
}
