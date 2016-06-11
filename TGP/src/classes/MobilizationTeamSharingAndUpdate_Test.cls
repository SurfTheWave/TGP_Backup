/*@Auhtor: Shivraj
 * @Description: This Test class contains code for coverage of MobilizatioSharingDelete Batch class
 * @CreatedDate: 10th September,2015
 */
@isTest
public class MobilizationTeamSharingAndUpdate_Test {

    private static set<Id> dId=new set<Id>(); 
    private static String dealQuery; 
    private static Map<Id,set<Id>> dealMap=new Map<Id,set<Id>>(); 
    private static String flag; 
    private static Map<Id,Id> sratWithMob=new Map<Id,Id>(); 
    private static Map<Id,Id> mobDealMap=new Map<Id,Id>(); 
    private static set<Id> sratId=new set<Id>(); 
    private static Map<Id,id>opexWithMob=new Map<Id,Id>(); 
    private static set<Id> opexId=new set<Id>(); 
    private static set<Id> waveId=new set<Id>(); 
    private static Map<Id,Id> waveMob=new Map<Id,Id>();
    private static User testUser;
    private static set<Id> userId=new set<Id>();

     /*
    @name : validateSharingDelete
    @Description: This method contains code to call MobilizationSharingDelete Batch class 
    @Version : 1.0
    */
    public static testMethod void validateTeamSharing(){
        
        
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');
        
        insert testUser;
        
        user_master__c userMaster=new user_master__C(user__c=testUser.id);
        insert usermaster;
        
        userId.add(testUser.id);
        
        Deal__c deal=new Deal__c(Name='Test Deal');
        insert deal;
        dId.add(deal.id);
        
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id);
        insert strmobplan;
        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today());
        insert strWave;
        
        SRAT_Tracker__c strSRATtrack = new SRAT_Tracker__c(Name = 'test SRAT Tracker', Wave__c =strWave.Id, Mobilization_Plan__c = strmobplan.Id);
        insert strSRATtrack; 
        
        OPEX_Tracker__c strOPEXTrack = new OPEX_Tracker__c(Name = 'Day 1 Assessment', Wave__c =strWave.Id, Mobilization_Plan__c = strmobplan.Id);
        insert strOPEXTrack; 
        
        opexId.add(strOPEXTrack.id);
        opexWithMob.put(strOPEXTrack.id,strmobplan.id);
        
        Procurement_Wave_Region__c strProcur = new Procurement_Wave_Region__c(Name = 'test Procurement', Wave__c = strWave.Id);
        insert strProcur;
        waveId.add(strWave.id);
        waveMob.put(strWave.id,strmobplan.id);                
        
        SRAT_Additional_Tracking_Level_1__c sratlevel1=new SRAT_Additional_Tracking_Level_1__c(Name='Test',SRAT_Tracker__c=strSRATtrack.id);
        insert sratlevel1;
        
        Deal_OPEX_Additional_Tracking_Level_1__c opexL1=new Deal_OPEX_Additional_Tracking_Level_1__c(name='test',OPEX_Tracker_del__c=strOPEXTrack.id);
        insert opexL1;
        
        sratId.add(strSRATtrack.id);
        sratWithMob.put(strSRATtrack.id,strmobplan.id);
        
        mobDealMap.put(strmobplan.id,deal.id);
        
        dealMap.put(deal.id,userId);
        
        
        dealQuery='select id,ownerId from Deal__c where Id IN:dealId';
        flag='Deal__Share';
        
        Test.startTest();
        
        Id testId=database.executeBatch(new MobilizationTeamSharing(dId,dealQuery,dealMap,flag,sratWithMob,mobDealMap,sratId,opexWithMob,opexId,waveId,waveMob));
        Id testUpdateId=database.executeBatch(new MobilizationTeamSharingUpdate(dId,dealQuery,dealMap,flag,sratWithMob,mobDealMap,sratId,opexWithMob,opexId,waveId,waveMob,dealMap));
        
        Test.stoptest();
    }

}