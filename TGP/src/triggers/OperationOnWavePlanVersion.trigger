/*  
 *  After Insert trigger for Wave_Plan_Version__c . 
 *  @author - Accenture Team 
 *  @date create - 18/2/2014
 *  @version - 0.1 
 */
trigger OperationOnWavePlanVersion on Wave_Plan_Version__c (after insert) {
    WavePlanVersionTriggerController.insertWPVRecordOperation(Trigger.New);
}