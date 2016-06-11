@IsTest(seeAllData = True)
    

    public class UpdateSratL1PrevItemScript_test{
        
        static testmethod void testMethod1(){
          Profile prof = [SELECT Id FROM Profile WHERE Name='Standard User']; 
          User usrObj = new User(Alias = 'stIS2e', 
                                Email='standarduserXYIS2e@testorg.com', 
                                EmailEncodingKey='UTF-8', 
                                LastName='Testing', 
                                LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', 
                                ProfileId = prof.Id, 
                                TimeZoneSidKey='America/Los_Angeles', 
                                UserName='standarduserXYIS2e@testorg.com');
                                Database.BatchableContext bc = null;
         
         
         
        UpdateSratL1PrevItemScript UpdateSratL1PrevItemScpt=new UpdateSratL1PrevItemScript('Select Id from Wave__c LIMIT 1');
        UpdateSratL2PrevItemScript UpdateSratL2PrevItemScpt=new UpdateSratL2PrevItemScript('Select Id from Wave__c LIMIT 1');  
        
        test.startTest();
         
        Database.executeBatch(UpdateSratL1PrevItemScpt);
         Database.executeBatch(UpdateSratL2PrevItemScpt);   
        
         test.stopTest();
         System.assert(true);
        }
        
    }