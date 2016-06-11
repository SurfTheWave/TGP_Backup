/*
  @Author: Suma Ganga
  @Name: Deal Trigger
  @Created Date: 2/25/2015 1:45 AM
  @Description: This trigger is called to update the Decisions on higher level.
  @version: 1.0
*/
Trigger decisionUpdateTrigger on Decision__c (after insert, before insert) {
    decisionUpdateController updateController = new decisionUpdateController();
    UAMSWBMWBUtility uamUtility= new UAMSWBMWBUtility();    
    
    if(Trigger.isBefore && Trigger.isInsert){
        updateController.populateFieldsAfterInsert(trigger.new);            

    }
    if(Trigger.isAfter && Trigger.isInsert){
            //uamUtility.CheckAccessDecisionShareInsert(Trigger.new);           
        MobilizationSharing mobSharing=new MobilizationSharing();
        mobSharing.createSharing(Trigger.new,'Decision__share');

    }
}