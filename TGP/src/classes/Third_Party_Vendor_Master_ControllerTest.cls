/*
Author : Shridhar Patankar
Story  : Story-0276/SOL_127_a
Description : Test Class for Third_Party_Vendor_Master_Controller. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class Third_Party_Vendor_Master_ControllerTest{
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
   static String Offering;
   static String Service;
   static Third_Party_Vendor_Master_Custom__c thirdPVendorname;
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
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestData1',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
     
     thirdPVendorname =  new Third_Party_Vendor_Master_Custom__c(Third_Party_Vendor_Name__c='testThirdparty',Offering_Master__c=offeringMaster.id);
     insert thirdPVendorname;
   }
   public static void setupData1(){
     
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
    
   }
   static testMethod void testThird_Party_Vendor_Master_Controller(){
   test.starttest();
      setupData();
      ApexPages.StandardController controller;
     Third_Party_Vendor_Master_Controller thirdPartyVen = new Third_Party_Vendor_Master_Controller( controller);
     
     PageReference pageRef= Page.ThirdPartyMaster;
     //pageRef.getParameters().put('id', String.valueOf(thirdPVendorname.Id));
     Test.setCurrentPageReference(pageRef);
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering1',Active__c = true);
     insert offeringMaster;
     thirdPVendorname =  new Third_Party_Vendor_Master_Custom__c(Third_Party_Vendor_Name__c='testThirdparty1',Offering_Master__c=offeringMaster.id);
     try
     {
     
     insert thirdPVendorname; 
     }
     catch(Exception e){
             Boolean expectedExceptionThrown =  e.getMessage().contains('Here goes your custom message') ? true : false;
            system.assertEquals(expectedExceptionThrown,true);       
            } 
     PageReference saveMethod= thirdPartyVen.saveMethod();
     PageReference cancelmethod= thirdPartyVen.cancelmethod();
     List<selectOption> getOfferings =thirdPartyVen.getOfferings();
    
   test.stoptest(); 
   }
   static testMethod void testThird_Party_Vendor_Master_Controller1(){
   test.starttest();
      setupData();
      ApexPages.StandardController controller;
     Third_Party_Vendor_Master_Controller thirdPartyVen = new Third_Party_Vendor_Master_Controller( controller);
     
     //PageReference pageRef= Page.ThirdPartyMaster;
     //pageRef.getParameters().put('id', String.valueOf(thirdPVendorname.Id));
     //Test.setCurrentPageReference(pageRef);
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering1',Active__c = true);
     insert offeringMaster;
     thirdPVendorname =  new Third_Party_Vendor_Master_Custom__c(Third_Party_Vendor_Name__c='testThirdparty1',Offering_Master__c=offeringMaster.id);
     try
     {
     
     insert thirdPVendorname; 
     
     }
     catch(Exception e){
             Boolean expectedExceptionThrown =  e.getMessage().contains('Record Saved Successfully!') ? true : false;
            system.assertEquals(expectedExceptionThrown,true);       
            } 
     PageReference saveMethod= thirdPartyVen.saveMethod();
     PageReference pageRef = new PageReference('/apex/ThirdPartyMaster?id=' + thirdPVendorname.Id); 
     Test.setCurrentPageReference(pageRef); 
     
    
   test.stoptest(); 
   }
}