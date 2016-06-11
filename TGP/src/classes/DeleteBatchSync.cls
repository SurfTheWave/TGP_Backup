/**   @Author Ezhdan
   @name   DeleteBatchSync
   @CreateDate 14 Augest 2015
   @Description DeleteBatchSync
   @Version
  */
global class DeleteBatchSync implements Database.batchable<id>,database.stateful{
global list<id> records_todelete;
global id oppid;
global string type;
global string srvgrp;
global Integer errorIndex;
global map<string,string> costdata;
@testvisible 
    private String isTestvariable='hello';
    /**
   *  @name : DeleteBatchSync
   *  @Description : constructor
   *  @param : deleterecords,Opportunityid,Operation,costingJson
   *  @return parameter - NA
   *  @throws exception- NA
   */
    global DeleteBatchSync(set<id> deleterecords, id Opportunityid,string Operation,
                                                                           map<string,string> costingJson,String ServiceGrp){
       records_todelete = new list<id>();
       records_todelete.addAll(deleterecords);
       oppid = Opportunityid;
       srvgrp=ServiceGrp;
       type = Operation;
       costdata = costingJson;
       errorIndex = 0;
       UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
    } 
    /**
   *  @name : start
   *  @Description : start
   *  @param : BatchableContext
   *  @return parameter - NA
   *  @throws exception- NA
   */
    global Iterable<id> start(Database.BatchableContext info){ 
       return records_todelete; 
   }     
    /**
   *  @name : execute
   *  @Description : execute
   *  @param : BatchableContext,scope
   *  @return parameter - void
   *  @throws exception- NA
   */   
   global void execute(Database.BatchableContext info, List<id> scope){
       try{
       UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
          Database.delete (scope,true);
          
       }
       catch(exception e){
         ExceptionClass.logException(SWBBPOSEIntegrationConstants.DeleteBatchSync ,SWBBPOSEIntegrationConstants.executefailed,e,UtilConstants.SWB,UtilConstants.BPOSE);
         errorindex++;
       }
   } 
   /**
   *  @name : finish
   *  @Description : finish
   *  @param : BatchableContext
   *  @return parameter - void
   *  @throws exception- NA
   */       
   global void finish(Database.BatchableContext info){
       // resetting scope status to out of scope and meking all offerings in active
        //ScopeUpdataion_FutureClass.updateScope(oppid,UtilConstants.OUT_SCOPE,false); 
        //invoking batch class to perform further transaction of making is transient false;
        UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
        if(UtilConstants.CSCOMMIT.equalsignorecase(type) && errorindex ==0){ 
            UpdateBatchSync  batchJob = new UpdateBatchSync(oppid,costdata,srvgrp);
            Id batchInstanceId = Database.executeBatch(batchJob, 1500);
        }
        else if(UtilConstants.CSROLLBACK.equalsignorecase(type) && errorindex==0){
            Costing_request__C cost = new costing_request__c(id=costdata.get(SWBBPOSEIntegrationConstants.id));
            cost.Sync_Failed_At__c = '';
            cost.Data_Cleaning_dev__c=false;
            cost.in_progress__c =SWBBPOSEIntegrationConstants.failurestatus;
            update cost;
        }
        else if(errorindex > 0){
            Costing_request__C cost = new costing_request__c(id=costdata.get(SWBBPOSEIntegrationConstants.id));
            cost.Sync_Failed_At__c = SWBBPOSEIntegrationConstants.ROLBACK;
            cost.Data_Cleaning_dev__c=false;
            cost.in_progress__c =SWBBPOSEIntegrationConstants.inprogressstatus;
            update cost;
        }
   } 
}