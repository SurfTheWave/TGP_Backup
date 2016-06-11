/*
Author : Shridhar Patankar
Story  : Release 2  
Description : Test Class for SendEmailForFollowingWeekScheduler. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class SendEmailForFollowingWeekSchedulerTest{
   static User testUser; 
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Opportunity_TGP__c oppTGP1;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Assumption__c assumption;
   static SAP_OM_Opportunity__c sAPOMOpp; 
   static Review_Meeting_Request__c rmr;
   static Approver_Master__c approveMaster;
   static Review_Meeting_Request__c meetingRecord;
   static Review_Meeting_Request__c meetingRecord1;
   static Calendar_Event__c calEvent;
   static Calendar_Event__c calEvent1;
   static Event ev;
   static Event ev1;
   static Review_Process__c reviewProcess;
   static Outbound_Email_User_Master__c outEmailUserMaster;
   static Outbound_Email_User_Master__c outEmailUserMaster1;
   static Outbound_Email_User_Master__c outEmailUserMaster2;
   static Outbound_Email_User_Master__c outEmailUserMaster3;
   static String USER_Name = 'vc7@testorg.com';
    static String USER_Name1 = 'vc71@testorg.com';
   
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name1);
     Database.insert(testUser, false);
      
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
   
   public static void setupData00(){
          setupData();
          assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
          insert assumptionMaster;
         
          approveMaster = new Approver_Master__c(Name='USer1',Approver_Mail_ID__c='shrid@gg.com',TCV_Range__c='0-10M',Region__c='North America');
          insert approveMaster;
          
          offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
          insert offeringMaster;

          serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
          insert serviceMaster;
         
          oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
          insert oppOffering;
         
          assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
          insert assumption;
         
          DateTime dte = Datetime.now();
         
          reviewProcess = new Review_Process__c(Status__c ='Submitted');
          insert reviewProcess;
         
          meetingRecord = new Review_Meeting_Request__c(BPO_Opportunity__c=oppTGP.id,Has_Email_Sent__c=false,Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='North America (10am CST)');
          insert meetingRecord;
         
          meetingRecord1 = new Review_Meeting_Request__c(BPO_Opportunity__c=oppTGP.id,Has_Email_Sent__c=false,Client_Name__c='test23',TCV_M__c=55000,Status__c='Scheduled',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
          insert meetingRecord1;
                  
          ev = new Event(Subject='TestTest',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='North America',Meeting_Record_ID__c =meetingRecord.id);
          insert ev;
         
          ev1 = new Event(Subject='TestTest1',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='APAC',Meeting_Record_ID__c =meetingRecord1.id);
          insert ev1;
                  
          calEvent = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'North America',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EALA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
          insert calEvent;
         
          calEvent1 = new Calendar_Event__c(TCV__c =55000,Subject__c='Testing1',Region__c = 'North America',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord1.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EALA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
          insert calEvent1;
       }
   
   public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name);
     insert testUser;
      
      outEmailUserMaster2 = new Outbound_Email_User_Master__c(Outbound_Email_User_Name__c='test2',Email_ID__c='test2@tes.com',Active__c=true);
      insert outEmailUserMaster2;
      
      outEmailUserMaster3 = new Outbound_Email_User_Master__c(Outbound_Email_User_Name__c='test12',Email_ID__c='test12@tes1.com',Active__c=true);
      insert outEmailUserMaster3;
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'testEALA',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
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
     
     rmr = new Review_Meeting_Request__c(Has_Email_Sent__c=false,BPO_Opportunity__c=oppTGP.id,Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='North America (10am CST)');
     insert rmr;
     
   }
    static testMethod void testSendEmailForFollowingWeekScheduler(){
    test.starttest();
      setupData();
      
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,'vc1234@testorg.com');
     insert testUser;
        datetime t = System.now();
        String value;
        List<User> us = new List<User>();
        us.add(testUser);
        String userid;
        List<Outbound_Email_User_Master__c> outboundMasterList = new List<Outbound_Email_User_Master__c>();
        List<Event> lstevent2 = new List<Event>();
        Event lstevent = new Event(StartDateTime=t,EndDateTime=t+2,ActivityDateTime=t,IsAllDayEvent=false,Subject='testSub',OwnerId=testUser.id);
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
        String documentLink;
        List <Client_Geo_Area_Master__c> clientList = new List<Client_Geo_Area_Master__c>();
        List <Client_Geo_Unit_Master__c> clientUnitList = new List<Client_Geo_Unit_Master__c>();
        List <Client_Master__c> clientMasterName = new List<Client_Master__c>();
        
       
       clientMasterName =[Select name from Client_Master__c];
       clientList =[Select name from Client_Geo_Area_Master__c where name=:'LATAM'];
       clientUnitList =[Select name from Client_Geo_Unit_Master__c];
       SendEmailForFollowingWeekScheduler.sendEmail7Days();
       SendEmailForFollowingWeekScheduler.getEmailAddresses(outboundMasterList);
       SendEmailForFollowingWeekScheduler.formTable7Days(lstevent2,eventID,clientName1,oppName,oppID,oppSolLead,offerings,solSpecialists,
                                                      geoArea,geoUnit,opGroup,outboundMasterList,us,description,opportunityID,meetingTime,documentLink);
       SendEmailForFollowingWeekScheduler.checkNullValues(value);
       SendEmailForFollowingWeekScheduler.findUserName(us,userid);
       
    test.stoptest(); 
    } 
    static testMethod void testSendEmailForFollowingWeekScheduler2(){
       test.starttest();
       //static testMe();
       setupData00();
      SendEmailForFollowingWeekScheduler.sendEmail7Days();
       test.stoptest(); 
    } 
}