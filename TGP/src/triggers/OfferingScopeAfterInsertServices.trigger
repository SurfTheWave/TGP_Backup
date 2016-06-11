trigger OfferingScopeAfterInsertServices on Services__c (after insert, after delete) {
    List<Services__c> lstNewService = Trigger.new;
    List<Services__c> lstOldService = Trigger.old;

    private static final string TRIGGER_NAME = 'OfferingScopeAfterInsertServices';
    try{
        OfferingScopeTriggerController controller = new OfferingScopeTriggerController();
        if(Trigger.isAfter && Trigger.isInsert)  {
            controller.copyScopeFromServices(lstNewService);
        }
        if (Trigger.isAfter && Trigger.isDelete) {
            controller.copyScopeFromServices(lstOldService);
        }   
        
    }catch(Exception exp) {
        UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, null, null, 
                                                TRIGGER_NAME, System.Logginglevel.ERROR);
    }


}