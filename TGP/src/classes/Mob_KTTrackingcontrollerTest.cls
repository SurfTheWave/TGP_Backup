/*
Author : Vinay Kumar Chada
Story  :   MOB_045
Description : Test Class for Mob_KTTrackingcontrollerTest. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_KTTrackingcontrollerTest{

static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
static Offerings_Master__c offering;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;
static Wave_Planning__c waveplan;
static Wave_Process__c WaveProcess;
static Deal_Location__c dealLoc;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;

static Commercial_Planning__c comPlan;
static Document newDocument;
static MOB_User_Role_Assignment__c mobUserRoleAssignment; 
static	User uAdm;
public static void setupData(){
// To create a Client Geo

	clientGeo = new Client_Geo_Area_Master__c();
	clientGeo.Client_Geo_Area_Description__c='TestData';
	database.insert(clientGeo);

// To create a Delivery Location Master
	deliveryLocMa =new Delievery_Location_Master__c();
	deliveryLocMa.Delivery_Location_Description__c='testdata';
	deliveryLocMa.Name='TestData';
	deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
	insert deliveryLocMa;

// To create a Deal
	deal =new Deal_TGP__c();
	deal.Name='Test Data';
	database.insert(deal);

// To create a offering
	offering =new Offerings_Master__c();
	offering.Name='Test Data';
	database.insert(offering);

//To create a Wave Plan Version
	wavePlanVersion =new Wave_Plan_Version__c();
	wavePlanVersion.Display_tracking_message__c=null;
	wavePlanVersion.Deal__c=deal.id;
	wavePlanVersion.active__c = true;
	database.insert(wavePlanVersion);

// To create a Deal Home Location
	dealHome =new Deal_Home_Location__c(); 
	dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
	dealHome.Deal__c= deal.id;
	database.insert(dealHome);


// To create a Deal Location
	dealLoc= new Deal_Location__c();
	dealLoc.Location__c='test Data';
	dealLoc.Deal_Home_Location__c=dealHome.id;
	dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
	database.insert(dealLoc);

// To Create Client Specific Process Mapping

	clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
	clientSpecificProcessMapping.Name='TestData';
	clientSpecificProcessMapping.Deal__c=deal.id;
	clientSpecificProcessMapping.Offering__c=offering.id;
	database.insert(clientSpecificProcessMapping);

//To create a Wave Plan

	waveplan =new Wave_Planning__c();
	waveplan.Wave_Comment__c='test data';
	waveplan.Wave_Label__c='TestData';
	waveplan.GO_Live_Date_del__c=date.today()+7;
	waveplan.Deal_Location__c=dealLoc.id;
	waveplan.Number_of_Projected_FTEs__c=1;
	database.insert(waveplan); 
	
	waveplan.Wave_Comment__c='test data2';
	database.update(waveplan);

// To create a Wave Process

	WaveProcess =new Wave_Process__c();
	WaveProcess.Wave_Planning__c=waveplan.id;
	WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
	database.insert(WaveProcess);




// To Create Commercial Planning
	comPlan = new Commercial_Planning__c();
	comPlan.Name='TestData';
	comPlan.Activity__c='TestData';
	comPlan.Delivery_Location__c=deliveryLocMa.id;
	comPlan.Planned_Start_Date__c=date.today();
	comPlan.Planned_End_Date__c=date.today()+7;
	database.insert(comPlan);

	Mob_User_Roles_Master__c mobUserRoleMaster=new Mob_User_Roles_Master__c();
	mobUserRoleMaster.Role_Name__c='Governance Lead';
	database.insert(mobUserRoleMaster);
	
// To Create Review User Master	
	Review_User_Master__c reviewUserMaster=new Review_User_Master__c();
	reviewUserMaster.First_Name__c='Test';
	reviewUserMaster.Last_Name__c='User';
	reviewUserMaster.Is_Active__c=true;
	reviewUserMaster.isUserActive__c=true;
	reviewUserMaster.SFDC_User__c=Userinfo.getUserId();
	database.insert(reviewUserMaster);
	
	
//To create MobUserRoleAssignment
	mobUserRoleAssignment=new MOB_User_Role_Assignment__c();
	mobUserRoleAssignment.Deal__c=deal.id;
	mobUserRoleAssignment.Mob_User_Roles_Master__c=mobUserRoleMaster.Id;
	mobUserRoleAssignment.Access_Level__c='edit';
	mobUserRoleAssignment.Role_Name__c='Program Control PMO';
	mobUserRoleAssignment.User_Assigned_New__c=reviewUserMaster.id;
	database.insert(mobUserRoleAssignment);
	//To Create Deal PMO
	MOB_User_Role_Assignment__c mobUserRoleAssignment1=new MOB_User_Role_Assignment__c();
	mobUserRoleAssignment1.Deal__c=deal.id;
	mobUserRoleAssignment1.Mob_User_Roles_Master__c=mobUserRoleMaster.Id;
	mobUserRoleAssignment1.Access_Level__c='edit';
	mobUserRoleAssignment1.Role_Name__c='Deal PMO';
	mobUserRoleAssignment1.User_Assigned_New__c=reviewUserMaster.id;
	database.insert(mobUserRoleAssignment1);
	//To Create Deal PMO
	MOB_User_Role_Assignment__c mobUserRoleAssignment2=new MOB_User_Role_Assignment__c();
	mobUserRoleAssignment2.Deal__c=deal.id;
	mobUserRoleAssignment2.Mob_User_Roles_Master__c=mobUserRoleMaster.Id;
	mobUserRoleAssignment2.Access_Level__c='edit';
	mobUserRoleAssignment2.Role_Name__c='Global Mobilization Lead';
	mobUserRoleAssignment2.User_Assigned_New__c=reviewUserMaster.id;
	database.insert(mobUserRoleAssignment2);
	

// To Create a Document
	newDocument = new Document();
	newDocument.name='KT Tracker-V1.2.1';
	newDocument.type='Text';
	String myString = 'StringToBlob';
	Blob myBlob = Blob.valueof(myString);
	newDocument.body=myBlob;
	newDocument.Description='Doc Description';
	newDocument.IsPublic=true;
	newDocument.AuthorId=UserInfo.getUserId();//'005L0000000Ucu8';
	newDocument.FolderId=UserInfo.getUserId();//'00lL0000000bSUa';
	database.insert(newDocument);
	PageReference pg = Page.KTTrackerUpDown; 
	Test.setCurrentPage(pg); 
	ApexPages.currentPage().getParameters().put('id', null);

}


static void CreateProfile(){
	uAdm =new User();
	String alias='test1';
	String lastName='RuningUSER';
	Profile userProfileObj = [select id from profile where name=:'Solution Admin' limit 1];
	uAdm = new User(alias =alias, email=alias+'@test.com',
	emailencodingkey='UTF-8', lastname=lastName, languagelocalekey='en_US', profileid = userProfileObj.Id, 
	TimeZoneSidKey='Europe/Prague',LocaleSidKey='en_US',username=lastName+'@test.com');
	Database.insert(uAdm);

	
      
}

 static testMethod void test1(){
	test.starttest();
	setupData();
	ApexPages.StandardController controller;
	apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
	Mob_KTTrackingcontroller obj = new Mob_KTTrackingcontroller( controller);
	obj.waveid=waveplan.id;
	obj.goToKTTrack();
	test.stoptest();
    
 }  
 
 
 static testMethod void test2(){
 	CreateProfile();
	test.starttest();
    System.runAs(uAdm)
    {   
		setupData();
		ApexPages.StandardController controller;
		apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
		Mob_KTTrackingcontroller obj = new Mob_KTTrackingcontroller( controller);
		obj.waveid=waveplan.id;
		obj.goToKTTrack();

    }
    test.stoptest();
 } 
 
  
}