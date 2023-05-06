@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Aggregating view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBM_I_ORDER_R
  as select from ZBM_I_ORDER
{




  key MrktUuid         as RMrktUuid,

      @Semantics.amount.currencyCode: 'TotalAmountcurr'
      sum(Netamount)   as TotalNetamount,
      
      @Semantics.amount.currencyCode: 'TotalAmountcurr'
      sum(Grossamount) as TotalGrossamount,
      
      Amountcurr       as TotalAmountcurr,
      
      sum(Quantity)    as TotalQuantity

}
group by MrktUuid, Amountcurr
