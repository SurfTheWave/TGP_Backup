trigger updateSectionOnWPVContractLegalPlanning on Contract_Legal_Infosec_Section_Master__c (after update,after delete) 
{
        if(Trigger.isUpdate)
        {
            Mob_CascadeContractLegalMasterChanges.CascadeJourneyMasterChangesOnUpdate(Trigger.old,Trigger.new);
        }
        if(Trigger.isDelete)
        {
            Mob_CascadeContractLegalMasterChanges.CascadeJourneyMasterChangesOnDelete(Trigger.old);
        }
}