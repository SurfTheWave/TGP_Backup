/*
@Author :  
@name : ShareTechStage
@CreateDate :    3/3/2015 5:27 AM
@Description : This class creates and deletes sharing records for Tech Approval Stage
@Version : 
*/
public without sharing class shareTechStage {
/*
@Author :  
@name : ShareStage
@CreateDate :    3/3/2015 5:27 AM
@Description : 
@Version : 
*/
    public static final String CONFIDENTIALOPPSHARE_METHOD =UtilConstants.CONF_SHR;
    public static final String SHARESTAGE =UtilConstants.SHRTECH_STAGE;
    public static final String CONFIDENTIALOPPSHAREACTIONITEM_METHOD =UtilConstants.CONFOPP_SHR_ACTIONITEM;
    
    /*

@name : share
@CreateDate :    3/3/2015 5:27 AM
@Description : 
@return type : void
*/
    public static void share(List<Tech_Approval_Request__c> rlist){
    try{
       System.Debug('********ShareStage  starts *********');
        Set<Id> reqids=new Set<Id>();
        Set<Id> approverids =new Set<ID>();
        Id approverid;
        //List<UserRecordAccess> userAccess =new List<UserRecordAccess>();
        UserRecordAccess userAccess;
        for(Tech_Approval_Request__c req:rlist){
            reqids.add(req.id);
        }
        boolean bool;
        List<Tech_Approval_Stage__Share> sharesToCreate = new List<Tech_Approval_Stage__Share>();
        List<Tech_Approval_Stage__Share> sharesToUpdate = new List<Tech_Approval_Stage__Share>();
        List<Tech_Approval_Request__c> apReqRec = [Select id,approval_request_status__c,approval_sent_date__c,Approval_Stage__c,approver__c,
            approver__r.user__c,approver__r.user__r.Isactive from Tech_Approval_Request__c where id IN :reqids Limit 5000];
        for(Tech_Approval_Request__c req:apReqRec){
            system.debug(' req.approver__r.user__c req.approver__r.user__c'+ req.approver__r.user__c);
            if(req.approver__r.user__r.Isactive==true){
            bool=UserRecordAccess.getHasEditAccess(req.approver__r.user__c,req.id);
            if(req.approval_sent_date__c==date.today() && bool==false ){
              Tech_Approval_Stage__Share cs = new Tech_Approval_Stage__Share();
              cs.AccessLevel = UtilConstants.EDIT_VALUE;
              cs.ParentId = req.Approval_Stage__c;
              cs.UserOrGroupId =  req.approver__r.user__c;
              sharesToCreate.add(cs);
            }
           }
        }
        if (!sharesToCreate.isEmpty()){
            system.debug('=========================sharesToCreatenew'+sharesToCreate);
            database.insert(sharesToCreate,false);
        }
        
      System.Debug('********ShareStage  ends *********');
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
  }
  
/*
@Author :  
@name : restrictShare
@CreateDate :    3/3/2015 5:27 AM
@Description : 
@Version : 
*/
        public static void restrictShare(List<Tech_Approval_Request__c> rlist){
        try{
        Set<Id> stageids=new Set<Id>();
        Set<Id> reqids=new Set<Id>();
        Set<Id> approverids =new Set<ID>();
        Set<ID> oppid=new set<id>();
        UserRecordAccess userAccess;
        for(Tech_Approval_Request__c req:rlist){
            reqids.add(req.id);
            oppid.add(req.Opportunity_Id_Dev__c);
            stageids.add(req.approval_stage__c);
        }
        List<Opportunity_Teams__c> oppteamRec=[Select id,Opportunity_Team_Member__r.user__c 
                                                from Opportunity_Teams__c where  Opportunity__c in:oppid and (Opportunity_Role_Dev__c=:UtilConstantsR3.SuppTechArch or 
                                                    Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch) limit 5000];
                                                    
        List<Tech_Action_Items__c> techActionItemRecord=[Select id,Primary_Owner__r.user__c from Tech_Action_Items__c where tech_approval_stage__c in:stageids
                                                            and action_item_status__c!=:UtilConstants.COMPLETED LIMIT 5000];  
        List<Tech_Approval_Request__c> existingAppReq=[Select id,approver__r.user__c from Tech_Approval_Request__c where Approval_Stage__c in: stageids and 
                                                        id not in:reqids and approval_request_status__c=:UtilConstants.PENDING_STATUS ];   
        map<id,id>approvermap=new map<id,id>();    
        for(Tech_Approval_Request__c techAppReQ : existingAppReq){
            approvermap.put(techAppReQ.approver__r.user__c,techAppReQ.id);
        }                                          
        map<id,id>actionpriownermap=new map<id,id>();
        if(!techActionItemRecord.isEmpty()){
            for(Tech_Action_Items__c techRec:techActionItemRecord){
                actionpriownermap.put(techRec.Primary_Owner__r.user__c,techRec.id);
                system.debug('action item status------------------------------------->'+techRec.Primary_Owner__r.user__c+'-----1234-------'+techRec.id);
            }               
        }                       
            Map<ID,ID> oppteam=new map<id,id>();
            for(Opportunity_Teams__c oteam:oppteamRec){
                oppteam.put(oteam.Opportunity_Team_Member__r.user__c,oteam.id);
            }
        boolean bool;
        List<ID> shareIdsToDelete = new List<ID>();
        List<ID> shareuserids=new List<ID>();
        List<Tech_Approval_Stage__Share> sharesToDelete;
        List<Tech_Approval_Request__c> apReqRec = [Select id,approval_request_status__c,approval_sent_date__c,Approval_Stage__c,
        approver__c,approver__r.user__c,approver__r.user__r.Isactive from Tech_Approval_Request__c where id IN :reqids Limit 5000];
        for(Tech_Approval_Request__c req:apReqRec){
            if((req.approval_sent_date__c!= null)&&(req.approval_request_status__c.Equals(UtilConstants.PEND_WITH_REQSTR)
                ||req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.APPRVD)|| 
                    req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.REJ) || 
                    req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.REWORK1)||
                    req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.READYREV))){
                if(!oppteam.containsKey(req.approver__r.user__c) && !actionpriownermap.containsKey(req.approver__r.user__c) && approvermap.isempty()){
                        shareIdsToDelete.add(req.Approval_Stage__c);
                        shareuserids.add(req.approver__r.user__c);
                }
            }       
        }
        if(!shareIdsToDelete.isEmpty()){
             sharesToDelete=[select id from Tech_Approval_Stage__Share where Tech_Approval_Stage__Share.ParentId IN :shareIdsToDelete AND
                  Tech_Approval_Stage__Share.UserOrGroupId IN :shareuserids Limit 5000 ];
             system.debug('=========================sharesToDelete'+sharesToDelete.size());
             system.debug('=========================sharesToDelete'+sharesToDelete);
            database.delete(sharesToDelete,false);
        }
    }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
    }   
    /*
    @Author :  
    @name : ShareStageWithPrimaryOwner
    @CreateDate :    3/3/2015 5:27 AM
    @Description : 
    @Version : 
    */
  public static void ShareStageWithPrimaryOwner(List<Tech_Action_Items__c > alist){
    Set<Id> actid =new Set<Id>();
  try{
    for(Tech_Action_Items__c  act :alist){
        actid.add(act.id);
    }
    List<Tech_Approval_Stage__Share> sharesToCreate = new List<Tech_Approval_Stage__Share>();
    List<Tech_Action_Items__c > actionRec=[Select Primary_owner__r.user__c,Primary_owner__c,Primary_owner__r.user__r.Isactive,
            tech_approval_stage__c from Tech_Action_Items__c  where id in:actid Limit 5000]; 
    for(Tech_Action_Items__c  act:actionRec){
        if(act.Primary_owner__r.user__r.Isactive==true){
            boolean bool;
            bool=UserRecordAccess.getHasEditAccess(act.Primary_owner__r.user__c,act.id);
            if(bool==false){
              Id pownerid=UtilUser.UtilUser(act.Primary_Owner__c);
              Tech_Approval_Stage__Share cs = new Tech_Approval_Stage__Share();
              cs.AccessLevel = UtilConstants.EDIT_VALUE ;
              cs.ParentId = act.tech_approval_stage__c;
              cs.UserOrGroupId =  act.Primary_owner__r.user__c;
              sharesToCreate.add(cs);
            }
        }
    }
    if (!sharesToCreate.isEmpty()){
            system.debug('=========================sharesToCreatenew'+sharesToCreate);
            //upsert sharesToCreate;
            database.insert(sharesToCreate,false);
        }
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
  }
    /*
    @Author :  
    @name : restrictShareForPrimaryOwner
    @CreateDate :    3/3/2015 5:27 AM
    @Description : 
    @Version : 
    */
    public static void restrictShareForPrimaryOwner(List<Tech_Action_Items__c > alist){
     try{   
        Set<Id> reqids=new Set<Id>();
        Set<String> oppid=new set<String>();
        UserRecordAccess userAccess;
        for(Tech_Action_Items__c  req:alist){
            reqids.add(req.id);
            oppid.add(req.Opportunity__c);
        }
        List<Opportunity_Teams__c> oppteamRec=[Select id,Opportunity_Team_Member__r.user__c,Opportunity__r.name
            from Opportunity_Teams__c where Opportunity__r.name in:oppid and (Opportunity_Role_Dev__c=:UtilConstantsR3.SuppTechArch or 
                                                    Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch) LIMIT 5000];
            Map<ID,ID> oppteam=new map<id,id>();
            //for(Opportunity_Teams__c oteam:oppteamRec){
            for(Opportunity_Teams__c oteam:[Select id,Opportunity_Team_Member__r.user__c,Opportunity__r.name
            from Opportunity_Teams__c where Opportunity__r.name in:oppid and (Opportunity_Role_Dev__c=:UtilConstantsR3.SuppTechArch or 
                                                    Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch) LIMIT 5000]){
                oppteam.put(oteam.Opportunity_Team_Member__r.user__c,oteam.id);
            }
        boolean bool;
        List<ID> shareIdsToDelete = new List<ID>();
        List<ID> shareuserids=new List<ID>();
        List<Tech_Approval_Stage__Share> sharesToDelete;
        List<Tech_Action_Items__c > apReqRec = [SELECT Id, tech_approval_stage__c, Primary_Owner__c,Primary_Owner__r.user__c, 
               action_item_status__c, Opportunity__c FROM Tech_Action_Items__c  where id IN :reqids Limit 5000];
        //for(Tech_Action_Items__c  req:apReqRec){
        for(Tech_Action_Items__c  req:[SELECT Id, tech_approval_stage__c, Primary_Owner__c,Primary_Owner__r.user__c, 
               action_item_status__c, Opportunity__c FROM Tech_Action_Items__c  where id IN :reqids Limit 5000]){
            if((req.action_item_status__c.Equals(UtilConstants.COMPLETED))){
                if(!oppteam.containsKey(req.Primary_Owner__r.user__c)){
                shareIdsToDelete.add(req.tech_approval_stage__c);
                shareuserids.add(req.Primary_Owner__r.user__c);
                }
            }   
        }
        if(!shareIdsToDelete.isEmpty()){
             sharesToDelete=[select id from Tech_Approval_Stage__Share where Tech_Approval_Stage__Share.ParentId IN :shareIdsToDelete AND
                              Tech_Approval_Stage__Share.UserOrGroupId IN :shareuserids Limit 5000 ];
             system.debug('=========================sharesToDelete'+sharesToDelete.size());
             system.debug('=========================sharesToDelete'+sharesToDelete);
            database.delete(sharesToDelete,false);
        }
       }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
    } 
    
    /*
    @Author :  
    @name : confidentialOppShare
    @CreateDate :    3/3/2015 5:27 AM
    @Description : 
    @Version : 
    */
     public static void confidentialOppShare(List<Tech_Approval_Request__c> alist){

         List<ID> aID = new List<ID>();
         List<ID> oppID = new List<ID>();
         Set<ID> oppUserID;
         MAP<ID,set<id>> oppMAP = new MAP<ID,set<id>>();
         list < OpportunityShare > oppShareRecList = new list < OpportunityShare > ();
         
         for(Tech_Approval_Request__c apReq : alist){
             aID.add(apReq.id);
             oppID.add(apReq.Opportunity_Id_Dev__c);
         }
         
         
         for(OpportunityShare oppSharelist : [SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause 
                                                FROM OpportunityShare where OpportunityId IN : oppID LIMIT 5000]){
         
            if(oppMAP.get(oppSharelist.OpportunityId) != null){
                
                oppMAP.get(oppSharelist.OpportunityId).add(oppSharelist.UserOrGroupId);
            }
            else{
            
                    oppUserID = new Set<ID>();
                    oppUserID.add(oppSharelist.UserOrGroupId);
                    oppMAP.put(oppSharelist.OpportunityId,oppUserID);
            }
         }
         
         List<Tech_Approval_Request__c> apReqRec = [Select id,approval_request_status__c,Opportunity_Id_Dev__c,
                                                    approval_sent_date__c,Approval_Stage__c,
                                                Approval_Stage__r.Opportunity__r.Confidential_Opp__c ,
                                                approver__c,approver__r.user__c,approver__r.user__r.Isactive 
                                                    from Tech_Approval_Request__c where id IN : aID Limit 5000];           
    
            for(Tech_Approval_Request__c a : apReqRec){
            
                set<id> userListId = oppMAP.get(a.Approval_Stage__r.Opportunity__c);
                if(!oppMAP.get(a.Approval_Stage__r.Opportunity__c).contains(a.approver__r.user__c)){
                    if(a.Approval_Stage__r.Opportunity__r.Confidential_Opp__c == true && a.approver__r.user__r.Isactive == true){
                             
                                OpportunityShare oppShareRec = new OpportunityShare();
                                oppShareRec.OpportunityId = a.Opportunity_Id_Dev__c;
                                oppShareRec.UserOrGroupId = a.approver__r.user__c;
                                oppShareRec.OpportunityAccessLevel = UTIL_Constants.READ;
                                oppShareRec.RowCause = UtilConstants.MANUAL;
                                oppShareRecList.add(oppShareRec);                        
                    }
                }
            }
        
         
         try{
             database.insert(oppShareRecList);
         }
         catch(DMLException e){
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
            SHARESTAGE, CONFIDENTIALOPPSHARE_METHOD , null, System.Logginglevel.ERROR);
            
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
         }
     }
    
      /*
        @Author :  
        @name : confidentialOppShareonActionItem
        @CreateDate :    3/3/2015 5:27 AM
        @Description : 
        @Version : 
      */
     public static void confidentialOppShareonActionItem(List<Tech_Action_Items__c  > alist){
     
          
         List<ID> aID = new List<ID>();
         list < OpportunityShare > oppShareRecList = new list < OpportunityShare > ();
         Set < Id > userMasterIds = new Set < Id > ();
         List<ID> oppID = new List<ID>();
         Set<ID> oppUserID;
         MAP<ID,set<id>> oppMAP = new MAP<ID,set<id>>();
         
         for(Tech_Action_Items__c  apReq : alist){
             aId.add(apReq.id);
         }
         
         list<Tech_Action_Items__c > appReqList = [Select Primary_owner__r.user__c,Primary_owner__c,
                                                   Primary_owner__r.user__r.Isactive,tech_approval_stage__c,
                                                   tech_approval_stage__r.Opportunity__c,
                                                   tech_approval_stage__r.Opportunity__r.Confidential_Opp__c 
                                                   from Tech_Action_Items__c  where id in:aId Limit 5000]; 
                                            
         for(Tech_Action_Items__c  actionItemRec : appReqList){
            oppID.add(actionItemRec.tech_approval_stage__r.Opportunity__c);
         }
         for(OpportunityShare oppSharelist : [SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause 
                                                FROM OpportunityShare where OpportunityId IN : oppID LIMIT 5000]){
         
            if(oppMAP.get(oppSharelist.OpportunityId) != null){
                
                oppMAP.get(oppSharelist.OpportunityId).add(oppSharelist.UserOrGroupId);
            }
            else{
            
                    oppUserID = new Set<ID>();
                    oppUserID.add(oppSharelist.UserOrGroupId);
                    oppMAP.put(oppSharelist.OpportunityId,oppUserID);
            }
         }
         
                 
         
         for(Tech_Action_Items__c  actionItemRec : appReqList){
              
                set<id> userListId = oppMAP.get(actionItemRec.tech_approval_stage__r.Opportunity__c);
                if(!oppMAP.get(actionItemRec.tech_approval_stage__r.Opportunity__c).contains(actionItemRec.Primary_owner__r.user__c)){

                    if(actionItemRec.tech_approval_stage__r.Opportunity__r.Confidential_Opp__c == true 
                       && actionItemRec.Primary_owner__r.user__r.Isactive == true){
                             
                                OpportunityShare oppShareRec = new OpportunityShare();
                                oppShareRec.OpportunityId = actionItemRec.tech_approval_stage__r.Opportunity__c;
                                oppShareRec.UserOrGroupId = actionItemRec.Primary_owner__r.user__c;
                                oppShareRec.OpportunityAccessLevel = UTIL_Constants.READ;
                                oppShareRec.RowCause = UtilConstants.MANUAL;
                                oppShareRecList.add(oppShareRec);
                         
                    }
                }
         }
         try{
             database.insert(oppShareRecList);
         }
         catch(DMLException e){
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
            SHARESTAGE, CONFIDENTIALOPPSHAREACTIONITEM_METHOD , null, System.Logginglevel.ERROR);
            
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
         }
     }
}