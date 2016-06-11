/*
Author : Shridhar Patankar
Story  : Story-0044/SOL_011  
Description : Controller for riskButtonNew page.Added for Button Go to Risk.Display logic for Risk. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public with sharing class RiskButtonController {
 public Opportunity_Offering__c oppOffering {get;set;}
 public Risk__c newRisk {get;set;}
 public String offId{get;set;}
 public List<Opportunity_Offering__c> oppOff = new List<Opportunity_Offering__c>();
 public List<Risk__c> risk =new List<Risk__c>();
 public List<Risk_Master__c> listRiskMaster = new List<Risk_Master__c>();
 public Integer sizeOfList{get;set;}         
  /******************************
    Method Name: RiskButtonController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public RiskButtonController(ApexPages.StandardController controller) {
      offId=ApexPages.CurrentPage().getParameters().get('id');//Get Current Page Offering id.
    //Check for Null offId.Start     
       if(offId==null)
       {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
       }
    //End      
    }
  /******************************
    Method Name: getRisk
    Description: Navigate to Page riskInline
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference getRisk(){
      if(offId!=null)
      {
            //Query to get Offerings related to current id.
            oppOff =[Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
               if(oppOff.Size()>0){
                    //Query to get list of Risk
                    List<Risk__c> listRisk = [Select Category__c,Risk__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                             Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Risk_Master__r.Risks__c,Opportunity_Offering__r.Name 
                                             from Risk__c where Opportunity_Offering__c = : offId ORDER BY CreatedDate DESC];
                   sizeOfList=listRisk.size();
                   
                   //Query to get list of Risk Master.
                   listRiskMaster = [Select Category__c,Risks__c,id,Offering_Master__r.name,Service_Master__r.Name ,Name,Active_Inactive__c 
                                            from Risk_Master__c where Active_Inactive__c= :true and (Offering_Master__r.name =:oppOff[0].Offering_Master__r.Name 
                                            OR Offering_Master__r.name =:'')
                                            ORDER BY CreatedDate DESC];
           
                       if(listRiskMaster.size()>0){
                              //Itirate through List of Risk Master
                              for(Risk_Master__c temp : listRiskMaster ){
                                  newRisk = new Risk__c();
                                  newRisk.Category__c = temp.Category__c;
                                  newRisk.Risk__c=temp.Risks__c;
                                  newRisk.Risk_Master__c =temp.id;                    
                                  newRisk.Opportunity_Offering__c=offId;
                                  newRisk.Click_Here__c ='Click here';
                                  newRisk.Services_per_Offering__c = temp.Service_Master__r.Name;
                                  newRisk.Applicable__c= oppOff[0].Active__c ;
                                  risk.add(newRisk);
                              }
                                  if(risk.Size()>0 && sizeOfList==0){
                                          upsert risk;
                                  }
                       }    
                            PageReference pg=new PageReference('/apex/riskInline?id='+offId);
                            pg.SetRedirect(true);
                            return pg;
      }
     }
      return null;    
    }
 
}