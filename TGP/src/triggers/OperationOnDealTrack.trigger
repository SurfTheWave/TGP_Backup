trigger OperationOnDealTrack on Deal_Track__c (after insert, after update) {

	List<Deal_Track__c> lstNewDealTrack = Trigger.new;
    List<Deal_Track__c> lstOldDealTrack = Trigger.old;
	// Create the instance of controller class
    UserAccessUtility uam = new UserAccessUtility();
    if(Trigger.isAfter && Trigger.isInsert) {
        uam.CheckAccessOfDealTrack(lstNewDealTrack);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        uam.CheckAccessOfDealTrackDelete(lstOldDealTrack);   
        uam.CheckAccessOfDealTrack(lstNewDealTrack);
    }
}