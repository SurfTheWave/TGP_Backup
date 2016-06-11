trigger updateDealOcation on Deal_Home_Location__c (after insert, after update) {

if(Trigger.isUpdate == true || Trigger.isInsert == true) {
    if(test.isRunningTest()==false )
        Mob_GoLiveGrid.addLocation(Trigger.New);
}
}