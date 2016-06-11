/**
   @Author : Reena Thakre
   @name   : operationOnGovernanceTrigger
   @CreateDate : 21 Jan 2015 
   @Description : Trigger on Governance object
   @Version : 1.0 
  */
trigger operationOnGovernanceTrigger on SD_Governance_Data__c(after Update, after insert,before update) {

    List < SD_Governance_Data__c > govListToUpdate = new List < SD_Governance_Data__c > ();


    if (trigger.isAfter) {
        if (trigger.isInsert) {
            operationOnGovernanceTriggerController obj = new operationOnGovernanceTriggerController();
            obj.afterInsertTaskOnGov(trigger.new);

        }

        if (trigger.isUpdate) {
            for (integer i = 0; i < trigger.new.size(); i++) {

                if (trigger.new[i].SD_Gov_Lead_Coach__c != trigger.old[i].SD_Gov_Lead_Coach__c) govListToUpdate.add(trigger.new[i]);
            }

            operationOnGovernanceTriggerController obj = new operationOnGovernanceTriggerController();
            obj.afterUpdateTaskOnGov(govListToUpdate);

        }
    }
    
    /*if(trigger.isUpdate && trigger.isbefore){
            GovernanceData.updateGoveraceDate(trigger.new);
    }*/
    
    if(trigger.isInsert&& trigger.isbefore){
        if(!UtilConstantsR3.runGovTrigger){
            for(SD_Governance_Data__c  sdGov:trigger.new){
              
                sdGov.addError('You don\'t have necessary level of access.');
            }
        }
    }

}