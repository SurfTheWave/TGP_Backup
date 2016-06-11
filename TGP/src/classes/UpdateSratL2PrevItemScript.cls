global class UpdateSratL2PrevItemScript implements Database.Batchable<sObject>, Database.Stateful{
    global final String query;
    global Long startTime;
    global Long endTime;

    
    global UpdateSratL2PrevItemScript(String qur){
        
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
List<Id> lstSL2Ids = new List<Id>();
         
         for(SRAT_Additional_Tracking_Level_1__c SL1: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__r.Wave__c IN: lstWaveIds]) {
            lstSL1Ids.add(SL1.Id);
         }
                
          for(SRAT_Additional_Tracking_Level_2__c SL2: [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where SRAT_Additional_Tracking_Level_1__c IN: lstSL1Ids]) {
            lstSL2Ids.add(SL2.Id);
         }
         
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSTL2Item5 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSTL2Item30 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSTL2Item60 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSTL2Item90 = new List<SRAT_Additional_Tracking_Level_2__c>();
                 
                  
        List<SRAT_Additional_Tracking_Level_2__c> lstSL2Item30 = [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = -30];
        List<SRAT_Additional_Tracking_Level_2__c> lstSL2Item60 = [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = -60];
        List<SRAT_Additional_Tracking_Level_2__c> lstSL2Item90 = [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = -90];
        List<SRAT_Additional_Tracking_Level_2__c> lstSL2Item120 = [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = -120];
         
         
         for(SRAT_Additional_Tracking_Level_2__c SL2Item5: [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = -5]) {
            for(SRAT_Additional_Tracking_Level_2__c SL2Item30: lstSL2Item30) {
                if( (SL2Item30.SRAT_Level_1_Tracking_Type__c == SL2Item5.SRAT_Level_1_Tracking_Type__c) && (SL2Item30.Name == SL2Item5.Name) && (SL2Item30.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c == SL2Item5.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c) ) {
                    SL2Item5.Previous_Item__c = SL2Item30.Id;
                    UpdatelstSTL2Item5.add(SL2Item5);
                }
            }
        }
        
         if(!UpdatelstSTL2Item5.isEmpty()) {               
         update UpdatelstSTL2Item5;        
         }
                                        
          for(SRAT_Additional_Tracking_Level_2__c SL2Item30: [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = -30]) {
            for(SRAT_Additional_Tracking_Level_2__c SL2Item60: lstSL2Item60) {
                if( (SL2Item30.SRAT_Level_1_Tracking_Type__c == SL2Item60.SRAT_Level_1_Tracking_Type__c) && (SL2Item30.Name == SL2Item60.Name) && (SL2Item30.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c == SL2Item60.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c) ) {
                    SL2Item30.Previous_Item__c = SL2Item60.Id;
                    UpdatelstSTL2Item30.add(SL2Item30);
                }
            }
        }
        
         if(!UpdatelstSTL2Item30.isEmpty()) {               
         update UpdatelstSTL2Item30;        
         }
                  
         
          for(SRAT_Additional_Tracking_Level_2__c SL2Item60: [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = -60]) {
            for(SRAT_Additional_Tracking_Level_2__c SL2Item90: lstSL2Item90) {
                if( (SL2Item60.SRAT_Level_1_Tracking_Type__c == SL2Item90.SRAT_Level_1_Tracking_Type__c) && (SL2Item60.Name == SL2Item90.Name) && (SL2Item60.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c == SL2Item90.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c) ) {
                    SL2Item60.Previous_Item__c = SL2Item90.Id;
                    UpdatelstSTL2Item60.add(SL2Item60);
                }
            }
        }
        
         if(!UpdatelstSTL2Item60.isEmpty()) {               
         update UpdatelstSTL2Item60;        
         }
                 
         
          for(SRAT_Additional_Tracking_Level_2__c SL2Item90:[Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = -90]) {
            for(SRAT_Additional_Tracking_Level_2__c SL2Item120: lstSL2Item120) {
                if( (SL2Item90.SRAT_Level_1_Tracking_Type__c == SL2Item120.SRAT_Level_1_Tracking_Type__c) && (SL2Item90.Name == SL2Item120.Name) && (SL2Item90.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c == SL2Item120.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c)) {
                    SL2Item90.Previous_Item__c = SL2Item120.Id;
                    UpdatelstSTL2Item90.add(SL2Item90);
                }
            }
        }
        
         if(!UpdatelstSTL2Item90.isEmpty()) {               
         update UpdatelstSTL2Item90;        
         }       
                
                
    }
    
     global void finish(Database.BatchableContext bc){
        
        
        endTime=System.currentTimeMillis()-startTime;
        System.debug('Success all records are inserted start time' +startTime + 'And total time taken is' +endTime);
    }
    
}