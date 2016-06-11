/*
Author : Mayank Tayal
Story  :   Story_0094/MOB__019 and Story_0100/MOB_022
Description : As KT Lead, I should able to initiate & complete SRAT as planned in High level mobilization plan 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    MOB_029/030/031/032        4 March 2013        Added Log RAID Button and functionality   

*/
global class SRATChecklist_KTLeadInlineController{    
    public String sratId{get;set;}
    public List<SRAT_Section_Questionnaire__c> listSectionQuestionActual{get;set;}
    public List<SRAT_VERSION__c> sratVersion{get;set;}
    public List<SRAT_VERSION__c> sratVersionInactive{get;set;}
    public String sratVersionId{get;set;}
    public String sratName{get;set;}
    public SRAT__c sratRecord{get;set;}
    public List<SRAT__c> sratRecordList{get;set;}
    public Wave_Plan_Version__c waveVersionRecord{get;set;}
    public List<Wave_Plan_Version__c> waveVersionRecordList{get;set;}
    public SRAT_User_Section_Question__c userSecQues{get;set;}
    public SRAT_User_Sub_Section_Question__c userSubSecQues{get;set;}
    public SRAT_Sub_Section_Name__c subSectionName{get;set;}
    public List<SRAT_User_Section_Question__c> listUserSecQues{get;set;}
    public Factory_Specific_Technology__c servDelApp{get;set;}
    public Factory_Specific_Technology__c servManageApp{get;set;}
    public Date Today { get { return Date.today(); }}
    
    //Shridhar.Factory Eng speciic
    public List<MainQuestion> FacEngSpecTabQues;  
    //Page Message Boolean variables
    public Boolean showMainMsg{get;set;}
    public Boolean showMsg1{get;set;}
    public Boolean showMsg2{get;set;}
    public Boolean showMsg3{get;set;}
    public Boolean showMsg4{get;set;}
    public Boolean showMsg5{get;set;}
    public Boolean showMsg6{get;set;}
    public Boolean showMsg71{get;set;}
    public Boolean showMsg72{get;set;}
    public Boolean showMsgNew{get;set;}
    
    public Boolean refreshPage{get;set;}
    public Boolean showForm{get;set;} 
    
    //Lists to get the Questions, Sections, Sub Questions and User Saved Data
    public List<SRAT_Section_Questionnaire__c> tempSecQuesList{get;set;}
    public List<SRAT_Sub_Section_Name__c> subSectionNameList{get;set;}
    public List<SRAT_Sub_Section_Questionnaire__c> subSectionQuesList{get;set;}
    public List<SRAT_User_Section_Question__c> userSecExistList{get;set;}
    public List<SRAT_User_Sub_Section_Question__c> userSubSecExistList{get;set;}
    
    //for D-0902
    public List<Srat__c> sratRecordListForPreviousRagStatus;
    public List<SRAT_User_Section_Question__c> recentlySubmittedUserSecExistList{get;set;}
    public List<SRAT_User_Sub_Section_Question__c> recentlySubmittedUserSubSecExistList{get;set;}
    public SRAT_User_Section_Question__c recentlySubmittedUserSecQues{get;set;}
    public SRAT_User_Sub_Section_Question__c recentlySubmittedUserSubSecQues {get;set;}
    public String setPreviousColor{get; set;}
    
    // D-0902 Ends
    //Mob R1.5 Req 15
    public List<SRAT_User_Sub_Section_Question__c> previousSubmittedUserSubSecExistList{get;set;}
    public List<SRAT_User_Sub_Section_Question__c> previousSubSectionList {get;set;}
    public List<SRAT__C> previousSRAT {get;set;}
    public List<Id> sratIdList {get;set;}
    public Map<String, List<SRAT_User_Sub_Section_Question__c>> mapTitleSubSection {get;set;}
    public boolean isRAGNone {get;set;}
    public boolean isPreviousSRATExist {get;set;}
    public boolean isOmRead {get; set;}
    //Mob R1.5 Req 15 End
    
    public String setColor{get;set;}
    public String setRAGColor{get;set;}
    public List<SRAT_User_Section_Question__c> userAnsSecQues{get;set;}
    public List<SRAT_User_Sub_Section_Question__c> userAnsSubSecQues{get;set;}
    
    //Manage Mobilization Program tab variables
    public List<MainQuestion> manageQuestion;  
    
    //BPO Mobilization Controls tab variables
    public List<MainQuestion >BPOMobCtrlQuestionnaire;     
    
    //OM Readiness Summary tab variables
     public List<MainQuestion> omReadiness;   
    public List<SubSection> bpoMobSubSecList;
    public List<SRAT_User_Sub_Section_Question__c> bpoMobSubSecQues{get;set;}
    
    //Establish Business Operations tab variables
    public List<MainQuestion> busOpMainQuestion;    
    
    //Implement Delivery Capability tab Variables
    public List<MainQuestion> delCapMainQuestion;    
    
    //Journey Management tab Variables
    public List<MainQuestion> clientChgQuestion;    
    
    //Factory Engagement Specific tab variables
    public List<MainQuestion> facEngSpcQuestion;
      
    
    //Factory Specific technology tab variables
    public List<Factory_Specific_Technology__c> listOfServiceDelApp{get;set;}
    public List<Factory_Specific_Technology__c> listOfServiceManageApp{get;set;}
    public List<Factory_Specific_Technology__c> facSpecificTechnology{get;set;}
    
    public Integer intCount{get;set;}
    public Decimal questionNumber{get;set;}
    
    public boolean isCalledFromSave{get;set;}
    public boolean isCalledFromSubmit{get;set;}
    
    // for D-1847 
    public boolean isOmReadinessTabVisible {get; set;}    
    
    /**************************************************
    Class Name: MainQuestion
    Description: To retrieve the Main Questionnaires
                 and set RAG Color values
    ***************************************************/
    public class MainQuestion
    {
        Public SRAT_User_Section_Question__c secQuestion{get;set;}
        public SRAT_User_Section_Question__c recentlySubmittedSecQuestion{get;set;}
        public List<SubSection> subSec{get;set;}
        public String color{get;set;}
        public String RAGColor{get;set;}
        public String PreviousRAGColor{get;set;}
        
       /*****************************************
        Method Name: MainQuestion
        Description: Constructor                 
        ******************************************/
        public MainQuestion(SRAT_User_Section_Question__c secQuestion,SRAT_User_Section_Question__c recentlySubmittedSecQuestion, 
                                                            List<SubSection> subSec,String color,String RAGColor, String PreviousRAGColor)
        {
            this.recentlySubmittedSecQuestion = recentlySubmittedSecQuestion;
            this.secQuestion=secQuestion;
            this.subSec=subSec;
            this.color=color;
            this.RAGColor=RAGColor;
            this.PreviousRAGColor = PreviousRAGColor;
        }
        /*****************************************
        Method Name: MainQuestion
        Description: Constructor                 
        ******************************************/
        public MainQuestion(SRAT_User_Section_Question__c secQuestion, List<SubSection> subSec,String color,String RAGColor)
        {
            this.secQuestion=secQuestion;
            this.subSec=subSec;
            this.color=color;
            this.RAGColor=RAGColor;
        }
        /*****************************************
        Method Name: MainQuestion
        Description: Constructor                 
        ******************************************/
        public MainQuestion(SRAT_User_Section_Question__c secQuestion, List<SubSection> subSec)
        {
            this.secQuestion=secQuestion;
            this.subSec=subSec;            
        }
    }
    /*****************************************
    Class Name: SubSection
    Description: To retrieve the Sub Sections                 
    ******************************************/
    public class SubSection
    {
        Public SRAT_Sub_Section_Name__c subSection{get;set;}
        public List<SubQuestion> subQues{get; set;}
        /*****************************************
        Method Name: SubSection
        Description: Constructor                 
        ******************************************/
        public SubSection(SRAT_Sub_Section_Name__c subSection, List<SubQuestion> subQues)
        {
            this.subSection=subSection;
            this.subQues=subQues;
        }
    }
    /********************************************************
    Class Name: SubQuestion
    Description: To retrieve the Sub-Section Questionnaires
                 and set RAG Color values
    *********************************************************/
    public class SubQuestion
    {
        Public SRAT_User_Sub_Section_Question__c subSecQuestion{get;set;}
        Public SRAT_User_Sub_Section_Question__c recentlySubmittedSubSecQuestion{get;set;}
        public String RAGStatusColor{get;set;}
        public Decimal questionNo{get;set;}
        public String PreviousRagStatusColor{get;set;}
        public List<PreviousSubSec> prvSubSec {get;set;}
        public Boolean isPrevious {get; set;}
        /*****************************************
        Method Name: SubQuestion
        Description: Constructor                 
        ******************************************/
        public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, SRAT_User_Sub_Section_Question__c recentlySubmittedSubSecQuestion, 
                                        String RAGStatusColor, String PreviousRagStatusColor, List<PreviousSubSec> prvSubSec, Boolean isPrevious)
        {
            this.recentlySubmittedSubSecQuestion = recentlySubmittedSubSecQuestion ;
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
            this.PreviousRagStatusColor = PreviousRagStatusColor;
            this.prvSubSec = prvSubSec;
            this.isPrevious = isPrevious;
        }
        /*****************************************
        Method Name: SubQuestion
        Description: Constructor                 
        ******************************************/
        public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, String RAGStatusColor)
        {
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
        }  
        /*****************************************
        Method Name: SubQuestion
        Description: Constructor                 
        ******************************************/      
        public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, String RAGStatusColor, Decimal questionNo)
        {
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
            this.questionNo=questionNo;
        }
    }
     /********************************************************
    Class Name: PreviousSubSec
    Description: To retrieve the previous Sub-Section Questionnaires
                 and set RAG Color values
    *********************************************************/
    global class PreviousSubSec implements Comparable {
        public SRAT_User_Sub_Section_Question__c preSubSecQuestion{get;set;}
        public Boolean isApproved {get; set;}
        public String item {get; set;}
        public String RAGStatusColor{get;set;}
         /*****************************************
        Method Name: PreviousSubSec
        Description: Constructor                 
        ******************************************/      
        public PreviousSubSec (SRAT_User_Sub_Section_Question__c preSubSecQuestion, Boolean isApproved, String item, String RAGStatusColor) {
            this.preSubSecQuestion =  preSubSecQuestion;
            this.isApproved = isApproved;
            this.item = item;
            this.RAGStatusColor = RAGStatusColor;
        }
        global Integer compareTo(Object compareTo) {
            PreviousSubSec compareToObj = (PreviousSubSec)compareTo;
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if(preSubSecQuestion.SRAT__r.Days_Before_Go_Live_Date__c > compareToObj.preSubSecQuestion.SRAT__r.Days_Before_Go_Live_Date__c) {
                // Set return value to a positive value.
                 returnValue = 1;
            }
            else if(preSubSecQuestion.SRAT__r.Days_Before_Go_Live_Date__c < compareToObj.preSubSecQuestion.SRAT__r.Days_Before_Go_Live_Date__c) {
                // Set return value to a negative value.
                returnValue = -1;
            }
            return returnValue;
        }
    }
    /******************************
    Method Name:SRATChecklist_KTLeadInlineController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
    public SRATChecklist_KTLeadInlineController(ApexPages.StandardController controller) {
        servDelApp=new Factory_Specific_Technology__c();
        servManageApp=new Factory_Specific_Technology__c();
        List<SRAT_Section_Questionnaire__c> tempSecQuesList=new List<SRAT_Section_Questionnaire__c>();
        List<SRAT_Sub_Section_Name__c> subSectionNameList=new List<SRAT_Sub_Section_Name__c>();
        List<SRAT_Sub_Section_Questionnaire__c> subSectionQuesList=new List<SRAT_Sub_Section_Questionnaire__c>();
        List<SRAT_User_Section_Question__c> userSecExistList=new List<SRAT_User_Section_Question__c>();
        List<SRAT_User_Sub_Section_Question__c> userSubSecExistList=new List<SRAT_User_Sub_Section_Question__c>();
        listSectionQuestionActual=new List<SRAT_Section_Questionnaire__c>();        
        listUserSecQues=new List<SRAT_User_Section_Question__c>();
        userSecQues = new SRAT_User_Section_Question__c();
        userSubSecQues = new SRAT_User_Sub_Section_Question__c();
        // For D-0902
        recentlySubmittedUserSecQues= new SRAT_User_Section_Question__c(); 
        recentlySubmittedUserSubSecQues = new SRAT_User_Sub_Section_Question__c();   
        //D-0902 Ends       
        userAnsSecQues = new List<SRAT_User_Section_Question__c>();
        userAnsSubSecQues = new List<SRAT_User_Sub_Section_Question__c>();
        //Mob R1.5 Req 15
        mapTitleSubSection = new Map<String,List<SRAT_User_Sub_Section_Question__c>>();
        previousSRAT = new List<SRAT__c>();
        sratIdList = new List<Id>();
        isCalledFromSubmit = false; //Hareesh
        previousSubmittedUserSubSecExistList = new List<SRAT_User_Sub_Section_Question__c>();
        //Mob R1.5 Req 15 End
        sratId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        isOmReadinessTabVisible = true;   
        isPreviousSRATExist = false;     
        isOmRead = false;
        if(sratId!=null)
        {
            sratRecordList=[select Item__c, Has_Deployment_Lead_Submitted__c, Wave_Plan_Version__c,Has_KT_Lead_Submitted__c, Has_KT_Lead_Saved__c,
                        Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c,Deal_Location_lk__r.Deployment_Lead_New__c,
                        Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,
                        Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, 
                        Wave_Plan_lk__r.KT_Lead_New__c,Wave_Plan_lk__r.GO_Live_Date_del__c, Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__c, 
                        Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, Planned_Date__c, id, name,
                        Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__c,Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,
                        Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__c,Days_Before_Go_Live_Date__c from SRAT__c where id=:sratId];
            
            if(sratRecordList.size()>0)
            {
                //D-1847 Starts
                if(sratRecordLIst[0].Wave_Plan_lk__r.GO_Live_Date_del__c > (sratRecordLIst[0].Planned_Date__c).adddays(30) ) 
                {
                    isOmReadinessTabVisible = false;
                }
                //D-1847 Ends                
                showForm=true;
                sratRecord=sratRecordList[0];
                //for D-0902 
                sratRecordListForPreviousRagStatus = new List<Srat__c>();
                sratRecordListForPreviousRagStatus  = [select RAG_Status__c, Overall_SRAT_RAG_status__c, Planned_Date__c from SRAT__c 
                                                        where Has_KT_Lead_Submitted__c =: true AND Wave_Plan_lk__c =: sratRecord.Wave_Plan_lk__c 
                                                        ORDER by Planned_Date__c Desc];
                if(sratRecordListForPreviousRagStatus != null && sratRecordListForPreviousRagStatus.Size()>0) {
                    If(sratRecordListForPreviousRagStatus[0].Planned_Date__c < sratRecord.Planned_Date__c) {
                        Id recentlySubmittedSRATId = sratRecordListForPreviousRagStatus[0].Id;
                        recentlySubmittedUserSecExistList = [select SRAT_Section_Questionnaire__c,IS_Factory_Engagement_Spc_Record__c, 
                                                                Question_Description__c, Default_RAG_Status__c, Category__c, Comments__c, Overall_RAG_Status__c,
                                                                 Title__c from SRAT_User_Section_Question__c where SRAT__c=:recentlySubmittedSRATId ];
                        recentlySubmittedUserSubSecExistList = [select Reference__c,IS_Factory_Engagement_Spc_Record__c,Handover_to_Service_Delivery__c, Measurement__c, 
                                                                SRAT_Sub_Section_Questionnaire__c, Question_Description__c, Category__c, Comments__c,
                                                                 RAG_Status__c, Title__c from SRAT_User_Sub_Section_Question__c where SRAT__c=:RecentlySubmittedSRATId];
                    }
                }
                // D-0902 Ends
                
                waveVersionRecordList=[select Deal__r.name, Deal__c, Deal__r.id, name,id from Wave_Plan_Version__c where id=:sratRecord.Wave_Plan_Version__c];
                if(waveVersionRecordList.size()>0)
                {
                    waveVersionRecord=waveVersionRecordList[0];   
                    //Mob R1.5 Req 15
                   /* allSratforWPV = [Select Comments__c,Has_Deployment_Lead_Submitted__c,Has_KT_Lead_Submitted__c,Item__c,SRAT_Item_Master_Id__c,
                                        SRAT_Item_Master_Id__r.Days_Before_Go_Live_Date__c From SRAT__C Where Wave_Plan_Version__c =:waveVersionRecord.Id ];    */
                    for(SRAT__C srat : [Select Comments__c,Has_Deployment_Lead_Submitted__c,Has_KT_Lead_Submitted__c,Item__c,SRAT_Item_Master_Id__c,
                                        Days_Before_Go_Live_Date__c From SRAT__C Where Wave_Plan_Version__c =:waveVersionRecord.Id  and Deal_Location_lk__c = : sratRecord.Deal_Location_lk__c 
                                        and Wave_Plan_lk__c = : sratRecord.Wave_Plan_lk__c order by Days_Before_Go_Live_Date__c])   {
                        if(srat.Days_Before_Go_Live_Date__c < sratRecord.Days_Before_Go_Live_Date__c) {
                            sratIdList.add(srat.Id);
                            previousSRAT.add(srat);
                        }
                    }   
                    //Mob R1.5 Req 15 END                                                     
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_WAVE_PLAN_EXIST));
                    showMainMsg=true;
                    showForm=false;
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_SRAT_EXIST));
                showMainMsg=true;
                showForm=false;
            }
            sratVersion=[select SRAT_Name__c, id, name from SRAT_VERSION__c where isActive__c=:true limit 500];
            if(sratVersion.size()>0)
            {
                sratVersionId=sratVersion[0].id;
                sratName=sratVersion[0].SRAT_Name__c;                                   
                listOfServiceDelApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c,
                                         Volume_of_Transactions__c from Factory_Specific_Technology__c 
                                         where Application_Type__c=: UTIL_Constants.SERVICE_DELIVERY_APPLICATIONS and SRAT__c=:sratId 
                                         and SRAT_Version__c=:sratVersionId order by createddate desc limit 1000];
                listOfServiceManageApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, 
                                            Volume_of_Transactions__c from Factory_Specific_Technology__c 
                                            where Application_Type__c=: UTIL_Constants.SERVICE_MANAGEMENT_APPLICATIONS and SRAT__c=:sratId and 
                                            SRAT_Version__c=:sratVersionId order by createddate desc limit 1000];
                assignMessages();
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_SRAT_ACTIVE));
                showMainMsg=true;
                showForm=false;
            }
            mainQueries();
            intCount=1;            
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_SRAT_ID_EXIST));
            showMainMsg=true;
            showForm=false;
        }
    }
    /******************************
    Method Name: assignMessages
    Description: Method for assigning the rendered value for ApexMessages
    Paramenters: NA
    Return Value: void
    *******************************/
    public void assignMessages()
    {
        List<SRAT_Section_Questionnaire__c> tempSecQues1= [Select SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c 
                                                            from SRAT_Section_Questionnaire__c where Sort_Order__c =:1 and 
                                                            SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId limit 1000];
        if(tempSecQues1.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_NO_QUESTION_SET_MMP));
            showMsg1=true;
        }
      /*  List<SRAT_Sub_Section_Name__c> bpoSubSecList=[select SRAT_Sub_Section_Name__c from SRAT_Sub_Section_Name__c
                                                         where SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId and 
                                                         SRAT_Sub_Section_Name__c=: UTIL_Constants.OM_READINESS_SUMMARY limit 1000];      
        if(bpoSubSecList.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_NO_QUESTION_SET_OMRS));
            showMsg2=true;
        } */
        List<SRAT_Section_Questionnaire__c> tempSecQues2= [Select SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c 
                                                            from SRAT_Section_Questionnaire__c where Sort_Order__c =:2 and 
                                                            SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId limit 1000];
        if(tempSecQues2.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_NO_QUESTION_SET_OMRS));
            showMsg1=true;
        }
        List<SRAT_Section_Questionnaire__c> tempSecQues3= [Select SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c 
                                                            from SRAT_Section_Questionnaire__c where Sort_Order__c =:3 and 
                                                            SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId limit 1000];        
        if(tempSecQues3.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_NO_QUESTION_SET_EBS));
            showMsg3=true;
        }
        List<SRAT_Section_Questionnaire__c> tempSecQues4= [Select SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c 
                                                            from SRAT_Section_Questionnaire__c where Sort_Order__c =:4 and 
                                                            SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId limit 1000];       
        if(tempSecQues4.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_NO_QUESTION_SET_IDC));
            showMsg4=true;
        }
        List<SRAT_Section_Questionnaire__c> tempSecQues5= [Select SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c 
                                                            from SRAT_Section_Questionnaire__c where Sort_Order__c =:5 and 
                                                            SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId limit 1000];        
        if(tempSecQues5.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_NO_QUESTION_SET_JM));
            showMsg5=true;
        }
        
         List<SRAT_Section_Questionnaire__c> tempSecQuesNew= [Select SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c 
                                                            from SRAT_Section_Questionnaire__c where Sort_Order__c =:6 and 
                                                            SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId limit 1000];
        if(tempSecQuesNew.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_NO_QUESTION_SET_BPOMC));
            showMsgNew=true;
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
        showMsg1=false; 
        showMsg2=false; 
        showMsg3=false; 
        showMsg4=false; 
        showMsg5=false; 
        showMsg6=false;
        showMsg71=false;
        showMsg72=false;
        showMsgNew=false;
    }
    /******************************
    Method Name: assignColors
    Description: Method for assigning colors to RAG Status
    Paramenters: coloringField: String
    Return Value: colorName: String
    *******************************/
    public String assignColors(String coloringField)
    {
        String colorName;
        if(coloringField== UTIL_Constants.DEFAULT_A_INCOMPLETE_ON_TRACK||coloringField== UTIL_Constants.A_INCOMPLETE_ON_TRACK)
            colorName= UTIL_Constants.color_FF8C00;
        if(coloringField== UTIL_Constants.DEFAULT_R_INCOMPLETE_OFF_TRACK||coloringField== UTIL_Constants.R_INCOMPLETE_OFF_TRACK)
            colorName=UTIL_Constants.COLOR_RED;
        if(coloringField==  UTIL_Constants.DEFAULT_G_COMPLETE||coloringField== UTIL_Constants.G_COMPLETE)
            colorName=UTIL_Constants.color_006400;
        if(coloringField== UTIL_Constants.DEFAULT_NOT_APPLICABLE||coloringField== UTIL_Constants.NOT_APPLICABLE)
            colorName=UTIL_Constants.COLOR_NOTAPPLICABLE;
        return colorName;
    }
    
    
    /**********************************************
    Method Name: mainQueries
    Description: Queries to get the list of Main Questions, 
                 Sections, Sub-Section Questions and pre-saved 
                 User Checklist data 
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void mainQueries()
    {
        List <SRAT_User_Sub_Section_Question__c> setSubUseSection = new List <SRAT_User_Sub_Section_Question__c>();
        tempSecQuesList = [Select Sort_Order__c, SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c 
                            from SRAT_Section_Questionnaire__c where SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId limit 1000];
        subSectionNameList = [select SRAT_Section_Name__c, SRAT_Section_Name__r.SRAT_Version__c, SRAT_Sub_Section_Name__c
                                 from SRAT_Sub_Section_Name__c order by SRAT_Sub_Section_Name__c ASC limit 1000];
        subSectionQuesList = [select Reference__c,Handover_to_Service_Delivery__c, Measurement__c,SRAT_Sub_Section_Id__c,Title__c, Question_Description__c, Category__c, name 
                                from SRAT_Sub_Section_Questionnaire__c order by Sort_Number__c ASC limit 1000];
        userSecExistList = [select SRAT_Section_Questionnaire__c,IS_Factory_Engagement_Spc_Record__c, Question_Description__c, Default_RAG_Status__c,
                             Category__c, Comments__c, Overall_RAG_Status__c, Title__c from SRAT_User_Section_Question__c where SRAT__c=:sratId limit 1000];
        userSubSecExistList = [select Reference__c,IS_Factory_Engagement_Spc_Record__c,Handover_to_Service_Delivery__c, Measurement__c, SRAT_Sub_Section_Questionnaire__c, 
                                    Question_Description__c, Category__c, Comments__c, RAG_Status__c, Title__c from SRAT_User_Sub_Section_Question__c 
                                    where SRAT__c=:sratId limit 1000];
        //Mob R1.5 Req 15
        if(!sratIdList.isEmpty()) {
            previousSubmittedUserSubSecExistList = [Select Title__c, Question_Description__c, Comments__c, RAG_Status__c, SRAT__c ,SRAT__r.Days_Before_Go_Live_Date__c,Reference__c,
                                                    SRAT__r.Has_Deployment_Lead_Submitted__c, SRAT__r.Item__c  From SRAT_User_Sub_Section_Question__c where SRAT__c IN : sratIdList order by Id limit 1000 ];
            
        }
        if(!previousSubmittedUserSubSecExistList.isEmpty()) {
            for(SRAT_User_Sub_Section_Question__c sratSubSec : previousSubmittedUserSubSecExistList) {
                if(sratSubSec.Title__c  != null) {
                    if(mapTitleSubSection.containsKey(sratSubSec.Title__c)) {
                        setSubUseSection = mapTitleSubSection.get(sratSubSec.Title__c);
                    }
                    else {
                        setSubUseSection = new List <SRAT_User_Sub_Section_Question__c>();
                    }
                    setSubUseSection.add(sratSubSec);
                    mapTitleSubSection.put(sratSubSec.Title__c,setSubUseSection);
                }
                else if (sratSubSec.Reference__c != null) {
                    if(mapTitleSubSection.containsKey(sratSubSec.Reference__c)) {
                        setSubUseSection = mapTitleSubSection.get(sratSubSec.Reference__c);
                    }
                    else {
                        setSubUseSection = new List <SRAT_User_Sub_Section_Question__c>();
                    }
                    setSubUseSection.add(sratSubSec);
                    mapTitleSubSection.put(sratSubSec.Reference__c,setSubUseSection);
                }
            }
        }
        //Mob R1.5 Req 1.5
    }
    
    /**********************************************
    Method Name: setTabQuestionnaires
    Description: Common Function to get the Checklist Questions for Tabs
    Paramenters: NA
    Return Value: List<MainQuestion>
    ***********************************************/
    public List<MainQuestion> setTabQuestionnaires(Integer sortOrder)
    {
        List<MainQuestion> mainQuestion= null;
        List<PreviousSubSec> previousSubSecQuestion = null;
        userSecQues = new SRAT_User_Section_Question__c();
        
        if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
        {
            if(tempSecQuesList!=null)
            {
                //Looping for the Main Questions List
                if(tempSecQuesList.size()>0 )
                {
                    for(SRAT_Section_Questionnaire__c sq : tempSecQuesList)
                    {      
                        
                        if(sq.Sort_Order__c == sortOrder)
                        {
                            mainQuestion= new List<MainQuestion>();
                            List<SubSection> subSecList=new List<SubSection>();
                            if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                            {
                                if(subSectionNameList!=null)
                                {
                                    if(subSectionNameList.size()>0)
                                    {
                                        //Looping for the Sub Section Names List 
                                        for(SRAT_Sub_Section_Name__c ssn : subSectionNameList)
                                        {     
                                            if(ssn.SRAT_Section_Name__c==sq.SRAT_Section_Name__c)
                                            {
                                                List<SubQuestion> subQuesList=new List<SubQuestion>();
                                                String subRAGColor= UTIL_Constants.EMPTY_STRING;
                                                String previousSubRAGColor = UTIL_Constants.EMPTY_STRING;
                                                if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                                                {
                                                    if(subSectionQuesList!=null)
                                                    {
                                                        if(subSectionQuesList.size()>0)
                                                        {
                                                        system.debug('++++subSectionQuesList++++'+subSectionQuesList);
                                                            //Looping for the Sub Section Questions List
                                                            for(SRAT_Sub_Section_Questionnaire__c subq : subSectionQuesList)
                                                            {  
                                                                userSubSecQues = new SRAT_User_Sub_Section_Question__c(); 
                                                                previousSubSectionList = new List<SRAT_User_Sub_Section_Question__c>();           
                                                                if(subq.SRAT_Sub_Section_Id__c==ssn.id)
                                                                {    
                                                                    if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                                                                    { 
                                                                        if(userSubSecExistList.size()>0)
                                                                        {
                                                                            //Looping to get the pre-saved User Sub Section Questions
                                                                            for(SRAT_User_Sub_Section_Question__c subUser : userSubSecExistList)
                                                                            {
                                                                                if(subUser.SRAT_Sub_Section_Questionnaire__c==subq.id)  {
                                                                                        userSubSecQues=subUser;
                                                                                }
                                                                            } 
                                                                             system.debug('!!!!!!subSectionQuesList!!!!'+subSectionQuesList);
                                                                        }
                                                                       
                                                                        else
                                                                        {
                                                                            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ purva-->'+subq);
                                                                            userSubSecQues=new SRAT_User_Sub_Section_Question__c();
                                                                            userSubSecQues.Title__c=subq.Title__c;
                                                                            userSubSecQues.Question_Description__c=subq.Question_Description__c;
                                                                            userSubSecQues.Category__c=subq.Category__c;
                                                                            userSubSecQues.SRAT__c=sratId;
                                                                            userSubSecQues.SRAT_Sub_Section_Questionnaire__c=subq.id;
                                                                            userSubSecQues.Measurement__c=subq.Measurement__c;
                                                                            userSubSecQues.Handover_to_Service_Delivery__c=subq.Handover_to_Service_Delivery__c;
                                                                            userSubSecQues.SRAT_Version__c=sratVersionId;
                                                                            userSubSecQues.Reference__c=subq.Reference__c;
                                                                            system.debug('!+!+!+!subSectionQuesList!!!!'+subSectionQuesList);
                                                                        }
                                                                        subRAGColor=assignColors(userSubSecQues.RAG_Status__c);
                                                                        
                                                                        // for D-0902
                                                                       if(recentlySubmittedUserSubSecExistList != null 
                                                                           && recentlySubmittedUserSubSecExistList.size()>0)
                                                                        {    
                                                                           if((sortOrder == 2) && 
                                                                                (sratRecordLIst[0].Wave_Plan_lk__r.GO_Live_Date_del__c > (sratRecordListForPreviousRagStatus[0].Planned_Date__c).adddays(30) )) 
                                                                            {
                                                                                recentlySubmittedUserSubSecQues.RAG_Status__c=UTIL_Constants.NOT_APPLICABLE;
                                                                            }
                                                                            else {                                                                             
                                                                                //Loop to get pre-saved Sub Questions for Last Or recently submitted Rag Status
                                                                                for(SRAT_User_Sub_Section_Question__c subUser : recentlySubmittedUserSubSecExistList)
                                                                                {
                                                                                    if(subUser.SRAT_Sub_Section_Questionnaire__c==subq.id)
                                                                                    {
                                                                                            recentlySubmittedUserSubSecQues=subUser;
                                                                                    }
                                                                                }
                                                                           }
                                                                       }
                                                                        else {
                                                                            recentlySubmittedUserSubSecQues.RAG_Status__c=UTIL_Constants.NOT_APPLICABLE;          
                                                                        }
                                                                        // D-0902 Ends
                                                                        previousSubRAGColor = assignColors(recentlySubmittedUserSubSecQues.RAG_Status__c);
                                                                    }
                                                                    Boolean isOMTab = false;
                                                                    if(mapTitleSubSection.containsKey(userSubSecQues.Title__c)) {
                                                                        previousSubSectionList = mapTitleSubSection.get(userSubSecQues.Title__c);
                                                                    }
                                                                    else if(mapTitleSubSection.containsKey(userSubSecQues.Reference__c)) {
                                                                        previousSubSectionList = mapTitleSubSection.get(userSubSecQues.Reference__c);
                                                                        isOMTab = true;
                                                                    }
                                                                    PreviousSubSec subSec;
                                                                    Boolean isPreviousRec = false;
                                                                    if(!previousSubSectionList.isEmpty()) {
                                                                        previousSubSecQuestion = new List<PreviousSubSec>();  
                                                                        List<SRAT_User_Sub_Section_Question__c> tempSRATUSerSubSecList = new List<SRAT_User_Sub_Section_Question__c>();
                                                                        if(isOMTab) {
                                                                            tempSRATUSerSubSecList = mapTitleSubSection.get(userSubSecQues.Reference__c);
                                                                            if(tempSRATUSerSubSecList.isEmpty()) {
                                                                                isOmRead = true;
                                                                            }
                                                                        }
                                                                        else {
                                                                            tempSRATUSerSubSecList = mapTitleSubSection.get(userSubSecQues.Title__c);
                                                                        }
                                                                        for(SRAT_User_Sub_Section_Question__c preSubUserSection : tempSRATUSerSubSecList) {
                                                                            previousSubRAGColor = assignColors(preSubUserSection.RAG_Status__c);
                                                                            subSec = new PreviousSubSec(preSubUserSection, preSubUserSection.SRAT__r.Has_Deployment_Lead_Submitted__c, preSubUserSection.SRAT__r.Item__c,previousSubRAGColor);
                                                                            previousSubSecQuestion.add(subSec);
                                                                        }
                                                                        previousSubSecQuestion.sort();
                                                                        String ragStatus = 'Not Applicable';
                                                                        String comments = '';
                                                                        for(PreviousSubSec pre : previousSubSecQuestion) {
                                                                            if(pre.isApproved) {
                                                                                ragStatus = pre.preSubSecQuestion.RAG_Status__c;
                                                                                comments = pre.preSubSecQuestion.Comments__c;
                                                                                //pre.RAGStatusColor = assignColors(pre.preSubSecQuestion.RAG_Status__c);
                                                                            }
                                                                        }
                                                                        if(userSubSecQues.RAG_Status__c == null || userSubSecQues.RAG_Status__c == 'NA' || userSubSecQues.RAG_Status__c == 'Not Applicable') {
                                                                            userSubSecQues.RAG_Status__c = ragStatus;
                                                                        }
                                                                        if(userSubSecQues.Comments__c == null || userSubSecQues.Comments__c == 'NA') {
                                                                            userSubSecQues.Comments__c = comments;
                                                                        }
                                                                        //system.debug('RAG_Status__c------>'+userSubSecQues.RAG_Status__c);
                                                                        subRAGColor = assignColors(userSubSecQues.RAG_Status__c);
                                                                        isPreviousRec = true;
                                                                        isPreviousSRATExist = true;
                                                                    }
                                                                    subQuesList.add(new SubQuestion(userSubSecQues,recentlySubmittedUserSubSecQues,subRAGColor,previousSubRAGColor,previousSubSecQuestion, isPreviousRec));
                                                                    recentlySubmittedUserSubSecQues = new SRAT_User_Sub_Section_Question__c();
                                                               }
                                                            }
                                                        }
                                                    }
                                                }
                                                subSectionName=new SRAT_Sub_Section_Name__c();
                                                subSectionName.SRAT_Sub_Section_Name__c=ssn.SRAT_Sub_Section_Name__c;                
                                                subSecList.add(new SubSection(subSectionName,subQuesList));
                                            }
                                        }
                                    }
                                }
                            }
                            if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                            {                                                                                                            
                                if(userSecExistList.size()>0)
                                {
                                    //Loop to get pre-saved Main Questions for SRAT version and SRAT plan
                                    for(SRAT_User_Section_Question__c user: userSecExistList)
                                    {
                                        if(user.SRAT_Section_Questionnaire__c==sq.id)                               
                                        {
                                            userSecQues=user;
                                        }                                            
                                    }                                  
                                }
                                else
                                {
                                    userSecQues=new SRAT_User_Section_Question__c();
                                    userSecQues.Category__c=sq.Category__c;
                                    userSecQues.Question_Description__c=sq.Question_Description__c;
                                    userSecQues.Title__c=sq.Title__c;
                                    userSecQues.SRAT__c=sratId;
                                    userSecQues.SRAT_Version__c=sratVersionId;
                                    userSecQues.Default_RAG_Status__c=UTIL_Constants.DEFAULT_NOT_APPLICABLE;
                                    userSecQues.SRAT_Section_Questionnaire__c=sq.id;
                                }
                                setRAGColor=assignColors(userSecQues.Overall_RAG_Status__c);            
                                setColor=assignColors(userSecQues.Default_RAG_Status__c);
                                
                                // for D-0902
                                
                                if(recentlySubmittedUserSecExistList != null 
                                   && recentlySubmittedUserSecExistList.size()>0)
                                {
                                    if(sortOrder == 2 && (sratRecordLIst[0].Wave_Plan_lk__r.GO_Live_Date_del__c > (sratRecordListForPreviousRagStatus[0].Planned_Date__c).adddays(30) )) 
                                    {
                                        recentlySubmittedUserSecQues.Default_RAG_Status__c=UTIL_Constants.DEFAULT_NOT_APPLICABLE;
                                    }
                                    else { 
                                    //Loop to get pre-saved Main Questions for Last Or recently submitted Rag Status
                                        for(SRAT_User_Section_Question__c user: recentlySubmittedUserSecExistList)
                                        {
                                            if(user.SRAT_Section_Questionnaire__c==sq.id)                               
                                            {
                                                recentlySubmittedUserSecQues=user;
                                            }                                            
                                        }
                                    }                                  
                                }
                                else
                                {
                                    recentlySubmittedUserSecQues.Default_RAG_Status__c=UTIL_Constants.DEFAULT_NOT_APPLICABLE;
                                }
                                setPreviousColor = assignColors(recentlySubmittedUserSecQues.Default_RAG_Status__c);
                            }
                            mainQuestion.add(new MainQuestion(userSecQues,recentlySubmittedUserSecQues,subSecList,setColor,setRAGColor,setPreviousColor));
                            recentlySubmittedUserSecQues = new SRAT_User_Section_Question__c();
                        }
                    }
                }
            }
        }
        return mainQuestion;
    }
    
    /******************************
    Method Name: setUserAnswers
    Description: To set the user saved records in the Lists
    Paramenters: List<MainQuestion> mainQuestionAnswer
    Return Value: String 
    *******************************/
    public String setUserAnswers(List<MainQuestion> mainQuestionAnswer)
    {        
        if(mainQuestionAnswer!=null)
        {
            if(mainQuestionAnswer.size()>0)
            {
                for(MainQuestion mq: mainQuestionAnswer)
                {            
                    Integer redCnt=0, amberCnt=0, greenCnt=0, naCnt=0;
                    if(mq.subSec!=null)
                    {
                        if(mq.subSec.size()>0)
                        {
                            for(SubSection ss:mq.subSec)
                            {
                                if(ss.subQues!=null)
                                {
                                    if(ss.subQues.size()>0)
                                    {
                                        for(SubQuestion sq:ss.subQues)
                                        {
                                            userAnsSubSecQues.add(sq.subSecQuestion); 
                                            if(isCalledFromSubmit)
                                            {  
                                                if(sq.subSecQuestion.RAG_Status__c==null || sq.subSecQuestion.RAG_Status__c==UTIL_Constants.EMPTY_STRING)
                                                {
                                                    String ragStatus=UTIL_Constants.NONE;
                                                    return ragStatus;
                                                }
                                            }
                                            else  {
                                                if(sq.subSecQuestion.RAG_Status__c==null || sq.subSecQuestion.RAG_Status__c==UTIL_Constants.EMPTY_STRING) {
                                                   // String ragStatus=UTIL_Constants.NONE;
                                                    isRAGNone = true;
                                                    //return ragStatus;
                                                }
                                            }
                                        
                                            if((sq.subSecQuestion.RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK || 
                                                    sq.subSecQuestion.RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK) && (sq.subSecQuestion.Comments__c== null || 
                                                    sq.subSecQuestion.Comments__c==UTIL_Constants.EMPTY_STRING))
                                            {
                                                String title;
                                                if(sq.subSecQuestion.Title__c!=null)
                                                    title=sq.subSecQuestion.Title__c;
                                                else if(sq.subSecQuestion.Reference__c!=null)
                                                    title=sq.subSecQuestion.Reference__c;
                                                return title.substringBefore(UTIL_Constants.SPACE_STRING);
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK)
                                                redCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK)
                                                amberCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.G_COMPLETE)
                                                greenCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.NOT_APPLICABLE)
                                                naCnt++;
                                        } 
                                    }
                                }
                            }
                        }
                    }
                    if(redCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_R_INCOMPLETE_OFF_TRACK;
                    else if(amberCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_A_INCOMPLETE_ON_TRACK;
                    else if(greenCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_G_COMPLETE;
                    else
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_NOT_APPLICABLE;
                    if((mq.secQuestion.Overall_RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK || 
                        mq.secQuestion.Overall_RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK) && 
                        (mq.secQuestion.Comments__c== null || mq.secQuestion.Comments__c==UTIL_Constants.EMPTY_STRING))
                    {                        
                        return UTIL_Constants.MAIN_QUESTION;
                    }
                    userAnsSecQues.add(mq.secQuestion);
                }
            }
        }
      //  system.debug('*********'+userAnsSubSecQues);
        return UTIL_Constants.COMPLETE;
    }
    
    /******************************
    Method Name: getQuestionnaire
    Description: To get the Checklist Questions for Manage Mobilization Program tab
    Paramenters: NA
    Return Value: List<MainQuestion>
    *******************************/
   public List<MainQuestion> getQuestionnaire()  {
        manageQuestion= setTabQuestionnaires(1);  
        return manageQuestion;
    }    
    
    /******************************
    Method Name: getBPOMobQuestionnaire
    Description: To get the Checklist Questions for OM Readiness Summary tab
    Paramenters: NA
    Return Value: List<SubSection>
    *******************************/
    public List<MainQuestion> getOMReadinessSummaryQuestionnaire() 
    {
        omReadiness= setTabQuestionnaires(3);    
        return omReadiness;
    }
     /******************************
    Method Name: getBPOMobQuestionnaire
    Description: To get the Checklist Questions for OM Readiness Summary tab
    Paramenters: NA
    Return Value: List<SubSection>
    *******************************/
    public List<SubSection> getBPOMobQuestionnaire() 
    {
        bpoMobSubSecList=new List<SubSection>();
        if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
        {
            if(subSectionNameList!=null)
            {
                if(subSectionNameList.size()>0)
                {
                    //Looping for the Sub Section Names List 
                    for(SRAT_Sub_Section_Name__c ssn : subSectionNameList)
                    {     
                        if(ssn.SRAT_Sub_Section_Name__c==UTIL_Constants.OM_READINESS_SUMMARY&& ssn.SRAT_Section_Name__r.SRAT_Version__c==sratVersionId)
                        {
                            List<SubQuestion> subQuesList=new List<SubQuestion>();
                            String BPOMobSubRAGColor= UTIL_Constants.SPACE_STRING;
                            if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                            {
                                if(subSectionQuesList!=null)
                                {
                                    if(subSectionQuesList.size()>0)
                                    {
                                        //Looping for the Sub Section Questions List
                                        for(SRAT_Sub_Section_Questionnaire__c subq : subSectionQuesList)
                                        {                    
                                            if(subq.SRAT_Sub_Section_Id__c==ssn.id)
                                            {
                                                if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                                                {                                                                                               
                                                    if(userSubSecExistList.size()>0)
                                                    {
                                                        //Looping to get the pre-saved User Sub Section Questions
                                                        for(SRAT_User_Sub_Section_Question__c subUser : userSubSecExistList)
                                                        {
                                                            if(subUser.SRAT_Sub_Section_Questionnaire__c==subq.id)
                                                            {
                                                                userSubSecQues=subUser;
                                                            }
                                                        }                                                                            
                                                    }
                                                    else
                                                    {
                                                        userSubSecQues=new SRAT_User_Sub_Section_Question__c();
                                                        userSubSecQues.Title__c=subq.Title__c;
                                                        userSubSecQues.Question_Description__c=subq.Question_Description__c;
                                                        userSubSecQues.Category__c=subq.Category__c;
                                                        userSubSecQues.Reference__c=subq.Reference__c;
                                                        userSubSecQues.Measurement__c=subq.Measurement__c;
                                                        userSubSecQues.Handover_to_Service_Delivery__c=subq.Handover_to_Service_Delivery__c;
                                                        userSubSecQues.SRAT__c=sratId;
                                                        userSubSecQues.SRAT_Sub_Section_Questionnaire__c=subq.id;
                                                        userSubSecQues.SRAT_Version__c=sratVersionId;
                                                        //userSubSecQues.RAG_Status__c='Not Applicable';  
                                                       // system.debug('@@@@subSectionQuesList!!!!'+subSectionQuesList);                  
                                                    }
                                                    BPOMobSubRAGColor=assignColors(userSubSecQues.RAG_Status__c);
                                                }                    
                                                subQuesList.add(new SubQuestion(userSubSecQues,BPOMobSubRAGColor));
                                            }
                                        }
                                    }
                                }
                            }
                            subSectionName=new SRAT_Sub_Section_Name__c();
                            subSectionName.SRAT_Sub_Section_Name__c=ssn.SRAT_Sub_Section_Name__c;                
                            bpoMobSubSecList.add(new SubSection(subSectionName,subQuesList));
                        }
                    }
                }
            }
        }       
        return bpoMobSubSecList;
    }
    /**********************************************
    Method Name: setFacEngSpecTabQues
    Description: Common Function to get the Checklist Questions for Tabs
    Paramenters: NA
    Return Value: List<MainQuestion>
    ***********************************************/
    public List<MainQuestion> setFacEngSpecTabQues()
    {        
        List<MainQuestion> mainQuestion= new List<MainQuestion>();        
        List<SubSection> subSecList=new List<SubSection>();
        //Added for factory engaement defect start
        boolean subsecExist=false;
        boolean secExist=false;
        //End   
        SRAT_User_Sub_Section_Question__c userSubSecQues=new SRAT_User_Sub_Section_Question__c();
                               
        if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
        {
            List<SubQuestion> subQuesList=new List<SubQuestion>(); 
            if(userSubSecExistList!=null && userSubSecExistList.size()>0)
            {
                 for(SRAT_User_Sub_Section_Question__c subUser : userSubSecExistList)
                {
                 if(subUser.IS_Factory_Engagement_Spc_Record__c) {
                      subsecExist=true;
                    }
                }
            }   
            if(subsecExist)
            {
                Decimal quesNo=5.00;
                //Looping to get the pre-saved User Sub Section Questions
                for(SRAT_User_Sub_Section_Question__c subUser : userSubSecExistList)
                {
                    String subRAGColor=UTIL_Constants.SPACE_STRING; 
                    if(subUser.IS_Factory_Engagement_Spc_Record__c)
                    {
                        userSubSecQues=subUser;
                        quesNo=quesNo+0.01; 
                        subRAGColor=assignColors(userSubSecQues.RAG_Status__c);
                        subQuesList.add(new SubQuestion(userSubSecQues,subRAGColor,quesNo));                        
                    }
                }                                                                            
            }
            else
            {
                Decimal quesNo=5.00;
                for(Integer i=0; i<15; i++)
                {                               
                    String subRAGColor=UTIL_Constants.SPACE_STRING;                                 
                    if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                    { 
                                    
                        userSubSecQues=new SRAT_User_Sub_Section_Question__c();                                                                             
                        userSubSecQues.SRAT__c=sratId;                                                                           
                        userSubSecQues.SRAT_Version__c=sratVersionId;
                        //userSubSecQues.RAG_Status__c='Not Applicable'; 
                        userSubSecQues.IS_Factory_Engagement_Spc_Record__c=true;
                        quesNo=quesNo+0.01;                     
                        subRAGColor=assignColors(userSubSecQues.RAG_Status__c);
                    }                    
                    subQuesList.add(new SubQuestion(userSubSecQues,subRAGColor, quesNo)); 
                }
            }                                   
            SRAT_Sub_Section_Name__c subSectionName=new SRAT_Sub_Section_Name__c();
            subSectionName.SRAT_Sub_Section_Name__c=UTIL_Constants.FACTORY_ENGAGEMENT_SPECIFIC;                
            subSecList.add(new SubSection(subSectionName,subQuesList));
            if(userSecExistList!=null && userSecExistList.size()>0)
            {
                 for(SRAT_User_Section_Question__c sUser : userSecExistList) {
                    if(sUser.IS_Factory_Engagement_Spc_Record__c) {
                      secExist=true;
                    }
                }
            }
            if(secExist) {
                //Loop to get pre-saved Main Questions for SRAT version and SRAT plan
                for(SRAT_User_Section_Question__c sUser : userSecExistList) {
                    //List<SubQuestion> subQuesList=new List<SubQuestion>();
                    String setRAGColor=UTIL_Constants.SPACE_STRING;  
                    if(sUser.IS_Factory_Engagement_Spc_Record__c)
                    {
                        userSecQues=sUser;                                                                                      
                        setRAGColor=assignColors(userSecQues.Overall_RAG_Status__c);            
                        setColor=assignColors(userSecQues.Default_RAG_Status__c);
                        mainQuestion.add(new MainQuestion(userSecQues,subSecList,setColor,setRAGColor));                     
                    }
                }                                  
            }
            else
            {
                userSecQues=new SRAT_User_Section_Question__c();                                                               
                userSecQues.SRAT__c=sratId;
                userSecQues.SRAT_Version__c=sratVersionId;
                userSecQues.Default_RAG_Status__c=UTIL_Constants.DEFAULT_NOT_APPLICABLE;
                //userSecQues.Overall_RAG_Status__c='Not Applicable';
                userSecQues.Category__c=UTIL_Constants.PEOPLE;
                userSecQues.IS_Factory_Engagement_Spc_Record__c=true;            
                setRAGColor=assignColors(userSecQues.Overall_RAG_Status__c);            
                setColor=assignColors(userSecQues.Default_RAG_Status__c);
                mainQuestion.add(new MainQuestion(userSecQues,subSecList,setColor,setRAGColor));            
            } 
        }       
        return mainQuestion;
    }
    /******************************
    Method Name: getFacEngSpcQuestionnaire
    Description: To get the Checklist Questions for Manage Mobilization Program tab
    Paramenters: NA
    Return Value: List<MainQuestion>
    *******************************/
    public List<MainQuestion> getFacEngSpecTabQues() 
    {
        facEngSpcQuestion= setFacEngSpecTabQues();
        return facEngSpcQuestion;
    }

    /******************************
    Method Name: setFacEngSpecUserAnswers
    Description: To set the user saved records in the Lists
    Paramenters: List<MainQuestion> mainQuestionAnswer
    Return Value: void 
    *******************************/
    public void setFacEngSpecUserAnswers(List<MainQuestion> mainQuestionAnswer)
    {      
        if(mainQuestionAnswer!=null)
        {
            if(mainQuestionAnswer.size()>0)
            {
                for(MainQuestion mq: mainQuestionAnswer)
                {          
                    Integer redCnt=0, amberCnt=0, greenCnt=0, naCnt=0;
                    if(mq.subSec!=null)
                    {
                        if(mq.subSec.size()>0)
                        {
                            for(SubSection ss:mq.subSec)
                            {
                                if(ss.subQues!=null)
                                {
                                    if(ss.subQues.size()>0)
                                    {
                                        for(SubQuestion sq:ss.subQues)
                                        {//&& intCount==2
                                            userAnsSubSecQues.add(sq.subSecQuestion);
                                            if(sq.subSecQuestion.Category__c==null)
                                            {
                                                questionNumber=sq.questionNo;
                                                //return UTIL_Constants.MANDATORY_FIELDS;
                                            }
                                            if((sq.subSecQuestion.Title__c!=null && sq.subSecQuestion.Question_Description__c==null) || 
                                                (sq.subSecQuestion.Title__c==null && sq.subSecQuestion.Question_Description__c!=null) )
                                            {                                                
                                                questionNumber=sq.questionNo;
                                                //return UTIL_Constants.MANDATORY_FIELDS;                                               
                                            }
                                            if(((sq.subSecQuestion.RAG_Status__c!=null && sq.subSecQuestion.RAG_Status__c!=UTIL_Constants.NOT_APPLICABLE) ||
                                                        sq.subSecQuestion.Comments__c!= null)&&(sq.subSecQuestion.Title__c==null || 
                                                        sq.subSecQuestion.Question_Description__c==null || sq.subSecQuestion.Category__c==null) )
                                            {                                                
                                                questionNumber=sq.questionNo;
                                                //return UTIL_Constants.MANDATORY_FIELDS;                                               
                                            }                                           
                                            if((sq.subSecQuestion.RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK || 
                                                    sq.subSecQuestion.RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK) && (sq.subSecQuestion.Comments__c== null ||
                                                    sq.subSecQuestion.Comments__c==UTIL_Constants.EMPTY_STRING))
                                            {
                                                questionNumber=sq.questionNo;
                                                //return UTIL_Constants.NO_COMMENTS;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK)
                                                redCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK)
                                                amberCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.G_COMPLETE)
                                                greenCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.NOT_APPLICABLE)
                                                naCnt++;
                                        } 
                                    }
                                }
                            }
                        }
                    }
                    if(redCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_R_INCOMPLETE_OFF_TRACK;
                    else if(amberCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_A_INCOMPLETE_ON_TRACK;
                    else if(greenCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_G_COMPLETE;
                    else
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_NOT_APPLICABLE;
                    if(((mq.secQuestion.Overall_RAG_Status__c!=null && mq.secQuestion.Overall_RAG_Status__c!=UTIL_Constants.NOT_APPLICABLE) ||
                                mq.secQuestion.Comments__c!= null)&&(mq.secQuestion.Title__c==null || mq.secQuestion.Question_Description__c==null) )
                    {                                                
                        //return UTIL_Constants.MANDATORY_FIELDS;
                    }
                    if((mq.secQuestion.Overall_RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK || 
                            mq.secQuestion.Overall_RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK) && (mq.secQuestion.Comments__c== null ||
                             mq.secQuestion.Comments__c==UTIL_Constants.EMPTY_STRING))
                    {                        
                        //return UTIL_Constants.MAIN_QUESTION;
                    }
                    userAnsSecQues.add(mq.secQuestion);
                }
            }
        }
        //return UTIL_Constants.COMPLETE;
    }   

    /******************************
    Method Name: setFacEngSpecUserAnswers1
    Description: To set the user saved records in the Lists
    Paramenters: List<MainQuestion> mainQuestionAnswer
    Return Value: String 
    *******************************/
    public String setFacEngSpecUserAnswers1(List<MainQuestion> mainQuestionAnswer)
    {      
        if(mainQuestionAnswer!=null)
        {
            if(mainQuestionAnswer.size()>0)
            {
                for(MainQuestion mq: mainQuestionAnswer)
                {          
                    Integer redCnt=0, amberCnt=0, greenCnt=0, naCnt=0;
                    if(mq.subSec!=null)
                    {
                        if(mq.subSec.size()>0)
                        {
                            for(SubSection ss:mq.subSec)
                            {
                                if(ss.subQues!=null)
                                {
                                    if(ss.subQues.size()>0)
                                    {
                                        for(SubQuestion sq:ss.subQues)
                                        {//&& intCount==2
                                            //userAnsSubSecQues.add(sq.subSecQuestion);
                                            if(isCalledFromSubmit==true)
                                            {
                                                if(sq.subSecQuestion.RAG_Status__c==null ||sq.subSecQuestion.RAG_Status__c==UTIL_Constants.EMPTY_STRING)
                                                  {
                                                    String ragStatus=UTIL_Constants.NONE;
                                                   // return ragStatus; Hareesh Mob 1.5 Req 15
                                                  }
                                                if(sq.subSecQuestion.Category__c==null)
                                                {
                                                    questionNumber=sq.questionNo;
                                                   // return UTIL_Constants.MANDATORY_FIELDS;
                                                }
                                            }
                                            if((sq.subSecQuestion.Title__c!=null && sq.subSecQuestion.Question_Description__c==null) || 
                                                    (sq.subSecQuestion.Title__c==null && sq.subSecQuestion.Question_Description__c!=null) )
                                            {                                                
                                                questionNumber=sq.questionNo;
                                                //return UTIL_Constants.MANDATORY_FIELDS;                                               
                                            }
                                            if(((sq.subSecQuestion.RAG_Status__c!=null && sq.subSecQuestion.RAG_Status__c!=UTIL_Constants.NOT_APPLICABLE) ||
                                                    sq.subSecQuestion.Comments__c!= null)&&(sq.subSecQuestion.Title__c==null || 
                                                    sq.subSecQuestion.Question_Description__c==null || sq.subSecQuestion.Category__c==null) )
                                            {                                                
                                                questionNumber=sq.questionNo;
                                                //return UTIL_Constants.MANDATORY_FIELDS;                                               
                                            }                                           
                                            if((sq.subSecQuestion.RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK || 
                                                sq.subSecQuestion.RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK) && (sq.subSecQuestion.Comments__c== null || 
                                                sq.subSecQuestion.Comments__c==UTIL_Constants.EMPTY_STRING))
                                            {
                                                questionNumber=sq.questionNo;
                                               // return UTIL_Constants.NO_COMMENTS;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK)
                                                redCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK)
                                                amberCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.G_COMPLETE)
                                                greenCnt++;
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_Constants.NOT_APPLICABLE)
                                                naCnt++;
                                        } 
                                    }
                                }
                            }
                        }
                    }
                    if(redCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_R_INCOMPLETE_OFF_TRACK;
                    else if(amberCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_A_INCOMPLETE_ON_TRACK;
                    else if(greenCnt>0)
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_G_COMPLETE;
                    else
                        mq.secQuestion.Default_RAG_Status__c=UTIL_Constants.DEFAULT_NOT_APPLICABLE;
                    if(((mq.secQuestion.Overall_RAG_Status__c!=null && mq.secQuestion.Overall_RAG_Status__c!=UTIL_Constants.NOT_APPLICABLE) ||
                        mq.secQuestion.Comments__c!= null)&&(mq.secQuestion.Title__c==null || mq.secQuestion.Question_Description__c==null) )
                    {                                                
                        return UTIL_Constants.MANDATORY_FIELDS;
                    }
                    if((mq.secQuestion.Overall_RAG_Status__c==UTIL_Constants.R_INCOMPLETE_OFF_TRACK || 
                            mq.secQuestion.Overall_RAG_Status__c==UTIL_Constants.A_INCOMPLETE_ON_TRACK) && (mq.secQuestion.Comments__c== null || 
                            mq.secQuestion.Comments__c==UTIL_Constants.EMPTY_STRING))
                    {                        
                        return UTIL_Constants.MAIN_QUESTION;
                    }
                    //userAnsSecQues.add(mq.secQuestion);
                }
            }
        }
        return UTIL_Constants.COMPLETE;
    }   
    /******************************
    Method Name: getBusOpsQuestionnaire
    Description: To get the Checklist Questions for Establish Business Operations tab
    Paramenters: NA
    Return Value: List<MainQuestion>
    *******************************/
    public List<MainQuestion> getBusOpsQuestionnaire() 
    {
        busOpMainQuestion= setTabQuestionnaires(4);        
        return busOpMainQuestion;
    }   
    
    /******************************
    Method Name: getDelCapQuestionnaire
    Description: To get the Checklist Questions for Implement Delivery Capability tab
    Paramenters: NA
    Return Value: List<MainQuestion>
    *******************************/
    public List<MainQuestion> getDelCapQuestionnaire() 
    {
        delCapMainQuestion = setTabQuestionnaires(5);
        return delCapMainQuestion;
    }
    
    /******************************
    Method Name: getClientChgQuestionnaire
    Description: To get the Checklist Questions for Journey Management tab
    Paramenters: NA
    Return Value: List<MainQuestion>
    *******************************/
    public List<MainQuestion> getClientChgQuestionnaire() 
    {
        clientChgQuestion = setTabQuestionnaires(6);
        return clientChgQuestion;
    } 
    
     /******************************
    Method Name: getBPOMobCtrlQuestionnaire
    Description: To get the Checklist Questions for BPO Mobilization Controls tab
    Paramenters: NA
    Return Value: List<MainQuestion>
    *******************************/
    public List<MainQuestion> getBPOMobCtrlQuestionnaire() 
    {
        BPOMobCtrlQuestionnaire = setTabQuestionnaires(2);
        //system.debug('BPOMobCtrlQuestionnaire ------------------------->'+BPOMobCtrlQuestionnaire);
        return BPOMobCtrlQuestionnaire;
    } 
    
    /**********************Factory Specific Technology Tab Begins**************************************/
    /**************************************************
    Class Name: FactorySpecTech
    Description: To set RAG Color values for Factory Specific Technology
    ***************************************************/
    public class FactorySpecTech{
        public Factory_Specific_Technology__c facSpecTech{get;set;}
        public String facSpecColor{get;set;}
        /**************************************************
        mathod Name: FactorySpecTech
        Description: To set RAG Color values for Factory Specific Technology
        ***************************************************/
        public FactorySpecTech(Factory_Specific_Technology__c facSpecTech, String facSpecColor)
        {
            this.facSpecTech=facSpecTech;
            this.facSpecColor=facSpecColor;
        }
    }
    /**********************************************
    Method Name: getFactorySpecificList
    Description: To set the color for Service Delivery Application entries
    Paramenters: List<Factory_Specific_Technology__c>
    Return Value: List<FactorySpecTech>
    ***********************************************/
    public List<FactorySpecTech> getFactorySpecificList(List<Factory_Specific_Technology__c> detailRecordList)
    {
        List<FactorySpecTech>  ServAppList=new List<FactorySpecTech>();
        if(detailRecordList!=null)
        {       
            if(detailRecordList.size()>0)
            {
                for(Factory_Specific_Technology__c sp1: detailRecordList )
                {
                    String delvColor=UTIL_Constants.SPACE_STRING;
                    delvColor=assignColors(sp1.RAG_Status__c);
                    ServAppList.add(new FactorySpecTech(sp1,delvColor));
                }
            }
        }
        return ServAppList;
    }
    /**********************************************
    Method Name: getServiceDelApp
    Description: To return the pre-saved list of Service Delivery Application
    Paramenters: NA
    Return Value: List<FactorySpecTech>
    ***********************************************/
    public List<FactorySpecTech> getServiceDelApp() {
        List<FactorySpecTech>  ServDeliveryAppList=getFactorySpecificList(listOfServiceDelApp);        
        return ServDeliveryAppList;
    }
    /**********************************************
    Method Name: initializeSerDelApp
    Description: To set the list of Service Delivery Application records
    Paramenters: NA
    Return Value: List<FactorySpecTech>
    ***********************************************/
    public void initializeSerDelApp() {
        listOfServiceDelApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, Volume_of_Transactions__c 
                                from Factory_Specific_Technology__c where Application_Type__c=:UTIL_Constants.SERVICE_DELIVERY_APPLICATIONS 
                                and SRAT__c=:sratId and SRAT_Version__c=:sratVersionId order by createddate desc limit 1000];
    }
    /**********************************************
    Method Name: getServiceManageApp
    Description: To return the pre-saved list of Service Management Application
    Paramenters: NA
    Return Value: List<FactorySpecTech>
    ***********************************************/
    public List<FactorySpecTech> getServiceManageApp() {
        List<FactorySpecTech>  ServManageAppList=getFactorySpecificList(listOfServiceManageApp);        
        return ServManageAppList;
    }
    /**********************************************
    Method Name: initializeservManageApp
    Description: To set the list of Service Management Application records
    Paramenters: NA
    Return Value: List<FactorySpecTech>
    ***********************************************/
    public void initializeservManageApp() {
        listOfServiceManageApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, Volume_of_Transactions__c
                                     from Factory_Specific_Technology__c where Application_Type__c=:UTIL_Constants.SERVICE_MANAGEMENT_APPLICATIONS 
                                     and SRAT__c=:sratId and SRAT_Version__c=:sratVersionId order by createddate desc limit 1000];
    }
    
    /**********************************************
    Method Name: addservDelApp
    Description: To add new Service Delivery Application record
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void addservDelApp()
    {
        initializePageMessages();
        if(!sratRecord.Has_KT_Lead_Submitted__c && !sratRecord.Has_Deployment_Lead_Submitted__c)
        {            
            if(servDelApp.Application_Name__c==null || servDelApp.Application_Name__c== UTIL_Constants.EMPTY_STRING)
            {
                showMsg71=true;            
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, UTIL_Constants.REQUIRED_FIELD_MISSING_APPLICATION_NAME));
                return;
            }
            servDelApp.SRAT__c=sratid;
            servDelApp.SRAT_Version__c=sratVersionId;
            servDelApp.Application_Type__c=UTIL_Constants.SERVICE_DELIVERY_APPLICATIONS;              
            try
            {
                insert servDelApp;                                 
            } 
            catch(Exception ex)
            {
                showMsg71=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
                initializeSerDelApp();
                initializeservManageApp();            
                return;
            }finally{            
                showMsg71=true;            
            }
            servDelApp=new Factory_Specific_Technology__c();
            initializeSerDelApp();
            initializeservManageApp();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.RECORD_ADDED_SUCCESFULLY));
        }
        else
        {
            showMainMsg=true;
            showMsg71=true;            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.SRAT_CHECKLIST_SUBMITTED));            
        }
    }
    
    /**********************************************
    Method Name: addmanageDelApp
    Description: To add new Service Management Application record
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void addmanageDelApp()
    {
        initializePageMessages();
        if(!sratRecord.Has_KT_Lead_Submitted__c && !sratRecord.Has_Deployment_Lead_Submitted__c)
        {
            if(servManageApp.Application_Name__c==null || servManageApp.Application_Name__c== UTIL_Constants.EMPTY_STRING)
            {
                showMsg72=true;            
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.REQUIRED_FIELD_MISSING_APPLICATION_NAME));
                return;
            }
            servManageApp.SRAT__c=sratid;
            servManageApp.SRAT_Version__c=sratVersionId;
            servManageApp.Application_Type__c=UTIL_Constants.SERVICE_MANAGEMENT_APPLICATIONS;               
            try
            {
                Database.insert(servManageApp);                      
            } 
            catch(Exception ex)
            {
                showMsg72=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
                initializeSerDelApp();
                initializeservManageApp();
                return;
            }
            finally{            
                showMsg72=true;
            }
            servManageApp=new Factory_Specific_Technology__c();
            initializeSerDelApp();
            initializeservManageApp();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.RECORD_ADDED_SUCCESFULLY));
        }
        else {
            showMainMsg=true;
            showMsg72=true;            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.SRAT_CHECKLIST_SUBMITTED));            
        }        
    }
    /**********************Factory Specific Technology Tab Ends**************************************/
    
    /**********************************************
    Method Name: setAllValues
    Description: To set all the Lists and updating/inserting all records
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void setAllValues()
    {                
        facSpecificTechnology.addAll(listOfServiceDelApp);     //Factory Specific Technology Tab
        facSpecificTechnology.addAll(listOfServiceManageApp);  //Factory Specific Technology Tab                  
        system.debug('~~~~~userAnsSecQues~~~~~'+userAnsSecQues);
        //Saving Data from all 6 Tabs

         Database.upsert (userAnsSecQues);
         system.debug('------------>'+userAnsSubSecQues);
         List<SRAT_User_Sub_Section_Question__c> tempList = new List<SRAT_User_Sub_Section_Question__c>();
         Set<SRAT_User_Sub_Section_Question__c> tempSet = new Set<SRAT_User_Sub_Section_Question__c>();
         for(SRAT_User_Sub_Section_Question__c st : userAnsSubSecQues) {
            //tempList.add(st);
            tempSet.add(st);
        }
        system.debug('tempSet:::::::'+tempSet);
        system.debug('userAnsSubSecQues:::::::'+userAnsSubSecQues);
        tempList.addAll(tempSet);
        Database.upsert(tempList);       
        //upsert userAnsSubSecQues;
        //Saving Factory Specific Technology Records
        Database.upsert(facSpecificTechnology);   
        
        
    }
    
    /**********************************************
    Method Name: saveSRATChecklist
    Description: To save the checklist entries
    Paramenters: NA
    Return Value: PageReference to same page
    ***********************************************/
   public PageReference saveSRATChecklist()
    {      
        isCalledFromSubmit=false; 
        isRAGNone = false;
        initializePageMessages();        
        if(!sratRecord.Has_KT_Lead_Submitted__c && !sratRecord.Has_Deployment_Lead_Submitted__c)
        {
            /****For Factory Specific Technology Tab****/        
            facSpecificTechnology= new List<Factory_Specific_Technology__c>();
            try {
                String title=setUserAnswers(manageQuestion);
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 
                            UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.MANAGE_MOBILIZATION_TAB));
                    return null;
                }
                title=setUserAnswers(BPOMobCtrlQuestionnaire);
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 
                            UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.BPO_MOBILIZATION_COTROLS_TAB));
                    return null;
                }
                title=setUserAnswers(omReadiness);
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                            UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION_REFERENCE+title+UTIL_Constants.OM_READINESS_TAB));
                    return null;
                }
                title=setUserAnswers(busOpMainQuestion);
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.EBP_TAB));
                    return null;
                }
                title=setUserAnswers(delCapMainQuestion);
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.IDC_TAB));
                    return null;
                }
                title=setUserAnswers(clientChgQuestion);
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.JOURNEY_TAB));
                    return null;
                }
                setFacEngSpecUserAnswers(facEngSpcQuestion);
                title=setFacEngSpecUserAnswers1(facEngSpcQuestion);
                if(title==UTIL_Constants.MANDATORY_FIELDS)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                            UTIL_Constants.REQUIRED_FIELDS_MISSING_FOR_QUESTION+questionNumber+UTIL_Constants.FACTORY_TAB));
                    return null;
                }
                if(title==UTIL_Constants.NO_COMMENTS)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                                    UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+questionNumber+UTIL_Constants.FACTORY_TAB));
                    return null;
                }
                //setting all the lists and updating/inserting in database
                system.debug('going to set all values');
                setAllValues();
                //Saving SRAT Records          
                sratRecord.Has_KT_Lead_Saved__c=true;
                sratRecord.SRAT_Version__c=sratVersionId;
                sratRecord.Assessment_Text__c = UTIL_Constants.IN_PROGRESS;
                system.debug('list of SRAT Records'+sratRecord);
                upsert sratRecord;
                if(isRAGNone) {
                      
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Save Successful. To submit the checklist the RAG status cannot be –None-.'));
                }
            }
            catch(Exception ex)
            {
                showMainMsg=true;                           
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING+ex));
                return null;
            }
            finally
            {
                userAnsSecQues = new List<SRAT_User_Section_Question__c>();
                userAnsSubSecQues = new List<SRAT_User_Sub_Section_Question__c>();
            }
            showMainMsg=true;
            if(isRAGNone) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Save Successful. To submit the checklist the RAG status cannot be –None-.'));
            }
            else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.SRAT_CHECKLIST_SUCCESSFULLY));
            }
           /* refreshPage=true;      
            PageReference pg=new PageReference(UTIL_Constants.SRAT_CHECKLIST_KT_LEAD_INLINE+sratid);
            pg.setRedirect(true);*/
            return null;
        }
        else
        {
            showMainMsg=true;            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.SRAT_CHECKLIST_SUBMITTED));            
            return null;
        }
    }
    /**********************************************
    Method Name: doCancelChecklist
    Description: To cancel the checklist 
    Paramenters: NA
    Return Value: PageReference to Wave Plan version page
    ***********************************************/
    public PageReference doCancelChecklist()
    {
        PageReference pg=new PageReference('/'+sratRecord.Wave_Plan_Version__c);
        pg.setRedirect(true);
        return pg;
    }
        
    /**********************************************
    Method Name: submitSRATChecklist
    Description: To submit the checklist to Deployement Lead
    Paramenters: NA
    Return Value: PageReference to Checklist ReadOnly page
    ***********************************************/
    public PageReference submitSRATChecklist()
    {
        isCalledFromSubmit=true;
        initializePageMessages();        
        if(!sratRecord.Has_KT_Lead_Submitted__c && !sratRecord.Has_Deployment_Lead_Submitted__c)
        {
            /****For Factory Specific Technology Tab****/        
            facSpecificTechnology= new List<Factory_Specific_Technology__c>();
            if(listOfServiceDelApp!=null)
            {
                if(listOfServiceDelApp.size()>0)
                {
                    for(Factory_Specific_Technology__c fac1: listOfServiceDelApp)
                    {
                        system.debug('#############################' +fac1.Application_Name__c);
                            if(fac1.Application_Name__c==null || fac1.Application_Name__c== UTIL_Constants.EMPTY_STRING)
                            {
                                
                                showMsg71=true;
                                showMsg72=false;
                                showMainMsg=true;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.REQUIRED_FIELD_MISSING_SDA));                          
                                initializeSerDelApp();
                                initializeservManageApp();
                                return null;
                            }
                    }
                }
            }
            if(listOfServiceManageApp!=null)
            {
                if(listOfServiceManageApp.size()>0)
                {
                    for(Factory_Specific_Technology__c fac2: listOfServiceManageApp)
                    {
                            if(fac2.Application_Name__c==null || fac2.Application_Name__c== UTIL_Constants.EMPTY_STRING)
                            {
                                showMsg71=false;
                                showMsg72=true;
                                showMainMsg=true;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.REQUIRED_FIELD_MISSING_SMA));
                                initializeSerDelApp();
                                initializeservManageApp();
                                return null;
                            }
                    }
                }
            }
            try{
                String title=setUserAnswers(manageQuestion);
                 if(title==UTIL_Constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.RAG_STATUS_MMMP_TAB));
                    return null;
                 }
                system.debug('title--------->>>>'+title); 
                if(title!=UTIL_Constants.COMPLETE)
                {                    
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.MANAGE_MOBILIZATION_TAB));
                    return null;
                }
                title=setUserAnswers(BPOMobCtrlQuestionnaire); 
                if(title==UTIL_Constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.RAG_STATUS_BPOMC_TAB ));
                    return null;
                 }
                title=setUserAnswers(omReadiness); 
                if(title==UTIL_Constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.RAG_STATUS_OM_READNIESS_TAB));
                    return null;
                 }
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION_REFERENCE+title+UTIL_Constants.OM_READINESS_TAB));
                    return null;
                }
                title=setUserAnswers(busOpMainQuestion);
                if(title==UTIL_Constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.RAG_STATUS_EBOP_TAB));
                    return null;
                 }
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.EBP_TAB));
                    return null;
                }
                title=setUserAnswers(delCapMainQuestion);
                if(title==UTIL_Constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.RAG_STATUS_DCT_TAB));
                    return null;
                 }
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.IDC_TAB));
                    return null;
                }
                title=setUserAnswers(clientChgQuestion);
                 if(title==UTIL_Constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.RAG_STATUS_JOURNEY_TAB));
                    return null;
                 }
                if(title!=UTIL_Constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+title+UTIL_Constants.JOURNEY_TAB));
                    return null;
                }
                setFacEngSpecUserAnswers(facEngSpcQuestion);
                title=setFacEngSpecUserAnswers1(facEngSpcQuestion);
                if(title==UTIL_Constants.NONE)
                 {
                 showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.RAG_STATUS_FE_SPECFIC_TAB));
                    return null;
                 }
                
                if(title==UTIL_Constants.MANDATORY_FIELDS)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, UTIL_Constants.REQUIRED_FIELDS_MISSING_FOR_QUESTION +questionNumber+UTIL_Constants.FACTORY_TAB));
                    return null;
                }
                if(title==UTIL_Constants.NO_COMMENTS)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_COMMENTS_QUESTION+questionNumber+UTIL_Constants.FACTORY_TAB));
                    return null;
                }
                setAllValues();
                
                if(sratRecord.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c==null && sratRecord.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c ==null && sratRecord.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c==null)                {
                    showMainMsg=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, UTIL_Constants.SELECT_LOCATION_MOBIKIZATION_LEAD));
                    return null;
                }
                //Creating a New Task for Deployment Lead
                if(sratRecord.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c!=null)
                {
                    Task task= new Task();
                    task.OwnerId =  sratRecord.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c;
                    
                    task.Subject = UTIL_Constants.NEW_SRAT_CHECKLIST_PENDING_FOR_SUBMISSION;            
                    task.Status = UTIL_Constants.NOT_STARTED;        
                    task.Description = UTIL_Constants.SRAT_CHECKLIST_PENDING+waveVersionRecord.Deal__r.name+UTIL_Constants.WAVE_PLAN_VERSION+waveVersionRecord.name+UTIL_Constants.SRAT_ITEM+sratRecord.Item__c;
                    Database.insert (task);
                    sratRecord.Deployment_Lead_Task_ID__c=task.id;
                }
                //Creating a New Task for Location Mobilization Lead Secondary
                if(sratRecord.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c!=null)
                {
                    Task task= new Task();
                    task.OwnerId =  sratRecord.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c;
                    
                    task.Subject = UTIL_Constants.NEW_SRAT_CHECKLIST_PENDING_FOR_SUBMISSION;            
                    task.Status = UTIL_Constants.NOT_STARTED;        
                    task.Description = UTIL_Constants.SRAT_CHECKLIST_PENDING+waveVersionRecord.Deal__r.name+UTIL_Constants.WAVE_PLAN_VERSION+waveVersionRecord.name+UTIL_Constants.SRAT_ITEM+sratRecord.Item__c;
                    Database.insert (task);
                    sratRecord.Location_Lead_Secondary_Task_ID__c=task.id;
                }
                if(sratRecord.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c!=null)
                {
                    Task task= new Task();
                    task.OwnerId =  sratRecord.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c;
                    
                    task.Subject = UTIL_Constants.NEW_SRAT_CHECKLIST_PENDING_FOR_SUBMISSION;            
                    task.Status = UTIL_Constants.NOT_STARTED;        
                    task.Description = UTIL_Constants.SRAT_CHECKLIST_PENDING+waveVersionRecord.Deal__r.name+UTIL_Constants.WAVE_PLAN_VERSION+waveVersionRecord.name+UTIL_Constants.SRAT_ITEM+sratRecord.Item__c;
                    Database.insert (task);
                    sratRecord.Location_Lead_Secondary_Task_ID__c=task.id;
                }                
                //Saving the SRAT Record
                sratRecord.Has_KT_Lead_Saved__c=true;
                sratRecord.Has_KT_Lead_Submitted__c=true;
                sratRecord.SRAT_Version__c=sratVersionId;
                upsert sratRecord;                                   
            }
            catch(Exception ex)
            {
                showMainMsg=true;
                if(ex.getMessage().contains(UTIL_Constants.INACTIVE_OWNER_OR_USER)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.NON_SFDC_USER_OPERATION));
                }else{                
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_WHILE_SUBMIT));
                }
                return null;
            }
            finally
            {
                userAnsSecQues = new List<SRAT_User_Section_Question__c>();
                userAnsSubSecQues = new List<SRAT_User_Sub_Section_Question__c>();
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.SRAT_CHECKLIST_SUBMITTED_SUCCESSFULLY));
            String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;                    
            PageReference pg;
            if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOBADMIN))
            {
                pg=new PageReference(UTIL_Constants.SRAT_CHECKLIST_INLINE+sratid);
            }
            else
            {
                pg=new PageReference(UTIL_Constants.SRAT_CHECKLIST_READONLY+sratid);
            }
            pg.setRedirect(true);
            return pg;
        }
        else
        {
            showMainMsg=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.SRAT_CHECKLIST_SUBMITTED));         
            return null;
        }                
    }
    
    public List<SRAT_User_Section_Question__c> initialUserAnsSecQues{get;set;}
    public List<SRAT_User_Sub_Section_Question__c> initialUserAnsSubSecQues{get;set;}
     /**********************************************
    Method Name: getActionFunction
    Description: Action Functions
    ***********************************************/
    public void getActionFunction()
    {
        initialUserAnsSecQues=new List<SRAT_User_Section_Question__c>();
        initialUserAnsSubSecQues=new List<SRAT_User_Sub_Section_Question__c>();
        if(userSecExistList.size()==0 || userSubSecExistList.size()==0)
        {
             setUserAnswers(manageQuestion);     //Manage Mobilization Tab
             setUserAnswers(omReadiness);
             setUserAnswers(BPOMobCtrlQuestionnaire); //BPO Mobilization Controls
            //setBPOMobilization();               //OM Readiness Summary Tab
            setUserAnswers(busOpMainQuestion);  //Establish Business Operations Tab
            setUserAnswers(delCapMainQuestion); //Implement Delivery Capability Tab
            setUserAnswers(clientChgQuestion);  //Journey Management Tab
            setFacEngSpecUserAnswers(facEngSpcQuestion);  //Factory Engagement Specific Tab
            //Saving Data from all 6 Tabs
            initialUserAnsSecQues.addAll(userAnsSecQues);
            initialUserAnsSubSecQues.addAll(userAnsSubSecQues);
            upsert initialUserAnsSecQues;
            upsert initialUserAnsSubSecQues;
            userSecExistList = [select SRAT_Section_Questionnaire__c, IS_Factory_Engagement_Spc_Record__c , Question_Description__c, Default_RAG_Status__c, Category__c, Comments__c, Overall_RAG_Status__c, Title__c from SRAT_User_Section_Question__c where SRAT__c=:sratId];
            userSubSecExistList = [select Reference__c, Measurement__c,Handover_to_Service_Delivery__c, IS_Factory_Engagement_Spc_Record__c , SRAT_Sub_Section_Questionnaire__c, Question_Description__c, Category__c, Comments__c, RAG_Status__c, Title__c from SRAT_User_Sub_Section_Question__c where SRAT__c=:sratId];
            userAnsSecQues = new List<SRAT_User_Section_Question__c>();
            userAnsSubSecQues = new List<SRAT_User_Sub_Section_Question__c>();
        }
        intCount=2;
    }
   
        
    
}