@isTest
private class UpdateBPOOPPTGPTest{

       static Client_Master__c clientName;
       static Client_Geo_Area_Master__c clientGeoArea;
       static Operating_Group_Master__c operatingGroup;
       static Client_Geo_Unit_Master__c clientGeoUnit;
       static Opportunity_TGP__c oppTGP;
       static Opportunity_TGP__c oppTGPNew;
       static User testUser; 

       static testMethod void test1(){
    
    
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
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
           insert oppTGP;
            
          SAP_OM_Opportunity__c obj = new SAP_OM_Opportunity__c(name='test',Client_Geo_Area__c = clientGeoArea.id,Client_Name__c = clientName.id,Operating_Group__c=operatingGroup.id,Opportunity_Name__c=oppTGP.name);
          insert obj;
          
          oppTGPNew=new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',SAP_OM_Opportunity__c = obj.id,OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
           insert oppTGPNew;
          
          obj.name = 'test1';
          update obj;
          
        
       }
}