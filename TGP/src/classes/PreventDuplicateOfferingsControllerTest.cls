/*
Author :Shridhar Patankar
Story  :   
Description : Test Class for PreventDuplicateOfferingsController Class. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class PreventDuplicateOfferingsControllerTest
{
    static User testUser; 
    static Opportunity_Offering__c oppOff1;
    static Opportunity_Offering__c oppOff2;
    static Offerings_Master__c offeringMaster;
    static Offerings_Master__c offeringMaster1;
    static List<Opportunity_Offering__c> lstoppOff;
    static Opportunity_TGP__c oppTGP;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
   
    
    public static void setupData()
    {
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
        lstoppOff= new List<Opportunity_Offering__c>();
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage    1',Client_Name__c=clientName.id,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low', 
                                        Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                                        Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
        insert oppTGP;
      
         offeringMaster = new Offerings_Master__c (Name = 'Test Data',Active__c = true);
         insert offeringMaster;
         offeringMaster1 = new Offerings_Master__c (Name = 'Test Data1',Active__c = true);
         insert offeringMaster1;
     
        // To create a Opportunity Offering
        oppOff1=new Opportunity_Offering__c();
        oppOff1.Offering_Master__c=offeringMaster.id;
        oppOff1.Opportunity_TGP__c=oppTGP.id;
        lstoppOff.add(oppOff1);
        
        oppOff2=new Opportunity_Offering__c();
        oppOff2.Offering_Master__c=offeringMaster1.id;
        oppOff2.Opportunity_TGP__c=oppTGP.id;
        lstoppOff.add(oppOff2);
               insert lstoppOff;
        
                
    }

    static testMethod void testPreventDuplicateOfferingsController()
    {
        test.starttest();
        setupData();
        oppOff1 = [select id,Offering_Master__c,Opportunity_TGP__c from Opportunity_Offering__c where Opportunity_TGP__c=:oppTGP.id and Offering_Master__c=:offeringMaster.id limit 1];
        oppOff1.Offering_Master__c=offeringMaster1.id;
        lstoppOff.add(oppOff1);
        oppOff2 = [select id,Offering_Master__c,Opportunity_TGP__c from Opportunity_Offering__c where Opportunity_TGP__c=:oppTGP.id and Offering_Master__c=:offeringMaster1.id limit 1];
        oppOff2.Offering_Master__c=offeringMaster1.id;
        lstoppOff.add(oppOff2);
        //update lstoppOff;
        test.stoptest();
        
    }   
}