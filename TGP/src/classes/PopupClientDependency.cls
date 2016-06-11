/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Controller for ClientDependency page.Display logic for ClientDependency . 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public class PopupClientDependency {
  public String pageid {get;set;}
  public String message {get;set;}
    /******************************
    Method Name: PopupClientDependency 
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public PopupClientDependency (ApexPages.StandardController controller) {
      //Get current page id.
      pageid =ApexPages.CurrentPage().getParameters().get('id'); 
       if(pageid!=null && pageid!=''){
      //Query to fetch Client Dependency Master records.
      List<Client_Dependency_Master__c> client = [Select Client_Dependency__c from Client_Dependency_Master__c where id = :pageid ];
           //Check Size
           if(client.size()>0){
              message = client[0].Client_Dependency__c;
           }
       }
       else{
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
      }
    }
}