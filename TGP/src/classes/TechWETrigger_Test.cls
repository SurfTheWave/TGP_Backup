/**
   @Author : 
   @name   : TechWETrigger_Test 
   @CreateDate :  
   @Description : Test class for TechWE Trigger Test  functionality testing
   @Version : 
  */
@isTest
private class TechWETrigger_Test {
/*    
    @Name :         test1
    @Description :  Creating test data with required field for testing 
*/    
    static Testmethod void test1(){
        Test.starttest();
        
        //Creating New Deal 
        Deal__c TestDeal = new Deal__c(Name='Testing Deal');
        insert TestDeal;
        
        //inserting New Plan under Deal
        Mobilization_Plan__c Testmobplan = new Mobilization_Plan__c(Name ='Plan Test', Deal__c = TestDeal.id);
        insert Testmobplan;
                        
        //Inserting new Wave        
        Wave__c TestWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= Testmobplan.id, Planned_Go_Live_Date__c= System.Today()+20);
        insert TestWave;
        
        //Inserting Tech&We tracker
        List<Tech_WE_Tracker__c> techList = new List<Tech_WE_Tracker__c>();
        Tech_WE_Tracker__c TestTech = new Tech_WE_Tracker__c(Name = 'Test Tech and We', Wave__c =TestWave.Id, IsPlanActive__c = True, Planned_Start_Date__c = System.Today(), Planned_End_Date__c=System.Today()+10);
        insert TestTech;
        techList.add(TestTech);
        
         UTILMobClasses utilTest = new UTILMobClasses();
         utilTest.populateMobilizationPlan(techList);
         //delete TestTech;
         //utilTest.checkBeforeDeletingChildREcords(techList);
        
        Test.stoptest();

}
    
}