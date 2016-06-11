/*
  @Author: 
  @Name: UTIL_Scheduling_TEST
  @Created Date: 01 January 2015
  @Description: This is a test class UTIL_Scheduling_TEST
  @version: 1.0
*/
@isTest
private class UTIL_Scheduling_TEST{
    private static List<Opportunity_Offering__c> offList = new List<Opportunity_Offering__c>();
    private static List<Opportunity_Offering__c> newOffList = new List<Opportunity_Offering__c>();
    private static List<Opportunity_TGP__c> oppList = new List<Opportunity_TGP__c>();
    private static List<Scheduling__c> schList = new List<Scheduling__c>();
    private static Client_Master__c clientName;
    private static Client_Geo_Area_Master__c clientGeoArea;
    private static Operating_Group_Master__c operatingGroup;
    private static Opportunity_Offering__c offRec;
    private static Opportunity_Offering__c offRec1;
    private static Opportunity_TGP__c oppRec;
    private static Opportunity_Offering__c newOffRec;
    private static User u;
    private static User u1;
    private static Profile p;
    private static Profile p1;
    private static Offerings_Master__c offMaster;
    private static string USER_NAME = 'vc12@testorg.com';
    private static string USER_NAME_NEW = 'vc13@testorg.com';
    private static final string OFF_NAME = 'test';
    private static Review_User_Master__c revUser;
    private static Review_User_Master__c revUser1;
 
/*
  @Author: 
  @Name: setupData
  @Created Date: 01 January 2015
  @Description: This is a test method setupData for data setup.
  @version: 1.0
*/ 
     public static void setupData(){
     
        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        
        p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        
        u =UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
        Database.insert(u, false);
        
        u1 =UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_NAME_NEW);
        Database.insert(u1, false);
        
        revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('abc@accenture.com','sophia prem kumar');
        revUser.SFDC_User__c = u.id;
        revUser.Is_Active__c = true;
        insert revUser ;
      
        revUser1 = UTIL_DataCreationForTestClass.getReviewUserMaster('abc123@accenture.com','sophia');
        revUser1.SFDC_User__c = u1.id;
        revUser1.Is_Active__c = true;
        insert revUser1 ;

        clientName = UTIL_DataCreationForTestClass.getClientMaster(UTIL_Constants.CLIENT_MASTER);
        Database.insert(clientName, false);
        
        clientGeoArea = UTIL_DataCreationForTestClass.getClientGEOAreaMaster(UTIL_Constants.AsiaPacific);
        Database.insert(clientGeoArea, false);
        
        operatingGroup = UTIL_DataCreationForTestClass.getOperatingGroupMaster(UTIL_Constants.OPERATING_GRP_MASTER_NAME,true);
        Database.insert(operatingGroup, false);
        
        oppRec = UTIL_DataCreationForTestClass.getBPOOpportunityRecord(UTIL_Constants.OPP_NAME,UTIL_Constants.STAGE,clientName.id,clientGeoArea.id,operatingGroup.id,UTIL_Constants.RISK_LEVEL,true,UTIL_Constants.REPORTING_STATUS);
        Database.insert(oppRec, false);
        oppRec.Enterprise_Solution_Architect_New__c = revUser.id;
        oppRec.Complex_Cost_Architect_New__c = revUser1.id;
        oppList.add(oppRec);
        
        offRec = UTIL_DataCreationForTestClass.getOfferingRecord(UTIL_Constants.OFFERING_NAME,oppRec.id);
        offRec.Solution_Specialist_New__c = revUser.id;
        offRec.Solution_Lead_New__c = revUser1 .id;
        offRec.Offering_Solution_Lead_Secondary_New__c = revUser.id;
        insert offRec;
        
        Scheduling_Date__c myCS2 = new Scheduling_Date__c();
        myCS2.Name = 'Execution Date';
        myCS2.Execution_Date__c = System.today();
        insert myCS2;
        
        Scheduling__c sch = new Scheduling__c();
        sch.BPO_Opportunity_MD__c = oppRec.id;
        sch.User_Master__c = revUser1.id;
        sch.First_Date__c = system.now();
        sch.isDateActive__c = true;
        sch.MondayDate__c = system.now();
        sch.MondayDate_1__c = system.now() + 7;
        sch.MondayDate_2__c = system.now() + 7;
        sch.MondayDate_3__c = system.now() + 7;
        insert sch;
        schList.add(sch);
      }
 /*
  @Author: 
  @Name: testSchedulingDateInsert
  @Created Date: 01 January 2015
  @Description:This is a test method testSchedulingDateInsert for testing of shceduling of inseted data.
  @version: 1.0
*/
     static testMethod void testSchedulingDateInsert(){
          setupData();
          Test.startTest();
          UTIL_SchedulingDateInsert usD = new UTIL_SchedulingDateInsert();
          usD.insertSchedulingDate(oppList);    
          Test.stopTest();
      }
 /*
  @Author: 
  @Name: testSchedulingDateUpdate
  @Created Date: 01 January 2015
  @Description: This is a test method testSchedulingDateUpdate for testing of scheduling of date update.
  @version: 1.0
*/     
      static testMethod void testSchedulingDateUpdate(){
          setupData();
          Test.startTest();
          UTIL_SchedulingDateUpdate usDataUpdate = new UTIL_SchedulingDateUpdate();
          usDataUpdate.updateDate(schList);    
          Test.stopTest();
      }
  
 /*
  @Author: 
  @Name: testOppDataManager
  @Created Date: 01 January 2015
  @Description: This is a test method for opportunity data manger.
  @version: 1.0
*/
      static testMethod void testOppDataManager(){
      setupData();
      oppRec.Analytics_Functional_Architect__c = revUser1.id;
      oppRec.Analytics_Solution_Lead__c  = revUser1.id;
      oppRec.BSS_Operation_New__c = revUser1.id;
      oppRec.PrimeSDOLeadName__c = revUser1.id;
      oppRec.SD_Governance_Lead__c = revUser1.id;
      database.update(oppRec);
      List<Opportunity_TGP__c> oppListNew = new List<Opportunity_TGP__c>();
      oppListNew.add(oppRec);
      
      offRec.Functional_Architect_Mobilization_New__c = revUser.id;
      offRec.Solution_Lead_New__c = revUser1 .id;
      offRec.Offering_Solution_Lead_Secondary_New__c = revUser.id;
      offRec.Solution_Specialist_New__c = revUser.id;
      offRec.Technical_Architect_New__c = revUser.id;
      database.update(offRec);
      
      Opportunity_Role_master__c oppRole = new Opportunity_Role_master__c(Name = 'Analytics Functional Architect',Is_Opportunity_Based__c = true);
      Opportunity_Role_master__c oppRole1 = new Opportunity_Role_master__c(Name = 'Analytics Solution Lead',Is_Opportunity_Based__c = true);
      Opportunity_Role_master__c oppRole2 = new Opportunity_Role_master__c(Name = 'BST Operation',Is_Opportunity_Based__c = true);
      Opportunity_Role_master__c oppRole3 = new Opportunity_Role_master__c(Name = 'Complex Cost Architect',Is_Opportunity_Based__c = true);
      Opportunity_Role_master__c oppRole4 = new Opportunity_Role_master__c(Name = 'Prime SDO Lead',Is_Opportunity_Based__c = true);
      Opportunity_Role_master__c oppRole5 = new Opportunity_Role_master__c(Name = 'SD Governance Lead/Coach',Is_Opportunity_Based__c = true);
      Opportunity_Role_master__c oppRole6 = new Opportunity_Role_master__c(Name = 'Mobilization Architect',Is_Offering_Based__c= true);
      Opportunity_Role_master__c oppRole7 = new Opportunity_Role_master__c(Name = 'Solution Architect - BPO',Is_Offering_Based__c= true);
      //Opportunity_Role_master__c oppRole8 = new Opportunity_Role_master__c(Name = 'Solution Architect – BPO',Is_Offering_Based__c= true);
      Opportunity_Role_master__c oppRole9 = new Opportunity_Role_master__c(Name = 'Solution Specialist',Is_Offering_Based__c= true);
      Opportunity_Role_master__c oppRole10 = new Opportunity_Role_master__c(Name = 'Technical Architect',Is_Offering_Based__c= true);
      List<Opportunity_Role_master__c> roleList = new List<Opportunity_Role_master__c>();
      roleList.add(oppRole);
      roleList.add(oppRole1);
      roleList.add(oppRole2);
      roleList.add(oppRole3);
      roleList.add(oppRole4);
      roleList.add(oppRole5);
      roleList.add(oppRole6);
      roleList.add(oppRole7);
      //roleList.add(oppRole8);
      roleList.add(oppRole9);
      roleList.add(oppRole10);
      insert roleList;  
      
      Test.startTest();
      UTIL_OpportunityTeamDataManager oppDm = new UTIL_OpportunityTeamDataManager();
      oppDm.insertOpportuintyTeamRecords(oppListNew);
      Test.stopTest();
      }
    
}