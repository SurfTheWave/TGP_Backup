/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Controller for assumptionButtonInline page.Go to Assumption button for display logic of Assumption. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/


public with sharing class AssumptionButtonController {
  public Opportunity_Offering__c oppOffering {get;set;}
  public String offId{get;set;}
  public List<Assumption_Master__c> listAssumptionMaster{get;set;}
  public Assumption__c newAssumption  {get;set;}
  public List<Assumption__c> assume =new List<Assumption__c>();
  public List<Opportunity_Offering__c> oppOff = new List<Opportunity_Offering__c>(); 
  public Integer sizeOfList{get;set;}                  
    /******************************
    Method Name: AssumptionButtonController 
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public AssumptionButtonController (ApexPages.StandardController controller){
       //Get current page id.
       offId=ApexPages.CurrentPage().getParameters().get('id'); 
       //Check for Null offId.Start     
           if(offId==null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
          }
    }    
    /******************************
    Method Name: getAssumption
    Description: Navigate to Page assumptionInline
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference getAssumption(){
    
      if(offId!=null){
          listAssumptionMaster = new List<Assumption_Master__c>();
          oppOff = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
              if(oppOff.Size()>0){
               List<Assumption__c > listAssumption = [Select id,name from Assumption__c where Opportunity_Offering__c = : offId ];
               sizeOfList=listAssumption.size();
                  //Query to get list of Assumption Master.
                  listAssumptionMaster = [Select Category__c,Assumption__c,id,Offering__r.Name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                                          from Assumption_Master__c where Active_Inactive__c= :true 
                                          and (Offering__r.Name =:oppOff[0].Offering_Master__r.Name OR Offering__r.Name =:'')ORDER BY CreatedDate DESC];
                    if(listAssumptionMaster.Size()>0){
                        //Itirate through List of Assumption Master.
                        for(Assumption_Master__c temp : listAssumptionMaster ){
                              newAssumption  = new Assumption__c();
                              newAssumption.Category__c = temp.Category__c;
                              newAssumption.Assumption__c=temp.Assumption__c;
                              newAssumption.Assumption_Master__c=temp.id;                    
                              newAssumption.Opportunity_Offering__c=offId;
                              newAssumption.Click_Here__c ='Click here';
                              newAssumption.Services_per_Offering__c = temp.Services_per_Offering__r.Name;
                              newAssumption.Applicable__c= oppOff[0].Active__c ;
                              assume.add(newAssumption);
                         }
                              if(assume.Size()>0 && sizeOfList==0){
                                      upsert assume;
                              }
                PageReference pg=new PageReference('/apex/assumptionInline?id='+offId);
                pg.SetRedirect(true);
                return pg;
         
                   }
             }    
      } 
      return null;  
    }
}