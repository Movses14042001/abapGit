@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Phase view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBM_I_PHASE as select from zbm_d_phase as Phase{
    key phaseid as PhaseId, 
    phase as Phase,
    //Add Criticality information
    case phase 
        when 'PLAN' then 1
        when 'DEV'  then 2
        when 'PROD' then 3
        when 'OUT'  then 4
        else 0
    end as phascriticality
    

}
