/*
Author : Mayank Tayal
Story  :   Story_0094/MOB__019 and Story_0100/MOB_022
Description : As KT Lead, I should able to initiate & complete SRAT as planned in High level mobilization plan 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    MOB_029/030/031/032        4 March 2013        Added Log RAID Button and functionality   

*/
global class SRATChecklist_InlineController1 {
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
    
    //Page Message Boolean variables
    public Boolean showMainMsg{get;set;}
    public Boolean showMsg1{get;set;}
    public Boolean showMsg2{get;set;}
    public Boolean showMsg3{get;set;}
    public Boolean showMsg4{get;set;}
    public Boolean showMsg5{get;set;}
    public Boolean showMsg6{get;set;}
    public Boolean showMsg7{get;set;}
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
    
    public String setColor{get;set;}
    public String setRAGColor{get;set;}
    public List<SRAT_User_Section_Question__c> userAnsSecQues{get;set;}
    public List<SRAT_User_Sub_Section_Question__c> userAnsSubSecQues{get;set;}
    
    public List<SRAT_User_Section_Question__c> userAnsSecQuesToUpdate = new List<SRAT_User_Section_Question__c>() ;
    public List<SRAT_User_Sub_Section_Question__c> userAnsSubSecQuesToUpdate = new List<SRAT_User_Sub_Section_Question__c>();
    
    //Set to Remove Duplicate Records
    public Set<SRAT_User_Section_Question__c> userAnsSecQuesSet= new Set<SRAT_User_Section_Question__c>();
    public Set<SRAT_User_Sub_Section_Question__c> userAnsSubSecQuesSet = new Set<SRAT_User_Sub_Section_Question__c>();
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
    
    //Journey Management Change tab Variables
    public List<MainQuestion> clientChgQuestion;    
    
    //Factory Engagement Specific tab variables
    public List<MainQuestion> facEngSpcQuestion;    
    
    //Factory Specific technology tab variables
    public List<Factory_Specific_Technology__c> listOfServiceDelApp{get;set;}
    public List<Factory_Specific_Technology__c> listOfServiceManageApp{get;set;}
    public List<Factory_Specific_Technology__c> facSpecificTechnology{get;set;}
    public Decimal questionNumber{get;set;}
    
    public boolean isCalledFromSubmit{get;set;}
    
    // D-1847
    public boolean isOmReadinessTabVisible{get;set;}
    //Mob R1.5 Req 15
    public List<SRAT_User_Sub_Section_Question__c> previousSubmittedUserSubSecExistList{get;set;}
    public List<SRAT_User_Sub_Section_Question__c> previousSubSectionList {get;set;}
    public List<SRAT__C> previousSRAT {get;set;}
    public List<Id> sratIdList {get;set;}
    public Map<String, List<SRAT_User_Sub_Section_Question__c>> mapTitleSubSection {get;set;}
    public boolean isRAGNone {get;set;}
    public boolean isPreviousSRATExist {get;set;}
    public boolean isOmRead {get; set;}
    //Mob R1.5 Req 15
    /**************************************************
    Class Name: MainQuestion
    Description: To retrieve the Main Questionnaires
                 and set RAG Color values
    ***************************************************/
    public class MainQuestion
    {
        Public SRAT_User_Section_Question__c secQuestion{get;set;}
        public List<SubSection> subSec{get;set;}
        public String color{get;set;}
        public String RAGColor{get;set;}
        
         /******************************
        Method Name: MainQuestion
        Description: Constructor for Initializing
        Paramenters: SRAT_User_Section_Question__c, List<SubSection>, string: color,RAGcolor
        Return Value: NA
        *******************************/       
        
        public MainQuestion(SRAT_User_Section_Question__c secQuestion, List<SubSection> subSec,String color,String RAGColor)
        {
            this.secQuestion=secQuestion;
            this.subSec=subSec;
            this.color=color;
            this.RAGColor=RAGColor;
        }
         /******************************
        Method Name: MainQuestion
        Description: Constructor for Initializing
        Paramenters: SRAT_User_Section_Question__c, List<SubSection>
        Return Value: NA
        *******************************/       
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
  
           /******************************
        Method Name: SubSection
        Description: Constructor for Initializing
        Paramenters: SRAT_Sub_Section_Name__c, List<SubQuestion>
        Return Value: NA
        *******************************/             
        
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
        public String RAGStatusColor{get;set;}
        public Decimal questionNo{get;set;}
        public List<PreviousSubSec> prvSubSec {get;set;}
        public Boolean isPrevious {get; set;}
        
         /******************************
        Method Name: SubQuestion
        Description: Constructor for Initializing
        Paramenters: SRAT_User_Sub_Section_Question__c,String: RAGStatusColor>
        Return Value: NA
        *******************************/             
        public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, String RAGStatusColor) {
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
        }  
        /******************************
        Method Name: SubQuestion
        Description: Constructor for Initializing
        Paramenters: SRAT_User_Sub_Section_Question__c,String: RAGStatusColor>
        Return Value: NA
        *******************************/          
         public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, String RAGStatusColor,List<PreviousSubSec> prvSubSec, Boolean isPrevious)  {
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
            this.prvSubSec = prvSubSec;
            this.isPrevious = isPrevious;
        }  
        
         /******************************
        Method Name: SubQuestion
        Description: Constructor for Initializing
        Paramenters: SRAT_User_Sub_Section_Question__c,String: RAGStatusColor>
        Return Value: NA
        *******************************/             
                    
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
    Method Name: SRATChecklist_InlineController1
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
    public SRATChecklist_InlineController1(ApexPages.StandardController controller) {
        servDelApp=new Factory_Specific_Technology__c();
        servManageApp=new Factory_Specific_Technology__c();
        List<SRAT_Section_Questionnaire__c> tempSecQuesList=new List<SRAT_Section_Questionnaire__c>();
        List<SRAT_Sub_Section_Name__c> subSectionNameList=new List<SRAT_Sub_Section_Name__c>();
        List<SRAT_Sub_Section_Questionnaire__c> subSectionQuesList=new List<SRAT_Sub_Section_Questionnaire__c>();
        List<SRAT_User_Section_Question__c> userSecExistList=new List<SRAT_User_Section_Question__c>();
        List<SRAT_User_Sub_Section_Question__c> userSubSecExistList=new List<SRAT_User_Sub_Section_Question__c>();
        listSectionQuestionActual=new List<SRAT_Section_Questionnaire__c>();        
        listUserSecQues=new List<SRAT_User_Section_Question__c>();
        userSecQues=new SRAT_User_Section_Question__c();
        userSubSecQues=new SRAT_User_Sub_Section_Question__c();
        userAnsSecQues = new List<SRAT_User_Section_Question__c>();
        userAnsSubSecQues = new List<SRAT_User_Sub_Section_Question__c>();
        sratId=ApexPages.CurrentPage().getParameters().get(UTIL_constants.URL_PARAMETER_ID);
        isOmReadinessTabVisible = true;
        previousSRAT = new List<SRAT__c>();
        mapTitleSubSection = new Map<String,List<SRAT_User_Sub_Section_Question__c>>();
        sratIdList = new List<Id>();
        isOmRead = false;
        isPreviousSRATExist = false;
        if(sratId!=null)
        {
            sratRecordList=[select Item__c, Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__r.Id, Deployment_Lead_Task_ID__c,Location_Lead_Secondary_Task_ID__c,Has_Deployment_Lead_Submitted__c, Wave_Plan_Version__c,
                            Has_KT_Lead_Submitted__c, Has_KT_Lead_Saved__c,Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, 
                            Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, Planned_Date__c, 
                            Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Wave_Plan_lk__r.GO_Live_Date_del__c, Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,
                            Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__r.id, name, SRAT_Version__c,Days_Before_Go_Live_Date__c,
                            Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c, Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__r.id,
                            Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__r.id                            
                            from SRAT__c where id=:sratId];
            if(sratRecordList.size()>0)
            {
                // for D-1847
                if(sratRecordLIst[0].Wave_Plan_lk__r.GO_Live_Date_del__c > (sratRecordLIst[0].Planned_Date__c).adddays(30) ) 
                {
                    isOmReadinessTabVisible = false;
                }
                //D-1847 Ends
                showForm=true;
                sratRecord=sratRecordList[0];
                waveVersionRecordList=[select Deal__r.name, Deal__c, name,id from Wave_Plan_Version__c where id=:sratRecord.Wave_Plan_Version__c];
                if(waveVersionRecordList.size()>0)
                {
                    waveVersionRecord=waveVersionRecordList[0];    
                    //Mob R1.5 Req 15
                    for(SRAT__C srat : [Select Comments__c,Has_Deployment_Lead_Submitted__c,Has_KT_Lead_Submitted__c,Item__c,SRAT_Item_Master_Id__c,
                                        Days_Before_Go_Live_Date__c From SRAT__C Where Wave_Plan_Version__c =:waveVersionRecord.Id  and Deal_Location_lk__c = : sratRecord.Deal_Location_lk__c 
                                        and Wave_Plan_lk__c = : sratRecord.Wave_Plan_lk__c order by Days_Before_Go_Live_Date__c])   {
                        if(srat.Days_Before_Go_Live_Date__c < sratRecord.Days_Before_Go_Live_Date__c) {
                            sratIdList.add(srat.Id);
                            previousSRAT.add(srat);
                        }
                    }      
                    //Mob R1.5 Req 15                                                   
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_such_Wave_Plan_Version_exists));
                    showMainMsg=true;
                    showForm=false;
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.SRAT_Record_Exists_Error));
                showMainMsg=true;
                showForm=false;
            }
            sratVersion=[select SRAT_Name__c, id, name from SRAT_VERSION__c where isActive__c=:true];
            
            if(sratVersion.size()>0)
            {
                //Checking the SRAT Version ID
                if(sratRecord.SRAT_Version__c != sratVersion[0].id)
                  {
                    sratVersionId=sratRecord.SRAT_Version__c;               
                  }
                else
                   {
                      sratVersionId=sratVersion[0].id;
                   }
                    
                sratName=sratVersion[0].SRAT_Name__c;                                   
                listOfServiceDelApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, Volume_of_Transactions__c from Factory_Specific_Technology__c where Application_Type__c=:UTIL_constants.SERVICE_DELIVERY_APPLICATIONS and SRAT__c=:sratId and SRAT_Version__c=:sratVersionId order by createddate desc];
                listOfServiceManageApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, Volume_of_Transactions__c from Factory_Specific_Technology__c where Application_Type__c=:UTIL_constants.SERVICE_MANAGEMENT_APPLICATIONS and SRAT__c=:sratId and SRAT_Version__c=:sratVersionId order by createddate desc];
                assignMessages();
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_SRAT_version_is_active));
                showMainMsg=true;
                showForm=false;
            }
            mainQueries();            
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_such_SRAT_ID_exists));
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
        List<SRAT_Section_Questionnaire__c> tempSecQues1= [Select id,SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where Sort_Order__c =:1 and SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];
        if(tempSecQues1.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_question_set_for_Manage_Mobilization_Program));
            showMsg1=true;
        }
        List<SRAT_Sub_Section_Name__c> bpoSubSecList=[select SRAT_Sub_Section_Name__c, id from SRAT_Sub_Section_Name__c where SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId and SRAT_Sub_Section_Name__c=:UTIL_constants.OM_READINESS_SUMMARY];      
        if(bpoSubSecList.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_question_set_for_OM_Readiness_Summary));
            showMsg2=true;
        }
        
         List<SRAT_Section_Questionnaire__c> tempSecQuesNew= [Select SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c 
                                                            from SRAT_Section_Questionnaire__c where Sort_Order__c =:6 and 
                                                            SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId limit 1000];
        if(tempSecQuesNew.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, UTIL_Constants.MSG_NO_QUESTION_SET_BPOMC));
            showMsgNew=true;
 
        }        
        List<SRAT_Section_Questionnaire__c> tempSecQues3= [Select id,SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where Sort_Order__c =:3 and SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];        
        if(tempSecQues3.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_question_set_for_Establish_Business_Operations));
            showMsg3=true;
        }
        List<SRAT_Section_Questionnaire__c> tempSecQues4= [Select id,SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where Sort_Order__c =:4 and SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];       
        if(tempSecQues4.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_question_set_for_Implement_Delivery_Capability));
            showMsg4=true;
        }
        List<SRAT_Section_Questionnaire__c> tempSecQues5= [Select id,SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where Sort_Order__c =:5 and SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];        
        if(tempSecQues5.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_question_set_for_Journey_Management));
            showMsg5=true;
        }
        /*List<SRAT_Section_Questionnaire__c> tempSecQues6= [Select id,SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where Sort_Order__c =:6 and SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];       
        if(tempSecQues6.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'There is no question set for Factory Engagement Specific!'));
            showMsg6=true;
        }*/
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
        if(coloringField==UTIL_constants.DEFAULT_A_INCOMPLETE_ON_TRACK||coloringField==UTIL_constants.A_INCOMPLETE_ON_TRACK)
        {
            colorName=UTIL_constants.color_FF8C00;
        }
        if(coloringField==UTIL_constants.DEFAULT_R_INCOMPLETE_OFF_TRACK||coloringField==UTIL_constants.R_INCOMPLETE_OFF_TRACK)
        {
            colorName=UTIL_constants.COLOR_RED;
        }
        if(coloringField==UTIL_constants.DEFAULT_G_COMPLETE||coloringField==UTIL_constants.G_COMPLETE)
        {
            colorName=UTIL_constants.color_006400;
        }
        if(coloringField==UTIL_constants.DEFAULT_NOT_APPLICABLE||coloringField==UTIL_constants.NOT_APPLICABLE)
        {
            colorName=UTIL_constants.COLOR_NOTAPPLICABLE;
        }
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
        previousSubmittedUserSubSecExistList = new List<SRAT_User_Sub_Section_Question__c>(); 
        tempSecQuesList = [Select id,Sort_Order__c, SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];
        subSectionNameList = [select SRAT_Section_Name__c, SRAT_Section_Name__r.SRAT_Version__c, SRAT_Sub_Section_Name__c, id from SRAT_Sub_Section_Name__c order by SRAT_Sub_Section_Name__c ASC];
        subSectionQuesList = [select Reference__c,Handover_to_Service_Delivery__c, Measurement__c,SRAT_Sub_Section_Id__c,Title__c, Question_Description__c, Category__c, id, name from SRAT_Sub_Section_Questionnaire__c order by Sort_Number__c ASC];
        userSecExistList = [select IS_Factory_Engagement_Spc_Record__c , SRAT_Section_Questionnaire__c, Question_Description__c, Default_RAG_Status__c, Category__c, Comments__c, Overall_RAG_Status__c, Title__c from SRAT_User_Section_Question__c where SRAT__c=:sratId];
        userSubSecExistList = [select IS_Factory_Engagement_Spc_Record__c , Reference__c,Handover_to_Service_Delivery__c, Measurement__c, SRAT_Sub_Section_Questionnaire__c, Question_Description__c, Category__c, Comments__c, RAG_Status__c, Title__c from SRAT_User_Sub_Section_Question__c where SRAT__c=:sratId];
        //Mob R1.5 Req 15
        if(!sratIdList.isEmpty()) {
            previousSubmittedUserSubSecExistList = [Select Title__c, Question_Description__c, Comments__c, RAG_Status__c, SRAT__c ,SRAT__r.Days_Before_Go_Live_Date__c, Reference__c,
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
        List<MainQuestion> mainQuestion= new List<MainQuestion>();
        List<PreviousSubSec> previousSubSecQuestion = null;
        previousSubSectionList = new List<SRAT_User_Sub_Section_Question__c>();
        if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
        {
            if(tempSecQuesList!=null)
            {
                //Looping for the Main Questions List
                if(tempSecQuesList.size()>0 )
                {
                    List<SubSection> subSecList;
                    for(SRAT_Section_Questionnaire__c sq : tempSecQuesList)
                    {      
                        if(sq.Sort_Order__c == sortOrder)
                        {
                            subSecList=new List<SubSection>();
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
                                                String subRAGColor=UTIL_constants.EMPTY_WITH_SPACE_STRING;
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
                                                                            userSubSecQues.SRAT__c=sratId;
                                                                            userSubSecQues.Measurement__c=subq.Measurement__c;
                                                                            userSubSecQues.Handover_to_Service_Delivery__c=subq.Handover_to_Service_Delivery__c;
                                                                            userSubSecQues.SRAT_Sub_Section_Questionnaire__c=subq.id;
                                                                            userSubSecQues.SRAT_Version__c=sratVersionId;
                                                                            userSubSecQues.Reference__c=subq.Reference__c;
                                                                            //userSubSecQues.RAG_Status__c=UTIL_constants.NOT_APPLICABLE;                       
                                                                        }
                                                                        subRAGColor=assignColors(userSubSecQues.RAG_Status__c);
                                                                    }    
                                                                    Boolean isOMTab = false;                
                                                                    if(mapTitleSubSection.containsKey(userSubSecQues.Title__c)) {
                                                                        previousSubSectionList = mapTitleSubSection.get(userSubSecQues.Title__c);
                                                                    }
                                                                    else if(mapTitleSubSection.containsKey(userSubSecQues.Reference__c)) {
                                                                        previousSubSectionList = mapTitleSubSection.get(userSubSecQues.Reference__c);
                                                                        isOMTab = true;
                                                                    }
                                                                    String previousSubRAGColor = UTIL_Constants.EMPTY_STRING;
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
                                                                        if(userSubSecQues.RAG_Status__c == null || userSubSecQues.RAG_Status__c == 'NA') {
                                                                            userSubSecQues.RAG_Status__c = ragStatus;
                                                                        }
                                                                        if(userSubSecQues.Comments__c == null || userSubSecQues.Comments__c == 'NA') {
                                                                            userSubSecQues.Comments__c = comments;
                                                                        }
                                                                        subRAGColor = assignColors(userSubSecQues.RAG_Status__c);
                                                                        isPreviousRec = true;
                                                                        isPreviousSRATExist = true;
                                                                    }                   
                                                                    subQuesList.add(new SubQuestion(userSubSecQues,subRAGColor,previousSubSecQuestion, isPreviousRec));
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
                                    userSecQues.Default_RAG_Status__c=UTIL_constants.DEFAULT_NOT_APPLICABLE;
                                    //userSecQues.Overall_RAG_Status__c=UTIL_constants.NOT_APPLICABLE;
                                    userSecQues.SRAT_Section_Questionnaire__c=sq.id;
                                }
                                setRAGColor=assignColors(userSecQues.Overall_RAG_Status__c);            
                                setColor=assignColors(userSecQues.Default_RAG_Status__c);
                            }
                            mainQuestion.add(new MainQuestion(userSecQues,subSecList,setColor,setRAGColor));
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
                                            if(sq.subSecQuestion.RAG_Status__c==null || sq.subSecQuestion.RAG_Status__c==UTIL_constants.EMPTY_STRING)
                                                {
                                                  String ragStatus=UTIL_constants.NONE;
                                                  return ragStatus;
                                                }
                                            }    
                                                
                                            if((sq.subSecQuestion.RAG_Status__c==UTIL_constants.R_INCOMPLETE_OFF_TRACK || sq.subSecQuestion.RAG_Status__c==UTIL_constants.A_INCOMPLETE_ON_TRACK) && (sq.subSecQuestion.Comments__c== null || sq.subSecQuestion.Comments__c==UTIL_constants.EMPTY_STRING))
                                            {
                                                String title;
                                                if(sq.subSecQuestion.Title__c!=null)
                                                {
                                                    title=sq.subSecQuestion.Title__c;
                                                }
                                                else if(sq.subSecQuestion.Reference__c!=null) 
                                                {                                              
                                                    title=sq.subSecQuestion.Reference__c;
                                                return title.substringBefore(UTIL_constants.EMPTY_WITH_SPACE_STRING);
                                                 }
                                            }                    
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_constants.R_INCOMPLETE_OFF_TRACK)
                                            {
                                                redCnt++;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_constants.A_INCOMPLETE_ON_TRACK)
                                            {
                                                amberCnt++;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_constants.G_COMPLETE)
                                            {
                                                greenCnt++;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_constants.NOT_APPLICABLE)
                                            {
                                                naCnt++;
                                            }
                                        } 
                                    }
                                }
                            }
                        }
                    }
                    if(redCnt>0)
                    {
                        mq.secQuestion.Default_RAG_Status__c=UTIL_constants.DEFAULT_R_INCOMPLETE_OFF_TRACK;
                    }
                    else if(amberCnt>0)
                    {
                        mq.secQuestion.Default_RAG_Status__c=UTIL_constants.DEFAULT_A_INCOMPLETE_ON_TRACK;
                    }
                    else if(greenCnt>0)
                    {
                        mq.secQuestion.Default_RAG_Status__c=UTIL_constants.DEFAULT_G_COMPLETE;
                    }
                    else
                    {
                        mq.secQuestion.Default_RAG_Status__c=UTIL_constants.DEFAULT_NOT_APPLICABLE;
                    }
                    if((mq.secQuestion.Overall_RAG_Status__c==UTIL_constants.R_INCOMPLETE_OFF_TRACK || mq.secQuestion.Overall_RAG_Status__c==UTIL_constants.A_INCOMPLETE_ON_TRACK) && (mq.secQuestion.Comments__c== null || mq.secQuestion.Comments__c==UTIL_constants.EMPTY_STRING))
                    {
                        return UTIL_constants.MAIN_QUESTION;
                    }
                    userAnsSecQues.add(mq.secQuestion);
                    
                }
            }
        }
        return UTIL_constants.COMPLETE;
    }
    
    /******************************
    Method Name: getQuestionnaire
    Description: To get the Checklist Questions for Manage Mobilization Program tab
    Paramenters: NA
    Return Value: List<MainQuestion>
    *******************************/
   public List<MainQuestion> getQuestionnaire() 
    {
        manageQuestion= setTabQuestionnaires(1);        
        return manageQuestion;
    }    
    
    /**********************************************
    Method Name: setFacEngSpecTabQues
    Description: Common Function to get the Checklist Questions for Tabs
    Paramenters: NA
    Return Value: List<MainQuestion>
    ***********************************************/
    
    public List<MainQuestion> setFacEngSpecTabQues()
    {        
        //Added for factory engaement defect start
        boolean subsecExist=false;
        boolean secExist=false;
        //End
        List<MainQuestion> mainQuestion= new List<MainQuestion>();        
        List<SubSection> subSecList=new List<SubSection>();     
        SRAT_User_Sub_Section_Question__c userSubSecQues=new SRAT_User_Sub_Section_Question__c();
                               
        if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
        {
            List<SubQuestion> subQuesList=new List<SubQuestion>();  
            if(userSubSecExistList!=null && userSubSecExistList.size()>0)
            {
                 for(SRAT_User_Sub_Section_Question__c subUser : userSubSecExistList)
                {
                 if(subUser.IS_Factory_Engagement_Spc_Record__c)
                    {
                      subsecExist=true;
                    }
                }
            }
                
            if(subsecExist)
            {
                Decimal quesNo=5.00;
                String subRAGColor=UTIL_constants.EMPTY_WITH_SPACE_STRING;
                //Looping to get the pre-saved User Sub Section Questions
                for(SRAT_User_Sub_Section_Question__c subUser : userSubSecExistList)
                {
                     
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
                    String subRAGColor=UTIL_constants.EMPTY_WITH_SPACE_STRING;                                 
                    if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                    { 
                                    
                        userSubSecQues=new SRAT_User_Sub_Section_Question__c();                                                                             
                        userSubSecQues.SRAT__c=sratId;                                                                           
                        userSubSecQues.SRAT_Version__c=sratVersionId;
                        //userSubSecQues.RAG_Status__c=UTIL_constants.NOT_APPLICABLE; 
                        userSubSecQues.IS_Factory_Engagement_Spc_Record__c=true;
                        quesNo=quesNo+0.01;                     
                        subRAGColor=assignColors(userSubSecQues.RAG_Status__c);
                    }                    
                    subQuesList.add(new SubQuestion(userSubSecQues,subRAGColor, quesNo));                    
                }
            }                                   
            SRAT_Sub_Section_Name__c subSectionName=new SRAT_Sub_Section_Name__c();
            subSectionName.SRAT_Sub_Section_Name__c=UTIL_constants.FACTORY_ENGAGEMENT_SPECIFIC;                
            subSecList.add(new SubSection(subSectionName,subQuesList));
            if(userSecExistList!=null && userSecExistList.size()>0)
            {
                 for(SRAT_User_Section_Question__c sUser : userSecExistList)
                {
                 if(sUser.IS_Factory_Engagement_Spc_Record__c)
                    {
                      secExist=true;
                    }
                }
            }
            if(secExist)
            {
                //Loop to get pre-saved Main Questions for SRAT version and SRAT plan
                for(SRAT_User_Section_Question__c sUser : userSecExistList)
                {
                    //List<SubQuestion> subQuesList=new List<SubQuestion>();
                    String setRAGColor=UTIL_constants.EMPTY_WITH_SPACE_STRING;  
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
                userSecQues.Default_RAG_Status__c=UTIL_constants.DEFAULT_NOT_APPLICABLE;
                //userSecQues.Overall_RAG_Status__c=UTIL_constants.NOT_APPLICABLE;
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
    Return Value: String 
    *******************************/
    public String setFacEngSpecUserAnswers(List<MainQuestion> mainQuestionAnswer)
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
                                            if(isCalledFromSubmit)
                                            {
                                            if(sq.subSecQuestion.Category__c==null)
                                            {
                                                questionNumber=sq.questionNo;
                                               // return UTIL_constants.MANDATORY_FIELDS;
                                            }
                                            
                                            if(sq.subSecQuestion.RAG_Status__c==null ||sq.subSecQuestion.RAG_Status__c==UTIL_constants.EMPTY_STRING)
                                              {
                                                //String ragStatus=UTIL_constants.NONE;
                                                //return ragStatus;
                                              }
                                            
                                            if((sq.subSecQuestion.Title__c!=null && sq.subSecQuestion.Question_Description__c==null) || (sq.subSecQuestion.Title__c==null && sq.subSecQuestion.Question_Description__c!=null) )
                                            {                                                
                                                questionNumber=sq.questionNo;
                                                //return UTIL_constants.MANDATORY_FIELDS;                                               
                                            }
                                            }
                                            if(((sq.subSecQuestion.RAG_Status__c!=null && sq.subSecQuestion.RAG_Status__c!=UTIL_constants.NOT_APPLICABLE) ||sq.subSecQuestion.Comments__c!= null)&&(sq.subSecQuestion.Title__c==null || sq.subSecQuestion.Question_Description__c==null || sq.subSecQuestion.Category__c==null) )
                                            {                                                
                                                questionNumber=sq.questionNo;
                                               // return UTIL_constants.MANDATORY_FIELDS;
                                            }
                                            if((sq.subSecQuestion.RAG_Status__c==UTIL_constants.R_INCOMPLETE_OFF_TRACK || sq.subSecQuestion.RAG_Status__c==UTIL_constants.A_INCOMPLETE_ON_TRACK) && (sq.subSecQuestion.Comments__c== null || sq.subSecQuestion.Comments__c==UTIL_constants.EMPTY_STRING))
                                            {
                                                questionNumber=sq.questionNo;
                                                //return UTIL_constants.NO_COMMENTS;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_constants.R_INCOMPLETE_OFF_TRACK)
                                            {
                                                redCnt++;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_constants.A_INCOMPLETE_ON_TRACK)
                                            {
                                                amberCnt++;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_constants.G_COMPLETE)
                                            {
                                                greenCnt++;
                                            }
                                            if(sq.subSecQuestion.RAG_Status__c==UTIL_constants.NOT_APPLICABLE)
                                            {
                                                naCnt++;
                                            }
                                        } 
                                    }
                                }
                            }
                        }
                    }
                    if(redCnt>0)
                    {                   
                        mq.secQuestion.Default_RAG_Status__c=UTIL_constants.DEFAULT_R_INCOMPLETE_OFF_TRACK; 
                    }                
                    else if(amberCnt>0)
                    {
                        mq.secQuestion.Default_RAG_Status__c=UTIL_constants.DEFAULT_A_INCOMPLETE_ON_TRACK;
                    }
                    else if(greenCnt>0)
                    {
                        mq.secQuestion.Default_RAG_Status__c=UTIL_constants.DEFAULT_G_COMPLETE;
                    }
                    else
                    {
                        mq.secQuestion.Default_RAG_Status__c=UTIL_constants.DEFAULT_NOT_APPLICABLE;
                    }
                    if(isCalledFromSubmit)
                    {
                        if(mq.secQuestion.Overall_RAG_Status__c==null || mq.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                        {
                            //return UTIL_constants.NULLOVERALLRAGSTATUS;
                        }
                    }
                    if(((mq.secQuestion.Overall_RAG_Status__c!=null && mq.secQuestion.Overall_RAG_Status__c!=UTIL_constants.NOT_APPLICABLE) ||mq.secQuestion.Comments__c!= null)&&(mq.secQuestion.Title__c==null || mq.secQuestion.Question_Description__c==null) )
                    {                                                
                        return UTIL_constants.MAIN_MANDATORY_FIELDS;
                    }
                    if((mq.secQuestion.Overall_RAG_Status__c==UTIL_constants.R_INCOMPLETE_OFF_TRACK || mq.secQuestion.Overall_RAG_Status__c==UTIL_constants.A_INCOMPLETE_ON_TRACK) && (mq.secQuestion.Comments__c== null || mq.secQuestion.Comments__c==UTIL_constants.EMPTY_STRING))
                    {                        
                        return UTIL_constants.MAIN_QUESTION;
                    }
                    userAnsSecQues.add(mq.secQuestion);
                }
            }
        }
        return UTIL_constants.COMPLETE;
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
        return BPOMobCtrlQuestionnaire;
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
                    List<SubQuestion> subQuesList;
                    for(SRAT_Sub_Section_Name__c ssn : subSectionNameList)
                    {     
                        if(ssn.SRAT_Sub_Section_Name__c==UTIL_constants.OM_READINESS_SUMMARY && ssn.SRAT_Section_Name__r.SRAT_Version__c==sratVersionId)
                        {
                            subQuesList=new List<SubQuestion>();
                            String BPOMobSubRAGColor=UTIL_constants.EMPTY_WITH_SPACE_STRING;
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
                                                        //userSubSecQues.RAG_Status__c=UTIL_constants.NOT_APPLICABLE;                    
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
    
    /******************************
    Method Name: setBPOMobilization
    Description: To set the user saved records in the Lists
    Paramenters: NA
    Return Value: String 
    *******************************/
    /*public String setBPOMobilization()
    {
        if(bpoMobSubSecList!=null)
        {
            if(bpoMobSubSecList.size()>0)
            {
                for(SubSection ss:bpoMobSubSecList)
                {
                    if(ss.subQues!=null)
                    {
                        if(ss.subQues.size()>0)
                        {
                            for(SubQuestion sq:ss.subQues)
                            {
                                userAnsSubSecQues.add(sq.subSecQuestion);
                                 if(isCalledFromSubmit==true)
                                {
                                 if(sq.subSecQuestion.RAG_Status__c==null || sq.subSecQuestion.RAG_Status__c==UTIL_constants.EMPTY_STRING)
                                 {
                                   String ragStatus=UTIL_constants.NONE;
                                   return ragStatus;
                                 }
                                }
                                if((sq.subSecQuestion.RAG_Status__c==UTIL_constants.R_INCOMPLETE_OFF_TRACK || sq.subSecQuestion.RAG_Status__c==UTIL_constants.A_INCOMPLETE_ON_TRACK) && (sq.subSecQuestion.Comments__c== null || sq.subSecQuestion.Comments__c==UTIL_constants.EMPTY_STRING))
                                {
                                    String title=sq.subSecQuestion.Reference__c;
                                    return title;
                                }
                            }
                        }
                    }
                }
            }
        }
        return UTIL_constants.COMPLETE;
    }*/
    
    /******************************
    Method Name: getQuestionnaire
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
    Return Value: clientChgQuestion
    *******************************/
    public List<MainQuestion> getClientChgQuestionnaire() 
    {
        clientChgQuestion = setTabQuestionnaires(6);
        return clientChgQuestion;
    }
    
    /**********************Factory Specific Technology Tab Begins**************************************/
    /**************************************************
    Class Name: FactorySpecTech
    Description: To set RAG Color values for Factory Specific Technology
    ***************************************************/
    public class FactorySpecTech{
        public Factory_Specific_Technology__c facSpecTech{get;set;}
        public String facSpecColor{get;set;}
       
        
        public FactorySpecTech(Factory_Specific_Technology__c facSpecTech, String facSpecColor)
        {
            this.facSpecTech=facSpecTech;
            this.facSpecColor=facSpecColor;
        }
    }
    /**********************************************
    Method Name: getFactorySpecificList
    Description: To get factory specific list
    Paramenters: List<Factory_Specific_Technology__c>
    Return Value: ServAppList
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
                    String delvColor=UTIL_constants.EMPTY_WITH_SPACE_STRING;
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
        listOfServiceDelApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, Volume_of_Transactions__c from Factory_Specific_Technology__c where Application_Type__c=:UTIL_Constants.SERVICE_DELIVERY_APPLICATIONS and SRAT__c=:sratId and SRAT_Version__c=:sratVersionId order by createddate desc];
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
        listOfServiceManageApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, Volume_of_Transactions__c from Factory_Specific_Technology__c where Application_Type__c=:UTIL_Constants.SERVICE_MANAGEMENT_APPLICATIONS and SRAT__c=:sratId and SRAT_Version__c=:sratVersionId order by createddate desc];
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
        if(sratRecord.Has_KT_Lead_Submitted__c && !sratRecord.Has_Deployment_Lead_Submitted__c)
        {
            if(servDelApp.Application_Name__c==null || servDelApp.Application_Name__c== UTIL_constants.EMPTY_STRING)
            {
                showMsg71=true;         
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_Application_Name));
                return;
            }
            servDelApp.SRAT__c=sratid;
            servDelApp.SRAT_Version__c=sratVersionId;
            servDelApp.Application_Type__c=UTIL_constants.SERVICE_DELIVERY_APPLICATIONS;              
            try
            {
                database.insert(servDelApp,false);                                 
            } 
            catch(Exception ex)
            {
                showMsg71=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Error_in_Saving));
                initializeSerDelApp();
                initializeservManageApp();            
                return;
            }finally{            
                initializePageMessages();
                showMsg71=true;
            }
            servDelApp=new Factory_Specific_Technology__c();
            initializeSerDelApp();
            initializeservManageApp();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Record_Added_Successfully));
        }
        else
        {
            showMainMsg=true;
            showMsg71=true;                       
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.This_SRAT_Checklist_has_Already_been_Submitted));
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
        if(sratRecord.Has_KT_Lead_Submitted__c && !sratRecord.Has_Deployment_Lead_Submitted__c)
        {         
            if(servManageApp.Application_Name__c==null || servManageApp.Application_Name__c== UTIL_constants.EMPTY_STRING)
            {
                showMsg72=true;          
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_Application_Name));
                return;
            }
            servManageApp.SRAT__c=sratid;
            servManageApp.SRAT_Version__c=sratVersionId;
            servManageApp.Application_Type__c=UTIL_constants.SERVICE_MANAGEMENT_APPLICATIONS;               
            try
            {
                database.insert(servManageApp,false);                      
            } 
            catch(Exception ex)
            {
                showMsg72=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Error_in_Saving));
                initializeSerDelApp();
                initializeservManageApp();
                return;
            }finally{            
                showMsg72=true;
            }
            servManageApp=new Factory_Specific_Technology__c();
            initializeSerDelApp();
            initializeservManageApp();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Record_Added_Successfully));
        }
        else
        {
            showMainMsg=true;
            showMsg72=true;                       
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.This_SRAT_Checklist_has_Already_been_Submitted));
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
        /*
        setUserAnswers(manageQuestion);     //Manage Mobilization Tab
        setBPOMobilization();               //OM Readiness Summary Tab
        setUserAnswers(busOpMainQuestion);  //Establish Business Operations Tab
        setUserAnswers(delCapMainQuestion); //Implement Delivery Capability Tab
        setUserAnswers(clientChgQuestion);  //Journey Management Tab
        setUserAnswers(facEngSpcQuestion);  //Factory Engagement Specific Tab
        */
        
        facSpecificTechnology.addAll(listOfServiceDelApp);       //Factory Specific Technology Tab
        facSpecificTechnology.addAll(listOfServiceManageApp);    //Factory Specific Technology Tab                  
        
        userAnsSecQuesSet.addAll(userAnsSecQues);
        userAnsSubSecQuesSet.addAll(userAnsSubSecQues);
        
        system.debug('Pitbull Extends Yo Yo!'+userAnsSecQuesSet);
        system.debug('Pitbull implements Yo Yo!'+userAnsSubSecQuesSet);
        userAnsSecQuesToUpdate.addAll(userAnsSecQuesSet);
        userAnsSubSecQuesToUpdate.addAll(userAnsSubSecQuesSet);
        //Saving Data from all 6 Tabs
        database.upsert(userAnsSecQuesToUpdate);
        database.upsert(userAnsSubSecQuesToUpdate);       
        //Saving Factory Specific Technology Records
        database.upsert(facSpecificTechnology,false);            
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
        initializePageMessages();
        if(sratRecord.Has_KT_Lead_Submitted__c==true && sratRecord.Has_Deployment_Lead_Submitted__c==false)
        {
            /****For Factory Specific Technology Tab****/        
            facSpecificTechnology= new List<Factory_Specific_Technology__c>();
            /*if(listOfServiceDelApp!=null)
            {
                if(listOfServiceDelApp.size()>0)
                {
                    for(Factory_Specific_Technology__c fac1: listOfServiceDelApp)
                    {
                            if(fac1.Application_Name__c==null || fac1.Application_Name__c== UTIL_constants.EMPTY_STRING)
                            {
                                showMsg71=true;
                                showMsg72=false;
                                showMainMsg=true;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field is missing in Service Delivery Application: [Application Name]'));                          
                                return null;
                            }
                             if(fac1.RAG_Status__c==null || fac1.RAG_Status__c== UTIL_constants.EMPTY_STRING)
                            {
                                showMsg71=true;
                                showMsg72=false;
                                showMainMsg=true;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'RAG Status in Service Delivery Applicationcannot be None. Please select another value'));                          
                                initializeSerDelApp();
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
                            if(fac2.Application_Name__c==null || fac2.Application_Name__c== UTIL_constants.EMPTY_STRING)
                            {
                                showMsg71=false;
                                showMsg72=true;
                                showMainMsg=true;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field is missing in Service Management Application: [Application Name]'));
                                return null;
                            }
                            if(fac2.RAG_Status__c==null || fac2.RAG_Status__c== UTIL_constants.EMPTY_STRING)
                            {
                                showMsg71=true;
                                showMsg72=false;
                                showMainMsg=true;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'RAG Status in Service Management Application cannot be None. Please select another value '));                          
                                initializeSerDelApp();
                                return null;
                            }
                    }
                }
            }*/
            try
            {
                boolean overallMangeRagNone=false;
                /*for(MainQuestion m : manageQuestion)
                {
                  if(m.secQuestion.Overall_RAG_Status__c==null || m.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                    {
                       overallMangeRagNone=true;
                    }
                }
                if(overallMangeRagNone)
                  {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Manage_Mobilization_Program_tab_cannot_be_None_Please_sele));
                    return null;
                  }*/
                String title=setUserAnswers(manageQuestion);
                
                 /*if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Staus_in_Manage_Mobilization_Program_tab_cannot_be_None_Please_select_anoth));
                    return null;
                 }*/
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Main_Question_in_Manage_Mobiliza));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+title+system.label.in_Manage_Mobilization_Tab));
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
                /*if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Staus_in_OM_Readiness_Summary_tab_cannot_be_None_Please_select_another_valu));
                    return null;
                 }*/
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Main_Question_in_OM_Readiness_Su));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Reference_Question+title+system.label.in_OM_Readiness_Summary_Tab));
                    return null;
                }
               
                boolean overallEstRagNone=false;
                /*for(MainQuestion m : busOpMainQuestion)
                {
                  if(m.secQuestion.Overall_RAG_Status__c==null || m.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                    {
                       overallEstRagNone=true;
                    }
                }
                if(overallEstRagNone==true)
                  {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Overall RAG Staus in Establish Business Operations Tab cannot be None. Please select another value '));
                    return null;
                  }*/
                   title=setUserAnswers(busOpMainQuestion);
                /*if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'RAG Staus in Establish Business Operations Tab cannot be None. Please select another value '));
                    return null;
                 }*/
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Main_Question_in_Establish_Busin));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+title+system.label.in_Establish_Business_Operations_Tab));
                    return null;
                }
                 if(title!=UTIL_constants.COMPLETE)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Reference_Question+title+system.label.in_OM_Readiness_Summary_Tab));
                    return null;
                }
               
                boolean overallEstIMPRagNone=false;
                /*for(MainQuestion m : delCapMainQuestion)
                {
                  if(m.secQuestion.Overall_RAG_Status__c==null || m.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                    {
                       overallEstIMPRagNone=true;
                    }
                }
                if(overallEstIMPRagNone==true)
                  {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Implement_Delivery_Capability_Tab_cannot_be_None_Please_se));
                    return null;
                  }*/
                title=setUserAnswers(delCapMainQuestion);
                 /*if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Implement_Delivery_Capability_Tab_cannot_be_None_Please_se));
                    return null;
                 }*/
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Enter_Comments_for_Main_Question_in_Implement_Deliv));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+title+system.label.in_Implement_Delivery_Capability_Tab));
                    return null;
                }
                boolean overallEstClntRagNone=false;
                /*for(MainQuestion m : clientChgQuestion)
                {
                  if(m.secQuestion.Overall_RAG_Status__c==null || m.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                    {
                       overallEstClntRagNone=true;
                    }
                }
                if(overallEstClntRagNone==true)
                  {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Journey_Management_Tab_cannot_be_None_Please_select_anothe));
                    return null;
                }*/
                title=setUserAnswers(clientChgQuestion);
                /*if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'RAG Staus in Journey Management Tab cannot be None. Please select another value '));
                    return null;
                 }*/
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_Comments_for_Main_Question_in_Journey_Managem));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+title+system.label.in_Journey_Management_Tab));
                    return null;
                }
                title=setFacEngSpecUserAnswers(facEngSpcQuestion);
                /*if(title==UTIL_constants.NONE)
                 {
                 showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Staus_in_Factory_Engagement_Specific_Tab_cannot_be_None_Please_select_anoth));
                    return null;
                 }*/
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MANDATORY_FIELDS)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_fields_missing_Title_Question_Description_Category_for_Question+questionNumber+system.label.in_Factory_Engagement_Specific_Tab));
                        return null;
                    }
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Main_Question_in_Factory_Engagem));
                        return null;
                    }
                    if(title==UTIL_constants.MAIN_MANDATORY_FIELDS)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_fields_missing_Title_Question_Description_for_Main_Question_in_Fac));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+questionNumber+system.label.in_Factory_Engagement_Specific_Tab));
                    return null;
                }
                //setting all the lists and updating/inserting in database
                setAllValues();
                //Saving SRAT Records
                sratRecord.Has_Deployment_Lead_Saved__c=true;
                database.upsert(sratRecord,false);               
            }
            catch(Exception ex)
            {
                showMainMsg=true;                            
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Error_in_Saving));
                return null;
            }
            finally
            {
                userAnsSecQues = new List<SRAT_User_Section_Question__c>();
                userAnsSubSecQues = new List<SRAT_User_Sub_Section_Question__c>();
            }
            showMainMsg = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.SRAT_Checklist_Saved_Successfully));
            /*refreshPage=true;      
            PageReference pg=new PageReference(system.label.apex_SRATChecklist_Inline1_id+sratid);
            pg.setRedirect(true);
            return pg;*/
            return null;
        }
        else
        {
            showMainMsg=true;                        
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.This_SRAT_Checklist_has_Already_been_Submitted));
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
    Method Name: DepLeadSubmitSRATChecklist
    Description: To submit the checklist to System
    Paramenters: NA
    Return Value: PageReference to Checklist ReadOnly page
    ***********************************************/
    public PageReference depLeadSubmitSRATChecklist()
    {
        isCalledFromSubmit=true;
        initializePageMessages();
        
        if(sratRecord.Has_KT_Lead_Submitted__c && !sratRecord.Has_Deployment_Lead_Submitted__c)
        {
            /****For Factory Specific Technology Tab****/        
            facSpecificTechnology= new List<Factory_Specific_Technology__c>();
            if(listOfServiceDelApp!=null)
            {
                if(listOfServiceDelApp.size()>0)
                {
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Service_Delivery_Application_Application_Name));                          
                    
                    for(Factory_Specific_Technology__c fac1: listOfServiceDelApp)
                    {
                            if(fac1.Application_Name__c==null || fac1.Application_Name__c== UTIL_constants.EMPTY_STRING)
                            {
                                showMsg71=true;
                                showMsg72=false;
                                showMainMsg=true;
                                return null;
                            }
                    }
                }
            }
            if(listOfServiceManageApp!=null)
            {
                if(listOfServiceManageApp.size()>0)
                {
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_field_is_missing_in_Service_Management_Application_Application_Name));
                    for(Factory_Specific_Technology__c fac2: listOfServiceManageApp)
                    {
                            if(fac2.Application_Name__c==null || fac2.Application_Name__c== UTIL_constants.EMPTY_STRING)
                            {
                                showMsg71=false;
                                showMsg72=true;
                                showMainMsg=true;

                                return null;
                            }
                    }
                }
            }
            try{   
                boolean overallMangeRagNone=false;
                for(MainQuestion m : manageQuestion)
                {
                  if(m.secQuestion.Overall_RAG_Status__c==null || m.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                    {
                       overallMangeRagNone=true;
                    }
                }
                if(overallMangeRagNone)
                  {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Manage_Mobilization_Program_tab_cannot_be_None_Please_sele));
                    return null;
                  }         
                String title=setUserAnswers(manageQuestion);
                 if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Staus_in_Manage_Mobilization_Program_tab_cannot_be_None_Please_select_anoth));
                    return null;
                 }
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Main_Question_in_Manage_Mobiliza));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+title+system.label.in_Manage_Mobilization_Tab));
                    return null;
                }
                title=setUserAnswers(omReadiness);
                if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Staus_in_OM_Readiness_Summary_tab_cannot_be_None_Please_select_another_valu));
                    return null;
                 }
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Main_Question_in_OM_Readiness_Su));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Reference_Question+title+system.label.in_OM_Readiness_Summary_Tab));
                    return null;
                }
                                  
                boolean overallEstRagNone=false;
                for(MainQuestion m : busOpMainQuestion)
                {
                  if(m.secQuestion.Overall_RAG_Status__c==null || m.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                    {
                       overallEstRagNone=true;
                    }
                }
                if(overallEstRagNone)
                  {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Establish_Business_Operations_Tab_cannot_be_None_Please_se));
                    return null;
                  }
                title=setUserAnswers(busOpMainQuestion);
                 if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Staus_in_Establish_Business_Operations_Tab_cannot_be_None_Please_select_ano));
                    return null;
                 }
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Main_Question_in_Establish_Busin));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+title+system.label.in_Establish_Business_Operations_Tab));
                    return null;
                }
                
                boolean overallEstIMPRagNone=false;
                for(MainQuestion m : delCapMainQuestion)
                {
                  if(m.secQuestion.Overall_RAG_Status__c==null || m.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                    {
                       overallEstIMPRagNone=true;
                    }
                }
                if(overallEstIMPRagNone)
                  {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Implement_Delivery_Capability_Tab_cannot_be_None_Please_se));
                    return null;
                  }
                title=setUserAnswers(delCapMainQuestion);
                if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Implement_Delivery_Capability_Tab_cannot_be_None_Please_se));
                    return null;
                 }
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Enter_Comments_for_Main_Question_in_Implement_Deliv));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+title+system.label.in_Implement_Delivery_Capability_Tab));
                    return null;
                }
                                  
                boolean overallEstClntRagNone=false;
                for(MainQuestion m : clientChgQuestion)
                {
                  if(m.secQuestion.Overall_RAG_Status__c==null || m.secQuestion.Overall_RAG_Status__c==UTIL_constants.EMPTY_STRING)
                    {
                       overallEstClntRagNone=true;
                    }
                }
                if(overallEstClntRagNone)
                  {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Journey_Management_Tab_cannot_be_None_Please_select_anothe));
                    return null;
                }
                title=setUserAnswers(clientChgQuestion);
                 if(title==UTIL_constants.NONE)
                 {
                  showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Staus_in_Journey_Management_Tab_cannot_be_None_Please_select_another_value));
                    return null;
                 }
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_Comments_for_Main_Question_in_Journey_Managem));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+title+system.label.in_Journey_Management_Tab));
                    return null;
                }
                title=setFacEngSpecUserAnswers(facEngSpcQuestion);
                if(title==UTIL_constants.NONE)
                 {
                 showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Staus_in_Factory_Engagement_Specific_Tab_cannot_be_None_Please_select_anoth));
                    return null;
                 }
                 
                if(title==UTIL_constants.NULLOVERALLRAGSTATUS)
                {
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Overall_RAG_Staus_in_Factory_Engagement_Specific_Tab_cannot_be_None_Please_sel));
                    return null;
                }
                if(title!=UTIL_constants.COMPLETE)
                {
                    if(title==UTIL_constants.MANDATORY_FIELDS)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_fields_missing_Title_Question_Description_Category_for_Question+questionNumber+system.label.in_Factory_Engagement_Specific_Tab));
                        return null;
                    }
                    if(title==UTIL_constants.MAIN_QUESTION)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Main_Question_in_Factory_Engagem));
                        return null;
                    }
                    if(title==UTIL_constants.MAIN_MANDATORY_FIELDS)
                    {
                        showMainMsg=true;                           
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Required_fields_missing_Title_Question_Description_for_Main_Question_in_Fac));
                        return null;
                    }
                    showMainMsg=true;                           
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.RAG_Status_RED_AMBER_Please_enter_Comments_for_Question+questionNumber+system.label.in_Factory_Engagement_Specific_Tab));
                    return null;
                }
                //Deleting the Task for Deployment Lead
                if(sratRecord.Deployment_Lead_Task_ID__c!=null)
                {
                    List<Task> lstTask=[select id from Task where id=:sratRecord.Deployment_Lead_Task_ID__c];
                    if(lstTask.size()>0)
                    {
                       database.delete(lstTask,false);
                    } 
                }
                //Deleting the Task for Location Mobilization Lead Secondary
                if(sratRecord.Location_Lead_Secondary_Task_ID__c!=null)
                {
                    List<Task> lstTask=[select id from Task where id=:sratRecord.Location_Lead_Secondary_Task_ID__c];
                    if(lstTask.size()>0)
                    {
                        database.delete(lstTask,false);   
                    }
                }         
                //Saving values for all Tabs
                setAllValues();
                
                //Creating New Task for KT Lead to get upload offline approval mail for SRAT
                if(sratRecord.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__r.Id !=null)
                {
                    Task emailTask= new Task();
                    emailTask.OwnerId = sratRecord.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__r.Id;
                    emailTask.Subject = UTIL_constants.APPROVAL_EMAIL_ATTACHMENT_ON_SRAT;
                    emailTask.Status = UTIL_constants.NOT_STARTED;
                    emailTask.Description = system.label.Please_Attach_Approval_Email_from_Governance_Lead_for_following_SRAT_nDeal_Nam+waveVersionRecord.Deal__r.name+system.label.nWave_Plan_Version+waveVersionRecord.name+system.label.n_SRAT_Item+sratRecord.Item__c;
                    database.insert(emailTask,false);
                }
                //Creating New Task for KT Lead Secondary to get upload offline approval mail for SRAT
                if(sratRecord.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__r.id !=null)
                {
                    Task emailTask= new Task();
                    emailTask.OwnerId = sratRecord.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__r.id;
                    emailTask.Subject = UTIL_constants.APPROVAL_EMAIL_ATTACHMENT_ON_SRAT;
                    emailTask.Status = UTIL_constants.NOT_STARTED;
                    emailTask.Description = system.label.Please_Attach_Approval_Email_from_Governance_Lead_for_following_SRAT_nDeal_Nam+waveVersionRecord.Deal__r.name+system.label.nWave_Plan_Version+waveVersionRecord.name+system.label.n_SRAT_Item+sratRecord.Item__c;
                    database.insert(emailTask,false);
                }
                if(sratRecord.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__r.id !=null)
                {
                    Task emailTask= new Task();
                    emailTask.OwnerId = sratRecord.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__r.id;
                    emailTask.Subject = UTIL_constants.APPROVAL_EMAIL_ATTACHMENT_ON_SRAT;
                    emailTask.Status = UTIL_constants.NOT_STARTED;
                    emailTask.Description = system.label.Please_Attach_Approval_Email_from_Governance_Lead_for_following_SRAT_nDeal_Nam+waveVersionRecord.Deal__r.name+system.label.nWave_Plan_Version+waveVersionRecord.name+system.label.n_SRAT_Item+sratRecord.Item__c;
                    database.insert(emailTask,false);
                }                
                //Saving the SRAT Record
                sratRecord.Has_Deployment_Lead_Saved__c=true;
                sratRecord.Has_Deployment_Lead_Submitted__c=true;
                sratRecord.SRAT_Version__c=sratVersionId;
                database.upsert(sratRecord,false);                                  
            }
            catch(Exception ex)
            {
                showMainMsg=true;                          
                system.debug('Yo Yo implements Pitbull'+ex);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Error_while_Submitting+ex));
                return null;
            }
            finally
            {
                userAnsSecQues = new List<SRAT_User_Section_Question__c>();
                userAnsSubSecQues = new List<SRAT_User_Sub_Section_Question__c>();
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.SRAT_Checklist_Submitted_Successfully));
            PageReference pg=new PageReference(system.label.apex_SRATChecklist_ReadOnlyInline_id+sratid);
            pg.setRedirect(true);
            return pg;
        }
        else
        {
            showMainMsg=true;                                  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.This_SRAT_Checklist_has_Already_been_Submitted));
            return null;
        }               
    }
}