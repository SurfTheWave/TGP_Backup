public class deleteofferingopportunitycontroller {   
    
    public String opportunityId{get;set;}
    public List<Opportunity_TGP__c> updateBPOOpptyList{get;set;} 
    public  void delteteoffering() {
    
        opportunityId=ApexPages.CurrentPage().getParameters().get('id');
        updateBPOOpptyList=[select id, name, Client_Name__r.name, SAP_OM_Opportunity__r.name, Enterprise_Solution_Architect_New__c, 
                            Enterprise_Solution_Architect_New__r.name, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, 
                                Operating_Group__r.name, TCV__c ,Offering_Solution_Leads__c from Opportunity_TGP__c where id=:opportunityId];
                                
        new UTIL_CorrectionOpportunityData().updateOpportunityRecord(updateBPOOpptyList);
    }
}