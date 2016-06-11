/*
  @Author: Sumalatha Ganga
  @Name: SRATUpdateController 
  @Created Date: 01 January 2015
  @Description: This class handles the SRAT Tracker "Checklist Status" picklist value after updating the SRAT level 1 object.
  @version: 1.0
*/
public with sharing class SRATUpdateController {
    public String CLASS_NAME = UtilConstants.SRATUPD_CONTROL;
    
    /*
*    @Description: Method of MWB
*    @Name : populateSRATinLevel2
*    @param 
*    @return <parameter> - void
*/
        public void populateSRATinLevel2(List<SRAT_Additional_Tracking_Level_2__c> sratLvl2List ){
        List<String> sratL1Ids= new List<String>();
        
        try {
        for(SRAT_Additional_Tracking_Level_2__c sratL2: sratLvl2List ){
            sratL1Ids.add(sratL2.SRAT_Additional_Tracking_Level_1__c);
        }
        Map<Id, SRAT_Additional_Tracking_Level_1__c> sratL1Map = new Map<Id, SRAT_Additional_Tracking_Level_1__c>([SELECT Id, Name, SRAT_Tracker__c FROM 
        SRAT_Additional_Tracking_Level_1__c WHERE ID IN : sratL1Ids limit 5000]);
        for(SRAT_Additional_Tracking_Level_2__c sratLvl2 : sratLvl2List){
            sratLvl2.SRAT_Tracking_Item__c = sratL1Map.get(sratLvl2.SRAT_Additional_Tracking_Level_1__c).SRAT_Tracker__c;
        }
        
        }
        catch(Exception e) {
        
        }
    }
    
    
    /*
*    @Description: Method of MWB
*    @Name : populateOPEXinLevel2
*    @param 
*    @return <parameter> - void
*/
    public void populateOPEXinLevel2(List<Deal_OPEX_Additional_Tracking_Level_2__c > opexLvl2List ){
        List<String> opexL1Ids= new List<String>();
        
        try {
        for(Deal_OPEX_Additional_Tracking_Level_2__c opexL2: opexLvl2List){
            opexL1Ids.add(opexL2.Deal_OPEX_Additional_Tracking_Level_1__c);
        }
        //List<Deal_OPEX_Additional_Tracking_Level_1__c > list2 = [SELECT Id,OPEX_Tracker_del__c  FROM Deal_OPEX_Additional_Tracking_Level_1__c WHERE ID IN : opexLvl2List ];
        Map<Id, Deal_OPEX_Additional_Tracking_Level_1__c > opexL1Map = new Map<Id, Deal_OPEX_Additional_Tracking_Level_1__c >([SELECT Id, Name, OPEX_Tracker_del__c 
        FROM Deal_OPEX_Additional_Tracking_Level_1__c WHERE ID IN : opexL1Ids limit 5000]);
        for(Deal_OPEX_Additional_Tracking_Level_2__c opexLvl2 : opexLvl2List){
            opexLvl2.OPEX_Tracking_Item__c = opexL1Map.get(opexLvl2.Deal_OPEX_Additional_Tracking_Level_1__c).OPEX_Tracker_del__c;
        }
        
        }
        catch(Exception e) {
        
        }
    }
    /**
     * @description       Method for updating the SRAT Tracker level status. 
     * @param             map<id,SRAT_Additional_Tracking_Level_1__c> SRAT_Old_map 
     * @param             List<SRAT_Additional_Tracking_Level_1__c> SRAT_New_List
     * @return            void 
     * @throws            Exception logging
     */
    public void changehecklistStatusLevel1AfterUpdate(map<id,SRAT_Additional_Tracking_Level_1__c > SRAT_Old_map, 
                                                        List<SRAT_Additional_Tracking_Level_1__c> SRAT_New_List) {
        try {
            set < Id > levelIds = new set < Id > ();
            List < SRAT_Tracker__c > SRATList = new List < SRAT_Tracker__c > ();

            for (SRAT_Additional_Tracking_Level_1__c Level_1_List: SRAT_New_list) {
                if ((!(Level_1_List.Overall_RAG_Status__c).equalsIgnoreCase(SRAT_Old_map.get(Level_1_List.id).Overall_RAG_Status__c) || 
                                                Level_1_List.Previous_Item__c != SRAT_Old_map.get(Level_1_List.id).Previous_Item__c)) {
                            levelIds.add(Level_1_List.SRAT_Tracker__c);
                }
            }
            //System.debug('levelIds@@'+levelIds);
            if (levelIds.size() > 0) {
                for (SRAT_Tracker__c sratTrackerList: [SELECT id, checklist_status__c, name 
                                                        FROM SRAT_Tracker__c where id in : levelIds LIMIT 2500]) {
                    if (!(sratTrackerList.checklist_status__c).equalsIgnoreCase(UtilConstants.SUBMITTED)) {
                        sratTrackerList.checklist_status__c = UtilConstants.TASK_STATUS;
                        SRATList.add(sratTrackerList);
                    }
                }
            }
            //System.debug('SRATList##'+SRATList);
            database.update(SRATList);
        } catch (Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB, CLASS_NAME, CLASS_NAME,
            null, System.Logginglevel.ERROR);
        }

    }
    /**
     * @description       Method for updating the checklist status field to in-progress. 
     * @param             map<id,SRAT_Additional_Tracking_Level_2__c> SRAT_Old_map
     * @param             List<SRAT_Additional_Tracking_Level_2__c> SRAT_New_List
     * @return            void 
     * @throws            Exception logging
     */
    public void changehecklistStatusLevel2AfterUpdate(map<id,SRAT_Additional_Tracking_Level_2__c > SRAT_Old_map, 
                                                            List<SRAT_Additional_Tracking_Level_2__c> SRAT_New_List) {
        try {

            set < Id > level2Ids = new set < Id > ();
            List < SRAT_Tracker__c > SRATList = new List < SRAT_Tracker__c > ();

            for (SRAT_Additional_Tracking_Level_2__c Level_2_List: SRAT_New_list) {
                if ((!(Level_2_List.RAG_Status__c).equalsIgnoreCase(SRAT_Old_map.get(Level_2_List.id).RAG_Status__c) || 
                Level_2_List.Comments__c != SRAT_Old_map.get(Level_2_List.id).Comments__c)) {
                    //System.debug('in side IF'+Level_2_List.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c);
                    level2Ids.add(Level_2_List.SRAT_Additional_Tracking_Level_1__c);
                }
            }
            //System.debug('level 2 Ids@@'+level2Ids);
            Set < Id > level2Set = new Set < Id > ();
            for (SRAT_Additional_Tracking_Level_2__c level2: [select id, SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c
            FROM SRAT_Additional_Tracking_Level_2__c where SRAT_Additional_Tracking_Level_1__c in : level2Ids LIMIT 2500]) {

                level2Set.add(level2.SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c);
            }
            if (level2Set.size() > 0) {

                for (SRAT_Tracker__c sratTrackerList: [select id, checklist_status__c, name FROM SRAT_Tracker__c where id in : level2Set LIMIT 2500]) {
                    if (!(sratTrackerList.checklist_status__c).equalsIgnoreCase(UtilConstants.SUBMITTED)) {
                        sratTrackerList.checklist_status__c = UtilConstants.TASK_STATUS;
                        SRATList.add(sratTrackerList);
                    }
                }
            }
            //System.debug('SRATList##'+SRATList);
            database.update(SRATList);
        } catch (Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB, CLASS_NAME, CLASS_NAME,
            null, System.Logginglevel.ERROR);
        }
    }
}