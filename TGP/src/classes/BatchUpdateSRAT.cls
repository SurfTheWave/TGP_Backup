/**
   @Author Mobilization Workbench
   @name BatchUpdateSRAT
   @CreateDate 08/12/2015
   @Description This is the class for BatchUpdateSRAT
   @Version <1.0>
   @reference 
  */
global  class BatchUpdateSRAT implements Database.Batchable<sObject>{
       /*
*    @Description: Method in MWB
*    @Name :start
*    @param 
*    @return <parameter> - void
*/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = UTILConstants.SratTrackerQuery;
            return Database.getQueryLocator(query);
         }
     /*
*    @Description: Method in MWB
*    @Name :execute
*    @param 
*    @return <parameter> - void
*/        
    global void execute(Database.BatchableContext BC, List<SRAT_Tracker__c> scope){
        for(SRAT_Tracker__c i : scope)
        {
            String s = i.Name.replace(UTILConstants.SRATValue ,UTILConstants.SERVICE_READINESS_REVIEW);
          i.Name = s;
        }
        update scope;
    }
    /*
*    @Description: Method in MWB
*    @Name :finish
*    @param 
*    @return <parameter> - void
*/
    global void finish(Database.BatchableContext BC){
        
    }
    }