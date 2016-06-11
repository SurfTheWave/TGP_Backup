/*    Author : Divyashree C K
*     @Trigger 
*     @Description : Auto populate Mobilization Plan from Wave page layout
*/
trigger TechWETrigger on Tech_WE_Tracker__c (before insert, before delete) {
    /*
    if(Trigger.isDelete){
        CheckForDelete c = new CheckForDelete();
            c.checkDeletingActiveRecords(trigger.old );
    }
    
    if(trigger.isDelete)
    {
        UTILMobClasses utilCls = new UTILMobClasses();
        utilCls.checkBeforeDeletingChildREcords(trigger.old);
    }
    */
    
    if(Trigger.isBefore && Trigger.isInsert){
        UTILMobClasses util = new UTILMobClasses();
        util.populateMobilizationPlan(trigger.new);
    }
    
    
}