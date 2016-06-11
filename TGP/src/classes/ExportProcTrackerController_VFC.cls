/**
   @Author : Madhusudhan
   @name   : ExportProcTrackerController_VFC 
   @CreateDate : 1 Jan 2015 
   @Description : 
   @Version : 1.0 
  */
public without sharing class ExportProcTrackerController_VFC {
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
     public Mobilization_Plan__c planName{get;set;}     
     public String dealNameVaule{get;set;}    
   
	   /**
	   @Method name   : Constructor 
	   @Description   : To Intialize the new line and coma seperator.
	   @Parameters	  : NA
	   @Return Value  : NA 
	  */
     public ExportProcTrackerController_VFC() {
      coma = UtilConstants.COMMA;
      newLine = UtilConstants.NEW_LINE_STRING;
    }
  
   /**
   @Method name   : exportToCSV 
   @Description   : Create the SOQL query using the Custom settings and fetch the Trackers export data from related tracker Object
   @Parameters	  : NA
   @Return Value  : NA 
  */
    public void exportToCSV() { 
    	try{
	        recordId=ApexPages.currentPage().getParameters().get(UtilConstants.REC_ID);
	        objName=ApexPages.currentPage().getParameters().get(UtilConstants.OBJECT_NAME);
	        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();  
	        Schema.DescribeSObjectResult r = gd.get(objName).getDescribe();  
	        fileName =  r.getLabel();
	        UTILMobClasses utilMob = new UTILMobClasses();
	        String Condition = utilMob.findObjectAPIName(recordId);
	        dealNameQry= UtilConstants.SOQL3 + objName + UtilConstants.WHERE_VALUE + Condition + UtilConstants.RECORD_ID + UtilConstants.SOQL2;
	        dealName = Database.Query(dealNameQry);
	        if(dealName <> null){
	           
	        }
	        // End for deal name Tracking on/off
	        List<Export_Fields__c>  fieldsList=[Select Object_Name__c,fields_Name__c from Export_Fields__c where Object_Name__c =:objName Limit 1];
	        for(Export_Fields__c flds : fieldsList) {
	            String [] fields = flds.fields_Name__c.split(UtilConstants.COMMA);
	            sql=UtilConstants.SELECT_VALUE + flds.fields_Name__c + UtilConstants.FROM_STRING + flds.Object_Name__c; 
	            dealNameQry=UtilConstants.SOQL3 +flds.Object_Name__c;
	        }       
	        sql +=UtilConstants.WHERE_VALUE + Condition + UtilConstants.RECORD_ID;
	        
	        fieldNames = sql.subString(7,sql.indexOf(UtilConstants.FROM_VALUE));  
	        //System.debug('fieldNames is ........ ' + fieldNames);  
	        flds = fieldNames.split(UtilConstants.COMMA);
	        objLst = Database.Query(sql);
	     }catch(Exception e){
	     	e.getMessage();	
	     }
    }
}