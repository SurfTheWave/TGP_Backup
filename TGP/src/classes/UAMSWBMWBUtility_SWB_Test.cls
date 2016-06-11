/*
@Author and Created Date : Divyashree C K ,  4/4/2015 2:30 PM
@name : UAMSWBMWBUtility_SWB_Test
@Description : 
@Version : 
*/
@isTest
private class UAMSWBMWBUtility_SWB_Test{
    /******************************
    Method Name: UAMSWBMWBUtility_SWB
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testmethod void UAMSWBMWBUtility_SWB(){
         UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
         User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com'); 
         insert testUser;

        Opportunity_Roles_Master__c oppRoleMaster = new Opportunity_Roles_Master__c(Name = 'Opportunity_Solution_Lead', Description__c = UtilConstants.TEST_DESC, 
                                                                                    HaveEditAccessOnOpportunity__c= true, ShouldReceiveAlertMail__c = False);
        insert oppRoleMaster;
        
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster;  

         List<User_Master__c> MasterList= new List<User_Master__c>();
         User_Master__c UserMasterRef0= new User_Master__c(Name = 'UserMasterTest0', User__c = testUser.Id);
         MasterList.add(UserMasterRef0);
         
         insert MasterList;
         //System.RunAs(testUser){
        Account accounts =new Account(name='testaccount');
        insert accounts;
        
        Opportunity opp = new Opportunity();
        
        opp.OperatingGroup__c = OppGrpMaster.id;
        opp.name= UtilConstants.TEST_OPP;
        opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
        opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
        opp.StageName= UtilConstants.OA;
        opp.Risk_Level__c= UtilConstants.LOW;
        opp.IO_Net_Revenue_Thousands__c = 1000;
        opp.CloseDate= date.newInstance(2001, 3, 21);
        opp.OwnerID = testUser.Id;
        insert opp;
        
        Profile testProfile = [SELECT Id FROM profile WHERE Name = 'IO Solution Editor' LIMIT 1];
        UserRole usrRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Support User' LIMIT 1];
        String r = usrRole.Id;
        User usObj = new User(LastName = 'test user 1', 
                             Username = 'test.user.2@example.com', 
                             Email = 'test.2@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id,
                             UserRole = usrRole,
                             isActive = true, 
                             LanguageLocaleKey = 'en_US');  
        insert(usObj);

        User_Master__c userObj = new User_Master__c(Name = 'Test',User__c = usObj.id);
        insert(userObj);
          
         Test.StartTest();
          {
          
              Boolean accessLevel = [select HasEditAccess,RecordId FROM userRecordAccess WHERE
                                         UserId =: usObj.Id AND 
                                         RecordId =: opp.Id Limit 1].HasEditAccess;
              //System.debug(LoggingLevel.ERROR, 'accessLevel ******'+ accessLevel );
              
             Opportunity_Teams__c oppTeam = new Opportunity_Teams__c();
             oppTeam.Opportunity__c = opp.Id;
             oppTeam.Role__c = oppRoleMaster.id;
             oppTeam.Opportunity_Team_Member__c = userObj.Id;
             oppTeam.Request_Team_Member__c = false;
             insert(oppTeam);
    
             User usObj_upd = new User(LastName = 'test user 3', 
                                 Username = 'test.user.3@example.com', 
                                 Email = 'test.3@example.com', 
                                 Alias = 'testu3', 
                                 TimeZoneSidKey = 'GMT', 
                                 LocaleSidKey = 'en_GB', 
                                 EmailEncodingKey = 'ISO-8859-1', 
                                 ProfileId = testProfile.Id,
                                 isActive = true, 
                             LanguageLocaleKey = 'en_US');  
             insert(usObj_upd);
             User_Master__c userObj_upd = new User_Master__c(Name = 'Test 2',User__c = usObj_upd.id);
             insert userObj_upd ;
             oppTeam.Opportunity_Team_Member__c = userObj_upd.Id;
             oppTeam.Role__c = oppRoleMaster.id;
             oppTeam.Requestor__c  = userObj_upd.Id;
             //oppTeam.Team_Member_Request_Status__c = 'On Hold';
             update oppTeam;
             
             oppTeam = new Opportunity_Teams__c();
             oppTeam.Opportunity__c = opp.Id;
             oppTeam.Role__c = oppRoleMaster.id;
             oppTeam.Opportunity_Team_Member__c = userObj_upd.Id;
             oppTeam.Request_Team_Member__c = false;
             insert(oppTeam);
        
              //System.debug('after update on Opp Team ' + limits.getQueries());
              delete oppTeam;
            }
            Test.StopTest();    
    }

}