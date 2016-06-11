/*@Author: Shivraj
 *@description:This Scheduler class is used to delete all the Solution Scope records which 
 *             has a different service group with opportunity    
 */ 
global class SolutionScopeScheduler implements Schedulable{
    /*@Author: Shivraj
     *@Description: This method picks up all the records which satify the condition and deletes them
     *              
     */
    global void execute(SchedulableContext SC) {
        Map<String,Solution_Scope__C> solutionScopeMap=new Map<String,Solution_Scope__C>();
        set<String> solScopeId=new Set<String>();
        try{
            for(Solution_Scope__c solScope:[select id,name,Service_Group__c,SAP_Offering_Revenue__c,
                                        Opportunity__r.Service_Grp__c from solution_scope__C 
                                        where (SAP_Offering_Revenue__c=0 OR SAP_Offering_Revenue__c=null) 
                                            and Solution_Component__c=:UtillContstant_Novasuite.DELIVERY
                                        and IsUserAddedOffering__c= FALSE and 
                                        ((Opportunity__r.Service_Grp__c= :UtillContstant_Novasuite.BPO 
                                          and Service_Group__c IN (:UtillContstant_Novasuite.IO,:UtillContstant_Novasuite.IC)) 
                                         OR (Opportunity__r.Service_Grp__c= :UtillContstant_Novasuite.IO 
                                             and Service_Group__c IN (:UtillContstant_Novasuite.BPO,:UtillContstant_Novasuite.IC)) 
                                         OR (Opportunity__r.Service_Grp__c= :UtillContstant_Novasuite.IC 
                                             and Service_Group__c IN (:UtillContstant_Novasuite.BPO,:UtillContstant_Novasuite.IO)) 
                                         OR (Opportunity__r.Service_Grp__c= :UtillContstant_Novasuite.IO_IC 
                                             and Service_Group__c IN (:UtillContstant_Novasuite.BPO)))]){
                                        
                                                   
                                            solScopeId.add(solScope.id);
                                        }
            system.debug('Size is' +solScopeId.size());
            if(!solScopeId.isEmpty()){
               Id batchId=database.executeBatch(new SolutionScopeDeleteBatch(UtillContstant_Novasuite.solQuery,solScopeId)); 
            }
        }catch(Exception e){
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtillContstant_Novasuite.SOL_SCOP, UtillContstant_Novasuite.SOL_SCOP, null, System.Logginglevel.ERROR);
        }
    }
}