/*
Author :  Vinay Kumar Chada
Story  :  UAM - Release R2.0
Description : UAM Implementation.


Updated by                  Story no.                Update Date        Update details
------------            -----------------        --------------    --------------------------
*/
public without sharing class UAMSWBMWBUtility {
    public static final String CHECKACCESSOPPSHAREDELETE_METHOD = 'CheckAccessOppShareDelete';
    public static final String CHECKACCESSOPPSHAREINSERT_METHOD = 'CheckAccessOppShareInsert';
    /**
     *  @Description : Inner Class for getting opp team data.
     *  @name : UserListForOppTeam
     */
    with sharing class UserListForOppTeam {
        Id userId;
        String accessLevel;
        String oppId;
        String oppTeamId;
        String rowCause;
        Boolean HaveEditAccessOnOpportunity;
        Boolean isActive;
    }
    /**
     *  @Description : Inner Class for getting user data.
     *  @name : UserListForSRAlevel1      
    **/
    with sharing class UserListForSRAlevel1 {
        Id userId;
        String accessLevel;
        String dealId;
        String rowCause;
    }
    /**
   *  @Description : This method is used give opportunity and opportunity team 
                       access to Opportunity team member upon insertion.
   *  @name : CheckAccessOppShareInsert
   *  @param : List<Opportunity_Teams__c> lstOppTeam
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
    public static void CheckAccessOppShareInsert(List < Opportunity_Teams__c > lstOppTeam) {
        list < OpportunityShare > oppShareRecList = new list < OpportunityShare > ();
        List < Opportunity_Teams__Share > oppTeamShareList = new List < Opportunity_Teams__Share > ();
        Set < ID > oppTeamIdList = new Set < ID > ();
        Set < ID > oppIdList = new Set < ID > ();
        List < UserListForOppTeam > lstUserList = new List < UserListForOppTeam > ();
        UserListForOppTeam ulist;
        map < Id, List < Opportunity_Teams__c >> oppTeamMap = new map < Id, List < Opportunity_Teams__c >> ();
        /*Map<String,UserRecordAccess> URARecMap = new Map<Id,UserRecordAccess>();
        
        List<UserRecordAccess> accessLevel = [select HasEditAccess,UserId,RecordId from userRecordAccess];
        
        for(UserRecordAccess URARec : accessLevel){
            String key = URARec.UserId + URARec.RecordId;
            //////system.debug('------key----'+key);
            //////system.debug('------URARec----'+URARec);
            URARecMap.put(key,URARec);
        }*/

        for (Opportunity_Teams__c oppTeamRec: lstOppTeam) {
            oppTeamIdList.add(oppTeamRec.id);
            oppIdList.add(oppTeamRec.opportunity__c);
        }
        List < Opportunity > oppList = [SELECT Id, name, (select Opportunity_Team_Member__r.isSFDCUser__c, Active__c,
                                        Team_Member_Request_Status__c, Request_Team_Member__c, Requestor__r.user__c, Requestor__c,
                                        Requestor__r.user__r.Email, Opportunity__r.ownerId, Role__r.HaveEditAccessOnOpportunity__c, Opportunity_Team_Member__r.name,
                                        Opportunity__r.Opportunity_Solution_Lead__c, Offering__c, Offering__r.Offering_Solution_Lead_Primary__c,
                                        Offering__r.Offering_Solution_Lead_Secondary__c, Role__r.name, Role__r.ShouldReceiveAlertMail__c,
                                        Opportunity_Team_Member__r.user__c, Opportunity_Team_Member__r.user__r.Email, Opportunity_Team_Member__r.user__r.IsActive
                                        FROM Opportunity_Team__r) FROM Opportunity WHERE id IN: oppIdList Limit 5000];
        if (oppList.size() > 0) {
            for (Opportunity oppRec: oppList) {

                oppTeamMap.put(oppRec.id, oppRec.Opportunity_Team__r);

            }
        }
        try {
            for (Opportunity_Teams__c oppTeamRec: [SELECT Id, Name, Opportunity_Team_Member__r.isSFDCUser__c, OwnerId, Opportunity_Team_Member__r.user__r.IsActive,
                                                Team_Member_Request_Status__c, Request_Team_Member__c, Requestor__r.user__c, Requestor__c,
                                                Requestor__r.user__r.Email, Opportunity__r.ownerId, Role__r.HaveEditAccessOnOpportunity__c, Opportunity_Team_Member__r.name,
                                                Opportunity__r.Opportunity_Solution_Lead__c, Offering__c, Offering__r.Offering_Solution_Lead_Primary__c,
                                                Offering__r.Offering_Solution_Lead_Secondary__c, Role__r.name, Role__r.ShouldReceiveAlertMail__c,
                                                Opportunity_Team_Member__r.user__c, Opportunity_Team_Member__r.user__r.Email
                                                FROM Opportunity_Teams__c where ID IN: oppTeamIdList AND Role__c != null limit 5000]) {
                // if(oppTeamRec.Opportunity_Team_Member__r.user__c != null){                                     
                ulist = new UserListForOppTeam();
                ulist.oppId = oppTeamRec.Opportunity__c;
                ulist.userId = oppTeamRec.Opportunity_Team_Member__r.user__c;
                ulist.HaveEditAccessOnOpportunity = oppTeamRec.Role__r.HaveEditAccessOnOpportunity__c;
                ulist.isActive = oppTeamRec.Opportunity_Team_Member__r.user__r.IsActive;
                //ulist.accessLevel = 'Edit';
                //ulist.rowCause = 'Manual';
                ulist.accessLevel = UtilConstants.EDIT_STRING;                
                ulist.rowCause = UtilConstants.MANUAL_STRING;
                ulist.oppTeamId = oppTeamRec.id;
                lstUserList.add(ulist);
                //}
            }
            if (lstUserList.size() > 0) {

                for (UserListForOppTeam userListRec: lstUserList) {

                    if (userListRec.isActive) {

                        if (userListRec.HaveEditAccessOnOpportunity) {

                            Boolean accessLevel = [select HasEditAccess, RecordId from userRecordAccess 
                                                    where UserId = : userListRec.userId and RecordId = : userListRec.oppId Limit 1].HasEditAccess;

                            if (!accessLevel) {

                                OpportunityShare oppShareRec = new OpportunityShare();
                                oppShareRec.OpportunityId = userListRec.oppId;
                                oppShareRec.UserOrGroupId = userListRec.userId;
                                oppShareRec.OpportunityAccessLevel = userListRec.accessLevel;
                                oppShareRec.RowCause = userListRec.rowCause;
                                oppShareRecList.add(oppShareRec);
                            }
                        }
                    }
                    List < Opportunity_Teams__c > oppTeamList = oppTeamMap.get(userListRec.oppId);

                    for (Opportunity_Teams__c oppTeamRec: oppTeamList) {
                        if (userListRec.isActive) {
                            if (userListRec.HaveEditAccessOnOpportunity) {
                                Boolean accessLevelForTeam = [select HasEditAccess, RecordId from userRecordAccess where 
                                                                UserId = : userListRec.userId and RecordId = : oppTeamRec.id limit 1].HasEditAccess;
                                if (!accessLevelForTeam) {
                                    Opportunity_Teams__Share oppTeamShareRec = new Opportunity_Teams__Share();
                                    oppTeamShareRec.ParentId = oppTeamRec.id;
                                    oppTeamShareRec.UserOrGroupId = userListRec.userId;
                                    oppTeamShareRec.AccessLevel = userListRec.accessLevel;
                                    oppTeamShareRec.RowCause = userListRec.rowCause;
                                    oppTeamShareList.add(oppTeamShareRec);
                                }
                            }
                        }
                        // Reverse
                        if (oppTeamRec.Opportunity_Team_Member__r.user__c != null && 
                                oppTeamRec.Opportunity_Team_Member__r.user__r.IsActive && 
                                oppTeamRec.Role__r.HaveEditAccessOnOpportunity__c) {
                            Boolean accessLevelOnTeam = [select HasEditAccess, RecordId from userRecordAccess where UserId = : oppTeamRec.Opportunity_Team_Member__r.user__c 
                                                        and RecordId = : userListRec.oppTeamId Limit 1].HasEditAccess;

                            if (!accessLevelOnTeam) {
                                Opportunity_Teams__Share oppShareOnTeam = new Opportunity_Teams__Share();
                                oppShareOnTeam.ParentId = userListRec.oppTeamId;
                                oppShareOnTeam.UserOrGroupId = oppTeamRec.Opportunity_Team_Member__r.user__c;
                                oppShareOnTeam.AccessLevel = userListRec.accessLevel;
                                oppShareOnTeam.RowCause = userListRec.rowCause;
                                oppTeamShareList.add(oppShareOnTeam);
                            }
                        }
                    }
                }

            }

            Database.SaveResult[] oppShareInsertResult = Database.insert(oppShareRecList, true);
            Database.SaveResult[] oppTeamShareInsertResult = Database.insert(oppTeamShareList, true);
        } catch (Exception e) {
            ////system.debug('----------e-----' + e);
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
            UtilConstants.UAMSWBMWBUTILITY_CLASS, CHECKACCESSOPPSHAREINSERT_METHOD, null, System.Logginglevel.ERROR);
        }
    }

    /**
   *  @Description : This method is used delete opportunity and opportunity team 
                       access to Opportunity team member when opp team record is getting deleted.
   *  @name : CheckAccessOppShareDelete
   *  @param : List<Opportunity_Teams__c> lstOldOppTeam
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
    public static void CheckAccessOppShareDelete(List < Opportunity_Teams__c > lstOldOppTeam) {
        Set < Id > userMasterIds = new Set < Id > ();
        MAp < Id, Id > roleIds = new Map < Id, ID > ();
        Set < String > oppIds = new Set < String > ();
        Set < String > oppTeamIds = new Set < String > ();
        Set < String > oppTeamUserAssignedSet = new set < String > ();
        Map < Set < String > , Boolean > oppTeamUserAssignedMap = new Map < Set < String > , Boolean > ();
        Set < Id > roleIdsToDelete = new Set < Id > ();
        map < String, List < Opportunity_Teams__c >> oppTeamMap = new map < String, List < Opportunity_Teams__c >> ();

        try {
            for (Opportunity_Teams__c oppTeamOldRec: lstOldOppTeam) {
                oppTeamIds.add(oppTeamOldRec.id);
                oppIds.add(oppTeamOldRec.opportunity__c);
                userMasterIds.add(oppTeamOldRec.Opportunity_Team_Member__c);
            }
            for (User_Master__c userMasterList: [Select user__c FROM User_Master__c where Id in : userMasterIds limit 5000]) {
                roleIds.put(userMasterList.id, userMasterList.user__c);
            }
            List < Opportunity > oppList = [SELECT Id, name, (select Opportunity_Team_Member__r.isSFDCUser__c, Active__c,
                                        Team_Member_Request_Status__c, Request_Team_Member__c, Requestor__r.user__c, Requestor__c,
                                        Requestor__r.user__r.Email, Opportunity__r.ownerId, Role__r.HaveEditAccessOnOpportunity__c, Opportunity_Team_Member__r.name,
                                        Opportunity__r.Opportunity_Solution_Lead__c, Offering__c, Offering__r.Offering_Solution_Lead_Primary__c,
                                        Offering__r.Offering_Solution_Lead_Secondary__c, Role__r.name, Role__r.ShouldReceiveAlertMail__c,
                                        Opportunity_Team_Member__r.user__c, Opportunity_Team_Member__r.user__r.Email
                                        FROM Opportunity_Team__r) FROM Opportunity WHERE id IN: oppIds Limit 5000];

            if (oppList.size() > 0) {
                for (Opportunity oppRec: oppList) {
                    oppTeamMap.put(oppRec.id, oppRec.Opportunity_Team__r);
                }
            }
            for (Opportunity_Teams__c oppTeamOldRec: lstOldOppTeam) { // old ma
                Integer Count = 0;
                List < Opportunity_Teams__c > oppTeamList = oppTeamMap.get(oppTeamOldRec.opportunity__c);

                if (oppTeamList.size() > 0) {
                    for (Opportunity_Teams__c oppTeam: oppTeamList) {
                        if(oppTeam.Opportunity_Team_Member__r.user__c != null){
                            if (oppTeam.Opportunity_Team_Member__r.user__c.equals(roleIds.get(oppTeamOldRec.Opportunity_Team_Member__c)) && 
                                oppTeam.Role__r.HaveEditAccessOnOpportunity__c) {
                                Count++;
                            }
                        }
                    }
                    if (Count > 0) {
                        roleIdsToDelete.remove(roleIds.get(oppTeamOldRec.Opportunity_Team_Member__c));
                    } else {
                        roleIdsToDelete.add(roleIds.get(oppTeamOldRec.Opportunity_Team_Member__c));
                    }
                } else {
                    roleIdsToDelete.add(roleIds.get(oppTeamOldRec.Opportunity_Team_Member__c));
                }
            }

            List < Opportunity_Teams__Share > oppTeamShareListTodelete = new List < Opportunity_Teams__Share > ();

            List < Id > oppTeamIdWhole = new List < Id > ();
            for (Opportunity oppRec: oppList) {
                for (Opportunity_Teams__c oppTeamRec: oppRec.Opportunity_Team__r) {
                     oppTeamIdWhole.add(oppTeamRec.Id);
                }
            }
            oppTeamShareListTodelete = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause 
                                        FROM Opportunity_Teams__Share where ParentId IN: oppTeamIdWhole and RowCause = :UtilConstants.MANUAL_STRING AND 
                                        UserOrGroupId IN: roleIdsToDelete LIMIT 500];

            List < OpportunityShare > oppShareListTodelete = [SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause 
                                                                FROM OpportunityShare where OpportunityId IN: oppIds and RowCause = :UtilConstants.MANUAL_STRING AND 
                                                                UserOrGroupId IN: roleIdsToDelete LIMIT 500];

            if (oppShareListTodelete.size() > 0) {
                Database.DeleteResult[] oppDeleteResult = Database.delete(oppShareListTodelete, true);
            }
            if (oppTeamShareListTodelete.size() > 0) {
                Database.DeleteResult[] oppTeamDeleteResult = Database.delete(oppTeamShareListTodelete, true);
            }
        } catch (Exception e) {

            ////system.debug('----------e-----' + e);
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
            UtilConstants.UAMSWBMWBUTILITY_CLASS, CHECKACCESSOPPSHAREDELETE_METHOD, null, System.Logginglevel.ERROR);
        }
    }
    /**** ======== MWB Sharing Records Creation Code =============== ****/
    /**
   *  @Description : This method is used delete opportunity and Mobilization team
                       access to Opportunity team member when opp team record is getting deleted.
   *  @name : CheckAccessDealShareInsert
   *  @param :List < Mobilization_Team__c > lstMobTeam
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
    public void CheckAccessDealShareInsert(List < Mobilization_Team__c > lstMobTeam) {
        List < UserList > lstUserList = new List < UserList > ();
        UserList ulist;
        List < sobject > lstDealShare = new List < sobject > ();
        
        set <Id> dealid = new set <Id> ();
        List < Mobilization_plan__c > mobplanlist = new List < Mobilization_plan__c > ();
        set < Id > sratId= new set < Id > ();
        set < Id > opexId= new set < Id > ();
        Set < ID > waveId= new Set < ID > ();
        Map<Id, Id> opexWithMobPlan= new Map<Id, Id>();
        Map<Id, Id> sratWithMobPlan= new Map<Id, Id>();
        Map<Id, Id> waveWithPlan= new Map<Id, Id>();
        Map<Id, Id> planWithDeal= new Map<Id, Id>();
        
        Map<Id, Id> teamDealMap = new Map<Id, Id>();
        Map<Id,set<Id>> dealWithMobMap=new Map<Id,set<Id>>();
                  
        try{
      
        //Divya Code Starts Here
            String dealQuery = 'SELECT Id, Name, ownerId  FROM Deal__C WHERE ID IN : dealId';
            String dealFlag= UtilConstants.DEAL_SHARE;
            for(Mobilization_Team__c mobTeam : lstMobTeam){
                dealId.add(mobTeam.Deal__c);
            }
             dealWithMobMap=getMobTeam(lstMobTeam);
        
            for(Mobilization_plan__C mp:[select id,deal__c from Mobilization_plan__C where Deal__C IN :dealId limit 10000]){
                 planWithDeal.put(mp.id,mp.deal__c);
            }
            
            for(SRAT_Tracker__c srat : [SELECT Id, Name, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c FROM SRAT_Tracker__c 
            WHERE Mobilization_Plan__r.Deal__c IN :dealId limit 10000]){
                sratId.add(srat.Id);
                sratWithMobPlan.put(srat.id, srat.Mobilization_Plan__c);
            }
            
            for(OPEX_Tracker__c opex : [SELECT Id, Name, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c FROM OPEX_Tracker__c 
            WHERE Mobilization_Plan__r.Deal__c IN :dealId limit 10000]){
                opexId.add(opex.Id);
                opexWithMobPlan.put(opex.id, opex.Mobilization_Plan__c);
            }
            
            for(Wave__c wave:[select id,mobilization_plan__c, Mobilization_Plan__r.Deal__c from Wave__c where
            Mobilization_Plan__r.Deal__c IN :dealId limit 10000]){
                waveId.add(wave.id);
                waveWithPlan.put(wave.id,wave.mobilization_plan__c);
            }
            
            Id batchId=database.executeBatch(new MobilizationTeamSharing(dealId, dealQuery, dealWithMobMap, dealFlag, sratWithMobPlan, 
            planWithDeal, sratId,opexWithMobPlan,opexId,waveId,waveWithPlan)); 
        }Catch(DMLException e) {   
        ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }

    }
    /**
   *  @Description : 
   *  @name : CheckAccessRiskShareInsert
   *  @param :List < Risks__c > lstNewRisk
   *  @return parameter - void
   *  @throws exception- NA
   */
    public void CheckAccessRiskShareInsert(List <Risks__c> lstNewRisk) {
        Set <ID> dealids = new Set <ID> ();
        Set <ID> riskIds = new Set <ID> ();
        Map<Id, Id> riskDealMap = new Map<Id, Id>();
        try{
        for (Risks__c risk: lstNewRisk) {
            dealids.add(risk.Deal__c);
            riskIds.add(risk.id);
            riskDealMap.put(risk.Id, risk.Deal__c);
        }
        //// ++ getAllTeamMumbers(riskDealMap, dealids,riskIds,'Risks__Share');
        getAllTeamMumbers(null, riskDealMap, dealids, riskIds, UtilConstants.RISK_SHARE);
        }Catch(DMLException e) {   
            ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
    /**
   *  @Description : 
   *  @name : CheckAccessActionShareInsert
   *  @param :List < Action__c > lstNewAction
   *  @return parameter - void
   *  @throws exception- NA
   */
    public void CheckAccessActionShareInsert(List < Action__c > lstNewAction) {
        Set < ID > dealids = new Set < ID > ();
        Set < ID > actionIds = new Set < ID > ();
        Map<Id, Id> actionDealMap = new Map<Id, Id>();
        try{
        for (Action__c action: lstNewAction) {
            dealids.add(action.Deal__c);
            actionIds.add(action.id);
            actionDealMap.put(action.Id, action.Deal__c);
        }
        //// ++ getAllTeamMumbers(dealids,actionIds,'Action__Share');
        getAllTeamMumbers(null, actionDealMap, dealids, actionIds, UtilConstants.ACTION_SHARE);
        }Catch(DMLException e) {   ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
    /**
   *  @Description : 
   *  @name : CheckAccessActionShareInsert
   *  @param :List < Action__c > lstNewAction
   *  @return parameter - void
   *  @throws exception- NA
   */
    public void CheckAccessIssueShareInsert(List < Issues__c > lstNewIssue) {
        Set < ID > dealids = new Set < ID > ();
        Set < ID > issueIds = new Set < ID > ();
        Map<Id, Id> issueDealMap = new Map<Id, Id>();
        try{
        for (Issues__c issue: lstNewIssue) {
            dealids.add(issue.Deal__c);
            issueIds.add(issue.id);
            issueDealMap.put(issue.Id, issue.Deal__c);
        }
        //// ++ getAllTeamMumbers(dealids,issueIds,'Issues__Share');
        getAllTeamMumbers(null, issueDealMap, dealids, issueIds, UtilConstants.ISSUES_SHARE);
        }Catch(DMLException e) {  
             ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
    /**
   *  @Description : 
   *  @name : CheckAccessActionShareInsert
   *  @param :List < Action__c > lstNewAction
   *  @return parameter - void
   *  @throws exception- NA
   */
    public void CheckAccessDecisionShareInsert(List < Decision__c > lstNewDecision) {
        Set < ID > dealids = new Set < ID > ();
        Set < ID > decisionIds = new Set < ID > ();
        Map<Id, Id> decDealMap = new Map<Id, Id>();
        try{
        for (Decision__c decision: lstNewDecision) {
            dealids.add(decision.Deal__c);
            decisionIds.add(decision.id);
            decDealMap.put(decision.Id, decision.Deal__c);
        }
        //// ++ getAllTeamMumbers(dealids,decisionIds,'Decision__Share');  
        getAllTeamMumbers(null, decDealMap, dealids, decisionIds, UtilConstants.DECISION_SHARE);
        }Catch(DMLException e) {   
            ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
 /**
   *  @Description : 
   *  @name : sratAdditionalTrakingLevel1ShareInsert
   *  @param :List < SRAT_Additional_Tracking_Level_1__c > lstNewSratLevel1
   *  @return parameter - void
   *  @throws exception- NA
   */
    public void sratAdditionalTrakingLevel1ShareInsert(List < SRAT_Additional_Tracking_Level_1__c > lstNewSratLevel1) {

        Set < ID > dealids = new Set < ID > ();
        Set < ID > sratLeve1Ids = new Set < ID > ();
        Map<Id, Id> sratL1DealMap = new Map<Id, Id>();
        try{
        for (SRAT_Additional_Tracking_Level_1__c stl1: lstNewSratLevel1) {
            sratLeve1Ids.add(stl1.id);
        }
        for (SRAT_Additional_Tracking_Level_1__c sat1: [SELECT Id, Name, SRAT_Tracker__r.Mobilization_Plan__r.deal__c 
                                                        FROM SRAT_Additional_Tracking_Level_1__c where id IN: sratLeve1Ids LIMIT 5000]) {
            dealids.add(sat1.SRAT_Tracker__r.Mobilization_Plan__r.deal__c);
            sratL1DealMap.put(sat1.Id, sat1.SRAT_Tracker__r.Mobilization_Plan__r.deal__c);
        }
        //// ++ getAllTeamMumbers(dealids,sratLeve1Ids,'SRAT_Additional_Tracking_Level_1__share');
        getAllTeamMumbers(null, sratL1DealMap, dealids, sratLeve1Ids, UtilConstants.SRAT_LEVEL1_SHARE);
        }Catch(DMLException e) {   
            ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }

    }
    
    /**
   *  @Description : method to gather all opex addtional track records 
   *  @name : opexAdditionalTrakingLevel1ShareInsert
   *  @param :List < Deal_OPEX_Additional_Tracking_Level_1__c > lstNewOpexLevel1
   *  @return parameter - void
   *  @throws exception- NA
   */
    public void opexAdditionalTrakingLevel1ShareInsert(List < Deal_OPEX_Additional_Tracking_Level_1__c > lstNewOpexLevel1) {

        Set < ID > dealids = new Set < ID > ();
        Set < ID > opexLeve1Ids = new Set < ID > ();
        Map<Id, Id> opexL1DealMap = new Map<Id, Id>();
        try{
        for (Deal_OPEX_Additional_Tracking_Level_1__c oplevl1: lstNewOpexLevel1) {
            opexLeve1Ids.add(oplevl1.id);
        }

        for (Deal_OPEX_Additional_Tracking_Level_1__c opexTLevl1: [SELECT Id, Name, OPEX_Tracker_del__r.Mobilization_Plan__r.deal__c 
                                                                    FROM Deal_OPEX_Additional_Tracking_Level_1__c 
                                                                    where id IN: opexLeve1Ids LIMIT 5000]) {
            dealids.add(opexTLevl1.OPEX_Tracker_del__r.Mobilization_Plan__r.deal__c);
            opexL1DealMap.put(opexTLevl1.Id, opexTLevl1.OPEX_Tracker_del__r.Mobilization_Plan__r.deal__c);
        }
        //// ++ getAllTeamMumbers(dealids,opexLeve1Ids,'Deal_OPEX_Additional_Tracking_Level_1__share');
        getAllTeamMumbers(null, opexL1DealMap, dealids, opexLeve1Ids, UtilConstants.OPEX_LEVEL1_SHARE);
        }Catch(DMLException e) {   
            ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          ////system.debug('Error!!' + e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
    /**
   *  @Description : 
   *  @name : procurementWaveShareInsert
   *  @param :List < Procurement_Wave_Region__c > lstNewprocrementwave
   *  @return parameter - void
   *  @throws exception- NA
   */
    public void procurementWaveShareInsert(List < Procurement_Wave_Region__c > lstNewprocrementwave) {
        set < id > dealids = new set < id > ();
        set < id > procwaveids = new set < id > ();
        Map<Id, Id> procDealMap = new Map<Id, Id>();
        try{
        for (Procurement_Wave_Region__c procwave: lstNewprocrementwave) {
            procwaveids.add(procwave.id);
        }
        for (Procurement_Wave_Region__c proc_deals: [SELECT id, wave__r.Mobilization_plan__r.deal__c 
                                                    FROM Procurement_Wave_Region__c WHERE ID IN: procwaveids LIMIT 2500]) {
            dealids.add(proc_deals.wave__r.Mobilization_plan__r.deal__c);
            procDealMap.put(proc_Deals.Id, proc_deals.wave__r.Mobilization_plan__r.deal__c);
        }
        //// ++ getAllTeamMumbers(dealids,procwaveids,'Procurement_Wave_Region__share');
        getAllTeamMumbers(null, procDealMap, dealids, procwaveids, UtilConstants.PROCUREMENT_WAVE_REGION_SHARE);
        }Catch(DMLException e) {   ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
    /*******************************
        @description : common method which inserts share records
        @inputs : dealids, parentids of records on which to create share rule, sobject API name
    ***************************************/
    public integer shareRecordCnt = 0;
    public void getAllTeamMumbers(Set<Id> newTeamMmbrs, Map<Id, Id> parentDealMap, Set < Id > dealids, Set < Id > ParentIds, String sObjectName) {
               UserList ulist;
        List<Id> idList;
        List < UserList > shareList;
        List < UserList > lstUserList = new List < UserList > ();
        List < UserList > finalUserList = new List < UserList > ();
        List<Mobilization_Team__c > mobTeamList = new List<Mobilization_Team__c >();
        List<Id> uL ;
        Map<Id, List<Id>> teamMembrs = new Map<Id, List<Id>>();
        List<String> members;
        //teamDealMap.KeySet()
        if(newTeamMmbrs <> null && newTeamMmbrs.size() > 0){
            mobTeamList  = [Select Id, Name, Ownerid, Deal__c, Deal__r.Ownerid, Role__c, Primary_Lead__c, Primary_Lead__r.user__c, 
                                        Secondary_Lead_1__c,Secondary_Lead_1__r.user__c, Secondary_Lead_2__c, Secondary_Lead_2__r.user__c
                                            FROM Mobilization_Team__c where ID IN: newTeamMmbrs limit 5000];
        }
        else{
            mobTeamList  = [Select Id, Name, Ownerid, Deal__c, Deal__r.Ownerid, Role__c, Primary_Lead__c, Primary_Lead__r.user__c, 
                                        Secondary_Lead_1__c,Secondary_Lead_1__r.user__c, Secondary_Lead_2__c, Secondary_Lead_2__r.user__c
                                            FROM Mobilization_Team__c where Deal__c IN: dealids limit 5000];
        }                                            
       if(mobTeamList.size() > 0){
        for(Mobilization_Team__c mobTeam: mobTeamList){
            idList = new List<Id>();
            if(teamMembrs.containsKey(mobTeam.Deal__c) && mobTeam.Deal__c <> null){
                idLIst = teamMembrs.get(mobTeam.Deal__c);
                idList.add(mobTeam.Primary_Lead__r.user__c);
                if(mobTeam.Secondary_Lead_1__c <> null){
                    idList.add(mobTeam.Secondary_Lead_1__r.user__c);
                }
                if(mobTeam.Secondary_Lead_2__c <> null){
                    idList.add(mobTeam.Secondary_Lead_2__r.user__c);
                }
                if (sObjectName != UtilConstants.DEAL_SHARE){
                    idList.add(mobTeam.Deal__r.Ownerid);
                    }
                teamMembrs.put(mobTeam.Deal__c, idList);
            }
            else{
                
                idList.add(mobTeam.Primary_Lead__r.user__c);
                if(mobTeam.Secondary_Lead_1__c <> null){
                    idList.add(mobTeam.Secondary_Lead_1__r.user__c);
                }
                if(mobTeam.Secondary_Lead_2__c <> null){
                    idList.add(mobTeam.Secondary_Lead_2__r.user__c);
                }
                if (sObjectName != UtilConstants.DEAL_SHARE){
                    idList.add(mobTeam.Deal__r.Ownerid);
                    }
                teamMembrs.put(mobTeam.Deal__c, idList);
                }    
            }
        }
        ////system.debug('teamMembrs ' + teamMembrs);
        ////system.debug('parentDealMap ' + parentDealMap);
        sharelist = new List<UserList>();
        for(String parentId : parentDealMap.KeySet()){
            Id DealId = parentDealMap.get(parentId);
            if(teamMembrs.containsKey(DealId)  && teamMembrs.get(DealId) <> null && teamMembrs.get(DealId).size() > 0){
                for(String mbr : teamMembrs.get(DealId)){
                    UserList  u =new UserList();
                    u.parentId = parentId;
                    u.userId = mbr;
                    u.dealId = DealId;
                    u.accessLevel = UtilConstants.EDIT_STRING;
                    u.rowCause = UtilConstants.MANUAL_STRING;
                    shareList.add(u);
                    }                     
            }
            
        }
        
        ////system.debug('finalUserList----->>>>' + shareList);
        ////system.debug('sObjectName----->>>>' + sObjectName);
        Set <UserList> setlist = new Set < UserList > (shareList);
        shareList = new List < UserList > (setlist);
        shareRecordCnt = shareRecordCnt + shareList.size();
        //creatSharingRecords(shareList, sObjectName);
        
        //Manas Future code
        if(shareRecordCnt <=3000){
            creatSharingRecords(shareList, sObjectName);
        }else{
        
            Map<Id,String> recId_usrIds = new Map<Id,String>();
            Integer cnt = 0;
            for(UserList usrl :shareList){
                cnt++;
                if(recId_usrIds.get(usrl.parentId) != null){
                    String str = recId_usrIds.get(usrl.parentId) + UtilConstants.SOQL_STRING15+usrl.userId;
                    recId_usrIds.put(usrl.parentId,str);
                }else{
                    recId_usrIds.put(usrl.parentId,usrl.userId);
                }
                if(cnt == 3000){
                    UAMSWBMWBUtilityFuture.createSharings(recId_usrIds,sObjectName);
                    cnt = 0;
                    recId_usrIds.clear();
                }
            }
            if(recId_usrIds !=null){
                UAMSWBMWBUtilityFuture.createSharings(recId_usrIds,sObjectName);
            }
            shareRecordCnt =0;
        }
        //Manas Future code ends
       
    }
    /**
   *  @Description : 
   *  @name : creatSharingRecords
   *  @param :List < UserList > finalUserList 
   *  @param :String sObjectName
   *  @return parameter - void
   *  @throws exception- NA
   */
    Public void creatSharingRecords(List < UserList > finalUserList, String sObjectName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
        sObject obj;
        //////system.debug('finalUserList---creatSharingRecords-->>>>'+finalUserList);
        List < sObject > shareList = new List < sObject > ();
        try{
        for (UserList tmpUser: finalUserList) {
            obj = targetType.newSObject();
            obj.put(UtilConstants.PARENTID, tmpUser.parentId);
            obj.put(UtilConstants.USER_GROUPID, tmpUser.userId);
            obj.put(UtilConstants.ACCESS_LEVEL, tmpUser.accessLevel);
            obj.put(UtilConstants.ROW_CAUSE, tmpUser.rowCause);
            shareList.add(obj);
            ////system.debug('shareList--->>>>' + obj);
        }

        shareList.sort();
        ////system.debug('shareList--->>>>'+shareList);   
        Database.SaveResult[] dealShareInsertResult = Database.insert(shareList, false);
        //insert shareList;
        
        for (Database.saveResult uresult: dealShareInsertResult ) {
                if (uresult.isSuccess()) {
                    ////system.debug('Inserted Records::::::::::::::::::::' + uresult);
                } else {
                    ////system.debug('failed Records::::::::' + uresult.getErrors());
                }
         }       
        }Catch(DMLException e) {   
            ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
    /*Code developed by Manas for future share calls not required*/
    public void createSharings(Map<Id,String> custUsrMap, String sObjectName){
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
        sObject obj;
        //////system.debug('finalUserList---creatSharingRecords-->>>>'+finalUserList);
        List < sObject > shareList = new List < sObject > ();
        for(Id prtId: custUsrMap.keySet()){
            List<String> Sharevalues = custUsrMap.get(prtId).split('<:>');
            if(Sharevalues.size() == 3){
                obj = targetType.newSObject();
                obj.put(UtilConstants.PARENTID, prtId);
                obj.put(UtilConstants.USER_GROUPID, Sharevalues[0]);
                obj.put(UtilConstants.ACCESS_LEVEL, Sharevalues[1]);
                obj.put(UtilConstants.ROW_CAUSE, Sharevalues[2]);
                shareList.add(obj);
                ////system.debug('shareList--->>>>' + obj);
            }
        }
        shareList.sort();
        ////system.debug('shareList--->>>>'+shareList);   
        Database.SaveResult[] dealShareInsertResult = Database.insert(shareList, false);
    }
    //END

    /* ============================================================= */
    /*****************************
        @description : method to delete share record for users deleted from mob team
        ******************** Method Not Used******
    *****************************/
    public void CheckAccessDealShareDelete(List < Mobilization_Team__c > lstOldDealTeam) {
        Set < Id > userMasterIds = new Set < Id > ();
        Set < Id > roleIds = new Set < Id > ();
        Set < String > dealIds = new Set < String > ();
        Set < Id > roleIdsToDelete = new Set < Id > ();
        set < id > mobteamids = new set < id > ();
        Set < String > primUserAssignedSet = new set < String > ();
        Set < String > sendUserAssignedSet1 = new set < String > ();
        Set < String > sendUserAssignedSet2 = new set < String > ();
        List < Mobilization_plan__c > mobplanlist = new List < Mobilization_plan__c > ();
        List < wave__c > wavelist = new List < wave__c > ();
        set < id > sratLvel1TrackerList = new set < id > ();
        set < id > opexLvel1TrackerList = new set < id > ();
        set < id > procWaveSet = new set < id > ();
        try {
            for (Mobilization_Team__c mOldTeam: lstOldDealTeam) {
                mobteamids.add(mOldTeam.id);
                dealIds.add(mOldTeam.Deal__c);
                userMasterIds.add(mOldTeam.Primary_Lead__c);
                userMasterIds.add(mOldTeam.Secondary_Lead_1__c);
                userMasterIds.add(mOldTeam.Secondary_Lead_2__c);
            }
            ////system.debug('::::::Mobteam records:::::' + mobteamids);

            for (User_Master__c userMasterList: [Select user__c from User_Master__c where Id in : userMasterIds limit 500]) {
                roleIds.add(userMasterList.user__c);
            }
            mobplanlist = [select id from Mobilization_plan__c where deal__c IN: dealids Limit 5000];
            if (!mobplanlist.isEmpty()) {
                for (wave__c wave: [select id, (select id FROM Procurement_Wave_Regions__r) 
                                    FROM wave__c where mobilization_plan__c IN: mobplanlist LIMIT 2500]) {
                    for (Procurement_Wave_Region__c proc: wave.Procurement_Wave_Regions__r) {
                        procWaveSet.add(proc.id);
                    }
                }
                for (Srat_tracker__c srat: [select id, (select id from SRAT_Additional_Tracking_Level_1__r)
                from Srat_tracker__c where Mobilization_Plan__c IN: mobplanlist LIMIT 2500]) {
                    for (SRAT_Additional_Tracking_Level_1__c sratlevel1: srat.SRAT_Additional_Tracking_Level_1__r) {
                        sratLvel1TrackerList.add(sratlevel1.id);
                    }
                }
                for (Opex_Tracker__c opex: [select id, (select id from Deal_OPEX_Additional_Tracking_Lev_del__r)
                from opex_tracker__c where Mobilization_Plan__c IN: mobplanlist LIMIT 2500]) {
                    for (Deal_OPEX_Additional_Tracking_Level_1__c opexlevel1: opex.Deal_OPEX_Additional_Tracking_Lev_del__r) {
                        opexLvel1TrackerList.add(opexlevel1.id);
                    }
                }
            }

            Set < ID > riskPIds = new Set < ID > ();
            Set < ID > actionPIds = new Set < ID > ();
            Set < ID > issuePIds = new Set < ID > ();
            Set < ID > decisionPIds = new Set < ID > ();

            for (Deal__c raidList: [Select id, (SELECT id from RAID_Risks__r), 
                                        (SELECT id from RAID_Decisions__r), (Select id from RAID_Actions__r), 
                                        (SELECT id from RAID_Issues__r) FROM Deal__c WHERE id in : dealids LIMIT 2500]) {
                for (Risks__c ris: raidList.RAID_Risks__r) {
                    riskPIds.add(ris.id);
                }
                for (Action__c act: raidList.RAID_Actions__r) {
                    actionPIds.add(act.id);
                }
                for (Issues__c iss: raidList.RAID_Issues__r) {
                    issuePIds.add(iss.id);
                }
                for (Decision__c dec: raidList.RAID_Decisions__r) {
                    decisionPIds.add(dec.id);
                }
            }

            for (Id tmpId: roleIds) {
                if (tmpId != null) {
                    if (primUserAssignedSet.contains(tmpId) || sendUserAssignedSet1.contains(tmpId) || 
                        sendUserAssignedSet2.contains(tmpId)) {
                        roleIdsToDelete.remove(tmpId);
                    } else {
                        roleIdsToDelete.add(tmpId);
                    }
                }
            }
            List < sobject > listtodelete = new List < sobject > ();

            List < Deal__Share > lstDealSharedelete = [Select ParentId, UserOrGroupId FROM Deal__Share 
                                                        where ParentId IN: dealIds 
                                                            AND UserOrGroupId IN: roleIdsToDelete 
                                                            AND RowCause = :UtilConstants.MANUAL_STRING Limit 5000];
            listtodelete.addAll((List < sObject > )(lstDealSharedelete));

            if (!sratLvel1TrackerList.isEmpty()) {
                lIST < SRAT_Additional_Tracking_Level_1__share > lstSratsharedelete = [Select ParentId, UserOrGroupId 
                from SRAT_Additional_Tracking_Level_1__share
                 where ParentId IN: sratLvel1TrackerList AND UserOrGroupId IN: roleIdsToDelete 
                 AND RowCause = : UtilConstants.MANUAL_STRING Limit 5000];
                listtodelete.addAll((List < sObject > )(lstSratsharedelete));
            }

            if (!opexLvel1TrackerList.isEmpty()) {
                lIST < Deal_OPEX_Additional_Tracking_Level_1__share > lstopexsharedelete = [Select ParentId, UserOrGroupId 
                from Deal_OPEX_Additional_Tracking_Level_1__share 
                where ParentId IN: opexLvel1TrackerList AND UserOrGroupId IN: roleIdsToDelete 
                AND RowCause = : UtilConstants.MANUAL_STRING Limit 5000];
                listtodelete.addAll((List < sObject > )(lstopexsharedelete));
            }

            if (!riskPIds.isEmpty()) {
                lIST < Risks__Share > lstRiskSharedelete = [Select ParentId, UserOrGroupId from Risks__Share 
                where ParentId IN: riskPIds AND UserOrGroupId IN: roleIdsToDelete AND RowCause = : UtilConstants.MANUAL_STRING Limit 5000];
                listtodelete.addAll((List < sObject > )(lstRiskSharedelete));
            }

            if (!actionPIds.isEmpty()) {
                lIST < Action__Share > lstACtionSharedelete = [Select ParentId, UserOrGroupId 
                from Action__Share where ParentId IN: actionPIds AND UserOrGroupId IN: roleIdsToDelete 
                AND RowCause = : UtilConstants.MANUAL_STRING Limit 5000];
                listtodelete.addAll((List < sObject > )(lstACtionSharedelete));
            }

            if (!issuePIds.isEmpty()) {
                lIST < Issues__Share > lstIssueSharedelete = [Select ParentId, UserOrGroupId 
                from Issues__Share where ParentId IN: issuePIds AND UserOrGroupId IN: roleIdsToDelete 
                AND RowCause = : UtilConstants.MANUAL_STRING Limit 5000];
                listtodelete.addAll((List < sObject > )(lstIssueSharedelete));
            }

            if (!decisionPIds.isEmpty()) {
                lIST < Decision__Share > lstDecisionSharedelete = [Select ParentId, UserOrGroupId 
                from Decision__Share where ParentId IN: decisionPIds AND UserOrGroupId IN: roleIdsToDelete 
                AND RowCause = : UtilConstants.MANUAL_STRING];
                listtodelete.addAll((List < sObject > )(lstDecisionSharedelete));
            }
            if (!procWaveSet.isEmpty()) {
                lIST < Procurement_Wave_Region__share > lstProcurementWaveSharedelete = [Select ParentId, UserOrGroupId 
                from Procurement_Wave_Region__share where ParentId IN: procWaveSet AND UserOrGroupId IN: roleIdsToDelete 
                AND RowCause = : UtilConstants.MANUAL_STRING];
                listtodelete.addAll((List < sObject > )(lstProcurementWaveSharedelete));
            }

            //Perform your DML operation here
            Database.DeleteResult[] dealshareDelete_result = database.delete(listtodelete, false);
        } catch (Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            ////system.debug('Exception from main class' + e);
        }
    }
    /*================= Update logic===========================*/
    /***************************************************/
    /**
   *  @Description : 
   *  @name : CheckAccessDealShareUpdate
   *  @param :List < Mobilization_Team__c > newMoblist
   *  @param :Map < id, Mobilization_Team__c > oldMobMap
   *  @return parameter - void
   *  @throws exception- Exception Handling
   ***** Method Not Used ************
   */
    public void CheckAccessDealShareUpdate(List < Mobilization_Team__c > newMoblist, Map < id, Mobilization_Team__c > oldMobMap) {
        set < id > alluseridsupdated = new set < id > ();
        set < id > dealids = new set < id > ();
        set < id > listafterduplicate = new set < id > ();
        map < id, id > existingteamMap = new map < id, id > ();
        set < id > mobteamids = new set < id > ();
        Map<Id,Id> mobilizationWithDeal=new Map<Id,Id>();
        set<Id> usersToDeleteShareAccess=new set<Id>();
        set<Id> userId = new set<Id>();
       try {
           
       
        
        for (Mobilization_Team__c mob: [Select Id, Name, Deal__c, Role__c, Primary_Lead__c, Primary_Lead__r.user__c, Secondary_Lead_1__c,
                                        Secondary_Lead_1__r.user__c, Secondary_Lead_2__c, Secondary_Lead_2__r.user__c
                                        FROM Mobilization_Team__c where ID IN: newMoblist limit 2500]) {
            dealids.add(mob.deal__c);
            mobteamids.add(mob.id);
            if (oldMobMap.get(mob.id).Primary_lead__c != mob.primary_lead__c && mob.primary_lead__c != null) {
                if(!userId.contains(oldMobMap.get(mob.id).Primary_lead__c)){
                    usersToDeleteShareAccess.add(oldMobMap.get(mob.id).Primary_lead__c);
                }else{
                    usersToDeleteShareAccess.remove(oldMobMap.get(mob.id).Primary_lead__c);
                }
                alluseridsupdated.add(mob.Primary_lead__r.user__c);
                
            }
            if (oldMobMap.get(mob.id).Secondary_Lead_1__c != mob.Secondary_Lead_1__c && mob.Secondary_Lead_1__c != null) {
                if(!userId.contains(oldMobMap.get(mob.id).Secondary_Lead_1__c)){
                    usersToDeleteShareAccess.add(oldMobMap.get(mob.id).Secondary_Lead_1__c);
                }
                else{
                    usersToDeleteShareAccess.remove(oldMobMap.get(mob.id).Secondary_Lead_1__c);
                }
                
                alluseridsupdated.add(mob.Secondary_Lead_1__r.user__c);
            }
            if (oldMobMap.get(mob.id).Secondary_Lead_2__c != mob.Secondary_Lead_2__c && mob.Secondary_Lead_2__c != null) {
                if(!userId.contains(oldMobMap.get(mob.id).Secondary_Lead_2__c)){
                    usersToDeleteShareAccess.add(oldMobMap.get(mob.id).Secondary_Lead_2__c);
                }
                else{
                    usersToDeleteShareAccess.remove(oldMobMap.get(mob.id).Secondary_Lead_2__c);
                }
                alluseridsupdated.add(mob.Secondary_Lead_2__r.user__c);
            }
            userId.add(oldMobMap.get(mob.id).Primary_lead__c);
            userId.add(oldMobMap.get(mob.id).Secondary_Lead_1__c);
            userId.add(oldMobMap.get(mob.id).Secondary_Lead_2__c);
        }
        Set < ID > riskPIds = new Set < ID > ();
        Set < ID > actionPIds = new Set < ID > ();
        Set < ID > issuePIds = new Set < ID > ();
        Set < ID > decisionPIds = new Set < ID > ();
        set < id > procwaveSet = new set < id > ();
        List < Mobilization_plan__c > mobplanlist = new List < Mobilization_plan__c > ();
        set < id > sratLvel1TrackerIds = new set < id > ();
        set < id > opexLvel1TrackerIds = new set < id > ();
        for (Deal__c raidList: [Select id, (Select id from RAID_Risks__r), (select id from RAID_Decisions__r), 
                            (Select id from RAID_Actions__r), (Select id from RAID_Issues__r) 
                            from Deal__c where id in : dealids Limit 5000]) {
            for (Risks__c ris: raidList.RAID_Risks__r) {
                riskPIds.add(ris.id);
            }
            for (Action__c act: raidList.RAID_Actions__r) {
                actionPIds.add(act.id);
            }
            for (Issues__c iss: raidList.RAID_Issues__r) {
                issuePIds.add(iss.id);
            }
            for (Decision__c dec: raidList.RAID_Decisions__r) {
                decisionPIds.add(dec.id);
            }
        }
        mobplanlist = [select id from Mobilization_plan__c where deal__c IN: dealids Limit 5000];
        if (!mobplanlist.isEmpty()) {
            for (Srat_tracker__c srat: [select id, (select id from SRAT_Additional_Tracking_Level_1__r)
            from Srat_tracker__c where Mobilization_Plan__c IN: mobplanlist LIMIT 2500]) {
                for (SRAT_Additional_Tracking_Level_1__c sratlevel1: srat.SRAT_Additional_Tracking_Level_1__r) {
                    sratLvel1TrackerIds.add(sratlevel1.id);
                }
            }
            for (Opex_Tracker__c opex: [select id, (select id from Deal_OPEX_Additional_Tracking_Lev_del__r)
                                        FROM opex_tracker__c where Mobilization_Plan__c IN: mobplanlist LIMIT 2500]) {
                for (Deal_OPEX_Additional_Tracking_Level_1__c opexlevel1: opex.Deal_OPEX_Additional_Tracking_Lev_del__r) {
                    opexLvel1TrackerIds.add(opexlevel1.id);
                }
            }
            for (wave__c wave: [select id, (select id from Procurement_Wave_Regions__r) from wave__c where 
            mobilization_plan__c IN: mobplanlist limit 2500]) {
                for (Procurement_Wave_Region__c proc: wave.Procurement_Wave_Regions__r) {
                    procwaveSet.add(proc.id);
                }
            }
        }

        ////system.debug('user records:::::::::' + alluseridsupdated);

        UAMSWBMWBUtilityFuture.updateShareRecords(dealids, alluseridsupdated,usersToDeleteShareAccess, UtilConstants.DEAL_SHARE);
        updateShareRecords(mobteamids, alluseridsupdated, UtilConstants.MOB_TEAM_SHARE);
        updateShareRecords(riskPIds, alluseridsupdated, UtilConstants.RISK_SHARE);
        updateShareRecords(actionPIds, alluseridsupdated, UtilConstants.ACTION_SHARE);
        updateShareRecords(issuePIds, alluseridsupdated, UtilConstants.ISSUES_SHARE);
        updateShareRecords(decisionPIds, alluseridsupdated, UtilConstants.DECISION_SHARE);
        updateShareRecords(sratLvel1TrackerIds, alluseridsupdated, UtilConstants.SRAT_LEVEL1_SHARE);
        updateShareRecords(opexLvel1TrackerIds, alluseridsupdated, UtilConstants.OPEX_LEVEL1_SHARE);
        updateShareRecords(procwaveSet, alluseridsupdated, UtilConstants.PROCUREMENT_WAVE_REGION_SHARE);
        }Catch(DMLException e) {  
             ////system.debug('Error!!' + e);
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
    /**
   *  @Description : 
   *  @name : updateShareRecords
   *  @param :set <id> parentids, set <id> userids, string sobjectName
   *  @return parameter - void
   *  @throws exception- Execption handling
   **** Method Not Used *******
   */
    public void updateShareRecords(set < id > parentids, set < id > userids, string sobjectName) {
        try {
            list < sobject > updateRecords = new List < sobject > ();

            list < sobject > getshareRecords = database.query(UtilConstants.SELECT_STAT + sobjectName + UtilConstants.QUERY_PART2);
            List < Database.deleteResult > performdelete = Database.delete(getshareRecords, false);
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
            sObject obj;
            if (parentids.size() > userids.size()) {
                for (id pid: parentids) {
                    for (id userid: userids) { 
                        obj = targetType.newSObject();
                        obj.put(UtilConstants.USER_GROUPID, userId);
                        obj.put(UtilConstants.PARENTID, pid);
                        obj.put(UtilConstants.ACCESS_LEVEL, UtilConstants.EDIT_STRING);
                        obj.put(UtilConstants.ROW_CAUSE, UtilConstants.MANUAL_STRING);
                        updateRecords.add(obj);
                    }
                }
            } else {
                for (id userid: userids) {
                    for (id pid: parentids) {
                        obj = targetType.newSObject();
                        obj.put(UtilConstants.USER_GROUPID, userId);
                        obj.put(UtilConstants.PARENTID, pid);
                        obj.put(UtilConstants.ACCESS_LEVEL, UtilConstants.EDIT_STRING);
                        obj.put(UtilConstants.ROW_CAUSE, UtilConstants.MANUAL_STRING);
                        updateRecords.add(obj);
                    }
                }
            }
            List < Database.saveResult > performUpdate = database.insert(updateRecords, false);
            ////system.debug('updated final list::::::' + performUpdate);
            for (Database.saveResult uresult: performUpdate) {
                if (uresult.isSuccess()) {
                    ////system.debug('updated Records::::::::::::::::::::' + uresult);
                } else {
                    ////system.debug('failed Records::::::::' + uresult.getErrors());
                }
            }
        } catch (Exception e) {
             ////system.debug('Error!!' + e);
            e.getMessage();
        }
    }
    // Users and corresponding access rights
    with sharing class UserList {
        Id userId;
        String accessLevel;
        String dealId;
        String parentId;
        String rowCause;
    }
    
    public static void updateMobTeamWithShare(List<Mobilization_team__c> mobilizationTeamList,Map<Id,Mobilization_team__c> oldMobMap){
        set<Id> dealId=new set<Id>();
        Map<Id,set<Id>> dealWithMobMap=new Map<Id,set<Id>>();
        Map<Id,Id> dumMap=new Map<Id,Id>();
        Map<Id,Id> dumMapOne=new Map<Id,Id>();
        dealWithMobMap=getMobTeam(mobilizationTeamList);
        
        set<Id> mobPlan=new set<id>();
        set<Id> sratId=new set<Id>();
        Map<Id,Id> sratWithMobPlan=new Map<Id,id>();
        Map<Id,Id> mobWithDeal=new Map<Id,Id>();
        
         set<Id> opexId=new set<Id>();
        Map<Id,Id> opexWithMobPlan=new Map<Id,id>();
        
        Map<Id,Id> waveWithMob=new Map<Id,Id>();
        
        set<Id> waveId=new set<Id>();
        
        for(Mobilization_team__C mobTeam:mobilizationTeamList){
            dealId.add(mobTeam.Deal__c);
        }
        Boolean flag=false;
        for(Mobilization_team__c mobteam:[select id,Primary_Lead__c,Secondary_Lead_1__c,Primary_Lead__r.user__C,Secondary_Lead_2__c,
        Secondary_Lead_1__r.user__c,Secondary_Lead_2__r.user__c,deal__C from Mobilization_team__c where Id in:mobilizationTeamList limit 10000]){
                if(mobteam.Primary_Lead__c!=oldMobMap.get(mobteam.id).Primary_Lead__c){
                   flag=true;
                }
                if(mobteam.Secondary_Lead_1__c!=oldMobMap.get(mobteam.id).Secondary_Lead_1__c){
                   flag=true;
                }
                if(mobteam.Secondary_Lead_2__c!=oldMobMap.get(mobteam.id).Secondary_Lead_2__c){
                   flag=true;
                }
        }

        for(Mobilization_plan__C mp:[select id,deal__c from Mobilization_plan__C where Deal__C IN :dealId limit 10000]){
            mobPlan.add(mp.id);
            mobWithDeal.put(mp.id,mp.deal__c);
        }
        
        
        
        for(Srat_tracker__c srat:[select id,Mobilization_plan__C from Srat_tracker__c where Mobilization_Plan__c IN:mobPlan limit 10000]){
            sratId.add(srat.id);
            sratWithMobPlan.put(srat.id,srat.Mobilization_plan__C);
        }
         for(OPEX_Tracker__c opex:[select id,mobilization_plan__c from OPEX_Tracker__c where Mobilization_Plan__c IN :mobPlan limit 10000]){
            opexId.add(opex.id);
            opexWithMobPlan.put(opex.id,opex.Mobilization_Plan__c);
        } 
        for(Wave__c wave:[select id,mobilization_plan__c from wave__C where mobilization_plan__c IN:mobPlan limit 10000]){
            waveId.add(wave.id);
            waveWithMob.put(wave.id,wave.mobilization_plan__c);
        }
        String query='select id,ownerId from Deal__c where Id IN:dealId';
        String dealFlag=UtilConstants.DEAL_SHARE;
        if(!flag){
            Id batchId=database.executeBatch(new MobilizationTeamSharing(dealId,query,dealWithMobMap,dealFlag,sratWithMobPlan,
            mobWithDeal,sratId,opexWithMobPlan,opexId,waveId,waveWithMob)); 
        }
        
    }
    
    
    
       
    public static Map<Id,set<Id>> getMobTeam(List<Mobilization_team__c> mobilizationTeamList){
        Map<Id,set<Id>> dealWithMobTeam=new Map<Id,Set<Id>>();
        set<Id> userIdset=new set<Id>();
        set<Id> dealId=new set<Id>();
        for(Mobilization_team__c mobTeam:mobilizationTeamList){
            dealId.add(mobTeam.deal__c);
            dealWithMobTeam.put(mobTeam.deal__c,userIdset);
        }
        for(Mobilization_team__C mobilization:[select id,Primary_Lead__r.user__C,Primary_Lead__r.user__r.isActive,
        Secondary_Lead_1__r.user__c,Secondary_Lead_1__r.user__r.isActive,Secondary_Lead_2__r.user__c,Secondary_Lead_2__r.user__r.isActive,
        deal__C from Mobilization_team__c where deal__c in:dealId limit 10000]){
             
             
             if(dealWithMobTeam.containsKey(mobilization.deal__c)){
                 userIdset=dealWithMobTeam.get(mobilization.deal__c);
                 if(mobilization.Primary_Lead__r.user__r.isActive){
                    userIdset.add(mobilization.Primary_Lead__r.user__C);    
                 }
                 
                 if(!String.isEmpty(mobilization.Secondary_Lead_1__r.user__c) && mobilization.Secondary_Lead_1__r.user__r.isActive){
                     userIdset.add(mobilization.Secondary_Lead_1__r.user__c);
                 }
                 if(!String.isEmpty(mobilization.Secondary_Lead_2__r.user__c) && mobilization.Secondary_Lead_2__r.user__r.isActive){
                    userIdset.add(mobilization.Secondary_Lead_2__r.user__c);
                 }
                 dealWithMobTeam.put(mobilization.deal__C,userIdset);
             }else{
                 userIdset=new set<Id>();
                 if(mobilization.Primary_Lead__r.user__r.isActive){
                    userIdset.add(mobilization.Primary_Lead__r.user__C);    
                 }
                 
                 if(!String.isEmpty(mobilization.Secondary_Lead_1__r.user__c) && mobilization.Secondary_Lead_1__r.user__r.isActive){
                     userIdset.add(mobilization.Secondary_Lead_1__r.user__c);
                 }
                 if(!String.isEmpty(mobilization.Secondary_Lead_2__r.user__c) && mobilization.Secondary_Lead_2__r.user__r.isActive){
                    userIdset.add(mobilization.Secondary_Lead_2__r.user__c);
                 }
                 dealWithMobTeam.put(mobilization.deal__C,userIdset);
             }
                
        }
        return dealWithMobTeam;
        
    }
    
    public void shareOnUpdate(List<Mobilization_team__c> mobilizationList,Map<Id,Mobilization_team__c> oldMobMap, Boolean FlagToDelete){
        set<Id> newMobSet=new set<Id>();
        set<Id> oldMobSet=new set<Id>();
        Map<id,set<Id>> mobWitDeal=new Map<Id,set<Id>>();
        Map<Id,set<Id>> dealWithAllMob=new Map<Id,set<Id>>();
        Map<Id,set<Id>> finalDealWithMob=new Map<Id,set<Id>>();
        Map<Id,set<Id>> oldMobPlan=new Map<Id,set<Id>>();
        set<Id> olduser=new set<Id>();
        Map<Id,Id> userMasterMap=new Map<Id,Id>();
        Map<Id,set<Id>> finalPlanTodelet=new Map<id,set<Id>>();
        set<Id> dealSetId=new set<Id>();
        
        Map<Id,Id> sratWithMobPlan=new Map<Id,id>();
        Map<Id,Id> mobWithDeal=new Map<Id,Id>();
        
        Map<Id,Id> opexWithMobPlan=new Map<Id,id>();
        Map<Id,Id> mobWithOpexDeal=new Map<Id,Id>();
        
        set<Id> mobPlan=new set<id>();
        set<Id> sratId=new set<Id>();
        set<Id> opexId=new set<Id>();
        Map<Id,Id> waveWithMob=new Map<Id,Id>();
        
        set<Id> waveId=new set<Id>();
        
        for(User_master__c userMaster:[select id,user__c from user_master__c limit 10000]){
            userMasterMap.put(userMaster.id,userMaster.user__c);
        }
        if(!FlagToDelete)
        {
        for(Mobilization_team__c mobteam:[select id,Primary_Lead__c,Secondary_Lead_1__c,Primary_Lead__r.user__C,Secondary_Lead_2__c,
        Secondary_Lead_1__r.user__c,Secondary_Lead_2__r.user__c,deal__C from Mobilization_team__c where Id in:mobilizationList limit 10000]){
            ////system.debug('Alpha came here');
            dealSetId.add(mobTeam.deal__c);
            if(mobWitDeal.containsKey(mobteam.deal__c)){
                newMobSet=mobWitDeal.get(mobteam.deal__c);
            }else{
                ////system.debug('will enter here for set');
                newMobSet=new set<Id>();
            }
            if(oldMobPlan.containsKey(mobTeam.Deal__c)){
                oldMobSet=oldMobPlan.get(mobTeam.deal__c);
            }else{
                oldMobSet=new set<Id>();
            }
            
            if(mobteam.Primary_Lead__c!=oldMobMap.get(mobteam.id).Primary_Lead__c){
                ////system.debug('Primary lead got changes');
                newMobSet.add(mobteam.Primary_Lead__r.user__c);
                Id userId=userMasterMap.get(oldMobMap.get(mobteam.id).Primary_Lead__c);
                oldMobSet.add(userId);
            }
            if(mobteam.Secondary_Lead_1__c!=oldMobMap.get(mobteam.id).Secondary_Lead_1__c){
                if(mobteam.Secondary_Lead_1__c!=null){
                    newMobSet.add(mobteam.Secondary_Lead_1__r.user__c);    
                }
                Id userIdTwo=userMasterMap.get(oldMobMap.get(mobteam.id).Secondary_Lead_1__c);
                oldMobSet.add(userIdTwo);
            }
            if(mobteam.Secondary_Lead_2__c!=oldMobMap.get(mobteam.id).Secondary_Lead_2__c){
                if(mobteam.Secondary_Lead_2__c!=null){
                    newMobSet.add(mobteam.Secondary_Lead_2__r.user__c);    
                }
                Id userIdThree=userMasterMap.get(oldMobMap.get(mobteam.id).Secondary_Lead_2__c);
                oldMobSet.add(userIdThree);
            }
            if(newMobSet!=null && !newMobSet.isEmpty()){
                mobWitDeal.put(mobteam.deal__c,newMobSet);    
            }
            if(oldMobSet!=null && !oldMobSet.isEmpty()){
                oldMobPlan.put(mobTeam.deal__c,oldMobSet);    
            }
            
        }
        }
        
        if(FlagToDelete)
        {
        for(Mobilization_team__c mobTeam: mobilizationList)
        {
            dealSetId.add(mobTeam.deal__c);
             if(oldMobPlan.containsKey(mobTeam.Deal__c)){
                oldMobSet=oldMobPlan.get(mobTeam.deal__c);
            }else{
                oldMobSet=new set<Id>();
            }
            oldMobSet.add(userMasterMap.get(mobTeam.Primary_Lead__c));
            
              if(mobteam.Secondary_Lead_1__c!=null){
                  oldMobSet.add(userMasterMap.get(mobTeam.Secondary_Lead_1__c)); 
              }
               if(mobteam.Secondary_Lead_2__c!=null){
                   oldMobSet.add(userMasterMap.get(mobTeam.Secondary_Lead_2__c));
                }
            oldMobPlan.put(mobTeam.deal__c,oldMobSet);
            
        }
        }
        
        dealWithAllMob=getMobteam(mobilizationList);
        set<Id> userGroupId=new set<Id>();
        for(Id dealId: dealWithAllMob.keySet()){
            set<Id> mobTeamToDelete=oldMobPlan.get(dealId);
            ////system.debug('MObTeamToDelete ' + mobTeamToDelete);
            set<Id> mobTeamOld=dealWithAllMob.get(dealId);
            if(mobTeamToDelete <> null){
                if(mobTeamToDelete.removeAll(mobTeamOld)){
                    if(mobTeamToDelete!=null && !mobTeamToDelete.isEmpty()){
                        finalPlanTodelet.put(dealId,mobTeamToDelete);
                        userGroupId.addAll(mobTeamToDelete);
                    }
                    
                }else{
                    finalPlanTodelet.put(dealId,mobTeamToDelete);
                    userGroupId.addAll(mobTeamToDelete);
                }    
            }
        }
        
        for(Mobilization_plan__C mp:[select id,deal__c from Mobilization_plan__C where Deal__C IN :dealSetId limit 10000]){
            mobPlan.add(mp.id);
            
            mobWithDeal.put(mp.id,mp.deal__c);
        }
        for(Srat_tracker__c srat:[select id,Mobilization_plan__C from Srat_tracker__c where Mobilization_Plan__c IN:mobPlan limit 10000]){
            sratId.add(srat.id);
            sratWithMobPlan.put(srat.id,srat.Mobilization_plan__C);
        }
        for(OPEX_Tracker__c opex:[select id,mobilization_plan__c from OPEX_Tracker__c where Mobilization_Plan__c IN :mobPlan limit 10000]){
            opexId.add(opex.id);
            opexWithMobPlan.put(opex.id,opex.Mobilization_Plan__c);
        } 
        for(Wave__c wave:[select id,mobilization_plan__c from wave__C where mobilization_plan__c IN:mobPlan limit 10000]){
            waveId.add(wave.id);
            waveWithMob.put(wave.id,wave.mobilization_plan__c);
        }
        String dealquery='select id,ownerId from Deal__c where Id IN:dealId';
        String dealFlag=UtilConstants.DEAL_SHARE;
        set<Id> tempAlpha=mobWitDeal.keySet();
        if(tempAlpha!=null && !tempAlpha.isEmpty()){
            Id batchMobId=database.executeBatch(new MobilizationTeamSharing(dealSetId,dealquery,mobWitDeal,dealFlag,sratWithMobPlan,mobWithDeal,
            sratId,opexWithMobPlan,opexId,waveId,waveWithMob));
        }
        
        
        set<Id> sratLevel=new set<Id>();
        Map<Id,set<Id>> sratWithDeal=new Map<Id,set<Id>>();
        set<Id> temp=new set<Id>();
        Map<Id,Id> sLevel=new Map<Id,Id>();
        set<Id> sratLevelOneId=new set<Id>();
        for(SRAT_Additional_Tracking_Level_1__c sratLl:[select id,SRAT_Tracker__c from SRAT_Additional_Tracking_Level_1__c where 
        SRAT_Tracker__c IN :sratId limit 10000]){
            Id mPId=sratWithMobPlan.get(sratLl.SRAT_Tracker__c);
            Id dealId=mobWithDeal.get(mPId);
            sLevel.put(sratLl.id,dealid);
            sratLevelOneId.add(sratLl.id);
        }
        
        set<Id> opexLevel=new set<Id>();
        Map<Id,Id> opexWithDeal=new Map<Id,Id>();
        
        set<Id> tempOne=new set<Id>();
        set<Id> rId=new set<Id>();
        set<Id> iId=new set<Id>();
        set<Id> aId=new set<Id>();
        set<Id> dId=new set<Id>();
        Map<Id,Id> rMap=new Map<Id,Id>();
        Map<Id,Id> iMap=new Map<Id,Id>();
        Map<Id,Id> aMap=new Map<Id,Id>();
        Map<Id,Id> dMap=new Map<Id,Id>();
        Map<Id,Id> mTeamMap=new Map<Id,Id>();
        set<Id> mTeamId=new set<Id>();
        Map<Id,Id> procMap=new Map<Id,Id>();
        set<Id> procId=new set<Id>();
        
        for(Mobilization_team__c mobTeam:[select id,deal__c from Mobilization_team__C where Deal__c IN:dealSetId limit 10000]){
            mTeamMap.put(mobTeam.id,mobTeam.deal__c);
            mTeamId.add(mobTeam.id);
        }
        for(Procurement_Wave_Region__c proc:[select id,wave__C from Procurement_Wave_Region__c where wave__c IN:waveId limit 10000]){
            Id wId=proc.wave__c;
            Id mId=waveWithMob.get(wId);
            Id dOneId=mobWithDeal.get(mId);
            procMap.put(proc.id,dOneId);
            procId.add(proc.id);
        }
        for(Risks__c risk:[select id,deal__C from Risks__c where Deal__C IN:dealSetId limit 10000]){
            rId.add(risk.id);
            rMap.put(risk.id,risk.Deal__c);
        }
         
        for(Issues__c issue:[select id,deal__C from Issues__c where Deal__C IN:dealSetId limit 10000]){
            iId.add(issue.id);
            iMap.put(issue.id,issue.Deal__c);
        }
         
        for(Decision__c decision:[select id,deal__C from Decision__c where Deal__C IN:dealSetId limit 10000]){
            dId.add(decision.id);
            dMap.put(decision.id,decision.Deal__c);
        }
         
        for(Action__c action:[select id,deal__C from Action__c where Deal__C IN:dealSetId limit 10000]){
            aId.add(action.id);
            aMap.put(action.id,action.Deal__c);
        }
        for(Deal_OPEX_Additional_Tracking_Level_1__c opexLl:[select id,OPEX_Tracker_del__c from Deal_OPEX_Additional_Tracking_Level_1__c 
        where OPEX_Tracker_del__c IN:opexId limit 10000]){
            Id mp1Id=opexWithMobPlan.get(opexLl.OPEX_Tracker_del__c);
            Id dealId=mobWithDeal.get(mp1Id);
            opexLevel.add(opexLl.id);
            opexWithDeal.put(opexLl.id,dealId);
            
        }
        String dealDeleteQuery='select id,userorgroupid,parentid,rowcause from Deal__Share where parentid IN:dealId AND userorgroupId in:userId';
        String dealDeleteFlag= UtilConstants.DEAL_SHARE;
        ////system.debug('dealDeleteQuery ' + dealDeleteQuery);
        ////system.debug('finalPlanTodelet = ' + finalPlanTodelet);
        set<id> tempBeta=finalPlanTodelet.keySet();
        if(tempBeta!=null && !tempBeta.isEmpty()){
            Id dealDeleteId=database.executeBatch(new MobilizationSharingDelete(userGroupId,dealDeleteQuery,dealDeleteFlag,finalPlanTodelet,
            dealSetId,sratLevelOneId,sLevel,rId,rMap,iId,iMap,aId,aMap,dId,dMap,opexLevel,opexWithDeal,procId,procMap,mTeamId,mTeamMap));      
        }
        
    }
    
}