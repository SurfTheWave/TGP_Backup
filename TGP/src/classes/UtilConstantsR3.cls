/*
  @Author: MobilizationWorkbench
  @Name: UtilConstantsR3
  @Created Date: 10 Sep 2015
  @Description: This class defines all Constants required  
  @version: 1.0 
*/
public without sharing class UtilConstantsR3 {

public static final String URL1 = '/apex/ApprovalErrorPage1?id=';
public static final String URL2 = '&type=';
public static final String URL3 = '&action=recall';
public static final String URL4 = '&stgId=';
public static final String URL5 = '/apex/ApprovalErrorPage?id=';
public static final String TYPE = 'type';
public static boolean allowactivation=false;
public static boolean allowstatusupdation=false;
public static final String LEVEL2= 'Level2';
public static final String LEVEL1 = 'Level1';
public static final String LEVEL2_FST= 'Level2FST';
public static final String SRAT_L1_TRACKING_TYPE= 'SRAT_Level_1_Tracking_Type__c';
public static final String LEVEL2_FST_QUERY = 'Select Id,Name,Deal_SRAT_Additional_Tracking_Level_1__c, Deal_SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c FROM SRAT_Additional_Tracking_Level_2_FST__c WHERE Deal_SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c IN :sratIds';
public static final String LEVEL2_QUERY = 'Select Id,Name,SRAT_Additional_Tracking_Level_1__c, SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c FROM SRAT_Additional_Tracking_Level_2__c WHERE  SRAT_Additional_Tracking_Level_1__r.SRAT_Tracker__c IN: sratIds';
public static final String LEVEL1_QUERY = 'Select Id,Name,SRAT_Tracker__c, SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c WHERE SRAT_Tracker__c IN: sratIds ORDER BY SRAT_Level_1_Tracking_Type__c';
public static final String ADMIN = 'Admin';
public static final String MISCELLANEOUS = 'Miscellaneous';
public static final String ROLL_BACK_FAILED = 'Roll Back Failed';
public static final string  BPO_USER_TECH_ARCH = 'BPO User assg inti New(Tech Arch)';
public static final string  Tech_Arch_Lead = 'Technical Architect';
public static final string Tech_Arch='Technical Architect';
public static final string  hyphen = '-';
public static final string  geoLead = ' Geo Lead';
public static final string cmt='Communications, Media & Technology';
public static final string fs='Financial Services';
public static final string hps='Health & Public Service';
public static final string cmtwatcher='CMT';
public static final string fswatcher='FS';
public static final string hpswatcher='HPS';
public static final string Watchers='Watchers';
public static boolean runaddWatcher=true;
public static final string ERROR_MSG_Watcher='You don\'t have necessary level of access. Only Technical Architect are allowed to add watcher for an Opportunity.';
public static final string NorthAmerica='North America';
public static final string NA='NA';
public static final string LatinAmerica='Latin America';
public static final string LATAM='LATAM';
public static final string FLY_BY_SOL_REVIEW='Fly By -Technical Solution Review';
public static final string STAGE1_SOL_APPROVAL='Stage 1 - Tech Approval';
public static final string STAGE2_SOL_APPROVAL='Stage 2 - Tech Approval';
public static final string STAGE3_SOL_APPROVAL='Stage 3 - Tech Approval';
public static final string Factory=' Factory';
public static final string APPR_REQ='Tech_Approval_Request__c';
public static final string Tech_Post_Approval='Tech_Post_Approval';
public static final string SRYAPPREQ='Request is pending for approval.It can not be deleted.';
public static final string SRYAPPREQAPP='Request is approved.It can not be deleted.';
public static final string handleInboundEmail='handleInboundEmail';
public static final string TechApprovalEmailService='TechApprovalEmailService';
public static final string Tech_Unauthorized_Approver='Tech_Unauthorized_Approver';
public static final string Tech_Approval_Test='Tech_Approval_Test';
public static final string Recall_Tech_Approval_Request='Recall_Tech_Approval_Request';
public static final string ActionItem='Tech_Action_Items__c';
public static final string Tech_Action_Items='Tech_Action_Items';
public static final string ERROR_MSG_APPROVAL='One or more request are pending for approval.Stage can not be deleted';
public static final string ERR_MSG_DEL_PERM='You don\'t have necessary level of access.';
public static final string WatchersStatusNStageNotification='DealStatus/StageChangeNotification';
public static final string ERROR_MSG_TestRequest='You don\'t have necessary level of access.Only Technical Architect/Supporting Tech Architect are allowed to  raise a approval request.';
public static final string ERROR_MSG_TestStage='You don\'t have necessary level of access.Only Technical Architect/Supporting Tech Architect are allowed to add  a Tech Approval Stage.';
public static final string won='Won';
public static final string lost='Lost';
public static final string approved='Approved';
public static final string INTIMATE_PMO_TECH_ARCH='InitmatiomToPMOTechArch';
public static final string SuppArch='Supporting Tech Architect Added';
public static final string LeadArch='Reassignment Of Tech Arch Lead';
public static final string SuppTechArch='Supporting Tech Architect';
public static final string ERROR_MSG_TechAction='You don\'t have necessary level of access.Only Technical Architect/Supporting Tech Architect are allowed to create action item.';
public static final string Assigned='Assigned';
public static final string ERROR_MSG_TechArch='You don \'t have required level of access. Only Technical Architect can reassign the team members';
public static final string ERROR_MSG_TechMOM='You don \'t have required level of access. Only Technical Architect/Supporting Tech Architect are allowed to create MOM';
public static boolean runWatcherMethodOnOPPTrigger=true;
public static boolean runServiceTrigger=false;
public static boolean runGovTrigger=false;
public static boolean runCommTrigger=false;
public static boolean runAnalyticTrigger=true;
public static boolean runCapasityTrigger=true;
public static final string TechForOpssWatcher='Tech for Ops Leadership';
public static final string Tech_Arch_Lead_Approval='Tech_Arch_Lead_Approval';
public static final string Arch_Lead_Approval='Arch Lead Approval';
public static final string ArchLead='ArchLead';
public static final string finalS='final';
public static final string typeurl='type';
public static final string FIELD_CUSTOM_VALIDATION_EXCEPTION='FIELD_CUSTOM_VALIDATION_EXCEPTION, Mandatory field missing: Provide a value for Tech Solution Deck Score';
public static final string TechApprovalErrorPageURL='/apex/TechApprovalErrorPage?id=';
public static final string typeFinal='&type=final';
public static final string typeArchlead='&type=ArchLead';
public static final string Tech_Final_Approval='Tech_Final_Approval';
public static final string Tech_Final_Approval_Arch_lead='Tech_Final_Approval_Arch_lead';
}