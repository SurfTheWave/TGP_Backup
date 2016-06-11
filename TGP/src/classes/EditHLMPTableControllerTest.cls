/**
 * Test Class for EditHLMPTableController
 */
@isTest
private class EditHLMPTableControllerTest {

//static List<Wave_Planning__c> wavePlanninglist;
//static List<Wave_Process__c> waveProcesslist;
static Wave_Planning__c wavPlanning;
static Wave_Process__c wavProc;
static Deal_Location__c dealLoc;
static Wave_Plan_Version__c wavPlanVer;
static Deal_TGP__c deal;
static Client_Specific_Process_Mapping__c csProcMapping;
static Offerings_Master__c om;
static User testUser;
private static string USER_NAME = 'vc12@testorg.com';

        public static void setupData(){
            deal = new Deal_TGP__c();
            insert deal;
            wavPlanVer = new Wave_Plan_Version__c(Deal__c=deal.Id);
            insert wavPlanVer;
            dealLoc = new Deal_Location__c(Wave_Plan_Version__c=wavPlanVer.Id);
            insert dealLoc;
            date myDate = date.today();
            wavPlanning = new Wave_Planning__c(Deal_Location__c=dealLoc.Id, GO_Live_Date_del__c=myDate, Wave_Label__c ='testLabel');
            insert wavPlanning;
            om = new Offerings_Master__c();
            insert om;
            csProcMapping = new Client_Specific_Process_Mapping__c(Deal__c=deal.Id,Offering__c=om.id);
            insert csProcMapping;
            
            wavProc = new Wave_Process__c(Wave_Planning__c=wavPlanning.Id, Number_of_Projected_FTEs__c=24, Client_Specific_Process_Mapping__c=csProcMapping.Id);
            insert wavProc;
        }

        static testMethod void testSave(){
            Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
            
            testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
            insert testUser;
            
            //Run As U1
            System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;
            //apexpages.currentpage().getparameters().put('Id',cEvent.id);
            EditHLMPTableController obj = new EditHLMPTableController(controller);
            test.starttest();
            obj.save();
            obj.edit();
            obj.cancel();
            test.stoptest();
            }
         }
}