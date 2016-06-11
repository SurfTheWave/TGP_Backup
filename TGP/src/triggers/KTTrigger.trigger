/*
  @Author: Divyashree C K
  @Name: KTTrigger
  @Created Date: 2/26/2015 1:45 AM
  @Description: This trigger is called to autopopulate Mobilization Plan.
  @version: 1.0
*/
trigger KTTrigger on KT_Trac__c (before insert, before update, before delete) {
    List<KT_Trac__c > ktList = new List<KT_Trac__c >();    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            UTILMobClasses util =  new UTILMobClasses();
            util.populateMobilizationPlan(trigger.new);
        }        
    }
    /*
    if(trigger.isDelete){
        UTILMobClasses utilCls = new UTILMobClasses();
        utilCls.checkBeforeDeletingChildRecords(trigger.old);
    }
    */
}