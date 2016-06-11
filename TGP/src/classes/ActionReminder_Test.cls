/*
@name : ActionReminder_Test
@CreateDate : 3/11/2015 8:25 PM
@Description : 
@Version : 
*/
@isTest(seeAllData = false)                     
private class ActionReminder_Test{
/******************
 * @class name : actionReminderTestMethod
  
 * @description :
******************/
    static testMethod void actionReminderTestMethod(){
        UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
        User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');
        System.runAs(testUser){
            Test.startTest();
            UtilConstants uc = new UtilConstants();        
            UtilConstantsforSWB  uswb = new UtilConstantsforSWB();
            UtilEmail ue = new UtilEmail();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            list<String> lstStr = new List<String>();
            //lstStr.add(',');
            //Email_Template__c et = new Email_Template__c(Name = 'test User', ID__c = 'a2Dc0000000E9w9');//This is not actual ID..
            //insert et;            
            Id userID = UserInfo.getUserId();
            User_Master__c testUserMaster = new User_Master__c();
            testUserMaster.Name = 'testUserMaster';
            testUserMaster.user__c = userID;
            insert testUserMaster;
            
            List<Opportunity> lstOpp = UnitTestDatafactory.createOppList('TestOppty',1);
            
            lstOpp[0].Active__c = true;
            Update lstOpp[0];
            Approval_stage__c ApprovalStage = new Approval_stage__c();
            ApprovalStage.opportunity__c = lstOpp[0].id;
            ApprovalStage.Service_Group__c = 'BPO';
            ApprovalStage.approval_stage_type__c = utilConstants.FLY_BY_SOL_REVIEW;
            ApprovalStage.approval_stage_status__c = 'Pending';
            Insert approvalstage;
            
            List<Action_Item__c> lstActionItem = new List<Action_Item__c>();
            Action_Item__c newActItem = new Action_Item__c();
            newActItem.approval_stage__c = approvalStage.Id;
            newActItem.Primary_Owner__c = testUserMaster.Id;
            newActItem.action__c = 'test Action';
            newActItem.due_date__c = Date.newInstance(1960, 2, 17);
            newActItem.action_item_status__c = 'Not Completed'; 
            lstActionItem.add(newActItem);
            insert lstActionItem; 
            for(action_item__c actid :lstActionItem ){
                lstStr.add(actid.id);
            }
            Email_Template__c myET = new Email_Template__c();
            UtilEmail.emailid();
                       
            ActionReminder.sendReminder(lstStr);
           // ActionReminder.sendMail(lstActionItem);
            Test.stopTest();
            System.assertEquals((testUser != null), true);
        }
    }
}