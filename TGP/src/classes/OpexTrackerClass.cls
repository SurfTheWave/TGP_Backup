/*
  @Author: Devanna
  @Name: OpexTrackerClass
  @Created Date: 05 January 2015
  @Description: This class conatins methods for opex tracker operations
  @version: 1.0 
*/
public with sharing class OpexTrackerClass {

List<Id> lstOpexTrackerIds = new List<Id>();
List<OPEX_Tracker__c> lstOpexTracker = new List<OPEX_Tracker__c>();
List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOpexLevel1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
Double SumStabilityScoreLevel1;
Double countLevel1;
Decimal OverallScore;
Decimal rounded;
List<OPEX_Tracker__c> lstUpdateOpexTracker = new List<OPEX_Tracker__c>();

/*
  @Author: Devanna
  @Name: UpdateOpexOverallScore
  @Created Date: 05 January 2015
  @Description: This method contains code to update opex records overall score
  @version: 1.0 
*/
public void UpdateOpexOverallScore(List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOpexTrackerLevel1) {

for(Deal_OPEX_Additional_Tracking_Level_1__c OpexTrackerLevel1: lstOpexTrackerLevel1)
{
    lstOpexTrackerIds.add(OpexTrackerLevel1.OPEX_Tracker_del__c);
}

lstOpexTracker = [Select Id,Name,Overall_Score__c from OPEX_Tracker__c where Id IN: lstOpexTrackerIds Limit 5000];
lstOpexLevel1 = [Select Name, Id,Stability_Score__c,OPEX_Tracker_del__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__c IN: lstOpexTrackerIds Limit 5000];

If(!lstOpexLevel1.isEmpty()) {
    for(OPEX_Tracker__c opexTracker: lstOpexTracker) {
         SumStabilityScoreLevel1 = 0;
         countLevel1 = 0; 
         OverallScore = 0;
        for(Deal_OPEX_Additional_Tracking_Level_1__c opexlevel1: lstOpexLevel1 ) {
            if( (opexTracker.Id == opexlevel1.OPEX_Tracker_del__c) && opexlevel1.Stability_Score__c != 0) {
                SumStabilityScoreLevel1 = SumStabilityScoreLevel1 + opexlevel1.Stability_Score__c;
                countLevel1++;         
            }
        }
        //system.debug('SumStabilityScoreLevel1:'+SumStabilityScoreLevel1);   
        //system.debug('countLevel1:'+countLevel1);
        if(countLevel1 != 0) {   
        OverallScore = Decimal.valueOf(SumStabilityScoreLevel1) / Decimal.valueOf(countLevel1);
        rounded = OverallScore.setScale(2);
        opexTracker.Overall_Score__c = OverallScore;       
        //system.debug('rounded:'+rounded);        
        lstUpdateOpexTracker.add(opexTracker);
        }        
     }
      try {
         if(!lstUpdateOpexTracker.isEmpty()) {               
         Database.update(lstUpdateOpexTracker,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
            //system.debug('exception:'+e);         
         }     
 }
 
 }
 
 
 
 /*
  @Author: MWB Developer
  @Name: UpdateOpexChecklistStatus
  @Created Date: 05 January 2015
  @Description: This method contains code to update code for checklist status code
  @version: 1.0 
*/
 public void UpdateOpexChecklistStatus(List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOTL1) {
 
 List<Id> lstOpexTIds = new List<Id>();

 List<OPEX_Tracker__c> lstUpdateOpexTr = new List<OPEX_Tracker__c>();
 
 for(Deal_OPEX_Additional_Tracking_Level_1__c OTL1: lstOTL1)
{
    lstOpexTIds.add(OTL1.OPEX_Tracker_del__c);
}

 

  for(OPEX_Tracker__c OpexTr:  [Select Id,Name,Checklist_Status__c from OPEX_Tracker__c where Id IN: lstOpexTIds AND Checklist_Status__c != :UtilCOnstants.SUBMITTED Limit 5000]) {
        OpexTr.Checklist_Status__c = UtilConstants.TASK_STATUS;
        lstUpdateOpexTr.add(OpexTr);
  }
  try {
         if(!lstUpdateOpexTr.isEmpty()) {               
         Database.update(lstUpdateOpexTr,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
            //system.debug('exception:'+e);         
         }    

 
 }
 
 
 List<Id> lstWaveIds = new List<Id>();
 List<Wave__c> lstWave = new List<Wave__c>();
 List<OPEX_Tracker__c> lstUpdateOT = new  List<OPEX_Tracker__c>();
 

 
 
List<OPEX_Additional_Tracking_Level1_Master__c> lstOpexLevel1Master = new List<OPEX_Additional_Tracking_Level1_Master__c>();
Deal_OPEX_Additional_Tracking_Level_1__c OpexL1;
List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOpexL1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();

List<OPEX_Additional_Tracking_Level2_Master__c> lstOpexLevel2Master = new List<OPEX_Additional_Tracking_Level2_Master__c>();
Deal_OPEX_Additional_Tracking_Level_2__c OpexL2;
List<Deal_OPEX_Additional_Tracking_Level_2__c> lstOpexL2 = new List<Deal_OPEX_Additional_Tracking_Level_2__c>();

Deal_OPEX_Additional_Tckn_Level_2_MOMC__c Opexlevel2MOMC;
 List<Deal_OPEX_Additional_Tckn_Level_2_MOMC__c> lstOpexlevel2MOMC = new List<Deal_OPEX_Additional_Tckn_Level_2_MOMC__c>();
 
 List<id> lstMobIds = new List<Id>();
 List<Mobilization_Plan__c> lstMobPlan = new List<Mobilization_Plan__c>();
 List<OPEX_Tracker__c> lstNewOpexTracker = new  List<OPEX_Tracker__c>();
 
 Id WaveId;

/*
@name : InsertOpexL1L2
@Description : 
@parameters :
*/   
 public void InsertOpexL1L2(List<OPEX_Tracker__c> lstOT) {
    List<Deal_OPEX_Additional_Tracking_Level_1__c> deal_opexaddtrac1list = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
 if(lstOT.Size() == 1) {
 
//system.debug('lstsize:'+lstOT.Size()); 

for(OPEX_Tracker__c OTrack: lstOT) {
    lstMobIds.add(OTrack.Mobilization_Plan__c);
 }

 
 List<Id> lstOTIds;
OPEX_Tracker__c OTMaxDay;
 for(Mobilization_Plan__c mb:  [Select Id,Name,IsTrackingOn__c from Mobilization_Plan__c where Id IN: lstMobIds AND IsTrackingOn__c = TRUE Limit 5000]) {
    for(OPEX_Tracker__c OpexTrack: lstOT) {
        if(OpexTrack.Mobilization_Plan__c == mb.Id) {
            lstNewOpexTracker.add(OpexTrack);
        }
    }

 
 lstOTIds = new List<Id>();
        //  List<Id> lstNewMobIds = new List<Id> ();
          Decimal daysAfterGoLive;   
          OPEX_Master__c OpexMaster;
          OPEX_Tracker__c otr ;
         OPEX_Tracker__c PreviousOT ;
          List<Deal_OPEX_Additional_Tracking_Level_1__c> lstNewOpxL1 ;
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstNOL1 ;
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOtrL1;
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstPrevL1;
         for(OPEX_Tracker__c OpexT: lstNewOpexTracker) {
            lstOTIds.add(OpexT.Id);
        //    lstNewMobIds.add(OpexT.Mobilization_Plan__c);
            WaveId = OpexT.Wave__c;
            daysAfterGoLive = OpexT.Days_After_Go_Live__c;         
         }
 
         OPEX_Tracker__c OTMinDay = [Select Name, Id,Days_After_Go_Live__c from OPEX_Tracker__c where Wave__c =: WaveId AND ID NOT IN: lstOTIds AND Days_After_Go_Live__c != NULL ORDER BY Days_After_Go_Live__c LIMIT 1];
         Decimal Minday = OTMinDay.Days_After_Go_Live__c;
             
         if(daysAfterGoLive > Minday) {
             OpexMaster = [Select Id,Name,Days_After_Go_Live__c from OPEX_Master__c where Days_After_Go_Live__c <: daysAfterGoLive ORDER BY Days_After_Go_Live__c DESC  LIMIT 1];
         } 
         else {
             OpexMaster = [Select Id,Name,Days_After_Go_Live__c from OPEX_Master__c where Days_After_Go_Live__c >: daysAfterGoLive ORDER BY Days_After_Go_Live__c LIMIT 1];
         }
 
               
        for(OPEX_Tracker__c ot: lstNewOpexTracker) {
          
                for(OPEX_Additional_Tracking_Level1_Master__c om: [Select Id,Name,OPEX_Level_1_Tracking_Type__c,Active__c,OPEX_Master__c from OPEX_Additional_Tracking_Level1_Master__c where Active__c = TRUE AND OPEX_Master__c =: OpexMaster.Id LIMIT 5000]) {
                 
                OpexL1 = new Deal_OPEX_Additional_Tracking_Level_1__c();
                OpexL1.Name = om.Name;
                OpexL1.OPEX_Level_1_Tracking_Type__c = om.OPEX_Level_1_Tracking_Type__c;
                OpexL1.OPEX_Additional_Tracking_Level1_Master__c = om.Id;
                OpexL1.OPEX_Tracker_del__c = ot.Id;
                OpexL1.Active__c = om.Active__c;
                                                
                lstOpexL1.add(OpexL1);
               
            }
          
        
        }
        try {
         if(!lstOpexL1.isEmpty()) {               
         Database.insert(lstOpexL1,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
         }
             
             
        OTMaxDay = new OPEX_Tracker__c();
        Decimal Maxday;  
         
         otr = new OPEX_Tracker__c();
         PreviousOT = new OPEX_Tracker__c();

         lstNewOpxL1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         UpdatelstNOL1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         UpdatelstOtrL1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         UpdatelstPrevL1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         
         OTMaxDay = [Select Name, Id,Days_After_Go_Live__c from OPEX_Tracker__c where Wave__c =: WaveId AND ID NOT IN: lstOTIds AND Days_After_Go_Live__c != NULL ORDER BY Days_After_Go_Live__c DESC LIMIT 1];
         Maxday = OTMaxDay.Days_After_Go_Live__c;
        // //system.debug('OTMaxDay:'+OTMaxDay);
        // //system.debug('assesmentDay:'+assesmentDay);
        // //system.debug('Maxday:'+Maxday);
              
         lstNewOpxL1 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__c IN: lstOTIds Limit 5000];
              
         if(Maxday > daysAfterGoLive) 
         {       
        // //system.debug('if maxday:');
         otr = [Select Name, Id,Days_After_Go_Live__c,Wave__c from OPEX_Tracker__c where Wave__c =: WaveId AND Days_After_Go_Live__c >: daysAfterGoLive ORDER BY Days_After_Go_Live__c LIMIT 1];
         
       // //system.debug('otr:'+otr);        
        deal_opexaddtrac1list  =   [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__c =: otr.Id Limit 5000];      
        
        for(Deal_OPEX_Additional_Tracking_Level_1__c NOL1: lstNewOpxL1) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c OtrL1: deal_opexaddtrac1list) {
                if(OtrL1.OPEX_Level_1_Tracking_Type__c == NOL1.OPEX_Level_1_Tracking_Type__c) {
                    NOL1.Previous_Item__c = OtrL1.Previous_Item__c;
                    OtrL1.Previous_Item__c = NOL1.Id;
                    //system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                    //system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstNOL1.add(NOL1);
                    UpdatelstOtrL1.add(OtrL1);
                    //system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
         if(!UpdatelstNOL1.isEmpty()) {               
         Database.update(UpdatelstNOL1,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿         
         }
        //system.debug('AfterUpdatelstNOL1:'+UpdatelstNOL1);           
         
       /* for(Deal_OPEX_Additional_Tracking_Level_1__c NOL1: lstNewOpxL1) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c OtrL1: lstotrL1) {
                if(OtrL1.OPEX_Level_1_Tracking_Type__c == NOL1.OPEX_Level_1_Tracking_Type__c) {
                    OtrL1.Previous_Item__c = NOL1.Id;
                    
                    UpdatelstOtrL1.add(OtrL1);
                }                
            }           
        }   */    
        try {
         if(!UpdatelstOtrL1.isEmpty()) {               
         Database.update(UpdatelstOtrL1,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿         
         }
         
       }  
       else {
            PreviousOT = [Select Name, Id,Days_After_Go_Live__c from OPEX_Tracker__c where Wave__c =: WaveId AND ID NOT IN: lstOTIds AND Days_After_Go_Live__c <: daysAfterGoLive ORDER BY Days_After_Go_Live__c DESC LIMIT 1];
            List<Deal_OPEX_Additional_Tracking_Level_1__c> dealopexlvel1list = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
          dealopexlvel1list =  [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__c =: PreviousOT.Id Limit 5000];
            //system.debug('PreviousOT:'+PreviousOT);
            
             for(Deal_OPEX_Additional_Tracking_Level_1__c NOL1: lstNewOpxL1) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c PrevL1: dealopexlvel1list) {
                if(PrevL1.OPEX_Level_1_Tracking_Type__c == NOL1.OPEX_Level_1_Tracking_Type__c) {
                    NOL1.Previous_Item__c = PrevL1.Id;
                   // //system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                   // //system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstNOL1.add(NOL1);
                  //  //system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
         if(!UpdatelstNOL1.isEmpty()) {               
         Database.update(UpdatelstNOL1,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿         
         }
            
       }
         
         
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c ol1: lstOpexL1) {
           if(ol1.OPEX_Level_1_Tracking_Type__c != UtilCOnstants.MOB_OPERATE_CRITERIA) {
            for(OPEX_Additional_Tracking_Level2_Master__c om2: [Select Id,Name,Active__c,OPEX_Additional_Tracking_Level1_Master__c,Question__c,Order__c from OPEX_Additional_Tracking_Level2_Master__c where Active__c = TRUE LIMIT 5000]) {
                if(ol1.OPEX_Additional_Tracking_Level1_Master__c == om2.OPEX_Additional_Tracking_Level1_Master__c) {
                    //system.debug('ol1.OPEX_Level_1_Tracking_Type__c:'+ol1.OPEX_Level_1_Tracking_Type__c);
                    OpexL2 = new Deal_OPEX_Additional_Tracking_Level_2__c();
                    
                    OpexL2.Name = om2.Name;
                    OpexL2.Question_Description__c = om2.Question__c;   
                   // OpexL2.Answer__c = om2.Answer__c;
                    OpexL2.Deal_OPEX_Additional_Tracking_Level_1__c = ol1.Id;
                    OpexL2.Order__c = om2.Order__c;
                    OpexL2.Active__c = om2.Active__c;
                    
                    lstOpexL2.add(OpexL2);
                }
              
            }
            
          }
           else {
                    Opexlevel2MOMC = new Deal_OPEX_Additional_Tckn_Level_2_MOMC__c();
                    Opexlevel2MOMC.Deal_OPEX_Additional_Tracking_Level_1__c = ol1.Id;
                    
                    lstOpexlevel2MOMC.add(Opexlevel2MOMC);
                }
         
         }
         try {
         if(!lstOpexL2.isEmpty()) {               
         Database.insert(lstOpexL2,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿         
         }
         
          try {
         if(!lstOpexlevel2MOMC.isEmpty()) {               
         Database.insert(lstOpexlevel2MOMC,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿         
         }
 
        
 }
 }
 }
 
 
 /*
  @Author: MWB Developer
  @Name: OpexDelete
  @Created Date: 05 January 2015
  @version: 1.0 
*/
 public void OpexDelete(OPEX_Tracker__c OpexDel) {
 
 Id waveId;
 Decimal daysAfterGoLiveDel;
 OPEX_Tracker__c OTUpdate;

 List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOUpdL1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
 OPEX_Tracker__c OTMaxDayDel;
 Decimal MaxdayDel;
 
 waveId = OpexDel.Wave__c;
 daysAfterGoLiveDel = OpexDel.Days_After_Go_Live__c;
 
 OTMaxDayDel = [Select Name, Id,Days_After_Go_Live__c,Wave__c from OPEX_Tracker__c where Wave__c =: waveId AND Days_After_Go_Live__c != NULL ORDER BY Days_After_Go_Live__c DESC LIMIT 1];
 MaxdayDel = OTMaxDayDel.Days_After_Go_Live__c;
 
 if(MaxdayDel != daysAfterGoLiveDel) 
 {
 OTUpdate = new OPEX_Tracker__c();
 OTUpdate = [Select Name, Id,Days_After_Go_Live__c,Wave__c from OPEX_Tracker__c where Wave__c =: waveId AND Days_After_Go_Live__c >: daysAfterGoLiveDel ORDER BY Days_After_Go_Live__c LIMIT 1];
  
 
         for(Deal_OPEX_Additional_Tracking_Level_1__c ODelL1: [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__c =: OpexDel.Id LIMIT 5000]) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c OUpdL1:  [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__c =: OTUpdate.Id LIMIT 5000]) {
                if(OUpdL1.OPEX_Level_1_Tracking_Type__c == ODelL1.OPEX_Level_1_Tracking_Type__c) {
                    OUpdL1.Previous_Item__c = ODelL1.Previous_Item__c;
                  //  //system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                  //  //system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstOUpdL1.add(OUpdL1);
                  //  //system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
         if(!UpdatelstOUpdL1.isEmpty()) {               
         Database.update(UpdatelstOUpdL1,false);             
         }
         }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿         
         }
    }
 
 }
 
 
 
 /*
  @Author: MWB Developer
  @Name: updateRecTypeOpexlevel2
  @Created Date: 05 January 2015
  @version: 1.0 
*/
 public void updateRecTypeOpexlevel2(List<OPEX_Tracker__c> lstOpexChklistSubmit) {
 
 List<Id> lstOpexChklistSubmitIds = new List<Id>();
 List <Deal_OPEX_Additional_Tracking_Level_1__c> lstopexLevel1Rec = new  List <Deal_OPEX_Additional_Tracking_Level_1__c>();
 List<Id> lstopexLevel1RecIds = new List<Id>();
 List<Deal_OPEX_Additional_Tracking_Level_2__c> lstOpexLevel2Rec = new List<Deal_OPEX_Additional_Tracking_Level_2__c>();
 List<Deal_OPEX_Additional_Tracking_Level_2__c> UpdatelstOpexLevel2Recs = new  List<Deal_OPEX_Additional_Tracking_Level_2__c>();
 List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOpexLevel1Recs = new  List<Deal_OPEX_Additional_Tracking_Level_1__c>();
 
 
 Set<Id> planIdList = new Set<Id>();
 
 if(!lstOpexChklistSubmit.isEmpty()) {
     for(OPEX_Tracker__c opexSubmitChklst: lstOpexChklistSubmit) {
        //lstOpexChklistSubmitIds.add(opexSubmitChklst.Id);
        planIdList.add(opexSubmitChklst.Mobilization_Plan__c);
     }
 
     database.executeBatch(new SRATOPEXRecTypeL1L2Update (planIdList, 'Level1', 'OPEX'));
 
 /*
 lstopexLevel1Rec = [Select Id,Name,OPEX_Tracker_del__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__c IN: lstOpexChklistSubmitIds AND OPEX_Level_1_Tracking_Type__c != :UtilConstants.MAURITOUS LIMIT 5000];
 
 RecordType OpexLevel1RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.DEAL_OPEX_LEVEL1  and DeveloperName = :UtilCOnstants.OPES_LEVEL1_SUBMIT LIMIT 1];
 
 for(Deal_OPEX_Additional_Tracking_Level_1__c opexLevel1Rec: lstopexLevel1Rec) {
    lstopexLevel1RecIds.add(opexLevel1Rec.Id);
    
    opexLevel1Rec.RecordTypeId = OpexLevel1RecordType.Id;
    UpdatelstOpexLevel1Recs.add(opexLevel1Rec);
 }
 
  
lstOpexLevel2Rec = [Select Id,Name,Deal_OPEX_Additional_Tracking_Level_1__c from Deal_OPEX_Additional_Tracking_Level_2__c where Deal_OPEX_Additional_Tracking_Level_1__c IN: lstopexLevel1RecIds LIMIT 5000];

RecordType OpexLevel2RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.DEAL_OPEX  and DeveloperName = :UtilCOnstants.OPES_LEVEL_SUBMIT LIMIT 1];

for(Deal_OPEX_Additional_Tracking_Level_2__c opexLevel2Rec: lstOpexLevel2Rec) {
        opexLevel2Rec.RecordTypeId = OpexLevel2RecordType.Id;
        UpdatelstOpexLevel2Recs.add(opexLevel2Rec);
}

try {

        if(!UpdatelstOpexLevel1Recs.isEmpty()) {               
         Database.update(UpdatelstOpexLevel1Recs,false);             
         }
         
         if(!UpdatelstOpexLevel2Recs.isEmpty()) {               
         Database.update(UpdatelstOpexLevel2Recs,false);             
         }
    }
         catch(Exception e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿         
         }

    */
 }
 
  
 }
 
 
  
 }