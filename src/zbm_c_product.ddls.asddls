@EndUserText.label: 'Product Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true


define root view entity ZBM_C_PRODUCT as projection on ZBM_I_PRODUCT as Product

{
    key ProdUuid,
    @Search.defaultSearchElement: true
    Prodid,
    @Search.defaultSearchElement: true
    Pgname,
    @Search.defaultSearchElement: true
    Height,
    Depth,
    Width,
    SizeUom,
    @Semantics.amount.currencyCode: 'PriceCurrency'
    Price,
    @Consumption.valueHelpDefinition: [{entity : {name : 'I_Currency', element : 'Currency'  } }]
    PriceCurrency,
    @Semantics.amount.currencyCode: 'PriceCurrency'
    Taxrate,
    CreatedBy,
    CreationTime,
    ChangedBy,
    ChangeTime,
    
    /* Associations */
    _Market : redirected to composition child ZBM_C_MARKET,
    _Orrder : redirected to composition child ZBM_C_ORDER,
    _Currency
    
}
