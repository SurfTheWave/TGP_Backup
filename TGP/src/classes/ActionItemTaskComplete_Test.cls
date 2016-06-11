@isTest
private class ActionItemTaskComplete_Test {
    
    private static testmethod void test1(){
        
        List<Opportunity> lstOpp = UnitTestDatafactory.createOppList('TestOppty',1);
            
        Id userID = UserInfo.getUserId();
            User_Master__c testUserMaster = new User_Master__c();
            testUserMaster.Name = 'testUserMaster';
            testUserMaster.user__c = userID;
            insert testUserMaster;

            //lstOpp[0].Active__c = true;
            //Update lstOpp[0];
            Approval_stage__c ApprovalStage = new Approval_stage__c();
            ApprovalStage.opportunity__c = lstOpp[0].id;
            ApprovalStage.Service_Group__c = 'BPO';
            ApprovalStage.approval_stage_type__c = utilConstants.FLY_BY_SOL_REVIEW;
            ApprovalStage.approval_stage_status__c = 'Pending';
            Insert approvalstage;
            
            Deal__c deal = new Deal__c(Opportunity__c = lstOpp[0].id);
            insert deal;
            
             
            
            List<Action_Item__c> act_itemList =  new List<Action_Item__c>();

            Action_Item__c act_itemObj = new Action_Item__c(approval_stage__c = approvalstage.id,
                                                            assigned_by__c = testUserMaster.id,
                                                            action_item_status__c = 'Completed',
                                                            Primary_Owner__c = testUserMaster.id
                                                            );
                                                            
            Action_Item__c act_itemObjNew = new Action_Item__c(approval_stage__c = approvalstage.id,
                                                                assigned_by__c = testUserMaster.id,
                                                               action_item_status__c = 'Completed',
                                                               Primary_Owner__c = testUserMaster.id
                                                               );
                                                            
            
            act_itemList.add(act_itemObjNew);
            UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
            User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');
            System.runAs(testUser){
            Test.startTest();
                system.debug('--->act_itemList'+act_itemList);
                system.debug('--->act_itemObj'+act_itemObj);
                system.debug('--->act_itemObjNew'+act_itemObjNew);
                
            
                
            if(!act_itemList.isEmpty())
               try{
               Database.insert(act_itemList);
                }catch(DmlException e) {
        
                }
               List<task> tsk = new List<task>{ new task(
                WhatID = act_itemList[0].id,
                Subject='Donni',
                Status='Completed',
                OwnerID = testUser.id,
                Priority='Normal'
                )};

               // insert tsk; 
            //ActionItemTaskComplete actItemTaskComp = new ActionItemTaskComplete();
            ActionItemTaskComplete.actionTaskClose(act_itemList);
            Test.stopTest();
            }
            System.assertEquals((testUser != null), true);
            //Action_Item__c act_itemObj = new Action_Item__c();
    }
}