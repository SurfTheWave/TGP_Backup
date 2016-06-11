trigger CapacityOperations on Capacity_Service_Data__c (before update) {
if(trigger.isBefore && trigger.isUpdate){
 for( Capacity_Service_Data__c anyRec:trigger.new){
   if(!anyRec.active__c && UtilConstantsR3.runCapasityTrigger){
     anyRec.addError('Record is not active.Enable Capacity Service in Scope from SWB BPO Details section');

}
}
}
}