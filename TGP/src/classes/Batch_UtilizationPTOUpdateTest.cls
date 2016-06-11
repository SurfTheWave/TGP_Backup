/*
 * @Author: Aswajit
 * @CreatedDate: 10/12/2015
 * @Description: 
 */
@isTest
private class Batch_UtilizationPTOUpdateTest {
    /*
     * @Author: Aswajit
     * @CreatedDate: 03/12/2015
     * @Description:  
     */
    private static testMethod void check_Blank(){
        
        User useObj1 = UtilNovaUnitTest.getUser1();
        insert useObj1;
        User_Master__c userObj1 = new User_Master__c(Name = 'SolTestUser',User__c = useObj1.id,email__c=useObj1.email);
        insert userObj1;
        Opportunity opp =UTIL_TestDataCreationForMobClasses.getOpportunity();
        utilizations__c util = new utilizations__c();
        util.Name = Opp.name+userObj1.name;
        util.Opportunity__c = opp.id;
        util.User__c = userObj1.id;
        util.Active__c = true;
        insert util;
        Utilization_Dates__c myCS =new Utilization_Dates__c();
        myCS.name='MondayDate';
        myCS.Referenced_Date__c=System.now().addDays(-7);
        insert myCS;
        PTO__c obj=new PTO__c();
        obj.Utilization__c=util.Id;
        obj.User__c=userObj1.Id;
        obj.Name='PTOTest';
        obj.PTO_Start__c=system.today();
        obj.PTO_End__c=system.today()+7;
        insert obj;
        Test.startTest();
        Batch_UtilizationPTOUpdate CheckBatch = new  Batch_UtilizationPTOUpdate();
        ID batchprocessid = Database.executeBatch(CheckBatch);
        System.assertNotEquals(batchprocessid , null);
        Test.stopTest();
    }
}