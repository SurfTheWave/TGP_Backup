/*
Author :Kapil Sandhu
Story  :   
Description : Test Class for PreventDuplicateServiceMasterName Class
*/

@isTest(SeeAlldata= true)
private class PreventDuplicateServiceMasterNameTest
{
 static User testUser;
 static Client_Geo_Area_Master__c clientGeoArea;   
 static Operating_Group_Master__c operatingGroup;  
 static Client_Geo_Unit_Master__c clientGeoUnit;

 static Offerings_Master__c offeringMaster;
 static Service_Master__c serviceMaster1; 
 static Service_Master__c serviceMaster2; 
 static List<Service_Master__c> triggernew;
 static List<Service_Master__c> Namecheck;
  
 
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
    
    triggernew = new List<Service_Master__c>();
    Namecheck =  new List<Service_Master__c>();
    
    Set<String> Namesets1 = new Set<String>();
    Set<String> Namesets2 = new Set<String>();

 

   /* oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage    1',Client_Name__c=clientName.id,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low', 
                 Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,                    
                 Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
    insert oppTGP;
   */  
    offeringMaster = new Offerings_Master__c (Name = 'Test Data',Active__c = true);         
    insert offeringMaster;
    
    serviceMaster1 = new Service_Master__c();
    serviceMaster1.Offering__c = offeringMaster.id;
    serviceMaster1.Service_Description__c = 'DemoService';
    serviceMaster1.Name = 'testservice';
    
    insert serviceMaster1;
    
    serviceMaster1.Name = 'test';
    
    update serviceMaster1;
    
    Namecheck.add(serviceMaster1);
    
  /*  serviceMaster2 = new Service_Master__c();
    serviceMaster2.Offering__c = offeringMaster.id;
    serviceMaster2.Service_Description__c = 'NormalService';
    serviceMaster2.Name = 'testservice';
    triggernew.add(serviceMaster2);
   */ 
    triggernew.add(Namecheck[0]);
    Namesets1.add(Namecheck[0].Name);
    Namesets2.add(Namecheck[0].Offering__c);
    
    }
    
    static testMethod void testPreventDuplicateServiceMasterName()
    {
         test.starttest();        
         setupData();                 
         test.stoptest();
         
     }
     
 }