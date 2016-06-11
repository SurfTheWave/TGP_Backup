@isTest
/******************************
   @Author       : 
   @Class name   : UTIL_MasterData_Test
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
private class DealTestClass {
    /*
    @name : validatecreateTask
    @Description : 
    @Version : 
    */
    static testMethod void validatecreateTask(){
        List<Deal__c> deals =  new List<Deal__c>();
        
        Deal__c deal = new Deal__C();
        
        deal.Name = 'Test Deal';
        deal.Approval_Status__c ='Pending';
        
        insert deal;
        
        Deal__C dea = [select id,name,Approval_Status__c from Deal__C where id= :deal.id Limit 500];
        
        deals.add(dea);
        
        Database.upsert(deals);
    }
}