/*
Author : Mayank Tayal
Story  :   Story_0094/MOB__019 and Story_0100/MOB_022
Description : As KT Lead, I should able to initiate & complete SRAT as planned in High level mobilization plan 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    MOB_029/030/031/032        4 March 2013        Added Log RAID Button and functionality   

*/
global class SRATChecklist_ReadOnlyInlineController {
    public String sratId{get;set;}    
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
    public Boolean showMsgNew{get;set;}    
    
    public Boolean refreshPage{get;set;}
    public Boolean showForm{get;set;}
    public Boolean showNotesBlock{get;set;}
    
    //Lists to get the Questions, Sections, Sub Questions and User Saved Data
    public List<SRAT_Section_Questionnaire__c> tempSecQuesList{get;set;}
    public List<SRAT_Sub_Section_Name__c> subSectionNameList{get;set;}
    public List<SRAT_Sub_Section_Questionnaire__c> subSectionQuesList{get;set;}
    public List<SRAT_User_Section_Question__c> userSecExistList{get;set;}
    public List<SRAT_User_Sub_Section_Question__c> userSubSecExistList{get;set;}
    
    public String setColor{get;set;}
    public String setRAGColor{get;set;}
    
    //Manage Mobilization Program tab variables
    public List<MainQuestion> manageQuestion;   
    
    //BPO Mobilization Controls tab variables
    public List<MainQuestion >BPOMobCtrlQuestionnaire;      
    
    //OM Readiness Summary tab variables
    public List<MainQuestion> omReadiness; 
    public List<SubSection> bpoMobSubSecList;
    
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
    
    public boolean isRAIDAccess{get;set;}
    
    // for D-1847
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
    //Mob R1.5 Req 15 End
        
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
        
        public MainQuestion(SRAT_User_Section_Question__c secQuestion, List<SubSection> subSec,String color,String RAGColor)
        {
            this.secQuestion=secQuestion;
            this.subSec=subSec;
            this.color=color;
            this.RAGColor=RAGColor;
        }
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
        
        public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, String RAGStatusColor,List<PreviousSubSec> prvSubSec, Boolean isPrevious)  {
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
            this.prvSubSec = prvSubSec;
            this.isPrevious = isPrevious;
        }      
        public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, String RAGStatusColor) {
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
           
        }  
        public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, String RAGStatusColor,Decimal questionNo) {
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
             this.questionNo=questionNo;
           
        }  
        public SubQuestion(SRAT_User_Sub_Section_Question__c subSecQuestion, String RAGStatusColor, Decimal questionNo,List<PreviousSubSec> prvSubSec, Boolean isPrevious)
        {
            this.subSecQuestion=subSecQuestion;
            this.RAGStatusColor=RAGStatusColor;
            this.questionNo=questionNo;
            this.prvSubSec = prvSubSec;
            this.isPrevious = isPrevious;
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
    Method Name: SRATChecklist_ReadOnlyInlineController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
    public SRATChecklist_ReadOnlyInlineController(ApexPages.StandardController controller) {        
        List<SRAT_Section_Questionnaire__c> tempSecQuesList=new List<SRAT_Section_Questionnaire__c>();
        List<SRAT_Sub_Section_Name__c> subSectionNameList=new List<SRAT_Sub_Section_Name__c>();
        List<SRAT_Sub_Section_Questionnaire__c> subSectionQuesList=new List<SRAT_Sub_Section_Questionnaire__c>();
        List<SRAT_User_Section_Question__c> userSecExistList=new List<SRAT_User_Section_Question__c>();
        List<SRAT_User_Sub_Section_Question__c> userSubSecExistList=new List<SRAT_User_Sub_Section_Question__c>();
        userSecQues=new SRAT_User_Section_Question__c();
        userSubSecQues=new SRAT_User_Sub_Section_Question__c();        
        sratId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        isOmReadinessTabVisible = true;
        isPreviousSRATExist = false;
        isOmRead = false;
        previousSRAT = new List<SRAT__c>();
        mapTitleSubSection = new Map<String,List<SRAT_User_Sub_Section_Question__c>>();
        sratIdList = new List<Id>();
        if(sratId!=null)
        {
            sratRecordList=[select SRAT_Version__c,Item__c, Has_Deployment_Lead_Submitted__c, Wave_Plan_Version__c,Has_KT_Lead_Submitted__c, 
                            Has_KT_Lead_Saved__c,Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c,Wave_Plan_lk__r.Wave_Label__c, 
                            Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, 
                            Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Wave_Plan_lk__r.GO_Live_Date_del__c ,
                            Deal_Location_lk__r.Deployment_Lead_New__c,Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__c,
                            Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__c,Wave_Plan_lk__r.KT_Lead_New__c,Planned_Date__c,
                            Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,Days_Before_Go_Live_Date__c, 
                            Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__c, 
                            Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__c,Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c
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
                showNotesBlock=true;
                sratRecord=sratRecordList[0];
                waveVersionRecordList=[select Deal__r.name, Deal__c, name from Wave_Plan_Version__c where id=:sratRecord.Wave_Plan_Version__c limit 1];
                if(waveVersionRecordList.size()>0)
                {
                    waveVersionRecord=waveVersionRecordList[0];      
                     for(SRAT__C srat : [Select Comments__c,Has_Deployment_Lead_Submitted__c,Has_KT_Lead_Submitted__c,Item__c,SRAT_Item_Master_Id__c,
                                        Days_Before_Go_Live_Date__c From SRAT__C Where Wave_Plan_Version__c =:waveVersionRecord.Id  and Deal_Location_lk__c = : sratRecord.Deal_Location_lk__c 
                                        and Wave_Plan_lk__c = : sratRecord.Wave_Plan_lk__c order by Days_Before_Go_Live_Date__c])   {
                        if(srat.Days_Before_Go_Live_Date__c < sratRecord.Days_Before_Go_Live_Date__c) {
                            sratIdList.add(srat.Id);
                            previousSRAT.add(srat);
                        }
                    }                                                        
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_WAVE_PLAN_EXIST));
                    showMainMsg=true;
                    showForm=false;
                    showNotesBlock=false;
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_SRAT_EXIST));
                showMainMsg=true;
                showForm=false;
                showNotesBlock=false;
            }
            sratVersion=[select SRAT_Name__c, id, name from SRAT_VERSION__c where id=:sratRecord.SRAT_Version__c];
            if(sratVersion.size()>0)
            {
                sratVersionId=sratVersion[0].id;
                sratName=sratVersion[0].SRAT_Name__c;                                   
                listOfServiceDelApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, Volume_of_Transactions__c from Factory_Specific_Technology__c where Application_Type__c=:'Service Delivery Applications' and SRAT__c=:sratId and SRAT_Version__c=:sratVersionId order by createddate desc];
                listOfServiceManageApp = [select Application_Description__c, Application_Name__c, Comments__c, No_of_Users__c, RAG_Status__c, Volume_of_Transactions__c from Factory_Specific_Technology__c where Application_Type__c=:'Service Management Applications' and SRAT__c=:sratId and SRAT_Version__c=:sratVersionId order by createddate desc];
                assignMessages();
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_SRAT_ACTIVE));
                showMainMsg=true;
                showForm=false;
                showNotesBlock=false;
            }
            mainQueries();            
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_SRAT_ID_EXIST));
            showMainMsg=true;
            showForm=false;
            showNotesBlock=false;
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
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_NO_QUESTION_SET_MMP));
            showMsg1=true;
        }
        List<SRAT_Sub_Section_Name__c> bpoSubSecList=[select SRAT_Sub_Section_Name__c, id from SRAT_Sub_Section_Name__c where SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId and SRAT_Sub_Section_Name__c=:'OM Readiness Summary'];      
        if(bpoSubSecList.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_NO_QUESTION_SET_OMRS));
            showMsg2=true;
        }
        List<SRAT_Section_Questionnaire__c> tempSecQues3= [Select id,SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where Sort_Order__c =:3 and SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];        
        if(tempSecQues3.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_NO_QUESTION_SET_EBS));
            showMsg3=true;
        }
        List<SRAT_Section_Questionnaire__c> tempSecQues4= [Select id,SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where Sort_Order__c =:4 and SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];       
        if(tempSecQues4.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_NO_QUESTION_SET_IDC));
            showMsg4=true;
        }
        List<SRAT_Section_Questionnaire__c> tempSecQues5= [Select id,SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where Sort_Order__c =:5 and SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];        
        if(tempSecQues5.size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.MSG_NO_QUESTION_SET_JM));
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
    Method Name: assignColors
    Description: Method for assigning colors to RAG Status
    Paramenters: coloringField: String
    Return Value: colorName: String
    *******************************/
    public String assignColors(String coloringField)
    {
        String colorName;
        if(coloringField==UTIL_Constants.DEFAULT_A_INCOMPLETE_ON_TRACK||coloringField==UTIL_Constants.A_INCOMPLETE_ON_TRACK)
            colorName=UTIL_Constants.color_FF8C00;
        if(coloringField==UTIL_Constants.DEFAULT_R_INCOMPLETE_OFF_TRACK||coloringField==UTIL_Constants.R_INCOMPLETE_OFF_TRACK)
            colorName=UTIL_Constants.COLOR_RED;
        if(coloringField==UTIL_Constants.DEFAULT_G_COMPLETE||coloringField==UTIL_Constants.G_COMPLETE)
            colorName=UTIL_Constants.color_006400;
        if(coloringField==UTIL_Constants.DEFAULT_NOT_APPLICABLE||coloringField==UTIL_Constants.NOT_APPLICABLE)
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
        previousSubmittedUserSubSecExistList = new List<SRAT_User_Sub_Section_Question__c>(); 
        tempSecQuesList = [Select id,Sort_Order__c, SRAT_Section_Name__c,Question_Description__c,Title__c,Category__c from SRAT_Section_Questionnaire__c where SRAT_Section_Name__r.SRAT_Version__c=:sratVersionId];
        subSectionNameList = [select SRAT_Section_Name__c, SRAT_Section_Name__r.SRAT_Version__c, SRAT_Sub_Section_Name__c, id from SRAT_Sub_Section_Name__c order by SRAT_Sub_Section_Name__c ASC];
        subSectionQuesList = [select Reference__c, Handover_to_Service_Delivery__c, Measurement__c,SRAT_Sub_Section_Id__c,Title__c, Question_Description__c, Category__c, id, name from SRAT_Sub_Section_Questionnaire__c order by Sort_Number__c ASC];
        userSecExistList = [select SRAT_Section_Questionnaire__c, IS_Factory_Engagement_Spc_Record__c, Question_Description__c, Default_RAG_Status__c, Category__c, Comments__c, Overall_RAG_Status__c, Title__c from SRAT_User_Section_Question__c where SRAT__c=:sratId];
        userSubSecExistList = [select Reference__c,Handover_to_Service_Delivery__c, Measurement__c, IS_Factory_Engagement_Spc_Record__c, SRAT_Sub_Section_Questionnaire__c, Question_Description__c, Category__c, Comments__c, RAG_Status__c, Title__c from SRAT_User_Sub_Section_Question__c where SRAT__c=:sratId];
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
                    for(SRAT_Section_Questionnaire__c sq : tempSecQuesList)
                    {      
                        if(sq.Sort_Order__c == sortOrder)
                        {
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
                                                String subRAGColor=' ';
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
                                                                            userSubSecQues.Measurement__c=subq.Measurement__c;
                                                                            userSubSecQues.Handover_to_Service_Delivery__c=subq.Handover_to_Service_Delivery__c;                                                                            
                                                                            userSubSecQues.SRAT__c=sratId;
                                                                            userSubSecQues.SRAT_Sub_Section_Questionnaire__c=subq.id;
                                                                            userSubSecQues.SRAT_Version__c=sratVersionId;
                                                                            userSubSecQues.RAG_Status__c=UTIL_Constants.NOT_APPLICABLE;  
                                                                            userSubSecQues.Reference__c=subq.Reference__c;                     
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
                                                                    system.debug('Ddamodar-------isPreviousRec '+ isPreviousRec);                
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
                                    userSecQues.Default_RAG_Status__c=UTIL_Constants.DEFAULT_NOT_APPLICABLE;
                                    userSecQues.Overall_RAG_Status__c=UTIL_Constants.NOT_APPLICABLE;
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
                    for(SRAT_Sub_Section_Name__c ssn : subSectionNameList)
                    {     
                        if(ssn.SRAT_Sub_Section_Name__c==UTIL_Constants.OM_READINESS_SUMMARY && ssn.SRAT_Section_Name__r.SRAT_Version__c==sratVersionId)
                        {
                            List<SubQuestion> subQuesList=new List<SubQuestion>();
                            String BPOMobSubRAGColor=' ';
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
                                                        userSubSecQues.RAG_Status__c=UTIL_Constants.NOT_APPLICABLE;                    
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
    Return Value: List<MainQuestion>
    *******************************/
    public List<MainQuestion> getClientChgQuestionnaire() 
    {
        clientChgQuestion = setTabQuestionnaires(6);
        return clientChgQuestion;
    } 
    
    /******************************
    Method Name: getFacEngSpcQuestionnaire
    Description: To get the Checklist Questions for Manage Mobilization Program tab
    Paramenters: NA
    Return Value: List<MainQuestion>
    Status: Not Used
    *******************************/
    public List<MainQuestion> getFacEngSpcQuestionnaire() 
    {
        facEngSpcQuestion= setTabQuestionnaires(6);
        return facEngSpcQuestion;
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
                 if(subUser.IS_Factory_Engagement_Spc_Record__c==true)
                    {
                      subsecExist=true;
                    }
                }
            }       
            if(subsecExist==true)
            {
                Decimal quesNo=5.00;
                //Looping to get the pre-saved User Sub Section Questions
                for(SRAT_User_Sub_Section_Question__c subUser : userSubSecExistList)
                {
                    String subRAGColor=' '; 
                    if(subUser.IS_Factory_Engagement_Spc_Record__c==true)
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
                    String subRAGColor=' ';                                 
                    if(Limits.getScriptStatements()<Limits.getLimitScriptStatements())
                    { 
                                    
                        userSubSecQues=new SRAT_User_Sub_Section_Question__c();                                                                             
                        userSubSecQues.SRAT__c=sratId;                                                                           
                        userSubSecQues.SRAT_Version__c=sratVersionId;
                        userSubSecQues.RAG_Status__c=UTIL_Constants.NOT_APPLICABLE; 
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
                 for(SRAT_User_Section_Question__c sUser : userSecExistList)
                {
                 if(sUser.IS_Factory_Engagement_Spc_Record__c==true)
                    {
                      secExist=true;
                    }
                }
            }
            if(secExist==true)
            {
                //Loop to get pre-saved Main Questions for SRAT version and SRAT plan
                for(SRAT_User_Section_Question__c sUser : userSecExistList)
                {
                    //List<SubQuestion> subQuesList=new List<SubQuestion>();
                    String setRAGColor=' ';  
                    if(sUser.IS_Factory_Engagement_Spc_Record__c==true)
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
                userSecQues.Overall_RAG_Status__c=UTIL_Constants.NOT_APPLICABLE;
                userSecQues.IS_Factory_Engagement_Spc_Record__c=true; 
                userSecQues.Category__c=UTIL_Constants.PEOPLE;           
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
                    String delvColor=' ';
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
    Method Name: getServiceManageApp
    Description: To return the pre-saved list of Service Management Application
    Paramenters: NA
    Return Value: List<FactorySpecTech>
    ***********************************************/
    public List<FactorySpecTech> getServiceManageApp() {
        List<FactorySpecTech>  ServManageAppList=getFactorySpecificList(listOfServiceManageApp);        
        return ServManageAppList;
    }       
    /**********************Factory Specific Technology Tab Ends**************************************/     
    public void callisRAIDAccessible()
    {
        List<SRAT__c> tempSRATLst=[select id, Wave_Plan_Version__r.deal__c from SRAT__c where id=:sratId];
        if(tempSRATLst.size()>0)
        {
            //isRAIDAccess=CheckProfile.isRAIDAccessible(tempSRATLst[0].Wave_Plan_Version__r.deal__c);
            isRAIDAccess = UAMSolMobUtility.isAddVisible_RAIDLog;
        }
    }   
}