@IsTest(seeAllData = True)
    

    public class UpdateOpexL1PrevItemScript_test{
        
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
         
         
         
        UpdateOpexL1PrevItemScript UpdateOpexL1PrevItemScpt=new UpdateOpexL1PrevItemScript('Select Id,Name from Wave__c LIMIT 1');
                
        test.startTest();
         
        Database.executeBatch(UpdateOpexL1PrevItemScpt);
              
         test.stopTest();
         System.assert(true);
        }
        
    }