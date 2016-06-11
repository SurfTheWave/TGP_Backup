/*
  @Author: Shivraj.Gangabyraiah
  @Name: Deal Trigger
  @Created Date: 03 January 2015
  @Description: This trigger is called on creation of new deals or if any deal is edited
  @version: 1.0
*/
trigger DealTrigger on Deal__c(before insert, after insert, before update, after update, before delete) {
    Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    
    if(flag){
            List < Deal__c > dealList = new List < Deal__c > ();
        List < Deal__c > dealTaskList = new List < Deal__c > ();
        List < Deal__c > dealMobilizationList = new List < Deal__c > ();
        List < Deal__c > dealToShareList = new List < Deal__C > ();
        List < Deal__c > dealToOpportunity = new List < Deal__C > ();
        List<Deal__c> dealGLevel=new List<Deal__c>();
        Boolean dealUpdated = false;
        try {
            if (trigger.IsUpdate && trigger.isBefore) {
                for (Deal__c deal: trigger.new) {
                    dealUpdated = true;
                    Deal__c oldDeal = trigger.oldMap.get(deal.Id);
                    if (!(deal.Opportunity__c).equals(oldDeal.Opportunity__c)) {
                        dealList.add(deal);
                    }
                    if (!(String.isEmpty(deal.Approval_Status__c))) {
                        if ((deal.Approval_Status__c).equals(utilConstants.PENDING_STATUS)) {
                            dealTaskList.add(deal);
                        }
                    }
                }
               //dealGLevel=trigger.new;
               
                 
            } else if (trigger.IsInsert && trigger.isAfter) {
                for (Deal__c deal: trigger.new) {
                    dealList.add(deal);
                }

               // ManageMoblilzationPlan.updateMobDurationonOpportunity(trigger.new);
                dealToShareList = trigger.new;
                dealToOpportunity = trigger.new;
                dealGLevel=trigger.new;
    
            } else if (trigger.isUpdate && trigger.isAfter) {

                ManageMoblilzationPlan.updateMobDurationonOpportunity(trigger.new);
                for (Deal__c deal: trigger.new) {
                    Deal__c oldDeal = trigger.oldMap.get(deal.Id);
                    if (!String.isEmpty(deal.Approval_Status__c)) {
                        if (!((deal.Approval_Status__c).equals(oldDeal.Approval_Status__c)) && ((deal.Approval_Status__c).equals(UtilConstants.APPROVED_STATUS))) {
                            dealMobilizationList.add(deal);
                        }
                    }
                    if (!(deal.Opportunity__c).equals(oldDeal.Opportunity__c)) {
                        dealToOpportunity.add(deal);
                    }
                }
            } else {        
            }
    
            if (!dealList.isEmpty()) {
                Deal.updateOpportunity(dealList, dealUpdated);
            }
            if (!dealTaskList.isEmpty()) {
                Deal.createTask(dealTaskList);
            }
            if (!dealMobilizationList.isEmpty()) {
                MobilizationTeam.createMobilizationTeam(dealMobilizationList);
            }
            if (!dealToShareList.isEmpty()) {
                Deal.shareDealRecord(dealToShareList);
            }
            if (!dealToOpportunity.isEmpty()) {
                Deal.updateClient(dealToOpportunity);
            }
            if(!dealGLevel.isEmpty()){
                Deal.updateGLevel(dealGlevel);
            }
            
        } catch (Exception e) {
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
            UtilConstants.DEAL, UtilConstants.DEAL, null, System.Logginglevel.ERROR);
        }
    }
    
}