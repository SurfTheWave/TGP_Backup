@isTest
/*
  @Author: 
  @Name: VF_OppTeamController_Test 
  @Created Date: 01 January 2015
  @Description:This is a test class VF_OppTeamController_Test for VF_opportunity controller .
  @version: 1.0
*/
private class VF_OppTeamController_Test {
    static User testUser;
    static Opportunity opp;
    static Profile p;
    static Opportunity_Teams__c oppTeam;
/*
  @Author: 
  @Name: setupData
  @Created Date: 01 January 2015
  @Description:this is a test method setupData for data setup.
  @version: 1.0
*/
    public static void setupData(){    
     p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.WORKBENCH_USER);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
    opp=new Opportunity(Name='test opp',CloseDate=system.today()+10,StageName='test stage'); 
    insert opp;
    oppTeam=new Opportunity_Teams__c(Opportunity__c=opp.id,Active__c=true);
    insert oppTeam;
    
    }
/*
  @Author: 
  @Name: oppTeamMethod
  @Created Date: 01 January 2015
  @Description:This is a test method oppTeamMethod for opportunity team refresh page,record save etc.
  @version: 1.0
*/
static testMethod void oppTeamMethod(){
            
        test.starttest();
        setupData();
        system.runAs(testUser){
                   
            PageReference tpageRef = Page.VF_OppTeam;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('id', oppTeam.id);
            ApexPages.StandardController testController=new ApexPages.StandardController(oppTeam); 
            VF_OppTeamController oppTeam1=new VF_OppTeamController(testController);
            oppTeam1.saveRecord();   
            oppTeam1.refreshPg();
            }
         test.stopTest();
        }
}