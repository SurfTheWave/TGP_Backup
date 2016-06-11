public class deletePopupCost {
     public string error{get;set;}
     public boolean displayPopup {get; set;} 
     public Costing_Request__c Record;
     public Costing_Request__c costingRequest;
     public deletePopupCost(ApexPages.StandardController controller){
        costingRequest = (Costing_Request__c)controller.getRecord();      
     }
     
     public PageReference deleteCostRecord(){
        
        Record=[SELECT Id, Opportunity__c,Opportunity__r.Service_Grp__c,Last_Checked_Out_By_Dev__c,Is_Checked_Out__c
                FROM Costing_Request__c where Id=:costingRequest.id ];
        displayPopup = true;
        error='Cost record can not be deleted.'; 
        return null;
     }
       
     public PageReference popUpRedirect(){
         PageReference pg=new PageReference('/'+Record.Opportunity__c);
         return pg;    
     }
}