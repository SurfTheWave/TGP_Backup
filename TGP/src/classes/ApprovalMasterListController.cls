public with sharing class ApprovalMasterListController {
    private List<Updates_to_Approval_Matrix__c> AMRecords;   
    private Approval_Stage__c appStage;  
    public String AMId {get;set;}
    
    public ApprovalMasterListController (ApexPages.StandardController controller) {   
        appStage = (Approval_Stage__c)controller.getRecord();  
    }    
     
    public List<Updates_to_Approval_Matrix__c> getAM(){        
         AMRecords = [SELECT Id, Name,Comments__c,LastModifiedBy.name,LastModifiedDate FROM Updates_to_Approval_Matrix__c ORDER BY LastModifiedDate DESC LIMIT 5 ];
         return AMRecords;         
    }     
}