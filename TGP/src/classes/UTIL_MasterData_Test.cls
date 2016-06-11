/******************************
   @Author       : 
   @Class name   : UTIL_MasterData_Test
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
@isTest
private class UTIL_MasterData_Test{
/******************************
     * Method Name: UTIL_MasterDataTest
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
static testMethod void UTIL_MasterDataTest(){
  Id Id = UserInfo.getUserId();

  Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
        String aliasString = 'alig';
        User userObj = new User(Alias =aliasString, 
        email= aliasString+'@accenture.com',
        emailencodingkey='UTF-8',
        lastname='Testing', 
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = sysAdminId,
        timezonesidkey='Europe/London',
        username= aliasString+'@accenture.com');
        
        insert userObj;

        List <User_Master__c> lum =new List<User_Master__c>();
        User_master__c um = new User_master__c();
        um.Name='Test User Master';
        um.email__c=userObj.email;
        um.canBeApprover__c=true;
        um.canBeSolUser__c=true;
        um.Old_SF_ID__c='Test';
        um.user__c=um.id;
        lum.add(um);
        
        insert lum;
        
        Test.startTest();  
        
        UTIL_MasterData umd=new  UTIL_MasterData();
        UTIL_MasterData.getUserMasterData();
        
       
        Test.stopTest();  
    }
}