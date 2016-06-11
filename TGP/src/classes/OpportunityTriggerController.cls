/*
Author : Harshit Shah
Story :  
Description :Controller for all the trigger operations on opportunity.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
public with sharing class OpportunityTriggerController {
    
    private static final string CLASS_NAME = 'OpportunityTriggerController';
    private static final string TRIGGER_NAME = 'OperationsOnOpportunity';
    private static final string METHOD_INSERT = 'insertSolutionUserAssignment';
    private static final string METHOD_UPDATE = 'updateSolutionUserAssignment';
    private static final string METHOD_INSERT_EMAIL = 'emailToRegionAndDealRadarGroup';
    private static final string METHOD_UPDATE_EMAIL = 'emailToClientGeoArea';
    private static final string METHOD_BEFORE_UPDATE = 'storeOppClientGeoAreaPriorValue';
    private static final string METHOD_INSERT_OPPTEAM = 'insertOppTeam';
    
    /*
    Method Name: storeOppClientGeoAreaPriorValue
    Parameter: List<Opportunity_TGP__c>
    Return Type: Void
    Description: updating the prior value of client Geo Area.
    */
    public static void storeOppClientGeoAreaPriorValue (List<Opportunity_TGP__c> oppNewList) {
        try {
              Map<Id,String> clientGeoAreaMap = new Map<Id,String>();
              Map<Id,Id> clientGeoAreaIdMap = new Map<Id,Id>();
              Opportunity_TGP__c temp;
              Set<String> clientGeoAreaSet = new Set<String>();
              for(Opportunity_TGP__c oppNew : oppNewList)  {
                     temp = (Opportunity_TGP__c)trigger.oldMap.get(oppNew.id);
                     if(oppNew.Client_Geo_Area__c!= Null && oppNew.Client_Geo_Area__c!=temp.Client_Geo_Area__c){
                           clientGeoAreaSet.add(temp.Client_Geo_Area__c);
                           clientGeoAreaIdMap.put(oppNew.Id,temp.Client_Geo_Area__c);
                     }
              }
              if(!clientGeoAreaSet.isEmpty()) {
                  for(Client_Geo_Area_Master__c clientGeoAreaMaster : [Select Name from Client_Geo_Area_Master__c Where Id =: clientGeoAreaSet limit 5000]) {
                         clientGeoAreaMap.put(clientGeoAreaMaster.Id, clientGeoAreaMaster.Name);
                  }
              }
              for(Opportunity_TGP__c oppNew : oppNewList) {
                     if(clientGeoAreaIdMap.containsKey(oppNew.Id)) {
                           oppNew.Client_Geo_Area_Prior_Value__c = clientGeoAreaMap.get(clientGeoAreaIdMap.get(oppNew.Id));
                     }
              }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_BEFORE_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }      
    
    /*
    Method Name: emailToRegionAndDealRadarGroup
    Parameter: List<Opportunity_TGP__c>
    Return Type: Void
    Description: sending email to Region and Deal Radar Group on creation of opportunity, getting invoked from opportunity trigger.
    */  
    public void emailToRegionAndDealRadarGroup(List<Opportunity_TGP__c> opptyListPassed) {
        
        List<ID> bpoOpptyIds = new List<ID>();
        try {
            
            for(Opportunity_TGP__c oppty : opptyListPassed){
                bpoOpptyIds.add(oppty.id);
            }
            List<Opportunity_TGP__c> oppTGP = new List<Opportunity_TGP__c>();
            oppTGP =[Select id,Activity__c,Client_Geo_Unit__r.name,Client_Name__r.name,name,Client_Geo_Area__r.name,SAP_OM_Opportunity__r.name,Stage__c,
                     Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Operating_Group__r.name,Risk_Level__c,Service_Group__c
                     from Opportunity_TGP__c where id In : bpoOpptyIds limit 5000]; 
            for(integer i=0; i<opptyListPassed.size(); i++)
            {
                
                //Email to Region group and Deal Radar group when new Opprtunity is created.
                if((OppTGP[i].Client_Geo_Area__r.name== Util_Constants.APAC || OppTGP[i].Client_Geo_Area__r.name== Util_Constants.LATIN_AMERICA || OppTGP[i].Client_Geo_Area__r.name== Util_Constants.EALA || OppTGP[i].Client_Geo_Area__r.name== Util_Constants.NORTH_AMERICA) && (OppTGP[i].Activity__c== Util_Constants.PIPELINE || OppTGP[i].Activity__c== Util_Constants.UNQUALIFIED))
                {
                    if(OppTGP[i].Service_Group__c !='IS'){
                        EmailOppTGPInsertSendEmail.sendMailInsert(OppTGP[i]);
                    }
                    EmailOPPTGPInsertRegionSendEmail.sendMailInsertRegion(OppTGP[i]);
                }
                else if(oppTGP[i].Activity__c== Util_Constants.PIPELINE || oppTGP[i].Activity__c== Util_Constants.UNQUALIFIED)        
                {
                    if(OppTGP[i].Service_Group__c !='IS'){
                        EmailOppTGPInsertSendEmail.sendMailInsert(OppTGP[i]);
                    }    
                }
                
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT_EMAIL, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);  
        }   
    }
    
    /*
    Method Name: insertOppTeam
    Parameter: List<Opportunity_TGP__c>
    Return Type: Void
    Description: Inserting Opportunity Team object record, getting invoked from opportunity trigger.
    */  
    public void insertOppTeam(List<Opportunity_TGP__c> opptyListPassed) {
        List<ID> bpoOpptyIds = new List<ID>();
        //For Bulk Insert        
        for(Opportunity_TGP__c oppty : opptyListPassed) {
            bpoOpptyIds.add(oppty.id);
        }
        Map<String, Id> oppRoleMasterMappedToId = new Map<String, Id>();
        for(Opportunity_Role_master__c oppMaster: [select Id, Name from Opportunity_Role_master__c limit 100]) {
            oppRoleMasterMappedToId.put(oppMaster.Name, oppMaster.Id);
        }
        
        Map<String, Id> userMasterMappedToId = new Map<String, Id>();
        for(Review_User_Master__c userMaster: [select Id, Name from Review_User_Master__c limit 5000]) {
            userMasterMappedToId.put(userMaster.Name, userMaster.Id);
        }
        
        List<Opportunity_TGP__c> oppTGP = new List<Opportunity_TGP__c>();        
        oppTGP =[Select id,Activity__c,Client_Geo_Unit__r.name,Client_Name__r.name,name,Client_Geo_Area__r.name,SAP_OM_Opportunity__r.name,Stage__c,
                 Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Operating_Group__r.name,Risk_Level__c,Enterprise_Solution_Architect_New__c 
                 from Opportunity_TGP__c where id In : bpoOpptyIds];
       List<Opportunity_Team__c> lstOppTeam = new List<Opportunity_Team__c>();
       for(integer i=0; i<opptyListPassed.size(); i++) {
           Opportunity_Team__c tempOppTeam = new Opportunity_Team__c();
           Opportunity_Team__c tempOppTeam1 = new Opportunity_Team__c();
           Opportunity_Team__c tempOppTeam2 = new Opportunity_Team__c();
           Opportunity_Team__c tempOppTeam3 = new Opportunity_Team__c();
           tempOppTeam.BPO_Opportunity__c=oppTGP[i].Id;
           tempOppTeam.Offering__c = null;
           tempOppTeam.Roles__c = oppRoleMasterMappedToId.get('BST Operation');
           tempOppTeam.Opportunity_Team_Member__c = userMasterMappedToId.get(System.label.BSS_User);
           
           lstOppTeam.add(tempOppTeam);
           
           tempOppTeam1.BPO_Opportunity__c=oppTGP[i].Id;
           tempOppTeam1.Offering__c = null;
           tempOppTeam1.Roles__c = oppRoleMasterMappedToId.get('Lead Solution Architect – BPO');
           tempOppTeam1.Opportunity_Team_Member__c = oppTGP[i].Enterprise_Solution_Architect_New__c;
           
           lstOppTeam.add(tempOppTeam1);
           
           tempOppTeam2.BPO_Opportunity__c=oppTGP[i].Id;
           tempOppTeam2.Offering__c = null;
           tempOppTeam2.Roles__c = oppRoleMasterMappedToId.get('Prime SDO Lead');
           tempOppTeam2.Opportunity_Team_Member__c = userMasterMappedToId.get('Unassigned');
           
           lstOppTeam.add(tempOppTeam2);
           
           tempOppTeam3.BPO_Opportunity__c=oppTGP[i].Id;
           tempOppTeam3.Offering__c = null;
           tempOppTeam3.Roles__c = oppRoleMasterMappedToId.get('SD Governance Lead/Coach');
           tempOppTeam3.Opportunity_Team_Member__c = userMasterMappedToId.get('Unassigned');
           
           lstOppTeam.add(tempOppTeam3);
       }
       try {
            Database.insert(lstOppTeam);
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);           
        }
        
    }
    
    /*
    Method Name: insertSolutionUserAssignment
    Parameter: List<Opportunity_TGP__c>
    Return Type: Void
    Description: Inserting Solution user Assignment object record, getting invoked from opportunity trigger.
    */  
    public void insertSolutionUserAssignment(List<Opportunity_TGP__c> opptyListPassed) {
        List<ID> bpoOpptyIds = new List<ID>();
        //For Bulk Insert        
        for(Opportunity_TGP__c oppty : opptyListPassed) {
            bpoOpptyIds.add(oppty.id);
        }
    
        List<Opportunity_TGP__c> oppTGP = new List<Opportunity_TGP__c>();        
        oppTGP =[Select id,Activity__c,Client_Geo_Unit__r.name,Client_Name__r.name,name,Client_Geo_Area__r.name,SAP_OM_Opportunity__r.name,Stage__c,
                 Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Operating_Group__r.name,Risk_Level__c,Enterprise_Solution_Architect_New__c 
                 from Opportunity_TGP__c where id In : bpoOpptyIds];
        List<Solution_User_Assignment__c> solUserAssignList = new List<Solution_User_Assignment__c>();      
        for(integer i=0; i<opptyListPassed.size(); i++) {
            /* Insert the data into Solution User Assignment Object*/
            String userId=UserInfo.getUserId();            
            Solution_User_Assignment__c  solUserAssign = new Solution_User_Assignment__c ();
            Solution_User_Assignment__c  solUserAssign1 = new Solution_User_Assignment__c ();  
            ////////////////////////////////////////////          
            solUserAssign.BPO_Opportunity__c=oppTGP[i].Id;
            solUserAssign.ClientName__c =oppTGP[i].Client_Name__r.name; 
                
            if(oppTGP[i].SAP_OM_Opportunity__r.name != null && oppTGP[i].SAP_OM_Opportunity__r.name !=UTIL_Constants.EMPTY_STRING) {
                solUserAssign.SAP_OM_ID__c =oppTGP[i].SAP_OM_Opportunity__r.name;
            }
            
            solUserAssign.Role__c =UTIL_Constants.COMPLEX_COST_ARCHITECT;
            if(solUserAssign.Role__c ==UTIL_Constants.COMPLEX_COST_ARCHITECT ) {
                //UserAssign.Resource_Assigned_User_New__c = oppTGP[i].Complex_Cost_Architect_New__c;
            }

            solUserAssign.User__c = userId;
            solUserAssignList.add(solUserAssign);
            ////////////////////////////////////////////
            solUserAssign1.BPO_Opportunity__c=oppTGP[i].Id;
            solUserAssign1.ClientName__c =oppTGP[i].Client_Name__r.name; 
                
            if(oppTGP[i].SAP_OM_Opportunity__r.name != null && oppTGP[i].SAP_OM_Opportunity__r.name !=UTIL_Constants.EMPTY_STRING) {
                solUserAssign1.SAP_OM_ID__c =oppTGP[i].SAP_OM_Opportunity__r.name;
            }
            
            solUserAssign1.Role__c =UTIL_Constants.OPP_SOL_LEAD;
            if(solUserAssign1.Role__c ==UTIL_Constants.OPP_SOL_LEAD && oppTGP[i].Enterprise_Solution_Architect_New__c!= null) {
                solUserAssign1.Resource_Assigned_User_New__c= oppTGP[i].Enterprise_Solution_Architect_New__c;
            }
            solUserAssign1.Status__c = UTIL_Constants.SUA_ASSIGNED; 
            solUserAssign1.Date_Requested__c=system.today();
            solUserAssign1.Requester_Name__c=UserInfo.getUserId();  
            solUserAssign1.Date_Assigned__c=system.today(); 
            solUserAssign1.User__c = userId;
            solUserAssignList.add(solUserAssign1);
            ////////////////////////////////////////////
        }
        try {
            Database.insert(solUserAssignList);
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);           
        }
    }
    
    /*
    Method Name: updateSolutionUserAssignment
    Parameter: List<Opportunity_TGP__c>
    Return Type: Void
    Description: Updating Solution user Assignment object record, getting invoked from opportunity trigger.
    */  
    public void updateSolutionUserAssignment(List<Opportunity_TGP__c> opptyListPassed) {
     }    
     
     
     /*
    Method Name: emailToClientGeoArea
    Parameter: List<Opportunity_TGP__c>
    Return Type: Void
    Description: Sending email alerts to client geo area group based on the conditions.
    */  
    public void emailToClientGeoArea(List<Opportunity_TGP__c> oppNewList, List<Opportunity_TGP__c> opptyListOld) {
        Opportunity_TGP__c opptyListOldPassed = new Opportunity_TGP__c();
        try {
            
            for(Opportunity_TGP__c oppty : oppNewList) {
                opptyListOldPassed = (Opportunity_TGP__c)Trigger.oldMap.get(oppty.Id);
                //calling method of swopportunitySharingLogicController class
                swopportunitySharingLogicController.updateOppty(oppNewList,opptyListOldPassed);
            }
            
            List <Client_Geo_Area_Master__c> clientList = new List<Client_Geo_Area_Master__c>();
            List <Client_Geo_Unit_Master__c> clientUnitList = new List<Client_Geo_Unit_Master__c>();
            List <Client_Master__c> clientMasterName = new List<Client_Master__c>();
            List <Operating_Group_Master__c> opGroup = new List<Operating_Group_Master__c>();
            List <Client_Geo_Area_Master__c > OldclientList = new List<Client_Geo_Area_Master__c >();
            
            Map<Id,Operating_Group_Master__c> operatingGroupMasterIDRecordMap = new Map<Id,Operating_Group_Master__c>();
            Map<Id,Client_Master__c> clientMasterIDRecordMap = new Map<Id,Client_Master__c>();
            Map<Id,Client_Geo_Area_Master__c> clientGeoAreaMasterIDRecordMap = new Map<Id,Client_Geo_Area_Master__c>();
            Map<Id,Client_Geo_Unit_Master__c> clientGeoUnitMasterIDRecordMap = new Map<Id,Client_Geo_Unit_Master__c>();
            
            for(Operating_Group_Master__c operatingGroupMaster : [select Id, Name from Operating_Group_Master__c limit 5000]) {
                operatingGroupMasterIDRecordMap.put(operatingGroupMaster.Id, operatingGroupMaster);
            }
            for(Client_Master__c clientMaster : [select Id, Name from Client_Master__c limit 5000]) {
                clientMasterIDRecordMap.put(clientMaster.Id, clientMaster);
            }
            for(Client_Geo_Area_Master__c clientGeoAreaMaster : [select Id, Name from Client_Geo_Area_Master__c limit 5000]) {
                clientGeoAreaMasterIDRecordMap.put(clientGeoAreaMaster.Id, clientGeoAreaMaster);
            }
            for(Client_Geo_Unit_Master__c clientGeoUnitMaster : [select Id, Name from Client_Geo_Unit_Master__c limit 5000]) {
                clientGeoUnitMasterIDRecordMap.put(clientGeoUnitMaster.Id, clientGeoUnitMaster);
            }
            // If the Old opportunity trigger doesnt have SAP OM ID
             Opportunity_TGP__c oppty;
            for(integer i=0; i<oppNewList.size(); i++) {
                oppty =oppNewList[i];
                if(oppty.Operating_Group__c!=null && oppty.Client_Name__c!=null && oppty.Client_Geo_Area__c!=null) {
                    opGroup.add(operatingGroupMasterIDRecordMap.get(((Opportunity_TGP__c)trigger.newMap.get(oppty.id)).Operating_Group__c));
                    clientMasterName.add(clientMasterIDRecordMap.get(((Opportunity_TGP__c)trigger.newMap.get(oppty.id)).Client_Name__c));
                    clientList.add(clientGeoAreaMasterIDRecordMap.get(((Opportunity_TGP__c)trigger.newMap.get(oppty.id)).Client_Geo_Area__c));
                    clientUnitList.add(clientGeoUnitMasterIDRecordMap.get(((Opportunity_TGP__c)trigger.newMap.get(oppty.id)).Client_Geo_Unit__c));           
                    OldclientList.add(clientGeoAreaMasterIDRecordMap.get(((Opportunity_TGP__c)trigger.oldMap.get(oppty.id)).Client_Geo_Area__c));
                    if(OldclientList.Size()>0 && clientList.Size()>0 ) {
                        if((OldclientList[0].name== Util_Constants.APAC && clientList[0].name==Util_Constants.LATIN_AMERICA && oppty.Activity__c== Util_Constants.PIPELINE) || 
                           (OldclientList[0].name==Util_Constants.APAC && clientList[0].name== Util_Constants.LATIN_AMERICA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.APAC && clientList[0].name== Util_Constants.EALA && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.APAC && clientList[0].name== Util_Constants.EALA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.APAC && clientList[0].name== Util_Constants.NORTH_AMERICA && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.APAC && clientList[0].name== Util_Constants.NORTH_AMERICA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.LATIN_AMERICA && clientList[0].name== Util_Constants.APAC && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.LATIN_AMERICA && clientList[0].name== Util_Constants.APAC && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.LATIN_AMERICA && clientList[0].name== Util_Constants.EALA && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.LATIN_AMERICA && clientList[0].name== Util_Constants.EALA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.LATIN_AMERICA && clientList[0].name== Util_Constants.NORTH_AMERICA && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.LATIN_AMERICA && clientList[0].name== Util_Constants.NORTH_AMERICA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.EALA && clientList[0].name== Util_Constants.APAC && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.EALA && clientList[0].name== Util_Constants.APAC && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.EALA && clientList[0].name== Util_Constants.LATIN_AMERICA && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.EALA && clientList[0].name== Util_Constants.LATIN_AMERICA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.EALA && clientList[0].name== Util_Constants.NORTH_AMERICA && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.EALA && clientList[0].name== Util_Constants.NORTH_AMERICA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.NORTH_AMERICA && clientList[0].name== Util_Constants.APAC && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.NORTH_AMERICA && clientList[0].name== Util_Constants.APAC && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.NORTH_AMERICA && clientList[0].name== Util_Constants.LATIN_AMERICA && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.NORTH_AMERICA && clientList[0].name== Util_Constants.LATIN_AMERICA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.NORTH_AMERICA && clientList[0].name== Util_Constants.EALA && oppty.Activity__c== Util_Constants.PIPELINE) ||
                           (OldclientList[0].name== Util_Constants.NORTH_AMERICA && clientList[0].name== Util_Constants.EALA && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.APAC && clientList[0].name!= Util_Constants.APAC && clientList[0].name!= Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.EALA && clientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.PIPELINE  ) ||
                           (OldclientList[0].name== Util_Constants.APAC && clientList[0].name!= Util_Constants.APAC &&  clientList[0].name!= Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.EALA && clientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.UNQUALIFIED) ||
                           (OldclientList[0].name== Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.LATIN_AMERICA  && clientList[0].name!= Util_Constants.APAC && clientList[0].name!= Util_Constants.EALA && clientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.PIPELINE ) ||
                           (OldclientList[0].name== Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.APAC && clientList[0].name!= Util_Constants.EALA && clientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.UNQUALIFIED ) ||  
                           (OldclientList[0].name== Util_Constants.EALA && clientList[0].name!= Util_Constants.EALA  && clientList[0].name!= Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.APAC && clientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.PIPELINE ) ||
                           (OldclientList[0].name== Util_Constants.EALA && clientList[0].name!= Util_Constants.EALA && clientList[0].name!= Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.APAC && clientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.UNQUALIFIED ) ||
                           (OldclientList[0].name== Util_Constants.NORTH_AMERICA && clientList[0].name!= Util_Constants.NORTH_AMERICA && clientList[0].name!= Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.EALA && clientList[0].name!= Util_Constants.APAC  && oppty.Activity__c== Util_Constants.PIPELINE ) ||
                           (OldclientList[0].name== Util_Constants.NORTH_AMERICA && clientList[0].name!= Util_Constants.NORTH_AMERICA && clientList[0].name!= Util_Constants.LATIN_AMERICA && clientList[0].name!= Util_Constants.EALA && clientList[0].name!= Util_Constants.APAC  && oppty.Activity__c== Util_Constants.UNQUALIFIED ) ||
                           (clientList[0].name== Util_Constants.APAC && OldclientList[0].name!= Util_Constants.APAC  && OldclientList[0].name!= Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.EALA && OldclientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.PIPELINE ) ||
                           (clientList[0].name== Util_Constants.APAC && OldclientList[0].name!= Util_Constants.APAC && OldclientList[0].name!= Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.EALA && OldclientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.UNQUALIFIED ) ||
                           (clientList[0].name== Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.APAC && OldclientList[0].name!= Util_Constants.EALA && OldclientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.PIPELINE ) || 
                           (clientList[0].name== Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.APAC && OldclientList[0].name!= Util_Constants.EALA && OldclientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.UNQUALIFIED ) || 
                           (clientList[0].name== Util_Constants.EALA && OldclientList[0].name!= Util_Constants.EALA && OldclientList[0].name!= Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.APAC && OldclientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.PIPELINE ) ||
                           (clientList[0].name== Util_Constants.EALA && OldclientList[0].name!= Util_Constants.EALA && OldclientList[0].name!= Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.APAC && OldclientList[0].name!= Util_Constants.NORTH_AMERICA  && oppty.Activity__c== Util_Constants.UNQUALIFIED ) || 
                           (clientList[0].name== Util_Constants.NORTH_AMERICA && OldclientList[0].name!= Util_Constants.NORTH_AMERICA && OldclientList[0].name!= Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.EALA && OldclientList[0].name!= Util_Constants.APAC  && oppty.Activity__c== Util_Constants.PIPELINE ) ||
                           (clientList[0].name== Util_Constants.NORTH_AMERICA && OldclientList[0].name!= Util_Constants.NORTH_AMERICA && OldclientList[0].name!= Util_Constants.LATIN_AMERICA && OldclientList[0].name!= Util_Constants.EALA && OldclientList[0].name!= Util_Constants.APAC  && oppty.Activity__c== Util_Constants.UNQUALIFIED )) {
                            if(OldclientList[0].name!=null) {
                                EmailClientGeoAreaSendEmail.sendMail(Trigger.old,Trigger.new,clientList,clientUnitList,clientMasterName,opGroup);
                            }
                           }
                    }
                    if(OldclientList.Size()==0) {
                        if(((clientList[0].name== Util_Constants.LATIN_AMERICA) && (oppty.Activity__c== Util_Constants.PIPELINE || oppty.Activity__c== Util_Constants.UNQUALIFIED)) || 
                            (( clientList[0].name== Util_Constants.NORTH_AMERICA) && (oppty.Activity__c== Util_Constants.PIPELINE || oppty.Activity__c== Util_Constants.UNQUALIFIED)) ||
                            (( clientList[0].name== Util_Constants.APAC) && (oppty.Activity__c== Util_Constants.PIPELINE || oppty.Activity__c== Util_Constants.UNQUALIFIED)) ||
                            ((clientList[0].name== Util_Constants.EALA) && (oppty.Activity__c== Util_Constants.PIPELINE || oppty.Activity__c== Util_Constants.UNQUALIFIED))) {
                                if(oppty.Service_Group__c !='IS'){
                                    EmailOppTGPInsertSendEmail.sendMailInsert(oppty );
                                }
                                EmailOPPTGPInsertRegionSendEmail.sendMailInsertRegion(oppty);
                        }
                    }
                }
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_UPDATE_EMAIL, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
      //End
    }
 
  
  /*
    Method Name: updateOfferingscopeOnSap
    Parameter: List<Opportunity_TGP__c>
    Return Type: Void
    Description: update the value of Offerings On BpoOpty(Dev) field on Sap Opportunity with the value of Offering Scope (SWB) field on BPO Opportunity. This method will be called by BPO trigger after Insert and after Update.
    */  
    public void updateOfferingscopeOnSap(List<Opportunity_TGP__c> oppNewList) { 
        
        map <ID, String> sapOmOppMap = new map <ID, String>();

        List <SAP_OM_Opportunity__c> sapOmOppList = new List <SAP_OM_Opportunity__c> ();
        
        for(Opportunity_TGP__c bpoOpty : oppNewList){
            if (bpoOpty.SAP_OM_Opportunity__c != NULL)
                sapOmOppMap.put(bpoOpty.SAP_OM_Opportunity__c, bpoOpty.Offerings__c);
        }

        for (SAP_OM_Opportunity__c sap : [select ID, Offering_bpo__c from SAP_OM_Opportunity__c where ID IN: sapOmOppMap.keySet() LIMIT 10000]) {           
            sap.Offering_bpo__c = sapOmOppMap.get(sap.ID);
            if (sap.Offering_bpo__c == NULL || sap.Offering_bpo__c == UTIL_Constants.EMPTY_STRING)
                sap.Offering_bpo__c = 'NA';
            sapOmOppList.add(sap);
        }
        if(sapOmOppList.size()>0){
        update sapOmOppList;
        }
    }
 public void refreshOfferingscopeOnSap (List<Opportunity_TGP__c> oppNewList, List<Opportunity_TGP__c> oppOldList){
 
     system.debug('----oppOldList----------'+oppOldList);
        map <ID, String> bpoOppMap = new map <ID, String>();
        map <ID, String> bpoOppOfferingMap = new map <ID, String>();
        boolean onlyOfferingChanged = false;
        boolean onlySapAssociationChanged = false;
        boolean bothChanged = false;
        List<SAP_OM_Opportunity__c> sapAssociationChanged = new List<SAP_OM_Opportunity__c>();
        
        for (Opportunity_TGP__c bpoOpty : oppNewList){
            bpoOppMap.put(bpoOpty.id, bpoOpty.SAP_OM_Opportunity__c);
            bpoOppOfferingMap.put(bpoOpty.id, bpoOpty.Offerings__c);
        }
        for (Opportunity_TGP__c oldBpoOpty : oppOldList){
            if(bpoOppMap.containsKey(oldBpoOpty.id) && bpoOppMap.get(oldBpoOpty.id) != NULL){
                if( (oldBpoOpty.SAP_OM_Opportunity__c != bpoOppMap.get(oldBpoOpty.id)) && (oldBpoOpty.Offerings__c != bpoOppOfferingMap.get(oldBpoOpty.id) ) )
                    bothChanged = true;
                    
                else if( (oldBpoOpty.SAP_OM_Opportunity__c == bpoOppMap.get(oldBpoOpty.id)) && (oldBpoOpty.Offerings__c != bpoOppOfferingMap.get(oldBpoOpty.id) ) )
                 {
                    system.debug('-------oldBpoOpty.Offerings__c------'+oldBpoOpty.Offerings__c);
                    system.debug('-------bpoOppOfferingMap.get(oldBpoOpty.id)------'+bpoOppOfferingMap.get(oldBpoOpty.id));
                    onlyOfferingChanged = true;
                }
                else if (oldBpoOpty.SAP_OM_Opportunity__c != bpoOppMap.get(oldBpoOpty.id))
                    onlySapAssociationChanged = true;                                   
                }
            if(bothChanged || onlySapAssociationChanged){
                Sap_Om_Opportunity__c sap = new Sap_Om_Opportunity__c();
                sap.id = oldBpoOpty.SAP_OM_Opportunity__c;
                sap.Offering_bpo__c = '';
                system.debug('Sap'+Sap);
                if(oldBpoOpty.SAP_OM_Opportunity__c!=null){
                sapAssociationChanged.add(sap);
                }
                Sap_Om_Opportunity__c newSap = new Sap_Om_Opportunity__c();
                newSap.id = bpoOppMap.get(oldBpoOpty.id);
                newSap.Offering_bpo__c = bpoOppOfferingMap.get(oldBpoOpty.id);
                if(bpoOppMap.get(oldBpoOpty.id)!=null){
                sapAssociationChanged.add(newSap); 
                }
                         
                System.debug('sap'+newSap);
            }   
            if(onlyOfferingChanged){
                Sap_Om_Opportunity__c newSap = new Sap_Om_Opportunity__c();
                system.debug('-------bpoOppMap.get(oldBpoOpty.id)------'+bpoOppMap.get(oldBpoOpty.id));
                newSap.id = bpoOppMap.get(oldBpoOpty.id);
                newSap.Offering_bpo__c = bpoOppOfferingMap.get(oldBpoOpty.id); 
                system.debug('newSap'+newSap);
                // New Code Change
                if(bpoOppOfferingMap.get(oldBpoOpty.id)!=null){
                    sapAssociationChanged.add(newSap);
                }         
                //sapAssociationChanged.add(newSap);
            }           
        }
        if (sapAssociationChanged.size() > 0){
            system.debug('-------sapAssociationChanged------'+sapAssociationChanged);
            update sapAssociationChanged;  
            }
    }
    public void refreshOfferingscopeOnSap (List<Opportunity_TGP__c> oppOldList){
        List<SAP_OM_Opportunity__c> sapAssociationChanged = new List<SAP_OM_Opportunity__c>();
        for(Opportunity_TGP__c bpoOpty : oppOldList){
            if (bpoOpty.SAP_OM_Opportunity__c != NULL){
                Sap_Om_Opportunity__c sap = new Sap_Om_Opportunity__c();
                sap.id = bpoOpty.SAP_OM_Opportunity__c;
                sap.Offering_bpo__c = '';
                sapAssociationChanged.add(sap);
            }
        }
        if (sapAssociationChanged.size() > 0)   
            update sapAssociationChanged;               
    }  
    
/*     public void emailOnDeliveryLocationChange(List<Opportunity_TGP__c> opptyListPassedNew,List<Opportunity_TGP__c> opptyListPassedOld ) {

    for(Opportunity_TGP__c oppNewRec : opptyListPassedNew){

        for(Opportunity_TGP__c oppOldRec : opptyListPassedOld){

            if((oppNewRec.Service_Delivery_Locations_Unique__c != oppOldRec.Service_Delivery_Locations_Unique__c) && oppNewRec.Service_Delivery_Locations_Unique__c != null){
                
                if(oppNewRec.Service_Delivery_Locations_Unique__c.contains('Arg - Buenos Aires') || oppNewRec.Service_Delivery_Locations_Unique__c.contains('Brazil - Belo Horizonte') || oppNewRec.Service_Delivery_Locations_Unique__c.contains('Brazil - Curitiba') || oppNewRec.Service_Delivery_Locations_Unique__c.contains('Chile - Chile') || oppNewRec.Service_Delivery_Locations_Unique__c.contains('CR - San Jose') || oppNewRec.Service_Delivery_Locations_Unique__c.contains('LATAM Client Location') || oppNewRec.Service_Delivery_Locations_Unique__c.contains('LATAM Non DCN Location')){
                
                EmailOppTGPInsertSendEmail.sendMailForDeliveryLocation(oppNewRec);

                

                    }

                }

            }   


        }
    } */
}