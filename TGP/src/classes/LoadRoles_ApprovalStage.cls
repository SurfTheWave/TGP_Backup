global class LoadRoles_ApprovalStage implements Database.Batchable<sObject>,database.stateful{
        global LoadRoles_ApprovalStage (){
           
        }
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Opportunity__c FROM Approval_Stage__c';
         return Database.getQueryLocator(query);
        }
      // Execute Logic
    global void execute(Database.BatchableContext BC, List<Approval_Stage__c>scope){
    List<Approval_Stage__Share> share = new List<Approval_Stage__Share>();
        for(Approval_Stage__c stage:scope){
            for(Opportunity_Teams__c team:[SELECT Id, Opportunity_Team_Member__r.user__c, Opportunity__c FROM Opportunity_Teams__c]){
        If(team.Opportunity__c==stage.Opportunity__c){
            Approval_Stage__Share object1= new Approval_Stage__Share();
            object1.ParentId=stage.Id;
            object1.UserOrGroupId=team.Opportunity_Team_Member__r.user__c;
            object1.AccessLevel='Edit';
            share.add(object1); 
        }  
       }
        }
        savepoint sp = database.setSavepoint();
        try{
            database.upsert(share,true);
        }
        catch (exception e){
            system.debug('Exception=='+e);
        database.rollback(sp); 
        }
    }
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
}