/*
  @Author: Yasin Khan
  @Name: MobDealReminderBatch 
  @Created Date: 16 Dec 2015
  @Description: Send alert remainder to deal members if dealrag status is not updated.
  @version: 3.5 
*/

global class MobDealReminderBatch implements Database.Batchable<sObject>,Database.Stateful{    

  global String query;
  global List<Deal__c> dealRecords = new List<Deal__c>();
  global Set<id> dealSetIDs = new set<id>();
  
  global Database.QueryLocator start(Database.BatchableContext bc){
               query='SELECT CreatedDate, Id,Name,Active__c,Deal_RAG_status__c FROM Deal__c WHERE Active__c = true';                             
               return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext bc,List<sObject> sObjectList){            
            List<Deal__c> dealRecordList = ((List<Deal__c>)sObjectList);                       
            for(Deal__c deals : dealRecordList){         
                if(((deals.CreatedDate.date()).daysBetween(Date.today()) == 1)  && (deals.Deal_RAG_status__c == 'NA' || deals.Deal_RAG_status__c == Null)){
                        dealRecords.add(deals); 
                        dealSetIDs.add(deals.Id);
                }                   
            }
  } 

  public void finish(Database.BatchableContext bc) {   
        if(dealRecords.size() > 0 && dealSetIDs != null){
                 waveEmailRemainder.dealAlert(dealRecords,dealSetIDs); 
        }
  }
  
}