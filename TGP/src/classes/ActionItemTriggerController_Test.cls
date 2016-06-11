/*
  @Author: 
  @Name: ActionItemTriggerController_Test
  @Created Date: 01 January 2015
  @Description: This is a test class ActionItemTriggerController_Test for testing the insertion, updation etc. for actionItem.
  @version: 1.0
*/
@isTest
private class ActionItemTriggerController_Test{
     
    private static Approval_Stage__c appStage;
    private static user_master__c userMaster;
/*
  @Author: 
  @Name: setupData
  @Created Date: 01 January 2015
  @Description: This is a test method setupData for testing and data setup.
  @version: 1.0
*/
    public static void setupData(){
    
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         Database.insert(TestOpportunity);
         
        //Opportunity opp = new Opportunity();
        userMaster = new user_master__c(user__c=UserInfo.getUserId(),email__c = 'test@test.com');
        insert userMaster;
        appStage = new Approval_Stage__c(active__c=true,approval_stage_type__c='Fly By - Solution Review',Service_Group__c='BPO',opportunity__c=TestOpportunity.Id);
        insert appStage;
           
        
    }
/*
  @Author: 
  @Name: testInsert
  @Created Date: 01 January 2015
  @Description:This is a test method testInsert for testing the insertion of actionItem.
  @version: 1.0
*/
    private static testMethod void testInsert(){
        setupData();
        Action_Item__c actionItem = new Action_Item__c(approval_stage__c=appStage.Id,Assigned_By__c=userMaster.Id,action_item_status__c='In Progress');
        test.startTest();
        
        insert actionItem;
        test.stopTest();
        
    }
/*
  @Author: 
  @Name: testUpdate
  @Created Date: 01 January 2015
  @Description:This is a test method testUpdate to test the updation of action item.
  @version: 1.0
*/
     private static testMethod void testUpdate(){
        setupData();
        
        Action_Item__c actionItem = new Action_Item__c(Primary_Owner__c=userMaster.Id,approval_stage__c=appStage.Id,Assigned_By__c=userMaster.Id,action_item_status__c='In Progress');
        insert actionItem;
        //system.debug('--actionItem-->'+actionItem);
       // Task task = new Task(WhatId=actionItem.Id,status='Completed',Subject = 'Other',description ='test desc');
        //insert task;
        Action_Item__c actionItem1 = [Select Id,name,action_item_status__c from action_item__c where Id=:actionItem.Id Limit 5000];
        actionItem1.action_item_status__c = 'Completed';
        
        //system.debug('--actionItem1--->'+actionItem1);
        test.startTest();
        update actionItem1;
        test.stopTest();
        
    }
}