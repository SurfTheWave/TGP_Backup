/*
@Author and Created Date : Suma Ganga,  2/25/2015 1:16 AM
@name : issueUpdateTrigger 
@Description : 
@Version : 
*/
trigger issueUpdateTrigger on Issues__c(after insert, before insert) {

    List < Issues__c > lstNewIssue = Trigger.new;
    // List<Issues__c> lstOldIssue = Trigger.old;

    
    
    if(Trigger.isBefore && Trigger.isInsert){
        issueUpdateController updateController = new issueUpdateController();
        updateController.populateFieldsAfterInsert(trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isInsert) {
        UAMSWBMWBUtility uamUtility = new UAMSWBMWBUtility();
        //uamUtility.CheckAccessIssueShareInsert(lstNewIssue);
        MobilizationSharing mobSharing=new MobilizationSharing();
        mobSharing.createSharing(Trigger.new,'Issues__share');

    }

}