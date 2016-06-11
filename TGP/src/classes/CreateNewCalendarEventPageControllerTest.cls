/*
    Author : Shridhar Patankar
    Story  :   SOL_077
    Description :As a PMO, I should be able to schedule approval meeting on a shared calendar.

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------


    */
    @isTest
    private class CreateNewCalendarEventPageControllerTest{
      static User testUser;
      static User testUser1; 
      
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
       static Review_Meeting_Request__c meetingRecord;
       static Review_Meeting_Request__c meetingRecord1;
       static Review_Meeting_Request__c meetingRecord2;
       static Review_Meeting_Request__c meetingRecord3;
       static Review_Meeting_Request__c meetingRecord4;
       static Review_Meeting_Request__c meetingRecord5;
       static Review_Meeting_Request__c meetingRecord6;
       static Review_Process__c reviewProcess;
       static Event ev;
       static Event ev1;
       static Calendar_Event__c calEvent;
       static Calendar_Event__c calEvent1;
       static Calendar_Event__c calEvent2;
       static Calendar_Event__c calEvent3;
       static Calendar_Event__c calEvent4;
       static Calendar_Event__c calEvent5;
       static Calendar_Event__c calEvent6;
       static Approver_Master__c approveMaster;
       static Approver_Master__c approveMaster1;
       static Approver_Master__c approveMaster2;
       static Approver_Master__c approveMaster3;
       static Approver_Master__c approveMaster4;
       static User_for_Calendar__c userForCal;
       static String USER_Name = 'vc7@testorg.com';
       static Review_User_Master__c testUserMaster;
       
        public static void setupData(){
         
            
          Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
         Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
        Database.insert(testUser1, false);
                    
           testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
           insert testUserMaster; 
           
          system.Runas(testUser1)
         { 
          clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
          insert clientName;
          
          clientGeoArea = new Client_Geo_Area_Master__c (Name = 'North America',Active__c = true);
          insert clientGeoArea;
          
          operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
          insert operatingGroup;
          
          clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
          insert clientGeoUnit; 
          
          userForCal = new User_for_Calendar__c(Name='test1',User_Name__c='uCal23ss5@t.com');
          insert userForCal;
          
         }
          system.Runas(testUser)
         {
          oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUserMaster.id ,Complex_Cost_Architect_New__c=testUserMaster.id,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
          insert oppTGP;
          }
      }
      public static void setupData00(){
          setupData();
          assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
          insert assumptionMaster;
         
          approveMaster = new Approver_Master__c(Name='USer1',Approver_Mail_ID__c='shrid@gg.com',TCV_Range__c='40-100M',Region__c='North America');
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
         
          ev = new Event(Subject='TestTest',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='North America');
          insert ev;
         
          ev1 = new Event(Subject='TestTest1',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='APAC');
          insert ev1;
         
          reviewProcess = new Review_Process__c(Status__c ='Submitted');
          insert reviewProcess;
         
          meetingRecord = new Review_Meeting_Request__c(Client_Name__c='test1',BPO_Opportunity__c=oppTGP.id,TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='North America (10am CST)');
          insert meetingRecord;
         
          meetingRecord1 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=55000,Status__c='Scheduled',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
          insert meetingRecord1;
         
          calEvent = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'North America',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
          insert calEvent;
         
          calEvent1 = new Calendar_Event__c(TCV__c =55000,Subject__c='Testing1',Region__c = 'North America',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord1.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
          insert calEvent1;
       }
       
       public static void setupData01(){
           setupData();
           assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
           insert assumptionMaster;
         
           approveMaster = new Approver_Master__c(Name='USer1',Approver_Mail_ID__c='shrid@gg.com',TCV_Range__c='40-100M',Region__c='North America');
           insert approveMaster;
         
           approveMaster1 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='10-40M',Region__c='APAC');
           insert approveMaster1;
          
           offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
           insert offeringMaster;

           serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
           insert serviceMaster;
         
           oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
           insert oppOffering;
         
           assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
           insert assumption;
         
           DateTime dte = Datetime.now();
         
           ev = new Event(Subject='TestTest',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='North America');
           insert ev;
         
           reviewProcess = new Review_Process__c(Status__c ='Scheduled');
           insert reviewProcess;
         
           meetingRecord = new Review_Meeting_Request__c(Client_Name__c='test1',TCV_M__c=58000,Status__c='Scheduled',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='North America (10am CST)');
           insert meetingRecord;
         
           meetingRecord1 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=25000,Status__c='Cancelled',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
           insert meetingRecord1;
         
           calEvent = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'North America',Review_Meeting_Request__c=meetingRecord.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent;
           calEvent1 = new Calendar_Event__c(TCV__c =55000,Subject__c='Testing1',Region__c = 'North America',Review_Meeting_Request__c=meetingRecord1.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent1;
       }
       
       public static void setupData02(){
          setupData();
          assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
          insert assumptionMaster;
         
          approveMaster = new Approver_Master__c(Name='USer1',Approver_Mail_ID__c='shrid@gg.com',TCV_Range__c='40-100M',Region__c='North America');
          insert approveMaster;
         
          approveMaster1 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='10-40M',Region__c='APAC');
          insert approveMaster1;
          
          approveMaster2 = new Approver_Master__c(Name='USer12',Approver_Mail_ID__c='shrid1@gg2.com',TCV_Range__c='40-100M',Region__c='EMEA');
          insert approveMaster2;
          
          approveMaster3 = new Approver_Master__c(Name='USer13',Approver_Mail_ID__c='shrid1@gg3.com',TCV_Range__c='10-40M',Region__c='Latin America');
          insert approveMaster3;
          
          approveMaster4 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='10-40M',Region__c='APAC');
          //insert approveMaster4;
           
          offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
          insert offeringMaster;

          serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
          insert serviceMaster;
         
          oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
          insert oppOffering;
         
          assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
          insert assumption;
         
          DateTime dte = Datetime.now();
         
          ev = new Event(Subject='TestTest',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='North America');
          insert ev;
         
          ev1 = new Event(Subject='TestTest1',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='APAC');
          insert ev1;
         
          reviewProcess = new Review_Process__c(Status__c ='Submitted');
          insert reviewProcess;
         
          meetingRecord = new Review_Meeting_Request__c(Client_Name__c='test1',TCV_M__c=58000,BPO_Opportunity__c=oppTGP.id,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)');
          insert meetingRecord;
         
          meetingRecord1 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=15000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
          insert meetingRecord1;
          
          meetingRecord2 = new Review_Meeting_Request__c(Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)');
          insert meetingRecord2;
         
          meetingRecord3 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=25000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
          insert meetingRecord3;
         
          calEvent = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'EMEA',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
          insert calEvent;
         
          calEvent1 = new Calendar_Event__c(TCV__c =55000,Subject__c='Testing1',Region__c = 'APAC',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord1.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
          insert calEvent1;
          
          calEvent2 = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'Latin America',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord2.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent2;
           calEvent3 = new Calendar_Event__c(TCV__c =25000,Subject__c='Testing1',Region__c = 'APAC',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord3.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent3;
       }
       
       public static void setupData03(){
           setupData();
           assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
           insert assumptionMaster;
         
           approveMaster = new Approver_Master__c(Name='USer1',Approver_Mail_ID__c='shrid@gg.com',TCV_Range__c='40-100M',Region__c='North America');
           insert approveMaster;
         
           approveMaster1 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='100M+',Region__c='APAC');
           insert approveMaster1;
          
           approveMaster2 = new Approver_Master__c(Name='USer12',Approver_Mail_ID__c='shrid1@gg2.com',TCV_Range__c='40-100M',Region__c='EMEA');
           insert approveMaster2;
          
           approveMaster3 = new Approver_Master__c(Name='USer13',Approver_Mail_ID__c='shrid1@gg3.com',TCV_Range__c='10-40M',Region__c='Latin America');
           insert approveMaster3;
          
           approveMaster4 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='10-40M',Region__c='EMEA');
           //insert approveMaster4;
           
           testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
           insert testUserMaster; 
           
           offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
           insert offeringMaster;

           serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
           insert serviceMaster;
         
           oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
           insert oppOffering;
         
           assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
           insert assumption;
         
           DateTime dte = Datetime.now();
         
           ev = new Event(Subject='TestTest',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='North America');
           insert ev;
         
           reviewProcess = new Review_Process__c(Status__c ='Scheduled');
           insert reviewProcess;
         
           meetingRecord = new Review_Meeting_Request__c(Client_Name__c='test1',BPO_Opportunity__c=oppTGP.id,TCV_M__c=158000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)');
           insert meetingRecord;
         
           meetingRecord1 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=25000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
           insert meetingRecord1;
           
           meetingRecord2 = new Review_Meeting_Request__c(Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)');
           insert meetingRecord2;
         
           meetingRecord3 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=25000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
           insert meetingRecord3;
           /*
           meetingRecord6 = new Review_Meeting_Request__c(Requester_User__c=testUser1.id,Client_Name__c='test11',TCV_M__c=1500,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)',Opportunity_Name__c=oppTGP.name,Opportunity_ID__c=oppTGP.id,Opportunity_Solution_lead__c='testlead',review_Process__c=reviewProcess.id ,Complex_Cost_Architect_New__c=testUserMaster.id);
           insert meetingRecord6;    
           */
           calEvent = new Calendar_Event__c(TCV__c =158000.00,Subject__c='Testing1',Region__c = 'Latin America',Review_Meeting_Request__c=meetingRecord.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent;
           calEvent1 = new Calendar_Event__c(TCV__c =25000,Subject__c='Testing1',Region__c = 'EMEA',Review_Meeting_Request__c=meetingRecord1.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent1;
           
           calEvent2 = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'EMEA',Review_Meeting_Request__c=meetingRecord2.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent2;
           calEvent3 = new Calendar_Event__c(TCV__c =25000,Subject__c='Testing1',Region__c = 'Latin America',Review_Meeting_Request__c=meetingRecord3.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent3;
           /*
           calEvent6 = new Calendar_Event__c(TCV__c =1500,Subject__c='Testing1',Review_Meeting_Request__c=meetingRecord6.id,Region__c = 'North America',Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent6;*/
       }
       
       public static void setupData04(){
           setupData();
           assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
           insert assumptionMaster;
         
           approveMaster = new Approver_Master__c(Name='USer1',IS_SFDC_User__c=true,Approver_Mail_ID__c='shrid@gg.com',TCV_Range__c='10-40M',Region__c='North America');
           insert approveMaster;
         
           approveMaster1 = new Approver_Master__c(Name='USer11',IS_SFDC_User__c=true,Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='100M+',Region__c='APAC');
           insert approveMaster1;
          
           approveMaster2 = new Approver_Master__c(Name='USer12',IS_SFDC_User__c=true,Approver_Mail_ID__c='shrid1@gg2.com',TCV_Range__c='40-100M',Region__c='EMEA');
           insert approveMaster2;
          
           approveMaster3 = new Approver_Master__c(Name='USer13',IS_SFDC_User__c=true,Approver_Mail_ID__c='shrid1@gg3.com',TCV_Range__c='10-40M',Region__c='Latin America');
           insert approveMaster3;
          
           approveMaster4 = new Approver_Master__c(Name='USer11',IS_SFDC_User__c=true,Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='10-40M',Region__c='EMEA');
           insert approveMaster4;
           
           offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
           insert offeringMaster;

           serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
           insert serviceMaster;
         
           oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
           insert oppOffering;
         
           assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
           insert assumption;
         
           DateTime dte = Datetime.now();
         
           reviewProcess = new Review_Process__c(Status__c ='Scheduled');
           insert reviewProcess;
         
           meetingRecord1 = new Review_Meeting_Request__c(Requester_User__c=testUser1.id,BPO_Opportunity__c=oppTGP.id,Client_Name__c='test1',TCV_M__c=15000,Status__c='Scheduled',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)',Opportunity_Name__c=oppTGP.name,Opportunity_ID__c=oppTGP.id,Opportunity_Solution_lead__c='testlead',review_Process__c=reviewProcess.id ,Complex_Cost_Architect__c='test CCA');
           insert meetingRecord1;
         
           meetingRecord = new Review_Meeting_Request__c(Requester_User__c=testUser1.id,Client_Name__c='test23',BPO_Opportunity__c=oppTGP.id,TCV_M__c=25000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)',Opportunity_Name__c=oppTGP.name,Opportunity_ID__c=oppTGP.id,Opportunity_Solution_lead__c='testlead',review_Process__c=reviewProcess.id ,Complex_Cost_Architect__c='test CCA');
           insert meetingRecord;
            
           meetingRecord2 = new Review_Meeting_Request__c(Requester_User__c=testUser1.id,Client_Name__c='test1',TCV_M__c=-150,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)',Opportunity_Name__c=oppTGP.name,Opportunity_ID__c=oppTGP.id,Opportunity_Solution_lead__c='testlead',review_Process__c=reviewProcess.id ,Complex_Cost_Architect__c='test CCA');
           insert meetingRecord2;
         
           meetingRecord3 = new Review_Meeting_Request__c(Requester_User__c=testUser1.id,Client_Name__c='test231',TCV_M__c=25000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)',Opportunity_Name__c=oppTGP.name,Opportunity_ID__c=oppTGP.id,Opportunity_Solution_lead__c='testlead',review_Process__c=reviewProcess.id ,Complex_Cost_Architect__c='test CCA');
           insert meetingRecord3;   
           
           meetingRecord4 = new Review_Meeting_Request__c(Requester_User__c=testUser1.id,Client_Name__c='test11',TCV_M__c=1500,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)',Opportunity_Name__c=oppTGP.name,Opportunity_ID__c=oppTGP.id,Opportunity_Solution_lead__c='testlead',review_Process__c=reviewProcess.id ,Complex_Cost_Architect__c='test CCA');
           insert meetingRecord4;
         
           meetingRecord5 = new Review_Meeting_Request__c(Requester_User__c=testUser1.id,Client_Name__c='test23',TCV_M__c=45000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)',Opportunity_Name__c=oppTGP.name,Opportunity_ID__c=oppTGP.id,Opportunity_Solution_lead__c='testlead',review_Process__c=reviewProcess.id ,Complex_Cost_Architect__c='test CCA');
           insert meetingRecord5;   
           
           ev = new Event(Subject='TestTest',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='North America',Meeting_Record_ID__c=meetingRecord5.id);
           insert ev; 
         
           calEvent1 = new Calendar_Event__c(TCV__c =15000,Subject__c='Testing1',Region__c = 'North America',Review_Meeting_Request__c=meetingRecord.id,
                            Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',
                            End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent1;
           calEvent = new Calendar_Event__c(TCV__c =25000,Subject__c='Testing1',Region__c = 'North America',Review_Meeting_Request__c=meetingRecord1.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent;     
            
           calEvent2 = new Calendar_Event__c(TCV__c =-150,Subject__c='Testing1',Region__c = 'North America',Review_Meeting_Request__c=meetingRecord2.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent2;
           calEvent3 = new Calendar_Event__c(TCV__c =25000,Subject__c='Testing1',Review_Meeting_Request__c=meetingRecord3.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent3;   
           
           calEvent4 = new Calendar_Event__c(TCV__c =1500,Subject__c='Testing1',Region__c = 'North America',Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent4;
           calEvent5 = new Calendar_Event__c(TCV__c =35000,Subject__c='Testing1',Review_Meeting_Request__c=meetingRecord5.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent5; 
           
       }
       
       public static void setupData05(){
           setupData();
           assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
           insert assumptionMaster;
         
           approveMaster = new Approver_Master__c(Name='USer1',Approver_Mail_ID__c='shrid@gg.com',TCV_Range__c='40-100M',Region__c='North America');
           insert approveMaster;
         
           approveMaster1 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='100M+',Region__c='APAC');
           insert approveMaster1;
          
           approveMaster2 = new Approver_Master__c(Name='USer12',Approver_Mail_ID__c='shrid1@gg2.com',TCV_Range__c='40-100M',Region__c='EMEA');
           insert approveMaster2;
          
           approveMaster3 = new Approver_Master__c(Name='USer13',Approver_Mail_ID__c='shrid1@gg3.com',TCV_Range__c='10-40M',Region__c='Latin America');
           insert approveMaster3;
          
           approveMaster4 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='10-40M',Region__c='EMEA');
           insert approveMaster4;
           
           offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
           insert offeringMaster;

           serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
           insert serviceMaster;
         
           oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
           insert oppOffering;
         
           assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
           insert assumption;
         
           DateTime dte = Datetime.now();
         
           ev = new Event(Subject='TestTest',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='North America');
           insert ev;
         
           reviewProcess = new Review_Process__c(Status__c ='Scheduled');
           insert reviewProcess;
                  
           meetingRecord2 = new Review_Meeting_Request__c(Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)');
           insert meetingRecord2;
                  
           meetingRecord3 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=25000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
           insert meetingRecord3;
           
           meetingRecord6 = new Review_Meeting_Request__c(Requester_User__c=testUser1.id,Client_Name__c='test11',TCV_M__c=1500,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)',Opportunity_Name__c=oppTGP.name,Opportunity_ID__c=oppTGP.id,Opportunity_Solution_lead__c='testlead',review_Process__c=reviewProcess.id ,Complex_Cost_Architect__c='test CCA');
           insert meetingRecord6;    
           
           calEvent2 = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'EMEA',Review_Meeting_Request__c=meetingRecord2.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent2;
                      
           calEvent3 = new Calendar_Event__c(TCV__c =25000,Subject__c='Testing1',Region__c = 'Latin America',Review_Meeting_Request__c=meetingRecord3.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent3;
           
           calEvent6 = new Calendar_Event__c(TCV__c =1500,Subject__c='Testing1',Review_Meeting_Request__c=meetingRecord6.id,Region__c = 'North America',Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,Additional_Invitees__c='USer1;USer11;USer12;USer13;',End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent6;
       }
       
       public static void setupData06(){
          setupData();
          assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
          insert assumptionMaster;
         
          approveMaster = new Approver_Master__c(Name='USer1',Approver_Mail_ID__c='shrid@gg.com',TCV_Range__c='40-100M',Region__c='North America');
          insert approveMaster;
         
          approveMaster1 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='10-40M',Region__c='APAC');
          insert approveMaster1;
          
          approveMaster2 = new Approver_Master__c(Name='USer12',Approver_Mail_ID__c='shrid1@gg2.com',TCV_Range__c='40-100M',Region__c='EMEA');
          insert approveMaster2;
          
          approveMaster3 = new Approver_Master__c(Name='USer13',Approver_Mail_ID__c='shrid1@gg3.com',TCV_Range__c='10-40M',Region__c='Latin America');
          insert approveMaster3;
          
          approveMaster4 = new Approver_Master__c(Name='USer11',Approver_Mail_ID__c='shrid1@gg1.com',TCV_Range__c='10-40M',Region__c='APAC');
          //insert approveMaster4;
           
          offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
          insert offeringMaster;

          serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
          insert serviceMaster;
         
          oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
          insert oppOffering;
         
          assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
          insert assumption;
         
          DateTime dte = Datetime.now();
         
          ev = new Event(Subject='TestTest',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='North America');
          insert ev;
         
          ev1 = new Event(Subject='TestTest1',OwnerId=testUser.id,StartDateTime=dte,EndDateTime=Datetime.now(),ActivityDateTime=dte ,IsAllDayEvent=false,Region__c ='APAC');
          insert ev1;
         
          reviewProcess = new Review_Process__c(Status__c ='Submitted');
          insert reviewProcess;
         
          meetingRecord = new Review_Meeting_Request__c(Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)');
          insert meetingRecord;
         
          /*meetingRecord1 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=15000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
          insert meetingRecord1;*/
          
          meetingRecord2 = new Review_Meeting_Request__c(Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EMEA (7am CST)');
          insert meetingRecord2;
         
          meetingRecord3 = new Review_Meeting_Request__c(Client_Name__c='test23',TCV_M__c=25000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='APAC (10 pm CST)');
          insert meetingRecord3;
         
          calEvent = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'EMEA',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
          insert calEvent;
         
          /*calEvent1 = new Calendar_Event__c(TCV__c =55000,Subject__c='Testing1',Region__c = 'APAC',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord1.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
          insert calEvent1;*/
          
          calEvent2 = new Calendar_Event__c(TCV__c =58000.00,Subject__c='Testing1',Region__c = 'Latin America',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord2.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent2;
           calEvent3 = new Calendar_Event__c(TCV__c =25000,Subject__c='Testing1',Region__c = 'APAC',Additional_Invitees__c='USer1;USer11;USer12;USer13;',Review_Meeting_Request__c=meetingRecord3.id,Assigned_To__c=testUser.id,Start_Date__c=Datetime.now()+2,End_Date__c=Datetime.now()+7,Approver_Master__c=approveMaster.id,Description__c='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>');
           insert calEvent3;
       }
       
       static testMethod void testCreateNewCalendarEventPageController(){
       test.starttest();
       PageReference pageRef = Page.CreateNewCalendarEventPage;
       Test.setCurrentPage(pageRef);
             setupData00();
                  Blob content;
           if (Test.IsRunningTest())
           {
                content=Blob.valueOf('UNIT.TEST');
           }
           else
           {
                content=pageRef.getContent();
           }
             
            //pageRef.getParameters().put('id', ev.id);
            pageRef.getParameters().put('calID', meetingRecord.id);
            
             
             //ApexPages.StandardController controller= new ApexPages.StandardController();
             ApexPages.StandardController controller;
             CreateNewCalendarEventPageController createNewCalenderEventPg = new CreateNewCalendarEventPageController(controller);
             set<String> mailAddresses;
             String userid;
             String value;
             
             createNewCalenderEventPg .chkMail();
             createNewCalenderEventPg .initializePageMessages();
             createNewCalenderEventPg .setDescription();
             createNewCalenderEventPg .fillApproverValue();
             createNewCalenderEventPg .changeMeeting();
             //createNewCalenderEventPg .sendEmailToApprover(mailAddresses,event.id);
             
             createNewCalenderEventPg .getMeetingRecordDetails();
             createNewCalenderEventPg .findUserName(userid);
             createNewCalenderEventPg .continueSaveApprover();
             createNewCalenderEventPg .notSaveApprover();
             createNewCalenderEventPg .addNewInvitees();
             createNewCalenderEventPg .checkNullValues(value);
             createNewCalenderEventPg .changeApprover();
             createNewCalenderEventPg.getApprovers();
             createNewCalenderEventPg.getStatusValues();
             //createNewCalenderEventPg.opportunityRecord = oppTGP;
             createNewCalenderEventPg .saveEvent();
             
             createNewCalenderEventPg.newCalEvent= calEvent ;
             createNewCalenderEventPg.meetingRecord = meetingRecord;
             
             Event createCalendarEvent =createNewCalenderEventPg.createCalendarEvent(approveMaster.id);
             
             pageRef.getParameters().put('calID', meetingRecord1.id);
             ApexPages.StandardController controller1;
             CreateNewCalendarEventPageController createNewCalenderEventPg1 = new CreateNewCalendarEventPageController(controller1);
             createNewCalenderEventPg1.newCalEvent= calEvent1 ;
             createNewCalenderEventPg1.fillApproverValue();
             //createNewCalenderEventPg.opportunityRecord = oppTGP;
             createNewCalenderEventPg1.saveEvent();
             createNewCalenderEventPg1.changeMeeting();
             createNewCalenderEventPg1.changeApprover();
             
           test.stoptest(); 
       } 
       static testMethod void testCreateNewCalendarEventPageControllerClass(){
       test.starttest();
       PageReference pageRef = Page.CreateNewCalendarEventPage;
       Test.setCurrentPage(pageRef);
             setupData00();
                  Blob content;
           if (Test.IsRunningTest())
           {
                content=Blob.valueOf('UNIT.TEST');
           }
           else
           {
                content=pageRef.getContent();
           }
             
            //pageRef.getParameters().put('id', ev.id);
            pageRef.getParameters().put('calID', meetingRecord.id);
            
             
             //ApexPages.StandardController controller= new ApexPages.StandardController();
             ApexPages.StandardController controller;
             CreateNewCalendarEventPageController createNewCalenderEventPg = new CreateNewCalendarEventPageController(controller);
             set<String> mailAddresses;
             String userid;
             String value;
             List<string> strList = new List<string>{'test'};
            
             //createNewCalenderEventPg.opportunityRecord = oppTGP;
             createNewCalenderEventPg.approverList = strList;
             createNewCalenderEventPg .saveEvent();
             
           test.stoptest(); 
       } 
       static testMethod void testCreateNewCalendarEventPageController1(){
       test.starttest();
             setupData01();
    PageReference pageRef = Page.CreateNewCalendarEventPage;
       Test.setCurrentPage(pageRef);
             
                  Blob content;
           if (Test.IsRunningTest())
           {
                content=Blob.valueOf('UNIT.TEST');
           }
           else
           {
                content=pageRef.getContent();
           }
             pageRef.getParameters().put('id', ev.id);
             
             ApexPages.StandardController controller;
             CreateNewCalendarEventPageController createNewCalenderEventPg = new CreateNewCalendarEventPageController(controller);
             
             set<String> mailAddresses;
             String userid;
             String value;
             
             createNewCalenderEventPg .chkMail();
             createNewCalenderEventPg .initializePageMessages();
             createNewCalenderEventPg .setDescription();
             createNewCalenderEventPg .fillApproverValue();
             createNewCalenderEventPg .changeMeeting();
             //createNewCalenderEventPg .sendEmailToApprover(mailAddresses);
             createNewCalenderEventPg.opportunityRecord = oppTGP;
             createNewCalenderEventPg .saveEvent();
             //createNewCalenderEventPg .getMeetingRecordDetails();
             createNewCalenderEventPg .findUserName(userid);
             createNewCalenderEventPg .continueSaveApprover();
             //createNewCalenderEventPg .notSaveApprover();
             createNewCalenderEventPg .addNewInvitees();
             createNewCalenderEventPg .checkNullValues(value);
             
             pageRef.getParameters().put('calID', meetingRecord1.id);
             ApexPages.StandardController controller1;
             CreateNewCalendarEventPageController createNewCalenderEventPg1 = new CreateNewCalendarEventPageController(controller1);
             createNewCalenderEventPg1.newCalEvent= calEvent1 ;
             createNewCalenderEventPg1.fillApproverValue();
             createNewCalenderEventPg.opportunityRecord = oppTGP;
             createNewCalenderEventPg1.saveEvent();
             createNewCalenderEventPg1.changeMeeting();
             createNewCalenderEventPg1.changeApprover();
             
           test.stoptest(); 
       }
       
       
       static testMethod void testCreateNewCalendarEventPageController2(){
       test.starttest();
             setupData02();
              PageReference pageRef = Page.CreateNewCalendarEventPage;
       Test.setCurrentPage(pageRef);
             
                  Blob content;
           if (Test.IsRunningTest())
           {
                content=Blob.valueOf('UNIT.TEST');
           }
           else
           {
                content=pageRef.getContent();
           }
             pageRef.getParameters().put('calID', meetingRecord.id);
             ApexPages.StandardController controller;
             CreateNewCalendarEventPageController createNewCalenderEventPg = new CreateNewCalendarEventPageController(controller);
             set<String> mailAddresses;
             String userid;
             String value;
             
             createNewCalenderEventPg .chkMail();
             createNewCalenderEventPg .initializePageMessages();
             createNewCalenderEventPg .setDescription();
             createNewCalenderEventPg .fillApproverValue();
             createNewCalenderEventPg .changeMeeting();
             //createNewCalenderEventPg .sendEmailToApprover(mailAddresses);
             createNewCalenderEventPg.opportunityRecord = oppTGP;
             createNewCalenderEventPg .saveEvent();
             createNewCalenderEventPg .getMeetingRecordDetails();
             createNewCalenderEventPg .findUserName(userid);
             createNewCalenderEventPg .continueSaveApprover();
             createNewCalenderEventPg .notSaveApprover();
             createNewCalenderEventPg .addNewInvitees();
             createNewCalenderEventPg .checkNullValues(value);             
             
             pageRef.getParameters().put('calID', meetingRecord1.id);
             ApexPages.StandardController controller1;
             CreateNewCalendarEventPageController createNewCalenderEventPg1 = new CreateNewCalendarEventPageController(controller1);
             createNewCalenderEventPg1.newCalEvent= calEvent1 ;
             createNewCalenderEventPg1.fillApproverValue();
             //createNewCalenderEventPg.opportunityRecord = oppTGP;
             createNewCalenderEventPg1.saveEvent();
             createNewCalenderEventPg1.changeMeeting();
             createNewCalenderEventPg1.changeApprover();
                          
           test.stoptest(); 
       }  
       static testMethod void testCreateNewCalendarEventPageController22(){
       test.starttest();
             setupData03();
              PageReference pageRef = Page.CreateNewCalendarEventPage;
       Test.setCurrentPage(pageRef);
             
                  Blob content;
           if (Test.IsRunningTest())
           {
                content=Blob.valueOf('UNIT.TEST');
           }
           else
           {
                content=pageRef.getContent();
           }
             pageRef.getParameters().put('calID', meetingRecord.id);
             ApexPages.StandardController controller;
             CreateNewCalendarEventPageController createNewCalenderEventPg = new CreateNewCalendarEventPageController(controller);
             set<String> mailAddresses;
             String userid;
             String value;
             createNewCalenderEventPg.fillApproverValue();
             //createNewCalenderEventPg.saveEvent();
             createNewCalenderEventPg.changeMeeting();
             createNewCalenderEventPg.getApprovers();
             createNewCalenderEventPg.getStatusValues();
             createNewCalenderEventPg.changeApprover();      
             
             pageRef.getParameters().put('calID', meetingRecord1.id);
             ApexPages.StandardController controller1;
             CreateNewCalendarEventPageController createNewCalenderEventPg1 = new CreateNewCalendarEventPageController(controller1);
             createNewCalenderEventPg1.newCalEvent= calEvent1 ;
             createNewCalenderEventPg1.fillApproverValue();
             //createNewCalenderEventPg.opportunityRecord = oppTGP;
             createNewCalenderEventPg1.saveEvent();
             createNewCalenderEventPg1.changeMeeting();
             createNewCalenderEventPg1.changeApprover();
             
           test.stoptest(); 
       }  
       
       
       static testMethod void testCreateNewCalendarEventPageController21(){
       test.starttest();
            setupData04();
              PageReference pageRef = Page.CreateNewCalendarEventPage;
       Test.setCurrentPage(pageRef);
             
                  Blob content;
           if (Test.IsRunningTest())
           {
                content=Blob.valueOf('UNIT.TEST');
           }
           else
           {
                content=pageRef.getContent();
           }
           
             pageRef.getParameters().put('calID', meetingRecord1.id);
             ApexPages.StandardController controller1;
             CreateNewCalendarEventPageController createNewCalenderEventPg1 = new CreateNewCalendarEventPageController(controller1);
             createNewCalenderEventPg1.newCalEvent= calEvent1 ;
             createNewCalenderEventPg1.fillApproverValue();
             createNewCalenderEventPg1.changeMeeting();
             createNewCalenderEventPg1.approverList = new String[]{};
             createNewCalenderEventPg1.approverList.add(approveMaster1.id);
             //createNewCalenderEventPg1.appMas.add(approveMaster);
             createNewCalenderEventPg1.statusValue= 'Cancelled';
             //createNewCalenderEventPg1.saveEvent();
             
             testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
             insert testUserMaster; 
             
             Opportunity_TGP__c oppTGP1;
             system.Runas(testUser1)
             {
              oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUserMaster.id ,Complex_Cost_Architect_New__c=testUserMaster.id,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
              insert oppTGP1;
             
             
             Review_User_Master__c appUserMaster = new Review_User_Master__c(Name='test1',Email_ID_of_the_reviewer__c='test1@test.com',Is_Active__c=true);
             insert appUserMaster ;
             
             //Opportunity_Offering__c oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering1',Opportunity_TGP__c=oppTGP1.id,Solution_lead__c=testUser.id ,Domain_Expert_Functional_Architect__c=testUser.id,Functional_Architect_Mobilization__c=testUser.id,Offering_Solution_Lead_Secondary__c=testUser.id,Solution_Specialist__c=testUser.id,Technical_Architect_New__c=appUserMaster.id);
            // insert oppOffering1;
             
             pageRef.getParameters().put('calID', meetingRecord.id);
             ApexPages.StandardController controller;
             CreateNewCalendarEventPageController createNewCalenderEventPg = new CreateNewCalendarEventPageController(controller);
             set<String> mailAddresses = new set<String>();
             String userid;
             String value;

             createNewCalenderEventPg.fillApproverValue();
             createNewCalenderEventPg.opportunityRecord=oppTGP1 ;
             createNewCalenderEventPg.saveEvent();
             createNewCalenderEventPg.changeMeeting();
             createNewCalenderEventPg.getApprovers();
             createNewCalenderEventPg.getStatusValues();
             createNewCalenderEventPg.changeApprover();
             mailAddresses.add('shrid@gg.com');
             approveMaster.IS_SFDC_User__c=true;

             }               
           test.stoptest(); 
       } 
        static testMethod void testCreateNewCalendarEventPageController21_New() { 
            Test.startTest();
                setupData04();
                PageReference pageRef = Page.CreateNewCalendarEventPage;
                Test.setCurrentPage(pageRef);
                Blob content=Blob.valueOf('UNIT.TEST');
                pageRef.getParameters().put('calID', meetingRecord1.id);
                ApexPages.StandardController controller1;
                CreateNewCalendarEventPageController createNewCalenderEventPg1 = new CreateNewCalendarEventPageController(controller1);
                createNewCalenderEventPg1.newCalEvent= calEvent1 ;
                createNewCalenderEventPg1.statusValue= 'Cancelled';
                //createNewCalenderEventPg1.saveEvent();
                createNewCalenderEventPg1.changeMeeting();
                createNewCalenderEventPg1.approverList = new String[]{};
                createNewCalenderEventPg1.approverList.add(approveMaster1.id);

                testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
               insert testUserMaster; 

                Opportunity_TGP__c oppTGP1;
                system.Runas(testUser1) {
                    oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                          Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUserMaster.id ,Complex_Cost_Architect_New__c=testUserMaster.id,
                          Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
                    insert oppTGP1;
                    Review_User_Master__c appUserMaster = new Review_User_Master__c(Name='test1',Email_ID_of_the_reviewer__c='test1@test.com',Is_Active__c=true);
                    insert appUserMaster ;
                 
                    //Opportunity_Offering__c oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering1',Opportunity_TGP__c=oppTGP1.id,Solution_lead__c=testUser.id ,Domain_Expert_Functional_Architect__c=testUser.id,Functional_Architect_Mobilization__c=testUser.id,Offering_Solution_Lead_Secondary__c=testUser.id,Solution_Specialist__c=testUser.id,Technical_Architect_New__c=appUserMaster.id);
                    //insert oppOffering1;
                    pageRef.getParameters().put('calID', meetingRecord2.id);
                    ApexPages.StandardController controller2;
                    CreateNewCalendarEventPageController createNewCalenderEventPg2 = new CreateNewCalendarEventPageController(controller2);
                    createNewCalenderEventPg2.newCalEvent= calEvent2 ;
                    //createNewCalenderEventPg2.saveEvent();
                    //createNewCalenderEventPg2.mailers();
                    CreateNewCalendarEventPageController.checkNullValuesDeciamlTCV(100);
                 
                }
            Test.stopTest();
        }
        
        //Added by Apoorva
        
       /* static testMethod void testCreateNewCalendarEventPageController21_New1() { 
            Test.startTest();
                setupData04();
                PageReference pageRef = Page.CreateNewCalendarEventPage;
                Test.setCurrentPage(pageRef);
                Blob content=Blob.valueOf('UNIT.TEST');
                pageRef.getParameters().put('calID', meetingRecord1.id);
                ApexPages.StandardController controller1;
                CreateNewCalendarEventPageController createNewCalenderEventPg1 = new CreateNewCalendarEventPageController(controller1);
                createNewCalenderEventPg1.newCalEvent= calEvent1 ;
                createNewCalenderEventPg1.statusValue= 'Cancelled';
                //createNewCalenderEventPg1.saveEvent();
                //createNewCalenderEventPg1.changeMeeting();
                //createNewCalenderEventPg1.approverList = new String[]{};
              //  createNewCalenderEventPg1.approverList.add(approveMaster1.id);

                testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
               insert testUserMaster; 

                Opportunity_TGP__c oppTGP1;
                system.Runas(testUser1) {
                    oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                          Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUserMaster.id ,Complex_Cost_Architect_New__c=testUserMaster.id,
                          Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
                    insert oppTGP1;
                    Review_User_Master__c appUserMaster = new Review_User_Master__c(Name='test1',Email_ID_of_the_reviewer__c='test1@test.com',Is_Active__c=true);
                    insert appUserMaster ;
                 
                    //Opportunity_Offering__c oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering1',Opportunity_TGP__c=oppTGP1.id,Solution_lead__c=testUser.id ,Domain_Expert_Functional_Architect__c=testUser.id,Functional_Architect_Mobilization__c=testUser.id,Offering_Solution_Lead_Secondary__c=testUser.id,Solution_Specialist__c=testUser.id,Technical_Architect_New__c=appUserMaster.id);
                    //insert oppOffering1;
                    //pageRef.getParameters().put('calID', meetingRecord2.id);
                    ApexPages.StandardController controller2;
                    CreateNewCalendarEventPageController createNewCalenderEventPg2 = new CreateNewCalendarEventPageController(controller2);
                    //createNewCalenderEventPg2.newCalEvent= calEvent2 ;
                    //createNewCalenderEventPg2.saveEvent();
                    createNewCalenderEventPg2.mailers();
                    //CreateNewCalendarEventPageController.checkNullValuesDeciamlTCV(100);
                 
                }
            Test.stopTest();
        }
        */
        //
        
        static testMethod void testCreateNewCalendarEventPageController30() 
        { 
            Test.startTest();
            
            Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
            User testUser6 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'vc723@testorg.com');
            insert testUser6;
            
            setupData05();
            
            system.Runas(testUser6)
            {
                PageReference pageRef = Page.CreateNewCalendarEventPage;
                Test.setCurrentPage(pageRef);
                Blob content=Blob.valueOf('UNIT.TEST');
                
                pageRef.getParameters().put('calID', meetingRecord2.id);
                ApexPages.StandardController controller2;
                CreateNewCalendarEventPageController createNewCalenderEventPg2 = new CreateNewCalendarEventPageController(controller2);
                createNewCalenderEventPg2.newCalEvent= calEvent2 ;
                createNewCalenderEventPg2.fillApproverValue();
                //createNewCalenderEventPg2.saveEvent();
                createNewCalenderEventPg2.changeApprover();
                
                pageRef.getParameters().put('calID', meetingRecord3.id);
                ApexPages.StandardController controller3;
                CreateNewCalendarEventPageController createNewCalenderEventPg3 = new CreateNewCalendarEventPageController(controller3);
                createNewCalenderEventPg3.newCalEvent= calEvent3 ;
                createNewCalenderEventPg3.fillApproverValue();
                //createNewCalenderEventPg3.saveEvent();
                createNewCalenderEventPg3.changeApprover();
             
                pageRef.getParameters().put('calID', meetingRecord6.id);
                ApexPages.StandardController controller6;
                CreateNewCalendarEventPageController createNewCalenderEventPg6 = new CreateNewCalendarEventPageController(controller6);
                createNewCalenderEventPg6.newCalEvent= calEvent6 ;
                createNewCalenderEventPg6.continueSave=false;
                //createNewCalenderEventPg6.saveEvent();
            }
            Test.stopTest();
        } 
        
        static testMethod void testCreateNewCalendarEventPageController31() 
        { 
            Test.startTest();
            
            Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
            User testUser6 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'vc7231@testorg.com');
            insert testUser6;
            
            setupData06();
            
            system.Runas(testUser6)
            {
                PageReference pageRef = Page.CreateNewCalendarEventPage;
                Test.setCurrentPage(pageRef);
                Blob content=Blob.valueOf('UNIT.TEST');
                
                pageRef.getParameters().put('calID', meetingRecord2.id);
                ApexPages.StandardController controller2;
                CreateNewCalendarEventPageController createNewCalenderEventPg2 = new CreateNewCalendarEventPageController(controller2);
                createNewCalenderEventPg2.newCalEvent= calEvent2 ;
                createNewCalenderEventPg2.fillApproverValue();
                //createNewCalenderEventPg2.saveEvent();
                createNewCalenderEventPg2.changeApprover();
                
                pageRef.getParameters().put('calID', meetingRecord3.id);
                ApexPages.StandardController controller3;
                CreateNewCalendarEventPageController createNewCalenderEventPg3 = new CreateNewCalendarEventPageController(controller3);
                createNewCalenderEventPg3.newCalEvent= calEvent3 ;
                createNewCalenderEventPg3.fillApproverValue();
                //createNewCalenderEventPg3.saveEvent();
                createNewCalenderEventPg3.changeApprover();             
                
            }
            Test.stopTest();
        }       
        
    }