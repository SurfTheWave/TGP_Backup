/**
   @Author         : Shoukath S
   @name           : VFP_OppHomePageController_TEST
   @CreateDate     : 03 April 2015 
   @Description    : Test class of VFC_OppHomePageController class
   @Version        : 1.0 
  */
@isTest
private class VFC_OppHomePageController_TEST{

/*
static integer count=20;
List<Opportunity> oppList = new List<Opportunity>();

List<Solution_Scope__c> solCompList = UnitTestDatafactory.getSolutionCompforVF(count);

static 
static List<utilizations__c> result= new List<utilizations__C>();
static Boolean hasPrevious;
static Integer pageNumber;
static Integer totalPages;
static Boolean hasNext;
*/
static testMethod void setUpData(){
PageReference pageRef = Page.VFP_OppHomePage;
    User_Master__c userObj1 = new User_Master__c(Name = 'SolTestUser',User__c = userinfo.getUserId(),email__c=userinfo.getuserEmail());
    insert userObj1;
    Opportunity_Roles_Master__c  oppRoleMas = new Opportunity_Roles_Master__c(Active__c=true,BPO_Role__c= true);
    insert oppRoleMas;
    Opportunity_Teams__c oppTeam=new Opportunity_Teams__c();
    Opportunity opp=UnitTestDatafactory.getOpportunity();
    oppTeam.Role__c= oppRoleMas.Id;
    oppTeam.Opportunity_Team_Member__c=userObj1.id;
    oppTeam.Opportunity__C=opp.id;
    insert oppTeam;
    system.debug('oppteam :::'+oppteam);
Test.setCurrentPageReference(pageRef); 

List<utilizations__c> insertutils = new list<utilizations__c>();
    for(integer i =0;i<20;i++){
    utilizations__c util = new utilizations__c();
        util.Name = oppteam.opportunity__r.name+userObj1.name;
        util.Opportunity__c = oppteam.opportunity__c;
        util.User__c = userObj1.id;
        util.Active__c = true;
       insertutils.add(util);
    }
    insert insertutils;
    test.startTest();
    VFC_OppHomePageController controller = new VFC_OppHomePageController();
    controller.getReportingStatus();
    controller.getSolList();
    controller.previous();
    controller.first();
    controller.last();
    controller.myMethod();
    controller.refresh();
    controller.next();
    test.stopTest();
}

/*

static testMethod void Test_refresh()
{
test.startTest();
controller.refresh();
test.stopTest();

system.assertEquals(count,result.size());
system.assertEquals(true,hasPrevious );
system.assertequals(1,pageNumber);
system.assertequals(2,totalPages);
system.assertequals(true,hasNext);

}
static testMethod void Test_first()
{
test.startTest();
controller.first();
test.stopTest();
system.assertEquals(count,result.size());
system.assertEquals(true,hasPrevious );
system.assertequals(1,pageNumber);
system.assertequals(2,totalPages);
system.assertequals(true,hasNext);

}

static testMethod void Test_last()
{
test.startTest();
controller.last();
test.stopTest();
system.assertEquals(count,result.size());
system.assertEquals(true,hasPrevious );
system.assertequals(1,pageNumber);
system.assertequals(2,totalPages);
system.assertequals(true,hasNext);

}

static testMethod void Test_previous()
{
test.startTest();
controller.previous();
test.stopTest();
system.assertEquals(count,result.size());
system.assertEquals(true,hasPrevious );
system.assertequals(1,pageNumber);
system.assertequals(2,totalPages);
system.assertequals(true,hasNext);

}

static testMethod void Test_next()
{
test.startTest();
controller.next();
test.stopTest();

system.assertEquals(count,result.size());
system.assertEquals(true,hasPrevious );
system.assertequals(1,pageNumber);
system.assertequals(2,totalPages);
system.assertequals(true,hasNext);

}*/

}