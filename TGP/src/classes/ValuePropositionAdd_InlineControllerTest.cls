/*
Author : Shridhar Patankar
Story  : Story-0165/SOL_068  
Description : Test Class for ValuePropositionAdd_InlineController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class ValuePropositionAdd_InlineControllerTest{
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
   static Value_Proposition__c valueprop;
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
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
     
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     valueprop = new Value_Proposition__c(Opportunity_TGP__c=oppTGP.id,Key_Messages_Win_Themes__c='testingpurpose',How_do_these_relate_to_buyer_values__c='valueessff',Evidence__c='proof',Active__c=true);
     insert valueprop;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
     
   }
    static testMethod void testValuePropositionAdd_InlineController(){
       test.starttest();
          setupData();
          String fileIdDelete;
          ApexPages.StandardController controller;
          apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
         ValuePropositionAdd_InlineController valuePropositionAddInlineController = new ValuePropositionAdd_InlineController( controller);
         valuePropositionAddInlineController.initializeDetailRecords();
         List<Value_Proposition__c> listProfileDetailsActual = new List<Value_Proposition__c>();
         listProfileDetailsActual.add(valueprop);
         PageReference addNewProfDetail= valuePropositionAddInlineController.addNewProfDetail();
         PageReference refreshAccProfilePage= valuePropositionAddInlineController.refreshAccProfilePage();
         PageReference saveAccProfileDetails= valuePropositionAddInlineController.saveAccProfileDetails();
         PageReference deleteFile= valuePropositionAddInlineController.deleteFile();
         valuePropositionAddInlineController.getFileIdDelete();
         valuePropositionAddInlineController.setFileIdDelete(fileIdDelete);
       test.stoptest(); 
   } 
   static testMethod void testValuePropositionAdd_InlineController2(){
       test.starttest();
          setupData();
          String fileIdDelete;
          ApexPages.StandardController controller;
          //apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
         ValuePropositionAdd_InlineController valuePropositionAddInlineController = new ValuePropositionAdd_InlineController( controller);
         
         PageReference addNewProfDetail= valuePropositionAddInlineController.addNewProfDetail();
         
       test.stoptest(); 
   } 
   static testMethod void testValuePropositionAdd_InlineController3(){
       test.starttest();
          setupData();
          String fileIdDelete;
          ApexPages.StandardController controller;
          apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
         ValuePropositionAdd_InlineController valuePropositionAddInlineController = new ValuePropositionAdd_InlineController( controller);
         valuePropositionAddInlineController.newProfDetail.Key_Messages_Win_Themes__c='Test Message';
         valuePropositionAddInlineController.newProfDetail.Evidence__c=null;
         PageReference addNewProfDetail= valuePropositionAddInlineController.addNewProfDetail();
         
       test.stoptest(); 
   } 
   static testMethod void testValuePropositionAdd_InlineController4(){
       test.starttest();
          setupData();
          String fileIdDelete;
          ApexPages.StandardController controller;
          apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
         ValuePropositionAdd_InlineController valuePropositionAddInlineController = new ValuePropositionAdd_InlineController( controller);
         valuePropositionAddInlineController.initializeDetailRecords();
         
         valuePropositionAddInlineController.newProfDetail.Key_Messages_Win_Themes__c='Test Message';
         valuePropositionAddInlineController.newProfDetail.Evidence__c='Test Evidence';
         valuePropositionAddInlineController.newProfDetail.How_do_these_relate_to_buyer_values__c=null;
         PageReference addNewProfDetail= valuePropositionAddInlineController.addNewProfDetail();
         
       test.stoptest(); 
   } 
   static testMethod void testValuePropositionAdd_InlineController5(){
       test.starttest();
          setupData();
          String fileIdDelete;
          ApexPages.StandardController controller;
          apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
         ValuePropositionAdd_InlineController valuePropositionAddInlineController = new ValuePropositionAdd_InlineController( controller);
         valuePropositionAddInlineController.initializeDetailRecords();
         
         valuePropositionAddInlineController.newProfDetail.Key_Messages_Win_Themes__c='Test Message';
         valuePropositionAddInlineController.newProfDetail.Evidence__c='Test Evidence';
         valuePropositionAddInlineController.newProfDetail.How_do_these_relate_to_buyer_values__c='Test how';
         PageReference addNewProfDetail= valuePropositionAddInlineController.addNewProfDetail();
         
       test.stoptest(); 
   } 
}