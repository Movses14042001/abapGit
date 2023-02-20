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
association to parent ZBM_I_PRODUCT  as _Product   on $projection.ProdUuid = _Product.ProdUuid
association to I_Currency as _Currency on $projection.Amountcurr = _Currency.Currency
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
    created_by as CreatedBy,
    creation_time as CreationTime,
    changed_by as ChangedBy,
    change_time as ChangeTime,
    
    /* Public associations */
    _Product,
    _Currency
    
}

