/*
Author :  Varsha Chougule.
Story  :  MOB_132_b 
Description : Test Class for insertNewWavePlanVersionController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class insertNewWavePlanVersionControllerTest
{
    static User testUser; 
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static Mob_User_Roles_Master__c strMoURM; 
    static Deal_Location__c strDealLocation;
    static MOB_User_Role_Assignment__c strMoURA;
    static Wave_Planning__c strWavePlanning;
    
    public static void setupData()
    {
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        deal=new Deal_TGP__c(Name='DealTest123');
        insert deal;
        
        strMoURM=new Mob_User_Roles_Master__c(Access_Level__c='Edit',Role_Name__c='Governance Lead1');
        insert strMoURM;
        
        strMoURA=new MOB_User_Role_Assignment__c(Access_Level__c='Edit',Deal__c=deal.id,User_Assigned__c=testUser.id,Role_Name__c='Governance Lead1',Mob_User_Roles_Master__c=strMoURM.id);
        insert strMoURA;
        
        wavePlanVersion =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=deal.id, Version__c=1, Active__c=false);
        insert wavePlanVersion; 
        
        strDealLocation=new Deal_Location__c(Wave_Plan_Version__c=wavePlanVersion .id);
        insert strDealLocation;
        strWavePlanning=new Wave_Planning__c(Wave_Label__c='waveTest', Number_of_Projected_FTEs__c=1,GO_Live_Date_del__c=System.today()+1, Deal_Location__c=strDealLocation.id);
        insert strWavePlanning;
    }
     public static void setupData1()
    {
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        deal=new Deal_TGP__c(Name='DealTest123');
        insert deal;
        
        strMoURM=new Mob_User_Roles_Master__c(Access_Level__c='Edit',Role_Name__c='Governance Lead1');
        insert strMoURM;
        
        strMoURA=new MOB_User_Role_Assignment__c(Access_Level__c='Edit',Deal__c=deal.id,User_Assigned__c=testUser.id,Role_Name__c='Governance Lead1',Mob_User_Roles_Master__c=strMoURM.id);
        insert strMoURA;
        
        wavePlanVersion =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=deal.id, Version__c=1, Active__c=true);
        insert wavePlanVersion; 
        
        strDealLocation=new Deal_Location__c(Wave_Plan_Version__c=wavePlanVersion .id);
        insert strDealLocation;
        strWavePlanning=new Wave_Planning__c(Wave_Label__c='waveTest', Number_of_Projected_FTEs__c=1,GO_Live_Date_del__c=System.today()+1, Deal_Location__c=strDealLocation.id);
        insert strWavePlanning;
    }
    static testMethod void testinsertNewWavePlanVersionController()
    {
        test.starttest();
        setupData();
        pageReference pageRef= Page.insertNewWavePlanVersion;
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        insertNewWavePlanVersionController obj= new insertNewWavePlanVersionController(controller);
        obj.SaveRecord();
        obj.CancelRecord(); 
     }
     static testMethod void testinsertNewWavePlanVersionController1()
    {
        test.starttest();
        setupData();
        pageReference pageRef= Page.insertNewWavePlanVersion;
        //apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('version' ,'1');
        apexpages.currentpage().getparameters().put('dealId' ,deal.id);
        Wave_Plan_Version__c wavePlanVersionTemp=new Wave_Plan_Version__c();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersionTemp);
        insertNewWavePlanVersionController obj= new insertNewWavePlanVersionController(controller);
        obj.SaveRecord();
        obj.CancelRecord(); 
     } 
     static testMethod void testinsertNewWavePlanVersionController2()
    {
        test.starttest();
        setupData1();
        pageReference pageRef= Page.insertNewWavePlanVersion;
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        insertNewWavePlanVersionController obj= new insertNewWavePlanVersionController(controller);
        obj.newWPV=null;
        obj.SaveRecord();
        obj.CancelRecord(); 
        Test.stopTest();
     } 
}