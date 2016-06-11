/*********

Batch size should be 1
*********/
global class createmissed_utilizations implements Database.Batchable<sObject>,database.stateful{

        global createmissed_utilizations (){
           
        }
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'select id,opportunity__c,Opportunity_team_member__c,opportunity__r.name from Opportunity_teams__c';
        
         return Database.getQueryLocator(query);
        }
      
      // Execute Logic
    global void execute(Database.BatchableContext BC, List<Opportunity_teams__c>scope){
    set<string> uniqueroles = new set<string>();
    list<Opportunity_teams__c> oppteam_toinsert = new List<Opportunity_teams__c>();
    map<id,utilizations__c> Map_toupdate = new map<id,utilizations__c>();
        for(Opportunity_teams__c util:scope){
            try{
                utilizations__c oppTeam = [select id,name,user_role_s__c,field_for_migration__c,user__c,Opportunity__c from utilizations__c where user__c =:util.Opportunity_team_member__c AND Opportunity__c =:util.opportunity__c];
            }
            catch(exception e){
                oppteam_toinsert.add(util);
            }
        }
        List<Utilizations__c> utilstoinsert = new list<Utilizations__c>();
        for(Opportunity_teams__c oppt : oppteam_toinsert){
            Utilizations__c utilizationObjectOther = new Utilizations__c(); 
                utilizationObjectOther.Opportunity__c = oppt.opportunity__c;
                utilizationObjectOther.User__c = oppt.Opportunity_team_member__c;
                if(oppt.Opportunity__r.Name.length() >80){
                     utilizationObjectOther.Name = oppt.Opportunity__r.Name.substring(0,67)+' '+'Utilization';
                }
                else{
                utilizationObjectOther.name = oppt.Opportunity__r.Name+' '+'Utilization';
                }
                utilizationObjectOther.Current_week__c = 0;
                utilizationObjectOther.Current_week_1__c = 0;
                utilizationObjectOther.Current_week_2__c = 0;
                utilizationObjectOther.Current_week_3__c = 0;
                utilizationObjectOther.Current_week_4__c = 0;  
                utilstoinsert.add(utilizationObjectOther);
        }
        try{
            insert utilstoinsert ;
        }
        catch(exception e){
            system.debug('error---->'+e);
        }
    }
       
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
}