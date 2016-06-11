/*
Author : Mayank Tayal
Story  :   MOB_029, MOB_030, MOB_031, MOB_032
Description :As an application user, I should able to add Risks, Actions,Issues and Decisions from any module of Mobilization workbench and & maintain the same 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class RAIDLog_InlineController {
    private static final string CLASS_NAME ='RAIDLog_InlineController';
    private static final string METHOD_INSERT ='saveActionsRAID';
    private static final string METHOD_INSERT1 ='saveDecisionRAID'; 
    public RAID_Risk__c riskRAID{get;set;}
    public RAID_Action__c actionRAID{get;set;}
    public RAID_Issue__c issueRAID{get;set;}
    public RAID_Decision__c decisioRAID{get;set;}
    public String moduleID{get;set;}
    public String id{get;set;}
    public String RiskId{get;set;}
    public String moduleName{get;set;}
    public String tabID {get;set;}
    public String tabToRender{get;set;}
    public List<SRAT__c> sratRecord{get;set;}
    public List<OPEX__c> opexRecord{get;set;}
    public List<Deal_TGP__c> dealRecord{get;set;}
    public List<Wave_Plan_Version__c> waveVersionRecord{get;set;}
    public List<Deal_Home_Location__c> dealHomeLocRecord{get;set;}
    public List<Deal_Location__c> deaLocationRecord{get;set;}
    public List<Wave_Planning__c> dealWaveRecord{get;set;}   
//MOB_154 Start
  public List<Deal_Location__c> recruitmentRecord{get;set;}
  public List<Wave_Planning__c> waveRecord{get;set;}
//MOB_154 End   
    
    //Variables for displaying Module Information
    public String itemActivity{get;set;}
    public String locationName{get;set;}
    public String wavePlanVersionName{get;set;}
    public String dealName{get;set;}
    public String waveName{get;set;}
    public String dealID{get;set;}
    public Boolean itemDisplay{get;set;}
    public Boolean wavePlanVersionDisplay{get;set;}
    public Boolean dealDisplay{get;set;}
    public Boolean locationDisplay{get;set;}
    public Boolean waveDisplay{get;set;}
    
    //Variables for displaying the Page Messages on Tab
    public Boolean showRiskMsg{get;set;}
    public Boolean showActionMsg{get;set;}
    public Boolean showIssueMsg{get;set;}
    public Boolean showDecisionMsg{get;set;}
    public Boolean showRiskSave{get;set;}
    public Boolean showActionSave{get;set;}
    public Boolean showIssueSave{get;set;}
    public Boolean showDecisionSave{get;set;}
    
    public Boolean showForm{get;set;}
    public Boolean showMainMsg{get;set;}
    
    public Integer riskRecCount{get;set;}
    public Integer actionRecCount{get;set;}
    public Integer issueRecCount{get;set;}
    public Integer decisionRecCount{get;set;}
    public Boolean disableLeadButton{get;set;}
    public Boolean isNA{get;set;}
    public boolean isAddVisible {get;set;}
    public boolean isEditVisible{get;set;}
        
    public List<RAID_Risk__c> listRiskRaidRecords{get;set;}
    public List<RAID_Action__c> listActionRaidRecords{get;set;}
    public List<RAID_Issue__c> listIssueRaidRecords{get;set;}
    public List<RAID_Decision__c> listDecisionRaidRecords{get;set;}
    
    /******************************
    Method Name: RAIDLog_InlineController
    Description: Constructor for Initializing details
    Paramenters: NA
    Return Value: NA
    *******************************/
    public RAIDLog_InlineController()
    {
        moduleID = ApexPages.currentPage().getParameters().get(UTIL_constants.URL_PARAMETER_ID);
        moduleName = ApexPages.currentPage().getParameters().get(UTIL_constants.MODULE_NAME);
        tabID = ApexPages.currentPage().getParameters().get(UTIL_constants.TAB);
        if(tabID  == UTIL_constants.VALUE_TWO) {
           tabToRender = UTIL_constants.TAB_TWO;
        }
        else if(tabID  == UTIL_constants.VALUE_THREE){
           tabToRender = UTIL_constants.TAB_THREE;
        }
        else if(tabID  == UTIL_constants.VALUE_FOUR){
            tabToRender = UTIL_constants.TAB_FOUR;
        }
        else{
           tabToRender = UTIL_constants.TAB_ONE;
        }
        if(moduleID!=null && moduleName!=null)
        {
            showForm=true;
            if(moduleName == UTIL_constants.SRAT) /*******************For SRAT Module*****************************/
            {
                //Query to fetch record from SRAT__c 
                sratRecord=[select Item__c,Wave_Plan_Version__r.Deal__c, Wave_Plan_Version__r.name, Wave_Plan_Version__c,Wave_Plan_Version__r.Deal__r.name,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, Planned_Date__c, id, name from SRAT__c where id=:moduleID limit 1000];
                if(sratRecord.size()>0)
                {
                    itemActivity=sratRecord[0].Item__c;
                    locationName=sratRecord[0].Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                    dealName=sratRecord[0].Wave_Plan_Version__r.Deal__r.name;
                    waveName=sratRecord[0].Wave_Plan_lk__r.Wave_Label__c;
                    wavePlanVersionName=sratRecord[0].Wave_Plan_Version__r.name;
                    dealID=sratRecord[0].Wave_Plan_Version__r.Deal__c;
                    itemDisplay=true;
                    dealDisplay=true;
                    locationDisplay=true;
                    waveDisplay=true;
                    wavePlanVersionDisplay=true;
                }
            }
            else if(moduleName == UTIL_constants.OPEX) /*******************For OPEX Module*****************************/
            {
                moduleName =UTIL_constants.OPERATIONAL_MATURITY;
                //Query to fetch record from OPEX__c 
                opexRecord=[select Item__c,Wave_Plan_Version__r.Deal__c, Wave_Plan_Version__r.name, Wave_Plan_Version__c,Wave_Plan_Version__r.Deal__r.name,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, Planned_Date__c, id, name from OPEX__c where id=:moduleID limit 1000];
                if(opexRecord.size()>0)
                {
                    itemActivity=opexRecord[0].Item__c;
                    locationName=opexRecord[0].Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                    dealName=opexRecord[0].Wave_Plan_Version__r.Deal__r.name;
                    waveName=opexRecord[0].Wave_Plan_lk__r.Wave_Label__c;
                    wavePlanVersionName=opexRecord[0].Wave_Plan_Version__r.name;
                    dealID=opexRecord[0].Wave_Plan_Version__r.Deal__c;
                    itemDisplay=true;
                    dealDisplay=true;
                    locationDisplay=true;
                    waveDisplay=true;
                    wavePlanVersionDisplay=true;
                }
            }
            else if(moduleName == UTIL_constants.DEAL) /*******************For Deal Module*****************************/
            {
                //Query to fetch record from Deal_TGP__c
                dealRecord=[select id, name from Deal_TGP__c where id=:moduleID limit 1000];
                if(dealRecord.size()>0)
                {
                    dealName=dealRecord[0].name;
                    dealID=dealRecord[0].id;
                    itemDisplay=false;
                    dealDisplay=true;
                    locationDisplay=false;
                    waveDisplay=false;
                    wavePlanVersionDisplay=false;
                }
            }
            else if(moduleName == UTIL_constants.WAVE_PLAN_VERSION_ONE) /*******************For Wave Plan Version Module*****************************/
            {
                //Query to fetch record from Deal_TGP__c
                moduleName = UTIL_constants.HIGH_LEVEL_MOBILIZATION_PLAN;
                waveVersionRecord=[select Deal__c, Deal__r.name, id, name from Wave_Plan_Version__c where id=:moduleID limit 1000];
                if(waveVersionRecord.size()>0)
                {
                    dealName=waveVersionRecord[0].Deal__r.name;
                    wavePlanVersionName=waveVersionRecord[0].name;
                    dealID=waveVersionRecord[0].Deal__c;
                    itemDisplay=false;
                    dealDisplay=true;
                    locationDisplay=false;
                    waveDisplay=false;
                    wavePlanVersionDisplay=true;
                }
            }
            else if(moduleName == UTIL_constants.DEAL_LOCATION) /*******************For Deal Location Module*****************************/
            {
                //Query to fetch record from Deal_TGP__c
                deaLocationRecord=[select Wave_Plan_Version__r.name, Wave_Plan_Version__r.Deal__c, Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Plan_Version__r.Deal__r.name, id, name from Deal_Location__c where id=:moduleID limit 1000];
                if(deaLocationRecord.size()>0)
                {
                    dealName=deaLocationRecord[0].Wave_Plan_Version__r.Deal__r.name;
                    dealID=deaLocationRecord[0].Wave_Plan_Version__r.Deal__c;
                    locationName=deaLocationRecord[0].Deal_Home_Location__r.Delivery_Location_Master__r.name;
                    wavePlanVersionName=deaLocationRecord[0].Wave_Plan_Version__r.name;
                    itemDisplay=false;
                    dealDisplay=true;
                    locationDisplay=true;
                    waveDisplay=false;
                    wavePlanVersionDisplay=true;
                }
            }
            else if(moduleName == UTIL_constants.DEAL_WAVE) /*******************For Deal Wave Module*****************************/
            {
                //Query to fetch record from Deal_TGP__c
                dealWaveRecord=[select Wave_Label__c, Deal_Location__r.Wave_Plan_Version__r.name, Deal_Location__r.Wave_Plan_Version__r.Deal__c, Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Deal_Location__r.Wave_Plan_Version__r.Deal__r.name, id, name from Wave_Planning__c where id=:moduleID limit 1000];
                if(dealWaveRecord.size()>0)
                {
                    dealName=dealWaveRecord[0].Deal_Location__r.Wave_Plan_Version__r.Deal__r.name;
                    dealID=dealWaveRecord[0].Deal_Location__r.Wave_Plan_Version__r.Deal__c;
                    locationName=dealWaveRecord[0].Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                    waveName=dealWaveRecord[0].Wave_Label__c;
                    wavePlanVersionName=dealWaveRecord[0].Deal_Location__r.Wave_Plan_Version__r.name;
                    itemDisplay=false;
                    dealDisplay=true;
                    locationDisplay=true;
                    waveDisplay=true;
                    wavePlanVersionDisplay=true;
                }
            }
            else if(moduleName == UTIL_constants.DEAL_HOME_LOCATION) /*******************For Deal Home Location Module*****************************/
            {
                //Query to fetch record from Deal_TGP__c
                dealHomeLocRecord=[select Deal__c, Delivery_Location_Master__r.name, Deal__r.name, id, name from Deal_Home_Location__c where id=:moduleID limit 1000];
                if(dealHomeLocRecord.size()>0)
                {
                    dealName=dealHomeLocRecord[0].Deal__r.name;
                    locationName=dealHomeLocRecord[0].Delivery_Location_Master__r.name;
                    dealID=dealHomeLocRecord[0].Deal__c;
                    itemDisplay=false;
                    dealDisplay=true;
                    locationDisplay=true;
                    waveDisplay=false;
                    wavePlanVersionDisplay=false;
                }
            }
            //MOB_154 Start
            else if(moduleName == UTIL_constants.RECRUITMENT) /*******************For RECRUITMENT Module*****************************/
            {
                //Query to fetch record from Recruitment_Tracking__c 
                //recruitmentRecord=[select Wave_Plan_Version__r.Deal__c, Wave_Plan_Version__r.name, Wave_Plan_Version__c,Wave_Plan_Version__r.Deal__r.name,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, id, name from Deal_Location__c where id=:moduleID];
                
                recruitmentRecord=[Select id, Wave_Plan_Version__r.deal__c, Wave_Plan_Version__c,Location_Name__c, 
                                                Wave_Plan_Version__r.deal__r.name,Wave_Plan_Version__r.name
                                               from Deal_Location__c where id=: moduleID limit 1000];  
                if(recruitmentRecord.size()>0)
                {
                    //itemActivity=recruitmentRecord[0].Item__c;
                    locationName=recruitmentRecord[0].Location_Name__c;
                    dealName=recruitmentRecord[0].Wave_Plan_Version__r.deal__r.name;
                   // waveName=recruitmentRecord[0].Wave_Plan_lk__r.Wave_Label__c;
                    wavePlanVersionName=recruitmentRecord[0].Wave_Plan_Version__r.name;
                    dealID=recruitmentRecord[0].Wave_Plan_Version__r.Deal__c;
                    itemDisplay=false;
                    dealDisplay=true;
                    locationDisplay=true;
                    waveDisplay=false;
                    wavePlanVersionDisplay=true;
                }
            }
            else if(moduleName == UTIL_constants.KT_TRACKER) /*******************For KTTRACKER Module*****************************/
            {
                //Query to fetch record from Recruitment_Tracking__c 
                //recruitmentRecord=[select Wave_Plan_Version__r.Deal__c, Wave_Plan_Version__r.name, Wave_Plan_Version__c,Wave_Plan_Version__r.Deal__r.name,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, id, name from Deal_Location__c where id=:moduleID];
                
                waveRecord=[Select id, Deal_Location__r.Wave_Plan_Version__r.deal__c, Deal_Location__r.Wave_Plan_Version__c,Location_Name__c, 
                                                Deal_Location__r.Wave_Plan_Version__r.deal__r.name,Wave_Label__c,Deal_Location__r.Wave_Plan_Version__r.name
                                               from Wave_Planning__c where id=: moduleID limit 1000]; 
                if(waveRecord.size()>0)
                {
                    //itemActivity=recruitmentRecord[0].Item__c;
                    locationName=waveRecord[0].Location_Name__c;
                    dealName=waveRecord[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name;
                   waveName=waveRecord[0].Wave_Label__c;
                    wavePlanVersionName=waveRecord[0].Deal_Location__r.Wave_Plan_Version__r.name;
                    dealID=waveRecord[0].Deal_Location__r.Wave_Plan_Version__r.Deal__c;
                    itemDisplay=false;
                    dealDisplay=true;
                    locationDisplay=true;
                    waveDisplay=true;
                    wavePlanVersionDisplay=true;
                }
            }
            else if(moduleName == UTIL_constants.TECH_ASSESSMENT) /*******************For TECHASSESSMENT Module*****************************/
            {
               waveRecord=[Select id, Deal_Location__r.Wave_Plan_Version__r.deal__c, Deal_Location__r.Wave_Plan_Version__c,Location_Name__c, 
                                                Deal_Location__r.Wave_Plan_Version__r.deal__r.name,Wave_Label__c,Deal_Location__r.Wave_Plan_Version__r.name
                                               from Wave_Planning__c where id=: moduleID limit 1000]; 
                if(waveRecord.size()>0) {
                    locationName=waveRecord[0].Location_Name__c;
                    dealName=waveRecord[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name;
                    waveName=waveRecord[0].Wave_Label__c;
                    wavePlanVersionName=waveRecord[0].Deal_Location__r.Wave_Plan_Version__r.name;
                    dealID=waveRecord[0].Deal_Location__r.Wave_Plan_Version__r.Deal__c;
                    itemDisplay=false;
                    dealDisplay=true;
                    locationDisplay=true;
                    waveDisplay=true;
                    wavePlanVersionDisplay=true;
                }
            }
            
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Invalid_Module_ID_or_Name));
                showMainMsg=true;
                showForm=false;
                return;
            }            
            riskRAID=new RAID_Risk__c();
            riskRAID.Module_Name__c=moduleName; 
            riskRAID.Date_Raised__c = date.today();       
            actionRAID=new RAID_Action__c();
            actionRAID.Module_Name__c=moduleName;
            actionRAID.Date_Raised__c = date.today();
            issueRAID=new RAID_Issue__c();
            issueRAID.Module_Name__c=moduleName;
            issueRAID.Date_Raised__c = date.today();
            decisioRAID=new RAID_Decision__c();
            decisioRAID.Module_Name__c=moduleName;
            decisioRAID.Date_Raised__c = date.today();
            initializePageMessages();                        
            initializeRiskRecords();
            initializeActionRecords();
            initializeIssueRecords();
            initializeDecisionRecords();
            /*if(CheckProfile.isMobLeadershipProfile())
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Leadership Profile is Not Authorized to add Risks!'));
                disableLeadButton=false;
                return;
            }
            else
                disableLeadButton=true;*/
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Invalid_Module_ID_or_Name));
            showMainMsg=true;
            showForm=false;
        }
        
        isNA=true;
        isAddVisible =true;
        isEditVisible =true;
       /* UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
        Map<String,Boolean> m = uam.CheckUserRole(dealID,'RAID_Action__c');
        isAddVisible = m.get('C');
        isEditVisible= m.get('U');
        if(m.get('NA'))
        {
            isNA=false;
            showMainMsg=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.NO_Privilege_Contact_your_Admin));
        }   */
        
        isAddVisible=UAMSolMobUtility.isAddVisible_RAIDLog;
        isEditVisible=UAMSolMobUtility.isEditVisible_RAIDLog;  
        if(UAMSolMobUtility.isNA_RAIDLog)
        {
            isNA=false;
            showMainMsg=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.NO_Privilege_Contact_your_Admin));
        }  
    }
    
        /******************************
    Method Name: getRiskRefId
    Description: Displaying Risk List in Action and Decision Tab
    Paramenters: NA
    Return Value: RiskRefIdOptions
    *******************************/
    
     public List<SelectOption> getRiskRefId(){
     List<SelectOption> RiskRefIdOptions=new List<SelectOption>();
       if(moduleName == UTIL_constants.WAVE_PLAN_VERSION_ONE) {
                moduleName = UTIL_constants.HIGH_LEVEL_MOBILIZATION_PLAN;
       }
       for(RAID_Risk__c r : [select Id, Serial_Number__c   from RAID_Risk__c where ModuleID__c=: moduleID and Module_Name__c=:moduleName Order by name asc limit 1000]){
          RiskRefIdOptions.add(new SelectOption(r.Id, r.Serial_Number__c)); 
       }
          return RiskRefIdOptions;
    } 
    
    
            /******************************
    Method Name: getIssueRefId
    Description: Displaying Issue List in Action and Decision Tab
    Paramenters: NA
    Return Value: IssueRefIdOptions
    *******************************/
    
         public List<SelectOption> getIssueRefId(){
     List<SelectOption> IssueRefIdOptions=new List<SelectOption>(); 
       if(moduleName == UTIL_constants.WAVE_PLAN_VERSION_ONE) {
                moduleName = UTIL_constants.HIGH_LEVEL_MOBILIZATION_PLAN;
       }
       for(RAID_Issue__c r : [select Id, Serial_Number__c  from RAID_Issue__c where Module_ID__c=: moduleID and Module_Name__c=:moduleName Order by name asc limit 1000]){
           IssueRefIdOptions.add(new SelectOption(r.Id, r.Serial_Number__c)); 
       }
          return IssueRefIdOptions;
        }
    
    /******************************
    Method Name: initializePageMessages
    Description: Initializing the display for Page Messages
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializePageMessages()
    {
        showRiskMsg=false;
        showActionMsg=false;
        showIssueMsg=false;
        showDecisionMsg=false;
        
        showRiskSave=false;
        showActionSave=false;
        showIssueSave=false;
        showDecisionSave=false;
    }
    /**************************************RISK Tab Begins************************************************/
    /******************************
    Method Name: saveRisksRAID
    Description: Saving the Risk Record
    Paramenters: NA
    Return Value: void
    *******************************/
    public Pagereference saveRisksRAID() {
        initializePageMessages();
        showRiskSave=true;
        initializeRiskRecords();
        
        String IdParameter = ApexPages.currentPage().getParameters().get(UTIL_constants.URL_PARAMETER_ID);
        String moduleParameter = ApexPages.currentPage().getParameters().get(UTIL_constants.MODULE_NAME);
        //String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        //sfdcBaseURL  = sfdcBaseURL + system.label.apex_RAIDLog_Inline;
        
        PageReference currPage = new PageReference(system.label.apex_RAIDLog_Inline);
        
        currPage.getParameters().put(UTIL_constants.URL_PARAMETER_ID, IdParameter );
        currPage.getParameters().put(UTIL_constants.MODULE_NAME,moduleParameter ); 
        currPage.getParameters().put(UTIL_constants.TAB,UTIL_constants.VALUE_ONE); 
        currPage.setRedirect(true);        
        
        if(riskRAID.Title__c==null )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Title));
            return null;
        }
        
        if(riskRAID.Forum_Raised__c==null /*|| riskRAID.Forum_Raised__c=='--Select--'*/ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Title));
            return null;
        }
        if(riskRAID.Workstream_Area__c==null /*|| riskRAID.Workstream_Area__c=='--Select--'*/ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Workstream_Area));
            return null;
        }
        if(riskRAID.Raised_at_level__c==null /*|| riskRAID.Raised_at_level__c=='--Select--'*/  )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Raised_at_level));
            return null;
        }
        if(riskRAID.Risk_Probability__c==null /*|| riskRAID.Risk_Probability__c=='--Select--'*/ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Risk_Probability));
            return null;
        }
        if(riskRAID.Risk_Impact__c==null /*|| riskRAID.Risk_Impact__c=='--Select--'*/ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Risk_Impact));
            return null;
        }
        if(riskRAID.Primary_Owner_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Primary_Owner));
            return null;
        }
        if(riskRAID.Raised_By_Person_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Raised_By_person));
            return null;
        }
        if(riskRAID.Assigned_To_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Assigned_To));
            return null;
        }
        if(riskRAID.Owned_by__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Owned_by));
            return null;
        }
        if(riskRAID.Raised_by_Client_Accenture__c==null )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Risk_Raised_by_Client_Accenture));
            return null;
        }
        try{
            riskRAID.Module_Name__c=moduleName;
            riskRAID.ModuleID__c=moduleID;
            riskRAID.Deal__c=DealID;
            riskRAID.Serial_Number__c=UTIL_constants.R+(riskRecCount+1);
            database.insert(riskRAID);            
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
            return null;
        }
        riskRAID=new RAID_Risk__c();
        riskRAID.Module_Name__c=moduleName;
        riskRAID.Raised_by_Client_Accenture__c=UTIL_constants.ACCENTURE;
        riskRAID.Date_Raised__c = date.today();   
        initializeRiskRecords();
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Risk_Record_Added_Successfully));
        showRiskMsg=false;  
        return currPage;            
    }
    /******************************
    Method Name: initializeRiskRecords
    Description: Query to initialize pre-saved Risk RAID records for the module ID
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializeRiskRecords() {
        listRiskRaidRecords = [Select id, name, Title__c, Action_Reference_ID__c,Decision_Reference_ID__c, Date_Raised__c,Status_Update__c, Serial_Number__c,Action_Ref_ID__r.Serial_Number__c,Action_Ref_ID__c, Risk_Age_days__c, Primary_Owner_New__c, Raised_By_Person_New__c,Decision_Ref_ID__r.Serial_Number__c,Action_Title__c,Decision_Title__c from RAID_Risk__c where ModuleID__c=:moduleID order by createddate limit 1000];            
        riskRecCount= listRiskRaidRecords.size();        
             
    }
    
    /******************************
    Method Name: saveRisksRecords
    Description: Method to save the modifications to Risk Records
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveRisksRecords() {
        initializePageMessages();
        showRiskMsg=true;
        List<RAID_Risk__c> allRiskRecords=new List<RAID_Risk__c>();
        if(listRiskRaidRecords.size()>0)
        { Set<String> riskString = new  Set<String>();
            for(RAID_Risk__c risk : listRiskRaidRecords)
            {
                riskString.add(risk.Title__c);
            }
                if(riskString.contains(null) || riskString.contains(UTIL_Constants.EMPTY_STRING))
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Title_field_in_Risk_Summary_cannot_be_deleted));
                    initializeRiskRecords();                    
                    return;
                }
            
            allRiskRecords.addAll(listRiskRaidRecords);   
                        
                 
            try{
                database.upsert(allRiskRecords);
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));                
                return;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Risk_Records_Saved_Successfully));
            initializeRiskRecords();            
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_insert_the_Risk_record));            
            return;
        }
    }
    /******************************
    Method Name: cancelRisk
    Description: Method to cancel the modifications to Risk Records
    Paramenters: NA
    Return Value: void
    *******************************/
    public void cancelRisk()
    {
        initializeRiskRecords();
    }
    /**************************************RISK Tab Ends**************************************************/
    
    /**************************************Action Tab Begins**************************************************/
    /******************************
    Method Name: saveActionsRAID
    Description: Saving the Actions Record
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public Pagereference saveActionsRAID() {
        initializePageMessages();
        showActionSave=true;
        initializeActionRecords();     
        String IdParameter = ApexPages.currentPage().getParameters().get(UTIL_constants.URL_PARAMETER_ID);
        String moduleParameter = ApexPages.currentPage().getParameters().get(UTIL_constants.MODULE_NAME);
        //String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        //sfdcBaseURL  = sfdcBaseURL + system.label.apex_RAIDLog_Inline;
        
        PageReference currPage = new PageReference(system.label.apex_RAIDLog_Inline);
        
        currPage.getParameters().put(UTIL_constants.URL_PARAMETER_ID, IdParameter );
        currPage.getParameters().put(UTIL_constants.MODULE_NAME,moduleParameter ); 
        currPage.getParameters().put(UTIL_constants.TAB,UTIL_constants.VALUE_TWO); 
        currPage.setRedirect(true);
        if(actionRAID.Raised_by_Client_Accenture__c==null )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Raised_by_Client_Accenture));
            return null;
        }
        if(actionRAID.Forum_Raised__c==null /*|| actionRAID.Forum_Raised__c=='--Select--'*/ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Forum_Raised));
            return null;
        }
        if(actionRAID.Workstream_Area__c==null /* || actionRAID.Workstream_Area__c=='--Select--' */)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Workstream_Area));
            return null;
        }
        if(actionRAID.Raised_at_level__c==null /*|| actionRAID.Raised_at_level__c=='--Select--' */ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Raised_at_level));
            return null;
        }  
        if(actionRAID.Raised_By_Person_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Raised_By_person));
            return null;
        } 
        if(actionRAID.Primary_Owner_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Primary_Owner));
            return null;
        } 
        if(actionRAID.Assigned_To_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Assigned_To));
            return null;
        }
        if(actionRAID.Owned_by__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Owned_by));
            return null;
        }
        if(actionRaid.Actual_Closed_Date__c <actionRaid.Date_Raised__c && actionRaid.Action_Closure_Notes_Comments__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Action_Closure_Notes_Comments_missing));
            return null;        
        }
        if(actionRAID.Action_Title__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Action_Title));
            return null;
        }
        
        try{
            actionRAID.Module_Name__c=moduleName;
            actionRAID.Module_ID__c=moduleID;           
            actionRAID.Deal__c=DealID;
            actionRAID.Serial_Number__c=UTIL_constants.A+(actionRecCount+1);
            database.insert(actionRAID);
  
        }
        catch(Exception ex)
        {
            system.debug('--------------exception-------'+ex);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
            return null;
        }
        List<RAID_Risk__c> riskList =  new  List<RAID_Risk__c>();
        riskList = [select Action_Reference_ID__c, Serial_Number__c,id,Action_Title__c  from RAID_Risk__c where id =: actionRAID.Risk_Ref_ID__c limit 1000];
        if(riskList.Size() >0) {
            if(riskList[0].Action_Reference_ID__c == null){
                riskList[0].Action_Reference_ID__c = UTIL_constants.EMPTY_STRING;
                riskList[0].Action_Reference_ID__c += actionRAID.Serial_Number__c ;
            }
            Else {
                riskList[0].Action_Reference_ID__c +=   UTIL_constants.COMMA_STRING  + actionRAID.Serial_Number__c ;
            }
            
            if(riskList[0].Action_Title__c == null){
                riskList[0].Action_Title__c = UTIL_constants.EMPTY_STRING;
                riskList[0].Action_Title__c += actionRAID.Action_Title__c ;
            }
            Else {
                riskList[0].Action_Title__c  += UTIL_constants.COMMA_STRING  + actionRAID.Action_Title__c ;
            }
            //system.debug('the Debug' + riskList[0].Action_Reference_ID__c);
            string actRefsize = riskList[0].Action_Reference_ID__c ;
            //system.debug('the Debug1' + actRefsize);
            if(actRefsize.length()> 180){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Maximum_character_limit_exceeded_for_Action_Ref_ID));
                return null;
            }               
            try
            {              
            system.debug('--------riskList[0]------------' + riskList[0].Target_Close_Date__c);
            system.debug('--------riskList[0]-----Date_Raised__c-------' + riskList[0].Date_Raised__c);
            database.update(riskList[0]) ;
            }
            catch(Exception ex)
            {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, null, 
            System.Logginglevel.ERROR);
            return null;           
            }
        }
        
        List<RAID_Issue__c> issueList = new List<RAID_Issue__c>();
        issueList = [select Action_Reference_ID__c, Serial_Number__c,id,Action_Title__c from RAID_Issue__c where id =: actionRAID.Issue_Ref_ID__c limit 1000];
        If(issueList.Size() >0) {        
            if(issueList[0].Action_Reference_ID__c  == null){
                issueList[0].Action_Reference_ID__c  = UTIL_constants.EMPTY_STRING;
                issueList[0].Action_Reference_ID__c  += actionRAID.Serial_Number__c;
            }
            Else {
                issueList[0].Action_Reference_ID__c += UTIL_constants.COMMA_STRING + actionRAID.Serial_Number__c;                
            }
             if(issueList[0].Action_Title__c  == null){
                issueList[0].Action_Title__c  = UTIL_constants.EMPTY_STRING;
                issueList[0].Action_Title__c  += actionRAID.Action_Title__c ;
            }
            Else {
                issueList[0].Action_Title__c  += UTIL_constants.COMMA_STRING + actionRAID.Action_Title__c ;                
            }
            //issueList[0].Action_Reference_ID__c += actionRAID.Serial_Number__c+ UTIL_constants.COMMA_STRING ;
            string actionRefsize = issueList[0].Action_Reference_ID__c ;
            if(actionRefsize!=null && actionRefsize.length()> 180){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Maximum_character_limit_exceeded_for_Action_Ref_ID));
                return null;
            }               
           // issueList[0].Action_Reference_ID__c = actionRefsize.removeEnd(UTIL_constants.COMMA_STRING );
           try {
            database.update(issueList[0]);  
            }
            catch(Exception ex)
            {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, null, 
            System.Logginglevel.ERROR);
            return null;           
            }              
        }     
        
        actionRAID=new RAID_Action__c();
        actionRAID.Module_Name__c=moduleName;
        actionRAID.Raised_by_Client_Accenture__c=UTIL_constants.ACCENTURE;
        actionRAID.Date_Raised__c = date.today();   
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Action_Record_Added_Successfully));
        initializeActionRecords();  
        system.debug(currPage);
        return currPage;              
    }
    
    
    /******************************
    Method Name: initializeActionRecords
    Description: Query to initialize pre-saved Action RAID records for the module ID
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializeActionRecords() {        
        listActionRaidRecords = [Select id, name, Date_Raised__c, Risk_Ref_ID__c, Risk_Ref_ID__r.Serial_Number__c, Issue_Ref_ID__r.Serial_Number__c,Issue_Ref_ID__c, Status_Update__c, Action_Age_days__c, Primary_Owner_New__c, Serial_Number__c,Raised_By_Person_New__c,Action_Title__c,Issue_Title__c,Risk_Title__c from RAID_Action__c where Module_ID__c=:moduleID order by createddate limit 1000];      
        actionRecCount=listActionRaidRecords.size();
    }
    /******************************
    Method Name: saveActionRecords
    Description: Method to save the modifications to Action Records
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveActionRecords() {
        initializePageMessages();
        showActionMsg=true;
        List<RAID_Action__c> allActionRecords=new List<RAID_Action__c>();
        if(listActionRaidRecords.size()>0)
        {
            allActionRecords.addAll(listActionRaidRecords);        
            try{
                database.upsert(allActionRecords);
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
                return;
            }
            
        if(actionRaid.Actual_Closed_Date__c <actionRaid.Date_Raised__c && actionRaid.Action_Closure_Notes_Comments__c!=null)
        {
                   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Action_Records_Saved_Successfully));
            initializeActionRecords(); 
            }           
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_insert_the_Action_record));            
            return;
        }
    }
    /******************************
    Method Name: cancelAction
    Description: Method to cancel the modifications to Action Records
    Paramenters: NA
    Return Value: void
    *******************************/
    public void cancelAction()
    {
        initializeActionRecords();
    }
    /**************************************Action Tab Ends**************************************************/
    
    /**************************************Issues Tab Begins**************************************************/
    /******************************
    Method Name: saveIssuesRAID
    Description: Saving the Issues Record
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public Pagereference saveIssuesRAID() {
        initializePageMessages();
        showIssueSave=true;
        initializeIssueRecords();
        
        String IdParameter = ApexPages.currentPage().getParameters().get(UTIL_constants.URL_PARAMETER_ID);
        String moduleParameter = ApexPages.currentPage().getParameters().get(UTIL_constants.MODULE_NAME);
        //String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        //sfdcBaseURL  = sfdcBaseURL + system.label.apex_RAIDLog_Inline;
        
        PageReference currPage = new PageReference(system.label.apex_RAIDLog_Inline);
        
        currPage.getParameters().put(UTIL_constants.URL_PARAMETER_ID, IdParameter );
        currPage.getParameters().put(UTIL_constants.MODULE_NAME,moduleParameter ); 
        currPage.getParameters().put(UTIL_constants.TAB,UTIL_constants.VALUE_THREE); 
        currPage.setRedirect(true);        
        
       /* if(CheckProfile.isMobLeadershipProfile())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Leadership Profile is Not Authorized to add Issues!'));
            return;
        } */
        if(issueRAID.Title__c==null )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Title));
            return null;
        }
        if(issueRAID.Raised_by_Client_Accenture__c==null )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Raised_by_Client_Accenture));
            return null;
        }
        if(issueRAID.Forum_Raised__c==null /*|| issueRAID.Forum_Raised__c=='--Select--'*/ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Forum_Raised));
            return null;
        }
        if(issueRAID.Workstream_Area__c==null /*|| issueRAID.Workstream_Area__c=='--Select--' */)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Workstream_Area));
            return null;
        }
        if(issueRAID.Raised_at_level__c==null /*|| issueRAID.Raised_at_level__c=='--Select--' */ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Raised_at_level));
            return null;
        }   
        if(issueRAID.Issue_Severity__c==null /*|| issueRAID.Issue_Severity__c=='--Select--' */ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Issue_Severity));
            return null;
        }  
        if(issueRAID.Raised_By_Person_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Raised_By_person));
            return null;
        } 
        if(issueRAID.Primary_Owner_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Primary_Owner));
            return null;
        }
        if(issueRAID.Assigned_To_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Assigned_To));
            return null;
        }
        if(issueRAID.Owned_by__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Issue_Owned_by));
            return null;
        }
        if(issueRAID.Actual_Close_Date__c <issueRAID.Date_Raised__c && issueRAID.Issue_Closure_Notes_Comments__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Issue_Closure_Notes_Comments_missing));
            return null;        
        }
        
          
        try{
            issueRAID.Module_Name__c=moduleName;
            issueRAID.Module_ID__c=moduleID;
            issueRAID.Deal__c=DealID;
            issueRAID.Serial_Number__c=UTIL_constants.I+(issueRecCount+1);
           database.insert(issueRAID);            
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
            return null;
        }
        issueRAID=new RAID_Issue__c();
        issueRAID.Module_Name__c=moduleName;
        issueRAID.Raised_by_Client_Accenture__c=UTIL_constants.ACCENTURE;
        issueRAID.Date_Raised__c = date.today();   
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Issue_Record_Added_Successfully));
        initializeIssueRecords();
        return currPage;
    }
    /******************************
    Method Name: initializeIssueRecords
    Description: Query to initialize pre-saved Issue RAID records for the module ID
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializeIssueRecords() {        
        listIssueRaidRecords = [Select id, name, Title__c,Date_Raised__c,Status_Update__c, Action_Reference_ID__c,Decision_Reference_ID__c, Issue_Age_days__c, Primary_Owner_New__c, Serial_Number__c,Action_Ref_ID__c,Decision_Ref_ID__c, Action_Ref_ID__r.Serial_Number__c, Decision_Ref_ID__r.Serial_Number__c, Raised_By_Person_New__c,Decision_Title__c,Action_Title__c from RAID_Issue__c where Module_ID__c=:moduleID order by createddate limit 1000];      
        issueRecCount=listIssueRaidRecords.size();
              
    }
    /******************************
    Method Name: saveIssuesRecords
    Description: Method to save the modifications to Issue Records
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveIssuesRecords() {
        initializePageMessages();
        showIssueMsg=true;
        List<RAID_Issue__c> allIssueRecords=new List<RAID_Issue__c>();
        if(listIssueRaidRecords.size()>0)
        { Set<String> issueString = new  Set<String>();
            for(RAID_Issue__c issue: listIssueRaidRecords)
            {
                issueString.add(issue.Title__c);
            }
                if(issueString.contains(null) || issueString.contains(UTIL_Constants.EMPTY_STRING))
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Title_field_in_Issue_Summary_cannot_be_deleted));
                    initializeIssueRecords();
                    return;
                }
            
            allIssueRecords.addAll(listIssueRaidRecords);        
            try{
                database.upsert(allIssueRecords);
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
                return;
            }
            
           if(issueRAID.Actual_Close_Date__c <issueRAID.Date_Raised__c && issueRAID.Issue_Closure_Notes_Comments__c!=null)
            {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Issue_Records_Saved_Successfully));
            initializeIssueRecords(); 
            }
                       
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_insert_the_Issue_record));
            return;
        }
    }
    /******************************
    Method Name: cancelIssue
    Description: Method to cancel the modifications to Issue Records
    Paramenters: NA
    Return Value: void
    *******************************/
    public void cancelIssue()
    {
        initializeIssueRecords();
    }
    /**************************************Issues Tab Ends**************************************************/
    
    /**************************************Decision Tab Starts**************************************************/
    /******************************
    Method Name: saveDecisionRAID
    Description: Saving the Decisions Record
    Paramenters: NA
    Return Value: void
    *******************************/
    public Pagereference saveDecisionRAID() {
        initializePageMessages();
        showDecisionSave=true;
        initializeDecisionRecords();
        
        String IdParameter = ApexPages.currentPage().getParameters().get(UTIL_constants.URL_PARAMETER_ID);
        String moduleParameter = ApexPages.currentPage().getParameters().get(UTIL_constants.MODULE_NAME);
       
        PageReference currPage = new PageReference(system.label.apex_RAIDLog_Inline);
        
        currPage.getParameters().put(UTIL_constants.URL_PARAMETER_ID, IdParameter );
        currPage.getParameters().put(UTIL_constants.MODULE_NAME,moduleParameter ); 
        currPage.getParameters().put(UTIL_constants.TAB,UTIL_constants.VALUE_FOUR); 
        currPage.setRedirect(true);
                           
        
       /* if(CheckProfile.isMobLeadershipProfile())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Leadership Profile is Not Authorized to add Decisions!'));
            return;
        }*/
        if(decisioRAID.Description__c==null )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Decision_Description));
            return null;
        } 
        if(decisioRAID.Forum_Raised__c==null /*|| decisioRAID.Forum_Raised__c=='--Select--'*/ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Forum_Raised));
            return null;
        }
        if(decisioRAID.Workstream_Area__c==null /*|| decisioRAID.Workstream_Area__c=='--Select--'*/ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Workstream_Area));
            return null;
        }
        if(decisioRAID.Raised_at_level__c==null /*|| decisioRAID.Raised_at_level__c=='--Select--' */ )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Raised_at_level));
            return null;
        }
        if(decisioRAID.Raised_By_Person_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Raised_By_person));
            return null;
        }  
        if(decisioRAID.Assigned_To_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Assigned_To));
            return null;
        }
        if(decisioRAID.Owned_by__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Owned_by));
            return null;
        } 
        if(decisioRAID.Primary_Owner_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Primary_Owner));
            return null;
        }  
        if(decisioRAID.Actual_Close_Date__c <decisioRAID.Date_Raised__c && decisioRAID.Additional_Notes_Comments__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Additional_Notes_Comments_missing));
            return null;        
        }
        //MOB_R1.7_004 modification
         if(decisioRAID.Decision_Title__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Decision_Title));
            return null;
        }
            
        try{
            decisioRAID.Module_Name__c=moduleName;
            decisioRAID.Module_ID__c=moduleID;
            decisioRAID.Deal__c=DealID;
            decisioRAID.Serial_Number__c=UTIL_constants.D+(decisionRecCount+1);
            database.insert(decisioRAID);
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
            return null;
        }
        List<RAID_Risk__c> riskList =  new  List<RAID_Risk__c>();
        riskList = [select Decision_Reference_ID__c,Serial_Number__c,id,Decision_Title__c from RAID_Risk__c where id =: decisioRAID.Risk_Ref_ID__c limit 1000];
        if(riskList.Size()>0) {
            if(riskList[0].Decision_Reference_ID__c == null){
                riskList[0].Decision_Reference_ID__c = UTIL_constants.EMPTY_STRING;
                riskList[0].Decision_Reference_ID__c +=  decisioRAID.Serial_Number__c ;
            }

            Else {
                riskList[0].Decision_Reference_ID__c += UTIL_constants.COMMA_STRING  + decisioRAID.Serial_Number__c  ;
            } 

            if(riskList[0].Decision_Title__c == null){
                riskList[0].Decision_Title__c = UTIL_constants.EMPTY_STRING;
                riskList[0].Decision_Title__c +=  decisioRAID.Decision_Title__c ;
            }

            Else {
                riskList[0].Decision_Title__c +=   UTIL_constants.COMMA_STRING  + decisioRAID.Decision_Title__c ;
            }            
           

            string desRefsize = riskList[0].Decision_Reference_ID__c;
            if(desRefsize.length()> 180){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Maximum_character_limit_exceeded_for_Decision_Ref_ID));
                return null;
            }
            //riskList[0].Decision_Reference_ID__c = desRefsize.removeEnd(UTIL_constants.COMMA_STRING );
            try{
            database.update(riskList[0]);
            }
            catch(Exception ex)
            {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT1, null, 
            System.Logginglevel.ERROR);
            return null;           
            }            
        }
        
        List<RAID_Issue__c> issueList = new List<RAID_Issue__c>();
            issueList = [select Decision_Reference_ID__c, Serial_Number__c,id,Decision_Title__c from RAID_Issue__c where id =: decisioRAID.Issue_Ref_ID__c limit 1000];
        if(issueList.Size() > 0) {            
            if(issueList[0].Decision_Reference_ID__c == null){
                issueList[0].Decision_Reference_ID__c = UTIL_constants.EMPTY_STRING;
                issueList[0].Decision_Reference_ID__c += decisioRAID.Serial_Number__c;                
            }
             Else {
                issueList[0].Decision_Reference_ID__c +=  UTIL_constants.COMMA_STRING  + decisioRAID.Serial_Number__c  ;
                  }            
            if(issueList[0].Decision_Title__c== null){
                issueList[0].Decision_Title__c = UTIL_constants.EMPTY_STRING;
                issueList[0].Decision_Title__c += decisioRAID.Decision_Title__c ;                
            }
             Else {
                issueList[0].Decision_Title__c += UTIL_constants.COMMA_STRING  + decisioRAID.Decision_Title__c  ;
                  }  

            string decisionRefsize = issueList[0].Decision_Reference_ID__c;
            if(decisionRefsize.length()> 180){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Maximum_character_limit_exceeded_for_Decision_Ref_ID));
                return null;
            }        
            //issueList[0].Decision_Reference_ID__c = decisionRefsize.removeEnd(UTIL_constants.COMMA_STRING );
            try{
            database.update(issueList[0]);
            }
            catch(Exception ex)
            {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT1, null, 
            System.Logginglevel.ERROR);
            return null;           
            }            
        }
                
        decisioRAID=new RAID_Decision__c();
        decisioRAID.Module_Name__c=moduleName;
       // decisioRAID.Workstream_Area__c='--Select--';
        //decisioRAID.Raised_at_level__c='--Select--';
        //decisioRAID.Forum_Raised__c='--Select--';
        decisioRAID.Date_Raised__c = date.today();   
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Decision_Record_Added_Successfully));
        initializeDecisionRecords();
        return currPage;
    }
    /******************************
    Method Name: initializeDecisionRecords
    Description: Query to initialize pre-saved Decision RAID records for the module ID
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializeDecisionRecords() {        
        listDecisionRaidRecords = [Select id, name, Date_Raised__c,Risk_Ref_ID__c, Risk_Ref_ID__r.Serial_Number__c, Issue_Ref_ID__r.Serial_Number__c,Issue_Ref_ID__c, Forum_Raised__c, Description__c, Serial_Number__c, Raised_By_Person_New__c, Risk_Title__c, Issue_Title__c, Decision_Title__c from RAID_Decision__c where Module_ID__c=:moduleID order by createddate limit 1000];      
        decisionRecCount=listDecisionRaidRecords.size();
    }
    /******************************
    Method Name: saveDecisionRecords
    Description: Method to save the modifications to Decision Records
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveDecisionRecords() {
        initializePageMessages();
        showDecisionMsg=true;
      /*  if(CheckProfile.isMobLeadershipProfile())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Leadership Profile is Not Authorized to modify Decision Records!'));
            return;
        } */
        List<RAID_Decision__c> allDecisionRecords=new List<RAID_Decision__c>();
        if(listDecisionRaidRecords.size()>0)
        {   Set<String> decisionString = new  Set<String>();   
            for(RAID_Decision__c decision: listDecisionRaidRecords)
            {
                decisionString.add(decision.Description__c); 
            }
            if(decisionString.contains(null) || decisionString.contains(UTIL_Constants.EMPTY_STRING)) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Decision_Description_field_in_Decision_Summary_cannot_be_deleted));
                initializeDecisionRecords();
                return;
            }
            
            allDecisionRecords.addAll(listDecisionRaidRecords);        
            try{
                database.upsert(allDecisionRecords);
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
                return;
            }
             if(decisioRAID.Actual_Close_Date__c <decisioRAID.Date_Raised__c && decisioRAID.Additional_Notes_Comments__c!=null)
           {          
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Decision_Records_Saved_Successfully));
            initializeDecisionRecords();
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_insert_the_Decision_record));
            return;
        }
    }
    /******************************
    Method Name: cancelDecision
    Description: Method to cancel the modifications to Decision Records
    Paramenters: NA
    Return Value: void
    *******************************/
    public void cancelDecision()
    {
        initializeDecisionRecords();
    }
    /**************************************Decision Tab Ends**************************************************/  
}