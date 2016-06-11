/*
Author : Shridhar Patankar
Story :  Feedback Rel 2
Description : Trigger on Services to add assumptions from assumption master only related to services added in services delivery model.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
trigger ServiceForAssumptions on Services__c (after Delete) {
    List<Assumption_Master__c> listAssumptionMaster = new List<Assumption_Master__c>();   
    List<Opportunity_Offering__c> oppOff = new List<Opportunity_Offering__c>(); 
    List<Opportunity_TGP__c> oppTGP = new List<Opportunity_TGP__c>();
    List<Assumption__c> assume =new List<Assumption__c>();
    List<Services__c > lstoldServices= Trigger.old;
    List<Services__c > lstNewServices= Trigger.new;
    oppTGP = [Select id,name from Opportunity_TGP__c]; 
    List<ID> bpoOpptyIds = new List<ID>();
    for(Services__c servi : Trigger.old)
    {
      bpoOpptyIds.add(servi.Opportunity_Offering__c);
    }
     
     oppOff = [Select Id,Name,Offering_Master__r.Name,Opportunity_TGP__c,Active__c from Opportunity_Offering__c where id in:bpoOpptyIds];
     Set<String> ServiceStr = new Set<String>();
     for(Services__c ser : Trigger.old)
     {
         ServiceStr.add(ser.name);
     }
     if(Trigger.isDelete)
    {
        List<Assumption__c > listAssumption = [Select Category__c,Assumption__c,Category_Master__c,Category_Master__r.Name,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                            Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,
                                            Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c = :oppOff[0].id and Services_per_Offering__c in :ServiceStr 
                                            ORDER BY CreatedDate DESC ];    
        
        delete  listAssumption;
        
        List<Client_Dependency__c> listClientDependency = [Select Category__c,Client_Dependency__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c, Category_Master__c, 
                                                               Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Client_Dependency_Master__r.Client_Dependency__c ,Opportunity_Offering__r.Name 
                                                               from Client_Dependency__c where Opportunity_Offering__c = : oppOff[0].id and Services_per_Offering__c in :ServiceStr  ORDER BY CreatedDate DESC ];
        
        delete  listClientDependency ;
        
        List<Risk__c> listRisk = [Select Category__c,Risk__c,Classification__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                             Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Risk_Master__r.Risks__c,Opportunity_Offering__r.Name, Category_Master__c 
                                             from Risk__c where Opportunity_Offering__c = : oppOff[0].id and Services_per_Offering__c in :ServiceStr  ORDER BY CreatedDate DESC];
        
        delete  listRisk ;
        
    }
    
}