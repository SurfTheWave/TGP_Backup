public with sharing class OpportunityDocumentsWrapper {
     public Boolean checked{ get; set; }
      public opportunity_documents__c oppdoc { get; set;}

    public OpportunityDocumentsWrapper(){
        oppdoc = new opportunity_documents__c();
        checked = false;
    }

    public OpportunityDocumentsWrapper(opportunity_documents__c c){
        oppdoc = c;
        checked = false;
    }
}