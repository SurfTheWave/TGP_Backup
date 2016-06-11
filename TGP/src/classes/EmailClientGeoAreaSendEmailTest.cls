/*
Author : Shridhar Patankar
Story  : Release 2  
Description : Test Class for EmailClientGeoAreaSendEmail. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class EmailClientGeoAreaSendEmailTest{
   static User testUser;
   static User testUser1;   
 static Client_Master__c clientName;
  
   static Client_Geo_Area_Master__c clientGeoArea;
   static Client_Geo_Area_Master__c clientGeoAreaNew;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Opportunity_TGP__c oppTGP1;
   static Opportunity_TGP__c oppTGP2;
   static Opportunity_TGP__c oppTGP3;
   static Opportunity_TGP__c oppTGPNew;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Assumption__c assumption;
   static SAP_OM_Opportunity__c sAPOMOpp; 
   static String USER_Name = 'vc7@testorg.com';
   static String strUrl{get;set;} 
   
   public static void setupDataNew(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
     Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
                testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
                Database.insert(testUser1, false);
      
      system.Runas(testUser1)
     {

    
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoAreaNew = new Client_Geo_Area_Master__c (Name = 'APAC',Active__c = true);
      insert clientGeoAreaNew;
      
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     }
     
     oppTGPNew = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c=UTIL_Constants.LATIN_AMERICA,Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoAreaNew.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
        insert oppTGPNew;
    
      
      
      
     
     
   }
   
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
     Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
                testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
                Database.insert(testUser1, false);
      
      system.Runas(testUser1)
     {

    
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'Latin America',Active__c = true);
      insert clientGeoArea;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'EALA',Active__c = true);
      insert clientGeoArea;
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'APAC',Active__c = true);
      insert clientGeoArea;
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'North America',Active__c = true);
      insert clientGeoArea;
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     }

    system.Runas(testUser)
    {
          oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
      insert oppTGP;
      
     }
     system.Runas(testUser1)
     {
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
          
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;

    }
    oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
     
     
   }
   public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'EALA',Active__c = true);
      insert clientGeoArea;
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'Latin America',Active__c = true);
      insert clientGeoArea;
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP;
      
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
    public static void setupData3(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = UTIL_Constants.APAC,Active__c = true);
      insert clientGeoArea;
      
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
      
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c=UTIL_Constants.LATIN_AMERICA,Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c=UTIL_Constants.PIPELINE,Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP;
      
      System.debug('---setupData3--'+oppTGP.id);
     
     /* oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='EALA',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      update oppTGP;*/
      
      oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='EALA',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP1;
      
     
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

public static void setupDataX(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
     clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
     insert clientName;
      
     clientGeoArea = new Client_Geo_Area_Master__c (Name = UTIL_Constants.LATIN_AMERICA,Active__c = true);
     insert clientGeoArea;
      
      
     operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
     insert operatingGroup;
      
     clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
     insert clientGeoUnit;
      
     sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                 Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Opportunity_Name__c = 'IBMTest');
     insert sAPOMOpp;
      
     oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c=UTIL_Constants.North_America,Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c=UTIL_Constants.PIPELINE,Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
     insert oppTGP;
           
     oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='EALA',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
     insert oppTGP1;
      
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
// Setup DAta X

   public static void setupData4(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'EALA',Active__c = true);
      insert clientGeoArea;
         
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
      
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP;
     
     
     
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
    public static void setupData5(){
    
    //Client_Geo_Area_Master__c clientGeoArea5;

     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea= new Client_Geo_Area_Master__c (Name = 'EALA',Active__c = true);
      insert clientGeoArea;
      clientGeoArea= new Client_Geo_Area_Master__c (Name = 'North America',Active__c = true);
      insert clientGeoArea;
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='TestIndia',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP;
      
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
    public static void setupData6(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'Latin America',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='TestIndia',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP;
      
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
   public static void setupData7(){
   
    // Client_Geo_Area_Master__c clientGeoArea7;

     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea= new Client_Geo_Area_Master__c (Name = 'APAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='TestIndia',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP;
      
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
   public static void setupData8(){
     
        //Client_Geo_Area_Master__c clientGeoArea8;

     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'EALA',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestrewrHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='TestIndia',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP;
      
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
    static testMethod void testEmailClientGeoAreaSendEmail(){
    test.starttest();
      setupData();
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
        clientList =[Select name from Client_Geo_Area_Master__c where name=:'EALA'];
        update clientList;
       //clientUnitList =[Select name from Client_Geo_Unit_Master__c];
       String value;
       value='kapil';
       Decimal value1;
       value1=123.45;
       EmailClientGeoAreaSendEmail emailclient = new EmailClientGeoAreaSendEmail();
       strUrl = URL.getSalesforceBaseUrl().toExternalForm();
     EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP,lstNewoppTGP,clientList, clientUnitList,clientMasterName,opGroup);
     String checkNullValues= EmailOppTGPInsertSendEmail.checkNullValues(value);
     String checkNullValuesDeciamlTCV= EmailOppTGPInsertSendEmail.checkNullValuesDeciamlTCV(value1);
    test.stoptest(); 
    } 
    
     static testMethod void testEmailClientGeoAreaSendEmail2(){
    test.starttest();
      setupData1();
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'Latin America'];
       update clientList;
       //clientUnitList =[Select name from Client_Geo_Unit_Master__c];
     EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
    test.stoptest(); 
    } 
    
    static testMethod void testEmailClientGeoAreaSendEmail1if(){
    test.starttest();
      setupData();
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
    // EmailClientGeoAreaSendEmail emailClientGeoAreaSendEmail = new EmailClientGeoAreaSendEmail();
     /*   oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
        insert oppTGP1;*/
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'North America'];
        update clientList;
        
       //clientUnitList =[Select name from Client_Geo_Unit_Master__c];
    EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
    test.stoptest(); 
    } 
    
    
        static testMethod void testEmailClientGeoAreaSendEmail1if6(){
        
        setupData3();
        
        test.starttest();
          
        clientGeoArea = new Client_Geo_Area_Master__c (Name = UTIL_Constants.APAC,Active__c = true);
        insert clientGeoArea;
             
        ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
        apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
        //EmailClientGeoAreaSendEmail emailClientGeoAreaSendEmail = new EmailClientGeoAreaSendEmail();
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
        //List<Opportunity_TGP__c> lstNewoppTGP=  new List<Opportunity_TGP__c>();
        //lstNewoppTGP.add(oppTGP);
        System.debug('-----'+oppTGP.id);
        List<Opportunity_TGP__c> lstNewoppTGP=  [select Name,Offerings__c,Service_Delivery_Locations_Unique__c,Risk_Level__c,TCV__c,Stage__c,Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Activity__c,Client_Name__c,Client_Geo_Unit__c,Client_Geo_Area__c,Operating_Group__c,Enterprise_Solution_Architect_New__r.Name from Opportunity_TGP__c where id = : oppTGP.id];
        System.debug('--------------'+lstNewoppTGP);
        //lstNewoppTGP.add(oppTGP);
        //List <Client_Geo_Area_Master__c> clientList = new List<Client_Geo_Area_Master__c>();
        //clientList.add(clientGeoArea);
        List <Client_Geo_Area_Master__c> clientList = [select name from  Client_Geo_Area_Master__c where id = : clientGeoArea.id];
        //clientList.add(clientGeoArea);
        List <Client_Geo_Unit_Master__c> clientUnitList = new List<Client_Geo_Unit_Master__c>();
        clientUnitList.add(clientGeoUnit);
        List <Client_Master__c> clientMasterName = new List<Client_Master__c>();
        clientMasterName.add(clientName);
        List <Operating_Group_Master__c> opGroup = new List<Operating_Group_Master__c>();
        opGroup.add(operatingGroup);
        
        if(lstNewoppTGP.size()>0){
        EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
        }
        test.stoptest(); 
        }
        // 
        
    static testMethod void testEmailClientGeoAreaSendEmailX(){
        
        setupData3();
        
        test.starttest();
          
        clientGeoArea = new Client_Geo_Area_Master__c (Name = UTIL_Constants.APAC,Active__c = true);
        insert clientGeoArea;
             
        ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
        apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
        List<Opportunity_TGP__c> lstNewoppTGP=  [select Name,Offerings__c,Service_Delivery_Locations_Unique__c,Risk_Level__c,TCV__c,Stage__c,Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Activity__c,Client_Name__c,Client_Geo_Unit__c,Client_Geo_Area__c,Operating_Group__c,Enterprise_Solution_Architect_New__r.Name from Opportunity_TGP__c where id = : oppTGP.id];
        
        List <Client_Geo_Area_Master__c> clientList = [select name from  Client_Geo_Area_Master__c where id = : clientGeoArea.id];
        
        List <Client_Geo_Unit_Master__c> clientUnitList = new List<Client_Geo_Unit_Master__c>();
        clientUnitList.add(clientGeoUnit);
        List <Client_Master__c> clientMasterName = new List<Client_Master__c>();
        clientMasterName.add(clientName);
        List <Operating_Group_Master__c> opGroup = new List<Operating_Group_Master__c>();
        opGroup.add(operatingGroup);
        
        if(lstNewoppTGP.size()>0){
        EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
        }
        test.stoptest(); 
    }

        
        //
    static testMethod void testEmailClientGeoAreaSendEmail1if61(){
        
        setupDataNew();
        
        test.starttest();
        
       oppTGPNew.Client_Geo_Area_Prior_Value__c='APAC';
       update oppTGPNew;
       
       clientGeoAreaNew.Name = 'APAC';
       update clientGeoAreaNew;
       
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGPNew);
      apexpages.currentpage().getparameters().put('id' ,oppTGPNew.id);
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGPNew);
        System.debug('-----'+oppTGPNew.id);
        List<Opportunity_TGP__c> lstNewoppTGP=  [select Name,Offerings__c,Service_Delivery_Locations_Unique__c,Risk_Level__c,TCV__c,Stage__c,Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Activity__c,Client_Name__c,Client_Geo_Unit__c,Client_Geo_Area__c,Operating_Group__c,Enterprise_Solution_Architect_New__r.Name from Opportunity_TGP__c where id = : oppTGPNew.id];
        System.debug('--------------'+lstNewoppTGP);
        //lstNewoppTGP.add(oppTGP);
        //List <Client_Geo_Area_Master__c> clientList = new List<Client_Geo_Area_Master__c>();
        //clientList.add(clientGeoArea);
        List <Client_Geo_Area_Master__c> clientList = [select name from  Client_Geo_Area_Master__c where id = : clientGeoAreaNew.id];
        //clientList.add(clientGeoArea);
        List <Client_Geo_Unit_Master__c> clientUnitList = new List<Client_Geo_Unit_Master__c>();
        clientUnitList.add(clientGeoUnit);
        List <Client_Master__c> clientMasterName = new List<Client_Master__c>();
        clientMasterName.add(clientName);
        List <Operating_Group_Master__c> opGroup = new List<Operating_Group_Master__c>();
        opGroup.add(operatingGroup);

       if(lstNewoppTGP.size()>0){
        EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
       }
    test.stoptest(); 
    }
    static testMethod void testEmailClientGeoAreaSendEmail1if62(){
        
        setupDataNew();
        
        test.starttest();
        
        
      
       
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGPNew);
      apexpages.currentpage().getparameters().put('id' ,oppTGPNew.id);
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGPNew);
        System.debug('-----'+oppTGPNew.id);
        List<Opportunity_TGP__c> lstNewoppTGP=  [select Name,Offerings__c,Service_Delivery_Locations_Unique__c,Risk_Level__c,TCV__c,Stage__c,Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Activity__c,Client_Name__c,Client_Geo_Unit__c,Client_Geo_Area__c,Operating_Group__c,Enterprise_Solution_Architect_New__r.Name from Opportunity_TGP__c where id = : oppTGPNew.id];
        System.debug('--------------'+lstNewoppTGP);
        //lstNewoppTGP.add(oppTGP);
        //List <Client_Geo_Area_Master__c> clientList = new List<Client_Geo_Area_Master__c>();
        //clientList.add(clientGeoArea);
        List <Client_Geo_Area_Master__c> clientList = [select name from  Client_Geo_Area_Master__c where id = : clientGeoAreaNew.id];
        //clientList.add(clientGeoArea);
        List <Client_Geo_Unit_Master__c> clientUnitList = new List<Client_Geo_Unit_Master__c>();
        clientUnitList.add(clientGeoUnit);
        List <Client_Master__c> clientMasterName = new List<Client_Master__c>();
        clientMasterName.add(clientName);
        List <Operating_Group_Master__c> opGroup = new List<Operating_Group_Master__c>();
        opGroup.add(operatingGroup);

       if(lstNewoppTGP.size()>0){
        EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
       }
    test.stoptest(); 
    }
    
    
     static testMethod void testEmailClientGeoAreaSendEmail1if7(){
    test.starttest();
      setupData();
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
    // EmailClientGeoAreaSendEmail emailClientGeoAreaSendEmail = new EmailClientGeoAreaSendEmail();
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='North America',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
       //opGroup =[Select name from Operating_Group_Master__c ];
       //clientMasterName =[Select name from Client_Master__c];
      clientList =[Select name from Client_Geo_Area_Master__c where name=:'Latin America'];
       update clientList;
     //  if(!clientUnitList.isEmpty())
     //  clientUnitList =[Select name from Client_Geo_Unit_Master__c];
    EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
    test.stoptest(); 
    } 
    
    
    static testMethod void testEmailClientGeoAreaSendEmail1if8(){
    test.starttest();
      setupData();
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
    // EmailClientGeoAreaSendEmail emailClientGeoAreaSendEmail = new EmailClientGeoAreaSendEmail();
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='North America',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
       //opGroup =[Select name from Operating_Group_Master__c ];
       //clientMasterName =[Select name from Client_Master__c];
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'APAC'];
       update clientList;
      // clientUnitList =[Select name from Client_Geo_Unit_Master__c];
     EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
    test.stoptest(); 
    } 
    
    
    static testMethod void testEmailClientGeoAreaSendEmail1if9(){
    test.starttest();
      setupData();
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
    // EmailClientGeoAreaSendEmail emailClientGeoAreaSendEmail = new EmailClientGeoAreaSendEmail();
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='North America',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
       //opGroup =[Select name from Operating_Group_Master__c ];
      // clientMasterName =[Select name from Client_Master__c];
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'EALA'];
       update clientList;
       //clientUnitList =[Select name from Client_Geo_Unit_Master__c];
     EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
    test.stoptest(); 
    }
    
     
    static testMethod void test10(){
    test.starttest();
      setupData5();
     // Client_Geo_Area_Master__c clientGeoArea5;

      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
    // EmailClientGeoAreaSendEmail emailClientGeoAreaSendEmail = new EmailClientGeoAreaSendEmail();
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='TestNA',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
       //opGroup =[Select name from Operating_Group_Master__c ];
       //clientMasterName =[Select name from Client_Master__c];
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'North America'];
       update clientList;
       //clientUnitList =[Select name from Client_Geo_Unit_Master__c];
     EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
    test.stoptest(); 
    } 
    
    static testMethod void test12(){
    test.starttest();
      setupData7();
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
    // EmailClientGeoAreaSendEmail emailClientGeoAreaSendEmail = new EmailClientGeoAreaSendEmail();
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
       //opGroup =[Select name from Operating_Group_Master__c ];
       //clientMasterName =[Select name from Client_Master__c];
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'APAC'];
       update clientList;
       //clientUnitList =[Select name from Client_Geo_Unit_Master__c];
     EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
    test.stoptest(); 
    } 
    
    
    static testMethod void test13(){
    test.starttest();
      setupData8();
      
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
      apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
    // EmailClientGeoAreaSendEmail emailClientGeoAreaSendEmail = new EmailClientGeoAreaSendEmail();
        List<Opportunity_TGP__c> lstOldoppTGP = new List<Opportunity_TGP__c>();
        lstOldoppTGP.add(oppTGP);
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
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c=UTIL_Constants.LATIN_AMERICA,Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
       insert oppTGP;
       lstNewoppTGP.add(oppTGP);
       //opGroup =[Select name from Operating_Group_Master__c ];
      // clientMasterName =[Select name from Client_Master__c];
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'EALA'];
       update clientList;
       //clientUnitList =[Select name from Client_Geo_Unit_Master__c];
     EmailClientGeoAreaSendEmail.sendMail(lstOldoppTGP ,lstNewoppTGP, clientList, clientUnitList,clientMasterName,opGroup);
    test.stoptest(); 
    } 
    
}