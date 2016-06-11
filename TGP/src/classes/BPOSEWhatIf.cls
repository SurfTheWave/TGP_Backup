/**
   @Author : Jyotsna Yadav
   @name   : CanvasClass
   @CreateDate : 22 June 2015 
   @Description : Controller Class for BPOSE WhatIF
   @Version : 1.0 
   */
public without sharing class BPOSEWhatIf{
    
    public Scratchpad_Opportunity__c scPad{get;set;}
    public String paramList{get;set;}
    public String emailId;
    public Boolean access;
    public Id spId;
    /* Constructor */
     public BPOSEWhatIf(ApexPages.StandardController stdController) {
         spId = stdController.getId();
         access = false; 
         
    }
     /*Inner class to set the parameters. */   
    public class WrapperLabelClass{
        private  string pagename; 
        private string enterpriseid;
        private string opportunityid;
        private Boolean IsDealEditableForUser,IsOpportunityCheckedOut;
        private Boolean IsDealCustomizable;
        private Boolean whatif;
        private Integer SAPOMID;
        private string OpportunityName;
        private string clientname;
        private Date contractstartdate;
        private Date contractenddate;
        private Date golivedate;
        private string OG;
        private string Salesgeography;
        private List<String> Offerings;
        private List<String> CountriesInScope;
        
        /* Constructor for the wrapper class */
        public WrapperLabelClass(String emailID,Boolean access,Scratchpad_Opportunity__c scPad){
             
            pageName = UtilConstants.DEAL;
            enterpriseId = emailId.split(UtilConstants.AT_THE_RATE_OF)[0];
            if(enterpriseId.contains('=')){
                enterpriseId = enterpriseid.split('=')[0];
            }
            opportunityId = scPad.Id;
            isDealEditableForUser = access;
            IsOpportunityCheckedOut = access;
            isDealCustomizable = true;
            whatIf = true;
            opportunityName = scPad.name;
            clientName = scPad.Client__r.name;
            contractStartDate = scPad.Contract_Start__c;
            contractEndDate = scPad.Contract_End__c;
            goLiveDate = scPad.Initial_Go_Live__c;
            OG = scPad.Operating_Group__r.Name;
           SalesGeography = scPad.Geo_Region__r.Name;
            countriesInScope = new List<String>{scPad.Country__c.replace(UtilConstants.SEMICOLON_STRING,UtilConstants.COMMA_STRING)};
            Offerings = new List<String>{scPad.Offering__c.replace(UtilConstants.SEMICOLON_STRING,UtilConstants.COMMA_STRING),UtilConstants.BSS,UtilConstants.CROSS,UtilConstants.PMO,UtilConstants.TECHNOLOGY};
            
        }
     }
     /* Wrapper class to get the JSON object */
     without sharing Class Canvas_Container{  
        WrapperLabelClass Canvas_request;
        /* Constructor of wrapper class */
        public Canvas_Container(String emailID,Boolean access,Scratchpad_Opportunity__c scPad){
            Canvas_request = new WrapperLabelClass(emailId,access,scPad);
        } 
     }
     /* Method called from page to pass parameters to the BPOSE as JSON Object */
     public String getgenerateJSONContent() {
        try{
         scPad= [Select Id,name,client__c,client__r.Name,country__c,Operating_Group__c,Operating_Group__r.Name,Geo_Region__r.Name,Contract_Start__c,Contract_End__c,Offering__c,Initial_Go_Live__c,ownerId from Scratchpad_Opportunity__c where ID =:spId limit 1];
         system.debug('*********'+scPad);
         //opportunity = [Select Id,Name,sap_om_id__c,Account.name,Contract_Start_Date__c,Contract_End_Date__c,Initial_Go_live_Date__c,OperatingGroup__r.name,Geo_Area__c,Fast_Track_Component__c,( Select Id,Name,Solution_Component__c,Offering_Master__r.name from Solution_Components__r ) from Opportunity where Id=:scPad.client__c limit 1];
         
         emailID = [Select Email__c From User_Master__c where user__c=:UserInfo.getUserId() limit 1].email__c;
         Id userId = UserInfo.getUserId();
        // access= [Select OpportunityAccessLevel from opportunityshare where OpportunityId=:opportunity.Id limit 1].OpportunityAccessLevel;
        Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
        if( UserInfo.getUserId()==scPad.ownerId || p.name.equalsignorecase(UtilConstants.SYSTEM_ADMIN)||p.name.equalsignorecase(UtilConstants.WORKBENCH_OPERATOR)){
            access=true;
        }
        /* if( p.name.equalsignorecase(UtilConstants.SYSTEM_ADMIN)||p.name.equalsignorecase(UtilConstants.WORKBENCH_OPERATOR)){
             access = true;
          }
         if(!access){
             Set<Id> userMasterSet = new Set<Id>();
             for( Opportunity_Teams__c oppTeam : opportunity.Opportunity_Team__r ){
                 userMasterSet.add( oppTeam.Opportunity_Team_Member__c );
             }
            for( User_Master__c userMaster : [Select Id,Name,User__c from User_Master__c] ){
                 if(userMasterSet.contains( userMaster.Id )){
                     if( userId.equals( userMaster.User__c ) ){
                         access = true;
                         break;
                     }
                 }
             }
         }*/
       Canvas_Container cc = new Canvas_Container(emailId,access,scPad);        
        paramList = JSON.serialize(cc);
        
       // paramList = '{"Canvas_request":{"whatif":false,"SAPOMID":null,"Salesgeography":"Asia Pacific","pagename":"deal","OpportunityName":"Test_NainaAT","opportunityid":"a09j0000002zrP8AAI","OG":"Finance Services","Offerings":["Finance and Accounting","Health Administration","BST","Cross","Technology","PMO"],"IsDealEditableForUser":true,"IsDealCustomizable":true,"IsAdmin":true,"golivedate":"2016-06-01","enterpriseid":"naina.sehgal","CountriesInScope":["Australia","Hungary","India","Indonesia"],"contractstartdate":"2015-06-01","contractenddate":"2020-06-30","clientname":"ATTest"}}';
        system.debug('____________'+paramList );
        return JSON.serialize(cc);
        }catch( Exception E ){
          return null;
        }
    }
}