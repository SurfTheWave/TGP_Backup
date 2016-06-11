trigger operationOnActionItem on action_item__c (after update,before delete,after insert) {
    
   Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
   if(flag){
   
       
           if(trigger.isAfter){
                if( trigger.isUpdate ){
                    operationOnActionItemTriggerController.actionTaskClose(Trigger.New);
                    shareStage.restrictShareForPrimaryOwner(Trigger.New);
                }
                
                if( trigger.isInsert ){
                    operationOnActionItemTriggerController.assignedByInActionItem( trigger.new );
                    shareStage.ShareStageWithPrimaryOwner(trigger.new);
                    shareStage.confidentialOppShareonActionItem(trigger.new);
                }
            }
        
           /*if( trigger.isBefore ){
                if( trigger.isDelete ){
                   // operationOnActionItemTriggerController.validateBeforeDelete( trigger.old );
                }
            }*/
          

    }
}