public with sharing class ExportRAIDToExcelController {
    public String dealId{get;set;}
    public Datetime date1{get;set;}
    public Deal_TGP__c dealName{get;set;}
    public List<RAID_Risk__c> listRiskRaidRecords{get;set;}
    public List<RAID_Action__c> listActionRaidRecords{get;set;}
    public List<RAID_Issue__c> listIssueRaidRecords{get;set;}
    public List<RAID_Decision__c> listDecisionRaidRecords{get;set;}
    public String xlsHeader {
         get {    
             String strHeader = '';
             strHeader += '<?xml version="1.0"?>';
             strHeader += '<?mso-application progid="Excel.Sheet"?>';
             return strHeader;
         }
     }

    public ExportRAIDToExcelController(){
        
        dealId=ApexPages.currentPage().getParameters().get('id');
        date1=Datetime.now();
        dealName=[Select Name from Deal_TGP__c where id= : dealId limit 1];
        listRiskRaidRecords = [Select Serial_Number__c,Action_Reference_ID__c,Decision_Reference_ID__c,Date_Raised__c,Risk_Age_days__c,Raised_by_Client_Accenture__c,Raised_By_person_New__r.name,Forum_Raised__c,Workstream_Area__c,Raised_at_level__c,Title__c,Description__c,Risk_Probability__c,Risk_Impact__c,Risk_Rating__c,Mitigating_Actions__c,Status_Update__c,Risk_Review_Date__c,Days_to_Risk_Review__c,Actual_Close_Date__c,Primary_Owner_New__r.name,Secondary_Owner_New__r.name,Deal__r.name,Target_Close_Date__c from RAID_Risk__c where Deal__r.id= : dealId order by createddate limit 1000];  
       
         listIssueRaidRecords= [Select Serial_Number__c,Action_Reference_ID__c,Decision_Reference_ID__c,Date_Raised__c,Raised_By_person_New__r.name,Forum_Raised__c,Workstream_Area__c,Raised_at_level__c,Title__c,Description__c,Issue_Severity__c,Updates__c,Status_Update__c,Target_Close_Date__c,Issue_Due_In_days__c,Actual_Close_Date__c,Issue_Closure_Notes_Comments__c,Primary_Owner_New__r.name,Secondary_Owner_New__r.name,Issue_Age_days__c,Raised_by_Client_Accenture__c  from RAID_Issue__c where Deal__r.id = : dealId order by createddate limit 1000];  
        
        listActionRaidRecords=[Select Serial_Number__c,Issue_Ref_ID__r.Serial_Number__c,Risk_Ref_ID__r.Serial_Number__c,Date_Raised__c,Action_Age_days__c,Raised_by_Client_Accenture__c,Raised_By_person_New__r.name,Forum_Raised__c,Workstream_Area__c,Raised_at_level__c,Description__c,Updates__c,Status_Update__c,Target_Close_Date__c,Action_Due_In_days__c,Actual_Closed_Date__c,Action_Closure_Notes_Comments__c,Primary_Owner_New__r.name,Secondary_Owner_New__r.name  from RAID_Action__c where Deal__r.id= : dealId order by createddate limit 1000];
        
        listDecisionRaidRecords = [Select id, name, Date_Raised__c,Risk_Ref_ID__c, Risk_Ref_ID__r.Serial_Number__c, Issue_Ref_ID__r.Serial_Number__c,Issue_Ref_ID__c, Forum_Raised__c, Description__c, Serial_Number__c, Raised_By_person_New__r.name,Workstream_Area__c,Raised_at_level__c,Additional_Notes_Comments__c,Target_Close_Date__c,Actual_Close_Date__c from RAID_Decision__c where Deal__r.id = : dealId order by createddate limit 1000];
    
    }
}