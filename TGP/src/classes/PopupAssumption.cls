/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Controller for assumptionInline page.Display logic for Assumption. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public class PopupAssumption {
   public String pageid {get;set;}
   public String message {get;set;}
   /******************************
    Method Name: PopupAssumption
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public PopupAssumption(ApexPages.StandardController controller) {
      //Get current page id.
      pageid =ApexPages.CurrentPage().getParameters().get('id');
      if(pageid!=null && pageid!=''){
      List<Assumption_Master__c> assm = [Select Assumption__c from Assumption_Master__c where id = :pageid ];
        if(assm.size()>0){
          message = assm[0].Assumption__c;
        }
      }
      else{
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
      }
    }

}