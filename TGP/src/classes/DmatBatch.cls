/*****************
@author : Madhusudhan
@description : This class implements Batch class
 It will be updating the DMAT record for Journey Mgmt field
                
*******************/
global class DmatBatch implements Database.Batchable<sObject>,Database.Stateful{
    
     global Database.QueryLocator start(Database.BatchableContext bc){
        Date synDate=Date.today();
        String query='select name,Opportunity__c from Costing_Request__c where DAY_ONLY(Last_Synced_Date__c)=:synDate';
        system.debug('query locator---'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc,List<Costing_Request__c> costRequestList){
        set<id> oppIds=new set<id>();
         set<id> updateOppIds=new set<id>();
       for(Costing_Request__c costList : costRequestList ){   
           oppIds.add(costList.Opportunity__c);
       }
       if(!oppIds.isEmpty()){
            for(FTE_Details__c fteDetails :[SELECT Id,Mob_Category1__c,Mob_Sub_Category__c,Opportunity__c FROM FTE_Details__c where Opportunity__c in : oppIds and Opportunity__r.Is_Synced__c=true and Mob_Category1__c='Client Specific Costs']){
                if((('Others - Journey Management/ Change Management/ Communications').trim().equalsignorecase(fteDetails.Mob_Sub_Category__c))){
                    updateOppIds.add(fteDetails.Opportunity__c);
                }
            }
            List<DMAT__c> updateDmatList=new List<DMAT__c>();
            if(!oppIds.isEmpty()){
                for(DMAT__c dmatRecord :[SELECT Id,Opportunity_DMAT__c,Journey_Mgmt__c,Opportunity_DMAT__r.Is_Synced__c FROM DMAT__c where Opportunity_DMAT__c in : oppIds]){
                    if(updateOppIds.contains(dmatRecord.Opportunity_DMAT__c)){
                        dmatRecord.Journey_Mgmt__c='Yes';
                        updateDmatList.add(dmatRecord);
                    }else if(dmatRecord.Opportunity_DMAT__r.Is_Synced__c!=null && dmatRecord.Opportunity_DMAT__r.Is_Synced__c){
                        dmatRecord.Journey_Mgmt__c='No';
                        updateDmatList.add(dmatRecord);
                    }
                }
                if(!updateDmatList.isEmpty()){
                    Database.update(updateDmatList,false);
                }   
            }      
       }
    }
    public void finish(Database.BatchableContext bc) {
           
    }
}