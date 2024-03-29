@EndUserText.label: 'Order Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZBM_C_ORDER
  as projection on ZBM_I_ORDER as Orrder

{
  key ProdUuid,
  key MrktUuid,
  key OrderUuid,
      @Search.defaultSearchElement: true
      Orderid,
      Quantity,
      CalendarYear,
      @Search.defaultSearchElement: true
      DeliveryDate,
      @Semantics.amount.currencyCode: 'Amountcurr'
      Netamount,
      @Semantics.amount.currencyCode: 'Amountcurr'
      Grossamount,
      @Consumption.valueHelpDefinition: [{ entity : { name : 'I_Currency', element : 'Currency' } }]
      Amountcurr,

      @EndUserText.label: 'Confirmed?'
      OrderStatus,

      BusPartner,
      BusPartnerGroup,
      BusPartnerName,


      CreatedBy,
      CreationTime,
      ChangedBy,
      ChangeTime,


      /* Associations */
      _Product : redirected to ZBM_C_PRODUCT,
      _Currency,
      _Market  : redirected to parent ZBM_C_MARKET
}
