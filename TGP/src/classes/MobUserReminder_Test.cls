@isTest
private class MobUserReminder_Test {

    static testMethod void test1(){
        Test.StartTest();
   
        MobUserReminder mobsch = new MobUserReminder();
  
        String sch = '0 0 23 * * ?'; 
     system.schedule('Test MobUserReminder_Test', sch, mobsch); 
        Test.stopTest();
    
    }

}