/*
*    @Author :Divyashree C K
*    @CreatedDate : 2/26/2015
*    @Description : Trigger to autopopulate Mobilization Plan 
*
*/
trigger RecruitmentTrigger on Recruit_Tracker__c (before insert, before delete) {
    
    if(Trigger.isInsert&& Trigger.isBefore){
        UTILMobClasses util =  new UTILMobClasses();
        util.populateMobilizationPlan(trigger.new);
    }
    /*
    if(trigger.isdelete)
    {
        UTILMobClasses utilcls = new UTILMobClasses();
        utilcls.checkBeforeDeletingChildRecords(trigger.old);
    }
    */
}