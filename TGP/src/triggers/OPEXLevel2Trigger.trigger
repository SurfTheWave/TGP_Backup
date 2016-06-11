/**
   @Author :Mobilization WorkBench
   @name   : OPEXLevel2Trigger  
   @CreateDate : 12 December 2015 
   @Description : This is a trigger in MWB
   @Version : 1.0 
  */
trigger OPEXLevel2Trigger on Deal_OPEX_Additional_Tracking_Level_2__c (before insert, before update) {
    
    Boolean flagtoEnableTrigger=false;
    List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
    flagtoEnableTrigger = flagCheckList[0].FieldOne__c; 
    
    
    if(flagtoEnableTrigger){
        
        if(Trigger.IsBefore && Trigger.IsInsert){
            SRATUpdateController updateController = new SRATUpdateController();
            updateController.populateOPEXinLevel2(trigger.new);
        }
    }
}