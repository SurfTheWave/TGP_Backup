public with sharing class nonStandardTabController {

    public String offId{get;set;}
    public Opportunity_TGP__c oppRec {get;set;}
    public Opportunity_Offering__c offRec{get;set;}
    public Opportunity_Offering__c oppOffering {get;set;}
    public boolean detailSection{get;set;}
    public boolean editSection{get;set;}

    public nonStandardTabController(ApexPages.StandardController controller) {
    
        detailSection = true;
        editSection = false;

         offId=ApexPages.CurrentPage().getParameters().get('id'); //Get current page id.
         oppOffering =(Opportunity_Offering__c )controller.getRecord();
         offRec = [select id,Third_Party_scope__c ,Accenture_non_BPO_scope__c,Non_standard_BPO_scope__c,Opportunity_TGP__c from Opportunity_Offering__c where id = : oppOffering.id];
         //oppRec = [select id,name,Third_Party_scope__c,Non_standard_BPO_scope__c,Accenture_non_BPO_scope__c from Opportunity_TGP__c where id =: offRec.Opportunity_TGP__c];
         //oppRec.Third_Party_scope__c = 'Hello';
    }

     /******************************
    Method Name: saverecord
    Description: To save Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecord(){
    
        try {
            upsert offRec;
            detailSection = true;
            editSection = false;
            
        }
        catch (Exception ex) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot update offering, please contact workbench administrator.'));
        }
            
    }
    /******************************
    Method Name: editrecord
    Description: To edit Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void editrecord(){
        
        editSection = true;
        detailSection = false;
    }
    /******************************
    Method Name: cancelrecord
    Description: To cancel records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void cancelrecord(){
        
        editSection = false;
        detailSection = true;
        //oppRec = [select id,name,Non_standard_BPO_scope__c,Accenture_non_BPO_scope__c from Opportunity_TGP__c where id =: offRec.Opportunity_TGP__c];
        offRec = [select id,Third_Party_scope__c ,Accenture_non_BPO_scope__c,Non_standard_BPO_scope__c,Opportunity_TGP__c from Opportunity_Offering__c where id = : oppOffering.id];
    }
}