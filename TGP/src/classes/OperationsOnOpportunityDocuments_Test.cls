/*
  @Author: 
  @Name: OperationsOnOpportunityDocuments_Test 
  @Created Date: 01 January 2015
  @Description:This is a test class OperationsOnOpportunityDocuments_Test for testing the operations on opportunity Docs.
  @version: 1.0
*/
@isTest
private class OperationsOnOpportunityDocuments_Test {
    private static Decimal testDecimal = 100;
    private static String testString = 'testString';
    private static Opportunity opp;
    /*
      @Author: 
      @Name: testOperationsOnOpportunityDocuments
      @Created Date: 01 January 2015
      @Description:This is a test method testOperationsOnOpportunityDocuments for testing the operation on opportunity Docs.
      @version: 1.0
    */
    static testMethod void testOperationsOnOpportunityDocuments(){
        
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
        
        opportunity_documents__c oppdocuments=new opportunity_documents__c(opportunity__c=opp.id,
                                                                           document__c='test Document',
                                                                           Document_Link__c='test link',
                                                                           Service_Group__c='BPO',
                                                                           modified_by__c='test user',
                                                                           modified_date__c =date.today()
                                                                          );
        List<opportunity_documents__c> documentlist=new List<opportunity_documents__c>();
        documentlist.add(oppdocuments);
        test.startTest();
        database.insert(documentlist,true);
        try{
        database.delete(documentlist,true);
        }
        catch(Exception e){
            String msg=e.getMessage();
           system.assert(msg.contains('Sorry !! Opportunity Document cannot be deleted'));
        }
        test.stopTest();   
    }
}