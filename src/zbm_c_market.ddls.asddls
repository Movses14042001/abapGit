@EndUserText.label: 'Market Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZBM_C_MARKET as projection on ZBM_I_MARKET as Market
{
    key ProdUuid,
    key MrktUuid,
    Mrktid,
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
