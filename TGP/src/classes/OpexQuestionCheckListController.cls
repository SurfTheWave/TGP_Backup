/*
Author : Sanjay Kumar Das
Story  : Story-0064/MOB_025 
Description : As an opex coach, I should be able to initiate & submit OPEX checklist to OPEX Lead. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public with sharing class OpexQuestionCheckListController {

    public String opexId{get;set;}
    public String opexVersionId{get;set;}
    public String stablity{get;set;}
    public String itemName{get;set;}
    public String whereStr{get;set;}
    public String overAllRating{get;set;}
    public String opexLeadSec{get;set;}
    public String opexLeadPrimary{get;set;}
    public OPEX__c opexRecord{get;set;}
    public OPEX_Section_Name__c subSectionName{get;set;}
    public OPEX_User_Section_Question__c userSubSecQues{get;set;}
    public  OPEX__c objOpex{get;set;}
    public String userProfileName{get;set;}
    public Wave_Plan_Version__c waveVersionRecord{get;set;}    
   
    public Boolean itemIndicator{get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean isOpexVersionActive {get; set;}
    public Boolean showForm{get;set;} 
    public Boolean isFocNone{get;set;}
    public Boolean isStdNone{get;set;}
    public Boolean isPlnNone{get;set;}
    public Boolean isOrgNone{get;set;}
    public Boolean isVisNone{get;set;}
    public Boolean isImpNone{get;set;}
    public Boolean isSaveSuccess{get;set;}
    
    public Boolean isSubmitted{get; set;} //    Story-0065/MOB_026    
  
    public List<OPEX_Version__c> opexVersion{get;set;}
    public List<OPEX_User_Section_Question__c> listUserSecQues{get;set;}
    public Map<String,Integer> m{get;set;}
    
    public Decimal focScore;
    public Decimal stdScore;
    public Decimal plnScore;
    public Decimal orgScore;
    public Decimal visScore;
    public Decimal impScore;
    public Decimal overAllScore;    
    public Decimal score;
    
    public boolean isRAIDAccess{get;set;}
    public boolean iscalledfromSubmit{get;set;}
    
     /******************************
    Method Name: OpexQuestionCheckListController
    Description: Constructor for Initialization
    Paramenters: controller
    Return Value: NA
    *******************************/
    public OpexQuestionCheckListController(ApexPages.StandardController controller) 
    {
                                                                       
        opexId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        isSubmitted = false;
        if(opexId!=null)
        {
                List<OPEX__c> tempLstOpex=[select id,Is_Submitted__c,OPEX_Version__c  from OPEX__c where id=:opexId];
                boolean isExist=false;
                if(tempLstOpex.size()>0)
                {
                     if(tempLstOpex[0].Is_Submitted__c==true)
                     {
                        opexVersionId=tempLstOpex[0].OPEX_Version__c;
                        opexVersion=[select OPEX_Name__c, id, name,isActive__c from OPEX_Version__c where id=:tempLstOpex[0].OPEX_Version__c]; 
                        isExist=true;
                     }
                }
                if(isExist==false)
                {
                    opexVersion=[select OPEX_Name__c, id, name,isActive__c from OPEX_Version__c where isActive__c=:true]; 
                }           
            if(opexVersion.size()>0)
            {
                opexVersionId=opexVersion[0].id;
                if(isExist==true)
                {
                    isOpexVersionActive=true;
                }
                else
                {
                    isOpexVersionActive=opexVersion[0].isActive__c;
                }
                if(isOpexVersionActive)
                    {
                    try
                        {
                            // Getting the opex record from OPEX__c object for the particaular opex id which the user want to fill the opex questionare.
                            
                            opexRecord=[select Operational_Maturity_Criteria_Remark__c,Overall_Rating__c,Item__c,
                                        Is_Submitted__c,Score__c,Overall_Rating_Status__c,Focus_Service_operation_Status__c,
                                        Standard__c,Improve_Service_Operation_Status__c,Organize_Service_Operation__c,
                                        Plan_Service_operation_Status__c,Visualize_Service_Operation_Status__c,
                                        Wave_Plan_Version__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                        Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, Planned_Date__c, id,name,
                                        Focus__c,Standardize__c,Plan__c,Organize__c,Visualize__c,Improve__c,Process_Score__c,People__c,
                                        Technology__c,Wave_Process__r.Client_Specific_Process_Mapping__r.name,  Wave_Plan_lk__r.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c,Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,OPEX_Version__c  from OPEX__c where id=:opexId];
                                        
                                        
                       
                                    
                            getWhereStr();
                            isSubmitted =  opexRecord.Is_Submitted__c;
                           // ktLead = opexRecord.Wave_Plan_lk__r.KT_Lead__r.Id ;
                            opexLeadPrimary = opexRecord.Wave_Plan_lk__r.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c ;
                            opexLeadSec =  opexRecord.Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c;
                            String currentUser = Userinfo.getUserId();
                            String userProfileName = [select u.Profile.Name from User u where u.id = :currentUser].Profile.Name; //Get users with Profile Name
                        }
                        catch(Exception ex)
                            {
                               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.OPERATIONAL_MATURITY_RECORD_NOT_AVAILABLE));
                               showForm=false;
                            }
                    try 
                            {
                            // Getting the wave version record for selected opex record.
                            waveVersionRecord=[select Deal__r.name, Deal__c, name,id from Wave_Plan_Version__c where id=:opexRecord.Wave_Plan_Version__c];
                            }
                        catch(Exception ex)
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.WAVE_PLAN_VERSION_NOT_AVAILABLE));
                                showForm=false;
                            }
                    listUserSecQues=new List<OPEX_User_Section_Question__c>();
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.NO_OPERATIONAL_MATURITY_VERSION_IS_ACTIVE));
                    showForm=false;
                    //PageReference pg=new PageReference('/'+opexRecord.Wave_Plan_Version__c);
                }
                isFocNone=false;
                isStdNone=false;
                isPlnNone=false;
                isOrgNone=false;
                isVisNone=false;
                isImpNone=false;
                isSaveSuccess=false;
           }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.NO_OPERATIONAL_MATURITY_VERSION_IS_ACTIVE));
                showForm=false;
                //PageReference pg=new PageReference('/'+opexRecord.Wave_Plan_Version__c);
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_OPENING_THE_PAGE));
            showForm=false;
        }
        focScore=0;
        stdScore=0;
        plnScore=0;
        orgScore=0;
        visScore=0;
        impScore=0;
        overAllScore=0;    
        score=0;
    }
     /**************************************************
    Class Name: Section
    Description:This is the inner class for holding the value of the OPEX section.
    ***************************************************/    
     public class Section
    {
        Public OPEX_Section_Name__c Section{get;set;}
        public List<SubQuestion> subQues{get; set;}
        
        public Section(OPEX_Section_Name__c Section, List<SubQuestion> subQues)
        {
            this.Section=Section;
            this.subQues=subQues;
        }
    }
     /**************************************************
    Class Name: SubQuestion
    Description:This is inner class for holding the value of the OPEX Questionare.
    ***************************************************/   
    public class SubQuestion
    {
        Public OPEX_User_Section_Question__c subSecQuestion{get;set;}
       
        public SubQuestion(OPEX_User_Section_Question__c subSecQuestion)
        {
            this.subSecQuestion=subSecQuestion;
      
        }        
        
    }
    /**********************************************
    Method Name: getServiceDelApp
    Description: Below method is used to get the Questionaires of Focus the Service Operation
    Paramenters: NA
    Return Value: List<Section> 
    ***********************************************/
    public List<Section> serOperSubSecList;    
    public List<Section> getServiceOperationQuestionnaire()
    {
            serOperSubSecList=new List<Section>();
            if(Limits.getQueries()<100){
            List<OPEX_Section_Name__c> focSec = [select OPEX_Section_Name__c, id from OPEX_Section_Name__c where OPEX_Version__c=:opexVersionId and OPEX_Section_Name__c=:'Focus the Service operation'];
            
            if(focSec.size()>0)
            {
                for(OPEX_Section_Name__c ssn:focSec)
                {     
                    List<SubQuestion> serOperSubQuesList=new List<SubQuestion>();
                    
                    if(Limits.getQueries()<100)
                    {
                    if(itemIndicator==true)
                        {
                            String qry=UTIL_Constants.SOQL_QUERY_ON_OPEX_SECTION_QUESTIONAIRE  + UTIL_Constants.INVERTED_COMMA_STRING + ssn.id + UTIL_Constants.INVERTED_COMMA_STRING;
                            List<OPEX_Section_Questionnaire__c> opexSecQues = new List<OPEX_Section_Questionnaire__c>();
                            opexSecQues = Database.query(qry+UTIL_Constants.AND_STRING+String.escapeSingleQuotes(whereStr));
                            for(OPEX_Section_Questionnaire__c subq:opexSecQues)
                                {   
                                    if(Limits.getQueries()<100)
                                        {
                                            List<OPEX_User_Section_Question__c>     userSubSecExist =[select Question_Description__c, Answer__c  from OPEX_User_Section_Question__c where OPEX_Section_Questionnaire__c=:subq.id and OPEX__c=:opexId];
                                            if(userSubSecExist.size()>0)
                                                {
                                                    userSubSecQues=userSubSecExist[0];
                                                }
                                            else
                                                {                        
                                                    userSubSecQues=new OPEX_User_Section_Question__c();                       
                                                    userSubSecQues.Question_Description__c=subq.Question_Description__c;
                                                    userSubSecQues.OPEX__c=opexId;
                                                    userSubSecQues.OPEX_Section_Questionnaire__c=subq.id;
                                                    //userSubSecQues.Answer__c='NA';
                                                }
                                        }
                                        
                                    serOperSubQuesList.add(new SubQuestion(userSubSecQues));
                                }
                        }
                    }
                    subSectionName=new OPEX_Section_Name__c();
                    subSectionName.OPEX_Section_Name__c=ssn.OPEX_Section_Name__c;                
                    serOperSubSecList.add(new Section(subSectionName,serOperSubQuesList));
                    
                }
            }
            else
            {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.THERE_IS_NO_QUESTION_SET_FOR));
          
            }
           
            }
        return serOperSubSecList;
    }
    /**********************************************
    Method Name: serOprSecQues
    Description: Below method is used to set the questionare of focus the service operation
    Paramenters: NA
    Return Value: void
    ***********************************************/
   
    public List<OPEX_User_Section_Question__c> serOprSecQues{get;set;}    
    public void setFocusServiceOperation()
    {
        serOprSecQues = new List<OPEX_User_Section_Question__c>();
            for(Section ss:serOperSubSecList)
            {
                for(SubQuestion sq:ss.subQues)
                {
                        serOprSecQues.add(sq.subSecQuestion);
                }
            }
    }
    /**********************************************
    Method Name: getStandarizeServiceOperationQuestionnaire
    Description:Below method is used to get the questionare of standard the service operation 
    Paramenters: NA
    Return Value: List<Section>
    ***********************************************/
    public List<Section> stdSerOprSubSecList;    
    public List<Section> getStandarizeServiceOperationQuestionnaire()
    {
            stdSerOprSubSecList=new List<Section>();
            
            if(Limits.getQueries()<100)
            {
                List<OPEX_Section_Name__c> stdSer=[select OPEX_Section_Name__c, id from OPEX_Section_Name__c where OPEX_Version__c=:opexVersionId and  OPEX_Section_Name__c=:'STANDARDIZE THE SERVICE OPERATION'];
            
                if(stdSer.size()>0)
                {
                    for(OPEX_Section_Name__c ssn:stdSer)
                        {  
                            List<SubQuestion> stdSerOperSubQuesList=new List<SubQuestion>();
                           
                                 if(Limits.getQueries()<100)
                                    {
                                        if(itemIndicator==true)
                                        {
                                           String qry=UTIL_Constants.SOQL_QUERY_ON_OPEX_SECTION_QUESTIONAIRE  + UTIL_Constants.INVERTED_COMMA_STRING + ssn.id + UTIL_Constants.INVERTED_COMMA_STRING;
                                            List<OPEX_Section_Questionnaire__c> opexSecQues = new List<OPEX_Section_Questionnaire__c>();
                                            opexSecQues = Database.query(qry+UTIL_Constants.AND_STRING+String.escapeSingleQuotes(whereStr));
                                                for(OPEX_Section_Questionnaire__c subq:opexSecQues)
                                                    {   
                                                        if(Limits.getQueries()<100)
                                                            {
                                                                List<OPEX_User_Section_Question__c>     userSubSecExist =[select Question_Description__c, Answer__c  from OPEX_User_Section_Question__c where OPEX_Section_Questionnaire__c=:subq.id and OPEX__c=:opexId];
                                                                if(userSubSecExist.size()>0)
                                                                {
                                                                    userSubSecQues=userSubSecExist[0];
                                                                }
                                                                else
                                                                {                        
                                                                    userSubSecQues=new OPEX_User_Section_Question__c();                       
                                                                    userSubSecQues.Question_Description__c=subq.Question_Description__c;
                                                                    userSubSecQues.OPEX__c=opexId;
                                                                    userSubSecQues.OPEX_Section_Questionnaire__c=subq.id;
                                                                    //userSubSecQues.Answer__c='NA';
                                                                }
                        
                                                            }
                                                            
                                                        stdSerOperSubQuesList.add(new SubQuestion(userSubSecQues));
                                                    }
                                        }
               
                                    }
                                subSectionName=new OPEX_Section_Name__c();
                                subSectionName.OPEX_Section_Name__c=ssn.OPEX_Section_Name__c;                
                                stdSerOprSubSecList.add(new Section(subSectionName,stdSerOperSubQuesList));
                        }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.THERE_IS_NO_QUESTION_SET_FOR));
                }
            }
        
        return stdSerOprSubSecList;
    }
   /**********************************************
    Method Name: setStandardizeServiceOperation
    Description:Below method is used to setting  the value questionae of service opeartion
    Paramenters: NA
    Return Value:void
    ***********************************************/
    public List<OPEX_User_Section_Question__c> stdSerSecQues{get;set;}
    
    public void setStandardizeServiceOperation()
    {
        stdSerSecQues = new List<OPEX_User_Section_Question__c>();
            for(Section ss:stdSerOprSubSecList)
            {
                for(SubQuestion sq:ss.subQues)
                {
                    stdSerSecQues.add(sq.subSecQuestion);
                }
            }
    }
   /**********************************************
    Method Name: getPlanServiceOperationQuestionnaire
    Description:Below method is used is to get the value of questionare for plan the service operation
    Paramenters: NA
    Return Value:List<Section>
    ***********************************************/
   
    public List<Section> planSerOprSubSecList;
    public List<Section> getPlanServiceOperationQuestionnaire()
    {
        planSerOprSubSecList=new List<Section>();
        if(Limits.getQueries()<100)
            {
                List<OPEX_Section_Name__c> plzSer=[select OPEX_Section_Name__c, id from OPEX_Section_Name__c where OPEX_Version__c=:opexVersionId and  OPEX_Section_Name__c=:'PLAN THE SERVICE OPERATION'];
            
                if(plzSer.size()>0)
                    {
            
                        for(OPEX_Section_Name__c ssn:plzSer)
                            {
                                List<SubQuestion> planSerOperSubQuesList=new List<SubQuestion>();
                               
                                if(Limits.getQueries()<100)
                                    {
                                        if(itemIndicator==true)
                                        {
                                            String qry=UTIL_Constants.SOQL_QUERY_ON_OPEX_SECTION_QUESTIONAIRE  + UTIL_Constants.INVERTED_COMMA_STRING + ssn.id + UTIL_Constants.INVERTED_COMMA_STRING;
                                            List<OPEX_Section_Questionnaire__c> opexSecQues = new List<OPEX_Section_Questionnaire__c>();
                                            opexSecQues = Database.query(qry+UTIL_Constants.AND_STRING+String.escapeSingleQuotes(whereStr));
                                                for(OPEX_Section_Questionnaire__c subq:opexSecQues)
                                                    {   
                                                        if(Limits.getQueries()<100)
                                                            {
                                                                List<OPEX_User_Section_Question__c>     userSubSecExist =[select Question_Description__c, Answer__c  from OPEX_User_Section_Question__c where OPEX_Section_Questionnaire__c=:subq.id and OPEX__c=:opexId];
                                                                if(userSubSecExist.size()>0)
                                                                {
                                                                    userSubSecQues=userSubSecExist[0];
                                                                }
                                                                else
                                                                {                        
                                                                    userSubSecQues=new OPEX_User_Section_Question__c();                       
                                                                    userSubSecQues.Question_Description__c=subq.Question_Description__c;
                                                                    userSubSecQues.OPEX__c=opexId;
                                                                    userSubSecQues.OPEX_Section_Questionnaire__c=subq.id;
                                                                    //userSubSecQues.Answer__c='NA';
                                                                }
                        
                                                            }
                                                            planSerOperSubQuesList.add(new SubQuestion(userSubSecQues));
                                                    }
                                        }
                                    }      
                                subSectionName=new OPEX_Section_Name__c();
                                subSectionName.OPEX_Section_Name__c=ssn.OPEX_Section_Name__c;                
                                planSerOprSubSecList.add(new Section(subSectionName,planSerOperSubQuesList));
                            }       
            
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.THERE_IS_NO_QUESTION_SET_FOR));
                        }
            }
           
        return planSerOprSubSecList;
    }
    /**********************************************
    Method Name: setPlanServiceOperation
    Description:Setting the value of questionare of plan the service operation
    Paramenters: NA
    Return Value:void
    ***********************************************/
    
    //Start- Setting the value of questionare of plan the service operation
    public List<OPEX_User_Section_Question__c> planSerSecQues{get;set;}    
    public void setPlanServiceOperation()
    {
        planSerSecQues = new List<OPEX_User_Section_Question__c>();
            for(Section ss:planSerOprSubSecList)
            {
                for(SubQuestion sq:ss.subQues)
                {
                    planSerSecQues.add(sq.subSecQuestion);
                }
            }
    }
 /**********************************************
    Method Name: getOrgServiceOperationQuestionnaire
    Description:Getting the value of questioanre for orgaanizr the service operation
    Paramenters: NA
    Return Value:List<Section>
    ***********************************************/
 
 //
     public List<Section> orgSerOprSubSecList;    
    public List<Section> getOrgServiceOperationQuestionnaire()
    {
       orgSerOprSubSecList=new List<Section>();
        if(Limits.getQueries()<100)
        {
            List<OPEX_Section_Name__c> orgSer=[select OPEX_Section_Name__c, id from OPEX_Section_Name__c where OPEX_Version__c=:opexVersionId and   OPEX_Section_Name__c=:'ORGANIZE THE SERVICE OPERATION'];
            if(orgSer.size()>0)
            {
            
              for(OPEX_Section_Name__c ssn:orgSer)
            {  
               List<SubQuestion> orgSerOperSubQuesList=new List<SubQuestion>();
               
                   if(Limits.getQueries()<100)
                                    {
                                        if(itemIndicator==true)
                                        {
                                            String qry=UTIL_Constants.SOQL_QUERY_ON_OPEX_SECTION_QUESTIONAIRE  + UTIL_Constants.INVERTED_COMMA_STRING + ssn.id + UTIL_Constants.INVERTED_COMMA_STRING;
                                            List<OPEX_Section_Questionnaire__c> opexSecQues = new List<OPEX_Section_Questionnaire__c>();
                                            opexSecQues = Database.query(qry+UTIL_Constants.AND_STRING+String.escapeSingleQuotes(whereStr));
                                                for(OPEX_Section_Questionnaire__c subq:opexSecQues)
                                                    {   
                                                        if(Limits.getQueries()<100)
                                                            {
                                                                List<OPEX_User_Section_Question__c>     userSubSecExist =[select Question_Description__c, Answer__c  from OPEX_User_Section_Question__c where OPEX_Section_Questionnaire__c=:subq.id and OPEX__c=:opexId];
                                                                if(userSubSecExist.size()>0)
                                                                {
                                                                    userSubSecQues=userSubSecExist[0];
                                                                }
                                                                else
                                                                {                        
                                                                    userSubSecQues=new OPEX_User_Section_Question__c();                       
                                                                    userSubSecQues.Question_Description__c=subq.Question_Description__c;
                                                                    userSubSecQues.OPEX__c=opexId;
                                                                    userSubSecQues.OPEX_Section_Questionnaire__c=subq.id;
                                                                    //userSubSecQues.Answer__c='NA';
                                                                }
                        
                                                            }
                                                        orgSerOperSubQuesList.add(new SubQuestion(userSubSecQues));
                                                    }
                                        }
                                    } 
                subSectionName=new OPEX_Section_Name__c();
                subSectionName.OPEX_Section_Name__c=ssn.OPEX_Section_Name__c;                
                orgSerOprSubSecList.add(new Section(subSectionName,orgSerOperSubQuesList));
            }
            
            }
            else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.THERE_IS_NO_QUESTION_SET_FOR));
            }
          }
            
        return orgSerOprSubSecList;
    }
  /**********************************************
    Method Name: setOrgStandardizeServiceOperation
    Description:Setting the value of questioanrte of Organize the service operation   
    Paramenters: NA
    Return Value:void
    ***********************************************/
    
 //Start-Setting the value of questioanrte of Organize the service operation   
    public List<OPEX_User_Section_Question__c> orgSerSecQues{get;set;}    
    public void setOrgStandardizeServiceOperation()
    {
        orgSerSecQues = new List<OPEX_User_Section_Question__c>();
            for(Section ss:orgSerOprSubSecList)
            {
                for(SubQuestion sq:ss.subQues)
                {
                    orgSerSecQues.add(sq.subSecQuestion);
                }
            }
    }
   /**********************************************
    Method Name: getVisServiceOperationQuestionnaire
    Description:Getting the value of questioanre for visualize the service operation   
    Paramenters: NA
    Return Value:List<Section>
    ***********************************************/
  
  //Start-Getting the value of questioanre for visualize the service operation
    public List<Section> visSerOprSubSecList;    
    public List<Section> getVisServiceOperationQuestionnaire() {
    
            visSerOprSubSecList=new List<Section>();
            if(Limits.getQueries()<100){
            List<OPEX_Section_Name__c> visSer=[select OPEX_Section_Name__c, id from OPEX_Section_Name__c where OPEX_Version__c=:opexVersionId and  OPEX_Section_Name__c=:'VISUALIZE THE SERVICE OPERATION'];
        
            if(visSer.size()>0){
             for(OPEX_Section_Name__c ssn:visSer)
            {    
                            
                List<SubQuestion> visSerOperSubQuesList=new List<SubQuestion>();
             
                if(Limits.getQueries()<100)
                                    {
                                        if(itemIndicator==true)
                                        {
                                            String qry=UTIL_Constants.SOQL_QUERY_ON_OPEX_SECTION_QUESTIONAIRE  + UTIL_Constants.INVERTED_COMMA_STRING + ssn.id + UTIL_Constants.INVERTED_COMMA_STRING;
                                            List<OPEX_Section_Questionnaire__c> opexSecQues = new List<OPEX_Section_Questionnaire__c>();
                                            opexSecQues = Database.query(qry+UTIL_Constants.AND_STRING+String.escapeSingleQuotes(whereStr));
                                                for(OPEX_Section_Questionnaire__c subq:opexSecQues)
                                                    {   
                                                        if(Limits.getQueries()<100)
                                                            {
                                                                List<OPEX_User_Section_Question__c>     userSubSecExist =[select Question_Description__c, Answer__c  from OPEX_User_Section_Question__c where OPEX_Section_Questionnaire__c=:subq.id and OPEX__c=:opexId];
                                                                if(userSubSecExist.size()>0)
                                                                {
                                                                    userSubSecQues=userSubSecExist[0];
                                                                }
                                                                else
                                                                {                        
                                                                    userSubSecQues=new OPEX_User_Section_Question__c();                       
                                                                    userSubSecQues.Question_Description__c=subq.Question_Description__c;
                                                                    userSubSecQues.OPEX__c=opexId;
                                                                    userSubSecQues.OPEX_Section_Questionnaire__c=subq.id;
                                                                    //userSubSecQues.Answer__c='NA';
                                                                }
                        
                                                            }
                                                        visSerOperSubQuesList.add(new SubQuestion(userSubSecQues));
                                                    }
                                        }
                                    } 
                subSectionName=new OPEX_Section_Name__c();
                subSectionName.OPEX_Section_Name__c=ssn.OPEX_Section_Name__c;                
                visSerOprSubSecList.add(new Section(subSectionName,visSerOperSubQuesList));
            }
            }
            else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.THERE_IS_NO_QUESTION_SET_FOR));
            }
            
           }
             
        return visSerOprSubSecList;
    }
    /**********************************************
    Method Name: setVisStandardizeServiceOperation
    Description: Setting the value of questionare for visualize the service operation   
    Paramenters: NA
    Return Value:void
    ***********************************************/
    
   
    public List<OPEX_User_Section_Question__c> visSerSecQues{get;set;}
    
    public void setVisStandardizeServiceOperation()
    {
        visSerSecQues = new List<OPEX_User_Section_Question__c>();
            for(Section ss:visSerOprSubSecList)
            {
                for(SubQuestion sq:ss.subQues)
                {
                    visSerSecQues.add(sq.subSecQuestion);
                }
            }
    }
   /**********************************************
    Method Name: getImpServiceOperationQuestionnaire
    Description: Getting the value of questionare for improve the service operation   
    Paramenters: NA
    Return Value:List<Section>
    ***********************************************/

 
    public List<Section> impSerOprSubSecList;
    
    public List<Section> getImpServiceOperationQuestionnaire() {
        
            impSerOprSubSecList=new List<Section>();
            if(Limits.getQueries()<100){
            List<OPEX_Section_Name__c> impSer=[select OPEX_Section_Name__c, id from OPEX_Section_Name__c where OPEX_Version__c=:opexVersionId and   OPEX_Section_Name__c=:'IMPROVE THE SERVICE OPERATION'];
            if(impSer.size()>0){
             for(OPEX_Section_Name__c ssn:impSer)
            {               
                List<SubQuestion> impSerOperSubQuesList=new List<SubQuestion>();
               
                    if(Limits.getQueries()<100)
                                    {
                                        if(itemIndicator==true)
                                        {
                                            String qry=UTIL_Constants.SOQL_QUERY_ON_OPEX_SECTION_QUESTIONAIRE  + UTIL_Constants.INVERTED_COMMA_STRING + ssn.id + UTIL_Constants.INVERTED_COMMA_STRING;
                                            List<OPEX_Section_Questionnaire__c> opexSecQues = new List<OPEX_Section_Questionnaire__c>();
                                            opexSecQues = Database.query(qry+UTIL_Constants.AND_STRING+String.escapeSingleQuotes(whereStr));
                                                for(OPEX_Section_Questionnaire__c subq:opexSecQues)
                                                    {   
                                                        if(Limits.getQueries()<100)
                                                            {
                                                                List<OPEX_User_Section_Question__c>     userSubSecExist =[select Question_Description__c, Answer__c  from OPEX_User_Section_Question__c where OPEX_Section_Questionnaire__c=:subq.id and OPEX__c=:opexId];
                                                                if(userSubSecExist.size()>0)
                                                                {
                                                                    userSubSecQues=userSubSecExist[0];
                                                                }
                                                                else
                                                                {                        
                                                                    userSubSecQues=new OPEX_User_Section_Question__c();                       
                                                                    userSubSecQues.Question_Description__c=subq.Question_Description__c;
                                                                    userSubSecQues.OPEX__c=opexId;
                                                                    userSubSecQues.OPEX_Section_Questionnaire__c=subq.id;
                                                                    //userSubSecQues.Answer__c='NA';
                                                                }
                        
                                                            }
                                                        impSerOperSubQuesList.add(new SubQuestion(userSubSecQues));
                                                    }
                                        }
                                    } 
                subSectionName=new OPEX_Section_Name__c();
                subSectionName.OPEX_Section_Name__c=ssn.OPEX_Section_Name__c;                
                impSerOprSubSecList.add(new Section(subSectionName,impSerOperSubQuesList));
            }
            }
            else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.THERE_IS_NO_QUESTION_SET_FOR));
            }
           }
         
        return impSerOprSubSecList;
    }
  /**********************************************
    Method Name: setImpStandardizeServiceOperation
    Description: Setting the value of questioanre for improve the service operation    
    Paramenters: NA
    Return Value:void
    ***********************************************/
    public List<OPEX_User_Section_Question__c> impSerSecQues{get;set;}
    
    public void setImpStandardizeServiceOperation()
    {
        impSerSecQues = new List<OPEX_User_Section_Question__c>();
            for(Section ss:impSerOprSubSecList)
            {
                for(SubQuestion sq:ss.subQues)
                {
                    impSerSecQues.add(sq.subSecQuestion);
                }
            }
    }
    //Default Constructor
    public OpexQuestionCheckListController()
        {
           
        }
    /**********************************************
    Method Name: SaveOPEXChecklist
    Description: Below method save the questionare and Answer of Each section.    
    Paramenters: NA
    Return Value:PageReference
    ***********************************************/    

    public PageReference SaveOPEXChecklist()
    {
      
      isFocNone=false;
      isStdNone=false;
      isPlnNone=false;
      isOrgNone=false;
      isVisNone=false;
      isImpNone=false;
      isSaveSuccess=false;
       
        if(opexId != null)
        {
            List<OPEX__c> lstOpex=[select Item__c,Is_Submitted__c,Score__c,Overall_Rating_Status__c,Focus_Service_operation_Status__c,
                                        Standard__c,Improve_Service_Operation_Status__c,Organize_Service_Operation__c,
                                        Plan_Service_operation_Status__c,Visualize_Service_Operation_Status__c,
                                        Wave_Plan_Version__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                        Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, Planned_Date__c, id,name,
                                        Focus__c,Standardize__c,Plan__c,Organize__c,Visualize__c,Improve__c,Process_Score__c,People__c,
                                        Technology__c,Overall_Rating__c,Operational_Maturity_Criteria_Remark__c 
                                        from OPEX__c where id=:opexId] ;
             objOpex = lstOpex.get(0);
        }     
        //Below code save the questions of each section BEGIN
        setFocusServiceOperation();
        setStandardizeServiceOperation();
        setPlanServiceOperation();
        setOrgStandardizeServiceOperation();
        setVisStandardizeServiceOperation();
        setImpStandardizeServiceOperation();  
         //setMaturityData();
         
         //checkForNoneAnswer();  
         
         /*if(isFocNone)
                {
                    //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Answer  in focus the service operation cannot be None. Please select another value'));
                    return null;
                }
            if(isStdNone)
                {
                     //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Answer in standardize the service operation cannot be None. Please select another value'));
                    return null;
                }
            if(isPlnNone)
                {
                     //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Answer in plan the service operation cannot be None. Please select another value'));
                    return null;
                }
            if(isOrgNone)
                {
                    //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Answer  in organize the service operation cannot be None. Please select another value'));
                    return null;
                }
            if(isVisNone)
                {
                     //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Answer  in visualize the service operation cannot be None. Please select another value'));
                    return null;
                }
            if(isImpNone)
                {
                     //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Answer  in improve the service operation cannot be None. Please select another value'));
                    return null;
                }*/
          
           
        //Value saved END  
//Story-0065/MOB_026    START
       try{
           /*if(opexRecord.Focus__c==null || opexRecord.Standardize__c==null ||  opexRecord.Plan__c==null ||  opexRecord.Organize__c==null ||  opexRecord.Visualize__c==null || opexRecord.Improve__c==null || opexRecord.People__c==null || opexRecord.Technology__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mobilization and Operational Maturity Criteria can not have None value'));
             return null;
           }*/
            setMaturityData();
            opexRecord.OPEX_Version__c=opexVersionId;
            update opexRecord;  
       }
       catch(Exception ex)
       {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
              return null;
       } 
        
        //Story-0065/MOB_026    End-        
        try
        {
            checkForStability();
           
            upsert serOprSecQues;
            upsert stdSerSecQues;
            upsert planSerSecQues;
            upsert orgSerSecQues;
            upsert visSerSecQues;
            upsert impSerSecQues;
            //upsert objOpex;
            update opexRecord;
            // refreshPage = true;
           refreshPage = true;
           if(iscalledfromSubmit==false)
           {
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.OPERATIONAL_MATURITY_CHECKLIST_SAVED_SUCCESSFULLY));     
           }
           PageReference pg=new PageReference(UTIL_Constants.APEX_OPEX_CHECKLISTLISTPAGE_ID+opexId);
           pg.setRedirect(true);
           return pg;   
           
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
            return null;
        }
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Operational Maturity Checklist Saved Successfully!'));     
       // PageReference pg=new PageReference('/apex/OPEXCheckListPage?id='+opexId);
        //pg.setRedirect(true);
        return null;
    }
    /**********************************************
    Method Name: doCancelChecklist
    Description: Below method is used to cancel the operation.    
    Paramenters: NA
    Return Value:PageReference
    ***********************************************/        
    public PageReference doCancelChecklist()
    {
        PageReference pg=new PageReference('/'+opexRecord.Wave_Plan_Version__c);
        pg.setRedirect(true);
        return pg;
    }
    /**********************************************
    Method Name: SubmitOPEXChecklist
    Description: Below method is used to submit the operation.    
    Paramenters: NA
    Return Value:PageReference
    ***********************************************/    
    public PageReference SubmitOPEXChecklist()
    {  
        iscalledfromSubmit=true; 
      SaveOPEXChecklist();
      iscalledfromSubmit=false;
      isFocNone=false;
      isStdNone=false;
      isPlnNone=false;
      isOrgNone=false;
      isVisNone=false;
      isImpNone=false;
       
        if(opexId != null)
        {
            List<OPEX__c> lstOpex=[select Item__c,Is_Submitted__c,Score__c,Overall_Rating_Status__c,Focus_Service_operation_Status__c,
                                        Standard__c,Improve_Service_Operation_Status__c,Organize_Service_Operation__c,
                                        Plan_Service_operation_Status__c,Visualize_Service_Operation_Status__c,
                                        Wave_Plan_Version__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                        Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__c, Wave_Plan_lk__c, Planned_Date__c, id,name,
                                        Focus__c,Standardize__c,Plan__c,Organize__c,Visualize__c,Improve__c,Process_Score__c,People__c,
                                        Technology__c,Overall_Rating__c,Operational_Maturity_Criteria_Remark__c 
                                        from OPEX__c where id=:opexId] ;
             objOpex = lstOpex.get(0);
        }     
        //Below code save the questions of each section BEGIN
        setFocusServiceOperation();
        setStandardizeServiceOperation();
        setPlanServiceOperation();
        setOrgStandardizeServiceOperation();
        setVisStandardizeServiceOperation();
        setImpStandardizeServiceOperation();  
        
         checkForNoneAnswer(); 
          if(isFocNone)
                {
                    //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ANSWER_IN_FOCUS));
                    return null;
                }
            if(isStdNone)
                {
                     //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ANSWER_IN_STANDARDIZE));
                    return null;
                }
            if(isPlnNone)
                {
                     //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ANSWER_IN_PLAN));
                    return null;
                }
            if(isOrgNone)
                {
                    //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ANSWER_IN_ORGANIZE));
                    return null;
                }
            if(isVisNone)
                {
                     //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ANSWER_IN_VISUALIZE));
                    return null;
                }
            if(isImpNone)
                {
                     //isSaveSuccess=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ANSWER_IN_IMPROVE));
                    return null;
                }
           //Story-0065/MOB_026    START
       try{
           if(opexRecord.Focus__c==null || opexRecord.Standardize__c==null ||  opexRecord.Plan__c==null ||  opexRecord.Organize__c==null ||  opexRecord.Visualize__c==null || opexRecord.Improve__c==null || opexRecord.People__c==null || opexRecord.Technology__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOBILZATION_AND_OPERATIONAL_MATURITY_CRITERIA_CAN_NOT_HAVE_NONE_VALUE));
             return null;
           }
            setMaturityData();
             update opexRecord;  
       }
       catch(Exception ex)
       {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
              return null;
       } 
        
          
        try
        {
                checkForStability();
               
                upsert serOprSecQues;
                upsert stdSerSecQues;
                upsert planSerSecQues;
                upsert orgSerSecQues;
                upsert visSerSecQues;
                upsert impSerSecQues;
                opexRecord.Is_Submitted__c=true;
                opexRecord.OPEX_Version__c=opexVersionId;
                upsert opexRecord;  
                refreshPage = true;
                 PageReference pg=new PageReference(UTIL_Constants.APEX_OPEX_qUESTIONAIRE_CHECKLIST_READ_ONLY_PAGE+opexId);
                 pg.setRedirect(true);
                 return pg;
        }
        catch(Exception ex)
        {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Submitting'));
            return null;
        }
     
        
         String currentUser = Userinfo.getUserId();
          if(opexLeadPrimary.equalsIgnoreCase(currentUser) || opexLeadSec.equalsIgnoreCase(currentUser) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN))
            {
             Task emailTask= new Task();
             emailTask.OwnerId = Userinfo.getUserId();//ktLead;
             emailTask.Subject = UTIL_Constants.APPROVAL_EMAIL_ATTACHMENT_ON_OPERATIONAL_MATURITY;
             emailTask.status = UTIL_Constants.NOT_STARTED;
             emailTask.description = UTIL_Constants.PLEASE_ATTACH_EMAIL_FROM_GOVERNANCE_LEAD_FOR_FOLLOWING_OPERATIONAL_MATURITY+waveVersionRecord.Deal__r.name+UTIL_Constants.WAVE_PLAN_VERSION+waveVersionRecord.name+UTIL_Constants.OPERATIONAL_MATURITY_ITEM +opexRecord.Item__c;
             insert emailTask;
            }
      return null;
    }
    /**********************************************
    Method Name: getWhereStr
    Description: Below method is used to build a where query based on the condition.  
    Paramenters: NA
    Return Value:void
    ***********************************************/
    public void getWhereStr()
    {
         itemName=opexRecord.Item__c;
         itemIndicator=false;
            if(itemName.equalsIgnoreCase(UTIL_Constants.PRE_GO_LIVE_ASSESSMENT) )
             {
               itemIndicator=true;
               whereStr=UTIL_Constants.BEING_PREPARED_GO_LIVE+itemIndicator;
          
             }
             else if(itemName.equalsIgnoreCase(UTIL_Constants.DAY_7_ASSIGNMENT))
             {
              itemIndicator=true;
             whereStr=UTIL_Constants.BEING_USED_DAY_7 +itemIndicator;
             
             }
              else if(itemName.equalsIgnoreCase(UTIL_Constants.DAY_30_ASSESSMENT))
             {
              itemIndicator=true;
             whereStr=UTIL_Constants.STABILITY_DAY_30_C +itemIndicator;
             
             }
             else if(itemName.equalsIgnoreCase(UTIL_Constants.DAY_60_ASSESSMENT))
             {
              itemIndicator=true;
             whereStr=UTIL_Constants.OK_DAY_60_C +itemIndicator ;
             
             }
             else if(itemName.equalsIgnoreCase(UTIL_Constants.DAY_90_ASSESSMENT))
             {
              itemIndicator=true;
              whereStr=UTIL_Constants.OK_DAY_90 +itemIndicator;
             
             }
              else if(itemName.equalsIgnoreCase(UTIL_Constants.DAY_1_ASSIGNMENT))
             {
              itemIndicator=true;
              whereStr=UTIL_Constants.DAY_1_ASSIGNMENT_C +itemIndicator;
             
             }
             
    }
    /**********************************************
    Method Name: checkForStability
    Description: Below method is used check the stability of a section  
    Paramenters: NA
    Return Value:void
    ***********************************************/
    
    public void checkForStability()
    {   
        List<OPEX_User_Section_Question__c> secStability =new List<OPEX_User_Section_Question__c>();
        if(serOprSecQues.size()>0)
        {      
            for(OPEX_User_Section_Question__c stab :serOprSecQues )
            {
                if(stab.Answer__c==UTIL_Constants.NO)
                  {
                    //objOpex.Focus_Service_operation_Status__c = 'Not Stable';
                    opexRecord.Focus_Service_operation_Status__c = UTIL_Constants.NOT_STABLE_STRING;
                    focScore=1;
                    break;
                    }
                else{
                    //objOpex.Focus_Service_operation_Status__c = 'Stable';
                    opexRecord.Focus_Service_operation_Status__c = UTIL_Constants.STABLE_STRING;
                    focScore=2;
                    }
                }
          }
          if(stdSerSecQues.size()>0)
          { 
            for(OPEX_User_Section_Question__c st :stdSerSecQues ){
                if(st.Answer__c==UTIL_Constants.NO)
                  {
                    //objOpex.Standard__c = 'Not Stable';
                    opexRecord.Standard__c = UTIL_Constants.NOT_STABLE_STRING;
                    stdScore=1;             
                    break;
                    }
                else{
                    //objOpex.Standard__c = 'Stable';
                    opexRecord.Standard__c = UTIL_Constants.STABLE_STRING;
                    stdScore=2;
                    }
                }
          }
          if(planSerSecQues.size()>0)
          {                   
            for(OPEX_User_Section_Question__c ste :planSerSecQues ){
                if(ste.Answer__c==UTIL_Constants.NO)
                  {
                  
                    //objOpex.Plan_Service_operation_Status__c = 'Not Stable';
                    opexRecord.Plan_Service_operation_Status__c = UTIL_Constants.NOT_STABLE_STRING;
                    plnScore=1;             
                    break;
                    }
                else{
                    //objOpex.Plan_Service_operation_Status__c = 'Stable';
                    opexRecord.Plan_Service_operation_Status__c = UTIL_Constants.STABLE_STRING;
                    plnScore=2;
                    }
                }
            }
            if(orgSerSecQues.size()>0)
            {
                for(OPEX_User_Section_Question__c sot :orgSerSecQues )
                 {
                    if(sot.Answer__c==UTIL_Constants.NO)
                      {
                        //objOpex.Organize_Service_Operation__c = 'Not Stable';
                        opexRecord.Organize_Service_Operation__c = UTIL_Constants.NOT_STABLE_STRING;
                        orgScore=1; 
                        break;
                        }
                    else{
                        //objOpex.Organize_Service_Operation__c = 'Stable';
                        opexRecord.Organize_Service_Operation__c = UTIL_Constants.STABLE_STRING;
                        orgScore=2;
                        }
                }
            }
            if(visSerSecQues.size()>0)
            {
                for(OPEX_User_Section_Question__c sovt :visSerSecQues )
                {
                if(sovt.Answer__c==UTIL_Constants.NO)
                  {
                    //objOpex.Visualize_Service_Operation_Status__c = 'Not Stable';
                    opexRecord.Visualize_Service_Operation_Status__c = UTIL_Constants.NOT_STABLE_STRING;
                    visScore=1; 
                    break;
                    }
                else{
                    //objOpex.Visualize_Service_Operation_Status__c = 'Stable';
                    opexRecord.Visualize_Service_Operation_Status__c = UTIL_Constants.STABLE_STRING;
                    visScore=2;
                    }
                }
            }
            if(impSerSecQues.size()>0)
            {
                for(OPEX_User_Section_Question__c soto :impSerSecQues )
                {
                    if(soto.Answer__c==UTIL_Constants.NO)
                    {
                        //objOpex.Improve_Service_Operation_Status__c = 'Not Stable';
                        opexRecord.Improve_Service_Operation_Status__c = UTIL_Constants.NOT_STABLE_STRING;
                        impScore=1;
                        break;
                    }
                else{
                    //objOpex.Improve_Service_Operation_Status__c = 'Stable';
                    opexRecord.Improve_Service_Operation_Status__c = UTIL_Constants.STABLE_STRING;
                    impScore=2;
                    }
                }
            }
            overAllScore=(focScore+stdScore+plnScore+orgScore+visScore+impScore)/6; 
            //objOpex.Overall_Rating_Status__c=overAllScore;
            opexRecord.Overall_Rating_Status__c=overAllScore;  
            try{            
               update opexRecord;
            }
            catch(Exception ex)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
            } 
            Map<String,opex_stability_checklist_score__c> scoreCode =new Map<String,opex_stability_checklist_score__c>();
            scoreCode = opex_stability_checklist_score__c.getAll();
            if(opexRecord.Score__c==null){
               opexRecord.Stablity__c='NA'; 
            }
            if(overAllScore > scoreCode.get(UTIL_Constants.SCORES_STRING).low_level_score__c)
             {
                overAllRating=UTIL_Constants.STABLE_STRING;
                //objOpex.Score__c='Stable';
                opexRecord.Score__c=UTIL_Constants.STABLE_STRING;
                opexRecord.Stablity__c=UTIL_Constants.STABLE_STRING;
              
             }
             else{
               overAllRating=UTIL_Constants.NOT_STABLE_STRING;
               //objOpex.Score__c='Not Stable';
               opexRecord.Score__c=UTIL_Constants.NOT_STABLE_STRING;
               opexRecord.Stablity__c=UTIL_Constants.NOT_STABLE_STRING;
              
             }
        try{
                //update objOpex; 
                 update opexRecord;
            }
            catch(Exception ex)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
            }
        
       
    }
    
    /**********************************************
    Method Name: setMaturityData
    Description: Below method is used set maturity  
    Paramenters: NA
    Return Value:void
    ***********************************************/
//    Story-0065/MOB_026    START    
    public void setMaturityData()
    {
            m = new Map<String,Integer>();
            m.put(null,0);
            m.put(UTIL_Constants.NOT_STABLE_STRING,1);
            m.put(UTIL_Constants.STABLE_STRING,2);
            m.put(UTIL_Constants.CAPABLE_STRING,3);
            m.put(UTIL_Constants.OPTIMIZED_STRING,4);
            score = ((Decimal)(m.get(opexRecord.Focus__c)+m.get(opexRecord.Standardize__c)+m.get(opexRecord.Plan__c)+m.get(opexRecord.Organize__c)+m.get(opexRecord.Visualize__c)+m.get(opexRecord.Improve__c)))/6;
            opexRecord.Process_Score__c = score;
            
            opex_stability_checklist_score__c stabScore = opex_stability_checklist_score__c.getInstance(UTIL_Constants.SCORES_STRING);
            Map<String,opex_stability_checklist_score__c> scoreCode =new Map<String,opex_stability_checklist_score__c>();
            scoreCode = opex_stability_checklist_score__c.getAll();
            
            opexRecord.Operational_Maturity_Criteria_Remark__c = '';
            if(score<scoreCode.get(UTIL_Constants.SCORES_STRING).low_level_score__c)
                opexRecord.Overall_Rating__c=UTIL_Constants.NOT_STABLE_STRING;
            else if( score >=scoreCode.get(UTIL_Constants.SCORES_STRING).low_level_score__c && score < scoreCode.get(UTIL_Constants.SCORES_STRING).medium_level_score__c)
            {
                opexRecord.Overall_Rating__c=UTIL_Constants.STABLE_STRING;
                opexRecord.Operational_Maturity_Criteria_Remark__c = UTIL_Constants.SHOULD_MEET_STABLE_CRITERIA_IN_EACH_CATEGORY_BY_90_DAYS_POST_GO_LIVE;
            }
            else if( score >=scoreCode.get(UTIL_Constants.SCORES_STRING).medium_level_score__c && score < scoreCode.get(UTIL_Constants.SCORES_STRING).high_level_score__c)
                opexRecord.Overall_Rating__c=UTIL_Constants.CAPABLE_STRING;
            else if(score >=scoreCode.get(UTIL_Constants.STABLE_STRING).high_level_score__c)
                opexRecord.Overall_Rating__c=UTIL_Constants.OPTIMIZED_STRING;
                        
            
//    Story-0065/MOB_026    END    
    }
    /**********************************************
    Method Name: checkForNoneAnswer
    Description: Below method is used check if the answer provided is None  
    Paramenters: NA
    Return Value:void
    ***********************************************/ 
    public void checkForNoneAnswer()
    {
        if(serOprSecQues.size()>0)
        {      
            for(OPEX_User_Section_Question__c focOnSer:serOprSecQues)
                {
                    if(focOnSer.Answer__c==null)
                     {
                        isFocNone=true;
                        break;
                     }
                }
         }    
         if(stdSerSecQues.size()>0)
         {      
                for(OPEX_User_Section_Question__c stdOnSer : stdSerSecQues)
                {
                    if(stdOnSer.Answer__c==null)
                     {
                        isStdNone=true;
                        break;
                     }
                }
         }
         if(planSerSecQues.size()>0)
         {   
                for(OPEX_User_Section_Question__c plnOnSer : planSerSecQues)
                {
                    if(plnOnSer.Answer__c==null)
                     {
                        isPlnNone=true;
                        break;
                     }
                }
          }
          if(orgSerSecQues.size()>0)
          {      
                for(OPEX_User_Section_Question__c orgOnSer : orgSerSecQues)
                {
                    if(orgOnSer.Answer__c==null)
                     {
                        isOrgNone=true;
                        break;
                     }
                }
          }
          if(visSerSecQues.size()>0)
          {     
                for(OPEX_User_Section_Question__c visOnSer : visSerSecQues)
                {
                    if(visOnSer.Answer__c==null)
                     {
                        isVisNone=true;
                        break;
                     }
                }
          }
          if(impSerSecQues.size()>0)
          {    
                for(OPEX_User_Section_Question__c impOnSer : impSerSecQues)
                {
                    if(impOnSer.Answer__c==null)
                     {
                        isImpNone=true;
                        break;
                     }
                }
           }
            
         
                    
           
    }
    public void callisRAIDAccessible()
    {
        List<OPEX__c> tempSRATLst=[select id, Wave_Plan_Version__r.deal__c from OPEX__c where id=:opexId];
        if(tempSRATLst.size()>0)
        {
            //isRAIDAccess=CheckProfile.isRAIDAccessible(tempSRATLst[0].Wave_Plan_Version__r.deal__c);
            isRAIDAccess=UAMSolMobUtility.isAddVisible_RAIDLog;
        }
    }   
}