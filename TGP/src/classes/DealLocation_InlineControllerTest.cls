/*
Author : Malkeet Singh
Story  :   
Description : Test Class for DealLocationFacility_InlineController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class DealLocation_InlineControllerTest{
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
	static User testUser;
	static Commercial_Planning__c comPlan;
	static Facility_Master__c FacMaster;
	static Deal_Location_Facility__c dealLocFac;

	public static void setupData(){
		// To create a Client Geo

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
		
		// To create a offering
		offering =new Offerings_Master__c();
		offering.Name='Test Data';
		insert offering;
		
		//To create a Wave Plan Version
		wavePlanVersion =new Wave_Plan_Version__c();
		wavePlanVersion.Display_tracking_message__c='Test Data';
		wavePlanVersion.Deal__c=deal.id;
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
		
		// To Create Client Specific Process Mapping
		
		clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
		clientSpecificProcessMapping.Name='TestData';
		clientSpecificProcessMapping.Deal__c=deal.id;
		clientSpecificProcessMapping.Offering__c=offering.id;
		insert clientSpecificProcessMapping;
		
		//To create a Wave Plan
		
		waveplan =new Wave_Planning__c();
		waveplan.Wave_Comment__c='test data';
		waveplan.Wave_Label__c='TestData';
		waveplan.GO_Live_Date_del__c=date.today()+7;
		waveplan.Deal_Location__c=dealLoc.id;
		waveplan.Number_of_Projected_FTEs__c=1;
		insert waveplan; 
		
		// To create a Wave Process
		
		WaveProcess =new Wave_Process__c();
		WaveProcess.Wave_Planning__c=waveplan.id;
		WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
		WaveProcess.Number_of_Projected_FTEs__c=5;
		insert WaveProcess;
		
		
		
		// To Create Commercial Planning
		comPlan = new Commercial_Planning__c();
		comPlan.Name='TestData';
		comPlan.Activity__c='TestData';
		comPlan.Delivery_Location__c=deliveryLocMa.id;
		comPlan.Planned_Start_Date__c=date.today();
		comPlan.Planned_End_Date__c=date.today()+7;
		insert comPlan;
		
		//To create a Facility Master 
		FacMaster= new Facility_Master__c();
		FacMaster.Name='test';
		FacMaster.Delivery_Location_Master__c=deliveryLocMa.id;
		insert FacMaster;
		
		
		//To create a Deal Location Facility
		dealLocFac=new Deal_Location_Facility__c();
		dealLocFac.Deal_Home_Location__c=dealHome.id;
		dealLocFac.Facility_Master__c=FacMaster.id;
		insert dealLocFac;
	}
	
	public static void setupData1(){
		// To create a Client Geo
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
		deal.Governance_Lead_Name__c=userinfo.getuserid();
		insert deal;
		
		// To create a offering
		offering =new Offerings_Master__c();
		offering.Name='Test Data';
		insert offering;
		
		//To create a Wave Plan Version
		wavePlanVersion =new Wave_Plan_Version__c();
		wavePlanVersion.Display_tracking_message__c='Tracking is on';
		wavePlanVersion.Deal__c=deal.id;
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
		
		// To create a Deal Location
		dealLoc= new Deal_Location__c();
		dealLoc.Location__c='test Data1';
		dealLoc.Deal_Home_Location__c=dealHome.id;
		dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
		insert dealLoc;
		
		// To Create Client Specific Process Mapping
		
		clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
		clientSpecificProcessMapping.Name='TestData';
		clientSpecificProcessMapping.Deal__c=deal.id;
		clientSpecificProcessMapping.Offering__c=offering.id;
		insert clientSpecificProcessMapping;
		
		//To create a Wave Plan
		
		waveplan =new Wave_Planning__c();
		waveplan.Wave_Comment__c='test data';
		waveplan.Wave_Label__c='TestData';
		waveplan.GO_Live_Date_del__c=date.today()+7;
		waveplan.Deal_Location__c=dealLoc.id;
		waveplan.Number_of_Projected_FTEs__c=1;
		insert waveplan; 
		
		// To create a Wave Process
		
		WaveProcess =new Wave_Process__c();
		WaveProcess.Wave_Planning__c=waveplan.id;
		WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
		WaveProcess.Number_of_Projected_FTEs__c=5;
		insert WaveProcess;
		
		
		// To Create Commercial Planning
		comPlan = new Commercial_Planning__c();
		comPlan.Name='TestData';
		comPlan.Activity__c='TestData';
		comPlan.Delivery_Location__c=deliveryLocMa.id;
		comPlan.Planned_Start_Date__c=date.today();
		comPlan.Planned_End_Date__c=date.today()+7;
		insert comPlan;
		
		//To create a Facility Master 
		FacMaster= new Facility_Master__c();
		FacMaster.Name='test';
		FacMaster.Delivery_Location_Master__c=deliveryLocMa.id;
		insert FacMaster;
		
		
		//To create a Deal Location Facility
		dealLocFac=new Deal_Location_Facility__c();
		dealLocFac.Deal_Home_Location__c=dealHome.id;
		dealLocFac.Facility_Master__c=FacMaster.id;
		insert dealLocFac;
	}
	static testMethod void test1(){
		test.starttest();
		Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     	testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     		Database.insert(testUser, false);

		//Run As U1
		System.RunAs(testUser){
			setupData();
			ApexPages.StandardController controller;
			apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
			DealLocation_InlineController obj = new DealLocation_InlineController(controller);
			//obj.getLocationNames();
			obj.locationName=dealHome.id;
			//obj.addLocationDetail();
			obj.initializeDetailRecords();
			//obj.saveLocationDetails();
			obj.refreshLocationPage();
			system.assertEquals(obj.refreshPage, true);
 		}
 
 		test.stoptest();
    
 	} 
 
 	static testMethod void test2(){
		test.starttest();
		Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     	testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     		Database.insert(testUser, false);
		
		//Run As U1
		System.RunAs(testUser){
			setupData1();
			ApexPages.StandardController controller;
			apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
			DealLocation_InlineController obj = new DealLocation_InlineController(controller);
			//obj.getLocationNames();
			//obj.addLocationDetail();
			obj.initializeDetailRecords();
			//obj.saveLocationDetails();
			obj.refreshLocationPage();
			system.assertEquals(obj.refreshPage, true);
 		}
  		test.stoptest();
 	}  
 
 	static testMethod void test3(){
		test.starttest();
		Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
		testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     		Database.insert(testUser, false);
		
		//Run As U1
		System.RunAs(testUser){
			setupData();
			ApexPages.StandardController controller;
			apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
			DealLocation_InlineController obj = new DealLocation_InlineController(controller);
			obj.locationName='test';
			//obj.getLocationNames();
			obj.locationName='None';
			//obj.addLocationDetail();
			obj.initializeDetailRecords();
			//obj.saveLocationDetails();
			obj.refreshLocationPage();
			system.assertEquals(obj.refreshPage, true);
		}
		test.stoptest();
    
 	}  
 }