/*
Author : Shridhar Patankar
Story  : Release 2  
Description : Test Class for EmailOppTGPInsertSendEmail. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class EmailOPPTGPInsertRegionSendEmailTest{
   static User testUser; 
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Client_Geo_Area_Master__c clientList1;
   static Client_Geo_Area_Master__c clientList2;
   static Client_Geo_Area_Master__c clientList3;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Opportunity_TGP__c oppTGP1;
   static Opportunity_TGP__c oppTGP2;
   static Opportunity_TGP__c oppTGP3;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Assumption__c assumption;
   static SAP_OM_Opportunity__c sAPOMOpp;
   static String strUrl{get;set;} 
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      Client_Geo_Area_Master__c clientList = new Client_Geo_Area_Master__c();

     // clientList =[Select name from Client_Geo_Area_Master__c where name=:'APAC'];
       clientList = new Client_Geo_Area_Master__c (Name = 'APAC',Active__c = true);
       insert clientList;
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientList.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
      insert oppTGP;
     // clientList1 =[Select name from Client_Geo_Area_Master__c where name=:'EALA'];
      clientList1 = new Client_Geo_Area_Master__c (Name = 'EALA',Active__c = true);
      insert clientList1 ;
      oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM343',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientList1.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
      insert oppTGP1;


    // clientList3 =[Select name from Client_Geo_Area_Master__c where name=:'Latin America'];
      clientList3 = new Client_Geo_Area_Master__c (Name = 'Latin America',Active__c = true);
      insert clientList3 ;
      

     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
    }
    static testMethod void testEmailOppTGPInsertSendEmail(){
    setupData();
    test.starttest();
      
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
      EmailOPPTGPInsertRegionSendEmail obj = new EmailOPPTGPInsertRegionSendEmail();
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        List<Opportunity_TGP__c> lstOldoppTGP1 = new List<Opportunity_TGP__c>();
        List<Opportunity_TGP__c> lstOldoppTGP2 = new List<Opportunity_TGP__c>();
        List<Opportunity_TGP__c> lstOldoppTGP3 = new List<Opportunity_TGP__c>();
        
        lstOldoppTGP.add(oppTGP);
        //lstOldoppTGP1.add(oppTGP1);
        List<Opportunity_TGP__c> lstNewoppTGP=  new List<Opportunity_TGP__c>();
        
        lstNewoppTGP.add(oppTGP);

        
        List <Client_Geo_Area_Master__c> clientList = new List<Client_Geo_Area_Master__c>();
        clientList.add(clientGeoArea);
        List <Client_Geo_Unit_Master__c> clientUnitList = new List<Client_Geo_Unit_Master__c>();
        clientUnitList.add(clientGeoUnit);
        List <Client_Master__c> clientMasterName = new List<Client_Master__c>();
        clientMasterName.add(clientName);
        List <Operating_Group_Master__c> opGroup = new List<Operating_Group_Master__c>();
        opGroup.add(operatingGroup);
     
       String value;
       Decimal value1;
     
      strUrl = URL.getSalesforceBaseUrl().toExternalForm();
      //EmailOPPTGPInsertRegionSendEmail.sendMailInsertRegion(oppTGP);
     
     
    test.stoptest(); 
    } 
     static testMethod void testEmailOppTGPInsertSendEmail1(){
     setupData();
     test.starttest();
      
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
      EmailOPPTGPInsertRegionSendEmail obj = new EmailOPPTGPInsertRegionSendEmail();
                                   
      strUrl = URL.getSalesforceBaseUrl().toExternalForm();
     EmailOPPTGPInsertRegionSendEmail.sendMailInsertRegion(oppTGP1);
   
     clientList3 = new Client_Geo_Area_Master__c (Name = 'Latin America',Active__c = true);
      insert clientList3 ;
      oppTGP3 = new Opportunity_TGP__c(Name = 'TestIBM3fgdfg413',Client_Geo_Area_Prior_Value__c='North America',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientList3.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
      insert oppTGP3;
     
     String value;

     EmailOPPTGPInsertRegionSendEmail.checkNullValues(value);

     
    test.stoptest(); 
    }
     
   }