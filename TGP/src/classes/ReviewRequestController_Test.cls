/*
    @Author     : 
    @name :         BudgetCostExport_Test 
    @CreateDate :   4/7/2015 3:03 AM
    @Description :  Test class for Review request controller functionality testing
    @Version : 
*/
@isTest(seeAllData=false)
private class ReviewRequestController_Test{
    private static Decimal testDecimal = 100;
    private static String testString = 'testString';
    public static Opportunity opp;  
    private String orgWideEmailAddressID=UtilEmail.emailid();
    /*    
    @Name :         test1
    @Description :  Test sample data for Review request controller functionality testing
    */
    static testmethod void test1(){
        List<Review_Request__c> rlist = new List<Review_Request__c>();
        //Review_Request__c revReqObj = new Review_Request__c();
        //Database.insert(revReqObj); 
        User useObj = UtilNovaUnitTest.getUser();
        database.insert(useObj);
        User_Master__c userObj = new User_Master__c(Name = 'TestUser',User__c = useObj.id);
        database.insert(userObj);
        String reviewer=userObj.id;
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        database.insert(ogm);        
        opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        database.insert(opp);
        
        Offering_Name__c offcustomsetting = new Offering_Name__c();
        offcustomsetting.name = UtilConstants.PROCUREMENT;
        offcustomsetting.Name__c = UtilConstants.CUST_OFFERING_NAME;
        database.insert(offcustomsetting);
        offering_master__c offer=new offering_master__c();
        offer.name=UtilConstants.ALL;
        offer.Active__c=true;
        offer.offering_description__c= UtilConstants.ALL;
        offer.flywheel_non_flywheel__c= UtilConstants.FLYWHEEL;        
        database.insert(offer);
        
        //id offid=[select id from offering_master__c  where name ='ALL'].id;
        
        Solution_Scope__c ss= new Solution_Scope__c();
        ss.Opportunity__c=opp.id;
        ss.Offering_Master__c=offer.id;
        ss.Solution_Component__c= UtilConstants.PMO;
        
        try {
            database.insert(ss);            
        } catch (Exception e) { 
            String str = e.getMessage() + e.getStackTraceString();
        }
        Service__c s=new Service__c();
        s.Solutionscope__c=ss.id;
        
        try {
            database.insert(s);
        
        } catch (Exception e) { 
            String str = e.getMessage() + e.getStackTraceString();
        }
    
    
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO);
        database.insert(appObj_stage);
      
        Approval_Request__c appObj = new Approval_Request__c(approval_stage__c=appObj_stage.id,approver__c=userObj.id,
                                                            approval_request_type__c='BST Approval',Service_Group__c = utilConstants.BPO);
        database.insert(appObj);
           
        Review_Request__c review_requestcTest =  new Review_Request__c(Reviewer_Comments__c='test',Reviewer__c = userObj.id,
                                                                    Approval_Request__c = appObj.id,Service__c=s.id);
        list<review_request__c> reqlist_toupdate = new list<review_request__c>();
        rlist.add(review_requestcTest); 
        test.startTest();
        
        database.insert(rlist);
        
        for(Review_Request__c revr:[select id,Review_Completed__c from review_request__c where id IN:rlist limit 50000]){
            revr.Review_Completed__c = true;
            reqlist_toupdate.add(revr);
        }
        database.update(reqlist_toupdate);
        
        test.stopTest();
       /* 
        ReviewRequestController.sendMailToReviewer(rlist);
        ReviewRequestController.sendMailToApprover(rlist);*/
    }
}