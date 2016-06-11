/*------------------------------------------
Author-Shridhar Patankar

Description:- To update records on Client Dependency when Client Dependency Master record is changed.

Date:- 08/07/2013
--------------------------------------------*/
trigger UpdateCategoryOnClientDependecy on Client_Dependency_Master__c (after update,after delete) {
  List<Client_Dependency_Master__c> lstOldClientDepMaster= Trigger.old;
  List<Client_Dependency_Master__c> lstNewClientDepMaster= Trigger.new;
  set<id> lstId = new set<id>();
  if(Trigger.isUpdate)
    {
       for(Client_Dependency_Master__c tmpcdMaster : lstNewClientDepMaster)
       {
           lstId.add(tmpcdMaster.id);
       }
       List<Client_Dependency__c> lstclientdep = [select id,Category_Master__c,Applicable__c,Opportunity_Offering__c,Client_Dependency__c,Services_per_Offering__c,Client_Dependency_Master__c from  Client_Dependency__c where Client_Dependency_Master__c in :lstId];
          for(integer i=0;i<lstNewClientDepMaster.size();i++)
          {
             if(lstNewClientDepMaster[i].Category_Master__c !=lstOldClientDepMaster[i].Category_Master__c)
             {
                for(Client_Dependency__c tmpcd : lstclientdep)
                {
                    if(tmpcd.Client_Dependency_Master__c==lstNewClientDepMaster[i].id)
                    {
                       tmpcd.Category_Master__c =lstNewClientDepMaster[i].Category_Master__c;
                       tmpcd.Client_Dependency__c=lstNewClientDepMaster[i].Client_Dependency__c;
                       
                    }
                }
             }
          }
          update lstclientdep;
     }
}