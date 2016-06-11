public class MilestoneReportPageController {

    public String wpvId {get; set;}
    
    class WrapperHighLevel {
        public String deal {get; set;}
        public String location {get; set;}
        public String Waves {get; set;}
        public String planingModules {get; set;}
        public String activityList {get; set;}
        
        //public Date plannedStartDate {get; set;}
        //public Date plannedEndDate {get; set;}
        //public Date actualStartDate {get; set;}
        //public Date actualEndDate {get; set;}
        
        public String plannedStartDate {get; set;}
        public String plannedEndDate {get; set;}
        public String actualStartDate {get; set;}
        public String actualEndDate {get; set;}
        
        public String ragStatus {get; set;}
        public String status {get; set;}
        public String completed {get; set;}
    }
     //public String exportURL {get; set;}
    public List<WrapperHighLevel> mileStoneList {get;set;}
    public Wave_Plan_Version__c wpvRecord{get;set;}
    
    //Construtor
    public MilestoneReportPageController(ApexPages.StandardController controller) {
        wpvId = ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID); 
        if(String.isNotEmpty(wpvId)) {
            wpvRecord = [Select Deal__r.Name, Active__c,BCP_Overall_RAG_Status__c,Commerce_Overall_RAG_Status__c,Contract_Overall_RAG_Status__c,Tech_Overall_RAG_Status__c
                         From Wave_Plan_Version__c Where Id =:wpvId];
        }
        
        mileStoneList = new List<WrapperHighLevel>();
        retriveSRAT();
        retriveOpsMat();
        retriveSerMang();
        retriveKT();
        retriveReqTrack();
        retriveCommericalPlaning();
        retriveContract();
        retrvieTechWork();
        retriveJourney();
        retriveBCP();
        
    }
    public pageReference exporttoExcel() {
        PageReference redirect = Page.MileStoneReportExport; 
        redirect.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, wpvRecord.Id);
        //exportURL = redirect.getUrl();
        redirect.setRedirect(true);
        return redirect;
    }
    private void retriveBCP() {
        List<Business_Continuity_Planning__c> bcpRecordsList = new List<Business_Continuity_Planning__c>();
        bcpRecordsList = [Select Completed__c,Task_Name__c, Actual_End_Date__c, Actual_Start_Date__c,Planned_End_Date__c, Planned_Start_Date__c, Status__c 
                    From Business_Continuity_Planning__c Where Milestone__c = true and Wave_Plan_Version__c = :wpvRecord.Id ];
        
        if(bcpRecordsList.size()>0) {
            for(Business_Continuity_Planning__c bcp : bcpRecordsList) {
            
         system.debug('------bcp.Planned_Start_Date__c.format(yyyy-MM-dd)------------'+bcp.Planned_Start_Date__c.format());
    
     
       
         
          //system.debug('------bcp.Planned_Start_Date__c.format(yyyy-MM-dd)------------'+String.valueOf(Dateformat)); 
         
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal = wpvRecord.Deal__r.Name;
                //wrapperRecord.location = 'Dummy';
                //wrapperRecord.Waves = 'Dummy';
                wrapperRecord.planingModules = 'BCP';
                if(bcp.Planned_Start_Date__c != null){
                    //wrapperRecord.plannedStartDate = (bcp.Planned_Start_Date__c).format();
                    wrapperRecord.plannedStartDate=bcp.Planned_Start_Date__c.day()+'/'+bcp.Planned_Start_Date__c.month()+'/'+bcp.Planned_Start_Date__c.year();
                }
                if(bcp.Planned_End_Date__c != null){
                    //wrapperRecord.plannedEndDate = (bcp.Planned_End_Date__c).format();
                    wrapperRecord.plannedEndDate =bcp.Planned_End_Date__c.day()+'/'+bcp.Planned_End_Date__c.month()+'/'+bcp.Planned_End_Date__c.year();
                }
                if(bcp.Actual_Start_Date__c != null){
                    //wrapperRecord.actualStartDate = (bcp.Actual_Start_Date__c).format();
                    wrapperRecord.actualStartDate =bcp.Actual_Start_Date__c.day()+'/'+bcp.Actual_Start_Date__c.month()+'/'+bcp.Actual_Start_Date__c.year();
                }
                if(bcp.Actual_End_Date__c != null){
                    //wrapperRecord.actualEndDate = (bcp.Actual_End_Date__c).format();
                    wrapperRecord.actualEndDate =bcp.Actual_End_Date__c.day()+'/'+bcp.Actual_End_Date__c.month()+'/'+bcp.Actual_End_Date__c.year();
                }
                
                wrapperRecord.ragStatus = wpvRecord.BCP_Overall_RAG_Status__c;
                wrapperRecord.status = bcp.Status__c;
                wrapperRecord.completed = bcp.Completed__c;
                wrapperRecord.activityList=bcp.Task_Name__c;
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);
            }
        }       
    }
    private void retriveSRAT() {
        List<SRAT__c>strSRATList=[Select Item__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Planned_Date__c, Wave_Plan_lk__r.Wave_Label__c,
                         Completed__c,Actual_Date__c,Overall_SRAT_Completion_Status__c, Individual_Plan_RAG_Status__c, Comments__c, is_RAG_status_changed__c,active__c,Deal_Location_lk__r.Deployment_Lead_New__c
                         from SRAT__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];
       if(strSRATList.size()>0) {
        for(SRAT__c srat : strSRATList){
            WrapperHighLevel wrapperRecord = new WrapperHighLevel();
           
            wrapperRecord.deal = wpvRecord.Deal__r.Name;
            wrapperRecord.location = srat.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
            wrapperRecord.Waves = srat.Wave_Plan_lk__r.Wave_Label__c;
            wrapperRecord.planingModules = 'SRAT';
            wrapperRecord.activityList = srat.Item__c;
            System.debug('----------srat.Item__c---------'+srat.Item__c);
            if(srat.Planned_Date__c != null){
            
                //wrapperRecord.plannedStartDate = (srat.Planned_Date__c).format();
                 wrapperRecord.plannedStartDate = srat.Planned_Date__c.day()+'/'+srat.Planned_Date__c.month()+'/'+srat.Planned_Date__c.year();
            }
            wrapperRecord.ragStatus = srat.Individual_Plan_RAG_Status__c;
            wrapperRecord.status = srat.Individual_Plan_RAG_Status__c;
            wrapperRecord.completed = srat.Overall_SRAT_Completion_Status__c;
            if(srat.Actual_Date__c!=null){
                //wrapperRecord.actualStartDate=String.valueOf(srat.Actual_Date__c);
                wrapperRecord.actualStartDate=srat.Actual_Date__c.day()+'/'+srat.Actual_Date__c.month()+'/'+srat.Actual_Date__c.year();
            }
            System.debug('----------wrapperRecord---------'+wrapperRecord);
            mileStoneList.add(wrapperRecord);
        }
       }                 
    }
    private void retriveOpsMat() {
        List<OPEX__c> strOPEXList=[Select Item__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Planned_Date__c, Wave_Plan_lk__r.Wave_Label__c,
                         Completed__c,Actual_Date__c,Overall_OPEX_Completion_Status__c, Individual_Plan_RAG_Status__c,Stablity__c,
                         Wave_Process__r.Client_Specific_Process_Mapping__r.name from OPEX__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];
        if(strOPEXList.size()>0) {
            for(OPEX__c opex: strOPEXList) {
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal =  wpvRecord.Deal__r.Name;
                wrapperRecord.location = opex.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                wrapperRecord.Waves = opex.Wave_Plan_lk__r.Wave_Label__c;
                wrapperRecord.planingModules = 'OPEX';
                if(opex.Planned_Date__c != null){
                   // wrapperRecord.plannedStartDate =(opex.Planned_Date__c).format();//String.valueOf(opex.Planned_Date__c); 
                    wrapperRecord.plannedStartDate =opex.Planned_Date__c.day()+'/'+opex.Planned_Date__c.month()+'/'+opex.Planned_Date__c.year();
                }
                //wrapperRecord.plannedEndDate = bcp.Planned_End_Date__c;
                if(opex.Actual_Date__c != null){
                    //wrapperRecord.actualStartDate = (opex.Actual_Date__c).format();//String.valueOf(opex.Actual_Date__c);
                    wrapperRecord.actualStartDate = opex.Actual_Date__c.day()+'/'+opex.Actual_Date__c.month()+'/'+opex.Actual_Date__c.year();
                }
                //wrapperRecord.actualEndDate = bcp.Actual_End_Date__c;
                wrapperRecord.ragStatus = opex.Individual_Plan_RAG_Status__c;
                wrapperRecord.status = opex.Individual_Plan_RAG_Status__c;
                wrapperRecord.completed = opex.Overall_OPEX_Completion_Status__c;
                wrapperRecord.activityList = opex.Item__c;
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);   
                
            }
        }    
    }
    private void retriveSerMang() {
        List<Service_Management__c> strServiceManagementList=[Select Task_Name__c, Activity__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                    Deal_Location_lk__r.Location_Name__c,Deal_Location_lk__c,Planned_Start_Date__c,
                                    Planned_End_Date__c, Wave_Plan_lk__r.Wave_Label__c,Completed__c,Actual_Start_Date__c,Actual_End_Date__c ,Status__c
                                    from Service_Management__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];
                                    System.debug('-----Deal_Location_lk__r.Location_Name__c---'+strServiceManagementList);
        if(strServiceManagementList.size()>0){
            for(Service_Management__c serMan :strServiceManagementList) {
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal =  wpvRecord.Deal__r.Name;
                wrapperRecord.location = serMan.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                wrapperRecord.Waves = serMan.Wave_Plan_lk__r.Wave_Label__c;
                system.debug('------------------------------pANY----------------'+serMan.Deal_Location_lk__r.Location_Name__c);
                wrapperRecord.planingModules = 'Service Management';
                if(serMan.Planned_Start_Date__c != null ){
                    //wrapperRecord.plannedStartDate = (serMan.Planned_Start_Date__c).format();
                   wrapperRecord.plannedStartDate =serMan.Planned_Start_Date__c.day()+'/'+serMan.Planned_Start_Date__c.month()+'/'+serMan.Planned_Start_Date__c.year();
                   
                }
                if(serMan.Planned_End_Date__c != null){
                   // wrapperRecord.plannedEndDate = (serMan.Planned_End_Date__c).format();
                    wrapperRecord.plannedEndDate = serMan.Planned_End_Date__c.day()+'/'+serMan.Planned_End_Date__c.month()+'/'+serMan.Planned_End_Date__c.year();
                }
                if(serMan.Actual_Start_Date__c != null ){
                    //wrapperRecord.actualStartDate = (serMan.Actual_Start_Date__c).format();
                    wrapperRecord.actualStartDate = serMan.Actual_Start_Date__c.day()+'/'+serMan.Actual_Start_Date__c.month()+'/'+serMan.Actual_Start_Date__c.year();
                }
                if(serMan.Actual_End_Date__c != null ){
                   // wrapperRecord.actualEndDate =(serMan.Actual_End_Date__c).format();//String.valueOf(serMan.Actual_End_Date__c)
                   wrapperRecord.actualEndDate =serMan.Actual_End_Date__c.day()+'/'+serMan.Actual_End_Date__c.month()+'/'+serMan.Actual_End_Date__c.year();
                }
                //wrapperRecord.ragStatus = serMan.Individual_Plan_RAG_Status__c;
                
                wrapperRecord.status = serMan.Status__c;
                wrapperRecord.completed = serMan.Completed__c;
                wrapperRecord.activityList = serMan.Task_Name__c;
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);   
            }
        }                           
    }
    private void retriveKT() {
        List<KT_Planning__c> strKTPlanningList=[Select Activity__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, 
                                 Wave_Plan_lk__r.Wave_Label__c,Completed__c,Actual_Start_Date__c,Actual_End_Date__c,Overall_RAG_status_for_Location__c,
                                 Overall_RAG_status_for_Wave__c,Comments_for_Wave__c,Comments_for_Location__c,
                                 Wave_Plan_lk__r.KT_Lead_New__c,Planned_Start_Date__c,Planned_End_Date__c
                                 from KT_Planning__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];
        if(strKTPlanningList.size()>0){
            for(KT_Planning__c kt :strKTPlanningList) {
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal =  wpvRecord.Deal__r.Name;
                wrapperRecord.location = kt.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                wrapperRecord.Waves = kt.Wave_Plan_lk__r.Wave_Label__c;
                wrapperRecord.planingModules = 'KT Planning';
                
                if(kt.Planned_Start_Date__c != null){
                   // wrapperRecord.plannedStartDate = (kt.Planned_Start_Date__c).format();
                   wrapperRecord.plannedStartDate=kt.Planned_Start_Date__c.day()+'/'+kt.Planned_Start_Date__c.month()+'/'+kt.Planned_Start_Date__c.year();
                }
                if(kt.Planned_End_Date__c != null){
                   // wrapperRecord.plannedEndDate = (kt.Planned_End_Date__c).format();
                   wrapperRecord.plannedEndDate = kt.Planned_End_Date__c.day()+'/'+kt.Planned_End_Date__c.month()+'/'+kt.Planned_End_Date__c.year();
                }
                if(kt.Actual_Start_Date__c != null ){
                    //wrapperRecord.actualStartDate = (kt.Actual_Start_Date__c).format();
                    wrapperRecord.actualStartDate =kt.Actual_Start_Date__c.day()+'/'+kt.Actual_Start_Date__c.month()+'/'+kt.Actual_Start_Date__c.year(); 
                }
                if(kt.Actual_End_Date__c != null){
                   // wrapperRecord.actualEndDate = (kt.Actual_End_Date__c).format();
                    wrapperRecord.actualEndDate = kt.Actual_End_Date__c.day()+'/'+kt.Actual_End_Date__c.month()+'/'+kt.Actual_End_Date__c.year(); 
                }
                wrapperRecord.ragStatus = kt.Overall_RAG_status_for_Location__c;
                wrapperRecord.status = kt.Overall_RAG_status_for_Location__c;
                wrapperRecord.completed = kt.Completed__c;
                wrapperRecord.activityList = kt.Activity__c;
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);   
            }
        }                         
    }
    private void retriveReqTrack() {
         List<Recruitment_Tracking__c>strRecruitmentTrackingList=[Select Activity__c,FTE_Number__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Planned_Start_Date__c,
                                             Planned_End_Date__c, Wave_Plan_lk__r.Wave_Label__c,Completed__c,Actual_Start_Date__c,Actual_End_Date__c,Overall_Recruitment_Planning_RAG_status__c,
                                             Overall_RAG_status_for_Location__c
                                            from Recruitment_Tracking__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];
        if(strRecruitmentTrackingList.size()>0){
            for(Recruitment_Tracking__c reqTrac :strRecruitmentTrackingList) {
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal =  wpvRecord.Deal__r.Name;
                wrapperRecord.location = reqTrac.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                wrapperRecord.Waves = reqTrac.Wave_Plan_lk__r.Wave_Label__c;
                wrapperRecord.planingModules = 'Requirement Tracking';
                
                if(reqTrac.Planned_Start_Date__c != null ){
                    //wrapperRecord.plannedStartDate = (reqTrac.Planned_Start_Date__c).format();
                    wrapperRecord.plannedStartDate=reqTrac.Planned_Start_Date__c .day()+'/'+reqTrac.Planned_Start_Date__c .month()+'/'+reqTrac.Planned_Start_Date__c .year(); 
                }
                if(reqTrac.Planned_End_Date__c != null ){
                    //wrapperRecord.plannedEndDate = (reqTrac.Planned_End_Date__c).format();
                    wrapperRecord.plannedEndDate = reqTrac.Planned_End_Date__c .day()+'/'+reqTrac.Planned_End_Date__c .month()+'/'+reqTrac.Planned_End_Date__c .year(); 
                }
                if(reqTrac.Actual_Start_Date__c != null ){
                   // wrapperRecord.actualStartDate = (reqTrac.Actual_Start_Date__c).format();
                   wrapperRecord.actualStartDate = reqTrac.Actual_Start_Date__c .day()+'/'+reqTrac.Actual_Start_Date__c.month()+'/'+reqTrac.Actual_Start_Date__c .year();
                }
                if(reqTrac.Actual_End_Date__c != null ){
                   // wrapperRecord.actualEndDate = (reqTrac.Actual_End_Date__c).format();
                   wrapperRecord.actualEndDate=reqTrac.Actual_End_Date__c .day()+'/'+reqTrac.Actual_End_Date__c.month()+'/'+reqTrac.Actual_End_Date__c.year();
                }
                wrapperRecord.ragStatus = reqTrac.Overall_RAG_status_for_Location__c;
                wrapperRecord.status = reqTrac.Overall_RAG_status_for_Location__c;
                wrapperRecord.completed = reqTrac.Completed__c;
                wrapperRecord.activityList = reqTrac.Activity__c;
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);   
            }
        }                                       
    }
    private void retriveCommericalPlaning() {
        List<Commercial_Planning__c> strCommercialPlanningList=[Select Activity__c,Planned_Start_Date__c,Planned_End_Date__c,Completed__c,Actual_Start_Date__c,Actual_End_Date__c,
                                    Comments__c,active__c,Delivery_Location__c from Commercial_Planning__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];
        if(strCommercialPlanningList.size()>0){
            for(Commercial_Planning__c sra :strCommercialPlanningList) {
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal =  wpvRecord.Deal__r.Name;
                //wrapperRecord.location = sra.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                //wrapperRecord.Waves = sra.Wave_Plan_lk__r.Wave_Label__c;
                wrapperRecord.planingModules = 'Commercial Planning';
                
                if(sra.Planned_Start_Date__c != null ){
                    //wrapperRecord.plannedStartDate = (sra.Planned_Start_Date__c).format();
                    wrapperRecord.plannedStartDate=sra.Planned_Start_Date__c.day()+'/'+sra.Planned_Start_Date__c.month()+'/'+sra.Planned_Start_Date__c.year();
                }
                if(sra.Planned_End_Date__c != null ){
                    //wrapperRecord.plannedEndDate = (sra.Planned_End_Date__c).format();
                    wrapperRecord.plannedEndDate=sra.Planned_End_Date__c.day()+'/'+sra.Planned_End_Date__c.month()+'/'+sra.Planned_End_Date__c.year();
                }
                if(sra.Actual_Start_Date__c != null ){
                    //wrapperRecord.actualStartDate = (sra.Actual_Start_Date__c).format();
                     wrapperRecord.actualStartDate=sra.Actual_Start_Date__c.day()+'/'+sra.Actual_Start_Date__c.month()+'/'+sra.Actual_Start_Date__c.year();
                }
                if(sra.Actual_End_Date__c != null ){
                    wrapperRecord.actualEndDate=sra.Actual_End_Date__c.day()+'/'+sra.Actual_End_Date__c.month()+'/'+sra.Actual_End_Date__c.year();
                   // wrapperRecord.actualEndDate = (sra.Actual_End_Date__c).format();
                }
                wrapperRecord.ragStatus = wpvRecord.Commerce_Overall_RAG_Status__c;
                wrapperRecord.status = wpvRecord.Commerce_Overall_RAG_Status__c;
                wrapperRecord.completed = sra.Completed__c;
                wrapperRecord.activityList = sra.Activity__c;
                wrapperRecord.location=sra.Delivery_Location__c;
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);   
            }
        }    
    }
    private void retriveContract() {
         List<Contract_Legal_Infosec__c> strContractLegalInfosecList=[Select name,Active__c,Cloned_From__c,Comments__c,Task_Name__c,Task_Number__c,Task_Master_ID__c,Section_Master_ID__c,
                                          Planned_End_Date__c,Planed_Start_Date__c,Responsibility__c,Section_Name__c,Section_Number__c,Version__c,
                                          Wave_Plan_Version__c,Resource_Name__c, Actual_Start_Date__c, Actual_End_Date__c ,Completed__c , status__c
                                          from Contract_Legal_Infosec__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];
        if(strContractLegalInfosecList.size()>0){
            for(Contract_Legal_Infosec__c sra :strContractLegalInfosecList) {
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal =  wpvRecord.Deal__r.Name;
                //wrapperRecord.location = sra.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                //wrapperRecord.Waves = sra.Wave_Plan_lk__r.Wave_Label__c;
                wrapperRecord.planingModules = 'Contact Legal Infosec';
                if(sra.Planed_Start_Date__c != null ){
                
                    //wrapperRecord.plannedStartDate = (sra.Planed_Start_Date__c).format();
                    wrapperRecord.plannedStartDate=sra.Planed_Start_Date__c.day()+'/'+sra.Planed_Start_Date__c.month()+'/'+sra.Planed_Start_Date__c.year();
                }
                if(sra.Planned_End_Date__c != null){
                
                    //wrapperRecord.plannedEndDate = (sra.Planned_End_Date__c).format();
                    wrapperRecord.plannedEndDate = sra.Planned_End_Date__c.day()+'/'+sra.Planned_End_Date__c.month()+'/'+sra.Planned_End_Date__c.year();
                }
                if(sra.Actual_Start_Date__c != null ){
                
                    wrapperRecord.actualStartDate = (sra.Actual_Start_Date__c).format();
                    wrapperRecord.actualStartDate = sra.Actual_Start_Date__c.day()+'/'+sra.Actual_Start_Date__c.month()+'/'+sra.Actual_Start_Date__c.year();
                }
                if(sra.Actual_End_Date__c != null){
                
                   // wrapperRecord.actualEndDate = (sra.Actual_End_Date__c).format();
                     wrapperRecord.actualEndDate = sra.Actual_End_Date__c.day()+'/'+sra.Actual_End_Date__c.month()+'/'+sra.Actual_End_Date__c.year();
                }
                wrapperRecord.ragStatus = wpvRecord.Contract_Overall_RAG_Status__c;
                wrapperRecord.status = sra.Status__c;
                wrapperRecord.completed = sra.Completed__c;
                wrapperRecord.activityList = sra.Task_Name__c;
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);   
            }
        } 
    }
    private void retrvieTechWork() {
         List<Tech_Assessment__c> strTechAssessmentList=[Select Activity__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Planned_Start_Date__c,Planned_End_Date__c, 
                                     Wave_Plan_lk__r.Wave_Label__c,Completed__c,Actual_Start_Date__c,Actual_End_Date__c
                                     from Tech_Assessment__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];
        if(strTechAssessmentList.size()>0){
            for(Tech_Assessment__c sra :strTechAssessmentList) {
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal =  wpvRecord.Deal__r.Name;
                wrapperRecord.location = sra.Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name;
                wrapperRecord.Waves = sra.Wave_Plan_lk__r.Wave_Label__c;
                wrapperRecord.planingModules = 'Technology & Work Enablement';
                if(sra.Planned_Start_Date__c != null ){
                    //wrapperRecord.plannedStartDate = (sra.Planned_Start_Date__c).format();
                    wrapperRecord.plannedStartDate =sra.Planned_Start_Date__c.day()+'/'+sra.Planned_Start_Date__c.month()+'/'+sra.Planned_Start_Date__c.year();
                }
                if(sra.Planned_End_Date__c != null ){
                    //wrapperRecord.plannedEndDate = (sra.Planned_End_Date__c).format();
                    wrapperRecord.plannedEndDate =sra.Planned_End_Date__c.day()+'/'+sra.Planned_End_Date__c.month()+'/'+sra.Planned_End_Date__c.year();
                }
                if(sra.Actual_Start_Date__c != null ){
                   // wrapperRecord.actualStartDate = (sra.Actual_Start_Date__c).format();
                    wrapperRecord.actualStartDate =sra.Actual_Start_Date__c.day()+'/'+sra.Actual_Start_Date__c.month()+'/'+sra.Actual_Start_Date__c.year();
                }
                if(sra.Actual_End_Date__c != null ){
                    //wrapperRecord.actualEndDate = (sra.Actual_End_Date__c).format();
                    wrapperRecord.actualEndDate = sra.Actual_End_Date__c.day()+'/'+sra.Actual_End_Date__c.month()+'/'+sra.Actual_End_Date__c.year();
                }
                wrapperRecord.ragStatus = wpvRecord.Tech_Overall_RAG_Status__c;
                wrapperRecord.status = wpvRecord.Tech_Overall_RAG_Status__c;
                wrapperRecord.completed = sra.Completed__c;
                wrapperRecord.activityList = sra.Activity__c;
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);   
            }
        } 
    }
    private void retriveJourney() {
        List<Journey_Management_Planning__c> strJourneyPlanList= [select name,Comments__c,Deliverable_Name__c,
                                 Planned_End_Date__c,Planned_Start_Date__c,Responsibility__c,Section_Name__c,
                                 Completed__c,Actual_Start_Date__c,Actual_End_Date__c,Status__c
                                 from Journey_Management_Planning__c where Wave_Plan_Version__c=:wpvRecord.Id and Milestone__c = true];   
        if(strJourneyPlanList.size()>0){
            for(Journey_Management_Planning__c sra :strJourneyPlanList) {
                WrapperHighLevel wrapperRecord = new WrapperHighLevel();
                wrapperRecord.deal =  wpvRecord.Deal__r.Name;
                wrapperRecord.planingModules = 'Journey Management';
                
                //wrapperRecord.plannedStartDate = (sra.Planned_Start_Date__c).format();
                //wrapperRecord.plannedEndDate = (sra.Planned_End_Date__c).format();
                //wrapperRecord.actualStartDate = (sra.Actual_Start_Date__c).format();
                //wrapperRecord.actualEndDate = (sra.Actual_End_Date__c).format();
                
                
                if(sra.Planned_Start_Date__c != null){
                    //wrapperRecord.plannedStartDate = (sra.Planned_Start_Date__c).format();
                    wrapperRecord.plannedStartDate =sra.Planned_Start_Date__c.day()+'/'+sra.Planned_Start_Date__c.month()+'/'+sra.Planned_Start_Date__c.year();
                }
                if(sra.Planned_End_Date__c != null ){
                    //wrapperRecord.plannedEndDate = (sra.Planned_End_Date__c).format();
                    wrapperRecord.plannedEndDate = sra.Planned_End_Date__c.day()+'/'+sra.Planned_End_Date__c.month()+'/'+sra.Planned_End_Date__c.year();
                }
                if(sra.Actual_Start_Date__c != null ){
                   // wrapperRecord.actualStartDate = (sra.Actual_Start_Date__c).format();
                    wrapperRecord.actualStartDate =sra.Actual_Start_Date__c.day()+'/'+sra.Actual_Start_Date__c.month()+'/'+sra.Actual_Start_Date__c.year();
                }
                if(sra.Actual_End_Date__c != null ){
                    //wrapperRecord.actualEndDate = (sra.Actual_End_Date__c).format();
                    wrapperRecord.actualEndDate =sra.Actual_End_Date__c.day()+'/'+sra.Actual_End_Date__c.month()+'/'+sra.Actual_End_Date__c.year();
                }
                
                wrapperRecord.ragStatus = wpvRecord.Tech_Overall_RAG_Status__c;
                wrapperRecord.status = sra.Status__c;
                wrapperRecord.completed = sra.Completed__c;
                wrapperRecord.activityList =sra.Deliverable_Name__c;
                
                System.debug('----------wrapperRecord---------'+wrapperRecord);
                mileStoneList.add(wrapperRecord);   
            }
        }
    }
    
}