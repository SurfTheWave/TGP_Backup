/**
    @Author : Divyashree
    @name:  WaveTrigger 
    @CreateDate :  1/3/2015
    @Description:  Wave Record being deleted is checked if it is Active.  Only Inactive Wave records can be deleted
    @Version: 1.0
    @reference: None
*/
trigger WaveTrigger on Wave__c(after insert, after update, before update, before insert, after delete, before delete) {
    Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    if(flag){
        List < Wave__c > lstNewWave = Trigger.new;
        List < Wave__c > lstOldWave = Trigger.old;
        List < Wave__c > waveList = new List < Wave__C > ();
        try {
            if (Trigger.isInsert || Trigger.isUpdate) {
                WaveTrackerApex waveTracker = new WaveTrackerApex();
                if (Trigger.isAfter && Trigger.isInsert) {
                    waveTracker.prePopulateTrackingInsert(lstNewWave);
                }
                if (Trigger.isAfter && Trigger.isUpdate) {
                    for (Wave__c wave: Trigger.new) {
                        if (wave.Procurement_Q1_Start_Date__c != Trigger.oldMap.get(wave.Id).Procurement_Q1_Start_Date__c) {
                            waveList.add(wave);
                        }
                    }
                    if (!waveList.isEmpty()) {
                        ProcurementClass.createSpendSavingsPlan(waveList);
                    }
    
                }
            }
            /*
         else if(Trigger.IsDelete){
            UTILMobClasses utilCls = new UTILMobClasses();
            utilCls.checkDeletingActiveRecords(trigger.old);
         }
        
       */


        } catch (Exception e) {
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
            UtilConstants.WAVE_TRIGGER, UtilConstants.WAVE_TRIGGER, null, System.Logginglevel.ERROR);
        }

    }
    
}