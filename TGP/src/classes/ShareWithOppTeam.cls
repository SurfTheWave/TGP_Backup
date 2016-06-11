/******************************
    Class Name: initializeData
    Description: 
    Created By : IO Solution Editor ,  1/16/2015 8:07 AM
    *******************************/ 
public without sharing class ShareWithOppTeam {
       public static Map<Id,Id> TeamMember;
    // Share records with team member for new approval stage
     /******************************
    Method Name: newStage
    Description: shares approval stage with opp team member
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void newClientDep(List<Opportunity_Client_Dependency__c> cdlist){
    
    try{
        Set<Id> oppid = new Set<Id>();
        Set<Id> oppteamid=new Set<Id>();
        Set<ID> clientDepid=new Set<ID>();
        for(Opportunity_Client_Dependency__c cdRec : cdlist){
            oppid.add(cdRec.Opportunity__c);
            clientDepid.add(cdRec.id);
        }
        List<Opportunity_Client_Dependency__Share> sharesToCreate = new List<Opportunity_Client_Dependency__Share>();
        List<Opportunity_Teams__c> oppteamlist=[Select Opportunity_Team_Member__c,Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.isActive from Opportunity_Teams__c where Opportunity__c IN:oppid Limit 5000];
        if(!oppteamlist.isEmpty()){
        Opportunity_Client_Dependency__Share cs;
        for(Opportunity_Client_Dependency__c cDRec : cdlist){
            
            for(Opportunity_Teams__c opp : oppteamlist)
            {
                if(opp.Opportunity_Team_Member__r.user__c != null && opp.Opportunity_Team_Member__r.user__r.isActive==true){
               system.debug('-opp.Opportunity_Team_Member__r.user__c------'+opp.Opportunity_Team_Member__r.user__c);
                system.debug('-cDRec .id-------'+cDRec .id);
                Boolean bool= [select HasEditAccess,RecordId from userRecordAccess where UserId =: opp.Opportunity_Team_Member__r.user__c AND RecordId =: cDRec.id Limit 5000].HasEditAccess;
                    if(bool==false){
                    cs = new Opportunity_Client_Dependency__Share();
                    cs.AccessLevel = UtilConstants.EDIT;
                    cs.ParentId = cDRec.id;
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
          system.debug('E==='+e);
      }
    }
    
     public static void newAssmp(List<Opportunity_Assumption__c> assmplist){
    
    try{
        Set<Id> oppid = new Set<Id>();
        Set<Id> oppteamid=new Set<Id>();
        Set<ID> assmpid=new Set<ID>();
        for(Opportunity_Assumption__c assmpRec : assmplist){
            oppid.add(assmpRec.Opportunity__c);
            assmpid.add(assmpRec.id);
        }
        List<Opportunity_Assumption__Share> sharesToCreate = new List<Opportunity_Assumption__Share>();
        List<Opportunity_Teams__c> oppteamlist=[Select Opportunity_Team_Member__c,Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.isActive from Opportunity_Teams__c where Opportunity__c IN:oppid Limit 5000];
        if(!oppteamlist.isEmpty()){
        Opportunity_Assumption__Share cs;
        for(Opportunity_Assumption__c assmpRec : assmplist){
            
            for(Opportunity_Teams__c opp : oppteamlist)
            {
                if(opp.Opportunity_Team_Member__r.user__c != null && opp.Opportunity_Team_Member__r.user__r.isActive==true){
               system.debug('-opp.Opportunity_Team_Member__r.user__c------'+opp.Opportunity_Team_Member__r.user__c);
                system.debug('-assmpRec.id-------'+assmpRec.id);
                Boolean bool= [select HasEditAccess,RecordId from userRecordAccess where UserId =: opp.Opportunity_Team_Member__r.user__c AND RecordId =: assmpRec.id Limit 5000].HasEditAccess;
                    if(bool==false){
                    cs = new Opportunity_Assumption__Share();
                    cs.AccessLevel = UtilConstants.EDIT;
                    cs.ParentId = assmpRec.id;
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
          system.debug('E==='+e);
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
        for(Opportunity_Teams__c oppTeamRec : oppteamlist){
            oppid.add(oppTeamRec.opportunity__c);
            oppteamid.add(oppTeamRec.id);
            system.debug('Set size is--->' +oppid.size() + 'and the id is' + oppTeamRec.opportunity__c);
        }
        Opportunity_Client_Dependency__Share cs;
        List<Opportunity_Teams__c> oppteamRec=[Select id,Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.isActive from Opportunity_Teams__c where id in:oppteamid Limit 5000];
        List<Opportunity_Client_Dependency__Share> sharesToCreate = new List<Opportunity_Client_Dependency__Share>();
        List<Opportunity_Client_Dependency__c> cdlist=[Select id from Opportunity_Client_Dependency__c where Opportunity__c IN:oppid Limit 5000];
        if(!oppteamRec.isEmpty() && !cdlist.isEmpty()){
            for(Opportunity_Teams__c opp : oppteamRec){
                for(Opportunity_Client_Dependency__c cdRecord : cdlist){
                    if(opp.Opportunity_Team_Member__r.user__c != null && opp.Opportunity_Team_Member__r.user__r.isActive==true){
                        boolean bool=UserRecordAccess.getHasEditAccess(opp.Opportunity_Team_Member__r.user__c,cdRecord.id);
                        System.debug('----Boolean value---'+bool);
                        if(!bool){
                        cs = new Opportunity_Client_Dependency__Share();
                        cs.AccessLevel = UtilConstants.EDIT;
                        cs.ParentId = cdRecord.id;
                        cs.UserOrGroupId =opp.Opportunity_Team_Member__r.user__c;
                        cs.rowcause='Manual';
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
    
    public static void teammemberAssmp(List<Opportunity_Teams__c> oppteamlist){
        Set<Id> oppid = new Set<Id>();
        Set<Id> oppteamid=new Set<Id>();
        for(Opportunity_Teams__c oppTeamRec : oppteamlist){
            oppid.add(oppTeamRec.opportunity__c);
            oppteamid.add(oppTeamRec.id);
            system.debug('Set size is--->' +oppid.size() + 'and the id is' + oppTeamRec.opportunity__c);
        }
        Opportunity_Assumption__Share cs;
        List<Opportunity_Teams__c> oppteamRec=[Select id,Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.isActive from Opportunity_Teams__c where id in:oppteamid Limit 5000];
        List<Opportunity_Assumption__Share> sharesToCreate = new List<Opportunity_Assumption__Share>();
        List<Opportunity_Assumption__c> assmplist=[Select id from Opportunity_Assumption__c where Opportunity__c IN:oppid Limit 5000];
        if(!oppteamRec.isEmpty() && !assmplist.isEmpty()){
            for(Opportunity_Teams__c opp : oppteamRec){
                for(Opportunity_Assumption__c assmpRecord : assmplist){
                    if(opp.Opportunity_Team_Member__r.user__c != null && opp.Opportunity_Team_Member__r.user__r.isActive==true){
                        boolean bool=UserRecordAccess.getHasEditAccess(opp.Opportunity_Team_Member__r.user__c,assmpRecord.id);
                        System.debug('----Boolean value---'+bool);
                        if(!bool){
                        cs = new Opportunity_Assumption__Share();
                        cs.AccessLevel = UtilConstants.EDIT;
                        cs.ParentId = assmpRecord.id;
                        cs.UserOrGroupId =opp.Opportunity_Team_Member__r.user__c;
                        cs.rowcause='Manual';
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
        List<Opportunity_Client_Dependency__Share> sharesToDelete;
        Set<Id> oppteamid=new Set<Id>();
        Set<Id> oppid = new Set<Id>();
        Set<ID> cd = new Set<ID>();
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
        List<Opportunity_Client_Dependency__Share> sharesToCreate = new List<Opportunity_Client_Dependency__Share>();
        List<Opportunity_Client_Dependency__c> stagelist=[Select id from Opportunity_Client_Dependency__c  where Opportunity__c IN:oppid Limit 5000];
        for(Opportunity_Client_Dependency__c s : stagelist){
            cd.add(s.id);
        }
        
        if(!oppteamlist.isEmpty() && !stagelist.isEmpty()){
            for(Opportunity_Teams__c opp : oppteamlist){
             if(teamusermasterrecord.get(opp.Opportunity_Team_Member__c)!=null ){
                 for(Opportunity_Client_Dependency__c cdRec : stagelist){
                    shareIdsToDelete.add(cdRec.id);
                    shareuserids.add(teamusermasterrecord.get(opp.Opportunity_Team_Member__c));
                   
                   }
         
                }
                
            
        }
       if(!shareIdsToDelete.isEmpty()){
           sharesToDelete=[select id,UserOrGroupId  from Opportunity_Client_Dependency__Share where ParentId IN :shareIdsToDelete AND UserOrGroupId IN :shareuserids Limit 5000 ];
           system.debug('-sharesToDelete-------'+sharesToDelete);
           database.delete(sharesToDelete,true);
        }
        
        
    } 
    }
    
    Catch(DMLException e) {
        system.debug('-----e-----'+e);
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          
        }
    }
    
    public static void restrictShareAssmp(List<Opportunity_Teams__c> oppteamlist,List<Opportunity_Teams__c> oppteamlistnew){
        system.debug('oppteamlist'+oppteamlist);
        List<ID> shareIdsToDelete = new List<ID>();
        List<ID> shareuserids=new List<ID>();
        List<Opportunity_Assumption__Share> sharesToDelete;
        Set<Id> oppteamid=new Set<Id>();
        Set<Id> oppid = new Set<Id>();
        Set<ID> cd = new Set<ID>();
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
        List<Opportunity_Assumption__Share> sharesToCreate = new List<Opportunity_Assumption__Share>();
        List<Opportunity_Assumption__c> stagelist=[Select id from Opportunity_Assumption__c where Opportunity__c IN:oppid Limit 5000];
        for(Opportunity_Assumption__c s : stagelist){
            cd.add(s.id);
        }
        
        if(!oppteamlist.isEmpty() && !stagelist.isEmpty()){
            for(Opportunity_Teams__c opp : oppteamlist){
             if(teamusermasterrecord.get(opp.Opportunity_Team_Member__c)!=null ){
                 for(Opportunity_Assumption__c cdRec : stagelist){
                    shareIdsToDelete.add(cdRec.id);
                    shareuserids.add(teamusermasterrecord.get(opp.Opportunity_Team_Member__c));
                   
                   }
         
                }
                
            
        }
       if(!shareIdsToDelete.isEmpty()){
           sharesToDelete=[select id,UserOrGroupId  from Opportunity_Assumption__Share where ParentId IN :shareIdsToDelete AND UserOrGroupId IN :shareuserids Limit 5000 ];
           system.debug('-sharesToDelete-------'+sharesToDelete);
           database.delete(sharesToDelete,true);
        }
        
        
    } 
    }
    
    Catch(DMLException e) {
        system.debug('-----e-----'+e);
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          
        }
    }
}