@isTest
/*
@name : UTIL_UtilizationDataUpdateNew_Test
@Description : 
@Version : 
*/
private class UTIL_UtilizationDataUpdateNew_Test{
/*
@name : UTIL_UtilizationDataUpdateNewTest
@Description : 
@Version : 
*/
  static testMethod void UTIL_UtilizationDataUpdateNewTest(){
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
        
        List<User_Master__c> UserMaster = new List<User_Master__c>();
        User_Master__c um =new User_Master__c(Name = 'test User', user__c = userObj.Id, Active__c= True, canBeApprover__c = True); 

        UserMaster.add(um);
        
        insert UserMaster; 
        
        List<Utilizations__c> lisutil =new List<Utilizations__c>();
        Utilizations__c util =new Utilizations__c();
        util.Name=UtilConstants.NAME ;
        util.User__c=UserMaster[0].id;
        util.Current_Week__c=1;
        util.Current_Week_1__c=2;
        util.Current_Week_2__c=3;
        util.Current_Week_3__c=4;
        util.Current_Week_4__c=5;
        
        lisutil.add(util);
        
        insert lisutil;  
        
        List<Utilization_weekStartDate__c> lisutildate =new List<Utilization_weekStartDate__c>();
        Utilization_weekStartDate__c utildate =new Utilization_weekStartDate__c();
        utildate.Name=UtilConstants.NAME;
        utildate.Referenced_Date__c=System.Today(); 
        
        lisutildate.add(utildate);
        
        insert lisutildate;
        
        Test.startTest();  
        UTIL_UtilizationDataUpdateNew UtilTest =new UTIL_UtilizationDataUpdateNew();
        UtilTest.updateData(lisutil); 
        UtilTest.updateDateInCustomSetting(lisutildate); 
        Test.stopTest();       
    
    }
    
    
 }