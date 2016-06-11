/*
@Author and Created Date : System
@name : operOnSolReportTriggerCntlr_Test
@Description : 
@Version : 
*/
@isTest
private class operOnSolReportTriggerCntlr_Test{     
    /******************************
    Method Name: testAfterInsert
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public static testMethod void testAfterInsert(){
       
         Offering_Master__c off1 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Human Resources',offering_description__c='test desc',flywheel_non_flywheel__c='test F');
         insert off1;
         String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + off1.Id;
         Report_Master__c repMaster = new Report_Master__c(Active__c=true,Report_Description__c='test report master description',Report_ID__c=off1.Id,Report_URL__c=fullRecordURL );
         insert repMaster;
         Account acc = new Account(name='test Account');
         insert acc;
         Solution_Report__c solutionReport = new Solution_Report__c( name= 'test Sol Report',Geo_Region__c='Test Geo Region',Operating_Unit__c='CMT Asia Pacific OU',Report__c= repMaster.ID);
         solutionReport.stage__c = '1';
        solutionReport.Operating_Group__c = 'test group';
        solutionReport.Account__c = acc.Id;
        solutionReport.Geo_Unit__c = 'ASEAN';
        solutionReport.Reporting_Status__c = 'test';
        test.startTest();
        insert solutionReport;
        test.stopTest();
    } 
}