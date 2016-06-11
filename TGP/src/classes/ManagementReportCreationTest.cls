/*
Author : Manik Chaudhary
Story  : Management Report Creation
Description : Test Class for Management Report Creation

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

@istest(seealldata = true)

private class ManagementReportCreationTest{

static User testUser;
static User testUser2;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Offerings_Master__c offeringMaster;
static Opportunity_TGP__c oppTGP;
static String USER_Name = 'vc7@testorg.com';

public static void Setupdata1()
{
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
      	testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      	Database.insert(testUser, false); 
    
    p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
      	testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name);
      	Database.insert(testUser2, false);
     system.runas(testUser2){
    // Inserting Data in Client Name master    
      clientName = new Client_Master__c (Name = 'DelMngReportTestObject1',Active__c = true);
      insert clientName;
   
      // Inserting data in Client Geo Area master
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'DelmngReportTestAPAC',Active__c = true);
      insert clientGeoArea;
      
      // Inserting data in Client Geo Unit Master
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'DelmngReportTestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      // Inserting Data in Operating Group Master
      operatingGroup = new Operating_Group_Master__c (Name = 'DelmngReportTestHSMPS',Active__c = true);
      insert operatingGroup;
       
      // Inserting Data in Offering Master   
      offeringMaster = new Offerings_Master__c (Name = 'DelmngReportTestOffering',Active__c = true);
      insert offeringMaster;
      }
      
     system.runas(testuser){
      // Inserting Data in Opportunity 
      oppTGP = new Opportunity_TGP__c(Name = 'DelmngReportTestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ManikmngReportTestC',OG_Sales_Lead__c='ManikmngReportTestC',TCV__C=55);
      insert oppTGP;
     
     }
         
    
         
}
    
    static testMethod void testManagementReportCreation()
    {
        test.starttest();

        setupdata1();
        
        ManagementReportCreation obj=new ManagementReportCreation();
        
        List<SelectOption>lstOPT1=obj.getReportList();
        List<SelectOption>lstOPT2=obj.getReportingStatus();
        List<SelectOption>lstOPT3=obj.getStatus();
        List<SelectOption>lstOPT4=obj.getoppStage();
        List<SelectOption>lstOPT5=obj.getOppReportingStatus();
        
        obj.updateData();
        obj.selectedvalue='My SRAT';
        obj.updateData();
        obj.selectedvalue='In flight Transition Summary (by wave)';
        obj.updateData();
        obj.selectedvalue='Go Lives - Forward Looking View';
        obj.updateData();
        obj.selectedvalue='YTD - Cost Summary';
        obj.updateData();
        obj.selectedvalue='Status Summary';
        obj.updateData();
        obj.selectedvalue='Mobilization Watch List';
        obj.updateData();
        obj.selectedvalue='Governance Report-GoLive Detail_SRAT';
        obj.updateData();
        obj.selectedvalue='Watch List Detail';
        obj.updateData();
        obj.selectedvalue='Go Live – Next 30 Day Detail';
        obj.updateData();
        obj.selectedvalue='Go Live - Next 30 days';
        obj.updateData();
        obj.selectedvalue='Governance report - Go Live detail SRAT';
        obj.updateData();
        obj.selectedvalue='Go Live Tracker';
        obj.updateData();
        obj.selectedvalue='Location Wise Transition Summary Report';
        obj.updateData();
        obj.selectedvalue='Critical Metrics - Execution';
        obj.updateData();
        obj.selectedvalue='In Flight – Transition Status – 30 day';
        obj.updateData();
        obj.selectedvalue='Watch List Summary';
        obj.updateData();
        obj.selectedvalue='Governance report - Go Live detail OPEX';
        obj.updateData();
        obj.selectedvalue='Location Wise Transition Summary';
        obj.updateData();
        obj.selectedvalue='In flight Transition Summary (by deal)';
        obj.updateData();
        obj.selectedvalue='OM Day 1/30/60/90 status';
        obj.updateData();
        
        obj.reloadIframe1();
        obj.reloadIframe2();
        obj.reloadIframe3();
        obj.reloadIframe4();
        obj.reloadIframe5();
        obj.reloadIframe6();
        obj.reloadIframe7();
        obj.reloadIframe8();
        obj.reloadIframe9();
        obj.reloadIframe10();
        obj.reloadIframe11();
        obj.reloadIframe12();
        obj.reloadIframe13();
        obj.reloadIframe14();
        obj.reloadIframe15();
        obj.reloadIframe16();
        
        test.stoptest();
        
    } 

}