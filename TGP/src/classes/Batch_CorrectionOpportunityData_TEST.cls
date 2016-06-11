/**
  * @author Accenture IDC Team
  * @name Batch_CorrectionOpportunityData_TEST
  * @createdDate 01/07/2014
  * @description This is a test class which will test the following classes
  *              1. UTIL_CorrectionOpportunityData
  *              2. deleteofferingopportunitycontroller
  *              3. Batch_UTIL_CorrectionOpportunityData
  *              4. opportunityOffSharingLogic
  *              
  * @version 0.1
  */ 
@isTest
private class Batch_CorrectionOpportunityData_TEST {
    public User solUser1, solUser2, solUser3;
    public Offerings_Master__c offMaster1,offMaster2,offMaster3;
    public Opportunity_TGP__c oppRecord;
    private static string USER_NAME_1 = 'v92@testorg.com';
    private static string USER_NAME_2 = 'v99@testorg.com';
    private static string USER_NAME_3 = 'v94@testorg.com';
    
    
    private void testUserCreation() {
        
        Profile solProfile = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        
        
        solUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_1);
        
        solUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_2);
        
        solUser3 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_3);

        Database.insert(new User[]{solUser1, solUser2,solUser3},false);
    }
    private void testDataCreation() {
        offMaster1 = new Offerings_Master__c (Name = 'TestOffering1',Active__c = true);
        offMaster2 = new Offerings_Master__c (Name = 'TestOffering2',Active__c = true);
        offMaster3 = new Offerings_Master__c (Name = 'TestOffering3',Active__c = true);
        Database.insert(new Offerings_Master__c[]{offMaster1, offMaster2,offMaster3},false);
        
        Client_Master__c clientName = new Client_Master__c (Name = 'TestObject1');
        insert clientName;
        Client_Geo_Area_Master__c clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
        insert clientGeoArea;
        
        Operating_Group_Master__c operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
        insert operatingGroup;
      
        Client_Geo_Unit_Master__c clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
        insert clientGeoUnit;
        
        oppRecord = new Opportunity_TGP__c(Name = 'TestSolLead',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,
                                            Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',Expected_contract_sign_qtr__c='FY12-Q4',
                                                Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=solUser1.id ,
                                                Oppotunity_QA__c='Hareesh Damodar',OG_Sales_Lead__c='Hareesh Damodar');
        insert  oppRecord;                                      
    }
    static testMethod void myUnitTest() {
        Batch_CorrectionOpportunityData_TEST testController = new Batch_CorrectionOpportunityData_TEST();
        testController.testUserCreation();
        Test.startTest();
            system.runAs(testController.solUser1) {
                testController.testDataCreation();
                Opportunity_Offering__c oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering1',Opportunity_TGP__c= testController.oppRecord.Id,
                                                        Offering_Master__c= testController.offMaster1.Id,Solution_Specialist__c = testController.solUser1.ID, 
                                                        Solution_Lead__c = testController.solUser1.Id);
                Opportunity_Offering__c oppOffering3 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering3',Opportunity_TGP__c=testController.oppRecord.Id,
                                                        Offering_Master__c= testController.offMaster3.Id,Solution_Specialist__c = testController.solUser3.Id, 
                                                        Solution_Lead__c = testController.solUser3.Id);
                Opportunity_Offering__c oppOffering2 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering2',Opportunity_TGP__c=testController.oppRecord.Id,
                                                        Offering_Master__c= testController.offMaster2.Id,Solution_Specialist__c = testController.solUser2.Id, 
                                                        Solution_Lead__c = testController.solUser2.Id); 
                                                        
                Database.insert(new Opportunity_Offering__c[]{oppOffering1, oppOffering2,oppOffering3},false);                                                                                  
            }
            Id jobId = Database.executeBatch(new Batch_UTIL_CorrectionOpportunityData(), 10); 
            system.assert(jobId!=null);
        Test.stopTest();
    }
}