/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Controller for riskInline page.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public class PopupRisk {
   public String pageid {get;set;}
   public String message {get;set;}
   /******************************
    Method Name: PopupRisk 
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public PopupRisk (ApexPages.StandardController controller) {
      //Get current page id.
      pageid =ApexPages.CurrentPage().getParameters().get('id'); 
      if(pageid!=null && pageid!=''){
      List<Risk_Master__c> risk = [Select Risks__c from Risk_Master__c where id = :pageid ];
           if(risk.size()>0){
              message = risk [0].Risks__c ;
           }
      }
      else{
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
      }
    }

}