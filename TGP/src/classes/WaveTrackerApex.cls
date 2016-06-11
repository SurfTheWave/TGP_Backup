/**
 *@Author:MWB developer
 *@Name:WaveTrackerApex
 *@created date: 05 Jan 2015
 *@Description:This class contains methods to create tracker items
 *@version:1.0
 */
public without sharing class WaveTrackerApex {
    /**
     *@Author:MWB developer
     *@Name:prePopulateTrackingInsert
     *@created date: 05 Jan 2015
     *@Description:This method is used to call other methods to insert data
     *@version:1.0
     */
    public void prePopulateTrackingInsert(List<Wave__c> waveList) {       
        try{
            Set<ID> waveID = new Set<ID>();
            List<Wave__c> lstWave = new  List<Wave__c>();
            for(Wave__c wp : waveList) {
                if(wp.Active__c && wp.Baseline_Wave__c == null){
                    lstWave.add(wp);
                }
            }   
            //List<Wave__c> lstWave=[Select id,Name,Mobilization_Plan__c,Active__c from Wave__c where id IN : waveID and Active__c =true limit 100];
            if(!lstWave.isEmpty()) {
                insertRecruitmentTracking(lstWave);
                insertKTTracking(lstWave);
                insertTechTracking(lstWave);
                insertSRATracking(lstWave);
                insertOPEXTracking(lstWave);
                insertWaveModule(lstWave);
            }    
           }
        catch(Exception exp) {
            //system.debug('Error ' + exp.getMessage());
            string msg = exp.getMessage();
        }        
    }    
        
   /*
    *   @ Method : insertRecruitmentTracking
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the Recruitment Tracking records
    */
    public void insertRecruitmentTracking (List<Wave__c> lstWave) {
        Recruit_Tracker__c rTracker=null;
        List <Recruit_Tracker__c> lstRecruit = new List <Recruit_Tracker__c>();
        
        try {            
             for(Wave__c w : lstWave){
                for(Recruitement_Activity_Master__c rm: [Select id,Name,Active__c,Activity_Order__c 
                                                         from Recruitement_Activity_Master__c where Active__c = true limit 5000]) {
                    rTracker = new Recruit_Tracker__c();
                    rTracker.Name=rm.Name;     
                    rTracker.Recruitement_Activity_Master__c=rm.id;                    
                    rTracker.Activity_Order__c=rm.Activity_Order__c;
                    rTracker.Mobilization_Plan__c=w.Mobilization_Plan__c;
                    rTracker.isTrackingOn__c = w.isTrackingOn__c;
                    rTracker.Wave__c=w.id;
                                           
                    lstRecruit.add(rTracker);
                }
             }
             if(!lstRecruit.isEmpty()) {
                Database.insert(lstRecruit,false);
             }
        }
        catch(Exception e) {
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVETRACKERAPEX_CLASS , UtilConstants.WAVETRACKERAPEX_CLASS , null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to Delete Recruitment Trackers ' + e.getMessage());
        }  
    }
   
   /*
    *   @ Method : insertKTTracking
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the KT Tracking records
    */
    public void insertKTTracking(List<Wave__c> lstWave) {
        KT_Trac__c kTracker=null;
        List <KT_Trac__c> lstKt = new List <KT_Trac__c>();
        
        try {            
             for(Wave__c w : lstWave){
                for(KT_Activity_Master__c ktm: [Select id,Name,Active__c,Activity_Order__c
                from KT_Activity_Master__c where Active__c = true limit 5000]) {
                    kTracker= new KT_Trac__c ();
                    kTracker.Name=ktm.Name;     
                    kTracker.KT_Activity_Master__c=ktm.id;                    
                    kTracker.Activity_Order__c=ktm.Activity_Order__c;
                    kTracker.Mobilization_Plan__c=w.Mobilization_Plan__c;
                    kTracker.isTrackingOn__c = w.isTrackingOn__c;
                    kTracker.Wave__c=w.id;
                                           
                    lstKt.add(kTracker);
                }
             }
             if(!lstKt.isEmpty()) {
                Database.insert(lstKt,false);
             }
        }
        catch(Exception e) {
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVETRACKERAPEX_CLASS , UtilConstants.WAVETRACKERAPEX_CLASS , null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to Delete KT Trackers ' + e.getMessage());
        }  
    } 
    
      
    /*
    *   @ Method : insertTech&WETracking
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the Tech & WE Tracking records
    */
    public void insertTechTracking(List<Wave__c> lstWave) {
        Tech_WE_Tracker__c TechTracker=null;
        List <Tech_WE_Tracker__c> lstTech = new List <Tech_WE_Tracker__c>();
     
        try {            
             for(Wave__c w : lstWave){
                for(Tech_WE_Activity_Master__c TechM: [Select id,Name,Active__c,Activity_Order__c 
                                                       from Tech_WE_Activity_Master__c where Active__c = true limit 5000]) {
                    TechTracker= new Tech_WE_Tracker__c();
                    TechTracker.Name=TechM.Name;     
                    TechTracker.Tech_W_Activity_Master__c=TechM.id;                    
                    TechTracker.Activity_Order__c=TechM.Activity_Order__c;
                    TechTracker.Mobilization_Plan__c=w.Mobilization_Plan__c;
                    TechTracker.Wave__c=w.id;
                    TechTracker.isTrackingOn__c= w.isTrackingOn__c;                       
                    lstTech.add(TechTracker);
                }
             }
             if(!lstTech.isEmpty()) {
                Database.insert(lstTech,false);
             }
        }
        catch(Exception e) {
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVETRACKERAPEX_CLASS , UtilConstants.WAVETRACKERAPEX_CLASS , null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to Delete Tech & WE Trackers ' + e.getMessage());
        }  
    }
       
     /*
    *   @ Method : insertSRATtracking
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the SRAT records
    */
    public void insertSRATracking(List<Wave__c> lstWave) {
        SRAT_Tracker__c sratTracker=null;
        List <SRAT_Tracker__c> lstTech = new List <SRAT_Tracker__c>();
        
        try {            
             for(Wave__c w : lstWave){
                for(SRAT_Master__c sratM: [Select id,Name,Active__c,Days_Before_Go_Live__c,Item_Order__c 
                                           from SRAT_Master__c where Active__c = true limit 5000]) {
                    sratTracker = new SRAT_Tracker__c ();
                    sratTracker.Name=sratM.Name;     
                    sratTracker.SRAT_Master__c=sratM.id;                    
                    sratTracker.Item_Order__c=sratM.Item_Order__c;
                    sratTracker.Days_Before_Go_Live__c=sratM.Days_Before_Go_Live__c;
                    sratTracker.Mobilization_Plan__c=w.Mobilization_Plan__c;
                    sratTracker.isTrackingOn__c= w.isTrackingOn__c;
                    sratTracker.Wave__c=w.id;
                                           
                    lstTech.add(sratTracker);
                }
             }
             if(!lstTech.isEmpty()) {
                Database.insert(lstTech,false);
             }
        }
        catch(Exception e) {
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVETRACKERAPEX_CLASS , UtilConstants.WAVETRACKERAPEX_CLASS , null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to Delete SRAT Trackers ' + e.getMessage());
        }  
    } 
    
    
    /*
    *   @ Method : insertOPEXtracking
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the OPEX records
    */
    public void insertOPEXTracking(List<Wave__c> lstWave) {
        OPEX_Tracker__c opexTracker=null;
        List <OPEX_Tracker__c> lstTech = new List <OPEX_Tracker__c>();
        List<Id> lstMobIds = new List<Id>();
        List<Mobilization_Plan__c> lstMobPlanIsTrackingOn = new List<Mobilization_Plan__c>();
        
    //    ManageMoblilzationPlan mngPlan = new ManageMoblilzationPlan();
        
        
        try {            
             for(Wave__c w : lstWave){
                for(OPEX_Master__c opexM: [Select id,Name,Active__c,Days_After_Go_Live__c,Item_Order__c 
                                           from OPEX_Master__c where Active__c = true limit 5000]) {
                    opexTracker = new OPEX_Tracker__c();
                    opexTracker.Name=opexM.Name;     
                    opexTracker.OPEX_Master__c=opexM.id;                    
                    opexTracker.Item_Order__c=opexM.Item_Order__c;
                    opexTracker.Days_After_Go_Live__c=opexM.Days_After_Go_Live__c;
                    opexTracker.Mobilization_Plan__c=w.Mobilization_Plan__c;
                    opexTracker.isTrackingOn__c=w.isTrackingOn__c;
                    opexTracker.Wave__c=w.id;
                                           
                    lstTech.add(opexTracker);
                }
             }
             if(!lstTech.isEmpty()) {
                Database.insert(lstTech,false);
                for(Wave__c lwave: lstWave) {
                    lstMobIds.add(lwave.Mobilization_Plan__c);
                }
                lstMobPlanIsTrackingOn = [Select Id,Name,IsTrackingOn__c from
                Mobilization_Plan__c where ID IN: lstMobIds AND  IsTrackingOn__c = TRUE LIMIT 2000];
                if(!lstMobPlanIsTrackingOn.isEmpty()) {
                  Database.executeBatch(new OpexSratBatchInsert(lstMobPlanIsTrackingOn),6); 
            //    mngPlan.insertOpexLevel1(lstMobPlanIsTrackingOn);
                }
             }
        }
        catch(Exception e) {
            //system.debug('Error for OPEX' + e.getMessage() );
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVETRACKERAPEX_CLASS , UtilConstants.WAVETRACKERAPEX_CLASS , null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to Delete OPEX Trackers ' + e.getMessage());
        }  
    }                                                      
   
    /*
    *   @ Method : insertWaveModule
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the Wave Module Status records
    */    
    public void insertWaveModule(List<Wave__c> waveList){
        List<Wave_Module_Status__c> wmList = new List<Wave_Module_Status__c>();
        Wave_Module_Status__c wmS=null;
        
        for(Wave__c w: waveList){
            wms = new Wave_Module_Status__c();
            wms.Wave__c= w.Id;
            wms.Name= w.Name;
            wms.Mobilization_Plan__c = w.Mobilization_Plan__c;
            wms.Active__c =  true;
            wmList.add(wmS);    
        }
        
        
        if(wmList.size() > 0){
            try{
                Database.insert(wmList);
            }
                
            catch (Exception e){
                //system.debug('Error for WMS' + e.getMessage());
                 UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVETRACKERAPEX_CLASS , UtilConstants.WAVETRACKERAPEX_CLASS , null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to Delete Wave Module Satus ' + e.getMessage());   
            }
        }
        
    }
}