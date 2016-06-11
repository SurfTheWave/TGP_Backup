/*
    Author : Shridhar Patankar
    Story  : Story-0043/SOL_010  
    Description : Test Class for assumptionInlineController. 

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------


    */
    @isTest
        private class RiskInlineControllerTest{
    static User testUser; 
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    static Service_Master__c serviceMaster; 
    static Assumption_Master__c assumptionMaster;
    static Offerings_Master__c offeringMaster;
    static Opportunity_Offering__c oppOffering;
    static Assumption__c assumption;
    static Risk_Master__c riskMaster;
    static Risk__c risk;
    static ApexPages.StandardController sc;
    public static void setupData(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);

    clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
    insert clientName;

    clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
    insert clientGeoArea;

    operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
    insert operatingGroup;

    clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
    insert clientGeoUnit;

    oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
    Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
    Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
    insert oppTGP;



    offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
    insert offeringMaster;

    oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
    insert oppOffering;

    serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
    insert serviceMaster;

    assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
    insert assumptionMaster;

    assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
    insert assumption;

    riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true);
    insert riskMaster;

    risk = new Risk__c (Name = 'TestRisk',Risk_Master__c = riskMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
    insert risk;
    sc = new ApexPages.StandardController(oppOffering);
    }
    public static void setupData1(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);

    clientName = new Client_Master__c (Name = 'TestObject1');
    insert clientName;

    clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
    insert clientGeoArea;

    operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
    insert operatingGroup;

    clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
    insert clientGeoUnit;

    oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
    Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
    Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
    insert oppTGP;

     offeringMaster = new Offerings_Master__c (Name = 'TestOffering');
    insert offeringMaster;
    
    oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
    insert oppOffering;
    
    
    riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true);
    insert riskMaster;

    serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id );
    insert serviceMaster;


    risk = new Risk__c (Name = 'TestRisk',Risk_Master__c = riskMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
    insert risk;
    sc = new ApexPages.StandardController(oppOffering);
    }
    public static void setupData2(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);

    clientName = new Client_Master__c (Name = 'TestObject1');
    insert clientName;

    clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
    insert clientGeoArea;

    operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
    insert operatingGroup;

    clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
    insert clientGeoUnit;

    oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
    Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
    Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
    insert oppTGP;
    
    offeringMaster = new Offerings_Master__c (Name = 'TestOffering');
    insert offeringMaster;


      riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true);
    insert riskMaster;
    oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
    insert oppOffering;

    
    serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id );
    insert serviceMaster;



    risk = new Risk__c (Name = 'TestRisk',Risk_Master__c = riskMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
    insert risk;
    sc = new ApexPages.StandardController(oppOffering);

    }
    public static void setupData3(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);

    clientName = new Client_Master__c (Name = 'TestObject1');
    insert clientName;

    clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
    insert clientGeoArea;

    operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
    insert operatingGroup;

    clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
    insert clientGeoUnit;

    oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
    Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
    Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
    insert oppTGP;

    
    offeringMaster = new Offerings_Master__c (Name = 'TestOffering');
    insert offeringMaster;
    oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
    insert oppOffering;


    serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id );
    insert serviceMaster;


    riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true);
    insert riskMaster;
sc = new ApexPages.StandardController(oppOffering);
    }
    public static void setupData4(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);

    clientName = new Client_Master__c (Name = 'TestObject1');
    insert clientName;

    clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
    insert clientGeoArea;

    operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
    insert operatingGroup;

    clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
    insert clientGeoUnit;

    oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
    Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
    Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
    insert oppTGP;

    

    riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true);
    insert riskMaster;
    
    oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
    insert oppOffering;



    risk = new Risk__c (Name = 'TestRisk',Risk_probability__c = 200,Risk_Master__c = riskMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
    insert risk;
    sc = new ApexPages.StandardController(oppOffering);
    }

   /* static testMethod void testRiskInlineController(){
    test.starttest();
    setupData();
    Opportunity_Offering__c oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
    insert oppOffering1;

    //Opportunity_Offering__c opportunityOffering = new Opportunity_Offering__c();
    //ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering1);
    RiskInlineController riskInline = new RiskInlineController(sc); 



    //assumptionInlineController.assumptionCall();

    //assumptionInlineController.wrapperAssumption();
    test.stoptest();   

    } */
    static testMethod void testAssumptionCallElse(){
    test.starttest();
    setupData1();

    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
    RiskInlineController riskInlineController = new RiskInlineController( sc);
    RiskInlineController.WrapperRisk wrapper = new RiskInlineController.WrapperRisk (risk);
    List<RiskInlineController.WrapperRisk > wrapperList = new List<RiskInlineController.WrapperRisk >();
    wrapperList.add(wrapper);
    riskInlineController.doCancel();
    riskInlineController.saveAccProfileDetails();
    PageReference backToOffer= riskInlineController.backToOffer();
    PageReference addNewOppOffer = riskInlineController.addNewOppOffer ();
    List<selectOption> getServicesdrop = riskInlineController.getServicesdrop();
    //PageReference saveAccProfileDetails = riskInlineController.saveAccProfileDetails();

    test.stoptest(); 
    }
    static testMethod void testAssumptionCallIF(){
    test.starttest();
    setupData2();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
    RiskInlineController riskInlineController = new RiskInlineController( sc);
     Solution_tabController.WrapperAssumption wrapper = new Solution_tabController.WrapperAssumption (assumption);
     List<Solution_tabController.WrapperAssumption> wrapperList = new List<Solution_tabController.WrapperAssumption>();
     wrapperList.add(wrapper);


    PageReference addNewOppOffer = riskInlineController.addNewOppOffer ();
    List<selectOption> getServicesdrop = riskInlineController.getServicesdrop();
    //PageReference saveAccProfileDetails = assumptionInlineController.saveAccProfileDetails();

    test.stoptest(); 
    }
    static testMethod void testAssumptionCallListSize(){
    String  fileIdDelete;

    test.starttest();
    setupData3();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
    RiskInlineController riskInlineController = new RiskInlineController( sc);
     Solution_tabController.WrapperAssumption wrapper = new Solution_tabController.WrapperAssumption (assumption);
     List<Solution_tabController.WrapperAssumption> wrapperList = new List<Solution_tabController.WrapperAssumption>();
     wrapperList.add(wrapper);


    PageReference addNewOppOffer = riskInlineController.addNewOppOffer ();
   List<selectOption> getServicesdrop =riskInlineController.getServicesdrop();
    riskInlineController.newRisk.Risk__c='test';
    riskInlineController.newRisk.Classification__c='test';
    riskInlineController.saveAccProfileDetails();
    riskInlineController.addNewOppOffer();
    riskInlineController.getFileIdDelete();
    riskInlineController.setFileIdDelete(fileIdDelete);

    riskInlineController.toggleSort();
    riskInlineController.getServicesFilter();
    riskInlineController.getCategory();
    riskInlineController.getCategoryFilter();
    riskInlineController.ExportRisk();
    riskInlineController.applyFilter();
    riskInlineController.deleteFile();
    riskInlineController.searchServer();

    //PageReference saveAccProfileDetails = assumptionInlineController.saveAccProfileDetails();

    test.stoptest(); 
    }
    /*  static testMethod void testAssumptionCallListSizepageIDNotFound(){
    test.starttest();
    setupData3();
    ApexPages.StandardController controller;

    RiskInlineController riskInlineController = new RiskInlineController( sc);
     AssumptionInlineController.WrapperAssumption wrapper = new AssumptionInlineController.WrapperAssumption (assumption);
    List<AssumptionInlineController.WrapperAssumption> wrapperList = new List<AssumptionInlineController.WrapperAssumption>();
    wrapperList.add(wrapper);


    PageReference addNewOppOffer = riskInlineController.addNewOppOffer ();
    List<selectOption> getServicesdrop=riskInlineController.getServicesdrop();
    //PageReference saveAccProfileDetails = assumptionInlineController.saveAccProfileDetails();

    test.stoptest(); 
    }
  static testMethod void testAssumptionCallListSizepageProbability(){
    test.starttest();
    setupData4();
    ApexPages.StandardController controller;

    RiskInlineController riskInlineController = new RiskInlineController( sc);
    AssumptionInlineController.WrapperAssumption wrapper = new AssumptionInlineController.WrapperAssumption (assumption);
     List<AssumptionInlineController.WrapperAssumption> wrapperList = new List<AssumptionInlineController.WrapperAssumption>();
     wrapperList.add(wrapper);


    riskInlineController.addNewOppOffer();
     List<selectOption> getServicesdrop = riskInlineController.getServicesdrop();
    //PageReference saveAccProfileDetails = assumptionInlineController.saveAccProfileDetails();

    test.stoptest(); 
    }*/

    }