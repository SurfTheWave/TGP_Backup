/*------------------------------------------
Author-Shridhar Patankar

Description:- To update records on Risk when Risk Master record is changed.

Date:- 08/07/2013
--------------------------------------------*/
trigger UpdateCategoryOnRisk on Risk_Master__c(after update,after delete) {
  List<Risk_Master__c> lstOldRiskMaster= Trigger.old;
  List<Risk_Master__c> lstNewRiskMaster= Trigger.new;
  set<id> lstId = new set<id>();
  if(Trigger.isUpdate)
    {
       for(Risk_Master__c tmpRiskMaster : lstNewRiskMaster)
       {
           lstId.add(tmpRiskMaster.id);
       }
       List<Risk__c> lstRisk = [select id,Category_Master__c,Applicable__c,Opportunity_Offering__c,Risk__c,Classification__c,Services_per_Offering__c,Risk_Master__c from  Risk__c where Risk_Master__c in :lstId];
          for(integer i=0;i<lstNewRiskMaster.size();i++)
          {
             if(lstNewRiskMaster[i].Category_Master__c !=lstOldRiskMaster[i].Category_Master__c)
             {
                for(Risk__c tmpRisk : lstRisk )
                {
                    if(tmpRisk.Risk_Master__c==lstNewRiskMaster[i].id)
                    {
                       tmpRisk.Category_Master__c =lstNewRiskMaster[i].Category_Master__c;
                       tmpRisk.Risk__c=lstNewRiskMaster[i].Risks__c;
                       
                    }
                }
             }
          }
          update lstRisk ;
     }

}