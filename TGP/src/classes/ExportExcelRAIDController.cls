public with sharing class ExportExcelRAIDController {
    public String dealId{get;set;}
    public Datetime date1{get;set;}
    public Deal__c dealName{get;set;}
    public List<Risks__c> listRiskRaidRecords{get;set;}
    public List<Action__c> listActionRaidRecords{get;set;}
    public List<Issues__c> listIssueRaidRecords{get;set;}
    public List<Decision__c> listDecisionRaidRecords{get;set;}
    public String xlsHeader {
         get {    
             String strHeader = '';
             strHeader += '<?xml version="1.0"?>';
             strHeader += '<?mso-application progid="Excel.Sheet"?>';
             return strHeader;
         }
     }

    public ExportExcelRAIDController(){
        
        dealId=ApexPages.currentPage().getParameters().get('id');
        date1=Datetime.now();
        dealName=[Select Name from Deal__c where id= : dealId limit 1];
        listRiskRaidRecords = [Select Name,Module__c,title__c,Raised_On__c,Raised_By__r.name,Primary_Owner__r.name,Status__c,Risk_Age_Days__c,Risk_Impact__c,Description__c,Mitigating_Actions__c,Risk_Review_Date__c,Target_Close_Date__c,Actual_Close_Date__c from Risks__c where Deal__r.id= : dealId order by createddate limit 1000];  
       
         listIssueRaidRecords= [Select Name,Module__c,Title__c,Raised_On__c,Raised_By__r.name,Primary_Owner__r.name,Status__c,Issue_Age_days__c,Issue_Severity__c,Description__c,Updates__c,Issue_Closure_Notes_Comments__c,Target_Close_Date__c,Actual_Close_Date__c  from Issues__c where Deal__r.id = : dealId order by createddate limit 1000];  
        
        listActionRaidRecords=[Select Name,Module__c,Raised_On__c,Raised_By__r.name,Primary_Owner__r.Name,Status__c,Action_Age_days__c,Risks__r.Name,Issue__r.Name,Description__c,Updates__c,Action_Closure_Notes_Comments__c,Target_Close_Date__c,Actual_Close_Date__c from Action__c where Deal__r.id= : dealId order by createddate limit 1000];
        
        listDecisionRaidRecords = [Select Name,Module__c,Raised_on__c,Raised_by__r.Name,Forum_Raised__c,Decision_Description__c,Risks__r.Name,Issue__r.Name,Primary_Owner__r.name,Additional_Notes_Comments__c,Target_Close_Date__c,Actual_Close_Date__c from Decision__c where Deal__r.id = : dealId order by createddate limit 1000];
    
    }
}