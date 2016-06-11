/*
    Author : Muthukumar
    Story  :   
    Description : Test Class for  Mob_PrePopulateSRATGrid

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------
*/
@isTest
private class Mob_PrePopulateSRATGrid_Test {
	static Wave_Planning__c wavePlanningObj;
	static list<Wave_Planning__c> wavePlanningList=new list<Wave_Planning__c>();
	static Wave_Plan_Version__c wavePlanVersion;
	static list<Wave_Process__c> waveProcess=new list<Wave_Process__c>();
	static void setupdata(){
		
	//To Create deal record	
		Deal_TGP__c dealData=new Deal_TGP__c();
		dealData.Opportunity_Name__c='TestOpportunity';
		database.insert(dealData);
		
	//To Create Wave_Plan_Version__c record
		wavePlanVersion=new Wave_Plan_Version__c();
		wavePlanVersion.Version__c=1;
		wavePlanVersion.Deal__c=dealData.Id;
		database.insert(wavePlanVersion);
		
	//To Create Deal_Location__c record
		Deal_Location__c dealLocation= new Deal_Location__c();
		dealLocation.Version__c=1;
		dealLocation.Wave_Plan_Version__c=wavePlanVersion.Id;
		database.insert(dealLocation);
		
	//To Create Wave_Planning__c record	
		wavePlanningObj=new Wave_Planning__c();
		wavePlanningObj.Wave_Label__c='Test Wave';
		wavePlanningObj.GO_Live_Date_del__c=system.today();
		wavePlanningObj.Deal_Location__c=dealLocation.Id;
		database.insert(wavePlanningObj);
		wavePlanningList.add(wavePlanningObj);
	//To Create KT_Planning_Activity_Master__c record
		KT_Planning_Activity_Master__c KTPlaningActivity=new KT_Planning_Activity_Master__c();
		KTPlaningActivity.Name='Test KT Activity';
		KTPlaningActivity.Activity_Order__c=1;
		KTPlaningActivity.Is_Active__c=true;
		database.insert(KTPlaningActivity);
		
   //To Create Recruitment_Tracking__c record
		Recruitment_Tracking__c recruitment=new Recruitment_Tracking__c();
		recruitment.Version__c=1;
		recruitment.Wave_Plan_Version__c=wavePlanVersion.Id;
		recruitment.Wave_Plan_lk__c=wavePlanningObj.Id;
		recruitment.Activity__c='Test';
		recruitment.Deal_Location_lk__c=dealLocation.Id;
		database.insert(recruitment);
		
		Offerings_Master__c offering=new Offerings_Master__c();
		offering.Name='Test Offer';
		offering.Active__c=true;
		database.insert(offering);
		
		Client_Specific_Process_Mapping__c clienProcesstMap=new Client_Specific_Process_Mapping__c();
		clienProcesstMap.Active__c=true;
		clienProcesstMap.Deal__c=dealData.Id; 
		clienProcesstMap.Offering__c=offering.Id;
		database.insert(clienProcesstMap);
		
		Wave_Process__c waveProcess1=new Wave_Process__c();
		waveProcess1.Version__c=1;
		waveProcess1.Wave_Planning__c=wavePlanningObj.Id;
		waveProcess1.Client_Specific_Process_Mapping__c=clienProcesstMap.Id;
		database.insert(waveProcess1);
		waveProcess.add(waveProcess1);
		
		SRAT_Item_Master__c SRATItemMaster =new SRAT_Item_Master__c();
		SRATItemMaster.Item_Name__c='Test Item'; 
		SRATItemMaster.Is_Active__c=true;
		SRATItemMaster.Days_Before_Go_Live_Date__c= -2;
		database.insert(SRATItemMaster);
	} 
	static testMethod void insertInSRAT(){
		setupdata();
		Mob_PrePopulateSRATGrid.insertInSRAT(wavePlanningList);
		
	}
	static testMethod void updateInSRAT(){
		setupdata();
		Mob_PrePopulateSRATGrid.updateInSRAT(wavePlanningList);
	}

}