/***********
@ Author : Ezdhan Hussain S K

@description : This is a test class for ApprovalMeetingScheduling,App_Meeting_DailyAgendaController,
                ApprovalMeetingDailyAgendaClass,ApprovalProcessPageController & ApprovalMeetingTrigger 
                
                This test class has 2 testMethods
                1) testDataMethod ---------------- this method creates an Approval Meeting with Meeting Approver Master and hence over ride Approver suggestion is false
                2) testDatamethodWithNoApprover -------- This method creates approval meeting, 
                                                        but Meeting Approver is not auto-populated,hence over ride Approver suggestion is true
Code coverages as of 13 Feb 2015

Class Name                                              Coverage

ApprovalMeetingScheduling                               92%
App_Meeting_DailyAgendaController                       94%
ApprovalMeetingTrigger                                  100%
ApprovalMeetingDailyAgendaClass                         100%
ApprovalProcessPageController                           100%
**************/
@istest
private class AllApprovalMeetingLogic_Test {
    /****************
    @desctiption : Method to create testdata for Approval Meeting Logic And test the initial submission logic with Approver Population
    *****************/
        static testMethod Approval_meeting__c testDatamethod(){
        list<sobject> alldatalist = new list<sobject>();
        id soleditorprofile;
        id soloperationprofile;
       
        for(profile p: [SELECT Id,name FROM Profile WHERE Name='Solution Editor' OR Name = 'Solution Operations' limit 2]){

            if(UtilConstants.WORKBENCH_USER.equalsignorecase(p.name)){
                soleditorprofile = p.id;
            }
            else{
                soloperationprofile = p.id;
            }
        }
        Account acc= new Account(Name='Test Account');
        Daily_Agenda_Mails_List__c Customsettings = new Daily_Agenda_Mails_List__c();
        Customsettings.Name = 'Daily Agenda mails';
        customsettings.to_Addresses__c = 'ezdhan.hussain.s.k@accenture.com,mohan.pedaprolu@accenture.com';
        customsettings.cc_Addresses__c = 'sumalatha.ganga@accenture.com,puvvada.rao@accenture.com';
        FlagforApprovalMails__c flag =new FlagforApprovalMails__c();
        flag.name = UtilConstants.CUSTOM_FLAG;
        flag.sendApprovalMails__c = true;
        flag.runtrigger__C = true;//new added
        insert flag;
        Operating_Groups_Master__c opp_group = new Operating_Groups_Master__c();
        opp_group.Name ='Test operating group';
        opp_group.Active__c = true;
        Geo_Region_Master__c GRM = new Geo_Region_Master__c();
        GRM.name = 'Test Geo Region';
        GRM.active__c = true;
        user soleditoruser = new user(Alias = 'testusr',isActive =true,lastname = 'user',firstname='test',profileid=soleditorprofile,
                                      email='test@accenture.com',username='testuser123456@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
       user soloperationsuser = new user(Alias = 'testsr',isActive =true,lastname = 'user',firstname='operations',profileid=soloperationprofile,
                                      email='test1@accenture.com',username='operationsuser123456@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
                                      
       Meeting_Lync_Details__c lync = new Meeting_Lync_Details__c();
       lync.name = UTIL_Constants.AsiaPacific_twothirtyCST;
       lync.active__c = true;
       lync.lync__c = 'https://www.testlync.accenture.com';                               
        //adding account at index 0
        alldatalist.add(acc);
        //adding custom settings at index 1
        alldatalist.add(customsettings); 
        //adding operating group at index 2
        alldatalist.add(opp_group);
        //adding geo region at index 3
        alldatalist.add(GRM);
        //adding solution editor user at index 4
        alldatalist.add(soleditoruser);
        //adding solution operations user at index 5
        alldatalist.add(soloperationsuser);
        //adding meeting lync details at index 6
        alldatalist.add(lync);
        Database.saveResult[] sreuslt = database.insert (alldatalist);
       for(integer i = 0;i<=alldatalist.size()-1;i++){
        //System.debug(i+':::::::::::::::::::::::::::::::::::::::::::::::::::::::'+alldatalist[i]);
       }
        
        list<user_master__c> usermasters = new list<user_master__c>();
        User_Master__c us_master1 = new User_Master__c();
        us_master1.name = 'Test User master';
        us_master1.email__c = 'test@accenture.com';
        us_master1.user__c = alldatalist[4].id;
        usermasters.add(us_master1);
        User_Master__c us_master2 = new User_Master__c();
        us_master2.name = 'Test User master';
        us_master2.email__c = 'test1@accenture.com';
        us_master2.user__c = alldatalist[5].id;
        usermasters.add(us_master2);
        Database.insert (usermasters);
        
        opportunity opp = new opportunity();
        opp.Name = 'Test Opp';
        opp.accountid = alldatalist[0].id;
        opp.Reporting_Status__c = 'Accenture Withdrew';
        opp.stageName = '0A';
        opp.Geo_Area__c ='test geo area';
        opp.Risk_level__c ='Low';
        opp.Geo_Unit__c = 'test geo unit';
        opp.OperatingGroup__c = alldatalist[2].Id;
        opp.Geo_Region__c = alldatalist[3].id;
        opp.CloseDate = System.today()+10;
        opp.BPO_Net_Rev_Thousands__c = 5000;
        opp.Off__c='testing';
        opp.Prime_SDO_Lead_dev__c='test';
        opp.Delivery_Locations__c='test';
        opp.Opportunity_Solution_Lead__c=us_master1.id;
        Database.insert (opp);
        list<Meeting_Approver_Master__c> list_masters = new list<Meeting_Approver_Master__c>();
      Meeting_Approver_Master__c MAM = new Meeting_Approver_Master__c();
      MAM.Name = 'Test Meeting Approver 1';
      MAM.active__c = true;
      MAM.approver__c = usermasters[1].id;
      MAM.Geo_Region__c = alldatalist[3].id;
      MAM.geo_unit__c = 'test geo unit';
      MAM.Preference__c = 1;
      MAM.tcv_range_minimum__c = 500;
      MAM.tcv_range_maximum__c = 6000;
      list_masters.add(MAM);
      Meeting_Approver_Master__c MAM1 = new Meeting_Approver_Master__c();
      MAM1.Name = 'Test Meeting Approver 2';
      MAM1.active__c = true;
      MAM1.approver__c = usermasters[1].id;
      MAM1.Geo_Region__c = alldatalist[3].id;
      MAM1.geo_unit__c = 'test geo unit';
      MAM1.Preference__c = 2;
      MAM1.tcv_range_minimum__c = 500;
      MAM1.tcv_range_maximum__c = 6000;
      list_masters.add(MAM1);
      Meeting_Approver_Master__c MAM2 = new Meeting_Approver_Master__c();
      MAM2.Name = 'Test Meeting Approver 3'; 
      MAM2.active__c = true;
      MAM2.approver__c = usermasters[1].id;
      MAM2.Preference__c = 1;
      MAM2.tcv_range_minimum__c = 500;
      MAM2.tcv_range_maximum__c = 6000;
      list_masters.add(MAM2);
      Database.insert (list_masters);
            Approval_stage__c app_stage = new Approval_stage__c();
                app_stage.opportunity__c = opp.id;
                app_stage.service_group__c ='BPO';
                app_stage.approval_stage_type__c = 'Fly By - Solution Review';
                Database.saveresult sresult = database.insert(app_stage);
                //System.debug('Approval Stage saved ::::'+sresult);
                List<Approval_Meeting__c> appmeetinglist = new list<Approval_Meeting__c>();
            Approval_meeting__c app_meeting = new Approval_meeting__c();
                app_meeting.service_group__c ='BPO';
                //app_meeting.meeting_status__c='scheduled';
                app_meeting.Approval_Stage__c = app_stage.id;
                app_meeting.Requestor__c = usermasters[0].id;
                app_meeting.Requested_Meeting_Date__c = System.today()+1;
                app_meeting.Requested_Meeting_Time__c = UTIL_Constants.AsiaPacific_twothirtyCST;
                appmeetinglist.add(app_meeting);
                
          Database.insert (appmeetinglist);
          
          ApprovalMeetingScheduling APPM = new ApprovalMeetingScheduling();
            //APPM.repopulateMeetingDescription(appmeetinglist);
            APPM.DeleteApprovalcalendarevents(appmeetinglist);
            //APPM.createApprovalCalendarMeeting(appmeetinglist);
        Approval_meeting__c ap = [select id,Meeting_Approver__r.name from Approval_meeting__c where id=:app_meeting.id limit 1]; 
        System.assertequals(ap.Meeting_Approver__r.name, 'Test Meeting Approver 1');
            AllApprovalMeetingLogic_Test.test_RecallMethod(app_meeting);
            AllApprovalMeetingLogic_Test.test_PendingClarificationMethod(app_meeting);
            
        
       return app_meeting;      
  
    }
    /****************
    @desctiption : Method to create testdata for Approval Meeting Logic And test the initial submission logic with Approver Population
    *****************/
        static testMethod Approval_meeting__c testDatamethodR1(){
        list<sobject> alldatalist = new list<sobject>();
        id soleditorprofile;
        id soloperationprofile;
       
        for(profile p: [SELECT Id,name FROM Profile WHERE Name='IO Solution Editor' OR Name = 'IO Solution Operations' limit 2]){

            if(p.name=='IO Solution Editor'){
                soleditorprofile = p.id;
            }
            else{
                soloperationprofile = p.id;
            }
        }
        Account acc= new Account(Name='Test Account');
        Daily_Agenda_Mails_List__c Customsettings = new Daily_Agenda_Mails_List__c();
        Customsettings.Name = 'Daily Agenda mails';
        customsettings.to_Addresses__c = 'ezdhan.hussain.s.k@accenture.com,mohan.pedaprolu@accenture.com';
        customsettings.cc_Addresses__c = 'sumalatha.ganga@accenture.com,puvvada.rao@accenture.com';
        FlagforApprovalMails__c flag =new FlagforApprovalMails__c();
        flag.name = UtilConstants.CUSTOM_FLAG;
        flag.sendApprovalMails__c = true;
        flag.runtrigger__C = true;//new added
        insert flag;
        Operating_Groups_Master__c opp_group = new Operating_Groups_Master__c();
        opp_group.Name ='Test operating group';
        opp_group.Active__c = true;
        Geo_Region_Master__c GRM = new Geo_Region_Master__c();
        GRM.name = 'Test Geo Region';
        GRM.active__c = true;
        user soleditoruser = new user(Alias = 'testusr',isActive =true,lastname = 'user',firstname='test',profileid=soleditorprofile,
                                      email='test@accenture.com',username='testuser123456@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
       user soloperationsuser = new user(Alias = 'testsr',isActive =true,lastname = 'user',firstname='operations',profileid=soloperationprofile,
                                      email='test1@accenture.com',username='operationsuser123456@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
                                      
       Meeting_Lync_Details__c lync = new Meeting_Lync_Details__c();
       lync.name = UTIL_Constants.AsiaPacific_twothirtyCST;
       lync.active__c = true;
       lync.lync__c = 'https://www.testlync.accenture.com';                               
        //adding account at index 0
        alldatalist.add(acc);
        //adding custom settings at index 1
        alldatalist.add(customsettings); 
        //adding operating group at index 2
        alldatalist.add(opp_group);
        //adding geo region at index 3
        alldatalist.add(GRM);
        //adding solution editor user at index 4
        alldatalist.add(soleditoruser);
        //adding solution operations user at index 5
        alldatalist.add(soloperationsuser);
        //adding meeting lync details at index 6
        alldatalist.add(lync);
        Database.saveResult[] sreuslt = database.insert (alldatalist);
       for(integer i = 0;i<=alldatalist.size()-1;i++){
        //System.debug(i+':::::::::::::::::::::::::::::::::::::::::::::::::::::::'+alldatalist[i]);
       }
        
        
        list<user_master__c> usermasters = new list<user_master__c>();
        User_Master__c us_master1 = new User_Master__c();
        us_master1.name = 'Test User master';
        us_master1.email__c = 'test@accenture.com';
        us_master1.user__c = alldatalist[4].id;
        usermasters.add(us_master1);
        User_Master__c us_master2 = new User_Master__c();
        us_master2.name = 'Test User master';
        us_master2.email__c = 'test1@accenture.com';
        us_master2.user__c = alldatalist[5].id;
        usermasters.add(us_master2);
        Database.insert (usermasters);
        
        opportunity opp = new opportunity();
        opp.Name = 'Test Opp';
        opp.Prime_SDO_Lead_dev__c='test';
        opp.accountid = alldatalist[0].id;
        opp.Reporting_Status__c = 'Accenture Withdrew';
        opp.stageName = '0A';
        opp.Geo_Area__c ='test geo area';
        opp.Risk_level__c ='Low';
        opp.Geo_Unit__c = 'test geo unit';
        opp.OperatingGroup__c = alldatalist[2].Id;
        opp.Geo_Region__c = alldatalist[3].id;
        opp.CloseDate = System.today()+10;
        opp.IO_Net_Revenue_Thousands__c = 5000;
        opp.off__C='test1';
        opp.Delivery_Locations__c='test';
        opp.Opportunity_Solution_Lead__c=us_master1.id;
        Database.insert (opp);
        list<Meeting_Approver_Master__c> list_masters = new list<Meeting_Approver_Master__c>();
      Meeting_Approver_Master__c MAM = new Meeting_Approver_Master__c();
      MAM.Name = 'Test Meeting Approver 1';
      MAM.active__c = true;
      MAM.approver__c = usermasters[1].id;
      MAM.Geo_Region__c = alldatalist[3].id;
      MAM.geo_unit__c = 'test geo unit';
      MAM.Preference__c = 1;
      MAM.tcv_range_minimum__c = 500;
      MAM.tcv_range_maximum__c = 6000;
      list_masters.add(MAM);
      Meeting_Approver_Master__c MAM1 = new Meeting_Approver_Master__c();
      MAM1.Name = 'Test Meeting Approver 2';
      MAM1.active__c = true;
      MAM1.approver__c = usermasters[1].id;
      MAM1.Geo_Region__c = alldatalist[3].id;
      MAM1.geo_unit__c = 'test geo unit';
      MAM1.Preference__c = 2;
      MAM1.tcv_range_minimum__c = 500;
      MAM1.tcv_range_maximum__c = 6000;
      list_masters.add(MAM1);
      Meeting_Approver_Master__c MAM2 = new Meeting_Approver_Master__c();
      MAM2.Name = 'Test Meeting Approver 3';
      MAM2.active__c = true;
      MAM2.approver__c = usermasters[1].id;
      MAM2.Preference__c = 1;
      MAM2.tcv_range_minimum__c = 500;
      MAM2.tcv_range_maximum__c = 6000;
      list_masters.add(MAM2);
      Database.insert (list_masters);
            Approval_stage__c app_stage = new Approval_stage__c();
                app_stage.opportunity__c = opp.id;
                app_stage.service_group__c ='IO';
                app_stage.approval_stage_type__c = 'Fly By - Solution Review';
                Database.saveresult sresult = database.insert(app_stage);
                //System.debug('Approval Stage saved ::::'+sresult);
                List<Approval_Meeting__c> appmeetinglist = new list<Approval_Meeting__c>();
            Approval_meeting__c app_meeting = new Approval_meeting__c();
                app_meeting.service_group__c ='IO';
                app_meeting.Approval_Stage__c = app_stage.id;
                app_meeting.Requestor__c = usermasters[0].id;
                app_meeting.Requested_Meeting_Date__c = System.today()+1;
                app_meeting.Requested_Meeting_Time__c = UTIL_Constants.AsiaPacific_twothirtyCST;
                appmeetinglist.add(app_meeting);
          Database.insert (appmeetinglist);
          ApprovalMeetingScheduling APPM = new ApprovalMeetingScheduling();
            //APPM.repopulateMeetingDescription(appmeetinglist);
            APPM.DeleteApprovalcalendarevents(appmeetinglist);
            APPM.populateFieldsonInsert(appmeetinglist);
        Approval_meeting__c ap = [select id,Meeting_Approver__r.name from Approval_meeting__c where id=:app_meeting.id limit 1];
        System.assertequals(ap.Meeting_Approver__r.name, 'Test Meeting Approver 1');
            AllApprovalMeetingLogic_Test.test_RecallMethod(app_meeting);
            AllApprovalMeetingLogic_Test.test_PendingClarificationMethod(app_meeting);
            
        
       return app_meeting;      
  
    }
   

    /**************************
    @description : test method with no matching approver
    ****************************/
 /*
@name : testDatamethodWithNoApprover
@Description : 
@Version : 

*/ 
        static testMethod Approval_meeting__c testDatamethodWithNoApprover(){
        list<sobject> alldatalist = new list<sobject>();
        id soleditorprofile;
        id soloperationprofile;
        for(profile p: [SELECT Id,name FROM Profile WHERE Name='Solution Editor' OR Name = 'Solution Operations' limit 2]){
            if(UtilConstants.WORKBENCH_USER.equalsignorecase(p.name)){
                soleditorprofile = p.id;
            }
            else{
                soloperationprofile = p.id;
            }
        }
        Account acc= new Account(Name='Test Account');
        Daily_Agenda_Mails_List__c Customsettings = new Daily_Agenda_Mails_List__c();
        Customsettings.Name = 'Daily Agenda mails';
        customsettings.to_Addresses__c = 'ezdhan.hussain.s.k@accenture.com,mohan.pedaprolu@accenture.com';
        customsettings.cc_Addresses__c = 'sumalatha.ganga@accenture.com,puvvada.rao@accenture.com';
          FlagforApprovalMails__c flag =new FlagforApprovalMails__c();
        flag.name = UtilConstants.CUSTOM_FLAG;
        flag.sendApprovalMails__c = true;
        flag.runtrigger__c = true;//new added
        insert flag;
        Operating_Groups_Master__c opp_group = new Operating_Groups_Master__c();
        opp_group.Name ='Test operating group';
        opp_group.Active__c = true;
        Geo_Region_Master__c GRM = new Geo_Region_Master__c();
        GRM.name = 'Test Geo Region';
        GRM.active__c = true;
        user soleditoruser = new user(Alias = 'testusr',isActive =true,lastname = 'user',firstname='test',profileid=soleditorprofile,
                                      email='test@accenture.com',username='testuser123456@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
       user soloperationsuser = new user(Alias = 'testsr',isActive =true,lastname = 'user',firstname='operations',profileid=soloperationprofile,
                                      email='test1@accenture.com',username='operationsuser123456@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
       
       Meeting_Lync_Details__c lync = new Meeting_Lync_Details__c();
       lync.name = UTIL_Constants.AsiaPacific_twothirtyCST;
       lync.active__c = true;
       lync.lync__c = 'https://www.testlync.accenture.com';                               
        //adding account at index 0
        alldatalist.add(acc);
        //adding custom settings at index 1
        alldatalist.add(customsettings); 
        //adding operating group at index 2
        alldatalist.add(opp_group);
        //adding geo region at index 3
        alldatalist.add(GRM);
        //adding solution editor user at index 4
        alldatalist.add(soleditoruser);
        //adding solution operations user at index 5
        alldatalist.add(soloperationsuser);
        //adding meeting lync details at index 6
        alldatalist.add(lync);
        Database.saveResult[] sreuslt = database.insert (alldatalist);
       for(integer i = 0;i<=alldatalist.size()-1;i++){
        //System.debug(i+':::::::::::::::::::::::::::::::::::::::::::::::::::::::'+alldatalist[i]);
       }
       
        list<user_master__c> usermasters = new list<user_master__c>();
        User_Master__c us_master1 = new User_Master__c();
        us_master1.name = 'Test User master';
        us_master1.email__c = 'test@accenture.com';
        us_master1.user__c = alldatalist[4].id;
        usermasters.add(us_master1);
        User_Master__c us_master2 = new User_Master__c();
        us_master2.name = 'Test User master';
        us_master2.email__c = 'test1@accenture.com';
        us_master2.user__c = alldatalist[5].id;
        usermasters.add(us_master2);
        Database.insert (usermasters);
         opportunity opp = new opportunity();
        opp.Name = 'Test Opp';
        opp.accountid = alldatalist[0].id;
        opp.Reporting_Status__c = 'Accenture Withdrew';
        opp.stageName = '0A';
        opp.Geo_Area__c ='test geo area';
        opp.Risk_level__c ='Low';
        opp.Geo_Unit__c = 'test geo unit';
        opp.Prime_SDO_Lead_dev__c='test';
        opp.OperatingGroup__c = alldatalist[2].Id;
        opp.Geo_Region__c = alldatalist[3].id;
        opp.CloseDate = System.today()+10;
        opp.off__c='testtest';
        opp.BPO_Net_Rev_Thousands__c = 5000;
        opp.Opportunity_Solution_Lead__c=us_master1.id;
        opp.Delivery_Locations__c='test';
        Database.insert (opp);
     /*Meeting_Approver_Master__c MAM = new Meeting_Approver_Master__c();
      MAM.Name = 'Test Meeting Approver';
      MAM.active__c = true;
      MAM.approver__c = usermasters[1].id;
      MAM.Geo_Region__c = alldatalist[3].id;
      MAM.geo_unit__c = 'test geo unit';
      MAM.Preference__c = 1;
      MAM.tcv_range_minimum__c = 500;
      MAM.tcv_range_maximum__c = 6000;
      Database.insert (MAM);*/
      
      
            Approval_stage__c app_stage = new Approval_stage__c();
                app_stage.opportunity__c = opp.id;
                app_stage.service_group__c ='BPO';
                app_stage.approval_stage_type__c = 'Fly By - Solution Review';
                
                Database.saveresult sresult = database.insert(app_stage,false);
                //System.debug('Approval Stage saved ::::'+sresult);
                List<Approval_Meeting__c> appmeetinglist = new list<Approval_Meeting__c>();
            Approval_meeting__c app_meeting = new Approval_meeting__c();
                app_meeting.service_group__c ='BPO';
                app_meeting.Approval_Stage__c = app_stage.id;
                app_meeting.Requestor__c = usermasters[0].id;
                app_meeting.Requested_Meeting_Date__c = System.today()+1;
                app_meeting.Requested_Meeting_Time__c = UTIL_Constants.AsiaPacific_twothirtyCST;    
          Database.insert (app_meeting);
        test.starttest();
            AllApprovalMeetingLogic_Test.test_RecallMethod(app_meeting);
            AllApprovalMeetingLogic_Test.test_PendingClarificationMethod(app_meeting);
            
            
        test.stoptest(); 
       return app_meeting;      
  
    }
   
    /*************
    @description : testMethod for recall functionality of Approval Meeting
    ***************/
/*
@name : test_RecallMethod
@Description : 
@Version : 

*/    
public static void test_RecallMethod(Approval_meeting__c approvalrecord){
    try{
    ApprovalMeetingScheduling.run = true;
    
    ApprovalMeetingScheduling.recallMeetingRequest(approvalrecord.id);
    
    Approval_Meeting__c app = [select id,meeting_status__c from approval_meeting__c where id= :approvalrecord.id limit 1];
    System.assertequals(app.Meeting_status__c,label.Approval_Meeting_Recalled);
    }
    Catch(Exception e)
    {
        /*Modified by ezdhan hussain
          @reason Novasuite rule : Empty catch block*/
            string exception_caught = string.valueof(e);
            //system.debug('-----'+exception_caught);
    }
    }
    /*************
    @description : testMethod for Pending clarification functionality of Approval Meeting
    ***************/
/*
@name : test_PendingClarificationMethod
@Description : 
@Version : 

*/     
public static void test_PendingClarificationMethod(Approval_meeting__c approvalrecord){
     try{
     ApprovalMeetingScheduling.run = true;
        approvalrecord.meeting_status__c = label.Approval_meeting_Pending;
        approvalrecord.Comments_Scheduler__c = 'test clarifaication';
     database.update (approvalrecord);    
         System.assertequals(approvalrecord.Meeting_status__c,label.Approval_meeting_Pending);
      AllApprovalMeetingLogic_Test.test_resubmitMethod(approvalrecord);
      AllApprovalMeetingLogic_Test.test_resubmitMethodR1(approvalrecord);
      }
      Catch(Exception e)
      {
          /*Modified by ezdhan hussain
          @reason Novasuite rule : Empty catch block*/
            string exception_caught = string.valueof(e);
            //system.debug('-----'+exception_caught);
      }
    }
   
    /*************
    @description : testMethod for resubmission functionality of Approval Meeting
    ***************/
 /*
@name : test_resubmitMethod
@Description : 
@Version : 

*/ 
public static Approval_meeting__c test_resubmitMethod(Approval_meeting__c approvalrecord){
     
     ApprovalMeetingScheduling.run = true;
        approvalrecord.Request_Submitted_Date__c = system.today();
        try{
              database.update (approvalrecord);
              return approvalrecord;
           }
           Catch(Exception e)
           {
              /*Modified by ezdhan hussain
          @reason Novasuite rule : Empty catch block*/
            string exception_caught = string.valueof(e);
            //system.debug('-----'+exception_caught);
           }
           return null;
    }
    public static Approval_meeting__c test_resubmitMethodR1(Approval_meeting__c approvalrecord){
     
     ApprovalMeetingScheduling.run = false;
        approvalrecord.Request_Submitted_Date__c = system.today();
        try{
              database.update (approvalrecord);
              return approvalrecord;
           }
           Catch(Exception e)
           {
              /*Modified by ezdhan hussain
          @reason Novasuite rule : Empty catch block*/
            string exception_caught = string.valueof(e);
            //system.debug('-----'+exception_caught);
           }
           return null;
    }
    /*************
    @description : testMethod for scheduled functionality and schedule apex class of Approval Meeting
    ***************/
 /*
@name : testSchedulable_withevents
@Description : 
@Version : 
 
    static testMethod void testSchedulable_withevents(){                             
     Approval_meeting__C approvalrecord = AllApprovalMeetingLogic_Test.testDataMethod();
     ApprovalMeetingScheduling.run = true;
    // approvalrecord.scheduled_start__c = system.today(); 
    // approvalrecord.scheduled_end__c = system.today()+1; 
     //approvalrecord.scheduled_meeting_time__c = UTIL_Constants.AsiaPacific_twothirtyCST; 
     approvalrecord.meeting_status__c = label.Approval_Meeting_scheduled;
    // approvalrecord.attendees__c = 'ezdhan.hussain.s.k@accenture.com'; 
    
     database.update (approvalrecord);
        dateavalueforagenda__c datecustomcs = new dateavalueforagenda__c();
        datecustomcs.name ='test custom setting';
        datecustomcs.next_date__c = 13;
        insert datecustomcs;
        // Schedule the test job
    test.starttest();
      String jobId = System.schedule('testScheduledApex',
      ApprovalMeetingDailyAgendaClass.CRON_EXP, 
         new ApprovalMeetingDailyAgendaClass());
    test.stoptest();
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId Limit 5000];

      // Verify the expressions are the same
      System.assertEquals(ApprovalMeetingDailyAgendaClass.CRON_EXP, 
         ct.CronExpression);
        AllApprovalMeetingLogic_Test.test_CancelledMethod(approvalrecord);
        AllApprovalMeetingLogic_Test.test_deleteMethod(approvalrecord);
    }
    */
    
    /************
    @description : testMethod for cancel functionality of Approval Meeting
    ****************/
/*
@name : test_CancelledMethod
@Description : 
@Version : 
*/ 
public static void test_CancelledMethod(Approval_Meeting__c approvalrecord){
     ApprovalMeetingScheduling.run = true;
        approvalrecord.meeting_status__c = label.Approval_Meeting_Cancelled;
      try{
             database.update (approvalrecord);
         }
         Catch(DMLException e)
         {
            /*Modified by ezdhan hussain
  @reason Novasuite rule : Empty catch block
*/
string exception_caught = string.valueof(e);
//system.debug('-----'+exception_caught);
         }
    }
     /************
    @description : testMethod for delete functionality of Approval Meeting
    ****************/
/*
@name : test_deleteMethod
@Description : 
@Version : 

*/ 
public static void test_deleteMethod(Approval_Meeting__c approvalrecord){
     ApprovalMeetingScheduling.run = true;
     try{
     database.delete (approvalrecord);
     }
     Catch(DMLException e)
     {
      /*Modified by ezdhan hussain
          @reason Novasuite rule : Empty catch block*/
       string exception_caught = string.valueof(e);
        //system.debug('-----'+exception_caught);
     }
    }
       /*************
    @description : testMethod for schedule apex class when there are no events for the day
    ***************/
/*
@name : testSchedulable_WithNoEvents
@Description : 
@Version : 
   
static testMethod void  testSchedulable_WithNoEvents(){
        // Schedule the test job
      Approval_meeting__C approvalrecord = AllApprovalMeetingLogic_Test.testDataMethod();
       dateavalueforagenda__c datecustomcs = new dateavalueforagenda__c();
        datecustomcs.name ='test custom setting';
        datecustomcs.next_date__c = 13;
        insert datecustomcs;
     test.starttest();
      String jobId = System.schedule('testScheduledApex1',
      ApprovalMeetingDailyAgendaClass.CRON_EXP, 
         new ApprovalMeetingDailyAgendaClass());
    test.stoptest();
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId Limit 5000];
    //System.debug('Job ID '+jobId+' crontrigger '+ ct);
      // Verify the expressions are the same
      System.assertEquals(ApprovalMeetingDailyAgendaClass.CRON_EXP, 
         ct.CronExpression);
       
    } 
    */  
/*
@name : testApprovalCalendarController
@Description : 
@Version : 
*/
    static testMethod void testApprovalCalendarController(){
        test.startTest();
            ApprovalMeetingCalendarController APPC = new ApprovalMeetingCalendarController();
        test.stopTest();
    }
    Public static TestMethod void Test11(){
        List<Opportunity_Teams__c> Optm=new List<Opportunity_Teams__c>();
        List<Meeting_Lync_Details__c> Mtl=new list<Meeting_Lync_Details__c>();
        string s='test';
        Meeting_Lync_Details__c MLD=new Meeting_Lync_Details__c(name='Test');
        Mtl.add(MLD);
        Meeting_Lync_Details__c MLD1=new Meeting_Lync_Details__c(name='Test');
        Mtl.add(MLD1);
        MLD.name='Test';
        insert MLD;

User_Master__c u=new User_Master__c();
        u.name='test';
        insert u;
        User_Master__c us=new User_Master__c();
        us.name='test1';
        insert us;
        Opportunity_Roles_Master__c opr=new Opportunity_Roles_Master__c();
        opr.name='Test';
        opr.Role_Level__c='Both';
        insert opr;
        Opportunity_Roles_Master__c opr1=new Opportunity_Roles_Master__c();
        opr1.name='Test1';
        opr.Role_Level__c='Both';
        insert opr1;
        Opportunity_Teams__c opteam=new Opportunity_Teams__c();
        opteam.Role__c=opr.id;
        opteam.Opportunity_Team_Member__c=u.id;
        Optm.add(opteam);
        insert opteam;      
        App_Meeting_DailyAgendaController AppMeet=new App_Meeting_DailyAgendaController();
        AppMeet.loadMailTemplate();
        AppMeet.list_meetingdetails=Mtl;
        AppMeet.finaldateval=s;
        AppMeet.oppteamroles=Optm;
        
    }
}