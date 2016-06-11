/**
     Author : Madhusudhan 
    Story  : Mob_R1.7_003_Export RAID Log to Excel  
    Description : Test Class for ExportRAIDToExcelControllerTest . 

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------

     */
@isTest
private class ExportRAIDToExcelControllerTest {
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
    static Opportunity_TGP__c oppTGP;
    static Recruitment_Tracking__c RecruitmentTracking;
    static SRAT__c srat;
    static OPEX__c opex;
    static RAID_Risk__c riskRAID;
    static RAID_Action__c actionRAID;
    static RAID_Issue__c issueRAID;
    static RAID_Decision__c decisioRAID;
    static Deal_Location__c recruitmentRecord;
    static User testUser; 
    static Review_User_Master__c objReviewUser; 
    static Admin_level_acces__c adminLevelAccObj;
    static UAM_Roles_Permissions__c uamRolesPermissions_action;
    static UAM_Roles_Permissions__c uamRolesPermissions_issue;
    static UAM_Roles_Permissions__c uamRolesPermissions_risk;
    static UAM_Roles_Permissions__c uamRolesPermissions_decision;
    
    public static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile('System Administrator');
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        insert testUser;
        String riskRole = userInfo.getUserRoleId();

        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Tesing the Deal Data';
        insert deal;

        
        }
     
              
         static testMethod void testExportRiskController(){
              test.starttest();
              setupData();
              
               PageReference pageRef = Page.ExportRAIDToExcel;
              apexpages.currentpage().getparameters().put('id' ,deal.id);
              ExportRAIDToExcelController exportRaidLogs = new ExportRAIDToExcelController();
              String testo = exportRaidLogs.xlsHeader;
              test.stoptest();  
        }

}