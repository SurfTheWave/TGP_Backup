@isTest
private class OpportunityDocDetailsTest{

   
     static testMethod void test1(){
     Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
          ogm.Name = 'test name ogm';
          insert ogm;
        
        Opportunity opp = new Opportunity();
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        insert opp; 
        /*PageReference pageRef = Page.OpportunityDocumentPage;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('pid', opp.id); 
        String oppId = ApexPages.currentPage().getParameters().get('pid');*/
        BenchMark__c b=new BenchMark__c();
        b.name='test';
        b.opportunity__c = opp.Id;
        insert b;
            opportunity_documents__c OppDocs= new opportunity_documents__c();
            OppDocs.document__c = 'Test Doc';
            OppDocs.Document_Link__c = 'Junk Link text';
            OppDocs.type__c = 'Overall Solution Plan Deck';
            OppDocs.modified_by__c='test user';
            OppDocs.opportunity__c =  opp.Id;          
            insert OppDocs;
           
        Attachment attchment=new Attachment();
        attchment.parentId=b.Id;
        attchment.Name=UtilConstants.TEST;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attchment.body=bodyBlob;
        insert attchment;
        ApexPages.StandardController sc = new ApexPages.StandardController(OppDocs);        
        OpportunityDocDetails OpD=new OpportunityDocDetails(sc);
        Test.startTest();
        OpD.getOpportunityId();
        OpD.getOpportunityDetails();
        OpD.getDocs();
        OpD.getStaticText();
        OpD.backToOpportunity();
        OpD.pageredir();
        OpD.backToPage();
        OpD.CancelPage();
        OpD.getSharePointUrl();
        OpD.getOpportunityDoumentList();
        test.stopTest(); 
        }
}