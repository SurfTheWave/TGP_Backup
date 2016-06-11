/*
  @Author: Shivraj.Gangabyraiah
  @Name: Deal
  @Created Date: 03 January 2015
  @Description: This class is called to update the deal field in Opportunity class when a deal is created
                or modified
  @version: 1.0
*/
public  without sharing class Deal {
    /*
    @Description: This method accepts list of Deal objects from trigger.new and updates the opportunity
                  record with deal id. If a deal record is update, this method updates old oppprtuity 
                  record with a null deal value and latest oppportunity with deal id
    @Required Parameters: Deal List
    @Return Parameters: void
    */
    public static void updateOpportunity(List<Deal__c> dealList,Boolean flag){
        set<Id> oppurtunityId = new Set<Id>();
        set<Id> dealId = new Set<Id>();
        List<Opportunity> oppurtunityList =  new List<Opportunity>();
        set<id> dealWithOpportunityId = new set<id>();
        
        try{
            for(Deal__c deal:dealList){
                oppurtunityId.add(deal.Opportunity__c);
                dealId.add(deal.Id);
            }
            
            for(Opportunity opportunity:[select id,Deal__c from Opportunity where id in:oppurtunityId LIMIT 5000]){
                for(Deal__c dealToUpdate: dealList){
                    if(null!=opportunity.Deal__c){
                        if(!(opportunity.Deal__c.equals(dealToUpdate.id))){
                            opportunity.Deal__c = dealToUpdate.id;
                            oppurtunityList.add(opportunity);
                        }
                    }
                    else{
                        opportunity.Deal__c = dealToUpdate.id;
                        oppurtunityList.add(opportunity);
                    }
                }
            }
            if(flag){
                List<Deal__c> dealWithOpportunityList = [select id,Opportunity__c from Deal__c where id in:dealId LIMIT 5000];
            
                for(Deal__c dealWithOpportunity:dealWithOpportunityList){
                    Id OpportunityId = dealWithOpportunity.Opportunity__c;
                    dealWithOpportunityId.add(OpportunityId);
                }
            
                for(Opportunity opportunityToUpdate:[select id,deal__c from opportunity where id in:dealWithOpportunityId LIMIT 5000]){
                    for(Deal__c deal:dealWithOpportunityList){
                        if(null!=opportunityToUpdate.Deal__c){
                            if(opportunityToUpdate.Deal__c.equals(deal.id)){
                                opportunityToUpdate.Deal__c=null;
                                oppurtunityList.add(opportunityToUpdate);
                            }
                        }else{
                            opportunityToUpdate.Deal__c=null;
                            oppurtunityList.add(opportunityToUpdate);
                        }
                    }
                }
            
            }
            
          Database.upsert(oppurtunityList);   
        
        }catch(Exception e){
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.DEAL , UtilConstants.DEAL , null, System.Logginglevel.ERROR);
        }
    }
     
    /*
      @Description: This method is used to create a new task for approver.
      @Required Parameters: List of Deals
      @Return Parameter: void
    */
    public static void createTask(List<Deal__c> deals){
        List<Task> taskList =  new List<Task>();
        Task task=new Task();
        for(Deal__c deal:deals){
            task = new Task();
            task.OwnerId = deal.Approver__c;
            task.Priority = UtilConstants.TASK_PRIORITY;
            task.Status = UtilConstants.TASK_STATUS;
            task.Subject = UtilConstants.TASK_SUBJECT;
            task.ActivityDate = Date.today().addDays(5);
            task.ReminderDateTime = Date.today().addDays(3);
            task.Task__c = URL.getSalesforceBaseUrl().toExternalForm()+ UtilConstants.SLASH +deal.id;                
            task.WhatId = deal.Id;
            taskList.add(task);
        }   
        try{
            if(!taskList.isEmpty()){
                Database.insert(taskList);
            }
        }catch(DMLException e){
           //system.debug('E==='+e);
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                    UtilConstants.DEAL , UtilConstants.DEAL , null, System.Logginglevel.ERROR);
        }
    }
    
    /*
      @Description: This method is used to provide share access to deal record.
      @Required Parameters: List of Deals
      @Return Parameter: void
    */
    public static void shareDealRecord(List<Deal__c> dealToShareList){
        List<Deal__Share> dealShare = new List<Deal__Share>();
        Deal__Share ds=null;
        try{
            for(Deal__C dealtoShare:dealToShareList){
                
                ds = new Deal__Share();
                ds.ParentId = dealtoShare.id;
                ds.UserOrGroupId = dealtoShare.Approver__c;
                ds.AccessLevel=UtilConstants.EDIT;
                
                dealShare.add(ds);
            }
            
            Database.insert(dealShare);
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.DEAL , UtilConstants.DEAL , null, System.Logginglevel.ERROR);
        }
    }
    
     /*
      @Description: This method is used to update client field on deal from opportunity during insert
      @Required Parameters: List of Deals
      @Return Parameter: void
    */
    public static void updateClient(List<Deal__c> dealList){
        
        try{
            List<Deal__c> dealToUpdate=new List<Deal__C>();
            
            for(Deal__c deal:[select id,name,opportunity__r.AccountId from Deal__C where id IN:dealList Limit 5000 ]){
                deal.client__c=deal.opportunity__r.AccountId;
                dealToUpdate.add(deal);
            }
            
            Database.update(dealToUpdate);
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.DEAL , UtilConstants.DEAL , null, System.Logginglevel.ERROR);
        }
            
    }
    
    /*
      @Description: This method is used to update offering field on deal as comma separated values when Client process is inserted
      @Required Parameters: List of Deals
      @Return Parameter: void
    */
    public static void updateOffering(List<SObject> processList){
        set<Id> dealid=new set<Id>();
        String offeringvalue=UtilConstants.BLANK;
        List<Deal__c> dealToUpdate=new List<Deal__c>();
        try{
            for(SObject itrObj:processList){
                if(itrObj instanceof Client_Specific_Process__c){
                    Client_Specific_Process__c clientSpecificProcess=(Client_Specific_Process__c)itrObj;
                    dealId.add(clientSpecificProcess.Deal__c);
                }else if(itrObj instanceof Infrastructure_Service__c){
                    Infrastructure_Service__c infrastructureProcess=(Infrastructure_Service__c)itrObj;
                    dealId.add(infrastructureProcess.Deal__c);
                }else{
                    
                }
            }
            
            Map<Id,List<Client_Specific_Process__c>> dealClntPrcsMap=new Map<Id,List<Client_Specific_Process__c>>();
            for(Client_Specific_Process__c itrObj:[Select id,deal__c,Process_Offering__r.name 
                                                   from Client_Specific_Process__c  WHERE deal__c IN:dealId LIMIT 5000]){
                if(dealClntPrcsMap.containsKey(itrObj.deal__c)){
                    List<Client_Specific_Process__c> tempClntSpPrcsList=dealClntPrcsMap.get(itrObj.deal__c);
                    tempClntSpPrcsList.add(itrObj);
                }else{
                    List<Client_Specific_Process__c> tempClntSpPrcsList=new List<Client_Specific_Process__c>();
                    tempClntSpPrcsList.add(itrObj);
                    dealClntPrcsMap.put(itrObj.deal__c,tempClntSpPrcsList);
                }
            }
            Map<Id,List<Infrastructure_Service__c>> dealInfPrcsMap=new Map<Id,List<Infrastructure_Service__c>>();
            for(Infrastructure_Service__c itrObj:[Select id,deal__c,ServiceOffering__r.name 
                                                  from Infrastructure_Service__c  WHERE deal__c IN:dealId LIMIT 5000]){
                if(dealInfPrcsMap.containsKey(itrObj.deal__c)){
                    List<Infrastructure_Service__c> tempInfSpPrcsList=dealInfPrcsMap.get(itrObj.deal__c);
                    tempInfSpPrcsList.add(itrObj);
                }else{
                    List<Infrastructure_Service__c> tempInfSpPrcsList=new List<Infrastructure_Service__c>();
                    tempInfSpPrcsList.add(itrObj);
                    dealInfPrcsMap.put(itrObj.deal__c,tempInfSpPrcsList);
                }
            }
                
            for(Id itrId:dealId){
                offeringvalue=UtilConstants.BLANK;
                if(dealClntPrcsMap.containsKey(itrId)){
                    for(Client_Specific_Process__c itrObj:dealClntPrcsMap.get(itrId)){
                        if(String.isBlank(offeringvalue)){
                            offeringvalue=  itrObj.Process_Offering__r.name;
                        }else{
                            offeringvalue=offeringvalue + UtilConstants.COMMA +itrObj.Process_Offering__r.name;
                        }
                    }
                }
                if(dealInfPrcsMap.containsKey(itrId)){
                    for(Infrastructure_Service__c itrObj:dealInfPrcsMap.get(itrId)){
                        if(String.isBlank(offeringvalue)){
                            offeringvalue=  itrObj.ServiceOffering__r.name;
                        }else{
                            offeringvalue=offeringvalue + UtilConstants.COMMA +itrObj.ServiceOffering__r.name;
                        }
                    }
                }
                
                Deal__c deal=new Deal__C();
                deal.Id=itrId;
                deal.Offering_Deal__c=offeringvalue;
                dealToUpdate.add(deal);     
            }
            
            if(dealToUpdate.size() > 0){
                Database.update(dealToUpdate);
             }
             
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.DEAL , UtilConstants.DEAL , null, System.Logginglevel.ERROR);
        }
    }
    
    /*
      @Description: This method is used to update Governance_Attention_Level__c field on deal when deal is inserted
      @Required Parameters: List of Deals
      @Return Parameter: void
    */
   public static void updateGLevel(List<Deal__c> dealList){
        try{
            List<Deal__c> dealUpdate=new List<Deal__C>();
            for(Deal__c deal:[select id,Offering_Opportunity__c,Opportunity__r.Off__c,Governance_Attention_Level__c,Service_Group__c , 
                                        Opportunity__r.Offerings_IO__c , Opportunity__r.Offerings_IC__c, 
                                        Opportunity__r.Governance_Attention_Level__c,Total_Contract_BPO_Value__c,Opportunity__r.IO_Net_Revenue_Thousands__c,
                                        Total_Contract_Value__c,Opportunity__r.BPO_Net_Rev_Thousands__c,Opportunity__r.Total_Current_Net_Rev__c 
                                        FROM Deal__c where ID IN :dealList LIMIT 2000]){
                String gLevel=deal.Opportunity__r.Governance_Attention_Level__c;
                deal.Governance_Attention_Level__c=gLevel;
                deal.Total_Contract_BPO_Value__c=deal.Opportunity__r.BPO_Net_Rev_Thousands__c;
                deal.Total_Contract_Value__c=deal.Opportunity__r.Total_Current_Net_Rev__c;
                if((deal.Service_Group__c).equals(UtillContstant_Novasuite.BPO)){
                    deal.Offering_Opportunity__c=deal.Opportunity__r.Off__c;
                }
                else if((deal.Service_Group__c).equals(UtillContstant_Novasuite.IO)){
                    deal.Offering_Opportunity__c=deal.Opportunity__r.Offerings_IO__c ;
                }
                else{
                    deal.Offering_Opportunity__c=deal.Opportunity__r.Offerings_IO__c + deal.Opportunity__r.Off__c;
                }
                deal.Total_Contract_IO_Value__c  = deal.Opportunity__r.IO_Net_Revenue_Thousands__c;
                dealUpdate.add(deal);
            }
            //System.debug(dealUpdate + '>>> <<< Deal Update');
            database.update(dealUpdate);
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.DEAL , UtilConstants.DEAL , null, System.Logginglevel.ERROR);
        }
        
        
    }
           
}