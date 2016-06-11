/*
    @author     : 
    @name :         UTIL_UtilizationDataManagerNew_Test
    @createDate :   
    @description : 
    @version : 
*/
@isTest
private class UTIL_UtilizationDataManagerNew_Test{
/*
@name : UTIL_UtilizationDataManagerNewTest
@Description : 
@Version : 
*/
    static testMethod void UTIL_UtilizationDataManagerNewTest(){
    Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
    String aliasString = 'aliasString';
        User userObj = new User(Alias =aliasString, 
        email= aliasString+'@accenture.com',
        emailencodingkey='UTF-8',
        lastname='Testing', 
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = sysAdminId,
        timezonesidkey='Europe/London',
        username= aliasString+'@accenture.com');
        
        
        //Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
        /*Static User stdUser = new User(
        alias = aliasString, 
        email= aliasString+'@accenture.com',
        emailencodingkey='UTF-8',
        lastname='Testing', 
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = sysAdminId,
        timezonesidkey='Europe/London',
        username= aliasString+'@accenture.com');*/
//        Id Id = UserInfo.getUserId();
        //system.debug('User DetaIls===='+Id);
        
        //User userObj = new User();
        //userObj.add(ID);
         
        List<User_Master__c> UserMaster = new List<User_Master__c>();
        User_Master__c um =new User_Master__c(Name = 'test User', user__c = userObj.Id, Active__c= True, canBeApprover__c = True); 
        User_Master__c um1 =new User_Master__c(Name = 'test User1', user__c = userObj.Id, Active__c= True, canBeApprover__c = True); 
        User_Master__c um2 =new User_Master__c(Name = 'test User2', user__c = userObj.Id, Active__c= True, canBeApprover__c = True); 
        UserMaster.add(um);
        UserMaster.add(um1);
        UserMaster.add(um2);
        insert UserMaster; 
        //system.debug('User Masters='+UserMaster);
        
        Account acc;
        acc = new account();
        acc.name = 'Test Client';
        //testaccounts.add(acc);
        insert acc;
        
        Operating_Groups_Master__c ogm;
        ogm= new Operating_Groups_Master__c();
        ogm.Name='OGM Test';
        //opp_testgroups.add(ogm);
        insert ogm;
        List<Opportunity> Opplist =new List<Opportunity>();
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Training';
        opp.accountid = acc.id;
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Active__c = true ;
        Opplist.add(opp);
        //insert opp;
        
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Other Deal Support';
        opp1.accountid = acc.id;
        opp1.Reporting_Status__c = UtilConstants.WON;
        opp1.Geo_Area__c = UtilConstants.EALA;
        opp1.OperatingGroup__c = ogm.id;
        opp1.StageName = UtilConstants.TWO_B;
        opp1.Risk_Level__c = UtilConstants.NORMAL;
        opp1.CloseDate = System.today();
        opp1.Active__c = true ;
//        insert opp1;
        Opplist.add(opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Other Unavailable';
        opp2.accountid = acc.id;
        opp2.Reporting_Status__c = UtilConstants.WON;
        opp2.Geo_Area__c = UtilConstants.EALA;
        opp2.OperatingGroup__c = ogm.id;
        opp2.StageName = UtilConstants.TWO_B;
        opp2.Risk_Level__c = UtilConstants.NORMAL;
        opp2.CloseDate = System.today();
        opp2.Active__c = true ;
        Opplist.add(opp2);
      //  insert opp2;
        
        //oppListnew[2].Name = 'Other Unavailable';
        //oppListnew[2].Active__c = true ;
        //insert oppListnew[2];
        
        insert oppList;
        //system.debug('oppList========'+oppList);
        //system.debug('User Masters='+UserMaster[0].id);
        //system.debug('User Masters========'+opp2);
        
        List<Utilizations__c> Utilist = new List<Utilizations__c>();      
        Utilizations__c Util = new Utilizations__c(); 
        Util.Opportunity__c= opp2.Id; 
        Util.User__c =um.id  ;
        Util.Current_Week__c= 0;
        Util.Current_Week_1__c= 0;
        Util.Current_Week_2__c= 0;
        Util.Current_Week_3__c= 0;
        Util.Current_Week_4__c= 0;
        Util.Name= 'Test';
        Utilist.add(Util);        
        
        insert Utilist;
        
        Test.startTest();  
        UTIL_UtilizationDataManagerNew UtilTest =new UTIL_UtilizationDataManagerNew();
        UtilTest.insertUtilizationRecordsforDummyOpp(UserMaster); 
        Test.stopTest();  
    }
     /*    
        @Name :         test2
        @Description :  Test for createSpendSavingsPlan in ProcurementClass
        */
    static  testMethod void negativetest_UTIL_utilization(){
        List<User_Master__c> UserMaster = new List<User_Master__c>();
 
        //system.debug('User Masters='+UserMaster);
        
        Account acc;
        acc = new account();
        acc.name = 'Test Client';
        //testaccounts.add(acc);
        insert acc;
        
        Operating_Groups_Master__c ogm;
        ogm= new Operating_Groups_Master__c();
        ogm.Name='OGM Test';
        //opp_testgroups.add(ogm);
        insert ogm;
        List<Opportunity> Opplist =new List<Opportunity>();
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Training';
        opp.accountid = acc.id;
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Active__c = true ;
        Opplist.add(opp);
        //insert opp;
        
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Other Deal Support';
        opp1.accountid = acc.id;
        opp1.Reporting_Status__c = UtilConstants.WON;
        opp1.Geo_Area__c = UtilConstants.EALA;
        opp1.OperatingGroup__c = ogm.id;
        opp1.StageName = UtilConstants.TWO_B;
        opp1.Risk_Level__c = UtilConstants.NORMAL;
        opp1.CloseDate = System.today();
        opp1.Active__c = true ;
//        insert opp1;
        Opplist.add(opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Other Unavailable';
        opp2.accountid = acc.id;
        opp2.Reporting_Status__c = UtilConstants.WON;
        opp2.Geo_Area__c = UtilConstants.EALA;
        opp2.OperatingGroup__c = ogm.id;
        opp2.StageName = UtilConstants.TWO_B;
        opp2.Risk_Level__c = UtilConstants.NORMAL;
        opp2.CloseDate = System.today();
        opp2.Active__c = true ;
        Opplist.add(opp2);
      //  insert opp2;
        
        //oppListnew[2].Name = 'Other Unavailable';
        //oppListnew[2].Active__c = true ;
        //insert oppListnew[2];
        
        insert oppList;
      
        Test.startTest();  
        UTIL_UtilizationDataManagerNew UtilTest =new UTIL_UtilizationDataManagerNew();
        UtilTest.insertUtilizationRecordsforDummyOpp(UserMaster); 
        Test.stopTest();
    }
}