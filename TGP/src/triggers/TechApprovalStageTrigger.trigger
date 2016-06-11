/**
   @Author :Apoorva Sharma
   @name   : TechApprovalStageOperations 
   @CreateDate : 25 November 2015 
   @Description : This trigger is used for performing operations on Tech Approval Stage.
   @Version : 1.0 
  */
trigger TechApprovalStageTrigger on Tech_Approval_Stage__c(after delete, after insert, after update, before delete, before insert, before update) {
    if(trigger.isInsert){
        TechApprovalStageOperations.setVersion(trigger.new);
         
    }
    if(trigger.isAfter && trigger.isinsert){
        ShareStageWithOppTeam.newTechStage(trigger.new);
        TechApprovalStageOperations.updateOpportunityforReporting(trigger.new);
    }
    if(trigger.isdelete && trigger.isBefore){
        TechApprovalStageOperations.validateBeforeDelete(trigger.old);
    }
    if(trigger.isdelete && trigger.isAfter){
        TechApprovalStageOperations.resetVersion(trigger.old);
    }
    
    if(trigger.isInsert && trigger.isBefore){
        TechApprovalStageOperations.addStage(trigger.new);
    }
    
    if(trigger.isupdate && trigger.isBefore){
        List<Tech_Approval_Stage__c> updateApprovalStage = new List<Tech_Approval_Stage__c>();
         for(Tech_Approval_Stage__c temp:trigger.new){
            updateApprovalStage.add(temp);
         }
         TechApprovalStageOperations.stagestatus(trigger.old);
         if(!updateApprovalStage.isEmpty()){
           TechApprovalStageOperations.editApprovalStage(updateApprovalStage);
         }
    }
    If(trigger.isupdate && trigger.isAfter){
    	TechApprovalStageOperations.updateApprovalDate(trigger.new);
    }
    
}