public without sharing class UTIL_OpportunityTeamDataManager {
  
  public void insertOpportuintyTeamRecords(List<Opportunity_TGP__c> scope) {
      Map<String, Id> RoleMasterMap = new Map<String, Id>();
      Opportunity_Team__c oppTeamRecord;
      List<Opportunity_Team__c> oppTeamRecordList = new List<Opportunity_Team__c>();
      
      for(Opportunity_Role_master__c roleMaster : [Select Id, Name from Opportunity_Role_master__c ]) {
          RoleMasterMap.put(roleMaster.Name, roleMaster.Id);
      } 
      
      for(Opportunity_TGP__c oppRecord : scope) {
          if(oppRecord.Analytics_Functional_Architect__c != null) {
              Id roleMasterID = RoleMasterMap.get('Analytics Functional Architect');
              if(roleMasterID != null) {
                  oppTeamRecord =  new Opportunity_Team__c(); 
                  oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                  oppTeamRecord.Roles__c = roleMasterID;
                  oppTeamRecord.Opportunity_Team_Member__c = oppRecord.Analytics_Functional_Architect__c;
                  oppTeamRecordList.add(oppTeamRecord); 
              }
          }
          if(oppRecord.Analytics_Solution_Lead__c != null) {
              Id roleMasterID = RoleMasterMap.get('Analytics Solution Lead');
              if(roleMasterID != null) {
                  oppTeamRecord =  new Opportunity_Team__c(); 
                  oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                  oppTeamRecord.Roles__c = roleMasterID;
                  oppTeamRecord.Opportunity_Team_Member__c = oppRecord.Analytics_Solution_Lead__c;
                  oppTeamRecordList.add(oppTeamRecord); 
              }
          }
          if(oppRecord.BSS_Operation_New__c != null) {
              Id roleMasterID = RoleMasterMap.get('BST Operation');
              if(roleMasterID != null) {
                  oppTeamRecord =  new Opportunity_Team__c(); 
                  oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                  oppTeamRecord.Roles__c = roleMasterID;
                  oppTeamRecord.Opportunity_Team_Member__c = oppRecord.BSS_Operation_New__c;
                  oppTeamRecordList.add(oppTeamRecord); 
              }
          }
          if(oppRecord.Complex_Cost_Architect_New__c != null) {
              Id roleMasterID = RoleMasterMap.get('Complex Cost Architect');
              if(roleMasterID != null) {
                  oppTeamRecord =  new Opportunity_Team__c(); 
                  oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                  oppTeamRecord.Roles__c = roleMasterID;
                  oppTeamRecord.Opportunity_Team_Member__c = oppRecord.Complex_Cost_Architect_New__c ;
                  oppTeamRecordList.add(oppTeamRecord); 
              }
          }
          if(oppRecord.Enterprise_Solution_Architect_New__c != null) {
              // Id roleMasterID = RoleMasterMap.get('Complex Cost Architect');
              //if(roleMasterID != null) {
              oppTeamRecord =  new Opportunity_Team__c(); 
              oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
              // oppTeamRecord.Roles__c = roleMasterID;
              oppTeamRecord.Opportunity_Team_Member__c = oppRecord.Enterprise_Solution_Architect_New__c ;
              oppTeamRecordList.add(oppTeamRecord); 
          }
          if(oppRecord.PrimeSDOLeadName__c != null) {
              Id roleMasterID = RoleMasterMap.get('Prime SDO Lead');
              if(roleMasterID != null) {
                  oppTeamRecord =  new Opportunity_Team__c(); 
                  oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                  oppTeamRecord.Roles__c = roleMasterID;
                  oppTeamRecord.Opportunity_Team_Member__c = oppRecord.PrimeSDOLeadName__c;
                  oppTeamRecordList.add(oppTeamRecord); 
              }
          }
          if(oppRecord.SD_Governance_Lead__c != null) {
              Id roleMasterID = RoleMasterMap.get('SD Governance Lead/Coach');
              if(roleMasterID != null) {
                  oppTeamRecord =  new Opportunity_Team__c(); 
                  oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                  oppTeamRecord.Roles__c = roleMasterID;
                  oppTeamRecord.Opportunity_Team_Member__c = oppRecord.SD_Governance_Lead__c;
                  oppTeamRecordList.add(oppTeamRecord); 
              }
          }
          
          for(Opportunity_Offering__c offferingRecord : [SELECT Offering_Master__c, Offering_Solution_Lead_Secondary_New__c, Functional_Architect_Mobilization_New__c, Technical_Architect_New__c, Solution_Lead_New__c, Solution_Specialist_New__c,
                                                           Id FROM Opportunity_Offering__c where Opportunity_TGP__c =: scope])        
          {
              if(offferingRecord.Functional_Architect_Mobilization_New__c != null) {
                  Id roleMasterID = RoleMasterMap.get('Mobilization Architect');
                  if(roleMasterID != null) {
                      oppTeamRecord =  new Opportunity_Team__c(); 
                      oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                      oppTeamRecord.Roles__c = roleMasterID;
                      oppTeamRecord.Offering__c = offferingRecord.Offering_Master__c; 
                      oppTeamRecord.Opportunity_Team_Member__c = offferingRecord.Functional_Architect_Mobilization_New__c;
                      oppTeamRecordList.add(oppTeamRecord); 
                  } 
              }
              if(offferingRecord.Solution_Lead_New__c != null) {
                  Id roleMasterID = RoleMasterMap.get('Solution Architect - BPO');
                  if(roleMasterID != null) {
                      oppTeamRecord =  new Opportunity_Team__c(); 
                      oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                      oppTeamRecord.Roles__c = roleMasterID;
                      oppTeamRecord.Offering__c = offferingRecord.Offering_Master__c; 
                      oppTeamRecord.Opportunity_Team_Member__c = offferingRecord.Solution_Lead_New__c ;
                      oppTeamRecordList.add(oppTeamRecord); 
                  } 
              }
              if(offferingRecord.Offering_Solution_Lead_Secondary_New__c != null) {
                  Id roleMasterID = RoleMasterMap.get('Solution Architect – BPO');
                  if(roleMasterID != null) {
                      oppTeamRecord =  new Opportunity_Team__c(); 
                      oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                      oppTeamRecord.Roles__c = roleMasterID;
                      oppTeamRecord.Offering__c = offferingRecord.Offering_Master__c; 
                      oppTeamRecord.Opportunity_Team_Member__c = offferingRecord.Offering_Solution_Lead_Secondary_New__c ;
                      oppTeamRecordList.add(oppTeamRecord); 
                  } 
              }
              if(offferingRecord.Solution_Specialist_New__c != null) {
                  Id roleMasterID = RoleMasterMap.get('Solution Specialist');
                  if(roleMasterID != null) {
                      oppTeamRecord =  new Opportunity_Team__c(); 
                      oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                      oppTeamRecord.Roles__c = roleMasterID;
                      oppTeamRecord.Offering__c = offferingRecord.Offering_Master__c; 
                      oppTeamRecord.Opportunity_Team_Member__c = offferingRecord.Solution_Specialist_New__c;
                      oppTeamRecordList.add(oppTeamRecord); 
                  } 
              }
              if(offferingRecord.Technical_Architect_New__c != null) {
                  Id roleMasterID = RoleMasterMap.get('Technical Architect');
                  if(roleMasterID != null) {
                      oppTeamRecord =  new Opportunity_Team__c(); 
                      oppTeamRecord.BPO_Opportunity__c = oppRecord.Id; 
                      oppTeamRecord.Roles__c = roleMasterID;
                      oppTeamRecord.Offering__c = offferingRecord.Offering_Master__c; 
                      oppTeamRecord.Opportunity_Team_Member__c = offferingRecord.Technical_Architect_New__c;
                      oppTeamRecordList.add(oppTeamRecord); 
                  } 
              }          
          }
      }
      insert oppTeamRecordList; 
  }  
}