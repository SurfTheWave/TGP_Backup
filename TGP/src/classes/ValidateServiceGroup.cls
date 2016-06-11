public class ValidateServiceGroup {
     public string error{get;set;}
     public Costing_Request__c Record;
     public Costing_Request__c costingRequest;
     public integer solScope;
     public boolean displayPopup {get; set;}  
     public ValidateServiceGroup(ApexPages.StandardController controller) {
        costingRequest = (Costing_Request__c)controller.getRecord();      
     }
    public PageReference validateCostingRecord(){
        PageReference pagr;
        BPOSE_Matrix__c matrix;
        string permission;
        String serviceGroup;
        Record=[SELECT Id, Opportunity__c,Opportunity__r.Service_Grp__c,Last_Checked_Out_By_Dev__c,Is_Checked_Out__c
                FROM Costing_Request__c where Id=:costingRequest.id ];
        solScope=[SELECT Count() FROM Solution_scope__c where opportunity__c=:Record.Opportunity__c and solution_component__c=:UtilConstants.SOLCOMP_DELIVERY  limit 500];
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(Record.Opportunity__r.Service_Grp__c == null){
            displayPopup =true;
            error='Opportunity is not Tagged to any service group, Costing can\'t be Done';
            pagr=null;
        }
        else if(Record.Opportunity__r.Service_Grp__c==UtilConstants.IC){
            displayPopup =true;
            error=SWBBPOSEIntegrationConstants.NoCostForIC;
            pagr=null;
        }
        else if(solScope == 0){
            displayPopup =true;
            error=SWBBPOSEIntegrationConstants.NoDeliveryscopes ;
            pagr=null;
        }
        else{
        permission = ProfileMatrix.giveAccessLevel(profileName,Record.Opportunity__r.Service_Grp__c,Record.Opportunity__c,userinfo.getuserid());            
        system.debug('permssion from matrix'+permission);
        //service group check starts here
         if(Record.Opportunity__r.Service_Grp__c != UtilConstants.BPO && Record.Opportunity__r.Service_Grp__c!=UtilConstants.IO){
            system.debug('satisfies condtion');
            if(profilename.contains(UtilConstants.IO) || profilename.contains(UtilConstants.IC) || profilename.contains(SWBBPOSEIntegrationConstants.IS)){
                serviceGroup=UtilConstants.IO;
            }
            else{
                serviceGroup=UtilConstants.BPO;
            }
            if(Record.Opportunity__r.Service_Grp__c==SWBBPOSEIntegrationConstants.IO_IC){
                serviceGroup=UtilConstants.IO;
            }
         }
         else{
            serviceGroup = Record.Opportunity__r.Service_Grp__c;
         } 
         system.debug('service group '+serviceGroup);        
         if(permission != 'N'){
            pagr = new pagereference('/apex/CostingRequestDetail_Page?id='+Record.id+'&SG='+serviceGroup);
         }
         else{
            displayPopup =true;
            error=SWBBPOSEIntegrationConstants.NoAccessToCost ;
            pagr=null;
         } 
         if(Record.Is_Checked_Out__c && Record.Last_Checked_Out_By_Dev__c == userinfo.getuserid()){
            pagr = new pagereference('/apex/Edit_Redirect?id='+record.id+'&SG=' +serviceGroup+'&sfdc.override=1');
        }                
        }
    return pagr;
    }
     public PageReference popUpRedirect(){
         PageReference pg=new PageReference('/'+Record.Opportunity__c);
         return pg;    
     }
}