/*
    @Author     : 
    @name :         BudgetCostExport_Test 
    @CreateDate :   4/7/2015 3:03 AM
    @Description :  Test class for budget cost export functionality testing
    @Version : 
*/
@isTest
private class BudgetCostExport_Test {
     /******************************
     * Method Name: Test1
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
    static Testmethod void Test1(){
      Test.startTest();
        //Inserting Deal
        Deal__c strDeal = new Deal__c(Name=UtilConstants.DEAL);
        insert strDeal;
        //Inserting New Mobilization Plan under Deal.
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name = UtilConstants.TEST, Deal__c = strDeal.id);
        insert strmobplan;        
        ApexPages.StandardController sc = new ApexPages.StandardController(strmobplan);        
        BudgetCostExport BdgtCostExp=new BudgetCostExport(sc);
        BdgtCostExp.getExcel();
        //inserting Attachment.
        Attachment attchment=new Attachment();
        attchment.parentId=strmobplan.Id;
        attchment.Name=UtilConstants.TEST;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attchment.body=bodyBlob;
        insert attchment;
        BdgtCostExp.getExcel();
    }
}