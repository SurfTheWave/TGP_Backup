/*@Description:: This is a global batch class which is used to insert records
* 
*/
global class SRATRecTypeL1L2Update  implements Database.Batchable<sObject>,Database.Stateful{

    global Set<Id> sratIds=new set<Id>();
    global String level;
    global String query;
    global RecordType sratLevel1RecordType;
    global RecordType sratLevel1RecordTypeFST;
    global RecordType sratLevel2RecordType;
    global RecordType sratLevel2RecordTypeFST;
    
    /*@Description:: this method accepts the parameter sent from apex class
     * and returns the records 
     */
    global SRATRecTypeL1L2Update(Set<Id> srats, String levelData ){
        sratIds = srats;
        level = levelData; 
        if(level.equalsIgnoreCase(UtillContstant_Novasuite.LEVEL1)){

            sratLevel1RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL1  
                                    and DeveloperName = :UtilCOnstants.SRAT_LEVEL1_NOT_FST LIMIT 1];
            sratLevel1RecordTypeFST = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL1  
                                       and DeveloperName = :UtilCOnstants.SRAT_LEVEL1_FST LIMIT 1];
            query = 'Select Id,Name,SRAT_Tracker__c, SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c WHERE SRAT_Tracker__c IN: sratIds ORDER BY SRAT_Level_1_Tracking_Type__c';

        }
        
        else if(level.equalsIgnoreCase(UtillContstant_Novasuite.LEVEL2)){
                sratLevel2RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL2  
                                        and DeveloperName = :UtilCOnstants.SRAT_LEVL2_READ_ONLY LIMIT 1];
                query = 'Select Id,Name,SRAT_Additional_Tracking_Level_1__c, SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c FROM SRAT_Additional_Tracking_Level_2__c WHERE  SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c IN: sratIds'; 
        }
        else if(level.equalsIgnoreCase(UtillContstant_Novasuite.LEVEL_2FST)){
                 sratLevel2RecordTypeFST = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL2_FST_OBJ  
                                            and DeveloperName = :UtilCOnstants.SRAT_LEVL2_FST_OBJ_READ_ONLY LIMIT 1];
                query = 'Select Id,Name,Deal_SRAT_Additional_Tracking_Level_1__c, Deal_SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c FROM SRAT_Additional_Tracking_Level_2_FST__c WHERE Deal_SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c IN :sratIds';
        } 
    }
    
    /*@Description:: this method executes the query
     * and returns the records 
     */
     global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    /*@Description:: this method is used to 
     * exceute the rows returned from query
     */
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
     
         if(null <> sobjectList && level.equalsIgnoreCase(UtillContstant_Novasuite.LEVEL1)){
            for(sObject sobj: sobjectList){
                        if(sobj.get(UtillContstant_Novasuite.SRAT_LEVEL1) == UtilConstants.FACTRY_SPEC_TECH){
                            sobj.put(UtillContstant_Novasuite.RECORD_TYPE,sratLevel1RecordTypeFST.Id );
                        }
                        else{
                            sobj.put(UtillContstant_Novasuite.RECORD_TYPE,sratLevel1RecordType.Id );
                        }
            }
            update sObjectList;
         }
        else if(sobjectList <> null && level.equalsIgnoreCase(UtillContstant_Novasuite.LEVEL2)){
            for(sObject sobj: sobjectList){
                sobj.put(UtillContstant_Novasuite.RECORD_TYPE,sratLevel2RecordType.Id );
            }
            update sObjectList;
        }
        
        else if(sobjectList <> null && level.equalsIgnoreCase(UtillContstant_Novasuite.LEVEL_2FST)){
            for(sObject sobj: sobjectList){
                sobj.put(UtillContstant_Novasuite.RECORD_TYPE,sratLevel2RecordTypeFST.Id );
            }
            update sObjectList;
        }
        
    }

     global void finish(Database.BatchableContext bc){
         if(level.equalsIgnoreCase(UtillContstant_Novasuite.LEVEL1)){
             String SratLevel = UtillContstant_Novasuite.LEVEL2;
             Id Level2batchId = database.executeBatch(new SRATRecTypeL1L2Update (sratIds, sratLevel));
         }
         else if(level.equalsIgnoreCase(UtillContstant_Novasuite.LEVEL2)){
             String sratLevel = UtillContstant_Novasuite.LEVEL_2FST;
             Id Level2batchId = database.executeBatch(new SRATRecTypeL1L2Update (sratIds, sratLevel));
         }
     }
}