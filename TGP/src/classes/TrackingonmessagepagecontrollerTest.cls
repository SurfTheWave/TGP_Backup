/*
Author :Varsha Chougule
Story  :   
Description : Test Class for Trackingonmessagepagecontroller class. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

@isTest(SeeAlldata= true)
private class TrackingonmessagepagecontrollerTest
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
        wavePlanVersion.Display_tracking_message__c='Tracking is On';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
    }
    
    static testMethod void test1()
    {
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Trackingonmessagepage;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Trackingonmessagepagecontroller obj = new Trackingonmessagepagecontroller(controller);
        test.stoptest();
    }  
}