/**
   @Author         : Reena Thakre
   @name           : operationOncapabilityInvController
   @CreateDate     : 28 july 2015
   @Description    : TriggerHandler Class for triggers capability Involvement object
   @Version        : 1.0
  */
public  class operationOncapabilityInvController{
       
       
    /* this method calls the method that assigns the permissionset to the user for edit access on current object.*/
    
    
    public static void shareRecordsToCapabilityLead(List<Capability_Involvement__c> capabilityList){
        List<id> usermasterList=new List<id>();
        list<id> oppteamID=new List<id>();
        system.debug('>>>capabilityList>>'+capabilityList.size());
        
        for(Capability_Involvement__c capability :capabilityList){
        oppteamID.add(capability.user__C);
        system.debug('>>>capabilityList>>'+capabilityList+'>>capability.Team_Member_Id_Dev__c>>'+capability.Team_Member_Id_Dev__c);
        }
        
        //for(opportunity_teams__C teammember:[select Opportunity_Team_Member__c, id,name from opportunity_teams__C where Opportunity_Team_Member__c in :oppteamID limit 1000])
        //{       
       // usermasterList.add(teammember.Opportunity_Team_Member__c);
       // }       
        permissionsetAssignment(oppteamID);
        
    }
    /* this method add the permission set on the user */
    @future
    private static void permissionsetAssignment(List<id>usermasterList ){
          Id ps=label.Capability_Team_Edit;
        //PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = :UtilConstantsforSWB.CAPABILITY_TEAM_EDIT limit 1];
        list <PermissionSetAssignment> PSAssignments = new list <PermissionSetAssignment>();
         Map<id, id> PermissionsetAMap =new Map<id,id>();
         for(PermissionSetAssignment p:[SELECT AssigneeId ,id FROM PermissionSetAssignment  where PermissionSetId = :ps Limit 5000 ])
         {
         PermissionsetAMap.put(p.AssigneeId,p.id);
         }
        for(User_Master__C master:[select user__c from user_master__C  where id in :usermasterList limit 1000]){
        if(!PermissionsetAMap.containskey(master.user__c)){
        PSAssignments.add( new PermissionSetAssignment(AssigneeId = master.user__c ,PermissionSetId = ps ) );
        //system.debug('.....................U'+master.user__c+'..........................PSAssignments'+PSAssignments+'.............ps.id'+ps.id);
        }
        }
        try{   
         if(!PSAssignments.isEmpty()){
           database.upsert(PSAssignments,true);
        }   
        
      }
      Catch(DMLException e)
      {
          system.debug('-----e-----'+e);
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
         
      }
    }
    
    /* this method calls the method that removes the permissionset from the user once deleted from Opp Team*/
    public static void removePermissionSetAccess(List<Capability_Involvement__c> capabilityList){
        List<id> usermasterList=new List<id>();
        list<id> oppteamID=new List<id>();

        for(Capability_Involvement__c capability :capabilityList){
        oppteamID.add(capability.User__c);
        }
        //for(opportunity_teams__C teammember:[select Opportunity_Team_Member__r.user__c, id,name from opportunity_teams__C where Opportunity_Team_Member__c in :oppteamID limit 1000])
        //{
        //usermasterList.add(teammember.Opportunity_Team_Member__r.user__C);
        //}       
        permissionsetdeletion(oppteamID);
        system.debug('oppteamID...'+oppteamID);
    }
      /* this method remove the permission set on the user */
    @future
    private static void permissionsetdeletion(List<id>usermasterList ){
        ID ps=label.Capability_Team_Edit;
        system.debug('.............................................usermasterList ....'+usermasterList);
        //PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = :UtilConstantsforSWB.CAPABILITY_TEAM_EDIT limit 1];
        List<id> usrid=new List<id>();
        for(User_master__c u:[select user__c from user_master__c where id in:usermasterList limit 5000])
        {
        usrid.add(u.user__c);
        }
        list <PermissionSetAssignment> PSAssignments = new list <PermissionSetAssignment>();
        
        for(PermissionSetAssignment p:[select id from PermissionSetAssignment  where PermissionSetId = :ps and  AssigneeId in :usrid limit 1000]){
        PSAssignments.add(p);
        //system.debug('.............................................PSAssignments'+PSAssignments+'.............ps.id'+ps.id);
        }
         try{   
         if(!PSAssignments.isEmpty()){
           database.delete(PSAssignments,true);
        }   
        
      }
      Catch(DMLException e)
      {
          system.debug('-----e-----'+e);
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
         
      }
    }
    
    
}