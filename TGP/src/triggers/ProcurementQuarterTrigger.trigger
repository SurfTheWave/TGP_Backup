/*
@Author and Created Date : Shivraj G,  3/6/2015 1:18 AM
@name : ProcurementQuarterTrigger 
@Description : 
@Version : 
*/
trigger ProcurementQuarterTrigger on Procurement_Quarter_Wise_Activity_Item__c (before update,after update) {
    List<Procurement_Quarter_Wise_Activity_Item__c> procurementQuarterList = new List<Procurement_Quarter_Wise_Activity_Item__c>();
    
    if(Trigger.isUpdate && Trigger.isAfter){
        for(Procurement_Quarter_Wise_Activity_Item__c proc:trigger.new){
            Procurement_Quarter_Wise_Activity_Item__c oldProcurement=Trigger.oldMap.get(proc.id);
            if((proc.name).equals(UtilConstants.TOTAL_SAVE_TODATE) && (proc.Value__c!=oldProcurement.value__c)){
                procurementQuarterList.add(proc);
            }
        }
        
    }
    if(!procurementQuarterList.isEmpty()){
       ProcurementClass.updateRollUpSummary(procurementQuarterList);    
    }
}