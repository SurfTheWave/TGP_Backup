@IsTest
private class Sch_UtilizationDataUpdateSchedulerTest{
    static User testUser; 
    static Review_User_Master__c reviewUserMaster;
    static Client_Master__c  clientName ;
    static Utilization_Date__c utilizationDateCSRecord = new Utilization_Date__c();
    static Utilization_Date__c utilizationDateCSRecord1 = new Utilization_Date__c();
    static Utilization_Date__c utilizationDateCSRecord2 = new Utilization_Date__c();
    static Utilization_Date__c utilizationDateCSRecord3 = new Utilization_Date__c();
    static Utilization_Date__c utilizationDateCSRecord4 = new Utilization_Date__c();
    static Utilization__c utilizationRecord = new Utilization__c();
    static List<Utilization__c> utilizationRecordList = new List<Utilization__c>();  
    static Opportunity_TGP__c oppTGP; 
    
   public static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        reviewUserMaster = UTIL_DataCreationForTestClass.getReviewUserMaster('abc@xyz.com',UTIL_Constants.USER_NAME);
        reviewUserMaster.SFDC_User__c = testUser.Id;
        Database.insert(reviewUserMaster, false);
        clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
        insert clientName;
        utilizationDateCSRecord.Name = 'MondayDate';
        utilizationDateCSRecord.ReferenceDate__c = System.Now();
        utilizationDateCSRecord1.Name = 'MondayDate+1';
        utilizationDateCSRecord1.ReferenceDate__c = System.Now()+7;
        utilizationDateCSRecord2.Name = 'MondayDate+2';
        utilizationDateCSRecord2.ReferenceDate__c = System.Now()+14;
        utilizationDateCSRecord3.Name = 'MondayDate+3';
        utilizationDateCSRecord3.ReferenceDate__c = System.Now()+21;
        utilizationDateCSRecord4.Name = 'MondayDate+4';
        utilizationDateCSRecord4.ReferenceDate__c = System.Now()+28;
        insert utilizationDateCSRecord;
        insert utilizationDateCSRecord1;
        insert utilizationDateCSRecord2;
        insert utilizationDateCSRecord3;
        insert utilizationDateCSRecord4;
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
        insert oppTGP;
        for(Integer i=1; i<10;i++) {
            utilizationRecord = new Utilization__c(); 
            utilizationRecord.User_Master__c  = reviewUserMaster.Id; 
            utilizationRecord.BPO_Opportunity__c = oppTGP .Id;
            utilizationRecord.Current_week__c = i;
            utilizationRecord.Current_week_1__c = i;
            utilizationRecord.Current_week_2__c = i;
            utilizationRecord.Current_week_3__c = i;
            utilizationRecord.Current_week_4__c = i;
            utilizationRecordList.add(utilizationRecord);
        }
        insert utilizationRecordList;
    }
    
    public static testMethod void testController() { 
        Sch_UtilizationDataUpdateScheduler obj = new Sch_UtilizationDataUpdateScheduler(); 
        String sch = '0 0 17 * * ?';
        Id jobId = System.schedule('utilizationDataUploader', sch, obj);
        System.assert(jobId!=null);
    }
    
    public static testMethod void testController1() {
        Test.starttest(); 
        setupData();          
        String QUERY = 'select id, Current_week__c, Current_week_1__c, Current_week_2__c, Current_week_3__c, Current_week_4__c from Utilization__c';
        String QUERY1 = 'select Name, Id, ReferenceDate__c from Utilization_Date__c';
        Id jobId = Database.executeBatch(new Batch_Utilization(QUERY), 10);
        Id jobId1 = Database.executeBatch(new Batch_UtilizationDates(QUERY1), 10);
        Test.stoptest();
    }
}