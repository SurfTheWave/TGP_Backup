public class reportingController {

    public String OffId;
    public Opportunity_Offering__c newOppOffer{get;set;}
    public Assumption__c assmpReport{get;set;}
    
 
    public reportingController(ApexPages.StandardController controller) {
         OffId=ApexPages.CurrentPage().getParameters().get('id');
         newOppOffer = new Opportunity_Offering__c();
         assmpReport =  new Assumption__c();
         newOppOffer = [select Id,Name from Opportunity_Offering__c where Id=:OffId];
         //assmpReport = [select Id,Opportunity_Offering__c,Editable__c from Assumption__c where Opportunity_Offering__c=:OffId limit 1];
        assmpReport.Editable__c = true;
    }

}