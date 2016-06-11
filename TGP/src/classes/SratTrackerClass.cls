/**
    @Author : MWB developer
    @name:  SratTrackerClass
    @CreateDate :  2/21/2015
    @Description: This class contains all methods SRAT tracker class to update records for SRAT tracker
    @Version: 1.0
    @reference: None
*/
public with sharing class SratTrackerClass {

    //List<SRAT_Additional_Tracking_Level1_Master__c> lstSratLevel1Master = new List<SRAT_Additional_Tracking_Level1_Master__c>();
    SRAT_Additional_Tracking_Level_1__c SratL1;
    List<SRAT_Additional_Tracking_Level_1__c> lstSratL1 = new List<SRAT_Additional_Tracking_Level_1__c>();
    
    //List<SRAT_Additional_Tracking_Level2_Master__c> lstSratLevel2Master = new List<SRAT_Additional_Tracking_Level2_Master__c>();
    SRAT_Additional_Tracking_Level_2__c SratL2;
    List<SRAT_Additional_Tracking_Level_2__c> lstSratL2 = new List<SRAT_Additional_Tracking_Level_2__c>();
    
    List<id> lstMobIds = new List<Id>();
    List<SRAT_Tracker__c> lstNewSratTracker = new  List<SRAT_Tracker__c>();
    Id WaveId;
    /**
     @Method name:  InsertSratL1L2
     Parameter   :list of Srat record
     @Description: This method is used for to insert to the Srat level2 records 
     @Version: 1.0
     @reference: None
    */
     public void InsertSratL1L2(List<SRAT_Tracker__c> lstST) {
     
     if(lstST.Size() == 1) {
     
    for(SRAT_Tracker__c STrack: lstST) {
        lstMobIds.add(STrack.Mobilization_Plan__c);
     }
   

 for(Mobilization_Plan__c mb: [Select Id,Name,IsTrackingOn__c from Mobilization_Plan__c where 
                                    Id IN: lstMobIds AND IsTrackingOn__c = TRUE limit 5000]) {
    for(SRAT_Tracker__c SratTrack: lstST) {
        if(SratTrack.Mobilization_Plan__c.equals(mb.Id)) {
            lstNewSratTracker.add(SratTrack);
        }else{
            
        }
    }

 }

          List<Id> lstSTIds = new List<Id>();
        //  List<Id> lstNewMobIds = new List<Id> ();
          Decimal daysBeforeGoLive;   
          SRAT_Master__c SratMaster;
         for(SRAT_Tracker__c SratT: lstNewSratTracker) {
            lstSTIds.add(SratT.Id);
         //   lstNewMobIds.add(SratT.Mobilization_Plan__c);
            WaveId = SratT.Wave__c;
            daysBeforeGoLive = SratT.Days_Before_Go_Live__c;         
         }
         
         SRAT_Tracker__c STMaxDay = new SRAT_Tracker__c();
         Decimal Maxday;
         
         STMaxDay = [Select Name, Id,Days_Before_Go_Live__c,Wave__c from SRAT_Tracker__c where Wave__c =: WaveId AND ID NOT IN: lstSTIds AND 
         Days_Before_Go_Live__c != NULL 
                    ORDER BY Days_Before_Go_Live__c DESC LIMIT 1];
         Maxday = STMaxDay.Days_Before_Go_Live__c;
         
         if(daysBeforeGoLive < Maxday) {
             SratMaster = [Select Id,Name,Days_Before_Go_Live__c from SRAT_Master__c where Days_Before_Go_Live__c >: daysBeforeGoLive 
             ORDER BY Days_Before_Go_Live__c LIMIT 1];
         }
         else {
             SratMaster = [Select Id,Name,Days_Before_Go_Live__c from SRAT_Master__c where Days_Before_Go_Live__c <: daysBeforeGoLive 
             ORDER BY Days_Before_Go_Live__c DESC LIMIT 1];
         }
         
         map<Id, SRAT_Additional_Tracking_Level1_Master__c>lstSratLevel1Master = new map<Id,SRAT_Additional_Tracking_Level1_Master__c>([Select Id,Name,Order__c,
         Question__c,SRAT_Level1_Tracking_Type__c,
                                                                                    Active__c,SRAT_Master__c from SRAT_Additional_Tracking_Level1_Master__c 
                                                                                    where Active__c = TRUE AND SRAT_Master__c =: SratMaster.Id  LIMIT 5000]);
               
        for(SRAT_Tracker__c st: lstNewSratTracker) {
            // not iterated query in for-each loop as query will come under for-loop
               for(SRAT_Additional_Tracking_Level1_Master__c sm: lstSratLevel1Master.values()) {
                SratL1 = new SRAT_Additional_Tracking_Level_1__c();
                SratL1.Name = sm.Name;
                SratL1.SRAT_Level_1_Tracking_Type__c = sm.SRAT_Level1_Tracking_Type__c;
                SratL1.SRAT_Additional_Tracking_Level1_Master__c = sm.Id;
                SratL1.SRAT_Tracker__c = st.Id;
                SratL1.Active__c = sm.Active__c;
                SratL1.Order__c = sm.Order__c;
                SratL1.Question__c = sm.Question__c;          
                                                
                lstSratL1.add(SratL1);
              
            }
                 
        }
        try {
             if(!lstSratL1.isEmpty()) {               
                Database.insert(lstSratL1,false);             
             }
         }
         catch(Exception e) {
            String str = e.getMessage();
         }
         
         
         map<Id,SRAT_Additional_Tracking_Level2_Master__c> lstSratLevel2Master = new map<Id,SRAT_Additional_Tracking_Level2_Master__c>([Select Id,Name,Active__c,
         Additional_Information__c,Category__c,
                                                                                    Order__c,Question__c,Section__c,SRAT_Additional_Tracking_Level1_Master__c,Title__c 
                                                                                    from SRAT_Additional_Tracking_Level2_Master__c where Active__c = TRUE LIMIT 5000]);
         
         for(SRAT_Additional_Tracking_Level_1__c sl1: lstSratL1) {
           if(sl1.SRAT_Level_1_Tracking_Type__c != UtilConstants.FACTORY_SPECIFIC) {
                        // not iterated query in for-each loop as query will come under for-loop
            for(SRAT_Additional_Tracking_Level2_Master__c sm2: lstSratLevel2Master.values()) {
                if(sl1.SRAT_Additional_Tracking_Level1_Master__c.equals(sm2.SRAT_Additional_Tracking_Level1_Master__c)) {
                    SratL2 = new SRAT_Additional_Tracking_Level_2__c();
                    SratL2.Name = sm2.Name;
                    SratL2.Active__c = sm2.Active__c;
                    SratL2.Additional_Information__c = sm2.Additional_Information__c;
                    SratL2.Category__c = sm2.Category__c;
                    SratL2.Order__c = sm2.Order__c;
                    SratL2.Question__c = sm2.Question__c;
                    SratL2.Section__c = sm2.Section__c;
                    sratL2.SRAT_Tracking_Item__c = sl1.SRAT_Tracker__c;
                    SratL2.SRAT_Additional_Tracking_Level_1__c = sl1.Id;
                    SratL2.Title_Description__c = sm2.Title__c;
                    SratL2.SRAT_Level_1_Tracking_Type__c = sl1.SRAT_Level_1_Tracking_Type__c;
                    
                    lstSratL2.add(SratL2);
                }
              
            }
            
          }
                    
         }
         try {
             if(!lstSratL2.isEmpty()) {               
                Database.insert(lstSratL2,false);             
             }
         }
         catch(Exception e) {
            String str10 = e.getMessage();
         }
                  
           
         SRAT_Tracker__c str = new SRAT_Tracker__c();
         SRAT_Tracker__c PreviousST = new SRAT_Tracker__c();
         SRAT_Tracker__c STMinDay = new SRAT_Tracker__c();
         Decimal Minday;

         List<SRAT_Additional_Tracking_Level_1__c> lstNewSrtL1 = new List<SRAT_Additional_Tracking_Level_1__c>();
         //List<SRAT_Additional_Tracking_Level_1__c> lststrL1 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstNSL1 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstStrL1 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstPrevL1 = new List<SRAT_Additional_Tracking_Level_1__c>();
         
         List<SRAT_Additional_Tracking_Level_2__c> lstNewSrtL2 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> lststrL2 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstNSL2 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstStrL2 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstPrevL2 = new List<SRAT_Additional_Tracking_Level_2__c>();
         
         STMinDay = [Select Name, Id,Days_Before_Go_Live__c,Wave__c from SRAT_Tracker__c where Wave__c =: WaveId AND ID NOT IN: lstSTIds AND 
         Days_Before_Go_Live__c != NULL 
                    ORDER BY Days_Before_Go_Live__c LIMIT 1];
         Minday = STMinDay.Days_Before_Go_Live__c;
        // system.debug('OTMaxDay:'+OTMaxDay);
        // system.debug('assesmentDay:'+assesmentDay);
        // system.debug('Maxday:'+Maxday);
              
         lstNewSrtL1 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c 
         where SRAT_Tracker__c IN: lstSTIds limit 5000];
        // lstNewSrtL2 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_2__c where SRAT_Tracker__c IN: lstSTIds];
              
         if(Maxday > daysBeforeGoLive && daysBeforeGoLive > Minday) 
         {       
         //system.debug('if maxday:');
         str = [Select Name, Id,Days_Before_Go_Live__c from SRAT_Tracker__c where Wave__c =: WaveId AND Days_Before_Go_Live__c <: daysBeforeGoLive 
         ORDER BY Days_Before_Go_Live__c DESC LIMIT 1];
         
        //system.debug('otr:'+otr);        
                     
        map<Id,SRAT_Additional_Tracking_Level_1__c> lststrL1 = new map<Id,SRAT_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,SRAT_Tracker__c,
        SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c =: str.Id limit 5000]);  
        
        for(SRAT_Additional_Tracking_Level_1__c NSL1: lstNewSrtL1) {
            for(SRAT_Additional_Tracking_Level_1__c StrL1: lststrL1.values()) {
                if(StrL1.SRAT_Level_1_Tracking_Type__c.equals(NSL1.SRAT_Level_1_Tracking_Type__c)) {
                    NSL1.Previous_Item__c = StrL1.Previous_Item__c;
                    //system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                    //system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstNSL1.add(NSL1);
                   // system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
         if(!UpdatelstNSL1.isEmpty()) {               
         Database.update(UpdatelstNSL1,false);             
         }
         }
         catch(Exception e) {
            String str1 = e.getMessage();
         }
       // system.debug('AfterUpdatelstNOL1:'+UpdatelstNOL1);           
         
        for(SRAT_Additional_Tracking_Level_1__c NSL1: lstNewSrtL1) {
            for(SRAT_Additional_Tracking_Level_1__c StrL1: lststrL1.values()) {
                if(StrL1.SRAT_Level_1_Tracking_Type__c.equals(NSL1.SRAT_Level_1_Tracking_Type__c)) {
                    StrL1.Previous_Item__c = NSL1.Id;
                    
                    UpdatelstStrL1.add(StrL1);
                }                
            }           
        }       
        try {
             if(!UpdatelstStrL1.isEmpty()) {               
                Database.update(UpdatelstStrL1,false);             
             }
         }
         catch(Exception e) {
            String str2 = e.getMessage();
         }
         
         
         List<Id> lststrL1Ids = new List<Id>();
         
         for(SRAT_Additional_Tracking_Level_1__c ST1: lststrL1.values()) {
            lststrL1Ids.add(ST1.Id);
         }
         lststrL2 = [Select Name,Id,Previous_Item__c,SRAT_Additional_Tracking_Level_1__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_2__c 
                            where SRAT_Additional_Tracking_Level_1__c IN: lststrL1Ids limit 5000];
         
          for(SRAT_Additional_Tracking_Level_2__c NSL2: lstSratL2) {
            for(SRAT_Additional_Tracking_Level_2__c StrL2: lststrL2) {
                if( (StrL2.SRAT_Level_1_Tracking_Type__c.equals(NSL2.SRAT_Level_1_Tracking_Type__c)) && (StrL2.Name.equals(NSL2.Name)) ) {
                    NSL2.Previous_Item__c = StrL2.Previous_Item__c;
                    //system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                    //system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstNSL2.add(NSL2);
                   // system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
             if(!UpdatelstNSL2.isEmpty()) {               
                Database.update(UpdatelstNSL2,false);             
             }
         }
         catch(Exception e) {
            String str3 = e.getMessage();
         }
         
          for(SRAT_Additional_Tracking_Level_2__c NSL2: lstSratL2) {
            for(SRAT_Additional_Tracking_Level_2__c StrL2: lststrL2) {
                if( (StrL2.SRAT_Level_1_Tracking_Type__c.equals(NSL2.SRAT_Level_1_Tracking_Type__c)) && (StrL2.Name.equals(NSL2.Name)) ) {
                    StrL2.Previous_Item__c = NSL2.Id;
                    
                    UpdatelstStrL2.add(StrL2);
                }                
            }           
        }       
        try {
             if(!UpdatelstStrL2.isEmpty()) {               
                Database.update(UpdatelstStrL2,false);             
             }
         }
         catch(Exception e) {
            String str4 = e.getMessage();
         }
         
         
       }  
       else {
            if (Maxday < daysBeforeGoLive) {
            PreviousST = [Select Name, Id,Days_Before_Go_Live__c from SRAT_Tracker__c where Wave__c =: WaveId AND ID NOT IN: lstSTIds AND 
            Days_Before_Go_Live__c <: daysBeforeGoLive ORDER BY Days_Before_Go_Live__c DESC LIMIT 1];
            
           // system.debug('PreviousOT:'+PreviousOT);
            
            map<Id,SRAT_Additional_Tracking_Level_1__c> lstPrevL1 = new map<Id,SRAT_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,
            SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c where  SRAT_Tracker__c =: PreviousST.Id limit 5000]); 
            
             for(SRAT_Additional_Tracking_Level_1__c NSL1: lstNewSrtL1) {
            for(SRAT_Additional_Tracking_Level_1__c PrevL1: lstPrevL1.values()) {
                if(PrevL1.SRAT_Level_1_Tracking_Type__c.equals(NSL1.SRAT_Level_1_Tracking_Type__c)) {
                    PrevL1.Previous_Item__c = NSL1.Id;
                   // system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                   // system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstPrevL1.add(PrevL1);
                  //  system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
             if(!UpdatelstPrevL1.isEmpty()) {               
                Database.update(UpdatelstPrevL1,false);             
             }
         }
         catch(Exception e) {
            String str5 = e.getMessage();
         }
         
         List<Id> lstPrevL1Ids = new List<Id>();
         
         for(SRAT_Additional_Tracking_Level_1__c STPrev1: lstPrevL1.values()) {
            lstPrevL1Ids.add(STPrev1.Id);
         }
         map<Id,SRAT_Additional_Tracking_Level_2__c> lstPrevL2 = new map<Id,SRAT_Additional_Tracking_Level_2__c>([Select Name,Id,Previous_Item__c,
         SRAT_Additional_Tracking_Level_1__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_2__c where 
         SRAT_Additional_Tracking_Level_1__c IN: lstPrevL1Ids limit 5000]);
         
          for(SRAT_Additional_Tracking_Level_2__c NSL2: lstSratL2) {
            for(SRAT_Additional_Tracking_Level_2__c PrevL2: lstPrevL2.values()) {
                if(PrevL2.SRAT_Level_1_Tracking_Type__c.equals(NSL2.SRAT_Level_1_Tracking_Type__c) && (PrevL2.Name.equals(NSL2.Name)) ) {
                    PrevL2.Previous_Item__c = NSL2.Id;
                   // system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                   // system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstPrevL2.add(PrevL2);
                  //  system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
             if(!UpdatelstPrevL2.isEmpty()) {               
                Database.update(UpdatelstPrevL2,false);             
             }
         }
         catch(Exception e) {
            String str6 = e.getMessage();
         }
        }   
        else
        {
             str = [Select Name, Id,Days_Before_Go_Live__c from SRAT_Tracker__c where Wave__c =: WaveId AND ID NOT IN: lstSTIds AND 
             Days_Before_Go_Live__c >: daysBeforeGoLive ORDER BY Days_Before_Go_Live__c LIMIT 1];
         
        //system.debug('otr:'+otr);        
                     
        map<Id,SRAT_Additional_Tracking_Level_1__c> lstNextstrL1 = new map<Id,SRAT_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,
        SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c =: str.Id limit 5000]);  
        
        for(SRAT_Additional_Tracking_Level_1__c NSL1: lstNewSrtL1) {
            for(SRAT_Additional_Tracking_Level_1__c StrL1: lstNextstrL1.values()) {
                if(StrL1.SRAT_Level_1_Tracking_Type__c.equals(NSL1.SRAT_Level_1_Tracking_Type__c)) {
                    NSL1.Previous_Item__c = StrL1.Id;
                    //system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                    //system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstNSL1.add(NSL1);
                   // system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
         if(!UpdatelstNSL1.isEmpty()) {               
         Database.update(UpdatelstNSL1,false);             
         }
         }
         catch(Exception e) {
            String str7 = e.getMessage();
         }
         
         List<Id> lstNextstrL1Ids = new List<Id>();
         
         for(SRAT_Additional_Tracking_Level_1__c ST1: lstNextstrL1.values()) {
            lstNextstrL1Ids.add(ST1.Id);
         }
         lststrL2 = [Select Name,Id,Previous_Item__c,SRAT_Additional_Tracking_Level_1__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_2__c 
                            where SRAT_Additional_Tracking_Level_1__c IN: lstNextstrL1Ids limit 5000];
         
          for(SRAT_Additional_Tracking_Level_2__c NSL2: lstSratL2) {
            for(SRAT_Additional_Tracking_Level_2__c StrL2: lststrL2) {
                if( (StrL2.SRAT_Level_1_Tracking_Type__c.equals(NSL2.SRAT_Level_1_Tracking_Type__c)) && (StrL2.Name.equals(NSL2.Name)) ) {
                    NSL2.Previous_Item__c = StrL2.Id;
                    //system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                    //system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstNSL2.add(NSL2);
                   // system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
             if(!UpdatelstNSL2.isEmpty()) {               
                Database.update(UpdatelstNSL2,false);             
             }
         }
         catch(Exception e) {
            String str8 = e.getMessage();
         }
         
        }
        
       }

 }
 }
 
 
 /**
    @Author : MWB developer
    @name:  SratDelete
    @CreateDate :  2/21/2015
    @Description: This class contains all methods 
    @Version: 1.0
    @reference: None
*/
 public void SratDelete(SRAT_Tracker__c SratDel) {
 
 Id waveId;
 Decimal daysBeforeGoLiveDel;
 SRAT_Tracker__c STUpdate;
 //List<SRAT_Additional_Tracking_Level_1__c> lstSratDelL1 = new  List<SRAT_Additional_Tracking_Level_1__c>();
 //List<SRAT_Additional_Tracking_Level_1__c> lstSratUpdateL1 = new List<SRAT_Additional_Tracking_Level_1__c>();
 List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSUpdL1 = new List<SRAT_Additional_Tracking_Level_1__c>();
 //SRAT_Tracker__c STMaxDayDel;
 Decimal MaxdayDel;
 Decimal MindayDel;
 
 List<Id> lstSratDelL1Ids = new List<Id>();
 List<Id> lstSratUpdateL1Ids = new List<Id>();
 set<Id> lstSratUpdateL1Ids_temp = new set<id>();
 //List<SRAT_Additional_Tracking_Level_2__c> lstSratUpdateL2 = new List<SRAT_Additional_Tracking_Level_2__c>();
 List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSUpdL2 = new List<SRAT_Additional_Tracking_Level_2__c>();
 
 waveId = SratDel.Wave__c;
 daysBeforeGoLiveDel = SratDel.Days_Before_Go_Live__c;
 
 for(SRAT_Tracker__c STMaxDayDel :[Select Name, Id,Days_Before_Go_Live__c from SRAT_Tracker__c where Wave__c =: waveId 
                                    AND Days_Before_Go_Live__c != NULL ORDER BY Days_Before_Go_Live__c DESC LIMIT 1]){
                    MaxdayDel = STMaxDayDel.Days_Before_Go_Live__c;
 }
 for(SRAT_Tracker__c STMinDayDel :[Select Name, Id,Days_Before_Go_Live__c from SRAT_Tracker__c where Wave__c =: waveId 
                                    AND Days_Before_Go_Live__c != NULL ORDER BY Days_Before_Go_Live__c LIMIT 1]){
                    MindayDel = STMinDayDel.Days_Before_Go_Live__c;
 }
 
 if(MaxdayDel != daysBeforeGoLiveDel && MindayDel != daysBeforeGoLiveDel) 
 {
 STUpdate = new SRAT_Tracker__c();
 STUpdate = [Select Name, Id,Days_Before_Go_Live__c from SRAT_Tracker__c where Wave__c =: waveId AND Days_Before_Go_Live__c <: daysBeforeGoLiveDel 
 ORDER BY Days_Before_Go_Live__c DESC LIMIT 1];
 

 //lstSratDelL1 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c =: SratDel.Id];
 
 //lstSratUpdateL1 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c =: STUpdate.Id];
 map<Id,SRAT_Additional_Tracking_Level_1__c> lstSratUpdateL1 = new map<Id,SRAT_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,SRAT_Tracker__c,
 SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c =: STUpdate.Id limit 5000]);
         for(SRAT_Additional_Tracking_Level_1__c SDelL1: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c from 
         SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c =: SratDel.Id limit 5000]) {
            lstSratDelL1Ids.add(SDelL1.Id);                                                                 
            for(SRAT_Additional_Tracking_Level_1__c SUpdL1: lstSratUpdateL1.values()) {
                lstSratUpdateL1Ids_temp.add(SUpdL1.Id);
                if(SUpdL1.SRAT_Level_1_Tracking_Type__c.equals(SDelL1.SRAT_Level_1_Tracking_Type__c)) {
                    SUpdL1.Previous_Item__c = SDelL1.Previous_Item__c;
                  //  system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                  //  system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstSUpdL1.add(SUpdL1);
                  //  system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
             if(!UpdatelstSUpdL1.isEmpty()) {               
                Database.update(UpdatelstSUpdL1,false);             
             }
         }
         catch(Exception e) {
            String str7=e.getMessage();
         }
         
         /*for(SRAT_Additional_Tracking_Level_1__c SL1Del: lstSratDelL1) {
            lstSratDelL1Ids.add(SL1Del.Id);
         }*/
         /*for(SRAT_Additional_Tracking_Level_1__c SUL1Del: lstSratUpdateL1) {
            lstSratUpdateL1Ids.add(SUL1Del.Id);
         }*/
         lstSratUpdateL1Ids.addAll(lstSratUpdateL1Ids_temp);
         map<Id,SRAT_Additional_Tracking_Level_2__c> lstSratUpdateL2 = new map<Id,SRAT_Additional_Tracking_Level_2__c>([Select Name,Id,Previous_Item__c,
         SRAT_Additional_Tracking_Level_1__c,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_2__c where SRAT_Additional_Tracking_Level_1__c IN: lstSratUpdateL1Ids limit 5000]);
         
         for(SRAT_Additional_Tracking_Level_2__c SDelL2: [Select Name,Id,Previous_Item__c,SRAT_Additional_Tracking_Level_1__c,SRAT_Level_1_Tracking_Type__c 
         from SRAT_Additional_Tracking_Level_2__c where SRAT_Additional_Tracking_Level_1__c IN: lstSratDelL1Ids limit 5000]) {
            // not iterated query with for each loop because query will be inside For-loop
            for(SRAT_Additional_Tracking_Level_2__c SUpdL2: lstSratUpdateL2.values()) {
                if( (SUpdL2.SRAT_Level_1_Tracking_Type__c.equals(SDelL2.SRAT_Level_1_Tracking_Type__c)) && (SUpdL2.Name.equals(SDelL2.Name)) ) {
                    SUpdL2.Previous_Item__c = SDelL2.Previous_Item__c;
                  //  system.debug('NOL1.Previous_Item__c:'+NOL1.Previous_Item__c);
                  //  system.debug('OtrL1.Previous_Item__c:'+OtrL1.Previous_Item__c);                    
                    UpdatelstSUpdL2.add(SUpdL2);
                  //  system.debug('UpdatelstNOL1:'+UpdatelstNOL1);                    
                }                
            }           
        }       
        try {
             if(!UpdatelstSUpdL2.isEmpty()) {               
                Database.update(UpdatelstSUpdL2,false);             
             }
         }
         catch(Exception e) {
            String str8= e.getMessage();
         }
         
    }
 
 }
 /**
 @Method name:  updateRecTypesratlevel2
 Parameter   :list of Srat record
 @Description: This method is used for to udated to the Srat level2 records 
 @Version: 1.0
 @reference: None
*/
public void updateRecTypesratlevel2(List<SRAT_Tracker__c> lstsratChklistSubmit) {
// List<Id> lstsratChklistSubmitIds = new List<Id>();
//List <SRAT_Additional_Tracking_Level_1__c> lstsratLevel1Rec = new  List <SRAT_Additional_Tracking_Level_1__c>();
//List <SRAT_Additional_Tracking_Level_1__c> lstsratLevel1RecFST = new  List <SRAT_Additional_Tracking_Level_1__c>();
// List<Id> lstsratLevel1RecIds = new List<Id>();
// List<Id> lstsratLevel1RecIdsFST = new List<Id>();
//List<SRAT_Additional_Tracking_Level_2__c> lstsratLevel2Rec = new List<SRAT_Additional_Tracking_Level_2__c>();
//List<SRAT_Additional_Tracking_Level_2_FST__c> lstsratLevel2RecFSTOBJ = new List<SRAT_Additional_Tracking_Level_2_FST__c>();
// List<SRAT_Additional_Tracking_Level_2__c> UpdatelstsratLevel2Recs = new  List<SRAT_Additional_Tracking_Level_2__c>();
// List<SRAT_Additional_Tracking_Level_1__c> UpdatelstsratLevel1Recs = new  List<SRAT_Additional_Tracking_Level_1__c>();
// List<SRAT_Additional_Tracking_Level_1__c> UpdatelstsratLevel1RecsFST = new  List<SRAT_Additional_Tracking_Level_1__c>();
// List<SRAT_Additional_Tracking_Level_2_FST__c> UpdatelstsratLevel2RecsFSTOBJ = new  List<SRAT_Additional_Tracking_Level_2_FST__c>();

Set<Id> planIdList = new Set<Id>();

 if(!lstsratChklistSubmit.isEmpty()) {
    for(SRAT_Tracker__c sratSubmitChklst: lstsratChklistSubmit) {
        //lstsratChklistSubmitIds.add(sratSubmitChklst.Id);
        planIdList.add(sratSubmitChklst.Mobilization_Plan__c);
    }
        database.executeBatch(new SRATOPEXRecTypeL1L2Update (planIdList, UtillContstant_Novasuite.LEVEL1, UtillContstant_Novasuite.SRAT));
    

    }
  
 }
 
 
}

/*
    //Set<Id> sratIds = new Set<Id>(lstsratChklistSubmitIds);
    //if(lstsratChklistSubmitIds <> null && lstsratChklistSubmitIds.size() > 0){
    
 //lstsratLevel1Rec = [Select Id,Name,SRAT_Tracker__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c IN: lstsratChklistSubmitIds AND SRAT_Level_1_Tracking_Type__c != 'Factory Specific Technology'];
 RecordType sratLevel1RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL1  and DeveloperName = :UtilCOnstants.SRAT_LEVEL1_NOT_FST LIMIT 1];
 for(SRAT_Additional_Tracking_Level_1__c sratLevel1Rec: [Select Id,Name,SRAT_Tracker__c from SRAT_Additional_Tracking_Level_1__c 
                                                            where SRAT_Tracker__c IN: lstsratChklistSubmitIds 
                                                            AND SRAT_Level_1_Tracking_Type__c !=: UtilConstants.FACTRY_SPEC_TECH limit 5000]) {
    lstsratLevel1RecIds.add(sratLevel1Rec.Id);
   
    sratLevel1Rec.RecordTypeId = sratLevel1RecordType.Id;
    UpdatelstsratLevel1Recs.add(sratLevel1Rec);
}

//lstsratLevel1RecFST = [Select Id,Name,SRAT_Tracker__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c IN: lstsratChklistSubmitIds AND SRAT_Level_1_Tracking_Type__c = 'Factory Specific Technology'];
 RecordType sratLevel1RecordTypeFST = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL1  and DeveloperName = :UtilCOnstants.SRAT_LEVEL1_FST LIMIT 1];
 for(SRAT_Additional_Tracking_Level_1__c sratLevel1RecFST: [Select Id,Name,SRAT_Tracker__c from SRAT_Additional_Tracking_Level_1__c 
                                                            where SRAT_Tracker__c IN: lstsratChklistSubmitIds AND 
                                                            SRAT_Level_1_Tracking_Type__c =: UtilConstants.FACTRY_SPEC_TECH limit 5000]) {
    lstsratLevel1RecIdsFST.add(sratLevel1RecFST.Id);
   
    sratLevel1RecFST.RecordTypeId = sratLevel1RecordTypeFST.Id;
    UpdatelstsratLevel1RecsFST.add(sratLevel1RecFST);
}

  
//lstsratLevel2Rec = [Select Id,Name,SRAT_Additional_Tracking_Level_1__c from SRAT_Additional_Tracking_Level_2__c where SRAT_Additional_Tracking_Level_1__c IN: lstsratLevel1RecIds];
 
RecordType sratLevel2RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL2  and DeveloperName = :UtilCOnstants.SRAT_LEVL2_READ_ONLY LIMIT 1];
 
for(SRAT_Additional_Tracking_Level_2__c sratLevel2Rec: [Select Id,Name,SRAT_Additional_Tracking_Level_1__c from SRAT_Additional_Tracking_Level_2__c 
                                                        where SRAT_Additional_Tracking_Level_1__c IN: lstsratLevel1RecIds limit 5000]) {
        sratLevel2Rec.RecordTypeId = sratLevel2RecordType.Id;
        UpdatelstsratLevel2Recs.add(sratLevel2Rec);
}

//lstsratLevel2RecFSTOBJ = [Select Id,Name,Deal_SRAT_Additional_Tracking_Level_1__c from SRAT_Additional_Tracking_Level_2_FST__c where Deal_SRAT_Additional_Tracking_Level_1__c IN: lstsratLevel1RecIdsFST];
 
RecordType sratLevel2RecordTypeFSTOBJ = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL2_FST_OBJ  and DeveloperName = :UtilCOnstants.SRAT_LEVL2_FST_OBJ_READ_ONLY LIMIT 1];
 
for(SRAT_Additional_Tracking_Level_2_FST__c sratLevel2RecFSTOBJ: [Select Id,Name,Deal_SRAT_Additional_Tracking_Level_1__c 
                                                                    from SRAT_Additional_Tracking_Level_2_FST__c 
                                                                    where Deal_SRAT_Additional_Tracking_Level_1__c IN: lstsratLevel1RecIdsFST limit 5000]) {
        sratLevel2RecFSTOBJ.RecordTypeId = sratLevel2RecordTypeFSTOBJ.Id;
        UpdatelstsratLevel2RecsFSTOBJ.add(sratLevel2RecFSTOBJ);
}

 
try {
 
        if(!UpdatelstsratLevel1Recs.isEmpty()) {              
         Database.update(UpdatelstsratLevel1Recs,false);            
         }else{}

        if(!UpdatelstsratLevel1RecsFST.isEmpty()) {              
         Database.update(UpdatelstsratLevel1RecsFST,false);            
         }else{}
        
         if(!UpdatelstsratLevel2Recs.isEmpty()) {              
         Database.update(UpdatelstsratLevel2Recs,false);            
         }else{}

        if(!UpdatelstsratLevel2RecsFSTOBJ.isEmpty()) {              
         Database.update(UpdatelstsratLevel2RecsFSTOBJ,false);            
         }else{}


    }
         catch(Exception e) {
            String str9 = e.getMessage();
         }
     */