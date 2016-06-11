public with sharing class VFC_Deal_Track_Controller {
    // Class level variable declarations
    public Deal_Track__c dealTrack {get; set;}
    public Deal_TGP__c strDealTGP{get;set;}
    public List<MOB_User_Role_Assignment__c> lstUserRoleAssign{get; set;}
    public MOB_User_Role_Assignment__c strMOBUserRoleAssignment {get;set;}
    public Wave_Plan_Version__c strWavePlanVersion{get;set;}
    public List<Deal_Location__c> strDealLocationList{get;set;}
    public List<Wave_Planning__c> strWavePlanningList{get;set;}
    public List<Wave_Process__c> strWaveProcessList{get;set;} 
    public List<SRAT__c> strSRATList{get;set;}
    public List<OPEX__c> strOPEXList{get;set;}
    public List<Service_Management__c> strServiceManagementList{get;set;}
    public List<KT_Planning__c> strKTPlanningList{get;set;}
    public List<KT_Planning__c> tempKTPlanningList{get;set;}
    public List<Recruitment_Tracking__c> strRecruitmentTrackingList{get;set;}
    public List<Recruitment_Tracking__c> tempRecruitmentTrackingList{get;set;}
    public boolean flag{get;set;}
    public boolean flagForLoc{get;set;}
    public List<Commercial_Planning__c> strCommercialPlanningList{get;set;}
    public List<Contract_Legal_Infosec_Section_Master__c> strContractLegalInfosecMgmt{get;set;}
    public List<Contract_Legal_Infosec__c> strContractLegalInfosecList{get;set;}
    public List<Tech_Assessment__c> strTechAssessmentList{get;set;}
    public List<Tech_Assessment__c> tempTechAssessmentList{get;set;}
    public List<Journey_Management_Planning__c> strJourneyPlanList{get;set;}
    public List<Journey_Management__c> lstJourneyMgmt {get;set;}
    public List<Service_Management__c> lstSeviceMgmtPlan{get;set;}
    public List<Service_Management_Master__c> lstServiceMgmtMaster{get;set;}
    public List<Business_Continuity_Planning__c> lstBCPPlan {get;set;}
    public List<BCP_Section_Master__c> lstBCPMaster {get;set;}
    public String wavePlanVersionId{get;set;}
    public boolean showForm{get;set;}
    public boolean isBCPAccess{get;set;}
    public boolean isServiceAccess{get;set;}
    public boolean isRecordAccess{get;set;}
    public string strDealId{get;set;}
    public boolean isAddVisible{get;set;}
    public boolean isEditVisible{get;set;}
    public boolean isNA{get;set;}
    public String userProfileName{get;set;}
    public Wave_Plan_Version__c wpv {get;set;}
    public boolean isInlineEdit {get;set;}
    public boolean isDealPMO {get;set;}
    // Constants
    private static final string CLASS_NAME = 'VFC_Deal_Track_Controller';
    private static final string METHOD_SaveBCPPlan = 'SaveBCPPlan';
    private static final string METHOD_SaveJourenyManagement = 'SaveJourneyManagement';
    private static final string METHOD_SaveTechEnable = 'SaveTechEnablement';
    private static final string METHOD_SaveContractLI = 'SaveContractLegalInfosec';
    private static final string METHOD_SaveCommercialPlan = 'SaveCommercialPlan';
    private static final string METHOD_SaveRecruitementlPlan = 'SaveRecruitmentPlan';
    private static final string METHOD_SaveKTlPlan = 'SaveKTPlan';
    private static final string METHOD_SaveServiceManagement = 'SaveServiceMgmt';
    private static final string METHOD_SaveOppMaturity = 'SaveOppMaturity';
    private static final string METHOD_SAVESTAT = 'SaveSRAT';
    private static final string METHOD_SAVE_GO_LIVE_PLAN = 'SaveGoLivePlan';
    private static final string METHOD_SAVE_DEAL_TRACK_FIELD = 'SaveDealTrackFields';
    /******************************
    * @Method Name: VFC_Deal_Track_Controller
    * @Description: This is Constructor for the VFC_Deal_Track_Controller class  
    * @Paramenters: ApexPages.StandardController
    * @Return Value: NA
    *******************************/
    public VFC_Deal_Track_Controller(ApexPages.StandardController controller) {
        dealTrack = new Deal_Track__c();
        dealTrack = (Deal_Track__c)controller.getRecord();
        dealTrack = [Select Name, Wave_Plan_Version__c from Deal_Track__c Where Id =: dealTrack.Id limit 1];
        isInlineEdit = false;
        isDealPMO = false;
        wavePlanVersionId = dealTrack.Wave_Plan_Version__c;
        if(wavePlanVersionId==null) {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Invalid_Wave_Plan_Version_ID)); 
             showForm=false; 
        }
        else {
             showForm=true;
        }
        wpv_Load();
        
        Deal_TGP__c dealTGP = [Select Deal_RAG_Status__c,Deal_Status__c, Issue__c, Action__c, Lead__c,
                                    Pre_Contract__c, Go_Live_Critical_Path__c from Deal_TGP__c where id=:wpv.Deal__c limit 1];
        if(!String.isEmpty(dealTGP.Id)) {
            lstUserRoleAssign = [select Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,User_Assigned_New__c,User_Assigned_New__r.SFDC_User__c,
                                        User_Assigned_secondary_New__c,User_Assigned_secondary_New__r.SFDC_User__c, 
                                        User_Assigned_secondary_Lead__c,User_Assigned_secondary_Lead__r.SFDC_User__c 
                                        from MOB_User_Role_Assignment__c where Deal__c = :dealTGP.id];
        }
        strDealTGP = [Select name,Deal_RAG_Status__c,Deal_Status__c, Issue__c, Action__c, Lead__c,
                                    Pre_Contract__c, Go_Live_Critical_Path__c from Deal_TGP__c where id=:wpv.Deal__c order by createddate];
        strDealLocationList = [Select Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c,Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c,Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Deployment_Lead_New__r.SFDC_User__c,Deal_Home_Location__r.Delivery_Location_Master__r.name,Location_RAG_Status__c,Comment__c,NewActive__c 
                                        from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersionId order by createddate];
        strWavePlanningList=[Select Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c,Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c,
                                        Mob_Technology_Lead_Secondary_New__r.SFDC_User__c,Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c,Mob_Technology_Lead_Secondary_2__r.SFDC_User__c,
                                        Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Label__c,Wave_Completion_Status__c,
                                        Wave_RAG_Status__c,Wave_Comment__c,KT_Lead_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c,
                                        NewActive__c,GO_Live_Date_del__c,Revised_Go_Live__c,Revised_Go_Live_Comments__c,Actual_Go_Live__c,Actual_Go_Live_Comments__c,
                                        Wave_Status__c,Deal_Location__r.NewActive__c from Wave_Planning__c 
                                        where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId order by createddate];
        strWaveProcessList=[Select Client_Specific_Process_Mapping__c,Completion_Status__c,Process_RAG_Status__c,Comment__c,
                                        Wave_Planning__r.Wave_Label__c,Wave_Planning__r.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                        Active__c,Wave_Planning__r.NewActive__c from Wave_Process__c 
                                        where Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId order by createddate];
        
        strCommercialPlanningList=[Select Activity__c,Activity_Order__c,Planned_Start_Date__c,Tracking_Comments__c, Milestone__c, Planned_End_Date__c,Completed__c,Actual_Start_Date__c,Actual_End_Date__c,
                                        Comments__c,active__c from Commercial_Planning__c where Wave_Plan_Version__c=:wavePlanVersionId  order by Activity_Order__c];
        strContractLegalInfosecMgmt=[select name,section_number__c, section_name__c from Contract_Legal_Infosec_Section_Master__c 
                                            where Is_Active__c =: true  order by section_number__c];
        strContractLegalInfosecList=[Select name,Active__c,Milestone__c,Cloned_From__c,Comments__c,Task_Name__c,Task_Number__c,Task_Master_ID__c,Section_Master_ID__c,
                                          Planned_End_Date__c,Planed_Start_Date__c,Tracking_Comments__c,Responsibility__c,Section_Name__c,Section_Number__c,Version__c,
                                          Wave_Plan_Version__c,Resource_Name__c, Actual_Start_Date__c, Actual_End_Date__c ,Completed__c , status__c
                                          from Contract_Legal_Infosec__c where Wave_Plan_Version__c=:wavePlanVersionId order by Task_Number__c];
       
        lstJourneyMgmt = [select name,section_number__c, section_name__c from journey_management__c where Is_Active__c =: true order by section_number__c];
        lstSeviceMgmtPlan = [select Active__c,Milestone__c, Comments__c,Phase_ID__c,Planned_End_Date__c,Planned_Start_Date__c,Task_Name__c,Resource_Name__c, Phase_Name__c, 
                                            Version__c, Tracking_Comments__c,Wave_Plan_Version__c,Wave_Plan_Version__r.active__c, Wave_Plan_Version__r.Display_tracking_message__c,
                                            Completed__c,Actual_Start_Date__c,Actual_End_Date__c,Status__c 
                                            from Service_Management__c where Wave_Plan_Version__c=:wavePlanVersionId];
        lstServiceMgmtMaster = [select name,Phase_Name__c,Phase_Number__c,Number_of_spaces__c from Service_Management_Master__c
                                         where Is_Active__c =: true order by Phase_Number__c];
      
        lstBCPMaster = [select name,Section_Name__c,Section_Number__c from BCP_Section_Master__c where Is_Active__c =: true];   
        if(!strDealLocationList.isEmpty()) {
            for(Deal_Location__c  loc : strDealLocationList ) {
                if(loc.Deployment_Lead_New__r.SFDC_User__c == UserInfo.getUserId() || loc.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() ||
                    loc.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c == UserInfo.getUserId() || loc.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()) {
                       isinlineEdit = true; 
                    }
            }
            for(Wave_Planning__c w : strWavePlanningList) {
                if(w.KT_Lead_New__r.SFDC_User__c == UserInfo.getUserId() || w.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()) {
                        isServiceAccess=true;
                        isinlineEdit = true;
                }
                if(w.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c == UserInfo.getUserId() ||
                     w.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || w.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c == UserInfo.getUserId()||
                     w.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()) {
                    isinlineEdit = true;
                }
            }
        }
        if(!lstUserRoleAssign.isEmpty()) {
            for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign) {
                if(UTIL_Constants.BUSINESS_CONTINUNITY_PLANING_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                    (mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))  {
                    isBCPAccess=true;
                }
                if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                        ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                    isBCPAccess=true;
                    isServiceAccess=true;
                    isRecordAccess=true;
                }
                if(UTIL_Constants.SERVICE_MANGEMENT_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) &&
                     ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                    isServiceAccess=true;
                }
                if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && 
                        ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                    isRecordAccess=true;
                    isDealPMO = true;
                }
                if(mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()) {
                    isinlineEdit = true;
                }
            }
        }
        userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;                    
        if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) 
                || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)) {    
            isRecordAccess=true;
        } 
        isAddVisible = UAMSolMobUtility.isAddVisible_DealTrackScreen;
            isEditVisible= UAMSolMobUtility.isEditVisible_DealTrackScreen;
            isRecordAccess= UAMSolMobUtility.isEditVisible_DealTrackScreen;
            
            if(UAMSolMobUtility.isNA_DealTrackScreen)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.NO_Privilege_Contact_your_Admin));
            }
            
     /*       // release 1.7-MOB-2 user story : to initialise the Revised Go Live Date with Planned Go Live Date
            for(Wave_Planning__c w : strWavePlanningList){
                if(w.Revised_Go_Live__c == null){
                w.Revised_Go_Live__c=w.GO_Live_Date_del__c;
                }
            } */
    }
    /**
     * @Method Name  : wpv_Load
     * @Description  : Method will get called on load of WPV
     * @Paramenters  : NA
     * @Return Value : NA
     **/
     public void wpv_Load() {
        wpv = [Select OPEX_Overall_Completion_Status__c,OPEX_Overall_RAG_Status__c,OPEX_Comments__c,
                                    SRAT_Overall_Completion_Status__c,SRAT_Overall_RAG_Status__c,SRAT_Comments__c,
                                    Service_Overall_Completion_Status__c, Service_Overall_RAG_Status__c,Service_Comments__c,
                                    KT_Plan_Overall_Completion_Status__c,KT_Plan_Overall_RAG_Status__c,KT_Plan_Comments__c,
                                    Recruit_Overall_Completion_Status__c,Recruit_Overall_RAG_Status__c,Recruit_Comments__c,
                                    Commerce_Overall_Completion_Status__c,Commerce_Overall_RAG_Status__c,Commerce_Comments__c,
                                    Contract_Overall_Completion_Status__c,Contract_Overall_RAG_Status__c,Contract_Comments__c,
                                    Tech_Overall_Completion_Status__c,Tech_Overall_RAG_Status__c,Tech_Comments__c,
                                    Journey_Overall_Completion_Status__c,Jou_Overall_RAG_Status__c,JourneyMgmt_Comments__c,
                                    BCP_Overall_Completion_Status__c,BCP_Overall_RAG_Status__c,BCP_Comments_for_deal_Tracking__c,
                                    BCP__c,BCP_Comments__c,Active__c,Deal__c,Name,Pre_Contract__c,Go_Live_Critical_Path__c,Issue1__c,
                                    Action1__c,Overall_Deal_RAG_Comments1__c From Wave_Plan_Version__c Where Id =: wavePlanVersionId Limit 1];
     }
    /**
     * @Method Name  : sRAT_Controller
     * @Description  : Method will get called on load of SRAT section
     * @Paramenters  : NA
     * @Return Value : NA
     **/
    public void sRAT_Controller (){
            strSRATList=[Select Item__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Planned_Date__c, Wave_Plan_lk__r.Wave_Label__c,
                        Completed__c,Actual_Date__c, Individual_Plan_RAG_Status__c, Comments__c, is_RAG_status_changed__c,active__c,
                        Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c, Tracking_Comments__c, Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,
                        Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c,Milestone__c, Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,Wave_Plan_lk__r.NewActive__c,Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c 
                        from SRAT__c where Wave_Plan_Version__c=:wavePlanVersionId 
                        order by Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Wave_Plan_lk__r.Wave_Label__c,Planned_Date__c];
    }
    /**
     * @Method Name  : kT_Construtor
     * @Description  : Method will get called on load of KT Planning section
     * @Paramenters  : NA
     * @Return Value : NA
     **/
    public void kT_Construtor () {
        strKTPlanningList=[Select Active__c,Activity__c, Milestone__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Planned_Start_Date__c,
                                Planned_End_Date__c, Wave_Plan_lk__r.Wave_Label__c,Wave_Plan_lk__r.NewActive__c,Completed__c,Actual_Start_Date__c,
                                Actual_End_Date__c,Overall_RAG_status_for_Location__c,Comments_for_Location__c,Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c,
                                Overall_RAG_status_for_Wave__c,Tracking_Comments__c, Comments_for_Wave__c,Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c,
                                Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c, Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c,
                                Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,Comments__c,Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c
                                from KT_Planning__c where Wave_Plan_Version__c=:wavePlanVersionId  order by  Location_Name_Wave_Name__c, Activity_Order__c];
    }
    /**
     * @Method Name  : recruitment_Constructor
     * @Description  :  Method will get called on load of Recruitment Tracking section
     * @Paramenters  : NA
     * @Return Value : NA
     **/
    public void recruitment_Constructor() {
        
        strRecruitmentTrackingList=[Select Active__c,Activity__c,Milestone__c, FTE_Number__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                        Planned_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__r.Wave_Label__c,Completed__c,Actual_Start_Date__c,
                                        Actual_End_Date__c,Overall_Recruitment_Planning_RAG_status__c,Overall_RAG_status_for_Location__c,
                                        Comments__c,Comments_for_Location__c, Tracking_Comments__c, is_RAG_status_changed__c, Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c,
                                        Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,
                                        Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c,
                                        Wave_Plan_lk__r.NewActive__c,Wave_Plan_lk__r.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c,
                                        Deal_Location_lk__r.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c, Deal_Location_lk__r.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c, Deal_Location_lk__r.Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c
                                        from Recruitment_Tracking__c where Wave_Plan_Version__c=:wavePlanVersionId  order by  Location_Name_Wave_Name__c, Activity_Order__c];

    }
     /**
     * @Method Name  : oPEX_Construtor
     * @Description  :  Method will get called on load of OPEX section
     * @Paramenters  : NA
     * @Return Value : NA
     **/
    public void oPEX_Construtor() {
        strOPEXList=[Select Item__c,Milestone__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Planned_Date__c, Wave_Plan_lk__r.Wave_Label__c,
                 Completed__c,Actual_Date__c, Individual_Plan_RAG_Status__c,Comments__c,Stablity__c,active__c ,
                 Wave_Plan_lk__r.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c, Tracking_Comments__c, Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,
                 Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c,                 
                 Wave_Process__r.Client_Specific_Process_Mapping__r.name from OPEX__c where Wave_Plan_Version__c=:wavePlanVersionId order by 
                 Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Process__r.Client_Specific_Process_Mapping__r.name,Wave_Plan_lk__r.Wave_Label__c,
                 Planned_Date__c];
    }
     /**
     * @Method Name  : serviceManagement_Construtor
     * @Description  :  Method will get called on load of Service management section
     * @Paramenters  : NA
     * @Return Value : NA
     **/
    public void serviceManagement_Construtor() {
        strServiceManagementList=[Select Activity__c,Milestone__c,Tracking_Comments__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                    Planned_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__r.Wave_Label__c,Completed__c,Actual_Start_Date__c,Actual_End_Date__c 
                                    from Service_Management__c where Wave_Plan_Version__c=:wavePlanVersionId order by createddate];
    }
     /**
     * @Method Name  : journeyManagementConstrutor
     * @Description  :  Method will get called on load of Journey Management Plan section
     * @Paramenters  : NA
     * @Return Value : NA
     **/
    public void journeyManagementConstrutor() {
        strJourneyPlanList= [select name,Active__c,Milestone__c, Cloned_From__c,Comments__c,Deliverable_Name__c,Deliverable_Number__c,Journey_Management_Deliverable_Id__c,
                                 Journey_Management_Id__c,Tracking_Comments__c,Planned_End_Date__c,Planned_Start_Date__c,Responsibility__c,Section_Name__c,Section_Number__c,Version__c,
                                 Completed__c,Actual_Start_Date__c,Actual_End_Date__c,Status__c,
                                 Wave_Plan_Version__c from Journey_Management_Planning__c where Wave_Plan_Version__c=:wavePlanVersionId  
                                 order by Section_Number__c,Deliverable_Number__c]; 
    }
     /**
     * @Method Name  : techAssementConstructor
     * @Description  :  Method will get called on load of T & E section
     * @Paramenters  : NA
     * @Return Value : NA
     **/
    public void techAssementConstructor() {
        strTechAssessmentList=[Select Activity__c,Milestone__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Planned_Start_Date__c, 
                                     Wave_Plan_lk__r.Wave_Label__c,Tracking_Comments__c, Completed__c,Actual_Start_Date__c,Actual_End_Date__c,Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c,
                                     Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c, Wave_Plan_lk__r.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c,
                                     Wave_Plan_lk__r.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c,Wave_Plan_lk__r.Mob_Technology_Lead_Secondary_2__r.SFDC_User__c, Active__c,Comments__c,Planned_End_Date__c
                                     from Tech_Assessment__c where Wave_Plan_Version__c=:wavePlanVersionId order by  Location_Name_Wave_Name__c,Activity_Order__c]; 
    }
     /**
     * @Method Name  : bcpPlan_Constructor
     * @Description  :  Method will get called on load of BCP section
     * @Paramenters  : NA
     * @Return Value : NA
     **/
    public void bcpPlan_Constructor() {
        lstBCPPlan = [select name,Active__c,Milestone__c, Comments__c,Resource_Name__c,Section_Number__c,Section_Name__c,Task_Name__c,Task_Number__c,
                            Planned_End_Date__c,Planned_Start_Date__c,Tracking_Comments__c,BCP_Task_Master_Id__c,BCP_Section_Master_Id__c,Wave_Plan_Version__c,Completed__c,
                            Actual_Start_Date__c,Actual_End_Date__c,Status__c from Business_Continuity_Planning__c 
                            where Wave_Plan_Version__c=:wavePlanVersionId ];
    }
    /**
     * @Class Name  : DealLocation
     * @Description  :  Wrapper Class
     **/
    public class DealLocation {
        public Deal_Location__c newDealLocation{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
       
        /**
         * @Method Name  : DealLocation
         * @Description  :  
         * @Paramenters  : Deal_Location__c,String,boolean,String passing as paramerters for DealLocation
         * @Return Value : NA
         **/
        public DealLocation(Deal_Location__c newDealLocation,String color, boolean isDisabled, String backgroundcolor)  {
            this.newDealLocation=newDealLocation;
            this.color=color;  
            this.isDisabled=isDisabled;  
            this.backgroundcolor=backgroundcolor;
        }       
    }
    
    /******************************
     * @Method Name : getListOfDealLocation
     * @Description : Method to get the list of Locations in Go Go-Live Plan with RAG Status Color.  
     * @Paramenters : NA
     * @Return Value: List<DealLocation>
     *******************************/ 
    public List<DealLocation> getListOfDealLocation() {
        List<DealLocation> listOfDealLocation=new List<DealLocation>();
        String color=null;
        boolean disable;
        String bgcolor=null;
        boolean isAvailable; 
        if(strDealLocationList.size()>0) {
            for(Deal_Location__c l:strDealLocationList) {
                disable=false;
                isAvailable=false;                   
                if(l.Location_RAG_Status__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }    
                if(l.Location_RAG_Status__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }    
                if(l.Location_RAG_Status__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }    
                if(l.Location_RAG_Status__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                }
                if(lstUserRoleAssign.size()>0) {
                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign) {
                        if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                            (mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                            isAvailable=true;   
                        }
                        if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) &&
                             ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                            isAvailable=true;
                        }
                    }
                } 
                if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)
                    || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)) {
                    isAvailable=true;
                } 
                if(isAvailable)  {                   
                    disable=false;
                    bgcolor=UTIL_Constants.color_FFFFFF;
                }
                else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                } 
                else {
                    disable=true;
                    bgcolor=UTIL_Constants.color_EBEBFA;
                    color=UTIL_Constants.color_EBEBFA;
                }
                if(!l.NewActive__c) {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                    color=UTIL_Constants.color_EBEBFA;
                } 
                listOfDealLocation.add(new DealLocation(l,color,disable, bgcolor));
            } 
        }
        return listOfDealLocation;
    }
     /**
     * @Class Name  : DealLocation
     * @Description  :  Wrapper Class for Wave Plan Records
     **/
    public class WavePlanning
    {
        public Wave_Planning__c newWavePlanning{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        /*
         * @Method Name  : WavePlanning 
         * @Description  : Constructor for WavePlanning
         * @Paramenters  : Wave_Planning__c,String,boolean,String paremeters are passing to constructor
         * @Return Value : NA
         */ 
        
        public WavePlanning(Wave_Planning__c newWavePlanning,String color, boolean isDisabled, String backgroundcolor)
        {
            this.newWavePlanning=newWavePlanning;
            this.color=color;  
            this.isDisabled=isDisabled;
            this.backgroundcolor=backgroundcolor; 
        }       
    }
    
    /******************************
     * @Method Name: getListOfWavePlanning
     * @Description: Method to  get the list of Waves in Go Go-Live Plan with RAG Status Color.  
     * @Paramenters: NA
     * @Return Value: List<WavePlanning>
     *******************************/
    public List<WavePlanning> getListOfWavePlanning() {
        List<WavePlanning> listOfWavePlanning=new List<WavePlanning>();
        String color=null;
        Boolean disable=null;
        String bgcolor=null;
        boolean isAvailable;
        if(strWavePlanningList.size()>0) {
            for(Wave_Planning__c w:strWavePlanningList) {
                if(w.Wave_RAG_Status__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }    
                if(w.Wave_RAG_Status__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }
                if(w.Wave_RAG_Status__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }
                if(w.Wave_RAG_Status__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                }
                if(w.NewActive__c) {
                    isAvailable=false;
                    if(lstUserRoleAssign.size()>0) {
                        for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)  {
                            if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) 
                                    && (mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))  {
                                isAvailable=true;   
                            }
                            if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                isAvailable=true;
                            }
                        }
                    }
                    if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)
                        || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)) {
                        isAvailable=true;
                    } 
                    if(isAvailable) {
                        disable=false;
                            bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else  {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA; 
                        color=UTIL_Constants.color_EBEBFA;   
                    }
                }
                if(!w.NewActive__c || !w.Deal_Location__r.NewActive__c)  {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                    color=UTIL_Constants.color_EBEBFA;
                }     
                listOfWavePlanning.add(new WavePlanning(w,color,disable,bgcolor));
            } 
        }
        return listOfWavePlanning;
    }
   //Wave Process
    public class WaveProcess
    {
        public Wave_Process__c newWaveProcess{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
       
        
        public WaveProcess(Wave_Process__c newWaveProcess,String color , boolean isDisabled, String backgroundcolor)
        {
            this.newWaveProcess=newWaveProcess;
            this.color=color;    
            this.isDisabled=isDisabled;  
            this.backgroundcolor=backgroundcolor;
        }       
    }
     /******************************
        *@ Method Name: getListOfWaveProcess
        *@ Description: Method to get the list of Processes in Go Go-Live Plan with RAG Status Color.  
        *@ Paramenters: NA
        *@ Return Value: List<WaveProcess>
    *******************************/  
    public List<WaveProcess> getListOfWaveProcess() {
        List<WaveProcess> listOfWaveProcess=new List<WaveProcess>();
        String color=null;
        boolean disable=false;
        String bgcolor=null;
        boolean isAvailable;
        // Throwing a NullPointerException
        if(strWaveProcessList.size()>0) {
            for(Wave_Process__c p:strWaveProcessList) {
                if(p.Process_RAG_Status__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }
                if(p.Process_RAG_Status__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }
                if(p.Process_RAG_Status__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }
                if(p.Process_RAG_Status__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                }
                isAvailable=false;
                if(lstUserRoleAssign.size()>0) {
                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign) {
                        if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                            (mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                            isAvailable=true;   
                        }
                        if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && 
                            ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                            isAvailable=true;
                        }
                    }
                }  
                if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || 
                    userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)) {
                    isAvailable=true;
                }
                if(isAvailable==true) {
                    disable=false;
                    bgcolor=UTIL_Constants.color_FFFFFF;
                } 
                else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                else {
                    disable=true;
                    bgcolor=UTIL_Constants.color_EBEBFA;
                    color=UTIL_Constants.color_EBEBFA;
                }
                if(!p.Active__c || !p.Wave_Planning__r.NewActive__c) {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                    color=UTIL_Constants.color_EBEBFA;
                }        
                listOfWaveProcess.add(new WaveProcess(p,color, disable, bgcolor));
            }
        } 
        return listOfWaveProcess;
    }
    
    
    /*
     * @Class Name   : SRAT
     * @Method Name  : Constructor for SRAT
     * @Description  : Class for SRAT with RAG Status Color 
     * @Paramenters  : NA
     * @Return Value : NA
     */
          
     public class SRAT
    {
        public SRAT__c newSRAT{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
        /*
         * @Method Name  : SRAT
         * @Description  : constructor for SRAT 
         * @Paramenters  : SRAT__c ,String , boolean , String are the parameter passing to WaveProcess constructor
         * @Return Value : NA
         */
         
        
        public SRAT(SRAT__c newSRAT,String color, boolean isDisabled, String backgroundcolor)
        {
            this.newSRAT=newSRAT;
            this.color=color;  
            this.isDisabled=isDisabled;
            this.backgroundcolor=backgroundcolor;  
        }       
    }
    
    /******************************
    *@ Method Name: getListOfSRAT
    *@ Description: Method to get the list of SRAT with RAG Status Color.  
    *@ Paramenters: NA
    *@ Return Value:List<SRAT>
    *******************************/ 
    public List<SRAT> getListOfSRAT()
    {
        List<SRAT> listOfSRAT=new List<SRAT>();
        String color=null;
        Boolean disable=null;
        String bgcolor=null;
        if(strSRATList.size()>0)
        {
            for(SRAT__c s:strSRATList)
            {
                if(!s.is_RAG_status_changed__c)
                {
                    s.Individual_Plan_RAG_Status__c=UTIL_Constants.NONE;
                    if(s.Planned_Date__c>system.today() && !s.Wave_Plan_lk__r.NewActive__c)
                    {
                        s.Individual_Plan_RAG_Status__c=UTIL_Constants.NONE;
                    }
                    else
                    {
                        s.Individual_Plan_RAG_Status__c=UTIL_Constants.UAM_NOTAPPLICABLE;
                    }
                }
                
                if(s.Individual_Plan_RAG_Status__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }
                if(s.Individual_Plan_RAG_Status__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }
                if(s.Individual_Plan_RAG_Status__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }
                if(s.Individual_Plan_RAG_Status__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                }
                if(s.Active__c)
                { 
                    if((s.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                            s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                            s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() ||                            
                             s.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                             s.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                             s.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId()))  {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || 
                        userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else
                    {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA; 
                        color=UTIL_Constants.color_EBEBFA;   
                    }
                }
                if(!s.Active__c)
                {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                    color=UTIL_Constants.color_EBEBFA;
                }    
                listOfSRAT.add(new SRAT(s,color,disable,bgcolor));
                //strClassSRATList.add(new SRAT(s,color));
            } 
        }
        return listOfSRAT;
    }

/*
     * @Class Name   : OPEX 
     * @Method Name  : OPEX with parameters
     * @Description  : Class for OPEX with RAG Status Color 
     * @Paramenters  : NA
     * @Return Value : NA
     */
    public class OPEX
    {
        public OPEX__c newOPEX{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
    /*
     * @Method Name  : OPEX 
     * @Description  : Class for OPEX with parameters
     * @Paramenters  : OPEX__c,String, boolean, String are the parameters passing to OPEX contructor
     * @Return Value : NA
     */
        public OPEX(OPEX__c newOPEX,String color, boolean isDisabled, String backgroundcolor)
        {
            this.newOPEX=newOPEX;
            this.color=color;  
            this.isDisabled=isDisabled;
            this.backgroundcolor=backgroundcolor;  
        }       
    }
    
    
    /******************************
     *@ Method Name: getListOfOPEX
     *@ Description: Method to get the list of OPEX with RAG Status Color.  
     *@ Paramenters: NA
     *@ Return Value: List<OPEX>
    *******************************/
    public List<OPEX> getListOfOPEX()
    {
        List<OPEX> listOfOPEX=new List<OPEX>();
        String color=null;
        Boolean disable=null;
        String bgcolor=null;
        if(strOPEXList.size()>0)
        {
            for(OPEX__c s:strOPEXList)
            {
                
                if(s.Individual_Plan_RAG_Status__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }
                if(s.Individual_Plan_RAG_Status__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }
                if(s.Individual_Plan_RAG_Status__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }
                if(s.Individual_Plan_RAG_Status__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                }
                if(s.Active__c)
                {
                    if((s.Wave_Plan_lk__r.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId()||
                        s.Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId()))  {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)
                        || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else
                    {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;
                        color=UTIL_Constants.color_EBEBFA;    
                    }
                }
                if(!s.Active__c)
                {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                    color=UTIL_Constants.color_EBEBFA;
                } 
                listOfOPEX.add(new OPEX(s,color,disable,bgcolor));
            }
        } 
        return listOfOPEX;
    }

/*
     * @Class Name   : ServiceManagement
     * @Method Name  : Class for Service Management
     * @Description  : Constructor for ServiceManagement method has been used with parameters
     * @Paramenters  : NA
     * @Return Value : NA
     */
    
    public class ServiceManagement
    {
        public Service_Management__c newServiceManagement{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
    /*
     * @method Name  : ServiceManagement
     * @Description  : Constructor for ServiceManagement
     * @Paramenters  : Service_Management__c , boolean, String parameters are passing to the constructor
     * @Return Value : NA
     */
        public ServiceManagement(Service_Management__c  newServiceManagement, boolean isDisabled, String backgroundcolor )
        {
            this.newServiceManagement=newServiceManagement;
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;
        }
    }
    
        
    /******************************
    *@ Method Name: getListOfService
    *@ Description: Method to get the list of Service mgmt.  
    *@ Paramenters: NA
    *@ Return Value:List<Journey>
    *******************************/ 
    public List<ServiceManagement> getListOfService()
    {   boolean isTask=false;
        boolean isEmpty=false;
        List<ServiceManagement> listOfService=new List<ServiceManagement>();        
        Boolean disable;
        string bgcolor=null;
        boolean isAvailable;
        String noOfSpace=UTIL_Constants.EMPTY_STRING;
            isTask=true;
                List<ServiceManagement> lstServicePlan = new List<ServiceManagement>();
                Integer i=0;
                isEmpty=true;
                boolean isTaskPresent;

                if(lstSeviceMgmtPlan.size()>0)
                {
                    for(Service_Management__c s : lstSeviceMgmtPlan)
                    { 
                            isEmpty=false;
                            if(s.Active__c)
                            {
                                isAvailable=false;
                                if(strDealLocationList.size()>0)
                                {
                                    for(Wave_Planning__c w : strWavePlanningList)
                                    {
                                        if(w.KT_Lead_New__r.SFDC_User__c == UserInfo.getUserId() || 
                                            w.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()||
                                            w.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c == UserInfo.getUserId()) {
                                            isAvailable=true;
                                        }
                                    }
                                }
                                if(lstUserRoleAssign.size()>0)
                                {
                                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                                    {
                                        if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                            ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                            isAvailable=true;
                                        }
                                        if(UTIL_Constants.SERVICE_MANGEMENT_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) &&
                                             ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                            isAvailable=true;
                                        }
                                    }
                                }
                                if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) 
                                    || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN )) {
                                    isAvailable=true;
                                }
                                if(isAvailable)
                                {
                                    disable=false;
                                    bgcolor=UTIL_Constants.color_FFFFFF;
                                }
                                else if(isInlineEdit) {
                                    disable=false;
                                    bgcolor=UTIL_Constants.color_FFFFFF;
                                }
                                else
                                {
                                    disable=true;  
                                    bgcolor=UTIL_Constants.color_EBEBFA;    
                                }
                            }
                            if(!s.Active__c)
                            {
                                disable=true;  
                                bgcolor=UTIL_Constants.color_EBEBFA;
                            } 
                            listOfService.add(new ServiceManagement(s,disable,bgcolor));
                        }
                    } 
               
                /* if(lstServicePlan.size()>0)
                {
                    if(isTask){
                        isTaskPresent = true;
                    }
                    else{
                        isTaskPresent = false;   
                    }
                    isTask=true;
                }
                else if(lstServicePlan.size()==0)
                {
                    if(isTask){
                        isTaskPresent = true;
                    }
                    else{
                        isTaskPresent = false;    
                    }
                    isTask=false;
                } */
             return listOfService;
             }
        
        
    
    
    /*
     * @Class Name   : KTPlan
     * @Method Name  : KTPlan method passing with parameters has been used. 
     * @Description  : Class for KTPlan  
     * @Paramenters  : NA
     * @Return Value : NA
     */
   
   public class KTPlan
    {
        public KT_Planning__c newKTPlan{get; set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
        /*
         * @Method Name  : KTPlan
         * @Description  : Class for KTPlan  
         * @Paramenters  : KT_Planning__c,boolean,String parameters are passing to the method.
         * @Return Value : NA
         */
        public KTPlan(KT_Planning__c newKTPlan, boolean isDisabled,String backgroundcolor)
        {
            this.newKTPlan=newKTPlan;
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;
        }       
    }
    
    /******************************
    *@ Method Name: getListOfKTPlan
    *@ Description: Method to get the list of KT Plan.  
    *@ Paramenters: NA
    *@ Return Value: List<KTPlan>
    *******************************/ 
    public List<KTPlan> getListOfKTPlan()
    {
        List<KTPlan> listOfKTPlan=new List<KTPlan>();
        Boolean disable;
        string bgcolor=null;
        if(strKTPlanningList.size()>0)
        {
            for(KT_Planning__c s : strKTPlanningList)
            {
                
                if(s.Active__c)
                {
                    if((s.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                        s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId()||
                        s.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId())) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;    
                    }
                    if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) ||
                         userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN))  {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                }
                if(!s.Active__c)
                {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                } 
                listOfKTPlan.add(new KTPlan(s,disable,bgcolor));
            }
        } 
        return listOfKTPlan;
    } 
    
     
    /*
     * @Class Name   : Class for Locations in KT Plan with RAG Status Color  
     * @Method Name  : KTPlanLocation method with parameters has been used
     * @Description  :  
     * @Paramenters  : NA
     * @Return Value : NA
     */ 
    public class KTPlanLocation
    {
        public KT_Planning__c newKTPlanLocation{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
        /*
         * @Method Name  : KTPlanLocation
         * @Description  : Constructor for KTPlanLocation  
         * @Paramenters  : KT_Planning__c,String,boolean,String parameters are passing to the method
         * @Return Value : NA
         */
        
        public KTPlanLocation(KT_Planning__c newKTPlanLocation,String color,boolean isDisabled, String backgroundcolor)
        {
            this.newKTPlanLocation=newKTPlanLocation;
            this.color=color; 
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;   
        }       
    }
    
    /******************************
    *@ Method Name: getListOfKTPlanLocation
    *@ Description: Method to get the list of Locations in KT Plan with RAG Status Color.  
    *@ Paramenters: NA
    *@ Return Value: List<KTPlanLocation>
    *******************************/ 
    public List<KTPlanLocation> getListOfKTPlanLocation()
    {
        List<KTPlanLocation> listOfKTPlanLocation=new List<KTPlanLocation>();
        String color=null;
        Boolean disable;
        string bgcolor=null;
        if(strKTPlanningList.size()>0)
        {
            for(KT_Planning__c k :strKTPlanningList)
            {
                flag=false;
                if(ListOfKTPlanLocation.size()>0)
                {
                    for(KTPlanLocation loc:listOfKTPlanLocation)
                    {
                        if(k.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name == 
                                loc.NewKTPlanLocation.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name)  {
                           k.Overall_RAG_status_for_Location__c=loc.NewKTPlanLocation.Overall_RAG_status_for_Location__c;
                           k.Comments_for_Location__c=loc.NewKTPlanLocation.Comments_for_Location__c;
                           if(k.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                                k.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() || 
                                k.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() ||                                 
                                k.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                                k.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                                k.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() ||
                                Test.isRunningTest()== true) {
                               loc.isDisabled=false;
                               loc.backgroundcolor=UTIL_Constants.color_FFFFFF;
                               String newColor=null;
                               if(k.Overall_RAG_status_for_Location__c==UTIL_Constants.AMBER){
                                   newColor=UTIL_Constants.COLOR_AMBER;
                               }
                               if(k.Overall_RAG_status_for_Location__c==UTIL_Constants.RED){
                                   newColor=UTIL_Constants.COLOR_RED;
                               }
                               if(k.Overall_RAG_status_for_Location__c==UTIL_Constants.GREEN){
                                   newColor=UTIL_Constants.COLOR_GREEN;
                               }
                               if(k.Overall_RAG_status_for_Location__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                                   newColor=UTIL_Constants.COLOR_NOTAPPLICABLE;
                               } 
                               loc.color=newColor;  
                                           
                           }
                           flag=true;
                        }
                    }
                }
                
                if(k.Overall_RAG_status_for_Location__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }
                if(k.Overall_RAG_status_for_Location__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }
                if(k.Overall_RAG_status_for_Location__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }
                if(k.Overall_RAG_status_for_Location__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;   
                }
                if(!flag)
                {
                    if(k.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                            k.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                            k.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() || 
                            k.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                            k.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId()||
                            k.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId())  {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) ||
                         userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;
                        color=UTIL_Constants.color_EBEBFA;
                    }
                    listOfKTPlanLocation.add(new KTPlanLocation(k,color,disable,bgcolor));
                }
            }
        } 
        return listOfKTPlanLocation;
    } 
    
     
    /*
     *@ Class Name   : Class for waves in KT Plan with RAG Status Color
     *@ Method Name  : KTPlanWave 
     *@ Description  : Constructor method with passing parameters has been used
     *@ Paramenters  : NA
     *@ Return Value : NA
     */ 
    public class KTPlanWave
    {
        public KT_Planning__c newKTPlanWave{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
        /*
         * @Method Name  : KTPlanWave
         * @Description  : Constructor for KTPlanWave 
         * @Paramenters  : KT_Planning__c ,String , boolean , String parameters are passing to the constructor 
         * @Return Value : NA
         */
        
        public KTPlanWave(KT_Planning__c newKTPlanWave,String color, boolean isDisabled, String backgroundcolor)
        {
            this.newKTPlanWave=newKTPlanWave;
            this.color=color;    
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;  
        }       
    }
    
    /******************************
    *@ Method Name: getListOfKTPlanWave
    *@ Description: Method to get the list of Waves in KT Plan with RAG Status Color.  
    *@ Paramenters: NA
    *@ Return Value: List<KTPlanWave>
    *******************************/ 
    public List<KTPlanWave> getListOfKTPlanWave()
    {
        List<KTPlanWave> listOfKTPlanWave=new List<KTPlanWave>();
        String color=null;
        Boolean disable;
        string bgcolor=null;
        if(strKTPlanningList.size()>0)
        {
            for(KT_Planning__c k :strKTPlanningList)
            {
                flag=false;
                if(ListOfKTPlanWave.size()>0)
                {
                    for(KTPlanWave loc:listOfKTPlanWave)
                    {
                        //To avoid the duplicate Waves per Location in KT plan
                        if(k.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name == 
                            loc.NewKTPlanWave.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name && 
                            k.Wave_Plan_lk__r.Wave_Label__c== loc.NewKTPlanWave.Wave_Plan_lk__r.Wave_Label__c) {
                           k.Overall_RAG_status_for_Wave__c=loc.NewKTPlanWave.Overall_RAG_status_for_Wave__c;
                           k.Comments_for_Wave__c=loc.NewKTPlanWave.Comments_for_Wave__c;
                           flag=true;
                        }
                    }
                }
                
                if(k.Overall_RAG_status_for_Wave__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }
                if(k.Overall_RAG_status_for_Wave__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }
                if(k.Overall_RAG_status_for_Wave__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }
                if(k.Overall_RAG_status_for_Wave__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                }
                if(!flag)
                {
                    if(k.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        k.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        k.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() || 
                        k.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        k.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId()||
                        k.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId()) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    } 
                    else if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) ||
                         userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN))  {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;
                        color=UTIL_Constants.color_EBEBFA;
                    }
                    if(k.Wave_Plan_lk__r.NewActive__c == false) {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;
                        color=UTIL_Constants.color_EBEBFA;
                    } 
                    listOfKTPlanWave.add(new KTPlanWave(k,color,disable,bgcolor));
                }
            }
        } 
        return listOfKTPlanWave;
    }
    
        /*
     * @Class Name   : RecruitmentTracking 
     * @Method Name  : RecruitmentTracking with parameters mathod has been used in  Recruitment Tracking
     * @Description  : Class for Recruitment Tracking with RAG Status Color 
     * @Paramenters  : NA
     * @Return Value : NA
     */
   public class RecruitmentTracking
    {
        public Recruitment_Tracking__c newRecruitmentTracking{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
        
    /*
     * @Method Name  : RecruitmentTracking
     * @Description  : RecruitmentTracking with parameters mathod has been used in  Recruitment Tracking 
     * @Paramenters  : Recruitment_Tracking__c,String,boolean,String are the parameters passing to the method 
     * @Return Value : NA
     */
        public RecruitmentTracking(Recruitment_Tracking__c newRecruitmentTracking,String color, boolean isDisabled,String backgroundcolor)
        {
            this.newRecruitmentTracking=newRecruitmentTracking;
            this.color=color;
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;
        }       
    }
    
    /******************************
    *@ Method Name: getListOfRecruitmentTracking
    *@ Description: Method to get the list of Recruitment Tracking with RAG Status Color.  
    *@ Paramenters: NA
    *@ Return Value: List<RecruitmentTracking>
    *******************************/ 
    public List<RecruitmentTracking> getListOfRecruitmentTracking()
    {
        List<RecruitmentTracking> listOfRecruitmentTracking=new List<RecruitmentTracking>();
        String color=null;
        Boolean disable;
        string bgcolor=null;
        if(strRecruitmentTrackingList.size()>0)
        {
            for(Recruitment_Tracking__c s:strRecruitmentTrackingList)
            {
                color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                if(!s.is_RAG_status_changed__c)
                {
                    s.Overall_Recruitment_Planning_RAG_status__c=UTIL_Constants.NONE;
                    if(s.Planned_End_Date__c>system.today())
                    {
                        s.Overall_Recruitment_Planning_RAG_status__c=UTIL_Constants.NONE;
                    }
                    else
                    {
                        s.Overall_Recruitment_Planning_RAG_status__c=UTIL_Constants.UAM_NOTAPPLICABLE;
                    }
                }
                
                if(s.Overall_Recruitment_Planning_RAG_status__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }
                if(s.Overall_Recruitment_Planning_RAG_status__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }
                if(s.Overall_Recruitment_Planning_RAG_status__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }
                if(s.Overall_Recruitment_Planning_RAG_status__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                }
                if(s.Active__c)
                {
                   
                    if(s.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                        s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c ==UserInfo.getUserId() ||
                        s.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c ==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c  ==UserInfo.getUserId() ||
                        s.Deal_Location_lk__r.Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c  ==UserInfo.getUserId()) {
                    disable=false;
                    bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) ||
                         userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) ) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else
                    {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;
                        color=UTIL_Constants.color_EBEBFA;    
                    }
                }
                if(!s.Active__c)
                {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                    color=UTIL_Constants.color_EBEBFA;
                } 
                listOfRecruitmentTracking.add(new RecruitmentTracking(s,color,disable,bgcolor));
            }
        } 
        return listOfRecruitmentTracking;
    } 
    
    /*
     * @Class Name   :  RecruitmentTrackingLocation
     * @Method Name  :  RecruitmentTrackingLocation with parameters
     * @Description  :  Class for Locations in Recruitment Tracking with RAG Status Color
     * @Paramenters  :  NA
     * @Return Value :  NA
     */
     
    public class RecruitmentTrackingLocation
    {
        public Recruitment_Tracking__c newRecruitmentTrackingLocation{get; set;}
        public String color{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
    /*
     * @Method Name  :  RecruitmentTrackingLocation
     * @Description  :  Copnstructor for RecruitmentTrackingLocation
     * @Paramenters  :  Recruitment_Tracking__c ,String , boolean, String parameters are passing to the constructor
     * @Return Value :  NA
     */
        public RecruitmentTrackingLocation(Recruitment_Tracking__c newRecruitmentTrackingLocation,String color, boolean isDisabled, String backgroundcolor)
        {
            this.newRecruitmentTrackingLocation=newRecruitmentTrackingLocation;
            this.color=color; 
            this.isDisabled=isDisabled;
            this.backgroundcolor=backgroundcolor; 
        }       
    }
    
    /******************************
    *@ Method Name: getListOfRecruitmentTrackingLocation
    *@ Description: Method to get the list of Locations in Recruitment Tracking with RAG Status Color.  
    *@ Paramenters: NA
    *@ Return Value:List<RecruitmentTrackingLocation>
    *******************************/ 
    public List<RecruitmentTrackingLocation> getListOfRecruitmentTrackingLocation()
    {
        List<RecruitmentTrackingLocation> listOfRecruitmentTrackingLocation=new List<RecruitmentTrackingLocation>();
        String color=null;
        Boolean disable;
        string bgcolor=null;
        if(strRecruitmentTrackingList.size()>0)
        {
            for(Recruitment_Tracking__c s:strRecruitmentTrackingList)
            {    
               // if(s.Active__c){
                flag=false;
                if(ListOfRecruitmentTrackingLocation.size()>0)
                {    
                    for(RecruitmentTrackingLocation loc:listOfRecruitmentTrackingLocation)
                    {
                        //To avoid the duplicate Locations in Recruitment Tracking
                       if(s.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name == 
                            loc.NewRecruitmentTrackingLocation.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name)  {
                            s.Overall_RAG_status_for_Location__c=loc.NewRecruitmentTrackingLocation.Overall_RAG_status_for_Location__c;
                            s.Comments_for_Location__c=loc.NewRecruitmentTrackingLocation.Comments_for_Location__c;
                            if(s.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                                s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                                s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                                 s.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c ==UserInfo.getUserId() || 
                                 s.Wave_Plan_lk__r.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c ==UserInfo.getUserId() || Test.isRunningTest() == true) {
                               loc.isDisabled=false;
                               loc.backgroundcolor=UTIL_Constants.color_FFFFFF;
                               String newColor=null;
                               if(s.Overall_RAG_status_for_Location__c==UTIL_Constants.AMBER){
                                   newColor=UTIL_Constants.COLOR_AMBER;
                               }
                               if(s.Overall_RAG_status_for_Location__c==UTIL_Constants.RED){
                                   newColor=UTIL_Constants.COLOR_RED;
                               }
                               if(s.Overall_RAG_status_for_Location__c==UTIL_Constants.GREEN){
                                   newColor=UTIL_Constants.COLOR_GREEN;
                               }
                               if(s.Overall_RAG_status_for_Location__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                                   newColor=UTIL_Constants.COLOR_NOTAPPLICABLE;
                               }
                               loc.color=newColor;  
                                           
                           }
                           flag=true;
                        }
                    }
                }
                
                if(s.Overall_RAG_status_for_Location__c==UTIL_Constants.AMBER){
                    color=UTIL_Constants.COLOR_AMBER;
                }
                if(s.Overall_RAG_status_for_Location__c==UTIL_Constants.RED){
                    color=UTIL_Constants.COLOR_RED;
                }
                if(s.Overall_RAG_status_for_Location__c==UTIL_Constants.GREEN){
                    color=UTIL_Constants.COLOR_GREEN;
                }
                if(s.Overall_RAG_status_for_Location__c==UTIL_Constants.UAM_NOTAPPLICABLE){
                    color=UTIL_Constants.COLOR_NOTAPPLICABLE;
                }
                if(!flag)
                {
                    if(s.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                        s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c ==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c ==UserInfo.getUserId()) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || 
                        userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) ) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;
                        color=UTIL_Constants.color_EBEBFA;
                    }
                    if(!s.Wave_Plan_lk__r.NewActive__c) {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;
                        color=UTIL_Constants.color_EBEBFA;
                    }
                    
                    listOfRecruitmentTrackingLocation.add(new RecruitmentTrackingLocation(s,color,disable,bgcolor));
                }
            }
          //  }
        } 
        return listOfRecruitmentTrackingLocation;
    }
    
    /*
     * @Class Name   : CommercialPlan
     * @Method Name  : Constructor for CommercialPlan
     * @Description  : Class for Commercial Plan
     * @Paramenters  : NA
     * @Return Value : NA
     */
    
   public class CommercialPlan
    {
        public Commercial_Planning__c newCommercialPlan{get; set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
       /*
        * @Method Name  : CommercialPlan
        * @Description  : Constructor method has been used in the CommercialPlan class  
        * @Paramenters  : Commercial_Planning__c, boolean,String parameters are passing to the constructor
        * @Return Value : NA
        */
        public CommercialPlan(Commercial_Planning__c newCommercialPlan, boolean isDisabled,String backgroundcolor)
        {
            this.newCommercialPlan=newCommercialPlan;
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;
        }       
    }
    /******************************
    *@ Method Name: getListOfCommercialPlan
    *@ Description: Method to get the list of Commercial Plan.  
    *@ Paramenters: NA
    *@ Return Value: List<CommercialPlan>
    *******************************/ 
    public List<CommercialPlan> getListOfCommercialPlan()
    {
        List<CommercialPlan> listOfCommercialPlan=new List<CommercialPlan>();
        Boolean disable;
        string bgcolor=null;
        boolean isAvailable;
        if(strCommercialPlanningList.size()>0)
        {
            for(Commercial_Planning__c c : strCommercialPlanningList)
            {
                
                if(c.Active__c)
                {
                    isAvailable=false;
                    if(lstUserRoleAssign.size()>0)
                    {
                        for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                        {
                            
                            if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) &&
                                 ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                isAvailable=true;
                            }
                        }
                    }
                    if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || 
                        userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)) {
                        isAvailable=true;
                    }
                    if(isAvailable)
                    {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else
                    {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;    
                    }
                }
                if(!c.Active__c)
                {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                } 
                listOfCommercialPlan.add(new CommercialPlan(c,disable,bgcolor));
            
            }
        } 
        
        return listOfCommercialPlan;
    }
    /*
     * @Class Name   : ContractLegalInfosec
     * @Method Name  : ContractLegalInfosec
     * @Description  : Class for Contract/Legal Infosec
     * @Paramenters  : NA
     * @Return Value : NA
     */
    
    public class ContractLegalInfosec
    {
        public Contract_Legal_Infosec__c  newContractLegalInfosec{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        /*
         * @Method Name  : ContractLegalInfosec
         * @Description  : ContractLegalInfosec has been passing with parameters in the ContractLegalInfosec class
         * @Paramenters  : Contract_Legal_Infosec__c , boolean, String parameters are passing to the constuctor
         * @Return Value : NA
         */
        public ContractLegalInfosec(Contract_Legal_Infosec__c newContractLegalInfosec, boolean isDisabled, String backgroundcolor )
        {
            this.newContractLegalInfosec=newContractLegalInfosec;
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;
        }
    }
    
    
       /******************************
    *@ Method Name: getListOfContract
    *@ Description: Method to get the list of Contract Plans.  
    *@ Paramenters: NA
    *@ Return Value:List<ContractLegalInfosecMaster>
    *******************************/ 
    public List<ContractLegalInfosec> getListOfContract()
    {
        List<ContractLegalInfosec> listOfContract=new List<ContractLegalInfosec>();
                
        boolean isEmpty;
        Boolean disable;
        string bgcolor=null;
           if(strContractLegalInfosecList.size()>0)
                {
                    for(Contract_Legal_Infosec__c  c : strContractLegalInfosecList)
                    { 
                           isEmpty=false;
                            if(c.Active__c)
                            {
                                boolean isAvailable=false;
                                if(lstUserRoleAssign.size()>0)
                                {
                                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                                    {
                                        if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                            (mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId() )) {
                                            isAvailable=true;
                                        }
                                        if(UTIL_Constants.CONTRACT_AND_LEAGAL_INFOSEC_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                            ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                            isAvailable=true;
                                        }
                                    }
                                }
                                if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) ||
                                     userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)) {
                                    isAvailable=true;
                                }
                                if(isAvailable)
                                {
                                    disable=false;
                                    bgcolor=UTIL_Constants.color_FFFFFF;
                                }
                                else if(isInlineEdit) {
                                    disable=false;
                                    bgcolor=UTIL_Constants.color_FFFFFF;
                                }
                                else {
                                    disable=true;  
                                    bgcolor=UTIL_Constants.color_EBEBFA;    
                                }
                            }
                            if(!c.Active__c)
                            {
                                disable=true;  
                                bgcolor=UTIL_Constants.color_EBEBFA;
                            } 
                            listOfContract.add(new ContractLegalInfosec(c,disable,bgcolor));
                        }
                    } 
                return listOfContract;                    
                }
                                 
    
    /*
     *@ Class Name   : TechAssessment
     *@ Method Name  : Constructor TechAssessment
     *@ Description  : Constructor TechAssessment has been used
     *@ Paramenters  : NA
     *@ Return Value : NA
     */
        
   public class TechAssessment
    {
        public Tech_Assessment__c newTechAssessment{get; set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
        /*
         *@ Method Name  : Constructor for TechAssessment
         *@ Description  : Constructor for TechAssessment has passing with parameters 
         *@ Paramenters  : Tech_Assessment__c, boolean,String parameters are passin to the constructor
         *@ Return Value : NA
         */ 
        
        public TechAssessment(Tech_Assessment__c newTechAssessment, boolean isDisabled,String backgroundcolor)
        {
            this.newTechAssessment=newTechAssessment;
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;
        }       
    }
    
    /******************************
    *@ Method Name: getListOfTechAssessment
    *@ Description: Method to get the list of Tech Assessment Plan.  
    *@ Paramenters: NA
    *@ Return Value: List<TechAssessment>
    *******************************/ 
    public List<TechAssessment> getListOfTechAssessment()
    {
        List<TechAssessment> listOfTechAssessment=new List<TechAssessment>();
        Boolean disable;
        string bgcolor=null;
        if(strTechAssessmentList.size()>0)
        {
            for(Tech_Assessment__c s : strTechAssessmentList)
            {
                
                if(s.Active__c)
                {
                    if(s.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                        s.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c==UserInfo.getUserId() || 
                        s.Wave_Plan_lk__r.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() ||
                        s.Wave_Plan_lk__r.Mob_Technology_Lead_Secondary_2__r.SFDC_User__c==UserInfo.getUserId()) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else if(isInlineEdit) {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                    else  {
                        disable=true;  
                        bgcolor=UTIL_Constants.color_EBEBFA;    
                    }
                    if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || 
                        userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN))  {
                        disable=false;
                        bgcolor=UTIL_Constants.color_FFFFFF;
                    }
                }
                if(!s.Active__c)
                {
                    disable=true;  
                    bgcolor=UTIL_Constants.color_EBEBFA;
                } 
                listOfTechAssessment.add(new TechAssessment(s,disable,bgcolor));
            }
        } 
        return listOfTechAssessment;
    } 
    /*
     * @Class Name   :  JourneyManagement
     * @Method Name  :  Constructor for JourneyManagement method has been used
     * @Description  :  Class for Journey Management
     * @Paramenters  :  NA
     * @Return Value :  NA
     */
    public class JourneyManagement
    {
        public Journey_Management_Planning__c newJourneyManagement{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
    /*
     * @Method Name  : JourneyManagement
     * @Description  : Constructor for JourneyManagement with passing parameters
     * @Paramenters  : Journey_Management_Planning__c, boolean , String parameters are passing to the constructor 
     * @Return Value : NA
     */
        public JourneyManagement(Journey_Management_Planning__c newJourneyManagement, boolean isDisabled, String backgroundcolor )
        {
            this.newJourneyManagement=newJourneyManagement;
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;
        }
    }
    
    
    /******************************
    *@ Method Name: getListOfJourney
    *@ Description: Method to get the list of Journey.  
    *@ Paramenters: NA
    *@ Return Value:List<Journey>
    *******************************/ 
    public List<JourneyManagement> getListOfJourney()
    {
        List<JourneyManagement> listOfJourney =new List<JourneyManagement>();
        boolean isEmpty;
        Boolean disable;
        string bgcolor=null;
        boolean isAvailable;   
        if(strJourneyPlanList.size()>0)
                      
                for(Journey_Management_Planning__c j : strJourneyPlanList)
                    { 
                        if(j.Active__c)
                            {
                               isAvailable=false;
                                if(lstUserRoleAssign.size()>0)
                                {
                                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                                    {
                                        if(UTIL_Constants.JOURNEY_MANGEMENT_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                            (mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                            isAvailable=true;
                                        }
                                        if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                            ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                            isAvailable=true;
                                        }
                                    }
                                }
                                if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) ||
                                     userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)) {
                                    isAvailable=true;
                                }
                                if(isAvailable) {
                                    disable=false;
                                    bgcolor=UTIL_Constants.color_FFFFFF;
                                }
                                else if(isInlineEdit) {
                                    disable=false;
                                    bgcolor=UTIL_Constants.color_FFFFFF;
                                }
                                else {
                                    disable=true;  
                                    bgcolor=UTIL_Constants.color_EBEBFA;    
                                }
                            }
                            if(!j.Active__c)
                            {
                                disable=true;  
                                bgcolor=UTIL_Constants.color_EBEBFA;
                            } 
                            listOfJourney.add(new JourneyManagement(j,disable,bgcolor));
                        }
                         return listOfJourney;                        
                    } 
                 
    /*
     * @Class Name   : BusinessContinuity 
     * @Method Name  : constructor BusinessContinuity passing with parameters 
     * @Description  : Class for BusinessContinuity Planning 
     * @Paramenters  : NA
     * @Return Value : NA
     */
    
    public class BusinessContinuity
    {
        public Business_Continuity_Planning__c newBusinessContinuity{get;set;}
        public boolean isDisabled{get;set;}
        public String backgroundcolor{get;set;}
        
        /*
         * @Method Name  : BusinessContinuity
         * @Description  : Constructor for BusinessContinuity
         * @Paramenters  : Business_Continuity_Planning__c, boolean, String parameters are passing to the constructor 
         * @Return Value : NA
         */
        public BusinessContinuity(Business_Continuity_Planning__c newBusinessContinuity, boolean isDisabled, String backgroundcolor )
        {
            this.newBusinessContinuity=newBusinessContinuity;
            this.isDisabled= isDisabled ;  
            this.backgroundcolor=backgroundcolor;
        }
    }
    
    
    /******************************
    *@ Method Name: getListOfBCP
    *@ Description: Method to get the list of BCP.  
    *@ Paramenters: NA
    *@ Return Value:List<BCP>
    *******************************/ 
    public List<BusinessContinuity> getListOfBCP()
    {
        List<BusinessContinuity> listOfBCP=new List<BusinessContinuity>();        
        Boolean disable;
        string bgcolor=null;
        boolean isEmpty;
        boolean isAvailable=false;
        if(lstBCPMaster.size()>0)
        {
            
                    for(Business_Continuity_Planning__c b : lstBCPPlan )
                    { 
                        
                        if(b.Active__c)
                            {
                                isAvailable=false;
                                if(lstUserRoleAssign.size()>0)
                                {
                                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                                    {
                                        if(UTIL_Constants.BUSINESS_CONTINUNITY_PLANING_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                            (mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                            isAvailable=true;   
                                        }
                                        if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                            ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))  {
                                            isAvailable=true;
                                        }
                                    }
                                }
                                if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) 
                                    || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN ))  {
                                    isAvailable=true;
                                }
                                if(isAvailable)
                                {
                                    disable=false;
                                    bgcolor=UTIL_Constants.color_FFFFFF;
                                }
                                else if(isInlineEdit) {
                                    disable=false;
                                    bgcolor=UTIL_Constants.color_FFFFFF;
                                }
                                else
                                {
                                    disable=true;  
                                    bgcolor=UTIL_Constants.color_EBEBFA;    
                                }
                            }
                            if(!b.Active__c)
                            {
                                disable=true;  
                                bgcolor=UTIL_Constants.color_EBEBFA;
                            } 
                            listOfBCP.add(new BusinessContinuity(b,disable,bgcolor));
                        }
                    } 
                    return listOfBCP;
                    
                }

     /******************************
    *@ Method Name: SaveDealTrackFields
    *@ Description: Method to save Oprational Maturity Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveDealTrackFields() {
        try{
            Wave_Plan_Version__c homeWPV = [Select Pre_Contract__c, Go_Live_Critical_Path__c,Issue1__c,Action1__c,Overall_Deal_RAG_Comments1__c
                                             From Wave_Plan_Version__c Where Id =: wpv.Id];
            homeWPV.Pre_Contract__c = wpv.Pre_Contract__c;
            homeWPV.Go_Live_Critical_Path__c = wpv.Go_Live_Critical_Path__c;
            homeWPV.Issue1__c = wpv.Issue1__c;
            homeWPV.Action1__c = wpv.Action1__c;
            homeWPV.Overall_Deal_RAG_Comments1__c = wpv.Overall_Deal_RAG_Comments1__c;
            Database.update(homeWPV);
            Database.update(strDealTGP);
            //wpv_Load();
        }
        catch(Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SAVE_DEAL_TRACK_FIELD, null, 
                         System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return;
    }
    /******************************
    *@ Method Name: SaveGoLivePlan
    *@ Description: Method to save Go Live Plan Tracking Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveGoLivePlan()  {
        try  {
            List<wave_planning__c> lstWavePlanNew = new List<wave_planning__c>();
            Boolean isError = false;
            lstWavePlanNew.addAll(strWavePlanningList);
            List<Wave_Planning__c> lstWavePlanOld = [Select Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c,Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c,
                                            Mob_Technology_Lead_Secondary_New__r.SFDC_User__c,Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c,Mob_Technology_Lead_Secondary_2__r.SFDC_User__c,
                                            Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Label__c,Wave_Completion_Status__c,
                                            Wave_RAG_Status__c,Wave_Comment__c,KT_Lead_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c,
                                            NewActive__c,GO_Live_Date_del__c,Revised_Go_Live__c,Revised_Go_Live_Comments__c,Actual_Go_Live__c,Actual_Go_Live_Comments__c,
                                            Wave_Status__c,Deal_Location__r.NewActive__c from Wave_Planning__c 
                                            where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId order by createddate]; 
            for(integer i=0;i<lstWavePlanNew.size();i++){
                 if(lstWavePlanNew[i].Revised_Go_Live__c==null){
                     lstWavePlanNew[i].addError('Revised Go live date cannot be blank');
                     isError = true;
                     break;
                 }
                 if(lstWavePlanNew[i]!=null && lstWavePlanOld[i]!=null){
                     if(   (lstWavePlanOld[i].Revised_Go_Live__c==null && 
                            lstWavePlanNew[i].Revised_Go_Live__c!=lstWavePlanNew[i].GO_Live_Date_del__c &&  
                            lstWavePlanNew[i].Revised_Go_Live_Comments__c==null) ||
                           (lstWavePlanOld[i].Revised_Go_Live__c!=null &&
                            lstWavePlanOld[i].Revised_Go_Live__c!=lstWavePlanNew[i].Revised_Go_Live__c && 
                            lstWavePlanNew[i].Revised_Go_Live_Comments__c==null)
                       ){
                        
                           lstWavePlanNew[i].addError('Insert comment under Revised Go Live Comments as the Revised Go live date is changed for the Wave');
                           isError = true;
                           break; 
                        }
                }
                  
            }
            if(!isError){
            
            
                Database.update(strDealLocationList);
                Database.update(strWavePlanningList);
                Database.update(strWaveProcessList);
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
            }
        }
        catch(Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SAVE_GO_LIVE_PLAN, null, 
                         System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
       
        return;
    }
    
    /******************************
    *@ Method Name: SaveSRAT
    *@ Description: Method to save SRAT Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveSRAT() {
        List<SRAT__c> updatedSRATList = new List<SRAT__c>();
        List<SRAT__c> tempSRATList=[select is_RAG_status_changed__c, Milestone__c, Individual_Plan_RAG_Status__c from SRAT__c where Wave_Plan_Version__c=:wavePlanVersionId];
        try {
            Wave_Plan_Version__c sratWPV = [Select SRAT_Overall_Completion_Status__c, SRAT_Overall_RAG_Status__c,SRAT_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            sratWPV.SRAT_Comments__c = wpv.SRAT_Comments__c;
            sratWPV.SRAT_Overall_Completion_Status__c = wpv.SRAT_Overall_Completion_Status__c;
            sratWpv.SRAT_Overall_RAG_Status__c = wpv.SRAT_Overall_RAG_Status__c;                             
            if(tempSRATList.size()>0) {
                for(SRAT__c oldSRATList: tempSRATList) {
                    if(strSRATList.size()>0) {
                        for(SRAT__c newSRATList : strSRATList)  {
                            if(oldSRATList.id==newSRATList .id) {
                                if(oldSRATList.Individual_Plan_RAG_Status__c !=newSRATList.Individual_Plan_RAG_Status__c || newSRATList.Planned_Date__c<=system.today()) {
                                   newSRATList.is_RAG_status_changed__c=true;
                                }
                            //try {
                                if(newSRATList.active__c) {    /*
                                    if(newSRATList.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() 
                                        ||newSRATList.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() 
                                        || newSRATList.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c ==UserInfo.getUserId() 
                                        || newSRATList.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() 
                                        || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) 
                                        || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) 
                                        || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)
                                        || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) 
                                        || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)
                                        || isDealPMO )*/
                                           //Database.update(wpv,false);
                                           updatedSRATList.add(newSRATList);
                                           //Database.update(newSRATList,false);
                                    }
                                }
                            } 
                        } 
                    }
                }
                Database.update(sratWpv);
                if(!updatedSRATList.isEmpty()) {
                    Database.update(updatedSRATList);
                }
                wpv_Load();
            }
            catch(Exception ex)  {
                UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SAVESTAT, null, 
                         System.Logginglevel.ERROR); 
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
                return;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
            return;
    }
     /******************************
    *@ Method Name: SaveOppMaturity
    *@ Description: Method to save Oprational Maturity Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveOppMaturity() {
        try{
            Wave_Plan_Version__c opexWPV = [Select OPEX_Overall_Completion_Status__c, OPEX_Overall_RAG_Status__c,OPEX_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            opexWPV.OPEX_Overall_Completion_Status__c = wpv.OPEX_Overall_Completion_Status__c;
            opexWPV.OPEX_Overall_RAG_Status__c = wpv.OPEX_Overall_RAG_Status__c;
            opexWPV.OPEX_Comments__c = wpv.OPEX_Comments__c;
            Database.update(strOPEXList);
            Database.update(opexWPV);      
            //wpv_Load();  
            }
        catch(Exception ex)  {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveOppMaturity, null, 
                                                    System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return;
    }
     /******************************
    *@ Method Name: SaveServiceMgmt
    *@ Description: Method to save Service Management Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveServiceMgmt() {
        boolean isAvailable;
        if(lstSeviceMgmtPlan.size()>0) {
            for(Service_Management__c s : lstSeviceMgmtPlan) {
                if(s.Active__c) {
                    isAvailable=false;
                    if(strDealLocationList.size()>0) {
                        for(Wave_Planning__c w : strWavePlanningList) {
                            if(w.KT_Lead_New__r.SFDC_User__c == UserInfo.getUserId() || w.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()|| w.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c == UserInfo.getUserId()) {
                                  isAvailable=true;
                            }
                        }
                    }
                    if(lstUserRoleAssign.size()>0) {
                        for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign) {
                            if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                   isAvailable=true;
                            }
                            if(UTIL_Constants.SERVICE_MANGEMENT_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && 
                                    ( mobUser.User_Assigned_New__r.SFDC_User__c ==  UserInfo.getUserId() || mobUser.User_Assigned_secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) {
                                    isAvailable=true;
                            }
                        }
                    }
                    if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) 
                            || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN ))  {
                            isAvailable=true;
                    }
                }
            }
        }    
        try{
            Wave_Plan_Version__c smWPV = [Select Service_Overall_Completion_Status__c, Service_Overall_RAG_Status__c, Service_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            smWpv.Service_Overall_Completion_Status__c = wpv.Service_Overall_Completion_Status__c;
            smWpv.Service_Overall_RAG_Status__c = wpv.Service_Overall_RAG_Status__c;
            smWpv.Service_Comments__c = wpv.Service_Comments__c;
            Database.update(smWPV);
            Database.update(lstSeviceMgmtPlan); 
            //wpv_Load();
        }
        catch(Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveServiceManagement, null, 
                                                    System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return; 
    }
    
     /******************************
    *@ Method Name: SaveKTPlan
    *@ Description: Method to save KT Plan Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveKTPlan() {
        getListOfKTPlanLocation();
        getListOfKTPlanWave();
        try{
            Wave_Plan_Version__c ktWPV = [Select KT_Plan_Overall_Completion_Status__c, KT_Plan_Overall_RAG_Status__c, KT_Plan_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            ktWPV.KT_Plan_Overall_Completion_Status__c = wpv.KT_Plan_Overall_Completion_Status__c;
            ktWPV.KT_Plan_Overall_RAG_Status__c = wpv.KT_Plan_Overall_RAG_Status__c;
            ktWPV.KT_Plan_Comments__c = wpv.KT_Plan_Comments__c;
            Database.update(ktWPV);
            Database.update(strKTPlanningList);
            //wpv_Load();
        }
        catch(Exception ex)  {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveKTlPlan, null, 
                                                        System.Logginglevel.ERROR);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return;
    }
     /******************************
    *@ Method Name: SaveRecruitmentPlan
    *@ Description: Method to save KT Plan Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveRecruitmentPlan() {
        getListOfRecruitmentTrackingLocation();
        List<Recruitment_Tracking__c> tempRecruitmentList=[select Overall_RAG_status_for_Location__c,Comments_for_Location__c, is_RAG_status_changed__c, Overall_Recruitment_Planning_RAG_status__c 
                                                                from Recruitment_Tracking__c where Wave_Plan_Version__c=:wavePlanVersionId];
        List<Recruitment_Tracking__c> recruitmentListToUpsert=new List<Recruitment_Tracking__c>();
        if(tempRecruitmentList.size()>0) {
            for(Recruitment_Tracking__c oldRecruitmentList: tempRecruitmentList) {
                if(strRecruitmentTrackingList.size()>0) {
                    for(Recruitment_Tracking__c newRecruitmentList : strRecruitmentTrackingList)  {
                        if(oldRecruitmentList.id==newRecruitmentList.id) {
                            if(oldRecruitmentList.Overall_Recruitment_Planning_RAG_status__c!=newRecruitmentList.Overall_Recruitment_Planning_RAG_status__c|| 
                                    newRecruitmentList.Planned_End_Date__c<=system.today()) {
                                newRecruitmentList.is_RAG_status_changed__c=true;
                            }
                           // if(newRecruitmentList.active__c) {
                               /*if(newRecruitmentList.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() 
                                   ||newRecruitmentList.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() 
                                   || newRecruitmentList.Deal_Location_lk__r.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c ==UserInfo.getUserId() 
                                   || newRecruitmentList.Deal_Location_lk__r.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c  ==UserInfo.getUserId() 
                                   || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) 
                                   || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN)
                                   || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)
                                   || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) 
                                   || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN)
                                   || isDealPMO )*/
                               recruitmentListToUpsert.add(newRecruitmentList);
                          // }
                        }
                    } 
                } 
            }
        }
        try {
            Wave_Plan_Version__c rtWPV = [Select Recruit_Overall_Completion_Status__c, Recruit_Overall_RAG_Status__c, Recruit_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            rtWPV.Recruit_Overall_Completion_Status__c = wpv.Recruit_Overall_Completion_Status__c;
            rtWPV.Recruit_Overall_RAG_Status__c = wpv.Recruit_Overall_RAG_Status__c;
            rtWPV.Recruit_Comments__c = wpv.Recruit_Comments__c;
            Database.update(rtWPV);
            Database.update(recruitmentListToUpsert);
           // wpv_Load();
        }
        catch(Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveRecruitementlPlan, null, 
                                                    System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return;
    }
    /******************************
    *@ Method Name: SaveCommercialPlan
    *@ Description: Method to save Commercial Plan Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveCommercialPlan() {
        try{
            Wave_Plan_Version__c cpWPV = [Select Commerce_Overall_Completion_Status__c, Commerce_Overall_RAG_Status__c, Commerce_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            cpWPV.Commerce_Overall_Completion_Status__c = wpv.Commerce_Overall_Completion_Status__c;
            cpWPV.Commerce_Overall_RAG_Status__c = wpv.Commerce_Overall_RAG_Status__c;
            cpWPV.Commerce_Comments__c = wpv.Commerce_Comments__c;
            Database.update(cpWPV);
            Database.update(strCommercialPlanningList);
            //wpv_Load();
        }
        catch(Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveCommercialPlan, null, 
                                                        System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return;
    }
    
    /******************************
    *@ Method Name: SaveContractLegalInfosec
    *@ Description: Method to save Contract/ Legal Infosec Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveContractLegalInfosec() {
        try{
            Wave_Plan_Version__c cLiWPV = [Select Contract_Overall_Completion_Status__c, Contract_Overall_RAG_Status__c, Contract_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            cLiWPV.Contract_Overall_Completion_Status__c = wpv.Contract_Overall_Completion_Status__c;
            cLiWPV.Contract_Overall_RAG_Status__c = wpv.Contract_Overall_RAG_Status__c;
            cLiWPV.Contract_Comments__c = wpv.Contract_Comments__c;
            Database.update(strDealLocationList);
            Database.update(cLiWPV);
            Database.update(strContractLegalInfosecList);
            //wpv_Load();
        }
        catch(Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveContractLI, null, 
                                                        System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return;
    }
    /******************************
    *@ Method Name: SaveTechEnablement
    *@ Description: Method to save Technology & Work Enablement Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveTechEnablement() {
        try{
            Wave_Plan_Version__c teWPV = [Select Tech_Overall_Completion_Status__c, Tech_Overall_RAG_Status__c, Tech_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            teWPV.Tech_Overall_Completion_Status__c = wpv.Tech_Overall_Completion_Status__c;
            teWPV.Tech_Overall_RAG_Status__c = wpv.Tech_Overall_RAG_Status__c;
            teWPV.Tech_Comments__c = wpv.Tech_Comments__c;
            Database.update(teWPV);
            Database.update(strTechAssessmentList);
            //wpv_Load();
        }
        catch(Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveTechEnable, null, 
                                                        System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return;
    }
    /******************************
    *@ Method Name: SaveJourneyManagement
    *@ Description: Method to save Journey Manaement Plan Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveJourneyManagement() {
        try{
            Wave_Plan_Version__c jmWPV = [Select Journey_Overall_Completion_Status__c, Jou_Overall_RAG_Status__c, JourneyMgmt_Comments__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            jmWPV.Journey_Overall_Completion_Status__c = wpv.Journey_Overall_Completion_Status__c;
            jmWPV.Jou_Overall_RAG_Status__c = wpv.Jou_Overall_RAG_Status__c;
            jmWPV.JourneyMgmt_Comments__c = wpv.JourneyMgmt_Comments__c;
            Database.update(jmWPV);
            Database.update(strJourneyPlanList);
            //wpv_Load();
        }
        catch(Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveJourenyManagement, null, 
                                                        System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
        return;   
    }
    
    /******************************
    *@ Method Name: SaveBCPPlan
    *@ Description: Method to save Business Continuity Plan Records of All the Objects.  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void SaveBCPPlan() {
        try{
            Wave_Plan_Version__c bcpWPV = [Select BCP_Overall_Completion_Status__c, BCP_Overall_RAG_Status__c, BCP_Comments_for_deal_Tracking__c From Wave_Plan_Version__c
                                         Where Id =: wpv.Id];
            bcpWPV.BCP_Overall_Completion_Status__c = wpv.BCP_Overall_Completion_Status__c;
            bcpWPV.BCP_Overall_RAG_Status__c = wpv.BCP_Overall_RAG_Status__c;
            bcpWPV.BCP_Comments_for_deal_Tracking__c = wpv.BCP_Comments_for_deal_Tracking__c;
            Database.update(bcpWPV);
            Database.update(lstBCPPlan);
            wpv_Load();
        }
        catch(Exception ex)  {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SaveBCPPlan, null, 
                                                        System.Logginglevel.ERROR); 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.EMPTY_STRING+ex.getdmlMessage(0)));
            return;
         }
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Save_Successfully_Message));
         return;   
    }
 
 // release 1.7-MOB-2 user story : to initialise the Revised Go Live Date with Planned Go Live Date   
    /******************************
    *@ Method Name: onLoad
    *@ Description: Onload initialise Revised Go Live Date  
    *@ Paramenters: NA
    *@ Return Value: void 
    *******************************/ 
    public void onLoad() {

            for(Wave_Planning__c w : strWavePlanningList){
                if(w.Revised_Go_Live__c == null){
                    w.Revised_Go_Live__c=w.GO_Live_Date_del__c;
                }
                
            }
            
    }
}