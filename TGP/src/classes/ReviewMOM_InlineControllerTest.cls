/*
Author : Vinay Kumar Chada
Story  :  
Description : Test Class for ReviewMOM_InlineControllerTest. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class ReviewMOM_InlineControllerTest{
static Approver_Master__c aMaster;
static Review_Meeting_Request__c revMeetReq;
static User testUser;
static User testUser1;
static Review_Process__c rProcess;
static Review_MOM_Titel__c riviewMOM;
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
static final string USER_NAME1 = 'vc123@testorg.com';

static ApexPages.StandardController sc;

public static void setupData(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);
    
    p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
          testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME1);
          Database.insert(testUser1, false);

  system.runas(testUser1)
  {  
  clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
  insert clientName;
  
  clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
  insert clientGeoArea;
  
  operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
  insert operatingGroup;
  
  clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
  insert clientGeoUnit;
 
  }
  system.runas(testUser)
  {
  oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
              Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
              Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
  insert oppTGP;
  
 
 
 offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
 insert offeringMaster;
 
  oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Lead__c=testUser.id,Solution_Specialist__c=testUser.id);
 insert oppOffering;
 
 serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
 insert serviceMaster;
 
 assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
 insert assumptionMaster;
 
  assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
 insert assumption;
 
 ccca = new Current_Client_Capability_Assessment__c(File_ID__c = 'TEstID1234',File_Name__c = 'TEstName',Opportunity_TGP__c =oppTGP.id,Comments__c = 'abc' );
 insert ccca;

 //To create a record of Review Process
rProcess=new Review_Process__c();
rProcess.BPO_Opportunity__c=oppTGP.id;
insert rProcess;

riviewMOM = new Review_MOM_Titel__c();
 riviewMOM.name='Test Data'; 
 riviewMOM.MOM_Rich__c='Test Data';
 riviewMOM.Review_Process__c=rProcess.id;
 
//To create a Review meeting request
revMeetReq=new Review_Meeting_Request__c();
revMeetReq.Client_Name__c='test';
revMeetReq.Status__c='Scheduled';
revMeetReq.Review_Process__c=rProcess.id;
revMeetReq.BPO_Opportunity__c=oppTGP.id;
insert revMeetReq;


//To create a Approval Master

aMaster=new Approver_Master__c();
//aMaster.TCV_Range__c='10-40M';
//aMaster.Region__c='NA';
aMaster.Name='TEst';
aMaster.Approver_Mail_ID__c='abc@email.com';
insert aMaster;

sc = new ApexPages.StandardController(rProcess); 
}
}

static testMethod void test1(){
 
test.starttest();



setupData();

//Run As U1
System.RunAs(testUser1){

ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id',rProcess.id);
apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
ReviewMOM_InlineController obj = new ReviewMOM_InlineController(sc);


obj.getDisplay1();
    obj.getComments();
    obj.initializeDetailRecords();
    ReviewMOM_InlineController.DisplayFile obj1=new ReviewMOM_InlineController.DisplayFile('testFile333','testid','testComment');
    obj.saveAccProfileDetails();
    obj.doc1.name='test';
    obj.doc1.body=Blob.valueOf('test');
    obj.saveNow();
    obj.upload();
    obj.cancelNow();
    obj.deleteFile();
}
test.stoptest();
 
 }  
 
 
  
}