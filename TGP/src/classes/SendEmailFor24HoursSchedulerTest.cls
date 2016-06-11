/*
Author : Shridhar Patankar
Story  : Release 2  
Description : Test Class for SendEmailFor24HoursScheduler. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class SendEmailFor24HoursSchedulerTest{
   static User testUser; 
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Opportunity_TGP__c oppTGP1;
   static Opportunity_Team__c oppTeam;
   static Opportunity_Role_Master__c roleMaster;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Assumption__c assumption;
   static SAP_OM_Opportunity__c sAPOMOpp; 
   static Event lstevent1;
   static Review_Meeting_Request__c rmr;
   static Calendar_Event__c ce;
   static Approver_Master__c appamster;
   static Outbound_Email_User_Master__c outEmailUserMaster;
   static Outbound_Email_User_Master__c outEmailUserMaster1;
   static String USER_Name = 'vc7@testorg.com';
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        insert testUser;
      
      outEmailUserMaster = new Outbound_Email_User_Master__c(Outbound_Email_User_Name__c='test',Email_ID__c='test@tes.com',Active__c=true);
      insert outEmailUserMaster;
      
      outEmailUserMaster1 = new Outbound_Email_User_Master__c(Outbound_Email_User_Name__c='test1',Email_ID__c='test1@tes1.com',Active__c=true);
      insert outEmailUserMaster1;
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'testLATAM',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
      insert oppTGP;
      
      roleMaster = new Opportunity_Role_Master__c(Name = 'Prime SDO Lead');
      
      insert roleMaster;
      
     oppTeam = new Opportunity_Team__c(Offering__c = null,BPO_Opportunity__c = oppTGP.Id,Roles__c = roleMaster.Id);
     
     insert oppTeam;
     
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
     
     rmr = new Review_Meeting_Request__c(Has_Email_Sent__c=false,BPO_Opportunity__c=oppTGP.id,Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='North America (10am CST)');
     insert rmr;
     
     datetime t = System.now();
     lstevent1 = new Event(StartDateTime=t+1,EndDateTime=t+2,ActivityDateTime=t+1,Meeting_Record_ID__c=rmr.id,IsAllDayEvent=false,Subject='testSub',OwnerId=testUser.id);
     insert lstevent1;
     
     appamster = new Approver_Master__c(Approver_Mail_ID__c='a1@logo.com',Region__c='testRegion',TCV_Range__c='testTCV');
     insert appamster;
     
     datetime dt = System.now();
     ce = new Calendar_Event__c(Start_Date__c=dt+1,End_Date__c=dt+4,TCV__c=5454,Subject__c='TestCalenderEvent',Review_Meeting_Request__c=rmr.id,Approver_Master__c=appamster.id);
     insert ce;
     
     
     
   }
  
    static testMethod void testSendEmailFor24HoursScheduler(){
    test.starttest();
      setupData();
      
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name);
        insert testUser;
        
        datetime t = System.now();
        String value;
        List<User> us = new List<User>();
        us.add(testUser);
        String userid;
        List<Outbound_Email_User_Master__c> outboundMasterList = new List<Outbound_Email_User_Master__c>();
        List<Event> lstevent2 = new List<Event>();
        Event lstevent = new Event(StartDateTime=t+1,EndDateTime=t+2,ActivityDateTime=t+1,IsAllDayEvent=false,Subject='testSub',OwnerId=testUser.id);
        insert lstevent ;
        
        lstevent2.add(lstevent);
        String eventID;
        String clientName1;
        String oppName;
        String oppID;
        String oppSolLead;
        String offerings;
        String solSpecialists;
        String geoArea;
        String geoUnit;
        String opGroup;
        String description;
        String opportunityID;
        String meetingTime;
        String opportunityLink;
        List <Client_Geo_Area_Master__c> clientList = new List<Client_Geo_Area_Master__c>();
        List <Client_Geo_Unit_Master__c> clientUnitList = new List<Client_Geo_Unit_Master__c>();
        List <Client_Master__c> clientMasterName = new List<Client_Master__c>();
        
       
       clientMasterName =[Select name from Client_Master__c];
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'LATAM'];
       clientUnitList =[Select name from Client_Geo_Unit_Master__c];
       SendEmailFor24HoursScheduler.getEmailAddresses(outboundMasterList);
       SendEmailFor24HoursScheduler.sendEmail24Hours();
       
       //SendEmailFor24HoursScheduler.formTable24Hours(lstevent2,eventID,clientName1,oppName,oppID,oppSolLead,offerings,solSpecialists,
                                                      //geoArea,geoUnit,opGroup,outboundMasterList,us,description,opportunityID,meetingTime, opportunityLink);
       SendEmailFor24HoursScheduler.checkNullValues(value);
       SendEmailFor24HoursScheduler.findUserName(us,userid);
       
    test.stoptest(); 
    } 
    
}