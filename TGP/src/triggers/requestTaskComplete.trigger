/*
@Author and Created Date : IO Solution Editor,  1/5/2015 5:32 AM
@name : requestTaskComplete 
@Description : 
@Version : 
*/
trigger requestTaskComplete on approval_request__c (before update,after update,before delete,after insert) {

    if(Trigger.isInsert && trigger.isAfter){
        shareStage.confidentialOppShare(trigger.new);
    }
   Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
        system.debug('flagCheckList'+flag);
    }
    if(flag){
    if(trigger.isAfter){
        if( trigger.isUpdate ){
       
          requestTaskClose.requestTaskClose(Trigger.New);
            requestTaskClose.sendMail(Trigger.New);
            for(approval_request__c appRec : trigger.new){
            system.debug('appRec record-->'+appRec);
           if(appRec.approval_request_status__c.Equals(UtilConstants.APPRVD))
           {
            
           if(!appRec.approval_request_type__c.Equals(UtilConstants.FIN_APPRBPO)){
            requestTaskClose.sendEmailToApprover(Trigger.new);
           }
           
           else if(!appRec.approval_request_type__c.Equals(UtilConstants.FIN_APPRIO))
           {
           requestTaskClose.sendEmailToApprover(Trigger.new);
           }
           
           else if(!appRec.approval_request_type__c.Equals(UtilConstants.FIN_APPRIC))
           {
           requestTaskClose.sendEmailToApprover(Trigger.new);
           }
           system.debug('appRec status-->'+appRec.approval_request_type__c);
           }
         }
            oppSVMComplianceController.updateDelvApprSVM(trigger.new);
            requestTaskClose.updateOperationalApprovalDate(trigger.new);
            shareStage.restrictShare(Trigger.Old);
        }
    }
   //Added by Jyotsna Start
    if( trigger.isBefore ){
        if( trigger.isUpdate ){
              shareStage.share(Trigger.new);
           requestTaskClose.getApproverRequsetUserMap( trigger.old );
           //requestTaskClose.validateBeforeEdit( trigger.oldMap,trigger.new );
        }
        if( trigger.isDelete ){
            requestTaskClose.validateBeforeDelete( trigger.old );
        }
    }
    //Added by Jyotsna End
       }
}