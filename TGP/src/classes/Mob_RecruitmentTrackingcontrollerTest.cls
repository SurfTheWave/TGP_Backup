/*
Author : Vinay Kumar Chada
Story  :   MOB_045
Description : Test Class for Mob_RecruitmentTrackingcontroller. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_RecruitmentTrackingcontrollerTest
{
    static Wave_Plan_Version__c wavePlanVersion;
    static Wave_Plan_Version__c wavePlanVersion1;
    static Deal_TGP__c deal;
    static Deal_TGP__c deal1;
    static Wave_Planning__c waveplan;
    static Wave_Planning__c waveplan1;
    static Deal_Location__c dealLoc;
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c deliveryLocMa;
    static Client_Geo_Area_Master__c clientGeo;
    static Document newDocument;
    static Document newDocument1;
    static MOB_User_Role_Assignment__c mobUserRoleAgnmtObj;
    static Mob_User_Roles_Master__c mobUserRoleMasterObj;
    static Recruitment_Tracking__c recTrackingObj;
    static Folder folder;
    
    public static void setupData()
    {
        clientGeo = new Client_Geo_Area_Master__c();
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
        
        // To create a Delivery Location Master
        deliveryLocMa =new Delievery_Location_Master__c();
        deliveryLocMa.Delivery_Location_Description__c='testdata';
        deliveryLocMa.Name='TestData';
        deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
        insert deliveryLocMa;
        
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Tracking is On';
        wavePlanVersion.Deal__c=deal.id;
        wavePlanVersion.Name = 'Test wave plan';
        insert wavePlanVersion;
        
        
        
        // To create a Deal Home Location
        dealHome =new Deal_Home_Location__c(); 
        dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
        dealHome.Deal__c= deal.id;
        insert dealHome;
        
        // To create a Deal Location
        dealLoc= new Deal_Location__c();
        dealLoc.Location__c='test Data';
        dealLoc.Deal_Home_Location__c=dealHome.id;
        dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
        insert dealLoc;
        
        //To create a Wave Plan
        
        waveplan =new Wave_Planning__c();
        waveplan.Wave_Comment__c='test data';
        waveplan.Wave_Label__c='TestData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Deal_Location__c=dealLoc.id;
        waveplan.Mobilization_Recruitment_Lead_Primary__c=UserInfo.getUserId();
        waveplan.Mobilization_Recruitment_Lead_Secondary__c=UserInfo.getUserId();
        waveplan.Number_of_Projected_FTEs__c=1;
        insert waveplan; 
        
        // To Create a Document
        newDocument = new Document();
        newDocument.name='Recruitment Tracker Fields Sequence V0 2';
        newDocument.type='Text';
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        newDocument.body=myBlob;
        newDocument.Description='Doc Description';
        newDocument.IsPublic=true;
        newDocument.AuthorId=UserInfo.getUserId();
        newDocument.FolderId=UserInfo.getUserId();
        insert newDocument;     
    }
    
    public static void setupData1()
    {
    	
    	
        clientGeo = new Client_Geo_Area_Master__c();
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
        
        // To create a Delivery Location Master
        deliveryLocMa =new Delievery_Location_Master__c();
        deliveryLocMa.Delivery_Location_Description__c='testdata';
        deliveryLocMa.Name='TestData';
        deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
        insert deliveryLocMa;
    	
    	// To create a Deal
        deal1 =new Deal_TGP__c();
        deal1.Name='Test deal for mob_recruitmenttracking controller class';
        insert deal1;
        
        //To create a Wave Plan Version
        wavePlanVersion1 =new Wave_Plan_Version__c();
        wavePlanVersion1.Display_tracking_message__c='Tracking is On';
        wavePlanVersion1.Deal__c=deal1.id;
        wavePlanVersion1.Name = 'Test wave plan version for mob_recruitmenttracking controller class';
        insert wavePlanVersion1;
        
         
        // To create a Deal Home Location
        dealHome =new Deal_Home_Location__c(); 
        dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
        dealHome.Deal__c= deal1.id;
        insert dealHome;
        
        // To create a Deal Location
        dealLoc= new Deal_Location__c();
        dealLoc.Location__c='test Data';
        dealLoc.Deal_Home_Location__c=dealHome.id;
        dealLoc.Wave_Plan_Version__c=wavePlanVersion1.id;
        //dealLoc.Wave_Plan_Version__r.deal__r.name='Test deal location for mob_recruitmenttracking controller class';
        //dealLoc.Wave_Plan_Version__r.name = 'Test wave plan version for mob_recruitmenttracking controller class';
        //dealLoc.Location_Name__c = 'test deal location for mob_recruitmenttracking controller class';
        insert dealLoc;	
        
        waveplan1 =new Wave_Planning__c();
        waveplan1.Wave_Comment__c='test data';
        waveplan1.Wave_Label__c='TestData';
        waveplan1.GO_Live_Date_del__c=date.today()+7;
        waveplan1.Deal_Location__c=dealLoc.id;
        waveplan1.Mobilization_Recruitment_Lead_Primary__c=UserInfo.getUserId();
        waveplan1.Mobilization_Recruitment_Lead_Secondary__c=UserInfo.getUserId();
        waveplan1.Number_of_Projected_FTEs__c=1;
        insert waveplan1; 
        
        recTrackingObj = new Recruitment_Tracking__c();
        recTrackingObj.Deal_Location_lk__c=dealLoc.Id;
        recTrackingObj.Wave_Plan_lk__c=waveplan1.Id;
        recTrackingObj.Name = 'test Name';
        recTrackingObj.Activity__c = 'test Activity';
        recTrackingObj.Planned_Start_Date__c =  Date.today();
        recTrackingObj.Planned_End_Date__c = Date.today();
        recTrackingObj.FTE_Number__c = 500;
        recTrackingObj.Active__c = true;
        recTrackingObj.Wave_Plan_Version__c = wavePlanVersion1.id;
        //recTrackingObj = UTIL_DataCreationForTestClass.getRecruitmentTracking(dealLoc.Id, waveplan.Id, 'test Name', 'test Activity', Date.today(), Date.today(), 5);
        insert recTrackingObj;
        
        mobUserRoleMasterObj = UTIL_DataCreationForTestClass.getMobUserRoleMaster('test');
        insert mobUserRoleMasterObj;
        
        mobUserRoleAgnmtObj = UTIL_DataCreationForTestClass.getMobUserRoleAssignment();
        mobUserRoleAgnmtObj.Deal__c = deal1.id;
        mobUserRoleAgnmtObj.Access_Level__c = 'low';
        mobUserRoleAgnmtObj.Mob_User_Roles_Master__c  = mobUserRoleMasterObj.id;
        mobUserRoleAgnmtObj.Role_Name__c = 'test';
        insert mobUserRoleAgnmtObj;
        
        folder = new Folder(name = 'Recruitment Tracker', type = 'Document');
        List<Folder> lstFolder = [Select Id From Folder Where Name = 'Recruitment Tracker' ];
        if(lstFolder.size() > 0)
           {
	        newDocument1 = new Document();
	        newDocument1.name='Recruitment Tracker Fields Sequence V0 2';
	        newDocument1.type='Text';
	        String myString = 'StringToBlob';
	        Blob myBlob = Blob.valueof(myString);
	        newDocument1.body=myBlob;
	        newDocument1.Description='Doc Description';
	        newDocument1.IsPublic=true;
	        newDocument1.AuthorId=UserInfo.getUserId();
	        newDocument1.FolderId=lstFolder.get(0).Id;
	        insert newDocument1;     
           }
    }

    static testMethod void test1()
    {
    	setupData();
        test.starttest();
        
	        ApexPages.StandardController controller;
	        apexpages.currentpage().getparameters().put(UTIL_Constants.URL_PARAMETER_ID ,wavePlanVersion.id); 
	        Mob_RecruitmentTrackingcontroller  obj = new Mob_RecruitmentTrackingcontroller ();
	        //obj.locationId=dealLoc.id;
	        obj.goToRecTrack();
        test.stoptest();    
     }   
     static testMethod void test2()
    {
    	setupData1();
        test.starttest();
        
	        ApexPages.StandardController controller;
	        apexpages.currentpage().getparameters().put(UTIL_Constants.URL_PARAMETER_ID ,wavePlanVersion1.id); 
	        Mob_RecruitmentTrackingcontroller  obj = new Mob_RecruitmentTrackingcontroller ();
	        obj.locationId=dealLoc.id;
	        obj.goToRecTrack();
        test.stoptest();    
     }        
}