/*
  @Author: 
  @Name: OperationsOnOppCommentsController_Test 
  @Created Date: 03 September 2015
  @Description:This is a test class OperationsOnOppCommentsController_Test for testing the operations on opportunity Docs.
  @version: 1.0
*/
@isTest
private class OperationsOnOppCommentsController_Test {
    private static Decimal testDecimal = 100;
    private static String testString = 'testString';
    private static Opportunity opp;
    /*
      @Author: 
      @Name: testOperationsOnOpportunityComments
      @Created Date: 01 January 2015
      @Description:This is a test method testOperationsOnOpportunityComments for testing the operation on opportunity Docs.
      @version: 1.0
    */
    static testMethod void testOperationsOnOpportunityComments(){
        
         User useObj = UtilNovaUnitTest.getUser();
         User_Master__c userObj = new User_Master__c(Name = 'TestUser',User__c = useObj.id,email__c=useObj.email);
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        Account accounts =new Account(name='testaccount');
        insert accounts;
        opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        opp.AccountId=accounts.id;
        insert opp;
        
        
        Opportunity_Comments__c oppComments = new Opportunity_Comments__c(opportunity__c=opp.id,
                                                                            Service_Group__c = 'BPO',
                                                                            comments__c = 'Hello this is a test class'
                                                                            );
      /*  opportunity_documents__c oppdocuments=new opportunity_documents__c(opportunity__c=opp.id,
                                                                           document__c='test Document',
                                                                           Document_Link__c='test link',
                                                                           Service_Group__c='BPO',
                                                                           modified_by__c='test user',
                                                                           modified_date__c =date.today()
                                                                          ); */
        List<Opportunity_Comments__c> oppCommentsList = new List<Opportunity_Comments__c>();
        oppCommentsList.add(oppComments);
        test.startTest();
        database.insert(oppCommentsList,true);
        try{
        database.delete(oppCommentsList,true);
        }
        catch(Exception e){
            String msg=e.getMessage();
           system.assert(msg.contains('Sorry !! Opportunity comment cannot be deleted'));
        }
        test.stopTest();   
    }
}