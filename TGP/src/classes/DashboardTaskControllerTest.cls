/*
Author : Shridhar Patankar
Story  : 
Description : Test Class for DashboardTaskController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class DashboardTaskControllerTest{
static String objectId; 
static Integer numLeft;
static Integer total; 
static Integer startNdx = 0;
static Integer PAGESIZE = 8;
static Integer endNdx; 
static User testUser; 
static List<Task> fullTaskList = new List<Task>();
static List<Task> displayedTaskList = new List<Task>();
public static void setupData(){

   Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        testUser.Email  = 'abc123@abc.com';
        Database.insert(testUser, false);
      
}

  static testMethod void testDashboardTaskController(){
       test.starttest();
       setupData();
       system.runas(testUser){
       Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        t.Approval_Status__c ='Pending';
        t.Email_ID_of_the_reviewer__c = testUser.Email;
     // t.Responsavel__c='Felipe';
         insert t;    
        
        fullTaskList.add(new Task(subject= 'Simple Task',status = 'In Progress',priority = 'Normal',Approval_Status__c = 'Pending'));
         insert fullTaskList;
         
         DashboardTaskController dashboardtsk =  new DashboardTaskController ();
           
       PageReference refreshPage = dashboardtsk.refreshPage();
       List<Task> task = dashboardtsk.getTasks();
       PageReference showDetail = dashboardtsk.showDetail();
       dashboardtsk.nextTask();
       dashboardtsk.previous();
       dashboardtsk.next();
       Boolean getHasNext = dashboardtsk.getHasNext();
       Boolean getHasPrevious = dashboardtsk.getHasPrevious();
       Integer getNum= dashboardtsk.getNum();
       PageReference save= dashboardtsk.save();
       }
       test.stoptest(); 
   }
}