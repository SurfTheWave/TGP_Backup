trigger updateSectionOnWPVJourneyPlanning on Journey_Management__c (after update) 
{
        Mob_CascadeJourneyMasterChanges.CascadeJourneyMasterChangesOnUpdate(Trigger.old,Trigger.new);      
}