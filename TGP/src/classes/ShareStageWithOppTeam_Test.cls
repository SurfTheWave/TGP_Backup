/*
*
*
*    ClassName: ShareStageWithOppTeam_Test
*
*    @Author
*
*/
@isTest
private class ShareStageWithOppTeam_Test{

/*
  @Author: 
  @Name: test1
  @Created Date: 01 January 2015
  @Description: This is a test class test1 for checking the sharestage with opportunity team.
  @version: 1.0
*/
    static testmethod void test1(){
    
        //User usObj = UtilNovaUnitTest.getuser();
        Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'Read Only' 
                           LIMIT 1];

        User usObj = new User(LastName = 'test user 1', 
                             Username = 'test.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id,
                             //isActive = true, 
                             LanguageLocaleKey = 'en_US');  
        Database.insert(usObj);
        
        User usObj2 = new User(LastName = 'test user 2', 
                             Username = 'test2.user.1@example.com', 
                             Email = 'test2.1@example.com', 
                             Alias = 'testu12', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id,
                             //isActive = true, 
                             LanguageLocaleKey = 'en_US');  
        Database.insert(usObj2);

        User_Master__c userObj = new User_Master__c(Name = 'Test',User__c = usObj.id);
        Database.insert(userObj);
        User_Master__c userObj2 = new User_Master__c(Name = 'Test2', User__c = usObj2.id);
        Database.insert(userObj2);
        
        Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c(Name = 'testName',Active__c = true);
         Database.insert(OppGrpMaster); 
         
         Opportunity opp=new Opportunity();
         opp.OperatingGroup__c=OppGrpMaster.id;
         opp.name=UtilConstants.TEST_OPP;
         
         opp.Geo_Area__c=UTIL_Constants.AsiaPacific;
         opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
         opp.StageName=UtilConstants.OA;
         opp.Risk_Level__c=UtilConstants.LOW;
         opp.CloseDate= date.newInstance(2001, 3, 21);
         opp.Opportunity_Solution_Lead__c = userObj.id;
         Database.insert(opp);
         
        Approval_Stage__c app_stageObj = new Approval_Stage__c(approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                                Service_Group__c = utilConstants.BPO,
                                                                opportunity__c = opp.id);
        Database.insert(app_stageObj);
    
    
        List<Approval_Stage__c> slist = new List<Approval_Stage__c>();
        List<Opportunity_Teams__c> oppteamlist = new List<Opportunity_Teams__c>();
        List<Opportunity_Teams__c> oppteamlist2 = new List<Opportunity_Teams__c>();
        
        Opportunity_Roles_Master__c oppRoleMaster = new Opportunity_Roles_Master__c(Name = 'Opportunity_Solution_Lead', Description__c = UtilConstants.TEST_DESC, ShouldReceiveAlertMail__c = True);
            insert oppRoleMaster;
           
        Opportunity_Teams__c oppTeam = new Opportunity_Teams__c();
            oppTeam.Opportunity__c = opp.Id;
            oppTeam.Role__c = oppRoleMaster.id;
            oppTeam.Opportunity_Team_Member__c = userObj.Id;
            oppTeam.Request_Team_Member__c = true;
            oppTeam.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            oppTeam.Assigned_Date__c = System.today(); 
            oppTeam.Requestor__c  = userObj.Id;   
         Database.insert(oppTeam);
        
        slist.add(app_stageObj);
        oppteamlist.add(oppTeam);
        oppTeam.Opportunity_Team_Member__c = userObj2.Id;
        Database.update(oppTeam);
        oppteamlist2.add(oppTeam);
        
        ShareStageWithOppTeam.newStage(slist);
        ShareStageWithOppTeam.newteammember(oppteamlist);
        ShareStageWithOppTeam.teammember(oppteamlist);
        ShareStageWithOppTeam.restrictShareForTeamMember(oppteamlist, oppteamlist2);
    }

}