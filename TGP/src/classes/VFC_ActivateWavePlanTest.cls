/*
Author : Rajdeep Bhuiya
Story  : Release 1.7  
Description : Test Class for VFC_ActivateWavePlan. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class VFC_ActivateWavePlanTest{
    static User testUser; 
    static Deal_TGP__c deal;
    static Wave_Plan_Version__c wavePlanVer;
      
    public static void setupData(){
      Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
      testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      Database.insert(testUser, false);
      String uId=testUser.Id;
      uId=uId.substring(0,15);
      deal = new Deal_TGP__c(Name = 'TestDeal',MOB_PMO_Project_ID__c=uId);
      Database.insert(deal,false);
      wavePlanVer=new Wave_Plan_Version__c(Name='new WavePlanVer',Version__c=1,Active__c=false,Display_tracking_message__c='Test Data',Deal__c=deal.Id);      
      Database.insert(wavePlanVer,false);  
      System.debug('deal.Id:::'+deal.Id);
      System.debug('wavePlanVer.Id:::'+wavePlanVer.Id);
    }
    
    static testMethod void testSelectOptionMethods(){
        test.starttest();
        setupData();
        System.runAs(testUser) {
            ApexPages.StandardController controller;
            apexpages.currentpage().getparameters().put('dealId' ,deal.id);
            VFC_ActivateWavePlan activateWavePlanIns=new VFC_ActivateWavePlan(controller);     
            activateWavePlanIns.activateWavePaln();
        }
        test.stoptest(); 
    }
    
}