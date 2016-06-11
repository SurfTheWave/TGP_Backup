/**
   @Author         : Komal Priya
   @name           : VFC_LinkToSAPOMController
   @CreateDate     : 22 December 2014
   @Description    : Controller Class for VFP_LinkToSAPOM Page
   @Version        : 1.0
  */
public class VFC_LinkToSAPOMController {
    private integer counter = UtilConstants.IntZERO; //keeps track of the offset
    private integer list_size = 5; //sets the page size or number of rows
    public integer total_size; //used to show user the total size of the list
    public integer CurrentPage;
    public String sheetThrowingException = UtilConstants.EMPTY_STRING;
    public String soqlQuery {
        get;
        set;
    }
    public List < Opportunity > rTrackingPageSize {
        get;
        set;
    }
    public Boolean disablePrevious1 {
        get;
        set;
    }
    public Boolean disableNext1 {
        get;
        set;
    }
    public List < Opportunity > ListOfSelectedSAPOM {
        get;
        set;
    }
    public Boolean selectedSection {
        get;
        set;
    }
    public String sapOMFieldValue;
    public String oppRecordToUpdate;
    public String selectedId;
    Public Integer size {
        get;
        set;
    }
    Public Integer noOfRecords {
        get;
        set;
    }

    public ApexPages.StandardSetController con {
        get {
            System_User_Id__c sysUserCS = System_User_Id__c.getValues(UtilConstants.SYSTEM_ID);
            oppRecordToUpdate = Apexpages.currentPage().getParameters().get(UtilConstants.OPPID);
            //system.debug('--oppRecordToUpdate------'+oppRecordToUpdate);
            if (String.isEmpty(sapOMFieldValue)) {
                soqlQuery = UtilConstants.SOQL_STRING4;
            } else {
                soqlQuery = UtilConstants.SOQL_STRING5;
            }
            if (con == null) {
                size = 5;
                con = new ApexPages.StandardSetController(Database.getQueryLocator(soqlQuery + UtilConstants.LIMIT_1000));
                con.setPageSize(size); // sets the number of records in each page set
                noOfRecords = con.getResultSize();
                //system.debug('----noOfRecords----'+noOfRecords);
            }
            return con;
        }
        set;
    }
    /**
     *  @Description          : This method is get method
     *  @name                 : getListOfSAPOM
     *  @param                : null
     *  @return parameter     : List of Oppty
     */
    public List < Opportunity > getListOfSAPOM() {
        List < Opportunity > ListOfSAPOM = new List < Opportunity > ();
        try{
            for (Opportunity oppRec: (List < Opportunity > ) con.getRecords()) {
                ListOfSAPOM.add(oppRec);
            }
            return ListOfSAPOM;
        }catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstants.PAGE_MSG_4 + ex.getMessage()));
            return null;
        }
    }
    /**
     *  @Description          : This method is used to get and display selected opportunity
     *  @name                 : searchSelectedSAPOM
     *  @param                : null
     *  @return parameter     : PageReference
     *  @throws exception     : DML Exception
     */
    public void callSelect() {        
        selectedSection = true;
        selectedId = Apexpages.currentPage().getParameters().get(UtilConstants.SELECTED_ID);
        try{
            ListOfSelectedSAPOM = [select id, name, SAP_OM_ID__c, Opportunity_Solution_Lead__r.name,IO_Solution_Architect__r.name, IC_Solution_Architect__r.name, Account.name, LastModifiedDate, LastModifiedBy.name from opportunity WHERE id = : selectedId LIMIT 1];
            //system.debug('------------ListOfSelectedSAPOM----'+ListOfSelectedSAPOM);
            if (ListOfSelectedSAPOM.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstants.PAGE_MSG_67));
            } 
        }catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstants.PAGE_MSG_4 + ex.getMessage()));
            //return null;
        }       
    }
    /**
     *  @Description          : This method is used to search selected opportunity
     *  @name                 : searchSelectedSAPOM
     *  @param                : null
     *  @return parameter     : PageReference
     *  @throws exception     : DML Exception
     */
    public void searchSelectedSAPOM() {        
        selectedSection = false;
        String selectedSearchId = Apexpages.currentPage().getParameters().get(UtilConstants.SEARCH_ID);
        try{
            sapOMFieldValue = selectedSearchId;
            con = null;
        }catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstants.PAGE_MSG_4 + ex.getMessage()));
            //return null;
        }        
    }
    /**
     *  @Description          : This method is used to Link an sap om opportunity with an existing opportunity
     *  @name                 : doLink
     *  @param                : null
     *  @return parameter     : PageReference
     *  @throws exception     : DML Exception
     */
    public PageReference doLink() {
        List < Opportunity > finalOppListToupdate = new List < Opportunity > ();
        List < Opportunity > OppOldListToupdate = new List < Opportunity > ();
        Map < String, Solution_Scope__c > OppMapToupdate = new Map < String, Solution_Scope__c > ();
        List < Opportunity_Additional_Team__c > oppAddTeamToUpdate = new List < Opportunity_Additional_Team__c > ();
        //List<Opportunity_Additional_Team__c> oppAddTeamToDelete = new List<Opportunity_Additional_Team__c>();
        List < Solution_Scope__c > solComToUpdate = new List < Solution_Scope__c > ();
        List < Solution_Scope__c > solComToInsert = new List < Solution_Scope__c > ();
        
        opportunity SelectedOpportunity;
        
        opportunity oppRecToUpdate;
        String oppOldOwnerName;
        String queryString = UtilConstants.SOQL_STRING;
        for (Schema.FieldSetMember fld: SObjectType.Opportunity.FieldSets.Opportunity_Field_Set.getFields()) {
            queryString += UtilConstants.COMMA_STRING + fld.getFieldPath();
        }
        queryString += UtilConstants.SOQL_STRING6;

        if (!String.isBlank(oppRecordToUpdate)) {
            oppRecToUpdate = database.query(queryString + UtilConstants.blackslashescapequotes + oppRecordToUpdate + UtilConstants.blackslashescapequotes + UtilConstants.SOQL2);
        }
        if (!String.isBlank(selectedId)) {
            SelectedOpportunity = database.query(queryString + UtilConstants.blackslashescapequotes + selectedId + UtilConstants.blackslashescapequotes + UtilConstants.SOQL2);
        }
        if(oppRecToUpdate != null){
            if (!oppRecToUpdate.Solution_Components__r.isEmpty()) {
                for (Solution_Scope__c solCompRec: oppRecToUpdate.Solution_Components__r) {
    
                    OppMapToupdate.put(solCompRec.Offering_Master__c + solCompRec.Solution_Component__c, solCompRec);
                }
            }
        }

        /*set<Id> solCompIdSet = new set<Id>();
        if(oppRecToUpdate.Solution_Components__r.size() > 0 ){
        
                for(Solution_Scope__c solComp : oppRecToUpdate.Solution_Components__r){
                        solCompIdSet.add(solComp.Offering_Master__c);
                     }
        
        }
        List<String> idList = new List<String>();
        for(ID idRec : solCompIdSet){
                
                        idList.add('\''+idRec+'\'');
                
        }
       String queryString1 = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.Opportunity.FieldSets.Opportunity_Field_Set.getFields()) {
         queryString1 += ', ' + fld.getFieldPath();
        }
        
        queryString1 += ',(select id,name,Opportunity__c,Offering_Master__c from Solution_Components__r where Offering_Master__c NOT IN '+ idList +') from Opportunity where id =  '; 

        if(!String.isBlank(selectedId)){
                SelectedOpportunity =  database.query(queryString1+ '\'' + selectedId+'\''+' LIMIT 1');
        }*/

        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        PageReference pg = new PageReference(baseUrl + UtilConstants.SLASH_OPRTR + oppRecordToUpdate);

        list < OpportunityShare > oppShareRecList = new list < OpportunityShare > ();
        Integer Count = UtilConstants.IntZERO;
        if (oppRecToUpdate != null && SelectedOpportunity != null) {

            oppOldOwnerName = oppRecToUpdate.ownerID;
            oppRecToUpdate.SAP_OM_ID__c = SelectedOpportunity.SAP_OM_ID__c;
            oppRecToUpdate.BPO_Total_CCI__c = SelectedOpportunity.BPO_Total_CCI__c;
             // By diwanshu
            if(SelectedOpportunity.SAP_OM_ID__c!=null){
            id sapid=[Select id from SAP_OM_Staging__c where Opportunity_id__c=:SelectedOpportunity.SAP_OM_ID__c].id;
            oppRecToUpdate.SAP_OM_Item_Id__c = sapid;//Added by diwanshu for sap om item id updation id
            } 
            else {
           }
            //by diwanshu
            oppRecToUpdate.BPO_Total_CCI_Per__c = SelectedOpportunity.BPO_Total_CCI_Per__c;
            oppRecToUpdate.BPO_Net_Rev__c = SelectedOpportunity.BPO_Net_Rev__c;
            oppRecToUpdate.IO_Net_Rev_SAP_OM_Thousands__c = SelectedOpportunity.IO_Net_Rev_SAP_OM_Thousands__c;
            oppRecToUpdate.IC_Net_Revenue_SAP_OM_Thousands__c = SelectedOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c;
            oppRecToUpdate.Competitive_Sole_Source__c = SelectedOpportunity.Competitive_Sole_Source__c;
            oppRecToUpdate.ownerID = userinfo.getuserid();
            oppRecToUpdate.Name = SelectedOpportunity.Name;
            oppRecToUpdate.StageName = SelectedOpportunity.StageName;
            oppRecToUpdate.AccountID = SelectedOpportunity.AccountID;
            oppRecToUpdate.Competitor__c = SelectedOpportunity.competitor__c;
            oppRecToUpdate.Contract_Extension_Flag__c = SelectedOpportunity.Contract_Extension_Flag__c;
            oppRecToUpdate.CR_Name__c = SelectedOpportunity.CR_name__c;
            oppRecToUpdate.CSG__c = SelectedOpportunity.CSG__c;
            oppRecToUpdate.Deal_Total_CCI__c = SelectedOpportunity.Deal_Total_CCI__c;
            oppRecToUpdate.Deal_Total_CCI_Per__c = SelectedOpportunity.Deal_Total_CCI_Per__c;
            oppRecToUpdate.Delivery_Centers__c = SelectedOpportunity.Delivery_Centers__c;
            oppRecToUpdate.ECSD_Quarter__c = SelectedOpportunity.ECSD_quarter__c;
            oppRecToUpdate.Function_Business_Services__c = SelectedOpportunity.function_business_services__c;
            oppRecToUpdate.Geo_Area__c = SelectedOpportunity.geo_area__c;
            oppRecToUpdate.Geo_Unit__c = SelectedOpportunity.geo_unit__c;
            oppRecToUpdate.Industry_Business_Services__c = SelectedOpportunity.Industry_Business_Services__c;
            oppRecToUpdate.Industry_Segment__c = SelectedOpportunity.industry_segment__c;
            oppRecToUpdate.Master_Client_Class__c = SelectedOpportunity.master_client_class__c;
            oppRecToUpdate.Mergers_Acquisitions__c = SelectedOpportunity.mergers_acquisitions__c;
            oppRecToUpdate.OperatingGroup__c = SelectedOpportunity.OperatingGroup__c;
            oppRecToUpdate.Operating_Unit__c = SelectedOpportunity.Operating_Unit__c;
            oppRecToUpdate.Pricing_Structure__c = SelectedOpportunity.pricing_structure__c;
            oppRecToUpdate.Primary_Work_Location__c = SelectedOpportunity.primary_work_location__c;
            oppRecToUpdate.Reason__c = SelectedOpportunity.Reason__c;
            oppRecToUpdate.Reporting_Status__c = SelectedOpportunity.reporting_status__c;
            oppRecToUpdate.Restricted__c = SelectedOpportunity.restricted__c;
            oppRecToUpdate.RSD_Quarter__c = SelectedOpportunity.RSD_Quarter__c;
            oppRecToUpdate.Sales_Forecast_Watch__c = SelectedOpportunity.sales_forecast_watch__c;
            oppRecToUpdate.Sub_CSG__c = SelectedOpportunity.sub_CSG__c;
            oppRecToUpdate.Target_Margin_Per__c = SelectedOpportunity.Target_Margin_Per__c;
            oppRecToUpdate.Total_CCI_Per__c = SelectedOpportunity.Total_CCI_Per__c;
            oppRecToUpdate.Total_Current_Net_Rev__c = SelectedOpportunity.Total_Current_Net_Rev__c;
            oppRecToUpdate.Total_Sol_Contingency_Amt__c = SelectedOpportunity.Total_Sol_Contingency_Amt__c;
            oppRecToUpdate.Total_Sol_Contingency_Per__c = SelectedOpportunity.Total_Sol_Contingency_Per__c;
            oppRecToUpdate.Probability = SelectedOpportunity.Probability;
            oppRecToUpdate.Winning_Competitor__c = SelectedOpportunity.winning_competitor__c;
            oppRecToUpdate.Third_Party_Adv__c = SelectedOpportunity.Third_Party_Adv__c;
            oppRecToUpdate.Create_Date_SAP__c = SelectedOpportunity.create_date_SAP__c;
            oppRecToUpdate.Expected_Contract_Signing_Date__c = SelectedOpportunity.expected_contract_signing_date__c;
            oppRecToUpdate.Pipeline_Entry_Date__c = SelectedOpportunity.pipeline_entry_date__c;
            oppRecToUpdate.Proposal_Submission_Date__c = SelectedOpportunity.proposal_submission_date__c;
            oppRecToUpdate.Stage_Update_Date__c = SelectedOpportunity.stage_update_date__c;
            oppRecToUpdate.SAP_Modified_Date__c = system.today();
            oppRecToUpdate.Master_Client_Name__c = SelectedOpportunity.Master_Client_Name__c;
            oppRecToUpdate.ParentOpp__c = SelectedOpportunity.ParentOpp__c;
            oppRecToUpdate.Confidential_Opp__c = SelectedOpportunity.Confidential_Opp__c;

			//added as pat of 826
            oppRecToUpdate.IC_Net_Rev_Thousands__c = SelectedOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c;
            oppRecToUpdate.IO_Net_Revenue_Thousands__c=SelectedOpportunity.IO_Net_Rev_SAP_OM_Thousands__c;
            oppRecToUpdate.BPO_Net_Rev_Thousands__c=SelectedOpportunity.BPO_Net_Rev__c;
            
            SelectedOpportunity.Active__c = false;
            SelectedOpportunity.SAP_OM_ID__c = null;            
            SelectedOpportunity.SAP_OM_Id_Dev__c = SelectedOpportunity.SAP_OM_ID__c;


            if (oppRecToUpdate.Opportunity_Team__r.size() > 0) {
                for (Opportunity_Teams__c oppTeamRec: oppRecToUpdate.Opportunity_Team__r) {
                    if (oppTeamRec.Opportunity_Team_Member__r.user__c == oppOldOwnerName && oppTeamRec.Role__r.HaveEditAccessOnOpportunity__c == true) {
                        Count++;
                    }
                }

            }
            //system.debug('-------Count>0-----'+Count);
            if (Count > 0) {
                if (oppRecToUpdate.ownerID != oppOldOwnerName) {
                    OpportunityShare oppShareRec = new OpportunityShare();
                    oppShareRec.OpportunityId = oppRecToUpdate.id;
                    oppShareRec.UserOrGroupId = oppOldOwnerName;
                    oppShareRec.OpportunityAccessLevel = UtilConstants.EDIT_VALUE;
                    oppShareRec.RowCause = UtilConstants.MANUAL;
                    oppShareRecList.add(oppShareRec);
                }
            }

            OppOldListToupdate.add(SelectedOpportunity);
            finalOppListToupdate.add(oppRecToUpdate);
        }

        for (Solution_Scope__c solCompRecToUpdate: SelectedOpportunity.Solution_Components__r) {

            if (OppMapToupdate.containsKey(solCompRecToUpdate.Offering_Master__c + solCompRecToUpdate.Solution_Component__c)) {

                //system.debug('------solCompRecToUpdate.Offering_Master__c+solCompRecToUpdate.Solution_Component__c------'+solCompRecToUpdate.Offering_Master__c+solCompRecToUpdate.Solution_Component__c);
                OppMapToupdate.get(solCompRecToUpdate.Offering_Master__c + solCompRecToUpdate.Solution_Component__c).SAP_Offering_Revenue__c = solCompRecToUpdate.SAP_Offering_Revenue__c;
                OppMapToupdate.get(solCompRecToUpdate.Offering_Master__c + solCompRecToUpdate.Solution_Component__c).Service_Group__c = solCompRecToUpdate.Service_Group__c;
                solComToUpdate.add(OppMapToupdate.get(solCompRecToUpdate.Offering_Master__c + solCompRecToUpdate.Solution_Component__c));

            } else {
                //system.debug('------solCompRecToUpdate.Offering_Master__c+solCompRecToUpdate.Solution_Component__c---in else---'+solCompRecToUpdate.Offering_Master__c+solCompRecToUpdate.Solution_Component__c);
                Solution_Scope__c solScope = new Solution_Scope__c();
                solScope.Opportunity__c = oppRecToUpdate.id;
                solScope.Offering_Master__c = solCompRecToUpdate.Offering_Master__c;
                solScope.Solution_Component__c = solCompRecToUpdate.Solution_Component__c;
                solScope.SAP_Offering_Revenue__c = solCompRecToUpdate.SAP_Offering_Revenue__c;
                solScope.Service_Group__c = solCompRecToUpdate.Service_Group__c;
                solScope.IsUserAddedOffering__c = false;

                solComToInsert.add(solScope);

            }

        }

        /*for(Opportunity_Additional_Team__c oppAddRecToDelete : oppRecToUpdate.Opportunity_Additional_Team__r){
                oppAddTeamToDelete.add(oppAddRecToDelete);
            }*/
        List < Opportunity_Additional_Team__c > selectedAddTeamList = [SELECT Id, Name, Opportunity__c, Additional_Opportunity_Role__c,
        Additional_Opportunity_Team_Member__c, Active__c, Service_Group__c,
        Old_SF_ID__c FROM Opportunity_Additional_Team__c where Opportunity__c = : SelectedOpportunity.id and Additional_Opportunity_Role__r.ShouldBePopulatedFromSAP__c = true Limit 5000];

        List < Opportunity_Additional_Team__c > AddTeamList = [SELECT Id, Name, Opportunity__c, Additional_Opportunity_Role__c,
        Additional_Opportunity_Team_Member__c, Active__c, Service_Group__c,
        Old_SF_ID__c FROM Opportunity_Additional_Team__c where Opportunity__c = : oppRecToUpdate.id and Additional_Opportunity_Role__r.ShouldBePopulatedFromSAP__c = true Limit 5000];

        Record_Type_ID__c myCS = Record_Type_ID__c.getValues(UtilConstants.SAPUPDATE_ID);
        String myCCVal = myCS.ID__c;

        for (Opportunity_Additional_Team__c addteamRec: AddTeamList) {
            for (Opportunity_Additional_Team__c addTeam: selectedAddTeamList) {
                if (addteamRec.Additional_Opportunity_Role__c == addTeam.Additional_Opportunity_Role__c) {
                    addteamRec.Active__c = addTeam.Active__c;
                    addteamRec.Additional_Opportunity_Team_Member__c = addTeam.Additional_Opportunity_Team_Member__c;
                    addteamRec.Service_Group__c = addTeam.Service_Group__c;
                    addteamRec.RecordTypeId = myCCVal;
                    oppAddTeamToUpdate.add(addteamRec);

                }
            }
        }
        //system.debug('------oppAddTeamToUpdate------'+oppAddTeamToUpdate);

        /*for(Opportunity_Additional_Team__c oppAddteamRec : SelectedOpportunity.Opportunity_Additional_Team__r){
                oppAddteamRec.Opportunity__c = oppRecToUpdate.id;
                oppAddTeamToUpdate.add(oppAddteamRec);
            }*/

        system.debug('------solComToUpdate------'+solComToUpdate);
        system.debug('------solComToInsert------'+solComToInsert);
        try {
            update solComToUpdate;
            insert solComToInsert;
            update OppOldListToupdate;
            update finalOppListToupdate;
            insert oppShareRecList;
            //delete oppAddTeamToDelete;
            update oppAddTeamToUpdate;
            return pg;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstants.PAGE_MSG_4 + ex.getMessage()));
            return null;
        }
    }
    // indicates whether there are more records after the current page set.
    /******************************
    Method Name: hasNext 
    Description: indicates whether there are more records after the current page set.
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    // indicates whether there are more records before the current page set.
    /******************************
    Method Name: hasPrevious 
    Description: indicates whether there are more records before the current page set.
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    // returns the page number of the current page set
    /******************************
    Method Name: pageNumber 
    Description: returns the page number of the current page set
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    // returns the first page of records
    /******************************
    Method Name: first
    Description: returns the first page of records
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void first() {
        try {
            con.first();
        } catch (Exception excp) {
            UTIL_LoggingService.logHandledException(excp, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
    }
    // returns the last page of records
    /******************************
    Method Name: last
    Description: returns the last page of records
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void last() {
        try {
            con.last();
        } catch (Exception excp) {
            UTIL_LoggingService.logHandledException(excp, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
    }
    // returns the previous page of records
    /******************************
    Method Name: previous
    Description: returns the previous page of records
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void previous() {
        try {
            con.previous();
            //sheetThrowingException = UtilConstants.EMPTY_STRING;
        } catch (DmlException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            UTIL_LoggingService.logHandledException(e, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
            throw (e);
        }
    }
    // returns the next page of records
    /******************************
    Method Name: next
    Description: returns the next page of records
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void next() {
        try {
            con.next();
            //sheetThrowingException = UtilConstants.EMPTY_STRING;
        } catch (DmlException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            UTIL_LoggingService.logHandledException(e, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
            throw (e);
        }
    }
    /******************************
    Method Name: cancel
    Description: returns the PageReference of the original page, if known, or the home page.
    Paramenters: NA
    Return Value: NA
    *******************************/
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {

        try {
            con.cancel();
        } catch (DmlException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            UTIL_LoggingService.logHandledException(e, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
            throw (e);
        }
    }
    /******************************
    Method Name: cancel
    Description: returns the PageReference of the original page, if known, or the home page.
    Paramenters: NA
    Return Value: NA
    *******************************/
    public pageReference doCancel() {
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        try {
            if (!String.isBlank(oppRecordToUpdate)) {
                PageReference pg = new PageReference(baseUrl + UtilConstants.SLASH + oppRecordToUpdate);
                return pg;
            } else return null;
        } catch (DmlException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            UTIL_LoggingService.logHandledException(e, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS,
            UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
            throw (e);
        }
    }
}