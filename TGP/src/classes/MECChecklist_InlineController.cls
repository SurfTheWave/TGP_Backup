/*
Story:MOB_035,MOB_034, MOB_036, MOB_136
Description: This Controller  is used initiate, update, submit MEC Checklist

Updated by        Story no.                Update Date        Update details
------------     -----------------        --------------    -------------------------------------------------------------


*/
public class MECChecklist_InlineController {
    
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
    public List<MEC_Post_Contract_End_User_Questionnaire__c> deleteUserMECQuestionList{get;set;}
    public MEC_Post_Contract_End_User__c newUserMECRecord{get;set;}
    public MEC_Post_Contract_End_User_Questionnaire__c newUserMECQuesRecord{get;set;}
    public String mecVersionId{get;set;}
    public String tabValue{get;set;}
    public String clientName{get;set;}
    public List<MOB_User_Role_Assignment__c> userList{get;set;} 
    
    public String setSatisfactionColor{get;set;}
    public String mandatoryMessage{get;set;}
    
    //User set variables
    public MECEndUserMain userMain{get;set;}
    public List<MECPostContractUser> mecQuestion{get;set;}
    public MEC_Post_Contract_End_User__c endUserSavedRecord{get;set;}
    public List<MEC_Post_Contract_End_User_Questionnaire__c> userMECAnsQuestion{get;set;}
    
    //Variables for Page Messages
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    public Boolean prjExecTab{get;set;}
    public Boolean dueDiliTab{get;set;}
    
    //Variables for Section Access to Users
    public Boolean mobArchRead{get;set;}
    public Boolean mobArchWrite{get;set;}
    public Boolean govLeadRead{get;set;}
    public Boolean govLeadWrite{get;set;}
    public Boolean submitButton{get;set;}
    
    public Integer intCount{get;set;}
    public Boolean isDateChanged{get;set;}
    
    public String mobArchPrimary{get;set;}
    public String mobArchSecondary{get;set;}
    public String mobArchSecondary1{get;set;}                 
    
    
    public String govLeadPrimary{get;set;}
    public String govLeadSecondary{get;set;}
    public String govLeadSecondary1{get;set;} 
    
    public void deleteMEC()
    {
        for(MEC_Post_Contract_End_User_Questionnaire__c  mec: [select id, name from MEC_Post_Contract_End_User_Questionnaire__c limit 90])
            delete mec;
    }
    
    /******************************
    Method Name: MECChecklist_InlineController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
    public MECChecklist_InlineController(ApexPages.StandardController controller) {
    
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        newUserMECRecord = new MEC_Post_Contract_End_User__c();
        endUserSavedRecord = new MEC_Post_Contract_End_User__c();
        newUserMECQuesRecord = new MEC_Post_Contract_End_User_Questionnaire__c();
        userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
        
        dealId=ApexPages.CurrentPage().getParameters().get('id');        
        tabValue=ApexPages.CurrentPage().getParameters().get('itemValue');
        
        if(dealId!=null && tabValue!=null)
        {
            dealRecordList=[select Client_Name__r.name, id, MEC_Version__c, Has_Gov_Lead_Submitted__c, Has_Mob_Architect_Submitted__c, Has_Mob_Architect_Saved__c, name, Opportunity_Name__c, Opportunity_ID__c,Solution_Architect_New__c,Solution_Architect_New__r.SFDC_User__c from Deal_TGP__c where id=:dealId];
            userList=[select id, name, Role_Name__c,User_Assigned_New__c, User_Assigned_New__r.name, User_Assigned_Secondary_New__c,User_Assigned_Secondary_New__r.name,User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_Lead__c,User_Assigned_Secondary_Lead__r.name,User_Assigned_Secondary_Lead__r.SFDC_User__c  from MOB_User_Role_Assignment__c where Deal__c=:dealId]; 
            
                                                  //User_Assigned_New__r.SFDC_User__r.name, User_Assigned_Secondary_New__r.SFDC_User__r.Name, User_Assigned_Secondary_Lead__r.SFDC_User__r.Name from MOB_User_Role_Assignment__c where Deal__c=:dealId]; 
            
           // User_Assigned_New__c, User_Assigned_New__r.name, User_Assigned_Secondary_New__c,User_Assigned_Secondary_New__r.name,User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_Lead__c,User_Assigned_Secondary_Lead__r.name,User_Assigned_Secondary_Lead__r.SFDC_User__c  from MOB_User_Role_Assignment__c where Deal__c=:dealId];
            
            if(dealRecordList.size()>0)              
            {
                showForm=true;
                dealRecord=dealRecordList[0];
                clientName=dealRecord.Client_Name__r.name;
                opportunityList=[select Enterprise_Solution_Architect_New__r.name, id, name from Opportunity_TGP__c where id=:dealRecord.Opportunity_ID__c];
                
                /*if(opportunityList.size()>0)
                {
                    opportunityRecord=opportunityList[0];                    
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Opportunity is associated to this Deal!'));
                    showMainMsg=true;
                    showForm=false;
                }*/
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No such Deal Record exists!'));
                showMainMsg=true;
                showForm=false;
            }
            mecVersion=[select id, name, Version_Name__c, Active__c from MEC_Post_Contract_Version__c where Active__c=:true];
            if(mecVersion.size()>0)
            {
                mecVersionRecord=mecVersion[0];
                mecVersionId=mecVersion[0].id;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No MEC Post Contract version is active!'));
                showMainMsg=true;
                showForm=false;
            }
            mainQueries();
            initializeSectionsUsers();
            intCount=1;
            isDateChanged=false;            
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
        userMECDataList=[select Capability_Assessment__c, HAS_Checklist_Version_Changed__c, MEC_Submission_End_Date__c, Primary_Mob_Arch_Task_ID__c, Secondary_Mob_Arch_Task_ID__c, Sol_Arch_Task_ID__c, Primary_Gov_Lead_task_ID__c, Secondary_Gov_Lead_Task_ID__c, Governance_Lead_Review_End_Date__c, Governance_Lead_Comments__c, Commercial_Commitment_obtained__c, Entry_Criteria_for_Project_Execution__c, Stage__c, Tier_Rating__c, id, name from MEC_Post_Contract_End_User__c where Deal__c=:dealId];
        userMECQuestionList = [select Category_Name__c, Is_Mandatory__c, Comments__c, Criteria__c, Satisfaction_Rating__c, id, name from MEC_Post_Contract_End_User_Questionnaire__c where Deal__c=:dealId];        
    }
    
    /******************************
    Method Name: initializeSectionsUsers
    Description: Set the visibility of sections to different users 
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializeSectionsUsers()
    {
        String currentUser=Userinfo.getUserId();
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;
        boolean isMobArchExist=false;
        boolean isGovExist=false;
        if(userList.size()>0)
        {
             
            for(MOB_User_Role_Assignment__c mobUser : userList)
            {
                if('Mobilization Architect'.equalsIgnoreCase(mobUser.Role_Name__c))
                {
                    mobArchPrimary=mobUser.User_Assigned_New__r.name;
                    mobArchSecondary=mobUser.User_Assigned_Secondary_New__r.name;
                    mobArchSecondary1=mobUser.User_Assigned_Secondary_Lead__r.name;    
                }
                if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c))
                {
                    govLeadPrimary=mobUser.User_Assigned_New__r.name;
                    govLeadSecondary=mobUser.User_Assigned_Secondary_New__r.name;
                    govLeadSecondary1=mobUser.User_Assigned_Secondary_Lead__r.name;
                }
                if('Mobilization Architect'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                {
                    isMobArchExist=true;
                }
                if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                {
                    isGovExist=true;
                }
            } 
            if((isMobArchExist==true || userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) && dealRecord.Has_Mob_Architect_Submitted__c==false)
            {
                mobArchRead = false;
                mobArchWrite = true;
                govLeadRead =true;
                govLeadWrite = false;
                submitButton = true;
            }
            if(dealRecord.Solution_Architect_New__r.SFDC_User__c==currentUser && dealRecord.Has_Mob_Architect_Submitted__c==false && dealRecord.Has_Mob_Architect_Saved__c==true)
            {
                mobArchRead = true;
                mobArchWrite = false;
                govLeadRead =true;
                govLeadWrite = false;
                submitButton = false;
            }
            if((isGovExist==true || userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) && dealRecord.Has_Mob_Architect_Submitted__c==true && dealRecord.Has_Gov_Lead_Submitted__c==false)
            {
                mobArchRead = true;
                mobArchWrite = false;
                govLeadRead =false;
                govLeadWrite = true;
                submitButton = true;
            }
        
            //Mayank code start
            /*for(MOB_User_Role_Assignment__c mobUser : userList)
            {
                if('Mobilization Architect'.equalsIgnoreCase(mobUser.Role_Name__c))
                {
                    mobArchPrimary=mobUser.User_Assigned_New__r.name;
                    mobArchSecondary=mobUser.User_Assigned_Secondary_New__r.name;
                }
                if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c))
                {
                    govLeadPrimary=mobUser.User_Assigned_New__r.name;
                    govLeadSecondary=mobUser.User_Assigned_Secondary_New__r.name;
                }
                if(('Mobilization Architect'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId())) && dealRecord.Has_Mob_Architect_Submitted__c==false)
                {
                    mobArchRead = false;
                    mobArchWrite = true;
                    govLeadRead =true;
                    govLeadWrite = false;
                    submitButton = true;
                }
                if(dealRecord.Solution_Architect_New__r.SFDC_User__c ==currentUser && dealRecord.Has_Mob_Architect_Submitted__c==false && dealRecord.Has_Mob_Architect_Saved__c==true)
                {
                    mobArchRead = true;
                    mobArchWrite = false;
                    govLeadRead =true;
                    govLeadWrite = false;
                    submitButton = false;
                }
                if(('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId())) && dealRecord.Has_Mob_Architect_Submitted__c==true && dealRecord.Has_Gov_Lead_Submitted__c==false)
                {
                    mobArchRead = true;
                    mobArchWrite = false;
                    govLeadRead =false;
                    govLeadWrite = true;
                    submitButton = true;
                }
            }*/
            //Mayank code end
        }        
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
            if(userMECDataList[0].HAS_Checklist_Version_Changed__c==false)
            {
                newUserMECRecord = userMECDataList[0];
                assessColor= assignAssessmentColors(newUserMECRecord.Capability_Assessment__c);
                contractColor= assignContractColors(newUserMECRecord.Commercial_Commitment_obtained__c);
                projectExecColor = assignAssessmentColors(newUserMECRecord.Entry_Criteria_for_Project_Execution__c);
            }
            else
            {
                 userMECDataList[0].Capability_Assessment__c = 'Minimum Criteria Met';
                 userMECDataList[0].Commercial_Commitment_obtained__c = 'Yes';
                 userMECDataList[0].Entry_Criteria_for_Project_Execution__c = 'Minimum Criteria Met';
                 userMECDataList[0].MEC_Submission_End_Date__c = null;
                 userMECDataList[0].Governance_Lead_Review_End_Date__c = null;
                 assessColor= assignAssessmentColors(userMECDataList[0].Capability_Assessment__c);
                 contractColor= assignContractColors(userMECDataList[0].Commercial_Commitment_obtained__c);
                 projectExecColor = assignAssessmentColors(userMECDataList[0].Entry_Criteria_for_Project_Execution__c);
                 newUserMECRecord = userMECDataList[0];              
            }            
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
            if(userMECQuestionList.size()>0 && userMECDataList.size()>0)
            {
                if(userMECDataList[0].HAS_Checklist_Version_Changed__c==false)
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
                        deleteUserMECQuestionList = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
                        deleteUserMECQuestionList.addAll(userMECQuestionList);
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
                                //newUserMECQuesRecord.Satisfaction_Rating__c='Satisfied'; 
                                newUserMECQuesRecord.Satisfaction_Rating__c='';                                
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
                            //newUserMECQuesRecord.Satisfaction_Rating__c='Satisfied';
                            newUserMECQuesRecord.Satisfaction_Rating__c='';                               
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
    
    /******************************
    Method Name: setMECUserQuestionnaire
    Description: To set the End user saved data
    Paramenters: NA
    Return Value: Boolean
    *******************************/
    public Boolean setMECUserQuestionnaire(Boolean value)
    {
        Integer satisfiedCnt=0, notSatisfiedCnt=0;
        //userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
        if(mecQuestion!=null)
        {
            if(mecQuestion.size()>0)
            {
                for(MECPostContractUser mec : mecQuestion)
                {
                    if((mec.mecContractQuesUser.Satisfaction_Rating__c=='' || mec.mecContractQuesUser.Satisfaction_Rating__c==null) && value==true)
                        return false;
                    if(mec.mecContractQuesUser.Is_Mandatory__c == true)
                    {
                        if(mec.mecContractQuesUser.Satisfaction_Rating__c=='Satisfied')
                            satisfiedCnt++;
                        if(mec.mecContractQuesUser.Satisfaction_Rating__c=='Not Satisfied')
                            notSatisfiedCnt++;    
                    }                    
                    userMECAnsQuestion.add(mec.mecContractQuesUser);
                }
            }
        }
        if(endUserSavedRecord.Commercial_Commitment_obtained__c == 'Yes')
        {
            if(satisfiedCnt==4)
                endUserSavedRecord.Entry_Criteria_for_Project_Execution__c='Minimum Criteria Met';
            if(satisfiedCnt==2 || satisfiedCnt==3)
                endUserSavedRecord.Entry_Criteria_for_Project_Execution__c='Minimum Criteria Partially Met - LOW RISK';
            if(satisfiedCnt==0 || satisfiedCnt==1)
                endUserSavedRecord.Entry_Criteria_for_Project_Execution__c='Minimum Criteria Not Met - HIGH RISK';            
        }
        else if(endUserSavedRecord.Commercial_Commitment_obtained__c == 'No')
        {
            endUserSavedRecord.Entry_Criteria_for_Project_Execution__c='Minimum Criteria Not Met - HIGH RISK';
        }
        return true;             
    }
    
    /******************************
    Method Name: setMECEndUser
    Description: To set the End user saved data
    Paramenters: NA
    Return Value: void 
    *******************************/
    public void setMECEndUser()
    {
        endUserSavedRecord = userMain.mecContractUser;
        endUserSavedRecord.Deal__c=dealId;
        endUserSavedRecord.Version_Number__c=mecVersionId;              
    }
    /**********************************************
    Method Name: saveMECChecklist
    Description: Below method is used to save the MEC Checklist-
                 Entry criteria for Project Execution Tab.    
    Paramenters: NA
    Return Value: PageReference 
    ***********************************************/
    public void saveMECChecklist()
    {
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;
        initializePageMessages();
        if(userList.size()>0)
        {
            boolean isMobArchExist=false;
            boolean isGovExist=false;
            String MobArchPrimaryId=null;
            String MobArchSecondaryId=null;
            String mobArchSecondary1Id=null;
            
            for(MOB_User_Role_Assignment__c mobUser : userList)
            {
                if((('Mobilization Architect'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()) || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId() || dealRecord.Solution_Architect_New__r.SFDC_User__c ==UserInfo.getUserId()) && dealRecord.Has_Mob_Architect_Submitted__c==false) || ('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId())) && dealRecord.Has_Mob_Architect_Submitted__c==true && dealRecord.Has_Gov_Lead_Submitted__c==false)
                {
                    isMobArchExist=true;
                }
                if('Mobilization Architect'.equalsIgnoreCase(mobUser.Role_Name__c))
                {
                    MobArchPrimaryId=mobUser.User_Assigned_New__r.SFDC_User__c;
                    MobArchSecondaryId=mobUser.User_Assigned_Secondary_New__r.SFDC_User__c;
                    
                     MobArchSecondary1Id=mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c;
                }
            }
            if(isMobArchExist==true || userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP))
            {
                setMECEndUser();
                if(endUserSavedRecord.MEC_Submission_End_Date__c==null)
                {
                    prjExecTab=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field is missing: [MEC Submission Date]!'));
                    return;
                }
                if(endUserSavedRecord.Governance_Lead_Review_End_Date__c==null)
                {
                    prjExecTab=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field is missing: [Governance Lead Review Date]!'));
                    return;
                }
                
                /*if(isDateChanged==true)
                {
                    if(endUserSavedRecord.MEC_Submission_End_Date__c < System.today())
                    {
                        prjExecTab=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'MEC Submission Date should always be greater or equal to Today\'s Date!'));
                        return;
                    }
                }*/
                
                if(endUserSavedRecord.MEC_Submission_End_Date__c > endUserSavedRecord.Governance_Lead_Review_End_Date__c)
                {
                    prjExecTab=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Governance Lead Review Date should always be greater or equal to MEC Submission Date!'));
                    return;
                }
                
                
                Boolean status=setMECUserQuestionnaire(false);
                try
                {
                    upsert userMECAnsQuestion;
                    endUserSavedRecord.HAS_Checklist_Version_Changed__c=false; 
                    upsert endUserSavedRecord;                           
                                
                    dealRecord.MEC_Version__c=mecVersionId;
                    if(dealRecord.Has_Mob_Architect_Submitted__c==false)
                    {
                        dealRecord.Has_Mob_Architect_Saved__c=true;                     
                        //Task for Mobilization Architect Primary
                        List<Task> mobPrimArchTask;
                        if(endUserSavedRecord.Primary_Mob_Arch_Task_ID__c!=null)
                        {
                            mobPrimArchTask=[select id from Task where id=:endUserSavedRecord.Primary_Mob_Arch_Task_ID__c];                        
                            if(mobPrimArchTask.size()>0)
                                delete mobPrimArchTask;
                        }
                        Task mobPrimArchTask1= new Task();
                        if(MobArchPrimaryId != null) {
                            mobPrimArchTask1.OwnerId =  id.valueOf(MobArchPrimaryId);
                        }
                        if(mobPrimArchTask1.OwnerId == null)
                        {
                            prjExecTab=true; 
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the Mobilization Architect Primary!'));
                            return;
                        }
                        mobPrimArchTask1.Subject = 'Deal Name- '+dealRecord.name+' MEC Checklist- Pending for Submission!';          
                        mobPrimArchTask1.Status = 'Not Started';
                        mobPrimArchTask1.ActivityDate =  endUserSavedRecord.MEC_Submission_End_Date__c;    
                        mobPrimArchTask1.Description = 'MEC Checklist for following Deal Pending for Submission: \nDeal Name: '+dealRecord.name+'\nMEC Submission End Date:'+endUserSavedRecord.MEC_Submission_End_Date__c+'\n Governance Lead Review End Date: '+endUserSavedRecord.Governance_Lead_Review_End_Date__c;
                        insert mobPrimArchTask1;
                        endUserSavedRecord.Primary_Mob_Arch_Task_ID__c=mobPrimArchTask1.id;
                        
                        //Task for Mobilization Architect Secondary
                        if(MobArchSecondaryId != null)
                        {
                            List<Task> mobSecArchTask;
                            if(endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c!=null)
                            {
                                mobSecArchTask=[select id from Task where id=:endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c];
                                if(mobSecArchTask.size()>0)
                                    delete mobSecArchTask;
                            }               
                            Task mobSecArchTask1= new Task();
                            mobSecArchTask1.OwnerId =  id.valueOf(MobArchSecondaryId);
                            mobSecArchTask1.Subject = 'Deal Name- '+dealRecord.name+' MEC Checklist- Pending for Submission!';        
                            mobSecArchTask1.Status = 'Not Started';        
                            mobSecArchTask1.Description = 'MEC Checklist for following Deal Pending for Submission: \nDeal Name: '+dealRecord.name+'\nMEC Submission End Date:'+endUserSavedRecord.MEC_Submission_End_Date__c+'\n Governance Lead Review End Date: '+endUserSavedRecord.Governance_Lead_Review_End_Date__c;
                            mobSecArchTask1.ActivityDate =  endUserSavedRecord.MEC_Submission_End_Date__c;
                            insert mobSecArchTask1;
                            endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c=mobSecArchTask1.id;                        
                        }
                        
                        // Task for Mobilization Architect Secondary Lead (Secondary 2)
                        
                        if(MobArchSecondary1Id != null)
                        {
                            List<Task> mobSecArchTask;
                            if(endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c!=null)
                            {
                                mobSecArchTask=[select id from Task where id=:endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c];
                                if(mobSecArchTask.size()>0)
                                    delete mobSecArchTask;
                            }               
                            Task mobSecArchTask1= new Task();
                            mobSecArchTask1.OwnerId =  id.valueOf(MobArchSecondary1Id);
                            mobSecArchTask1.Subject = 'Deal Name- '+dealRecord.name+' MEC Checklist- Pending for Submission!';        
                            mobSecArchTask1.Status = 'Not Started';        
                            mobSecArchTask1.Description = 'MEC Checklist for following Deal Pending for Submission: \nDeal Name: '+dealRecord.name+'\nMEC Submission End Date:'+endUserSavedRecord.MEC_Submission_End_Date__c+'\n Governance Lead Review End Date: '+endUserSavedRecord.Governance_Lead_Review_End_Date__c;
                            mobSecArchTask1.ActivityDate =  endUserSavedRecord.MEC_Submission_End_Date__c;
                            insert mobSecArchTask1;
                            endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c=mobSecArchTask1.id;                        
                        }
                        
                        
                        //Task for Solution Architect            
                        if(dealRecord.Solution_Architect_New__c != null)
                        {
                            List<Task> solArchTask;
                            if(endUserSavedRecord.Sol_Arch_Task_ID__c!=null)
                            {
                                solArchTask=[select id from Task where id=:endUserSavedRecord.Sol_Arch_Task_ID__c];
                                if(solArchTask.size()>0)
                                    delete solArchTask;
                            } 
                            Task solArchTask1= new Task();
                            solArchTask1.OwnerId =  dealRecord.Solution_Architect_New__r.SFDC_User__c;                
                            solArchTask1.Subject = 'Deal Name- '+dealRecord.name+' MEC Checklist- Pending for Submission!';         
                            solArchTask1.Status = 'Not Started';
                            solArchTask1.ActivityDate =  endUserSavedRecord.MEC_Submission_End_Date__c;        
                            solArchTask1.Description = 'MEC Checklist for following Deal is open for your review: \nDeal Name: '+dealRecord.name+'\nMEC Submission End Date:'+endUserSavedRecord.MEC_Submission_End_Date__c+'\n Governance Lead Review End Date: '+endUserSavedRecord.Governance_Lead_Review_End_Date__c;
                            insert solArchTask1;
                            endUserSavedRecord.Sol_Arch_Task_ID__c=solArchTask1.id;                        
                        }
                        upsert endUserSavedRecord;
                    }            
                    upsert dealRecord;
                }
                catch(Exception ex)
                {
                    prjExecTab=true;
                    endUserSavedRecord = new MEC_Post_Contract_End_User__c();
                    userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();                           
                    // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'+ex));
                    return;
                }     
                endUserSavedRecord = new MEC_Post_Contract_End_User__c();
                userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
                isDateChanged=false;
                mainQueries();
                prjExecTab=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Entry Criteria for Project Execution Saved Successfully!'));
            }
            else
            {
                showMainMsg=true;            
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'This MEC Checklist has already been Submitted!'));            
                return;
            }
        }
    }
    /**********************************************
    Method Name: doCancelChecklist
    Description: To cancel the checklist 
    Paramenters: NA
    Return Value: PageReference to Deal page
    ***********************************************/
    public PageReference doCancelChecklist()
    {
        PageReference pg=new PageReference('/'+dealId);
        pg.setRedirect(true);
        return pg;
    }
    /**********************************************
    Method Name: submitMECChecklist
    Description: Below method is used to submit the operation.    
    Paramenters: NA
    Return Value:PageReference
    ***********************************************/    
    public PageReference submitMECChecklist()
    {   
        initializePageMessages();
        boolean isMobArchExist=false;
        boolean isGovExist=false;
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; 
        String GovPrimaryId=null;
        String GovSecondaryId=null;
        if(userList.size()>0)
        {
            for(MOB_User_Role_Assignment__c mobUser : userList)
            {               
                if('Mobilization Architect'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                {
                    isMobArchExist=true;
                }
                if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                {
                    isGovExist=true;
                }
                if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c))
                {
                    GovPrimaryId=mobUser.User_Assigned_New__r.SFDC_User__c;
                    GovSecondaryId=mobUser.User_Assigned_Secondary_New__r.SFDC_User__c;
                    
                    
                    GovSecondaryId=mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c;
                }
            }
                if(((isMobArchExist==true || userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) && dealRecord.Has_Mob_Architect_Submitted__c==false) 
                || ((isGovExist==true || userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) && dealRecord.Has_Mob_Architect_Submitted__c==true && dealRecord.Has_Gov_Lead_Submitted__c==false ))
                {
                    if(GovPrimaryId== null && GovSecondaryId== null)
                    {
                        prjExecTab=true; 
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the Mobilization Governance Lead Primary or Mobilization Governance Lead Secondary!'));
                        return null;
                    }
                    setMECEndUser();
                    if(endUserSavedRecord.MEC_Submission_End_Date__c==null)
                    {
                        prjExecTab=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field is missing: [MEC Submission End Date]!'));
                        return null;
                    }
                    if(endUserSavedRecord.Governance_Lead_Review_End_Date__c==null)
                    {
                        prjExecTab=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field is missing: [Governance Lead Review End Date]!'));
                        return null;
                    }
                    /*if(isDateChanged==true)
                    {
                        if(endUserSavedRecord.MEC_Submission_End_Date__c < System.today())
                        {
                            prjExecTab=true;                           
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'MEC Submission Date should always be greater or equal to Today\'s Date!'));
                            return null;
                        }
                    }*/
                    if(endUserSavedRecord.MEC_Submission_End_Date__c > endUserSavedRecord.Governance_Lead_Review_End_Date__c)
                    {
                        prjExecTab=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Governance Lead Review Date should always be greater or equal to MEC Submission Date!'));
                        return null;
                    }
                    
                    Boolean status=setMECUserQuestionnaire(true);
                    if(status==false)
                    {
                        prjExecTab=true; 
                        endUserSavedRecord = new MEC_Post_Contract_End_User__c();
                        userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the Valid Value for Satisfaction Rating field!'));
                        return null;
                    }
                    try
                    {
                        upsert userMECAnsQuestion;
                        endUserSavedRecord.HAS_Checklist_Version_Changed__c=false; 
                        upsert endUserSavedRecord;                
                        dealRecord.MEC_Version__c=mecVersionId;
                        if((isMobArchExist==true || userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) && dealRecord.Has_Mob_Architect_Submitted__c==false)
                        {
                            dealRecord.Has_Mob_Architect_Submitted__c=true;
                            dealRecord.Has_Mob_Architect_Saved__c=true; 
                            
                            //Delete Task for Mobilization Architect Primary
                            List<Task> mobPrimArchTask;
                            if(endUserSavedRecord.Primary_Mob_Arch_Task_ID__c!=null)
                            {
                                mobPrimArchTask=[select id from Task where id=:endUserSavedRecord.Primary_Mob_Arch_Task_ID__c];
                                if(mobPrimArchTask.size()>0)
                                    delete mobPrimArchTask;
                            }            
                            endUserSavedRecord.Primary_Mob_Arch_Task_ID__c='';
                            
                            //Delete Task for Mobilization Architect Secondary
                            List<Task> mobSecArchTask;
                            if(endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c!=null)
                            {
                                mobSecArchTask=[select id from Task where id=:endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c];
                                if(mobSecArchTask.size()>0)
                                    delete mobSecArchTask;
                            }                             
                            endUserSavedRecord.Secondary_Mob_Arch_Task_ID__c='';
                            
                            //Delete Task for Solution Architect            
                            List<Task> solArchTask;
                            if(endUserSavedRecord.Sol_Arch_Task_ID__c!=null)
                            {
                                solArchTask=[select id from Task where id=:endUserSavedRecord.Sol_Arch_Task_ID__c];
                                if(solArchTask.size()>0)
                                    delete solArchTask;
                            }                
                            endUserSavedRecord.Sol_Arch_Task_ID__c='';
                            
                            //Task for Mobilization Governance Lead Primary
                            if(GovPrimaryId!= null)
                            {
                                List<Task> govPrimTask;
                                if(endUserSavedRecord.Primary_Gov_Lead_task_ID__c!=null)
                                {
                                    govPrimTask=[select id from Task where id=:endUserSavedRecord.Primary_Gov_Lead_task_ID__c];
                                    if(govPrimTask.size()>0)
                                        delete govPrimTask;
                                }
                                Task govPrimTask1= new Task();
                                govPrimTask1.OwnerId =  id.valueOf(GovPrimaryId);                      
                                govPrimTask1.Subject = 'Deal Name- '+dealRecord.name+' MEC Checklist- Pending for Submission!';           
                                govPrimTask1.Status = 'Not Started';
                                govPrimTask1.ActivityDate =  endUserSavedRecord.Governance_Lead_Review_End_Date__c;        
                                govPrimTask1.Description = 'MEC Checklist for following Deal Pending for Submission: \nDeal Name: '+dealRecord.name+'\nMEC Submission End Date:'+endUserSavedRecord.MEC_Submission_End_Date__c+'\n Governance Lead Review End Date: '+endUserSavedRecord.Governance_Lead_Review_End_Date__c;
                                insert govPrimTask1;
                                endUserSavedRecord.Primary_Gov_Lead_task_ID__c=govPrimTask1.id;
                            }
                            
                            //Task for Mobilization Governance Lead Secondary
                            if(GovSecondaryId!= null)
                            {
                                List<Task> govSecTask;
                                if(endUserSavedRecord.Secondary_Gov_Lead_Task_ID__c!=null)
                                {
                                    govSecTask=[select id from Task where id=:endUserSavedRecord.Secondary_Gov_Lead_Task_ID__c];
                                    if(govSecTask.size()>0)
                                        delete govSecTask;
                                }
                                Task govSecTask1= new Task();
                                govSecTask1.OwnerId =  id.valueOf(GovSecondaryId);                
                                govSecTask1.Subject = 'Deal Name- '+dealRecord.name+' MEC Checklist- Pending for Submission!';            
                                govSecTask1.Status = 'Not Started';
                                govSecTask1.ActivityDate =  endUserSavedRecord.Governance_Lead_Review_End_Date__c;         
                                govSecTask1.Description = 'MEC Checklist for following Deal is pending for Submission: \nDeal Name: '+dealRecord.name+'\nMEC Submission End Date:'+endUserSavedRecord.MEC_Submission_End_Date__c+'\n Governance Lead Review End Date: '+endUserSavedRecord.Governance_Lead_Review_End_Date__c;
                                insert govSecTask1;
                                endUserSavedRecord.Secondary_Gov_Lead_Task_ID__c = govSecTask1.id; 
                            }
                        }
                        else if((isGovExist==true || userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) && dealRecord.Has_Mob_Architect_Submitted__c==true && dealRecord.Has_Gov_Lead_Submitted__c==false)
                        {
                            dealRecord.Has_Gov_Lead_Submitted__c=true;
                            //Delete Task for Mobilization Governance Lead Primary
                            List<Task> govPrimTask;
                            if(endUserSavedRecord.Primary_Gov_Lead_task_ID__c!=null)
                            {
                                govPrimTask=[select id from Task where id=:endUserSavedRecord.Primary_Gov_Lead_task_ID__c];
                                if(govPrimTask.size()>0)
                                    delete govPrimTask;
                            }            
                            endUserSavedRecord.Primary_Gov_Lead_task_ID__c='';
                            
                            //Delete Task for Mobilization Governance Lead Secondary
                            List<Task> govSecTask;
                            if(endUserSavedRecord.Secondary_Gov_Lead_Task_ID__c!=null)
                            {
                                govSecTask=[select id from Task where id=:endUserSavedRecord.Secondary_Gov_Lead_Task_ID__c];
                                if(govSecTask.size()>0)
                                    delete govSecTask;
                            }                
                            endUserSavedRecord.Secondary_Gov_Lead_Task_ID__c = ''; 
                        }           
                        upsert dealRecord;
                        upsert endUserSavedRecord;  
                        
                    }
                    catch(Exception ex)
                    {
                        prjExecTab=true;
                        endUserSavedRecord = new MEC_Post_Contract_End_User__c();
                        userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
                        return null;
                    }
                    endUserSavedRecord= new MEC_Post_Contract_End_User__c();
                    userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
                    isDateChanged=false;
                    mainQueries();             
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Entry Criteria for Project Execution Submitted Successfully!')); 
                    PageReference pg;
                    if((userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)) && dealRecord.Has_Mob_Architect_Submitted__c==true && dealRecord.Has_Gov_Lead_Submitted__c==false)       
                    {
                        pg=Page.MECChecklist_Inline; 
                    }
                    else
                    {
                        pg=Page.MECChecklist_InlineReadOnly; 
                    }
                    pg.getParameters().put('id', dealId);
                    pg.getParameters().put('itemValue', tabValue);
                    pg.setRedirect(true);
                    return pg;
                }
                else
                {
                    showMainMsg=true;            
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'This MEC Checklist has already been Submitted!'));            
                    return null;
                }
            return null;
        }
        else
        {
            return null;
        }
    }
    
    /**********************************************
    Method Name: getActionFunction
    Description: To save the records in one go.    
    Paramenters: NA
    Return Value: void 
    ***********************************************/
    public void getActionFunction()
    {
        if(dealRecord.Has_Mob_Architect_Saved__c==false)
        {
            if(deleteUserMECQuestionList!=null)
                delete deleteUserMECQuestionList;
            //endUserSavedRecord = new MEC_Post_Contract_End_User__c();
            //userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
            setMECEndUser();
            setMECUserQuestionnaire(false);
            upsert endUserSavedRecord;
            endUserSavedRecord.HAS_Checklist_Version_Changed__c=false;            
            upsert userMECAnsQuestion;
            userMECDataList=[select Capability_Assessment__c, HAS_Checklist_Version_Changed__c, MEC_Submission_End_Date__c, Primary_Mob_Arch_Task_ID__c, Secondary_Mob_Arch_Task_ID__c, Sol_Arch_Task_ID__c, Primary_Gov_Lead_task_ID__c, Secondary_Gov_Lead_Task_ID__c, Governance_Lead_Review_End_Date__c, Governance_Lead_Comments__c, Commercial_Commitment_obtained__c, Entry_Criteria_for_Project_Execution__c, Stage__c, Tier_Rating__c, id, name from MEC_Post_Contract_End_User__c where Deal__c=:dealId];
            userMECQuestionList = [select Category_Name__c, Is_Mandatory__c, Comments__c, Criteria__c, Satisfaction_Rating__c, id, name from MEC_Post_Contract_End_User_Questionnaire__c where Deal__c=:dealId];        
            userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
        }
        else if(dealRecord.Has_Gov_Lead_Submitted__c==false && userMECDataList.size()>0)
        {
            if(userMECDataList[0].HAS_Checklist_Version_Changed__c==true)
            {
                if(deleteUserMECQuestionList!=null)
                    delete deleteUserMECQuestionList;
                //endUserSavedRecord = new MEC_Post_Contract_End_User__c();
                //userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
                setMECEndUser();
                setMECUserQuestionnaire(false);
                endUserSavedRecord.HAS_Checklist_Version_Changed__c=false;
                upsert endUserSavedRecord;
                upsert userMECAnsQuestion;
                userMECDataList=[select Capability_Assessment__c, HAS_Checklist_Version_Changed__c, MEC_Submission_End_Date__c, Primary_Mob_Arch_Task_ID__c, Secondary_Mob_Arch_Task_ID__c, Sol_Arch_Task_ID__c, Primary_Gov_Lead_task_ID__c, Secondary_Gov_Lead_Task_ID__c, Governance_Lead_Review_End_Date__c, Governance_Lead_Comments__c, Commercial_Commitment_obtained__c, Entry_Criteria_for_Project_Execution__c, Stage__c, Tier_Rating__c, id, name from MEC_Post_Contract_End_User__c where Deal__c=:dealId];
                userMECQuestionList = [select Category_Name__c, Is_Mandatory__c, Comments__c, Criteria__c, Satisfaction_Rating__c, id, name from MEC_Post_Contract_End_User_Questionnaire__c where Deal__c=:dealId];        
                userMECAnsQuestion = new List<MEC_Post_Contract_End_User_Questionnaire__c>();
            }
        }
        intCount=2;
    }
    /**********************************************
    Method Name: checkDateChange
    Description: Check if MEC submission date is changed.    
    Paramenters: NA
    Return Value: void 
    ***********************************************/
    public void checkDateChange()
    {
        isDateChanged=true;
    }
}