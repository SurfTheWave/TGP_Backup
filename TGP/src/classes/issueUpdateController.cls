/*****************
@author : Sumalatha Ganga
@description : This class handles the auto- populating Fields functionality for Issue object.

*******************/
public with sharing class issueUpdateController {

    public List < Issues__c > issue = new List < Issues__c > ();
    public String CLASS_NAME = UtilConstants.issueclassName;
    private String sql;


    /******************************
    Method Name: populateFieldsAfterInsert
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void populateFieldsAfterInsert(List < Issues__c > issueFieldList) {
        set < Id > issueId = new set < Id > ();
        Map < Id, Issues__c > issueMap = new Map < Id, Issues__c > ();

        //System.debug('issue ' + issueFieldList);
        try {
            KT_Trac__c issueList1 = new KT_Trac__c();
            Recruit_Tracker__c issueList2 = new Recruit_Tracker__c();
            Tech_WE_Tracker__c issueList3 = new Tech_WE_Tracker__c();
            OPEX_Tracker__c issueList4 = new OPEX_Tracker__c();
            SRAT_TRacker__c issueList5 = new SRAT_Tracker__c();
            Procurement_General_Activity_Item__c issueList6 = new Procurement_General_Activity_Item__c();
            Procurement_Quarter_Wise_Activity_Item__c issueList7 = new Procurement_Quarter_Wise_Activity_Item__c();
            Procurement_Region_Wise_Activity_Item__c issueList8 = new Procurement_Region_Wise_Activity_Item__c();
            Procurement_Wave_Region__c issueList9 = new Procurement_Wave_Region__c();
            Budget_Trac__c issueList10 = new Budget_Trac__c();
            Contract_Legal_Tracker__c issueList11 = new Contract_Legal_Tracker__c();
            BCP_Tracker__c issueList12 = new BCP_Tracker__c();
            Service_Management_Tracker__c issueList13 = new Service_Management_Tracker__c();
            Journey_Management_Tracker__c issueList14 = new Journey_Management_Tracker__c();
            wave_proc__c issueList15 = new wave_proc__c();
            wave__c issueList16 = new wave__c();
            Mobilization_Plan__c issueList17 = new Mobilization_Plan__c();
            for (Issues__c issueUpd: issueFieldList) {

                if (issueUpd.kt_trac__c != null) {
                    
                    issueList1 = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM KT_Trac__c WHERE Id = : issueUpd.kt_trac__c LIMIT 1];
                    issueUpd.Wave__c = issueList1.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList1.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList1.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Recruit_Tracker__c != null) {
                    
                    issueList2 = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM Recruit_Tracker__c WHERE ID = : issueUpd.Recruit_Tracker__c LIMIT 1];
                    issueUpd.Wave__c = issueList2.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList2.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList2.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Tech_WE_Tracker__c != null) {
                    
                    issueList3 = [SELECT ID, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM Tech_WE_Tracker__c WHERE Id = : issueUpd.Tech_WE_Tracker__c LIMIT 1];
                    issueUpd.Wave__c = issueList3.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList3.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList3.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.opex_tracker__c != null) {
                    
                    issueList4 = [SELECT ID, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM OPEX_TRacker__c WHERE Id = : issueUpd.opex_tracker__c LIMIT 1];
                    issueUpd.Wave__c = issueList4.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList4.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList4.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.srat_tracker__c != null) {
                    
                    issueList5 = [SELECT ID, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM SRAT_TRacker__c WHERE Id = : issueUpd.srat_tracker__c LIMIT 1];
                    issueUpd.Wave__c = issueList5.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList5.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList5.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Procurement_General_Activity_Item__c != null) {
                    
                    issueList6 = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c 
                                FROM Procurement_General_Activity_Item__c WHERE Id = : issueUpd.Procurement_General_Activity_Item__c LIMIT 1];
                    issueUpd.Wave__c = issueList6.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList6.wave__r.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList6.wave__r.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Procurement_Quarter_Wise_Activity_Item__c != null) {
                    
                    issueList7 = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c 
                                FROM Procurement_Quarter_Wise_Activity_Item__c WHERE Id = : issueUpd.Procurement_Quarter_Wise_Activity_Item__c LIMIT 1];
                    issueUpd.Wave__c = issueList7.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList7.wave__r.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList7.wave__r.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Procurement_Region_Wise_Activity_Item__c != null) {
                    
                    issueList8 = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c 
                                FROM Procurement_Region_Wise_Activity_Item__c WHERE Id = : issueUpd.Procurement_Region_Wise_Activity_Item__c LIMIT 1];
                    issueUpd.Wave__c = issueList8.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList8.wave__r.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList8.wave__r.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Procurement_Wave_Region__c != null) {
                    
                    issueList9 = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c 
                                FROM Procurement_Wave_Region__c WHERE ID = : issueUpd.Procurement_Wave_Region__c LIMIT 1];
                    issueUpd.Wave__c = issueList9.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList9.wave__r.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList9.wave__r.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Budget_Trac__c != null) {
                    
                    issueList10 = [SELECT Id, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM Budget_Trac__c WHERE ID = : issueUpd.Budget_Trac__c LIMIT 1];
                    issueUpd.Mobilization_Plan__c = issueList10.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList10.Mobilization_Plan__r.Deal__c;
                    //issue.add(issueUpd);                 
                } else if (issueUpd.Contract_Legal_Tracker__c <> null) {
                    
                    issueList11 = [SELECT Id, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM Contract_Legal_Tracker__c WHERE ID = : issueUpd.Contract_Legal_Tracker__c LIMIT 1];
                    issueUpd.Mobilization_Plan__c = issueList11.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList11.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.BCP_Tracker__c <> null) {
                    
                    issueList12 = [SELECT Id, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM BCP_Tracker__c WHERE ID = : issueUpd.BCP_Tracker__c LIMIT 1];
                    issueUpd.Mobilization_Plan__c = issueList12.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList12.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Service_Mgmt_Tracker__c <> null) {
                    
                    issueList13 = [SELECT Id, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM Service_Management_Tracker__c WHERE ID = : issueUpd.Service_Mgmt_Tracker__c LIMIT 1];
                    issueUpd.Mobilization_Plan__c = issueList13.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList13.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Journey_Management_Tracker__c <> null) {
                    
                    issueList14 = [SELECT Id, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                    FROM Journey_Management_Tracker__c WHERE ID = : issueUpd.Journey_Management_Tracker__c LIMIT 1];
                    issueUpd.Mobilization_Plan__c = issueList14.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList14.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.wave_proc__c <> null) {
                    
                    issueList15 = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                    FROM wave_proc__c WHERE ID = : issueUpd.wave_proc__c LIMIT 1];
                    issueUpd.Wave__c = issueList15.Wave__c;
                    issueUpd.Mobilization_Plan__c = issueList15.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList15.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.wave__c <> null) {
                    
                    issueList16 = [SELECT Id, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                    FROM wave__c WHERE ID = : issueUpd.wave__c LIMIT 1];
                    issueUpd.Mobilization_Plan__c = issueList16.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList16.Mobilization_Plan__r.Deal__c;
                } else if (issueUpd.Mobilization_Plan__c <> null) {
                    
                    issueList17 = [SELECT Id, Deal__c FROM Mobilization_Plan__c WHERE ID = : issueUpd.Mobilization_Plan__c LIMIT 1];
                    //issueUpd.Mobilization_Plan__c = issueList.Mobilization_Plan__c;
                    issueUpd.Deal__c = issueList17.Deal__c;
                } else {}

            }
        } catch (Exception ex) {
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB, CLASS_NAME, CLASS_NAME,
            null, System.Logginglevel.ERROR);

        }
    }
    /*****************
    @description : This method will auto - populate fields on Issue Object
   
    public void populateFieldsAfterInsert(List<Issues__c> issueFieldList){
        set<Id> issueId=new set<Id>();
        
        for(Issues__c issueList:issueFieldList){
            issueId.add(issueList.id);
       
        }
       try{
           for(Issues__c issuesList:  [SELECT id,Module__c,kt_trac__c,bcp_tracker__c,KT_Trac__r.Wave__c,KT_Trac__r.Mobilization_Plan__c,KT_Trac__r.Mobilization_Plan__r.Deal__c,
                                    Recruit_Tracker__r.Wave__c,Recruit_Tracker__r.Mobilization_Plan__c,Recruit_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    Tech_WE_Tracker__r.Wave__c,Tech_WE_Tracker__r.Mobilization_Plan__c,Tech_WE_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    srat_tracker__r.Wave__c,srat_tracker__r.Mobilization_Plan__c,srat_tracker__r.Mobilization_Plan__r.Deal__c,
                                    opex_tracker__r.Wave__c,opex_tracker__r.Mobilization_Plan__c,opex_tracker__r.Mobilization_Plan__r.Deal__c,
                                    Procurement_General_Activity_Item__r.wave__c,Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__c,
                                       Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c,
                                    Procurement_Quarter_Wise_Activity_Item__r.wave__c,Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c,
                                       Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c,
                                    Procurement_Region_Wise_Activity_Item__r.wave__c,Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c,
                                       Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c,
                                    Procurement_Wave_Region__r.wave__c,Procurement_Wave_Region__r.wave__r.Mobilization_Plan__c,
                                       Procurement_Wave_Region__r.wave__r.Mobilization_Plan__r.Deal__c,
                                    
                                    Budget_Trac__r.Mobilization_Plan__c,Budget_Trac__r.Mobilization_Plan__r.Deal__c,
                                    Contract_Legal_Tracker__r.Mobilization_Plan__c,Contract_Legal_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    BCP_Tracker__r.Mobilization_Plan__c,BCP_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    Service_Mgmt_Tracker__r.Mobilization_Plan__c,Service_Mgmt_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    Journey_Management_Tracker__r.Mobilization_Plan__c,Journey_Management_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    Wave_proc__r.Wave__c,Wave_proc__r.Mobilization_Plan__c,wave_proc__r.Mobilization_Plan__r.Deal__c,
                                    wave__r.Mobilization_Plan__c,wave__r.Mobilization_Plan__r.Deal__c,
                                    Mobilization_Plan__r.Deal__c from Issues__c where id in: issueId Limit 5000] ){
           
                if(issuesList.kt_trac__c != null){
                     issuesList.Wave__c = issuesList.KT_Trac__r.Wave__c;
                     issuesList.Mobilization_Plan__c = issuesList.KT_Trac__r.Mobilization_Plan__c;
                     issuesList.Deal__c = issuesList.KT_Trac__r.Mobilization_Plan__r.Deal__c;
                     issue.add(issuesList);
                    }else if(issuesList.Recruit_Tracker__c != null){                
                    issuesList.Wave__c = issuesList.Recruit_Tracker__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.Recruit_Tracker__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Recruit_Tracker__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);
                }else if(issuesList.Tech_WE_Tracker__c != null){
                    issuesList.Wave__c = issuesList.Tech_WE_Tracker__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.Tech_WE_Tracker__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Tech_WE_Tracker__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.opex_tracker__c != null){                   
                    issuesList.Wave__c = issuesList.opex_tracker__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.opex_tracker__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.opex_tracker__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);
                }else if(issuesList.srat_tracker__c != null){
                    issuesList.Wave__c = issuesList.srat_tracker__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.srat_tracker__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.srat_tracker__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Procurement_General_Activity_Item__c != null){
                    issuesList.Wave__c = issuesList.Procurement_General_Activity_Item__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Procurement_Quarter_Wise_Activity_Item__c != null){
                    issuesList.Wave__c = issuesList.Procurement_Quarter_Wise_Activity_Item__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Procurement_Region_Wise_Activity_Item__c != null){
                    issuesList.Wave__c = issuesList.Procurement_Region_Wise_Activity_Item__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Procurement_Wave_Region__c != null){
                    issuesList.Wave__c = issuesList.Procurement_Wave_Region__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.Procurement_Wave_Region__r.wave__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Procurement_Wave_Region__r.wave__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Budget_Trac__c != null){
                    issuesList.Mobilization_Plan__c = issuesList.Budget_Trac__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Budget_Trac__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Contract_Legal_Tracker__c != null){
                    issuesList.Mobilization_Plan__c = issuesList.Contract_Legal_Tracker__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Contract_Legal_Tracker__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.BCP_Tracker__c != null){
                    issuesList.Mobilization_Plan__c = issuesList.BCP_Tracker__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.BCP_Tracker__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Service_Mgmt_Tracker__c != null){
                    issuesList.Mobilization_Plan__c = issuesList.Service_Mgmt_Tracker__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Service_Mgmt_Tracker__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Journey_Management_Tracker__c != null){
                    issuesList.Mobilization_Plan__c = issuesList.Journey_Management_Tracker__r.Mobilization_Plan__c;
                    issuesList.Deal__c = issuesList.Journey_Management_Tracker__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.wave_proc__c != null){
                    issuesList.Wave__c = issuesList.Wave_proc__r.Wave__c;
                    issuesList.Mobilization_Plan__c = issuesList.Wave_proc__r.Mobilization_Plan__c;              
                    issuesList.Deal__c = issuesList.wave_proc__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);  
                }else if(issuesList.wave__c != null){
                    issuesList.Mobilization_Plan__c = issuesList.wave__r.Mobilization_Plan__c;              
                    issuesList.Deal__c = issuesList.wave__r.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }else if(issuesList.Mobilization_Plan__c != null){
                    issuesList.Deal__c = issuesList.Mobilization_Plan__r.Deal__c;
                    issue.add(issuesList);                  
                }
                else{
                                            
                }
            
           }
           Database.SaveResult[] srList = Database.update(issue,false);          
    
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                   // System.debug('Successfully inserted Issue. Issue ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                       // System.debug('The following error has occurred.');                    
                       // System.debug(err.getStatusCode() + ': ' + err.getMessage());
                       // System.debug('issue fields that affected this error: ' + err.getFields());
                    }
                }       
            }
       }catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,CLASS_NAME, CLASS_NAME, 
                   null, System.Logginglevel.ERROR);
            
       }
        
       }
       
       *****************/


}