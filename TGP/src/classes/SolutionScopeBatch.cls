global class SolutionScopeBatch implements Database.Batchable<sObject>,Database.Stateful{
    global set<String> solScopeId=new set<String>();
    global Map<String,Solution_scope__C> solutionScopeMap=new Map<String,Solution_Scope__C>();
    global string query;
    global List<Solution_Scope__c> solScopeList=new List<Solution_Scope__C>();
    
    global SolutionScopeBatch(String tgpQuery,Map<String,Solution_Scope__C> solScopeMap,set<String> solId){
        solutionScopeMap=solScopeMap;
        query=tgpQuery;
        solScopeId=solId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
        for(sObject sol:sObjectList){
            Id pId=String.valueOf(sol.get('id'));
            solScopeList.add(solutionScopeMap.get(pId));
        }
        
        database.update(solScopeList,false);
    }
    global void finish(Database.BatchableContext bc){
        
    }
}