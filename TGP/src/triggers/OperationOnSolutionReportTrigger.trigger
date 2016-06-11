/*
@Author and Created Date : jyotsna yadav,  3/27/2015 1:07 AM
@name : operationOnSolutionReportTrigger 
@Description : update the querystring field on Solution report for dynamic URL functionality.
@Version : 1.0
*/
trigger OperationOnSolutionReportTrigger on Solution_Report__c (after insert,after update) {
    List<Solution_Report__c> solutionList=new List<Solution_Report__c>();
    if( trigger.isAfter ){
        if( trigger.isInsert){
            if( !UtilConstants.IS_RECURSIVE ){
                operOnSolReportTriggerCntlr.createReportURL( trigger.new);
            }
        }
        
        if(trigger.isUpdate){
            for(Solution_Report__c sol:trigger.new){
            
                Solution_Report__c oldSolutionReport=trigger.oldMap.get(sol.id);
               if(sol.pv__c!=null){
                    if(!(sol.pv__c).equals(oldSolutionReport.pv__c)){
                     //system.debug('gets called after workflow update' +sol.PV__c);
                        solutionList.add(sol);
                    }
                }
            }
            operOnSolReportTriggerCntlr.createReportURL(solutionList);
            
        }
    }
}