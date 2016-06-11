/*
Author : Komal Priya
Story  :   
Description : Test Class for UTIL_DataCreationForTestClass. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= false)
private class UTIL_DataCreationForTestClassTest{

    static Assumption__c assumptionRec;
    static Assumption_Master__c assumptionMaster;
    static User testUser; 
    static User testUser1; 
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    public static final string USER_NAME = 'vc123@testorg.com';
    static Opportunity_Offering__c oppOffering;
    static Service_Master__c serviceMaster;
    

    public static void setupData(){
    
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
      /*Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_NAME);
        Database.insert(testUser1, false); */
        
      clientName = UTIL_DataCreationForTestClass.getClientMaster('TestObject1');
      insert clientName;
      
      clientGeoArea = UTIL_DataCreationForTestClass.getClientGEOAreaMaster('TestAPAC');
      insert clientGeoArea;
      
      operatingGroup = UTIL_DataCreationForTestClass.getOperatingGroupMaster('TestHSMPS',true);
      insert operatingGroup;
      
      clientGeoUnit = UTIL_DataCreationForTestClass.getClientGeoUnitMaster('TestLATAM');
      insert clientGeoUnit;
    
        oppTGP = UTIL_DataCreationForTestClass.getBPOOpportunityRecord('TestIBM','Stage 1',clientName.id,clientGeoArea.id,operatingGroup.id,'Low',true,'testRepStatus');
        insert oppTGP;
        
        oppOffering = UTIL_DataCreationForTestClass.getOfferingRecord('TestOffering',oppTGP.id);
        insert oppOffering;
        
        assumptionMaster = UTIL_DataCreationForTestClass.getAssumptionMaster('TestCategory','TestData');
        assumptionMaster.Active_Inactive__c = true;        
        insert assumptionMaster;
        
        Offerings_Master__c offeringMaster = UTIL_DataCreationForTestClass.getOfferingMaster('test');
        insert offeringMaster;
        
        serviceMaster=UTIL_DataCreationForTestClass.getServiceMaster(offeringMaster.id);
        //serviceMaster.Offering__c = offeringMaster.id;
        insert serviceMaster;
        
        Tech_Assessment_Activity_Master__c  techMasterRec = UTIL_DataCreationForTestClass.getTechAssessmentActivityMaster(1234);
        insert techMasterRec;
        
        Deal_TGP__c deal = UTIL_DataCreationForTestClass.getDealRecord('test',testUser.id);
        insert deal ;
        
        Wave_Plan_Version__c WPVRec = UTIL_DataCreationForTestClass.getWavePlanVersionRecord('Trackingis On',deal.id);
        insert WPVRec;
        
        Delievery_Location_Master__c delLocMasterRec = UTIL_DataCreationForTestClass.getdelLocMaster(clientGeoArea.id,'test');
        insert delLocMasterRec ;
        
        Deal_Home_Location__c dealHomeRec = UTIL_DataCreationForTestClass.getDealHomeLocation(delLocMasterRec.id,deal.id);
        insert dealHomeRec;
        
        Deal_Location__c dealLocRec = UTIL_DataCreationForTestClass.getDealLocation('bangalore',dealHomeRec.id,WPVRec.id);
        insert dealLocRec ;
        
        Wave_Planning__c wavePlanningRec = UTIL_DataCreationForTestClass.getWavePlanning(dealLocRec.id,System.today()+7,'test');
        insert wavePlanningRec;
        
        Tracking_Tech_Assessment__c  trackingTechAssRec = UTIL_DataCreationForTestClass.getTrackingTechAssessment();

        insert trackingTechAssRec;
        
        Tracking_Recruitment__c trackingRecruitmentRec = UTIL_DataCreationForTestClass.getTrackingRecruitment();
        insert trackingRecruitmentRec;
        
        Tracking_KT__c  trackingKT = UTIL_DataCreationForTestClass.getTrackingKT();
        insert trackingKT;
        
        Technical_Arch_Task__c  techArchTask = UTIL_DataCreationForTestClass.getTechnicalArchTask();
        insert techArchTask;
        
        Tech_Tracker__c techTracker = UTIL_DataCreationForTestClass.getTechTracker();
        insert techTracker ;
        
        //Solution_Scope__c solScope = UTIL_DataCreationForTestClass.getSolScope();
        //insert solScope;
        
        //Staffing_Plan__c staffingPlanRec = UTIL_DataCreationForTestClass.getStaffingPlan(solScope.id,2,'test');
        //insert staffingPlanRec ;
        
        Solution_User_Task__c solUserTaskRec = UTIL_DataCreationForTestClass.getSolUserTask();
        insert solUserTaskRec ;
        
        Solution_User_Assignment__c solUserAssignmentRec = UTIL_DataCreationForTestClass.getSolUserAssignment();
        solUserAssignmentRec.BPO_Opportunity__c = oppTGP.id ;
        insert solUserAssignmentRec;
        
        Solution_Specialist_Task__c solSpecialistRec = UTIL_DataCreationForTestClass.getSolSpecialistTask();
        insert solSpecialistRec ;
        
        Offerings_Master__c ofMaterRec = UTIL_DataCreationForTestClass.getOfferingMaster('test');
        insert ofMaterRec ;
        
        Solution_Plan__c solPlane = UTIL_DataCreationForTestClass.getSolPlan();
        solPlane.BPO_Opportunity__c = oppTGP.id ;
        insert solPlane;
        
        Service_Component__c serComRec = UTIL_DataCreationForTestClass.getServiceComponentMaster();
        serComRec.Service_Master__c = serviceMaster.id;
        serComRec.Offering_Master__c = ofMaterRec.id;
        insert serComRec ;
        
        Scheduling__c schRec = UTIL_DataCreationForTestClass.getScheduling();
        schRec.BPO_Opportunity_MD__c = oppTGP.id;
        insert schRec ;
        
        SRAT_User_Sub_Section_Question__c SRATUserSubSectionQuestionRec = UTIL_DataCreationForTestClass.getSRATUserSubSection();
        insert SRATUserSubSectionQuestionRec ;
        
        SRAT_VERSION__c SRATVersionRec = UTIL_DataCreationForTestClass.getSRATVersion('test');
        insert SRATVersionRec;
        
        
         SRAT__c SRATRec = UTIL_DataCreationForTestClass.getSRAT();
         SRATRec.Deal_Location_lk__c = dealLocRec.id;
         SRATRec.Wave_Plan_lk__c = wavePlanningRec.id;
         insert SRATRec ;
         
         Review_files_attachment__c rreviewFileAttachmentRec = UTIL_DataCreationForTestClass.getReviewFileAttachment();
         insert rreviewFileAttachmentRec ;
         
         Review_Process__c revProcessRec = UTIL_DataCreationForTestClass.getReviewProcess();
         insert revProcessRec ;
         
         Review_Meeting_Request__c revMeetingRec = UTIL_DataCreationForTestClass.getReviewMeetingRequest();
         insert revMeetingRec ;
         
         Review_MOM_Titel__c revMOMTitleRec = UTIL_DataCreationForTestClass.getReviewMOMTitle();
         insert revMOMTitleRec ;
         
         Review_MOM__c revMOMRec = UTIL_DataCreationForTestClass.getReviewMOM();
         insert revMOMRec ;
         
         //Request_Review__c reqReviewRec = UTIL_DataCreationForTestClass.getRequestReview();
         //insert reqReviewRec ;
         
         Contact conRec = new Contact(LastName = 'test');
         insert conRec;
         
         Request__c reqRec = UTIL_DataCreationForTestClass.getRequest();
         reqRec.Request_Title__c = 'TestTitle';
         reqRec.Requestor__c = conRec.id;
         insert reqRec;
         
         Release__c relRec = UTIL_DataCreationForTestClass.getRelease();
         insert relRec ;
         
         Recruitment_Tracker__c recruitmentTrackerRec = UTIL_DataCreationForTestClass.getRecruitmentTracker();
         insert recruitmentTrackerRec ;
         
         Opportunity_Solution_Lead_Task__c oppSolLeadTaskRec = UTIL_DataCreationForTestClass.getOpportunitySolutionLeadTask();
         insert oppSolLeadTaskRec ;
         
         OPEX_User_Section_Question__c opexUserSecQusRec = UTIL_DataCreationForTestClass.getOpexUserSectionQuestion();
         insert opexUserSecQusRec ;
         
         OPEX_Version__c opexVer = UTIL_DataCreationForTestClass.getOpexVersion('test');
         insert opexVer;
         
         OPEX_Section_Name__c opexSecName = UTIL_DataCreationForTestClass.getOpexSectionName(opexVer.id);
         insert opexSecName;
         
         OPEX_Section_Questionnaire__c opexSecQusRec  = UTIL_DataCreationForTestClass.getOpexSectionQuestionnaire();
         opexSecQusRec.OPEX_Section_Name__c = opexSecName.id;
         opexSecQusRec.Question_No__c = 2;
         opexSecQusRec.Sort_Number__c = 3;
         insert opexSecQusRec  ;
         
         Mob_User_Roles_Master__c mobUserRoleMasterRec = UTIL_DataCreationForTestClass.getMobUserRoleMaster('mob user');
         insert mobUserRoleMasterRec;
         
         MOB_User_Role_Assignment__c mobUserRoleAssignmntRec = UTIL_DataCreationForTestClass.getMobUserRoleAssignment();
         mobUserRoleAssignmntRec.Deal__c = deal.id;
         mobUserRoleAssignmntRec.Access_Level__c = 'test';
         mobUserRoleAssignmntRec.Mob_User_Roles_Master__c = mobUserRoleMasterRec.id;
         mobUserRoleAssignmntRec.Role_Name__c = 'test role';
         insert mobUserRoleAssignmntRec ;
         
         Mob_Architect_Task__c MobArchitectTaskRec = UTIL_DataCreationForTestClass.getMobArchitectTask();
         insert MobArchitectTaskRec ;
         
         Journey_Management_Planning__c jrnyManagementPlanning = UTIL_DataCreationForTestClass.getJourneyManagementPlanning();
         insert jrnyManagementPlanning ;
         
         Domain_Expert_Task__c domainExpertTaskRec = UTIL_DataCreationForTestClass.getdomainExpertTask();
         insert domainExpertTaskRec ;
         
         Document_for_Request_Review__c docForReqReviewRec = UTIL_DataCreationForTestClass.getdomainForRequestReview();
         insert docForReqReviewRec ;
         
         DTP_Tracker__c DTPTrackerRec = UTIL_DataCreationForTestClass.getDTPTracker();
         insert DTPTrackerRec ;
         
         Contract_Legal_Infosec__c contractLegalInfoRec = UTIL_DataCreationForTestClass.getContractLegalInfosec();
         insert contractLegalInfoRec ;
         
         APXTConga4__Conga_Email_Template__c CongaEmailTemplate  = UTIL_DataCreationForTestClass.getCongaEmailTemplate();
         insert CongaEmailTemplate ;
         
         APXTConga4__Conga_Email_Staging__c CongaEmailStaging  = UTIL_DataCreationForTestClass.getCongaEmailStaging();
         insert CongaEmailStaging ;
         
        // Component_Service__c ComponentService  = UTIL_DataCreationForTestClass.getComponentService();
         //ComponentService.Solution_Scope__c = solScope.id;
        // ComponentService.Description__c = 'test';
        // insert ComponentService ;
         
         Capability__c capRec = UTIL_DataCreationForTestClass.getcapabilities();
         insert capRec ;
         
         Application_Inventory__c appInvRec = UTIL_DataCreationForTestClass.getapplicationInventory();
         appInvRec.Request__c = reqRec.id;
         insert appInvRec ;
         
         Actual_Level_of_Effort__c actualLevelEffortRec = UTIL_DataCreationForTestClass.getactualLevelEffort();
         actualLevelEffortRec.Requirement__c = reqRec.id;
         actualLevelEffortRec.Week__c = System.today();
         insert actualLevelEffortRec ;
         
         Primary_Owner_Master__c primaryOwnerMasterRec = UTIL_DataCreationForTestClass.getprimaryOwnerMaster();
         primaryOwnerMasterRec.Email_ID__c = 'abc321@email.com';
         insert primaryOwnerMasterRec ;
         
         Tech_Assessment_Activity_Master__c techAssActivityMasterRec = UTIL_DataCreationForTestClass.getTechAssessmentActivityMaster(1235);
         insert techAssActivityMasterRec ;
         
         SRAT_Item_Master__c SRATItemMaster  = UTIL_DataCreationForTestClass.getSRATItemMaster();
         SRATItemMaster.Days_Before_Go_Live_Date__c = -1;
         SRATItemMaster.Item_Name__c = 'test';
         insert SRATItemMaster ;
         
         Risk_Master__c riskMasterrec = UTIL_DataCreationForTestClass.getriskMaster();
         insert riskMasterrec ;
         
         Activity_Master__c ActivityMaster  = UTIL_DataCreationForTestClass.getActivityMaster(2313);
         insert ActivityMaster ;
         
         Assumption__c assmRec = UTIL_DataCreationForTestClass.getAssumptionRecord('test',oppOffering.id);
         insert assmRec;
         
         Budget_Solution__c  budgetSolRec = UTIL_DataCreationForTestClass.getBudgetSolutionRecord('test');
         insert budgetSolRec;
         
         Current_Client_Capability_Assessment__c cccaRec = UTIL_DataCreationForTestClass.getCurrentClientCapabilityAssessmentRecord();
         insert cccaRec ;
         
         Client_Specific_Process_Mapping__c clientSpecificProcessMappingRec = UTIL_DataCreationForTestClass.getClientSpecificProcessMapping('test',deal.id,offeringMaster.id);
         insert clientSpecificProcessMappingRec;
         
         Wave_Process__c WaveProcessRec = UTIL_DataCreationForTestClass.getWaveProcess(wavePlanningRec.id);
         WaveProcessRec.Client_Specific_Process_Mapping__c = clientSpecificProcessMappingRec.id;
         insert WaveProcessRec;
         
         Commercial_Planning__c  comPlanRec = UTIL_DataCreationForTestClass.getWaveCommercialPlanning('test','testActivity',1238);
         insert comPlanRec ;
         
         Tech_Assessment__c  TechAssessmentRec = UTIL_DataCreationForTestClass.getTechAssessment('test','testActivity',System.today(),System.today()+7,wavePlanningRec.id,dealLocRec.id);
         insert TechAssessmentRec;
         
         Risk__c  riskRec = UTIL_DataCreationForTestClass.getrisk('test',oppOffering.id);
         insert riskRec;
         
         Review_Action_Item_Log__c  revActionItemLogRec = UTIL_DataCreationForTestClass.getReviewActionItemLog('test');
         insert revActionItemLogRec;
         
         Process__c processRec = UTIL_DataCreationForTestClass.getProcess(oppOffering.id);
         insert processRec;
         
         SRAT_Section_Name__c SRATSectionNameRec = UTIL_DataCreationForTestClass.getSRATSectionName();
         SRATSectionNameRec.SRAT_Version__c = SRATVersionRec.id;
         insert SRATSectionNameRec;
         
         SRAT_Sub_Section_Name__c SRATSubSectionNameRec = UTIL_DataCreationForTestClass.getSRATSubSectionName();
         SRATSubSectionNameRec.SRAT_Section_Name__c = SRATSectionNameRec.id;
         insert SRATSubSectionNameRec;
        
        }
    static void setUpData1(){
    
        Operating_Group_Master__c opp_Grp_Master=new Operating_Group_Master__c();
        opp_Grp_Master.Operating_Group_Name__c='TestOpGrpMaster';
        database.insert(opp_Grp_Master);
        
        Client_Master__c clientMaster=new Client_Master__c();
        clientMaster.Name='Test';
        clientMaster.Active__c=True;
        database.insert(clientMaster);
         
         Client_Geo_Area_Master__c clientGeo=new Client_Geo_Area_Master__c ();
         clientGeo.Client_Geo_Area_Name__c='clientGeo';
         database.insert(clientGeo);
         Opportunity_TGP__c objOpportunity=new Opportunity_TGP__c();
         objOpportunity.Name='Test';
         objOpportunity.Client_Name__c=clientMaster.Id;
         objOpportunity.Client_Geo_Area__c=clientGeo.Id;
         objOpportunity.Operating_Group__c=opp_Grp_Master.Id;
         database.insert(objOpportunity);
         
         Opportunity_Offering__c oppOff =new Opportunity_Offering__c();
         oppOff.Offering_Text_Name__c='TestOffering';
         oppOff.Opportunity_TGP__c=objOpportunity.id;
         database.insert(oppOff);
    
         
        
         Offerings_Master__c offMaster=new Offerings_Master__c();
         offMaster.Name='testOffMasster';
         database.insert(offMaster);
         Service_Master__c services=new Service_Master__c();
         services.Name='Tech Support - Inbound';
         services.Offering__c =offMaster.Id;
         Database.insert(services);
        
         Service_Delivery_Location__c servicesloc=new Service_Delivery_Location__c();
         servicesloc.Name='testServiceDelivaryLoc';
         servicesloc.Opportunity_Offering__c=oppOff.id;
         database.insert(servicesloc);
         //Solution_Scope__c scoscope=new Solution_Scope__c();
         //scoscope.Name='scoscopeTest';
         //database.insert(scoscope);
         
         
         
         Deal_TGP__c deal_TGP=new Deal_TGP__c();
         deal_TGP.Name='testDeal';
         database.insert(deal_TGP); 
        
         Wave_Plan_Version__c wavepalnversion=new Wave_Plan_Version__c();
         wavepalnversion.Name='TestWaveplan';
         wavepalnversion.Deal__c= deal_TGP.Id;
         database.insert(wavepalnversion);
        
         Deal_Location__c dealLocation=new Deal_Location__c();
         dealLocation.Location__c='testLocation';
         dealLocation.Wave_Plan_Version__c=wavepalnversion.Id;
         database.insert(dealLocation); 
        
         Wave_Planning__c wplan=new Wave_Planning__c();
         wplan.Cloned_From__c='testDeal';
         wplan.Deal_Location__c=dealLocation.Id;
         wplan.GO_Live_Date_del__c=System.today();
         wplan.Wave_Label__c='TestWave';
         Database.insert(wplan);
        
         Service_Management__c serviceManagement=new Service_Management__c();
         serviceManagement.Wave_Plan__c=wplan.id;
         serviceManagement.Activity__c='TEST';
         serviceManagement.Planned_Start_Date__c=System.today();
         serviceManagement.Planned_End_Date__c=System.today()+1;
         Database.insert(serviceManagement); 
        
         SRAT_VERSION__c SRATName=new SRAT_VERSION__c();
         SRATName.SRAT_Name__c='Test SRAT';
         database.insert(SRATName);
         SRAT_VERSION__c SRATVersionRec1 = UTIL_DataCreationForTestClass.getSRATVersion('test');
         insert SRATVersionRec1;
        
        
         SRAT_Section_Name__c SRATSectionNameRec1 = UTIL_DataCreationForTestClass.getSRATSectionName();
         SRATSectionNameRec1.SRAT_Version__c = SRATVersionRec1.id;
         insert SRATSectionNameRec1;
         
         SRAT_Section_Questionnaire__c SRATSectionQues=new SRAT_Section_Questionnaire__c();
         SRATSectionQues.Title__c='SRATsectionTest';
         SRATSectionQues.Question_Description__c='testQuestion';
         SRATSectionQues.Sort_Order__c=2;
         SRATSectionQues.SRAT_Section_Name__c=SRATSectionNameRec1.Id;
         database.insert(SRATSectionQues);
        
         Risk__c riskObj=new Risk__c();
         riskObj.Name='High';
         riskObj.Opportunity_Offering__c= oppOff.Id;
        
         database.insert(riskObj);
         
         SAP_OM_Opportunity__c SAPOMOpportunity=new SAP_OM_Opportunity__c();
         SAPOMOpportunity.Name='SAP Name';
         SAPOMOpportunity.Client_Name__c= clientMaster.Id;
         SAPOMOpportunity.Opportunity_Name__c='TestOpp';
         SAPOMOpportunity.Client_Geo_Area__c=clientGeo.Id;
         SAPOMOpportunity.Operating_Group__c=opp_Grp_Master.Id;
         database.insert(SAPOMOpportunity);
        
         Recruitment_Tracking__c RecruitmentTracking=new Recruitment_Tracking__c();
         RecruitmentTracking.Name='Test  RecruitmentTracking';
         RecruitmentTracking.Deal_Location_lk__c=dealLocation.Id;
         RecruitmentTracking.Wave_Plan_lk__c= wplan.Id;
         RecruitmentTracking.Planned_End_Date__c=system.today()+1;
         RecruitmentTracking.Planned_Start_Date__c=system.today();
         RecruitmentTracking.Activity__c='Test';
         Database.insert(RecruitmentTracking);
         
         RAID_Issue__c RAIDIssue=new RAID_Issue__c();
         RAIDIssue.Deal__c=deal_TGP.Id;
         RAIDIssue.Module_Name__c='TestRAID';
         RAIDIssue.Title__c='TestTitle';
         RAIDIssue.Raised_by_Client_Accenture__c='Accenture';
         RAIDIssue.Issue_Severity__c='High';
         RAIDIssue.Forum_Raised__c='Strategic / Engagement Level';
         RAIDIssue.Raised_at_level__c='Strategic / Engagement Level';
         RAIDIssue.Primary_Owner__c=UserInfo.getUserId();
         RAIDIssue.Assigned_To__c=UserInfo.getUserId();
         RAIDIssue.Owned_by__c='Tester';
         RAIDIssue.Raised_by_person__c=UserInfo.getUserId();
         RAIDIssue.Workstream_Area__c='Manage Transition Programme';
         Database.insert(RAIDIssue);
        
         RAID_Risk__c RAIDRisk =new RAID_Risk__c();
         RAIDRisk.Module_Name__c='TestModule';
         RAIDRisk.Deal__c=deal_TGP.Id;
         RAIDRisk.Module_Name__c='TestRAID';
         RAIDRisk.Title__c='TestTitle';
         RAIDRisk.Raised_by_Client_Accenture__c='Accenture';
         RAIDRisk.Forum_Raised__c='Strategic / Engagement Level';
         RAIDRisk.Raised_at_level__c='Strategic / Engagement Level';
         RAIDRisk.Primary_Owner__c=UserInfo.getUserId();
         RAIDRisk.Assigned_To__c=UserInfo.getUserId();
         RAIDRisk.Owned_by__c='Tester';
         RAIDRisk.Raised_by_person__c=UserInfo.getUserId();
         RAIDRisk.Workstream_Area__c='Manage Transition Programme';
         RAIDRisk.Risk_Impact__c='High';
         RAIDRisk.Risk_Probability__c='High';
         Database.insert(RAIDRisk);
          
         OPEX__c opex=new OPEX__c();
         opex.Name='TestOpex';
         opex.Planned_Date__c=system.today();
         opex.Deal_Location__c=dealLocation.Id;
         opex.Wave_Plan__c=wplan.Id;
         opex.Deal_Location_lk__c=dealLocation.Id;
         opex.Wave_Plan_lk__c=wplan.Id;
         database.insert(opex);
         MEC_Post_Contract_Version__c MCEPostObj=new MEC_Post_Contract_Version__c();
         MCEPostObj.Version_Name__c='testMEC';
         database.insert(MCEPostObj);
        
         MEC_Post_Contract_End_User__c MECPostContractEnd=new MEC_Post_Contract_End_User__c();
         MECPostContractEnd.Version_Number__c= MCEPostObj.Id;
         MECPostContractEnd.Entry_Criteria_for_Project_Execution__c='TestCriteria';
         MECPostContractEnd.Deal__c=deal_TGP.Id;
         database.insert(MECPostContractEnd);
         
        KT_Planning__c KT_Planning=new KT_Planning__c();
        KT_Planning.Activity__c='test';
        KT_Planning.Planned_Start_Date__c=system.today();
        KT_Planning.Planned_End_Date__c=system.today()+1;
        KT_Planning.Wave_Plan_lk__c=wplan.Id;
        KT_Planning.Deal_Location_lk__c=dealLocation.Id;
        database.insert(KT_Planning);
        
         Delievery_Location_Master__c deliverylocation=new Delievery_Location_Master__c();
         deliverylocation.Name='TestDL';
         deliverylocation.Delivery_Location_Description__c='TestDelivery';
         deliverylocation.Client_Geo_Area_Master__c=clientGeo.Id;
         Database.insert(deliverylocation);        
        
         Facility_Master__c facilityMaster=new Facility_Master__c();
         facilityMaster.Name='TestFM';
         facilityMaster.Facility_Description__c ='TesetDescription';
         facilityMaster.Delivery_Location_Master__c=deliverylocation.Id;
         database.insert(facilityMaster); 
        
          
        
         
     
         Opportunity_TGP__c oppTGP1= UTIL_DataCreationForTestClass.getBPOOpportunityRecord('Test','1',clientMaster.Id,clientGeo.Id,opp_Grp_Master.Id,'High',true,'lost');
         Value_Proposition__c valueProp=UTIL_DataCreationForTestClass.getValuePropositionRecord(objOpportunity.Id);
         //UTIL_DataCreationForTestClass.getSolScope();
         Services__c services1 =UTIL_DataCreationForTestClass.getServices(services.Name,services.Id,'Conditional',offMaster.Id,servicesloc.Id);
         Service_Delivery_Location__c serviceDelivery_Location=UTIL_DataCreationForTestClass.getServiceDeliveryLocation( servicesloc.Name,offMaster.Id);
         //Service_Delivery_Model__c serviceDeliveryMod=UTIL_DataCreationForTestClass.getServiceDeliveryModel(scoscope.Name,scoscope.id);
         Service_Management__c serviceManagement1= UTIL_DataCreationForTestClass.getServiceManagement(wplan.id, dealLocation.id,'Test','TestName' ,serviceManagement.Planned_Start_Date__c,serviceManagement.Planned_End_Date__c);
         SRAT_VERSION__c SRATName1=UTIL_DataCreationForTestClass.getSRATVersion(SRATName.Id);
         SRAT_Section_Questionnaire__c SRATSectionQues1=UTIL_DataCreationForTestClass.getSRATSectionQuestionnaire(SRATSectionQues.Name,SRATSectionQues.Question_Description__c ,2);
         Risk__c riskObj1=UTIL_DataCreationForTestClass.getrisk(riskObj.Name,oppOff.Id);
         SAP_OM_Opportunity__c SAPOMOpportunity1=UTIL_DataCreationForTestClass.getSAPOmOpportunity(SAPOMOpportunity.Name, clientMaster.Id, '3B',clientGeo.Id,opp_Grp_Master.Id,1, SAPOMOpportunity.Opportunity_Name__c,'Lost');
         Recruitment_Tracking__c RecruitmentTracking1=UTIL_DataCreationForTestClass.getRecruitmentTracking(RecruitmentTracking.Deal_Location_lk__c,RecruitmentTracking.Wave_Plan_lk__c ,RecruitmentTracking.Name , RecruitmentTracking.Activity__c, RecruitmentTracking.Planned_Start_Date__c, RecruitmentTracking.Planned_End_Date__c,1);
         RAID_Issue__c RAIDIssue1=UTIL_DataCreationForTestClass.getRAIDIssue(RAIDIssue.Deal__c,RAIDIssue.Module_Name__c,RAIDIssue.Title__c,RAIDIssue.Raised_by_Client_Accenture__c,RAIDIssue.Issue_Severity__c,RAIDIssue.Forum_Raised__c, RAIDIssue.Raised_at_level__c, RAIDIssue.Primary_Owner__c, RAIDIssue.Assigned_To__c,RAIDIssue.Owned_by__c , RAIDIssue.Raised_by_person__c,  RAIDIssue.Workstream_Area__c);
         RAID_Risk__c RAIDRisk1=UTIL_DataCreationForTestClass.getRAIDRisk(RAIDRisk.Deal__c, RAIDRisk.Title__c, RAIDRisk.Raised_by_Client_Accenture__c, RAIDRisk.Forum_Raised__c, RAIDRisk.Raised_at_level__c, RAIDRisk.Risk_Impact__c, RAIDRisk.Primary_Owner__c, RAIDRisk.Assigned_To__c, RAIDRisk.Owned_by__c, RAIDRisk.Raised_by_person__c, RAIDRisk.Workstream_Area__c, RAIDRisk.Risk_Probability__c);
         Offering_Scope_Image__c Offering_ScopeImage=UTIL_DataCreationForTestClass.getOfferingScopeImage(oppOff.Id);
         OPEX__c OPEX1=UTIL_DataCreationForTestClass.getOpexRec(opex.Name,opex.Planned_Date__c , opex.Deal_Location__c, opex.Wave_Plan__c);
         MEC_Post_Contract_Version__c MECPostContractVersion=UTIL_DataCreationForTestClass.getMECPostContractVersion(MCEPostObj.Version_Name__c);
         MEC_Post_Contract_End_User__c MECPostContractEnd1=UTIL_DataCreationForTestClass.getMECPostContractEndUser(MECPostContractEnd.Version_Number__c, MECPostContractEnd.Entry_Criteria_for_Project_Execution__c,MECPostContractEnd.Deal__c);
         KT_Tracker__c KT_Tracker=UTIL_DataCreationForTestClass.getKTTracker();
         Key_Buyer_Value__c Key_Buyer_Value=UTIL_DataCreationForTestClass.getkeyBuyerValue(oppTGP1.id);
         KT_Planning__c KT_Planning1=UTIL_DataCreationForTestClass.getKTPlanning(KT_Planning.Activity__c, KT_Planning.Planned_Start_Date__c , KT_Planning.Planned_End_Date__c, KT_Planning.Wave_Plan_lk__c,KT_Planning.Deal_Location_lk__c);
         Delievery_Location_Master__c delivery=UTIL_DataCreationForTestClass.getDelieveryLocationMaster('name',clientGeo.Id);
         Facility_Master__c facilityObj=UTIL_DataCreationForTestClass.getFacilityMaster(facilityMaster.Id,facilityMaster.Name);
    }
    
    static void setupData4(){
        
         Deal_TGP__c deal_TGP1=new Deal_TGP__c();
         deal_TGP1.Name='testDeal';
         database.insert(deal_TGP1);
        
         RAID_Decision__c RAIDDecision=new RAID_Decision__c();
         RAIDDecision.Module_Name__c='TestModule';
         RAIDDecision.Description__c='Test RAIDDescription';
         RAIDDecision.Deal__c=deal_TGP1.Id;
         RAIDDecision.Module_Name__c='TestRAID';
         RAIDDecision.Forum_Raised__c='Strategic / Engagement Level';
         RAIDDecision.Raised_at_level__c='Strategic / Engagement Level';
         RAIDDecision.Primary_Owner__c=UserInfo.getUserId();
         RAIDDecision.Assigned_To__c=UserInfo.getUserId();
         RAIDDecision.Owned_by__c='Tester';
         RAIDDecision.Raised_by_person__c=UserInfo.getUserId();
         RAIDDecision.Workstream_Area__c='Manage Transition Programme';
         Database.insert(RAIDDecision); 
         
         RAID_Action__c RAID_Action=new RAID_Action__c ();
         RAID_Action.Module_Name__c='TestModule';
         RAID_Action.Description__c='Test RAIDDescription';
         RAID_Action.Deal__c=deal_TGP1.Id;
         RAID_Action.Module_Name__c='TestRAID';
         RAID_Action.Forum_Raised__c='Strategic / Engagement Level';
         RAID_Action.Raised_at_level__c='Strategic / Engagement Level';
         RAID_Action.Primary_Owner__c=UserInfo.getUserId();
         RAID_Action.Assigned_To__c=UserInfo.getUserId();
         RAID_Action.Owned_by__c='Tester';
         RAID_Action.Raised_by_person__c=UserInfo.getUserId();
         RAID_Action.Workstream_Area__c='Manage Transition Programme';
         database.insert(RAID_Action);
         
         Third_Party_Vendor_Master_Custom__c thirdPartyVendor=new Third_Party_Vendor_Master_Custom__c();
         thirdPartyVendor.Third_Party_Vendor_Name__c='testVendor';
         database.insert(thirdPartyVendor);
         
         Contract_Legal_Infosec_Section_Master__c contrsctlegalsection=new Contract_Legal_Infosec_Section_Master__c();
         contrsctlegalsection.Section_Name__c='Testsrction';
         contrsctlegalsection.Section_Number__c='1234';
         database.insert(contrsctlegalsection);
         
         
         RAID_Decision__c RAID_Decision1=UTIL_DataCreationForTestClass.getRAIDDecision(RAIDDecision.Deal__c, RAIDDecision.Module_Name__c,RAIDDecision.Description__c, RAIDDecision.Forum_Raised__c, RAIDDecision.Raised_at_level__c, RAIDDecision.Primary_Owner__c, RAIDDecision.Assigned_To__c, RAIDDecision.Owned_by__c, RAIDDecision.Raised_By_Person__c, RAIDDecision.Workstream_Area__c);        
         RAID_Action__c RAID_Action1=UTIL_DataCreationForTestClass.getRAIDAction(RAID_Action.Deal__c,RAID_Action.Module_Name__c,RAID_Action.Description__c,RAID_Action.Forum_Raised__c, RAID_Action.Raised_at_level__c, RAID_Action.Primary_Owner__c, RAID_Action.Assigned_To__c,RAID_Action.Owned_by__c, RAID_Action.Raised_By_person__c,RAID_Action.Workstream_Area__c);
         MEC_Post_Contract_End_User_Questionnaire__c MEC_postOBJ=UTIL_DataCreationForTestClass.getMECPostContractEndUserQuestionnaire(deal_TGP1.Id);
         Service_Management_Master__c servicemanagement=UTIL_DataCreationForTestClass.getServiceManagementMaster('Test',2);
         Solution_Document_Master__c solutionDoc=UTIL_DataCreationForTestClass.getSolDocumentMaster('solutionDoc');
         Third_Party_Vendor_Master_Custom__c thirdPartyVendor1=UTIL_DataCreationForTestClass.getThirdPartyVendorMaster(thirdPartyVendor.Third_Party_Vendor_Name__c);
         Category__c Category=UTIL_DataCreationForTestClass.getcategoryMaster('TestCategory');
         Commercial_Plan_Activity_Master__c commerialPlan=UTIL_DataCreationForTestClass.getcommPlanActivityMaster('activityName',123);
         Contract_Legal_Infosec_Section_Master__c contractLegal=UTIL_DataCreationForTestClass.getLegalInfosecSectionMaster('name','secNumber');
         Contract_Legal_Infosec_Task_Master__c   ContractTask=UTIL_DataCreationForTestClass.getcontractLegalInfosecTaskMaster(contrsctlegalsection.Id,'taskName','taskNo');
         Review_Type_Master__c reviewType=UTIL_DataCreationForTestClass.getReviewTypeMaster('ReviewMaster');
         Review_Stage_Master__c reviewStage=UTIL_DataCreationForTestClass.getReviewStageMaster('ReviewStagemaster');
         Outbound_Email_User_Master__c outbound=UTIL_DataCreationForTestClass.getOutBoundEmailUserMaster('TestuserName','test@tester.com');
         Key_Buyer_Value_Category_Master__c keyBuyerVal=UTIL_DataCreationForTestClass.getkeyBuyerValueCategoryMaster('keyBuyer');
         KT_Planning_Activity_Master__c KTPlaning=UTIL_DataCreationForTestClass.getKTPlanningActivityMaster('KTPlaning');
         Budget__c budget=UTIL_DataCreationForTestClass.getBudget('NewbudgetMaster');
         APXTConga4__Conga_Template__c  APXT=UTIL_DataCreationForTestClass.getCongaTemplate('templateType');
        Journey_Management__c journeymanagement=UTIL_DataCreationForTestClass.getJourneyManagement('Testsection','TestsectionNumber');
        Factory_Specific_Technology__c appName=UTIL_DataCreationForTestClass.getfactorySpecificTech('FactorySpecificTech');
    }
    
   /*     static testMethod void test2(){
    
        test.starttest();
            setupData();
          test.stoptest();
  
    }*/
     /*static testMethod void test3(){
    
        test.starttest();
          
            setUpData1();
         test.stoptest();
  
    }
    static testMethod void test4(){
    
        test.starttest();
          setupData4();
         test.stoptest();
  
    }*/



}