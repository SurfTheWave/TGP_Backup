/*
Author :  Accenture IDC
Story  :  Sol_R1.6_1 
Description : Commercial Data Tab.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

public without sharing class  Commercial_InlineeController{
   // public String fields { get; set; }
    public string opportunityId{get;set;}
    public string commercialID{get;set;}
  //  public Commercial_Data__c commecricalObj{get;set;}
    
    public Commercial_Data__c newCommercial{get;set;}
    public list<Commercial_Data__c> newCommercialList{get;set;}
    public BenchMark__c newbenchmark{get;set;}    
   
    public list<BenchMark_OADM_FTE__c> listBPOSEOADM{get; set;}
    public list<BenchMark_Offering_Service__c> listBenchmarkSummary{get; set;}

    public Commercial_InlineeController(ApexPages.StandardController controller) {
    /* 
        * Use this Constructor for the Logic to be executed on Page load.
        * The Standard Controller is Commercial Data. Hence the Id passed as a parameter in the URL will be of Commercial Record and not Opportunity.
        *    
    */

    //system.debug('here i am');
    commercialID=ApexPages.CurrentPage().getParameters().get(UtilConstants.id_par);
    //system.debug('this is me '+commercialID);
    Commercial_InlineeController1();
    
    }

    /******************************
    Method Name: Commercial_InlineController
    Description: Constructor for Commercial_InlineController
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
   public void Commercial_InlineeController1(){
        //system.debug('in method');   
        newCommercialList= new List<Commercial_Data__c>(); 
        newCommercial = new Commercial_Data__c();
        newCommercialList=[select id,Opportunity__c,BenchMark__c from Commercial_Data__c where id=:commercialID limit 1];
        //system.debug('records '+newCommercialList);
        opportunityId=newCommercialList[0].Opportunity__c;        
        listBenchmarkSummary = new List<BenchMark_Offering_Service__c>();
        listBPOSEOADM = new List<BenchMark_OADM_FTE__c>();
      
         
        List<BenchMark__c> benchmarkRecord = new List<BenchMark__c>();
        newbenchmark  =  new BenchMark__c();         
        benchmarkRecord = [select ID,Languages__c,Mobilization_of_TCC__c,Number_of_rebadged_resources_from_client__c,Onshore_Nearshore_Offshore_Split__c,PMO_of_TCC__c FROM BenchMark__c where Opportunity__c =:opportunityId Limit 1];
        //system.debug('!!!!'+benchmarkRecord);
        if(benchmarkRecord.Size() > 0) 
        {
        
            listBPOSEOADM = [select OADM_FTE_Location__c,OADM_FTE_Level__c,OADM_FTEs__c from BenchMark_OADM_FTE__c where BenchMark__c=: benchmarkRecord[0].Id Limit 5000 ];
            newbenchmark =  benchmarkRecord[0];           
        }
        
        if(benchmarkRecord.Size() > 0) 
        {
           
            listBenchmarkSummary = [select Sum_of_Baseline_FTEs__c,Opportunity_Offering__c,Name,Costing_Type__c from BenchMark_Offering_Service__c where BenchMark_Offering__r.BenchMark__c=: benchmarkRecord[0].Id and Costing_Type__c =: UtilConstants.SDO Limit 5000];
        }
        
                           
       }  
     
     
    }