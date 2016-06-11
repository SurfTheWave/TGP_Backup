/*
    Author : Muthukumar
    Story  :   
    Description : Test Class for  Mob_PrePopulateTechAssessGrid

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------
*/
@isTest
private class Mob_PrePopulateTechAssessGrid_Test {
	static Wave_Planning__c wavePlanningObj;
	static list<Wave_Planning__c> wavePlanningList=new list<Wave_Planning__c>();
	static Wave_Plan_Version__c wavePlanVersion;
	static list <Tech_Assessment__c> techAssessmentList=new list<Tech_Assessment__c>();
	static void setupdata(){
		
	//To Create deal record	
		Deal_TGP__c dealData=new Deal_TGP__c();
		dealData.Opportunity_Name__c='TestOpportunity';
		database.insert(dealData);
		
	//To Create Wave Plan Version record
		wavePlanVersion=new Wave_Plan_Version__c();
		wavePlanVersion.Version__c=1;
		wavePlanVersion.Deal__c=dealData.Id;
		database.insert(wavePlanVersion);
		
	//To Create Deal Location record
		Deal_Location__c dealLocation= new Deal_Location__c();
		dealLocation.Version__c=1;
		dealLocation.Wave_Plan_Version__c=wavePlanVersion.Id;
		database.insert(dealLocation);
		
	//To Create Wave Planning record	
		wavePlanningObj=new Wave_Planning__c();
		wavePlanningObj.Wave_Label__c='Test Wave';
		wavePlanningObj.GO_Live_Date_del__c=system.today();
		wavePlanningObj.Deal_Location__c=dealLocation.Id;
		database.insert(wavePlanningObj);
		wavePlanningList.add(wavePlanningObj);
		
   //To Create KT Planning Activity Master record
		KT_Planning_Activity_Master__c KTPlaningActivity=new KT_Planning_Activity_Master__c();
		KTPlaningActivity.Name='Test KT Activity';
		KTPlaningActivity.Activity_Order__c=1;
		KTPlaningActivity.Is_Active__c=true;
		database.insert(KTPlaningActivity);
    //To Create Activity Master  record
		Activity_Master__c activityMaster=new Activity_Master__c();
		activityMaster.Name='Test Activity';
		activityMaster.Is_Active__c=true;
		activityMaster.Activity_Order__c=1;
		database.insert(activityMaster); 
		
	//To Create Tech Assessment record	
		Tech_Assessment__c techAssesment=new Tech_Assessment__c();
		techAssesment.Name='Test TechAssessment';
		techAssesment.Activity__c='Test Activity';
		techAssesment.Deal_Location_lk__c=dealLocation.Id;
		techAssesment.Wave_Plan_lk__c=wavePlanningObj.Id;
		database.insert(techAssesment);
		techAssessmentList.add(techAssesment);
	//To Create Tech Assessment Acvitity record	
		Tech_Assessment_Activity_Master__c techAssessmentActivutyMaster=new Tech_Assessment_Activity_Master__c();
		techAssessmentActivutyMaster.Is_Active__c=true;
		techAssessmentActivutyMaster.Name='TestActivity';
		techAssessmentActivutyMaster.Activity_Order__c=1.0;
		database.insert(techAssessmentActivutyMaster);
		
   //To Create Recruitment Tracking record
		Recruitment_Tracking__c recruitment=new Recruitment_Tracking__c();
		recruitment.Version__c=1;
		recruitment.Wave_Plan_Version__c=wavePlanVersion.Id;
		recruitment.Wave_Plan_lk__c=wavePlanningObj.Id;
		recruitment.Activity__c='Test';
		recruitment.Deal_Location_lk__c=dealLocation.Id;
		database.insert(recruitment);
	}
	
	static testMethod void insertInTechAssess(){
		setupdata();
		Mob_PrePopulateTechAssessGrid.insertInTechAssess(wavePlanningList);
	}
	static testMethod void updateInTechAssess(){
		setupdata();
		Mob_PrePopulateTechAssessGrid.updateInTechAssess(wavePlanningList);
	}

}