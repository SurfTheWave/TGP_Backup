trigger operationOnOpportunityTeam on Opportunity_Team__c (after Insert, after update, after delete) {
    
    UserAccessUtility uam = new UserAccessUtility();
    List<Opportunity_Team__c> lstNewOpp = Trigger.new;
    List<Opportunity_Team__c> lstOldOpp = Trigger.old;
    
    if(Trigger.isInsert && Trigger.isAfter) {
          OpportunityTeamTriggerController.insertUtilizationRecords(Trigger.New);
          //uam.CheckAccessOpportunityDelete(lstOldOpp);   
          uam.CheckAccessOpportunityTeam(lstNewOpp);
          OpportunityTeamTriggerController.insertSolUserAssignment(Trigger.New); 
    }
    else If(Trigger.isUpdate && Trigger.isAfter) {
          OpportunityTeamTriggerController.updateUtilizationRecords(Trigger.New, Trigger.Old);
          OpportunityTeamTriggerController.updateSolUserAssignment(Trigger.New, Trigger.Old);
          uam.CheckAccessOpportunityTeamDelete(lstOldOpp);   
          uam.CheckAccessOpportunityTeam(lstNewOpp); 
    }
    else If(Trigger.isDelete && Trigger.isAfter){
          OpportunityTeamTriggerController.deleteUtilizationRecords(Trigger.Old);
          uam.CheckAccessOpportunityTeamDelete(lstOldOpp);
    }
}