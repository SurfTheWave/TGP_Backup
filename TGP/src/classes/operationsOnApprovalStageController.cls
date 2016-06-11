/*
@Author : Jyotsna Yadav
@name : operationsOnApprovalStageController
@CreateDate : 1/7/2015 4:55 AM
@Description : 
@Version : 
*/
public without sharing class operationsOnApprovalStageController {
    public static Map < Id, String > stagestatus;
    public static Map < Id, String > opp;
    public static Map < Id, String > comments;

    /*
@Author : Jyotsna Yadav
@name : operationsOnApprovalStageController
@CreateDate : 1/7/2015 4:55 AM
@Description : 
@Version : 
*/
    public static void validateBeforeDelete(List < Approval_Stage__c > approvalStageList) {
        try {
            Boolean isPending = false;
            Map < Id, Boolean > pendingAppStageMap = new Map < Id, Boolean > ();
            for (Approval_Stage__c appStageRec: [Select name, (Select approval_request_status__c, approval_sent_date__c
            from Approval_Request__r) from Approval_Stage__c where Id IN: approvalStageList Limit 5000]) {
                for (approval_request__c appRequestRec: appStageRec.Approval_Request__r) {
                    if (appRequestRec.approval_request_status__c.equals(UtilConstants.PEND_WITH_APPR2) 
                        && appRequestRec.approval_sent_date__c != null) {
                        isPending = true;
                        pendingAppStageMap.put(appStageRec.Id, isPending);
                        //appStageRec.addError( 'Sorry !! One or more approval request are pending.Approval stage can not be deleted.' );
                        break;
                    }
                }
                if (isPending) {
                    break;
                }
            }
            for (Approval_Stage__c appStageRec: approvalStageList) {
                if (pendingAppStageMap.containsKey(appStageRec.Id)) {
                    appStageRec.addError(UtilConstants.ERROR_MSG_APPROVAL);
                }
            }
        } Catch(DMLException e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
            //system.debug('E==='+e);
            //system.debug('E==='+e);
        }
    }
    ///**-----------------------------------------------------------------------------------------------**\\

    /*
@Author : Jyotsna Yadav
@name : operationsOnApprovalStageController
@CreateDate : 1/7/2015 4:55 AM
@Description : 
@Version : 
*/
    public static void setVersion(List<Approval_Stage__c> approvalStageList ){
    
    try{
       List<approval_stage__c> approvalstageToUpdate = new List<approval_stage__c>();
      //system.debug('------approvalStageList -------'+approvalStageList);
      Set<Id> oppIds = new Set<Id>();
      string approvalstage;
      integer version;

      for(Approval_Stage__c appStageRec: approvalStageList){
          oppIds.add(appStageRec.Opportunity__c);
      }
      integer i;
  for(Approval_Stage__c appRec:approvalStageList){
  
           approvalstage=appRec.approval_stage_type__c;
           //system.debug('**********' + approvalstage);
           //system.debug('**********' + appRecServiceGrp);                                 
           i=getVersion(appRec,oppIds,approvalstage,approvalStageList);
           //system.debug('********' + i);
       }
   
     //system.debug('********' + i);
     List<Approval_Stage__c> stagelist =[Select Version__c,id from approval_stage__c where ID IN :approvalStageList Limit 5000];
        integer k=1;
        for(Approval_Stage__c appStageRec:stagelist){
         //system.debug('********' + i);
         appStageRec.Version__c=utilConstants.V_ALPHA+(i);
         //system.debug('----*****appStageRec.Version__c*****----'+appStageRec.Version__c); 

        approvalstageToUpdate.add(appStageRec);
       }
     update approvalstageToUpdate;
    
   }
   Catch(DMLException e)
   {
    String sheetThrowingException = UtilConstants.EMPTY_STRING;
    sheetThrowingException = e.getMessage() + e.getStackTraceString();
    throw (e);
    //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
    //ApexPages.addMessage(myMsg);
       //system.debug('E==='+e);
   }
  }

    /*  ------------------------------------------------------------------------------------------------------------*/
    /*
@Author : Jyotsna Yadav
@name : operationsOnApprovalStageController
@CreateDate : 1/7/2015 4:55 AM
@Description : 
@Version : 
*/
    public static integer getVersion(Approval_Stage__c appRec, set<Id> oppIds, string ApprovalStageType,List<Approval_Stage__c> approvalStageList){
  integer i;
  List<approval_stage__c> approvalstageToUpdate = new List<approval_stage__c>();
  String sheetThrowingException = UtilConstants.EMPTY_STRING;
  try{
  if(appRec.approval_stage_type__c.EqualsIgnoreCase(utilConstants.STAGE1_SOL_APPROVAL)){
           for(Opportunity oppRec : [Select id,(Select id,approval_stage_type__c from approval_stage__r 
           where approval_stage_type__c=:ApprovalStageType) 
           from Opportunity where id in :oppIds Limit 5000]){
               i = oppRec.approval_stage__r.size();
               //system.debug('----i----'+i);  
            }           
           }
           if(appRec.approval_stage_type__c.EqualsIgnoreCase(utilConstants.STAGE2_SOL_APPROVAL)){
               for(Opportunity oppRec : [Select id,(Select id,approval_stage_type__c from approval_stage__r 
           where approval_stage_type__c=:ApprovalStageType)
               from Opportunity where id in :oppIds Limit 5000]){
                   i = oppRec.approval_stage__r.size();
              // system.debug('----i----'+i); 
            }  
           }
           if(appRec.approval_stage_type__c.EqualsIgnoreCase(utilConstants.STAGE3_SOL_APPROVAL)){
               for(Opportunity oppRec : [Select id,(Select id,approval_stage_type__c from approval_stage__r 
           where approval_stage_type__c=:ApprovalStageType)
                   from Opportunity where id in :oppIds Limit 5000]){
                       i = oppRec.approval_stage__r.size();
               //system.debug('----i----'+i); 
            }  
           }
           if(appRec.approval_stage_type__c.EqualsIgnoreCase(utilConstants.FLY_BY_SOL_REVIEW)){
               for(Opportunity oppRec : [Select id,(Select id,approval_stage_type__c from approval_stage__r 
           where approval_stage_type__c=:ApprovalStageType) 
                       from Opportunity where id in :oppIds Limit 5000]){
                           i = oppRec.approval_stage__r.size();
               //system.debug('----i----'+i); 
            }  
           }
         return i;
     } catch(DmlException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);
          }        
  }
    /*   -----------------------------------------------------------------------------------------------------------*/
    /*
@Author : Jyotsna Yadav
@name : operationsOnApprovalStageController
@CreateDate : 1/7/2015 4:55 AM
@Description : 
@Version : 
*/
    public static void editApprovalStage(List < Approval_Stage__c > approvalStageList) {
        String sheetThrowingException = UtilConstants.EMPTY_STRING;
        try {
            Set < id > oppid = new Set < id > ();
            boolean bool;
            for (Approval_Stage__c rec: approvalStageList) {
                oppid.add(rec.Opportunity__c);
            }
            List < Opportunity_Teams__c > oteam = [Select id, Opportunity_Team_Member__r.user__c from
            Opportunity_Teams__c where Opportunity__c IN: oppid and Opportunity_Team_Member__r.user__c = : UserInfo.getUserId() Limit 5000];
            //system.debug('oteamoteamoteamoteam++++++++++++++++++++++++++++'+oteam);
            list < string > profileNames = new list < string > {
                Label.solution_editor_profile,
                Label.IC_solution_editor_profile, Label.IOSolutionEditor_profile
            };
            map < id, profile > userprofiles = new map < id, profile > ();
            userprofiles = UtilConstantsforSWB.queryProfiles(profileNames);
            for (Approval_Stage__c rec: approvalStageList) {
                //system.debug(comments.get(rec.id)+'++++++COMMENTS+++++++++++++'+rec.comments__c);

                if (oteam.size() == 0 && userprofiles.containsKey(userinfo.getProfileid()) && 
                    (comments.get(rec.id) != rec.comments__c || opp.get(rec.id) != rec.opportunity__c)) {
                    rec.addError(UtilConstants.ERR_MSG_DEL_PERM);
                }
                if (oteam.size() > 0) {
                    for (Opportunity_Teams__c ot: oteam) {


                        if (UserInfo.getUserId() == ot.Opportunity_Team_Member__r.user__c && 
                            (opp.get(rec.id) != rec.opportunity__c)) {
                            //system.debug(stagestatus.get(rec.id)+' new' +rec.approval_stage_status__c);
                            rec.addError(UtilConstants.ERR_MSG_DEL_PERM);
                        }
                    }
                }

            }
        } Catch(DMLException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
            //system.debug('E==='+e);
        }
    }
    /*
@Author : Jyotsna Yadav
@name : operationsOnApprovalStageController
@CreateDate : 1/7/2015 4:55 AM
@Description : 
@Version : 
*/
    public static void stagestatus(List < Approval_Stage__c > approvalRequestList) {
        try {
            stagestatus = new Map < Id, String > ();
            opp = new Map < ID, ID > ();
            comments = new Map < Id, String > ();
            for (Approval_Stage__c appRequestRec: [Select id, opportunity__c, approval_stage_status__c, comments__c
            from Approval_Stage__c where Id IN: approvalRequestList Limit 5000]) {
                stagestatus.put(appRequestRec.Id, appRequestRec.approval_stage_status__c);
                opp.put(appRequestRec.Id, appRequestRec.opportunity__c);
                comments.put(appRequestRec.Id, appRequestRec.comments__c);
            }
        } Catch(DMLException e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
            //system.debug('E==='+e);
            //system.debug('E==='+e);
        }
    }
    /*
@Author : Jyotsna Yadav
@name : operationsOnApprovalStageController
@CreateDate : 1/7/2015 4:55 AM
@Description : 
@Version : 
*/
    public static void reSetVersion(List<Approval_Stage__c> approvalStageList ){
    try
    {
      List<approval_stage__c> approvalstageToUpdate = new List<approval_stage__c>();
      //system.debug('------approvalStageList -------'+approvalStageList);
      Set<Id> oppIds = new Set<Id>();
      string approvalstage;
      integer version;
      for(Approval_Stage__c appStageRec: approvalStageList){
          oppIds.add(appStageRec.Opportunity__c);
      }
      integer i;
  for(Approval_Stage__c appRec:approvalStageList){
   
           approvalstage=appRec.approval_stage_type__c;
     
           //system.debug('**********' + approvalstage);
           //system.debug('**********' + appRecServiceGrp);                                 
           i=getVersion(appRec,oppIds,approvalstage,approvalStageList);
           //system.debug('********' + i);
   
  }
      //system.debug('********' + i);
      integer k=1;
        for(Approval_Stage__c appStageRec:[Select Version__c,id,approval_stage_type__c
         from approval_stage__c where opportunity__c IN :oppIds LIMIT 5000]){
                for(Approval_Stage__c appStageRec1:approvalStageList){
                    if(appStageRec.approval_stage_type__c == appStageRec1.approval_stage_type__c ){  
                        //system.debug('********ServiceGrp' + appStageRec.Service_Group__c);
                         //system.debug('********ServiceGrp1' + appStageRec1.Service_Group__c);
                         //system.debug('********' + i);
                       if(k<=i){
                              //system.debug('----i----'+i); 
                              //system.debug('----k----'+k); 
                                appStageRec.Version__c=utilConstants.V_ALPHA+(k);
                                //system.debug('************' + appStageRec.Version__c);
                           
                            approvalstageToUpdate.add(appStageRec);
                                k++;
                            }
                    }
                }
       }
            //system.debug('----approvalstageToUpdate------'+approvalstageToUpdate);
     update approvalstageToUpdate;
  }
  Catch(DMLException e)
  {
      String sheetThrowingException = UtilConstants.EMPTY_STRING;
      sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);
            //system.debug('E==='+e);
      //system.debug('E==='+e);
  }
}
    /*
    @Author : Vishal Tulsiyan
    @name : insertOpportunitySVMCompliance(List<Approval_Stage__c> appStage)
    @CreateDate : 04/01/2016 04:11 PM
    @Description : Inserts Opportunity SVM Compliance record if Approval Stage is 'Stage 2 - Solution Approval'  
                    or 'Stage 3 - Solution Approval'
    @Version : 
    */
    public static void insertOpportunitySVMCompliance(List<Approval_Stage__c> appStage){
        List<Opportunity_SVM_Compliance__c> oppSVMList = new List<Opportunity_SVM_Compliance__c>();
        Opportunity_SVM_Compliance__c newOppSVMCompliance;
        
        for(Approval_Stage__c app: appStage){
            if(app.approval_stage_type__c.equals(UtilConstants.STAGE2_SOL_APPROVAL) || app.approval_stage_type__c.equals(UtilConstants.STAGE3_SOL_APPROVAL) ){
               // System.debug('I CAME INSDIE TO CREATE SVM COMPLIANCE OBJECT');
                newOppSVMCompliance = new Opportunity_SVM_Compliance__c();
                newOppSVMCompliance.Approval_Id__c = app.Id;
                newOppSVMCompliance.Stage__c = app.approval_stage_type__c;
                newOppSVMCompliance.Opportunity__c = app.Opportunity__c;
                newOppSVMCompliance.Active__c = TRUE;
                oppSVMList.add(newOppSVMCompliance);
            }
        }
        try{
            if(oppSVMList.size()>0 && oppSVMList!=NULL){
                INSERT oppSVMList;
                //System.debug('Following Record is inserted: '+oppSVMList);
            }
        } Catch(DMLException e){}
    }
}