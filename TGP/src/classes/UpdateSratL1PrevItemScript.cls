global class UpdateSratL1PrevItemScript implements Database.Batchable<sObject>, Database.Stateful{
    global final String query;
    global Long startTime;
    global Long endTime;

    
    global UpdateSratL1PrevItemScript(String qur){
        
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
List<Id> lstSL1Ids = new List<Id>();
         
         for(SRAT_Additional_Tracking_Level_1__c SL1: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__r.Wave__c IN: lstWaveIds]) {
            lstSL1Ids.add(SL1.Id);
         }
                
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSTL1Item5 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSTL1Item30 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSTL1Item60 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSTL1Item90 = new List<SRAT_Additional_Tracking_Level_1__c>();
         
         List<SRAT_Additional_Tracking_Level_1__c> lstSL1Item30 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = -30];
         List<SRAT_Additional_Tracking_Level_1__c> lstSL1Item60 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = -60];
         List<SRAT_Additional_Tracking_Level_1__c> lstSL1Item90 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = -90];
         List<SRAT_Additional_Tracking_Level_1__c> lstSL1Item120 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = -120];

                 
          for(SRAT_Additional_Tracking_Level_1__c SL1Item5: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = -5]) {
            for(SRAT_Additional_Tracking_Level_1__c SL1Item30: lstSL1Item30) {
                if( (SL1Item30.SRAT_Level_1_Tracking_Type__c == SL1Item5.SRAT_Level_1_Tracking_Type__c) && (SL1Item30.SRAT_Tracker__r.Wave__c == SL1Item5.SRAT_Tracker__r.Wave__c) ) {
                    SL1Item5.Previous_Item__c = SL1Item30.Id;
                    UpdatelstSTL1Item5.add(SL1Item5);
                }
            }
        }
        
         if(!UpdatelstSTL1Item5.isEmpty()) {               
         update UpdatelstSTL1Item5;        
         }
         
        
          for(SRAT_Additional_Tracking_Level_1__c SL1Item30: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = -30]) {
            for(SRAT_Additional_Tracking_Level_1__c SL1Item60: lstSL1Item60) {
                if( (SL1Item30.SRAT_Level_1_Tracking_Type__c == SL1Item60.SRAT_Level_1_Tracking_Type__c) && (SL1Item30.SRAT_Tracker__r.Wave__c == SL1Item60.SRAT_Tracker__r.Wave__c) ) {
                    SL1Item30.Previous_Item__c = SL1Item60.Id;
                    UpdatelstSTL1Item30.add(SL1Item30);
                }
            }
        }
        
         if(!UpdatelstSTL1Item30.isEmpty()) {               
         update UpdatelstSTL1Item30;        
         }
                  
          for(SRAT_Additional_Tracking_Level_1__c SL1Item60: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = -60]) {
            for(SRAT_Additional_Tracking_Level_1__c SL1Item90: lstSL1Item90) {
                if( (SL1Item60.SRAT_Level_1_Tracking_Type__c == SL1Item90.SRAT_Level_1_Tracking_Type__c) && (SL1Item60.SRAT_Tracker__r.Wave__c == SL1Item90.SRAT_Tracker__r.Wave__c) ) {
                    SL1Item60.Previous_Item__c = SL1Item90.Id;
                    UpdatelstSTL1Item60.add(SL1Item60);
                }
            }
        }
        
         if(!UpdatelstSTL1Item60.isEmpty()) {               
         update UpdatelstSTL1Item60;        
         }
         
                  
          for(SRAT_Additional_Tracking_Level_1__c SL1Item90:[Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = -90]) {
            for(SRAT_Additional_Tracking_Level_1__c SL1Item120: lstSL1Item120) {
                if( (SL1Item90.SRAT_Level_1_Tracking_Type__c == SL1Item120.SRAT_Level_1_Tracking_Type__c) && (SL1Item90.SRAT_Tracker__r.Wave__c == SL1Item120.SRAT_Tracker__r.Wave__c) ) {
                    SL1Item90.Previous_Item__c = SL1Item120.Id;
                    UpdatelstSTL1Item90.add(SL1Item90);
                }
            }
        }
        
         if(!UpdatelstSTL1Item90.isEmpty()) {               
         update UpdatelstSTL1Item90;        
         }        
                
                
    }
    
     global void finish(Database.BatchableContext bc){
        
        
        endTime=System.currentTimeMillis()-startTime;
        System.debug('Success all records are inserted start time' +startTime + 'And total time taken is' +endTime);
    }
    
}