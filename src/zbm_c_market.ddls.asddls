@EndUserText.label: 'Market Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZBM_C_MARKET as projection on ZBM_I_MARKET as Market
{
    key ProdUuid,
    key MrktUuid,
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{entity : { name : 'ZBM_I_MARKET_T' , element : 'Mrktid' } }]
    MrktId,
    @Search.defaultSearchElement: true
    Status,
    Startdate,
    Enddate,
    CreatedBy,
    CreationTime,
    ChangedBy,
    ChangeTime,
    
    /* Associations */
    _Product : redirected to parent ZBM_C_PRODUCT
}
