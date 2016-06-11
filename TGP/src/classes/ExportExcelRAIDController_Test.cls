/**
     Author : Madhusudhan 
    Story  : 2.5 CR Export RAID Log to Excel  
    Description : Test Class for ExportRAIDToExcelControllerTest . 

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------

     */
@isTest
private class ExportExcelRAIDController_Test {
    static User testUser;  
    static Deal__c deal ;   
    public static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile('System Administrator');
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        insert testUser;
        String riskRole = userInfo.getUserRoleId();
        // To create a Deal
        deal =new Deal__c();
        deal.Name='Tesing the Deal Data';
        insert deal;
        }
         static testMethod void testExportRiskController(){
              test.starttest();
              setupData();
              PageReference pageRef = Page.ExportAllRAIDExcel_VFP;
              apexpages.currentpage().getparameters().put('id' ,deal.id);
              ExportExcelRAIDController exportRaidLogs = new ExportExcelRAIDController();
              String testo = exportRaidLogs.xlsHeader;
              test.stoptest();  
        }

}