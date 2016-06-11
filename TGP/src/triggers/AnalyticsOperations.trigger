trigger AnalyticsOperations on Analytics_Datas__c (before update) {
if(trigger.isBefore && trigger.isUpdate){
    for(Analytics_Datas__c anyRec:trigger.new){
        if(anyRec.active__c==false && UtilConstantsR3.runAnalyticTrigger){
            anyRec.addError('Record is not active.Enable Analytics in Scope from SWB BPO Details section');
        }
    }
}
}