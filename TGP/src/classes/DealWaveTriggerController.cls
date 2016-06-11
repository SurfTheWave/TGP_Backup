/*
* This class will be used as business logic controller for trigger OperationOnDealWave on Wave_Planning__c
*
*  @ Author Accenture Team
*  @ Date 18/02/2014 
*/
public class DealWaveTriggerController {
    // Class Constants
    private static final string CLASS_NAME = 'DealWaveTriggerController';
    private static final string TRIGGER_NAME = 'OperationOnDealWave';
    private static final string METHOD_BEFORE_INSERT = 'copyUserFromDealLocation';
    private static final string METHOD_PRE_POPULATE = 'prePopulateTrackingInsert';
    private static final string METHOD_RT = 'insertInRecruitmentTracking'; 
    private static final string METHOD_TA = 'insertInTechAssess'; 
    private static final string METHOD_KT = 'insertInKTPlan'; 
    private static final string METHOD_SRAT_INSERT = 'insertInSRAT';
    private static final string METHOD_PRE_POPULATE_UPDATE = 'prePopulateTrackingInsert'; 
    private static final string METHOD_SRAT_UPDATE = 'updateInSRAT'; 
    private static final string METHOD_OPEX_UPDATE = 'updateInOPEX';
    private static final string METHOD_ACESS_PERMISSON = 'accessPermissionDealWave';
    private static final string METHOD_KT_UPDATE = 'updateInKTPlan';
    private static final string METHOD_RT_UPDATE = 'updateInRecruitTracking';
    private static final string METHOD_TA_UPDATE= 'updateInTechAssess';
    private static final string METHOD_FTES_UPDATE_ON_DEAL='UpdateTotalFTEsOnDeal';
    /*
    *   @ Method : copyUserFromDealLocation
    *   @ Description : This method called by the before insert trigger, and it assigne the 
    *                   Deal Location user to Wave plan records
    */
    public void copyUserFromDealLocation(List<Wave_Planning__c> wavePlanList) {
        set<Id> dlIDSet = new set<Id>();
        Map<ID, Deal_Location__c> dealLocMap = new Map<ID, Deal_Location__c>();
        try{
            for(Wave_Planning__c wp : wavePlanList) {
                dlIDSet.add(wp.Deal_Location__c);
            }
            for(Deal_Location__c dl : [select Mobilization_Recruitment_Lead_Primary__c,
                                                    Mobilization_Recruitment_Lead_Secondary__c from Deal_Location__c where Id IN : dlIDSet limit 5000]) {
                if(!dealLocMap.containsKey(dl.Id))  {
                    dealLocMap.put(dl.Id, dl);
                }
            }
            for(Wave_Planning__c wp : wavePlanList) {
                if(dealLocMap.containsKey(wp.Deal_Location__c)) {
                    Deal_Location__c dl = dealLocMap.get(wp.Deal_Location__c);
                    wp.Mobilization_Recruitment_Lead_Primary__c = dl.Mobilization_Recruitment_Lead_Primary__c;
                    wp.Mobilization_Recruitment_Lead_Secondary__c = dl.Mobilization_Recruitment_Lead_Secondary__c;
                    //wp.Wave_Status__c = UTIL_Constants.YET_TO_GO_LIVE; 
                }
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_BEFORE_INSERT, 
                                                TRIGGER_NAME, System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : accessPermissionDealWave
    *   @ Description : This method used to provide the accees to Deal Wave Records
    */
    public void accessPermissionDealWave(List<Wave_Planning__c> newWavePlanList,List<Wave_Planning__c> oldWavePlanList ) {
        List<Wave_Planning__c> lstNewdealWaveForUAM = new List<Wave_Planning__c>();
        List<Wave_Planning__c> lstOlddealWaveForUAM = new List<Wave_Planning__c>();
        UserAccessUtility uam = new UserAccessUtility();
        try {
            if(!Recursive.isDealWaveUpdateFromWaveProcess) {
                for(integer i=0;i<oldWavePlanList.size();i++ ) {
                    if(oldWavePlanList.get(i).active__c == newWavePlanList.get(i).active__c) {
                        lstOlddealWaveForUAM.add(oldWavePlanList.get(i));   
                        lstNewdealWaveForUAM.add(newWavePlanList.get(i));
                    }
                }
                if(!lstOlddealWaveForUAM.isEmpty()) {    
                    uam.CheckAccessDealWaveDelete(lstOlddealWaveForUAM);   
                }
                if(!lstNewdealWaveForUAM.isEmpty()) {         
                    uam.CheckAccessDealWave(lstNewdealWaveForUAM);
                }
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_ACESS_PERMISSON, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : prePopulateTrackingInsert
    *   @ Description : This method called by the after insert trigger, and it calls the 
    *                  method for insert the KT Planning, Recruitmrnt Tracking and SRAT Records
    */
    public void prePopulateTrackingInsert(List<Wave_Planning__c> wavePlanList) {
        set<Id> wpIDSet = new set<Id>();
        try{
            for(Wave_Planning__c wp :wavePlanList ) {
                wpIDSet.add(wp.id);
            }
            List<Wave_Planning__c> lstWavePlan = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,
                                                        Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,GO_Live_Date_del__c,
                                                        Deal_Location__r.Wave_Plan_Version__r.cloned_from__c,Wave_Label__c from Wave_Planning__c
                                                        where Id IN :wpIDSet and Deal_Location__r.Wave_Plan_Version__r.active__c = true limit 5000];
            if(!lstWavePlan.isEmpty()) {
                insertInRecruitmentTracking(lstWavePlan);
                insertInTechAssess(lstWavePlan);
                insertInKTPlan(lstWavePlan);
                insertInSRAT(lstWavePlan);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_PRE_POPULATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : prePopulateTrackingUpdate
    *   @ Description : This method called by the after Update trigger, and it calls the 
    *                  method for update the opex and SRAT Records
    */
    public void prePopulateTrackingUpdate(List<Wave_Planning__c> wavePlanList) {
        set<Id> wpIDSet = new set<Id>();
        try{
            for(Wave_Planning__c wp :wavePlanList ) {
                    wpIDSet.add(wp.id);
            }
            List<Wave_Planning__c> lstWavePlan = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,NewActive__c,
                                                    Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Label__c,
                                                    Deal_Location__r.Wave_Plan_Version__r.cloned_from__c,GO_Live_Date_del__c from Wave_Planning__c
                                                    where Id IN :wpIDSet limit 5000];
            if(!lstWavePlan.isEmpty())  {
                updateInSRAT(lstWavePlan);
                updateInOPEX(lstWavePlan);
                updateInKTPlan(lstWavePlan);
                updateInRecruitTracking(lstWavePlan);
                updateInTechAssess(lstWavePlan);
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_PRE_POPULATE_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : prePopulateTrackingUpdate
    *   @ Description : This method called by the after Update trigger, and it calls the 
    *                  method for update the opex and SRAT Records
    */
    /*public void prePopulateDealTrackingDate(List<Wave_Planning__c> wavePlanListNew,List<Wave_Planning__c> wavePlanListOld) {
            List<Wave_Planning__c> listToUpdate = new List<Wave_Planning__c>();
            
            for(Wave_Planning__c oldRec : wavePlanListOld){
            
                for(Wave_Planning__c newRec : wavePlanListNew){
                
                    if(oldRec.GO_Live_Date_del__c != newRec.GO_Live_Date_del__c){
                    
                    
                        if(oldRec.GO_Live_Date_del__c > newRec.GO_Live_Date_del__c){
                        
                            newRec.Wave_Status__c = UTIL_Constants.YET_TO_GO_LIVE;
                        
                        }
                        if(oldRec.GO_Live_Date_del__c < newRec.GO_Live_Date_del__c){
                        
                            newRec.Wave_Status__c = 'Gone Live';
                        
                        }
                        listToUpdate.add(newRec);
                    
                    
                    }
                
                }
                
            
            }
            
            try{
                update listToUpdate;
            }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_PRE_POPULATE_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }*/
    /*
    *   @ Method : insertInRecruitmentTracking
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the Recruitment Tracking records for Wave Plan Version
    */
    private  void insertInRecruitmentTracking (List<Wave_Planning__c> lstWavePlan) {
        set<Id> wpIDSet = new set<Id>();
        List<Recruitment_Tracking__c> lstRecruit = new List<Recruitment_Tracking__c>();
        Map<Id,Set<Recruitment_Tracking__c>> recTracMap = new Map<Id,Set<Recruitment_Tracking__c>>();
        set<Recruitment_Tracking__c> rtSet = new set<Recruitment_Tracking__c>();
        List<Activity_Master__c> lstActivity = new List<Activity_Master__c>();
        Recruitment_Tracking__c recruit=null;
        try {
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Deal_Location__r.Wave_Plan_Version__c);
            } 
            if(!wpIDSet.isEmpty())  {
                lstActivity = [select name,Activity_order__c from Activity_Master__c where Is_Active__c = true limit 5000];
                for(Recruitment_Tracking__c rt :[Select Wave_Plan_Version__c, Deal_Location_lk__r.Wave_Plan_Version__c 
                                                from Recruitment_Tracking__c where Deal_Location_lk__r.Wave_Plan_Version__C IN: wpIDSet limit 5000]) {
                    if(recTracMap.containsKey(rt.Deal_Location_lk__r.Wave_Plan_Version__c)){
                        rtSet = recTracMap.get(rt.Deal_Location_lk__r.Wave_Plan_Version__c);
                    }
                    else {
                        rtSet = new set<Recruitment_Tracking__c>();
                    }
                    rtSet.add(rt);
                    recTracMap.put(rt.Deal_Location_lk__r.Wave_Plan_Version__c,rtSet);  
                }   
            }
            for(Wave_Planning__c wp : lstWavePlan) {
                rtSet = new set<Recruitment_Tracking__c>();
                if(recTracMap.containsKey(wp.Deal_Location__r.Wave_Plan_Version__c)) {
                    rtSet = recTracMap.get(wp.Deal_Location__r.Wave_Plan_Version__c);
                }
                if(!rtSet.isEmpty() || String.isEmpty(wp.Deal_Location__r.Wave_Plan_Version__r.cloned_from__c)) {
                    for(Activity_Master__c tmpActivity : lstActivity ) {
                        recruit = new Recruitment_Tracking__c ();
                            recruit.Wave_Plan_lk__c = wp.id;
                            recruit.Deal_Location_lk__c = wp.Deal_Location__c;
                            recruit.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__c;
                            recruit.activity__c = tmpActivity.name;
                            recruit.Activity_Master_ID__c = tmpActivity.id; 
                            recruit.Activity_Order__c = tmpActivity.Activity_order__c;
                            
                            recruit.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                            recruit.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                                    wp.Wave_Label__c; 
                            lstRecruit.add(recruit);
                    }
                }
            }
            if(!lstRecruit.isEmpty()) {
                Database.insert(lstRecruit,false);
            } 
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_RT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }                                   
    }
    /*
    *   @ Method : insertInTechAssess
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the Tech Assessment records for Wave Plan Version
    */
    private void insertInTechAssess(List<Wave_Planning__c> lstWavePlan) {
        set<Id> wpIDSet = new set<Id>();
        List<Tech_Assessment__c> lstTechAssess = new List<Tech_Assessment__c>();
        Map<Id,Set<Tech_Assessment__c>> techAssesMap = new Map<Id,Set<Tech_Assessment__c>>();
        set<Tech_Assessment__c> techSet = new set<Tech_Assessment__c>();
        List<Tech_Assessment_Activity_Master__c> lstActivity = new List<Tech_Assessment_Activity_Master__c>();
        Tech_Assessment__c techAssess=null;
        try {
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Deal_Location__r.Wave_Plan_Version__c);
            } 
            if(!wpIDSet.isEmpty()) {
                lstActivity = [select name,Activity_order__c from Tech_Assessment_Activity_Master__c where Is_Active__c = true limit 5000];
                for(Tech_Assessment__c tech : [Select Deal_Location_lk__r.Wave_Plan_Version__c,Wave_Plan_Version__c 
                                                from Tech_Assessment__c Where Deal_Location_lk__r.Wave_Plan_Version__C IN: wpIDSet limit 5000]) {
                    if(techAssesMap.containsKey(tech.Deal_Location_lk__r.Wave_Plan_Version__c)){
                        techSet = techAssesMap.get(tech.Deal_Location_lk__r.Wave_Plan_Version__c);
                    }
                    else {
                        techSet = new set<Tech_Assessment__c>();
                    }
                    techSet.add(tech);
                    techAssesMap.put(tech.Deal_Location_lk__r.Wave_Plan_Version__c,techSet);  
                }
            }
            for(Wave_Planning__c wp : lstWavePlan) {
                techSet = new set<Tech_Assessment__c>();
                if(techAssesMap.containsKey(wp.Deal_Location__r.Wave_Plan_Version__c)) {
                    techSet = techAssesMap.get(wp.Deal_Location__r.Wave_Plan_Version__c);
                }
               if(!techSet.isEmpty() || String.isEmpty(wp.Deal_Location__r.Wave_Plan_Version__r.cloned_from__c)) {
                    for(Tech_Assessment_Activity_Master__c tmpActivity : lstActivity){
                        techAssess = new Tech_Assessment__c ();
                        techAssess.Wave_Plan_lk__c = wp.id;
                        techAssess.Deal_Location_lk__c = wp.Deal_Location__c;
                        techAssess.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__c;
                        techAssess.activity__c = tmpActivity.name;
                        techAssess.Tech_Assessment_Activity_Master_ID__c = tmpActivity.id;
                        techAssess.Activity_Order__c = tmpActivity.Activity_order__c;                        
                        techAssess.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                        techAssess.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                                    wp.Wave_Label__c;  
                        lstTechAssess.add(techAssess);
                    }
                }
            }
            if(!lstTechAssess.isEmpty()) {
                Database.insert(lstTechAssess,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_TA, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : insertInTechAssess
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the KT Planning records for Wave Plan Version
    */
    private void insertInKTPlan(List<Wave_Planning__c> lstWavePlan) {
        set<Id> wpIDSet = new set<Id>();
        List<KT_Planning__c> lstKTPlan = new List<KT_Planning__c>();
        List<KT_Planning_Activity_Master__c> lstActivity = new List<KT_Planning_Activity_Master__c>();
        Map<Id,Set<KT_Planning__c>> ktPlanAssesMap = new Map<Id,Set<KT_Planning__c>>();
        set<KT_Planning__c> ktSet = new set<KT_Planning__c>();
        KT_Planning__c ktPlan;
        try {
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Deal_Location__r.Wave_Plan_Version__c);
            } 
            if(!wpIDSet.isEmpty()) {
                lstActivity = [select name,Activity_order__c from KT_Planning_Activity_Master__c Where Is_Active__c = true limit 5000];
                for(KT_Planning__c kt : [Select Deal_Location_lk__r.Wave_Plan_Version__c,Wave_Plan_Version__c 
                                         from KT_Planning__c where Deal_Location_lk__r.Wave_Plan_Version__c IN : wpIDSet limit 5000]){
                    if(ktPlanAssesMap.containsKey(kt.Deal_Location_lk__r.Wave_Plan_Version__c)){
                        ktSet = ktPlanAssesMap.get(kt.Deal_Location_lk__r.Wave_Plan_Version__c);
                    }
                    else {
                        ktSet = new set<KT_Planning__c>();
                    }
                    ktSet.add(kt);
                    ktPlanAssesMap.put(kt.Deal_Location_lk__r.Wave_Plan_Version__c,ktSet);                      
                }
            }
            for(Wave_Planning__c wp : lstWavePlan) {
                ktSet = new set<KT_Planning__c>();
                if(ktPlanAssesMap.containsKey(wp.Deal_Location__r.Wave_Plan_Version__c)) {
                    ktSet = ktPlanAssesMap.get(wp.Deal_Location__r.Wave_Plan_Version__c);
                }
                if(!ktSet.isEmpty() || String.isEmpty(wp.Deal_Location__r.Wave_Plan_Version__r.cloned_from__c)) {
                    for(KT_Planning_Activity_Master__c tmpActivity : lstActivity ) {
                        ktPlan = new KT_Planning__c ();
                        ktPlan.Wave_Plan_lk__c = wp.id;
                        ktPlan.Deal_Location_lk__c = wp.Deal_Location__c;
                        ktPlan.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__c;
                        ktPlan.activity__c = tmpActivity.name;
                        ktPlan.KT_Planning_Activity_Master_ID__c = tmpActivity.id;
                        ktPlan.Activity_order__c = tmpActivity.Activity_order__c;                        
                        ktPlan.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                        ktPlan.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                                wp.Wave_Label__c;  
                        lstKTPlan.add(ktPlan);
                    }
                }
            }
            if(!lstKTPlan.isEmpty()) {
                Database.insert(lstKTPlan,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_KT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : insertInSRAT
    *   @ Description : This method called by method prePopulateTrackingInsert, and it 
    *                  inserts the SRAT records for Wave Plan Version
    */
    private void insertInSRAT(List<Wave_Planning__c> lstWavePlan) {
        List<SRAT__c> lstSRAT = new List<SRAT__c>();
        List<SRAT_Item_master__c> lstItem = new List<SRAT_Item_master__c>();
        set<Id> wpIDSet = new set<Id>();
        Map<Id,Set<SRAT__c>> sratMap = new Map<Id,Set<SRAT__c>>();
        set<SRAT__c> sratSet = new set<SRAT__c>();
        SRAT__c srat=null;
        try{
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Deal_Location__r.Wave_Plan_Version__c);
            } 
            if(!wpIDSet.isEmpty()) {
                lstItem = [select item_name__c,Days_Before_Go_Live_Date__c from SRAT_Item_master__c where Is_Active__c =: true limit 5000];
                for(SRAT__c sr : [Select Deal_Location_lk__r.Wave_Plan_Version__c,Wave_Plan_Version__c 
                                         from SRAT__c where Deal_Location_lk__r.Wave_Plan_Version__c IN : wpIDSet limit 5000]) {
                    if(sratMap.containsKey(sr.Deal_Location_lk__r.Wave_Plan_Version__c)){
                        sratSet = sratMap.get(sr.Deal_Location_lk__r.Wave_Plan_Version__c);
                    }
                    else {
                        sratSet = new set<SRAT__c>();
                    }
                    sratSet.add(sr);
                    sratMap.put(sr.Deal_Location_lk__r.Wave_Plan_Version__c,sratSet);                               
                }
            }
            SRAT_VERSION__c sratVersion = [select SRAT_Name__c, id, name from SRAT_VERSION__c where isActive__c=:true limit 1];
            for(Wave_Planning__c wp : lstWavePlan) {
                sratSet = new set<SRAT__c>();
                if(sratMap.containsKey(wp.Deal_Location__r.Wave_Plan_Version__c)) {
                    sratSet = sratMap.get(wp.Deal_Location__r.Wave_Plan_Version__c);
                }
                if(!sratSet.isEmpty() || String.isEmpty(wp.Deal_Location__r.Wave_Plan_Version__r.cloned_from__c)) {
                    for(SRAT_Item_master__c tmpItem : lstItem ) {
                        srat = new SRAT__C ();
                        srat.Wave_Plan_lk__c = wp.id;
                        srat.Deal_Location_lk__c = wp.Deal_Location__c;
                        srat.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                        srat.Item__c = tmpItem.Item_Name__c;
                        srat.SRAT_Item_master_id__c= tmpItem.id;
                        srat.active__c=true;
                        srat.Days_Before_Go_Live_Date__c = tmpItem.Days_Before_Go_Live_Date__c;
                        srat.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(tmpItem.Days_Before_Go_Live_Date__c.intValue());
                        srat.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                        srat.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                                wp.Wave_Label__c;  
                        if(!String.isEmpty(sratVersion.id))
                            srat.SRAT_Version__c = sratVersion.id;
                        lstSRAT.add(srat);
                    }
                }
            }
            if(!lstSRAT.isEmpty()) {
                Database.insert(lstSRAT,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_SRAT_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : updateInSRAT
    *   @ Description : This method called by method prePopulateTrackingUpdate, and it 
    *                  update the SRAT Tracking records for Wave Plan Version
    */
    private void updateInSRAT(List<Wave_Planning__c> lstWavePlan) {
        system.debug('lstWavePlan------inside SRAT------>>>>>>>>>'+lstWavePlan);
        Map<Id,Set<SRAT__c>> sratMap = new Map<Id,Set<SRAT__c>>();
        set<SRAT__c> sratSet = new set<SRAT__c>();
        set<Id> wpIDSet = new set<Id>();
        List<SRAT__c> lstSRAT = new List<SRAT__c> ();
        String temp=null;
        Integer numTemp;
        try {
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Id);
            }
            if(!wpIDSet.isEmpty()){
                for(SRAT__c srat : [select Item__c ,Wave_Plan_Version__c, Wave_Plan_lk__c, Deal_Location_lk__c,Planned_Date__c,
                                    Location_Id_Wave_Id__c,Location_Name_Wave_Name__c,SRAT_Item_master_id__r.Days_Before_Go_Live_Date__c 
                                    from SRAT__C where Wave_Plan_lk__c IN : wpIDSet limit 5000]) {
                    if(sratMap.containsKey(srat.Wave_Plan_lk__c)) {
                        sratSet = sratMap.get(srat.Wave_Plan_lk__c);
                    }
                    else {
                        sratSet = new set<SRAT__c>();
                    }
                    sratSet.add(srat);
                    sratMap.put(srat.Wave_Plan_lk__c,sratSet);                      
                }
            } 
            for(Wave_Planning__c wp : lstWavePlan) {
                sratSet = new set<SRAT__c>();
                if(sratMap.containsKey(wp.Id)) {
                    sratSet = sratMap.get(wp.Id);
                }
                for(SRAT__c srat : sratSet) {
                    srat.Wave_Plan_lk__c = wp.id;
                    srat.Deal_Location_lk__c = wp.Deal_Location__c;
                    srat.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__c;
                    if(srat.SRAT_Item_master_id__r.Days_Before_Go_Live_Date__c != null) {
                        srat.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(srat.SRAT_Item_master_id__r.Days_Before_Go_Live_Date__c.intValue());
                    }
                    else { 
                        temp = srat.Item__c.substring(7);
                        numTemp = Integer.ValueOf(temp);                   
                        srat.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(-numTemp);
                     } 
                    srat.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                    srat.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                            wp.Wave_Label__c; 
                    lstSRAT.add(srat);
                }
            }
            if(!lstSRAT.isEmpty()) {
                system.debug('Before update method'+lstSRAT);
                Database.update(lstSRAT,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_SRAT_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : updateInOPEX
    *   @ Description : This method called by method prePopulateTrackingUpdate, and it 
    *                  update the OPEX Tracking records for Wave Plan Version
    */
    private void updateInOPEX(List<Wave_Planning__c> lstWavePlan) {
        Map<Id,Set<OPEX__c>> opexMap = new Map<Id,Set<OPEX__c>>();
        set<OPEX__c> opexSet = new set<OPEX__c>();
        set<Id> wpIDSet = new set<Id>();
        List<OPEX__c> lstOPEX = new List<OPEX__c> ();
        try {
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Id);
            }
            if(!wpIDSet.isEmpty()){
                for(OPEX__c opex : [Select Wave_Plan_Version__c, Deal_Location_lk__c,Planned_Date__c,Wave_Plan_lk__c,
                                    Location_Id_Wave_Id__c,Location_Name_Wave_Name__c,OPEX_Item_master_id__r.Days_After_Go_Live_Date__c 
                                    from OPEX__c where Wave_Plan_lk__c IN: wpIDSet limit 5000]) {
                    if(opexMap.containsKey(opex.Wave_Plan_lk__c)) {
                        opexSet = opexMap.get(opex.Wave_Plan_lk__c);
                    }
                    else {
                        opexSet = new set<OPEX__c>();
                    }
                    opexSet.add(opex);
                    opexMap.put(opex.Wave_Plan_lk__c,opexSet);                  
                }
            }
            for(Wave_Planning__c wp : lstWavePlan) {
                opexSet = new set<OPEX__c>();
                if(opexMap.containsKey(wp.Id)) {
                    opexSet = opexMap.get(wp.Id);
                }
                for(OPEX__c tmpOpex: opexSet) {
                    tmpOpex.Wave_Plan_lk__c = wp.id;
                    tmpOpex.Deal_Location_lk__c = wp.Deal_Location__c;
                    tmpOpex.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                    tmpOpex.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(tmpOpex.OPEX_Item_master_id__r.Days_After_Go_Live_Date__c.intValue());
                    tmpOpex.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                    tmpOpex.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                            wp.Wave_Label__c; 
                    lstOPEX.add(tmpOpex);
                }
            }
            if(!lstOPEX.isEmpty()) {
                Database.update(lstOPEX,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_OPEX_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : updateInRecruitTracking
    *   @ Description : This method called by method prePopulateTrackingUpdate, and it 
    *                  update the Recruitement  Tracking records for Wave Plan Version
    */
    private void updateInRecruitTracking(List<Wave_Planning__c> lstWavePlan) {
        Map<Id,Set<Recruitment_Tracking__c>> rtMap = new Map<Id,Set<Recruitment_Tracking__c>>();
        set<Recruitment_Tracking__c> rtSet = new set<Recruitment_Tracking__c>();
        set<Id> wpIDSet = new set<Id>();
        List<Recruitment_Tracking__c> lstRT = new List<Recruitment_Tracking__c> ();
        try {
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Id);
            }
            if(!wpIDSet.isEmpty()){
                for(Recruitment_Tracking__c rt :[Select Wave_Plan_Version__c,Location_Id_Wave_Id__c,Location_Name_Wave_Name__c, Deal_Location_lk__c ,Wave_Plan_lk__c
                                                from Recruitment_Tracking__c where Wave_Plan_lk__c IN: wpIDSet limit 5000]) {
                    if(rtMap.containsKey(rt.Wave_Plan_lk__c)) {
                        rtSet = rtMap.get(rt.Wave_Plan_lk__c);
                    }
                    else {
                        rtSet = new set<Recruitment_Tracking__c>();
                    }
                    rtSet.add(rt);
                    rtMap.put(rt.Wave_Plan_lk__c,rtSet);                                                
                }
            }
            for(Wave_Planning__c wp : lstWavePlan) {
                rtSet = new set<Recruitment_Tracking__c>();
                if(rtMap.containsKey(wp.Id)) {
                    rtSet = rtMap.get(wp.Id);
                }
                for(Recruitment_Tracking__c rt : rtSet) {
                    rt.Wave_Plan_lk__c = wp.id;
                    rt.Deal_Location_lk__c = wp.Deal_Location__c;
                    rt.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                    rt.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                    rt.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                            wp.Wave_Label__c; 
                    lstRT.add(rt);
                }
            }
            if(!lstRT.isEmpty()) {
                Database.update(lstRT,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_RT_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : updateInKTPlan
    *   @ Description : This method called by method prePopulateTrackingUpdate, and it 
    *                  update the Recruitement  Tracking records for Wave Plan Version
    */
    private void updateInKTPlan(List<Wave_Planning__c> lstWavePlan) {
        Map<Id,Set<KT_Planning__c>> ktMap = new Map<Id,Set<KT_Planning__c>>();
        set<KT_Planning__c> ktSet = new set<KT_Planning__c>();
        set<Id> wpIDSet = new set<Id>();
        List<KT_Planning__c> lstKT = new List<KT_Planning__c> ();
        try {
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Id);
            }
            if(!wpIDSet.isEmpty()){
                for(KT_Planning__c kt :[Select Wave_Plan_Version__c,Location_Id_Wave_Id__c,Location_Name_Wave_Name__c, Deal_Location_lk__c ,Wave_Plan_lk__c
                                                from KT_Planning__c where Wave_Plan_lk__c IN: wpIDSet limit 5000]) {
                    if(ktMap.containsKey(kt.Wave_Plan_lk__c)) {
                        ktSet = ktMap.get(kt.Wave_Plan_lk__c);
                    }
                    else {
                        ktSet = new set<KT_Planning__c>();
                    }
                    ktSet.add(kt);
                    ktMap.put(kt.Wave_Plan_lk__c,ktSet);                                                
                }
            }
            for(Wave_Planning__c wp : lstWavePlan) {
                ktSet = new set<KT_Planning__c>();
                if(ktMap.containsKey(wp.Id)) {
                    ktSet = ktMap.get(wp.Id);
                }
                for(KT_Planning__c kt : ktSet) {
                    kt.Wave_Plan_lk__c = wp.id;
                    kt.Deal_Location_lk__c = wp.Deal_Location__c;
                    kt.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                    kt.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                    kt.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                            wp.Wave_Label__c; 
                    lstKT.add(kt);
                }
            }
            if(!lstKT.isEmpty()) {
                Database.update(lstKT,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_KT_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : updateInTechAssess
    *   @ Description : This method called by method prePopulateTrackingUpdate, and it 
    *                  update the TA  records for Wave Plan Version
    */
    private void updateInTechAssess(List<Wave_Planning__c> lstWavePlan) {
        Map<Id,Set<Tech_Assessment__c>> taMap = new Map<Id,Set<Tech_Assessment__c>>();
        set<Tech_Assessment__c> taSet = new set<Tech_Assessment__c>();
        set<Id> wpIDSet = new set<Id>();
        List<Tech_Assessment__c> lstTA = new List<Tech_Assessment__c> ();
        try {
            for(Wave_Planning__c wp : lstWavePlan) {
                wpIDSet.add(wp.Id);
            }
            if(!wpIDSet.isEmpty()){
                for(Tech_Assessment__c ta :[Select Wave_Plan_Version__c,Location_Id_Wave_Id__c,Location_Name_Wave_Name__c, Deal_Location_lk__c,Wave_Plan_lk__c 
                                                from Tech_Assessment__c where Wave_Plan_lk__c IN: wpIDSet limit 5000]) {
                    if(taMap.containsKey(ta.Wave_Plan_lk__c)) {
                        taSet = taMap.get(ta.Wave_Plan_lk__c);
                    }
                    else {
                        taSet = new set<Tech_Assessment__c>();
                    }
                    taSet.add(ta);
                    taMap.put(ta.Wave_Plan_lk__c,taSet);                                                
                }
            }
            for(Wave_Planning__c wp : lstWavePlan) {
                taSet = new set<Tech_Assessment__c>();
                if(taMap.containsKey(wp.Id)) {
                    taSet = taMap.get(wp.Id);
                }
                for(Tech_Assessment__c ta : taSet) {
                    ta.Wave_Plan_lk__c = wp.id;
                    ta.Deal_Location_lk__c = wp.Deal_Location__c;
                    ta.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                    ta.Location_Id_Wave_Id__c = String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                    ta.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + UTIL_Constants.HYPEN + 
                                                            wp.Wave_Label__c; 
                    lstTA.add(ta);
                }
            }
            if(!lstTA.isEmpty()) {
                Database.update(lstTA,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_TA_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
     *   @ Method : UpdateTotalFTEsOnDeal
     *   @ Description : This method calculate TotalFTEs of all dealwaves and update total FTEs into respective deal object
     */
     public void UpdateTotalFTEsOnDeal(List<Wave_Planning__c> lstWavePlan) {
            system.debug('lstWavePlan>>>'+lstWavePlan);
            try{
             set<Id> locID = new set<Id>(); 
             set<Id> dealIdList = new set<Id>();   
             for(Wave_Planning__c wp :lstWavePlan ) {
                 locID.add(wp.Deal_Location__c);
             }
             system.debug('locID------->>>'+locID);
             for(Deal_Location__c dealLoc :[Select Wave_Plan_Version__c, Wave_Plan_Version__r.Deal__c From Deal_Location__c Where Id IN :locID  limit 5000]) {
                dealIdList.add(dealLoc.Wave_Plan_Version__r.Deal__c);
             }
             Map<String, List<Wave_Planning__c>> dealWPMap = new MAP<String, List<Wave_Planning__c>> ();
             List<Wave_Planning__c> tempWpList;
             for(Wave_Planning__c wp : [Select Deal_Location__c, Number_of_FTEs__c, Deal_Location__r.Wave_Plan_Version__r.Deal__c From Wave_Planning__c Where Deal_Location__r.Wave_Plan_Version__r.Deal__c IN :dealIdList and NewActive__c = true and Deal_Location__r.Wave_Plan_Version__r.Active__c = true limit 5000]) 
                 {
                     if(dealWPMap.containsKey(wp.Deal_Location__r.Wave_Plan_Version__r.Deal__c)) {
                          tempWpList = dealWPMap.get(wp.Deal_Location__r.Wave_Plan_Version__r.Deal__c);
                     }
                     else {
                       tempWpList = new List<Wave_Planning__c> ();
                     }
                     tempWpList.add(wp);
                     dealWPMap.put(wp.Deal_Location__r.Wave_Plan_Version__r.Deal__c,tempWpList);
                 }
    
                 List<Deal_TGP__c> dealUpdatedList = new List<Deal_TGP__c>();
                 Decimal count =0;
                 for(Deal_TGP__c deal : [SELECT Name,Total_No_Of_Projected_FTEs__c from Deal_TGP__c where id IN : dealIdList limit 5000]) {
                     if(dealWPMap.containskey(deal.Id)) {
                         tempWpList = dealWPMap.get(deal.Id);
                         count = 0;
                         for(Wave_Planning__c wpplan : tempWpList) {
                            if(wpplan.Number_of_FTEs__c !=null){
                            count = count + wpplan.Number_of_FTEs__c;
                              system.debug('count >>>>>>>>'+count );
                            }
                         }
                         deal.Total_No_Of_Projected_FTEs__c = count;
                         dealUpdatedList.add(deal);
                     }else{
                         deal.Total_No_Of_Projected_FTEs__c = count;
                         dealUpdatedList.add(deal);
                      }
                      system.debug('dealUpdatedList>>>>>>>>'+dealUpdatedList);
                 }
             
        if(!dealUpdatedList.isEmpty()) {
                 Database.update(dealUpdatedList,false);
           }
         }
     catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_FTES_UPDATE_ON_DEAL, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
     }
     
     /*public void UpdateRevisedGoLiveOnDealTrack(List<Wave_Planning__c> lstWavePlanNew,List<Wave_Planning__c> lstWavePlanOld) {
         for(integer i=0;i<lstWavePlanNew.size();i++){
             if(lstWavePlanNew[i].Revised_Go_Live__c==null){
                 lstWavePlanNew[i].addError('Revised Go live date cannot be blank');
                 break;
             }
             if(lstWavePlanNew[i]!=null && lstWavePlanOld[i]!=null){
                 if(   (lstWavePlanOld[i].Revised_Go_Live__c==null && 
                        lstWavePlanNew[i].Revised_Go_Live__c!=lstWavePlanNew[i].GO_Live_Date_del__c &&  
                        lstWavePlanNew[i].Revised_Go_Live_Comments__c==null) ||
                       (lstWavePlanOld[i].Revised_Go_Live__c!=null &&
                        lstWavePlanOld[i].Revised_Go_Live__c!=lstWavePlanNew[i].Revised_Go_Live__c && 
                        lstWavePlanNew[i].Revised_Go_Live_Comments__c==null)
                   ){
                    
                       lstWavePlanNew[i].addError('Insert comment under Revised Go Live Comments as the Revised Go live date is changed for the Wave');
                       break; 
                    }
            }
              
        }
     }*/
}