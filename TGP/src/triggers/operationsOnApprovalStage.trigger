/*
@Author and Created Date : jyotsna yadav,  1/7/2015 4:55 AM
@name : operationsOnApprovalStage 
@Description : 
@Version : 
*/
trigger operationsOnApprovalStage on Approval_Stage__c (before delete,after insert,before update,after update,after delete) {
   Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    if(flag){
        List<Approval_Stage__c> updateApprovalStage = new List<Approval_Stage__c>();
        if( trigger.isBefore ){
            if( trigger.isDelete ){
                operationsOnApprovalStageController.validateBeforeDelete( trigger.old);
           }
            
        }
        
        if( trigger.isInsert ){
                operationsOnApprovalStageController.setVersion(trigger.new);
                ShareStageWithOppTeam.newStage(trigger.new);
             if(Trigger.isAfter){
                System.debug('I CALLED INSERTOPPORTUNITYSVMCOMPLIANCE');
                operationsOnApprovalStageController.insertOpportunitySVMCompliance(Trigger.new);
            }
            }
        if(trigger.isAfter){
            if(trigger.isDelete){
                operationsOnApprovalStageController.reSetVersion(trigger.old);
            }
        }
        if(trigger.isBefore){
            if(trigger.isUpdate){
                for(Approval_Stage__c temp:trigger.new){
                        updateApprovalStage.add(temp);
                }
                operationsOnApprovalStageController.stagestatus(trigger.old);
                if(!updateApprovalStage.isEmpty()){
                    operationsOnApprovalStageController.editApprovalStage(updateApprovalStage);
                }
                
            }
        }
   
    }
}