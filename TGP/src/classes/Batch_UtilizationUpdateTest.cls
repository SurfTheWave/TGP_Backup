/*
 * @Author: Vaishnavi
 * @CreatedDate: 17/12/2015
 * @Description: 
 */
@isTest
private class Batch_UtilizationUpdateTest{
    
        public static Opportunity TestOpportunity;
        public static Opportunity_Teams__c TestOpportunityTeam;
        public static Opportunity_Teams__c TestOpportunityTeam1;
        public static User_Master__c  TestUserMaster;
        public static User_Master__c  TestUserMaster1;
        public static Opportunity_Roles_Master__c TestOpportunityRoleMaster;
        public static Opportunity_Roles_Master__c TestOpportunityRoleMaster1;
        public static Utilizations__c TestUtilization;
        public static Utilizations__c TestUtilization1;
        
    /*
     * @Author: Vaishnavi
     * @CreatedDate: 17/12/2015
     * @Description:  
     */
    private static testMethod void doTest(){
        
        Test.startTest();
    
        TestOpportunity = new Opportunity();
        TestOpportunity.Reporting_Status__c = UtilConstants.WON;
        TestOpportunity.Geo_Area__c = UtilConstants.EALA;
        //TestOpportunity.OperatingGroup__c = TestOperatingGroup.id;
        TestOpportunity.StageName = UtilConstants.TWO_B;
        TestOpportunity.Risk_Level__c = UtilConstants.NORMAL;
        TestOpportunity.CloseDate = System.today();
        TestOpportunity.Name = UtilConstants.TEST_OPP;
        insert TestOpportunity;
        
        TestUserMaster = new User_Master__c();
        TestUserMaster.Active__c = TRUE;
        TestUserMaster.User__c = '005E0000006CTLz';
        insert TestUserMaster;
        
        TestUserMaster1 = new User_Master__c();
        TestUserMaster1.Active__c = TRUE;
        TestUserMaster1.User__c = '005E0000006CTOt';
        insert TestUserMaster1;
        
        TestOpportunityRoleMaster = new Opportunity_Roles_Master__c();
        TestOpportunityRoleMaster.Name = 'TestRoleMaster';
        TestOpportunityRoleMaster.Role_Level__c = 'Both';
        insert TestOpportunityRoleMaster;
        
        TestOpportunityRoleMaster1 = new Opportunity_Roles_Master__c();
        TestOpportunityRoleMaster1.Name = 'TestRoleMaster2';
        TestOpportunityRoleMaster1.Role_Level__c = 'Both';
        insert TestOpportunityRoleMaster1;
        
        TestOpportunityTeam = new Opportunity_Teams__c();
        //TestOpportunityTeam.Name = 'Test User Master';
        TestOpportunityTeam.Role__c = TestOpportunityRoleMaster.ID;
        TestOpportunityTeam.Opportunity_Team_Member__c = TestUserMaster.ID;
        TestOpportunityTeam.Opportunity__c = TestOpportunity.ID;
        insert TestOpportunityTeam;
        
        TestUtilization = new Utilizations__c();
        TestUtilization.Name = TestOpportunity.Name + ' ' + 'Utilization';
        TestUtilization.Opportunity__c = TestOpportunity.ID;
        TestUtilization.User__c = TestUserMaster.ID;
        insert TestUtilization;
        
        TestOpportunityTeam1 = new Opportunity_Teams__c();
        //TestOpportunityTeam.Name = 'Test User Master';
        TestOpportunityTeam1.Role__c = TestOpportunityRoleMaster1.ID;
        TestOpportunityTeam1.Opportunity_Team_Member__c = TestUserMaster.ID;
        TestOpportunityTeam1.Opportunity__c = TestOpportunity.ID;
        insert TestOpportunityTeam1;
        
        TestUtilization1 = new Utilizations__c();
        TestUtilization1.Name = TestOpportunity.Name + ' ' + 'Utilization';
        TestUtilization1.Opportunity__c = TestOpportunity.ID;
        TestUtilization1.User__c = TestUserMaster.ID;
        insert TestUtilization1;
        
        
        
        
        
        Batch_UtilizationUpdate CheckBatch = new Batch_UtilizationUpdate();
        ID batchprocessid = Database.executeBatch(CheckBatch);
        System.assertNotEquals(batchprocessid , null);
        Test.stopTest();
    }
}