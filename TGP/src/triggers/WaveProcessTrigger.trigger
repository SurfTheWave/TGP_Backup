/**
    @Author : Divyashree
    @name:  WaveProcessTrigger
    @CreateDate :  2/6/2015
    @Description:  Wave Record being deleted is checked if it is Active.  Only Inactive Wave records can be deleted
    @Version: 1.0
    @reference: None
*/
trigger WaveProcessTrigger on Wave_Proc__c (after insert,before delete) {


    List<Wave_Proc__c> waveProcessList = new List<Wave_Proc__c>();
    /*
    if(Trigger.isDelete){
        try{
            UTILMobClasses utilCls = new UTILMobClasses();
            //utilCls.checkDeletingActiveRecords(trigger.old);
            //utilCls.checkBeforeDeletingChildRecords(Trigger.old);
         }
         catch(Exception e){
             
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVEPROCESS_TRIGGER, UtilConstants.WAVEPROCESS_TRIGGER, null, System.Logginglevel.ERROR);
         }
    }
    */
    if(Trigger.isInsert && Trigger.isAfter){
        //try{
            WaveProcess.updateWave(Trigger.new);
        /* }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVEPROCESS_TRIGGER, UtilConstants.WAVEPROCESS_TRIGGER, null, System.Logginglevel.ERROR);
        } */
        
    }
    
}