/*@Auhtor: Shivraj
 * @Description: This Test class contains code for coverage of MobilizatioSharingDelete Batch class
 * @CreatedDate: 10th September,2015
 */
@isTest
public class MobilizationSharingDelete_Test {
    private static set<Id> userGroupId=new set<Id>();
    private static String query;
    private static String objName;
    private static Map<Id,set<Id>> dealWithteam=new Map<Id,set<Id>>();
    private static set<Id> ddID=new set<Id>();
    private static set<Id> sId=new set<Id>();
    private static Map<Id,id> sratDeal=new Map<Id,Id>();
    private static set<Id> rId=new set<Id>();
    private static Map<Id,Id> rMap=new Map<Id,Id>();
    private static set<Id> iId=new set<Id>();
    private static Map<Id,Id> iMap=new Map<Id,Id>();
    private static set<Id> aId=new set<Id>();
    private static Map<Id,Id> aMap=new Map<Id,Id>();
    private static set<Id> dId=new set<Id>();
    private static Map<id,id>dMap=new Map<Id,Id>();
    private static set<Id> oId=new set<Id>();
    private static Map<Id,Id> oMap=new Map<Id,Id>();
    private static set<Id> pId=new set<Id>();
    private static Map<Id,Id> pMap=new Map<Id,Id>();
    private static set<Id> mtId=new set<Id>();
    private static Map<Id,Id> mtMap=new Map<Id,Id>();
    private static User testUser;
    
    /*
    @name : validateSharingDelete
    @Description: This method contains code to call MobilizationSharingDelete Batch class 
    @Version : 1.0
    */
    public static testMethod void validateSharingDelete(){
        Test.startTest();
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');
        
        insert testUser;
        query='select id,userorgroupid,parentid,rowcause from Deal__Share where parentid IN:dealId AND userorgroupId in:userId';
        objName='Deal__Share';
        
        User_Master__c userMaster= new User_Master__c();
        userMaster.Name = 'UserMasterTest0';
        userMaster.user__C = testUser.id;
        insert userMaster;
        
        Deal__c dealObj=new Deal__c(Name='Testdeal');
        insert dealObj;
         
        Deal__share dealShare = new Deal__share();
        dealShare.parentid=dealObj.id;
        dealShare.rowcause='Manual';
        dealShare.accesslevel='Edit';
        dealShare.UserOrGroupId=testUser.id;
        
        insert dealShare;
        
        Risks__c risk= new Risks__C();
        risk.Title__c = 'Test Isuue0';
        risk.Raised_by_Client_Accenture__c = 'Accenture';
        risk.Workstream_Area__c = 'Enable People';
        risk.Forum_Raised__c = 'Tactical / Program Level';
        risk.Raised_at_level__c = 'Tactical / Program Level';
        risk.deal__C=dealObj.id;
        risk.Raised_By__c = userMaster.Id ;
        risk.Owned_by__c = userMaster.Id ;
        risk.Assigned_To__c = userMaster.Id ;
        risk.Primary_Owner__c = userMaster.Id ;
        risk.deal__c=dealObj.id;
        
        insert risk;
        rId.add(risk.id);
        Risks__share riskShare=new Risks__share();
        riskShare.parentid=risk.id;
        riskShare.rowcause='Manual';
        riskShare.accesslevel='Edit';
        riskShare.UserOrGroupId=testUser.id;
        insert riskShare;
        
        
        Mobilization_team__c mobTeam=new Mobilization_team__c(deal__C=dealObj.id,role__c='Deal PMO',primary_lead__c=userMaster.id);
        insert mobTeam;
        
        Mobilization_team__share mobteamShare=new Mobilization_team__share();
        mobTeamShare.parentid=mobTeam.id;
        mobTeamShare.rowcause='Manual';
        mobTeamShare.accesslevel='Edit';
        mobTeamShare.UserOrGroupId=testUser.id;
        insert mobTeamShare;
        
        mtId.add(mobTeam.id);
        
        ddID.add(dealObj.id);
        userGroupId.add(testUser.id);
        
        MobilizationSharingDelete mobDelete = new MobilizationSharingDelete(userGroupId,query,objName,dealWithteam, ddID, sId,sratDeal, rId,rMap, iId,iMap, aId,aMap, dId,dMap, oId,oMap, pId,pMap, mtId,mtMap);
        Id batchId=database.executeBatch(mobDelete);
        Test.stopTest();
    }
}