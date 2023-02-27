@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Product Group view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBM_I_PROD_GROUP as select from zbm_d_prod_group
{
    key pg_id as PgId,
    pg_name as PgName,
    image_url as ImageUrl
}
