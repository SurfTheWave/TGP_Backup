/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class solutionTabControllerNewTest {
    static Opportunity_Offering__c solution;
    static Service_Delivery_Location__c serDelLoc;
    static Review_User_Master__c testUserMaster;
    static Assumption__c assump;
    static Client_Dependency__c clientDepend;
    static Category__c cat;
    static Service_Master__c serMaster;
    static Offerings_Master__c offMaster;
    static Services__c service;
    static Opportunity_Role_master__c oppRoleRec;
    public static void setupData() {
        Client_Master__c clientName = new Client_Master__c (Name = 'TestObject1');
        insert clientName;
        Client_Geo_Area_Master__c clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
        insert clientGeoArea;
        Operating_Group_Master__c operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
        insert operatingGroup;
        Client_Geo_Unit_Master__c clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
        insert clientGeoUnit;
        Opportunity_TGP__c oppRecord = UTIL_DataCreationForTestClass.getBPOOpportunityRecord('Test','1',clientName.Id,clientGeoArea.Id,operatingGroup.Id,'Low',true,'Won');
        insert oppRecord;
        offMaster = UTIL_DataCreationForTestClass.getOfferingMaster('Test');
        insert offMaster;
        solution = UTIL_DataCreationForTestClass.getOfferingRecord('Test', oppRecord.Id);
        solution.Offering_Text_Name__c ='Test';
        insert solution;
        Delievery_Location_Master__c delLocMaster = UTIL_DataCreationForTestClass.getDelieveryLocationMaster('Test', clientGeoArea.Id);
        delLocMaster.Active__c = true;
        insert delLocMaster;
        Delievery_Location_Master__c delLocMaster1 = UTIL_DataCreationForTestClass.getDelieveryLocationMaster('Test1', clientGeoArea.Id);
        delLocMaster1.Active__c = true;
        insert delLocMaster1;
        serDelLoc = UTIL_DataCreationForTestClass.getServiceDeliveryLocation('Test', solution.Id);
        insert serDelLoc;
        Delivery_Location__c delLocation = UTIL_DataCreationForTestClass.getdelLoc(solution.Id, serDelLoc.Id);
        delLocation.Delivery_Location_Master__c = delLocMaster.Id;
        insert delLocation;
        serMaster = UTIL_DataCreationForTestClass.getServiceMasterRecord('Test', offMaster, true);
        insert serMaster;
        Service_Delivery_Location__c serDealLocation = UTIL_DataCreationForTestClass.getServiceDeliveryLocation('Test', solution.Id);
        serDealLocation.Service_Master__c = serMaster.Id;
        insert serDealLocation;
        service = UTIL_DataCreationForTestClass.getServices('Test', serMaster.Id, 'Conditional', solution.Id, serDealLocation.id);
        insert service;
        clientDepend = UTIL_DataCreationForTestClass.getClientDependency('Test', solution.Id);
        insert clientDepend;
        oppRoleRec = new Opportunity_Role_master__c();
        oppRoleRec.Name = 'Solution Architect - BPO';
        insert oppRoleRec;
    }
    public static void setupDate2() {
        testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true, SFDC_User__c = Userinfo.getUserId(),
                                                    Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com');
        insert  testUserMaster; 
        /*Service_Master__c serMas =    UTIL_DataCreationForTestClass.getServiceMaster(offMaster.Id);
        serMas.Active__c = true;
        serMas.Name =   'Damodar';
        insert serMas;*/
    }
    public static void setupDate3() {
        assump = UTIL_DataCreationForTestClass.getAssumptionRecord('Test', solution.Id);
        insert assump;
        cat = UTIL_DataCreationForTestClass.getcategoryMaster('Test');
        insert cat;
        Client_Dependency_Master__c clientDependMaster = UTIL_DataCreationForTestClass.getclientDependencyMaster(cat.Id, clientDepend.Id);
        clientDependMaster.Active_Inactive__c = true;
        insert clientDependMaster;
        Assumption_Master__c assMaster = UTIL_DataCreationForTestClass.getAssumptionMaster(cat.Id, 'Test');
        assMaster.Offering__c = offMaster.Id;
        assMaster.Category_Master__c = cat.Id;
        insert assMaster;
        Assumption__c assum = UTIL_DataCreationForTestClass.getAssumptionRecord('Test', solution.Id);
        assum.Assumption_Master__c = assMaster.Id;
        assum.Category_Master__c = cat.Id;
        assum.Offering_Master__c = offMaster.Id;
        insert assum;
        
    }
    public static void setup4() {
        cat = UTIL_DataCreationForTestClass.getcategoryMaster('Test');
        insert cat;
        Risk_Master__c riskMaster = UTIL_DataCreationForTestClass.getriskMaster();
        riskMaster.Category_Master__c = cat.Id;
        riskMaster.Offering_Master__c = offMaster.Id;
        //riskMaster.Service_Master__c = serMaster.Id;
        riskMaster.Active_Inactive__c = true;
        insert riskMaster;
    }
    public static void setup5() {
        Third_Party_Vendor_Master_Custom__c thirdParty = UTIL_DataCreationForTestClass.getThirdPartyVendorMaster('Dummy');
        thirdParty.Offering_Master__c = offMaster.Id;
        thirdParty.Comments__c = 'I hate writing test class';
        insert thirdParty;
        Third_Party_Vendor_Master_Custom__c thirdParty1 = UTIL_DataCreationForTestClass.getThirdPartyVendorMaster('Dummy');
        thirdParty1.Offering_Master__c = offMaster.Id;
        thirdParty1.Comments__c = 'I hate writing test class';
        insert thirdParty1;
    }
    static testMethod void constructorUnitTest() {
        setupData();
        ApexPages.currentPage().getParameters().put(UTIL_Constants.SERVICE_NAME,'TestId');
        ApexPages.currentPage().getParameters().put(UTIL_Constants.OFF_ID,solution.Id);
        ApexPages.currentPage().getParameters().put(UTIL_Constants.SERVICE_ID,serDelLoc.id);
        Test.startTest();
            Solution_tabController controler = new Solution_tabController();
            controler.Cancel();
            controler.listAllRecordsForClientDependency();
            controler.saveDeliveryLocation();
            
        Test.stopTest();
    }
    static testMethod void paraConstructorUnitTest() {
        setupData();
        setupDate2();
        ApexPages.currentPage().getParameters().put('id', solution.id);
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(solution);
            Solution_tabController  solTabContr = new Solution_tabController (sc);
            solTabContr.cancelNow();
            solTabContr.oppServices = 'Damodar';
            solTabContr.addNewOppOfferForServiceComponent();
            solTabContr.doc1.Body = Blob.valueOf('I am a test');
            solTabContr.doc1.Name ='Damodar';
            solTabContr.upload();
            solTabContr.saverecord();
            solTabContr.edit1();
            solTabcontr.oppOffering = solution;
            solTabcontr.oppOffering .Domain_Expert_Functional_Architect_1_New__c = testUserMaster.Id;
            solTabContr.edit1();
            solTabcontr.oppOffering .Domain_Expert_Functional_Architect_2_New__c= testUserMaster.Id;
            solTabContr.edit1();
            solTabcontr.oppOffering .Domain_Expert_Functional_Architect_3_New__c= testUserMaster.Id;
            solTabContr.edit1();
            solTabContr.saverecordOfferingUser();
            solTabContr.cancelRecord();
            solTabContr.saveNow();
            List<SelectOption> tst = solTabContr.getServicesForServiceComponent();
        Test.stopTest();
    }
    static testMethod void scopeUnitTest() {
        setupData();
        ApexPages.currentPage().getParameters().put('id', solution.id);
        List<String> tst = new List<string>();
        tst.add('Test');
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(solution);
            Solution_tabController  solTabContr = new Solution_tabController (sc);
            solTabContr.cancelNowForServiceComponent();
            solTabContr.oppServices = 'Damodar';
            solTabContr.thirdPartyvendor = tst;
            solTabContr.saverecord();
            solTabContr.saveAccProfileDetailsForServiceComponent();
            solTabContr.addNewOppOfferForServiceComponent();
            solTabContr.plus1();
            solTabContr.plus2();
            solTabContr.plus3();
            solTabContr.plus4();
            
            solTabContr.setOtherComments();
        Test.stopTest();
    }
    static testMethod void assumptionUnitTest() {
        setupData();
        setupDate3();
        ApexPages.currentPage().getParameters().put('id', solution.id);
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(solution);
            Solution_tabController  solTabContr = new Solution_tabController (sc);
            solTabContr.oppServices = 'Damodar';
            solTabContr.getAssumption();
            solTabContr.applyFilter();
            solTabContr.clearFilter();
            solTabContr.saveAccProfileDetails();
            solTabContr.doCancel();
            solTabContr.toggleSort();
            solTabContr.fileIdDelete = assump.Id;
            solTabContr.deleteFileForAssumptions();
            solTabContr.addNewOppOffer();
            solTabContr.deleteFile();
            solTabContr.getServiceDeliveryModel();
        Test.stopTest();
    }
    static testMethod void clientUnitTest() {
        setupData();
        setupDate3();
        ApexPages.currentPage().getParameters().put('id', solution.id);
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(solution);
            Solution_tabController  solTabContr = new Solution_tabController (sc);
            solTabContr.getClientDependency();
            solTabContr.starting();
            solTabContr.ending();
            solTabContr.addButtonRender = false;
            solTabContr.saveEditButtonRender = false;
            solTabContr.sortField = null;
            solTabContr.clientDependencyControllerConstructor();
            solTabContr.clearFilterForClientDependency();
            solTabContr.runSearchForClientDependency();
            solTabContr.saveAccProfileDetailsForClientDependency();
            solTabContr.doCancelForClientDependency();
            solTabContr.toggleSortForClientDependency();
            solTabContr.clientDependencyCall();
            solTabContr.newClientDependency = clientDepend;
            solTabContr.addNewOppOfferForClientDependency();
            solTabContr.saveAccProfileDetailsForClientDependency();
            solTabContr.deleteFileForClientDependency();
        Test.stopTest();
     }
     static testMethod void nonStandardUnitTest()  {
        setupData();
        setup4();
        ApexPages.currentPage().getParameters().put('id', solution.id);
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(solution);
            Solution_tabController  solTabContr = new Solution_tabController (sc);
            solTabContr.getClientDependency();
            solTabContr.addSolCharEdit();
            solTabContr.saverecordForNonStandaredScopeTab();
            solTabContr.cancelrecordNonStandaredScopeTab();
            solTabContr.cancelNow();
            solTabContr.getRisk();
        Test.stopTest();
     }
    static testMethod void nonCoveredUnitTest() {
        setupData();
        setupDate3();
        setup5();
        ApexPages.currentPage().getParameters().put('id', solution.id);
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(solution);
            Solution_tabController  solTabContr = new Solution_tabController (sc);
            solTabContr.fileIdDelete = service.Id;
            solTabContr.deleteFileForServiceComponent();
            solTabContr.ExportClientDependency();
            solTabContr.getlstAssume1();
            List<SelectOption> te = solTabContr.getServicesdrop();
            List<SelectOption> te1 = solTabContr.getServicesFilter();
            List<SelectOption> te11 = solTabContr.getCategory();
            List<SelectOption> te12 = solTabContr.getCategoryFilter();
            solTabContr.backToOffer();
            solTabContr.cat = cat.Id;
            solTabContr.runSearch();
            solTabContr.edit = true;
            solTabContr.cat = null;
            solTabContr.app = true;
            solTabContr.categoryMasterFilter = 'All';
            solTabContr.edit = false;
            solTabContr.app = false;
            solTabContr.ServiceFilter = 'Common';
            solTabContr.runSearch();
            List<SelectOption> te13 = solTabContr.getThirdPartyVendorName();
            solTabContr.getthirdPartyvendor();
            solTabContr.setFileIdDelete(assump.Id);
            solTabContr.getFileIdDelete();
            String tst3 = solTabContr.debugSoql;
            //solTabContr.getDisplay1();
            solTabContr.comments = 'Kill';
            //solTabContr.comments();
        Test.stopTest();
      }
}