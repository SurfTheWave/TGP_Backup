/**
 * Name : Sch_SendEmailForGovernanceLead_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the Sch_SendEmailForGovernanceLeadScheduler
 * Date : 3/18/15 6:19 PM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class Sch_SendEmailForGovernanceLead_Nova_Test { 
/*    
    @Name :         testSch_SendEmailForGovernanceLeadScheduler
    @Description :  inserting required data for Account  
*/   
     static testMethod  void testSch_SendEmailForGovernanceLeadScheduler(){
        User stdUser = UtilNovaUnitTest.getUser();
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'testScheduledApexFromTestMethod';
        insert acc;
        System.runAs(stdUser) {
            String jobId = System.schedule('testBasicScheduledApex','0 0 0 3 9 ? 2022',new Sch_SendEmailForGovernanceLeadScheduler());
            CronTrigger ct  = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId Limit 1];
            System.assertEquals('0 0 0 3 9 ? 2022',ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
            Test.stopTest();
        }
    }
}