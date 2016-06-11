/*
Author : Shridhar Patankar
Story  : Story-0055/SOL_012  
Description : Controller for clientDependencyButtonNew page.Display logic for Client Dependencies.Button added
              for Go to Client Dependency. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public with sharing class ClientDependencyButtonController {
 public Opportunity_Offering__c oppOffering {get;set;}
 public String offId{get;set;}
 public Client_Dependency__c newClientDependency {get;set;}
 public List<Opportunity_Offering__c> oppOff = new List<Opportunity_Offering__c>();  
 public List<Client_Dependency_Master__c> listClientDependencyMaster = new List<Client_Dependency_Master__c>();
 public List<Client_Dependency__c> clientDependency =new List<Client_Dependency__c>();
 public Integer sizeOfList{get;set;}             
    /******************************
    Method Name: ClientDependencyButtonController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public ClientDependencyButtonController(ApexPages.StandardController controller) {
       offId=ApexPages.CurrentPage().getParameters().get('id');//Get Current Page ID.
    //Check for Null offId.Start     
       if(offId==null)
       {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
       }
    //End      
    }
      /******************************
    Method Name: getClientDependency
    Description: Navigate to Page clientDependencyInline
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference getClientDependency(){
      if(offId!=null){
            //Query to get Offerings related to current id.
            oppOff =[Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
            if(oppOff.Size()>0){
                //Query to get list of Client Dependency
                List<Client_Dependency__c> listClientDependency = [Select Category__c,Client_Dependency__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                                               Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Client_Dependency_Master__r.Client_Dependency__c ,Opportunity_Offering__r.Name 
                                                               from Client_Dependency__c where Opportunity_Offering__c = : offId ORDER BY CreatedDate DESC ];
                sizeOfList=listClientDependency.size();
                //Query to get list of Client Dependency Master
                listClientDependencyMaster = [Select Category__c,Client_Dependency__c,id,Offering__r.name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                                              from Client_Dependency_Master__c where Active_Inactive__c= :true and (Offering__r.name =:oppOff[0].Offering_Master__r.Name 
                                              OR Offering__r.name =:'')ORDER BY CreatedDate DESC];
            
                        if( listClientDependencyMaster.size()>0){
                            //Iterate through List of Client Dependency Master
                            for(Client_Dependency_Master__c temp : listClientDependencyMaster ){
                                      newClientDependency= new Client_Dependency__c();
                                      newClientDependency.Category__c = temp.Category__c;
                                      newClientDependency.Client_Dependency__c=temp.Client_Dependency__c;
                                      newClientDependency.Client_Dependency_Master__c =temp.id;                    
                                      newClientDependency.Opportunity_Offering__c=offId;
                                      newClientDependency.Click_Here__c ='Click here';
                                      newClientDependency.Services_per_Offering__c = temp.Services_per_Offering__r.Name;
                                      newClientDependency.Applicable__c= oppOff[0].Active__c ;
                                      clientDependency.add(newClientDependency);
                                  }
                                      if(clientDependency.Size()>0 && sizeOfList==0){
                                          upsert clientDependency;
                                      }
                            }
                              PageReference pg=new PageReference('/apex/clientDependencyInline?id='+offId);
                              pg.SetRedirect(true);
                              return pg;
                         } 
                }
      return null;   
    }
}