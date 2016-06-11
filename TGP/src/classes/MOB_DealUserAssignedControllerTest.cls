@isTest
private class MOB_DealUserAssignedControllerTest
{
    static OPEX__c opex;
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static OPEX_Version__c opexversion;
    static Wave_Planning__c waveplan;
    static Deal_Location__c dealLoc;
    static Client_Geo_Area_Master__c clientGeo ;
    static Delievery_Location_Master__c deliveryLocMa ;
    static Deal_Home_Location__c dealHome ;
    static OPEX_Section_Name__c opexsec;
    static OPEX_Section_Questionnaire__c opexques;
    static ApexPages.StandardController sc;
    static OPEX_Section_Name__c bpoopexsec;
    static OPEX_Section_Questionnaire__c bpopexques;
    static User testUser,testUser1;
    static Task emailTask;
    static Mob_User_Roles_Master__c strMoURM; 
    static MOB_User_Role_Assignment__c strMoURA;
    static Review_User_Master__c objReviewUser;
    static Review_User_Master__c objReviewUser1;
    static Review_User_Master__c objReviewUser2;

    
    public static void setupData(){

    // To Create a Test User

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
    
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser1, false);
     
     // To create a Mob_User_Roles_Master__c
    strMoURM=new Mob_User_Roles_Master__c();
    strMoURM.Access_Level__c='Edit';
    strMoURM.Role_Name__c='Governance Lead';
    insert strMoURM;
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser1.Email;        
    objReviewUser.Name='reviewUaser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser1.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUaser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser1.Email;        
    objReviewUser2.Name='reviewUaser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    

    }
    
    static testMethod void testsave1()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Governance Lead';
    roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser2.id;
    
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    test.stoptest();
    }  
    
    static testMethod void testsave2()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Governance Lead';
    roleAssign.User_Assigned_New__c=null;
    roleAssign.User_Assigned_Secondary_New__c=null;
    roleAssign.User_Assigned_Secondary_Lead__c=null;

    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    test.stoptest();
    }      
    
static testMethod void testsave3()
{
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Governance Lead';
    roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=null;
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    test.stoptest();
}

    static testMethod void testsave4()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Global Mobilization Lead';
    roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser2.id;    
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    obj.Loaddata();
    test.stoptest();
    }
    static testMethod void testsave41()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Deal PMO';
    roleAssign.User_Assigned_New__c=objReviewUser.id;    
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser2.id;
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    test.stoptest();
    }      
    static testMethod void testsave42()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Program Control PMO';
    roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser2.id;    
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    test.stoptest();
    }
    static testMethod void testsave5()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Mobilization PMO Project';
    roleAssign.User_Assigned_New__c=objReviewUser.id;    
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser2.id;
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    test.stoptest();
    }      
    
    static testMethod void testsave6()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Program Control PMO';
    roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser2.id;
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    obj.refreshPage();
    obj.edit();
    obj.cancel();
    test.stoptest();
    }      
    
    
 // SETUP DATA
 
 static testMethod void testsave7()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Governance Lead';
    roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser1.id;
    
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    obj.refreshPage();
    obj.edit();
    obj.cancel();
    
    test.stoptest();
    }     
    
    
    
    static testMethod void testsave8()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Governance Lead';
    roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser1.id;
    
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    obj.refreshPage();
    obj.edit();
    obj.cancel();
    
    test.stoptest();
    }     
  
  
  
  static testMethod void testsave9()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Governance Lead';
    roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser.id;
    
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    obj.refreshPage();
    obj.edit();
    obj.cancel();
    
    test.stoptest();
    }     

    
   static testMethod void testsave10()
    {
    test.starttest();

    setupData();
    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    deal.Governance_Lead_Name_New__c=objReviewUser.id;
    insert deal;

    MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Governance Lead';
    // roleAssign.User_Assigned_New__c=objReviewUser.id;
    roleAssign.User_Assigned_Secondary_New__c=objReviewUser1.id;
    roleAssign.User_Assigned_Secondary_Lead__c=objReviewUser1.id;
    
    insert roleAssign ;
    
    sc = new ApexPages.StandardController(deal);
    MOB_DealUserAssignedController obj = new MOB_DealUserAssignedController(sc);
    
    obj.save();
    obj.refreshPage();
    obj.edit();
    obj.cancel();
    
    test.stoptest();
    }     
 
    
    
}