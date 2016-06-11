@isTest(SeeAlldata= true)
private class deleteEventControllerTest{
static Event cEvent;
static Approver_Master__c aMaster;
static Review_Meeting_Request__c revMeetReq;
static User testUser;
static Review_Process__c rProcess;
private static string USER_NAME = 'vc12@testorg.com';

public static void setupData(){

//To create a record of Review Process
rProcess=new Review_Process__c();
insert rProcess;
//To create a Review meeting request
revMeetReq=new Review_Meeting_Request__c();
revMeetReq.Client_Name__c='test';
revMeetReq.Status__c='Scheduled';
revMeetReq.Review_Process__c=rProcess.id;
insert revMeetReq;


//To create a Approval Master

aMaster=new Approver_Master__c();
//aMaster.TCV_Range__c='10-40M';
//aMaster.Region__c='NA';
aMaster.Name='TEst';
aMaster.Approver_Mail_ID__c='abc@email.com';
insert aMaster;

//To craete an Event

            
cEvent=new Event();
cEvent.StartDateTime =datetime.now()+1;
cEvent.Subject='testevent';
cEvent.EndDateTime =datetime.now()+2;
cEvent.OwnerId = UserInfo.getUserId();
cEvent.Meeting_Record_ID__c=revMeetReq.id;
insert cEvent;

}

static testMethod void test1(){
test.starttest();

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
insert testUser;


//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id',cEvent.id);
deleteEventController obj = new deleteEventController(controller);
obj.checkOperations();
obj.deleteEvent();
obj.refreshMsg();
}
test.stoptest();
 }
 
 static testMethod void test2(){
test.starttest();

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);

insert testUser;

/*testUser = new User(alias = 'u1', email='u1@testorg.com',
emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
localesidkey='en_US', profileid = p.Id, country='United States',UserRoleId =role[0].id,
timezonesidkey='America/Los_Angeles', username='deleteEventControllerTest2@testorg.com');
insert testUser;*/

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id',cEvent.id);
deleteEventController obj = new deleteEventController(controller);
obj.checkOperations();
obj.deleteEvent();
obj.refreshMsg();
}
test.stoptest();
 }
 }