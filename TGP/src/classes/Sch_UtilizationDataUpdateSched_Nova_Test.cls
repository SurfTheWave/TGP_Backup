/**
 * Name : Sch_UtilizationDataUpdateSched_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the Sch_UtilizationDataUpdateSchedulerNew
 * Date : 3/24/15 11:17 AM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class Sch_UtilizationDataUpdateSched_Nova_Test { 
     static testMethod  void testSch_UtilizationDataUpdateSchedulerNew(){
        User stdUser = UtilNovaUnitTest.getUser();
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'testScheduledApexFromTestMethod';
        insert acc;
        System.runAs(stdUser) {
            String jobId = System.schedule('testBasicScheduledApex','0 0 0 3 9 ? 2022',new Sch_UtilizationDataUpdateSchedulerNew());
            CronTrigger ct  = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals('0 0 0 3 9 ? 2022',ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
            Test.stopTest();
        }
    }
}