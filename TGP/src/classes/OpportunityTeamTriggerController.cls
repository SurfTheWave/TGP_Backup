/*
Author : Harshit Shah
Story :  
Description :Controller for all the trigger operations on opportunity team.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
public without sharing class OpportunityTeamTriggerController {

    public static String SEPERATOR = ';';
    /*
    Method Name: insertUtilizationRecords
    Parameter: List<Opportunity_Team__c>, DateTime mondayDate2
    Return Type: Void
    Description: Inserting the utilization Records
    */
    
    public static void insertUtilizationRecords(List<Opportunity_Team__c> oppNewList) {
        system.debug('the LIst To insert' +oppNewList);
        String keyField;
        String exsistingKeyfield; 
        set<String> keyFieldSet = new set<String>();
        set<String> exsistingKeyfieldSet = new set<String>();
        set<Id> userMasterIdsSet = new set<Id>();
        set<Id> opportunityIdsSet = new set<Id>();
        List<Utilization__c> utilizationListToInsert = new List<Utilization__c>();
        Utilization__c utilizationObject;
                
        for(Opportunity_Team__c oppTeamRecord : oppNewList) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Bpo_Opportunity__c != null) {
                keyField = oppTeamRecord.BPO_Opportunity__c + SEPERATOR + oppTeamRecord.Opportunity_Team_Member__c;
                keyFieldSet.add(keyField);
                userMasterIdsSet.add(oppTeamRecord.Opportunity_Team_Member__c);
                opportunityIdsSet.add(oppTeamRecord.BPO_Opportunity__c);
                
            }
        }
        
        for(Utilization__c utilizationRecord : [select BPO_Opportunity__c, User_Master__c from Utilization__c where (BPO_Opportunity__c IN:opportunityIdsSet OR User_Master__c IN:userMasterIdsSet) limit 40000]) {
           if(utilizationRecord.User_Master__c != null && utilizationRecord.BPO_Opportunity__c != null) {
               exsistingKeyfield = utilizationRecord.BPO_Opportunity__c + SEPERATOR + utilizationRecord.User_Master__c;
               exsistingKeyfieldSet.add(exsistingKeyfield);
           }
        }
        system.debug('keyFieldSet>>>>>>'+keyFieldSet);
        system.debug('exsistingkeyFieldSet>>>>>>'+exsistingKeyfieldSet);
        for(String key : keyFieldSet) {
           if(!exsistingKeyfieldSet.contains(key)) {
               String[] splittedIds = new String[]{};
               splittedIds = key.split(SEPERATOR);
               utilizationObject = new Utilization__c(); 
               utilizationObject.Bpo_Opportunity__c = splittedIds[0];
               utilizationObject.User_Master__c = splittedIds[1];
               utilizationObject.Current_week__c = 0;
               utilizationObject.Current_week_1__c = 0;
               utilizationObject.Current_week_2__c = 0;
               utilizationObject.Current_week_3__c = 0;
               utilizationObject.Current_week_4__c = 0; 
               system.debug('Added Record'+ Key + '>>'+splittedIds[0] + '>>'+ splittedIds[1]);
               utilizationListToInsert.add(utilizationObject);
           }
        } 
        system.debug('Records Inserted' + utilizationListToInsert);          
        database.insert(utilizationListToInsert);  
    }
    
    
    /*
    Method Name: updateUtilizationRecords
    Parameter: List<Opportunity_Team__c>, DateTime mondayDate2
    Return Type: Void
    Description: Inserting the utilization Records
    */
    
    public static void updateUtilizationRecords(List<Opportunity_Team__c> oppNewList, List<OPportunity_Team__c> oppOldList) {
        String keyField;
        String exsistingKeyfield; 
        String oldKeyField; 
        String KeyFieldForTeamRecord;
        set<String> keyFieldSet = new set<String>();
        set<String> exsistingKeyfieldSet = new set<String>();
        set<String> oldKeyFieldSet = new set<String>();
        set<String> KeyFieldSetForAllTeamRecords = new set<String>();
        set<String> keyFieldsToVerify = new set<String>();
        set<Id> userMasterIdsSet = new set<Id>();
        set<Id> opportunityIdsSet = new set<Id>();
        set<Id> oppIdSetToVerify = new set<Id>();
        set<Id> oppIdSetToVerifyforDeletion = new set<Id>();
        set<String> keyOfRecordsToDelete = new set<String>();
        List<Utilization__c> utilizationListToInsert = new List<Utilization__c>();
        List<Utilization__c> utilizationListToDelete = new List<Utilization__c>();
        Utilization__c utilizationObject;
        Map<String, Utilization__c> keyToUtilizationMapped = new Map<String, Utilization__c>();
               
        for(Opportunity_Team__c oppTeamRecord : oppNewList) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Bpo_Opportunity__c != null) {
                keyField = oppTeamRecord.BPO_Opportunity__c + SEPERATOR  + oppTeamRecord.Opportunity_Team_Member__c;
                keyFieldSet.add(keyField);
                userMasterIdsSet.add(oppTeamRecord.Opportunity_Team_Member__c);
                opportunityIdsSet.add(oppTeamRecord.BPO_Opportunity__c);
                
            }
        }
        
        for(Utilization__c utilizationRecord : [select BPO_Opportunity__c, User_Master__c from Utilization__c where (BPO_Opportunity__c IN:opportunityIdsSet OR User_Master__c IN:userMasterIdsSet)  limit 40000]) {
           if(utilizationRecord.User_Master__c != null && utilizationRecord.BPO_Opportunity__c != null) {
               exsistingKeyfield = utilizationRecord.BPO_Opportunity__c + SEPERATOR  + utilizationRecord.User_Master__c;
               exsistingKeyfieldSet.add(exsistingKeyfield);
           }
        }

        for(String key : keyFieldSet) {
           if(!exsistingKeyfieldSet.contains(key)) {
               String[] splittedIds = new String[]{};
               splittedIds = key.split(SEPERATOR );
               utilizationObject = new Utilization__c(); 
               utilizationObject.Bpo_Opportunity__c = splittedIds[0];
               utilizationObject.User_Master__c = splittedIds[1];
               utilizationObject.Current_week__c = 0;
               utilizationObject.Current_week_1__c = 0;
               utilizationObject.Current_week_2__c = 0;
               utilizationObject.Current_week_3__c = 0;
               utilizationObject.Current_week_4__c = 0; 
               utilizationListToInsert.add(utilizationObject);
           }
        }   
        
        for(Opportunity_Team__c oppTeamOldRecord : oppOldList) {
            if(oppTeamOldRecord.Opportunity_Team_Member__c != null && oppTeamOldRecord.Bpo_Opportunity__c != null) {
                oldKeyField = oppTeamOldRecord.BPO_Opportunity__c + SEPERATOR  + oppTeamOldRecord.Opportunity_Team_Member__c;
                oldKeyFieldSet.add(oldKeyField);                
            }
        }
        
        for(String key : oldKeyFieldSet) {
            if(!keyFieldSet.contains(key)) {
                keyFieldsToVerify.add(key);
                String[] oppId = key.split(SEPERATOR );
                oppIdSetToVerify.add(oppId[0]);
            }
        }
        
        for(Opportunity_Team__c oppTeamRecord : [select BPO_Opportunity__c,Opportunity_Team_Member__c from Opportunity_Team__c  where BPO_Opportunity__c IN :oppIdSetToVerify  limit 40000]) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Bpo_Opportunity__c != null) {
                KeyFieldForTeamRecord = oppTeamRecord.BPO_Opportunity__c + SEPERATOR  + oppTeamRecord.Opportunity_Team_Member__c;
                KeyFieldSetForAllTeamRecords.add(KeyFieldForTeamRecord);                
            }            
        }
        
        for(String key : keyFieldsToVerify) {
            if(!KeyFieldSetForAllTeamRecords.contains(key)) {
                keyOfRecordsToDelete.add(key);
                String[] oppId = key.split(SEPERATOR );
                oppIdSetToVerifyforDeletion.add(oppId[0]);
            }
        }
        
        
        for(Utilization__c utilizationRecordToCheck : [select Id, BPO_Opportunity__c, User_Master__c from Utilization__c where BPO_Opportunity__c IN:oppIdSetToVerifyforDeletion  limit 40000]) {
            if(utilizationRecordToCheck.BPO_Opportunity__c != null && utilizationRecordToCheck.User_Master__c != null) {
                String mapKey = utilizationRecordToCheck.BPO_Opportunity__c + SEPERATOR  + utilizationRecordToCheck.User_Master__c;   
                keyToUtilizationMapped.put(mapKey,utilizationRecordToCheck);
            }            
        }
        
        for(String keyToDelete :keyOfRecordsToDelete) {
            Utilization__c utilizationRecordToDelete = keyToUtilizationMapped.get(keyToDelete);
            if(utilizationRecordToDelete != null) {
                utilizationListToDelete.add(utilizationRecordToDelete);
            }
        }
         system.debug('inside Update Method Trigger');                   
        database.insert(utilizationListToInsert);
        database.delete(utilizationListToDelete);  
    }
    
    
    /*
    Method Name: deleteUtilizationRecords
    Parameter: List<Opportunity_Team__c>, DateTime mondayDate2
    Return Type: Void
    Description: Inserting the utilization Records
    */
    
    public static void deleteUtilizationRecords(List<Opportunity_Team__c> oppOldList) {
        String oldKeyField ; 
        String KeyFieldForTeamRecord;
        set<String> oldKeyFieldSet = new set<String>();
        set<String> KeyFieldSetForAllTeamRecords = new set<String>();
        set<Id> uniqueOpportunities = new set<Id>();
        set<Id> oppIdSetToVerify = new set<Id>();
        set<Id> oppIdSetToVerifyforDeletion = new set<Id>();
        set<String> keyOfRecordsToDelete = new set<String>();
        List<Utilization__c> utilizationListToDelete = new List<Utilization__c>();
        Utilization__c utilizationObject;
        Map<String, Utilization__c> keyToUtilizationMapped = new Map<String, Utilization__c>();
        
        for(Opportunity_Team__c oppTeamOldRecord : oppOldList) {
            if(oppTeamOldRecord.Opportunity_Team_Member__c != null && oppTeamOldRecord.Bpo_Opportunity__c != null) {
                oldKeyField = oppTeamOldRecord.BPO_Opportunity__c + SEPERATOR  + oppTeamOldRecord.Opportunity_Team_Member__c;
                oldKeyFieldSet.add(oldKeyField);
                uniqueOpportunities.add(oppTeamOldRecord.BPO_Opportunity__c);                
            }
        }
        
        for(Opportunity_Team__c oppTeamRecord : [select BPO_Opportunity__c,Opportunity_Team_Member__c from Opportunity_Team__c  where BPO_Opportunity__c IN :uniqueOpportunities  limit 40000]) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Bpo_Opportunity__c != null) {
                KeyFieldForTeamRecord = oppTeamRecord.BPO_Opportunity__c + SEPERATOR  + oppTeamRecord.Opportunity_Team_Member__c;
                KeyFieldSetForAllTeamRecords.add(KeyFieldForTeamRecord);                
            }            
        }
        
        for(String key : oldKeyFieldSet) {
            if(!KeyFieldSetForAllTeamRecords.contains(key)) {
                keyOfRecordsToDelete.add(key);
                String[] oppId = key.split(SEPERATOR );
                oppIdSetToVerifyforDeletion.add(oppId[0]);
            }
        }
        
        for(Utilization__c utilizationRecordToCheck : [select Id, BPO_Opportunity__c, User_Master__c from Utilization__c where BPO_Opportunity__c IN:oppIdSetToVerifyforDeletion  limit 40000]) {
            if(utilizationRecordToCheck.BPO_Opportunity__c != null && utilizationRecordToCheck.User_Master__c != null) {
                String mapKey = utilizationRecordToCheck.BPO_Opportunity__c + SEPERATOR  + utilizationRecordToCheck.User_Master__c;   
                keyToUtilizationMapped.put(mapKey,utilizationRecordToCheck);
            }            
        }
        
        for(String keyToDelete :keyOfRecordsToDelete) {
            Utilization__c utilizationRecordToDelete = keyToUtilizationMapped.get(keyToDelete);
            if(utilizationRecordToDelete != null) {
                utilizationListToDelete.add(utilizationRecordToDelete);
            }
        }
        
        if(utilizationListToDelete.size()>0){                    
           database.delete(utilizationListToDelete);
        }  
        
    }
    
    public static void insertSolUserAssignment(List<Opportunity_Team__c> oppNewListTeam) {
        
        List<ID> bpoOpptyTeamIds = new List<ID>();
        for(Opportunity_Team__c oppty : oppNewListTeam) {
        bpoOpptyTeamIds.add(oppty.BPO_Opportunity__c);
        }
        
        String userId=UserInfo.getUserId();
        List<Solution_User_Assignment__c> solUserAssignList = new List<Solution_User_Assignment__c>();
        List<Solution_User_Assignment__c> solUserAssignList2 = new List<Solution_User_Assignment__c>();
        List<Solution_User_Assignment__c> solUserAssignList1=[Select Date_Needed_by__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.SFDC_User__c,Status__c, User__c,Requester_Name__c, SAP_OM_ID__c,Date_Assigned__c ,Date_Requested__c , ClientName__c, Id, BPO_Opportunity__c,Role__c,Offering_Master__c  From Solution_User_Assignment__c where BPO_Opportunity__c In : bpoOpptyTeamIds limit 5000];
        
        for(Opportunity_Team__c tempOppTeam : [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c where  BPO_Opportunity__c In : bpoOpptyTeamIds limit 5000]) {
             for(Solution_User_Assignment__c solUSerList: solUserAssignList1) {
                 if(tempOppTeam.BPO_Opportunity__c == solUSerList.BPO_Opportunity__c && tempOppTeam.Offering__c == solUSerList.Offering_Master__c) {
                 if((tempOppTeam.Offering__c == null && tempOppTeam.Roles__r.name == 'Complex Cost Architect' && solUSerList.Resource_Assigned_User_New__c == null && solUSerList.Role__c == 'Complex Cost Architect' && tempOppTeam.Opportunity_Team_Member__r.SFDC_User__c != null)
                     || (tempOppTeam.Offering__c != null && tempOppTeam.Roles__r.name == 'Mobilization Architect' && solUSerList.Resource_Assigned_User_New__c == null && solUSerList.Role__c == 'Mobilization Architect' && tempOppTeam.Opportunity_Team_Member__r.SFDC_User__c != null)
                     || (tempOppTeam.Offering__c != null && tempOppTeam.Roles__r.name == 'Solution Specialist' && solUSerList.Resource_Assigned_User_New__c == null && solUSerList.Role__c == 'Solution Specialist' && tempOppTeam.Opportunity_Team_Member__r.SFDC_User__c != null)
                     || (tempOppTeam.Offering__c != null && tempOppTeam.Roles__r.name == 'Technical Architect' && solUSerList.Resource_Assigned_User_New__c == null && solUSerList.Role__c == 'Technical Architect' && tempOppTeam.Opportunity_Team_Member__r.SFDC_User__c != null)) {
                     solUSerList.Resource_Assigned_User_New__c = tempOppTeam.Opportunity_Team_Member__c;
                     solUSerList.Status__c = 'Assigned';
                     solUSerList.Requester_Name__c = userId;
                     solUSerList.Date_Assigned__c = System.Today();
                     solUSerList.Date_Requested__c = System.Today();
                     solUSerList.Date_Needed_by__c = System.Today();
                     
                     solUserAssignList.add(solUSerList);
                  }
                  } 
             }
        }
         Database.update(solUserAssignList);
               
         for(Opportunity_Team__c tempOppTeam : [Select BPO_Opportunity__r.Client_Name__r.name,BPO_Opportunity__r.SAP_OM_Opportunity__r.name,BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c where  Id In : oppNewListTeam limit 49999]) {
             if((tempOppTeam.Offering__c == null && (tempOppTeam.Roles__r.name == 'Mobilization Architect' || tempOppTeam.Roles__r.name == 'Technical Architect' || tempOppTeam.Roles__r.name == 'Solution Specialist'))
                 || (tempOppTeam.Offering__c != null && tempOppTeam.Roles__r.name == 'Complex Cost Architect')) {
                 Solution_User_Assignment__c tempsol = new Solution_User_Assignment__c();
                 tempsol.BPO_Opportunity__c = tempOppTeam.BPO_Opportunity__c;
                 tempsol.ClientName__c = tempOppTeam.BPO_Opportunity__r.Client_Name__r.name; 
                 tempsol.Role__c = tempOppTeam.Roles__r.name;
                 if(tempOppTeam.Offering__c != null /*&& tempOppTeam.Offering__c !=UTIL_Constants.EMPTY_STRING*/) {
                     tempsol.Offering_Master__c =  tempOppTeam.Offering__c;
                 }
                 if(tempOppTeam.BPO_Opportunity__r.SAP_OM_Opportunity__r.name != null && tempOppTeam.BPO_Opportunity__r.SAP_OM_Opportunity__r.name !=UTIL_Constants.EMPTY_STRING) {
                     tempsol.SAP_OM_ID__c =tempOppTeam.BPO_Opportunity__r.SAP_OM_Opportunity__r.name;
                 }
                 tempsol.Resource_Assigned_User_New__c = tempOppTeam.Opportunity_Team_Member__c;
                 tempsol.Status__c = 'Assigned';
                 tempsol.Requester_Name__c = userId;
                 tempsol.Date_Assigned__c = System.Today();
                 tempsol.Date_Requested__c = System.Today();
                 tempsol.Date_Needed_by__c = System.Today();
                
                 solUserAssignList2.add(tempSol);
             }
         }
         
         Database.insert(solUserAssignList2);
         
    }
    
    public static void updateSolUserAssignment(List<Opportunity_Team__c> oppNewListTeam, List<Opportunity_Team__c> oppOldListTeam) {
        
        List<ID> bpoOpptyTeamIds = new List<ID>();
        Set<ID> oppTeamMemberIds = new Set<ID>();
        Set<ID> roleIds = new Set<ID>();
        Set<ID> offIds = new Set<ID>();
        for(Opportunity_Team__c oppty : oppNewListTeam) {
            bpoOpptyTeamIds.add(oppty.BPO_Opportunity__c);
        }
        
        Map<Id, String> oppRoleMasterMappedToId = new Map<Id, String>();
            for(Opportunity_Role_master__c oppMaster: [select Id, Name from Opportunity_Role_master__c limit 200]) {
                oppRoleMasterMappedToId.put(oppMaster.Id, oppMaster.Name);
            }
        
        List<Opportunity_Team__c> listUpdatedOppTeam = new List<Opportunity_Team__c>();
        for(Opportunity_Team__c temp : oppNewListTeam) {
            for(Opportunity_Team__c temp1 : oppOldListTeam) {
                if(temp.Offering__c == temp1.Offering__c && temp.Roles__c == temp1.Roles__c
                   && temp.Opportunity_Team_Member__c != temp1.Opportunity_Team_Member__c) {
                       listUpdatedOppTeam.add(temp);
                   }    
            }
        }
       
        List<Opportunity_Team__c> listOSL = [SELECT id,Roles__c,Opportunity_Team_Member__c,BPO_Opportunity__r.Enterprise_Solution_Architect_New__c from Opportunity_Team__c where BPO_Opportunity__c IN : bpoOpptyTeamIds AND Roles__r.Name =: 'Lead Solution Architect – BPO'];
        
        if(listOSL.size() == 1) {
            if(ListOSL[0].Opportunity_Team_Member__c != ListOSL[0].BPO_Opportunity__r.Enterprise_Solution_Architect_New__c){
                ListOSL[0].Opportunity_Team_Member__c = ListOSL[0].BPO_Opportunity__r.Enterprise_Solution_Architect_New__c;
                
                Database.update(ListOSL);
            }
       }
        
        for(Opportunity_Team__c temp : listUpdatedOppTeam) {
            oppTeamMemberIds.add(temp.Opportunity_Team_Member__c);
            roleIds.add(temp.Roles__c);
            offIds.add(temp.Offering__c);
        }
        system.debug('++++'+listUpdatedOppTeam);
        String userId=UserInfo.getUserId();
        List<Solution_User_Assignment__c> solUserAssignList = new List<Solution_User_Assignment__c>();
        List<Solution_User_Assignment__c> solUserAssignList1=[Select Date_Needed_by__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.SFDC_User__c,Status__c, User__c,Requester_Name__c, SAP_OM_ID__c,Date_Assigned__c ,Date_Requested__c , ClientName__c, Id, BPO_Opportunity__c,Role__c,Offering_Master__c From Solution_User_Assignment__c where BPO_Opportunity__c In : bpoOpptyTeamIds limit 5000];
        
        for(Opportunity_Team__c tempOppTeam : listUpdatedOppTeam) {
             for(Solution_User_Assignment__c solUSerList: solUserAssignList1) {
                 String temp = oppRoleMasterMappedToId.get(tempOppTeam.Roles__c);
                 system.debug('++++'+temp);
                 if(tempOppTeam.BPO_Opportunity__c == solUSerList.BPO_Opportunity__c
                    && tempOppTeam.Offering__c == solUSerList.Offering_Master__c
                    && temp == solUSerList.Role__c ||(tempOppTeam.Offering__c == null && temp == null)) {
                    system.debug('++++1');                    
                     solUSerList.Resource_Assigned_User_New__c = tempOppTeam.Opportunity_Team_Member__c;
                    
                     solUserAssignList.add(solUSerList);
                  }
             } 
        }
        system.debug('++++'+solUserAssignList);
         Database.update(solUserAssignList);
         
         //List<Review_User_Master__c> listUserMaster = new List<Review_User_Master__c>();
         //List<Opportunity_Role_master__c> listRoleMaster = new List<Opportunity_Role_master__c>();
         //List<Offerings_Master__c> listOffMaster = new List<Offerings_Master__c>();
         Map<Id,String> mapOffMaster = new Map<Id,String>();
         Map<Id,String> mapRoleMaster = new Map<Id,String>();
         Map<Id,Id> mapUserMaster = new Map<Id,Id>();
         //listUserMaster  = [select SFDC_User__c from Review_User_Master__c where Id IN:oppTeamMemberIds];
         for(Review_User_Master__c userMaster : [select SFDC_User__c from Review_User_Master__c where Id IN:oppTeamMemberIds]) {
             mapUserMaster.put(userMaster.Id,userMaster.SFDC_User__c);
         }
         for(Opportunity_Role_master__c roleMaster : [SELECT Id, Name FROM Opportunity_Role_master__c where Id IN :roleIds]) {
             mapRoleMaster.put(roleMaster.Id,roleMaster.Name);
         }
         //listOffMaster = [SELECT Id, Name FROM Offerings_Master__c where Id IN :offIds];
         for(Offerings_Master__c offmas : [SELECT Id, Name FROM Offerings_Master__c where Id IN :offIds]) {
             mapOffMaster.put(offmas.Id,offmas.name);
         } 
      
         if(listUpdatedOppTeam.size() > 0) {
             for(Integer i =0; i<listUpdatedOppTeam.size();i++) {
                 String oppId = listUpdatedOppTeam[i].BPO_Opportunity__c;
                 String roleName;
                 String offName;
                 if(mapRoleMaster.size() == 0) {
                     roleName = '';
                 }
                 else {
                     roleName = mapRoleMaster.get(listUpdatedOppTeam[i].Roles__c);
                 }
                 String toAddressId = mapUserMaster.get(listUpdatedOppTeam[i].Opportunity_Team_Member__c);
                 if(mapOffMaster.size() ==0 || listUpdatedOppTeam[i].Offering__c == null) {
                     offName = null;
                 }
                 else if(mapOffMaster.size() > 0) {
                     offName = mapOffMaster.get(listUpdatedOppTeam[i].Offering__c);
                 }
                 Opp_Team_Controller.sendEmailAlertToAssignedUser(oppId, roleName, toAddressId, offName);  
             }
        }        
    }            
}