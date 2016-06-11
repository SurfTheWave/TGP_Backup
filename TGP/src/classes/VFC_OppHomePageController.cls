/*
@Author : Shoukath Shaik 
@name : VFC_OppHomePageController 
@CreateDate : 1/8/2015 8:03 AM
@Description : 
@Version : 33.0
*/
public without sharing class VFC_OppHomePageController {
    public String RunningUser;
    public String RunningUseremail;
    Public Integer noOfRecords {
        get;
        set;
    }
    Public Integer size {
        get;
        set;
    }
    public string queryString {
        get;
        set;
    }
    public String reportstat {
        get;
        set;
    }
    public string sortDir {
        set;
        get;
    }
    /******************************
    Method Name: getReportingStatus
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List < SelectOption > getReportingStatus() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(UtilConstants.EMPTY_STRING, UtilConstants.ALL_HDCODE));
        
        options.add(new SelectOption(UtilConstants.Accenture_withdrew, UtilConstants.Accenture_withdrew));
        options.add(new SelectOption(UtilConstants.Client_withdrew, UtilConstants.Client_withdrew));
         options.add(new SelectOption(UtilConstants.Lost, UtilConstants.Lost));
        options.add(new SelectOption(UtilConstants.Pipeline_unqualified, UtilConstants.PIPELINE));
        options.add(new SelectOption(UtilConstants.UNQUALIFIED, UtilConstants.UNQUALIFIED));
          String s=UtilConstants.Pipeline_unqualified+UtilConstants.Pipeline_unqualified1;
        options.add(new SelectOption(s, UtilConstants.PipelineplusUnqualified));
        
       options.add(new SelectOption(UtilConstants.WON, UtilConstants.WON));
        options.add(new SelectOption(UtilConstants.Closed_duplicate, UtilConstants.Closed_duplicate));
        
       /* Schema.DescribeFieldResult fieldResult = opportunity.Reporting_Status__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: ple)
        options.add(new SelectOption(p.getValue(), p.getLabel()));*/
        return options;
    }

    /******************************
    Method Name: myMethod
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    Public void myMethod() {
        setCon = null;
        getSolList();
    }
    /******************************
    Method Name: VFC_OppHomePageController
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public VFC_OppHomePageController() {
        reportstat = UtilConstants.EMPTY_STRING;
        sortDir = UtilConstants.Description;
        RunningUser = UserInfo.getUserId();
        RunningUseremail = userinfo.getUserEmail();

    }
    /******************************
    Method Name: setCon 
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public ApexPages.StandardSetController setCon {
        get {
            size = 10;
            set < id > oppids = new set < id > ();
            /*roles = new List<string>{Label.Opportunity_Solution_Lead,label.Complex_Cost_Architect,label.Solution_Specialist,label.Offering_Solution_Lead_Primary,
                                    label.Offering_Solution_Lead_Secondary,label.IO_Solution_Architect,label.IC_Solution_Architect};*/
            if (setCon == null) {
                // if(reportstat != '' && reportstat != null){
                /* queryString = 'SELECT id,Name,SAP_OM_Id_Dev__c,SAP_OM_ID__c,Off__C,'+
                                        'Opportunity_Solution_Lead__r.name,Account.Name,'+
                                        'Staffing_Status__c,'+'Reporting_Status__c,'+
                                        'Latest_Comment__c,( select User_Role_s__c from Utilization__r )' +
                                        ' from Opportunity '+
                                        'where Reporting_Status__c=\''+reportstat+'\''+' Order by SAP_OM_ID__c '+sortDir+' LIMIT 10000';*/
                //+ ' AND ' + 'where  Created By Id = \''+ 'Userinfo.getuserId'+'\''+'';
                //}
                //else{
                for (Opportunity_Teams__c opp: [select opportunity__c from Opportunity_Teams__c where Opportunity_Team_Member__r.user__c = : userinfo.getUserid() Limit 5000]) {
                    oppids.add(opp.opportunity__c);
                }
                /* queryString = 'SELECT id,Name,SAP_OM_Id_Dev__c,SAP_OM_ID__c,Off__C,'+
                                        'Opportunity_Solution_Lead__r.name,Account.Name,'+
                                        'Staffing_Status__c,Reporting_Status__c,Latest_Comment__c,'+
                                        ' (select role__r.name from Opportunity_team__r  where Opportunity_Team_Member__r.user__c=\''+ Userinfo.getuserId()+'\' ) '+''+'from Opportunity where ID IN:oppids Order by sap_om_id__c '+sortDir+' LIMIT 10000';*/
                // }
                queryString = UtilConstants.SOQL_STRING9 + + UtilConstants.SOQL_STRING10;
                //system.debug('reportstat ---'+reportstat );
                if (reportstat != UtilConstants.EMPTY_STRING && reportstat != null && reportstat!='PipelineUnqualified') {
                    queryString = queryString + UtilConstants.SOQL_STRING11 + runninguser + UtilConstants.SOQL_STRING12 + reportstat + UtilConstants.blackslashescapequotes;
                } 
                else if(reportstat=='PipelineUnqualified'){             
                 system.debug('>>>>'+reportstat+'inside if');
                 System.debug('?????'+UtilConstants.Pipeline_unqualified);
                
                queryString = queryString + UtilConstants.SOQL_STRING11 + runninguser + UtilConstants.SOQL_STRING100 + UtilConstants.Pipeline_unqualified +UtilConstants.SOQL_STRING101 + UtilConstants.Pipeline_unqualified1 + UtilConstants.blackslashescapequotes+UtilConstants.SOQL_STRING102 ;
                 System.debug('query ----> '+querystring) ; 
                 }
                else {
                    queryString = queryString + UtilConstants.SOQL_STRING11 + runninguser + UtilConstants.SOQL_STRING13;
                }
                //System.debug('query ----> '+querystring) ;                      
                setCon = new ApexPages.StandardSetController(Database.getQuerylocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }
        set;
    }
    /******************************
    Method Name: getSolList
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List < utilizations__c > getSolList() {
        List < utilizations__c > OppTeam = new list < utilizations__c > ();
        for (utilizations__c solRec: (List < utilizations__c > ) setCon.getRecords()) {
            oppteam.add(solRec);
        }
        //System.debug('utilization records:::::;'+oppteam);

        return oppteam;
    }
    /******************************
    Method Name: refresh
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public pageReference refresh() {
        setCon = null;
        getSolList();
        setCon.setPageNumber(1);
        return null;
    }
    /******************************
    Method Name: pageNumber 
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    /******************************
    Method Name: totalPages 
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Integer totalPages {
        get {
            if (math.mod(setCon.getResultSize(), setCon.getPageSize()) == 0) {
                totalPages = setCon.getResultSize() / setCon.getPageSize();
            } else {
                totalPages = 1 + (setCon.getResultSize() / setCon.getPageSize());
            }
            return totalPages;
        }
        set;
    }

    /******************************
    Method Name: first
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void first() {        
         try {
            setCon.first();
        } catch (Exception excp) {
            UTIL_LoggingService.logHandledException(excp, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
    }
    /******************************
    Method Name: last
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void last() {        
        try {
            setCon.last();
        } catch (Exception excp) {
            UTIL_LoggingService.logHandledException(excp, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
    }
    /******************************
    Method Name: previous
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void previous() {
        try {
           setCon.previous();
        } catch (Exception excp) {
            UTIL_LoggingService.logHandledException(excp, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
    }
    /******************************
    Method Name: next
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void next() {        
        try {
           setCon.next();
        } catch (Exception excp) {
            UTIL_LoggingService.logHandledException(excp, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
    }
}