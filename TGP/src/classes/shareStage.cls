/*
@Author :  
@name : ShareStage
@CreateDate :    3/3/2015 5:27 AM
@Description : 
@Version : 
*/
public without sharing class shareStage {
/*
@Author :  
@name : ShareStage
@CreateDate :    3/3/2015 5:27 AM
@Description : 
@Version : 
*/
    public static final String CONFIDENTIALOPPSHARE_METHOD = 'confidentialOppShare';
    public static final String SHARESTAGE = 'shareStage';
    public static final String CONFIDENTIALOPPSHAREACTIONITEM_METHOD = 'confidentialOppShareonActionItem';
    
    public static void share(List<approval_request__c> rlist){
    try{
       //System.Debug('********ShareStage  starts *********');
        Set<Id> reqids=new Set<Id>();
        Set<Id> approverids =new Set<ID>();
        Id approverid;
        //List<UserRecordAccess> userAccess =new List<UserRecordAccess>();
        UserRecordAccess userAccess;
        for(Approval_Request__c req:rlist){
            reqids.add(req.id);
        }
        boolean bool;
        List<Approval_Stage__Share> sharesToCreate = new List<Approval_Stage__Share>();
        List<Approval_Stage__Share> sharesToUpdate = new List<Approval_Stage__Share>();
        List<approval_request__c> apReqRec = [Select id,approval_request_status__c,approval_sent_date__c,approval_stage__c,approver__c,
            approver__r.user__c,approver__r.user__r.Isactive from approval_request__c where id IN :reqids Limit 5000];
        for(Approval_Request__c req:apReqRec){
            //system.debug(' req.approver__r.user__c req.approver__r.user__c'+ req.approver__r.user__c);
            if(req.approver__r.user__r.Isactive==true){
            bool=UserRecordAccess.getHasEditAccess(req.approver__r.user__c,req.id);
            if(req.approval_sent_date__c==date.today() && bool==false ){
              Approval_Stage__Share cs = new Approval_Stage__Share();
              cs.AccessLevel = UtilConstants.EDIT_VALUE;
              cs.ParentId = req.approval_stage__c;
              cs.UserOrGroupId =  req.approver__r.user__c;
              sharesToCreate.add(cs);
            }
           }
        }
        if (!sharesToCreate.isEmpty()){
            //system.debug('=========================sharesToCreatenew'+sharesToCreate);
            database.insert(sharesToCreate,false);
        }
        
      //System.Debug('********ShareStage  ends *********');
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
  }
  
/*
@Author :  
@name : ShareStage
@CreateDate :    3/3/2015 5:27 AM
@Description : 
@Version : 
*/
        public static void restrictShare(List<approval_request__c> rlist){
        try{
        Set<Id> reqids=new Set<Id>();
        Set<Id> approverids =new Set<ID>();
        Set<ID> oppid=new set<id>();
        UserRecordAccess userAccess;
        for(Approval_Request__c req:rlist){
            reqids.add(req.id);
            oppid.add(req.opp_dev__c);
        }
        List<Opportunity_Teams__c> oppteamRec=[Select id,Opportunity_Team_Member__r.user__c 
                from Opportunity_Teams__c where Opportunity__c in:oppid Limit 5000];
            Map<ID,ID> oppteam=new map<id,id>();
            for(Opportunity_Teams__c oteam:oppteamRec){
                oppteam.put(oteam.Opportunity_Team_Member__r.user__c,oteam.id);
            }
        boolean bool;
        List<ID> shareIdsToDelete = new List<ID>();
        List<ID> shareuserids=new List<ID>();
        List<Approval_Stage__Share> sharesToDelete;
        List<approval_request__c> apReqRec = [Select id,approval_request_status__c,approval_sent_date__c,approval_stage__c,
        approver__c,approver__r.user__c,approver__r.user__r.Isactive from approval_request__c where id IN :reqids Limit 5000];
        for(Approval_Request__c req:apReqRec){
            if((req.approval_sent_date__c!= null)&&(req.approval_request_status__c.Equals(UtilConstants.PEND_WITH_REQSTR)||req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.APPRVD)|| req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.REJ) || req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.REWORK1)||req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.READYREV))){
                if(!oppteam.containsKey(req.approver__r.user__c)){
               shareIdsToDelete.add(req.approval_stage__c);
                shareuserids.add(req.approver__r.user__c);
                }
            }       
        }
        if(!shareIdsToDelete.isEmpty()){
             sharesToDelete=[select id from Approval_Stage__Share where Approval_Stage__Share.ParentId IN :shareIdsToDelete AND
                  Approval_Stage__Share.UserOrGroupId IN :shareuserids Limit 5000 ];
             //system.debug('=========================sharesToDelete'+sharesToDelete.size());
             //system.debug('=========================sharesToDelete'+sharesToDelete);
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
@name : ShareStage
@CreateDate :    3/3/2015 5:27 AM
@Description : 
@Version : 
*/
  public static void ShareStageWithPrimaryOwner(List<Action_Item__c> alist){
    Set<Id> actid =new Set<Id>();
  try{
    for(Action_Item__c act :alist){
        actid.add(act.id);
    }
    List<Approval_Stage__Share> sharesToCreate = new List<Approval_Stage__Share>();
    List<Action_Item__c> actionRec=[Select Primary_owner__r.user__c,Primary_owner__c,Primary_owner__r.user__r.Isactive,
            approval_stage__c from Action_Item__c where id in:actid Limit 5000]; 
    for(Action_Item__c act:actionRec){
        if(act.Primary_owner__r.user__r.Isactive==true){
            boolean bool;
            bool=UserRecordAccess.getHasEditAccess(act.Primary_owner__r.user__c,act.id);
            if(bool==false){
              Id pownerid=UtilUser.UtilUser(act.Primary_Owner__c);
              Approval_Stage__Share cs = new Approval_Stage__Share();
              cs.AccessLevel = UtilConstants.EDIT_VALUE ;
              cs.ParentId = act.approval_stage__c;
              cs.UserOrGroupId =  act.Primary_owner__r.user__c;
              sharesToCreate.add(cs);
            }
        }
    }
    if (!sharesToCreate.isEmpty()){
            //system.debug('=========================sharesToCreatenew'+sharesToCreate);
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
@name : ShareStage
@CreateDate :    3/3/2015 5:27 AM
@Description : 
@Version : 
*/
    public static void restrictShareForPrimaryOwner(List<Action_Item__c> alist){
     try{   
        Set<Id> reqids=new Set<Id>();
        Set<String> oppid=new set<String>();
        UserRecordAccess userAccess;
        for(Action_Item__c req:alist){
            reqids.add(req.id);
            oppid.add(req.Opportunity__c);
        }
        List<Opportunity_Teams__c> oppteamRec=[Select id,Opportunity_Team_Member__r.user__c,Opportunity__r.name
            from Opportunity_Teams__c where Opportunity__r.name in:oppid Limit 5000];
            Map<ID,ID> oppteam=new map<id,id>();
            for(Opportunity_Teams__c oteam:oppteamRec){
                oppteam.put(oteam.Opportunity_Team_Member__r.user__c,oteam.id);
            }
        boolean bool;
        List<ID> shareIdsToDelete = new List<ID>();
        List<ID> shareuserids=new List<ID>();
        List<Approval_Stage__Share> sharesToDelete;
        List<Action_Item__c> apReqRec = [SELECT Id, approval_stage__c, Primary_Owner__c,Primary_Owner__r.user__c, 
               action_item_status__c, Opportunity__c FROM Action_Item__c where id IN :reqids Limit 5000];
        for(Action_Item__c req:apReqRec){
            if((req.action_item_status__c.Equals(UtilConstants.COMPLETED))){
                if(!oppteam.containsKey(req.Primary_Owner__r.user__c)){
                shareIdsToDelete.add(req.approval_stage__c);
                shareuserids.add(req.Primary_Owner__r.user__c);
                }
            }   
        }
        if(!shareIdsToDelete.isEmpty()){
             sharesToDelete=[select id from Approval_Stage__Share where Approval_Stage__Share.ParentId IN :shareIdsToDelete AND
                              Approval_Stage__Share.UserOrGroupId IN :shareuserids Limit 5000 ];
             //system.debug('=========================sharesToDelete'+sharesToDelete.size());
             //system.debug('=========================sharesToDelete'+sharesToDelete);
            database.delete(sharesToDelete,false);
        }
       }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
    } 
    
     public static void confidentialOppShare(List<approval_request__c> alist){

         List<ID> aID = new List<ID>();
         List<ID> oppID = new List<ID>();
         Set<ID> oppUserID;
         MAP<ID,set<id>> oppMAP = new MAP<ID,set<id>>();
         list < OpportunityShare > oppShareRecList = new list < OpportunityShare > ();
         
         for(approval_request__c apReq : alist){
             aID.add(apReq.id);
             oppID.add(apReq.Opportunity_Id_Dev__c);
         }
         
         
         for(OpportunityShare oppSharelist : [SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause 
                                                FROM OpportunityShare where OpportunityId IN : oppID]){
         
            if(oppMAP.get(oppSharelist.OpportunityId) != null){
                
                oppMAP.get(oppSharelist.OpportunityId).add(oppSharelist.UserOrGroupId);
            }
            else{
            
                    oppUserID = new Set<ID>();
                    oppUserID.add(oppSharelist.UserOrGroupId);
                    oppMAP.put(oppSharelist.OpportunityId,oppUserID);
            }
         }
         
         List<approval_request__c> apReqRec = [Select id,approval_request_status__c,Opportunity_Id_Dev__c,approval_sent_date__c,approval_stage__c,
                                                Approval_Stage__r.Opportunity__r.Confidential_Opp__c ,
                                                approver__c,approver__r.user__c,approver__r.user__r.Isactive from approval_request__c 
                                                where id IN : aID Limit 5000];           
    
            for(approval_request__c a : apReqRec){
            
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
             insert oppShareRecList;
         }
         catch(DMLException e){
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
            SHARESTAGE, CONFIDENTIALOPPSHARE_METHOD , null, System.Logginglevel.ERROR);
            
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
         }
     }
     public static void confidentialOppShareonActionItem(List<action_item__c > alist){
     
          
         List<ID> aID = new List<ID>();
         list < OpportunityShare > oppShareRecList = new list < OpportunityShare > ();
         Set < Id > userMasterIds = new Set < Id > ();
         List<ID> oppID = new List<ID>();
         Set<ID> oppUserID;
         MAP<ID,set<id>> oppMAP = new MAP<ID,set<id>>();
         
         for(action_item__c apReq : alist){
             aId.add(apReq.id);
         }
         
         list<action_item__c> appReqList = [Select Primary_owner__r.user__c,Primary_owner__c,Primary_owner__r.user__r.Isactive,
                                            approval_stage__c,approval_stage__r.Opportunity__c,approval_stage__r.Opportunity__r.Confidential_Opp__c from Action_Item__c where id in:aId Limit 5000]; 
                                            
         for(action_item__c actionItemRec : appReqList){
            oppID.add(actionItemRec.approval_stage__r.Opportunity__c);
         }
         for(OpportunityShare oppSharelist : [SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause 
                                                FROM OpportunityShare where OpportunityId IN : oppID]){
         
            if(oppMAP.get(oppSharelist.OpportunityId) != null){
                
                oppMAP.get(oppSharelist.OpportunityId).add(oppSharelist.UserOrGroupId);
            }
            else{
            
                    oppUserID = new Set<ID>();
                    oppUserID.add(oppSharelist.UserOrGroupId);
                    oppMAP.put(oppSharelist.OpportunityId,oppUserID);
            }
         }
         
                 
         
         for(action_item__c actionItemRec : appReqList){
              
                set<id> userListId = oppMAP.get(actionItemRec.Approval_Stage__r.Opportunity__c);
                if(!oppMAP.get(actionItemRec.Approval_Stage__r.Opportunity__c).contains(actionItemRec.Primary_owner__r.user__c)){

                    if(actionItemRec.approval_stage__r.Opportunity__r.Confidential_Opp__c == true && actionItemRec.Primary_owner__r.user__r.Isactive == true){
                             
                                OpportunityShare oppShareRec = new OpportunityShare();
                                oppShareRec.OpportunityId = actionItemRec.approval_stage__r.Opportunity__c;
                                oppShareRec.UserOrGroupId = actionItemRec.Primary_owner__r.user__c;
                                oppShareRec.OpportunityAccessLevel = UTIL_Constants.READ;
                                oppShareRec.RowCause = UtilConstants.MANUAL;
                                oppShareRecList.add(oppShareRec);
                         
                    }
                }
         }
         try{
             insert oppShareRecList;
         }
         catch(DMLException e){
             UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
            SHARESTAGE, CONFIDENTIALOPPSHAREACTIONITEM_METHOD , null, System.Logginglevel.ERROR);
            
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
         }
     }
}