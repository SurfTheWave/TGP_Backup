/*
  @Author: Aswajit Swain
  @Name: ExceptionClassTest
  @Created Date: 29 June 2015
  @Description:
  @version: 1.0
*/
@isTest
private class ExceptionClassTest{
    
    /*
      @Author: Aswajit Swain
      @Name: testException
      @Created Date: 15 jun 2015
      @Description:
      @version: 1.0
    */
    private static testMethod void testException(){
        User user = UtilNovaUnitTest.getUser();
        insert user;
        system.runAs(user){
           Test.startTest();
           ExceptionClass.logError(UtilConstants.CROSS_CLASSNAME,UtilConstants.CROSS_METHOD2,'dassa','Not matches',UtilConstants.CROSS_APP,UtilConstants.CROSS_MODULE);
           /*Exception ex =new System.QueryException();
           ExceptionClass.logException(UtilConstants.CROSS_CLASSNAME,UtilConstants.CROSS_METHOD1,ex,UtilConstants.CROSS_APP,UtilConstants.CROSS_MODULE);
           System.assertNotEquals(null, ex);
           */
           
           Test.stopTest();
        }
    }
}