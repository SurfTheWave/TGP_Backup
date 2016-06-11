/*
*@Author : Vaishnavi
*@CreatedDate : 12/17/2015
*@Description : This batch will do batch update on utilization
*/

global class Batch_UtilizationUpdate implements Database.Batchable<sObject>
{
    
    
    global Database.QueryLocator start(Database.BatchableContext context)
    {
        String query ='Select Id, Active__c, Opportunity__c, User__c, User_Role_s__c from Utilizations__c where Active__c = TRUE and Opportunity__c != NULL';
        System.debug('Start query-->' + query);                
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext context, List<Utilizations__c> utiList)
    {
        Set<ID> oppIds = new Set<ID>();
        Set<ID> userIDs = new Set<ID>();
        String tempString = '';
        List<Utilizations__c> utiListToUpdate = new List<Utilizations__c>();
        Map<ID, String> mapOfUtiRoles = new Map<ID, String>();
        
        for(Utilizations__c utilRecs : utiList)
        {
            oppIDs.add(utilRecs.Opportunity__c);
            userIDs.add(utilRecs.User__c);
        }
        List<Opportunity_Teams__c> oppTList = [Select ID, Role__r.Name, Opportunity__c, Opportunity_Team_Member__c from Opportunity_Teams__c where Opportunity__c IN : oppIDs and
            Opportunity_Team_Member__c IN : userIDs and Role__c != NULL];
            
        System.debug('oppTList-->'+oppTList.size());

        for(Utilizations__c uti :utiList)
        {
            
            for(Opportunity_Teams__c oppT : oppTList)
            {
                if(oppT.Opportunity_Team_Member__c == uti.User__c)
                {
                    System.debug('Inside first IF');
                    if(oppT.Opportunity__c == uti.Opportunity__c)
                    {
                        System.debug('Inside Second IF');
                        if(mapOfUtiRoles.containsKey(uti.Id))
                        {
                            System.debug('Map contains key');
                            tempString = mapOfUtiRoles.get(uti.Id);
                            if(!tempString.contains(oppT.Role__r.Name))
                            {
                                System.debug('Key doesnt contains role');
                                tempString += ';' + oppT.Role__r.Name;
                                mapOfUtiRoles.put(uti.Id, tempString);
                            }
                        }
                        else
                        {
                            System.debug('Map does not contains key');
                            mapOfUtiRoles.put(uti.Id, oppT.Role__r.Name);
                        }
                        
                    }
                }
            }
        }
        for(Utilizations__c util : utiList)
        {
            util.User_Role_s__c = mapOfUtiRoles.get(util.ID);
            utiListToUpdate.add(util);
        }
        
        update utiListToUpdate;
    }
    
    global void finish(Database.BatchableContext context)
    {
    }
}