/*
Author : Harshit SHAH
Story  : Story-0163/Sol_066    
Description : Test Class for utilityClass. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

@isTest
private class utilityClassTest{ 
 static User testUser; 
  static Review_User_Master__c testUser1;
static Opportunity_TGP__c oppTGP;
static Opportunity_Offering__c oppOffering;
static Opportunity_Offering__c oppOffering1;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Offerings_Master__c offeringMaster;
static  Scheduling__c Scheduling;
private static string USER_NAME = 'vc12@testorg.com';


public static void setupData() {

     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
     Database.insert(testUser, false);
         
     testUser1 = UTIL_DataCreationForTestClass.getReviewUserMaster(USER_NAME,'test');
     testUser1.Is_Active__c = true;
     insert testUser1;
     
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
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
      
      oppTGP = new Opportunity_TGP__c(Name = 'DelReportTestIBM',Stage__c='Stage 1',complex_cost_architect_New__c=testUser1.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUser1.id ,
                  Oppotunity_QA__c='ManikReportTestC',OG_Sales_Lead__c='ManikReportTestC',TCV__C=55);
      insert oppTGP;
      
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id,Service_Delivery_Location_Unique__c = 'US; UK; India-Mumbai');
     insert oppOffering;
     
      oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering1',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id, Service_Delivery_Location_Unique__c = 'India-Pune; UK; India-Bangalore');
     insert oppOffering1;
     
     //Scheduling = new Scheduling__c(Offerings__c = oppOffering.Id, BPO_Opportunity_MD__c = oppTGP.Id );
     //insert Scheduling ;
}
 
 
 /*static testMethod void testupdateDeliveryLocation()
 {
   //setupData();
   utilityClass utilityClassInstance = new utilityClass();
   utilityClassInstance.updateDeliverylocationinOpportunity(oppTGP.Id);
   //utilityClassInstance.deleteSchedulingFromOffering(oppOffering.Id);
 }   */


}