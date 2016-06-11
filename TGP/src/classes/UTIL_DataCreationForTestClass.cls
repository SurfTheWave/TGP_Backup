/*
* @Author : Accenture IDC Team
* @Description : UTIL Class for vreating test data for all Test classes. 
* @Version : 1.0                
*/
public with sharing class UTIL_DataCreationForTestClass {
    
    private static final string ALIAS = 'vc12';
    private static final string EMAIL = 'vc12@testorg.com';
    private static final string EMAIL_ENCODING_KEY = 'UTF-8';
    private static final string LANGUAGE_LOCAL_KEY = 'en_US';
    private static final string COUNTRY = 'United States';
    private static final string TIME_ZONE = 'America/Los_Angeles';
    public static final string USER_NAME = 'vc12@testorg.com';
    private static final string LAST_NAME = 'test last name';
    private static final String ROLE_NAME='System Admin';
    
    /******************************
    * Method Name: getProfile
    * Description: get the profile record based on profile name
    * Paramenters: profile Name
    * Return Value: profile
    *******************************/
    public static profile getProfile(String profileName)
    {
        Profile p = [Select id from Profile where Name =: profileName limit 1]; 
        return p;
    }
    
    /******************************
    * Method Name: getUserWithProfile
    * Description: get user record based on profile
    * Paramenters: profile 
    * Return Value: User
    *******************************/
    public static User getUserWithProfile(Profile p,String userName){
    	String str = generateRandomString(2);
          User testUser = new User(alias = ALIAS, email= str+EMAIL,
                      emailencodingkey=EMAIL_ENCODING_KEY, lastname= UTIL_Constants.TEST, languagelocalekey=LANGUAGE_LOCAL_KEY,
                      localesidkey=LANGUAGE_LOCAL_KEY, profileid = p.Id, country= COUNTRY,
                      timezonesidkey= TIME_ZONE, username= userName);
                      
           return testUser;
    }
    
    public static String generateRandomString(Integer len) {
	    final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
	    String randStr = '';
	    while (randStr.length() < len) {
	       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
	       randStr += chars.substring(idx, idx+1);
	    }
	    return randStr; 
	}
    /******************************
    * Method Name: getBPOOpportunityRecord
    * Description: get BPO Opportunity record 
    * Paramenters: String name,String stage,String clientMaster,String clientGeoArea,String operatingGroup,String riskLevel,Boolean isActive,String reportingStatus
    * Return Value: Opportunity_TGP__c
    *******************************/
    public static Opportunity_TGP__c getBPOOpportunityRecord(String name,String stage,Id clientMaster,Id clientGeoArea,
                                                                Id operatingGroup,String riskLevel,Boolean isActive,String reportingStatus){
    
        Opportunity_TGP__c oppTGP = new Opportunity_TGP__c(Name = name,Stage__c=stage,Client_Name__c= clientMaster ,Client_Geo_Area__c=clientGeoArea,
                                                            Operating_Group__c=operatingGroup,Risk_Level__c=riskLevel,Activity__c = reportingStatus);
        return oppTGP;
    } 
    
    /******************************
    * Method Name: getOfferingRecord
    * Description: get Opportunity offering record 
    * Paramenters: String name,String oppTGP
    * Return Value: Opportunity_Offering__c
    *******************************/ 
    public static Opportunity_Offering__c getOfferingRecord(String name,String oppTGP){
    
        Opportunity_Offering__c oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = name,Opportunity_TGP__c=oppTGP);
        return oppOffering;
    }
    
    /******************************
    * Method Name: getAssumptionRecord
    * Description: get Assumption record 
    * Paramenters: String name,String oppOffering
    * Return Value: Assumption__c
    *******************************/ 
     public static Assumption__c getAssumptionRecord(String name,String oppOffering){
     
         Assumption__c assumptionRec = new Assumption__c(Name = name,Opportunity_Offering__c= oppOffering);         
         return assumptionRec ;
     }
     /******************************
    * Method Name: getBudgetSolutionRecord
    * Description: get Budget Solution record 
    * Paramenters: String name
    * Return Value: Budget_Solution__c
    *******************************/
     public static Budget_Solution__c getBudgetSolutionRecord(String name){
     
         Budget_Solution__c budSol = new Budget_Solution__c(name = name);
         return budSol ;
     }   
     /******************************
    * Method Name: getWavePlanVersionRecord
    * Description: get Wave Plan Version record 
    * Paramenters: String msg,String deal
    * Return Value: Wave_Plan_Version__c
    *******************************/  
     public static Wave_Plan_Version__c getWavePlanVersionRecord(String msg,String deal){
         
         Wave_Plan_Version__c wavePlanVersion =new Wave_Plan_Version__c(Display_tracking_message__c=msg,Deal__c=deal);
         return wavePlanVersion ;
     }
     /******************************
    * Method Name: getDealRecord
    * Description: get Deal record 
    * Paramenters: String name,String govName
    * Return Value: Deal_TGP__c
    *******************************/
     public static Deal_TGP__c getDealRecord(String name,String govName){
     
         Deal_TGP__c deal =new Deal_TGP__c(Name=name,Governance_Lead_Name__c = govName);
         return deal;
     }
     /******************************
    * Method Name: getCurrentClientCapabilityAssessmentRecord
    * Description: get Current Client Capability Assessment Record 
    * Paramenters: null
    * Return Value: Current_Client_Capability_Assessment__c
    *******************************/
     public static Current_Client_Capability_Assessment__c getCurrentClientCapabilityAssessmentRecord(){
     
         Current_Client_Capability_Assessment__c ccca = new Current_Client_Capability_Assessment__c();
         return ccca;
     }
     
     /******************************
    * Method Name: getDealHomeLocation
    * Description: get Deal Home Location Record 
    * Paramenters: String deliveryLocMa,String deal
    * Return Value: Deal_Home_Location__c
    *******************************/
     public static Deal_Home_Location__c getDealHomeLocation(String deliveryLocMa,String deal){
          
          Deal_Home_Location__c dealHome = new Deal_Home_Location__c(Delivery_Location_Master__c=deliveryLocMa,Deal__c= deal);
          return  dealHome;
      }
      
      /******************************
    * Method Name: getDealLocation
    * Description: get Deal Location Record 
    * Paramenters: String location,String dealHome,String wavePlanVersion
    * Return Value: Deal_Location__c
    *******************************/
      public static Deal_Location__c getDealLocation(String location,String dealHome,String wavePlanVersion){
          Deal_Location__c dealLoc= new Deal_Location__c(Location__c=location,Deal_Home_Location__c=dealHome,Wave_Plan_Version__c=wavePlanVersion);
          return dealLoc;
      }
      
      /******************************
        * Method Name: getWavePlanning
        * Description: get Wave Planning  Record 
        * Paramenters: null
        * Return Value: Wave_Planning__c
        *******************************/
       public static Wave_Planning__c getWavePlanning(String dealLocId,Date d,String label){
          Wave_Planning__c waveplan =new Wave_Planning__c(Deal_Location__c = dealLocId, GO_Live_Date_del__c = d, Wave_Label__c=label);
          return waveplan ;
      }
      
      /******************************
        * Method Name: getWaveProcess
        * Description: get Wave Process  Record 
        * Paramenters: String waveplan
        * Return Value: Wave_Process__c
        *******************************/
      public static Wave_Process__c getWaveProcess(String waveplan){
          Wave_Process__c WaveProcess =new Wave_Process__c(Wave_Planning__c=waveplan);
          return WaveProcess;
      }
      
      /******************************
        * Method Name: getWaveCommercialPlanning
        * Description: get Wave Commercial Planning Record 
        * Paramenters: String name
        * Return Value: Commercial_Planning__c
        *******************************/
      public static Commercial_Planning__c getWaveCommercialPlanning(String name,String activity, Integer actOrder){
          Commercial_Planning__c comPlan = new Commercial_Planning__c(Name = name,Activity__c= activity, Activity_Order__c=actOrder);
          return comPlan;
      }
      
      /******************************
        * Method Name: getWaveCommercialPlanning
        * Description: get Wave Commercial Planning Record 
        * Paramenters: String name
        * Return Value: Client_Specific_Process_Mapping__c
        *******************************/
      public static Client_Specific_Process_Mapping__c getClientSpecificProcessMapping(String name,String deal,String offering){
          Client_Specific_Process_Mapping__c clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c(Name = name,Deal__c = deal,Offering__c = offering);
          return clientSpecificProcessMapping ;
      }
      
      /******************************
        * Method Name: getValuePropositionRecord
        * Description: get value proposition Record 
        * Paramenters: String oppRec
        * Return Value: Value_Proposition__c
        *******************************/
      public static Value_Proposition__c getValuePropositionRecord(String oppRec){
          Value_Proposition__c valueProposition = new Value_Proposition__c(Opportunity_TGP__c = oppRec);
          return valueProposition;
      } 
         
      /******************************
        * Method Name: getTrackingTechAssessment
        * Description: get tracking tech assessment Record 
        * Paramenters: null
        * Return Value: Tracking_Tech_Assessment__c
        *******************************/  
      public static Tracking_Tech_Assessment__c getTrackingTechAssessment(){
          Tracking_Tech_Assessment__c trackingTechAssessment= new Tracking_Tech_Assessment__c();
          return trackingTechAssessment;
      }
      
      /******************************
        * Method Name: getTrackingRecruitment
        * Description: get tracking recruitment Record 
        * Paramenters: null
        * Return Value: Tracking_Recruitment__c
        *******************************/
      public static Tracking_Recruitment__c getTrackingRecruitment(){
          Tracking_Recruitment__c trackingRecruitment= new Tracking_Recruitment__c();
          return trackingRecruitment;
      }
      
      /******************************
        * Method Name: getTrackingKT
        * Description: get tracking KT Record 
        * Paramenters: null
        * Return Value: Tracking_KT__c
        *******************************/
      public static Tracking_KT__c getTrackingKT(){
          Tracking_KT__c trackingKT= new Tracking_KT__c();
          return trackingKT;
      }
      
      /******************************
        * Method Name: getTrackingKT
        * Description: get tracking KT Record 
        * Paramenters: null
        * Return Value: Tracking_KT__c
        *******************************/
      public static Technical_Arch_Task__c getTechnicalArchTask(){
          Technical_Arch_Task__c TechnicalArchTask= new Technical_Arch_Task__c();
          return TechnicalArchTask;
      }
      
      /******************************
        * Method Name: getTechTracker
        * Description: get tech tracker Record 
        * Paramenters: null
        * Return Value: Tech_Tracker__c
        *******************************/
      public static Tech_Tracker__c getTechTracker(){
          Tech_Tracker__c TechTracker= new Tech_Tracker__c();
          return TechTracker;
      }
      
       /******************************
        * Method Name: getTechAssessment
        * Description: get tech Assessment Record 
        * Paramenters: String name,String activity,Date plannedStartDate,Date plannedEndDate,String dealWave,String dealLocation
        * Return Value: Tech_Assessment__c
        *******************************/
      public static Tech_Assessment__c getTechAssessment(String name,String activity,Date plannedStartDate,Date plannedEndDate,String dealWave,String dealLocation){
          Tech_Assessment__c TechAssessment= new Tech_Assessment__c(Name = name , Activity__c = activity,Planned_Start_Date__c = plannedStartDate,Planned_End_Date__c=plannedEndDate,Wave_Plan_lk__c = dealWave,Deal_Location_lk__c = dealLocation);
          return TechAssessment;
      }
      
      /******************************
        * Method Name: getStaffingPlan
        * Description: get staffing Record 
        * Paramenters: null
        * Return Value: Staffing_Plan__c
        *******************************/
      //public static Staffing_Plan__c getStaffingPlan(String solScopeRecId,Integer resources ,String role){
        //  Staffing_Plan__c StaffingPlan = new Staffing_Plan__c(Solution_Scope__c = solScopeRecId,Resources__c = resources,Role__c = role);
        //  return StaffingPlan;
    //  }
      
      /******************************
        * Method Name: getSolUserTask
        * Description: get solution user task Record 
        * Paramenters: null
        * Return Value: Solution_User_Task__c
        *******************************/
      public static Solution_User_Task__c getSolUserTask(){
          Solution_User_Task__c solUserTask = new Solution_User_Task__c();
          return solUserTask;
      }
      
      /******************************
        * Method Name: getSolUserAssignment
        * Description: get solution user Assignment Record 
        * Paramenters: null
        * Return Value: Solution_User_Assignment__c
        *******************************/
      public static Solution_User_Assignment__c getSolUserAssignment(){
          Solution_User_Assignment__c solUserAssignment = new Solution_User_Assignment__c();
          return solUserAssignment;
      }
      
      /******************************
        * Method Name: getSolSpecialistTask
        * Description: get solution Specialist task Record 
        * Paramenters: null
        * Return Value: Solution_Specialist_Task__c
        *******************************/
      public static Solution_Specialist_Task__c getSolSpecialistTask(){
          Solution_Specialist_Task__c solSpecialistTask = new Solution_Specialist_Task__c();
          return solSpecialistTask;
      }
      
     
      
      /******************************
        * Method Name: getSolPlan
        * Description: get solution Plan Record 
        * Paramenters: null
        * Return Value: Solution_Plan__c
        *******************************/
      public static Solution_Plan__c getSolPlan(){
          Solution_Plan__c solPlan = new Solution_Plan__c();
          return solPlan;
      }
      
       /******************************
        * Method Name: getServices
        * Description: get services Record 
        * Paramenters: String name,String serviceMaster,String status,String oppOffering,String serDelLocation
        * Return Value: Services__c
        *******************************/
        public static Services__c getServices(String name,String serviceMaster,String status,String oppOffering,String serDelLocation){
          Services__c services = new Services__c(Name = name,Service_Master__c = serviceMaster,Status__c = status,Opportunity_Offering__c = oppOffering,Service_Delivery_Location__c = serDelLocation);
          return services;
        }
      
      /******************************
        * Method Name: getServiceManagement
        * Description: get services Management Record 
        * Paramenters: String wavePlan,String dealLoc,String name,String activity,Date plannedStartDate,Date plannedEndDate
        * Return Value: Service_Management__c
        *******************************/
      
      public static Service_Management__c getServiceManagement(String wavePlan,String dealLoc,String name,String activity,Date plannedStartDate,Date plannedEndDate){
          Service_Management__c serviceManagement = new Service_Management__c(Wave_Plan_lk__c = wavePlan,Deal_Location_lk__c = dealLoc,Name = name,Activity__c = activity,Planned_Start_Date__c = plannedStartDate,Planned_End_Date__c = plannedEndDate);
          return serviceManagement;
      }
      
      /******************************
        * Method Name: getServiceDeliveryModel
        * Description: get service delivery model Record 
        * Paramenters: String name,String solScope
        * Return Value: Service_Delivery_Model__c
        *******************************/
     // public static Service_Delivery_Model__c getServiceDeliveryModel(String name,String solScope){
     //     Service_Delivery_Model__c serviceDeliveryModel = new Service_Delivery_Model__c(Name = name,Solution_Scope__c = solScope);
     //     return serviceDeliveryModel;
    //  }
      
       /******************************
        * Method Name: getServiceDeliveryLocation
        * Description: get service delivery location Record 
        * Paramenters: String name,String offering
        * Return Value: Service_Delivery_Location__c
        *******************************/
      public static Service_Delivery_Location__c getServiceDeliveryLocation(String name,String offering){
          Service_Delivery_Location__c serviceDeliveryLocation = new Service_Delivery_Location__c(Name = name,Opportunity_Offering__c = offering);
          return serviceDeliveryLocation;
      }
      
      /******************************
        * Method Name: getServiceComponentMaster
        * Description: get service component master Record 
        * Paramenters: null
        * Return Value: Service_Component__c
        *******************************/
      public static Service_Component__c getServiceComponentMaster(){
          Service_Component__c ServiceComponentMaster = new Service_Component__c();
          return ServiceComponentMaster;
      }
      
      /******************************
        * Method Name: getScheduling
        * Description: get scheduling Record 
        * Paramenters: null
        * Return Value: Scheduling__c
        *******************************/
      public static Scheduling__c getScheduling(){
          Scheduling__c Scheduling = new Scheduling__c();
          return Scheduling;
      }
      
      /******************************
        * Method Name: getSRATVersion
        * Description: get SRAT Version Record 
        * Paramenters: null
        * Return Value: SRAT_VERSION__c
        *******************************/
      public static SRAT_VERSION__c getSRATVersion(String name){
          SRAT_VERSION__c SRATVersion = new SRAT_VERSION__c(SRAT_Name__c = name);
          return SRATVersion;
      }
      
      /******************************
        * Method Name: getSRATVersion
        * Description: get SRAT User Sub Section Question Record 
        * Paramenters: null
        * Return Value: SRAT_User_Sub_Section_Question__c
        *******************************/
      public static SRAT_User_Sub_Section_Question__c getSRATUserSubSection(){
          SRAT_User_Sub_Section_Question__c SRATUserSubSection = new SRAT_User_Sub_Section_Question__c();
          return SRATUserSubSection;
      }
      
      /******************************
        * Method Name: getSRATSectionQuestionnaire
        * Description: get SRAT Section Questionnaire Record 
        * Paramenters: String SRATSectionName,String QuestionDes,Integer orderNo
        * Return Value: SRAT_Section_Questionnaire__c
        *******************************/
      public static SRAT_Section_Questionnaire__c getSRATSectionQuestionnaire(String SRATSectionName,String QuestionDes,Integer orderNo){
          SRAT_Section_Questionnaire__c SRATSectionQuestionnaire = new SRAT_Section_Questionnaire__c(SRAT_Section_Name__c = SRATSectionName,
                                                                    Question_Description__c = QuestionDes,Sort_Order__c = orderNo);
          return SRATSectionQuestionnaire;
      }
      
      /******************************
        * Method Name: getSRATSubSectionName
        * Description: get SRAT Sub Section Name Record 
        * Paramenters: null
        * Return Value: SRAT_Sub_Section_Name__c
        *******************************/
      public static SRAT_Sub_Section_Name__c getSRATSubSectionName(){
          SRAT_Sub_Section_Name__c SRATSubSectionName = new SRAT_Sub_Section_Name__c();
          return SRATSubSectionName;
      }
      
      /******************************
        * Method Name: getSRAT
        * Description: get SRAT Record 
        * Paramenters: null
        * Return Value: SRAT__c
        *******************************/
      public static SRAT__c getSRAT(){
          SRAT__c SRAT = new SRAT__c();
          return SRAT;
      }
      
      /******************************
        * Method Name: getSAPOmOpportunity
        * Description: get SAP OM Opportunity Record 
        * Paramenters: String name,String clientName,String stage,String clientGeoArea,String operatingGroup,
                        Integer BPONetRevenue,String oppName,String reportingStatus
        * Return Value: SAP_OM_Opportunity__c
        *******************************/
      public static SAP_OM_Opportunity__c getSAPOmOpportunity(String name,String clientName,String stage,
                                                                String clientGeoArea,String operatingGroup,Integer BPONetRevenue,String oppName,
                                                                String reportingStatus){
          SAP_OM_Opportunity__c SAPOmOpportunity = new SAP_OM_Opportunity__c(Name = name,Client_Name__c = clientName,
                                                                            Stage__c = stage,Client_Geo_Area__c = clientGeoArea,
                                                                            Operating_Group__c = operatingGroup,TCV__c = BPONetRevenue,
                                                                            Opportunity_Name__c = oppName,Activity__c = reportingStatus);
          return SAPOmOpportunity;
      }
      
      /******************************
        * Method Name: getrisk
        * Description: get Risk Record 
        * Paramenters: String name,String oppOffering
        * Return Value: Risk__c
        *******************************/
      public static Risk__c getrisk(String name,String oppOffering){
          Risk__c risk = new Risk__c(Name = name,Opportunity_Offering__c = oppOffering);
          return risk;
      }
      
      /******************************
        * Method Name: getrisk
        * Description: get Risk Record 
        * Paramenters: String name,String oppOffering
        * Return Value: Risk__c
        *******************************/
      public static Review_files_attachment__c getReviewFileAttachment(){
          Review_files_attachment__c reviewFileAttachment = new Review_files_attachment__c();
          return reviewFileAttachment;
      }
      
      /******************************
        * Method Name: getReviewProcess
        * Description: get Review Process Record 
        * Paramenters: null
        * Return Value: Review_Process__c
        *******************************/
      public static Review_Process__c getReviewProcess(){
          Review_Process__c ReviewProcess = new Review_Process__c();
          return ReviewProcess;
      }
      
      /******************************
        * Method Name: getReviewMeetingRequest
        * Description: get Review Meeting Request Record 
        * Paramenters: null
        * Return Value: Review_Meeting_Request__c
        *******************************/
      public static Review_Meeting_Request__c getReviewMeetingRequest(){
          Review_Meeting_Request__c ReviewMeetingRequest = new Review_Meeting_Request__c();
          return ReviewMeetingRequest;
      }
      
      /******************************
        * Method Name: getReviewMOMTitle
        * Description: get Review MOM Title Record 
        * Paramenters: null
        * Return Value: Review_MOM_Titel__c
        *******************************/
      public static Review_MOM_Titel__c getReviewMOMTitle(){
          Review_MOM_Titel__c ReviewMOMTitle = new Review_MOM_Titel__c();
          return ReviewMOMTitle;
      }
      
      /******************************
        * Method Name: getReviewMOM
        * Description: get Review MOM Record 
        * Paramenters: null
        * Return Value: Review_MOM__c
        *******************************/
      public static Review_MOM__c getReviewMOM(){
          Review_MOM__c ReviewMOM = new Review_MOM__c();
          return ReviewMOM;
      }
      
      /******************************
        * Method Name: getReviewActionItemLog
        * Description: get Review Action Item Log Record 
        * Paramenters: String name
        * Return Value: Review_Action_Item_Log__c
        *******************************/
      public static Review_Action_Item_Log__c getReviewActionItemLog(String name){
          Review_Action_Item_Log__c ReviewActionItemLog = new Review_Action_Item_Log__c(Name = name);
          return ReviewActionItemLog;
      }
      
      /******************************
        * Method Name: getRequestReview
        * Description: get Request Review Record 
        * Paramenters: null
        * Return Value: Request_Review__c
        *******************************/
      public static Request_Review__c getRequestReview(){
          Request_Review__c RequestReview = new Request_Review__c();
          return RequestReview;
      }
      
      /******************************
        * Method Name: getRequest
        * Description: get Request Record 
        * Paramenters: null
        * Return Value: Request__c
        *******************************/
      public static Request__c getRequest(){
          Request__c Request = new Request__c();
          return Request;
      }
      
      /******************************
        * Method Name: getRelease
        * Description: get Release Record 
        * Paramenters: null
        * Return Value: Release__c
        *******************************/
      public static Release__c getRelease(){
          Release__c Release = new Release__c();
          return Release;
      }
      
      /******************************
        * Method Name: getRecruitmentTracking
        * Description: get Recruitment Tracking Record 
        * Paramenters: String dealLoc,String wavePlan,String name,String activity,Date plannedStartDate,
                                                        Date plannedEndDate,Integer FTENumber
        * Return Value: Recruitment_Tracking__c
        *******************************/
      public static Recruitment_Tracking__c getRecruitmentTracking(String dealLoc,String wavePlan,String name,String activity,
                                                                    Date plannedStartDate,Date plannedEndDate,Integer FTENumber){
          Recruitment_Tracking__c getRecruitmentTracking = new Recruitment_Tracking__c(Deal_Location_lk__c = dealLoc,Wave_Plan_lk__c = wavePlan,
                                                                        Name = name,Activity__c = activity,Planned_Start_Date__c = plannedStartDate,
                                                                        Planned_End_Date__c = plannedEndDate,FTE_Number__c = FTENumber);
          return getRecruitmentTracking;
      }
      
      /******************************
        * Method Name: getRecruitmentTracker
        * Description: get Recruitment Tracker Record 
        * Paramenters: null
        * Return Value: Recruitment_Tracking__c
        *******************************/
      public static Recruitment_Tracker__c getRecruitmentTracker(){
          Recruitment_Tracker__c RecruitmentTracker = new Recruitment_Tracker__c();
          return RecruitmentTracker;
      }
      
      /******************************
        * Method Name: getRAIDRisk
        * Description: get RAID Risk Record 
        * Paramenters: String deal,String title,String reisedByClientAccenture,String forumRaised,
                                            String raisedByLevel,String riskImpact,String primaryOwner,String assignedTo,String ownedBy,
                                            String raisedByPerson,String workStreamArea,String riskProbability
        * Return Value: RAID_Risk__c
        *******************************/
      public static RAID_Risk__c getRAIDRisk(String deal,String title,String reisedByClientAccenture,String forumRaised,
                                            String raisedByLevel,String riskImpact,String primaryOwner,String assignedTo,String ownedBy,
                                            String raisedByPerson,String workStreamArea,String riskProbability){
          RAID_Risk__c RAIDRisk = new RAID_Risk__c(Deal__c = deal,Title__c = title,Raised_by_Client_Accenture__c = reisedByClientAccenture,
                                                    Forum_Raised__c = forumRaised,Raised_at_level__c = raisedByLevel,Risk_Impact__c = riskImpact,
                                                    Primary_Owner__c = primaryOwner,Assigned_To__c = assignedTo,Owned_by__c = ownedBy,
                                                    Raised_by_person__c = raisedByPerson,Workstream_Area__c = workStreamArea,
                                                    Risk_Probability__c = riskProbability);
          return RAIDRisk;
      }
      
      /******************************
        * Method Name: getRAIDIssue
        * Description: get RAID Issue Record 
        * Paramenters: String deal,String moduleName,String title,String reisedByClientAccenture,String issueSeverity,String forumRaised,
                            String raisedByLevel,String primaryOwner,String assignedTo,String ownedBy,String raisedByPerson,String workStreamArea
        * Return Value: RAID_Issue__c
        *******************************/
      public static RAID_Issue__c getRAIDIssue(String deal,String moduleName,String title,String reisedByClientAccenture,String issueSeverity,
                                                String forumRaised,String raisedByLevel,String primaryOwner,String assignedTo,String ownedBy, 
                                                String raisedByPerson,String workStreamArea){
          RAID_Issue__c RAIDIssue = new RAID_Issue__c(Deal__c = deal,Module_Name__c = moduleName,Issue_Severity__c = issueSeverity,
                                                        Title__c = title,Raised_by_Client_Accenture__c = reisedByClientAccenture,Forum_Raised__c = forumRaised,
                                                        Raised_at_level__c = raisedByLevel,Primary_Owner__c = primaryOwner,Assigned_To__c = assignedTo,
                                                        Owned_by__c = ownedBy,Raised_by_person__c = raisedByPerson,Workstream_Area__c = workStreamArea);
          return RAIDIssue;
      }
      /******************************
        * Method Name: getRAIDIssue
        * Description: get RAID Issue Record 
        * Paramenters: String deal,String moduleName,String title,String reisedByClientAccenture,String issueSeverity,String forumRaised,
                            String raisedByLevel,String primaryOwner,String assignedTo,String ownedBy,String raisedByPerson,String workStreamArea
        * Return Value: RAID_Issue__c
        *******************************/
      public static RAID_Decision__c getRAIDDecision(String deal,String moduleName,String description,
                                                        String forumRaised,String raisedByLevel,String primaryOwner,String assignedTo,
                                                        String ownedBy,String raisedByPerson,String workStreamArea){
          RAID_Decision__c RAIDDecision = new RAID_Decision__c(Deal__c = deal,Description__c = description,
                                                                Module_Name__c = moduleName,Forum_Raised__c = forumRaised,
                                                                Raised_at_level__c = raisedByLevel,Primary_Owner__c = primaryOwner,Assigned_To__c = assignedTo,
                                                                Owned_by__c = ownedBy,Raised_by_person__c = raisedByPerson,Workstream_Area__c = workStreamArea);
          return RAIDDecision;
      }
      /******************************
        * Method Name: getRAIDAction
        * Description: get RAID Action Record 
        * Paramenters: String deal,String moduleName,String description,
                                                    String forumRaised,String raisedByLevel,String primaryOwner,String assignedTo,
                                                    String ownedBy,String raisedByPerson,String workStreamArea
        * Return Value: RAID_Action__c
        *******************************/
      public static RAID_Action__c getRAIDAction(String deal,String moduleName,String description,
                                                    String forumRaised,String raisedByLevel,String primaryOwner,String assignedTo,
                                                    String ownedBy,String raisedByPerson,String workStreamArea){
          RAID_Action__c RAIDAction = new RAID_Action__c(Deal__c = deal,Description__c = description,Module_Name__c = moduleName,
                                                            Forum_Raised__c = forumRaised,Raised_at_level__c = raisedByLevel,Primary_Owner__c = primaryOwner,
                                                            Assigned_To__c = assignedTo,Owned_by__c = ownedBy,Raised_by_person__c = raisedByPerson,
                                                            Workstream_Area__c = workStreamArea);
          return RAIDAction;
      }
      /******************************
        * Method Name: getProcess
        * Description: get Process Record 
        * Paramenters: String offering
        * Return Value: Process__c
        *******************************/
      public static Process__c getProcess(String offering){
          Process__c Process = new Process__c(Offering__c = offering);
          return Process;
      }
      
      /******************************
        * Method Name: getOpportunitySolutionLeadTask
        * Description: get Lead Solution Architect – BPO Task Record 
        * Paramenters: null
        * Return Value: Opportunity_Solution_Lead_Task__c
        *******************************/
      public static Opportunity_Solution_Lead_Task__c getOpportunitySolutionLeadTask(){
          Opportunity_Solution_Lead_Task__c OpportunitySolutionLeadTask = new Opportunity_Solution_Lead_Task__c();
          return OpportunitySolutionLeadTask;
      }
      /******************************
        * Method Name: getOfferingScopeImage
        * Description: get Offering Scope Image Record 
        * Paramenters: String oppOff
        * Return Value: Offering_Scope_Image__c
        *******************************/
      public static Offering_Scope_Image__c getOfferingScopeImage(String oppOff){
          Offering_Scope_Image__c OfferingScopeImage = new Offering_Scope_Image__c(Opportunity_Offering__c = oppOff);
          return OfferingScopeImage;
      }
      /******************************
        * Method Name: getOpexVersion
        * Description: get Opex Version Record 
        * Paramenters: String opexName
        * Return Value: OPEX_Version__c
        *******************************/
      public static OPEX_Version__c getOpexVersion(String opexName){
          OPEX_Version__c OpexVersion = new OPEX_Version__c (OPEX_Name__c = opexName);
          return OpexVersion;
      }
      /******************************
        * Method Name: getOpexUserSectionQuestion
        * Description: get Opex User Section Question Record 
        * Paramenters: null
        * Return Value: OPEX_User_Section_Question__c
        *******************************/
      public static OPEX_User_Section_Question__c getOpexUserSectionQuestion(){
          OPEX_User_Section_Question__c OpexUserSectionQuestion = new OPEX_User_Section_Question__c ();
          return OpexUserSectionQuestion;
      }
       /******************************
        * Method Name: getOpexSectionQuestionnaire
        * Description: get Opex Section Questionnaire Record 
        * Paramenters: null
        * Return Value: OPEX_Section_Questionnaire__c
        *******************************/
      public static OPEX_Section_Questionnaire__c getOpexSectionQuestionnaire(){
          OPEX_Section_Questionnaire__c OpexSectionQuestionnaire = new OPEX_Section_Questionnaire__c ();
          return OpexSectionQuestionnaire;
      }
      /******************************
        * Method Name: getOpexSectionName
        * Description: get Opex Section Name Record 
        * Paramenters: String opexversion
        * Return Value: OPEX_Section_Questionnaire__c
        *******************************/
      public static OPEX_Section_Name__c getOpexSectionName(String opexversion){
          OPEX_Section_Name__c OpexSectionName = new OPEX_Section_Name__c (OPEX_Version__c = opexversion);
          return OpexSectionName;
      }
      /******************************
        * Method Name: getOpexRec
        * Description: get Opex Record 
        * Paramenters: String name,Date plannedDate,String dealLocation,String wavePlan
        * Return Value: OPEX__c
        *******************************/
      public static OPEX__c getOpexRec(String name,Date plannedDate,String dealLocation,String wavePlan){
          OPEX__c OpexRec = new OPEX__c (Name = name,Planned_Date__c = plannedDate,Deal_Location_lk__c = dealLocation,Wave_Plan_lk__c = wavePlan);
          return OpexRec;
      }
      /******************************
        * Method Name: getMobUserRoleAssignment
        * Description: get Opex Record 
        * Paramenters: null
        * Return Value: MOB_User_Role_Assignment__c
        *******************************/ 
      public static MOB_User_Role_Assignment__c getMobUserRoleAssignment(){
          MOB_User_Role_Assignment__c MobUserRoleAssignment = new MOB_User_Role_Assignment__c ();
          return MobUserRoleAssignment;
      }
      /******************************
        * Method Name: getMobArchitectTask
        * Description: get Mob Architect Task Record 
        * Paramenters: null
        * Return Value: Mob_Architect_Task__c
        *******************************/
      public static Mob_Architect_Task__c getMobArchitectTask(){
          Mob_Architect_Task__c mobArchitectTask = new Mob_Architect_Task__c ();
          return mobArchitectTask;
      }
      /******************************
        * Method Name: getMECPostContractVersion
        * Description: get MEC Post Contract Version Record 
        * Paramenters: String verName
        * Return Value: MEC_Post_Contract_Version__c
        *******************************/
      public static MEC_Post_Contract_Version__c getMECPostContractVersion(String verName){
          MEC_Post_Contract_Version__c mobArchitectTask = new MEC_Post_Contract_Version__c (Version_Name__c = verName);
          return mobArchitectTask;
      }
      /******************************
        * Method Name: getMECPostContractEndUserQuestionnaire
        * Description: get MEC Post Contract End User Questionnaire Record 
        * Paramenters: String deal
        * Return Value: MEC_Post_Contract_End_User_Questionnaire__c
        *******************************/
      public static MEC_Post_Contract_End_User_Questionnaire__c getMECPostContractEndUserQuestionnaire(String deal){
          MEC_Post_Contract_End_User_Questionnaire__c MECPostContractEndUserQuestionnaire = new MEC_Post_Contract_End_User_Questionnaire__c (Deal__c = deal);
          return MECPostContractEndUserQuestionnaire;
      }
      /******************************
        * Method Name: getMECPostContractEndUser
        * Description: get MEC Post Contract End User Record 
        * Paramenters: String verNo,String entryCriteria,String deal
        * Return Value: MEC_Post_Contract_End_User__c
        *******************************/
      public static MEC_Post_Contract_End_User__c getMECPostContractEndUser(String verNo,String entryCriteria,String deal){
          MEC_Post_Contract_End_User__c MECPostContractEndUser = new MEC_Post_Contract_End_User__c (Version_Number__c = verNo,Entry_Criteria_for_Project_Execution__c = entryCriteria,Deal__c = deal);
          return MECPostContractEndUser;
      }
      /******************************
        * Method Name: getkeyBuyerValue
        * Description: get key Buyer Value Record 
        * Paramenters: String oppTGP
        * Return Value: Key_Buyer_Value__c
        *******************************/
      public static Key_Buyer_Value__c getkeyBuyerValue(String oppTGP){
          Key_Buyer_Value__c keyBuyerValue = new Key_Buyer_Value__c (Opportunity_TGP__c = oppTGP);
          return keyBuyerValue;
      }
      /******************************
        * Method Name: getKTTracker
        * Description: get KT Tracker Record 
        * Paramenters: null
        * Return Value: KT_Tracker__c
        *******************************/
      public static KT_Tracker__c getKTTracker(){
          KT_Tracker__c KTTracker = new KT_Tracker__c ();
          return KTTracker;
      }
      /******************************
        * Method Name: getKTPlanning
        * Description: get KT Planning Record 
        * Paramenters: String activity,Date plannedStartDate,Date plannedEndDate,String dealWave,String dealLocation
        * Return Value: KT_Planning__c
        *******************************/
      public static KT_Planning__c getKTPlanning(String activity,Date plannedStartDate,Date plannedEndDate,String dealWave,String dealLocation){
          KT_Planning__c KTPlanning = new KT_Planning__c (Activity__c = activity,Planned_Start_Date__c = plannedStartDate,Planned_End_Date__c = plannedEndDate,Wave_Plan_lk__c = dealWave,Deal_Location_lk__c = dealLocation);
          return KTPlanning;
      }
      /******************************
        * Method Name: getJourneyManagement
        * Description: get Journey Management Record 
        * Paramenters: String sectionName,String sectionNumber
        * Return Value: Journey_Management__c
        *******************************/
      public static Journey_Management__c getJourneyManagement(String sectionName,String sectionNumber){
          Journey_Management__c JourneyManagement = new Journey_Management__c(Section_Name__c = sectionName,Section_Number__c = sectionNumber);
          return JourneyManagement;
      }
      /******************************
        * Method Name: getJourneyManagementPlanning
        * Description: get Journey Management Planning Record 
        * Paramenters: null
        * Return Value: Journey_Management_Planning__c
        *******************************/
      public static Journey_Management_Planning__c getJourneyManagementPlanning(){
          Journey_Management_Planning__c JourneyManagementPlanning = new Journey_Management_Planning__c();
          return JourneyManagementPlanning;
      }
      /******************************
        * Method Name: getJourneyManagementDeliverables
        * Description: get Journey Management Deliverables Record 
        * Paramenters: String deliverable,String deliverableNo,String jrnyManagement
        * Return Value: Journey_Management_Planning__c
        *******************************/
      public static Journey_Management_Deliverable__c getJourneyManagementDeliverables(String deliverable,String deliverableNo,String jrnyManagement){
          Journey_Management_Deliverable__c JourneyManagementDeliverables = new Journey_Management_Deliverable__c(Deliverable_Name__c = deliverable,Deliverable_Number__c = deliverableNo,Journey_Management__c = jrnyManagement);
          return JourneyManagementDeliverables;
      }
      /******************************
        * Method Name: getfactorySpecificTech
        * Description: get factory Specific Tech Record 
        * Paramenters: String appName
        * Return Value: Factory_Specific_Technology__c
        *******************************/
      public static Factory_Specific_Technology__c getfactorySpecificTech(String appName){
          Factory_Specific_Technology__c factorySpecificTech = new Factory_Specific_Technology__c(Application_Name__c = appName);
          return factorySpecificTech;
      }
      /******************************
        * Method Name: getExceptionLog
        * Description: get Exception Log Record 
        * Paramenters: String application,String className
        * Return Value: ExceptionLog__c
        *******************************/
      public static ExceptionLog__c getExceptionLog(String application,String className){
          ExceptionLog__c factorySpecificTech = new ExceptionLog__c(Application__c = application,ClassName__c = className);
          return factorySpecificTech;
      }
      /******************************
        * Method Name: getdomainExpertTask
        * Description: get domain Expert Task Record 
        * Paramenters: null
        * Return Value: Domain_Expert_Task__c
        *******************************/
      public static Domain_Expert_Task__c getdomainExpertTask(){
          Domain_Expert_Task__c domainExpertTask = new Domain_Expert_Task__c();
          return domainExpertTask;
      }
      /******************************
        * Method Name: getdomainForRequestReview
        * Description: get domain For Request eview Record 
        * Paramenters: null
        * Return Value: Document_for_Request_Review__c
        *******************************/
      public static Document_for_Request_Review__c getdomainForRequestReview(){
          Document_for_Request_Review__c domainForRequestReview = new Document_for_Request_Review__c();
          return domainForRequestReview;
      }
      /******************************
        * Method Name: getdelLoc
        * Description: get Delivery Location Record 
        * Paramenters: String offName,String serDelLocation
        * Return Value: Delivery_Location__c
        *******************************/
      public static Delivery_Location__c getdelLoc(String offName,String serDelLocation){
          Delivery_Location__c delLoc = new Delivery_Location__c(Offering_Name__c = offName,Service_Delivery_Location__c = serDelLocation);
          return delLoc;
      }
      /******************************
        * Method Name: getDTPTracker
        * Description: get DTP Tracker Record 
        * Paramenters: null
        * Return Value: DTP_Tracker__c
        *******************************/
      public static DTP_Tracker__c getDTPTracker(){
          DTP_Tracker__c DTPTracker = new DTP_Tracker__c();
          return DTPTracker;
      }
      /******************************
        * Method Name: getContractLegalInfosec
        * Description: get Contract Legal Infosec Record 
        * Paramenters: null
        * Return Value: Contract_Legal_Infosec__c
        *******************************/
      public static Contract_Legal_Infosec__c getContractLegalInfosec(){
          Contract_Legal_Infosec__c ContractLegalInfosec = new Contract_Legal_Infosec__c();
          return ContractLegalInfosec;
      }
      /******************************
        * Method Name: getCongaTemplate
        * Description: get Conga Template Record 
        * Paramenters: String templateType
        * Return Value: APXTConga4__Conga_Template__c
        *******************************/
      public static APXTConga4__Conga_Template__c getCongaTemplate(String templateType){
          APXTConga4__Conga_Template__c CongaTemplate = new APXTConga4__Conga_Template__c(APXTConga4__Template_Type__c = templateType);
          return CongaTemplate;
      }
      /******************************
        * Method Name: getCongaEmailTemplate
        * Description: get Conga Email Template Record 
        * Paramenters: null
        * Return Value: APXTConga4__Conga_Email_Template__c
        *******************************/
      public static APXTConga4__Conga_Email_Template__c getCongaEmailTemplate(){
          APXTConga4__Conga_Email_Template__c CongaEmailTemplate = new APXTConga4__Conga_Email_Template__c();
          return CongaEmailTemplate;
      }
      /******************************
        * Method Name: getCongaEmailStaging
        * Description: get Conga Email Staging Record 
        * Paramenters: null
        * Return Value: APXTConga4__Conga_Email_Staging__c
        *******************************/
      public static APXTConga4__Conga_Email_Staging__c getCongaEmailStaging(){
          APXTConga4__Conga_Email_Staging__c CongaEmailStaging = new APXTConga4__Conga_Email_Staging__c();
          return CongaEmailStaging;
      }
     
      /******************************
        * Method Name: getClientDependency
        * Description: get Client Dependency Record 
        * Paramenters: String name,String oppOfferings
        * Return Value: Component_Service__c
        *******************************/
      public static Client_Dependency__c getClientDependency(String name,String oppOfferings){
          Client_Dependency__c ClientDependency = new Client_Dependency__c(Name = name,Opportunity_Offering__c = oppOfferings);
          return ClientDependency;
      }
      /******************************
        * Method Name: getcapabilities
        * Description: get capabilities Record 
        * Paramenters: null
        * Return Value: Capability__c
        *******************************/
      public static Capability__c getcapabilities(){
          Capability__c capabilities = new Capability__c();
          return capabilities;
      }
      /******************************
        * Method Name: getbusinessContinuityPlanning
        * Description: get business Continuity Planning Record 
        * Paramenters: String wavePlanVer
        * Return Value: Business_Continuity_Planning__c
        *******************************/
      public static Business_Continuity_Planning__c getbusinessContinuityPlanning(String wavePlanVer){
          Business_Continuity_Planning__c businessContinuityPlanning = new Business_Continuity_Planning__c(Wave_Plan_Version__c = wavePlanVer);
          return businessContinuityPlanning;
      }
      /******************************
        * Method Name: getbusinessContinuityPlanning
        * Description: get Budget Record 
        * Paramenters: String budgetMasterName
        * Return Value: Business_Continuity_Planning__c
        *******************************/
      public static Budget__c getBudget(String budgetMasterName){
          Budget__c Budget = new Budget__c(Name = budgetMasterName);
          return Budget;
      }
      /******************************
        * Method Name: getapplicationInventory
        * Description: get application Inventory Record 
        * Paramenters: null
        * Return Value: Application_Inventory__c
        *******************************/
      public static Application_Inventory__c getapplicationInventory(){
          Application_Inventory__c applicationInventory = new Application_Inventory__c();
          return applicationInventory;
      }
      /******************************
        * Method Name: getactualLevelEffort
        * Description: get actual Level Effort Record 
        * Paramenters: null
        * Return Value: Actual_Level_of_Effort__c
        *******************************/
      public static Actual_Level_of_Effort__c getactualLevelEffort(){
          Actual_Level_of_Effort__c actualLevelEffort = new Actual_Level_of_Effort__c();
          return actualLevelEffort;
      }
      
      ////////////////////////////Master/////////////////////////
      
      /******************************
        * Method Name: getKTPlanningActivityMaster
        * Description: get KT Planning Activity Master Record 
        * Paramenters: String name
        * Return Value: KT_Planning_Activity_Master__c
        *******************************/
      public static KT_Planning_Activity_Master__c getKTPlanningActivityMaster(String name){
          KT_Planning_Activity_Master__c KTPlanningActivityMaster = new KT_Planning_Activity_Master__c (Name = name);
          return KTPlanningActivityMaster;
      }
      /******************************
        * Method Name: getFacilityMaster
        * Description: get Facility Master Record 
        * Paramenters: String delLocMaster,String name
        * Return Value: KT_Planning_Activity_Master__c
        *******************************/
      public static Facility_Master__c getFacilityMaster(String delLocMaster,String name){
          Facility_Master__c FacilityMaster = new Facility_Master__c (Delivery_Location_Master__c = delLocMaster,Name = name);
          return FacilityMaster;
      }
      /******************************
        * Method Name: getkeyBuyerValueCategoryMaster
        * Description: get key Buyer Value Category Master Record 
        * Paramenters: String name
        * Return Value: Key_Buyer_Value_Category_Master__c
        *******************************/
      public static Key_Buyer_Value_Category_Master__c getkeyBuyerValueCategoryMaster(String name){
          Key_Buyer_Value_Category_Master__c keyBuyerValueCategoryMaster = new Key_Buyer_Value_Category_Master__c (Name = name);
          return keyBuyerValueCategoryMaster;
      }
      /******************************
        * Method Name: getMECPostContractQuestionnaireMaster
        * Description: get MEC Post Contract Questionnaire Master Record 
        * Paramenters: String MECPostContractVer,String categoryName,String criteria
        * Return Value: MEC_Post_Contract_Questionnaire_Master__c
        *******************************/
      public static MEC_Post_Contract_Questionnaire_Master__c getMECPostContractQuestionnaireMaster(String MECPostContractVer,String categoryName,String criteria){
          MEC_Post_Contract_Questionnaire_Master__c MECPostContractQuestionnaireMaster = new MEC_Post_Contract_Questionnaire_Master__c (MEC_Post_Contract_Version__c = MECPostContractVer,Category_Name__c = categoryName,Criteria__c = criteria);
          return MECPostContractQuestionnaireMaster;
      }
      /******************************
        * Method Name: getMobUserRoleMaster
        * Description: To get Mob User Role Master Record 
        * Paramenters: String roleName
        * Return Value: Mob_User_Roles_Master__c
        *******************************/
      public static Mob_User_Roles_Master__c getMobUserRoleMaster(String roleName){
          Mob_User_Roles_Master__c mobUserRoleMaster = new Mob_User_Roles_Master__c (Role_Name__c = roleName);
          return mobUserRoleMaster;
      }
      /******************************
        * Method Name: getOutBoundEmailUserMaster
        * Description: To get OutBound Email User Master Record 
        * Paramenters: String userName,String emailId
        * Return Value: Outbound_Email_User_Master__c
        *******************************/
      public static Outbound_Email_User_Master__c getOutBoundEmailUserMaster(String userName,String emailId){
          Outbound_Email_User_Master__c primaryOwnerMaster = new Outbound_Email_User_Master__c(Outbound_Email_User_Name__c = userName,Email_ID__c = emailId);
          return primaryOwnerMaster;
      }
      /******************************
        * Method Name: getprimaryOwnerMaster
        * Description: get primary Owner Master Record 
        * Paramenters: null
        * Return Value: Outbound_Email_User_Master__c
        *******************************/
      public static Primary_Owner_Master__c getprimaryOwnerMaster(){
          Primary_Owner_Master__c primaryOwnerMaster = new Primary_Owner_Master__c();
          return primaryOwnerMaster;
      }
      /******************************
        * Method Name: getReviewTypeMaster
        * Description: To get Review Type Master Record 
        * Paramenters: String name
        * Return Value: Review_Type_Master__c
        *******************************/
      public static Review_Type_Master__c getReviewTypeMaster(String name){
          Review_Type_Master__c reviewTypeMaster = new Review_Type_Master__c(Name = name);
          return reviewTypeMaster;
      }
      /******************************
        * Method Name: getReviewStageMaster
        * Description: To get Review Stage Master Record 
        * Paramenters: String name
        * Return Value: Review_Stage_Master__c
        *******************************/
      public static Review_Stage_Master__c getReviewStageMaster(String name){
          Review_Stage_Master__c ReviewStageMaster = new Review_Stage_Master__c(Name = name);
          return ReviewStageMaster;
      }
      /******************************
        * Method Name: getClientMaster
        * Description: To get Client Master Record 
        * Paramenters: String name
        * Return Value: Client_Master__c
        *******************************/
       public static Client_Master__c getClientMaster(String name){
    
        Client_Master__c clientName = new Client_Master__c (Name = name);
        
        return clientName;
        
     }
     /******************************
        * Method Name: getOpexItemMaster
        * Description: To get Opex Item Master Record 
        * Paramenters: Integer daysAfterGoLiveDate,String itemName
        * Return Value: OPEX_Item_master__c
        *******************************/
      public static OPEX_Item_master__c getOpexItemMaster(Integer daysAfterGoLiveDate,String itemName){
          OPEX_Item_master__c OpexItemMaster = new OPEX_Item_master__c (Days_After_Go_Live_Date__c = daysAfterGoLiveDate,Item_Name__c = itemName);
          return OpexItemMaster;
      }
      /******************************
        * Method Name: getClientGEOAreaMaster
        * Description: To get Client GEO Area Master Record 
        * Paramenters: String name
        * Return Value: Client_Geo_Area_Master__c
        *******************************/
     public static Client_Geo_Area_Master__c getClientGEOAreaMaster(String name){
    
        Client_Geo_Area_Master__c clientGeoArea = new Client_Geo_Area_Master__c (Name = name);
        return clientGeoArea;
        
     }
     /******************************
        * Method Name: getOperatingGroupMaster
        * Description: To get Operating Group Master Record 
        * Paramenters: String name,Boolean isActive
        * Return Value: Operating_Group_Master__c
        *******************************/
     public static Operating_Group_Master__c getOperatingGroupMaster(String name,Boolean isActive){
    
        Operating_Group_Master__c  operatingGroup = new Operating_Group_Master__c (Name = name,Active__c = isActive);
        return operatingGroup;
     }
     /******************************
        * Method Name: getClientGeoUnitMaster
        * Description: To get Client Geo Unit Master Record 
        * Paramenters: String name
        * Return Value: Client_Geo_Unit_Master__c
        *******************************/
     public static Client_Geo_Unit_Master__c getClientGeoUnitMaster(String name){
        Client_Geo_Unit_Master__c clientGeoUnit = new Client_Geo_Unit_Master__c (Name = name);
        return clientGeoUnit;
     }
     /******************************
        * Method Name: getDelieveryLocationMaster
        * Description: To get Delievery Location Master Record 
        * Paramenters: String name,String clientGeo
        * Return Value: Delievery_Location_Master__c
        *******************************/
     public static Delievery_Location_Master__c getDelieveryLocationMaster(String name,String clientGeo){
          Delievery_Location_Master__c deliveryLocMa =new Delievery_Location_Master__c(Name=name,
                                                            Client_Geo_Area_Master__c=clientGeo);
          return deliveryLocMa ;
      }  
      /******************************
        * Method Name: getcontractLegalInfosecTaskMaster
        * Description: To get contract Legal Infosec Task Master Record 
        * Paramenters: String contractLegalInfosecSecMaster,String taskName,String taskNo
        * Return Value: Contract_Legal_Infosec_Task_Master__c
        *******************************/
      public static Contract_Legal_Infosec_Task_Master__c getcontractLegalInfosecTaskMaster(String contractLegalInfosecSecMaster,
                                                                                            String taskName,String taskNo){
          Contract_Legal_Infosec_Task_Master__c contractLegalInfosecTaskMaster =new Contract_Legal_Infosec_Task_Master__c(Contract_Legal_Infosec_Section_Master__c=contractLegalInfosecSecMaster,
                                                            Task_Name__c=taskName,Task_Number__c = taskNo);
          return contractLegalInfosecTaskMaster ;
      }
      /******************************
        * Method Name: getcontractLegalInfosecTaskMaster
        * Description: To get contract Legal Infosec Task Master Record 
        * Paramenters: String contractLegalInfosecSecMaster,String taskName,String taskNo
        * Return Value: Contract_Legal_Infosec_Task_Master__c
        *******************************/
       public static Contract_Legal_Infosec_Section_Master__c getLegalInfosecSectionMaster(String name,String secNumber){
             
             Contract_Legal_Infosec_Section_Master__c joumg = new Contract_Legal_Infosec_Section_Master__c(Section_Name__c=name,Section_Number__c = secNumber);
             return joumg;
       }
       /******************************
        * Method Name: getcommPlanActivityMaster
        * Description: To get comm Plan Activity Master Record 
        * Paramenters: String activityName
        * Return Value: Commercial_Plan_Activity_Master__c
        *******************************/
       public static Commercial_Plan_Activity_Master__c getcommPlanActivityMaster(String activityName, Integer actNum){
            Commercial_Plan_Activity_Master__c commPlanActivityMaster = new Commercial_Plan_Activity_Master__c (Activity_Name__c = activityName, Activity_Order__c=1294);
            return commPlanActivityMaster;
        }
        /******************************
        * Method Name: getclientDependencyMaster
        * Description: To get client Dependency Master Record 
        * Paramenters: String cat,String clientDependency
        * Return Value: Client_Dependency_Master__c
        *******************************/
        public static Client_Dependency_Master__c getclientDependencyMaster(String cat,String clientDependency){
            Client_Dependency_Master__c clientDependencyMaster = new Client_Dependency_Master__c (Category__c = cat,Client_Dependency__c = clientDependency);
            return clientDependencyMaster;
        }
        /******************************
        * Method Name: getcategoryMaster
        * Description: To get category Master Record 
        * Paramenters: String name
        * Return Value: Category__c
        *******************************/
        public static Category__c getcategoryMaster(String name){
        
            Category__c categoryMaster = new Category__c (Name = name);
            return categoryMaster;
        }
        /******************************
        * Method Name: getBCPTaskMaster
        * Description: To get BCP Task Master Record 
        * Paramenters: String BCPContinuityPlanning,Integer taskNo,String taskName
        * Return Value: BCP_Task_Master__c
        *******************************/
        public static BCP_Task_Master__c getBCPTaskMaster(String BCPContinuityPlanning,Integer taskNo,String taskName){
        
            BCP_Task_Master__c BCPTaskMaster = new BCP_Task_Master__c(Business_Continuity_Planning_del__c = BCPContinuityPlanning,Task_Number__c = taskNo,Task_Name__c = taskName);
            return BCPTaskMaster;
        }
        /******************************
        * Method Name: getBCPSectionMaster
        * Description: To get BCP Section Master Record 
        * Paramenters: String sectionName,Integer taskNo,String sectionNo
        * Return Value: BCP_Section_Master__c
        *******************************/
        public static BCP_Section_Master__c getBCPSectionMaster(String sectionName,Integer taskNo,String sectionNo){
        
            BCP_Section_Master__c BCPSectionMaster = new BCP_Section_Master__c(Section_Name__c = sectionName,Section_Number__c = sectionNo);
            return BCPSectionMaster;
        }
        /******************************
        * Method Name: getReviewUserMaster
        * Description: To get Review User Master Record 
        * Paramenters: String emailId,String name
        * Return Value: Review_User_Master__c
        *******************************/
        public static Review_User_Master__c getReviewUserMaster(String emailId,String name){
        
            Review_User_Master__c ReviewUserMaster = new Review_User_Master__c(Email_ID_of_the_reviewer__c = emailId,Name = name);
            return ReviewUserMaster;
        }
        /******************************
        * Method Name: getApproverMaster
        * Description: To get Approver Master Record 
        * Paramenters: String TCVRange,String region,String name,String approverMailID
        * Return Value: Approver_Master__c
        *******************************/
        public static Approver_Master__c getApproverMaster(String TCVRange,String region,String name,String approverMailID){
        
            Approver_Master__c ApproverMaster = new Approver_Master__c(TCV_Range__c = TCVRange,Region__c = region,Name = name,Approver_Mail_ID__c = approverMailID);
            return ApproverMaster;
        }
        /******************************
        * Method Name: getanalyticsSubOfferingMaster
        * Description: To get analytics Sub Offering Master Record 
        * Paramenters: String offMaster
        * Return Value: Analytics_Sub_Offering_Master__c
        *******************************/
        public static Analytics_Sub_Offering_Master__c getanalyticsSubOfferingMaster(String offMaster){
        
            Analytics_Sub_Offering_Master__c analyticsSubOfferingMaster = new Analytics_Sub_Offering_Master__c(Offering__c = offMaster);
            return analyticsSubOfferingMaster;
        }
        /******************************
        * Method Name: getOfferingMaster
        * Description: To get Offering Master Record 
        * Paramenters: String name
        * Return Value: Offerings_Master__c
        *******************************/
        public static Offerings_Master__c getOfferingMaster(String name){
        
            Offerings_Master__c offeringMaster = new Offerings_Master__c (Name = name);
            return offeringMaster;
        }
        /******************************
        * Method Name: getServiceMasterRecord
        * Description: To get Service Master Record 
        * Paramenters: String name,Offerings_Master__c offeringMaster,Boolean isActive
        * Return Value: Service_Master__c
        *******************************/
        public static Service_Master__c getServiceMasterRecord(String name,Offerings_Master__c offeringMaster,Boolean isActive){
            Service_Master__c serviceMaster = new Service_Master__c(Name = name,Offering__c = offeringMaster.id,Active__c = isActive);
            return serviceMaster ;
        }
        /******************************
        * Method Name: getAssumptionMaster
        * Description: To get Assumption Master Record 
        * Paramenters: String categories,String assumption
        * Return Value: Assumption_Master__c
        *******************************/
         public static Assumption_Master__c getAssumptionMaster(String categories,String assumption){
             Assumption_Master__c assumptionMaster = new Assumption_Master__c(Category__c = categories,Assumption__c = assumption);
             return assumptionMaster;
         }
         /******************************
        * Method Name: getFacilityMaster
        * Description: To get Facility Master Record 
        * Paramenters: String name,String delivaryLoc,String offering
        * Return Value: Facility_Master__c
        *******************************/
         public static Facility_Master__c getFacilityMaster(String name,String delivaryLoc,String offering){
              Facility_Master__c FacMaster = new Facility_Master__c(Name = name,Delivery_Location_Master__c= delivaryLoc);
              return FacMaster;
          }
          /******************************
        * Method Name: getThirdPartyVendorMaster
        * Description: To get Third Party Vendor Master Record 
        * Paramenters: String name
        * Return Value: Third_Party_Vendor_Master_Custom__c
        *******************************/
          public static Third_Party_Vendor_Master_Custom__c getThirdPartyVendorMaster(String name){
              Third_Party_Vendor_Master_Custom__c thirdPartyVendorMaster= new Third_Party_Vendor_Master_Custom__c(Third_Party_Vendor_Name__c = name);
              return thirdPartyVendorMaster;
          }
          /******************************
        * Method Name: getTechAssessmentActivityMaster
        * Description: To get Tech Assessment Activity Master Record 
        * Paramenters: null
        * Return Value: Tech_Assessment_Activity_Master__c
        *******************************/
          public static Tech_Assessment_Activity_Master__c getTechAssessmentActivityMaster(Integer actOrder){
              Tech_Assessment_Activity_Master__c TechAssessmentActivityMaster= new Tech_Assessment_Activity_Master__c(Activity_Order__c=actOrder);
              return TechAssessmentActivityMaster;
          }
          /******************************
        * Method Name: getSolDocumentMaster
        * Description: To get Solution Document Master Record 
        * Paramenters: String name
        * Return Value: Solution_Document_Master__c
        *******************************/
          public static Solution_Document_Master__c getSolDocumentMaster(String name){
              Solution_Document_Master__c solDocMaster = new Solution_Document_Master__c(Name = name);
              return solDocMaster;
          }
          /******************************
        * Method Name: getServiceMaster
        * Description: To get Service Master Record 
        * Paramenters: null
        * Return Value: Service_Master__c
        *******************************/
          public static Service_Master__c getServiceMaster(String offId ){
              Service_Master__c ServiceMaster = new Service_Master__c(Offering__c = offId);
              return ServiceMaster;
          }
          /******************************
        * Method Name: getServiceManagementTaskMaster
        * Description: To get Service Management Task Master Record 
        * Paramenters: String serManPhase,String name,Integer taskNumber
        * Return Value: Service_Management_Task_Master__c
        *******************************/
          public static Service_Management_Task_Master__c getServiceManagementTaskMaster(String serManPhase,String name,Integer taskNumber){
              Service_Management_Task_Master__c ServiceManagementTaskMaster = new Service_Management_Task_Master__c(Service_Management_Phase__c = serManPhase,Task_Name__c = name,Task_Number__c = taskNumber);
              return ServiceManagementTaskMaster;
          }
          /******************************
        * Method Name: getServiceManagementMaster
        * Description: To get Service Management Master Record 
        * Paramenters: String name,Integer phaseNumber
        * Return Value: Service_Management_Master__c
        *******************************/
          public static Service_Management_Master__c getServiceManagementMaster(String name,Integer phaseNumber){
              Service_Management_Master__c serviceManagementMaster = new Service_Management_Master__c(Phase_Name__c = name,Phase_Number__c = phaseNumber);
              return serviceManagementMaster;
          }
          /******************************
        * Method Name: getSRATItemMaster
        * Description: To get SRAT Item Master Record 
        * Paramenters: null
        * Return Value: SRAT_Item_Master__c
        *******************************/
          public static SRAT_Item_Master__c getSRATItemMaster(){
              SRAT_Item_Master__c SRATItemMaster = new SRAT_Item_Master__c();
              return SRATItemMaster;
          }
          /******************************
        * Method Name: getriskMaster
        * Description: To get risk Master Record 
        * Paramenters: null
        * Return Value: Risk_Master__c
        *******************************/
          public static Risk_Master__c getriskMaster(){
              Risk_Master__c riskMaster = new Risk_Master__c();
              return riskMaster;
          }
          /******************************
        * Method Name: getActivityMaster
        * Description: To get Activity Master Record 
        * Paramenters: null
        * Return Value: Activity_Master__c
        *******************************/
          public static Activity_Master__c getActivityMaster(Integer actOrd){
              Activity_Master__c ActivityMaster = new Activity_Master__c(Activity_Order__c=actOrd);
              return ActivityMaster;
          }
          
          /******************************
        * Method Name: getActivityMaster
        * Description: To get Activity Master Record 
        * Paramenters: null
        * Return Value: Activity_Master__c
        *******************************/
          public static Delievery_Location_Master__c getdelLocMaster(String clientGEOAreaMasterId,String recName){
              Delievery_Location_Master__c delLocMaster = new Delievery_Location_Master__c(Client_Geo_Area_Master__c = clientGEOAreaMasterId,Name = recName);
              return delLocMaster;
          }
          
          /******************************
        * Method Name: getActivityMaster
        * Description: To get Activity Master Record 
        * Paramenters: null
        * Return Value: Activity_Master__c
        *******************************/
          public static SRAT_Section_Name__c getSRATSectionName(){
              SRAT_Section_Name__c SRATSectionName = new SRAT_Section_Name__c();
              return SRATSectionName;
          }
          /******************************
        * Method Name: getDealTrackRecord
        * Description: To get Deal Track  Record 
        * Paramenters: null
        * Return Value: Activity_Master__c
        *******************************/
        public static Deal_Track__c getDealTrackRecord(Id wpvId, Id DealId, String recName) {
            Deal_Track__c dealTrack = new Deal_Track__c(Name = recName, Wave_Plan_Version__c = wpvId, Deal__c = dealId);
            return dealTrack;
        } 
        ////////////////Codes Till Production//////////////////////
        ////////////////Codes For R2//////////////////////  
        
    
    
    
    
    /******************************
    * Method Name: getUserWithProfile
    * Description: get user record based on profile
    * Paramenters: profile 
    * Return Value: User
    *******************************/
    public static User getUserWithProfile(Profile p,String userName,String emailId){
    try{
        User testUser = new User(alias = ALIAS, email= emailId,
                  emailencodingkey=EMAIL_ENCODING_KEY, lastname= LAST_NAME, languagelocalekey=LANGUAGE_LOCAL_KEY,
                  localesidkey=LANGUAGE_LOCAL_KEY, profileid = p.Id, country= COUNTRY,
                  timezonesidkey= TIME_ZONE, username= userName,IsActive=true);
                      
       return testUser;
       }
       Catch(Exception e)
       {
       
       system.debug('E==='+e);
       }
       return null;
    }
    
      /******************************
    * Method Name: getRole
    * Description: get the role record based on role name
    * Paramenters: role Name
    * Return Value: role
    *******************************/
    public static UserRole getRole(){
        UserRole testUserRole=[select id,Name from UserRole where name=:ROLE_NAME];
        return testUserRole;
    }
    
     /******************************
    * Method Name: getOperatingGroupMasterRec
    * Description: get Operating Group Master record
    * Paramenters: Name,Active
    * Return Value: Operating_Groups_Master__c
    *****************************/
    public static Operating_Groups_Master__c getOperatingGroupMasterRec(String testName,Boolean isActive){
    try{
          Operating_Groups_Master__c testOpGrpMstr = new Operating_Groups_Master__c(Name = testName,Active__c = isActive);
          return testOpGrpMstr;
       }
       Catch(Exception e)
       {
       system.debug('E==='+e);
       }   
       return null;
    }
    
    /******************************
    * Method Name: getAccountRec
    * Description: get Account record
    * Paramenters: Name
    * Return Value: Account
    ***************************/
    public static Account getAccountRec(String testName){
    try{
          Account acc = new Account(Name= testName);
          return acc;
       }
       Catch(Exception e)
       {
         system.debug('E==='+e);
       }
       return null;   
    }
    
    /******************************
    * Method Name: getSAPOMStagingRec
    * Description: get SAP_OM_Staging record
    * Paramenters: oppId,group master name,master client name,opportunity name,stage
    * Return Value: SAP_OM_Staging__c
    ******************************/
    public static SAP_OM_Staging__c getSAPOMStagingRec(Integer oppId,String testGroupMaster,String masterClientName,String opportunityName,String stage){
    try{
          SAP_OM_Staging__c testStagingRec = new SAP_OM_Staging__c (opportunity_ID__c=oppId+'',OG__c=testGroupMaster,master_client_name__c=masterClientName,opportunity_name__c=opportunityName,Stage__c=stage);
          return testStagingRec;
       }
       Catch(Exception e)
       {
       system.debug('E==='+e);
       }  
       return null;
    }
    
    /******************************
    * Method Name: getSAPOMStagingRec
    * Description: get SAP_OM_Staging record
    * Paramenters: oppId,group master name,master client name,opportunity name,stage
    * Return Value: SAP_OM_Staging__c
    ******************************/
    public static SAP_OM_Staging__c getSAPOMStagingRec(Integer oppId,String testGroupMaster,String masterClientName,String opportunityName,String stage,Decimal netRev){
    try{
          SAP_OM_Staging__c testStagingRec = new SAP_OM_Staging__c (opportunity_ID__c=oppId+'',OG__c=testGroupMaster,master_client_name__c=masterClientName,opportunity_name__c=opportunityName,Stage__c=stage,BPONR__c=netRev);
          return testStagingRec;
       }
       Catch(Exception e)
       {
       system.debug('E==='+e);
       }  
       return null;
    }
    
    /******************************
    * Method Name: getSystemUserCSRec
    * Description: get System_User_Id__c Custom Setting record
    * Paramenters: Name,User Id
    * Return Value: System_User_Id__c
    *****************************/
    public static System_User_Id__c getSystemUserCSRec(String Name,String userId){
    try{
    
          System_User_Id__c testSystemUserCSRec = new System_User_Id__c(Name=Name,User_Id__c = userId);
          return testSystemUserCSRec;
        }
        Catch(Exception e)
        {
        system.debug('E==='+e);
        }  
        return null;
    }
    
     /******************************
    * Method Name: getSystemUserCSRec
    * Description: get System_User_Id__c Custom Setting record
    * Paramenters: Name,User Id
    * Return Value: System_User_Id__c
    *****************************/
    public static Staging_CustomSetting__c getStagingCSRec(String Name,String masterRecordName,String serviceGroup,string masterObject){
    try{
    
          Staging_CustomSetting__c getStagingCSRec = new Staging_CustomSetting__c(Name=Name,Master_Record_Name__c= masterRecordName,Service_Group__c=serviceGroup,Related_Master_Object__c=masterObject);
          return getStagingCSRec;
       }
       Catch(Exception e)
       {
       system.debug('E==='+e);
       }   
       return null;
    }


    public static Opportunity getOpportunity(Operating_Groups_Master__c OppGrpMaster){
    try{
    Opportunity opp=new Opportunity();
    opp.OperatingGroup__c=OppGrpMaster.id;
    opp.name=UtilConstants.TEST_OPP;
    opp.Geo_Area__c=UTIL_Constants.AsiaPacific;
    opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
    opp.StageName=UtilConstants.OA;
    opp.Risk_Level__c=UtilConstants.LOW;
    //Date dd=new Date();
    opp.CloseDate= date.newInstance(2001, 3, 21);
    return opp;
    }
    Catch(Exception e)
    {
    system.debug('E==='+e);
    }
    return null;
    
    }
    
    public static Opportunity getOpportunityForBenchmark(Operating_Groups_Master__c OppGrpMaster){
    try{
    Opportunity opp=new Opportunity();
    opp.OperatingGroup__c=OppGrpMaster.id;
    opp.name=UtilConstants.TEST_OPP;
    opp.Geo_Area__c=UTIL_Constants.AsiaPacific;
    opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
    opp.StageName=UtilConstants.OA;
    opp.Risk_Level__c=UtilConstants.LOW;
    //Date dd=new Date();
    opp.CloseDate= date.newInstance(2020, 3, 21);
    return opp;
    }
    Catch(Exception e)
    {
    system.debug('E==='+e);
    }
    return null;
    
    }


    public static Opportunity_Roles_Master__c getOpportunityRoleMaster(){
    try{
    Opportunity_Roles_Master__c oppRoleMaster=new Opportunity_Roles_Master__c();
    oppRoleMaster.name=UtilConstants.ABCD;
    //oppRoleMaster.description__c='This is a mock data';
    return oppRoleMaster;
    }
    Catch(Exception e)
    {
    system.debug('E==='+e);
    }
    return null;
 }
     
      
  public static Offering_Master__c getOffering(){
  try{
    Offering_Master__c off=new Offering_Master__c();
    off.name=UtilConstants.TEST_OFFER;
    off.offering_description__c=UtilConstants.NEW_VAR;
    off.flywheel_non_flywheel__c=UtilConstants.ER;
    return off;
    }
    Catch(Exception e)
    {
    system.debug('E==='+e);
    }
    return null;
    }
  
    public static Offering_Master__c getOfferingwithALL(){
        try{
            Offering_Master__c off=new Offering_Master__c();
            off.name=UtilConstants.ALL;
            off.offering_description__c=UtilConstants.ALL;
            off.flywheel_non_flywheel__c=UtilConstants.ER;
            off.active__c=true;
            return off;
        }Catch(Exception e){
             system.debug('E==='+e);
        }
        return null;
    }  
    
  public static Offering_Master__c getOfferingwithProcurement(){
  try{
    Offering_Master__c off=new Offering_Master__c();
    off.name=UtilConstants.PROC_VAR;
    off.offering_description__c=UtilConstants.PROC_DESC;
    off.flywheel_non_flywheel__c=UtilConstants.FLYWHEEL;
    off.active__c=true;
    return off;
    }
    Catch(Exception e)
    {
     system.debug('E==='+e);
    }
    return null;
    
    }
    
    public static Offering_Name__c getOfferingNamewithProcurement(Offering_Master__c offMaster){
        try{
            Offering_Name__c offCustomObj = new Offering_Name__c();
            offCustomObj.Name = UtilConstants.SOURCE_AND_PROCURE;
            offCustomObj.Name__c = offMaster.id;
            return offCustomObj;
        }Catch(Exception e){
            system.debug('E==='+e);
        }
        return null;
    
    }
    
    public static Offering_Master__c getOfferingwithSourceProcurement(){
    try{
        Offering_Master__c off=new Offering_Master__c();
        off.name=UtilConstants.PROCUREMENT ;
        off.offering_description__c='S_AND_P';
        off.flywheel_non_flywheel__c=UtilConstants.FLYWHEEL;
        off.active__c=true;
        off.Service_Group__c='BPO';
        return off;
      }
        Catch(Exception e)
        {
         system.debug('E==='+e);
        }
        return null;
    
    }



    public static Solution_Scope__c getSolutionComp(Opportunity opp,Offering_Master__c off){
    try{
         Solution_Scope__c newSolComp= new Solution_Scope__c();
         newSolComp.opportunity__c=opp.id;
         newSolComp.Solution_Component__c=UtilConstants.SDO;
         newSolComp.Offering_Master__c=off.id;
         newSolComp.Active__c=true;
         newSolComp.SAP_Offering_Revenue__c=20;
         return newSolComp;
        }
        Catch(Exception e)
        {
        system.debug('E==='+e);
        }
        return null;
    }


    public static Offering_Name__c getofferingCustom(String Name, String NameID){
    try{
          Offering_Name__c getOfferingCustom = new Offering_Name__c(Name=Name,Name__c= NameID);
          return getOfferingCustom;
       }
       Catch(Exception e)
       {
       system.debug('E==='+e);
       }   
       return null;
    }
    
    public static Services_Master__c getServiceMasterWithoutALL(Offering_Master__c offMaster){
     try{
     Services_Master__c ser=new Services_Master__c();
     ser.offering__c=offMaster.id;
     ser.active__c=true;
     ser.name='Test';
     ser.Solution_Component__c='SDO';
     return ser;    
     }
     Catch(Exception e)
     {
     system.debug('E==='+e);
     }
     return null;
     }
    
     public static Services_Master__c getServiceMaster(Offering_Master__c offMaster){
     try{
     Services_Master__c ser=new Services_Master__c();
     ser.offering__c=offMaster.id;
     ser.active__c=true;
     ser.name='ALL';
     return ser;    
     }
     Catch(Exception e)
     {
     system.debug('E==='+e);
     }
     return null;
     }
     
     
     public static Services_Master__c getBSSServiceMaster(Offering_Master__c offMaster){
     try{
     Services_Master__c ser=new Services_Master__c();
     ser.offering__c=offMaster.id;
     ser.Solution_Component__c=UtilConstants.BSS;
     ser.active__c=true;
     ser.name=UtilConstants.BSS;
     return ser;    
     }
     Catch(Exception e)
     {
     system.debug('E==='+e);
     }
     return null;
     }
     
     
     public static Assumptions_Master__c getAssumptionMaster(Offering_Master__c offMaster,Services_Master__c serMaster){
     try{
     Assumptions_Master__c assumption=new Assumptions_Master__c();
     assumption.offering__c=offMaster.id;
     assumption.Service__c=serMaster.id;
     assumption.active__c=true;
     assumption.assumption__c=UtilConstants.TEST_ASSUMP_DESC;
     assumption.category__c=UtilConstants.CATEGORY;
     assumption.classification__c=UtilConstants.EXTERNAL;
     assumption.name=UtilConstants.TEST_ASSUMP;   
     return assumption;    
     }
     Catch(Exception e)
     {
     system.debug('E==='+e);
     }
     return null;
     }
    public static Client_Dependencies_Master__c getClientMaster(Offering_Master__c offMaster,Services_Master__c serMaster){
     try{
     Client_Dependencies_Master__c client=new Client_Dependencies_Master__c ();
     client.offering__c=offMaster.id;
     client.Services_per_Offering__c = serMaster.id;
     client.active__c=true;
     client.client_depedency__c=UtilConstants.TEST_CLIENT_DESC;
     client.category__c=UtilConstants.CATEGORY;
     client.name=UtilConstants.TEST_RISK;
     client.classification__c=UtilConstants.EXTERNAL;    
     return client;    
     }
     Catch(Exception e)
     {
     system.debug('E==='+e);
     }
     return null;
     }


    public static Risks_Master__c getRiskMaster(Offering_Master__c offMaster,Services_Master__c serMaster){
    try{
     
     Risks_Master__c risk=new Risks_Master__c();
     risk.offering__c=offMaster.id;
     risk.Service__c=serMaster.id;
     risk.active__c=true;
     risk.risk_depedency__c=UtilConstants.RISK_DEPENDENCY;
     risk.category__c=UtilConstants.CATEGORY;
     risk.name= UtilConstants.TEST_RISK;
     risk.classification__c=UtilConstants.EXTERNAL;    
     return risk;    
     }
     Catch(Exception e)
     {
     system.debug('E==='+e);
     }
     return null;
    }
    /**
     *
     * MethodName: createTestUser
     *
     * Purpose: Creating test user for each test case.
     *
     *
     */
     public User createTestUser(String Lname,String Uname,String email_var)
      {
      
          Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'System Administrator' 
                           LIMIT 1];

           User testUser = new User(LastName = Lname, 
                             Username = Uname, 
                             Email = email_var, 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
                             
           return testUser;   
      }
     /**
     *
     * MethodName: createUtilization()
     *
     * Purpose: Creating utilization object with required data for each test case.
     *
     *
     */ 
     public static Utilizations__c createUtilization(String Name,Decimal curr_Week,
                                              Decimal curr_Week1,Decimal curr_Week2,
                                              Decimal curr_Week3,Decimal curr_Week4)
     {
            
            User_Master__c user_obj = new User_Master__c(Name = Name);
            Database.insert(user_obj);
            Utilizations__c ut = new Utilizations__c(User__c = user_obj.id,Name = Name,Current_Week__c = curr_Week,
                                                 Current_Week_1__c = curr_Week1,
                                                 Current_Week_2__c = curr_Week2,
                                                 Current_Week_3__c = curr_Week3,
                                                 Current_Week_4__c = curr_Week4); 
           
           return ut;
     }
     /*
      *
      * MethodName: 
      *
      * Purpose:User_Master__c
      *
      */
      public static Approval_Meeting__c createApprovalMeetingTestData(){
        
        try{
        
        User usObj = [SELECT Id, Name FROM User WHERE Name=: 'pranjal singh'];
        
        User_Master__c userObj = new User_Master__c(Name = 'Test',User__c = usObj.id);
        Database.insert(userObj);
        
        Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c(Name = 'testName',Active__c = true);
         Database.insert(OppGrpMaster); 
         
         Opportunity opp=new Opportunity();
         opp.OperatingGroup__c=OppGrpMaster.id;
         opp.name=UtilConstants.TEST_OPP;
         opp.Geo_Area__c=UTIL_Constants.AsiaPacific;
         opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
         opp.StageName=UtilConstants.OA;
         opp.Risk_Level__c=UtilConstants.LOW;
         opp.CloseDate= date.newInstance(2001, 3, 21);
         opp.Opportunity_Solution_Lead__c = userObj.id;
         Database.insert(opp);
         
        Approval_Stage__c app_stageObj = new Approval_Stage__c(approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                                Service_Group__c = utilConstants.BPO,
                                                                opportunity__c = opp.id);
        Database.insert(app_stageObj);
        Meeting_Approver_Master__c meetApprovObj = new Meeting_Approver_Master__c(approver__c = userObj.id, 
                                                                    tcv_range_minimum__c = 200,
                                                                    tcv_range_maximum__c = 100);
        Database.insert(meetApprovObj);
        Approval_Meeting__c approval_meetingcTest =  new Approval_Meeting__c(Approval_Stage__c = app_stageObj.id,
                                                        Meeting_Status__c =Label.Approval_Meeting_scheduled,
                                                        Meeting_Approver__c = meetApprovObj.id,
                                                        Scheduled_Meeting_Time__c = 'LATAM(8 AM CST)',
                                                        Scheduled_End__c = system.now(),
                                                        Scheduled_Start__c = system.now());
        Database.insert(approval_meetingcTest);
        Database.update(approval_meetingcTest);
        Database.delete(approval_meetingcTest);
        
        }
        Catch(Exception e){
            e.getmessage();
        }
            return null;
        }
        /*
         *
         * MethodName: createAnalyticData
         *
         * Purpose:
         *
         */
         public static Analytics_Datas__c createAnalyticData() {
         
         Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c(Name = 'testName',Active__c = true);
         Database.insert(OppGrpMaster); 
         Opportunity opp=new Opportunity();
         opp.OperatingGroup__c=OppGrpMaster.id;
         opp.name=UtilConstants.TEST_OPP;
         opp.Geo_Area__c=UTIL_Constants.AsiaPacific;
         opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
         opp.StageName=UtilConstants.OA;
         opp.Risk_Level__c=UtilConstants.LOW;
         opp.CloseDate= date.newInstance(2001, 3, 21);
         Database.insert(opp);
         Analytics_Datas__c analyticObj = new Analytics_Datas__c(Opportunity__c = opp.id);
         Database.insert(analyticObj);
         return null;
         }
         /*
         *
         * MethodName: createAnalyticData
         *
         * Purpose:
         *
         */
         public static Capacity_Service_Data__c createCapacityServData() {
         
         Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c(Name = 'testName',Active__c = true);
         Database.insert(OppGrpMaster); 
         Opportunity opp=new Opportunity();
         opp.OperatingGroup__c=OppGrpMaster.id;
         opp.name=UtilConstants.TEST_OPP;
         opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
         opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
         opp.StageName=UtilConstants.OA;
         opp.Risk_Level__c=UtilConstants.LOW;
         opp.CloseDate= date.newInstance(2001, 3, 21);
         Database.insert(opp);
         Capacity_Service_Data__c capObj = new Capacity_Service_Data__c(Opportunity__c = opp.id);
         Database.insert(capObj);
         return null;
         }
         
         
         
         
         public static BenchMark__c getBenchmark(Account client,Opportunity opp){
          
           try{
            Benchmark__c bnchmark=new BenchMark__c();
            
            bnchmark.Name = 'testBenchmark';
            bnchmark.Client__c = client.Id;
            bnchmark.Opportunity__c =opp.Id;
            bnchmark.Active__c = True;
            bnchmark.Average_Run_Contingency__c = 20.12;
            bnchmark.BSS_Total_Cost__c = 1234569;
            bnchmark.CFM_Total_Cost__c = 321654;
            bnchmark.CI__c = 12.62;
            bnchmark.CM_Total_Cost__c = 56239;
            bnchmark.Command_Center_Total_Cost__c = 1234;
            bnchmark.Contract_End_Date__c = Date.newInstance(2015,08,01);
            bnchmark.Contract_Start_Date__c = Date.newInstance(2014,08,01);
            bnchmark.Deal_Data_Tables_Updated__c = True;
            bnchmark.Deal_Unlocked__c = True;
            bnchmark.BenchMark_Delivery_Location__c = 'three';
            bnchmark.Electronic_Documentation_Mgmy_Total__c = 65000;
            bnchmark.Grand_Total_Cost__c = 123;
            bnchmark.Inc_in_BM_Report__c = 'Yes';
            bnchmark.Initial_Go_Live__c = Date.newInstance(2015,08,01);
            bnchmark.Languages__c = '8'; 
            bnchmark.Count_of_Language__c = '3+'; 
            bnchmark.Mobilization_Contingency__c = 56;
            bnchmark.Mobilization_Total_Cost__c = 125; 
            bnchmark.Multi_Single_Offering__c = 'Multiple'; 
            bnchmark.Nearshore_Baseline_FTEs__c = 569;  
            bnchmark.Number_of_locations_where_scope_is_deliv__c = 3;
            bnchmark.OADM_Total_Cost__c = 123965;
            bnchmark.Offshore_Baseline_FTEs__c = 123;  
            bnchmark.Onshore_Baseline_FTEs__c = 985;
            bnchmark.PMO_Total_Cost__c = 9586; 
            bnchmark.Pyramid_Richness_Year1__c = 55;
            bnchmark.QAD_Total_Cost__c   = 4568; 
            bnchmark.SAP_OM_ID__c = '101154'; 
            bnchmark.Scenario__c = 'Hello Scene'; 
            bnchmark.SDO_Total_Cost__c = 5698;
            bnchmark.Service_Management_Total_Cost__c = 1562; 
            bnchmark.SSM_Version__c = 'version 2'; 
            bnchmark.Support_Center_Total_Cost__c = 5689;
            bnchmark.Technology_Tools_Total_Cost__c = 78954; 
            bnchmark.Technology_Total_Cost__c = 78459; 
            bnchmark.Baseline_FTEs__c = 4562.32;
            bnchmark.Transformation_Costs_consulting__c = 4589; 
            bnchmark.Version__c = '8'; 
            bnchmark.Voice_and_Data_Total_Cost__c = 1234;
            
            return bnchmark;
            }catch(Exception e){
                system.debug('E---'+e);
            }
            return null;
        }
        
        public static BenchMark_Offerings__c getBenchmarkOffering(Benchmark__c benchmark){
            try{
                BenchMark_Offerings__c benchOff=new BenchMark_Offerings__c();
                benchOff.Name='Human Resources';  
                benchOff.BenchMark__c=benchmark.Id;
                return benchOff;
            }catch(Exception e){
                system.debug('E----'+e);
            }
            return null;
            
        }
        
        public static BenchMark_Offering_Service__c getBenchmarkOfferingService(BenchMark_Offerings__c benchOff){
            try{
                BenchMark_Offering_Service__c benchOffServ=new BenchMark_Offering_Service__c();
                benchOffServ.No_of_Contractors__c=3;
                benchOffServ.No_of_Employees__c=3;
                benchOffServ.of_Headcount_Transferred_from_client__c=3;
                benchOffServ.Active__c=true;
                benchOffServ.Average_of_FTE_Type__c=4;
                benchOffServ.Average_of_Location_Definition__c=2;
                benchOffServ.Average_of_Pyramid_Richness_Year_1__c=2;
                benchOffServ.Costing_Type__c='SDO';
                benchOffServ.Count_of_Language__c=3;
                benchOffServ.Nearshore_Baseline_FTEs__c=4;
                benchOffServ.Offshore_Baseline_FTEs__c=4;
                benchOffServ.Onshore_Baseline_FTEs__c=4;
                benchOffServ.Opportunity_Offering__c='Human Resource';
                benchOffServ.Name='Payroll';
                benchOffServ.Sum_of_Average_FTEs__c=5;
                benchOffServ.Sum_of_Baseline_FTEs__c=6;
                benchOffServ.Sum_of_Final_Month_FTE__c=6;
                benchOffServ.Sum_of_Total_Cost__c=100;
                benchOffServ.BenchMark_Offering__c=benchOff.Id;
                return benchOffServ;
            }catch(Exception e){
                system.debug('E----'+e);
            }
            return null;
            
        }
        
        public static FTE_Details__c getFTEDetails(Solution_Scope__c solComp,Service__c servObj){
            try{
                FTE_Details__c fteDetails=new FTE_Details__c();
                fteDetails.Phase__c = 'Text';
                fteDetails.Service_Group__c = 'text';
                fteDetails.Sub_Service_Group__c = solComp.id; 
                fteDetails.Service__c = servObj.id;
                
                return fteDetails;
            }catch(Exception e){
                system.debug('E----'+e);
            }
            return null;
            
        }
        
        public static Service__c getService(Solution_Scope__c solComp,services__c serMaster){
            try{
                Service__c servObj = new Service__c();
                servObj.Solutionscope__c=solComp.id;
                servObj.services__c=serMaster.id;
                return servObj;
            }catch(Exception e){
                system.debug('E----'+e);
            }
            return null;
            
        }  
      
}