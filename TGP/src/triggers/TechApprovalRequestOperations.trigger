/**
   @Author :Apoorva Sharma
   @name   : TechApprovalDocumentsTrigger 
   @CreateDate : 27 November 2015 
   @Description : This trigger is used for performing operations on Tech Approval Request.
   @Version : 1.0 
  */
trigger TechApprovalRequestOperations on Tech_Approval_Request__c (after delete, after insert, after update, before delete, before insert,before update) {
     if( trigger.isDelete ){
            TechApprovalRequestOperations.validateBeforeDelete( trigger.old );
      }
      if(Trigger.isInsert && trigger.isAfter){
        sharetechStage.confidentialOppShare(trigger.new);
    }
    
    if(Trigger.isInsert && trigger.isBefore){
        for(Tech_Approval_Request__c  techReq :trigger.new){
            techReq.Service_Group__c='BPO';
            techReq.approval_request_status__c=UtilConstants.PEND_WITH_REQSTR;
            techReq.RecordTypeId= Schema.SObjectType.Tech_Approval_Request__c.getRecordTypeInfosByName().get('Prior/Post Approval').getRecordTypeId();
        }
        TechApprovalRequestOperations.addRequest(trigger.new);
    }    
      Set<id>stageRec=new set<id>();
      String FinalApproval;
        if( trigger.isUpdate && trigger.isAfter ){
        system.debug('trigger.new--------------------------------->'+Trigger.new);
            TechApprovalRequestOperations.updateTechSolutionDeckScore(Trigger.new);
            TechApprovalRequestOperations.requestTaskClose(Trigger.New);
            TechApprovalRequestOperations.sendMail(Trigger.New);
            for(Tech_Approval_Request__c appRec : trigger.new){
                if(appRec.approval_request_status__c.Equals(UtilConstants.APPRVD)){
                    if(appRec.Final_Approval__c!=null){
                        if(!appRec.approval_request_type__c.equalsignorecase(appRec.Final_Approval__c)){
                            TechApprovalRequestOperations.sendMailToFinalApprover(Trigger.new);
                        }
                    }
                }
                if(appRec.approval_request_status__c.Equals(UtilConstants.APPRVD) &&
                    appRec.approval_request_type__c.equalsignorecase(appRec.Final_Approval__c)){
                        stageRec.add(appRec.Approval_Stage__c);
                        FinalApproval=appRec.Final_Approval__c;
                        
                }
            }
            if(!stageRec.isEmpty()){
                TechApprovalStageOperations.approveApprovalStage(stageRec);
                TechApprovalRequestOperations.restrictApproval(Trigger.new,FinalApproval);
            }
            shareTechStage.restrictShare(Trigger.Old);
        }
        if( trigger.isBefore ){
        if( trigger.isUpdate ){
              sharetechStage.share(Trigger.new);
              }
          }
        
}