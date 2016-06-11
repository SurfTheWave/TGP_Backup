/**
       @Author : Devanna
       @name   : ExportOpexChecklistController 
       @CreateDate : 26 Feb 2015 
       @Description : 
       @Version : 1.0 
      */
    public without sharing class ExportOpexChecklistController {
     
      //  public string xmlheader {get;set;}
      //  public string endfile{get;set;}
        public String recordId;
        public String dealName{get;set;}
        public List<Deal_OPEX_Additional_Tracking_Level_1__c> OpexLevel1List{get;set;}
        public List<Deal_OPEX_Additional_Tracking_Level_2__c> opexLevel2List{get;set;}
        public List<Id> lstopexLevel1Ids = new List<Id>();
        public Opex_Tracker__c OpexTracker{get;set;}  
        
        public List<SRAT_Additional_Tracking_Level_1__c> SratLevel1List{get;set;}
        public List<SRAT_Additional_Tracking_Level_1__c> lstSratLevel1 = 
            new List<SRAT_Additional_Tracking_Level_1__c>();
        public List<SRAT_Additional_Tracking_Level_2__c> sratLevel2List{get;set;}
        public List<Id> lstsratLevel1Ids = new List<Id>();
        public Srat_Tracker__c SratTracker{get;set;}  
        
        public String coma {get;set;}
        public String newLine {get;set;}
        
         public String xlsHeader {
             get {    
                 String strHeader = '';
                 strHeader += '<?xml version="1.0"?>';
                 strHeader += '<?mso-application progid="Excel.Sheet"?>';
                 return strHeader;
             }
         }
        /**
        @Method name   : Constructor
        @Description   : Initializing the new string , comma string , recordId.. 
       */ 
        public ExportOpexChecklistController() {
        //    xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
         //   endfile = '</Workbook>';
        coma = UtilConstants.COMMA_STRING;
        newLine = UtilConstants.NEW_LINE;
        recordId=ApexPages.currentPage().getParameters().get(UTILConstants.REC_ID);
        }
       /**
       @Method name   : exportToCSV 
       @Description   : Create the SOQL query using the Custom settings and fetch the Trackers 
        export data from SRAT or OPEX Tracker Object 
      */
       public void exportToCSV() {    
           try{
            
            OpexTracker = [Select Id,Name,Mobilization_Plan__r.deal__r.name from Opex_Tracker__c where Id =: recordId limit 1000]; 
            dealName=OpexTracker.Mobilization_Plan__r.deal__r.name;         
            OpexLevel1List = [Select Id,Name,OPEX_Tracker_del__r.name,Order__c,Stability__c,
                              OPEX_Level_1_Tracking_Type__c,Previous_Stability__c,Assessment_Notes__c,Assessment_Status__c from 
                              Deal_OPEX_Additional_Tracking_Level_1__c where 
                              OPEX_Tracker_del__c =: recordId limit 1000];
            
            for(Deal_OPEX_Additional_Tracking_Level_1__c opexLevel1: OpexLevel1List) {
                lstopexLevel1Ids.add(opexLevel1.Id);
            }            
            opexLevel2List = [Select Id,Name,Answer__c,OPEX_Level_1_Tracking_Type__c,OPEX_Tracker__c,
                              Deal_OPEX_Additional_Tracking_Level_1__c,Question_Description__c from Deal_OPEX_Additional_Tracking_Level_2__c
                              where Deal_OPEX_Additional_Tracking_Level_1__c IN: lstopexLevel1Ids order by OPEX_Level_1_Tracking_Type__c,Order__c limit 1000];
           }catch(Exception e){
               e.getMessage();
           }
         } 
     
       /**
       @Method name   : exportSratLevel1Level2
       @Description   : Create the SOQL query using the Custom settings and fetch 
        the Trackers export data from related tracker Object 
      */                 
      public void exportSratLevel1Level2() { 
        try{
            
             SratTracker = [Select Id,Name,Mobilization_Plan__r.deal__r.name from Srat_Tracker__c where Id =: recordId limit 1000];  
            dealName=SratTracker.Mobilization_Plan__r.deal__r.name; 
             SratLevel1List = [Select Id,Name,SRAT_Tracker__c,SRAT_Level_1_Tracking_Type__c,
                               Question__c,Overall_RAG_Status__c,Comments__c from 
                               SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c =: recordId limit 1000];
             for(SRAT_Additional_Tracking_Level_1__c sratLevel1: SratLevel1List) {
                 lstsratLevel1Ids.add(sratLevel1.Id);
              }
                sratLevel2List = [Select Id,Name,SRAT_Additional_Tracking_Level_1__c,SRAT_Level_1_Tracking_Type__c,
                                  Section__c,Question__c,Category__c,RAG_Status__c,Comments__c 
                                  from SRAT_Additional_Tracking_Level_2__c where 
                                  SRAT_Additional_Tracking_Level_1__c IN: lstsratLevel1Ids limit 1000];
            }catch(DMLException e)
             {
               e.getmessage();
             }                     
          }
    }