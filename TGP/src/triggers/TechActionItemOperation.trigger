/**
   @Author :Mobilization WorkBench
   @name   : TechActionItemOperation 
   @CreateDate : 12 December 2015 
   @Description : This is a trigger on Tech_Action_Items__c.
   @Version : 1.0 
  */
trigger TechActionItemOperation on Tech_Action_Items__c (after update,before delete,after insert,before insert) {
    
   Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
   if(flag){
    if(trigger.isinsert && trigger.isbefore){
        TechActionItemLogReminder.addActionItem(trigger.new);
    
    }
       
           if(trigger.isAfter){
                if( trigger.isUpdate ){
                    TechActionItemOperationTriggerController.actionTaskClose(Trigger.New);
                    
                }
                
                if( trigger.isInsert ){
                    TechActionItemOperationTriggerController.assignedByInActionItem( trigger.new );
                    shareTechStage.ShareStageWithPrimaryOwner(trigger.new);
                    shareTechStage.confidentialOppShareonActionItem(trigger.new);
                    
                }
            }
        
           
          

    }
}