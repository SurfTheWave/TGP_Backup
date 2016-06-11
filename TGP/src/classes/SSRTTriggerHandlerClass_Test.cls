/************
Class  Name : 
************/
@istest
/************
Class  Name : 
************/
private class SSRTTriggerHandlerClass_Test {
/************
Method  Name : 
************/
    static List<Opportunity> test_data(){
           List<Operating_Groups_Master__c> opp_testgroups = new List<Operating_Groups_Master__c>();
        Operating_Groups_Master__c opp_group;
        for(integer i =0;i<=5;i++){
        opp_group = new Operating_Groups_Master__c();
        opp_group.Name ='Test operating group '+i+'';
        opp_group.Active__c = true;
        opp_testgroups.add(opp_group);
        }
        insert opp_testgroups;
        List<account> testaccounts = new List<account>();
        Account acc;
        for(integer i =0;i<=5;i++){
            acc = new account();
            acc.name = 'Test Client Master'+i+'';
            //system.debug(' Accounts:::::::::::::::::::::'+acc);
            testaccounts.add(acc);
        }
        insert testaccounts;
        
        
        List<Opportunity> test_opps = new List<opportunity>();
        opportunity opp;
        for(integer i =0;i<=5;i++){
            opp  = new opportunity();
            opp.Name = 'Test Opp'+i+'';
            opp.accountid = testaccounts.get(i).id;
            opp.Reporting_Status__c = 'Accenture Withdrew';
            opp.stageName = '0A';
            opp.Geo_Area__c ='test geo area';
            opp.Risk_level__c ='Low';
            opp.Geo_Unit__c = 'test geo unit';
            opp.OperatingGroup__c = opp_testgroups.get(i).id;
            opp.CloseDate = System.today()+10;
            opp.BPO_Net_Rev_Thousands__c = 5000;
            test_opps.add(opp);
        }
        insert test_opps;
        
        Opportunity_Roles_Master__c opprole = new Opportunity_Roles_Master__c();
        opprole.name = 'Content Manager';
        //opprole.Description__c = 'Test Role';
        opprole.Active__c = true;
        opprole.BPO_Role__c = true;
        opprole.HaveEditAccessOnOpportunity__c = true;
        opprole.Role_Level__c ='Opportunity';
        opprole.IC_Role__c = true;
        opprole.IO_Role__c = true;
        insert opprole; 
        return test_opps;
    }
/************
Method  Name : 
************/
    static testMethod void test_withoutcontentintegrator(){
        List<opportunity> test_opps = SSRTTriggerHandlerClass_Test.test_data();
        List<SSRT_Content_Management_Request__c> testSSRTs = new List<SSRT_Content_Management_Request__c>();
        SSRT_Content_Management_Request__c ssrt;
        for(integer i =0;i<=5;i++){
            ssrt = new SSRT_Content_Management_Request__c();
            ssrt.Opportunity__c = test_opps.get(i).id;
            testSSRTs.add(ssrt);
        }
        test.startTest();
        insert testSSRTs; 
        SSRTTriggerHandlerClass.run = true;
        delete testSSRTs;
        test.stopTest();
    }
/************
Method  Name : 
************/
    static testMethod void test_datawithcontentintegrator(){
        List<opportunity> test_opps = SSRTTriggerHandlerClass_Test.test_data();
        set<id> oppids = new set<id>();
        for(Opportunity opp : test_opps){
        oppids.add(opp.id);
        }
         id soleditorprofile;
        id soloperationprofile;
         
        for(profile p: [SELECT Id,name FROM Profile WHERE Name=:Label.solution_editor_profile OR Name =:Label.Solution_Operations_Profile_Name LIMIT 2]){
            if(UtilConstants.WORKBENCH_USER.equalsignorecase(p.name)){

                soleditorprofile = p.id;
            }
            else{
                soloperationprofile = p.id;
            }
        }
         user soleditoruser = new user(Alias = 'testr1',isActive =true,lastname = 'user1',firstname='test1',profileid=soleditorprofile,
                                      email='tefast@accenture.com',username='testuser12ddq3456@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
       user soloperationsuser = new user(Alias = 'testsr1',isActive =true,lastname = 'user2',firstname='operations2',profileid=soloperationprofile,
                                      email='tesdst1@accenture.com',username='operationsuser123dd456@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
        List<user> users = new list<user>{soleditoruser,soloperationsuser};
        insert users;
        list<user_master__c> usermasters = new list<user_master__c>();
        User_Master__c us_master1 = new User_Master__c();
        us_master1.name = 'Test User master1';
        us_master1.email__c = 'test@accenture.com';
        us_master1.user__c = users[0].id;
        usermasters.add(us_master1);
        User_Master__c us_master2 = new User_Master__c();
        us_master2.name = 'Test User master1';
        us_master2.email__c = 'test1@accenture.com';
        us_master2.user__c = users[1].id;
        usermasters.add(us_master2);
        insert usermasters ;
        List<SSRT_Content_Management_Request__c> testSSRTs = new List<SSRT_Content_Management_Request__c>();
        SSRT_Content_Management_Request__c ssrt;
        for(integer i =0;i<=5;i++){
            ssrt = new SSRT_Content_Management_Request__c();
            ssrt.Opportunity__c = test_opps.get(i).id;
            ssrt.content_integrator__c = usermasters[0].id;
            testSSRTs.add(ssrt);
        }  
         test.startTest();
        SSRTTriggerHandlerClass.run = true;
        insert testSSRTs;
        test.stopTest();
         List<SSRT_Content_Management_Request__c> testSSRTsupdate = new List<SSRT_Content_Management_Request__c>();
         for(SSRT_Content_Management_Request__c ss : testSSRTs){
              ss.content_integrator__c = usermasters[1].id;
              testSSRTsupdate.add(ss);
          }
        SSRTTriggerHandlerClass.run = true;
        update testSSRTsupdate;
        SSRTTriggerHandlerClass.run = true;
        delete testSSRTsupdate;
         
      
    }
  
}