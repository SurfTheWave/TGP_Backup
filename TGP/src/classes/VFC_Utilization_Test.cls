/*
Author : Harshit Shah
Story  :   SOL_082
Description :Test Class for the VFC_Utilization Controller.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class VFC_Utilization_Test{
    static User testUser; 
    static Review_User_Master__c reviewUserMaster;
    static Client_Master__c  clientName ;
    static Utilization_Date__c utilizationDateCSRecord = new Utilization_Date__c();
    static Utilization_Date__c utilizationDateCSRecord1 = new Utilization_Date__c();
    static Utilization_Date__c utilizationDateCSRecord2 = new Utilization_Date__c();
    static Utilization_Date__c utilizationDateCSRecord3 = new Utilization_Date__c();
    static Utilization_Date__c utilizationDateCSRecord4 = new Utilization_Date__c();
    static Utilization__c utilizationRecord = new Utilization__c();
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
        utilizationRecord.User_Master__c  = reviewUserMaster.Id; 
        utilizationRecord.BPO_Opportunity__c = oppTGP .Id;
        insert utilizationRecord;
    }
    
    
    static testMethod void testApprovalProcessPageController(){   
       Test.starttest();
       setupData();
       System.runAs(testUser) {
           VFC_Utilization VFC_UtilizationInstance = new VFC_Utilization();
           Pagereference p1;
           Pagereference p2;
           p1 = VFC_UtilizationInstance.doSave();
           p2 = VFC_UtilizationInstance.doCancel();
       }
       Test.stoptest();
    }  
}