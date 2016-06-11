public with sharing class Maintain_History {
    public string ObjName = ApexPages.currentPage().getParameters().get('ObjName');
    public string RecordID = ApexPages.currentPage().getParameters().get('ID');
    public string Field1 = ApexPages.currentPage().getParameters().get('Field1');
    public string Field2 = ApexPages.currentPage().getParameters().get('Field2');
    public string Field3 = ApexPages.currentPage().getParameters().get('Field3');
    public string Field4 = ApexPages.currentPage().getParameters().get('Field4');
    public string Field5 = ApexPages.currentPage().getParameters().get('Field5');
    
    public List<HistoryInfo> HistoryList {get;set;}
    public boolean showMessage {get;set;}
    
    public class HistoryInfo{
        public string FieldName {get;set;}
        public string OldValue {get;set;}
        public string NewValue {get;set;}
        public string ModifiedBy {get;set;}
        public string ModifiedDate {get;set;}   
        public HistoryInfo(string FieldName,string OldValue,string NewValue,string ModifiedBy,string ModifiedDate){
            this.FieldName = FieldName;
            this.OldValue = OldValue;
            this.NewValue = NewValue;
            this.ModifiedBy = ModifiedBy;
            this.ModifiedDate = ModifiedDate;
        }
    }

    public Maintain_History (){
        HistoryList = new List<HistoryInfo>();
        showMessage  = false;
        
        if(ObjName != null && RecordID != null){
            string qry = 'Select Id,Name,LastModifiedDate,LastModifiedBy.Name,LastModifiedById,(Select NewValue,OldValue,Field,CreatedDate,CreatedById,CreatedBy.Name From Histories) From '+ ObjName+'  where Id =: RecordID ' ;
            string HistoryObjName = 'Histories';
            List<sObject> ChildHistoryList = Database.query(qry);
                    
            for(sObject sObj:ChildHistoryList){

                for(sObject HistoryRecords:sObj.getSObjects(HistoryObjName)){                
                    String strFieldLabel = string.valueOf(HistoryRecords.get('Field'));
                             
                    Schema.SObjectField sfieldName = Schema.getGlobalDescribe().get(ObjName).getDescribe().fields.getMap().get(strFieldLabel);
                    if(sfieldName != null){
                        Schema.DescribeFieldResult fieldDescribe = sfieldName.getDescribe();
                        strFieldLabel = fieldDescribe.getLabel();
                    }
               
                    String strNewValue = string.ValueOf(HistoryRecords.get('NewValue'));   
                    if(string.ValueOf(HistoryRecords.get('NewValue')) != null && ((HistoryRecords.get('Field')=='Actual_End_Date__c') || (HistoryRecords.get('Field')=='Actual_Start_Date__c') || (HistoryRecords.get('Field')=='Actual_Date__c')|| (HistoryRecords.get('Field')=='Revised_Go_Live__c') || (HistoryRecords.get('Field')=='Actual_Go_Live__c'))){
                        String newValueStr = string.valueOf(HistoryRecords.get('NewValue'));
                        Datetime dateNewValue = datetime.valueof(newValueStr);
                        if(dateNewValue != null)
                            strNewValue = dateNewValue.format('MM-dd-yyyy');
                    }
                
                    String strOldValue = string.ValueOf(HistoryRecords.get('OldValue'));   
                    if(string.ValueOf(HistoryRecords.get('OldValue')) != null && ((HistoryRecords.get('Field')=='Actual_End_Date__c') || (HistoryRecords.get('Field')=='Actual_Start_Date__c') || (HistoryRecords.get('Field')=='Actual_Date__c') || (HistoryRecords.get('Field')=='Revised_Go_Live__c') || (HistoryRecords.get('Field')=='Actual_Go_Live__c'))){
                        String oldValueStr = string.valueOf(HistoryRecords.get('OldValue'));
                        Datetime dateOldValue = datetime.valueof(oldValueStr);
                        if(dateOldValue != null)
                            strOldValue = dateOldValue.format('MM-dd-yyyy');
                    }
                
                    String strCreatedDate = string.ValueOf(HistoryRecords.get('CreatedDate'));   
                    Datetime dateCreatedDate = datetime.valueof(strCreatedDate );
                    if(dateCreatedDate != null)
                        strCreatedDate = dateCreatedDate.format('MM-dd-yyyy');                
                    
                    SObject usr = HistoryRecords.getSObject('CreatedBy');
                    if(strFieldLabel != 'created' && ((string.valueOf(HistoryRecords.get('Field')) == Field1) || (string.valueOf(HistoryRecords.get('Field')) == Field2) || (string.valueOf(HistoryRecords.get('Field')) == Field3) || (string.valueOf(HistoryRecords.get('Field')) == Field4) || (string.valueOf(HistoryRecords.get('Field')) == Field5))){
                        HistoryList.add(new HistoryInfo(strFieldLabel,strOldValue,strNewValue,string.ValueOf(usr.get('Name')),strCreatedDate));
                    }
                }
            }           
        }
        if(HistoryList.size() >0){
            showMessage = true; 
        }else{
            showMessage = false; 
        }         
    }   
}