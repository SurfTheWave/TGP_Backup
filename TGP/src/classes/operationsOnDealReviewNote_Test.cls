@isTest(SeeAllData=false)
/*
  @Author: 
  @Name: operationsOnDealReviewNote_Test
  @Created Date: 01 January 2015
  @Description: This is a test class for operation on Deal Review note.
  @version: 1.0
*/
private class operationsOnDealReviewNote_Test{
/*
  @Author: 
  @Name: test1
  @Created Date: 01 January 2015
  @Description:This is a test method test1.
  @version: 1.0
*/
    static testMethod void test1(){
        User stdUser = UtilNovaUnitTest.getUser();
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        stdUser.profileid = p.Id;
            System.runAs(stdUser) {
                test.starttest();
                List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
                Commercial_Data__c CData = new Commercial_Data__c(Name = 'Id', Opportunity__c = oppList[0].Id );
                Insert CData;
                //CData.Name = CData.Id ;
                //Update CData;
                Deal_Review_Notes__c DRNotes = new Deal_Review_Notes__c(Name = 'TestData',Active__c = true,Opportunity_Commerical_Data__c =CData.Id , Approval_Stage__c = 'Stage 2' );
                Insert DRNotes ;
                DRNotes.Approval_Stage__c = 'Stage 3';
                Update DRNotes;
                test.stoptest();
          }
      }  
}