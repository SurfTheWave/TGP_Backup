/*
@Author and Created Date : jyotsna yadav,  1/4/2015 11:16 PM 
@name : operationsOnUserTrigger 
@Description : 
@Version : 
*/
trigger operationsOnUserTrigger on User (before insert,before update,after insert,after update) {
    if( trigger.isInsert || trigger.isUpdate){
        
        operationsOnUserTriggerController.checkForDuplicateUser( trigger.new );
    }
    if( trigger.isAfter ){
        if( trigger.isInsert ){
            operationsOnUserTriggerController.insertUpdateUserMaster( trigger.newMap );
        }
        if( trigger.isUpdate ){
            operationsOnUserTriggerController.oldUserMap = trigger.oldMap;
            operationsOnUserTriggerController.insertUpdateUserMaster( trigger.newMap );
        }
    }
    if( trigger.isBefore ){
        if( trigger.isInsert ){
            operationsOnUserTriggerController.validateUserBeforeInsert( trigger.new );
        }
        if(  trigger.isUpdate ){
        List<User> userToUpdate = new List<User>();
            for( User user : trigger.new ){
                if( user.email != trigger.oldMap.get(user.Id).email ){
                    usertoUpdate.add(user);
                }
            }
            if(!userToUpdate.isEmpty()){
                operationsOnUserTriggerController.validateUserBeforeInsert( userToUpdate );
            }
        }
    }
}