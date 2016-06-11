/*@Developer: Shivraj
 *@Description: This batch class is used to delete solution scope records which
 *				has a different service group from opportunity
 */
global class SolutionScopeDeleteBatch implements Database.Batchable<sObject>,Database.Stateful{
	private String query;
    private set<String> solScopeId=new set<String>();
   /*
    *@Description: This method accepts two parameters from main batch class
    */
    global SolutionScopeDeleteBatch(String qur,set<String> solId){
        query=qur;
        solScopeId=solId;
    }
    
     /*
     *@Description: This method returns the solution scope records to be deleted
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    /*
     *@Description: This method deletes the solution scope records from query method
     */
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
        database.delete(sObjectList,false);
    }
    
    /*
     *@Description: Final method to invoke emails if required
     */
    global void finish(Database.BatchableContext bc){
        
    }
}