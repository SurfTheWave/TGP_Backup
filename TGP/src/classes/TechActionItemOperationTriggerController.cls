/**
@Author         : Rishabh Agrawal
@name           : TechActionItemOperationTriggerController 
@CreateDate     : 11 November 2015
@Description    : TriggerHandler Class for triggers on Opportunity Staging object
@Version        : 1.0
*/
public without sharing class TechActionItemOperationTriggerController {


    /**
    *  @Description        : This method is used to update the assignedBy with loggedIn User
    *  @name               : assignedByInActionItem
    *  @param              : List<Tech_Action_Items__c> actionItemList
    *  @return parameter   : void
    *  @throws exception   : DML Exception
    */
    public static void assignedByInActionItem(List<Tech_Action_Items__c> actionItemList){
        
        List<user_master__c> usermaster = [Select id from user_master__c where user__c =: UserInfo.getUserId() limit 1];
        List<Tech_Action_Items__c> actionitemToUpdate = new List<Tech_Action_Items__c>();
        List<Tech_Action_Items__c> actionitem = [Select id, assigned_by__c from Tech_Action_Items__c where id in:actionItemList limit 100];
        for(Tech_Action_Items__c act : actionitem){
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
    *  @param              : List<Tech_Action_Items__c> rlist
    *  @return parameter   : void
    *  @throws exception   : DML Exception
    */
    public static void actionTaskClose(List<Tech_Action_Items__c> rlist){
        Set<Id> actids = new Set<Id>();
        List<Task> taskstoupdate = new list<Task>();
        for(Tech_Action_Items__c act : [SELECT Id, (SELECT Id, Whatid, status FROM Tasks limit 5000) from Tech_Action_Items__c
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