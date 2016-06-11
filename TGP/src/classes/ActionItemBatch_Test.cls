/******************************
   @Author       : 
   @Class name   : ActionItemBatch_Test 
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
@isTest
public class ActionItemBatch_Test {

    /******************************
     * Method Name: test1
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
    static testmethod void test1() {

    Test.startTest();
     //Test Data for Batch
     Id I = UserInfo.getUserId();
      //   List<Task> lstTask = new List<Task>();  
      
       List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',1);
       oppList[0].Active__c = true ;
       Update oppList[0];
       
       Approval_stage__c ApprovalStage = new Approval_stage__c();
            ApprovalStage.opportunity__c = oppList[0].id;
            ApprovalStage.Service_Group__c = 'BPO';
            ApprovalStage.approval_stage_type__c = utilConstants.FLY_BY_SOL_REVIEW;
            ApprovalStage.approval_stage_status__c = 'Pending';
            Insert ApprovalStage;
        
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        UserMasterRef0.user__c = I ;
        Insert UserMasterRef0;
        
        Action_Item__c AI = new Action_Item__c();
        AI.Primary_Owner__c = UserMasterRef0.Id;
        AI.action__c = 'Description test class';
        AI.due_date__c = System.today() + 5 ;
        AI.approval_stage__c = ApprovalStage.Id ;
       AI.Primary_Owner__c = UserMasterRef0.Id;
       Insert AI ;
    action_itemsbatchscript CheckBatch1 = new action_itemsbatchscript();
    ID batchprocessid1 = Database.executeBatch(CheckBatch1);
    
    Test.StopTest();
    }
  

}