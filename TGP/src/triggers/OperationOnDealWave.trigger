trigger OperationOnDealWave on Wave_Planning__c (after insert, after update, before insert) {
     List<Wave_Planning__c> lstNewDeal = Trigger.new;
    List<Wave_Planning__c> lstOldDeal = Trigger.old;
     boolean isActive = false;
    private static final string TRIGGER_NAME = 'OperationOnDealWave';
    try {
        DealWaveTriggerController controller = new DealWaveTriggerController();
        if(Trigger.isBefore && Trigger.isInsert) {
            controller.copyUserFromDealLocation(Trigger.new);
        }
        if(Trigger.isAfter && Trigger.isInsert) {
            controller.prePopulateTrackingInsert(Trigger.new);
            controller.UpdateTotalFTEsOnDeal(Trigger.new);
        }
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            controller.UpdateTotalFTEsOnDeal(Trigger.new);
            
            Boolean callPrePopulateTrackUpdt=false;
            for(Wave_Planning__c wavePlan:Trigger.new){
                if(wavePlan.active__c){    
                    callPrePopulateTrackUpdt=true;    
                    break;
                }
            }
            if(callPrePopulateTrackUpdt){
                controller.prePopulateTrackingUpdate(Trigger.new);
            }
            
            for(integer i=0;i<lstOldDeal.size();i++ )
            {
                if((lstOldDeal.get(i).KT_Lead_New__c != lstNewDeal.get(i).KT_Lead_New__c)
                    ||(lstOldDeal.get(i).Mobilization_KT_Lead_Secondary_New__c != lstNewDeal.get(i).Mobilization_KT_Lead_Secondary_New__c)
                    ||(lstOldDeal.get(i).Mobilization_KT_Lead_Secondary_2__c != lstNewDeal.get(i).Mobilization_KT_Lead_Secondary_2__c)
                    ||(lstOldDeal.get(i).Mob_Recruitment_Lead_Primary_New__c != lstNewDeal.get(i).Mob_Recruitment_Lead_Primary_New__c) 
                    ||(lstOldDeal.get(i).Mob_Recruitment_Lead_Secondary_New__c != lstNewDeal.get(i).Mob_Recruitment_Lead_Secondary_New__c)
                    ||(lstOldDeal.get(i).Mobilization_Opex_Lead_Primary_New__c != lstNewDeal.get(i).Mobilization_Opex_Lead_Primary_New__c)
                    ||(lstOldDeal.get(i).Mobilization_Opex_Lead_Secondary_New__c != lstNewDeal.get(i).Mobilization_Opex_Lead_Secondary_New__c)
                    ||(lstOldDeal.get(i).Mobilization_Opex_Lead_Secondary_2__c != lstNewDeal.get(i).Mobilization_Opex_Lead_Secondary_2__c)
                    ||(lstOldDeal.get(i).Mobilization_Technology_Lead_Primary_New__c != lstNewDeal.get(i).Mobilization_Technology_Lead_Primary_New__c)
                    ||(lstOldDeal.get(i).Mob_Technology_Lead_Secondary_New__c != lstNewDeal.get(i).Mob_Technology_Lead_Secondary_New__c)
                    ||(lstOldDeal.get(i).Mob_Technology_Lead_Secondary_2__c != lstNewDeal.get(i).Mob_Technology_Lead_Secondary_2__c)){
                     isActive=true;
                     break;
                }
            }
        if(isActive){
         controller.accessPermissionDealWave(Trigger.new, Trigger.old); 
        }        
        }
    }
    catch(Exception exp) {
        UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, null, null, 
                                                TRIGGER_NAME, System.Logginglevel.ERROR);
    }
}