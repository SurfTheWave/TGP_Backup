//***************************************************************************************************************
    //  Method Name: Test class for ServiceComponentNameCheckInsert
    // Description: Test class for Before Inserting Records,Checks whether Name  is already present with other ServiceComponent Record or not
    // Created By: Manik Chaudhary
    // Story: Story-0153/COM_065
    
    @isTest
    private class PreventDuplicateServiceComponentNameTest{
    
    static User testUser;
    static User testUser2;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Offerings_Master__c offeringMaster;
    static Opportunity_TGP__c oppTGP;
    static Solution_User_Assignment__c solusassign;
    static Solution_User_Assignment__c solusassign1;
    static Service_Component__c servicecomponent;
    static Service_Master__c service;
    static Service_Component__c servicecomponent1;
    private static string USER_NAME = 'vc123@testorg.com';
    public static void SetupData()
    {
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,'vc12345@testorg.com');
        Database.insert(testUser, false);  
        
        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
        Database.insert(testUser2, false);
    }
    
    public static void Setupdata1()
    {
         system.runas(testUser2){
        // Inserting Data in Client Name master    
          clientName = new Client_Master__c (Name = 'DelReportTestObject1',Active__c = true);
          insert clientName;
       
          // Inserting data in Client Geo Area master
          clientGeoArea = new Client_Geo_Area_Master__c (Name = 'DelReportTestAPAC',Active__c = true);
          insert clientGeoArea;
          
          // Inserting data in Client Geo Unit Master
          clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'DelReportTestLATAM',Active__c = true);
          insert clientGeoUnit;
          
           // Inserting Data in Offering Master   
          offeringMaster = new Offerings_Master__c (Name = 'DelReportTestOfferingdel',Active__c = true);
          insert offeringMaster;
          
          // Inserting Data in Operating Group Master
          operatingGroup = new Operating_Group_Master__c (Name = 'DelReportTestHSMPS',Active__c = true);
          insert operatingGroup;
           
         
          service=new Service_Master__c(Name ='Testservicdel',Active__c= true, Offering__c=offeringmaster.id);
          insert service;
          
          servicecomponent=new Service_Component__c(Name='Testservcompdel',Active__c=true,Service_Component_Description__c='comment',Offering_Master__c=offeringmaster.id,Service_Master__c=service.id);
          insert servicecomponent;
          
         // servicecomponent1=new Service_Component__c(Name='Testservcompdel',Active__c=true,Service_Component_Description__c='comment',Offering_Master__c=offeringmaster.id,Service_Master__c=service.id);
        //  insert servicecomponent1;
          }
          
         system.runas(testuser){
          // Inserting Data in Opportunity 
          oppTGP = new Opportunity_TGP__c(Name = 'DelReportTestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ManikReportTestC',OG_Sales_Lead__c='ManikReportTestC',TCV__C=55);
          insert oppTGP;
          
             
             
         }
    }
    
    public static void Setupdata2()
    {    system.runas(testuser2)
    {
        servicecomponent.Name='delkTest';
        update servicecomponent;
    }
    }
    
    static testMethod void testPreventDuplicateServiceComponent()
    {
    test.starttest();
    setupdata();
    setupdata1();
    //system.runas(testUser2){
    Integer i=0;
    Integer j=0;
    //PreventDuplicateServiceComponentName.serviceComponentNameCheckInsert();
    
    //}
    test.stoptest();
    }
        static testMethod void testPreventDuplicateServiceComponent1()
        {
        test.starttest();
        setupdata();
        setupdata1();
        setupdata2();
        //system.runas(testUser2){
        Integer i=0;
        Integer j=0;
        
        //PreventDuplicateServiceComponentName.serviceComponentNameCheckUpdate();
        //}
        test.stoptest();
        }
    }