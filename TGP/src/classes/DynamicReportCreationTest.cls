/*
Author : Manik Chaudhary
Story  : Dynamic Report Creation
Description : Test Class for Dynamic Report Creation

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

@istest(SeeAlldata= true)

private class DynamicReportCreationTest 
{
static User testUser;
static User testUser2;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Offerings_Master__c offeringMaster;
static Opportunity_TGP__c oppTGP;
static Service_Master__c serviceMaster; 
static Assumption_Master__c assumptionMaster;
public static final string User_Name =  'vc123@testorg.com';

    public static void SetupData()
    {
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
    
        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
        
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name);       
        insert testUser2;
    }

public static void Setupdata1()
{
setupdata();
     system.runas(testUser2){
    // Inserting Data in Client Name master    
      clientName = new Client_Master__c (Name = 'DelDynReportTestObject1',Active__c = true);
      insert clientName;
   
      // Inserting data in Client Geo Area master
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'DelDynReportTestAPAC',Active__c = true);
      insert clientGeoArea;
      
      // Inserting data in Client Geo Unit Master
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'DelDynReportTestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      // Inserting Data in Operating Group Master
      operatingGroup = new Operating_Group_Master__c (Name = 'DelDynReportTestHSMPS',Active__c = true);
      insert operatingGroup;
      
      // Inserting Data in Offering Master   
      offeringMaster = new Offerings_Master__c (Name = 'DelDynReportTestOffering',Active__c = true);
      insert offeringMaster;

      }
      
     system.runas(testuser){
      // Inserting Data in Opportunity 
      oppTGP = new Opportunity_TGP__c(Name = 'DelDynReportTestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ManikDynReportTestC',OG_Sales_Lead__c='ManikDynReportTestC',TCV__C=55);
      insert oppTGP;
     
     }
       
}
public static void setupData2()
{
    setupdata1();
    system.runas(testUser2){
    serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     }
}
    
    static testMethod void testDynamicReportCreation()
    {
        test.starttest();
        
        setupData2();
        DynamicReportCreation obj=new DynamicReportCreation();
        
         List<SelectOption>lstOPT1=obj.getReportList();
         List<SelectOption>lstOPT2=obj.getReportingStatus();
         List<SelectOption>lstOPT3=obj.getStatus();
         List<SelectOption>lstOPT4=obj.getoppStage();
         List<SelectOption>lstOPT5=obj.getsapOMReportingStatus();
         List<SelectOption>lstOPT6=obj.getOppReportingStatus();
       
        obj.updateData();
        obj.selectedValue='Opportunity Report';
        obj.updateData();
        obj.selectedValue='Top 25 Stage 2 + Active Opportunities';
        obj.updateData();
        obj.selectedValue='New Demand';
        obj.updateData();
        obj.selectedValue='Next 15 RFPs Due';
        obj.updateData();
        obj.selectedValue='Active Stage 2+Opportunities not in SWB';
        obj.updateData();
        obj.selectedValue='Deals with CCI% lower than 29.5%';
        obj.updateData();
        obj.selectedValue='BPO Opportunity Raw Data Report';
        //obj.updateData();
            
        obj.reloadIframe1();
        obj.reloadIframe2();
        obj.reloadIframe3();
        obj.reloadIframe4();
        obj.reloadIframe5();
        obj.reloadIframe6();
        
         test.stoptest();

         
    }
     /*static testMethod void testDynamicReportCreation()
    {
        test.starttest();
        
        setupData2();
        DynamicReportCreation obj=new DynamicReportCreation();
        
         List<SelectOption>lstOPT1=obj.getReportList();
         List<SelectOption>lstOPT2=obj.getReportingStatus();
         List<SelectOption>lstOPT3=obj.getStatus();
         List<SelectOption>lstOPT4=obj.getoppStage();
         List<SelectOption>lstOPT5=obj.getsapOMReportingStatus();
         List<SelectOption>lstOPT6=obj.getOppReportingStatus();
       
        
        obj.selectedValue='New Demand';
        obj.updateData();
        
            
        obj.reloadIframe1();
        obj.reloadIframe2();
        obj.reloadIframe3();
        obj.reloadIframe4();
        obj.reloadIframe5();
        obj.reloadIframe6();
        
         test.stoptest();

         
    }*/
    
}