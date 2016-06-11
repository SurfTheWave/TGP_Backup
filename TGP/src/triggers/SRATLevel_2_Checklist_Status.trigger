/**
   @Author :Mobilization WorkBench
   @name   :SRATLevel_2_Checklist_Status
   @CreateDate : 12 December 2015 
   @Description : This is a trigger on SRAT_Additional_Tracking_Level_2__c.
   @Version : 1.0 
  */
trigger SRATLevel_2_Checklist_Status on SRAT_Additional_Tracking_Level_2__c (After Update, before insert) {

    Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    
    if(flag) {
    
    
    SRATUpdateController updateController = new SRATUpdateController();
    if(trigger.isafter && trigger.isUpdate){       
            updateController.changehecklistStatusLevel2AfterUpdate(trigger.oldmap, trigger.new);          
            
    }
    
    if(Trigger.IsBefore && Trigger.IsInsert){
        updateController.populateSRATinLevel2(trigger.new);
    }
    
  }
}