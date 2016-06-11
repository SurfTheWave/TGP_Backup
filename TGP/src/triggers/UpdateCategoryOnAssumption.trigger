/*------------------------------------------
Author-Shridhar Patankar

Description:- To update records on Assumption when Assumption Master record is changed.

Date:- 08/07/2013
--------------------------------------------*/
trigger UpdateCategoryOnAssumption on Assumption_Master__c (after update,after delete) {
  List<Assumption_Master__c > lstOldassumeMaster= Trigger.old;
  List<Assumption_Master__c > lstNewAssumeMaster= Trigger.new;
  set<id> lstId = new set<id>();
  if(Trigger.isUpdate)
    {
       for(Assumption_Master__c tmpassMaster : lstNewAssumeMaster)
       {
           lstId.add(tmpassMaster.id);
       }
       List<Assumption__c> lstassume = [select id,Category_Master__c,Applicable__c,Opportunity_Offering__c,Assumption__c,Classification__c,Services_per_Offering__c,Assumption_Master__c  from  Assumption__c where Assumption_Master__c in :lstId];
          for(integer i=0;i<lstNewAssumeMaster.size();i++)
          {
             if(lstNewAssumeMaster[i].Category_Master__c !=lstOldassumeMaster[i].Category_Master__c)
             {
                for(Assumption__c tmpassume : lstassume)
                {
                    if(tmpassume.Assumption_Master__c ==lstNewAssumeMaster[i].id)
                    {
                       tmpassume.Category_Master__c =lstNewAssumeMaster[i].Category_Master__c;
                       tmpassume.Assumption__c=lstNewAssumeMaster[i].Assumption__c;
                       
                    }
                }
             }
          }
          update lstassume;
     }

}