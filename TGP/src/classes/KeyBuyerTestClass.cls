@isTest
public class KeyBuyerTestClass {
    public static testMethod void testKeyBuyer(){
        
        Profile p = UTIL_DataCreationForTestClass.getProfile('Standard Platform User'); 
        
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,'test1233435@testorg.com','test1235335@test.net');
        
        Opportunity opp=new Opportunity();
        opp.name=UtilConstants.TEST_OPP;
        opp.Geo_Area__c=UtilConstants.APAC;
        opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
        opp.StageName=UtilConstants.OA;
        opp.Risk_Level__c=UtilConstants.LOW;
        
        opp.CloseDate= date.newInstance(2020, 3, 21);
   		insert opp;
        
        insert testUser;
        
        test.startTest();
        Opportuntiy_Key_Buyer_Temporary_Object__c keyBuyer=new Opportuntiy_Key_Buyer_Temporary_Object__c();
        keyBuyer.name='Test';
        keyBuyer.Category__c='Experience';
        keyBuyer.Importance_to_the_client__c='1';
        keyBuyer.Key_Buyer_Value_Description__c='Test area';
        keyBuyer.Key_Dependencies_Assumptions__c='test';
        keyBuyer.Risk_Level__c='High';
        keyBuyer.Risk_Tier__c=2.0;
        keyBuyer.Success_Measures__c='Test';
        keyBuyer.Solution_Component__c='Test';
        keyBuyer.SAP_OM_ID__c='320731';
        insert keyBuyer;
        
        Opportunity_Key_Buyer__c oppKey=new Opportunity_Key_Buyer__c();
        oppKey.Opportunity__c=opp.id;
        insert oppKey;
        
        test.stopTest();
    }
}