trigger operationsOnUser on User(after insert, after update) {
    List<Id> idList = new List<Id>();    
    for(User u :Trigger.New) {
        idList.add(u.Id);
    }     
    if(Trigger.isInsert && Trigger.isAfter) {
          UserTriggerController.insertUpdateApprovalUserMaster(idList);
    }
    else If(Trigger.isUpdate && Trigger.isAfter) {
        UserTriggerController.updateApprovalUserMaster(idList);
    }
}