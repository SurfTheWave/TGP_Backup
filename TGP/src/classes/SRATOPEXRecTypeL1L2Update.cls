global class SRATOPEXRecTypeL1L2Update  implements Database.Batchable<sObject>,Database.Stateful{

        global Set<Id> sratIds;
        global String level;
        global String query;
        global RecordType sratLevel1RecordType;
        global RecordType sratLevel1RecordTypeFST;
        global RecordType sratLevel2RecordType;
        global RecordType sratLevel2RecordTypeFST;
        global RecordType OpexLevel1RecordType;
        global RecordType OpexLevel1RecordTypeMOMC;
        global RecordType OpexLevel2RecordType;
        global RecordType OpexLevel2RecordTypeMOMC;
        global String objectName; 
        global Set<Id> planIds;
        global String MOMC = 'Mobilization and Operational Maturity Criteria';
        global SRATOPEXRecTypeL1L2Update(Set<Id> planIdList, String levelData, String ObjectString ){
            planIds = planIdList;
            level = levelData; 
            objectName = ObjectString;
            System.debug('Query+++ ' + query);
            System.debug('Obje Name ' + objectName);
            if(ObjectName.equalsIgnoreCase('SRAT')){
                if(level.equalsIgnoreCase('Level1')){
                    sratLevel1RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL1  and DeveloperName = :UtilCOnstants.SRAT_LEVEL1_NOT_FST LIMIT 1];
                    sratLevel1RecordTypeFST = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL1  and DeveloperName = :UtilCOnstants.SRAT_LEVEL1_FST LIMIT 1];
                        query = 'Select Id,Name,SRAT_Tracker__c, SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c WHERE SRAT_Tracker__r.Mobilization_Plan__c IN: planIds AND (SRAT_Tracker__r.Checklist_Reviewed__c=TRUE OR  SRAT_Tracker__r.IsPlanActive__c=FALSE)  ORDER BY SRAT_Level_1_Tracking_Type__c';
                }
                
                else if(level.equalsIgnoreCase('Level2')){
                        sratLevel2RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL2  and DeveloperName = :UtilCOnstants.SRAT_LEVL2_READ_ONLY LIMIT 1];
                        query = 'Select Id,Name,SRAT_Additional_Tracking_Level_1__c, SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c FROM SRAT_Additional_Tracking_Level_2__c WHERE  SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Mobilization_Plan__c IN: planIds AND (SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Checklist_Reviewed__c=TRUE OR  SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.IsPlanActive__c=FALSE)'; 
                }
                else if(level.equalsIgnoreCase('Level2FST')){
                         sratLevel2RecordTypeFST = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.SRAT_LEVEL2_FST_OBJ  and DeveloperName = :UtilCOnstants.SRAT_LEVL2_FST_OBJ_READ_ONLY LIMIT 1];
                        query ='Select Id,Name,Deal_SRAT_Additional_Tracking_Level_1__c, Deal_SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c FROM SRAT_Additional_Tracking_Level_2_FST__c WHERE Deal_SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Mobilization_Plan__c IN :planIds AND (Deal_SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.Checklist_Reviewed__c=TRUE OR  Deal_SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__r.IsPlanActive__c=FALSE)';
                } 
            }
            
            else if(ObjectName.equalsIgnoreCase('OPEX')){
                if(level.equalsIgnoreCase('Level1')){
                    OpexLevel1RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.DEAL_OPEX_LEVEL1  and DeveloperName = :UtilCOnstants.OPES_LEVEL1_SUBMIT LIMIT 1];
                    OpexLevel1RecordTypeMOMC = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.DEAL_OPEX_LEVEL1  and DeveloperName = :UtilCOnstants.OPEX_LEVEL1_MOMC_READ_ONLY LIMIT 1];
                    query = 'Select Id,Name,OPEX_Tracker_del__c, OPEX_Level_1_Tracking_Type__c  from Deal_OPEX_Additional_Tracking_Level_1__c where OPEX_Tracker_del__r.Mobilization_Plan__c IN: planIds AND (OPEX_Tracker_del__r.Submit_Checklist__c=TRUE OR  OPEX_Tracker_del__r.IsPlanActive__c=FALSE) ORDER BY  OPEX_Level_1_Tracking_Type__c LIMIT 9999';
                }
                
                else if(level.equalsIgnoreCase('Level2')){
                    OpexLevel2RecordType = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.DEAL_OPEX  and DeveloperName = :UtilCOnstants.OPES_LEVEL_SUBMIT LIMIT 1];
                    query = 'Select Id,Name,Deal_OPEX_Additional_Tracking_Level_1__c,  Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Level_1_Tracking_Type__c  FROM Deal_OPEX_Additional_Tracking_Level_2__c WHERE Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Tracker_del__r.Mobilization_Plan__c IN: planIds AND (Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Tracker_del__r.Submit_Checklist__c=TRUE OR  Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Tracker_del__r.IsPlanActive__c=FALSE) LIMIT 9999';
                    
                }
                 else if(level.equalsIgnoreCase('Level2MOMC')){
                    OpexLevel2RecordTypeMOMC = [Select Id From RecordType  Where SobjectType = :UtilCOnstants.OPEX_LEVEL2_MOMC  and DeveloperName = :UtilCOnstants.OPEX_LEVEL2_MOMC_READ_ONLY LIMIT 1];
                    query = 'Select Id,Name,Deal_OPEX_Additional_Tracking_Level_1__c,  Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Level_1_Tracking_Type__c,Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Tracker_del__c  FROM Deal_OPEX_Additional_Tckn_Level_2_MOMC__c WHERE Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Tracker_del__r.Mobilization_Plan__c IN: planIds AND (Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Tracker_del__r.Submit_Checklist__c=TRUE OR  Deal_OPEX_Additional_Tracking_Level_1__r.OPEX_Tracker_del__r.IsPlanActive__c=FALSE) LIMIT 9999';
                    
                }
            
            }
        }    
        
         global Database.QueryLocator start(Database.BatchableContext bc){
             System.debug('Query  ++ ' + query);
            return Database.getQueryLocator(query);
        }
        
        global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
         
         if(objectName.equalsIgnoreCase('SRAT') && sobjectList <> null){
             if(level.equalsIgnoreCase('Level1')){
                for(sObject sobj: sobjectList){
                            if(sobj.get('SRAT_Level_1_Tracking_Type__c') == UtilConstants.FACTRY_SPEC_TECH){
                                sobj.put('RecordTypeId',sratLevel1RecordTypeFST.Id );
                            }
                            else{
                                sobj.put('RecordTypeId',sratLevel1RecordType.Id );
                            }
                }
                update sObjectList;
             }
            else if(level.equalsIgnoreCase('Level2')){
                for(sObject sobj: sobjectList){
                    sobj.put('RecordTypeId',sratLevel2RecordType.Id );
                }
                update sObjectList;
            }
            
            else if(level.equalsIgnoreCase('Level2FST')){
                for(sObject sobj: sobjectList){
                    sobj.put('RecordTypeId',sratLevel2RecordTypeFST.Id );
                }
                update sObjectList;
            }
            
            }
            
          else if(objectName.equalsIgnoreCase('OPEX') && sobjectList <> null){
              if(level.equalsIgnoreCase('Level1')){
                  for(sObject sobj: sobjectList){
                    if(sobj.get('OPEX_Level_1_Tracking_Type__c') == UtilConstants.MOB_OPERATE_CRITERIA) {
                        sobj.put('RecordTypeId', OpexLevel1RecordTypeMOMC.Id );
                    }
                    else{
                        sobj.put('RecordTypeId', OpexLevel1RecordType.Id );
                    }
                }
                update sObjectList;
              }
              
              else if(level.equalsIgnoreCase('Level2')){
                  for(sObject sobj: sobjectList){
                    sobj.put('RecordTypeId', OpexLevel2RecordType.Id);
                }
                update sObjectList;
              }
              else if(level.equalsIgnoreCase('Level2MOMC')){
                  for(sObject sobj: sobjectList){
                    sobj.put('RecordTypeId', OpexLevel2RecordTypeMOMC.Id);
                }
                update sObjectList;
              }
          } 
        }

         global void finish(Database.BatchableContext bc){
             if(objectName.equalsIgnoreCase('SRAT') && level.equalsIgnoreCase('Level1')){
                 String Obj = 'SRAT';
                 String SratLevel = 'Level2';
                 Id Level2batchId = database.executeBatch(new SRATOPEXRecTypeL1L2Update(planIds, sratLevel, obj));
             }
             else if(objectName.equalsIgnoreCase('SRAT') && level.equalsIgnoreCase('Level2')){
                 String Obj = 'SRAT';
                 String sratLevel = 'Level2FST';
                 Id Level2FSTbatchId = database.executeBatch(new SRATOPEXRecTypeL1L2Update(planIds, sratLevel, obj));
             }
             else if(objectName.equalsIgnoreCase('OPEX') && level.equalsIgnoreCase('Level1')){
                 String Obj = 'OPEX';
                 String opexLEvel = 'Level2';
                 Id Level2batchId = database.executeBatch(new SRATOPEXRecTypeL1L2Update(planIds, opexLevel , obj ));
             }
              else if(objectName.equalsIgnoreCase('OPEX') && level.equalsIgnoreCase('Level2')){
                 String Obj = 'OPEX';
                 String opexLEvel = 'Level2MOMC';
                 Id Level2MOMCbatchId = database.executeBatch(new SRATOPEXRecTypeL1L2Update(planIds, opexLevel , obj ));
             }
             
         }
    }