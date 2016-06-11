/*
    @author     : 
    @name :         LoadRoles_ApprovalStage_Test 
    @createDate :   
    @description : 
    @version : 
*/
@isTest
private class LoadRoles_ApprovalStage_Test {
    
        private static User_Master__c testUserMaster;
        private static Opportunity_Roles_Master__c oppRoleMaster;
        private static Opportunity_Teams__c oppTeamNew;
     /*    
        @name :         setupdata
        @description :  set up test data for LoadRoles_ApprovalStage functionality testing
    */
    public static void setupdata(){
        
        //inserting opp role master
        oppRoleMaster = new Opportunity_Roles_Master__c(Name = Label.Complex_Cost_Architect,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMaster;
        
        //inserting approval stage
        User useObj = UtilNovaUnitTest.getUser();
        insert useObj;
        User_Master__c userObj1 = new User_Master__c(Name = 'TestUser',User__c = useObj.id,email__c=useObj.email);
        insert userObj1;
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
    
        Opportunity opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        insert opp;
        
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c='Pending');

        insert appObj_stage;
        
            //inserting opportunity team
            
            testUserMaster = new User_Master__c();
            testUserMaster.Name = useObj.name;
            testUserMaster.user__c = useObj.Id;
            insert testUserMaster;
          
            
            oppTeamNew = new Opportunity_Teams__c();
            oppTeamNew.Opportunity__c = opp.Id;
            oppTeamNew.Role__c = oppRoleMaster.id;
            oppTeamNew.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamNew.Request_Team_Member__c = true;
            oppTeamNew.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            oppTeamNew.Assigned_Date__c = System.today(); 
            oppTeamNew.Requestor__c  = testUserMaster.Id;

            insert oppTeamNew;
        
        
    }
       /*    
        @name :         test
        @description :  set up test data for LoadRoles_ApprovalStage functionality testing
    */ 
    public static Testmethod void test(){
        Test.starttest();
        setupdata();
        LoadRoles_ApprovalStage batchmeeting=new LoadRoles_ApprovalStage();
        id batchid=database.executeBatch(batchmeeting,1);
        
    }

}