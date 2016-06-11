/**
    @Author     : 
    @name :         RecursiveTriggerHelper_Test
    @CreateDate :   4/7/2015 3:03 AM
    @Description :  Test class for Recursive Trigger Helper page functionality testing
    @Version : 
*/
@isTest
private class RecursiveTriggerHelper_Test{
    private static boolean run = true;  
    /**
      @Author: 
      @Name: RecursiveTriggerHelperTest
      @Created Date: 01 January 2015
      @Description: instantiating recursive trigger helper for testing
      @version: 1.0
    */       
    static testMethod void RecursiveTriggerHelperTest(){
        Test.startTest();
        RecursiveTriggerHelper triggerHelper = new RecursiveTriggerHelper();
        RecursiveTriggerHelper.runOnce();
        
        Test.stopTest(); 
    }     
}