/**
   @Author : Madhusudhan
   @name   : ExportTrackerController_VFC 
   @CreateDate : 1 Jan 2015 
   @Description : 
   @Version : 1.0 
  */
public without sharing class ExportTrackerController_VFC {
    
     public String objName{get;set;}
     public static List<Export_Fields__c> opexFieldsList = new List<Export_Fields__c>();
     public String sql = UtilConstants.EMPTY_STRING;
     public String dealNameQry= UtilConstants.EMPTY_STRING;
     public List<sObject> objLst {get;set;} 
     public sObject dealName {get;set;}
     public String soql;
     public String recordId;
     public String fieldNames {get;set;}
     public List<String> flds {get;set;}
     public String fileName{get;set;}
     public Map<String,String> fldDataType {get;set;}
     public String coma {get;set;}
     public String newLine {get;set;}
     Public Mobilization_Plan__c planName{get;set;} 
     public String dealNameVaule{get;set;}
     

     /**
     @Method name   : ExportTrackerController_VFC 
     @Description   : Contractor Method of the class 
    */
     public ExportTrackerController_VFC () {
     coma = UtilConstants.COMMA;
      //coma = '<,>';
      newLine = UtilConstants.NEW_LINE_STRING;
    }
   
   /**
   @Method name   : exportToCSV 
   @Description   : Create the SOQL query using the Custom settings and fetch the Trackers export data from related tracker Object 
  */
        public void exportToCSV() { 
          try{
            recordId=ApexPages.currentPage().getParameters().get(UtilConstants.REC_ID);
            objName=ApexPages.currentPage().getParameters().get(UtilConstants.OBJECT_NAME);
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();  
            Schema.DescribeSObjectResult r = gd.get(objName).getDescribe();  
            fileName =  r.getLabel();
            Boolean isTrackingOn;
            UTILMobClasses utilMob = new UTILMobClasses();
            String Condition = utilMob.findObjectAPIName(recordId);
            // start for deal name, Tracking on/off
              dealNameQry= UtilConstants.SOQL1 + objName + UtilConstants.WHERE_VALUE + Condition + UtilConstants.RECORD_ID + UtilConstants.SOQL2;
            if(String.isNotEmpty(dealNameQry)){
            try{
                    dealName = Database.Query(dealNameQry);
                }
                catch(Exception e){
                    e.getMessage();
                }
            }
            System.debug('dealName is****** ' + dealName);
            if(dealName!=null){
                String planId=(string)dealName.get(UtilConstants.MOBILIZATION_PLAN_API);
               //System.debug('planId-------- ' + dealName.get('Mobilization_Plan__c'));
                planName=[Select Deal__r.Name,IsTrackingOn__c from Mobilization_Plan__c where id= : planId limit 1];
                dealNameVaule=planName.Deal__r.Name;
                isTrackingOn=planName.IsTrackingOn__c;
            }
            // End for deal name Tracking on/off
            List<Export_Fields__c>  fieldsList=[Select Object_Name__c,fields_Name__c from Export_Fields__c where Object_Name__c =:objName and Tracking_on_off__c =: isTrackingOn order by createddate Limit 2];
            String [] fields;
            String fieldN=UtilConstants.EMPTY_STRING;
            if(fieldsList.size()<2){
                for(Export_Fields__c flds : fieldsList) {
                     sql=UtilConstants.SELECT_VALUE + flds.fields_Name__c + UtilConstants.FROM_VALUE + flds.Object_Name__c;
                    fields= flds.fields_Name__c.split(UtilConstants.COMMA);
                }
            }
            else{
                for(Export_Fields__c flds : fieldsList) {
                    fieldN=fieldN+flds.fields_Name__c;
                }
                fields = fieldN.split(UtilConstants.COMMA);
                sql=UtilConstants.SELECT_VALUE + fieldN+UtilConstants.FROM_VALUE + objName; 
            } 
            dealNameQry=UtilConstants.SOQL1 + objName;
            sql +=UtilConstants.WHERE_VALUE + Condition + UtilConstants.RECORD_ID;
            fieldNames = sql.subString(7,sql.indexOf(UtilConstants.FROM_VALUE));  
            flds = fieldNames.split(UtilConstants.COMMA);
            if(String.isNotEmpty(sql)){
            try{
                objLst = Database.Query(sql);
                }catch(Exception e){
                    e.getMessage();            
                }
           }
         }catch(Exception e){
                e.getMessage();
            }
        }
}