/*
Author :Kapil Sandhu
Story  :   
Description : Test Class for PreventDuplicateServiceMasterName Class
*/

@isTest(SeeAlldata= true)
private class PreventDuplThirdPartyVendorMastNameTest
{
     static User testUser; 
     static Client_Geo_Area_Master__c clientGeoArea;    
     static Operating_Group_Master__c operatingGroup;   
     static Client_Geo_Unit_Master__c clientGeoUnit;
     static Third_Party_Vendor_Master_Custom__c thirdparty1;
     static Third_Party_Vendor_Master_Custom__c thirdparty2;
     static Offerings_Master__c offeringMaster;
   //  static List<Third_Party_Vendor_Master_Custom__c> triggernew;
     static List<Third_Party_Vendor_Master_Custom__c> Namecheck;
     
     public static void setupData()
     {
          Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);
          
          clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);      
          insert clientGeoArea;
          
          operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);    
          insert operatingGroup;
          
          clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);          
          insert clientGeoUnit;
          
      //    triggernew = new List<Third_Party_Vendor_Master_Custom__c>();
          Namecheck = new List<Third_Party_Vendor_Master_Custom__c>();
          
          offeringMaster = new Offerings_Master__c (Name = 'Test Data',Active__c = true);             
          insert offeringMaster;
          
          thirdparty1 = new Third_Party_Vendor_Master_Custom__c();
          thirdparty1.Offering_Master__c = offeringMaster.id;
          thirdparty1.Third_Party_Vendor_Name__c = 'Name1';
          Namecheck.add(thirdparty1);
          
          }
          
          static testMethod void testPreventDuplThirdPartyVendorMasterName()
          {
               test.starttest();                 
               setupData();                         
               test.stoptest();
               
          }
          
       }