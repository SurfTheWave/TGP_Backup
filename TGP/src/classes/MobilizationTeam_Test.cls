/*@Auhtor: Shivraj
 * @Description: This Test class contains code for coverage of MobilizatioSharingDelete Batch class
 * @CreatedDate: 10th September,2015
 */
@isTest
public class MobilizationTeam_Test {

    private static User testUser;
    private static List<Mobilization_team__C> mobilizationList=new List<Mobilization_team__C>();
    private static List<Deal__c> dealList=new List<Deal__C>();
    /*
    @name : validateMobilizationTeam
    @Description: This method contains code to call MobilizationTeam class 
    @Version : 1.0
    */
    public static testMethod void validateMobilizationTeam(){
        Test.startTest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');
        
        insert testUser;
        
        Deal__c deal=new Deal__c(Name='Test deal',Approval_Status__c='Pending',approver__c=testUser.id);
        insert deal;
        
        dealList.add(deal);
        
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id);
        insert strmobplan;
        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today());
        insert strWave;
        
        User_Master__c userMaster= new User_Master__c();
        userMaster.Name = 'UserMasterTest0';
        userMaster.user__C = testUser.id;
        insert userMaster;
        
        deal=[select id,approval_status__C from deal__c where id=:deal.id];
        deal.Approval_Status__c='Approved';
        update deal;
        
        Mobilization_team__c mobTeam=new Mobilization_team__c(deal__C=deal.id,role__c='Global Transition Lead',primary_lead__c=userMaster.id);
        insert mobTeam;
        
        Mobilization_team__c mobTeamOne=new Mobilization_team__c(deal__C=deal.id,role__c='Governance Lead',primary_lead__c=userMaster.id);
        insert mobTeamOne;
        
        Mobilization_team__c mobTeamThree=new Mobilization_team__c(deal__C=deal.id,role__c='Governance Lead',primary_lead__c=userMaster.id);
        insert mobTeamThree;
        
         Mobilization_team__c mobTeamFour=new Mobilization_team__c(deal__C=deal.id,role__c='KT Lead',primary_lead__c=userMaster.id,wave__c=strWave.id);
        insert mobTeamFour;
        
        mobilizationList.add(mobTeam);
        mobilizationList.add(mobTeamOne);
        mobilizationList.add(mobTeamThree);
        mobilizationList.add(mobTeamFour);        
        
        MobilizationTeamMemberRole.populateRole(mobilizationList);
        
        MobilizationTeam.createMobilizationTeam(dealList);
        MobilizationTeam.checkDuplicateRoles(mobilizationList);
        MobilizationTeam.populateDealOnMobilizationTeam(mobilizationList);
               
        Test.stopTest();
    }
}