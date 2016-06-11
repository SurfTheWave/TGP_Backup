/******************************
   @Author       : Jyotsna
   @Class name   : BPOSEWhatIfTest
   @CreateDate   : 2-July-2015
   @Description : Test class for CanvasClass 
   @Version : 1.0 
*******************************/
@isTest

private class BPOSEWhatIfTest{
     /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON() {
        Scratchpad_Opportunity__c scOpp= new Scratchpad_Opportunity__c();
       // scOpp.Client__c= TestOpportunity.Id;
        insert scOpp;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', scOpp.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(scOpp);
        
        test.startTest();
           BPOSEWhatIf whatIf = new BPOSEWhatIf(sc);
           whatIf.getgenerateJSONContent();
        test.stopTest();
        
    }
    
    /******************************
     * Method Name: testJSON1
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON1() {
         Profile p = UTIL_DataCreationForTestClass.getProfile('Solution Read Only');
         User u = UTIL_DataCreationForTestClass.getUserWithProfile(p,'yetre@asad.com');
         insert u;
         User_Master__c userMaster = new User_Master__c(User__c=u.id,Active__c=true,email__c='test.123=test@test.com');
         insert userMaster;
         system.runAs(u){
         Scratchpad_Opportunity__c scOpp= new Scratchpad_Opportunity__c();
         scOpp.country__c = 'test1;test2';
         scOpp.Offering__c = 'testOffering1;testOffering2';
        //scOpp.Client__c= TestOpportunity.Id;
        insert scOpp;
        PageReference pg = Page.BPOSEWhatIf;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', scOpp.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(scOpp);
        
        test.startTest();
           BPOSEWhatIf whatIf = new BPOSEWhatIf(sc);
           whatIf.getgenerateJSONContent();
           
        test.stopTest();
        
    }
    }
}