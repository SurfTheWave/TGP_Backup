/*
  @Author: 
  @Name: Batch_UtilizationDatesNew_Test 
  @Created Date: 01 January 2015
  @Description:This is a test class Batch_UtilizationDatesNew_Test for batch_utilizationDate new.
  @version: 1.0
*/
@IsTest(SeeAllData=false) 
private class Batch_UtilizationDatesNew_Test {
private Id I = UserInfo.getUserId();
/*
  @Author: 
  @Name: test1
  @Created Date: 01 January 2015
  @Description:This is a test method test1 for quary and check batch.
  @version: 1.0
*/
static testmethod void test1() {
    Utilization_Dates__c utildates = new Utilization_Dates__c();
    
    utildates.Name = 'test custom settings';
    utildates.Referenced_Date__c = system.now();
    insert utildates;
    Test.startTest();
    String q = 'Select Id,Utilization_Dates__c.Referenced_Date__c from Utilization_weekStartDate__c where name= \''+utildates.name+'\' limit 1';
    Batch_UtilizationDatesNew CheckBatch = new Batch_UtilizationDatesNew(q);
    ID batchprocessid = Database.executeBatch(CheckBatch);
    Test.StopTest();
    }

}