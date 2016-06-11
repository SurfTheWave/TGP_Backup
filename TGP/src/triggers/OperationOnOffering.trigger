/*  
 *  After Insert, After update, before delete, before insert, before update trigger for Opportunity_Offering__c . 
 *  
 * 
 *  @author - Accenture Team 
 *  @date create - 18/2/2014
 *  @version - 0.1 
 */
trigger OperationOnOffering on Opportunity_Offering__c (after insert, after update,after delete, before delete, before insert, before update) {
    // Create the instance of controller class
    UserAccessUtility uam = new UserAccessUtility();
    if(Trigger.isBefore && Trigger.isInsert) {
        if(!Recursive.offeringsNameFlag && !Recursive.opportunityNameFlag)  {
            PreventDuplicateOfferingsController.offeringsNameCheckInsert();
        }
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        if(!Recursive.offeringsNameFlag && !Recursive.opportunityNameFlag) {
            PreventDuplicateOfferingsController.offeringsNameCheckUpdate();
        }
    }
    if (Trigger.isBefore && Trigger.isDelete) {
        //uam.CheckAccessOfferingDelete(Trigger.old); 
    }
    if(Trigger.isAfter && Trigger.isInsert) {
       // uam.CheckAccessOffering(Trigger.new);
        offeringTriggerController.insertSolUserAssignment(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        //uam.CheckAccessOfferingDelete(Trigger.old);   
        //uam.CheckAccessOffering(Trigger.new);
        offeringTriggerController.updateAndEmailSolUserAssignement(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isDelete) {
        offeringTriggerController.deleteOfferingrec(Trigger.old);
    }
    
}