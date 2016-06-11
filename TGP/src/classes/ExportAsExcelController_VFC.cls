/**
   @Author : Madhusudhan
   @name   : ExportAsExcelController_VFC 
   @CreateDate : 07 Jan 2015 
   @Description : 
   @Version : 1.0 
  */
public without sharing class ExportAsExcelController_VFC {
        
     public List<sObject> objLst {get;set;} 
     public String obj;
     public String soql;
     public String recordId;
     public String fieldNames {get;set;}
     public List<String> flds {get;set;}
     public List<String> fldsLabel {get;set;}
     public Map<String,String> fldDataType {get;set;}
     public String coma {get;set;}
     public String newLine {get;set;}
     public List<String> pageFieldLabels {get;set;} 
     public String objType {get; set;}
      // The sObject type as a string
/******************
 * @methodname  : getObjectType
 * @returns    : string of sobject type
 * @description :
******************/
        public String getObjectType() {
              return(this.objType);
        }
/******************
 * @methodname : setObjectType
 * @returns    : string of sobject type
 * @description :
******************/
        public String setObjectType(sObject newObj) {
            this.objType =  System.currentPageReference().getParameters().get(UtilConstants.OBJECT_NAME);
            return(this.objType);
        }
/******************
 * @methodname : findObjectAPIName
 * @parameters : id of record
 * @returns    : string
 * @description :
******************/       
       
        public string findObjectAPIName( String recordId ){
            if(recordId == null)
                return null;
            //System.debug('recordId:: in findObjAPTNAme function:::'+recordId);

            String objectAPIName = UTIL_Constants.EMPTY_STRING ;
            String keyPrefix = recordId.substring(0,3);
             for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ) {
                  String prefix = obj.getDescribe().getKeyPrefix();
                  //System.debug('prefix:: in findObjAPTNAme function:::'+prefix+'  keyPrefix::'+keyPrefix);
                   if(keyPrefix.equals(prefix)) {
                             objectAPIName = obj.getDescribe().getName();
                              break;
                   }
            }

         return objectAPIName;
    }
/******************
 * @methodname : ExportAsExcelController_VFC
 * @type    : constructor
 * @parameters : none
 * @returns    : none 
 * @description :
******************/ 
 
     public ExportAsExcelController_VFC () {


          coma = UTIL_Constants.COMMA_STRING ;
          newLine = UTILConstants.NEW_LINE;
          obj = System.currentPageReference().getParameters().get(UtilConstants.OBJECT_NAME);
          soql = System.currentPageReference().getParameters().get(UtilConstants.SOQL);
          recordId = System.currentPageReference().getParameters().get(UtilConstants.REC_ID);
          //System.debug('recordId-------- ' + recordId); 
          String Condition = findObjectAPIName(recordId); 

          soql +=' where '+ Condition +'=:recordId';
         // System.debug('soql-------- ' + soql);  
     }






 
 public void exportToExcel() { 
      fieldNames = soql.subString(7,soql.indexOf(UtilConstants.FROM_STRING ));  
      //System.debug('fieldNames is ........ ' + fieldNames);  
      flds = fieldNames.split(UTIL_Constants.COMMA_STRING );
      //system.debug('SOQL is ::'+soql);
      objLst = Database.Query(soql);
      //system.debug('objLst------>'+objLst);
     }
}