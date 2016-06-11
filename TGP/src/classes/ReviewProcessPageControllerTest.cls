@isTest
private class ReviewProcessPageControllerTest{
static Event cEvent;
static Approver_Master__c aMaster;
static Review_Meeting_Request__c revMeetReq;
static User testUser;
static Review_Process__c rProcess;

static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Opportunity_TGP__c oppTGP;
static Service_Master__c serviceMaster; 
static Assumption_Master__c assumptionMaster;
static Offerings_Master__c offeringMaster;
static Opportunity_Offering__c oppOffering;
static Assumption__c assumption;
static Current_Client_Capability_Assessment__c ccca;
static Document doc;
public static void setupData(){
 
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);
  
  clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
  insert clientName;
  
  clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
  insert clientGeoArea;
  
  operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
  insert operatingGroup;
  
  clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
  insert clientGeoUnit;
 
  oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
              Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
              Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
  insert oppTGP;
  
 
 
 offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
 insert offeringMaster;
 
 serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
 insert serviceMaster;
 
  oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Lead__c=testUser.id,Solution_Specialist__c=testUser.id);
 insert oppOffering;


 //To create a record of Review Process
rProcess=new Review_Process__c();
rProcess.BPO_Opportunity__c=oppTGP.id;
insert rProcess;

revMeetReq=new Review_Meeting_Request__c();
revMeetReq.Client_Name__c='test';
revMeetReq.Status__c='Submitted';
revMeetReq.Review_Process__c=rProcess.id;
revMeetReq.BPO_Opportunity__c=oppTGP.id;
revMeetReq.Preferred_Meeting_Date_del__c=Date.today()+1;
revMeetReq.Meeting_Time__c='EALA (7am CST)';
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
public static void setupData1(){
 
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);
  
  clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
  insert clientName;
  
  clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
  insert clientGeoArea;
  
  operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
  insert operatingGroup;
  
  clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
  insert clientGeoUnit;
 
  oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
              Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
              Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
  insert oppTGP;
  
 //To create a record of Review Process
rProcess=new Review_Process__c();
rProcess.BPO_Opportunity__c=oppTGP.id;
insert rProcess;
//To create a Review meeting request
revMeetReq=new Review_Meeting_Request__c();
revMeetReq.Client_Name__c='test';
revMeetReq.Status__c='Submitted';
revMeetReq.Review_Process__c=rProcess.id;
revMeetReq.BPO_Opportunity__c=oppTGP.id;
revMeetReq.Preferred_Meeting_Date_del__c=Date.today()+1;
revMeetReq.Meeting_Time__c='EALA (7am CST)';
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

User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
System.runAs ( thisUser ) {
setupData();
}
//Run As U1
System.RunAs(testUser){

ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id',rProcess.id);
apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
ReviewProcessPageController obj = new ReviewProcessPageController(controller);
obj.getMeetingReviewList();
obj.initializePageMessages();
obj.getEmailAddresses();
if(revMeetReq!=null)
{
obj.sendEmailAlertToPmo(revMeetReq,'Submitted');
obj.sendEmailAlertToPmoUpdate(revMeetReq,'Submitted');
}
obj.emailToPMO();
obj.saveAndEmailToPMO();
obj.checkNullValues('abc');
obj.checkNumNullValues(56);
}
test.stoptest();
 }
 
 static testMethod void test2(){
test.starttest();
//Run As U1
User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
System.runAs ( thisUser ) {
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id',rProcess.id);
apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
ReviewProcessPageController obj = new ReviewProcessPageController(controller);
obj.newReviewMeet.Preferred_Meeting_Date_del__c=Date.today()+1;
obj.newReviewMeet.Meeting_Time__c=null;
List<String> userMail = ReviewProcessPageController.getUserEmailAddress(thisUser.Id);
obj.getMeetingReviewList();
obj.initializePageMessages();
obj.getEmailAddresses();
if(revMeetReq!=null)
{
obj.sendEmailAlertToPmo(revMeetReq,'Submitted');
obj.sendEmailAlertToPmoUpdate(revMeetReq,'Submitted');
}
obj.emailToPMO();
obj.saveAndEmailToPMO();
obj.checkNullValues(null);
obj.checkNumNullValues(null);
}

test.stoptest();
 }
  static testMethod void test3(){
test.starttest();
//Run As U1
User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
System.runAs ( thisUser ) {
setupData1();

ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id',rProcess.id);
apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
ReviewProcessPageController obj = new ReviewProcessPageController(controller);


obj.newReviewMeet.Preferred_Meeting_Date_del__c=Date.today()+1;
obj.newReviewMeet.Meeting_Time__c='EALA (7am CST)';
obj.getMeetingReviewList();
obj.initializePageMessages();
obj.getEmailAddresses();
obj.sendEmailAlertToPmo(revMeetReq,'Submitted');
obj.sendEmailAlertToPmoUpdate(revMeetReq,'Submitted');

obj.emailToPMO();
obj.saveAndEmailToPMO();
obj.checkNullValues(null);
obj.checkNumNullValues(null);
}

test.stoptest();
 }
  static testMethod void test4(){
test.starttest();
//Run As U1
User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
System.runAs ( thisUser ) {
setupData();

ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id',rProcess.id);
apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
ReviewProcessPageController obj = new ReviewProcessPageController(controller);
String userName;

obj.newReviewMeet.Preferred_Meeting_Date_del__c=Date.today()-1;
obj.newReviewMeet.Meeting_Time__c='EALA (7am CST)';

obj.getMeetingReviewList();
obj.initializePageMessages();
obj.getEmailAddresses();
if(revMeetReq!=null)
{
    obj.sendEmailAlertToPmo(revMeetReq,'Submitted');
    obj.sendEmailAlertToPmoUpdate(revMeetReq,'Submitted');
}
obj.opportunityRecord.TCV__c=null;
obj.emailToPMO();
obj.saveAndEmailToPMO();
obj.checkNullValues(null);
obj.checkNumNullValues(null);
}
test.stoptest();
 }
 }