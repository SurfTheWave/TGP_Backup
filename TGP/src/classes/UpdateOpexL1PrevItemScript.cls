global class UpdateOpexL1PrevItemScript implements Database.Batchable<sObject>, Database.Stateful{
    global final String query;
    global Long startTime;
    global Long endTime;

    
    global UpdateOpexL1PrevItemScript(String qur){
   
        query=qur;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        startTime=System.currentTimeMillis();
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<Wave__c> lstWave){
        
  
    List<Id> lstWaveIds = new List<Id>();
    for(Wave__c w: lstWave) {
    lstWaveIds.add(w.Id);
    }
    
    List<Id> lstOL1Ids = new List<Id>();
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c OL1: [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,New_Wave_Process_Id__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__r.Wave__c IN: lstWaveIds]) {
            lstOL1Ids.add(OL1.Id);
         }
         
                 
         List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1DayMinus3 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day7 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day30 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day60 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day90 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day90 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
        // List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day2 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day7 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day30 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day60 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
                          
         lstL1DayMinus3 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,New_Wave_Process_Id__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = -1];
         lstL1Day1 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,New_Wave_Process_Id__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 1];
         lstL1Day7 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,New_Wave_Process_Id__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 7];
         lstL1Day30 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,New_Wave_Process_Id__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 30];
         lstL1Day60 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,New_Wave_Process_Id__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 60];
         lstL1Day90 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,New_Wave_Process_Id__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 90];
         
       // system.debug('lstL1Day30 :'+lstL1Day30);         
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day60: lstL1Day60) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day90: lstL1Day90) {
                if((L1Day90.OPEX_Level_1_Tracking_Type__c == L1Day60.OPEX_Level_1_Tracking_Type__c) && (L1Day90.New_Wave_Process_Id__c == L1Day60.New_Wave_Process_Id__c)) {
                    L1Day90.Previous_Item__c = L1Day60.Id;
                    UpdatelstOTL1Day90.add(L1Day90);
                }
            }
        }
        try {
                       
         database.update(UpdatelstOTL1Day90,false);        
         
         }
         catch(Exception e) {
         system.debug('Exception:'+e);
         }
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day30: lstL1Day30) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day60: lstL1Day60) {
                if((L1Day60.OPEX_Level_1_Tracking_Type__c == L1Day30.OPEX_Level_1_Tracking_Type__c) && (L1Day60.New_Wave_Process_Id__c == L1Day30.New_Wave_Process_Id__c)) {
                    L1Day60.Previous_Item__c = L1Day30.Id;
                    UpdatelstOTL1Day60.add(L1Day60);
                }
            }
        }
        try {
                       
         database.update(UpdatelstOTL1Day60,false);        
         
         }
         catch(Exception e) {
         system.debug('Exception:'+e);
         }
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day7: lstL1Day7) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day30: lstL1Day30) {
                if((L1Day30.OPEX_Level_1_Tracking_Type__c == L1Day7.OPEX_Level_1_Tracking_Type__c) && (L1Day30.New_Wave_Process_Id__c == L1Day7.New_Wave_Process_Id__c)) {
                    L1Day30.Previous_Item__c = L1Day7.Id;
                    UpdatelstOTL1Day30.add(L1Day30);
                }
            }
        }
        try {
                       
         database.update(UpdatelstOTL1Day30,false);        
         
         }
         catch(Exception e) {
         system.debug('Exception:'+e);
         }
        
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day1: lstL1Day1) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day7: lstL1Day7) {
                if((L1Day7.OPEX_Level_1_Tracking_Type__c == L1Day1.OPEX_Level_1_Tracking_Type__c) && (L1Day7.New_Wave_Process_Id__c == L1Day1.New_Wave_Process_Id__c)) {
                    L1Day7.Previous_Item__c = L1Day1.Id;
                    UpdatelstOTL1Day7.add(L1Day7);
                }
            }
        }
        try {
                        
         database.update(UpdatelstOTL1Day7,false);        
         
         }
         catch(Exception e) {
         system.debug('Exception:'+e);
         }
        
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1DayM3: lstL1DayMinus3) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day1: lstL1Day1) {
                if((L1Day1.OPEX_Level_1_Tracking_Type__c == L1DayM3.OPEX_Level_1_Tracking_Type__c) && (L1Day1.New_Wave_Process_Id__c == L1DayM3.New_Wave_Process_Id__c)) {
                    L1Day1.Previous_Item__c = L1DayM3.Id;
                    UpdatelstOTL1Day1.add(L1Day1);
                }
            }
        }
        try {
                     
         database.update(UpdatelstOTL1Day1,false);        
         
         }
         catch(Exception e) {
         system.debug('Exception:'+e);
         }
        
        
        
    }
    
    global void finish(Database.BatchableContext bc){
        
        
        endTime=System.currentTimeMillis()-startTime;
        System.debug('Success all records are inserted start time' +startTime + 'And total time taken is' +endTime);
    }
}