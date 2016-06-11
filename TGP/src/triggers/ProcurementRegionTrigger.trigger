/**
    @Author : Shivraj.gangabyraiah
    @name:  ProcurementRegionTrigger
    @CreateDate :  2/21/2015
    @Description: Trigger to insert region wise records
    @Version: 1.0
    @reference: None
*/
trigger ProcurementRegionTrigger on Procurement_Wave_Region__c (before insert,after insert,before update,after update) {
    
    List<Procurement_Wave_Region__c> regionWiseList = Trigger.new;
    UAMSWBMWBUtility uamUtility= new UAMSWBMWBUtility();
    if(Trigger.isInsert && Trigger.isAfter){
        ProcurementRegion.createRegionWise(regionWiseList);
        //uamUtility.procurementWaveShareInsert(trigger.new);
       MobilizationSharing mobSharing=new MobilizationSharing();
       mobSharing.createSharing(Trigger.new,'Procurement_Wave_Region__share');                  
    }
}