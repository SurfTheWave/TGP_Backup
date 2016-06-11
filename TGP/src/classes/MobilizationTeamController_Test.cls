/*
  @Author: 
  @Name: test
  @Created Date: 01 January 2015
  @Description: 
  @version: 1.0
*/
@isTest
public class MobilizationTeamController_Test {
    Private static User testUser;
    Private static Profile p;
    Private static Delivery_Location_Masters__c location;
    private static User_Master__c userMaster;
    Private static Deal__c dealObj;
    Private static Wave__c wav_Obj;
    Private static Mobilization_Plan__c mob_Obj;
    Public static Mobilization_Team__c mteam ;
    Private static Country_Master__c countryMaster;
    
/*
  @Author: 
  @Name: setupData
  @Created Date: 01 January 2015
  @Description: 
  @version: 1.0
*/
 public static void setupData(){
        p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        dealObj=new Deal__c(Name='Testdeal', Approver__c = testUser.Id);
        insert dealObj;
        /*
        mob_Obj=new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealObj.id);
        insert mob_Obj;
        wav_Obj=new Wave__c(Name='testWave',Mobilization_Plan__c=mob_Obj.id, Active__c=True);
        insert wav_Obj;
        */
        countryMaster=new Country_Master__c(Name='India');
        insert countryMaster;
        location=new Delivery_Location_Masters__c(Name='India-Hyderabad',country__c=countryMaster.id);
        insert location;
        userMaster=new User_Master__c(name='testuser');
        insert userMaster;
       
        //system.debug('mteam----'+mteam);
     } 
    
/*
  @Author: 
  @Name: mteamMethod
  @Created Date: 01 January 2015
  @Description: 
  @version: 1.0
*/    
 static testMethod void mteamMethod(){
        test.starttest();
        setupData();
        //system.runAs(testUser){
              mteam=new Mobilization_Team__c(Active__c=true,Deal__c=dealObj.id,Delivery_Location_Master__c=location.id,Primary_Lead__c=userMaster.id,Role__c='role');
             insert mteam;      
            PageReference tpageRef = Page.MobilizationTeamPage;
            Test.setCurrentPage(tpageRef);
            //system.debug('mteam.id---- '+mteam.id);
            ApexPages.currentPage().getParameters().put('id',mteam.id);
            ApexPages.StandardController testController=new ApexPages.StandardController(mteam); 
             //system.debug('mteamline43----'+mteam);
            MobilizationTeamController MobilizationTeamPage = new MobilizationTeamController(testController);
           // MobilizationTeampage.populateMobTeam();
            MobilizationTeamController.getData('India-Hyderabad');
            MobilizationTeamPage.saveRecord();
       
          mteam=new Mobilization_Team__c(Deal__c=dealObj.id);
         insert mteam; 
        PageReference mteamPageErr= new Pagereference('/apex/MobilizationTeamPage');
        test.setCurrentPage(mteamPageErr);
        ApexPages.StandardController stdConErr= new ApexPages.StandardController(mteam);
        MobilizationTeamController mteamConErr = new MobilizationTeamController (stdConErr);
        MobilizationTeamController.getData('India-Hyderabad');
        
        mteamConErr .saveRecord();
         test.stopTest();
    }
}