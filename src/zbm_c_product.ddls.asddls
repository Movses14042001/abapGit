@EndUserText.label: 'Product Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true


define root view entity ZBM_C_PRODUCT as projection on ZBM_I_PRODUCT as Product
{
    key ProdUuid,
    @Search.defaultSearchElement: true
    ProdId,
    @EndUserText.label: 'Product Group'
    @ObjectModel.text.element: ['Pgname']
    @Consumption.valueHelpDefinition: [{entity : { name : 'ZBM_I_PROD_GROUP' , element : 'PgId' } }]
    PgId,
    _PGroup.PgName,
    @Consumption.valueHelpDefinition: [{entity : { name : 'ZBM_I_PHASE' , element : 'PhaseId' } }]
    @ObjectModel.text.element: ['Phase']
    PhaseId,
    _Phase.Phase,
    @Semantics.quantity.unitOfMeasure: 'SizeUom'
    @EndUserText.label: 'Height'
    Height,
    @Semantics.quantity.unitOfMeasure: 'SizeUom'
    @EndUserText.label: 'Depth'
    Depth,
    @EndUserText.label: 'Width'
    @Semantics.quantity.unitOfMeasure: 'SizeUom'
    Width,
    @Semantics.unitOfMeasure: true
    @Consumption.valueHelpDefinition: [{entity : {name : 'ZBM_I_UOM', element : 'Msehi'  } }]
    SizeUom,
    @Semantics.amount.currencyCode: 'PriceCurrency'
    @EndUserText.label: 'Net Price'
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
    _Currency,
    _Phase,
    _PGroup

    
}

