@EndUserText.label: 'Market Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZBM_C_MARKET as projection on ZBM_I_MARKET as Market
{
    key ProdUuid,
    key MrktUuid,
    @Search.defaultSearchElement: true
    @ObjectModel.text.element: ['Country']
    @EndUserText.label: 'Market'
   @Consumption.valueHelpDefinition: [{entity : { name : 'ZBM_I_MARKET_T' , element : 'Mrktid' } }]
    @UI.textArrangement: #TEXT_ONLY
    MrktId,
    _Market_t.Mrktname as  Country,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Confirmed?'
    Status,
    Startdate,
    Enddate,
    CreatedBy,
    CreationTime,
    ChangedBy,
    ChangeTime,
    Img,
    StatCriticality,
   
    
    /* Associations */
    _Product : redirected to parent ZBM_C_PRODUCT,
    _Market_t,
    _Orrder
}
