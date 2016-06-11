/*
Author :  Accenture IDC
Story  :  Sol_R1.6_1 
Description : Commercial Data Tab.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

public class Commercial_InlineController{

    public string opportunityId{get;set;}
    public Opportunity_Commerical_Data__c commecricalObj{get;set;}
    public string commercialId{get;set;}
    public String tabFocus{get;set;}
    public boolean editSection {get;set;}
    public Opportunity_Commerical_Data__c newCommercial{get;set;}
    public list<Opportunity_Commerical_Data__c> newCommercialList{get;set;}
    public Opportunity_BenchMark_Data__c newbenchmark{get;set;}    
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean deleteButtonRender{get;set;}
    public Opportunity_TGP__c objOpportunity{get;set;}
    public Commercial_Section_Item__c newLegalSectionItem {get; set;}
    public Commercial_Section_Item__c newRiskSectionItem {get; set;}
    public Commercial_Section_Item__c newActItemSectionItem {get; set;}
    public Commercial_Section_Item__c newNextStepItem {get; set;}
    public Commercial_Section_Item__c newDealActivityItem {get; set;}
    public Boolean refreshPage {get; set;}
    public Boolean readOnlyMode {get; set;}
    public list<Commercial_Section_Item__c> listLegalItemDetails {get;set;}
    public list<Commercial_Section_Item__c> listRiskItemDetails {get;set;}
    public list<Commercial_Section_Item__c> listNextStepItemDetails {get;set;}
    public list<Commercial_Section_Item__c> listActivityItemDetails {get;set;}
    public list<Commercial_Section_Item__c> listActionItemDetails {get;set;}
    public String fileIdDelete;
    public String fileIdDelete1;
    //public Commercial_Document__c commecricalDocObj{get;set;}
    public list<Commercial_Document__c> listCommercialDocs {get;set;}
    public list<Deal_Review_Note__c> listDealReviewNote {get;set;}
    public String selectedApprovalStage{get; set;}    
    public list<Opportunity_Level_Wise_FTE__c> listBPOSE{get; set;}
    public list<Opportunity_OADM_FTE__c>listBPOSEOADM{get; set;}
    public list<Opportunity_Offering_BenchMark_Data__c> listBenchmarkSummary{get; set;}
    public Deal_Review_Note__c dealReviewObj{get; set;}
    public List<Deal_Review_Note__c> tempDealReviewObj{get; set;}
    public Commercial_Document__c comDocObj{get; set;}
    public String CommentsField{get; set;}
    public String CommentsFieldCommercial{get; set;}
    public Boolean booleanPageMessageRender{get;set;}
    public Boolean editButtonPermission{get;set;}
    public Boolean addHideRender {get; set;}
    
    public string solRevApprover{get;set;}
    public string oppQAApprover{get;set;}
    public string transPlanApprover{get;set;}
    public string cdpWorkbookSubmitted{get;set;}
    public string speedAnalysisWB{get;set;}
    public string compRegApprover{get;set;}
    public String CommLeadName {get;set;}
          
    //Uplaod Issue Hareesh
    public Boolean commericalDocPMRender{get;set;}
    public Boolean dealReviewPMRender{get;set;}   
    public Boolean addRiskPageMessage {get;set;}  
    public Boolean addActionItemPageMessage {get; set;}
    public Boolean nextStepPageMessage {get; set;} 
    public Boolean keyActivitiesPageMessage {get; set;}  
    public Boolean addlegalItesmPM {get; set;}       
    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
    public Attachment attachment {
        get {
          if (attachment == null)
            attachment = new Attachment();
          return attachment;
        }
        set;
    }
    public Id SYS_ADMIN_PROFILE_ID;
    
    /******************************
    Method Name: Commercial_InlineController
    Description: Constructor for Commercial_InlineController
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
   public Commercial_InlineController(){
        opportunityId=ApexPages.CurrentPage().getParameters().get('id');
        newCommercialList= new List<Opportunity_Commerical_Data__c>(); 
        newCommercial = new Opportunity_Commerical_Data__c();
        
        newLegalSectionItem = new Commercial_Section_Item__c();
        newRiskSectionItem = new Commercial_Section_Item__c();
        newActItemSectionItem = new Commercial_Section_Item__c();
        newNextStepItem = new Commercial_Section_Item__c();
        newDealActivityItem = new Commercial_Section_Item__c();
        listBPOSE = new List<Opportunity_Level_Wise_FTE__c>();
        listBPOSEOADM = new List<Opportunity_OADM_FTE__c>();
        listBenchmarkSummary = new List<Opportunity_Offering_BenchMark_Data__c>();
        listLegalItemDetails  = new list<Commercial_Section_Item__c>();
        listRiskItemDetails  = new list<Commercial_Section_Item__c>();
        listNextStepItemDetails  = new list<Commercial_Section_Item__c>();
        listActivityItemDetails  = new list<Commercial_Section_Item__c>();
        listActionItemDetails  = new list<Commercial_Section_Item__c>();
        listCommercialDocs  = new list<Commercial_Document__c>();
        listDealReviewNote = new list<Deal_Review_Note__c>();
         
        for(Opportunity_Commerical_Data__c c : [Select c.Value_Outcome_Based_Components__c, c.True_up_period__c, c.True_up_period_Comments__c, c.Transition_Plan_Approver__c, 
                                c.Transition_Fees_at_Risk__c, c.Transition_Fees_at_Risk_Comments__c, c.Transition_Billing_Terms__c, c.Total_Current_Net_Revenue__c, 
                                 c.Third_Party_Advisor__c, c.Targeted_Go_Live__c, c.SystemModstamp, c.Step_in_Rights__c, 
                                c.Step_in_Rights_Comments__c, c.Spend_Analysis_WBApprover_APS_Only__c, c.Sourcing_Total_Avail_Spend__c, c.Sourcing_Total_Addressable_Spend__c, 
                                c.Sourcing_Comments__c, c.Sourcing_Anticipated_Savings__c, c.Solution_Review_Approver__c, c.Solution_Comments__c, c.Service_Levels__c, 
                                c.Seat_Utilization__c, c.SLA_Pool__c, c.SLA_Pool_Comments__c, c.SLA_Fees_at_Risk__c, c.SLA_Fees_at_Risk_Comments__c, c.ROI__c, 
                                c.Proposal_Submission_Date__c, c.Productivity__c, c.Pricing_Structure__c, c.Pricing_Structure_Comments__c, c.Peak_Capital_Balance__c, 
                                 c.PMO_of_Deal_Costs_Comments__c, c.Orals_Date__c, c.Opportunity_TGP__c, c.Opportunity_QA_Approver__c, 
                                c.Opportunity_BenchMark_Data__c, c.OI__c, c.OADM_Level_Location_FTE_Comments__c, c.Number_of_Yellow_1370_Terms__c, c.Number_of_Total_SLAs__c, 
                                c.Number_of_Total_SLAs_Comments__c, c.Number_of_Red_1370_Terms__c, 
                                c.Negotiation_Start_Date__c, c.Name, c.Mobilization_of_TCC_Comments__c, c.Max_SLA_Risk_Allocation__c, 
                                c.Max_SLA_Risk_Allocation_Comments__c, c.Limits_of_Liability_Cap__c, c.Limits_of_Liability_Cap_Comments__c, c.LastModifiedDate, 
                                c.LastModifiedById, c.IsDeleted, c.Invoicing_Terms__c, c.Id, c.IP_Ownership__c, c.IP_Ownership_Comments__c, c.FX__c, 
                                c.Dragnet_Sweeps_Clause__c, c.Dragnet_Sweeps_Clause_Comments__c,c.Downselect_Status_Date__c, c.Disputed_Payments_Months_Fees__c, 
                                c.Disputed_Payments_Comments__c, c.Dedicated_Personnel__c, c.Dedicated_Personnel_Comments__c, c.Deal_Total_CCI__c, 
                                c.Deal_Overview__c,c.Current_FY_CCI__c, c.Critical_Milestones_on_Transitions__c, c.Critical_Milestones_on_Transitions_Comme__c, 
                                c.CreatedDate, c.CreatedById, c.Contract_Term__c, c.Contract_Signature__c, c.Contingency__c, c.Consents__c, c.Consents_Comments__c, 
                                c.Compliance_with_Laws__c, c.Compliance_with_Laws_Comments__c, c.Compliance_Regulatory_Approver__c, c.Competitor__c, c.Comments_on_CCI__c,
                                c.Comment_on_revenue__c, c.Client_Termination_Rights__c, c.Client_Term_Notice_Period__c, c.Client_Term_Notice_Period_Comments__c, 
                                c.Client_Term_Fees__c, c.Client_Term_Fees_Comments__c, c.CPR_Transition__c, c.CPR_RUN__c, c.COLA__c, c.CDP_Workbook_Submitted_Y_N__c,
                                c.Benchmarking__c, c.Benchmarking_Comments__c, c.BPO_Total_CCI__c, c.BPO_Net_Revenue_SD_Estimate__c, c.BPO_Net_Revenue_SAP_OM__c, 
                                c.BPO_Margin_Diff__c,c.Award_Date__c, c.Automatic_Continuous_Improvement_Y_N__c, c.Automatic_Continuous_Improvement_Comment__c, 
                                c.Accenture_Term_Rights__c, c.Accenture_Term_Rights_Comments__c, c.ACN_Transition_Price_FTE__c, c.ACNRUN_Price_FTE__c 
                                From Opportunity_Commerical_Data__c c where Opportunity_TGP__c=:opportunityId order by createddate desc]) {
             newCommercialList.add(c);
            }
        
        try{
        if(newCommercialList != null && newCommercialList.size() > 0) {
            newCommercial = newCommercialList[0];      
        }
        List<Opportunity_BenchMark_Data__c> benchmarkRecord = new List<Opportunity_BenchMark_Data__c>();
        newbenchmark  =  new Opportunity_BenchMark_Data__c();         
        benchmarkRecord = [select ID, Delivery_Locations__c,Languages__c,Mobilization_of_TCC__c,Number_Of_Contractors_Rool_Up__c,Number_of_rebadged_resources_from_client__c,Onshore_Nearshore_Offshore_Split__c,PMO_of_TCC__c, TOTAL_Baseline_SDO_FTEs__c FROM Opportunity_BenchMark_Data__c where Opportunity__c =:opportunityId Limit 1];
        if(benchmarkRecord.Size() > 0) {
            listBPOSEOADM = [select Career_Level__c,OADM_FTEs__c, Country__c from Opportunity_OADM_FTE__c where Opportunity_BenchMark_Data__c =: benchmarkRecord[0].Id ];
            newbenchmark =  benchmarkRecord[0];           
        }
        
        if(benchmarkRecord.Size() > 0) {
            listBenchmarkSummary = [select Sub_Service_Offering__c, Service__c,Sum_of_Baseline_FTEs__c,Costing_Type__c from Opportunity_Offering_BenchMark_Data__c where Opportunity_BenchMark_Data__c =: benchmarkRecord[0].Id and Costing_Type__c = 'SDO'];
        }
        
        commecricalObj = [Select ID from Opportunity_Commerical_Data__c where Opportunity_TGP__c=:opportunityId Limit 1].get(0);
        commercialId=commecricalObj.Id;
        }
        catch(Exception ex){
            
        }
        detailRecordsOfCommercialISections();   
        dealReviewNote();
        documentsCommercial();
        refreshPage=false;
        addButtonRender = true;  //checked
        deleteButtonRender=true;
        editSection = false; 
        readOnlyMode=true;
        addHideRender=true;
        if(addButtonRender==false){
            readOnlyMode=true;
        }
       booleanPageMessageRender=false;
       //Harish
       dealReviewPMRender = false;
       commericalDocPMRender = false;
       addRiskPageMessage = false;
       addActionItemPageMessage = false;
       nextStepPageMessage = false;
       keyActivitiesPageMessage = false;
       addlegalItesmPM = false;
       editButtonPermission=true;
       if(editButtonPermission==true){
            addHideRender=true;
        }
       List<PermissionSetAssignment> lstcurrentUserPerSet = [ SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Name = 'Commercial_Write'];
        
       List<Opportunity_Team__c> lstOppTeam = [select Opportunity_Team_Member__r.SFDC_User__c,Active__c,
                                                BPO_Opportunity__c, Offering__c,Opportunity_Team_Member__c,Roles__c 
                                                from Opportunity_Team__c 
                                                where BPO_Opportunity__c =: opportunityId]; 
                                                
       SYS_ADMIN_PROFILE_ID = [select ProfileId from User where Profile.Name = 'System Administrator' limit 1].ProfileId;                                         

        if(!lstcurrentUserPerSet.isEmpty() || UserInfo.getProfileId().equals(SYS_ADMIN_PROFILE_ID )){
            editButtonPermission = true;
            addHideRender=true;
        }
        else {
            editButtonPermission = false;
            addHideRender=false;
        }
     }
     
     public void updateCommercial() {
        List<Opportunity_Team__c> lstOppTeamCommercial = [select Opportunity_Team_Member__r.name, Opportunity_Team_Member__c 
                                                from Opportunity_Team__c 
                                                where BPO_Opportunity__c =: opportunityId And Roles__r.name = 'Commercial Team' ];                                         
                                                 
       if(lstOppTeamCommercial.size()>0){
        CommLeadName = lstOppTeamCommercial[0].Opportunity_Team_Member__r.name;                     
       }  
     
     }
    
    /******************************
    Method Name: addLegalSectionItems
    Description: Add button For Legal Section
    Paramenters: NA
    Return Value: PageReference
    *******************************/
   public PageReference addLegalSectionItems(){
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        if(String.isBlank(newLegalSectionItem.Common_Name__c)){
            addlegalItesmPM = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Comments_cannot_be_left_blank));
            return null;
        }
        if(opportunityId != null){
            newLegalSectionItem.Commercial__c=commercialId;
            newLegalSectionItem.Section_Type__c='Add Additional Legal Items';
            try{
            insert newLegalSectionItem;
            }
            catch(exception ex){
                addlegalItesmPM = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                return null;
            }
            finally{
                newLegalSectionItem= new Commercial_Section_Item__c();
            }
            addlegalItesmPM = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
            }
        detailRecordsOfCommercialISections();
        refreshPage = true;
        addButtonRender = true;        
        return null;
    }
    
    /******************************
    Method Name: addRiskSectionItems
    Description: Add button For Risk Section
    Paramenters: NA
    Return Value: PageReference
    *******************************/
   public PageReference addRiskSectionItems(){
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        if(String.isBlank(newRiskSectionItem.Common_Name__c)){
            addRiskPageMessage = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Comments_cannot_be_left_blank));
            return null;
        }
        if(opportunityId != null){
            newRiskSectionItem.Commercial__c=commercialId;
            newRiskSectionItem.Section_Type__c='Risks';
            try{
            insert newRiskSectionItem;
            }
            catch(exception ex){
                addRiskPageMessage = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                return null;
            }
            finally{
                newRiskSectionItem = new Commercial_Section_Item__c();
            }
            addRiskPageMessage = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
            }
        detailRecordsOfCommercialISections();
        refreshPage = true;
        return null;
    }
    
   /******************************
    Method Name: addActionItemSectionItems
    Description: Add button For Action Item Section
    Paramenters: NA
    Return Value: PageReference
    *******************************/
   public PageReference addActionItemSectionItems(){
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        if(String.isBlank(newActItemSectionItem.Common_Name__c)){
            addActionItemPageMessage = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Comments_cannot_be_left_blank));
            return null;
        }
        if(opportunityId != null){
            newActItemSectionItem.Commercial__c=commercialId;
            newActItemSectionItem.Section_Type__c='Action Item';
            try{
            insert newActItemSectionItem;
            }
            catch(exception ex){
                addActionItemPageMessage = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                return null;
            }
            finally{
                newActItemSectionItem = new Commercial_Section_Item__c();
            }
            addActionItemPageMessage = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
        }
        detailRecordsOfCommercialISections();
        refreshPage = true;
        return null;
    }
    
    /******************************
    Method Name: addNextStepSectionItems
    Description: Add button For Action Item Section
    Paramenters: NA
    Return Value: PageReference
    *******************************/
   public PageReference addNextStepSectionItems(){
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        if(String.isBlank(newNextStepItem.Common_Name__c)){
            nextStepPageMessage = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Comments_cannot_be_left_blank));
            return null;
        }
        if(opportunityId != null){
            newNextStepItem.Commercial__c=commercialId;
            newNextStepItem.Section_Type__c='Next Step';
            try{
            insert newNextStepItem;
            }
            catch(exception ex){
                nextStepPageMessage = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                return null;
            }
            finally{
                newNextStepItem = new Commercial_Section_Item__c();
            }
            nextStepPageMessage = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
        }
        detailRecordsOfCommercialISections();
        refreshPage = true;
        return null;
    }
    
     /******************************
    Method Name: addNextStepSectionItems
    Description: Add button For Action Item Section
    Paramenters: NA
    Return Value: PageReference
    *******************************/
   public PageReference addDealClosingActivitySectionItems(){
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        if(String.isBlank(newDealActivityItem.Common_Name__c)){
            keyActivitiesPageMessage = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Comments_cannot_be_left_blank));
            return null;
        }
        if(opportunityId != null){
            newDealActivityItem.Commercial__c=commercialId;
            newDealActivityItem.Section_Type__c='Key Activities to Close the Deal';
            try{
            insert newDealActivityItem;
            }
             catch(exception ex){
                keyActivitiesPageMessage = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                return null;
            }
            finally{
                newDealActivityItem = new Commercial_Section_Item__c();
            }
            keyActivitiesPageMessage = true;
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
        }
        detailRecordsOfCommercialISections();
        refreshPage = true;
        return null;
    }
    
    
  /******************************
    Method Name: detailRecordsOfCommercialISections
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
   //Start
    public void detailRecordsOfCommercialISections() {   
     //hiddenNavigator2=UTIL_Constants.ADD;    
    listLegalItemDetails = new List<Commercial_Section_Item__c>();
    List<Commercial_Section_Item__c> legalSec = [Select id,Name,Common_Name__c,Section_Type__c,Created_by__c, Created_Date__c from Commercial_Section_Item__c where Commercial__c=:commercialId AND Section_Type__c ='Add Additional Legal Items' order by Created_Date__c ];
        if(legalSec.Size()>0){
            for(Commercial_Section_Item__c cs : legalSec){
                System.debug('####'+cs.Common_Name__c);
                listLegalItemDetails.add(cs);                
            } 
        }
    System.debug('listLegalItemDetails123'+listLegalItemDetails);      
        
    listRiskItemDetails = new List<Commercial_Section_Item__c>();
    List<Commercial_Section_Item__c> riskSec = [Select id,Name,Common_Name__c,Section_Type__c,Created_by__c, Created_Date__c from Commercial_Section_Item__c where Commercial__c=:commercialId AND Section_Type__c ='Risks' order by Created_Date__c ];
        if(riskSec.Size()>0){
            for(Commercial_Section_Item__c cs : riskSec){
                listRiskItemDetails.add(cs);                
            } 
        }  

    listNextStepItemDetails = new List<Commercial_Section_Item__c>();
    List<Commercial_Section_Item__c> nextStepSec = [Select id,Name,Common_Name__c,Section_Type__c,Created_by__c, Created_Date__c from Commercial_Section_Item__c where Commercial__c=:commercialId AND Section_Type__c ='Next Step' order by Created_Date__c ];
        if(nextStepSec.Size()>0){
            for(Commercial_Section_Item__c cs : nextStepSec){
                listNextStepItemDetails.add(cs);                
            } 
        }  
        
    listActivityItemDetails = new List<Commercial_Section_Item__c>();
    List<Commercial_Section_Item__c> actSec = [Select id,Name,Common_Name__c,Section_Type__c,Created_by__c, Created_Date__c from Commercial_Section_Item__c where Commercial__c=:commercialId AND Section_Type__c ='Key Activities to Close the Deal' order by Created_Date__c ];
        if(actSec.Size()>0){
            for(Commercial_Section_Item__c cs : actSec){
                listActivityItemDetails.add(cs);                
            } 
        }  
        
    listActionItemDetails = new List<Commercial_Section_Item__c>();
    List<Commercial_Section_Item__c> actionSec = [Select id,Name,Common_Name__c,Section_Type__c,Created_by__c, Created_Date__c from Commercial_Section_Item__c where Commercial__c=:commercialId AND Section_Type__c ='Action Item' order by Created_Date__c ];
        if(actionSec.Size()>0){
            for(Commercial_Section_Item__c cs : actionSec){
                listActionItemDetails.add(cs);                
            } 
        }  
    }
    /******************************
    Method Name: deleteFileForCommercial
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFileForCommercial() {
        boolean deletedrecord=false;
        String SectionType = null;
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        for(Commercial_Section_Item__c cs : [Select Name,Common_Name__c,Section_Type__c from Commercial_Section_Item__c 
                                                where Commercial__c=:commercialId and id=:fileIdDelete]) {
            SectionType = cs.Section_Type__c;                                       
            deletedrecord=true;
            delete cs;
        }  
        if(SectionType == 'Action Item') {
            addActionItemPageMessage = true;
        } 
        else if(SectionType == 'Next Step') {
            nextStepPageMessage = true;
        }
        else if(SectionType == 'Risks') {
            addRiskPageMessage = true;
        }
        else if(SectionType == 'Key Activities to Close the Deal') {
            keyActivitiesPageMessage = true;
        }
        else if(SectionType == 'Add Additional Legal Items') {
            addlegalItesmPM = true;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
        detailRecordsOfCommercialISections();
        /*PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?Count=1&id='+opportunityId+'&isVisible=true&tabFocus=tab7');
        pg.setRedirect(true);*/
        return null; 
    }
    
    
    /******************************
    Method Name: documentsCommercial
    Description: To retrieve Deal Review Notes.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void dealReviewNote() {   
    listDealReviewNote = new List<Deal_Review_Note__c>();
    List<Deal_Review_Note__c> dealRevDocs = [Select id,Name,Approval_Stage__c,Comments__c,Document_Version__c,Name_Link__c,Review_Process__c,Review_Process__r.Review_Stage_master__r.Name,Commercial__c,Date_Uploaded__c, Document_Name__c from Deal_Review_Note__c where Commercial__c=:commercialId order by Date_Uploaded__c ];
    System.debug('dealRevDocs1111'+dealRevDocs);
        if(dealRevDocs.Size()>0){
            for(Deal_Review_Note__c dr : dealRevDocs){
                listDealReviewNote.add(dr);                
            }
          System.debug('listDealReviewNote11112'+listDealReviewNote);   
        }
    }
    
    /******************************
    Method Name: deleteFileForCommercialDocument
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFileForDealReviewNote() {
        boolean deletedrecord=false;
        for(Deal_Review_Note__c dr : [Select id,Name,Approval_Stage__c,Comments__c,Commercial__c,Date_Uploaded__c, Document_Name__c from Deal_Review_Note__c
                                     where Commercial__c=:commercialId and id=:fileIdDelete])  {
            try{
                deletedrecord=true;
                delete dr;
                dealReviewNote();
            }
            catch(Exception ex){
                dealReviewPMRender = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Delete'));
                return null;
            }
        } 
        dealReviewPMRender = true; 
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
           //detailRecordsOfCommercialISections();
       PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?Count=1&id='+opportunityId+'&isVisible=true&tabFocus=tab7');
       pg.setRedirect(true);
       return null; 
    }
    
    /******************************
    Method Name: documentsCommercial
    Description: To retrieve commercial Documents.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void documentsCommercial() {   
    listCommercialDocs = new List<Commercial_Document__c>();
    List<Commercial_Document__c> commDocs = [Select id,Name,Comments__c,Commercial__c,Date_Uploaded__c, Document_Name__c,Name_Link__c from Commercial_Document__c where Commercial__c=:commercialId order by Date_Uploaded__c ];
        if(commDocs.Size()>0){
            for(Commercial_Document__c cd : commDocs){
                listCommercialDocs.add(cd);                
            } 
        }
    }
    
    /******************************
    Method Name: deleteFileForCommercialDocument
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFileForCommercialDocument() {
        boolean deletedrecord=false;
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        for(Commercial_Document__c cd : [Select id,Name,Comments__c,Commercial__c,Date_Uploaded__c, Document_Name__c from Commercial_Document__c 
                                                where Commercial__c=:commercialId and id=:fileIdDelete]) {
            try{
                delete cd;
                deletedrecord=true;
                documentsCommercial();
            }
            catch(Exception ex){
                commericalDocPMRender = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Error in Delete'));
            }
                     
        }  
        commericalDocPMRender = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
            //detailRecordsOfCommercialISections();
        /*PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?Count=1&id='+opportunityId+'&isVisible=true&tabFocus=tab7');
        pg.setRedirect(true);
        return pg; */
        return null;
    }
    
   /******************************
    Method Name: upload
    Description: To upload Deal Review Docs.
    Paramenters: NA
    Return Value: PageReference
    *******************************/
    public PageReference upload() {
        commericalDocPMRender = false;
        dealReviewPMRender = true;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        system.debug('selectedApprovalStage--------->>>'+selectedApprovalStage);
        if(selectedApprovalStage == null || selectedApprovalStage == 'None' ) {
            dealReviewPMRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select the Approval Stage'));
            attachment.body=null;
            attachment = new Attachment();
            return null;
        }
        if(attachment.name == null) {
            dealReviewPMRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select the File to Upload'));
            
            return null;
        } 
        tempDealReviewObj =  [select Approval_Stage__c,Document_Version__c,Commercial__c,Review_Process__c,Review_Process__r.Name from Deal_Review_Note__c where Commercial__c=:commercialId and Approval_Stage__c =: selectedApprovalStage order by createddate desc limit 1];
        Decimal version=1;
        if(tempDealReviewObj.size()>0 && tempDealReviewObj[0].Document_Version__c != null) {
            version = tempDealReviewObj[0].Document_Version__c + 1;
        }
          
        dealReviewObj = new Deal_Review_Note__c(Approval_Stage__c = selectedApprovalStage, Commercial__c=commercialId, Document_Version__c=version ,Comments__c=CommentsField);
        try {
            insert dealReviewObj;
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = dealReviewObj.Id; // the record the file is attached to
            attachment.IsPrivate = false;
                //if(attachment.Name.endsWith('.txt'))    
            insert attachment;
            dealReviewObj.AttachmentID__c=attachment.Id;
            dealReviewObj.Document_Name__c=attachment.Name;
                //dealReviewObj.Date_Uploaded__c=Date.valueOf(attachment.createddate);
            update dealReviewObj;
            dealReviewNote();
        } 
        catch (DMLException e) {
            dealReviewPMRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } 
        finally {
            attachment.body=null;
            attachment = new Attachment(); 
            CommentsField = null;
            dealReviewObj = new Deal_Review_Note__c();
        }
        dealReviewPMRender = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
   }
   
   
   /******************************
    Method Name: uploadCommDoc
    Description: To uploadCommDoc.
    Paramenters: NA
    Return Value: PageReference
    *******************************/
    public PageReference uploadCommDoc() {
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        if(attachment.name == null) {
            commericalDocPMRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select the File to Upload'));
            return null;
        } 
        comDocObj = new Commercial_Document__c(Document_Name__c = attachment.name, Commercial__c=commercialId, Comments__c=CommentsFieldCommercial);
        insert comDocObj;
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = comDocObj.Id; // the record the file is attached to
        attachment.IsPrivate = false;
        try {
                //if(attachment.Name.endsWith('.txt'))    
            insert attachment;
            comDocObj.AttachmentID__c=attachment.Id;
            comDocObj.Document_Name__c=attachment.Name;
            update comDocObj;
            documentsCommercial();
        } 
        catch (DMLException e) {
            commericalDocPMRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } 
        finally {
            attachment.body=null;
            attachment = new Attachment(); 
            CommentsFieldCommercial = null;
            comDocObj = new Commercial_Document__c();
        }
        commericalDocPMRender = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
    }
    
    /******************************
    Method Name: Edit
    Description: To Edit Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void edit()
    {
        editSection = true;  
        readOnlyMode = false;
        editButtonPermission = false; 
  
    }
   /******************************
    Method Name: save 
    Description: To Save whichever is updating from master in Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public PageReference save()
    {
        system.debug('**************>'+booleanPageMessageRender);
        commericalDocPMRender = false;
        dealReviewPMRender = false;
        addRiskPageMessage = false;
        addActionItemPageMessage = false;
        nextStepPageMessage = false;
        keyActivitiesPageMessage = false;
        addlegalItesmPM = false;
        booleanPageMessageRender = true;
         try{
        
    /*   newCommercial.Solution_Review_Approver__c=solRevApprover;
         newCommercial.Transition_Plan_Approver__c=transPlanApprover;
         newCommercial.CDP_Workbook_Submitted_Y_N__c=cdpWorkbookSubmitted;
         newCommercial.Opportunity_QA_Approver__c=oppQAApprover;
         newCommercial.Spend_Analysis_WBApprover_APS_Only__c=speedAnalysisWB;
         newCommercial.Compliance_Regulatory_Approver__c=compRegApprover;*/
         system.debug('----------------->'+newCommercial.Id);
         update newCommercial;
         }
         catch(exception ex){
            system.debug('ex**************>'+booleanPageMessageRender);
            booleanPageMessageRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
            return null;
              }
         finally{
            // BiswA check below line logic
           // newCommercial = new Opportunity_Commerical_Data__c(Opportunity_TGP__c = opportunityId);
            }
            booleanPageMessageRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
        
        PageReference pr;  
        if(opportunityId !=null){      
            pr=new PageReference('/apex/BPO_Opportunity_tab?id='+opportunityId+'&Count=1&tabFocus=tab7&isVisible=true');
            pr.setRedirect(true);
            return pr;
        }
        editSection = false;
        return null;
    
    }
    /******************************
    Method Name: pagerefresh
    Description: Refresh othercharacteristics
    Paramenters: NA
    Return Value: NA
    *******************************/  

    public PageReference pagerefresh(){
                PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?id='+opportunityId+'&Count=1&tabFocus=tab7&isVisible=true');
                pg.SetRedirect(true);
                tabFocus= 'tab7';
                return pg; 
    }
    
   
    /******************************
    Method Name: getListOfApprovalStage
    Description: get the lstOf ApprovalStage
    Paramenters: NA
    Return Value: List<selectOption>
    *******************************/    
   public List<selectOption> getListOfApprovalStage() {
     List<selectOption> fteRangeOptions = new List<selectOption>();
        Schema.DescribeFieldResult fteRange = Deal_Review_Note__c.Approval_Stage__c.getDescribe();
        List<Schema.PicklistEntry> fteRangeValues = fteRange.getPicklistValues();
        fteRangeOptions.add(new SelectOption('None', '--None--'));
        for (Schema.PicklistEntry a : fteRangeValues) { 
            fteRangeOptions.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return fteRangeOptions; 
    } 
}