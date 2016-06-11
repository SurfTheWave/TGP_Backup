@isTest
public Class createmissed_utilizations_Test{
    
    
   private static CreateApprovalDocument_VFC ext;
    private static Approval_Request__c requestReview3;
    private static PageReference pref;
    private static User testUser;
    private static Decimal testDecimal = 100;
    private static Opportunity opp;
    
     
   private static testMethod void  testUtils(){
    
   
    User useObj = UtilNovaUnitTest.getUser();
        User useObj1 = UtilNovaUnitTest.getUser1();
        List<user> userlist=new List<user>();
        userlist.add(useObj);
        userlist.add(useObj1);
        insert userlist;

        system.runAs(userlist[0]){
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        
        User_Master__c userObj = new User_Master__c(Name = 'TestUser',User__c = userlist[0].id,email__c=userlist[0].email);
        User_Master__c userObj1 = new User_Master__c(Name = 'SolTestUser',User__c = userlist[0].id,email__c=userlist[0].email);
        insert(userObj);
        insert(userObj1);
            
         Opportunity_Roles_Master__c oppRoleMaster = new Opportunity_Roles_Master__c(Name = UtilConstants.OPP_SOL_LEAD, Description__c = UtilConstants.TEST_DESC, 
                                                                                    HaveEditAccessOnOpportunity__c= true, ShouldReceiveAlertMail__c = False);
        insert oppRoleMaster;   
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
    
        opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        insert opp;
            
        Opportunity_Teams__c OppTeam_Obj = new Opportunity_Teams__c(Role__c = oppRoleMaster.Id,    Opportunity_Team_Member__c = userObj.id,
                                                                Request_Team_Member__c = False, Team_Member_Request_Status__c = 'Assigned',
                                                               opportunity__c=opp.id  );
        insert OppTeam_Obj; 
        
        Test.StartTest();
        createmissed_utilizations cmu =  new createmissed_utilizations();
        Id BatchId = Database.ExecuteBatch(cmu);
        Test.StopTest();
        
      }  
   }
    
}