trigger prePopulateOPEX on Wave_Process__c (after insert, after update) {
if(Trigger.isInsert==true)
{
    Mob_PrePopulateOPEXGrid.insertInOPEXForProcess(Trigger.new);
}
}