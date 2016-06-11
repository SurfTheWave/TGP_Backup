/******************************
    Class Name: initializeData
    Description: 
    Created By : IO Solution Editor ,  1/16/2015 8:07 AM
    *******************************/ 
public without sharing class ShareStageWithOppTeam {
       public static Map<Id,Id> TeamMember;
    // Share records with team member for new approval stage
     /******************************
    Method Name: newStage
    Description: shares approval stage with opp team member
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void newStage(List<Approval_Stage__c> slist){
    
    try{
        Set<Id> oppid = new Set<Id>();
        Set<Id> oppteamid=new Set<Id>();
        Set<ID> stageid=new Set<ID>();
        for(Approval_Stage__c stageRec:slist){
            oppid.add(stageRec.opportunity__c);
            stageid.add(stageRec.id);
        }
        //List<approval_request__c> approvalRequest=[SELECT Approval_Stage__c, Id, Approver__c, approval_request_status__c FROM approval_request__c];
        List<Approval_Stage__Share> sharesToCreate = new List<Approval_Stage__Share>();
        List<Opportunity_Teams__c> oppteamlist=[Select Opportunity_Team_Member__c,Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.isActive from Opportunity_Teams__c where Opportunity__c IN:oppid Limit 5000];
        if(!oppteamlist.isEmpty()){
        Approval_Stage__Share cs;
        for(Approval_Stage__c stageRec:slist){
            
            for(Opportunity_Teams__c opp : oppteamlist)
            {
                if(opp.Opportunity_Team_Member__r.user__c != null && opp.Opportunity_Team_Member__r.user__r.isActive==true){
               system.debug('-opp.Opportunity_Team_Member__r.user__c------'+opp.Opportunity_Team_Member__r.user__c);
                system.debug('-stageRec.id-------'+stageRec.id);
                Boolean bool= [select HasEditAccess,RecordId from userRecordAccess where UserId =: opp.Opportunity_Team_Member__r.user__c AND RecordId =: stageRec.id Limit 5000].HasEditAccess;
                    //boolean bool=UserRecordAccess.getHasEditAccess(opp.Opportunity_Team_Member__r.user__c,stageRec.id);
                     if(bool==false){
                    cs = new Approval_Stage__Share();
                    cs.AccessLevel = UtilConstants.EDIT;
                    cs.ParentId = stageRec.id;
                    cs.UserOrGroupId =opp.Opportunity_Team_Member__r.user__c;
                    sharesToCreate.add(cs);
                    }
                }
            }
        }  } 
        
        if(!sharesToCreate.isEmpty()){
           database.upsert(sharesToCreate,true);
        }   
        
      }
      Catch(DMLException e)
      {
          system.debug('-----e-----'+e);
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
                 system.debug('E==='+e);
      }
    }
    /********************************
    Method Name: newTechStage
    param : List<Tech_Approval_Stage__c> slist
    return type : void
    desription :Shares tech approval stage with opp team(Tech Arch and Supporting Tech Arch)
    ********************************/
    public static void newTechStage(List<Tech_Approval_Stage__c> slist){
    
    try{
        Set<Id> oppid = new Set<Id>();
        Set<Id> oppteamid=new Set<Id>();
        Set<ID> stageid=new Set<ID>();
        for(Tech_Approval_Stage__c stageRec:slist){
            oppid.add(stageRec.opportunity__c);
            stageid.add(stageRec.id);
        }
        List<Tech_Approval_Stage__Share> sharesToCreate = new List<Tech_Approval_Stage__Share>();
        List<Opportunity_Teams__c> oppteamlist=[Select Opportunity_Team_Member__c,Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.isActive from Opportunity_Teams__c where Opportunity__c IN:oppid 
                                                    and (Opportunity_Role_Dev__c=:UtilConstantsR3.SuppTechArch or 
                                                    Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch)Limit 5000];
        if(!oppteamlist.isEmpty()){
        Tech_Approval_Stage__Share tcs;
        for(Tech_Approval_Stage__c stageRec:slist){
            
            for(Opportunity_Teams__c opp : oppteamlist)
            {
                if(opp.Opportunity_Team_Member__r.user__c != null && opp.Opportunity_Team_Member__r.user__r.isActive==true){
                Boolean bool= [select HasEditAccess,RecordId from userRecordAccess where UserId =: opp.Opportunity_Team_Member__r.user__c AND RecordId =: stageRec.id Limit 5000].HasEditAccess;
                   
                     if(bool==false){
                    tcs = new Tech_Approval_Stage__Share();
                    tcs.AccessLevel = UtilConstants.EDIT;
                    tcs.ParentId = stageRec.id;
                    tcs.UserOrGroupId =opp.Opportunity_Team_Member__r.user__c;
                    sharesToCreate.add(tcs);
                    }
                }
            }
        }  } 
        
        if(!sharesToCreate.isEmpty()){
           database.upsert(sharesToCreate,true);
        }   
        
      }
      Catch(DMLException e)
      {
          system.debug('-----e-----'+e);
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
      }
    }
     /******************************
    Method Name: newteammember
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void newteammember(List<Opportunity_Teams__c> oppteamlist){
        Set<Id> oppid = new Set<Id>();
        Set<Id> oppteamid=new Set<Id>();
        for(Opportunity_Teams__c stageRec:oppteamlist){
            oppid.add(stageRec.opportunity__c);
            oppteamid.add(stageRec.id);
        }
         Approval_Stage__Share cs;
        List<Opportunity_Teams__c> oppteamRec=[Select id,Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.isActive from Opportunity_Teams__c where id in:oppteamid Limit 5000];
        List<Approval_Stage__Share> sharesToCreate = new List<Approval_Stage__Share>();
        List<Approval_Stage__c> stagelist=[Select id from Approval_Stage__c where Opportunity__c IN:oppid Limit 5000];
        if(!oppteamRec.isEmpty() && !stagelist.isEmpty()){
            for(Opportunity_Teams__c opp:oppteamRec){
                for(Approval_Stage__c app:stagelist){
                    if(opp.Opportunity_Team_Member__r.user__c != null && opp.Opportunity_Team_Member__r.user__r.isActive==true){
                        boolean bool=UserRecordAccess.getHasEditAccess(opp.Opportunity_Team_Member__r.user__c,app.id);
                    
                        if(bool==false){
                        cs = new Approval_Stage__Share();
                        cs.AccessLevel = UtilConstants.EDIT;
                        cs.ParentId = app.id;
                        cs.UserOrGroupId =opp.Opportunity_Team_Member__r.user__c;
                        sharesToCreate.add(cs);
                        }
                    }
                }
            }
            
            if(!sharesToCreate.isEmpty()){
                try{
                    database.upsert(sharesToCreate,true);
                }
                catch(Exception e){
                    system.debug('-----e-----'+e);
                    String sheetThrowingException = UtilConstants.EMPTY_STRING;
                    sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
                    //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                    //ApexPages.addMessage(myMsg);
                    system.debug('E==='+e);
                }
                
            }
        }
        
        
    }
    
     /******************************
    Method Name: teammember
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
     public static void teammember(List<Opportunity_Teams__c> oppteamlist){
         try{
        TeamMember=new Map<ID,ID>();
        for(Opportunity_Teams__c opp:[Select id,Opportunity_Team_Member__r.user__c from Opportunity_Teams__c where id in:oppteamlist Limit 5000]){
            TeamMember.put(opp.id,opp.Opportunity_Team_Member__r.user__c);
        }
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
    }
    
     /******************************
    Method Name: restrictShareForTeamMember
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void restrictShareForTeamMember(List<Opportunity_Teams__c> oppteamlist,List<Opportunity_Teams__c> oppteamlistnew){
        system.debug('oppteamlist'+oppteamlist);
        List<ID> shareIdsToDelete = new List<ID>();
        List<ID> shareuserids=new List<ID>();
        List<Approval_Stage__Share> sharesToDelete;
        List<Tech_Approval_Stage__Share> techsharesToDelete;
        Set<Id> oppteamid=new Set<Id>();
        Set<Id> oppid = new Set<Id>();
        Set<ID>stage=new Set<ID>();
        Set<ID> teammemberusermaster=new set<id>();
        try{
        for(Opportunity_Teams__c stageRec:oppteamlist){
          for(Opportunity_Teams__c newoppteam:oppteamlistnew){
                if(newoppteam.Opportunity_Team_Member__c!=stageRec.Opportunity_Team_Member__c)
                {
                    oppid.add(stageRec.opportunity__c);
                    oppteamid.add(stageRec.id);
                    teammemberusermaster.add(stageRec.Opportunity_Team_Member__c);   
                    system.debug('teammemberusermaster'+stageRec.Opportunity_Team_Member__c);
                }
            }
        }
        system.debug('teammemberusermaster'+teammemberusermaster);
        List<user_master__c> usermaster=[SELECT Id, Name, User__c FROM User_Master__c where id in:teammemberusermaster Limit 5000];
        Map<id,id>teamusermasterrecord=new map<id,id>();
        for(user_master__c u:usermaster){
            teamusermasterrecord.put(u.id,u.User__c);
           system.debug('teamusermasterrecord'+u.id+'usermaster'+u.User__c);
        }
        List<Opportunity_Teams__c> oppteamRec=[Select id,Opportunity_Team_Member__r.user__c from Opportunity_Teams__c where id in:oppteamid Limit 5000];
        List<Approval_Stage__Share> sharesToCreate = new List<Approval_Stage__Share>();
        List<Approval_Stage__c> stagelist=[Select id from Approval_Stage__c where Opportunity__c IN:oppid Limit 5000];
        for(Approval_Stage__c s:stagelist){
            stage.add(s.id);
        }
        List<Approval_request__c> approvalRequest=[SELECT Id, approval_stage__c, approver__r.user__c,approval_stage__r.Opportunity__c ,
        approval_request_status__c, opp_dev__c FROM approval_request__c where approval_stage__r.Opportunity__c IN:oppid AND approval_request_status__c=: UtilConstants.PEND_APPROV Limit 5000 ];
        Map<Id,Id> approvalRequestApprover =new Map<Id,Id>();
        
            for(Approval_request__c app:approvalRequest){
                approvalRequestApprover.put(app.approver__r.user__c,app.approval_stage__c);
            }
        List<Action_Item__c> actionItemList=[SELECT Id, approval_stage__c, action__c, Primary_Owner__r.user__c, 
                                            action_item_status__c, Opportunity__c FROM Action_Item__c
                                            where approval_stage__c IN:stage AND 
                                            action_item_status__c!=:UtilConstantsforSWB.COMPLETED Limit 5000
                                            ];
        
        Map<ID,ID> actionPrimaryRequest = new Map<ID,ID>();
        for(Action_Item__c act:actionItemList){
            approvalRequestApprover .put(act.Primary_Owner__r.user__c,act.approval_stage__c);
        }
       system.debug('oppteamlist'+oppteamlist.size());
        if(!oppteamlist.isEmpty() && !stagelist.isEmpty()){
        
            
            
            for(Opportunity_Teams__c opp : oppteamlist){
            
           system.debug('opp.Opportunity_Team_Member__c'+opp.Opportunity_Team_Member__c);
           system.debug('opp.teamusermasterrecord'+teamusermasterrecord.get(opp.Opportunity_Team_Member__c));
            
            system.debug('opp.teamusermasterrecord.get(opp.Opportunity_Team_Member__c)---'+teamusermasterrecord.get(opp.Opportunity_Team_Member__c));
            
            system.debug('approvalRequestApprover.keySet()---'+approvalRequestApprover.keySet());
            
                if(teamusermasterrecord.get(opp.Opportunity_Team_Member__c)!=null && (!approvalRequestApprover.containsKey(teamusermasterrecord.get(opp.Opportunity_Team_Member__c)))){
              //if(!TeamMember.get(opp.id).equals(opp.Opportunity_Team_Member__r.user__c)){
              system.debug('in if::::-');
                    for(Approval_Stage__c app:stagelist){
                   system.debug('app--------'+app);
                    shareIdsToDelete.add(app.id);
                    shareuserids.add(teamusermasterrecord.get(opp.Opportunity_Team_Member__c));
                   
                     // }
                   }
         
                }
                
            
        }
        /////////////////////////////////////////
        //List<Tech_Approval_Stage__Share> techsharesToCreate = new List<Tech_Approval_Stage__Share>();
        List<Tech_Approval_Stage__c> techstagelist=[Select id from Tech_Approval_Stage__c where Opportunity__c IN:oppid Limit 5000];
        for(Tech_Approval_Stage__c s:techstagelist){
            stage.add(s.id);
        }
        List<Tech_Approval_request__c> techapprovalRequest=[SELECT Id, approval_stage__c, approver__r.user__c,approval_stage__r.Opportunity__c ,
        approval_request_status__c, Opportunity_Id_Dev__c FROM Tech_approval_request__c where approval_stage__r.Opportunity__c IN:oppid AND approval_request_status__c=: UtilConstants.PEND_APPROV Limit 5000 ];
        Map<Id,Id> techapprovalRequestApprover =new Map<Id,Id>();
        
            for(Tech_Approval_request__c app:techapprovalRequest){
                techapprovalRequestApprover.put(app.approver__r.user__c,app.approval_stage__c);
            }
        List<Tech_Action_Items__c> techactionItemList=[SELECT Id, tech_approval_stage__c, action__c, Primary_Owner__r.user__c, 
                                            action_item_status__c, Opportunity__c FROM Tech_Action_Items__c
                                            where tech_approval_stage__c IN:stage AND 
                                            action_item_status__c!=:UtilConstantsforSWB.COMPLETED Limit 5000
                                            ];
        
        //Map<ID,ID> techactionPrimaryRequest = new Map<ID,ID>();
        for(Tech_Action_Items__c act:techactionItemList){
            approvalRequestApprover.put(act.Primary_Owner__r.user__c,act.tech_approval_stage__c);
        }
        if(!oppteamlist.isEmpty() && !stagelist.isEmpty()){
        
            
            
            for(Opportunity_Teams__c opp : oppteamlist){
            
                if(teamusermasterrecord.get(opp.Opportunity_Team_Member__c)!=null && (!approvalRequestApprover.containsKey(teamusermasterrecord.get(opp.Opportunity_Team_Member__c)))){
                    for(Tech_Approval_Stage__c app:techstagelist){
                    shareIdsToDelete.add(app.id);
                    shareuserids.add(teamusermasterrecord.get(opp.Opportunity_Team_Member__c));
                   }
            }
        /////////////////////////////////////////
        
        if(!shareIdsToDelete.isEmpty()){
           sharesToDelete=[select id,UserOrGroupId  from Approval_Stage__Share where ParentId IN :shareIdsToDelete AND UserOrGroupId IN :shareuserids Limit 5000 ];
           system.debug('-sharesToDelete-------'+sharesToDelete);
           database.delete(sharesToDelete,true);
        }
        
        
    } 
    }
    }
   
}
    Catch(DMLException e) {
        system.debug('-----e-----'+e);
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
    }
}