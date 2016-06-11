/**
 *
 *    TriggerName:changeTaskName
 *
 *    Purpose:
 *
 */

trigger changeTaskName on Task(before Insert, after Insert) {
	Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    if(flag){
    if (trigger.isBefore) {
        if (trigger.isinsert) {
            changeTaskName.changeTaskName(Trigger.new);
            //changeTaskName.deltask(Trigger.new);
        }
    }
   }
}