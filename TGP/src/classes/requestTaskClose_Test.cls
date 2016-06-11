/**
 *    TestClassName: requestTaskClose_Test
 *    
 *
 *    @Pranjal
 */
@isTest(SeeAllData=true)
 private class requestTaskClose_Test
 {
   /**
    *   TestMethodName:    test1
    *
    *   Purpose:
    *
    */
      static testMethod void test1() {
      UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
      User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');
      //requestTaskClose req_Obj = new requestTaskClose();
      List<approval_request__c> rlist = new List<approval_request__c>();
      List<Approval_Request__c> approvalRequestList = new List<Approval_Request__c>();
      Map<Id,Approval_Request__c> oldApprovalRequestMap = new Map<Id,Approval_Request__c>();
      List<Approval_Request__c> newApprovalRequestList = new List<Approval_Request__c>();
      Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c();
      Database.insert(OppGrpMaster);
      Opportunity opp_obj = UTIL_DataCreationForTestClass.getOpportunity(OppGrpMaster);//new Opportunity(Name = 'TestOPP', StageName = 'Approval Stage:14', CloseDate = system.today());
      Database.insert(opp_obj);
      User_Master__c userObj1 = new User_Master__c(Name = 'SolTestUser',User__c = userinfo.getUserId(),email__c=userinfo.getuserEmail());
    insert userObj1;
      List<approval_request__c> alist = new List<approval_request__c>();
      Approval_Stage__c app_stageObj = new Approval_Stage__c(approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                                Service_Group__c = utilConstants.BPO,
                                                                opportunity__c = opp_obj.id);
       insert app_stageObj;
      approval_request__c req = new approval_request__c(//approval_stage_type__c= 'Stage 1 - Solution Approval',
                                                        approval_stage__c= app_stageObj.id,
                                                        active__c = true,
                                                        approval_sent_date__c = system.today(),
                                                        //opportunity__c = opp_obj.id,
                                                        Service_Group__c = 'BPO',approver__c=userObj1.id,approval_request_type__c =UtilCOnstants.FIN_APPR,
                                                        approval_request_status__c ='BST Approval',
                                                        Old_SF_ID__c = 'Text');
      req.approval_request_status__c = UtilCOnstants.PEND_WITH_APPR2;
           approval_request__c req1 = new approval_request__c(//approval_stage_type__c= 'Stage 1 - Solution Approval',
                                                        approval_stage__c= app_stageObj.id,
                                                        active__c = true,
                                                        approval_sent_date__c = system.today(),
                                                        Service_Group__c = 'BPO',
                                                        approver__c=userObj1.id,
                                                        //Is_MOM_Submitted__c = 'Yes',
                                                        Old_SF_ID__c = 'Text',approval_request_type__c =UtilCOnstants.FIN_APPR,
                                                        approval_request_status__c =UtilCOnstants.APPRVD);
          approval_request__c req2 = new approval_request__c(//approval_stage_type__c= 'Stage 1 - Solution Approval',
                                                        approval_stage__c= app_stageObj.id,
                                                        active__c = true,
                                                        approval_sent_date__c = system.today(),
                                                        //opportunity__c = opp_obj.id,
                                                        Service_Group__c = 'BPO',approver__c=userObj1.id,
                                                        //Is_MOM_Submitted__c = 'Yes',
                                                        Old_SF_ID__c = 'Text',approval_request_type__c =UtilCOnstants.FIN_APPR,
                                                        approval_request_status__c =UtilCOnstants.APPRVD);
          list<approval_request__c> reqlist = new list<approval_request__c>{req,req1,req2};
              
      System.RunAs(testUser){
          Test.startTest();  
          insert reqlist;
          update reqlist;
          try{
          delete reqlist;
          }
          catch(exception e){
              system.assert(e.getMessage().contains(UtilCOnstants.ERR_MSG2));
          }
          //requestTaskClose.requestTaskClose(rlist);
          /*requestTaskClose.validateBeforeDelete(approvalRequestList);
          requestTaskClose.getApproverRequsetUserMap(approvalRequestList);
          requestTaskClose.validateBeforeEdit(oldApprovalRequestMap,newApprovalRequestList);
          requestTaskClose.sendMail(alist);
          requestTaskClose.sendEmailToApprover(approvalRequestList);*/
          Test.stopTest();
          //System.assertEquals(rlist.isEmpty(), true);
         }
      }
 }