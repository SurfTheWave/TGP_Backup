/**
 *@Author:Vinay.kumar.chada
 *@Name:CheckDeleteMWB
 *@Description:This class contains all methods which is called from Delete button of respective object records
 *@version:1.0 
 */ 
public without sharing class CheckDeleteMWB { 

    public Id RecordId {get;set;}
    public Id parentId {get;set;}
    public String urlPeram {get; set;}

    /**
     *@Author:Vinay.kumar.chada
     *@Name:CheckDeleteMWB
     *@Description:This constructor is initialized when new instance of checkdeleteMWB is called
     *@version:1.0
     */
    public CheckDeleteMWB(ApexPages.StandardController strController) { 
       RecordId = strController.getId();
       parentId = ApexPages.currentPage().getParameters().get(UtilConstants.id_par);
       urlPeram  = ApexPages.currentPage().getParameters().get(UtilConstants.retURL);
       String[] cd = urlPeram.split(UtilConstants.SLASH);
       urlPeram =cd[1];
    }
    
    /**
     *@Author:Vinay.kumar.chada
     *@Name:CheckDeleteMWB
     *@Description:This method is called on click of delete button from UI
     *@version:1.0
     */
    public PageReference CheckDeleteMWB() {
        try{
             Boolean isUserFound=false;
            String strUserId = UserInfo.getUserId();
            String userRoleName = [select u.UserRole.Name from User u where u.id = :strUserId LIMIT 1].UserRole.Name; //Get users with UserRole Name
            if(userRoleName <> null){
                if(userRoleName.equalsIgnoreCase(UtilConstants.MOB_Admin) || userRoleName.equalsIgnoreCase(UtilConstants.MOB_LEAD) || userRoleName.equalsIgnoreCase(UtilConstants.WORK_LEAD) || userRoleName.equalsIgnoreCase(UtilConstants.SYS_ADMIN)){
                    isUserFound=true;
                }
            } 
            if(!isUserFound){
            Boolean shareValue = [SELECT  RecordId,MaxAccessLevel,HasEditAccess  
                                  FROM UserRecordAccess where UserId =: strUserId and RecordId =: RecordId LIMIT 1].HasEditAccess;
                if(shareValue ){
                    isUserFound=true;
                }           
            }
    
            if(isUserFound){
                Schema.SObjectType sobj = RecordId.getSobjectType();
                String objectAPIName = string.valueof(sobj);
                
                /************* Mobilization Team Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.MOB_TEAM)){
                    List<Mobilization_Team__c> getSobjRecords =[Select id,Deal__c,Role__c 
                                                                from  Mobilization_Team__c where id=:RecordId LIMIT 10000];
                    if(getSobjRecords[0].Role__c==UtilConstants.GTL || getSobjRecords[0].Role__c==UtilConstants.ROLE_ID){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, UtilConstants.TEAM_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH +urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Mobilization Plan  Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.MOB_PLAN)){
                    List<Mobilization_Plan__c> getSobjRecords =[Select id,Deal__c,Active__c 
                                                                from  Mobilization_Plan__c where id=:RecordId LIMIT 10000];
                    if(getSobjRecords[0].Active__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, UtilConstants.DELETE_ACTIVE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Wave Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.WAV)){
                    List<Wave__c> getSobjRecords =[Select id,Active__c, Mobilization_Plan__r.Active__c 
                                                   from  Wave__c where id=:RecordId LIMIT 10000];
                    if(getSobjRecords[0].Active__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, UtilConstants.DELETE_ACTIVE));
                        return null;                 
                    }else if(!getSobjRecords[0].Mobilization_Plan__r.Active__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, UtilConstants.CHILD_DELETE));
                        return null;
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Budget Tracking Item Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.BUDGET_TRACKER)){
                    List<Budget_Trac__c> getSobjRecords =[Select id,Mobilization_Plan__r.Active__c 
                                                          from  Budget_Trac__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].Mobilization_Plan__r.Active__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* BCP Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.BCP_TRACKER)){
                    List<BCP_Tracker__c> getSobjRecords =[Select id,Mobilization_Plan__r.Active__c 
                                                          from  BCP_Tracker__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].Mobilization_Plan__r.Active__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Contract & Legal Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.CONTRACT_TRACKER)){
                    List<Contract_Legal_Tracker__c> getSobjRecords =[Select id,isPlanActive__c 
                                                                     from  Contract_Legal_Tracker__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].isPlanActive__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Service Management Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.SERVICE)){
                    List<Service_Management_Tracker__c> getSobjRecords =[Select id,isPlanActive__c 
                                                                         from  Service_Management_Tracker__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].isPlanActive__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Journey Management Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.JOURNEY)){
                    List<Journey_Management_Tracker__c> getSobjRecords =[Select id,isPlanActive__c 
                                                                         from  Journey_Management_Tracker__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].isPlanActive__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Wave Process Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.WAV_PROC)){
                    List<Wave_Proc__c> getSobjRecords =[Select id,Active__c, Mobilization_Plan__r.Active__c 
                                                        from  Wave_Proc__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].Mobilization_Plan__r.Active__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else if(getSobjRecords[0].Active__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, UtilConstants.DELETE_ACTIVE));
                        return null;                 
                    }
                    else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }            
                
                /************* KT Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.KT_TRAC)){
                    List<KT_Trac__c> getSobjRecords =[Select id,IsPlanActive__c from  KT_Trac__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].IsPlanActive__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* RT Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.REC_TRACK)){
                    List<Recruit_Tracker__c> getSobjRecords =[Select id,IsPlanActive__c from  Recruit_Tracker__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].IsPlanActive__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Tech & WE Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.TECH_WE)){
                    List<Tech_WE_Tracker__c> getSobjRecords =[Select id,IsPlanActive__c from  Tech_WE_Tracker__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].IsPlanActive__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* SRAT Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.SRAT)){
                    List<SRAT_Tracker__c> getSobjRecords =[Select id,IsPlanActive__c from  SRAT_Tracker__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].IsPlanActive__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* OPEX Tracker Delete Code*********************/
                if(objectAPIName.equalsIgnoreCase(UtilConstants.OPEX)){
                    List<OPEX_Tracker__c> getSobjRecords =[Select id,IsPlanActive__c from  OPEX_Tracker__c where id=:RecordId LIMIT 10000];
                    if(!getSobjRecords[0].IsPlanActive__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,UtilConstants.CHILD_DELETE));
                        return null;                 
                    }else{
                        Database.delete(getSobjRecords[0]); 
                        PageReference ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                        return ref ;           
                    }
                }
                
                /************* Comman code for Delete *********************/        
                string query = 'SELECT id FROM '+ objectAPIName +' where id = '+ '\''+ RecordId  + '\'' ;
                list<sobject> getSobjRecords = database.query(query);               
                List<Database.deleteResult> performdelete = Database.delete(getSobjRecords,false);
                PageReference ref =null;
                  for (Database.DeleteResult sr : performdelete) {
                      if (sr.isSuccess()) {
                         ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                          return ref ;
                      }
                      else {
                          // Operation failed, so get all errors                
                          for(Database.Error err : sr.getErrors()) {
                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,err.getMessage()));
                              return null;
                          }
                      }
                }
                
                ref =  new PageReference(UtilConstants.SLASH+urlPeram);
                return ref ;            
             }else{
                return null;
             }
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.CHECK_DELETE , UtilConstants.CHECK_DELETE , null, System.Logginglevel.ERROR);
            return null;
        }
           
        
    }  
}