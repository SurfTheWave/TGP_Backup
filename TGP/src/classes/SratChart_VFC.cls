public without sharing class SratChart_VFC {

    public string sratTrackerId {get;set;}
    List<SRAT_Additional_Tracking_Level_2__c> sratL2records{get;set;}
    
      /**
    * @description       This is the Constructor of SratChart_VFC class.
    * @param             ApexPages.StandardController 
    * @return            NA
    * @throws            NA
    */ 
   public SratChart_VFC(ApexPages.StandardController controller) {
        sratTrackerId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        system.debug('sratTrackerId:'+sratTrackerId);
        
        List<Id> sratIds = new List<Id>();
            List<Id> sratLevel1Ids = new List<Id>();
            List<Id> sratLevel2Ids = new List<Id>();
            
           
        
            Srat_Tracker__c sratTracker = [Select id,name,Active__c,Days_Before_Go_Live__c,Wave__c from Srat_Tracker__c where Id =: sratTrackerId LIMIT 1];
        
                    
           for(Srat_Tracker__c sratList:[Select id,name,Active__c,Days_Before_Go_Live__c,Wave__c from Srat_Tracker__c where Wave__c =: sratTracker.Wave__c AND Active__C=TRUE LIMIT 5000]) {
                sratIds.add(sratList.Id);
            } 
            for(SRAT_Additional_Tracking_Level_1__c sralLevel1: [Select Id,name,SRAT_Tracker__c from SRAT_Additional_Tracking_Level_1__c where SRAT_Tracker__c IN: sratIds]) {
                sratLevel1Ids.add(sralLevel1.Id);
            } 
            for(SRAT_Additional_Tracking_Level_2__c sratLevel2: [Select id,name,SRAT_Additional_Tracking_Level_1__c,Category__c,RAG_Status__c,SRAT_Tracking_Item__c from SRAT_Additional_Tracking_Level_2__c where SRAT_Additional_Tracking_Level_1__c IN: sratLevel1Ids]) {
                sratLevel2Ids.add(sratLevel2.Id);
            }
            
            sratL2records = [Select id,name,SRAT_Additional_Tracking_Level_1__c,Category__c,RAG_Status__c,SRAT_Tracking_Item__c,SRAT_Tracking_Item__r.name from SRAT_Additional_Tracking_Level_2__c where Id IN: sratLevel2Ids];
        //    return sratL2records;
            system.debug('sratL2records :'+sratL2records);
    }
    
    
          
            
    // Return a list of data points for a chart

    public List<Data> getData() {
              
         
            Map<String,Data> data1 = new Map<String,Data>();
            List<Data> Datalst = new List<Data>();
         //   data1.clear();
            Data datatemp;
            for(SRAT_Additional_Tracking_Level_2__c s:sratL2records) {
                
               if(s.Category__c == 'People') {
            //    String sratKey = s.SRAT_Tracking_Item__r.name;
                system.debug('itemname:'+s.SRAT_Tracking_Item__r.name);
                if(data1.containsKey(s.SRAT_Tracking_Item__r.name))  {
                 datatemp = data1.get(s.SRAT_Tracking_Item__r.name);
                
                if(s.RAG_Status__c == 'In Complete, Off Track') {
                    datatemp.offTrack += 1;
                }
                else if(s.RAG_Status__c == 'In Complete, On Track') {
                     datatemp.onTrack += 1;
                }
                else if(s.RAG_Status__c == 'Complete') {
                    datatemp.complete += 1;
                }
                else {
                    datatemp.NA += 1;
                }
             
                data1.put(s.SRAT_Tracking_Item__r.name,datatemp);       
                
                }
                else {
                        datatemp = new Data(s.SRAT_Tracking_Item__r.name,0,0,0,0);
                        if(s.RAG_Status__c == 'In Complete, Off Track') {
                    datatemp.offTrack = 1;
                }
                else if(s.RAG_Status__c == 'In Complete, On Track') {
                     datatemp.onTrack = 1;
                }
                else if(s.RAG_Status__c == 'Complete') {
                    datatemp.complete = 1;
                }
                else {
                    datatemp.NA = 1;
                }
                Datalst.add(datatemp);
                data1.put(s.SRAT_Tracking_Item__r.name,datatemp); 
                
                    }
                    
               }
                              
            }
            
            
            
            system.debug('datatemp:'+datatemp);
            system.debug('data1:'+data1);
           return Datalst;
    }
    
    
    
        public List<Process> getProcess() {
              
         
            Map<String,Process> processMap = new Map<String,Process>();
            List<Process> processLst = new List<Process>();
         //   data1.clear();
            Process ProcessRec;
            for(SRAT_Additional_Tracking_Level_2__c s:sratL2records) {
                
               if(s.Category__c == 'Process') {
            //    String sratKey = s.SRAT_Tracking_Item__r.name;
            //    system.debug('itemname:'+s.SRAT_Tracking_Item__r.name);
                if(processMap.containsKey(s.SRAT_Tracking_Item__r.name))  {
                 ProcessRec = processMap.get(s.SRAT_Tracking_Item__r.name);
                
                if(s.RAG_Status__c == 'In Complete, Off Track') {
                    ProcessRec.offTrack += 1;
                }
                else if(s.RAG_Status__c == 'In Complete, On Track') {
                     ProcessRec.onTrack += 1;
                }
                else if(s.RAG_Status__c == 'Complete') {
                    ProcessRec.complete += 1;
                }
                else {
                    ProcessRec.NA += 1;
                }
             
                processMap.put(s.SRAT_Tracking_Item__r.name,ProcessRec);       
                
                }
                else {
                        ProcessRec = new Process(s.SRAT_Tracking_Item__r.name,0,0,0,0);
                        if(s.RAG_Status__c == 'In Complete, Off Track') {
                    ProcessRec.offTrack = 1;
                }
                else if(s.RAG_Status__c == 'In Complete, On Track') {
                     ProcessRec.onTrack = 1;
                }
                else if(s.RAG_Status__c == 'Complete') {
                    ProcessRec.complete = 1;
                }
                else {
                    ProcessRec.NA = 1;
                }
                processLst.add(ProcessRec);
                processMap.put(s.SRAT_Tracking_Item__r.name,ProcessRec); 
                
                    }
                    
               }
                              
            }
            
            
            
        //    system.debug('datatemp:'+datatemp);
         //   system.debug('data1:'+data1);
           return processLst;
    }
    
    
            public List<Technology> getTechnology() {
              
         
            Map<String,Technology> technologyMap = new Map<String,Technology>();
            List<Technology> technologyLst = new List<Technology>();
         //   data1.clear();
            Technology TechnologyRec;
            for(SRAT_Additional_Tracking_Level_2__c s:sratL2records) {
                
               if(s.Category__c == 'Technology') {
            //    String sratKey = s.SRAT_Tracking_Item__r.name;
            //    system.debug('itemname:'+s.SRAT_Tracking_Item__r.name);
                if(technologyMap.containsKey(s.SRAT_Tracking_Item__r.name))  {
                 TechnologyRec = technologyMap.get(s.SRAT_Tracking_Item__r.name);
                
                if(s.RAG_Status__c == 'In Complete, Off Track') {
                    TechnologyRec.offTrack += 1;
                }
                else if(s.RAG_Status__c == 'In Complete, On Track') {
                     TechnologyRec.onTrack += 1;
                }
                else if(s.RAG_Status__c == 'Complete') {
                    TechnologyRec.complete += 1;
                }
                else {
                    TechnologyRec.NA += 1;
                }
             
                technologyMap.put(s.SRAT_Tracking_Item__r.name,TechnologyRec);       
                
                }
                else {
                        TechnologyRec = new Technology(s.SRAT_Tracking_Item__r.name,0,0,0,0);
                        if(s.RAG_Status__c == 'In Complete, Off Track') {
                    TechnologyRec.offTrack = 1;
                }
                else if(s.RAG_Status__c == 'In Complete, On Track') {
                     TechnologyRec.onTrack = 1;
                }
                else if(s.RAG_Status__c == 'Complete') {
                    TechnologyRec.complete = 1;
                }
                else {
                    TechnologyRec.NA = 1;
                }
                technologyLst.add(TechnologyRec);
                technologyMap.put(s.SRAT_Tracking_Item__r.name,TechnologyRec); 
                
                    }
                    
               }
                              
            }
            
            
            
        //    system.debug('datatemp:'+datatemp);
         //   system.debug('data1:'+data1);
           return technologyLst;
    }
    
    
                public List<Commercial> getCommercial() {
              
         
            Map<String,Commercial> CommercialMap = new Map<String,Commercial>();
            List<Commercial> CommercialLst = new List<Commercial>();
         //   data1.clear();
            Commercial CommercialRec;
            for(SRAT_Additional_Tracking_Level_2__c s:sratL2records) {
                
               if(s.Category__c == 'Commercial') {
            //    String sratKey = s.SRAT_Tracking_Item__r.name;
            //    system.debug('itemname:'+s.SRAT_Tracking_Item__r.name);
                if(CommercialMap.containsKey(s.SRAT_Tracking_Item__r.name))  {
                 CommercialRec = CommercialMap.get(s.SRAT_Tracking_Item__r.name);
                
                if(s.RAG_Status__c == 'In Complete, Off Track') {
                    CommercialRec.offTrack += 1;
                }
                else if(s.RAG_Status__c == 'In Complete, On Track') {
                     CommercialRec.onTrack += 1;
                }
                else if(s.RAG_Status__c == 'Complete') {
                    CommercialRec.complete += 1;
                }
                else {
                    CommercialRec.NA += 1;
                }
             
                CommercialMap.put(s.SRAT_Tracking_Item__r.name,CommercialRec);       
                
                }
                else {
                        CommercialRec = new Commercial(s.SRAT_Tracking_Item__r.name,0,0,0,0);
                        if(s.RAG_Status__c == 'In Complete, Off Track') {
                    CommercialRec.offTrack = 1;
                }
                else if(s.RAG_Status__c == 'In Complete, On Track') {
                     CommercialRec.onTrack = 1;
                }
                else if(s.RAG_Status__c == 'Complete') {
                    CommercialRec.complete = 1;
                }
                else {
                    CommercialRec.NA = 1;
                }
                CommercialLst.add(CommercialRec);
                CommercialMap.put(s.SRAT_Tracking_Item__r.name,CommercialRec); 
                
                    }
                    
               }
                              
            }
            
            
            
        //    system.debug('datatemp:'+datatemp);
         //   system.debug('data1:'+data1);
           return CommercialLst;
    }
    
    // Wrapper class

    public class Data {


        public String name { get; set; }


        public Integer offTrack { get; set; }


        public Integer onTrack { get; set; }


        public Integer complete { get; set; }
          public Integer NA { get; set; }


        public Data(String name, Integer offTrack, Integer onTrack, Integer complete,Integer NA) {


            this.name = name;


            this.offTrack = offTrack;


            this.onTrack = onTrack;


            this.complete = complete;
            this.NA = NA;


        }
        
    }
    
     public class Process {


        public String name { get; set; }


        public Integer offTrack { get; set; }


        public Integer onTrack { get; set; }


        public Integer complete { get; set; }
          public Integer NA { get; set; }


        public Process(String name, Integer offTrack, Integer onTrack, Integer complete,Integer NA) {


            this.name = name;


            this.offTrack = offTrack;


            this.onTrack = onTrack;


            this.complete = complete;
            this.NA = NA;


        }
        
    }
    
    public class Technology {


        public String name { get; set; }


        public Integer offTrack { get; set; }


        public Integer onTrack { get; set; }


        public Integer complete { get; set; }
          public Integer NA { get; set; }


        public Technology(String name, Integer offTrack, Integer onTrack, Integer complete,Integer NA) {


            this.name = name;


            this.offTrack = offTrack;


            this.onTrack = onTrack;


            this.complete = complete;
            this.NA = NA;


        }
        
    }
    
    public class Commercial {


        public String name { get; set; }


        public Integer offTrack { get; set; }


        public Integer onTrack { get; set; }


        public Integer complete { get; set; }
          public Integer NA { get; set; }


        public Commercial(String name, Integer offTrack, Integer onTrack, Integer complete,Integer NA) {


            this.name = name;


            this.offTrack = offTrack;


            this.onTrack = onTrack;


            this.complete = complete;
            this.NA = NA;


        }
        
    }

}