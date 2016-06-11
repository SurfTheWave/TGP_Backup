/*
* This class will be used as business logic controller for trigger OperationOnWavePlanVersion on Wave_Plan_Version__c
*
*  @ Author Accenture Team
*  @ Date 18/02/2014 
*/
public class WavePlanVersionTriggerController {
    // Class Constants
    private static final string CLASS_NAME = 'WavePlanVersionTriggerController';
    private static final string TRIGGER_NAME = 'OperationOnWavePlanVersion';
    private static final string METHOD_COMM_INSERT = 'insertCommericalPlan';
    private static final string METHOD_SERVICE_INSERT = 'insertInServiceMgmt';
    private static final string METHOD_CONTRACT_INSERT = 'insertContractLegalInfo';
    private static final string METHOD_JOURNEY_INSERT = 'insertInJourneyMgmt';
    private static final string METHOD_BCP_INSERT = 'insertBusinessContinuity';
    private static final string METHOD_KTP_INSERT = 'insertKTPlan';
    private static final string METHOD_TECH_INSERT = 'insertTechPlan';
    private static final string METHOD_RECRUIT_INSERT = 'insertRecruitmentPlan';
    private static final string METHOD_LOCATION_INSERT = 'insertLocation';
    private static final string METHOD_DEACTIVATE_WPV_INSERT = 'deactivateVersion';
    private static final string METHOD_INSERT_WPV_INSERT = 'insertWPVRecordOperation';
    private static final string METHOD_SEND_EMAIL = 'sendEmail';
    /*
    *   @ Method : insertWavePlanVersion
    *   @ Description : This method called by the trigger, and its call the 
    *                   other method insert High Level plan Records
    */
    public static void insertWPVRecordOperation (List<Wave_Plan_Version__c> wpvList) {
        List<Wave_Plan_Version__c> wavePlanVersionList = new List<Wave_Plan_Version__c>();
        try {
            for(Wave_Plan_Version__c wpv : wpvList) {
                if(wpv.Active__c) {
                    wavePlanVersionList.add(wpv);
                }
            }
            if(!wavePlanVersionList.isEmpty()) {
                insertCommericalPlan(wavePlanVersionList);
                insertInServiceMgmt(wavePlanVersionList);
                insertContractLegalInfo(wavePlanVersionList);
                insertInJourneyMgmt(wavePlanVersionList);
                insertBusinessContinuity(wavePlanVersionList);
                insertLocation(wavePlanVersionList);
                deactivateVersion(wavePlanVersionList);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_INSERT_WPV_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : insertCommericalPlan
    *   @ Description : This method insert the Commerical Planning records for new Wave plan version
    */
    private static void insertCommericalPlan (List<Wave_Plan_Version__c> wavePlanVersionList) {
        List<Commercial_Planning__c> lstCommercePlan = new List<Commercial_Planning__c>();
        Commercial_Planning__c commercePlan;
        try {
            List<Commercial_Plan_Activity_Master__c> lstActivity = [select Activity_Name__c from Commercial_Plan_Activity_Master__c where Is_Active__c =: true];
            
            system.debug('-----------lstActivity ---------'+lstActivity );
            for(Wave_Plan_Version__c wpv : wavePlanVersionList) {
                if(String.isEmpty(wpv.cloned_from__c)) {
                    for(Commercial_Plan_Activity_Master__c tmpActivity : lstActivity) {
                        commercePlan = new Commercial_Planning__c ();
                        commercePlan.Wave_Plan_Version__c = wpv.id;
                        commercePlan.activity__c = tmpActivity.Activity_Name__c;
                        commercePlan.Commercial_Plan_Activity_Master_Id__c = tmpActivity.id;
                        lstCommercePlan.add(commercePlan);
                    }
                }
            }
            if(!lstCommercePlan.isEmpty())  {
                Database.Saveresult [] lsr = Database.insert(lstCommercePlan, false);           
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_COMM_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }                       
    }
    /*
    *   @ Method : insertInServiceMgmt
    *   @ Description : This method insert the Service Mangement records for new Wave plan version
    */
    private static void insertInServiceMgmt(List<Wave_Plan_Version__c> wavePlanVersionList) {
        List<Service_Management__c> lstService = new List<Service_Management__c>();
        Service_Management__c service;
        try {
            List<Service_Management_Task_Master__c> lstDeliverable = [select  Task_Name__c,Task_Number__c,Service_Management_Phase__c,
                                                                        Service_Management_Phase__r.Phase_Name__c ,Service_Management_Phase__r.Phase_Number__c
                                                                        from Service_Management_Task_Master__c where Is_Active__c =: true];
            
            
            for(Wave_Plan_Version__c wpv : wavePlanVersionList) {
                if(String.isEmpty(wpv.cloned_from__c)) {
                    for(Service_Management_Task_Master__c tmpDeliverable : lstDeliverable ){
                        service = new Service_Management__c ();
                        service.Task_Name__c = tmpDeliverable.Task_Name__c;
                        service.Task_Number__c = tmpDeliverable.Task_Number__c;
                        service.Task_ID__c= tmpDeliverable.id;
                        service.Phase_ID__c = tmpDeliverable.Service_Management_Phase__c;
                        service.Phase_Name__c = tmpDeliverable.Service_Management_Phase__r.Phase_Name__c;
                        service.Phase_Number__c = tmpDeliverable.Service_Management_Phase__r.Phase_Number__c;
                        service.Wave_Plan_Version__c = wpv.id;
                        lstService.add(service); 
                    }
                }
            }
            if(!lstService.isEmpty())  {
                Database.Saveresult [] lsr = Database.insert(lstService, false);            
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SERVICE_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : insertContractLegalInfo
    *   @ Description : This method insert the Contract Legal Infosec records
    */
    private static void insertContractLegalInfo(List<Wave_Plan_Version__c> wavePlanVersionList) {
        List<Contract_Legal_Infosec__c> lstContract = new List<Contract_Legal_Infosec__c>();
        Contract_Legal_Infosec__c contract;
        try {
            List<Contract_Legal_Infosec_Task_Master__c> lstTask = [select Task_Name__c,Task_Number__c,Contract_Legal_Infosec_Section_Master__c,
                                                                Contract_Legal_Infosec_Section_Master__r.Section_Name__c,
                                                                Contract_Legal_Infosec_Section_Master__r.Section_Number__c 
                                                                from Contract_Legal_Infosec_Task_Master__c where Is_Active__c =: true];
            for(Wave_Plan_Version__c wpv : wavePlanVersionList) {
                if(String.isEmpty(wpv.cloned_from__c)) {
                    for(Contract_Legal_Infosec_Task_Master__c tmpTask : lstTask ){
                        contract = new Contract_Legal_Infosec__c ();
                        contract.Task_Name__c = tmpTask.Task_Name__c;
                        contract.Task_Number__c = tmpTask.Task_Number__c;
                        contract.Task_Master_ID__c = tmpTask.id;
                        contract.Section_Master_ID__c = tmpTask.Contract_Legal_Infosec_Section_Master__c;
                        contract.Section_Name__c = tmpTask.Contract_Legal_Infosec_Section_Master__r.Section_Name__c;
                        contract.Section_Number__c = tmpTask.Contract_Legal_Infosec_Section_Master__r.Section_Number__c;
                        contract.Wave_Plan_Version__c = wpv.id;
                        lstContract.add(contract); 
                    }
                }
            }
            if(!lstContract.isEmpty())  {
                Database.Saveresult [] lsr = Database.insert(lstContract, false);           
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_CONTRACT_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @ Method : insertInJourneyMgmt
    *   @ Description : This method insert the Journey Management records
    */
    private static void insertInJourneyMgmt(List<Wave_Plan_Version__c> wavePlanVersionList) {
        List<Journey_Management_Planning__c> lstJourney = new List<Journey_Management_Planning__c>();
        Journey_Management_Planning__c journey;
        try {
            List<Journey_Management_Deliverable__c> lstDeliverable = [select Deliverable_Name__c,Deliverable_Number__c,Journey_Management__c,
                                                                Journey_Management__r.Section_Name__c,Journey_Management__r.Section_Number__c 
                                                                from Journey_Management_Deliverable__c where Is_Active__c =: true];
            for(Wave_Plan_Version__c wpv : wavePlanVersionList) {
                if(String.isEmpty(wpv.cloned_from__c)) {
                    for(Journey_Management_Deliverable__c tmpDeliverable : lstDeliverable ){
                        journey = new Journey_Management_Planning__c ();
                        journey.Deliverable_Name__c = tmpDeliverable.Deliverable_Name__c;
                        journey.Deliverable_Number__c = tmpDeliverable.Deliverable_Number__c;
                        journey.Journey_Management_Deliverable_Id__c = tmpDeliverable.id;
                        journey.Journey_Management_Id__c = tmpDeliverable.Journey_Management__c;
                        journey.Section_Name__c = tmpDeliverable.Journey_Management__r.Section_Name__c;
                        journey.Section_Number__c = tmpDeliverable.Journey_Management__r.Section_Number__c;
                        journey.Wave_Plan_Version__c = wpv.id;
                        lstJourney.add(journey); 
                    }
                }
            }
            if(!lstJourney.isEmpty())  {
                Database.Saveresult [] lsr = Database.insert(lstJourney, false);            
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_JOURNEY_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @Method : insertBusinessContinuity
    *   @ Description : This method used to insert the Business Continuity Plan records
    */
    private static void insertBusinessContinuity(List<Wave_Plan_Version__c> wavePlanVersionList) {
        List<Business_Continuity_Planning__c> lstBCP = new List<Business_Continuity_Planning__c>();
        Business_Continuity_Planning__c bcp;
        try {
            List<BCP_Task_Master__c> lstDeliverable = [select id,Task_Number__c, Task_Name__c,Business_Continuity_Planning_del__r.Section_Number__c,
                                                        Business_Continuity_Planning_del__c,Business_Continuity_Planning_del__r.Section_Name__c 
                                                        from BCP_Task_Master__c where Is_Active__c =: true];
            for(Wave_Plan_Version__c wpv : wavePlanVersionList) {
                if(String.isEmpty(wpv.cloned_from__c)) {
                    for(BCP_Task_Master__c tmpDeliverable : lstDeliverable ){
                        bcp = new Business_Continuity_Planning__c ();
                        bcp.Task_Name__c = tmpDeliverable.Task_Name__c;
                        bcp.Task_Number__c = tmpDeliverable.Task_Number__c;
                        bcp.BCP_Section_Master_Id__c  = tmpDeliverable.Business_Continuity_Planning_del__c;
                        bcp.BCP_Task_Master_Id__c  = tmpDeliverable.id;
                        bcp.Section_Name__c = tmpDeliverable.Business_Continuity_Planning_del__r.Section_Name__c;
                        bcp.Section_Number__c = tmpDeliverable.Business_Continuity_Planning_del__r.Section_Number__c;
                        bcp.Wave_Plan_Version__c = wpv.id;
                        lstBCP.add(bcp); 
                    }
                }
            }
            if(!lstBCP.isEmpty())  {
                Database.Saveresult [] lsr = Database.insert(lstBCP, false);            
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_BCP_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    
    
    
    /*
    *   @Method : insertLocation
    *   @ Description : This method used to insert the Deal Location for new Wave Plan Version.
    */
    private static void insertLocation(List<Wave_Plan_Version__c> wavePlanVersionList) {
        List<Deal_Location__c> lstDealLocation = new List<Deal_Location__c>();
        Set<Deal_Home_Location__c> setDHL = new Set<Deal_Home_Location__c>();
        Map<Id, Set<Deal_Home_Location__c>> dHLMap = new Map<Id, set<Deal_Home_Location__c>>();
        Deal_Location__c dalLoc;
        Set<Id> dealSet = new Set<Id>();
        try {
            for (Wave_Plan_Version__c wpv : wavePlanVersionList) {
                if(!String.isEmpty(wpv.Deal__c)) {
                    dealSet.add(wpv.Deal__c);
                }
            }
            for(Deal_Home_Location__c dhl : [select Deal__c,name,Delivery_Location_Master__c,Active__c from Deal_Home_Location__c 
                                                where Deal__c IN : dealSet order by Delivery_Location_Master__r.name]) {
                if(dHLMap.containsKey(dhl.Deal__c)) {
                    setDHL = dHLMap.get(dhl.Deal__c);
                }
                else {
                    setDHL = new Set<Deal_Home_Location__c>();
                }
                setDHL.add(dhl);
                dHLMap.put(dhl.Deal__c, setDHL);
            }
            for(Wave_Plan_Version__c wpv : wavePlanVersionList) {
                if(dHLMap.containsKey(wpv.Deal__c) && String.isEmpty(wpv.cloned_from__c)) {
                    setDHL = dHLMap.get(wpv.Deal__c);
                    for(Deal_Home_Location__c tmpDeliverable : setDHL ){
                        dalLoc = new Deal_Location__c();
                        dalLoc.Wave_Plan_Version__c=wpv.Id;
                        dalLoc.Deal_Home_Location__c=tmpDeliverable.id;
                        if(!tmpDeliverable.Active__c){
                            dalLoc.NewActive__c = false;
                        }
                        lstDealLocation.add(dalLoc);
                    }
                }
            }
            if(!lstDealLocation.isEmpty())  {
                Database.Saveresult [] lsr = Database.insert(lstDealLocation, false);           
            }   
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_LOCATION_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @Method : deactivateVersion
    *   @ Description : This method used to deavtivate the old wave plan version, Deal location and Wave Plan
    */
    private static void deactivateVersion(List<Wave_Plan_Version__c> wavePlanVersionList) {
        Set<Id> dealSet = new Set<Id>();
        list<Wave_Plan_Version__c> wpvList = new list<Wave_Plan_Version__c>();
        list<Deal_Location__c> dealLocationList = new list<Deal_Location__c>();
        list<Wave_Planning__c> wavePlanList = new list<Wave_Planning__c>();
        Map<Id,set<Wave_Plan_Version__c>> dealWPVMap = new Map<Id,set<Wave_Plan_Version__c>>();
        Map<Id,set<Deal_Location__c>> dealLocMap = new Map<Id,set<Deal_Location__c>>();
        Map<Id,set<Wave_Planning__c>> wavePlanMap = new Map<Id,set<Wave_Planning__c>>();
        set<Wave_Plan_Version__c> wpvSet = new set<Wave_Plan_Version__c>();
        set<Deal_Location__c> dealLocSet = new set<Deal_Location__c>();
        set<Wave_Planning__c> wavePlancSet = new set<Wave_Planning__c>();
        list<Wave_Plan_Version__c> updateWPVList = new list<Wave_Plan_Version__c>();
        list<Deal_Location__c> updatedealLocList = new list<Deal_Location__c>();
        list<Wave_Planning__c> updatedWavePlanList = new list<Wave_Planning__c>();
        List<Id> wpvIdList = new List<Id>();
        List<Deal_Track__c> trackDealList = new List<Deal_Track__c>();
        try {
            for(Wave_Plan_Version__c wpv : wavePlanVersionList) {
                dealSet.add(wpv.deal__c);
            }
            if(!dealSet.isEmpty()) {
                wpvList = [Select Deal__c, name, deal__r.name, deal__r.Governance_Lead_Name_New__r.SFDC_User__r.email, deal__r.owner.email, Active__c, 
                            Display_tracking_message__c from Wave_Plan_Version__c where deal__c =: dealSet and active__c = true];
            }
            if(!wpvList.isEmpty()) {
                dealLocationList = [select Wave_Plan_Version__c,active__c from Deal_Location__c Where Wave_Plan_Version__c =: wpvList ];
            }
            if(!dealLocationList.isEmpty()) {
                wavePlanList = [select id,Deal_Location__c,active__c from Wave_Planning__c where Deal_Location__c  = : dealLocationList];
            }
            for(Wave_Plan_Version__c wpv: wpvList){
                if(dealWPVMap.containsKey(wpv.Deal__c)) {
                    wpvSet = dealWPVMap.get(wpv.Deal__c);
                }
                else {
                    wpvSet = new Set<Wave_Plan_Version__c>();
                }
                wpvSet.add(wpv);
                dealWPVMap.put(wpv.Deal__c, wpvSet);
            }
            for(Deal_Location__c dealLoc : dealLocationList) {
                if(dealLocMap.containsKey(dealLoc.Wave_Plan_Version__c)) {
                    dealLocSet = dealLocMap.get(dealLoc.Wave_Plan_Version__c);
                }
                else {
                    dealLocSet = new Set<Deal_Location__c>();
                }
                dealLocSet.add(dealLoc);
                dealLocMap.put(dealLoc.Wave_Plan_Version__c, dealLocSet);
            }
            for(Wave_Planning__c wavePlan : wavePlanList) {
                if(wavePlanMap.containsKey(wavePlan.Deal_Location__c)) {
                    wavePlancSet = wavePlanMap.get(wavePlan.Deal_Location__c);
                }
                else {
                    wavePlancSet = new Set<Wave_Planning__c>();
                }
                wavePlancSet.add(wavePlan);
                wavePlanMap.put(wavePlan.Deal_Location__c, wavePlancSet);
            }
            for(Wave_Plan_Version__c wpv : wavePlanVersionList) {
                if(dealWPVMap.containsKey(wpv.Deal__c)) {
                    for(Wave_Plan_Version__c wpvRec : dealWPVMap.get(wpv.Deal__c)){
                        if(wpv.Id != wpvRec.id) {
                            wpvRec.Active__c = false;
                            wpvRec.Display_tracking_message__c = null;
                            wpvIdList.add(wpvRec.Id);
                            updateWPVList.add(wpvRec);
                            sendEmail(wpvRec);
                        }
                    }
                }
            }
            if(!wpvIdList.isEmpty()) {
                trackDealList = [Select Wave_Plan_Version__c From Deal_Track__c Where Wave_Plan_Version__c IN: wpvIdList ];
            }
            for(Wave_Plan_Version__c wpvupdate: updateWPVList) {
                if(dealLocMap.containsKey(wpvupdate.id)) {
                    for(Deal_Location__c dealLoc : dealLocMap.get(wpvupdate.id)) {
                        dealLoc.Active__c = false;
                        updatedealLocList.add(dealLoc);
                    }
                }
            }
            for(Deal_Location__c dealLoc : updatedealLocList) {
                if(wavePlanMap.containsKey(dealLoc.Id)) {
                    for(Wave_Planning__c wavePlan : wavePlanMap.get(dealLoc.Id)) {
                        wavePlan.Active__c = false;
                        updatedWavePlanList.add(wavePlan);
                    }
                }
            }
            if(!trackDealList.isEmpty()) {
                Database.Deleteresult [] lsr = Database.delete(trackDealList,false);
            }
            if(!updateWPVList.isEmpty()) {
                Database.Saveresult [] lsr = Database.update(updateWPVList, false);
            }
            if(!updatedealLocList.isEmpty()) {
                Database.Saveresult [] lsr = Database.update(updatedealLocList, false);
            }
            if(!updatedWavePlanList.isEmpty()) {
                Database.Saveresult [] lsr = Database.update(updatedWavePlanList, false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_DEACTIVATE_WPV_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR); 
        }
    }
    /*
    *   @Method : sendEmail
    *   @ Description : This method used to Send Email once the New Wave Plan Version Created
    */
    private static void sendEmail(Wave_Plan_Version__c wpvRec) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {wpvRec.deal__r.Governance_Lead_Name_New__r.SFDC_User__r.email,wpvRec.deal__r.owner.email}; 
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('TGP Support');
            mail.setSubject('New revision of High Level Mobilization Plan created.');
            mail.setHtmlBody('Hello,<br/>' +
            'New revision of High Level Mobilization Plan <b>' + wpvRec.name +
            '</b> of the  deal <b>'+ wpvRec.deal__r.name + '</b> is created.<br/>' +
            'Regards, <br/>' +
            'TGP Support Team'); 
            mail.saveAsActivity=false;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
        catch(System.EmailException ex) {
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_MWB, CLASS_NAME, METHOD_SEND_EMAIL, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
}