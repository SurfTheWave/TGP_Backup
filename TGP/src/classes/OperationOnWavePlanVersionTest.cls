/*
Author : Komal Priya  
Description :Test class for all the trigger operations on opportunity.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
@isTest
private class OperationOnWavePlanVersionTest{

    private static Deal_TGP__c  deal;
    private static Deal_TGP__c  deal1;
    private static Profile p;
    private static Profile p1;
    private static User u;
    private static User u1;
    private static Wave_Plan_Version__c wavePlanVer;
    private static Wave_Plan_Version__c wavePlanVer1;
    private static final string ACTIVITY = 'TestActivity';
    private static final string PHASE_NAME = 'testPhaseName';
    private static final string SER_MGMT_TASK_MASTER_NAME = 'TestMaster';
    private static final integer PHASE_NO = 10;
    private static final integer TASK_NO = 2;
    private static final string TASK_NO_NEW = '2';
    private static final string INFOSEC_SECTION_MASTER_NAME = 'TestMaster';
    private static final string DELIVERABLE_NAME = 'DeliverableTest';
    private static Commercial_Plan_Activity_Master__c commPlanMaster;
    private static Service_Management_Task_Master__c serMgmTaskMaster;
    private static Service_Management_Master__c serMgmMaster;
    private static Contract_Legal_Infosec_Task_Master__c conLegalInfotaskMaster;
    private static Contract_Legal_Infosec_Section_Master__c conLegalInfotasSeckMaster;
    private static Journey_Management__c jrnyManagement;
    private static Journey_Management_Deliverable__c jrnyMgmDeliverables;
    private static Wave_Planning__c wavePlanning;
    private static BCP_Section_Master__c BCPSectionMaster;
    private static BCP_Task_Master__c BCPTskMaster;
    private static Deal_Home_Location__c dealHomeLoc;
    private static Delievery_Location_Master__c delLocMaster;
    private static Client_Geo_Area_Master__c clientGeoArea;
    private static string USER_NAME = 'vc12@testorg.com';
    private static string USER_NAME_NEW = 'vc13@testorg.com';
     /*
    *   @Method : setupData
    *   @ Description : This method will create test data
    */
     static void setupData(){
     
         p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
         
         p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
        
         u =UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
         Database.insert(u, false);
         
         u1 =UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_NAME_NEW);
         Database.insert(u1, false);
         
         deal = UTIL_DataCreationForTestClass.getDealRecord(UTIL_Constants.TEST,u.id);
         Database.insert(deal, false);
         
         deal1 = UTIL_DataCreationForTestClass.getDealRecord(UTIL_Constants.TEST,u.id);
         Database.insert(deal1, false);
         
         clientGeoArea = UTIL_DataCreationForTestClass.getClientGEOAreaMaster(UTIL_Constants.AsiaPacific);
         Database.insert(clientGeoArea, false);
         
         commPlanMaster = UTIL_DataCreationForTestClass.getcommPlanActivityMaster(ACTIVITY,125);
         Database.insert(commPlanMaster, false);
         
         serMgmMaster = UTIL_DataCreationForTestClass.getServiceManagementMaster(PHASE_NAME,PHASE_NO);
         Database.insert(serMgmMaster, false);
         
         serMgmTaskMaster =  UTIL_DataCreationForTestClass.getServiceManagementTaskMaster(serMgmMaster.id,SER_MGMT_TASK_MASTER_NAME,TASK_NO);
         Database.insert(serMgmTaskMaster, false);
         
         serMgmTaskMaster.Task_Name__c = 'testTaskName';
         update serMgmTaskMaster;
         
         conLegalInfotasSeckMaster = UTIL_DataCreationForTestClass.getLegalInfosecSectionMaster(INFOSEC_SECTION_MASTER_NAME,TASK_NO_NEW);
         Database.insert(conLegalInfotasSeckMaster, false);
         
         conLegalInfotaskMaster = UTIL_DataCreationForTestClass.getcontractLegalInfosecTaskMaster(conLegalInfotasSeckMaster.id,INFOSEC_SECTION_MASTER_NAME,TASK_NO_NEW);
         Database.insert(conLegalInfotaskMaster, false);
         
         jrnyManagement = UTIL_DataCreationForTestClass.getJourneyManagement(INFOSEC_SECTION_MASTER_NAME,TASK_NO_NEW);
         Database.insert(jrnyManagement, false);
         
         jrnyMgmDeliverables = UTIL_DataCreationForTestClass.getJourneyManagementDeliverables(DELIVERABLE_NAME,TASK_NO_NEW,jrnyManagement.id);
         Database.insert(jrnyMgmDeliverables, false);
         
         BCPSectionMaster = UTIL_DataCreationForTestClass.getBCPSectionMaster(SER_MGMT_TASK_MASTER_NAME,TASK_NO,TASK_NO_NEW);
         Database.insert(BCPSectionMaster, false);
         
         BCPTskMaster = UTIL_DataCreationForTestClass.getBCPTaskMaster(BCPSectionMaster.id,TASK_NO,TASK_NO_NEW);
         BCPTskMaster.Is_Active__c = true;
         Database.insert(BCPTskMaster, false);
         
         wavePlanVer1 = UTIL_DataCreationForTestClass.getWavePlanVersionRecord(UTIL_Constants.TRACKING_IS_OFF,deal.id);
         wavePlanVer1.Active__c = true;
         Database.insert(wavePlanVer1, false);
         
         Commercial_Planning__c commPlan = UTIL_DataCreationForTestClass.getWaveCommercialPlanning(UTIL_Constants.COMM_PLAN_NAME,ACTIVITY,45);
         commPlan.Wave_Plan_Version__c = wavePlanVer1.id;
         Database.insert(commPlan, false);
         
         
         Journey_Management_Planning__c jrnyMgmntPlanning = UTIL_DataCreationForTestClass.getJourneyManagementPlanning();
         jrnyMgmntPlanning.Wave_Plan_Version__c = wavePlanVer1.id;
         Database.insert(jrnyMgmntPlanning, false);
         
         delLocMaster = UTIL_DataCreationForTestClass.getDelieveryLocationMaster(DELIVERABLE_NAME,clientGeoArea.id);
         Database.insert(delLocMaster, false);
         
         dealHomeLoc = UTIL_DataCreationForTestClass.getDealHomeLocation(delLocMaster.id,deal1.id);
         Database.insert(dealHomeLoc, false);
     }
     
     /*
    *   @Method : testOperationOnWavePlanVersion
    *   @ Description : This method will create wave plan version record
    */
     static testMethod void testOperationOnWavePlanVersion(){
         
        setupData();
        test.starttest();
        System.runAs(u1)
        {
             wavePlanVer = UTIL_DataCreationForTestClass.getWavePlanVersionRecord(UTIL_Constants.TRACKING_IS_ON,deal1.id);
             wavePlanVer.Active__c = true;
             Database.insert(wavePlanVer, false);
             
             wavePlanVer.Name = UTIL_Constants.TEST;
             Database.update(wavePlanVer, false);
             
             List<Wave_Plan_Version__c > wavePlanVerList = [select Display_tracking_message__c,id from Wave_Plan_Version__c where id = : wavePlanVer.id limit 50];
         
         }      
        test.stoptest();
     }
}