/*
Author : Manik Chaudhary
Story  : DealSpecificReport Creation
Description : Test Class for DealSpecificReport Creation

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/



@istest(Seealldata=true)
private class DealSpecificReportCreationTest{
static Boolean section0;
static Boolean section1;
static Boolean section2;
static Boolean section3;
static Boolean section4;
static Boolean section5;
static Boolean section6;
static Boolean section7;
static Boolean section8;
static Boolean section9;
static Boolean section10;
static Boolean section11;

static String selectedValue;
static String listOppSelected;
static String listSAPOMSelected;
static String listClientSelected;
static String listopGroupSelected;
static String listOUSelected;
static String listGeoAreaSelected;
static String listGeoUnitSelected;
static String listOffSelected;
static String listReportStatusSelected;
static String listOppReportStatusSelected;
static String listStageSelected;
static String listOppStageSelected;
static String x_reportOptions;
static String iframeSource;
static String iframeSource1;
static String listDealSelected;  

static User testUser;
static User testUser2;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Offerings_Master__c offeringMaster;
static Opportunity_TGP__c oppTGP;
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
      
      // Inserting Data in Operating Group Master
      operatingGroup = new Operating_Group_Master__c (Name = 'DelReportTestHSMPS',Active__c = true);
      insert operatingGroup;
       
      // Inserting Data in Offering Master   
      offeringMaster = new Offerings_Master__c (Name = 'DelReportTestOffering',Active__c = true);
      insert offeringMaster;
      }
      
     system.runas(testuser){
      // Inserting Data in Opportunity 
      oppTGP = new Opportunity_TGP__c(Name = 'DelReportTestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ManikReportTestC',OG_Sales_Lead__c='ManikReportTestC',TCV__C=55);
      insert oppTGP;
     
     }
         
    
         
}

static testMethod void testDealSpecificReportCreation ()
{
    test.starttest();
    Setupdata();
    Setupdata1();
    DealSpecificReportCreation obj=new DealSpecificReportCreation();
    List<SelectOption>lstOPT1=obj.getReportList();
    List<SelectOption>lstOPT2=obj.getoppStage();
    List<SelectOption>lstOPT3=obj.getOppReportingStatus();
    List<SelectOption>lstOPT4=obj.getReportingStatus();
    List<selectOption>lstOPT5=obj.getStatus();
    obj.updateData();
    obj.selectedValue ='My SRAT';
    obj.updateData();
    obj.selectedValue='In Flight - Transition Status Summary';
    obj.updatedata();
    obj.selectedValue='My Program Milestones';
    obj.updatedata();
    obj.selectedValue='Governance Report-GoLive Detail';
    obj.updatedata();
   // obj.selectedValue='GoLive Detail_SRAT';
   // obj.updatedata();
    obj.selectedValue='Governance Report-GoLive Detail_OPEX';
    obj.updatedata();
    //obj.selectedValue='Mob - Go Lives - Forward Looking View';
    //obj.updatedata();
    obj.selectedValue='Watch List Summary';
    obj.updatedata();
    obj.selectedValue='My Wave Status';
    obj.updatedata();
    obj.selectedValue='In Flight – Transition Status – 30 day';
    obj.updatedata();
    obj.selectedValue='My Transition Summary';
    obj.updatedata();
    
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
    test.stoptest();
}

}