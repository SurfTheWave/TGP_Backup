/*
  @Author: Yasin Khan
  @Name: MobWaveWaveProcessReminderBatch
  @Created Date: 09 Dec 2015
  @Description: Send alert remainder for the following scenarios
                1. 1 day before/after the Planned go live date for the wave.
                2. Wave RAG Status not updated 1/7 day after wave is created in MWB.
                3. Wave Process not created in a wave 1/7 day after the wave is created.
                4. Remainder for KTtrackingItem 1 day before Planned End Date.
                5. Remainder for RecruitTracking 1 day before Planned End Date.   
                6. Remainder for TechWETracking 1 days before Planned End Date.
  @version: 3.5 
*/

global class MobWaveWaveProcessReminderBatch implements Database.Batchable<sObject>,Database.Stateful{
    
    /*** wave varibales ***/
    global String query;
    global String objectName;
    global Set<id> waveIds;
    global Set <Id> waveProcessIdsSet;
    global List<Wave__c> wavesRecordList;
    global Set<id> wavePlannedGoLivedealIdSet;
    global List<Wave__c> wavePlannedGoLiveList;
    global Set<id> waveRagstatusdealIdSet;
    global List<Wave__c> waveRagstatusList; 
    global Map<id,List<Wave_Proc__c>> waverecordIds;
    global Set<id> waveprocessdealIdSet;
    global List<Wave__c> waveList;
    global List<Wave_Proc__c> waveprocessList;
    
    /*** Tracking Variables ***/
    global List<KT_Trac__c > KTTrackingItem;
    global List<KT_Trac__c > KTTrackingItemsforAlert; 
    global Set<id> KTTrackingItemdealSetIDs;    
    global List<Recruit_Tracker__c> RecruitTrackingTracking;
    global List<Recruit_Tracker__c> RecruitTrackingforAlert; 
    global Set<id> RecruitTrackingdealSetIDs;              
    global List<Tech_WE_Tracker__c> TechWETrackingTracking;
    global List<Tech_WE_Tracker__c> TechWETrackingforAlert; 
    global Set<id> TechWETrackingdealSetIDs;
    
    global Boolean waveTrackingCond;     

    global MobWaveWaveProcessReminderBatch(String objectName){
                            
                wavePlannedGoLivedealIdSet = new set<id>();
                wavePlannedGoLiveList = new List<Wave__c>();
                waveRagstatusdealIdSet = new set<id>();
                waveRagstatusList = new List<Wave__c>();           
                waverecordIds = new Map<id,List<Wave_Proc__c>>();
                waveprocessdealIdSet = new set<id>();
                waveList = new List<Wave__c>();
                waveprocessList = new List<Wave_Proc__c>();
                
                KTTrackingItem = new List<KT_Trac__c>();
                KTTrackingItemsforAlert = new List<KT_Trac__c>();
                KTTrackingItemdealSetIDs = new Set<id>();
                
                RecruitTrackingTracking = new List<Recruit_Tracker__c>();
                RecruitTrackingforAlert = new List<Recruit_Tracker__c>();
                RecruitTrackingdealSetIDs = new Set<id>();
                
                TechWETrackingTracking = new List<Tech_WE_Tracker__c>();
                TechWETrackingforAlert = new List<Tech_WE_Tracker__c>();
                TechWETrackingdealSetIDs = new Set<id>();
                wavesRecordList = new List<Wave__c>();
                this.objectName = objectName;   
                waveTrackingCond = (objectName == 'wave')? true :false;                                                  
    }     
    
    global Database.QueryLocator start(Database.BatchableContext bc){
               query='SELECT CreatedDate, Id,Name,Wave_RAG_Status_del__c,Wave_Status__c , Planned_Go_Live_Date__c,Active__c,Mobilization_Plan__c,Mobilization_Plan__r.Active__c, Mobilization_Plan__r.Deal__c,Mobilization_Plan__r.Deal__r.name,Mobilization_Plan__r.Deal__r.Active__c FROM Wave__c WHERE Active__c = true and Mobilization_Plan__r.Active__c = true and Mobilization_Plan__r.Deal__r.Active__c = true';                             
               return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
           wavesRecordList = ((List<Wave__c>)sObjectList);
             waveIds = new Set<id>();
             if(wavesRecordList.size() > 0){    
                for(Wave__c waves : wavesRecordList)
                  waveIds.add(waves.Id);
             }
           
            if(wavesRecordList.size() > 0 && objectName == 'wave'){    
                for(Wave__c waves : wavesRecordList){
                  if(waves.Planned_Go_Live_Date__c != null){
                    if(((waves.Planned_Go_Live_Date__c).daysBetween(Date.today()) == -1)  || ((waves.Planned_Go_Live_Date__c).daysBetween(Date.today()) == 1) ){
                           wavePlannedGoLiveList.add(waves);
                           wavePlannedGoLivedealIdSet.add(waves.Mobilization_Plan__r.Deal__c);
                    }                   
                  }
                                              
                    if(((((waves.CreatedDate.date()).daysBetween(Date.today()) == 1)  && waves.Wave_RAG_Status_del__c== 'NA' || waves.Wave_RAG_Status_del__c== '')) || (((waves.CreatedDate.date()).daysBetween(Date.today()) == 7)  && (waves.Wave_RAG_Status_del__c== 'NA' || waves.Wave_RAG_Status_del__c== ''))){ 
                          waveRagstatusList.add(waves); 
                          waveRagstatusdealIdSet.add(waves.Mobilization_Plan__r.Deal__c);
                    }                       
                }
                    
                waveprocessList = [SELECT Wave__c, Active__c, Id, CreatedDate FROM Wave_Proc__c WHERE Wave__c IN : waveIds AND Active__c = true ];  
                
                waveProcessIdsSet = new Set<id>(); 
                for(Wave_Proc__c wp : waveprocessList )
                     waveProcessIdsSet.add(wp.Wave__c); 
                                                      
                for(Wave__c waves : wavesRecordList){
                      if(!(waveProcessIdsSet.contains(waves.Id)) && (((waves.CreatedDate.date()).daysBetween(Date.today()) == 1)  || ((waves.CreatedDate.date()).daysBetween(Date.today()) == 7) )){ 
                           waveprocessdealIdSet.add(waves.Mobilization_Plan__r.Deal__c);
                           waveList.add(waves);
                      }
                }  
                
            }else if(wavesRecordList.size() > 0 && objectName == 'tracking'){

                       KTTrackingItem = [SELECT Wave__r.Mobilization_Plan__r.Deal__r.name,Wave__r.Name,Wave__c,Wave__r.Mobilization_Plan__r.Deal__c,Active__c,Id,Name,Planned_End_Date__c,Actual_End_Date__c FROM KT_Trac__c WHERE Wave__c IN : waveIds AND Active__c = true ];                                                       
                       RecruitTrackingTracking = [SELECT Actual_End_Date__c,Planned_End_Date__c,Wave__r.Mobilization_Plan__r.Deal__r.name,Wave__r.Name,Wave__c,Wave__r.Mobilization_Plan__r.Deal__c,Active__c,Id,Name FROM Recruit_Tracker__c WHERE Wave__c IN : waveIds  AND Active__c = true ];                      
                       TechWETrackingTracking = [SELECT Actual_End_Date__c,Planned_End_Date__c,Wave__r.Mobilization_Plan__r.Deal__r.name,Wave__r.Name,Wave__c,Wave__r.Mobilization_Plan__r.Deal__c,Active__c,Id,Name FROM Tech_WE_Tracker__c WHERE Wave__c IN : waveIds AND Active__c = true ];                                  
 
                   if(KTTrackingItem.size() > 0){ 
                       for(KT_Trac__c kttrac : KTTrackingItem){ 
                         if(kttrac.Planned_End_Date__c != null){
                              if(((kttrac.Planned_End_Date__c).daysBetween(Date.today()) == -1) && (kttrac.Actual_End_Date__c == null || String.valueOf(kttrac.Actual_End_Date__c) == '')){ 
                                 KTTrackingItemsforAlert.add(kttrac);
                                 KTTrackingItemdealSetIDs.add(kttrac.Wave__r.Mobilization_Plan__r.Deal__c); 
                              }   
                         } 
                       }
                   }               
                   
                   if(RecruitTrackingTracking.size() > 0){ 
                     for(Recruit_Tracker__c rttrac : RecruitTrackingTracking){ 
                          if(rttrac.Planned_End_Date__c != null){
                          if(((rttrac.Planned_End_Date__c).daysBetween(Date.today()) == -1) && (rttrac.Actual_End_Date__c == null || String.valueOf(rttrac.Actual_End_Date__c) == '')){ 
                             RecruitTrackingforAlert.add(rttrac);
                             RecruitTrackingdealSetIDs.add(rttrac.Wave__r.Mobilization_Plan__r.Deal__c); 
                          }   
                        }
                       }
                   }                               
                   
                   if(TechWETrackingTracking.size() > 0){ 
                       for(Tech_WE_Tracker__c twtrac : TechWETrackingTracking){ 
                        if(twtrac.Planned_End_Date__c!= null){
                          if(((twtrac.Planned_End_Date__c).daysBetween(Date.today()) == -1) && (twtrac.Actual_End_Date__c == null || String.valueOf(twtrac.Actual_End_Date__c) == '')){ 
                             TechWETrackingforAlert.add(twtrac);
                             TechWETrackingdealSetIDs.add(twtrac.Wave__r.Mobilization_Plan__r.Deal__c); 
                          } 
                        }  
                       }
                   }                          
            }                                          
    }

   public void finish(Database.BatchableContext bc) {     
           system.debug('wavePlannedGoLiveList.size() :'+wavePlannedGoLiveList.size());
           system.debug('KTTrackingItemsforAlert.size()'+KTTrackingItemsforAlert);
           system.debug('RecruitTrackingforAlert :'+RecruitTrackingforAlert.size());
           system.debug('TechWETrackingforAlert:'+TechWETrackingforAlert.size());
            
           system.debug('wavePlannedGoLiveList.size()'+wavePlannedGoLiveList.size());
           system.debug('waveRagstatusList :'+waveRagstatusList.size());
           system.debug('waveList:'+waveList.size());
            
            if(wavePlannedGoLiveList.size() > 0 && wavePlannedGoLivedealIdSet != null)
                 waveEmailRemainder.waveStatusAlert(wavePlannedGoLiveList,wavePlannedGoLivedealIdSet,'plannedgolivedate','wave'); 
            if(waveRagstatusList.size() > 0 && waveRagstatusdealIdSet != null)
                  waveEmailRemainder.waveStatusAlert(waveRagstatusList,waveRagstatusdealIdSet,'waveragstatus','wave');           
            if(waveList.size() > 0 && waveprocessdealIdSet != null)
                  waveEmailRemainder.waveStatusAlert(waveList,waveprocessdealIdSet,'nowaveprocess','wave'); 
                                    
            if(KTTrackingItemsforAlert.size() > 0 && KTTrackingItemdealSetIDs != null) 
                  waveEmailRemainder.trackingStatusAlert(KTTrackingItemsforAlert,KTTrackingItemdealSetIDs ,'kttracking','KT');
            if(RecruitTrackingforAlert.size() > 0 && RecruitTrackingdealSetIDs != null)
                  waveEmailRemainder.trackingStatusAlert(RecruitTrackingforAlert,RecruitTrackingdealSetIDs ,'recruittracking','Recruit');           
            if(TechWETrackingforAlert.size() > 0 && TechWETrackingdealSetIDs != null)
                  waveEmailRemainder.trackingStatusAlert(TechWETrackingforAlert,TechWETrackingdealSetIDs ,'techwetracking','TechWE');   
            
            if(waveTrackingCond){          
                     MobWaveWaveProcessReminderBatch reminderBatch = new MobWaveWaveProcessReminderBatch('tracking');
                     Database.executeBatch(reminderBatch);            
            }                                 
   }
}