/**
 * Test class for VFC_Deal_Track_Controller
 */
@isTest
private class VFC_Deal_Track_Controller_TEST {
    static User testUser;
    static Deal_Track__c dealtrack;
    static Wave_Plan_Version__c wpv;
    static Deal_TGP__c deal;
    static Review_User_Master__c userMaster;
    static Deal_Location__c dealLoc;
    static Wave_Planning__c wavePlan;
    static Service_Management__c sm;
    static Business_Continuity_Planning__c bcp;
    static BCP_Section_Master__c bcpMaster;
    static String USER_Name1 = 'vc71@testorg.com';
    static KT_Planning__c ktPlan;
    static KT_Planning__c ktPlan1;
    public static void setupData_Construtor() {
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name1);
        Database.insert (testUser);
        userMaster = UTIL_DataCreationForTestClass.getReviewUserMaster('test@test.com', 'test');
        userMaster.SFDC_User__c = testUser.Id;
        userMaster.Is_Active__c = true;
        Database.insert(userMaster);
        deal = UTIL_DataCreationForTestClass.getDealRecord('Test', testUser.Id);
        deal.Governance_Lead_Name_New__c = userMaster.id;
        Database.insert(deal);
        wpv = UTIL_DataCreationForTestClass.getWavePlanVersionRecord('Tracking is On', deal.Id);
        Database.insert(wpv);
        dealtrack = UTIL_DataCreationForTestClass.getDealTrackRecord(wpv.Id, deal.Id, 'Tracking Test');
        Database.insert(dealtrack);
        Client_Geo_Area_Master__c clientGeoMaster = UTIL_DataCreationForTestClass.getClientGEOAreaMaster('Haunsbhavi');
        Database.insert(clientGeoMaster);
        Delievery_Location_Master__c dealLocMaster = UTIL_DataCreationForTestClass.getDelieveryLocationMaster('Haunsbhavi',clientGeoMaster.Id);
        Database.insert(dealLocMaster);
        Deal_Home_Location__c dealHomeLoc = UTIL_DataCreationForTestClass.getDealHomeLocation(dealLocMaster.Id, deal.Id);
        Database.insert(dealHomeLoc);
        dealLoc = UTIL_DataCreationForTestClass.getDealLocation('Haunsbhavi', dealHomeLoc.Id, wpv.Id);
        Database.insert(dealLoc);
        wavePlan = UTIL_DataCreationForTestClass.getWavePlanning(dealLoc.Id, System.today(), 'Test');
        Database.insert(wavePlan);
        Offerings_Master__c offMaster = UTIL_DataCreationForTestClass.getOfferingMaster('Damodar');
        Database.insert(offMaster);
        Client_Specific_Process_Mapping__c clientProcessMaping = UTIL_DataCreationForTestClass.getClientSpecificProcessMapping('Tesr Process', deal.Id, offMaster.Id);
        Database.insert(clientProcessMaping);
        Wave_Process__c waveProcess = UTIL_DataCreationForTestClass.getWaveProcess(wavePlan.Id);
        waveProcess.Client_Specific_Process_Mapping__c = clientProcessMaping.ID;
        Database.insert(waveProcess);
        Commercial_Plan_Activity_Master__c commPlanActivityMaster = UTIL_DataCreationForTestClass.getcommPlanActivityMaster('Test23', 1234);
        Database.insert(commPlanActivityMaster);
        Commercial_Planning__c commPlaning = UTIL_DataCreationForTestClass.getWaveCommercialPlanning('Test',commPlanActivityMaster.Id,1234);
        commPlaning.Delivery_Location__c = dealLocMaster.Id;
        commPlaning.Wave_Plan_Version__c = wpv.Id;
        Database.insert(commPlaning);
        Contract_Legal_Infosec_Section_Master__c contractLegalInfosecSectionMaster = UTIL_DataCreationForTestClass.getLegalInfosecSectionMaster('Test', '10');
        Database.insert(contractLegalInfosecSectionMaster);
        Contract_Legal_Infosec__c contractLegalInfosec = UTIL_DataCreationForTestClass.getContractLegalInfosec();
        contractLegalInfosec.Wave_Plan_Version__c = wpv.Id;
        //contractLegalInfosec.Contract_Legal_Infosec_Completion_Status__c = 0;
        contractLegalInfosec.Deal_Home_Location_lk__c = dealHomeLoc.Id;
        contractLegalInfosec.Deal_Location_lk__c = dealLoc.Id;
        contractLegalInfosec.Delivery_Location__c = dealLocMaster.Id;
        contractLegalInfosec.Wave_Plan_lk__c = wavePlan.Id;
        contractLegalInfosec.Wave_Plan_Version__c = wpv.Id;
        Database.insert(contractLegalInfosec);
        Journey_Management__c jm = UTIL_DataCreationForTestClass.getJourneyManagement('10', '11');
        Database.insert(jm);
        sm = UTIL_DataCreationForTestClass.getServiceManagement(wavePlan.Id, dealLoc.Id, 'Test', 'Test', system.today(), system.today().addDays(5));
        sm.Wave_Plan_Version__c = wpv.Id;
        Database.insert(sm);
        Service_Management_Master__c smMaster = UTIL_DataCreationForTestClass.getServiceManagementMaster('Test', 187);
        Database.insert(smMaster);
        bcpMaster = UTIL_DataCreationForTestClass.getBCPSectionMaster('0123', 0, '0123');
        Database.insert(bcpMaster);
        Mob_User_Roles_Master__c strMoURM=  UTIL_DataCreationForTestClass.getMobUserRoleMaster('Global Mobilization Lead');
        Database.insert (strMoURM);
        MOB_User_Role_Assignment__c mobUserAssignment = UTIL_DataCreationForTestClass.getMobUserRoleAssignment();
        mobUserAssignment.Deal__c = Deal.id;
        mobUserAssignment.Mob_User_Roles_Master__c = strMoURM.Id;
        mobUserAssignment.Role_Name__c = 'Global Mobilization Lead';
        mobUserAssignment.User_Assigned_New__c = userMaster.Id;
        mobUserAssignment.Access_Level__c = 'Edit';
        Database.insert(mobUserAssignment);
    }
    public static void sratSetupData() {
        SRAT__c srat = UTIL_DataCreationForTestClass.getSRAT();
        srat.Wave_Plan_Version__c = wpv.Id;
        srat.Deal_Location_lk__c = dealLoc.id;
        srat.Wave_Plan_lk__c = wavePlan.id;
        srat.Name = 'Test';
        Database.insert(srat);
    }
    public static void ktSetupData() {
        ktPlan = UTIL_DataCreationForTestClass.getKTPlanning('Test', system.today(), system.today().addDays(5), wavePlan.id, dealLoc.id);
        ktPlan.Wave_Plan_Version__c = wpv.Id;
        Database.insert(ktPlan);
        ktPlan1 = UTIL_DataCreationForTestClass.getKTPlanning('Test1', system.today(), system.today().addDays(15), wavePlan.id, dealLoc.id);
        ktPlan.Wave_Plan_Version__c = wpv.Id;
        Database.insert(ktPlan1);
    }
    public static void recruitmentSetupData() {
        Recruitment_Tracking__c rt = UTIL_DataCreationForTestClass.getRecruitmentTracking(dealLoc.id, wavePlan.id, 'Test', 'Dummy', system.today(), system.today().addDays(5), 5);
        rt.Wave_Plan_Version__c = wpv.Id;
        Database.insert(rt);
    }
    public static void opexSetupData() {
        OPEX__c opex = UTIL_DataCreationForTestClass.getOpexRec('Tesst', system.today().addDays(5), dealLoc.id, wavePlan.id);
        opex.Active__c = true;
        opex.Wave_Plan_Version__c = wpv.Id;
        Database.insert(opex);
    }
    public static void smSetupData() {
        Service_Management__c service = UTIL_DataCreationForTestClass.getServiceManagement(wavePlan.id, dealLoc.id, 'Test name', 'Dummy', system.today(), system.today().addDays(5));
        service.Wave_Plan_Version__c = wpv.Id;
        Database.insert(service);
        sm.Phase_ID__c = service.Id;
        Database.update(sm);
    }
    public static void journeyMagSetupData() {
        Journey_Management_Planning__c journey = UTIL_DataCreationForTestClass.getJourneyManagementPlanning();
        journey.Wave_Plan_Version__c = wpv.Id;
        Database.insert(journey);
    }
    public static void techSetupData() {
        Tech_Assessment__c techAssement = UTIL_DataCreationForTestClass.getTechAssessment('Test', 'Dummy', system.today(), system.today().addDays(5), wavePlan.id, dealLoc.id);
        techAssement.Wave_Plan_Version__c = wpv.Id;
        Database.insert(techAssement);
    }
    public static void bcpSetupData() {
        bcp = UTIL_DataCreationForTestClass.getbusinessContinuityPlanning(wpv.Id);
        bcp.BCP_Section_Master_Id__c = bcpMaster.Id;
        Database.insert(bcp);
    }
    static testMethod void construtorUnitTest() {
        setupData_Construtor();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfContract();
            dealTrackController.SaveDealTrackFields();
            dealTrackController.SaveGoLivePlan();
            dealTrackController.SaveContractLegalInfosec();
        Test.stopTest();
    }
    static testMethod void commericalPlanUnitTest() {
        setupData_Construtor();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfCommercialPlan();
            dealTrackController.SaveCommercialPlan();
            
        Test.stopTest();
    }
    static testMethod void sratUnitTest() {
        setupData_Construtor();
        sratSetupData();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.sRAT_Controller();
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfSRAT();
            dealTrackController.SaveSRAT();
        Test.stopTest();
    }
    static testMethod void ktUnitTest() {
        setupData_Construtor();
        ktSetupData();
        
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            VFC_Deal_Track_Controller.KTPlanLocation innerObj = new VFC_Deal_Track_Controller.KTPlanLocation(ktPlan,'red',true,'green');
            List<VFC_Deal_Track_Controller.KTPlanLocation> innerObjList = new List<VFC_Deal_Track_Controller.KTPlanLocation>();
            innerObjList.add(innerObj);
            dealTrackController.kT_Construtor();
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfKTPlan();
            //innerObj.ListOfKTPlanLocation = innerObjList;
            dealTrackController.SaveKTPlan();
        Test.stopTest();
    }
    static testMethod void recruitmentUnitTest() {
        setupData_Construtor();
        recruitmentSetupData();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.recruitment_Constructor();
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfRecruitmentTracking();
            dealTrackController.SaveRecruitmentPlan();
        Test.stopTest();
    }
     static testMethod void opexUnitTest() {
        setupData_Construtor();
        opexSetupData();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.oPEX_Construtor();
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfOPEX();
            dealTrackController.SaveOppMaturity();
        Test.stopTest();
    }
    static testMethod void smUnitTest() {
        setupData_Construtor();
        smSetupData();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.serviceManagement_Construtor();
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfService();
            dealTrackController.SaveServiceMgmt();
            VFC_Deal_Track_Controller.ServiceManagement smController = new VFC_Deal_Track_Controller.ServiceManagement(sm,false,'Red');
        Test.stopTest();
    }
    static testMethod void jMPUnitTest() {
        setupData_Construtor();
        journeyMagSetupData();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.journeyManagementConstrutor();
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfJourney();
            dealTrackController.SaveJourneyManagement();
        Test.stopTest();
    }
    static testMethod void techAssmentUnitTest() {
        setupData_Construtor();
        techSetupData();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.techAssementConstructor();
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfTechAssessment();
            dealTrackController.SaveTechEnablement();
        Test.stopTest();
    }
    static testMethod void bcpUnitTest() {
        setupData_Construtor();
        bcpSetupData();
        Test.startTest();
            ApexPages.StandardController controller= new ApexPages.StandardController(dealtrack);
            VFC_Deal_Track_Controller dealTrackController = new VFC_Deal_Track_Controller(controller);
            dealTrackController.bcpPlan_Constructor();
            dealTrackController.getListOfDealLocation();
            dealTrackController.getListOfWavePlanning();
            dealTrackController.getListOfWaveProcess();
            dealTrackController.getListOfBCP();
            dealTrackController.SaveBCPPlan();
            VFC_Deal_Track_Controller.BusinessContinuity  bcplan = new VFC_Deal_Track_Controller.BusinessContinuity(bcp, false,'Red');
        Test.stopTest();
    }
}