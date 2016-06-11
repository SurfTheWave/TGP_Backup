/**
   @Author : Suma
   @name   : ExportRAIDController 
   @CreateDate : 22 Jan 2015 
   @Description : Export Functionality for RAID
   @Version : 1.0 
  */
public with sharing class ExportRAIDController {
    public String objName{get;set;}
    public static List<Export_Fields__c> opexFieldsList = new List<Export_Fields__c>();
    public String sql = UtilConstants.EMPTY_STRING;
    public List<sObject> objLst {get;set;} 
     public String objType {get; set;}
     public String soql;
     public Id recordId;
     public String fieldNames {get;set;}
     public List<String> flds {get;set;}
     public List<String> fldsLabel {get;set;}
     public Map<String,String> fldDataType {get;set;}
     UTILMobClasses utilMob = new UTILMobClasses();
     public String whereObj ;
 
	  /**
	   @Name   : Constructor.
	   @Description : Export Functionality
	   @Parameters : NA
	   @Return Value : NA. 
	  */   
	   public ExportRAIDController () {
         objType = System.currentPageReference().getParameters().get(UtilConstants.OBJECT_NAME);
         soql = System.currentPageReference().getParameters().get(UtilConstants.SOQL);
         recordId = System.currentPageReference().getParameters().get(UtilConstants.REC_ID);
	    }
	   
     /**
     @ Method name	: Get method for object.
     @ Description	: getter/setter methods.
     @ Parameters	: NA
     @ Return Value	: String.
     */
    public String getObjectType() {
          return(this.objType);
    }
    /**
     @ Method name	: Set method for object.
     @ Description	: getter/setter methods.
     @ Parameters	: sobject type
     @ Return Value	: String.
     */
    public String setObjectType(sObject newObj) {
        this.objType =  System.currentPageReference().getParameters().get(UtilConstants.OBJECT_NAME);
        return(this.objType);
    }
    
	  /**
	   @name   : Export to Excel  
	   @Description : Export Functionality
	   @Parameters : NA
	   @Return Value : NA. 
	  */       
    public void exportToExcel() {
    
    try{
        objName=ApexPages.currentPage().getParameters().get(UtilConstants.OBJECT_NAME);
        recordId = System.currentPageReference().getParameters().get(UtilConstants.REC_ID);
        
        for(Export_Fields__c flds : [Select Object_Name__c,fields_Name__c from Export_Fields__c where Object_Name__c =:objName  Limit 1]) {
            String [] fields = flds.fields_Name__c.split(UtilConstants.COMMA_STRING);
            sql=UtilConstants.SELECT_VALUE+flds.fields_Name__c+UtilConstants.FROM_VALUE+flds.Object_Name__c; 
        }            
        String objName = utilMob.findObjectAPIName(recordId);
        //system.debug('sql::'+sql);
        soql = sql+UtilConstants.WHERE_VALUE + objName +UtilConstants.RECORD_ID; 
        fieldNames = soql.subString(7,soql.indexOf(UtilConstants.FROM_VALUE));   
        flds = fieldNames.split(UtilConstants.COMMA);
        objLst = Database.Query(soql); 
       // system.debug('objLst  in ::'+objLst ); 
     
     }catch(Exception e){
         e.getMessage();
       } 
     }
}