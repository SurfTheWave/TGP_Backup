/*
   @Author         : Suma
   @name           : MaintainTrackerHistoryController
   @CreateDate     : 2 January 2015
   @Description    : Controller Class for MaintainTrackerHistory Page
   @Version        : 1.0
  */


public with sharing class MaintainTrackerHistoryController {
    /**
     *  This class is to maintain all the trackers field history.
     *
     *  History report can be generated for those fields for which SalesForce tracking is enabled which is as follows
     *  Responsibility
     *  Planned Start Date
     *  Planned End Date
     *  Milestone
     *  Completion Status (%)
     *  Status
     *  Actual Start Date
     *  Actual End Date
     *
     **/    
    // Getting values from the URL.
    public String objName = ApexPages.currentPage().getParameters().get(UtilConstants.OBJECT_NAME);
    public String recordID = ApexPages.currentPage().getParameters().get(UtilConstants.ID);
    public String wave = ApexPages.currentPage().getParameters().get(UtilConstants.WAVE);
    public String field1 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD1);
    public String field2 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD2);
    public String field3 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD3);
    public String field4 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD4);
    public String field5 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD5);
    public String field6 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD6);
    public String field7 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD7);
    public String field8 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD8);
    public String field9 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD9);
    public String field10 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD10);
    public String field11 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD11);
    public String field12 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD12);
    public String field13 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD13);
    public String field14 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD14);
    public String field15 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD15);
    public String field16 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD16);
    public String field17 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD17);
    public String field18 = ApexPages.currentPage().getParameters().get(UtilConstants.FIELD18);
    
    
    public static final String CLASS_NAME=UtilConstants.MAINTAIN_CLASS_NAME;
    
    
    public List<HistoryInfo> HistoryList {get;set;}
    public boolean showMessage {get;set;}
    public boolean WaveTrue {get;set;}
    public String keyPrefix{ get; Set;} 
    //Wrapper class to store the values.
    public  without sharing class HistoryInfo{
        public String FieldName {get;set;}
        public String OldValue {get;set;}
        public String NewValue {get;set;}
        public String ModifiedBy {get;set;}
        public String ModifiedDate {get;set;}
        public String Wave{get;set;}
        
         // consturctor for wrapper class 
        public HistoryInfo(String FieldName,String OldValue,String NewValue,String ModifiedBy,String ModifiedDate,String Wave){
            this.FieldName = FieldName;
            this.OldValue = OldValue;
            this.NewValue = NewValue;
            this.ModifiedBy = ModifiedBy;
            this.ModifiedDate = ModifiedDate;
            this.Wave= Wave;
        }
    }
    
    /*
     *  Constructor to initialize the values.
     **/

    public MaintainTrackerHistoryController (){
        try{
            HistoryList = new List<HistoryInfo>();
            showMessage  = false;
            WaveTrue= false;
            
            if(Wave.EqualsIgnoreCase(UtilConstants.NA))
            {
                WaveTrue= true;
            }
            
            if(objName != null && recordID != null){
                String queryString = UtilConstants.SOQL_STRING1 + ObjName+ UtilConstants.SOQL_STRING2  ;
                String HistoryObjName = UtilConstants.HISTORY_OBJECT;
                List<sObject> ChildHistoryList = Database.query(queryString);
                        
                for(sObject sObj:ChildHistoryList){
    
                    for(sObject HistoryRecords:sObj.getSObjects(HistoryObjName)){   
                        // Getting the FieldLable.             
                        String strFieldLabel = String.valueOf(HistoryRecords.get(UtilConstants.FIELD)); 
                        // Getting the Field Name.                            
                        Schema.SObjectField sfieldName = Schema.getGlobalDescribe().get(ObjName).getDescribe().fields.getMap().get(strFieldLabel);
                        
                        if(sfieldName != null){
                            Schema.DescribeFieldResult fieldDescribe = sfieldName.getDescribe();
                            strFieldLabel = fieldDescribe.getLabel();
                        }
                        // New Value.
                        String strNewValue = String.ValueOf(HistoryRecords.get(UtilConstants.NEW_VALUE));   
                        if(String.ValueOf(HistoryRecords.get(UtilConstants.NEW_VALUE)) != null &&
                        ((HistoryRecords.get(UtilConstants.FIELD)==(UtilConstants.ACTUAL_START_DATE)) 
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.ACTUAL_END_DATE)) 
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.PLANNED_END_DATE))
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.PLANNED_START_DATE)) 
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.ACTUAL_GO_LIVE_DATE))
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.WAVE_GO_LIVE_DATE)) 
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.ACTUAL_DATE)))){
                            String newValueStr = String.valueOf(HistoryRecords.get(UtilConstants.NEW_VALUE));
                            Datetime dateNewValue = datetime.valueof(newValueStr);
                            if(dateNewValue != null)
                                strNewValue = dateNewValue.format(UtilConstants.DATE_FORMAT);
                        }
                        // Old Value.
                        String strOldValue = String.ValueOf(HistoryRecords.get(UtilConstants.OLD_VALUE));   
                        if(String.ValueOf(HistoryRecords.get(UtilConstants.OLD_VALUE)) != null && 
                        ((HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.ACTUAL_START_DATE)) 
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.ACTUAL_END_DATE))  || 
                            (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.PLANNED_END_DATE)) 
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.PLANNED_START_DATE)) || 
                            (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.ACTUAL_GO_LIVE_DATE))
                            || (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.WAVE_GO_LIVE_DATE))|| 
                            (HistoryRecords.get(UtilConstants.FIELD).equals(UtilConstants.ACTUAL_DATE)) )){
                            String oldValueStr = String.valueOf(HistoryRecords.get(UtilConstants.OLD_VALUE));
                            Datetime dateOldValue = datetime.valueof(oldValueStr);
                            if(dateOldValue != null)
                                strOldValue = dateOldValue.format(UtilConstants.DATE_FORMAT);
                        }
                        
                        String strCreatedDate = String.ValueOf(HistoryRecords.get(UtilConstants.CREATED_DATE));   
                        Datetime dateCreatedDate = datetime.valueof(strCreatedDate );
                        if(dateCreatedDate != null)
                            strCreatedDate = dateCreatedDate.format(UtilConstants.DATE_FORMAT);                
                        
                        SObject usr = HistoryRecords.getSObject(UtilConstants.CREATED_BY);
                        Schema.DescribeSObjectResult r = Delivery_Location_Masters__c.sObjectType.getDescribe();
                        keyPrefix = r.getKeyPrefix();
                        //system.debug('keyPrefix -- '+keyPrefix);
                                        
                        if(!strFieldLabel.equalsIgnoreCase(UtilConstants.CREATED) && 
                                ((String.valueOf(HistoryRecords.get(UtilConstants.FIELD)) == field1) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field2))
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field3)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field4)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field5)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field6)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field7)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field8)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field9)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field10)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field11)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field12))
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field13))
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field14)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field15)) 
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field16))
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field17))
                                        || (String.valueOf(HistoryRecords.get(UtilConstants.FIELD)).equals(field18)))){
                                                                    
                            if(strNewValue <> null ){
                                if(!strNewValue.contains(keyPrefix)){              
                                    HistoryList.add(new HistoryInfo(strFieldLabel,strOldValue,strNewValue,String.ValueOf(usr.get(UtilConstants.NAME)),strCreatedDate, wave));
                                }
                            }    
                            else{
                                HistoryList.add(new HistoryInfo(strFieldLabel,strOldValue,strNewValue,String.ValueOf(usr.get(UtilConstants.NAME)),strCreatedDate, wave));
                            }
                        }
                    }
                }           
            }
            /**
             * Checking if the list NOT contains a value means list size is ZERO then, No History found Message to the user.
             **/
            if(HistoryList.size() > 0){
                showMessage = true; 
            }else{
                showMessage = false; 
            }         
        } catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,CLASS_NAME, CLASS_NAME, 
                   null, System.Logginglevel.ERROR);
        } 
    } 
}