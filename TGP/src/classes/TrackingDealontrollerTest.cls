/*
Author :Varsha Chougule
Story  :   
Description : Test Class for TrackingDealontroller class. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

@isTest(SeeAlldata= true)
private class TrackingDealontrollerTest
{
    static Deal_TGP__c deal;
    static Wave_Plan_Version__c wavePlanVersion;
    
    public static void setupData()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
    }
    
    static testMethod void test1()
    {
        test.starttest();
        setupData();
        TrackingDealontroller obj = new TrackingDealontroller();
        test.stoptest();
    }  
}