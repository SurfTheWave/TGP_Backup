global class DataCorrectionScheduleClass implements Schedulable{ 
    global void execute(SchedulableContext SC) {
        List<FlagCheck__c> flagCheckList= FlagCheck__c.getAll().values();
        flagCheckList[0].MMS_Object_Key__c=false;
        flagCheckList[0].RunOppTrigger__C=false;
        update flagCheckList;
        Id batch=database.executeBatch(new Batch_OpportunityDataCorrection(),1000);
        flagCheckList[0].MMS_Object_Key__c=true;
        flagCheckList[0].RunOppTrigger__C=true;
        update flagCheckList;
    }
}