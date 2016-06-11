/*
Author :Mayank Tayal
Story:MOB_035,MOB_034, MOB_036, MOB_136
Description: This Controller  is used initiate, update, submit MEC Checklist

Updated by        Story no.                Update Date        Update details
------------     -----------------        --------------    -------------------------------------------------------------


*/
public class MECChecklist_InlineReadOnlyController {
    public String dealId{get;set;}
    public List<Deal_TGP__c> dealRecordList{get;set;}
    public Deal_TGP__c dealRecord{get;set;}
    public List<MEC_Post_Contract_Version__c> mecVersion{get;set;}
    public MEC_Post_Contract_Version__c mecVersionRecord{get;set;}
    public List<Opportunity_TGP__c> opportunityList{get;set;}
    public Opportunity_TGP__c opportunityRecord{get;set;}
    public List<MEC_Post_Contract_End_User__c> userMECDataList{get;set;}
    public List<MEC_Post_Contract_Questionnaire_Master__c> quesMECMaster{get;set;}
    public List<MEC_Post_Contract_End_User_Questionnaire__c> userMECQuestionList{get;set;}
    public MEC_Post_Contract_End_User__c newUserMECRecord{get;set;}
    public MEC_Post_Contract_End_User_Questionnaire__c newUserMECQuesRecord{get;set;}
    public String mecVersionId{get;set;}
    public String tabValue{get;set;}
    public String clientName{get;set;}
    
    public String setSatisfactionColor{get;set;}
    public String mandatoryMessage{get;set;}
    
    //User set variables
    public MECEndUserMain userMain{get;set;}
    public List<MECPostContractUser> mecQuestion{get;set;}
    public MEC_Post_Contract_End_User__c endUserSavedRecord{get;set;}
    public List<MEC_Post_Contract_End_User_Questionnaire__c> userMECAnsQuestion{get;set;}
    public List<MOB_User_Role_Assignment__c> userList{get;set;} 
    
    //Variables for Page Messages
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    public Boolean prjExecTab{get;set;}
    public Boolean dueDiliTab{get;set;}
    
    public String mobArchPrimary{get;set;}
    public String mobArchSecondary{get;set;}
    public String mobArchSecondary1{get;set;} 
    
    
    public String govLeadPrimary{get;set;}
    public String govLeadSecondary{get;set;}
    public String govLeadSecondary1{get;set;}
    
    /******************************
    Method Name: MECChecklist_InlineReadOnlyController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
    public MECChecklist_InlineReadOnlyController(ApexPages.StandardController controller) 
    {    
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        newUserMECRecord = new MEC_Post_Contract_End_User__c();
        endUserSavedRecord = new MEC_Post_Contract_End_User__c();
        newUserMECQuesRecord = new MEC_Post_Contract_End_User_Questionnaire__c();
        userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
        dealId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        tabValue=ApexPages.CurrentPage().getParameters().get('itemValue');
        if(dealId!=null)
        {
            dealRecordList=[select Client_Name__c, Client_Name__r.name, MEC_Version__c, Has_Mob_Architect_Saved__c, name, 
                             Opportunity_Name__c, Opportunity_ID__c from Deal_TGP__c where id=:dealId];
            userList=[select name, Role_Name__c,  User_Assigned_New__r.SFDC_User__r.Name, User_Assigned_Secondary_New__r.SFDC_User__r.Name,User_Assigned_Secondary_Lead__r.SFDC_User__r.Name   
                            from MOB_User_Role_Assignment__c where Deal__c=:dealId];
            if(userList.size()>0)
            {
                for(MOB_User_Role_Assignment__c mobUser : userList)
                {
                    if(UTIL_Constants.MOBILIZATION_ARCHITECT.equalsIgnoreCase(mobUser.Role_Name__c))
                    {
                        mobArchPrimary=mobUser.User_Assigned_New__r.SFDC_User__r.Name;
                        mobArchSecondary=mobUser.User_Assigned_Secondary_New__r.SFDC_User__r.Name;
                        mobArchSecondary1=mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__r.name;
                    }
                    if(UTIL_Constants.GOVERNANCE_LEAD.equalsIgnoreCase(mobUser.Role_Name__c))
                    {
                        govLeadPrimary=mobUser.User_Assigned_New__r.SFDC_User__r.Name;
                        govLeadSecondary=mobUser.User_Assigned_Secondary_New__r.SFDC_User__r.Name;
                        govLeadSecondary1=mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__r.name;
                    }
                }
            }
            
            if(dealRecordList.size()>0)
            {
                showForm=true;
                dealRecord=dealRecordList[0];
                clientName=dealRecord.Client_Name__r.name;
                opportunityList=[select Enterprise_Solution_Architect__r.name, name from Opportunity_TGP__c where id=:dealRecord.Opportunity_ID__c];
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No such Deal Record exists!'));
                showMainMsg=true;
                showForm=false;
            }
            mecVersion=[select id, name, Version_Name__c, Active__c from MEC_Post_Contract_Version__c where id=:dealRecord.MEC_Version__c];
            if(mecVersion.size()>0)
            {
                mecVersionRecord=mecVersion[0];
                mecVersionId=mecVersion[0].id;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No MEC Post Contract version is active or MEC Checklist is not yet Submitted!'));
                showMainMsg=true;
                showForm=false;
            }
            mainQueries();
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No such Deal ID exists!'));
            showMainMsg=true;
            showForm=false;
        }
    }
    
    /******************************
    Method Name: initializePageMessages
    Description: Initializing the display for Page Messages
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializePageMessages()
    {
        showMainMsg=false;
        prjExecTab=false; 
        dueDiliTab=false;        
    }
    /******************************
    Method Name: mainQueries
    Description: Queries to get the list of Main Questions from Master, 
                 and pre-saved User Checklist data 
    Paramenters: NA
    Return Value: void
    *******************************/
    public void mainQueries()
    {
        quesMECMaster = [select Category_Name__c, Criteria__c, Is_Mandatory__c, id, name from MEC_Post_Contract_Questionnaire_Master__c where MEC_Post_Contract_Version__c = :mecVersionId order by createddate asc];
        userMECDataList=[select Capability_Assessment__c, MEC_Submission_End_Date__c, Primary_Mob_Arch_Task_ID__c, Secondary_Mob_Arch_Task_ID__c, Sol_Arch_Task_ID__c, Primary_Gov_Lead_task_ID__c, Secondary_Gov_Lead_Task_ID__c, Governance_Lead_Review_End_Date__c, Governance_Lead_Comments__c, Commercial_Commitment_obtained__c, Entry_Criteria_for_Project_Execution__c, Stage__c, Tier_Rating__c, id, name from MEC_Post_Contract_End_User__c where Deal__c=:dealId];
        userMECQuestionList = [select Category_Name__c, Is_Mandatory__c, Comments__c, Criteria__c, Satisfaction_Rating__c, id, name from MEC_Post_Contract_End_User_Questionnaire__c where Deal__c=:dealId];        
    }
    
    /**************************************************
    Class Name: MECEndUserMain
    Description: To set Assessment and Contract field Color values
    ***************************************************/
    public class MECEndUserMain{
        public MEC_Post_Contract_End_User__c mecContractUser{get;set;}
        public String assessmentColor{get;set;}
        public String contractColor{get;set;}
        public String projectExecColor{get;set;}
        
        public MECEndUserMain(MEC_Post_Contract_End_User__c mecContractUser, String assessmentColor, String contractColor, String projectExecColor)
        {
            this.mecContractUser=mecContractUser;
            this.assessmentColor=assessmentColor;
            this.contractColor=contractColor;
            this.projectExecColor=projectExecColor;
        }
        public MECEndUserMain(MEC_Post_Contract_End_User__c mecContractUser, String assessmentColor, String contractColor)
        {
            this.mecContractUser=mecContractUser;
            this.assessmentColor=assessmentColor;
            this.contractColor=contractColor;            
        }       
    }
    
    /**************************************************
    Class Name: MECPostContractUser
    Description: To set Satisfaction Rating Color values
    ***************************************************/
    public class MECPostContractUser{
        public MEC_Post_Contract_End_User_Questionnaire__c mecContractQuesUser{get;set;}
        public String ratingColor{get;set;}
        public String mandatoryMessage{get;set;}
        
        public MECPostContractUser(MEC_Post_Contract_End_User_Questionnaire__c mecContractQuesUser, String ratingColor, String mandatoryMessage)
        {
            this.mecContractQuesUser=mecContractQuesUser;
            this.ratingColor=ratingColor;
            this.mandatoryMessage=mandatoryMessage;
        }
        public MECPostContractUser(MEC_Post_Contract_End_User_Questionnaire__c mecContractQuesUser, String ratingColor)
        {
            this.mecContractQuesUser=mecContractQuesUser;
            this.ratingColor=ratingColor;
            
        }
    }
    
    /******************************
    Method Name: assignContractColors
    Description: Method for assigning colors to Contract Signed Field
    Paramenters: coloringField: String
    Return Value: colorName: String
    *******************************/
    public String assignContractColors(String coloringField)
    {
        String colorName;
        if(coloringField=='No')
            colorName='#FF0000';
        if(coloringField=='Yes')
            colorName='#7CFC00';        
        return colorName;
    }
    
    /******************************
    Method Name: assignAssessmentColors
    Description: Method for assigning colors to Assessment Post Review Field
    Paramenters: coloringField: String
    Return Value: colorName: String
    *******************************/
    public String assignAssessmentColors(String coloringField)
    {
        String colorName;
        if(coloringField=='Minimum Criteria Not Met - HIGH RISK')
            colorName='#FF0000';        
        if(coloringField=='Minimum Criteria Met')
            colorName='#7CFC00';
        if(coloringField=='Minimum Criteria Partially Met - LOW RISK')
            colorName='#FF8C00';            
        return colorName;
    }
    
    /******************************
    Method Name: assignColors
    Description: Method for assigning colors to Satisfaction Rating
    Paramenters: coloringField: String
    Return Value: colorName: String
    *******************************/
    public String assignRatingColors(String coloringField)
    {
        String colorName;
        if(coloringField=='Not Satisfied')
            colorName='#FF0000';
        if(coloringField=='Satisfied')
            colorName='#7CFC00';        
        return colorName;
    }
    
    /******************************
    Method Name: setMECQuestionnaire
    Description: To get the Checklist Questions for Entry Criteria for Project Execution tab
    Paramenters: NA
    Return Value: 
    *******************************/
    public MECEndUserMain getMECUserValues()
    {
        //List<MECEndUserMain> userMain = new List<MECEndUserMain>();        
        String assessColor;
        String contractColor;
        String projectExecColor;
        if(userMECDataList.size()>0)
        {
            newUserMECRecord = userMECDataList[0];
            assessColor= assignAssessmentColors(newUserMECRecord.Capability_Assessment__c);
            contractColor= assignContractColors(newUserMECRecord.Commercial_Commitment_obtained__c);
            projectExecColor = assignAssessmentColors(newUserMECRecord.Entry_Criteria_for_Project_Execution__c);            
        }
        else
        {
             newUserMECRecord = new MEC_Post_Contract_End_User__c();
             newUserMECRecord.Capability_Assessment__c = 'Minimum Criteria Met';
             newUserMECRecord.Commercial_Commitment_obtained__c = 'Yes';
             newUserMECRecord.Entry_Criteria_for_Project_Execution__c = 'Minimum Criteria Met';
             assessColor= assignAssessmentColors(newUserMECRecord.Capability_Assessment__c);
             contractColor= assignContractColors(newUserMECRecord.Commercial_Commitment_obtained__c);
             projectExecColor = assignAssessmentColors(newUserMECRecord.Entry_Criteria_for_Project_Execution__c);              
        }
        //userMain.add(new MECEndUserMain(newUserMECRecord, assessColor, contractColor));
        userMain=new MECEndUserMain(newUserMECRecord, assessColor, contractColor, projectExecColor);
        return userMain;
    }
    
    /******************************
    Method Name: setMECQuestionnaire
    Description: To get the Checklist Questions for Entry Criteria for Project Execution tab
    Paramenters: NA
    Return Value: 
    *******************************/
    public List<MECPostContractUser> getMECQuestionnaire()
    {
        mecQuestion= new List<MECPostContractUser>();
        if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
        {
            if(userMECQuestionList.size()>0)
            {
                for(MEC_Post_Contract_End_User_Questionnaire__c user: userMECQuestionList)
                {
                    newUserMECQuesRecord=user;
                    setSatisfactionColor=assignRatingColors(newUserMECQuesRecord.Satisfaction_Rating__c);
                    if(newUserMECQuesRecord.Is_Mandatory__c == true)
                    {
                        if(newUserMECQuesRecord.Category_Name__c == 'Contract')
                            mandatoryMessage='Mandatory Field that impact the overall Satisfaction Rating in Row 7 for Review 2 ONLY';
                        else
                            mandatoryMessage='Mandatory Field that impact the overall Satisfaction Rating in Row 7 for Review 1 & 2';
                    }   
                    else
                    {
                        mandatoryMessage='';    
                    }
                    mecQuestion.add(new MECPostContractUser(newUserMECQuesRecord,setSatisfactionColor,mandatoryMessage));
                }
            }
            else if(quesMECMaster != null)
            {
                if(quesMECMaster.size()>0)
                {
                    for(MEC_Post_Contract_Questionnaire_Master__c ques : quesMECMaster)
                    {
                        if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                        {                                                                                                            
                            newUserMECQuesRecord=new MEC_Post_Contract_End_User_Questionnaire__c();
                            newUserMECQuesRecord.Category_Name__c=ques.Category_Name__c;
                            newUserMECQuesRecord.Criteria__c=ques.Criteria__c;
                            newUserMECQuesRecord.Is_Mandatory__c=ques.Is_Mandatory__c;                                
                            newUserMECQuesRecord.Deal__c=dealId;
                            newUserMECQuesRecord.Version_Number__c=mecVersionId;
                            newUserMECQuesRecord.Satisfaction_Rating__c='Satisfied';                                
                            //newUserMECQuesRecord.SRAT_Section_Questionnaire__c=sq.id;                                
                            setSatisfactionColor=assignRatingColors(newUserMECQuesRecord.Satisfaction_Rating__c);
                            if(ques.Is_Mandatory__c == true)
                            {
                                if(ques.Category_Name__c == 'Contract')
                                    mandatoryMessage='Mandatory Field that impact the overall Satisfaction Rating in Row 7 for Review 2 ONLY';
                                else
                                    mandatoryMessage='Mandatory Field that impact the overall Satisfaction Rating in Row 7 for Review 1 & 2';
                            }   
                            else
                            {
                                mandatoryMessage='';    
                            }                                                            
                        }
                        mecQuestion.add(new MECPostContractUser(newUserMECQuesRecord,setSatisfactionColor,mandatoryMessage));
                    }
                }
            }
        }
        return mecQuestion;
    }

}