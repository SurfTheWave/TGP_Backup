/*********************
copy this code in anonymous block and run 2 times.
first time opp1 will be IO
second time opp1 will be IC
turn off Opportunity trigger there are some email alerts which triggers

string opp1 = 'IO';
string emptystring='';
string q = 'Select opportunity__c from solution_scope__C where  (service_group__c=\''+opp1+'\') AND active__c=true';
database.executeBatch(new populateIO_ICfields(q,'primary'),200);

string opp1 = 'IC';
string emptystring='';
string q = 'Select id,opportunity__c,Solution_Component__c,Offering_Master__r.Service_Group__c from solution_scope__C where  (service_group__c=\''+opp1+'\') AND active__c=true';
database.executeBatch(new populateIO_ICfields(q,'updateofferings'),200);

*************************/
global class populateIO_ICfields implements Database.Batchable<sObject>{
string query;
string type;
    global populateIO_ICfields(string q,string t){
        query = q;
        type = t;
    }
     global Database.QueryLocator start(Database.BatchableContext BC){
     system.debug('query string '+query);
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<solution_scope__c > scope){
   system.debug('queried records---> '+scope);
     //operationOnSolCompTriggerController.updatePrimaryOffOnOpp(scope);
     system.debug('type ----- > '+type);
    map<id,opportunity> oppListToUpdateBPO = new map<id,opportunity>();
     map<id,opportunity> oppListToUpdateIO= new map<id,opportunity>(); 
     map<id,opportunity> oppListToUpdateIC= new map<id,opportunity>(); 
       set < ID > oppIds = new set < ID > ();
       for(solution_scope__c sol: scope){
           oppIds.add(sol.opportunity__c);
       }
       if(type.equalsignorecase('primary')){
         for(Opportunity oppRec: [select id,Primary_IO_Offering_name__c, (select id, SAP_Offering_Revenue__c,Offering_Master__r.name FROM Solution_Components__r where Active__c = : true AND service_group__c='IO' order by SAP_Offering_Revenue__c desc limit 1)FROM Opportunity where id IN: oppIds LIMIT 5000]){
            if (oppRec.Solution_Components__r.size() > 0) {
                for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                    oppRec.Primary_IO_Offering_name__c = solComponentRec.offering_master__r.name;
                    system.debug('update primary off method invoked'+oppRec.Primary_IO_Offering_name__c);
                  oppListToUpdateIO.put(oppRec.id,oppRec);
                }
            }   
        }
        for(Opportunity oppRec: [select id,Primary_IO_Offering_name__c, (select id, SAP_Offering_Revenue__c,Offering_Master__r.name FROM Solution_Components__r where Active__c = : true AND service_group__c='IC' order by SAP_Offering_Revenue__c desc limit 1)FROM Opportunity where id IN: oppIds LIMIT 5000]){
            if (oppRec.Solution_Components__r.size() > 0) {
                for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                    oppRec.Primary_IC_Offering_name__c = solComponentRec.offering_master__r.name;
                    system.debug('update primary off method invoked'+oppRec.Primary_IC_Offering_name__c);
                    oppListToUpdateIC.put(oppRec.id,oppRec);
                }
            }   
        }
        try{
            update oppListToUpdateIO.values();
            update oppListToUpdateIc.values();
        }
        catch(exception e){
            system.debug('exception '+e);
        }
      }
      else{
        for(Opportunity oppRec: [select id,Offerings_IO__c, Offerings_IC__c, (Select id,opportunity__c,Solution_Component__c,Offering_Master__r.Service_Group__c,Offering_Master__r.name from Solution_Components__r where solution_component__c='Delivery' AND active__c=true)FROM Opportunity where id IN: oppIds LIMIT 5000]){
            String offListIO = UtilCOnstants.EMPTY_STRING;
            String offListIC = UtilCOnstants.EMPTY_STRING;
            if (oppRec.Solution_Components__r.size() > 0) {
                for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                    if (solComponentRec.Offering_Master__r.Service_Group__c !=null && solComponentRec.Offering_Master__r.Service_Group__c.equals(UtilCOnstants.IO)) {
                            offListIO += solComponentRec.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                    } else if(solComponentRec.Offering_Master__r.Service_Group__c !=null && solComponentRec.Offering_Master__r.Service_Group__c.equals(UtilCOnstants.IC)){
                            offListIC += solComponentRec.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                    }
                    else{
                           
                    }
                }
                if (offListIO != null) {
                //oppRec.Offerings_IO__c = offListIO.removeEnd(UtilCOnstants.DELIMITER);
                //oppListToUpdateIO.add(oppRec);
            }
            if (offListIC != null) 
            {
                oppRec.Offerings_IC__c = offListIC.removeEnd(UtilCOnstants.DELIMITER);
                //oppListToUpdateBPO.add(oppRec);

            }
            oppListToUpdateBPO.put(oppRec.id,oppRec);
            }
        }
        try{
            update oppListToUpdateBPO.values();
        }
        catch(exception e){
            system.debug('exception --->'+e);
        }
      }
    }

   global void finish(Database.BatchableContext BC){
   }
}