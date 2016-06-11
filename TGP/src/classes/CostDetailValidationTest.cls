/******************************
   @Author       : Rahul Walecha
   @Class name   : CostDetailValidationTest
   @CreateDate   : 8-Feb-2016
   @Description : Test class for CostDetailValidation 
   @Version : 1.0 
*******************************/
@isTest

private class CostDetailValidationTest {
    /******************************
     * Method Name: testvalidateDates
     * Description: test method to check if inserted dates are valid or not
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testvalidateDates() {
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
             Opportunity TestOpportunity = new Opportunity();
             TestOpportunity.name = 'TestOpportunity';
             TestOpportunity.StageName = '1';
             TestOpportunity.Pipeline_Entry_Date__c = date.today();
             TestOpportunity.BPO_Net_Rev__c = 100;
             Database.insert(TestOpportunity);
             
            Costing_Request__c cost = [Select Id from Costing_Request__c where Opportunity__c =:TestOpportunity.id];
            Date startDate = Date.newInstance(2016,2,8);
            cost.Contract_Start__c = startDate;
            Date endDate= Date.newInstance(2026,2,8);
            cost.Contract_End__c = endDate;
            Date goLiveDate = Date.newInstance(2020,3,13);
            cost.Initial_Go_Live__c = goLiveDate;
            List<Costing_Request__c> costList = new List<Costing_Request__c>();
            costList.add(cost);
            try{
                update costList;
            }
            catch(Exception e){
                String errMsg = e.getMessage();
                System.assertEquals(errMsg,'Update failed. First exception on row 0 with id '+cost.Id+'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Contract duration can not be greater than 120 months.: []');
            }
            
         }
     }
     
}