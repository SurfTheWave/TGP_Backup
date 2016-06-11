/*
Author :  Rangappa / Vinay
Story  :  UAM New Changes - Release 2.2 
Description : New UAM Implementation.


Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
global without sharing class UAMSolMobUtility 
{
    public static boolean isAddVisible_MURAssign = false;
    public static boolean isNA_MURAssign = false; 
    
    public static boolean isSaveVisible_DealOpp = false;
    public static boolean isAddVisible_DealOpp = false;
    public static boolean isNA_DealOpp = false; 
    
    public static boolean isSaveVisible_DealHome = false;
    public static boolean isAddVisible_DealHome = false;
    public static boolean isNA_DealHome = false; 
    
    public static boolean saveEditButtonRender_DealInfo = false;
    
    public static boolean isAddVisible_CSpecific = false; 
    public static boolean isEditVisible_CSpecific = false;
    public static boolean isNA_CSpecific = false;
    
    public static boolean isWPVAccess_WPV = false;
    public static boolean isWPVAccess_WPV_C = false;
    
    public static boolean isAddVisible_DealLoc = false; 
    public static boolean isWaveVersionActive_DealLoc = false;
    public static boolean isNA_DealLoc = false;
    
    public static boolean isAddVisible_Srat = false; 
    public static boolean isWaveVersionActive_Srat = false;
    public static boolean isNA_Srat = false;
    
    public static boolean isWaveVersionActive_Opex = false;
    public static boolean isNA_Opex = false;    
    
    public static boolean isAddVisible_KTPlan = false; 
    public static boolean isWaveVersionActive_KTPlan = false;
    public static boolean isNA_KTPlan = false;
    
    public static boolean isAddVisible_RTPlan = false; 
    public static boolean isWaveVersionActive_RTPlan = false;
    public static boolean isNA_RTPlan = false;
    
    public static boolean isAddVisible_SMPlan = false; 
    public static boolean isWaveVersionActive_SMPlan = false;
    public static boolean isNA_SMPlan = false;
    
    public static boolean isAddVisible_TAPlan = false;
    public static boolean isWaveVersionActive_TAPlan = false;
    public static boolean isNA_TAPlan = false;
    
    public static boolean isAddVisible_CommPlan = false;
    public static boolean isWaveVersionActive_CommPlan = false;
    public static boolean isNA_CommPlan = false;
    
    public static boolean isAddVisible_CLIPlan = false;
    public static boolean isWaveVersionActive_CLIPlan = false;
    public static boolean isNA_CLIPlan = false; 
    
    public static boolean isAddVisible_JMPlan = false;
    public static boolean isWaveVersionActive_JMPlan = false;
    public static boolean isNA_JMPlan = false; 
        
    public static boolean isAddVisible_BCPlan = false;
    public static boolean isWaveVersionActive_BCPlan = false;
    public static boolean isNA_BCPlan = false; 

    public static boolean isEditVisiblee_MobDealTracking = false;
    public static boolean isNA_MobDealTracking = false; 
    
    public static boolean showForm_DLFacility = false;
    public static boolean isSaveVisible_DLFacility = false;
    public static boolean isNA_DLFacility = false; 
    
    public static boolean isAddVisible_DealTrackScreen = false;
    public static boolean isEditVisible_DealTrackScreen = false;
    public static boolean isNA_DealTrackScreen = false;
        
    public static boolean isAddVisible_WavePlan = false;
    public static boolean is_WavePlanVersionActive_WavePlan = false;
    public static boolean isNA_WavePlan = false;
        
    public static boolean isAddVisible_WaveProcess = false;
    public static boolean is_WavePlanVersionActive_WaveProcess = false;
    public static boolean isNA_WaveProcess = false;
    
    public static boolean isAddVisible_RAIDLog = false;
    public static boolean isEditVisible_RAIDLog = false;
    public static boolean isNA_RAIDLog = false;
    // Mob Static Variables End
    /***************************************************************/
    
    // Solution Static Variables Start
    public static boolean addButtonRender_BPOOppTgp = false;
    public static boolean saveEditButtonRender_BPOOppTgp = false;
    public static boolean deleteButtonRender_BPOOppTgp = false;    
    
    public static boolean addButtonRender_Assumption = false;
    public static boolean saveEditButtonRender_Assumption = false;
    public static boolean deleteButtonRender_Assumption = false;

    // Solution Static Variables End
    /***************************************************************/
            
    public static String strSolMobId {get;set;}
    public static String userProfileName {get;set;}
    public static String strUserId {get;set;}
    
    public static List<UAM_Mob_Objects__c> lstUAMMobObj = new List<UAM_Mob_Objects__c>();
    public static List<UAM_Mob_Varibles__c> lstUAMMobVar = new List<UAM_Mob_Varibles__c>();   
    public static List<UAM_Roles_Permissions__c> lstUserRoles = new List<UAM_Roles_Permissions__c>();
    public static List<Admin_level_acces__c> accessLeveList = new List<Admin_level_acces__c>();
    public static Set<String> adminSet = new Set<String>();
    public static Set<String> permissionSet = new Set<String>();
    public static List<MOB_User_Role_Assignment__c> lstUserRoleAssignment = new List<MOB_User_Role_Assignment__c>();                              
    public static List<Deal_location__c> lstDealLoc = new List<Deal_location__c>();    
    public static List<Wave_Planning__C> lstDealWave = new List<Wave_Planning__C>() ; 
    public static List<Deal_TGP__c> lstDeal = new List<Deal_TGP__c>();
    public static List<PermissionSetAssignment> mobUserList = new List<PermissionSetAssignment>();
    public static List<Deal_TGP__c> lstDealID = new List<Deal_TGP__c>();
    
    // For Sloution
    public static List<Opportunity_TGP__c> lstOpportunity = new List<Opportunity_TGP__c>();
    public static List<Opportunity_Team__c> lstOpportunityTeam = new List<Opportunity_Team__c>();
    public static List<Opportunity_Offering__c> lstOffering = new List<Opportunity_Offering__c>();
    
    public static List<Review_User_Master__c> lstReviewUserMaster = new List<Review_User_Master__c>();
    public static boolean isMobApp = false;
    public static boolean isSolApp = false;
    
    public UAMSolMobUtility(ApexPages.StandardController stdController)
    {
        
    }
    
    static
    {
        strUserId = UserInfo.getUserId();
        
        if( ApexPages.CurrentPage() != null )
        {
            strSolMobId = ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);            
        }
        List<OPEX__c> opexWaveVersion= [select Wave_Plan_Version__c from OPEX__c where id = : strSolMobId limit 50];
        if(opexWaveVersion.size() > 0)
        {
            strSolMobId = opexWaveVersion.get(0).Wave_Plan_Version__c ;
        }
        List<SRAT__c> sratWaveVersion= [select Wave_Plan_Version__c from SRAT__c where id = : strSolMobId limit 50];
        if(sratWaveVersion.size() > 0)
        {
            strSolMobId = sratWaveVersion.get(0).Wave_Plan_Version__c ;
        }        

        List<wave_plan_version__c> lstWPV = [select deal__c from wave_plan_version__c where id = : strSolMobId limit 50];
        if( lstWPV.size() > 0 )
        {
            strSolMobId = lstWPV.get(0).deal__c;
        }
        List<Deal_Track__c> lstDt = [Select wave_plan_version__r.Deal__c from Deal_Track__c where id = : strSolMobId limit 50];
        if( lstDt.size() > 0 )
        {
            strSolMobId = lstDt.get(0).wave_plan_version__r.Deal__c;
        }
        
        List<Deal_Home_Location__c > dHLocation = [select Deal__c from Deal_Home_Location__c where id=:strSolMobId limit 50];
        if( dHLocation.size() > 0 )
        {
            strSolMobId = dHLocation.get(0).deal__c;
        }
        
        List<Deal_Location__c> dLocation = [select wave_plan_version__r.deal__c from Deal_Location__c where id = : strSolMobId];
        if( dLocation.size() > 0 )
        {
            strSolMobId = dLocation.get(0).wave_plan_version__r.deal__c;
        }
        
        List<Wave_Planning__c> lstDealWP = [select deal_location__r.wave_plan_version__r.deal__c,deal_location__r.wave_plan_version__r.Display_tracking_message__c,deal_location__r.wave_plan_version__r.active__c from Wave_Planning__c where id = : strSolMobId];
        if( lstDealWP.size() > 0 )
        {
            strSolMobId = lstDealWP.get(0).deal_location__r.wave_plan_version__r.deal__c;
        } 
              
        if( ApexPages.CurrentPage() != null)
        {
            if(strSolMobId == null)
                strSolMobId = ApexPages.CurrentPage().getParameters().get(UTIL_Constants.DEAL_ID_STRING);
        } 
        //Solution Workbench Opp Id   
        if( ApexPages.CurrentPage() != null && ApexPages.CurrentPage().getParameters().get(UTIL_Constants.OPP_ID_STRING) != null)
        {
            //if(strSolMobId == null)
                strSolMobId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.OPP_ID_STRING);
        }
                    
        List<Opportunity_Offering__c>  oppOffList=[Select id, name, Opportunity_TGP__c  from Opportunity_Offering__c where id=:strSolMobId];
        if( oppOffList.size() > 0 )
        {
            strSolMobId = oppOffList.get(0).Opportunity_TGP__c;
        } 
        system.debug('strSolMobId --------->>'+strSolMobId );
        if(strSolMobId != null)
        {   
            RunSoqlQueries(strSolMobId);
            uamAccessUtillity();
        }    
    }
    
    public static void RunSoqlQueries(String strDLId)
    {
    system.debug('strDLId--------->>'+strDLId);
        strSolMobId = strDLId;
        List<wave_plan_version__c> lstWPVId = [select deal__c from wave_plan_version__c where id = : strSolMobId];
        if( lstWPVId.size() > 0 )
        {
            strSolMobId = lstWPVId.get(0).deal__c;
        }
        
       // mobUserList = [Select AssigneeId from PermissionSetAssignment Where PermissionSetId in (Select Id From PermissionSet where name = 'MobilizationLeadership_with_WorkbenchUser') and AssigneeId = : userInfo.getUserId()]; 
        mobUserList = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE  AssigneeId  = : userInfo.getUserId()];
        
        userProfileName = [select u.Profile.Name from User u where u.id = :strUserId].Profile.Name; //Get users with Profile Name
        
        lstUserRoles=[select id, Object_Name__c, Permissions__c, Roles__c from UAM_Roles_Permissions__c];
        
        accessLeveList=[select Profile_Name__c from Admin_level_acces__c];
        
        for(PermissionSetAssignment permissionObj : mobUserList){
            permissionSet.add(permissionObj.PermissionSet.Name);
        }
        
        for(Admin_level_acces__c adminObj : accessLeveList){
            adminSet.add(adminObj.Profile_Name__c);
        }
        
        
        lstDealID=[select id,Name from Deal_TGP__c Where id=:strSolMobId];
        
        if(lstDealID.size() > 0)
        {
            isMobApp=true;
            isSolApp=false;
            
            lstUserRoleAssignment = [select id, Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,
                                                                User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_Lead__r.SFDC_User__c
                                                                from MOB_User_Role_Assignment__c where Deal__c= : strSolMobId ];  
                                                                                            
            lstDealLoc = [select Deployment_Lead_New__r.SFDC_User__c, Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,
                                        Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c, Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c, Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c
                                        from deal_location__c
                                        where Wave_Plan_Version__r.Deal__c=: strSolMobId AND Wave_Plan_Version__r.active__c=true ];
    
             lstDealWave = [ select Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c, Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c, Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c,
                                            Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c,  Mob_Technology_Lead_Secondary_New__r.SFDC_User__c,Mob_Technology_Lead_Secondary_2__r.SFDC_User__c,
                                            KT_Lead_New__r.SFDC_User__c,  Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,  Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c
                                            from Wave_Planning__c where deal_location__r.Wave_Plan_Version__r.Deal__c = : strSolMobId  AND  deal_location__r.Wave_Plan_Version__r.active__c=true];
                                             
             lstDeal = [select Solution_Architect_New__r.SFDC_User__c,ownerId from deal_tgp__C where id=:strSolMobId];
        }else 
        {
            isMobApp=false;
            isSolApp=true;
            
            //Using Sol BPO OPP ID
            lstOpportunity = [select id, name, ownerId, Enterprise_Solution_Architect_New__c, Enterprise_Solution_Architect_New__r.SFDC_User__c, BSS_Operation_New__c,BSS_Operation_New__r.SFDC_User__c,  Analytics_Solution_Lead__c, Analytics_Solution_Lead__r.SFDC_User__c from Opportunity_TGP__c where id= : strSolMobId ];
            lstOpportunityTeam = [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c where BPO_Opportunity__c = : strSolMobId];
            lstOffering = [ select id, name, Domain_Expert_Functional_Architect_New__c, Domain_Expert_Functional_Architect_New__r.SFDC_User__c,
                                    Domain_Expert_Functional_Architect_1_New__r.SFDC_User__c,Domain_Expert_Functional_Architect_2_New__r.SFDC_User__c,Domain_Expert_Functional_Architect_3_New__r.SFDC_User__c,Domain_Expert_Functional_Architect_4_New__r.SFDC_User__c, Functional_Architect_Mobilization_New__c, Functional_Architect_Mobilization_New__r.SFDC_User__c,
                                    Solution_Lead_New__c, Solution_Lead_New__r.SFDC_User__c, Offering_Solution_Lead_Secondary_New__c, Offering_Solution_Lead_Secondary_New__r.SFDC_User__c, Solution_Specialist_New__c, Solution_Specialist_New__r.SFDC_User__c, Technical_Architect_New__c, Technical_Architect_New__r.SFDC_USer__c  
                                    from Opportunity_Offering__c where Opportunity_TGP__c = : strSolMobId];
                                                    
        }  
        system.debug('---------');                                      
            
    }
    
    public static void uamAccessUtillity()
    {   
             
    /*********************************************************************************************************/ 
        // UAM - Deal Information Section - Start    
         Map<String,Boolean> m = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Deal_TGP);           
         saveEditButtonRender_DealInfo = m.get(UTIL_Constants.UAM_UPDATE);    
        // UAM - Deal Information Section - End
    /*********************************************************************************************************/
        // UAM - User Assignment Section - Start
        Map<String,Boolean> map_MURAssign = checkSolMobAcess(UTIL_Constants.UAM_OBJ_MOB_User_Role_Assignment);
        
        if( map_MURAssign.get(UTIL_Constants.UAM_CREATE) || map_MURAssign.get(UTIL_Constants.UAM_UPDATE) )
        {
            isAddVisible_MURAssign = true;
        }         
        isNA_MURAssign = map_MURAssign.get(UTIL_Constants.UAM_NOTAPPLICABLE);        
        // UAM - User Assignment Section - End
    /*********************************************************************************************************/ 
        // UAM - Deal Opportunity Section - Start   
        Map<String,Boolean> map_DealOpp = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Deal_Opportunity);
        
        isAddVisible_DealOpp = map_DealOpp.get(UTIL_Constants.UAM_CREATE);
        isSaveVisible_DealOpp = map_DealOpp.get(UTIL_Constants.UAM_UPDATE);        
        isNA_DealOpp = map_DealOpp.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Deal Opportunity Section - End
    /*********************************************************************************************************/  
        // UAM - Deal Location Section - Start      
        Map<String,Boolean> map_DealHome = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Deal_Home_Location);
        
        isAddVisible_DealHome = map_DealHome.get(UTIL_Constants.UAM_CREATE);
        isSaveVisible_DealHome = map_DealHome.get(UTIL_Constants.UAM_UPDATE);        
        isNA_DealHome = map_DealHome.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        
        // UAM - Deal Location Section - End
    /*********************************************************************************************************/ 
        // UAM - Client Specific Processes Section - Start
        Map<String,Boolean> map_CSpecific = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Client_Specific_Process_Mapping);
        
        isAddVisible_CSpecific = map_CSpecific.get(UTIL_Constants.UAM_CREATE);
        isEditVisible_CSpecific = map_CSpecific.get(UTIL_Constants.UAM_UPDATE);
        isNA_CSpecific = map_CSpecific.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Client Specific Processes Section - End
    /*********************************************************************************************************/
        // UAM - Insert New Wave Plan Version Section - Start
        Map<String,Boolean> map_WPV = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Wave_Plan_Version);
        
        isWPVAccess_WPV_C = map_WPV.get(UTIL_Constants.UAM_CREATE);
        if(map_WPV.get(UTIL_Constants.UAM_CREATE)==true || map_WPV.get(UTIL_Constants.UAM_UPDATE)==true)
        {
            isWPVAccess_WPV = true;
        }
        // UAM - Insert New Wave Plan Version Section - End
    /*********************************************************************************************************/ 
        // UAM - Deal Location Section - Start
        Map<String,Boolean> map_DealLoc = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Deal_Location);
        
        isAddVisible_DealLoc = map_DealLoc.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_DealLoc = map_DealLoc.get(UTIL_Constants.UAM_UPDATE);
        isNA_DealLoc = m.get(UTIL_Constants.UAM_NOTAPPLICABLE);            
        // UAM - Deal Location Section - End
    /*********************************************************************************************************/
        // UAM - SRAT Section - Start
        Map<String,Boolean> map_Srat = checkSolMobAcess(UTIL_Constants.UAM_OBJ_SRAT);
        
        isAddVisible_Srat = map_Srat.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_Srat = map_Srat.get(UTIL_Constants.UAM_UPDATE);       
        isNA_Srat = map_Srat.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - SRAT Section - End
    /*********************************************************************************************************/
        // UAM - OPEX Section - Start
        Map<String,Boolean> map_Opex = checkSolMobAcess(UTIL_Constants.UAM_OBJ_OPEX);
       // isAddVisible = m.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_Opex = map_Opex.get(UTIL_Constants.UAM_UPDATE);
        isNA_Opex = map_Opex.get(UTIL_Constants.UAM_NOTAPPLICABLE);
       // UAM - OPEX Section - End
    /*********************************************************************************************************/
        // UAM - KT Plan Section - Start
        Map<String,Boolean> map_KTPlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_KT_Planning);
        
        isAddVisible_KTPlan = map_KTPlan.get(UTIL_Constants.UAM_CREATE);
        system.debug('isAddVisible_KTPlan -------->>>'+isAddVisible_KTPlan);
        isWaveVersionActive_KTPlan = map_KTPlan.get(UTIL_Constants.UAM_UPDATE);
        system.debug('isWaveVersionActive_KTPlan -------->>>'+isWaveVersionActive_KTPlan );
        isNA_KTPlan = map_KTPlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        system.debug('isNA_KTPlan  -------->>>'+isNA_KTPlan );
        // UAM - KT Plan Section - End
    /*********************************************************************************************************/
        // UAM - Recruitment Plan Section - Start
        Map<String,Boolean> map_RTPlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Recruitment_Tracking);
        
        isAddVisible_RTPlan = map_RTPlan.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_RTPlan = map_RTPlan.get(UTIL_Constants.UAM_UPDATE);
        isNA_RTPlan = map_RTPlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Recruitment Plan Section - End
    /*********************************************************************************************************/
        // UAM - Service Management Plan Section - Start
        Map<String,Boolean> map_SMPlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Service_Management);
        
        isAddVisible_SMPlan = map_SMPlan.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_SMPlan = map_SMPlan.get(UTIL_Constants.UAM_UPDATE);
        isNA_SMPlan = map_SMPlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Service Management Plan Section - End
    /*********************************************************************************************************/
        // UAM - Tech Assessment Plan Section - Start
        Map<String,Boolean> map_TAPlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Tech_Assessment);
        
        isAddVisible_TAPlan = map_TAPlan.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_TAPlan = map_TAPlan.get(UTIL_Constants.UAM_UPDATE);
        isNA_TAPlan = map_TAPlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Tech Assessment Plan Section - End
    /*********************************************************************************************************/
        // UAM - Commercial Plan Section - Start
        Map<String,Boolean> map_CommPlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Commercial_Planning);
        
        isAddVisible_CommPlan = map_CommPlan.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_CommPlan = map_CommPlan.get(UTIL_Constants.UAM_UPDATE);
        isNA_CommPlan = map_CommPlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Commercial Plan Section - End
    /*********************************************************************************************************/
        // UAM - ContractLegalInfoManagementPlan Section - Start 
        Map<String,Boolean> map_CLIPlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Contract_Legal_Infosec);
        
        isAddVisible_CLIPlan = map_CLIPlan.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_CLIPlan= map_CLIPlan.get(UTIL_Constants.UAM_UPDATE);
        isNA_CLIPlan = map_CLIPlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - ContractLegalInfoManagementPlan Section - End  
    /*********************************************************************************************************/ 
        // UAM - JourneyManagementPlan Section - Start 
        Map<String,Boolean> map_JMPlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Journey_Management_Planning);
        
        isAddVisible_JMPlan = map_JMPlan.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_JMPlan= map_JMPlan.get(UTIL_Constants.UAM_UPDATE);
        isNA_JMPlan = map_JMPlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - JourneyManagementPlan Section - End    
    /*********************************************************************************************************/ 
        // UAM - BusinessContinuityPlan Section - Start 
        Map<String,Boolean> map_BCPlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Business_Continuity_Planning);
        
        isAddVisible_BCPlan = map_BCPlan.get(UTIL_Constants.UAM_CREATE);
        isWaveVersionActive_BCPlan= map_BCPlan.get(UTIL_Constants.UAM_UPDATE);
        isNA_BCPlan = map_BCPlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);     
        // UAM - BusinessContinuityPlan Section - End
    /*********************************************************************************************************/ 
        // UAM - Mob Deal Tracking Section - Start 
        Map<String,Boolean> map_MobDelTrack = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Initiation_of_Deal_Tracking);
        
        //isAddVisible = m.get(UTIL_Constants.UAM_CREATE);
        isEditVisiblee_MobDealTracking= map_MobDelTrack.get(UTIL_Constants.UAM_UPDATE);
        isNA_MobDealTracking = map_MobDelTrack.get(UTIL_Constants.UAM_NOTAPPLICABLE);       
        // UAM - Mob Deal Tracking Section - End
    /*********************************************************************************************************/
        // UAM - Deal Location Facility - Start
        Map<String,Boolean> map_DLFacility = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Deal_Location_Facility);
        
        showForm_DLFacility = map_DLFacility.get(UTIL_Constants.UAM_CREATE);
        isSaveVisible_DLFacility = map_DLFacility.get(UTIL_Constants.UAM_UPDATE);
        isNA_DLFacility = map_DLFacility.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Deal Location Facility - End
    /*********************************************************************************************************/
        // UAM - Deal Tracking Screen - Start
        Map<String,Boolean> map_DealTrackScreen = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Deal_Tracking_Screen);
        isAddVisible_DealTrackScreen = map_DealTrackScreen.get(UTIL_Constants.UAM_CREATE);
        isEditVisible_DealTrackScreen = map_DealTrackScreen.get(UTIL_Constants.UAM_UPDATE);
        isNA_DealTrackScreen = map_DealTrackScreen.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Deal Tracking Screen - End
    /*********************************************************************************************************/
        // UAM - Wave Planning - Start
        Map<String,Boolean> map_WavePlan = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Wave_Planning);
        
        isAddVisible_WavePlan = map_WavePlan.get(UTIL_Constants.UAM_CREATE);
        is_WavePlanVersionActive_WavePlan = map_WavePlan.get(UTIL_Constants.UAM_UPDATE);
        isNA_WavePlan = map_WavePlan.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Wave Planning - End
    /*********************************************************************************************************/
        // UAM - Wave Process - Start
        Map<String,Boolean> map_WaveProcess = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Wave_Process);
        
        isAddVisible_WaveProcess = map_WaveProcess.get(UTIL_Constants.UAM_CREATE);
        is_WavePlanVersionActive_WaveProcess = map_WaveProcess.get(UTIL_Constants.UAM_UPDATE);
        isNA_WaveProcess = map_WaveProcess.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - Wave Process - End
    /*********************************************************************************************************/
        // UAM - RAIDLog - Start
        Map<String,Boolean> map_RAIDLog = checkSolMobAcess(UTIL_Constants.UAM_OBJ_RAID_Action);

        isAddVisible_RAIDLog = map_RAIDLog.get(UTIL_Constants.UAM_CREATE);
        isEditVisible_RAIDLog = map_RAIDLog.get(UTIL_Constants.UAM_UPDATE);
        isNA_RAIDLog = map_RAIDLog.get(UTIL_Constants.UAM_NOTAPPLICABLE);
        // UAM - RAIDLog - End
    /*********************************************************************************************************/
    
    
    //Solution UAM Start
    /*********************************************************************************************************/
        // UAM - BPO Opportunity - Start
        Map<String,Boolean> map_BPOOppTgp = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Opportunity_TGP);            
        addButtonRender_BPOOppTgp = map_BPOOppTgp.get(UTIL_Constants.UAM_CREATE);
        saveEditButtonRender_BPOOppTgp = map_BPOOppTgp.get(UTIL_Constants.UAM_UPDATE);
        deleteButtonRender_BPOOppTgp = map_BPOOppTgp.get(UTIL_Constants.UAM_DELETE);
       
        // UAM - BPO Opportunity - End
    /*********************************************************************************************************/
    }
    
    public static Map<String,Boolean> checkSolMobAcess(String strSObjectType)
    {
        system.debug('isSolApp--->>' + isSolApp);
        system.debug('isMobApp--->>' + isMobApp);   
        // lstUserRoles=[select id, Object_Name__c, Permissions__c, Roles__c from UAM_Roles_Permissions__c where Object_Name__c =: strSObjectType];
        Map<String,Boolean> m = new Map<String,Boolean>();  
        List<RoleClass> roleClass=new List<RoleClass>();
        system.debug('adminSet---->' + adminSet);
         system.debug('userProfileName--->>' + userProfileName);      
         system.debug('permissionSet******----->>'+permissionSet);
        //if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.ADMIN_RESTRICTED_ACCES))
        if(adminSet.contains(userProfileName))
        {
        system.debug('In side IF Block for Admin people---->');
            m.put(UTIL_Constants.UAM_CREATE,true);
            m.put(UTIL_Constants.UAM_READ,true);
            m.put(UTIL_Constants.UAM_UPDATE,true);
            m.put(UTIL_Constants.UAM_DELETE,true);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
            return m;
        }
        if(permissionSet.contains('SA_OU_Lead') && isSolApp)
        {
        system.debug('In side IF Block for SA_OU_Lead Permission Set---->');
            m.put(UTIL_Constants.UAM_CREATE,true);
            m.put(UTIL_Constants.UAM_READ,true);
            m.put(UTIL_Constants.UAM_UPDATE,true);
            m.put(UTIL_Constants.UAM_DELETE,true);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
            return m;
        }
        if(UTIL_Constants.UAM_OBJ_MOB_User_Role_Assignment.equalsIgnoreCase(strSObjectType) || UTIL_Constants.UAM_OBJ_Wave_Plan_Version.equalsIgnoreCase(strSObjectType) || UTIL_Constants.UAM_OBJ_Deal_Opportunity.equalsIgnoreCase(strSObjectType) || UTIL_Constants.UAM_OBJ_Opportunity_TGP.equalsIgnoreCase(strSObjectType))
        {
          
            if(lstDeal.size()>0 && lstDeal.get(0).ownerId == UserInfo.getUserId())
            {
                m.put(UTIL_Constants.UAM_CREATE,true);
                m.put(UTIL_Constants.UAM_READ,true);
                m.put(UTIL_Constants.UAM_UPDATE,true);
                m.put(UTIL_Constants.UAM_DELETE,true);
                m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
                return m;
            }
          /*  else if(lstDealWave.size()>0 )
            {
                m.put(UTIL_Constants.UAM_CREATE,true);
                m.put(UTIL_Constants.UAM_READ,true);
                m.put(UTIL_Constants.UAM_UPDATE,true);
                m.put(UTIL_Constants.UAM_DELETE,true);
                m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
                return m;
            }
            else if(lstDealLoc.size()>0)
            {
                m.put(UTIL_Constants.UAM_CREATE,true);
                m.put(UTIL_Constants.UAM_READ,true);
                m.put(UTIL_Constants.UAM_UPDATE,true);
                m.put(UTIL_Constants.UAM_DELETE,true);
                m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
                return m;
            }*/
            else if(lstOpportunity.size()>0 && lstOpportunity.get(0).ownerId == UserInfo.getUserId())
            {
                m.put(UTIL_Constants.UAM_CREATE,true);
                m.put(UTIL_Constants.UAM_READ,true);
                m.put(UTIL_Constants.UAM_UPDATE,true);
                m.put(UTIL_Constants.UAM_DELETE,true);
                m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
                return m;
            }
            else if(lstOpportunityTeam.size()>0 && lstOpportunity.get(0).ownerId == UserInfo.getUserId())
            {
                m.put(UTIL_Constants.UAM_CREATE,true);
                m.put(UTIL_Constants.UAM_READ,true);
                m.put(UTIL_Constants.UAM_UPDATE,true);
                m.put(UTIL_Constants.UAM_DELETE,true);
                m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
                return m;
            }
        }
        for(MOB_User_Role_Assignment__c tmpUser : lstUserRoleAssignment)
        {
            roleClass.add(new RoleClass(tmpUser.Role_Name__c,tmpUser.User_Assigned_New__r.SFDC_User__c));               
            roleClass.add(new RoleClass(tmpUser.Role_Name__c,tmpUser.User_Assigned_Secondary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(tmpUser.Role_Name__c,tmpUser.User_Assigned_Secondary_Lead__r.SFDC_User__c));             
        }                                              
                                      
        for(deal_location__c tmpDealLoc : lstDealLoc )
        {
            roleClass.add(new RoleClass(UTIL_Constants.UAM_Role_Deployment_Lead,tmpDealLoc.Deployment_Lead_New__r.SFDC_User__c));           
            roleClass.add(new RoleClass(UTIL_Constants.UAM_Role_Loc_Mob_Lead_Sec,tmpDealLoc.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_Role_Loc_Mob_Lead_Sec_2,tmpDealLoc.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_Role_Mob_Recrui_Lead_Prim,tmpDealLoc.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_Role_Mob_Recruit_Lead_Sec,tmpDealLoc.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_Role_Mob_Recruit_Lead_Sec_2,tmpDealLoc.Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c));
        }

        for(Wave_Planning__C tmpDealWave : lstDealWave )
        {
        system.debug('primary------------>>>>'+tmpDealWave.KT_Lead_New__r.SFDC_User__c);
        system.debug('second------------>>>>'+tmpDealWave.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c);
        system.debug('third------------>>>>'+tmpDealWave.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c);
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_OPEX_LEAD_PRIMAY,tmpDealWave.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c));           
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_OPEX_LEAD_SECONDARY,tmpDealWave.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_OPEX_LEAD_SECONDARY_2,tmpDealWave.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_TECH_LEAD_PRIMAY,tmpDealWave.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_TECH_LEAD_SECONDARY,tmpDealWave.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_TECH_LEAD_SECONDARY_2,tmpDealWave.Mob_Technology_Lead_Secondary_2__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_KT_LEAD_PRIMAY,tmpDealWave.KT_Lead_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_KT_LEAD_SECONDARY,tmpDealWave.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_KT_LEAD_SECONDARY_2,tmpDealWave.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c));
        }
    
        for(deal_tgp__c tmpDeal : lstDeal)
        {
            roleClass.add(new RoleClass(UTIL_Constants.SOLUTION_ARCHITECT,tmpDeal.Solution_Architect_New__r.SFDC_User__c));               
        } 
        for(Opportunity_TGP__c tmpOppObject : lstOpportunity)
        {
            //roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_COMPLEXCOST,tmpOppObject.Complex_Cost_Architect_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_ENTERPRISE_SOLUTION,tmpOppObject.Enterprise_Solution_Architect_New__r.SFDC_User__c));            
            //roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_BSS_OPERATION,tmpOppObject.BSS_Operation_New__r.SFDC_User__c));            
            //roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_ANALYTICS_SOL_LEAD,tmpOppObject.Analytics_Solution_Lead__r.SFDC_User__c));
        }
        for(Opportunity_Team__c tmpOppObject : lstOpportunityTeam)
        {
            //roleClass.add(new RoleClass(tmpOppObject.Roles__r.name,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_ENTERPRISE_SOLUTION,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));            
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_BSS_OPERATION,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));            
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_ANALYTICS_SOL_LEAD,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));            
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_DOMAIN_EXP_FUN_ART,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_FUN_ART_MOBILIZATION,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_SOL_LEAD,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_OFF_SOL_LEAD_SECONDARY,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_TECH_ARCHITECT,tmpOppObject.Opportunity_Team_Member__r.SFDC_User__c));
            
        }                                     
        for(Opportunity_Offering__c tmpOffObject : lstOffering )
        {
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_DOMAIN_EXP_FUN_ART,tmpOffObject.Domain_Expert_Functional_Architect_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_DOMAIN_EXP_FUN_ART,tmpOffObject.Domain_Expert_Functional_Architect_1_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_DOMAIN_EXP_FUN_ART,tmpOffObject.Domain_Expert_Functional_Architect_2_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_DOMAIN_EXP_FUN_ART,tmpOffObject.Domain_Expert_Functional_Architect_3_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_DOMAIN_EXP_FUN_ART,tmpOffObject.Domain_Expert_Functional_Architect_4_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_FUN_ART_MOBILIZATION,tmpOffObject.Functional_Architect_Mobilization_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_SOL_LEAD,tmpOffObject.Solution_Lead_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_OFF_SOL_LEAD_SECONDARY,tmpOffObject.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_SOL_SPECIALIST,tmpOffObject.Solution_Specialist_New__r.SFDC_User__c));
            roleClass.add(new RoleClass(UTIL_Constants.UAM_MOB_TECH_ARCHITECT,tmpOffObject.Technical_Architect_New__r.SFDC_User__c));
        }
        
        Boolean isUserFound=false;
        Integer crudCnt=0;
        Integer ruCnt=0;
        Integer rCnt=0;
        Integer naCnt=0;
          
        for(UAM_Roles_Permissions__c tmp : lstUserRoles)
        {
        system.debug('temp Object Name---->' + tmp.Object_Name__c);
        system.debug('strSObjectType Name---->' + strSObjectType);
            if(tmp.Object_Name__c.equalsIgnoreCase(strSObjectType)){
                if(tmp.Permissions__c.containsIgnoreCase(UTIL_Constants.UAM_CREATE)== true)
                {
                    for(RoleClass roleCl: roleClass)
                    {
                        if(roleCl.roleName==tmp.Roles__c && roleCl.roleUserID==strUserId)
                        {
                            isUserFound=true;
                            crudCnt++;  
                        }
                    }                
                }
                else if(tmp.Permissions__c.containsIgnoreCase(UTIL_Constants.UAM_UPDATE)== true)
                {  
                    for(RoleClass roleCl: roleClass)
                    {
                        if(roleCl.roleName==tmp.Roles__c && roleCl.roleUserID==strUserId)
                        {
                            isUserFound=true;
                            ruCnt++;   
                        }
                    }                                     
                }
                else if(tmp.Permissions__c.containsIgnoreCase(UTIL_Constants.UAM_UPDATE)== false && tmp.Permissions__c.containsIgnoreCase(UTIL_Constants.UAM_CREATE)== false && tmp.Permissions__c.containsIgnoreCase(UTIL_Constants.UAM_READ)== true )
                { 
                    for(RoleClass roleCl: roleClass)
                    {
                        if(roleCl.roleName==tmp.Roles__c && roleCl.roleUserID==strUserId)
                        {
                            isUserFound=true;
                            rCnt++;  
                        }
                    }                 
                }
                else if(tmp.Permissions__c.containsIgnoreCase(UTIL_Constants.UAM_NOTAPPLICABLE)== true)
                { 
                    for(RoleClass roleCl: roleClass)
                    {
                        if(roleCl.roleName==tmp.Roles__c && roleCl.roleUserID==strUserId)
                        {
                            isUserFound=true;
                            naCnt++;  
                        }
                    }                 
                } 
            }                                       
        }
        system.debug('crudCnt---->' + crudCnt);
        system.debug('ruCnt---->' + ruCnt);
        system.debug('rCnt---->' + rCnt);
        system.debug('naCnt---->' +naCnt);
        if((userProfileName.equalsIgnoreCase(System.Label.Mobilization_Regional_Leadership) || userProfileName.equalsIgnoreCase(System.Label.Mobilization_Admin)) && isMobApp)
        {
            m.put(UTIL_Constants.UAM_CREATE,true);
            m.put(UTIL_Constants.UAM_READ,true);
            m.put(UTIL_Constants.UAM_UPDATE,true);
            m.put(UTIL_Constants.UAM_DELETE,false);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
            return m;
        }
        else if(userProfileName.equalsIgnoreCase(System.Label.Solution_Admin) && isSolApp)
        {
            m.put(UTIL_Constants.UAM_CREATE,true);
            m.put(UTIL_Constants.UAM_READ,true);
            m.put(UTIL_Constants.UAM_UPDATE,true);
            m.put(UTIL_Constants.UAM_DELETE,false);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
            return m;
        } else    
        if(crudCnt>0) //CRUD Permission
        {
            m.put(UTIL_Constants.UAM_CREATE,true);
            m.put(UTIL_Constants.UAM_READ,true);
            m.put(UTIL_Constants.UAM_UPDATE,true);
            m.put(UTIL_Constants.UAM_DELETE,true);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
            return m;
        }
        else if(ruCnt>0) //RU Permission
        {
            m.put(UTIL_Constants.UAM_CREATE,false);
            m.put(UTIL_Constants.UAM_READ,true);
            m.put(UTIL_Constants.UAM_UPDATE,true);
            m.put(UTIL_Constants.UAM_DELETE,false);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
            return m;
        }
        else if(rCnt>0) //R Permission
        {
            m.put(UTIL_Constants.UAM_CREATE,false);
            m.put(UTIL_Constants.UAM_READ,true);
            m.put(UTIL_Constants.UAM_UPDATE,false);
            m.put(UTIL_Constants.UAM_DELETE,false);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
            return m;
        }        
        //else if(mobUserList.size()>0) //MobilizationLeadership with WorkbenchUser Permission set
        else if(permissionSet.contains('MobilizationLeadership_with_WorkbenchUser') && isMobApp)
        {
            system.debug('In side MobilizationLeadership_with_WorkbenchUser permission set==============>>');
            m.put(UTIL_Constants.UAM_CREATE,false);
            m.put(UTIL_Constants.UAM_READ,true);
            m.put(UTIL_Constants.UAM_UPDATE,false);
            m.put(UTIL_Constants.UAM_DELETE,false);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,false);
            return m;
        }           
        else if(naCnt>0) //NoAccess Permission
        {    
            m.put(UTIL_Constants.UAM_CREATE,false);
            m.put(UTIL_Constants.UAM_READ,false);
            m.put(UTIL_Constants.UAM_UPDATE,false);
            m.put(UTIL_Constants.UAM_DELETE,false);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,true);
            return m;
        }
        system.debug('isUserFound---->' + isUserFound);    
        if(isUserFound==false)
        {   
            m.put(UTIL_Constants.UAM_CREATE,false);
            m.put(UTIL_Constants.UAM_READ,false);
            m.put(UTIL_Constants.UAM_UPDATE,false);
            m.put(UTIL_Constants.UAM_DELETE,false);
            m.put(UTIL_Constants.UAM_NOTAPPLICABLE,true);
            return m;
        }
        return m;
    
    }
    
 /******************************
    Class Name: RoleClass
    Description: To check the permissions for different roles under Solution (Sol Users Profile)    
    Story: SOL_148
    Author: Mayank Tayal
    *******************************/
    public Class RoleClass
    {
        public String roleName{get;set;}
        public String roleUserID{get;set;}
        
        public RoleClass(String roleName, String roleUserID)
        {
            this.roleName=roleName;
            this.roleUserID=roleUserID;
        }
    }
   webservice static boolean isWPVAccessible( string strDealId)
    {
        RunSoqlQueries(strDealId);
        Map<String,Boolean> map_WPV = checkSolMobAcess(UTIL_Constants.UAM_OBJ_Wave_Plan_Version);
        if(map_WPV.get(UTIL_Constants.UAM_CREATE)==true)
        {
            return true;
        }
        else
        {
            return false;
        }
      
    } 
    webservice static boolean isRAIDAccessible(string strDealId)
    {
        RunSoqlQueries(strDealId);        
        Map<String,Boolean> map_RAID_LOG = checkSolMobAcess(UTIL_Constants.UAM_OBJ_RAID_Action);
        if(map_RAID_LOG.get(UTIL_Constants.UAM_CREATE)==true)
        {
            return true;
        }
        else
        {
            return false;
        }
        
    }
}