@isTest
private class UTIL_TestMethods_Test{
    
    static testMethod void UTIL_TestMethodsTest(){
    Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
     String pname = p.name;
    Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
   //String proname= [select Name from Profile where id =:id1];
    
    String aliasString = 'aling';
        User userObj = new User(Alias =aliasString, 
        email= aliasString+'@accenture.com',
        CommunityNickname='Test',
        emailencodingkey='UTF-8',
        lastname='Testing', 
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = sysAdminId,
        timezonesidkey='Europe/London',
        username= aliasString+'@accenture.com');
        
        insert userObj;
//List<PaginationRecords__c > listpgr =new List<PaginationRecords__c >();
         PaginationRecords__c pgr =new  PaginationRecords__c();
         pgr.Name='Test';
         pgr.NumberofRecords__c=1;
            insert pgr;
             
           Test.startTest();    
UTIL_TestMethods.runningUser(aliasString,pname);
UTIL_TestMethods.createCustomSetting('Name',1);
UTIL_TestMethods.runningUser('xyz','XYZ'); 
     Test.stopTest();
   
    }
 }