/* Contains code to test following batch classes :
BatchApexGovernanceLead
Batch_UtilizationNew
*/
@IsTest
public class Batch_Test {

/**
    *  @Description        : 
    *  @name               : 
    *  @param              : 
    *  @return parameter   : 
    *  @throws exception   : 
    */
static testmethod void test1() {

    Test.startTest();
     //Test Data for Batch
    List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',1);
    oppList[0].Active__c = true ;
    Update oppList[0];
    SD_Governance_Data__c SD= new SD_Governance_Data__c ();
    SD.Name = 'SD';
    SD.Opportunity__c =  oppList[0].Id ;
    Insert SD; 
    String q1 = 'Select Id,Opportunity__r.SAP_OM_ID__c,Opportunity__r.name,SD_Gov_Lead_Coach__c,Offerings_Scope_SWB__c from SD_Governance_Data__c where id != \'\' limit 1';
    BatchApexGovernanceLead CheckBatch1 = new BatchApexGovernanceLead(q1);
    ID batchprocessid1 = Database.executeBatch(CheckBatch1);
    
    Test.StopTest();
    }
    /**
    *  @Description        : 
    *  @name               : 
    *  @param              : 
    *  @return parameter   : 
    *  @throws exception   : 
    */
    static testmethod void test2() {

    Test.startTest();
     
    String q2 = 'Select Id, Utilizations__c.Current_Week_1__c from Utilizations__c where id != \'\' limit 1';
    Batch_UtilizationNew CheckBatch2 = new Batch_UtilizationNew(q2);
    ID batchprocessid2 = Database.executeBatch(CheckBatch2);
    
    Test.StopTest();
    }

}