/*
* @Description : Webservice methods of this class gets executed from New Version button on Wave Plan Version.
*              This class will create clone of old wave plan version and mark as active.
*              This will inactivate entire tree of the old wave plan version.
*
* @Author : Accenture
*------------    -----------------        --------------    -------------------------------------------------------------*/
global class Mob_RebaselineHighLevelPlan {
    //Class Constants
    private static final String CLONE_WPV_SUFFIX = UTIL_Constants.ID_OLDWAVEVERSIONID;
    private static final String CLONE_CHILD_SUFFIX = UTIL_Constants.WAVE_PLAN_VERSION_ID_OLDWAVEVERSIONID;
    private static final String CLONE_WAVE_SUFFIX = UTIL_Constants.WAVE_PLANNING_DEAL_LOCATION_WAVE_PLAN_VERSION_ID_OLDWAVEVERSIONID;
    private static final String CLONE_WAVE_PLAN_SUFFIX = UTIL_Constants.DEAL_LOCATION_WAVE_PLAN_VERSION_OLDWAVEVERSIONID;
    private static final String CLONE_SRAT_SUFFIX = UTIL_Constants.SRAT_IN_LSTSRATIDS;
    private static final String CLONE_OPEX_SUFFIX = UTIL_Constants.OPEX_IN_LSTOPEXIDS;  
    private static final String CLONE_KT_SUFFIX = UTIL_Constants.DEAL_WAVE_DEAL_LOCATION_WAVE_PLAN_VERSION_OLDWAVEVERSIONID;
    private static final String CLONE_BS_SUFFIX = UTIL_Constants.BUDGET_SOLUTION_IN_LSTBUDGETSOLIDS; 
    private static final string CLASS_NAME = UTIL_Constants.MOB_REBASELINE_HIGH_LEVEL_PLAN;
    private static final string METHOD_NAME_RHLP = UTIL_Constants.REBASELINE_HIGH_LEVEL_PLAN;
    private static final string METHOD_NAME_DL = UTIL_Constants.CLONE_DEAL_LOCATION;
    private static final string METHOD_NAME_ACTIVE = UTIL_Constants.IS_WAVE_PLAN_VERSION_ACTIVE;
    private static final string METHOD_NAME_DEAL_WAVE = UTIL_Constants.CLONE_DEAL_WAVE;
    private static final string METHOD_NAME_WP = UTIL_Constants.CLONE_WAVE_PROCESS;
    private static final string METHOD_NAME_SRAT = UTIL_Constants.CLONE_SRAT;
    private static final string METHOD_NAME_OPEX = UTIL_Constants.CLONE_OPEX;
    private static final string METHOD_NAME_SM =UTIL_Constants.CLONE_SERVICE_MANAGEMENT; 
    private static final string METHOD_NAME_KT =UTIL_Constants.CLONE_KT_PLANNING; 
    private static final string METHOD_NAME_KT_TRACK =UTIL_Constants.CLONE_KT_TRACKER; 
    private static final string METHOD_NAME_RT =UTIL_Constants.CLONE_RECRUITMENT_TRACKING;  
    private static final string METHOD_NAME_RT_TRACK = UTIL_Constants.CLONE_RECRUITMENT_TRACKER;
    private static final string METHOD_NAME_CP = UTIL_Constants.CLONE_COMMERCIAL_PLANNING;
    private static final string METHOD_NAME_LI = UTIL_Constants.CLONE_CONTRACT_LEGAL_INFOSEC;
    private static final string METHOD_NAME_TT = UTIL_Constants.CLONE_TECH_TRACKER;
    private static final string METHOD_NAME_JP = UTIL_Constants.CLONE_JOURNEY_PLAN;
    private static final string METHOD_NAME_BCP = UTIL_Constants.CLONE_BCP_PLAN;
    private static final string METHOD_NAME_MOB_USER =UTIL_Constants.IS_AUTHENTIC_MOB_USER;
    
    private static List<Deal_Location__c> lstNewDealLocation = new List<Deal_Location__c>();
    private static List<Wave_Planning__c> lstNewWavePlanning = new List<Wave_Planning__c>();
    private static List<Wave_Process__c> lstNewWaveProcess = new List<Wave_Process__c>();
    
    /*
    * @Description :  Called by New version button on Wave Plan vesrion creates clone of entire wave plan version tree and 
    *                enables disables tracking and wave plan version
    * @Returns: Id of new wave plan version
    */
    webservice static String rebaselineHighLevelPlan(String oldWaveVersionId) {
        List<Wave_Plan_Version__c> lstWavePlanVersion = new List<Wave_Plan_Version__c>();
        Wave_Plan_Version__c clonedWPVersion;
        Decimal version=0;
        try {
            lstWavePlanVersion = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Wave_Plan_Version__c.sObjectType.getDescribe().getName(),
                                                    CLONE_WPV_SUFFIX));
            if(!lstWavePlanVersion.isEmpty() && lstWavePlanVersion[0].Active__c) {
                clonedWPVersion = lstWavePlanVersion.get(0).clone(false,true);
                clonedWPVersion.Display_tracking_message__c = null;
                clonedWPVersion.is_Clone__c = true;
                clonedWPVersion.active__c = true;
                clonedWPVersion.Cloned_From__c = oldWaveVersionId;
                clonedWPVersion.version__c = lstWavePlanVersion.get(0).version__c+1;
                version = lstWavePlanVersion.get(0).version__c+1;
                Database.insert(clonedWPVersion,false);
                lstWavePlanVersion[0].Active__c = false;
                lstWavePlanVersion[0].Display_tracking_message__c = null;
                Database.update(lstWavePlanVersion,false);
            }
            else {
                return null;
            }                                       
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_RHLP, null, 
                                                    System.Logginglevel.ERROR);
            return null;
        }
        return clonedWPVersion.Id;
        
    }
    /**
    * @MethodName:isWavePlanVersionActive 
    * @Description:Returns status Wave Plan Version Record 
    */ 
    webservice static boolean isWavePlanVersionActive(String oldWaveVersionId) {
        try {
            List<Wave_Plan_Version__c> lstWavePlanVersion = [select active__c from wave_plan_version__c where id= : oldWaveVersionId limit 1];
            return lstWavePlanVersion.get(0).active__c;
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_ACTIVE, null, 
                                                    System.Logginglevel.ERROR);
            return null;                                        
        }
    }
    /**
    * @MethodName:cloneDealLocation
    * @Description:Clone the Deal Location related which are all related to WPV records. 
    */ 
    webservice static void cloneDealLocation(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Deal_Location__c> lstDealLocation = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Deal_Location__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX));
            if(!lstDealLocation.isEmpty()) {
                List<Deal_Location__c> lstClonedDealLocation = new List<Deal_Location__c>();
                Deal_Location__c tempDealLoc;
                for(Deal_Location__c dealLoc : lstDealLocation) {
                    tempDealLoc = new Deal_Location__c();
                    tempDealLoc=dealLoc.clone(false,true);
                    tempDealLoc.Wave_Plan_Version__c=clonedWPVersion;
                    tempDealLoc.version__c = version + 1;
                    tempDealLoc.Cloned_From__c = dealLoc.id;
                    tempDealLoc.active__c = true;
                    lstClonedDealLocation.add(tempDealLoc);
                    dealLoc.active__c=false;
                }
                if(!lstClonedDealLocation.isEmpty()) {
                    Database.insert(lstClonedDealLocation,false);
                }
                Database.update(lstDealLocation,false);
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_DL, null, 
                                                    System.Logginglevel.ERROR);
        }                                       
    }
    /**
    * @MethodName: cloneDealWave
    * @Description:Clone the Deal Wave Records related WPV   
    */ 
    webservice static void cloneDealWave(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Wave_Planning__c> lstWavePlanning = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Wave_Planning__c.sObjectType.getDescribe().getName(),
                                                        CLONE_WAVE_PLAN_SUFFIX));                                   
            if(!lstWavePlanning.isEmpty()) {
                List<Wave_Planning__c> lstClonedWavePlan = new List<Wave_Planning__c> ();
                getNewDealLocationAndDealWave(clonedWPVersion);
                Wave_Planning__c WavePlan;
                 for(Wave_Planning__c tmpWavePlan : lstWavePlanning) {
                    for(Deal_Location__c tmpDealLoc : lstNewDealLocation) {
                        if(tmpWavePlan.Deal_Location__c == tmpDealLoc.Cloned_From__c) {
                            WavePlan = new Wave_Planning__c();
                            WavePlan = tmpWavePlan.clone(false,true);
                            WavePlan.Deal_Location__c = tmpDealLoc.id;
                            WavePlan.version__c= version + 1;
                            WavePlan.Cloned_From__c = tmpWavePlan.id;
                            WavePlan.active__c = true;
                            WavePlan.NewActive__c = tmpWavePlan.NewActive__c;                                
                            WavePlan.isEditVisible__c = true;
                            lstClonedWavePlan.add(WavePlan);
                            tmpWavePlan.active__c = false;
                        }
                    }
                 }
                 if(!lstClonedWavePlan.isEmpty()) {
                    Database.insert(lstClonedWavePlan,false);
                    Database.update(lstWavePlanning,false);
                 }
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_DEAL_WAVE, null, 
                                                    System.Logginglevel.ERROR);
        }                                   
    }
    /**
    * @MethodName:cloneWaveProcess
    * @Description:Clone the Wave Process related old WPV to new WPV
    */ 
    webservice static void cloneWaveProcess(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Wave_Process__c> lstWaveProcess = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Wave_Process__c.sObjectType.getDescribe().getName(),
                                                        CLONE_WAVE_SUFFIX));
            if(!lstWaveProcess.isEmpty()) {
                List<Wave_Process__c> lstClonedWaveProcess = new List<Wave_Process__c> ();
                getNewDealLocationAndDealWave(clonedWPVersion);
                Wave_Process__c WaveProcess;
                for(Wave_Process__c tmpWaveProcess : lstWaveProcess) {
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        if(tmpWaveProcess.Wave_Planning__c == tmpWavePlan.Cloned_From__c) {
                            WaveProcess = new Wave_Process__c();
                            WaveProcess = tmpWaveProcess.clone(false,true);
                            WaveProcess.Wave_Planning__c = tmpWavePlan.id;
                            WaveProcess.version__c= version + 1;
                            WaveProcess.Cloned_From__c = tmpWaveProcess.id;
                            WaveProcess.active__c = tmpWaveProcess.Active__c;
                            lstClonedWaveProcess.add(WaveProcess);
                        }
                    }
                }
                if(!lstClonedWaveProcess.isEmpty()) {
                    Database.insert(lstClonedWaveProcess,false);
                    Database.update(lstWaveProcess,false);
                }
            }                                           
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_WP, null, 
                                                    System.Logginglevel.ERROR);
        }                                           
    }
    /**
    * @Description:Clone the SRAT Wave related WPV   
    * @MethodName:cloneSRAT
    */ 
    webservice static void cloneSRAT(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<SRAT__c> lstSRAT = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(SRAT__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX));
            Set<Id> lstSRATIds = new Set<Id>();
            List<SRAT_Item_Master__c> lstActivity = new List<SRAT_Item_Master__c>(); 
            List<Id> lstActivityIds = new List<Id>(); 
            List<SRAT__c>lstClonedSRAT =  new List<SRAT__c>();
            Map<String,List<SRAT_User_Section_Question__c>> userSectionMap = new Map<String,List<SRAT_User_Section_Question__c>>();
            List<SRAT_User_Section_Question__c> tempUserSectionList;
            Map<String,List<SRAT_User_Sub_Section_Question__c>> userSubSectionMap = new Map<String,List<SRAT_User_Sub_Section_Question__c>>();
            List<SRAT_User_Sub_Section_Question__c> tempUserSubSectionList;
            Map<String,List<Factory_Specific_Technology__c>> factorySectionMap = new Map<String,List<Factory_Specific_Technology__c>>();
            List<Factory_Specific_Technology__c> tempFactorySectionList;
            SRAT__c tempSRAT;
            for(SRAT__c tmp:lstSRAT) {
                lstSRATIds.add(tmp.id);
            }   
            List<SRAT_User_Section_Question__c> lstSRAT_User_Qns = new List<SRAT_User_Section_Question__c>();
            List<SRAT_User_Sub_Section_Question__c> lstSRAT_User_Sub_Qns = new List<SRAT_User_Sub_Section_Question__c>();
            List<Factory_Specific_Technology__c> lstFactorySpecTech = new List<Factory_Specific_Technology__c>();
            SRAT_User_Section_Question__c tempSRAT_User_Qns;
            List<SRAT_User_Section_Question__c> tempSRAT_User_Qns_List = new List<SRAT_User_Section_Question__c>();
            SRAT_User_Sub_Section_Question__c tempSRAT_User_sub_Qns;
            List<SRAT_User_Sub_Section_Question__c> tempSRAT_User_sub_Qns_List =new List<SRAT_User_Sub_Section_Question__c>();
            Factory_Specific_Technology__c tempFactorySpecTech;
            List<Factory_Specific_Technology__c> tempFactorySpecTechList = new List<Factory_Specific_Technology__c>(); 
            getNewDealLocationAndDealWave(clonedWPVersion);
            boolean isInMaster=false;
            if(!lstSRAT.isEmpty()) {
                lstActivity = [select Item_Name__c from SRAT_Item_Master__c where Is_Active__c =: true];
                lstSRAT_User_Qns = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(SRAT_User_Section_Question__c.sObjectType.getDescribe().getName(),
                                                        CLONE_SRAT_SUFFIX));
                if(!lstSRAT_User_Qns.isEmpty()) {
                    for(SRAT_User_Section_Question__c userSection : lstSRAT_User_Qns) {
                        if(userSectionMap.containsKey(userSection.SRAT__c)) {
                            tempUserSectionList = userSectionMap.get(userSection.SRAT__c);
                        }
                        else {
                            tempUserSectionList = new List<SRAT_User_Section_Question__c>();
                        }
                        tempUserSectionList.add(userSection);
                        userSectionMap.put(userSection.SRAT__c,tempUserSectionList);
                    }
                }   
                system.debug('Section-------->'+userSectionMap);    
                lstSRAT_User_Sub_Qns = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(SRAT_User_Sub_Section_Question__c.sObjectType.getDescribe().getName(),
                                                        CLONE_SRAT_SUFFIX));
                system.debug('--lstSRAT_User_Sub_Qns-->'+lstSRAT_User_Sub_Qns);
                if(!lstSRAT_User_Sub_Qns.isEmpty()) {
                    for(SRAT_User_Sub_Section_Question__c userSubSection : lstSRAT_User_Sub_Qns) {
                        if(userSubSectionMap.containsKey(userSubSection.SRAT__c)) {
                            tempUserSubSectionList = userSubSectionMap.get(userSubSection.SRAT__c);
                        }
                        else {
                            tempUserSubSectionList = new List<SRAT_User_Sub_Section_Question__c>();
                        }
                        tempUserSubSectionList.add(userSubSection);
                        userSubSectionMap.put(userSubSection.SRAT__c,tempUserSubSectionList);
                    }
                }
                system.debug('Sub Section-------->'+userSubSectionMap);
                lstFactorySpecTech = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Factory_Specific_Technology__c.sObjectType.getDescribe().getName(),
                                                        CLONE_SRAT_SUFFIX));
                if(!lstFactorySpecTech.isEmpty()) {
                    for(Factory_Specific_Technology__c factSection : lstFactorySpecTech) {
                        if(factorySectionMap.containsKey(factSection.SRAT__c)) {
                            tempFactorySectionList = factorySectionMap.get(factSection.SRAT__c);
                        }
                        else {
                            tempFactorySectionList = new List<Factory_Specific_Technology__c>();
                        }
                        tempFactorySectionList.add(factSection);
                        factorySectionMap.put(factSection.SRAT__c,tempFactorySectionList);
                    }
                }
                for(SRAT__c srat : lstSRAT) {
                    isInMaster=false;
                    tempSRAT = new SRAT__c();
                    tempSRAT=srat.clone(false,true);
                    tempSRAT.Wave_Plan_Version__c=clonedWPVersion;
                    tempSRAT.version__c= version + 1;
                    tempSRAT.isEditVisible__c = true;                                        
                    tempSRAT.Cloned_From__c = srat.id;
                    for(Deal_location__c tmpDealLoc : lstNewDealLocation) {
                        if(srat.Deal_Location_lk__c == tmpDealLoc.Cloned_From__c) {
                            tempSRAT.Deal_Location_lk__c = tmpDealLoc.id;
                        }
                    }
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        if(srat.Wave_Plan_lk__c== tmpWavePlan.Cloned_From__c) {
                            tempSRAT.Wave_Plan_lk__c= tmpWavePlan.id;
                            tempSRAT.Location_Id_Wave_Id__c = ''+tmpWavePlan.Deal_Location__c+''+tmpWavePlan.id;
                            
                        }
                    }
                    for(SRAT_Item_Master__c tmpActivity : lstActivity ) {
                        if(srat.SRAT_Item_Master_Id__c== tmpActivity.id) {
                            tempSRAT.Item__c = tmpActivity.Item_Name__c;
                            lstActivityIds.add(srat.SRAT_Item_Master_Id__c);
                            isInMaster=true;
                            break;
                        }
                    }
                    if(isInMaster || srat.Is_From_Add_Section__c) {                              
                        lstClonedSRAT.add(tempSRAT);
                    }
                }
                if(!lstClonedSRAT.isEmpty()) {
                        Database.insert(lstClonedSRAT,false);
                }
            }
            /*for(SRAT__c tmpSRAT : lstClonedSRAT) {
                if(!lstSRAT_User_Qns.isEmpty()) {
                    for(SRAT_User_Section_Question__c SRAT_user_Qns : lstSRAT_User_Qns) {
                        if(SRAT_user_Qns.SRAT__c==tempSRAT.Cloned_From__c) {
                            tempSRAT_User_Qns = new SRAT_User_Section_Question__c();
                            tempSRAT_User_Qns = SRAT_user_Qns.clone(false,true);
                            tempSRAT_User_Qns.SRAT__c = tmpSRAT.id;
                            tempSRAT_User_Qns.version__c= version + 1;
                            tempSRAT_User_Qns_List.add(tempSRAT_User_Qns);
                        }
                    }
                } 
                    
                if(!lstSRAT_User_Sub_Qns.isEmpty()) {
                    for(SRAT_User_Sub_Section_Question__c SRAT_user_sub_Qns : lstSRAT_User_Sub_Qns) {
                        if(SRAT_user_sub_Qns.SRAT__c==tempSRAT.Cloned_From__c) {   
                            tempSRAT_User_sub_Qns  = new SRAT_User_Sub_Section_Question__c ();
                            tempSRAT_User_sub_Qns = SRAT_user_sub_Qns.clone(false,true);
                            tempSRAT_User_sub_Qns.SRAT__c = tmpSRAT.id;
                            tempSRAT_User_sub_Qns.version__c= version + 1; 
                            tempSRAT_User_sub_Qns_List.add(tempSRAT_User_sub_Qns);
                        }
                    }
                }
                if(!lstFactorySpecTech.isEmpty()){
                    for(Factory_Specific_Technology__c Fact_Spec_Tech : lstFactorySpecTech ) {
                        if(Fact_Spec_Tech.SRAT__c==tempSRAT.Cloned_From__c) {   
                            tempFactorySpecTech = new Factory_Specific_Technology__c();
                            tempFactorySpecTech = Fact_Spec_Tech.clone(false,true);
                            tempFactorySpecTech.SRAT__c = tmpSRAT.id;
                            tempFactorySpecTech.version__c= version + 1;
                            tempFactorySpecTechList.add(tempFactorySpecTech);
                        }
                    }
                }*/
            for(SRAT__c tmpSRAT : [Select  Cloned_From__c From SRAT__c Where Wave_Plan_Version__c = :clonedWPVersion]){
                if(userSectionMap.containsKey(tmpSRAT.Cloned_From__c)) {
                    tempUserSectionList = userSectionMap.get(tmpSRAT.Cloned_From__c);
                    for(SRAT_User_Section_Question__c SRAT_user_Qns : tempUserSectionList) {
                        tempSRAT_User_Qns = new SRAT_User_Section_Question__c();
                        tempSRAT_User_Qns = SRAT_user_Qns.clone(false,true);
                        tempSRAT_User_Qns.SRAT__c = tmpSRAT.id;
                        tempSRAT_User_Qns.version__c= version + 1;
                        tempSRAT_User_Qns_List.add(tempSRAT_User_Qns);
                    }
                }
                if(userSubSectionMap.containsKey(tmpSRAT.Cloned_From__c)) {
                    tempUserSubSectionList = userSubSectionMap.get(tmpSRAT.Cloned_From__c);
                    for(SRAT_User_Sub_Section_Question__c SRAT_user_sub_Qns: tempUserSubSectionList){
                        tempSRAT_User_sub_Qns  = new SRAT_User_Sub_Section_Question__c ();
                        tempSRAT_User_sub_Qns = SRAT_user_sub_Qns.clone(false,true);
                        tempSRAT_User_sub_Qns.SRAT__c = tmpSRAT.id;
                        tempSRAT_User_sub_Qns.version__c= version + 1; 
                        tempSRAT_User_sub_Qns_List.add(tempSRAT_User_sub_Qns);
                    }
                }
                if(factorySectionMap.containsKey(tmpSRAT.Cloned_From__c)) {
                    tempFactorySectionList = factorySectionMap.get(tmpSRAT.Cloned_From__c);
                    for(Factory_Specific_Technology__c Fact_Spec_Tech : tempFactorySectionList) {
                        tempFactorySpecTech = new Factory_Specific_Technology__c();
                        tempFactorySpecTech = Fact_Spec_Tech.clone(false,true);
                        tempFactorySpecTech.SRAT__c = tmpSRAT.id;
                        tempFactorySpecTech.version__c= version + 1;
                        tempFactorySpecTechList.add(tempFactorySpecTech);
                    }
                }
                
            }   
            if(!tempSRAT_User_Qns_List.isEmpty()) {
                Database.insert(tempSRAT_User_Qns_List,false);
            }
            if(!tempSRAT_User_sub_Qns_List.isEmpty()) {
                Database.insert(tempSRAT_User_sub_Qns_List,false);  
            }
            if(!tempFactorySpecTechList.isEmpty()) {
                Database.insert(tempFactorySpecTechList,false);
            }
            lstClonedSRAT =  new List<SRAT__c>();
            lstActivity = [select id, Item_Name__c,Days_Before_Go_Live_Date__c from SRAT_Item_Master__c where id not in :lstActivityIds AND Is_Active__c =: true limit 5000];
            if(!lstActivity.isEmpty()) {
                for(SRAT_Item_Master__c tmpActivity : lstActivity ) {
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        tempSRAT = new SRAT__c();
                        tempSRAT.Item__c = tmpActivity.Item_Name__c;
                        tempSRAT.Days_Before_Go_Live_Date__c = tmpActivity.Days_Before_Go_Live_Date__c;
                        tempSRAT.SRAT_Item_Master_Id__c = tmpActivity.id;
                        tempSRAT.Deal_Location_lk__c = tmpWavePlan.Deal_Location__c;
                        tempSRAT.Wave_Plan_lk__c = tmpWavePlan.id;
                        tempSRAT.Planned_Date__c=tmpWavePlan.GO_Live_Date_del__c.addDays(tmpActivity.Days_Before_Go_Live_Date__c.intValue());
                        tempSRAT.Wave_Plan_Version__c=clonedWPVersion;
                        tempSRAT.version__c= version + 1;
                        tempSRAT.Active__c= true;                                      
                        tempSRAT.isEditVisible__c = true;
                        lstClonedSRAT.add(tempSRAT);
                    }
                }
            }
            if(!lstClonedSRAT.isEmpty()) {
                Database.insert(lstClonedSRAT,false);   
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_SRAT, null, 
                                                    System.Logginglevel.ERROR);
        }                                   
    }
    /**
    * @Description:Clone the OPEX Wave related WPV   
    * @MethodName:cloneOPEX
    */ 
    webservice static void cloneOPEX(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<OPEX__c> lstOPEX =  Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(OPEX__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX));
            Set<Id> lstOPEXIds = new Set<Id>();
            List<OPEX_Item_Master__c> lstActivity = new List<OPEX_Item_Master__c> (); 
            List<Id> lstActivityIds = new List<Id>(); 
            List<OPEX__c>lstClonedOPEX =  new List<OPEX__c>(); 
            boolean isInMaster=false;
            OPEX__c tempOpex;
            for(OPEX__c tmp:lstOPEX) {
                lstOPEXIds.add(tmp.id);
            }
            getNewDealLocationAndDealWave(clonedWPVersion);
            List<OPEX_User_Section_Question__c> tempOpex_User_qnsList = new List<OPEX_User_Section_Question__c>();
            OPEX_User_Section_Question__c tempOpex_User_qns;
            List<OPEX_User_Section_Question__c> lstOPEX_User_Qns = new List<OPEX_User_Section_Question__c>();
            if(!lstOPEX.isEmpty())  {
                lstActivity = [select id, Item_Name__c from OPEX_Item_Master__c where Is_Active__c =: true limit 5000]; 
                lstOPEX_User_Qns = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(OPEX_User_Section_Question__c.sObjectType.getDescribe().getName(),
                                                        CLONE_OPEX_SUFFIX));
                for(OPEX__c opex : lstOPEX) {
                    tempOpex= new OPEX__c();
                    tempOpex=opex.clone(false,true);
                    tempOpex.Wave_Plan_Version__c = clonedWPVersion;
                    tempOpex.Cloned_From__c=opex.id;
                    tempOpex.version__c= version + 1;
                    tempOpex.isEditVisible__c = true;
                    for(Deal_location__c tmpDealLoc : lstNewDealLocation) {
                        if(opex.Deal_Location_lk__c == tmpDealLoc.Cloned_From__c) {
                            tempOpex.Deal_Location_lk__c = tmpDealLoc.id;
                        }
                    }
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        if(opex.Wave_Plan_lk__c== tmpWavePlan.Cloned_From__c) {
                            tempOpex.Wave_Plan_lk__c= tmpWavePlan.id;
                            tempOpex.Location_Id_Wave_Id__c = ''+tmpWavePlan.Deal_Location__c+''+tmpWavePlan.id;
                        }
                    }
                    for(Wave_Process__c tmpWaveProcess : lstNewWaveProcess) {
                        if(opex.Wave_Process__c== tmpWaveProcess.Cloned_From__c) {
                            tempOpex.Wave_Process__c= tmpWaveProcess.id;
                        }
                    }
                    for(OPEX_Item_Master__c tmpActivity : lstActivity ) {
                        if(opex.OPEX_Item_Master_Id__c== tmpActivity.id) {
                            tempOPEX.Item__c = tmpActivity.Item_Name__c;
                            lstActivityIds.add(opex.OPEX_Item_Master_Id__c);
                            isInMaster=true;
                            break;
                        }
                    }
                    if(isInMaster) {
                        lstClonedOPEX.add(tempOPEX);
                    }
                }
                if(!lstClonedOPEX.isEmpty()) {
                    Database.insert(lstClonedOPEX,false);
                }                                       
            }
            for(OPEX__c tmpOPEX : lstClonedOPEX) {
                if(!lstOPEX_User_Qns.isEmpty()) {
                    for(OPEX_User_Section_Question__c OPEX_user_Qns : lstOPEX_User_Qns) {
                         if(OPEX_user_Qns.OPEX__c== tempOPEX.Cloned_From__c) {
                            tempOpex_User_qns = new OPEX_User_Section_Question__c();
                            tempOPEX_User_Qns = OPEX_user_Qns.clone(false,true);
                            tempOPEX_User_Qns.OPEX__c = tmpOPEX.id;
                            tempOPEX_User_Qns.version__c= version + 1;
                            tempOpex_User_qnsList.add(tempOPEX_User_Qns);
                         }
                    }
                }
            }
            if(!tempOpex_User_qnsList.isEmpty()){
                Database.insert(tempOpex_User_qnsList,false);
            }
            lstClonedOPEX =  new List<OPEX__c>();
            lstActivity = [select id, Item_Name__c,Days_After_Go_Live_Date__c from OPEX_Item_Master__c where id not in :lstActivityIds AND Is_Active__c =: true];
            if(!lstActivity.isEmpty()) {
                for(OPEX_Item_Master__c tmpActivity : lstActivity ) {
                    for(Wave_Process__c tmpWaveProcess : lstNewWaveProcess) {
                        tempOpex= new OPEX__c();
                        tempOPEX.Item__c = tmpActivity.Item_Name__c;
                        tempOPEX.OPEX_Item_Master_Id__c = tmpActivity.id;
                        tempOPEX.Wave_Process__c=tmpWaveProcess.id;
                        tempOPEX.Deal_Location_lk__c = tmpWaveProcess.Wave_Planning__r.Deal_Location__c;
                        tempOPEX.Wave_Plan_lk__c = tmpWaveProcess.Wave_Planning__c;
                        tempOPEX.Planned_Date__c=tmpWaveProcess.Wave_Planning__r.GO_Live_Date_del__c.addDays(tmpActivity.Days_After_Go_Live_Date__c.intValue());
                        tempOPEX.Wave_Plan_Version__c=clonedWPVersion;
                        tempOPEX.version__c= version + 1;
                        tempOPEX.Active__c= tmpWaveProcess.Active__c;                                        
                        tempOPEX.isEditVisible__c = true;
                        lstClonedOPEX.add(tempOPEX);
                    }
                }
                if(!lstClonedOPEX.isEmpty()){
                    Database.insert(lstClonedOPEX);
                }
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_OPEX, null, 
                                                    System.Logginglevel.ERROR);
        }                                       
    }
    /**
    * @Description:Clone the Service Management records related WPV   
    * @MethodName:cloneServiceManagement
    */ 
    webservice static void cloneServiceManagement(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Service_Management__c> lstServicePlan = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Service_Management__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX));
            List<Service_Management_Task_Master__c> lstServiceDelivery = [select id,Task_Name__c,Task_Number__c,
                                                                          Service_Management_Phase__c,Service_Management_Phase__r.Phase_Name__c,
                                                                          Service_Management_Phase__r.Phase_Number__c 
                                                                          from Service_Management_Task_Master__c where Is_Active__c =: true ];
            List<Service_Management__c> lstClonedServicePlan = new List<Service_Management__c>();
            List<Id> lstActivityIds = new  List<Id>();
            Service_Management__c tempServicePlan = new Service_Management__c();
            Boolean isInMaster = false;
            if(!lstServicePlan.isEmpty()) {
                for(Service_Management__c servicePlan : lstServicePlan) {
                    isInMaster = false;
                    tempServicePlan = new Service_Management__c();
                    tempServicePlan = servicePlan.clone(false,true);
                    tempServicePlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempServicePlan.version__c = version + 1;
                    tempServicePlan.isEditVisible__c= true;                                       
                    tempServicePlan.Cloned_From__c = servicePlan.id;
                    for( Service_Management_Task_Master__c tmpActivity : lstServiceDelivery){
                        if(servicePlan.Task_id__c== tmpActivity.id) {
                            tempServicePlan.Task_Name__c= tmpActivity.Task_Name__c;
                            tempServicePlan.Task_Number__c = tmpActivity.Task_Number__c;
                            tempServicePlan.Phase_Name__c = tmpActivity.Service_Management_Phase__r.Phase_Name__c;
                            tempServicePlan.Phase_Number__c = tmpActivity.Service_Management_Phase__r.Phase_Number__c;
                            lstActivityIds.add(servicePlan.Task_id__c);                        
                            isInMaster = true;
                            break;
                        }
                    }
                    if(servicePlan.Is_From_Add_Section__c || isInMaster) {
                        lstClonedservicePlan.add(tempServicePlan);
                    }
                }
            } 
            if(!lstActivityIds.isEmpty()) {
                lstServiceDelivery = [select id,Task_Name__c,Task_Number__c,Service_Management_Phase__c,
                               Service_Management_Phase__r.Phase_Name__c,Service_Management_Phase__r.Phase_Number__c
                               from Service_Management_Task_Master__c 
                               where id not in :lstActivityIds AND Is_Active__c =: true limit 5000];
                if(!lstServiceDelivery.isEmpty()) {
                    for(Service_Management_Task_Master__c tmpActivity : lstServiceDelivery) {
                        tempServicePlan= new Service_Management__c();
                        tempServicePlan.Wave_Plan_Version__c = clonedWPVersion;
                        tempServicePlan.version__c = version + 1;
                        tempServicePlan.Task_Name__c= tmpActivity.Task_Name__c;
                        tempServicePlan.Task_Number__c = tmpActivity.Task_Number__c;
                        tempServicePlan.Phase_Name__c = tmpActivity.Service_Management_Phase__r.Phase_Name__c;
                        tempServicePlan.Phase_Number__c = tmpActivity.Service_Management_Phase__r.Phase_Number__c;
                        tempServicePlan.Task_id__c = tmpActivity.id;
                        tempServicePlan.Phase_id__c = tmpActivity.Service_Management_Phase__c;
                        tempServicePlan.isEditVisible__c=true;
                        lstClonedservicePlan.add(tempServicePlan);
                    }
                }               
            }
            if(!lstClonedservicePlan.isEmpty()) {
                Database.insert(lstClonedservicePlan,false);   
            }  
        } 
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_SM, null, 
                                                    System.Logginglevel.ERROR);
        }                                                                                               
    }
    /**
    * @Description:Clone the KT Planning  related WPV   
    * @MethodName:cloneKTPlanning
    */ 
    webservice static void cloneKTPlanning(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<KT_Planning__c> lstKTPlanning =  Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(KT_Planning__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX));
            getNewDealLocationAndDealWave(clonedWPVersion);
            List<KT_Planning_Activity_Master__c> lstActivity = [select id, name from KT_Planning_Activity_Master__c where Is_Active__c =: true]; 
            List<KT_Planning__c>lstClonedKTPlanning =  new List<KT_Planning__c>();
            List<Id> lstActivityIds = new  List<Id>();
            KT_Planning__c tempKtPlan = new KT_Planning__c();
            Boolean isInMaster = false;
            if(!lstKTPlanning.isEmpty()){
                for(KT_Planning__c ktPlan : lstKTPlanning) {
                    isInMaster = false;
                    tempKtPlan=ktPlan.clone(false,true);
                    tempKtPlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempKtPlan.version__c = version + 1;
                    tempKtPlan.isEditVisible__c= true;                                      
                    for(Deal_location__c tmpDealLoc : lstNewDealLocation) {
                        if(ktPlan.Deal_Location_lk__c == tmpDealLoc.Cloned_From__c) {
                            tempKtPlan.Deal_Location_lk__c = tmpDealLoc.id;
                        }
                    }                    
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        if(ktPlan.Wave_Plan_lk__c== tmpWavePlan.Cloned_From__c) {
                            tempKtPlan.Wave_Plan_lk__c= tmpWavePlan.id;
                            tempKtPlan.Location_Id_Wave_Id__c = ''+tmpWavePlan.Deal_Location__c+''+tmpWavePlan.id;
                        }
                    }
                    for(KT_Planning_Activity_Master__c tmpActivity : lstActivity ) {
                        if(ktPlan.KT_Planning_Activity_Master_ID__c == tmpActivity.id) {
                            tempktPlan.Activity__c = tmpActivity.name;
                            lstActivityIds.add(ktPlan.KT_Planning_Activity_Master_ID__c);
                            isInMaster = true;
                            break;
                        }
                    } 
                                    
                    if(ktPlan.Is_From_Add_Section__c|| isInMaster){
                        lstClonedKTPlanning.add(tempKtPlan);
                    }
                }
            }
            lstActivity = [select id, name from KT_Planning_Activity_Master__c where id not in :lstActivityIds AND Is_Active__c =: true limit 5000];
            if(!lstActivity.isEmpty()) {
                for(KT_Planning_Activity_Master__c tmpActivity : lstActivity) {
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        tempktPlan= new KT_Planning__c ();
                        tempKtPlan.Activity__c = tmpActivity.name;
                        tempKtPlan.KT_Planning_Activity_Master_ID__c = tmpActivity.id;
                        tempKtPlan.Deal_Location_lk__c = tmpWavePlan.Deal_Location__c;
                        tempKtPlan.Wave_Plan_lk__c = tmpWavePlan.id;
                        tempKtPlan.Wave_Plan_Version__c = clonedWPVersion;
                        tempKtPlan.version__c= version + 1;
                        tempKtPlan.isEditVisible__c=true;
                        lstClonedKTPlanning.add(tempKtPlan);
                    }
                }
            }
            if(!lstClonedKTPlanning.isEmpty()) {
                Database.insert(lstClonedKTPlanning,false);
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_KT, null, 
                                                    System.Logginglevel.ERROR);
        }                                       
    }
    /**
    * @Description:Clone the KT Tracker related WPV   
    * @MethodName:cloneKTTracker
    */ 
    webservice static void cloneKTTracker(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<KT_Tracker__c> lstKTTracker = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(KT_Tracker__c.sObjectType.getDescribe().getName(),
                                                        CLONE_KT_SUFFIX));
            List<DTP_Tracker__c> lstDTPTracker = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(DTP_Tracker__c.sObjectType.getDescribe().getName(),
                                                        CLONE_KT_SUFFIX));
            List<Tracking_KT__c> lstTrackKT  =  Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Tracking_KT__c.sObjectType.getDescribe().getName(),
                                                        CLONE_KT_SUFFIX));  
            getNewDealLocationAndDealWave(clonedWPVersion); 
            if(!lstKTTracker.isEmpty()){
                List<KT_Tracker__c> lstClonedKTTrack = new List<KT_Tracker__c>();
                KT_Tracker__c tempKTTrack = new KT_Tracker__c();
                for(KT_Tracker__c KTTrack : lstKTTracker){
                    for(Wave_Planning__c tmpWave : lstNewWavePlanning){
                        if(KTTrack.Deal_Wave__c == tmpWave.Cloned_From__c){
                            tempKTTrack = new KT_Tracker__c();
                            tempKTTrack = KTTrack.clone(false,true);
                            tempKTTrack.Deal_Wave__c = tmpWave.id;
                            tempKTTrack.version__c= version + 1;
                            tempKTTrack.Cloned_From__c = KTTrack.id;
                            tempKTTrack.active__c = true;
                            lstClonedKTTrack.add(tempKTTrack);
                            KTTrack.active__c = false;
                        }
                    }
                }
                if(!lstClonedKTTrack.isEmpty()){
                    Database.insert(lstClonedKTTrack,false);
                    Database.update(lstKTTracker,false);
                }
            }
            if(!lstDTPTracker.isEmpty()) {
                List<DTP_Tracker__c> lstClonedDTPTrack = new List<DTP_Tracker__c>();
                DTP_Tracker__c tempDTPTrack = new DTP_Tracker__c();
                for(DTP_Tracker__c DTPTrack : lstDTPTracker) {
                    for(Wave_Planning__c tmpWave : lstNewWavePlanning ){
                        if(DTPTrack.Deal_Wave__c == tmpWave.Cloned_From__c){
                            tempDTPTrack = new DTP_Tracker__c();
                            tempDTPTrack = DTPTrack.clone(false,true);
                            tempDTPTrack.Deal_Wave__c = tmpWave.id;
                            tempDTPTrack.version__c= version + 1;
                            tempDTPTrack.Cloned_From__c = DTPTrack.id;
                            tempDTPTrack.active__c = true;
                            lstClonedDTPTrack.add(tempDTPTrack);
                            DTPTrack.active__c = false;
                        }
                    }
                }
                if(!lstClonedDTPTrack.isEmpty()) {
                    Database.insert(lstClonedDTPTrack,false);
                    Database.update(lstDTPTracker,false);
                }
            }
            if(!lstTrackKT.isEmpty()) {
                List<Tracking_KT__c> lstClonedTrackKT = new List<Tracking_KT__c>();
                Tracking_KT__c tempTrackKT = new Tracking_KT__c();
                for(Tracking_KT__c TrackKT : lstTrackKT){
                    for(Wave_Planning__c tmpWave : lstNewWavePlanning ){
                        if(TrackKT.Deal_Wave__c == tmpWave.Cloned_From__c){
                            tempTrackKT = new Tracking_KT__c();
                            tempTrackKT = TrackKT.clone(false,true);
                            tempTrackKT.Deal_Wave__c = tmpWave.id;
                            tempTrackKT.version__c= version + 1;
                            tempTrackKT.Cloned_From__c = TrackKT.id;
                            tempTrackKT.active__c = true;
                            lstClonedTrackKT.add(tempTrackKT);
                            TrackKT.active__c = false;
                        }
                    }
                }
                if(!lstClonedTrackKT.isEmpty()){
                    Database.insert(lstClonedTrackKT,false);
                    Database.update(lstTrackKT,false);
                }
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_KT_TRACK, null, 
                                                    System.Logginglevel.ERROR);
        }                                                                                                                       
    }
    /**
    * @Description:Clone the Recruitement Tracking records related WPV   
    * @MethodName:cloneRecruitmentTracking
    */ 
    webservice static void cloneRecruitmentTracking(String oldWaveVersionId, String clonedWPVersion, integer version){
        try {
            List<Recruitment_Tracking__c> lstRecruitmentTracking = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Recruitment_Tracking__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX)); 
            system.debug('lstRecruitmentTracking -------->'+lstRecruitmentTracking );                                            
            getNewDealLocationAndDealWave(clonedWPVersion);
            List<Activity_master__c> lstActivity = [select id, name from activity_master__c where Is_Active__c =: true limit 5000];
            List<Recruitment_Tracking__c>lstClonedRecruitmentTracking =  new List<Recruitment_Tracking__c>();
            List<Id> lstActivityIds = new  List<Id>();
            Recruitment_Tracking__c tempRecruit = new Recruitment_Tracking__c();
            Boolean isInMaster = false;
            if(!lstRecruitmentTracking.isEmpty()) {
                for(Recruitment_Tracking__c recruit : lstRecruitmentTracking) {
                    isInMaster = false;
                    tempRecruit= recruit.clone(false,true);
                    tempRecruit.Wave_Plan_Version__c = clonedWPVersion;
                    tempRecruit.version__c= version + 1;
                    tempRecruit.isEditVisible__c= true; 
                    for(Deal_location__c tmpDealLoc : lstNewDealLocation) {
                        if(recruit.Deal_Location_lk__c == tmpDealLoc.Cloned_From__c){
                            tempRecruit.Deal_Location_lk__c = tmpDealLoc.id;
                        }
                    }
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        if(recruit.Wave_Plan_lk__c== tmpWavePlan.Cloned_From__c){
                            tempRecruit.Wave_Plan_lk__c= tmpWavePlan.id;
                            tempRecruit.Location_Id_Wave_Id__c = ''+tmpWavePlan.Deal_Location__c+''+tmpWavePlan.id;
                        }
                    }
                    for(Activity_master__c tmpActivity : lstActivity ) {
                        if(recruit.Activity_Master_ID__c == tmpActivity.id){
                            tempRecruit.Activity__c = tmpActivity.name;
                            lstActivityIds.add(recruit.Activity_Master_ID__c);
                            isInMaster = true;
                            break;
                        }
                    }
                    if(recruit.Is_From_Add_Section__c|| isInMaster) {
                        lstClonedRecruitmentTracking.add(tempRecruit);
                    }
                }
            }
            lstActivity = [select id, name from activity_master__c where id not in :lstActivityIds AND Is_Active__c =: true limit 5000];
            if(!lstActivity.isEmpty()) {
                for(activity_master__c tmpActivity : lstActivity ) {
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        tempRecruit= new Recruitment_Tracking__c ();
                        tempRecruit.Activity__c = tmpActivity.name;
                        tempRecruit.Activity_Master_ID__c = tmpActivity.id;
                        tempRecruit.Deal_Location_lk__c = tmpWavePlan.Deal_Location__c;
                        tempRecruit.Wave_Plan_lk__c = tmpWavePlan.id;
                        tempRecruit.Wave_Plan_Version__c = clonedWPVersion;
                        tempRecruit.version__c= version + 1;
                        tempRecruit.isEditVisible__c = true;
                        lstClonedRecruitmentTracking.add(tempRecruit);
                    }
                }
            }
            if(!lstClonedRecruitmentTracking.isEmpty()) {
                Database.insert(lstClonedRecruitmentTracking,false);
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_RT, null, 
                                                    System.Logginglevel.ERROR);
        }                                   
    }
    /**
    * @Description:Clone the Recruitment Tracker related WPV   
    * @MethodName:cloneRecruitmentTracker
    */ 
    webservice static void cloneRecruitmentTracker(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Recruitment_Tracker__c> lstRecruitTracker = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Recruitment_Tracker__c.sObjectType.getDescribe().getName(),
                                                        CLONE_WAVE_PLAN_SUFFIX)); 
            getNewDealLocationAndDealWave(clonedWPVersion);
            if(!lstRecruitTracker.isEmpty()) {
                List<Recruitment_Tracker__c> lstClonedRecruitTrack = new List<Recruitment_Tracker__c>();
                Recruitment_Tracker__c tempRecruitTrack = new Recruitment_Tracker__c();
                for(Recruitment_Tracker__c recruitTrack : lstRecruitTracker) {
                    for(Deal_Location__c tmpDealLoc : lstNewDealLocation) {
                        if(recruitTrack.Deal_Location__c == tmpDealLoc.Cloned_From__c) {
                            tempRecruitTrack = new Recruitment_Tracker__c();
                            tempRecruitTrack = recruitTrack.clone(false,true);
                            tempRecruitTrack.Deal_Location__c = tmpDealLoc.id;
                            tempRecruitTrack.version__c= version + 1;
                            tempRecruitTrack.Cloned_From__c = recruitTrack.id;
                            tempRecruitTrack.active__c = true;
                            lstClonedRecruitTrack.add(tempRecruitTrack);
                            recruitTrack.active__c = false;
                        }
                    }
                }
                if(!lstClonedRecruitTrack.isEmpty()) {
                    Database.insert(lstClonedRecruitTrack,false);
                    Database.update(lstRecruitTracker,false);
                }
            }
            List<Tracking_Recruitment__c> lstTrackingRecruit =  Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Tracking_Recruitment__c.sObjectType.getDescribe().getName(),
                                                        CLONE_WAVE_PLAN_SUFFIX)); 
            if(!lstTrackingRecruit.isEmpty()) {
                List<Tracking_Recruitment__c> lstClonedRecruitTrack = new List<Tracking_Recruitment__c>();
                Tracking_Recruitment__c tempRecruitTrack = new Tracking_Recruitment__c();
                for(Tracking_Recruitment__c recruitTrack : lstTrackingRecruit) {
                    for(Deal_Location__c tmpDealLoc : lstNewDealLocation) {
                        if(recruitTrack.Deal_Location__c == tmpDealLoc.Cloned_From__c) {
                            tempRecruitTrack = new Tracking_Recruitment__c();
                            tempRecruitTrack = recruitTrack.clone(false,true);
                            tempRecruitTrack.Deal_Location__c = tmpDealLoc.id;
                            tempRecruitTrack.version__c= version + 1;
                            tempRecruitTrack.Cloned_From__c = recruitTrack.id;
                            tempRecruitTrack.active__c = true;
                            lstClonedRecruitTrack.add(tempRecruitTrack);
                            recruitTrack.active__c = false;
                        }
                    }
                }
                if(!lstClonedRecruitTrack.isEmpty()) {
                    Database.insert(lstClonedRecruitTrack,false);
                    Database.update(lstTrackingRecruit,false);
                }
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_RT_TRACK, null, 
                                                    System.Logginglevel.ERROR);
        }                                                                               
    }
    /**
    * @Description:Clone the Commercial Planning related WPV   
    * @MethodName:cloneCommercialPlanning
    */ 
    webservice static void cloneCommercialPlanning(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Commercial_Plan_Activity_Master__c> lstActivity = [select id, Activity_name__c from Commercial_Plan_Activity_Master__c where Is_Active__c =: true];
            List<Id> lstActivityIds = new  List<Id>(); 
            List<Commercial_Planning__c> lstCommercialPlanning = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Commercial_Planning__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX)); 
            getNewDealLocationAndDealWave(clonedWPVersion);
            List<Commercial_Planning__c>lstClonedCommercialPlanning =  new List<Commercial_Planning__c>();
            Commercial_Planning__c tempComPlan = new Commercial_Planning__c();
            Boolean isInMaster = false;
            if(!lstCommercialPlanning.isEmpty()) {
                for(Commercial_Planning__c comPlan : lstCommercialPlanning) {
                    isInMaster = false;
                    tempComPlan = comPlan.clone(false,true);
                    tempComPlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempComPlan.version__c= version + 1;
                    tempComPlan.Cloned_From__c = comPlan.id;
                    tempComPlan.isEditVisible__c = true;
                    for(Commercial_Plan_Activity_Master__c tmpActivity : lstActivity ){
                        if(comPlan.Commercial_Plan_Activity_Master_Id__c == tmpActivity.id){
                            tempComPlan.Activity__c = tmpActivity.Activity_name__c;
                            lstActivityIds.add(comPlan.Commercial_Plan_Activity_Master_Id__c);
                            isInMaster = true;
                            break;
                        }
                    }
                    if(comPlan.Is_From_Add_Section__c || isInMaster) {
                        lstClonedCommercialPlanning.add(tempComPlan);
                    }
                }
            }
            lstActivity = [select id, Activity_name__c from Commercial_Plan_Activity_Master__c where id not in :lstActivityIds limit 5000];
            if(!lstActivity.isEmpty()) {
                for(Commercial_Plan_Activity_Master__c tmpActivity : lstActivity) {
                    tempComPlan = new Commercial_Planning__c();
                        tempComPlan.Activity__c = tmpActivity.Activity_name__c ;
                        tempComPlan.Commercial_Plan_Activity_Master_Id__c = tmpActivity.id;
                        tempComPlan.Wave_Plan_Version__c = clonedWPVersion;
                        tempComPlan.version__c= version + 1;
                        tempComPlan.isEditVisible__c = true;
                        lstClonedCommercialPlanning.add(tempComPlan );
                }
            }
            if(!lstClonedCommercialPlanning.isEmpty()) {
                Database.insert(lstClonedCommercialPlanning,false);
            }   
            List<Budget_Solution__c>  lstBudgetSol = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Budget_Solution__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX)); 
            List<Id> lstBudgetSolIds = new List<Id>();
            List<Budget_Solution__c>lstClonedBudgetSol = new List<Budget_Solution__c>();
            if(!lstBudgetSol.isEmpty()) {
                Budget_Solution__c tempBudget = new Budget_Solution__c();
                for(Budget_Solution__c BudgetSol : lstBudgetSol) {
                    tempBudget = new Budget_Solution__c();
                    tempBudget = BudgetSol.clone(false,true);
                    tempBudget.Wave_Plan_Version__c = clonedWPVersion;
                    tempBudget.version__c= version + 1;
                    tempBudget.Cloned_From__c = BudgetSol.id;
                    tempBudget.isSubmitted__c = false;
                    lstClonedBudgetSol.add(tempBudget);
                    lstBudgetSolIds.add(BudgetSol.id);
                }
                if(!lstClonedBudgetSol.isEmpty()) {
                    Database.insert(lstClonedBudgetSol,false);
                }
                List<Budget_Reforecast__c>  lstBudgetReforecast = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Budget_Reforecast__c.sObjectType.getDescribe().getName(),
                                                        CLONE_BS_SUFFIX)); 
                if(!lstBudgetReforecast.isEmpty()){
                    List<Budget_Reforecast__c> lstClonedBudgetReforecast =  new List<Budget_Reforecast__c>();
                    Budget_Reforecast__c tempBudgetR = new Budget_Reforecast__c();
                    for(Budget_Reforecast__c BudgetReforecast : lstBudgetReforecast) {
                        tempBudgetR = BudgetReforecast.clone(false,true);
                        for(Budget_Solution__c BudgetSol : lstClonedBudgetSol) {
                            if(BudgetSol.Cloned_From__c == BudgetReforecast.Budget_Solution__c) {
                                tempBudgetR.Budget_Solution__c = BudgetSol.id;
                            }
                        }
                        tempBudgetR.Reforecast_Record__c = false;
                        tempBudgetR.Actuals_Record__c = false;
                        tempBudgetR.Varience_Record__c = false;
                        tempBudgetR.version__c= version + 1;
                        tempBudgetR.Cloned_From__c = BudgetReforecast.id;
                        tempBudgetR.isSubmitted__c = false;
                        tempBudgetR.isActualSubmitted__c = false;
                        lstClonedBudgetReforecast.add(tempBudgetR);
                    }
                    if(!lstClonedBudgetReforecast.isEmpty()) {
                        Database.insert(lstClonedBudgetReforecast,false);
                    }
                }                                       
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_CP, null, 
                                                    System.Logginglevel.ERROR);
        }                                                                                   
    }
    /**
    * @Description:cloneContractLegalInfosec  records related WPV
    * @MethodName:cloneContractLegalInfosec
    */ 
    webservice static void cloneContractLegalInfosec(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Contract_Legal_Infosec__c> lstContractLegalInfosec = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Contract_Legal_Infosec__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX)); 
            List<Contract_Legal_Infosec_Task_Master__c> lstServiceDelivery = [select id,Task_Name__c,Task_Number__c,
                                                                          Contract_Legal_Infosec_Section_Master__c,Contract_Legal_Infosec_Section_Master__r.Section_Name__c,
                                                                          Contract_Legal_Infosec_Section_Master__r.Section_Number__c 
                                                                          from Contract_Legal_Infosec_Task_Master__c where Is_Active__c =: true limit 5000];
            List<Contract_Legal_Infosec__c> lstClonedServicePlan = new List<Contract_Legal_Infosec__c>();
            List<Id> lstActivityIds = new  List<Id>();
            Contract_Legal_Infosec__c tempServicePlan = new Contract_Legal_Infosec__c();
            if(!lstContractLegalInfosec.isEmpty()) {
                Boolean isInMaster = false;
                for(Contract_Legal_Infosec__c servicePlan : lstContractLegalInfosec) {
                    isInMaster = false;
                    tempServicePlan = servicePlan.clone(false,true);
                    tempServicePlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempServicePlan.version__c = version + 1;
                    tempServicePlan.isEditVisible__c = true;   
                    tempServicePlan.Cloned_From__c = servicePlan.id;
                    for( Contract_Legal_Infosec_Task_Master__c tmpActivity : lstServiceDelivery){
                        if(servicePlan.Task_Master_ID__c== tmpActivity.id) {
                            tempServicePlan.Task_Name__c= tmpActivity.Task_Name__c;
                            tempServicePlan.Task_Number__c = tmpActivity.Task_Number__c;
                            tempServicePlan.Section_Name__c = tmpActivity.Contract_Legal_Infosec_Section_Master__r.Section_Name__c;
                            tempServicePlan.Section_Number__c = tmpActivity.Contract_Legal_Infosec_Section_Master__r.Section_Number__c;
                            lstActivityIds.add(servicePlan.Task_Master_ID__c);                        
                            isInMaster = true;
                            break;
                        }
                    }
                    if(servicePlan.Is_From_Add_Section__c|| isInMaster) {
                        lstClonedservicePlan.add(tempServicePlan);
                    }
                }
            }  
            if(!lstActivityIds.isempty()) {
                lstServiceDelivery = [select id,Task_Name__c,Task_Number__c,Contract_Legal_Infosec_Section_Master__c,
                                        Contract_Legal_Infosec_Section_Master__r.Section_Name__c,
                                        Contract_Legal_Infosec_Section_Master__r.Section_Number__c 
                                        from Contract_Legal_Infosec_Task_Master__c
                                        where id not in :lstActivityIds AND Is_Active__c =: true limit 5000];
            }                           
            if(!lstServiceDelivery.isEmpty()) {
                for(Contract_Legal_Infosec_Task_Master__c tmpActivity : lstServiceDelivery ){
                    tempServicePlan= new Contract_Legal_Infosec__c();
                    tempServicePlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempServicePlan.version__c = version + 1;
                    tempServicePlan.Task_Name__c= tmpActivity.Task_Name__c;
                    tempServicePlan.Task_Number__c = tmpActivity.Task_Number__c;
                    tempServicePlan.Section_Name__c = tmpActivity.Contract_Legal_Infosec_Section_Master__r.Section_Name__c;
                    tempServicePlan.Section_Number__c = tmpActivity.Contract_Legal_Infosec_Section_Master__r.Section_Number__c;
                    tempServicePlan.Task_Master_ID__c= tmpActivity.id;
                    tempServicePlan.Section_Master_ID__c= tmpActivity.Contract_Legal_Infosec_Section_Master__c;
                    tempServicePlan.isEditVisible__c = true;
                    lstClonedservicePlan.add(tempServicePlan);
                }
            }
            if(!lstClonedservicePlan.isEmpty()) {
                Database.insert(lstClonedservicePlan,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_LI, null, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /**
    * @Description:Clone the Tech Assesment Records related WPV 
    * @MethodName: cloneTechAssessment
    */ 
     webservice static void cloneTechAssessment(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Tech_Assessment__c> lstTechAssessment = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Tech_Assessment__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX)); 

            getNewDealLocationAndDealWave(clonedWPVersion);
            List<Tech_Assessment_Activity_Master__c > lstActivity = [select id, name from Tech_Assessment_Activity_Master__c where Is_Active__c =: true ];
            List<Tech_Assessment__c> lstClonedTechAssessment =  new List<Tech_Assessment__c>();
            Tech_Assessment__c tempTechAssess= new Tech_Assessment__c();
            List<Id> lstActivityIds = new  List<Id>();
            if(!lstTechAssessment.isEmpty()) {
                Boolean isInMaster = false;
                for(Tech_Assessment__c TechAssess : lstTechAssessment){
                    isInMaster = false;
                    tempTechAssess = TechAssess.clone(false,true);
                    tempTechAssess.Wave_Plan_Version__c = clonedWPVersion;
                    tempTechAssess.version__c= version + 1;
                    tempTechAssess.isEditVisible__c = true; 
                    for(Deal_location__c tmpDealLoc : lstNewDealLocation) {
                        if(TechAssess.Deal_Location_lk__c == tmpDealLoc.Cloned_From__c) {
                            tempTechAssess.Deal_Location_lk__c = tmpDealLoc.id;
                        }
                    }                    
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        if(TechAssess.Wave_Plan_lk__c== tmpWavePlan.Cloned_From__c) {
                            tempTechAssess.Wave_Plan_lk__c= tmpWavePlan.id;
                            tempTechAssess.Location_Id_Wave_Id__c = ''+tmpWavePlan.Deal_Location__c+''+tmpWavePlan.id;
                        }
                    }                     
                    for(Tech_Assessment_Activity_Master__c tmpActivity : lstActivity ){
                        if(TechAssess.Tech_Assessment_Activity_Master_ID__c == tmpActivity.id){
                            tempTechAssess.Activity__c = tmpActivity.name;
                            lstActivityIds.add(TechAssess.Tech_Assessment_Activity_Master_ID__c);
                            isInMaster = true;
                            break;
                        }
                    }
                    if(TechAssess.Is_From_Add_Section__c|| isInMaster) {
                        lstClonedTechAssessment.add(tempTechAssess);
                    }
                }
            }
            lstActivity = [select id, name from Tech_Assessment_activity_master__c where id not in :lstActivityIds AND Is_Active__c =: true];
            if(!lstActivity.isEmpty()) {
                for(Tech_Assessment_activity_master__c tmpActivity : lstActivity ){
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning){
                        tempTechAssess= new Tech_Assessment__c ();
                        tempTechAssess.Activity__c = tmpActivity.name;
                        tempTechAssess.Tech_Assessment_Activity_Master_ID__c = tmpActivity.id;
                        tempTechAssess.Deal_Location_lk__c = tmpWavePlan.Deal_Location__c;
                        tempTechAssess.Wave_Plan_lk__c = tmpWavePlan.id;
                        tempTechAssess.Wave_Plan_Version__c = clonedWPVersion;
                        tempTechAssess.version__c= version + 1;
                        tempTechAssess.isEditVisible__c = true;
                        lstClonedTechAssessment.add(tempTechAssess);
                    }
                }
            }
            if(!lstClonedTechAssessment.isEmpty()) {
                Database.insert(lstClonedTechAssessment,false);
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_LI, null, 
                                                    System.Logginglevel.ERROR);
        }                                        
     }
     /**
    * @Description:clone TechTracker records related WPV
    * @MethodName:cloneTechTracker
    */ 
    webservice static void cloneTechTracker(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Tech_Tracker__c> lstTechTracker = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Tech_Tracker__c.sObjectType.getDescribe().getName(),
                                                        CLONE_KT_SUFFIX));
            getNewDealLocationAndDealWave(clonedWPVersion);
            if(!lstTechTracker.isEmpty()) {
                List<Tech_Tracker__c> lstClonedTechTrack = new List<Tech_Tracker__c>();
                Tech_Tracker__c tempTechTrack = new Tech_Tracker__c();
                for(Tech_Tracker__c TechTrack : lstTechTracker){
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        if(TechTrack.Deal_Wave__c == tmpWavePlan.Cloned_From__c) {
                            tempTechTrack = new Tech_Tracker__c();
                            tempTechTrack = TechTrack.clone(false,true);
                            tempTechTrack.Deal_Wave__c = tmpWavePlan.id;
                            tempTechTrack.version__c= version + 1;
                            tempTechTrack.Cloned_From__c = TechTrack.id;
                            tempTechTrack.active__c = true;
                            lstClonedTechTrack.add(tempTechTrack);
                            TechTrack.active__c = false;
                        }
                    }
                }
                if(!lstClonedTechTrack.isEmpty()) {
                    Database.insert(lstClonedTechTrack,false);
                    Database.update(lstTechTracker);
                }
            }
            List<Tracking_Tech_Assessment__c> lstTrackingTechAssess =  Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Tracking_Tech_Assessment__c.sObjectType.getDescribe().getName(),
                                                        CLONE_KT_SUFFIX));
            if(!lstTrackingTechAssess.isEmpty()) {
                List<Tracking_Tech_Assessment__c> lstClonedTechTrack = new List<Tracking_Tech_Assessment__c>();
                Tracking_Tech_Assessment__c tempTechTrack = new Tracking_Tech_Assessment__c();
                for(Tracking_Tech_Assessment__c TechTrack : lstTrackingTechAssess) {
                    for(Wave_Planning__c tmpWavePlan : lstNewWavePlanning) {
                        if(TechTrack.Deal_Wave__c == tmpWavePlan.Cloned_From__c) {
                            tempTechTrack = new Tracking_Tech_Assessment__c();
                            tempTechTrack = TechTrack.clone(false,true);
                            tempTechTrack.Deal_Wave__c = tmpWavePlan.id;
                            tempTechTrack.version__c= version + 1;
                            tempTechTrack.Cloned_From__c = TechTrack.id;
                            tempTechTrack.active__c = true;
                            lstClonedTechTrack.add(tempTechTrack);
                            TechTrack.active__c = false;
                        }
                    }
                }
                if(!lstClonedTechTrack.isEmpty()) {
                    Database.insert(lstClonedTechTrack,false);
                    Database.update(lstTrackingTechAssess,false);
                }
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_TT, null, 
                                                    System.Logginglevel.ERROR);
        }   
    }
    /**
    * @Description:Clone the journey Management Records 
    * @MethodName:cloneJourneyPlan
    */ 
    webservice static void cloneJourneyPlan(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Journey_Management_Planning__c> lstJourneyPlan = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Journey_Management_Planning__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX)); 
            List<Journey_Management_Planning__c> lstClonedJourneyPlan = new List<Journey_Management_Planning__c>();
            List<Journey_Management_Deliverable__c> lstJourneyDelivery = [select id,Deliverable_Name__c,Deliverable_Number__c,
                                                                          Journey_Management__c,Journey_Management__r.section_name__c,
                                                                          Journey_Management__r.Section_Number__c 
                                                                          from Journey_Management_Deliverable__c where Is_Active__c =: true limit 5000];
            List<Id> lstActivityIds = new  List<Id>();
            Journey_Management_Planning__c tempJourneyPlan = new Journey_Management_Planning__c();
            if(!lstJourneyPlan.isEmpty()) {
                Boolean isInMaster = false;
                for(Journey_Management_Planning__c journeyPlan : lstJourneyPlan ) {
                    isInMaster = false;
                    tempJourneyPlan = new Journey_Management_Planning__c();
                    tempJourneyPlan = journeyPlan.clone(false,true);
                    tempJourneyPlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempJourneyPlan.version__c = version + 1;
                    tempJourneyPlan.isEditVisible__c = true;
                    tempJourneyPlan.Cloned_From__c = journeyPlan.id;
                    for( Journey_Management_Deliverable__c tmpActivity : lstJourneyDelivery ) {
                        if(journeyPlan.Journey_Management_Deliverable_Id__c== tmpActivity.id) {
                            tempJourneyPlan.Deliverable_Name__c= tmpActivity.Deliverable_Name__c;
                            tempJourneyPlan.Deliverable_Number__c = tmpActivity.Deliverable_Number__c;
                            tempJourneyPlan.Section_Name__c = tmpActivity.Journey_Management__r.section_name__c;
                            tempJourneyPlan.Section_Number__c = tmpActivity.Journey_Management__r.Section_Number__c;
                            lstActivityIds.add(journeyPlan.Journey_Management_Deliverable_Id__c);                        
                            isInMaster = true;
                            break;
                        }
                    }
                    if(journeyPlan.Is_From_Add_Section__c || isInMaster) {
                        lstClonedJourneyPlan.add(tempJourneyPlan);
                    }
                }
            } 
            if(!lstActivityIds.isEmpty()) {
                lstJourneyDelivery = [select id,Deliverable_Name__c,Deliverable_Number__c,Journey_Management__c,
                               Journey_Management__r.section_name__c,Journey_Management__r.Section_Number__c 
                               from Journey_Management_Deliverable__c 
                               where id not in :lstActivityIds AND Is_Active__c =: true limit 5000];
            }
            if(!lstJourneyDelivery.isEmpty()) {
                for(Journey_Management_Deliverable__c tmpActivity : lstJourneyDelivery) {
                    tempJourneyPlan= new Journey_Management_Planning__c();
                    tempJourneyPlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempJourneyPlan.version__c = version + 1;
                    tempJourneyPlan.Deliverable_Name__c= tmpActivity.Deliverable_Name__c;
                    tempJourneyPlan.Deliverable_Number__c = tmpActivity.Deliverable_Number__c;
                    tempJourneyPlan.Section_Name__c = tmpActivity.Journey_Management__r.section_name__c;
                    tempJourneyPlan.Section_Number__c = tmpActivity.Journey_Management__r.Section_Number__c;
                    tempJourneyPlan.Journey_Management_Deliverable_Id__c = tmpActivity.id;
                    tempJourneyPlan.Journey_Management_Id__c = tmpActivity.Journey_Management__c;
                    tempJourneyPlan.isEditVisible__c = true;
                    lstClonedJourneyPlan.add(tempJourneyPlan);
                }
            }
            if(!lstClonedJourneyPlan.isEmpty()) {
                Database.insert(lstClonedJourneyPlan,false);
            }  
        }  
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_JP, null, 
                                                    System.Logginglevel.ERROR);
        }                                                                                                   
    }
    /**
    * @Description:Clone the BCP Records related WPV 
    * @MethodName:cloneBCPPlan
    */ 
    webservice static void cloneBCPPlan(String oldWaveVersionId, String clonedWPVersion, integer version) {
        try {
            List<Business_Continuity_Planning__c> lstBCPPlan = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Business_Continuity_Planning__c.sObjectType.getDescribe().getName(),
                                                        CLONE_CHILD_SUFFIX));
            List<Business_Continuity_Planning__c> lstClonedBCPPlan = new List<Business_Continuity_Planning__c>();
            List<BCP_Task_Master__c> lstBCPDelivery = [select id,Task_Name__c,Task_Number__c,Business_Continuity_Planning_del__c,
                                                        Business_Continuity_Planning_del__r.section_name__c,Business_Continuity_Planning_del__r.Section_Number__c 
                                                        from BCP_Task_Master__c where Is_Active__c =: true limit 5000]; 
            List<Id> lstActivityIds = new  List<Id>();
            Business_Continuity_Planning__c tempBCPPlan = new Business_Continuity_Planning__c();
            if(!lstBCPPlan.isEmpty()) {
                Boolean isInMaster = false;
                for(Business_Continuity_Planning__c BCPPlan : lstBCPPlan ) {
                    isInMaster = false;
                    tempBCPPlan = new Business_Continuity_Planning__c();
                    tempBCPPlan = BCPPlan.clone(false,true);
                    tempBCPPlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempBCPPlan.version__c = version + 1;
                    tempBCPPlan.isEditVisible__c = true;                                        
                    tempBCPPlan.Cloned_From__c = BCPPlan.id;
                    for( BCP_Task_Master__c tmpActivity : lstBCPDelivery ) {
                        if(BCPPlan.BCP_Task_Master_Id__c== tmpActivity.id) {
                            tempBCPPlan.Task_Name__c= tmpActivity.Task_Name__c;
                            tempBCPPlan.Task_Number__c = tmpActivity.Task_Number__c;
                            tempBCPPlan.Section_Name__c = tmpActivity.Business_Continuity_Planning_del__r.section_name__c;
                            tempBCPPlan.Section_Number__c = tmpActivity.Business_Continuity_Planning_del__r.Section_Number__c;
                            lstActivityIds.add(BCPPlan.BCP_Task_Master_Id__c);                        
                            isInMaster = true;
                            break;
                        }
                    }
                    if(BCPPlan.Is_From_Add_Section__c || isInMaster) {
                        lstClonedBCPPlan.add(tempBCPPlan);
                    }
                }
            }
            if(!lstActivityIds.isEmpty()) { 
               lstBCPDelivery = [select id,Task_Name__c,Task_Number__c,Business_Continuity_Planning_del__r.Section_Number__c ,
                               Business_Continuity_Planning_del__c,Business_Continuity_Planning_del__r.section_name__c
                               from BCP_Task_Master__c 
                               where id not in :lstActivityIds AND Is_Active__c =: true limit 5000];
            } 
            if(!lstBCPDelivery.isEmpty()) {
                for(BCP_Task_Master__c tmpActivity : lstBCPDelivery ) { 
                    tempBCPPlan= new Business_Continuity_Planning__c();
                    tempBCPPlan.Wave_Plan_Version__c = clonedWPVersion;
                    tempBCPPlan.version__c = version + 1;
                    tempBCPPlan.Task_Name__c= tmpActivity.Task_Name__c;
                    tempBCPPlan.Task_Number__c = tmpActivity.Task_Number__c;
                    tempBCPPlan.Section_Name__c = tmpActivity.Business_Continuity_Planning_del__r.section_name__c;
                    tempBCPPlan.Section_Number__c = tmpActivity.Business_Continuity_Planning_del__r.Section_Number__c;
                    tempBCPPlan.BCP_Task_Master_Id__c = tmpActivity.id;
                    tempBCPPlan.BCP_Section_Master_Id__c = tmpActivity.Business_Continuity_Planning_del__c;
                    tempBCPPlan.isEditVisible__c  = true;
                    lstClonedBCPPlan.add(tempBCPPlan);
                }
            } 
            if(!lstClonedBCPPlan.isEmpty()) {
                Database.insert(lstClonedBCPPlan,false);
            }  
        } 
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_BCP, null, 
                                                    System.Logginglevel.ERROR);
        }                                                                                                
    }
    /**
    * @Description:Check the Login user has the Create permisson the the WPV record  
    * @MethodName:isAuthenticMobUser
    */ 
    webservice static boolean isAuthenticMobUser(String oldWaveVersionId) {
        try {
            List<wave_Plan_Version__c> lstWavePlanVersion = [select deal__c from wave_Plan_Version__c where id=:oldWaveVersionId limit 1];
            string strDealId;
            if(!lstWavePlanVersion.isEmpty()) {
                strDealId =  lstWavePlanVersion.get(0).deal__c;
            }
            UAMSolMobUtility.RunSoqlQueries(strDealId);
            Map<String,Boolean> m = UAMSolMobUtility.checkSolMobAcess(UTIL_Constants.UAM_OBJ_Wave_Plan_Version);
            return m.get(UTIL_Constants.CREATE);
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME_REBASELINE, CLASS_NAME, METHOD_NAME_MOB_USER, null, 
                                                    System.Logginglevel.ERROR);
            return null;                                        
        } 
    }
    /**
    * @Description:Get deal locations and waves under new cloned wave plan version
    * @MethodName:getNewDealLocationAndDealWave
    */ 
    public static void getNewDealLocationAndDealWave(String oldWaveVersionId) {
        lstNewDealLocation =  Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Deal_Location__c.sObjectType.getDescribe().getName(),
                                                    CLONE_CHILD_SUFFIX));                                      
        lstNewWavePlanning = Database.query(new Mob_RebaselineHighLevelPlan().getCreatableFieldsSOQL(Wave_Planning__c.sObjectType.getDescribe().getName(),
                                                    CLONE_WAVE_PLAN_SUFFIX));
        lstNewWaveProcess = lstNewWaveProcess = [Select name,Active__c,Client_Specific_Process_Mapping__c,Comment__c,Cloned_From__c,
                                    Wave_Planning__r.Deal_Location__c,Wave_Planning__r.GO_Live_Date_del__c,
                                    Completion_Status__c,Process_RAG_Status__c,Wave_Planning__c,Number_of_Projected_FTEs__c
                                    from Wave_Process__c where Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__c = :oldWaveVersionId limit 5000];                             
    }
    /**
    * @Description:Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we 
    *              will be inserting a cloned result of this query.   
    * @MethodName:getCreatableFieldsSOQL
    */ 
    public String getCreatableFieldsSOQL(String objectName , String whereClause){
        if (String.isBlank(whereClause)){
            return null;
        } 
        String selects = UTIL_Constants.EMPTY_STRING;
        Map<String, Schema.SObjectField> fMap = 
            Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if (fMap != null){
            for(Schema.SObjectField ft : fMap.values()){ 
                Schema.DescribeFieldResult fd = ft.getDescribe();
                String fieldName = fd.getName();
                if(fd.isCreateable()){
                    selectFields.add(fieldName);
                }
            }
        }
        if (!selectFields.isEmpty()){
            //Loop through selectFields with loop variable as "tempSelect"
            for(string tempSelect: selectFields){
                selects += tempSelect + UTIL_Constants.COMMA_STRING;
            }
            if (selects.endsWith(UTIL_Constants.COMMA_STRING)){
                selects = selects.substring(0,selects.lastIndexOf(UTIL_Constants.COMMA_STRING));
            }
        }
        system.debug('Query---->'+UTIL_Constants.SELECT_STRING + selects + UTIL_Constants.FROM_STRING + objectName + UTIL_Constants.WHERE_STRING + whereClause);
        return UTIL_Constants.SELECT_STRING + selects + UTIL_Constants.FROM_STRING + objectName + UTIL_Constants.WHERE_STRING + whereClause;    
    }
}