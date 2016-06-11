/*
  @Author: Aswajit Swain
  @Name: HidePermissionServiceTest
  @Created Date: 22 Oct 2015
  @Description:
  @version: 1.0
*/
@isTest
private class HidePermissionServiceTest{
    
    /*
      @Author: Aswajit Swain
      @Name: testGETService
      @Created Date: 22 Oct 2015
      @Description:
      @version: 1.0
    */
    private static testMethod void testGETService(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = System.URL.getSalesforceBaseUrl()+'/services/apexrest/Permission/1.0';  
        req.httpMethod = 'GET';
        req.addParameter('type', 'Solution Report');
        RestContext.request = req;
        RestContext.response = res;
        Boolean isBoll = HidePermissionService.permissionSetService();
        System.assertEquals(isBoll, false);
        
        req.requestURI = System.URL.getSalesforceBaseUrl()+'/services/apexrest/Permission/1.0';  
        req.httpMethod = 'GET';
        req.addParameter('type', 'Opportunity');
        RestContext.request = req;
        RestContext.response = res;
        Boolean isBoll1 = HidePermissionService.permissionSetService();
    }
}