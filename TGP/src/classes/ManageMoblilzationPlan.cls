/**
   @Author Divyashree C K
   @name ManageMoblilzationPlan
   @CreateDate 30/12/2014
   @Description This is the helper class for MobilizationPlanTrigger
   @Version <1.0>
   @reference 
  */
public with sharing class ManageMoblilzationPlan {
 private List<BCP_Tracker__c> bcpInsertList ;
 private List <Contract_Legal_Tracker__c> legalInsrtList;
 private List <Contract_Legal_Tracker__c> legalTrkrsToDel;
 private List<Id> legalsToDel;
 private List<Mobilization_Plan__c> svceMobPlans;
 private List<Mobilization_Plan__c> svceTrkrsDel;
 private List<Service_Management_Tracker__c> svceTrkrList;
 private List<Mobilization_Plan__c> jrnyMobPlans;
 private List<Mobilization_Plan__c> jrnyMobPlansDel;
 private List<Journey_Management_Tracker__c> jrnyTrkrsList;
 public Savepoint trackersSavePoint;
 public SavePoint trackingSavePoint;
 public SavePoint  deactivatingSavePoint;




/*
*    @Description: Method to manage Plan level Trackers
*    @Name : manageAllTrackers
*    @param 
*    @return <parameter> - void
*    @throws exception- Exception Logging Framework
*/
public void manageAllTrackers(Map<Id, Mobilization_Plan__c> triggernewMap, Boolean isInsert, Map<Id, Mobilization_Plan__c> triggerOldMap){
    trackersSavePoint= Database.setSavePoint();
    
    try{
        manageBCPTrackers(triggernewMap, isInsert , triggeroldMap);
        manageBudgetTrackers(triggernewMap, isInsert , triggeroldMap);
        manageLegalTrackers(triggernewMap, isInsert , triggeroldMap);
        manageServiceTrackers(triggernewMap, isInsert , triggeroldMap);
        manageJrnyTrkrs(triggernewMap, isInsert , triggeroldMap);
        }
        
    catch(Exception e){
        Database.rollback(trackersSavePoint);
        UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
                    ////system.debug('ERROR!!!  Error while managing Trackers ' + e.getMessage());
        
        }
}
    


/**
   *  @Description Method to manage BCP trackers.If BCP type is not client driven, then BCP trackers are inserted. If BCP is Client Driven, BCP trackerws are deleted
   *  @name manageBCPTrackers
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */
 public void  manageBCPTrackers(Map<Id, Mobilization_Plan__c> triggernewMap, Boolean isInsert, Map<Id, Mobilization_Plan__c> triggerOldMap){
 List<Mobilization_Plan__c > bcpMobPlans = new List<Mobilization_Plan__c >();
 List<Id> nonStdBCPstoDel= new List<Id>();
 List<Id> stdBCPsToDel= new List<Id>();
 List<BCP_Tracker__c> bcpTrackersDel;
 List<Id > bcpstoDel = new List<Id> ();
  
    if(isInsert){
       
        for(Mobilization_Plan__c m: triggernewMap.values()){
         //system.debug('BCPTYPE : ' + m.BCP_Type__c);
            if(m.Active__c &&  m.Baseline_Mobilization_Plan__c== null &&  m.BCP_Type__c <> null && 
            m.BCP_Type__c  <> UtilConstants.CLIENT_DRIVEN_BCP){
                bcpMobPlans.add(m);
            }
        }
    }
    else {
        for(Mobilization_Plan__c  mPlan : triggernewMap.values()){
                //system.debug('mPlan.BCP_type -> ' +  mPlan.BCP_Type__c);
            if(mPlan.Active__c && mPlan.BCP_Type__c!= triggerOldMap.get(mPlan.Id).BCP_Type__c){
                
                if(String.IsBlank(mPlan.BCP_Type__c) || mPlan.BCP_Type__c.equals(UtilConstants.CLIENT_DRIVEN_BCP) 
                    || mPlan.BCP_Type__c.equals(UtilConstants.EMPTY_STRING) ){
                    bcpstoDel.add(mPlan.Id);
                }
                else if(mPlan.BCP_Type__c.equals(UtilConstants.STD_OFFER)){
                    bcpMobPlans.add(mPlan);
                    nonStdBCPstoDel.add(mPlan.Id);    
                }
                else if(mPlan.BCP_Type__c.equals(UtilConstants.NON_STD_OFFER)){
                    bcpMobPlans.add(mPlan);
                    stdBCPsToDel.add(mPlan.Id);
                }
                else{
                }
            }

        }
    }

    bcpTrackersDel = new List<BCP_Tracker__c>();
    if(nonStdBCPstoDel.size() > 0){
        bcpTrackersDel.addAll([SELECT Id, BCP_Type__c FROM BCP_Tracker__c  WHERE 
        Mobilization_Plan__c IN : nonStdBCPstoDel AND BCP_Type__c  = :UtilConstants.NON_STD_OFFER LIMIT 5000]);
    }
    if(stdBCPsToDel.size() > 0){
        bcpTrackersDel.addAll([SELECT Id, BCP_Type__c FROM BCP_Tracker__c  
        WHERE Mobilization_Plan__c IN : stdBCPsToDel AND BCP_Type__c  = :UtilConstants.STD_OFFER LIMIT 5000]);
    }
    if(bcpstoDel.size() >0){
        bcpTrackersDel.addAll([SELECT Id, Name, Mobilization_Plan__c FROM BCP_Tracker__c 
        WHERE Mobilization_Plan__c IN :bcpstoDel LIMIT 5000]);
    }
    if(bcpMobPlans.size() > 0){
              insertBCPTrackers(bcpMobPlans);
      }  
   
    if(bcpTrackersDel.size() > 0){
        try{
            database.delete(bcpTrackersDel);
        }
        catch (Exception e){
            Database.rollback(trackersSavePoint);
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
            UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , null, System.Logginglevel.ERROR);
            //system.debug('ERROR!!!  Unable to Delete BCP Trackers ' + e.getMessage());
        }
    }                       
    
 }

/**
   *  @Description Method to insert BCP trackers
   *  @name insertBCPTrackers
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */
 public void insertBCPTrackers(List<Mobilization_Plan__c > bcpMobPlans){
   BCP_Tracker__c bcp=null;  
   bcpInsertList = new List<BCP_Tracker__c>();
       //system.debug('bcpMobPlans ' + bcpMobPlans);
      List<BCP_Master__c> bcpMstersList = [SELECT Id, Name, Section__c, Task__C, BCP_Type__c ,Task_Order__c FROM BCP_Master__c 
                                                    WHERE Active__c =TRUE ORDER BY Task_Order__c LIMIT 5000];
        if(bcpMstersList.size() > 0){                                                    
          for(BCP_Master__c bcpMstr : bcpMstersList){
                  for(Mobilization_Plan__c mobPlan : bcpMobPlans){
                      if(bcpMstr.BCP_Type__c == mobPlan.BCP_Type__c){
                          bcp = new BCP_Tracker__c();
                          bcp.BCP_Master__c = bcpMstr.Id;
                          bcp.Section__c = bcpMstr.Section__c;
                          bcp.Task_Order__c = bcpMstr.Task_Order__c;
                          bcp.BCP_Type__c = bcpMstr.BCP_Type__c;
                          bcp.Mobilization_Plan__c = mobPlan.Id;
                          bcp.Name = bcpMstr.Name;
                          bcp.Task_Description__c = bcpMstr.Task__c;
                          bcp.IsPlanActive__c = true;
                          bcp.IsTrackingOn__c = mobPlan.isTrackingOn__c;
                          bcpInsertList.add(bcp);
                      } 
                  }
           }
           if(bcpInsertList.size() > 0){
               try{
                    database.insert(bcpInsertList);
                }
                catch (Exception e){
                    Database.rollback(trackersSavePoint);
                    UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to insert BCP Trackers ' + e.getMessage());
                }
           }
        }
    }


/**
   *  @Description : When a plan is created, the budget tracker would be set up  automatically.
   *  @name manageBudgetTrackers
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */
 public void  manageBudgetTrackers(Map<Id, Mobilization_Plan__c> triggernewMap, Boolean isInsert, Map<Id, Mobilization_Plan__c> triggerOld){
 List<Budget_Trac__c> bdgtInsertList;
 List<Budget_Master__c > bdgtMstrsList;
 Budget_Trac__c bdgtTrkr=null;    
 List<Mobilization_Plan__c > activeBudgetPlans = new List <Mobilization_Plan__c >();
     if(isInsert){
         for(Mobilization_Plan__c mobPlan : triggernewMap.values()){
             if(mobPlan.Active__c && mobPlan.Baseline_Mobilization_Plan__c== null ){
                 activeBudgetPlans.add(mobPlan);
             }
         }
         
         if(activeBudgetPlans.size() > 0){
             bdgtInsertList = new List<Budget_Trac__c>();
             bdgtMstrsList = [SELECT ID, Name, Active__c , Activity_Order__c FROM Budget_Master__c
                         WHERE Active__c = TRUE ORDER BY Activity_Order__c LIMIT 5000];
             if(bdgtMstrsList.size() > 0){
                 for(Mobilization_Plan__c mobPlan : activeBudgetPlans){
                     if(mobPlan.Active__c){
                         for(Budget_Master__c  bdgtMstr : bdgtMstrsList){
                             bdgtTrkr = new Budget_Trac__c();
                             bdgtTrkr.Mobilization_Plan__c = mobPlan.Id;
                             bdgtTrkr.Activity_Order__c = bdgtMstr.Activity_Order__c;
                             bdgtTrkr.Budget_Master__c = bdgtMstr.Id;
                             bdgtTrkr.Name = bdgtMstr.Name;
                            // bdgtTrkr.Task_Description__c = bdgtMstr.Task__c;
                             bdgtTrkr.IsPlanActive__c = true;
                             bdgtTrkr.isTrackingOn__c = mobPlan.isTrackingOn__c;
                             bdgtInsertList.add(bdgtTrkr);
                         }
                     }
                 }
               if(bdgtInsertList.size() > 0){
                   try{
                        database.insert(bdgtInsertList);
                    }
                    catch (Exception e){
                        Database.rollback(trackersSavePoint);
                        UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
                        //system.debug('ERROR!!!  Unable to Insert Budget Trackers ' + e.getMessage());
                    }
               }     
           }         
         }
    }
 }
    
    
    
/**
   *  Method to manage Legeal Trackers. If Contract and legal is in scope, then legagl trackers are setup for the plan   
   *  @name manageLegalTrackers
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */    
 public void  manageLegalTrackers(Map<Id, Mobilization_Plan__c> triggernewMap, Boolean isInsert, Map<Id, Mobilization_Plan__c> triggerOldMap){
  List<Mobilization_Plan__c> legalMobPlans = new List <Mobilization_Plan__c>();
  List<Mobilization_Plan__c> legalTrkrsDel; 
 
 //If Insert, check if Contract & legal is in scope
     if(isInsert){
        for(Mobilization_Plan__c  mPlan: triggernewMap.values()){
            if(mPlan.Active__c && mPlan.Baseline_Mobilization_Plan__c== null && mPlan.Contract_Legal_In_Scope__c){
                legalMobPlans.add(mPlan);
            }
        }
     }
     //Else Check if Contract & Legal scope has been recently enabled
     else {
         legalTrkrsDel = new List<Mobilization_Plan__c> ();
         for(Mobilization_Plan__c  mPlan: triggernewMap.values()){
             if(mPlan.Active__c && mPlan.Contract_Legal_In_Scope__c && (!triggerOldMap.get(mPlan.Id).Contract_Legal_In_Scope__c )){
                 legalMobPlans.add(mPlan);
             }
             
             else if (mPlan.Active__c && (!mPlan.Contract_Legal_In_Scope__c) && triggerOldMap.get(mPlan.Id).Contract_Legal_In_Scope__c){
                 legalTrkrsDel.add(mPlan);
             }
             else{
             }
         }
     }
     if(legalMobPlans.size() > 0){
         insertLegalTrackers(legalMobPlans);
     }
     
     if(legalTrkrsDel <> null && legalTrkrsDel.size() > 0){
         legalTrkrsToDel = [SELECT Id, Mobilization_Plan__c, Name FROM Contract_Legal_Tracker__c 
         WHERE Mobilization_Plan__c IN : legalTrkrsDel LIMIT 5000];
         if(legalTrkrsToDel.size() > 0){
             try{
                 database.delete(legalTrkrsToDel);
             }
         
             catch(Exception e ){
                 Database.rollback(trackersSavePoint);
                 UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
                 //system.debug('ERROR!!!  Unable to Delete Legal Trackers ' + e.getMessage() );
             }
         }
     }
 }
 
/**
   *  Method to insert Legeal Trackers. 
   *  @name insertLegalTrackers
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */ 
 public void insertLegalTrackers(List<Mobilization_Plan__c> legalMobPlans)   {
  Contract_Legal_Tracker__c legalTrkr;
  legalInsrtList = new List <Contract_Legal_Tracker__c>();
 
         if(legalMobPlans.size() > 0){
            List<Contract_Legal_Master__c>  LegalMstrsList = [SELECT Id, Name, Section__c, Task_Order__c, Task__c
                                            FROM Contract_Legal_Master__c WHERE Active__c = TRUE ORDER BY Task_Order__c LIMIT 5000];
            if(LegalMstrsList.size() > 0){                                            
                for(Mobilization_Plan__c  mobPlan  :legalMobPlans){
                    for(Contract_Legal_Master__c legalMstr : LegalMstrsList)  {
                        legalTrkr = new Contract_Legal_Tracker__c();
                        legalTrkr.Mobilization_Plan__c = mobPlan.Id;
                        legalTrkr.IsPlanActive__c = true;
                        legalTrkr.Contract_Master__c = legalMstr.Id;
                        legalTrkr.Section__c = legalMstr.Section__c;
                        legalTrkr.Task_Order__c = legalMstr.Task_Order__c ;
                        legalTrkr.Name = legalMstr.Name;
                        legalTrkr.Task_Description__c = legalMstr.Task__c;
                        legalTrkr.isTrackingOn__c = mobPlan.isTrackingOn__c;
                        legalInsrtList.add(legalTrkr);
                    }          
                }                                            
            }
        }
        
        if(legalInsrtList.size() > 0){
            try{
                    database.insert(legalInsrtList);
                }
                catch (Exception e){
                    Database.rollback(trackersSavePoint);
                    UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to Insert Legal Trackers :  ' + e.getMessage());
                }
        }
 }
 
 
 
/**
   *  Method to manage Service Management Trackers. When service Management is in scope, service management trackers are automatically setup for the plan  
   *  @name manageServiceTrackers
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */ 
public void  manageServiceTrackers(Map<Id, Mobilization_Plan__c> triggernewMap, Boolean isInsert, Map<Id, Mobilization_Plan__c> triggerOldMap){

 svceMobPlans = new List<Mobilization_Plan__c>();
        if(isInsert){
            for(Mobilization_Plan__c mPlan : triggernewMap.values()){
                if(mPlan.Active__c && mPlan.Baseline_Mobilization_Plan__c== null && mPlan.Service_Management_In_Scope__c){
                    svceMobPlans.add(mPlan);
                }
            }
        }  
        else {
            svceTrkrsDel = new List<Mobilization_Plan__c>();
            for(Mobilization_Plan__c mobPlan : triggernewMap.values()){
                if(mobPlan.Active__c && (!triggerOldMap.get(mobPlan.Id).Service_Management_In_Scope__c) 
                    && mobPlan.Service_Management_In_Scope__c){
                    svceMobPlans.add(mobPlan);
                }
               else if(mobPlan.Active__c &&  (!mobPlan.Service_Management_In_Scope__c) && triggerOldMap.get(mobPlan.Id).Service_Management_In_Scope__c) {
                   svceTrkrsDel.add(mobPlan);
               }
               else{
               }
            }
        }
        
        if(svceTrkrsDel <> null && svceTrkrsDel.size() >  0){
            svceTrkrList = new List<Service_Management_Tracker__c>();
            svceTrkrList = [SELECT ID, Name, Active__c, Mobilization_Plan__c, Section__c, Deliverable_Order__c 
            FROM Service_Management_Tracker__c
                            WHERE Mobilization_Plan__c IN : svceTrkrsDel LIMIT 5000];
            if(svceTrkrList.size() > 0)  {
                try{
                    database.delete(svceTrkrList);
                }
                
                catch (Exception e){
                    Database.rollback(trackersSavePoint);
                    UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
                    //system.debug('ERROR!!!  Unable to delete Service Trackers :  ' + e.getMessage());
                }
            }           
        }
        
        if(svceMobPlans.size() > 0){
            insertSvceTrkrs(svceMobPlans);
        }
              
    }


/**
   *  Method to insert Service Management Trackers
   *  @name insertSvceTrkrs
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */ 
 public void insertSvceTrkrs(List<Mobilization_Plan__c> mobPlansSetSvce){
 Service_Management_Tracker__c svceTrkr=null;
 List<Service_Mgmt_Master__c> svceMstrsList=null;
 svceTrkrList = new List<Service_Management_Tracker__c> ();
     
     if(mobPlansSetSvce.size() > 0){
       svceMstrsList   = [SELECT Id, Name,  Deliverable_Order__c, Section__c, Deliverable__c 
                          FROM Service_Mgmt_Master__c WHERE Active__c =TRUE ORDER BY Deliverable_Order__c LIMIT 5000];
         if(svceMstrsList.size() > 0){
             for(Mobilization_Plan__c mPlanSvce : mobPlansSetSvce){
                 for(Service_Mgmt_Master__c svceMstr : svceMstrsList ){
                     svceTrkr = new Service_Management_Tracker__c ();
                     svceTrkr.Mobilization_Plan__c = mPlanSvce.Id;
                     svceTrkr.Service_Management_Master__c = svceMstr.Id;
                     svceTrkr.Section__c = svceMstr.section__c;
                     svceTrkr.Name = svceMstr.Name;
                     svceTrkr.Deliverable_Description__c = svceMstr.Deliverable__c;
                     svceTrkr.Deliverable_Order__c = svceMstr.Deliverable_Order__c;
                     svceTrkr.IsPlanActive__c  = true;
                     svceTrkr.isTrackingOn__c = mPlanSvce.isTrackingOn__c;
                     svceTrkrList.add(svceTrkr);
                 }
             }
         }                                                    
                                                             
     }
     
     if(svceTrkrList.size() > 0){
         //system.debug('svceTrkrList ' + svceTrkrList);
         try{
             database.insert(svceTrkrList);
         }
         catch (Exception e ){
             Database.rollback(trackersSavePoint);
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
             //system.debug('ERROR!!!  Unable to Insert Service Trackers :  ' + e.getMessage());
         }
     }
     
 }

/**
   *  Method to manage Journey Management trackers. When Journey Management is in scope, Journey management trackers are automatically setup for the plan 
   *  @name manageJrnyTrkrs
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */ 
 public void  manageJrnyTrkrs(Map<Id, Mobilization_Plan__c> triggernewMap, Boolean isInsert, Map<Id, Mobilization_Plan__c> triggerOldMap){
     jrnyMobPlans = new List<Mobilization_Plan__c>();
     
     if(isInsert){
         for(Mobilization_Plan__c mobPlan : triggernewMap.values()){
             if(mobPlan.Active__c && mobPlan.Baseline_Mobilization_Plan__c== null && mobPlan.Journey_Management_In_Scope__c){
                 jrnyMobPlans.add(mobPlan);
             }
         }
     }
     
     else{
         jrnyMobPlansDel = new List<Mobilization_Plan__c>();
         for(Mobilization_Plan__c mPlan : triggernewMap.values()){
             if(mPlan.Active__c && mPlan.Journey_Management_In_Scope__c && 
             (!triggerOldMap.get(mPlan.Id).Journey_Management_In_Scope__c)){
                 jrnyMobPlans.add(mPlan);
             }
             
             else if(mPlan.Active__c && triggerOldMap.get(mPlan.Id).Journey_Management_In_Scope__c 
             && (!mPlan.Journey_Management_In_Scope__c)){
                 jrnyMobPlansDel.add(mPlan);
             }
             else{
             }
         }
     }
     
     if(jrnyMobPlansDel <> null && jrnyMobPlansDel.size() > 0){
         jrnyTrkrsList = [SELECT Id, Name, Active__c, Mobilization_Plan__c, Status__c, Deliverable_Number__c 
                         FROM Journey_Management_Tracker__c WHERE Mobilization_Plan__c IN :jrnyMobPlansDel LIMIT 5000];
        if(jrnyTrkrsList.size() > 0){
            try{
               database.delete(jrnyTrkrsList);
            }
            catch(Exception e ){
                Database.rollback(trackersSavePoint);
                UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
                //system.debug('ERROR!!!  Unable to delete Journey Trackers :  ' + e.getMessage());
            }
        }                        
     }
     
     if(jrnyMobPlans.size() > 0){
         insertJrnyTrkrs(jrnyMobPlans);
     }
 }
 
 
 
 /**
   *  Method to insert Journey trackers
   *  @name insertJrnyTrkrs
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */
 public  void insertJrnyTrkrs(List<Mobilization_Plan__c> jrnyMobPlans){
 List<Journey_Management_Master__c> jrnyMstrs = new List<Journey_Management_Master__c>();
 Journey_Management_Tracker__c jTrkr=null ;
 jrnyTrkrsList= new List<Journey_Management_Tracker__c>();
 
     if(jrnyMobPlans.size() > 0){
         jrnyMstrs  = [SELECT ID, Name, Deliverable_Number__c, Section__c, Deliverable__c, Section_Number__c 
                         FROM Journey_Management_Master__c WHERE Active__c = TRUE ORDER BY Deliverable_Number__c LIMIT 5000 ];
         if(jrnyMstrs.size() > 0){
             
             for(Mobilization_Plan__c mPlan : jrnyMobPlans){
                 for(Journey_Management_Master__c jMstr: jrnyMstrs){
                     jTrkr  = new Journey_Management_Tracker__c ();
                     jTrkr.Mobilization_Plan__c = mPlan.Id;
                     jTrkr.Journey_Management_Master__c = jMstr.Id;
                     jTrkr.Name = jMstr.Name;
                     jTrkr.Section__c = jMstr.Section__c;
                     jTrkr.Section_Number__c = jMstr.Section_Number__c;
                     jTrkr.Deliverable_Number__c =  jMstr.Deliverable_Number__c;
                     jTrkr.Deliverable_Description_del__c =  jMstr.Deliverable__c;
                     jTrkr.IsPlanActive__c=  true;
                     jTrkr.isTrackingOn__c = mPlan.isTrackingOn__c;
                     jrnyTrkrsList.add(jTrkr);
                 }
             }
         }
         
     }
     
     if(jrnyTrkrsList.size() > 0){
         //system.debug('jrnyTrkrsList ' + jrnyTrkrsList);
         try{
             database.insert(jrnyTrkrsList);
         }
         catch (Exception e ) {
             Database.rollback(trackersSavePoint);
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
             //system.debug('ERROR!!!  Unable to insert Journey Trackers :  ' + e.getMessage());
         }
     }
 }


 /**
   *  Increment Version of Mobilization Plan. Check if the previous version is Active, If yes, inactivate the previous version
   *  @name checkPlanStatus
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */
  public void checkPlanStatus(List<Mobilization_Plan__c> triggernew, Boolean isInsert, Map<Id, Mobilization_Plan__c> triggerOldMap){
  
    List<Mobilization_Plan__c> activemobPlans = new List<Mobilization_Plan__c>();
    List<Id> DealIds= new List<Id>();
    List<Mobilization_Plan__c> mobPlans= new List<Mobilization_Plan__c>();
    Map<String,Mobilization_Plan__c > dealPlanMap = new Map<String, Mobilization_Plan__c>();
    List<Mobilization_Plan__c> deactivatePlansList= new List<Mobilization_Plan__c>();

try{
        for(Mobilization_Plan__c mPlan : triggernew){
                if(mPlan.Active__c){
                    activemobPlans.add(mPlan);
                    DealIds.add(mPlan.Deal__c);
                } 
        }
        
        if(activemobPlans.size() > 0){
           mobPlans=[ SELECT Id, Name, CreatedDate, Service_Group__c, Deal__c, Deal__r.Name, Version__c, Active__c
                               FROM Mobilization_Plan__c WHERE Deal__c IN : DealIds
                               ORDER BY Deal__c, Version__c DESC NULLS Last LIMIT 5000];      
           if(mobPlans.size() > 0){
               for(Mobilization_Plan__c  mPlan : mobPlans){
                   //system.debug('Mob PLan cosidered ' + mPlan );
                   if(dealPlanMap.containsKey(mPlan.Deal__c + mplan.Service_Group__c) ){
                       if((dealPlanMap.get(mPlan.Deal__c+mplan.Service_Group__c).Version__c < mPlan.Version__c) ){
                            dealPlanMap.put(mPlan.Deal__c+ mplan.Service_Group__c, mPlan);
                        }
                   }
                   
                   else {
                       dealPlanMap.put(mPlan.Deal__c+mplan.Service_Group__c, mPlan);
                   }
               }
           }
        }
        
        //system.debug('PLan Map ' + dealPlanMap);
// Increment the verison by 1 and inactivate the previous plan if the plan is active        
        for(Mobilization_Plan__c  tempMob :  triggernew){
            if(dealPlanMap.containsKey(tempMob.Deal__c + tempMob.Service_Group__c)&&  
            dealPlanMap.get(tempMob.Deal__c + +tempMob.Service_Group__c) <> null){
                tempMob.Version__c = dealPlanMap.get(tempMob.Deal__c + tempMob.Service_Group__c).Version__c + 1;                
                //system.debug('Version for ' +tempMob.Name + 'is '  + tempMob.Version__c);
                if(dealPlanMap.get(tempMob.Deal__c + tempMob.Service_Group__c).Active__c ){
                    deactivatePlansList.add(dealPlanMap.get(tempMob.Deal__c + tempMob.Service_Group__c));                    
                    //system.debug('Plan ' + tempMob.Id +  'is active');
                }
            }
            else {
                tempMob.Version__c = 1;
            } 
        }
        
        if(deactivatePlansList.size() > 0){ 
     
            deactivatePlans_V2(deactivatePlansList);
        }
   } 
   Catch(Exception e)
   {
      UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
   }
  }
 
/**
   *  Check the Plan for Tracking. The Plan is baselined if not already baselined before enabling Tracking
   *  @name checkForTracking
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception + Logging Framework
   */
 public void checkForTracking(Map<Id, Mobilization_Plan__c> triggernewMap, Boolean isInsert, Map<Id, Mobilization_Plan__c> triggerOldMap){
     List<Mobilization_Plan__c> plansTrkEn = new List<Mobilization_Plan__c> ();
     trackingSavePoint = Database.setSavePoint();
     try{
     if(isInsert){
         for(Mobilization_Plan__c mPlan : triggernewMap.values()){
             if(mPlan.IsTrackingon__c){
                 plansTrkEn.add(mPlan);
             }
         }
     }
     
     else{
         for(Mobilization_Plan__c mPlan : triggernewMap.values()){
             if((mPlan.IsTrackingOn__c) && (!triggerOldMap.get(mPlan.Id).IsTrackingOn__c)){
                 plansTrkEn.add(mPlan);
             }
         }
     }
    
     if(plansTrkEn.size() > 0){
           List<Mobilization_Plan__c> planstoEnTrk= checkBaselineBeforeTrking(triggernewMap, plansTrkEn);
           if(plansToEnTrk <> null && plansToEnTrk .size() > 0){
               String methodResult = enableTrkingOnPlan(triggernewMap, plansToEnTrk );
        /* if(!UtilConstants.SUCCESS_MESSAGE.equals(methodResult)){
               Database.rollBack(trackingSavePoint ); 
           } */
           }
     }
     }
     Catch(Exception e)
     {
        UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , 
                        null, System.Logginglevel.ERROR);
     }
 }

/**
   *  Method to enable tracking on Waves, Wave prceosses and tracker records
   *  @name enableTrkingOnPlan_V2
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */ 
 private String enableTrkingOnPlan(Map<Id, Mobilization_Plan__c> triggernewMap, List<MObilization_Plan__c> plansToTrk){
     List<Id> planIds = new List<Id>();
     List<sObject> planTrkrsEnList = new List<Sobject>();
     List<sObject> waveTrkrsEnList = new List<Sobject>();
     List<sObject> objEnList= new List<Sobject>();
     List<sObject> waveEnList =  new List<Sobject>();
     List<sObject> ktTrkrsEnList = new List<Sobject>();
     List<sObject> sratTrkrsEnList = new List<Sobject>();
     List<sObject> opexTrkrsEnList = new List<Sobject>();
     List<sObject> recrTrkrsEnList = new List<Sobject>();
     List<sObject> techTrkrsEnList = new List<Sobject>();
     
     
     for(Mobilization_Plan__c mPlan : plansToTrk){
         //system.debug('&&&&&&&' + mplan);
            //if(mPlan.IsTrackingOn__c && (triggernewMap.get(mPlan.id).Baseline_Mobilization_Plan__c == null))
              if(mPlan.IsTrackingOn__c){
                planIds.add(mPlan.id);
              }
        }
        
     if(planIds.size() > 0){
     objEnList  = [SELECT ID, Name, Active__c, IsTrackingOn__c, Version__c ,
                            (SELECT ID, Name,  Active__c, IsTrackingOn__c, Mobilization_Plan__c FROM Waves__r LIMIT 5000),
                            (SELECT ID, Name, Active__c, IsTrackingOn__c, Mobilization_Plan__c FROM Wave_Process__r LIMIT 5000),
                            (SELECT ID, Name, Planned_Start_Date__c, Planned_End_Date__c, Active__c, IsTrackingOn__c, Mobilization_Plan__c, Task_Order__c FROM BCP_Trackers__r LIMIT 5000),
                            (SELECT ID, Name, Planned_Start_Date__c, Planned_End_Date__c, Active__c, IsTrackingOn__c, Mobilization_Plan__c, Activity_Order__c FROM Budget_Trackers__r LIMIT 5000),
                            (SELECT ID, Name, Planned_Start_Date__c, Planned_End_Date__c, Active__c, IsTrackingOn__c, Mobilization_Plan__c, Task_Order__c FROM Contract_Legal_Trackers__r LIMIT 5000),
                            (SELECT ID, Name, Planned_Start_Date__c, Planned_End_Date__c, Active__c, IsTrackingOn__c, Mobilization_Plan__c, Section_Number__c FROM Journey_Management_Trackers__r LIMIT 5000),
                            (SELECT ID, Name, Planned_Start_Date__c, Planned_End_Date__c, Active__c, IsTrackingOn__c, Mobilization_Plan__c, Activity_Order__c FROM KT_Trackers__r LIMIT 5000),
                            (SELECT ID, Name,  Active__c, IsTrackingOn__c, Mobilization_Plan__c, Item_Order__c FROM OPEX_Trackers__r LIMIT 5000),
                            (SELECT ID, Name, Planned_Start_Date__c, Planned_End_Date__c, Active__c, IsTrackingOn__c, Mobilization_Plan__c, Activity_Order__c FROM Recruitment_Trackers__r LIMIT 5000),
                            (SELECT ID, Name,  Active__c, IsTrackingOn__c, Mobilization_Plan__c, Item_Order__c FROM SRAT_Trackers__r LIMIT 5000),
                            (SELECT ID, Name, Planned_Start_Date__c, Planned_End_Date__c, Active__c, IsTrackingOn__c, Mobilization_Plan__c, Deliverable_Order__c FROM Service_Management_Trackers__r LIMIT 5000),
                            (SELECT ID, Name, Planned_Start_Date__c, Planned_End_Date__c, Active__c, IsTrackingOn__c, Mobilization_Plan__c, Activity_Order__c FROM Tech_WE_Trackers__r LIMIT 5000)
                                    FROM Mobilization_Plan__c WHERE ID IN : planIds LIMIT 5000 ];
                                    
      for(Integer l =0 ; l<objEnList.size(); l++){                            
            if(objEnList.get(l).getSObjects(UtilConstants.BCP_TRACKERS) <> null) {                
            planTrkrsEnList.addAll(objEnList.get(l).getSObjects(UtilConstants.BCP_TRACKERS));}
            if(objEnList.get(l).getSObjects(UtilConstants.BUDGET_TRACKERS) <> null ){             
            planTrkrsEnList.addAll(objEnList.get(l).getSObjects(UtilConstants.BUDGET_TRACKERS));}
            if(objEnList.get(l).getSObjects(UtilConstants.CONTRACT_LEGAL_TRACKERS) <> null) {     
            planTrkrsEnList.addAll( objEnList.get(l).getSObjects(UtilConstants.CONTRACT_LEGAL_TRACKERS));}
            if(objEnList.get(l).getSObjects(UtilConstants.JOURNEY_MANAGEMENT_TRACKERS) <> null) { 
            planTrkrsEnList.addAll( objEnList.get(l).getSObjects(UtilConstants.JOURNEY_MANAGEMENT_TRACKERS));}
            if(objEnList.get(l).getSObjects(UtilConstants.SERVICE_MANAGEMENT_TRACKERS) <> null) { 
            planTrkrsEnList.addAll( objEnList.get(l).getSObjects(UtilConstants.SERVICE_MANAGEMENT_TRACKERS));}
            if(objEnList.get(l).getsObjects(UtilConstants.KT_TRACKERS) <> null) {                 
            ktTrkrsEnList.addAll(   objEnList.get(l).getsObjects(UtilConstants.KT_TRACKERS));}
            if(objEnList.get(l).getsObjects(UtilConstants.OPEX_TRACKERS) <> null) {               
            opexTrkrsEnList.addAll( objEnList.get(l).getsObjects(UtilConstants.OPEX_TRACKERS));}
            if(objEnList.get(l).getsObjects(UtilConstants.RECRUITMENT_TRACKERS) <> null) {        
            recrTrkrsEnList.addAll( objEnList.get(l).getsObjects(UtilConstants.RECRUITMENT_TRACKERS));}
            if(objEnList.get(l).getsObjects(UtilConstants.SRAT_TRACKERS) <> null) {               
            sratTrkrsEnList.addAll( objEnList.get(l).getsObjects(UtilConstants.SRAT_TRACKERS));}
            if(objEnList.get(l).getsObjects(UtilConstants.TECH_WE_TRACKERS) <> null) {            
            techTrkrsEnList.addAll( objEnList.get(l).getsObjects(UtilConstants.TECH_WE_TRACKERS));}
            if(objEnList.get(l).getSObjects(UtilConstants.WAVES) <> null) {                       
            waveEnList.addAll(objEnList.get(l).getSObjects(UtilConstants.WAVES));}
            if(objEnList.get(l).getSObjects(UtilConstants.WAVE_PROCESS) <> null) {                
            waveEnList.addAll(objEnList.get(l).getSObjects(UtilConstants.WAVE_PROCESS));}
            }
       } 
       planTrkrsEnList.sort();
       waveTrkrsEnList.sort();
       try{
           
           if(waveEnList.size() > 0){
               for(sObject wave: waveEnList){
                   wave.put(UtilConstants.ISTRACKINGON_FIELD, true);
               }
           }
            waveEnList.sort();
            Database.update(waveEnList);
           
            
           if(planTrkrsEnList.size() > 0){
               for(sObject obj : planTrkrsEnList){
                   obj.put(UtilConstants.ISTRACKINGON_FIELD, true);
               }
            }
            planTrkrsEnList.sort();  
            Database.update(planTrkrsEnList);
            
            
            if(ktTrkrsEnList.size() > 0){
                for(sObject s :ktTrkrsEnList){
                    s.put(UtilConstants.ISTRACKINGON_FIELD, true);
                }
            }
            ktTrkrsEnList.sort();
            Database.update(ktTrkrsEnList);

            
            if(recrTrkrsEnList.size() > 0){
                for(sObject s :recrTrkrsEnList){
                    s.put(UtilConstants.ISTRACKINGON_FIELD, true);
                }
            }
            recrTrkrsEnList.sort();
            Database.update(recrTrkrsEnList);
            
            //system.debug('Recr Done ');
            
            if(techTrkrsEnList.size() > 0){
                for(sObject s :techTrkrsEnList){
                    s.put(UtilConstants.ISTRACKINGON_FIELD, true);
                }
            }
            techTrkrsEnList.sort();
            Database.update(techTrkrsEnList);

            //system.debug('Tech Done ');
            
            waveTrkrsEnList.sort();  
            Database.update(waveTrkrsEnList);
            
            //system.debug('Wave Done ');
            
            if(sratTrkrsEnList.size() > 0){
                for(sObject s :sratTrkrsEnList){
                    s.put(UtilConstants.ISTRACKINGON_FIELD, true);
                }
            }
            sratTrkrsEnList.sort();
            Database.update(sratTrkrsEnList);
            
                        
            if(opexTrkrsEnList.size() > 0){
                for(sObject s :opexTrkrsEnList){
                    s.put(UtilConstants.ISTRACKINGON_FIELD, true);
                }
            }
            opexTrkrsEnList.sort();
            Database.update(opexTrkrsEnList);
            
            return UtilConstants.SUCCESS_MESSAGE ;
         
         }
        
        
        catch (Exception e){
            //system.debug('ERROR!!!!  Unable to add isTrackingOn' + e.getMessage());
            Database.rollback(trackingSavePoint );
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
            UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , null, 
            System.Logginglevel.ERROR);
            return UtilConstants.FAILURE_MESSAGE;
          } 
     }
 

/**
   *  Any plan should be baselined before enabling tracking. This method baselines the plan is the plan has not been already baselined
   *  @name checkBaselineBeforeTrking
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */ 
  public List<Mobilization_Plan__c> checkBaselineBeforeTrking(Map<Id, Mobilization_Plan__c> triggernewMap, List< Mobilization_Plan__c> plansForTrking){
    List<Mobilization_Plan__c> baselinedPlans = new List<Mobilization_Plan__c>();
     for(Mobilization_Plan__c mob: plansForTrking){
         if(mob.isTrackingOn__c && (!(mob.Baseline_Mobilization_Plan__c <> null))){
             String baselineId = MobilizationReBaseline.baselineMobilizationPlan(mob.Id,true);
             if(!baselineId.contains(UtilConstants.FAILURE_MESSAGE)){
                mob.Baseline_Mobilization_Plan__c = baselineId ;
             }
             else {
                 Database.rollback(trackingSavePoint);
                 Mobilization_Plan__c errorPlan = triggernewMap.get(mob.Id);
                 errorPlan.addError(UtilConstants.MOBPLAN_BASELINE_ERROR );
                 //system.debug('ERROR!! Unable to Baseline  ' + baselineId );
             }
         }else if(mob.isTrackingOn__c){
             baselinedPlans.add(mob);
         }else {
             
         }      
     }
     return baselinedPlans;
     
 }

 /**
   *  Method to inactivate previous version of Mobilization Plan and all its child records
   *  @name  deactivatePlans_V2
   *  @param 
   *  @return <parameter> - void
   *  @throws exception- Exception Logging Framework
   */      
 public void deactivatePlans_V2(List<Mobilization_Plan__c> plansToDeacti){
 
     List<sObject> planTrkrsList = new List<Sobject>();
     List<sObject> waveTrkrsList = new List<Sobject>();
     List<sObject> ktTrkrsList = new List<Sobject>();
     List<sObject> sratTrkrsList = new List<Sobject>();
     List<sObject> opexTrkrsList = new List<Sobject>();
     List<sObject> recrTrkrsList = new List<Sobject>();
     List<sObject> techTrkrsList = new List<Sobject>();
     List<sObject> objList= new List<Sobject>();
     List<sObject> waveList =  new List<Sobject>();
     List<sObject> wmList = new List<sObject>();
     List<ID> mobIDs = new List<ID>(); 
     
    
     
     
     for(Mobilization_Plan__c  m: plansToDeacti){
            //system.debug('Mobilization.... '+m.name);
            //system.debug('Plan to deactivate is ' +m.name  + 'Id is' +m.id);
            if(m.Active__c){
            //system.debug('Active inside.. '+m.Active__c);
                mobIds.add(m.Id);
                m.IsTrackingOn__C = false;
                m.Active__c= false;
                
           }
        }
      
      objList =  [SELECT ID, Name, Active__c , Version__c ,
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c FROM Waves__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c FROM Wave_Process__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c FROM Wave_Module_Status__r LIMIT 5000),
                            (SELECT ID, Name , Active__c , Mobilization_Plan__c, Task_Order__c FROM BCP_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, 
                            Activity_Order__c FROM Budget_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, Task_Order__c 
                            FROM Contract_Legal_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, Section_Number__c 
                            FROM Journey_Management_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, Activity_Order__c 
                            FROM KT_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, Item_Order__c FROM OPEX_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, Activity_Order__c 
                            FROM Recruitment_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, Item_Order__c FROM SRAT_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, Deliverable_Order__c 
                            FROM Service_Management_Trackers__r LIMIT 5000),
                            (SELECT ID, Name , Active__c,  Mobilization_Plan__c, Activity_Order__c FROM Tech_WE_Trackers__r LIMIT 5000)
                                FROM Mobilization_Plan__c WHERE ID IN : mobIds  LIMIT 10000];  
         List<Mobilization_Team__c> mobTeams = [SELECT ID, Name , Active__c,  Wave__r.Mobilization_Plan__c 
         FROM Mobilization_Team__C WHERE Wave__r.Mobilization_Plan__c IN : mobIds LIMIT 10000]; 
                                    
                                    
        for(Integer k =0 ; k<objList.size(); k++){                            
            if(objList.get(k).getsObjects(UtilConstants.BCP_TRACKERS) <> null) {
                planTrkrsList.addAll(objList.get(k).getsObjects(UtilConstants.BCP_TRACKERS));
                }
            if(objList.get(k).getsObjects(UtilConstants.BUDGET_TRACKERS) <> null ){
                planTrkrsList.addAll(objList.get(k).getsObjects(UtilConstants.BUDGET_TRACKERS));
                }
            if(objList.get(k).getsObjects(UtilConstants.CONTRACT_LEGAL_TRACKERS) <> null) {
                planTrkrsList.addAll( objList.get(k).getsObjects(UtilConstants.CONTRACT_LEGAL_TRACKERS));
                }
            if(objList.get(k).getsObjects(UtilConstants.JOURNEY_MANAGEMENT_TRACKERS) <> null) { 
            planTrkrsList.addAll( objList.get(k).getsObjects(UtilConstants.JOURNEY_MANAGEMENT_TRACKERS));    }
            if(objList.get(k).getsObjects(UtilConstants.SERVICE_MANAGEMENT_TRACKERS) <> null) { 
            planTrkrsList.addAll( objList.get(k).getsObjects(UtilConstants.SERVICE_MANAGEMENT_TRACKERS));    }            
            if(objList.get(k).getsObjects(UtilConstants.KT_TRACKERS) <> null) {
                ktTrkrsList.addAll(   objList.get(k).getsObjects(UtilConstants.KT_TRACKERS));
                }
            if(objList.get(k).getsObjects(UtilConstants.OPEX_TRACKERS) <> null) {
                opexTrkrsList.addAll( objList.get(k).getsObjects(UtilConstants.OPEX_TRACKERS));
                }
            if(objList.get(k).getsObjects(UtilConstants.RECRUITMENT_TRACKERS) <> null) {
                recrTrkrsList.addAll( objList.get(k).getsObjects(UtilConstants.RECRUITMENT_TRACKERS));
                }
            if(objList.get(k).getsObjects(UtilConstants.SRAT_TRACKERS) <> null) {
                sratTrkrsList.addAll( objList.get(k).getsObjects(UtilConstants.SRAT_TRACKERS));
                }
            if(objList.get(k).getsObjects(UtilConstants.TECH_WE_TRACKERS) <> null) {
                techTrkrsList.addAll( objList.get(k).getsObjects(UtilConstants.TECH_WE_TRACKERS));
                }
            if(objList.get(k).getsObjects(UtilConstants.WAVES) <> null) {
                waveList.addAll(objList.get(k).getsObjects(UtilConstants.WAVES));
                }           
            if(objList.get(k).getsObjects(UtilConstants.WAVE_PROCESS) <> null) {
                waveList.addAll(objList.get(k).getsObjects(UtilConstants.WAVE_PROCESS));
                }
            //if(objList.get(k).getsObjects(UtilConstants.WAVE_MODULE_STATUS) <> null) {          wmList.addAll(objList.get(k).getsObjects(UtilConstants.WAVE_MODULE_STATUS));                 }
        }
        planTrkrsList.sort();
        waveTrkrsList.sort();
        try{    
               
            if(planTrkrsList.size() > 0){
                for(sObject s :planTrkrsList){
                    s.put(UtilConstants.IS_PLAN_ACTIVE_FIELD , false);
                    ///s.put(UtilConstants.ISTRACKINGON_FIELD, false);
                }
            }
            planTrkrsList.sort();
            Database.update(planTrkrsList); 
            
            
            if(ktTrkrsList.size() > 0){
                for(sObject s :ktTrkrsList){
                    s.put(UtilConstants.IS_PLAN_ACTIVE_FIELD , false);
                    //s.put(UtilConstants.ISTRACKINGON_FIELD, false);
                }
            }
            ktTrkrsList.sort();
            Database.update(ktTrkrsList);
            
            if(sratTrkrsList.size() > 0){
                for(sObject s :sratTrkrsList){
                    s.put(UtilConstants.IS_PLAN_ACTIVE_FIELD , false);
                    //s.put(UtilConstants.ISTRACKINGON_FIELD, false);
                }
            }
            sratTrkrsList.sort();
            Database.update(sratTrkrsList);
            
            if(opexTrkrsList.size() > 0){
                for(sObject s :opexTrkrsList){
                    s.put(UtilConstants.IS_PLAN_ACTIVE_FIELD , false);
                    //s.put(UtilConstants.ISTRACKINGON_FIELD, false);
                }
            }
            opexTrkrsList.sort();
            Database.update(opexTrkrsList);
            
            if(recrTrkrsList.size() > 0){
                for(sObject s :recrTrkrsList){
                    s.put(UtilConstants.IS_PLAN_ACTIVE_FIELD , false);
                    //s.put(UtilConstants.ISTRACKINGON_FIELD, false);
                }
            }
            recrTrkrsList.sort();
            Database.update(recrTrkrsList);
            
            if(techTrkrsList.size() > 0){
                for(sObject s :techTrkrsList){
                    s.put(UtilConstants.IS_PLAN_ACTIVE_FIELD , false);
                    //s.put(UtilConstants.ISTRACKINGON_FIELD, false);
                }
            }
            techTrkrsList.sort();
            Database.update(techTrkrsList);
 
            
            
            if(waveList.size() > 0){
                for(sObject wave : waveList){
                    //wave.put(UtilConstants.ISTRACKINGON_FIELD, false);
                    wave.put(UtilConstants.IS_PLAN_ACTIVE_FIELD, false);
                }
             }   
             
            waveList.sort();
            Database.update(waveList);
            //system.debug('Reaches here');
            

            
            for(Mobilization_Plan__c mob:plansToDeacti){
                //system.debug('Plan Name is'+mob.name+' Id is' +mob.id+' And checkbox is' +mob.Active__c);
            }
            Database.update(plansToDeacti);
            
        }   
    
        catch (Exception e){
            Database.rollback(deactivatingSavePoint);
            //system.debug('ERROR!!!! ' + e.getMessage());
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
            UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , UtilConstants.MANAGEMOBLILZATIONPLAN_CLASS , null, System.Logginglevel.ERROR);
            
         } 
        
    }
    
    /**
     * @description       This method is used to update mobolization duration on opportunity for reporting purpose.
     * @param             List<Deal__c> lstdeals
     * @return            Void
     * @throws            DML Exception
     * @author            Apoorva Sharma
     */  
     public static void updateMobDurationonOpportunity(List<Deal__c> lstdeals) {
     	map<id,datetime>dealCreatedDateMap=new map<id,datetime>();
     	map<id,date>dealStartTransitionDateMap=new map<id,date>();
     	map<id,date>dealEndTransitionDateMap=new map<id,date>();
     	set<id> opportunityids=new set<id>();
     	for(Deal__c dealRec:lstdeals){
     		opportunityids.add(dealRec.Opportunity__c);
     	}
     	for(Deal__c dealRec:[Select id,createddate,End_Date_of_Transition__c,Start_Date_of_Transition__c,Opportunity__c from Deal__c where Opportunity__c in:opportunityids limit 5000 ]){
     		if(dealRec.End_Date_of_Transition__c!=null && dealRec.Start_Date_of_Transition__c!=null && dealRec.Opportunity__c!=null){
     			if(dealCreatedDateMap.get(dealRec.Opportunity__c)==null){
     				dealCreatedDateMap.put(dealRec.Opportunity__c,dealRec.createddate);
     				dealEndTransitionDateMap.put(dealRec.Opportunity__c,dealRec.End_Date_of_Transition__c);
     				dealStartTransitionDateMap.put(dealRec.Opportunity__c,dealRec.Start_Date_of_Transition__c);
     			}else{
     				if(dealCreatedDateMap.get(dealRec.Opportunity__c)>dealRec.createddate){
     					dealCreatedDateMap.put(dealRec.Opportunity__c,dealRec.createddate);
     					dealEndTransitionDateMap.put(dealRec.Opportunity__c,dealRec.End_Date_of_Transition__c);
     					dealStartTransitionDateMap.put(dealRec.Opportunity__c,dealRec.Start_Date_of_Transition__c);
     				}
     			}
     		}
     	}
     	List<Opportunity>opportunityRecToUpdate=new list<Opportunity>();
     	if(!opportunityids.isEmpty()){
     		for(Opportunity oppRec:[Select id,Mobilization_Duration__c from opportunity where id in: opportunityids  limit 5000]){
     			if(dealStartTransitionDateMap.get(oppRec.id)!=null && dealEndTransitionDateMap.get(oppRec.id)!=null){
     				oppRec.Mobilization_Duration__c=UtilClassCountNoOFBusinessDays.getDiffBusinessDays(dealStartTransitionDateMap.get(oppRec.id),dealEndTransitionDateMap.get(oppRec.id));
     				opportunityRecToUpdate.add(oppRec);
     			}
     		}
     	}
     	system.debug('opportunityRecToUpdate----------------------------------------->'+opportunityRecToUpdate.size());
     	if(!opportunityRecToUpdate.isEmpty()){
     		try{
     			database.update(opportunityRecToUpdate,false);
     		}
     		catch(Exception e){
     			
     		}
     	}
     }
      
}