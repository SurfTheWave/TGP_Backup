/*
@Author and Created Date : 
@name : actionUpdateTrigger 
@Description : Suma Ganga,  2/24/2015 1:54 AM
@Version : 
*/
trigger actionUpdateTrigger on Action__c(after insert, before insert) {

    List < Action__c > lstNewAction = Trigger.new;
    List < Action__c > lstOldAction = Trigger.old; //Not used?

    actionUpdateController updateController = new actionUpdateController();
    UAMSWBMWBUtility uamUtility = new UAMSWBMWBUtility();

    if(Trigger.isBefore && Trigger.isInsert){
        updateController.populateFieldsAfterInsert(trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        //uamUtility.CheckAccessActionShareInsert(lstNewAction);
       MobilizationSharing mobSharing=new MobilizationSharing();
       mobSharing.createSharing(Trigger.new,'Action__share');

    }
}