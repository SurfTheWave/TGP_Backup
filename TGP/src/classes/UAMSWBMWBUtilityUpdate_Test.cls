/*@Auhtor: Shivraj
 * @Description: This Test class contains code for coverage of MobilizatioSharingDelete Batch class
 * @CreatedDate: 10th September,2015
 */
@isTest
public class UAMSWBMWBUtilityUpdate_Test {
     private static User testUser;
     private static List < Mobilization_team__c > mobilizationTeamList=new List<Mobilization_team__c>();
    /*
    @name : validateSharingDelete
    @Description: This method contains code to call MobilizationSharingDelete Batch class 
    @Version : 1.0
    */
    public static testMethod void validateupdateMobTeamWithShare(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');
        
        insert testUser;
        
        User_Master__c userMaster= new User_Master__c();
        userMaster.Name = 'UserMasterTest0';
        userMaster.user__C = testUser.id;
        insert userMaster;
        
        Deal__c dealObj=new Deal__c(Name='Testdeal');
        insert dealObj;
        
        Mobilization_team__c mobTeam=new Mobilization_team__c(deal__C=dealObj.id,role__c='Deal PMO',primary_lead__c=userMaster.id,Secondary_Lead_1__c=userMaster.id,Secondary_Lead_2__c=userMaster.id);
        insert mobTeam;
        
        Mobilization_team__c mobTeamTwo=new Mobilization_team__c(deal__C=dealObj.id,role__c='Deal PMO',primary_lead__c=userMaster.id,Secondary_Lead_1__c=userMaster.id,Secondary_Lead_2__c=userMaster.id);
        insert mobTeamTwo;
        
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealObj.id);
        insert strmobplan;
        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today());
        insert strWave;
        
        SRAT_Tracker__c strSRATtrack = new SRAT_Tracker__c(Name = 'test SRAT Tracker', Wave__c =strWave.Id, Mobilization_Plan__c = strmobplan.Id);
        insert strSRATtrack; 
        
        OPEX_Tracker__c strOPEXTrack = new OPEX_Tracker__c(Name = 'Day 1 Assessment', Wave__c =strWave.Id, Mobilization_Plan__c = strmobplan.Id);
        insert strOPEXTrack; 
        
        SRAT_Additional_Tracking_Level_1__c sratlevel1=new SRAT_Additional_Tracking_Level_1__c(Name='Test',SRAT_Tracker__c=strSRATtrack.id);
        insert sratlevel1;
        
        Deal_OPEX_Additional_Tracking_Level_1__c opexL1=new Deal_OPEX_Additional_Tracking_Level_1__c(name='test',OPEX_Tracker_del__c=strOPEXTrack.id);
        insert opexL1;
        
        Procurement_Wave_Region__c strProcur = new Procurement_Wave_Region__c(Name = 'test Procurement', Wave__c = strWave.Id);
        insert strProcur;
        
        mobilizationTeamList.add(mobTeam);        
        mobilizationTeamList.add(mobTeamTwo);
        
        Test.startTest();
        UAMSWBMWBUtilityUpdate.updateMobTeamWithShare(mobilizationTeamList);
        Test.stopTest();
        
    }
}