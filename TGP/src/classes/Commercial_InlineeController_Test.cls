@isTest(SeeAllData=false)
/*
@name : Commercial_InlineeController_Test
@Description : 
@Version : 
*/
private class Commercial_InlineeController_Test {

  private static Commercial_InlineeController ext;
  private static Commercial_Data__c masterObject;
  private static PageReference pref;
  private static User testUser;
/*
@name : init
@Description : 
@Version : 
*/
  private static void init() {
    
    List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',1);
    oppList[0].Active__c = true ;
    Update oppList[0];
    masterObject = new Commercial_Data__c (Name='Test Object 1', Opportunity__c = oppList[0].Id);
    insert masterObject;
    
    pref = Page.Commercial_Vf_Number_of_sdo ;
    pref.getParameters().put('id',masterObject.id);
    Test.setCurrentPage(pref);

    ApexPages.StandardController con = new ApexPages.StandardController(masterObject);
    ext = new Commercial_InlineeController(con);
    
    
  BenchMark_OADM_FTE__c listBPOSEOADM =new BenchMark_OADM_FTE__c(OADM_FTE_Location__c='test',OADM_FTE_Level__c='5-Senior Manager ',OADM_FTEs__c=4);
            
   Database.insert(listBPOSEOADM, false);         
     
    BenchMark_Offering_Service__c listBenchmarkSummary= new BenchMark_Offering_Service__c(Sum_of_Baseline_FTEs__c=3,Opportunity_Offering__c='test',Name='lets test');       
       Database.insert(listBenchmarkSummary, false);
  }
/*
@name : Test1
@Description : 
@Version : 
*/
  static testMethod void Test1() {

    

    Test.startTest();

       init();

    Test.stopTest();

  }

}