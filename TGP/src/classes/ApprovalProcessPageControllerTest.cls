/*
Author : Shridhar Patankar
Story  :   SOL_082
Description :Under View Submitted Meetings Tab under Approval Tab, default list of all the submitted meetings is displayed with button to see the previously scheduled meeting logs.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class ApprovalProcessPageControllerTest{
  static User testUser; 
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
   
    public static void setupData(){
     
      //Profile p = [Select id from Profile where Name = 'Solution Users'];
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
      
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
      Review_Process__c rProcess=new Review_Process__c();
        rProcess.BPO_Opportunity__c=oppTGP.id;
        insert rProcess;
      
           Review_Meeting_Request__c revMeetingRec = new Review_Meeting_Request__c();
        revMeetingRec.Client_Name__c='test';
        revMeetingRec.Status__c='Scheduled';
        revMeetingRec.Review_Process__c=rProcess.id;
        revMeetingRec.BPO_Opportunity__c=oppTGP.id;
        insert revMeetingRec;
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
     assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
     
     
   }
    public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1');
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData');
     insert assumptionMaster;
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering');
     insert offeringMaster;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id );
     insert serviceMaster;
     
     
    
      assumption= new Assumption__c (Opportunity_Offering__c =oppOffering.id ,Services_per_Offering__c ='ServiceTest' );
      insert assumption;
   }
   
   static testMethod void testApprovalProcessPageController(){
   
       Test.starttest();
       setupData();
         
         ApprovalProcessPageController approvalProcessPageCntr = new ApprovalProcessPageController();
         String meetingID;
         approvalProcessPageCntr.getMeetingID();
         approvalProcessPageCntr.initializeSubmittedMeetings();
         approvalProcessPageCntr.scheduledMeetingList();
         approvalProcessPageCntr.deferredMeetingList();
         approvalProcessPageCntr.hideScheduledList();
         approvalProcessPageCntr.hideDeferredList();
         approvalProcessPageCntr.scheduleCall();
         approvalProcessPageCntr.deferCall();
         approvalProcessPageCntr.getMeetingID();
         approvalProcessPageCntr.setMeetingID(meetingID);
         PageReference redirectToDownload= approvalProcessPageCntr.redirectToDownload();
         
       Test.stoptest(); 
   } 
   static testMethod void tester(){
   
       Test.starttest();
       setupData();
         
         ApprovalProcessPageController approvalProcessPageCntr = new ApprovalProcessPageController();
         String meetingID;
         approvalProcessPageCntr.getMeetingID();
         approvalProcessPageCntr.initializeSubmittedMeetings();
         approvalProcessPageCntr.scheduledMeetingList();
         ApprovalProcessPageController.refreshPage();
         approvalProcessPageCntr.setMeetingID(meetingID);
         PageReference redirectToDownload= approvalProcessPageCntr.redirectToDownload();
         
       Test.stoptest(); 
   } 
}