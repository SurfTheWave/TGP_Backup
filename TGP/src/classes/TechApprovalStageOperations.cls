/**
   @Author :Apoorva Sharma
   @name   : TechApprovalStageOperations 
   @CreateDate : 25 November 2015 
   @Description : This class is used for performing operations on Tech Approval Stage.
   @Version : 1.0 
  */
public with sharing class TechApprovalStageOperations {
    
    public static Map < Id, String > stagestatus;
    public static Map < Id, String > opp;
    public static Map < Id, String > comments;
    
    /**
     * @description       This method is used to get Tech Approval Stage Version.
     * @param             Tech_Approval_Stage__c appRec, set<Id> oppIds, string ApprovalStageType,List<Tech_Approval_Stage__c> approvalStageList
     * @return            Integer
     * @throws            DML Exception
     */  
    public static integer getVersion(Tech_Approval_Stage__c appRec, set<Id> oppIds, string ApprovalStageType,List<Tech_Approval_Stage__c> approvalStageList){
        integer i;
        String sheetThrowingException = UtilConstants.EMPTY_STRING;
        List<Tech_Approval_Stage__c> approvalstageToUpdate = new List<Tech_Approval_Stage__c>();
        try{
                if(appRec.approval_stage_type__c.EqualsIgnoreCase(UtilConstantsR3.STAGE1_SOL_APPROVAL)){
                     for(Opportunity oppRec : [Select id,(Select id,approval_stage_type__c from Tech_Approval_Stage__r 
                                                where approval_stage_type__c=:ApprovalStageType LIMIT 5000) from Opportunity where id in :oppIds Limit 5000]){
                        i = oppRec.Tech_Approval_Stage__r.size();
                        system.debug('UtilConstantsR3.STAGE1_SOL_APPROVAL--------------->'+i);
                    }           
               }
               if(appRec.approval_stage_type__c.EqualsIgnoreCase(UtilConstantsR3.STAGE2_SOL_APPROVAL)){
                   for(Opportunity oppRec : [Select id,(Select id,approval_stage_type__c from Tech_Approval_Stage__r 
                                            where approval_stage_type__c=:ApprovalStageType LIMIT 5000) from Opportunity where id in :oppIds Limit 5000]){
                       i = oppRec.Tech_Approval_Stage__r.size();
                       system.debug('UtilConstantsR3.STAGE2_SOL_APPROVAL--------------->'+i);
                    }  
               }
               if(appRec.approval_stage_type__c.EqualsIgnoreCase(UtilConstantsR3.STAGE3_SOL_APPROVAL)){
                   for(Opportunity oppRec : [Select id,(Select id,approval_stage_type__c from Tech_Approval_Stage__r where approval_stage_type__c=:ApprovalStageType LIMIT 5000)
                                            from Opportunity where id in :oppIds Limit 5000]){
                           i = oppRec.Tech_Approval_Stage__r.size();
                           system.debug('UtilConstantsR3.STAGE3_SOL_APPROVAL--------------->'+i);
                    }  
               }
               if(appRec.approval_stage_type__c.EqualsIgnoreCase(UtilConstantsR3.FLY_BY_SOL_REVIEW)){
                   for(Opportunity oppRec : [Select id,(Select id,approval_stage_type__c from Tech_Approval_Stage__r 
                                             where approval_stage_type__c=:ApprovalStageType LIMIT 5000) from Opportunity where id in :oppIds Limit 5000]){
                               i = oppRec.Tech_Approval_Stage__r.size();
                               system.debug('UtilConstantsR3.FLY BY--------------->'+i);
                  }  
               }
           
            return i;
         }
         catch(DmlException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
         }       
    }
    
    /**
     * @description       This method is used to reset approval stage version after delete.
     * @param             List<Tech_Approval_Stage__c> approvalStageList
     * @return            Void
     * @throws            DML Exception
     */  
    public static void reSetVersion(List<Tech_Approval_Stage__c> approvalStageList ){
        try{
            List<Tech_Approval_Stage__c> approvalstageToUpdate = new List<Tech_Approval_Stage__c>();
            Set<Id> oppIds = new Set<Id>();
            string approvalstage;
            integer version;
          for(Tech_Approval_Stage__c appStageRec: approvalStageList){
              oppIds.add(appStageRec.Opportunity__c);
          }
          integer i;
          for(Tech_Approval_Stage__c appRec:approvalStageList){
           
                   approvalstage=appRec.approval_stage_type__c;                              
                   i=getVersion(appRec,oppIds,approvalstage,approvalStageList);
         }
         integer k=1;
         for(Tech_Approval_Stage__c appStageRec:[Select Version__c,id,approval_stage_type__c from Tech_Approval_Stage__c where opportunity__c IN :oppIds LIMIT 5000]){
                    for(Tech_Approval_Stage__c appStageRec1:approvalStageList){
                        if(appStageRec.approval_stage_type__c == appStageRec1.approval_stage_type__c ){  
                           if(k<=i){
                                    appStageRec.Version__c=utilConstants.V_ALPHA+(k);
                                    approvalstageToUpdate.add(appStageRec);
                                    k++;
                           }
                        }
                    }
         } 
        update approvalstageToUpdate;
    }
    Catch(DMLException e)
    {
      String sheetThrowingException = UtilConstants.EMPTY_STRING;
      sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
    }
  }
  
   /**
     * @description       This method is used to set approval stage version.
     * @param             List<Tech_Approval_Stage__c> approvalStageList
     * @return            Void
     * @throws            DML Exception
     */  
  public static void setVersion(List<Tech_Approval_Stage__c> approvalStageList ){
    try{
          List<Tech_Approval_Stage__c> approvalstageToUpdate = new List<Tech_Approval_Stage__c>();
          system.debug('------approvalStageList -------'+approvalStageList);
          Set<Id> oppIds = new Set<Id>();
          string approvalstage;
          integer version;

          for(Tech_Approval_Stage__c appStageRec: approvalStageList){
              oppIds.add(appStageRec.Opportunity__c);
          }
        integer i;
        for(Tech_Approval_Stage__c appRec:approvalStageList){
      
               approvalstage=appRec.approval_stage_type__c;                                
               i=getVersion(appRec,oppIds,approvalstage,approvalStageList);
               system.debug('i-----------------------------------------------'+i);
        }
   
        List<Tech_Approval_Stage__c> stagelist =[Select Version__c,id from Tech_Approval_Stage__c where ID IN :approvalStageList Limit 5000];
        integer k=1;
        for(Tech_Approval_Stage__c appStageRec:stagelist){
         system.debug('********' + i);
         appStageRec.Version__c=utilConstants.V_ALPHA+(i);
         system.debug('----*****appStageRec.Version__c*****----'+appStageRec.Version__c); 

        approvalstageToUpdate.add(appStageRec);
       }
     update approvalstageToUpdate;
    
   }
   Catch(DMLException e)
   {
    String sheetThrowingException = UtilConstants.EMPTY_STRING;
    sheetThrowingException = e.getMessage() + e.getStackTraceString();
    throw (e);
   }
  }
  
  /**
     * @description       This method is used to restrict deletion of approval stage records if the stage has one or more pending request
     * @param             List < Tech_Approval_Stage__c > approvalRequestList
     * @return            void
     * @throws            User Defined Exception
     */  
     public static void validateBeforeDelete(List < Tech_Approval_Stage__c > approvalStageList) {
        try {
            Boolean isPending = false;
            Map < Id, Boolean > pendingAppStageMap = new Map < Id, Boolean > ();
            for (Tech_Approval_Stage__c appStageRec: [Select name, (Select approval_request_status__c, approval_sent_date__c
            from Tech_Approval_Requests__r LIMIT 5000) from Tech_Approval_Stage__c where Id IN: approvalStageList Limit 5000]) {
                for (Tech_Approval_Request__c appRequestRec: appStageRec.Tech_Approval_Requests__r) {
                    if (appRequestRec.approval_request_status__c.equals(UtilConstants.PEND_WITH_APPR2) 
                        && appRequestRec.approval_sent_date__c != null) {
                        isPending = true;
                        pendingAppStageMap.put(appStageRec.Id, isPending);
                        break;
                    }
                }
                if (isPending) {
                    break;
                }
            }
            for (Tech_Approval_Stage__c appStageRec: approvalStageList) {
                if (pendingAppStageMap.containsKey(appStageRec.Id)) {
                    appStageRec.addError(UtilConstantsR3.ERROR_MSG_APPROVAL);
                }
            }
        } Catch(DMLException e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    
     /**
     * @description       This method is used populate stagesataus and comment map.
     * @param             List < Tech_Approval_Stage__c > approvalRequestList
     * @return            Void
     * @throws            NA
     */  
        public static void stagestatus(List < Tech_Approval_Stage__c > approvalRequestList) {
        try {
            stagestatus = new Map < Id, String > ();
            opp = new Map < ID, ID > ();
            comments = new Map < Id, String > ();
            for (Tech_Approval_Stage__c appRequestRec: [Select id, opportunity__c, approval_stage_status__c, comments__c
                 from Tech_Approval_Stage__c where Id IN: approvalRequestList Limit 5000]) {
                stagestatus.put(appRequestRec.Id, appRequestRec.approval_stage_status__c);
                opp.put(appRequestRec.Id, appRequestRec.opportunity__c);
                comments.put(appRequestRec.Id, appRequestRec.comments__c);
            }
        } Catch(DMLException e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    
    /**
     * @description       This method is used to restrict updation of approval stage records.
     * @param             List < Tech_Approval_Stage__c > approvalRequestList
     * @return            void
     * @throws            User Defined Exception
     */  
    public static void editApprovalStage(List < Tech_Approval_Stage__c > approvalStageList) {
        String sheetThrowingException = UtilConstants.EMPTY_STRING;
        try {
            Set < id > oppid = new Set < id > ();
            boolean bool;
            for (Tech_Approval_Stage__c rec: approvalStageList) {
                oppid.add(rec.Opportunity__c);
            }
            List < Opportunity_Teams__c > oteam = [Select id, Opportunity_Team_Member__r.user__c,Opportunity_Role_Dev__c from
                                                    Opportunity_Teams__c where Opportunity__c IN: oppid and Opportunity_Team_Member__r.user__c = : UserInfo.getUserId() 
                                                    and (Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch_Lead or Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch) limit 5000];
            system.debug('oteamoteamoteamoteam++++++++++++++++++++++++++++'+oteam);
            list < string > profileNames = new list < string > {
                Label.solution_editor_profile
            };
            map < id, profile > userprofiles = new map < id, profile > ();
            userprofiles = UtilConstantsforSWB.queryProfiles(profileNames);
            for (Tech_Approval_Stage__c rec: approvalStageList) {
                system.debug(comments.get(rec.id)+'++++++COMMENTS+++++++++++++'+rec.comments__c);

                if (oteam.size() == 0 && userprofiles.containsKey(userinfo.getProfileid()) && 
                    (comments.get(rec.id) != rec.comments__c || opp.get(rec.id) != rec.opportunity__c)) {
                    rec.addError(UtilConstants.ERR_MSG_DEL_PERM);
                }
                if (oteam.size() > 0) {
                    for (Opportunity_Teams__c ot: oteam) {


                        if (UserInfo.getUserId() == ot.Opportunity_Team_Member__r.user__c && 
                            (opp.get(rec.id) != rec.opportunity__c)) {
                            system.debug(stagestatus.get(rec.id)+' new' +rec.approval_stage_status__c);
                            rec.addError(UtilConstantsR3.ERR_MSG_DEL_PERM);
                        }
                    }
                }

            }
        } Catch(DMLException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    
     /**
     * @description       This method is used to update approval request status if Final approval is Approved.
     * @param             set<id> approvalStage
     * @return            Void
     * @throws            DML Exception
     */  
     public static void approveApprovalStage(set<id> approvalStage) {
        List<Tech_Approval_Stage__c> stagetoupdate=new List<Tech_Approval_Stage__c>();
        List<Tech_Approval_Stage__c> techStageRec=[Select id,Final_Approval__c,approval_stage_status__c,approval_stage_type__c
                                                    from Tech_Approval_Stage__c where id in:approvalStage limit 5000];
        if(!techStageRec.isEmpty()){
            for(Tech_Approval_Stage__c stageRec:techStageRec){
            	if(!stageRec.approval_stage_type__c.equalsignorecase(UtilConstantsR3.FLY_BY_SOL_REVIEW)){
	                stageRec.approval_stage_status__c=UtilConstants.APPROVED_STATUS;
	                stagetoupdate.add(stageRec);
            	}
            }
            
            if(!stagetoupdate.isEmpty()){
                try{
                    database.update(stagetoupdate,true);
                }
                catch(Exception e){
                    throw(e);
                }
            }
        }
     }
     
     
      /**
     * @description       This method is used to ensure that only technical architect leads/technical architect are allowed to create approval stage.
     * @param             list<Tech_Approval_Stage__c> requestlist
     * @return            Void
     * @throws            User-Defined Exception
     */  
     public static void addStage(list<Tech_Approval_Stage__c> requestlist){
        set<id> opportunityIds =new set<id>();
        for(Tech_Approval_Stage__c req:requestlist){
            opportunityIds.add(req.Opportunity__c);
        }
        
        list<Opportunity_Teams__c> oppTeamRec=[Select id,Opportunity_Role_Dev__c,Opportunity_Team_Member__r.user__c,Opportunity__c from Opportunity_Teams__c where 
                                                (Opportunity_Role_Dev__c=:UtilConstantsR3.SuppTechArch or Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch) and Opportunity__c in :opportunityIds and 
                                                Opportunity_Team_Member__r.user__c=:userinfo.getUserid() limit 5000];
        if(oppTeamRec.isEmpty() &&  userinfo.getProfileId()!=UtilConstantsforSWB.utilMethod(Label.System_Admin_Profile)){
              for(Tech_Approval_Stage__c requestRec:requestlist){
                requestRec.addError(UtilConstantsR3.ERROR_MSG_TestStage);
              }
        }
        
        
     }
      /**
     * @description       This method is used to Update Fields on Opportunity for Reporting.
     * @param             list<Tech_Approval_Stage__c> requestlist
     * @return            Void
     * @throws            User-Defined Exception
     */  
     public static void updateOpportunityforReporting(list<Tech_Approval_Stage__c> requestlist){
     	Set<ID> opIds = new Set<ID>();
     	Map<id,Opportunity> mapIdWithOpportunity = new Map<id,Opportunity>();
     	Opportunity opprecToUpdate = new Opportunity();
     	List<Opportunity> oppListToUpdate = new List<Opportunity>();
     	for(Tech_Approval_Stage__c tAS: requestlist){
     		opIds.add(tAS.Opportunity__c);
     	}
     	for(Opportunity oppRec : [select id,name,Approval_Stage_Approved__c,Approval_Stage_Created__c from Opportunity where ID IN:opIds]){
     		for(Tech_Approval_Stage__c tAS: requestlist){
     			if(tAS.Opportunity__c == oppRec.id){
     				mapIdWithOpportunity.put(tAS.id,oppRec);
     			}
     		}
 	}
     		for(Tech_Approval_Stage__c tAS: requestlist){
     			if(tas.approval_stage_status__c == 'Pending'){
     				opprecToUpdate=mapIdWithOpportunity.get(tAS.id);
     				opprecToUpdate.Approval_Stage_Created__c = true;
     				oppListToUpdate.add(opprecToUpdate);
     			}
     			if(tas.approval_stage_status__c == 'Approved'){
     				opprecToUpdate=mapIdWithOpportunity.get(tAS.id);
     				opprecToUpdate.Approval_Stage_Approved__c = true;
     				oppListToUpdate.add(opprecToUpdate);
     			}
     		}
     	try{
     	if(oppListToUpdate.size()>0){
     		database.update(oppListToUpdate);
     	}
     	}
     	catch(Exception w){
     		// put some exception handling code here
     	}
     }
     
     /**
     * @description       This method is used to update Tech Approval Date at Opportunity Level.
     * @param             list<Tech_Approval_Stage__c > stagelist
     * @return            Void
     * @throws            dml exception
     
     */ 
     
     public static void updateApprovalDate(list<Tech_Approval_Stage__c > stagelist){
     	Set<id> opportunityId=new set<id>();
     	map<id,datetime>appreqDateMap=new map<id,datetime>();
     	List<Opportunity> opportunityRecToUpdate=new List<Opportunity>();
     	List<Tech_Approval_Stage__c> ApprovalStageNONFlyBy = new List<Tech_Approval_Stage__c>();
     	for(Tech_Approval_Stage__c stageRec:stagelist){
     		if(!UtilConstantsR3.FLY_BY_SOL_REVIEW.equalsIgnoreCase(stageRec.approval_stage_type__c) && UtilConstantsR3.approved.equalsIgnoreCase(stageRec.approval_stage_status__c)
     		    && !UtilConstantsR3.STAGE1_SOL_APPROVAL.equalsIgnoreCase(stageRec.approval_stage_type__c)){
     			ApprovalStageNONFlyBy.add(stageRec);
     		}
     		opportunityId.add(stageRec.opportunity__c);
     	}
     	
     	if(!ApprovalStageNONFlyBy.isEmpty()){
     		for(Tech_Approval_Stage__c appr:ApprovalStageNONFlyBy){
	     		if(appreqDateMap.get(appr.Opportunity__c)==null){
	     			appreqDateMap.put(appr.Opportunity__c,appr.createddate);
	     		}
	     		else{
	     			if(appreqDateMap.get(appr.Opportunity__c)>appr.createddate){
	     				appreqDateMap.put(appr.Opportunity__c,appr.createddate);
	     			}
	     		}
     		}
     	}
     	
     	for(Opportunity oppRec:[select id,Tech_Approval_Date__c from opportunity where id in:opportunityId]){
        		if(appreqDateMap.get(oppRec.id)!=null){
        			oppRec.Tech_Approval_Date__c=appreqDateMap.get(oppRec.id);
        			opportunityRecToUpdate.add(oppRec);
        		}
        	}
        if(!opportunityRecToUpdate.isEmpty()){
        	try{
        		database.update(opportunityRecToUpdate,false);
        	}
        	catch(Exception e){
        		
        	}
        }
     } 
}