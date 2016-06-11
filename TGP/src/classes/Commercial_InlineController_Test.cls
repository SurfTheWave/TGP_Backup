/**
 * This class contains unit tests for validating the behavior of 
 *Apex class Commercial_InlineController
 *
 */
@isTest
private class Commercial_InlineController_Test {

    static User testUser;
    static Opportunity_TGP__c oppTGP;
    static Opportunity_Commerical_Data__c oppComData;
    static Commercial_Section_Item__c commSecItem1;
    static Commercial_Section_Item__c commSecItem2;
    static Commercial_Section_Item__c commSecItem3;
    static Commercial_Section_Item__c commSecItem4;
    static Commercial_Section_Item__c commSecItem5;
    static Commercial_Section_Item__c commSecItem6;
    static Commercial_Section_Item__c commSecItem7;  
    static Commercial_Section_Item__c commSecItem8;
    static Commercial_Section_Item__c commSecItem9;
    static Commercial_Document__c commDoc;
    static Deal_Review_Note__c dealReviewNote;
    static attachment attach;
    static attachment attachComm;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    
    
    
    public static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        system.Runas(testUser)
        {
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
          Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
         insert oppTGP;
        oppComData = new Opportunity_Commerical_Data__c(Opportunity_TGP__c = oppTGP.Id);        
        insert oppComData;
            
        commSecItem1= new Commercial_Section_Item__c(Commercial__c =oppComData.Id , Section_Type__c = 'Next Steps' );
        insert commSecItem1;        
      
        commSecItem2= new Commercial_Section_Item__c(Commercial__c =oppComData.Id , Section_Type__c = 'Risks');
        insert commSecItem2; 
        
        commSecItem3= new Commercial_Section_Item__c(Commercial__c =oppComData.Id , Section_Type__c = 'Action Item' );
        insert commSecItem3; 
        
        commSecItem4= new Commercial_Section_Item__c(Commercial__c =oppComData.Id , Section_Type__c = 'Key Activities to Close the Deal' );
        insert commSecItem4; 
        
        commSecItem5= new Commercial_Section_Item__c(Commercial__c =oppComData.Id , Section_Type__c = 'Add Additional Legal Items' );
        insert commSecItem5; 
        
        commSecItem6= new Commercial_Section_Item__c(Common_Name__c= 'testdata', Section_Type__c = 'Add Additional Legal Items' );
        
        commSecItem7= new Commercial_Section_Item__c(Common_Name__c= 'testdata', Section_Type__c = 'Risks' );
        
        commSecItem8= new Commercial_Section_Item__c(Common_Name__c= 'testdata', Section_Type__c = 'Next Step');
        
       commSecItem9= new Commercial_Section_Item__c(Common_Name__c= 'testdata', Section_Type__c = 'Key Activities to Close the Deal');

        
        
        CommDoc = new Commercial_Document__c (Commercial__c = oppComData.Id  );  
        insert CommDoc; 
        
        dealReviewNote = new Deal_Review_Note__c (Commercial__c = oppComData.Id, Approval_Stage__c = 'Stage 2');
        insert dealReviewNote;
        
        attach= new Attachment();   
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
         
        
        attachComm= new Attachment();   
        attachComm.Name = 'Unit Test Attachment1';
        //Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body1');
        attachComm.body = bodyBlob;
        attachComm.ParentId = CommDoc.id;
        insert attachComm;
        } 
    }
    
    static testMethod void myUnitTest() {
        setupData();
        test.starttest();
        PageReference pageRef= Page.CommercialTab;
        pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
        Test.setCurrentPageReference(pageRef);
        
         //apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
        Commercial_InlineController insertCommData= new Commercial_InlineController();
        insertCommData.addLegalSectionItems();
        insertCommData.addRiskSectionItems();
        insertCommData.addActionItemSectionItems(); 
        insertCommData.addNextStepSectionItems(); 
        insertCommData.addDealClosingActivitySectionItems();        
                
        insertCommData.opportunityId = oppTGP.id ;
        insertCommData.newLegalSectionItem = commSecItem6;
        insertCommData.commercialId = oppComData.Id;
        insertCommData.addLegalSectionItems();

        
        insertCommData.opportunityId = oppTGP.id ;
        insertCommData.newRiskSectionItem = commSecItem7;
        insertCommData.commercialId = oppComData.Id;
        insertCommData.addRiskSectionItems();
        
       
        
        insertCommData.opportunityId = oppTGP.id ;
        insertCommData.newActItemSectionItem = commSecItem8;
        insertCommData.commercialId = oppComData.Id;
        insertCommData.addActionItemSectionItems();
        
        
        insertCommData.opportunityId = oppTGP.id ;
        insertCommData.newNextStepItem = commSecItem9;
        insertCommData.commercialId = oppComData.Id;        
        insertCommData.addNextStepSectionItems();
         

        insertCommData.opportunityId = oppTGP.id ;
        insertCommData.newActItemSectionItem = commSecItem6;
        insertCommData.commercialId = oppComData.Id;        
      
        insertCommData.addDealClosingActivitySectionItems();
        insertCommData.detailRecordsOfCommercialISections();
        insertCommData.deleteFileForCommercial();
        insertCommData.dealReviewNote();
        insertCommData.deleteFileForDealReviewNote();
        insertCommData.documentsCommercial();
        insertCommData.deleteFileForCommercialDocument();
        insertCommData.upload();
        insertCommData.uploadCommDoc();
        insertCommData.attachment = attach;
        insertCommData.uploadCommDoc();
        insertCommData.edit();
        insertCommData.save();
        insertCommData.pagerefresh();
        insertCommData.getListOfApprovalStage();
        insertCommData.getFileIdDelete();
            
            
        test.stoptest();         
    }
    
}