/*
Author : Accenture Team 
@date create -  
@version - 0.1 
Story :
Description : All the trigger operations on opportunity, generally used.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
trigger OperationsOnOpportunity on Opportunity_TGP__c (after insert, after update, before update, before delete) {

    UserAccessUtility uam = new UserAccessUtility();
    OpportunityTriggerController opportunityTriggerControllerInstance = new OpportunityTriggerController();
    List<Opportunity_TGP__c> lstNewOpp = Trigger.new;
    List<Opportunity_TGP__c> lstOldOpp = Trigger.old;
    
    /*before Update Event*/
    if(trigger.isUpdate && trigger.isBefore ) {
        //OpptyClientGeoAreaPriorTrigger(Before Update)
        OpportunityTriggerController.storeOppClientGeoAreaPriorValue(lstNewOpp);
    }

    /*After Update Event*/
    else if(trigger.isUpdate && trigger.isAfter) {    
        Map<Id, Opportunity_TGP__c> oppIdMappedToNewRecord = Trigger.newMap;
        Map<Id, Opportunity_TGP__c> oppIdMappedToOldRecord = Trigger.oldMap;
        //trigger meetingProcessUpdate on Opportunity_TGP__c (after update) 
        ApprovalProcessPageController.refreshPageTrigger(lstNewOpp);
        ReviewProcessPageController.refreshPageTrigger(lstNewOpp);

        //SoluserInsertUpdate (After Update)        
        opportunityTriggerControllerInstance.updateSolutionUserAssignment(lstNewOpp);
        
        //AccessPermissionOpportunity(After Update) event check when records are updated
        uam.CheckAccessOpportunityDelete(lstOldOpp);   
        uam.CheckAccessOpportunity(lstNewOpp); 
        
        //swopportunitySharingLogic(After update), send email Client Geo Area to Region and Deal Radar Group
        opportunityTriggerControllerInstance.emailToClientGeoArea(lstNewOpp,lstOldOpp);
        //opportunityTriggerControllerInstance.emailOnDeliveryLocationChange(lstNewOpp,lstOldOpp);
        //logic to update BPO Net Revenue Range in Benchmark Tab
        //opportunityTriggerControllerInstance.updateNetRevenueRangeInBenchmark(oppIdMappedToNewRecord ,oppIdMappedToOldRecord,lstNewOpp,lstOldOpp  );   
        
        //Logic to update Offering scope value on SAP Om Opportunity
        //opportunityTriggerControllerInstance.updateOfferingscopeOnSap(lstNewOpp); 
        opportunityTriggerControllerInstance.refreshOfferingscopeOnSap(lstNewOpp, lstOldOpp);        
    }   

    /*After Insert Event */
    else if(trigger.isInsert && trigger.isAfter) {
        //SolUserInsertUpdate(After Insert) event check when the records are inserted.
        opportunityTriggerControllerInstance.insertSolutionUserAssignment(lstNewOpp);
        
        //swopportunitySharingLogic(After Insert), send email to Region and Deal Radar Group
        opportunityTriggerControllerInstance.emailToRegionAndDealRadarGroup(lstNewOpp);
        
        //AccessPermissionOpportunity(After Insert) event check when records are Inserted.
        uam.CheckAccessOpportunity(lstNewOpp);
        
        opportunityTriggerControllerInstance.insertOppTeam(lstNewOpp);
        //If the Opportunity is assiciated with Sap ID, then update the offerings__c on SAP
        opportunityTriggerControllerInstance.updateOfferingscopeOnSap(lstNewOpp);
    }     
    
    /*Before Delete Event */
    else if(trigger.isdelete && trigger.isBefore) {
        //AccessPermissionOpportunity(before delete) event check when records are Deleted.
        uam.CheckAccessOpportunityDelete(lstOldOpp);        
        opportunityTriggerControllerInstance.refreshOfferingscopeOnSap(lstOldOpp);
    }
    
}