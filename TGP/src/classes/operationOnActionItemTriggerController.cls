/**
@Author         : Apoorva Sharma
@name           : operationOnActionItemTriggerController
@CreateDate     : 09 January 2015
@Description    : TriggerHandler Class for triggers on Opportunity Staging object
@Version        : 1.0
*/
public without sharing class operationOnActionItemTriggerController {

/**
    *  @Description        : This method is used to stop a user from deleting the completed Action Item Record
    *  @name               : validateBeforeDelete
    *  @param              : List<Action_Item__c> actionItemList
    *  @return parameter   : void
    */
   /* public static void validateBeforeDelete( List<Action_Item__c> actionItemList ){
        Boolean isCompleted = false;
        for( Action_Item__c actionitem : [Select action_item_status__c,id from Action_Item__c where Id IN : actionItemList limit 100]){
                if( actionitem.action_item_status__c.equals('Completed')){
                    isCompleted = true;
                    actionitem.addError( 'Sorry !! Action items staus is completed.It cannot be deleted.' );
                }
            
        }
    
    }*/
    
    /**
    *  @Description        : This method is used to update the assignedBy with loggedIn User
    *  @name               : assignedByInActionItem
    *  @param              : List<Action_Item__c> actionItemList
    *  @return parameter   : void
    *  @throws exception   : DML Exception
    */
    public static void assignedByInActionItem(List<Action_Item__c> actionItemList){
        
        List<user_master__c> usermaster = [Select id from user_master__c where user__c =: UserInfo.getUserId() limit 1];
        List<Action_Item__c> actionitemToUpdate = new List<Action_Item__c>();
        List<Action_Item__c> actionitem = [Select id, assigned_by__c from Action_Item__c where id in:actionItemList limit 100];
        for(Action_Item__c  act : actionitem){
            act.assigned_by__c = usermaster[0].id;
            actionitemToUpdate.add(act);
        }   
        try{
            //Added if condition before DML execution by Jyotsna
            if( !actionitemToUpdate.isEmpty() ){
                database.update(actionitemToUpdate,false);
            }   
         
        }
        catch(Exception e){
           // String err = e.getMessage();
           throw (e);
        }   
    
    }
    
     /**
    *  @Description        : This method is used to close all the tasks related to Action Items
    *  @name               : actionTaskClose
    *  @param              : List<Action_Item__c> rlist
    *  @return parameter   : void
    *  @throws exception   : DML Exception
    */
    public static void actionTaskClose(List<Action_Item__c> rlist){
        Set<Id> actids = new Set<Id>();
        List<Task> taskstoupdate = new list<Task>();
        for(action_item__c act : [SELECT Id, (SELECT Id, Whatid, status FROM Tasks limit 5000) from action_item__c 
                Where action_item_status__c =: UtilConstants.COMPLETED and Id IN : rlist limit 100]) {
            for(Task t : act.Tasks) {
                t.status= UtilConstants.COMPLETED;
                taskstoupdate.add(t);
            }
        }
        try{
            //Added if condition before DML execution by Jyotsna
            if( !taskstoupdate.isEmpty() ){
                database.update(taskstoupdate,false);
            }   
        }catch(Exception e){
            //String err = e.getMessage();
            throw (e);
        }   
   }
}