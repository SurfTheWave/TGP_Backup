/*
  @Author: MWB Developer
  @Name: OpexSratBatchInsert
  @Created Date: 05 January 2015
  @Description: This class is used to run opex Srat batch class
  @version: 1.0 
*/
global class OpexSratBatchInsert implements Database.Batchable<sObject>, Database.Stateful{
    
  //  global final String MobIds;
      global final String query;  
      global List<Id> MobIds = new List<Id>(); 
    
    /*
      @Author: MWB Developer
      @Name: OpexSratBatchInsert
      @Created Date: 05 January 2015
      @Description: This constructor method is called on creation of new OpexSratBatchInsert class
      @version: 1.0 
    */
    global OpexSratBatchInsert(List<Mobilization_Plan__c> lstMobplan){
        
     //   query=qur;
          for(Mobilization_Plan__c mobplan: lstMobplan) {
             MobIds.add(mobplan.Id);  
          }   
          
          query = UtilConstants.MOB_QUERY;  
    }

    /*
      @Author: MWB Developer
      @Name: start
      @Created Date: 05 January 2015
      @Description: This method is called from constructor method to run the interface
      @version: 1.0 
    */
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    
    }

    /*
      @Author: MWB Developer
      @Name: start
      @Created Date: 05 January 2015
      @Description: This method is called from start method to run the execution part of batch class
      @version: 1.0 
    */
    global void execute(Database.BatchableContext bc,List<Wave__c> lstWave){
    
    //Devanna: Below code to insert the records in 'OPEX Additional tracker level1Ã¢â‚¬â„¢ copying from Ã¢â‚¬ËœOPEX Additional Tracker level1 Master' and to insert 'OPEX Additional tracker level2Ã¢â‚¬â„¢ copying from Ã¢â‚¬ËœOPEX Additional Tracker level2 Master'.
    
    SavePoint sp = Database.setSavepoint();
    
    List<Id> WaveIds = new List<Id>();
    List<Id> lstOTIds = new List<Id>();
    List<Id> lstExistingOpexTrackerIds = new List<Id>();
    Deal_OPEX_Additional_Tracking_Level_1__c OpexLevel1;
    List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOpexLevel1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
    Deal_OPEX_Additional_Tracking_Level_2__c Opexlevel2;
    List<Deal_OPEX_Additional_Tracking_Level_2__c> lstOpexLevel2 = new  List<Deal_OPEX_Additional_Tracking_Level_2__c>();
    Deal_OPEX_Additional_Tckn_Level_2_MOMC__c Opexlevel2MOMC;
    List<Deal_OPEX_Additional_Tckn_Level_2_MOMC__c> lstOpexlevel2MOMC = new List<Deal_OPEX_Additional_Tckn_Level_2_MOMC__c>();
    List<OPEX_Additional_Tracking_Level1_Master__c> lstOpexLevel1Master = new List<OPEX_Additional_Tracking_Level1_Master__c>();
    
    OpexTrackerClass OTclass = new OpexTrackerClass();
    List<OPEX_Tracker__c> lstOpexUserCreated = new List<OPEX_Tracker__c>();
    
    
        for(Wave__c wave: lstWave) {
            WaveIds.add(wave.Id);
        }
        
        try {
        
         for(OPEX_Tracker__c checkOT:  [Select Id,Name,Wave__c,Mobilization_Plan__c,OPEX_Master__c from OPEX_Tracker__c where Wave__c IN: WaveIds limit 5000]) {
            lstOTIds.add(checkOT.Id);
        }
        for(Deal_OPEX_Additional_Tracking_Level_1__c existOpexL1: [Select Name,Id,OPEX_Tracker_del__c from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__c IN: lstOTIds limit 5000]) {
            lstExistingOpexTrackerIds.add(existOpexL1.OPEX_Tracker_del__c);
        }
        
        lstOpexLevel1Master = [Select Id,Name,OPEX_Level_1_Tracking_Type__c,Active__c,Order__c,OPEX_Master__c from  OPEX_Additional_Tracking_Level1_Master__c where Active__c = TRUE LIMIT 5000];
        
        for(OPEX_Tracker__c ot: [Select Id,Name,OPEX_Master__c,Wave__c,Mobilization_Plan__c,Days_After_Go_Live__c from OPEX_Tracker__c where ID IN: lstOTIds AND ID NOT IN: lstExistingOpexTrackerIds limit 5000]){
            for(OPEX_Additional_Tracking_Level1_Master__c om: lstOpexLevel1Master) {
                if(om.OPEX_Master__c == ot.OPEX_Master__c) {             
                    OpexLevel1 = new Deal_OPEX_Additional_Tracking_Level_1__c();
                    OpexLevel1.Name = om.Name;
                    OpexLevel1.OPEX_Level_1_Tracking_Type__c = om.OPEX_Level_1_Tracking_Type__c;
                    OpexLevel1.OPEX_Additional_Tracking_Level1_Master__c = om.Id;
                    OpexLevel1.OPEX_Tracker_del__c = ot.Id;
                    OpexLevel1.Active__c = om.Active__c;
                    OpexLevel1.Order__c = om.Order__c;
                                                
                    lstOpexLevel1.add(OpexLevel1);
                }
                
            }
            string opexusercreated = ot.OPEX_Master__c;           
            if(opexusercreated==null || String.ISBLANK(opexusercreated)) {
                    lstOpexUserCreated.add(ot);
                }     
        
        }
        
        
         if(!lstOpexLevel1.isEmpty()) {               
         insert lstOpexLevel1;             
         }
                           
         
         List<Id> lstOL1Ids = new List<Id>();
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c OL1: lstOpexLevel1) {
            lstOL1Ids.add(OL1.Id);
         }
         
         //map<Id,Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day1 = new map<Id,Deal_OPEX_Additional_Tracking_Level_1__c>();       
         //List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         //List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1DayMinus3 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         //List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day7 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         //List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day30 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         //List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day60 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         //List<Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day90 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day90 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day7 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day30 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
         List<Deal_OPEX_Additional_Tracking_Level_1__c> UpdatelstOTL1Day60 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
                          
         //lstL1DayMinus3 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c, OPEX_Tracker_del__r.Wave__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = -1];
         
         /*lstL1Day1 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c 
                        from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 1 limit 5000];*/
        map<Id,Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day1 = new map<Id,Deal_OPEX_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 1 limit 5000]);                        
         /*lstL1Day7 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c 
                        from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 7 limit 5000];*/
        map<Id,Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day7 = new map<Id,Deal_OPEX_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 7 limit 5000]);                    
         /*lstL1Day30 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c 
                        from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 30 limit 5000];*/
         map<Id,Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day30 = new map<Id,Deal_OPEX_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 30 limit 5000]);
         /*lstL1Day60 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c 
                        from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 60 limit 5000];*/
        map<Id,Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day60 = new map<Id,Deal_OPEX_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 60 limit 5000]);
         /*lstL1Day90 = [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c 
                        from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 90 limit 5000];*/
        map<Id,Deal_OPEX_Additional_Tracking_Level_1__c> lstL1Day90 = new map<Id,Deal_OPEX_Additional_Tracking_Level_1__c>([Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 90 limit 5000]);
         
       // ////system.debug('lstL1Day30 :'+lstL1Day30);         
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day60: [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from  Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 60 limit 5000]) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day90: lstL1Day90.values()) {
                if( (L1Day90.OPEX_Level_1_Tracking_Type__c == L1Day60.OPEX_Level_1_Tracking_Type__c) && (L1Day90.OPEX_Tracker_del__r.Wave__c == L1Day60.OPEX_Tracker_del__r.Wave__c) ) {
                    L1Day90.Previous_Item__c = L1Day60.Id;
                    UpdatelstOTL1Day90.add(L1Day90);
                }
            }
        }
       
                if(!UpdatelstOTL1Day90.isEmpty()) {      
         update UpdatelstOTL1Day90;        
         }
                        
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day30: [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from  Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 30 limit 5000]) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day60: lstL1Day60.values()) {
                if( (L1Day60.OPEX_Level_1_Tracking_Type__c == L1Day30.OPEX_Level_1_Tracking_Type__c) && (L1Day60.OPEX_Tracker_del__r.Wave__c == L1Day30.OPEX_Tracker_del__r.Wave__c) ) {
                    L1Day60.Previous_Item__c = L1Day30.Id;
                    UpdatelstOTL1Day60.add(L1Day60);
                }
            }
        }
        
                if(!UpdatelstOTL1Day60.isEmpty())    {   
                update UpdatelstOTL1Day60;        
         }
        
         
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day7: [Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from  Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 7 limit 5000]) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day30: lstL1Day30.values()) {
                if( (L1Day30.OPEX_Level_1_Tracking_Type__c == L1Day7.OPEX_Level_1_Tracking_Type__c) && (L1Day30.OPEX_Tracker_del__r.Wave__c == L1Day7.OPEX_Tracker_del__r.Wave__c) )  {
                    L1Day30.Previous_Item__c = L1Day7.Id;
                    UpdatelstOTL1Day30.add(L1Day30);
                }
            }
        }
        
              if(!UpdatelstOTL1Day30.isEmpty())   {      
              update UpdatelstOTL1Day30;        
         }
                 
        
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day1:[Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c,OPEX_Tracker_del__r.Wave__c from  Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = 1 limit 5000]) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day7: lstL1Day7.values()) {
                if( (L1Day7.OPEX_Level_1_Tracking_Type__c == L1Day1.OPEX_Level_1_Tracking_Type__c) && (L1Day7.OPEX_Tracker_del__r.Wave__c == L1Day1.OPEX_Tracker_del__r.Wave__c) )  {
                    L1Day7.Previous_Item__c = L1Day1.Id;
                    UpdatelstOTL1Day7.add(L1Day7);
                }
            }
        }
        
             if(!UpdatelstOTL1Day7.isEmpty()) {          
             update UpdatelstOTL1Day7;   
             }
                  
        
         for(Deal_OPEX_Additional_Tracking_Level_1__c L1DayM3:[Select Name,Id,Previous_Item__c,OPEX_Tracker_del__c,OPEX_Level_1_Tracking_Type__c,Days_After_Go_Live__c, OPEX_Tracker_del__r.Wave__c from  Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: lstOL1Ids AND Days_After_Go_Live__c = -1 limit 5000]) {
            for(Deal_OPEX_Additional_Tracking_Level_1__c L1Day1: lstL1Day1.values()) {
                if( (L1Day1.OPEX_Level_1_Tracking_Type__c == L1DayM3.OPEX_Level_1_Tracking_Type__c) && (L1Day1.OPEX_Tracker_del__r.Wave__c == L1DayM3.OPEX_Tracker_del__r.Wave__c) )  {
                    L1Day1.Previous_Item__c = L1DayM3.Id;
                    UpdatelstOTL1Day1.add(L1Day1);
                }
            }
        }
        
            if(!UpdatelstOTL1Day1.isEmpty())  {       
          update UpdatelstOTL1Day1;        
         }
         
         
         
        List<OPEX_Additional_Tracking_Level2_Master__c> lstOpexLevel2Master = new List<OPEX_Additional_Tracking_Level2_Master__c>();
          lstOpexLevel2Master = [Select Id,Name,Active__c,OPEX_Additional_Tracking_Level1_Master__c,Question__c,Order__c from OPEX_Additional_Tracking_Level2_Master__c where Active__c = TRUE LIMIT 5000];         
         
         for(Deal_OPEX_Additional_Tracking_Level_1__c ol1: lstOpexLevel1) {
           if(ol1.OPEX_Level_1_Tracking_Type__c != UtilConstants.MOB_OPERATE_CRITERIA) {
            for(OPEX_Additional_Tracking_Level2_Master__c om2: lstOpexLevel2Master) {
                if(ol1.OPEX_Additional_Tracking_Level1_Master__c == om2.OPEX_Additional_Tracking_Level1_Master__c) {
                    ////system.debug('ol1.OPEX_Level_1_Tracking_Type__c:'+ol1.OPEX_Level_1_Tracking_Type__c);
                    Opexlevel2 = new Deal_OPEX_Additional_Tracking_Level_2__c();
                    Opexlevel2.Name = om2.Name;
                    Opexlevel2.Question_Description__c = om2.Question__c;
                  //  Opexlevel2.Answer__c = om2.Answer__c;
                    Opexlevel2.OPEX_Tracking_Item__c = ol1.OPEX_Tracker_del__c;
                    Opexlevel2.Deal_OPEX_Additional_Tracking_Level_1__c = ol1.Id;
                    Opexlevel2.Order__c = om2.Order__c;
                    Opexlevel2.Active__c = om2.Active__c;
                    
                    lstOpexLevel2.add(Opexlevel2);
                }
              
            }
            
          }
           else {
                    Opexlevel2MOMC = new Deal_OPEX_Additional_Tckn_Level_2_MOMC__c();
                    Opexlevel2MOMC.Deal_OPEX_Additional_Tracking_Level_1__c = ol1.Id;
                    Opexlevel2MOMC.OPEX_Tracking_Item__c = ol1.OPEX_Tracker_del__c;
                    
                    lstOpexlevel2MOMC.add(Opexlevel2MOMC);
                }
         
         }
         
         if(!lstOpexLevel2.isEmpty()) {               
         insert lstOpexLevel2;             
         }
                 
         
          
         if(!lstOpexlevel2MOMC.isEmpty()) {               
         insert lstOpexlevel2MOMC;             
         }
         
        if(!lstOpexUserCreated.isEmpty()) {  
             
         OTclass.InsertOpexL1L2(lstOpexUserCreated);
        }          
     
    }
    catch(Exception e) {
    System.debug(LoggingLevel.Error, 'OpexExceptionError:'); 
    system.debug(LoggingLevel.Info,'OpexException');
    Database.rollback(sp);
    }
        
        
    //Devanna: Below code to insert the records in 'SRAT Additional Tracking Level 1Ã¢â‚¬â„¢ & 'SRAT Additional Tracking Level 2' copying from the respective masters object.
    
    List<Id> lstSTIds = new List<Id>();
    List<Id> lstExistingSratTrackerIds = new List<Id>();
    SRAT_Additional_Tracking_Level_1__c SratLevel1;
    List<SRAT_Additional_Tracking_Level_1__c> lstSratLevel1 = new List<SRAT_Additional_Tracking_Level_1__c>();
    SRAT_Additional_Tracking_Level_2__c Sratlevel2;
    List<SRAT_Additional_Tracking_Level_2__c> lstSratLevel2 = new  List<SRAT_Additional_Tracking_Level_2__c>();
    List<SRAT_Additional_Tracking_Level1_Master__c> lstSratLevel1Master = new List<SRAT_Additional_Tracking_Level1_Master__c>();
    
    SratTrackerClass STclass = new SratTrackerClass();
    List<SRAT_Tracker__c> lstSratUserCreated = new List<SRAT_Tracker__c>();
       
    try {
        
        for(SRAT_Tracker__c checkST:  [Select Id,Name,Wave__c,Mobilization_Plan__c,SRAT_Master__c from SRAT_Tracker__c where Wave__c IN: WaveIds limit 5000]) {
            lstSTIds.add(checkST.Id);
        }
        for(SRAT_Additional_Tracking_Level_1__c existSratL1: [Select Name,Id,SRAT_Tracker__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c IN: lstSTIds limit 5000]) {
            lstExistingSratTrackerIds.add(existSratL1.SRAT_Tracker__c);
        }
        
        lstSratLevel1Master = [Select Id,Name,Order__c,Question__c,SRAT_Level1_Tracking_Type__c,Active__c,SRAT_Master__c from SRAT_Additional_Tracking_Level1_Master__c where Active__c = TRUE LIMIT 5000];
        
         for(SRAT_Tracker__c st: [Select Id,Name,Wave__c,Mobilization_Plan__c,SRAT_Master__c,Days_Before_Go_Live__c from  SRAT_Tracker__c where ID IN: lstSTIds AND ID NOT IN: lstExistingSratTrackerIds limit 5000]){
            for(SRAT_Additional_Tracking_Level1_Master__c sm: lstSratLevel1Master) {
                if(sm.SRAT_Master__c == st.SRAT_Master__c) {            
                SratLevel1 = new SRAT_Additional_Tracking_Level_1__c();
                SratLevel1.Name = sm.Name;
                SratLevel1.SRAT_Level_1_Tracking_Type__c = sm.SRAT_Level1_Tracking_Type__c;
                SratLevel1.SRAT_Additional_Tracking_Level1_Master__c = sm.Id;
                SratLevel1.SRAT_Tracker__c = st.Id;
                SratLevel1.Active__c = sm.Active__c;
                SratLevel1.Order__c = sm.Order__c;
                SratLevel1.Question__c = sm.Question__c;         
                               
                lstSratLevel1.add(SratLevel1);
              }
            }
            
            string sratusercreated = st.SRAT_Master__c;           
            if(sratusercreated==null || String.ISBLANK(sratusercreated)) {
                    lstSratUserCreated.add(st);
                } 
        
        }
       
         if(!lstSratLevel1.isEmpty()) {               
         insert lstSratLevel1;             
         }
         
         
         
         
        List<Id> lstSL1Ids = new List<Id>();
         
         for(SRAT_Additional_Tracking_Level_1__c SL1: lstSratLevel1) {
            lstSL1Ids.add(SL1.Id);
         }
        
                
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSTL1Item5 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSTL1Item30 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSTL1Item60 = new List<SRAT_Additional_Tracking_Level_1__c>();
         List<SRAT_Additional_Tracking_Level_1__c> UpdatelstSTL1Item90 = new List<SRAT_Additional_Tracking_Level_1__c>();
         
         List<SRAT_Additional_Tracking_Level_1__c> lstSL1Item30 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = 30 limit 5000];
         List<SRAT_Additional_Tracking_Level_1__c> lstSL1Item60 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = 60 limit 5000];
         List<SRAT_Additional_Tracking_Level_1__c> lstSL1Item90 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = 90 limit 5000];
         List<SRAT_Additional_Tracking_Level_1__c> lstSL1Item120 = [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = 120 limit 5000];

                 
          for(SRAT_Additional_Tracking_Level_1__c SL1Item5: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = 5 limit 5000]) {
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
         
        
          for(SRAT_Additional_Tracking_Level_1__c SL1Item30: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = 30 limit 5000]) {
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
                  
          for(SRAT_Additional_Tracking_Level_1__c SL1Item60: [Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = 60 limit 5000]) {
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
         
                  
          for(SRAT_Additional_Tracking_Level_1__c SL1Item90:[Select Name,Id,Previous_Item__c,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_1__c where Id IN: lstSL1Ids AND SRAT_Days_Before_Go_Live__c = 90 limit 5000]) {
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
                
         
         
        List<SRAT_Additional_Tracking_Level2_Master__c> lstSratLevel2Master = new List<SRAT_Additional_Tracking_Level2_Master__c>();
          lstSratLevel2Master = [Select Id,Name,Active__c,Additional_Information__c,Category__c,Order__c,Question__c,Section__c,SRAT_Additional_Tracking_Level1_Master__c,Title__c from SRAT_Additional_Tracking_Level2_Master__c where Active__c = TRUE LIMIT 5000];         
         
         for(SRAT_Additional_Tracking_Level_1__c sl1: lstSratLevel1) {
           if(sl1.SRAT_Level_1_Tracking_Type__c != UtilConstants.FACTRY_SPEC_TECH) {
            for(SRAT_Additional_Tracking_Level2_Master__c sm2: lstSratLevel2Master) {
                if(sl1.SRAT_Additional_Tracking_Level1_Master__c == sm2.SRAT_Additional_Tracking_Level1_Master__c) {
                    //////system.debug('ol1.OPEX_Level_1_Tracking_Type__c:'+ol1.OPEX_Level_1_Tracking_Type__c);
                    Sratlevel2 = new SRAT_Additional_Tracking_Level_2__c();
                    Sratlevel2.SRAT_Tracking_Item__c = sl1.SRAT_Tracker__c;
                    Sratlevel2.Name = sm2.Name;
                    Sratlevel2.Active__c = sm2.Active__c;
                    Sratlevel2.Additional_Information__c = sm2.Additional_Information__c;
                    Sratlevel2.Category__c = sm2.Category__c;
                    Sratlevel2.Order__c = sm2.Order__c;
                    Sratlevel2.Question__c = sm2.Question__c;
                    Sratlevel2.Section__c = sm2.Section__c;
                    Sratlevel2.SRAT_Additional_Tracking_Level_1__c = sl1.Id;
                    Sratlevel2.Title_Description__c = sm2.Title__c;
                    Sratlevel2.SRAT_Level_1_Tracking_Type__c = sl1.SRAT_Level_1_Tracking_Type__c;
                    
                    
                    lstSratLevel2.add(Sratlevel2);
                }
              
            }
            
          }
                    
         }
         
         if(!lstSratLevel2.isEmpty()) {               
         insert lstSratLevel2;             
         }
         
                  
         
         List<Id> lstSL2Ids = new List<Id>();
         
         for(SRAT_Additional_Tracking_Level_2__c SL2: lstSratLevel2) {
            lstSL2Ids.add(SL2.Id);
         }
         
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSTL2Item5 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSTL2Item30 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSTL2Item60 = new List<SRAT_Additional_Tracking_Level_2__c>();
         List<SRAT_Additional_Tracking_Level_2__c> UpdatelstSTL2Item90 = new List<SRAT_Additional_Tracking_Level_2__c>();
                 
                  
        List<SRAT_Additional_Tracking_Level_2__c> lstSL2Item30 = [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = 30 limit 5000];
        List<SRAT_Additional_Tracking_Level_2__c> lstSL2Item60 = [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = 60 limit 5000];
        List<SRAT_Additional_Tracking_Level_2__c> lstSL2Item90 = [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = 90 limit 5000];
        List<SRAT_Additional_Tracking_Level_2__c> lstSL2Item120 = [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = 120 limit 5000];
         
         
         for(SRAT_Additional_Tracking_Level_2__c SL2Item5: [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = 5 limit 5000]) {
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
                                        
          for(SRAT_Additional_Tracking_Level_2__c SL2Item30: [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = 30 limit 5000]) {
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
                  
         
          for(SRAT_Additional_Tracking_Level_2__c SL2Item60: [Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = 60 limit 5000]) {
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
                 
         
          for(SRAT_Additional_Tracking_Level_2__c SL2Item90:[Select Name,Id,Previous_Item__c,SRAT_Level_1_Tracking_Type__c,SRAT_Days_Before_Go_Live__c,SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Wave__c from  SRAT_Additional_Tracking_Level_2__c where Id IN: lstSL2Ids AND SRAT_Days_Before_Go_Live__c = 90 limit 5000]) {
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
         
         
         if(!lstSratUserCreated.isEmpty()) {  
             
         STclass.InsertSratL1L2(lstSratUserCreated);
        }
                 
    }
    catch(Exception e) {
   
    system.debug(LoggingLevel.Info,'ExceptionSrat:');
       System.debug('ERROR ' + e);
    Database.rollback(sp);
    }
  
    
    
    
    }
    
    /*
      @Author: MWB Developer
      @Name: finish
      @Created Date: 05 January 2015
      @Description: This method is executed after all class is initalized
      @version: 1.0 
    */
     global void finish(Database.BatchableContext bc){
        
                
    }
    
    
}