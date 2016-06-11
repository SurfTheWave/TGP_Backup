/*
* Test Class to cover the trigger
*/
@isTest
private class TriggerTest {
    
    public static Deal_TGP__c testRec12;
    
    static testMethod void setUP() {
    
        testRec12 = new Deal_TGP__c(Name = 'test');
        insert testRec12;
    
        
    }

    static testMethod void testAccessPermissionDeal() {
        Deal_TGP__c dealTGPRec = new Deal_TGP__c(Deal_RAG_Status__c = 'Red',Deal_Status__c ='New',CommentForDealTracking__c = 'Test',Approval_Status__c = true);
        dealTGPRec.Name = 'Test Data';
        insert dealTGPRec ;
        Test.startTest();
           dealTGPRec.Offerings__c= 'Test';
           update dealTGPRec;
        Test.stopTest();
    }
    static testMethod void testPreventclientGeoUnitDuplicateNames_Insert() {
        Client_Geo_Unit_Master__c testRec = new Client_Geo_Unit_Master__c(Name ='Test Geo Unit', Active__c = true, Client_Geo_Unit_Description__c = 'Dummy');
        Client_Geo_Unit_Master__c testRec1 = new Client_Geo_Unit_Master__c(Name ='Test Geo Unit', Active__c = true, Client_Geo_Unit_Description__c = 'Dummy');
        Test.startTest();
            insert testRec;
            insert testRec1;
        Test.stopTest();
    }
    static testMethod void testPreventclientGeoUnitDuplicateNames_Update() {
        Client_Geo_Unit_Master__c testRec = new Client_Geo_Unit_Master__c(Name ='Test Geo Unit', Active__c = true, Client_Geo_Unit_Description__c = 'Dummy');
        insert testRec;
        Test.startTest();
            testRec.Client_Geo_Unit_Description__c ='Dummy2';
            update testRec;
        Test.stopTest();
    }
    static testMethod void testPreventclientGeoUnitDuplicateNames_delete() {
        Client_Geo_Unit_Master__c testRec = new Client_Geo_Unit_Master__c(Name ='Test Geo Unit', Active__c = true, Client_Geo_Unit_Description__c = 'Dummy');
        insert testRec;
        Test.startTest();
            delete testRec;
        Test.stopTest();
    }
    static testMethod void updatePhaseOnWPVServicePlanningTest() {
        Service_Management_Master__c testRec = new Service_Management_Master__c(Is_Active__c = true, Number_of_spaces__c = 2, Phase_Name__c ='Test157', Phase_Number__c = 157);
        insert testRec;
        Test.startTest();
            testRec.Phase_Number__c = 142;
            update TestRec;
        Test.stopTest();
    }
    static testMethod void updateSectionOnWPVBusinessContinuityPlanningTest() {
        BCP_Section_Master__c testRec = new BCP_Section_Master__c(Is_Active__c = true, Section_Name__c = 'Test124', Section_Number__c = '1243');
        insert testRec;
        Test.startTest();
            testRec.Section_Number__c = '1420';
            update TestRec;
        Test.stopTest();
    }
    static testMethod void updateSectionOnWPVJourneyPlanningTest() {
        Journey_Management__c testRec = new Journey_Management__c(Is_Active__c = true, Section_Name__c = 'Test124', Section_Number__c = '1243');
        insert testRec;
        Test.startTest();
            testRec.Section_Number__c = '1420';
            update TestRec;
        Test.stopTest();
    }
    static testMethod void updateUserRolesOnDealTest() {
        Mob_User_Roles_Master__c testRec = new Mob_User_Roles_Master__c(Access_Level__c = 'edit', Role_Name__c = 'Test124');
        Test.startTest();
            insert testRec;
            testRec.Access_Level__c = 'Read';
            update TestRec;
            delete TestRec;
        Test.stopTest();
    }
    static testMethod void updateActivityOnWPVCommercialPlanTest() {
        Commercial_Plan_Activity_Master__c testRec = new Commercial_Plan_Activity_Master__c(Is_Active__c = true, Activity_Name__c = 'Test124', Activity_Order__c=1234);
        //insert testRec;
        Test.startTest();
            insert testRec;
            testRec.Activity_Name__c = 'Test1241';
            update TestRec;
            delete TestRec;
        Test.stopTest();
    }
    static testMethod void updateActivityOnWPVTechAssessmentTest() {
        Tech_Assessment_Activity_Master__c testRec = new Tech_Assessment_Activity_Master__c(name = 'test',Activity_Order__c=1234);
        //insert testRec;
        Test.startTest();
            insert testRec;
            testRec.name = 'Test1241';
            update TestRec;
            delete TestRec;
        Test.stopTest();
    }
    static testMethod void updateItemOnWPV_SRATTest() {
        SRAT_Item_Master__c  testRec = new SRAT_Item_Master__c(Days_Before_Go_Live_Date__c = -1,Item_Name__c = 'test');
        //insert testRec;
        Test.startTest();
            insert testRec;
            testRec.Item_Name__c = 'testRec';
            update TestRec;
            delete TestRec;
        Test.stopTest();
    }
    static testMethod void saveSRATVersionTest() {
        SRAT_VERSION__c testRec = new SRAT_VERSION__c(isActive__c = true,SRAT_Name__c = 'test',Active_Modified_Date__c = system.today());
        //insert testRec;
        Test.startTest();
            insert testRec;
            
        Test.stopTest();
    }
    static testMethod void saveOpexItemMasterTest() {
        OPEX_Item_master__c testRec = new OPEX_Item_master__c(Days_After_Go_Live_Date__c=2,Item_Name__c='test');
        //insert testRec;
        Test.startTest();
            insert testRec;
            testRec.Item_Name__c = 'test2';
            update testRec;
            
            delete testRec;
            
            
        Test.stopTest();
    }
    
    static testMethod void clientGEOTest() {
    
        Opportunity_TGP__c oppRec = new Opportunity_TGP__c();
        Client_Geo_Area_Master__c testRec = new Client_Geo_Area_Master__c(Name = 'test');
        //insert testRec;
        Test.startTest();
            insert testRec;
            testRec.Name = 'test2';
            update testRec;
            
            delete testRec;
            
            
        Test.stopTest();
    }
    /*static testMethod void dealTGPTest() {
    
        //Deal_TGP__c oppRec = new Deal_TGP__c();
        testRec12 = new Deal_TGP__c(Name = 'test');
        //insert testRec;
        Test.startTest();
        
            insert testRec12;
                       
            
        Test.stopTest();
    }*/
    static testMethod void dealTGPTest1() {
    
        setUP();
    
        Test.startTest();
            
            testRec12.Name = 'test2';
            
            update testRec12;
            
            delete testRec12;
            
            
        Test.stopTest();
    }
    
    static testMethod void KTPlanningActivityMaster() {
        KT_Planning_Activity_Master__c testRec = new KT_Planning_Activity_Master__c(Name = 't',Activity_Order__c=1234);
        testRec.Name = 'Test Data';
        insert testRec;
        Test.startTest();
           testRec.Name = 'Test';
           update testRec;
        Test.stopTest();
    }
     static testMethod void operatingGroupMaster() {
        Operating_Group_Master__c testRec = new Operating_Group_Master__c(Name = 't');
        testRec.Name = 'Test Data';
        
        Test.startTest();
        insert testRec;
           testRec.Name = 'Test';
           update testRec;
        Test.stopTest();
    }
    
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   
   static testMethod void commentsOnHomePage() {
    
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        user testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
    
        Client_Master__c clientMasterObj = UTIL_DataCreationForTestClass.getClientMaster('test');
        insert clientMasterObj;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientMasterObj.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
      insert oppTGP;
      


        Comments_on_Opportunity__c testRec = new Comments_on_Opportunity__c(Name = 't');
        testRec.Name = 'Test Data';
        testRec.BPO_Opportunity__c = oppTGP.id;
        
        Test.startTest();
            insert testRec;
            testRec.Name = 'Test';
           update testRec;
           delete testRec;
        Test.stopTest();
    }
    
}