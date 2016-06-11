trigger triggerOnDmat on DMAT__c (after insert, after update,before insert) {
if(trigger.isBefore && trigger.isInsert){
       operationOnOppTeamTriggerController.restrictDmatUser(trigger.new);
    }
    if((trigger.isInsert&&trigger.isAfter) || (trigger.isUpdate&&trigger.isAfter)){
         if(RecursiveTriggerHelper.runOnce()){
            set<id> oppIds=new set<id>();
            set<id> updateOppIds=new set<id>();
            for(DMAT__c dmat: Trigger.New){
                oppIds.add(dmat.Opportunity_DMAT__c);
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
                        system.debug('Is_Synced__c----- '+dmatRecord.Opportunity_DMAT__r.Is_Synced__c);
                        if(updateOppIds.contains(dmatRecord.Opportunity_DMAT__c)){
                            dmatRecord.Journey_Mgmt__c='Yes';
                            updateDmatList.add(dmatRecord);
                        }else if(dmatRecord.Opportunity_DMAT__r.Is_Synced__c!=null && dmatRecord.Opportunity_DMAT__r.Is_Synced__c){
                            system.debug('inside else if');
                            dmatRecord.Journey_Mgmt__c='No';
                            updateDmatList.add(dmatRecord);
                        }
                    }
                    try{
                    if(!updateDmatList.isEmpty()){
                        Database.update(updateDmatList,false);
                    }   
                    }catch(Exception e){
                        system.debug('exception ---- '+e);
                        
                    }
                }      
            }
        }
    }
}