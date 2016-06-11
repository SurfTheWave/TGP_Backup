/*
Author : Komal Priya  
Description :Test class for all the trigger operations on opportunity.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
@isTest
private class OpportunityTriggerControllerTest{

    private static Client_Master__c clientName;
    private static Client_Geo_Area_Master__c clientGeoArea;
    private static Client_Geo_Area_Master__c clientGeoAreaRec;
    private static Operating_Group_Master__c operatingGroup;
    private static Opportunity_Offering__c offRec;
    private static Opportunity_TGP__c oppRec;
    private static Profile p;
    private static User u;
    private static User u1;
    private static final string STAGE_VALUE = 'stage2';
    private static string USER_NAME = 'vc123@testorg.com';
    static Review_User_Master__c revUser;
    static Review_User_Master__c revUser1;
    //private static List<Opportunity_TGP__c > oppList = new List<Opportunity_TGP__c >();
    
    /*
    *   @Method : setupData
    *   @ Description : This method will create test data
    */
     static void setupData(){
     
        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        
        u =UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        insert u;
        
        u1 =UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
        insert u1;
        
        revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('abc@accenture.com','sophia prem kumar');
        revUser.SFDC_User__c = u.id;
        revUser.Is_Active__c = true;
        insert revUser ;
      
        revUser1 = UTIL_DataCreationForTestClass.getReviewUserMaster('abc123@accenture.com','sophia');
        revUser1.SFDC_User__c = u1.id;
        revUser1.Is_Active__c = true;
        insert revUser1 ;
          
        clientName = UTIL_DataCreationForTestClass.getClientMaster(UTIL_Constants.CLIENT_MASTER);
        insert clientName;
        
        clientGeoAreaRec = UTIL_DataCreationForTestClass.getClientGEOAreaMaster(UTIL_Constants.EALA);
        insert clientGeoAreaRec;
        
        clientGeoArea = UTIL_DataCreationForTestClass.getClientGEOAreaMaster(UTIL_Constants.APAC);
        insert clientGeoArea;
        
        operatingGroup = UTIL_DataCreationForTestClass.getOperatingGroupMaster(UTIL_Constants.OPERATING_GRP_MASTER_NAME,true);
        insert operatingGroup;
                              
    }
    
     /*
    *   @Method : testOpportunityTriggerControllerForInsert
    *   @ Description : This method will insert Opportunity record.
    */
    static testMethod void testOpportunityTriggerControllerForInsert(){
    
        setupData();
        test.starttest();
        System.runAs(u)
        {
        
            oppRec = UTIL_DataCreationForTestClass.getBPOOpportunityRecord(UTIL_Constants.OPP_NAME,UTIL_Constants.STAGE,clientName.id,clientGeoArea.id,operatingGroup.id,UTIL_Constants.RISK_LEVEL,true,Util_Constants.PIPELINE);
            oppRec.Complex_Cost_Architect__c = u.id;
            insert oppRec ; 
            
        }      
        test.stoptest();
        List<Opportunity_TGP__c> oppRecList = [select Name ,id from Opportunity_TGP__c where id = : oppRec.id limit 50];
        System.assertEquals(oppRecList[0].name,UTIL_Constants.OPP_NAME);
     }
     
     /*
    *   @Method : testOpportunityTriggerControllerForUpdate
    *   @ Description : This method will update Opportunity record.
    */
     static testMethod void testOpportunityTriggerControllerForUpdate(){
    
        setupData();
        test.starttest();
        System.runAs(u)
        {
            oppRec = UTIL_DataCreationForTestClass.getBPOOpportunityRecord(UTIL_Constants.OPP_NAME,UTIL_Constants.STAGE,clientName.id,clientGeoArea.id,operatingGroup.id,UTIL_Constants.RISK_LEVEL,true,UTIL_Constants.REPORTING_STATUS);
            oppRec.Complex_Cost_Architect_New__c = revUser1.id;
            insert oppRec;
            
            oppRec.Stage__c = STAGE_VALUE;
            oppRec.Complex_Cost_Architect_New__c = revUser.id;
            oppRec.Client_Geo_Area__c = clientGeoAreaRec.id;
            update oppRec;
            
            
            
            oppRec = UTIL_DataCreationForTestClass.getBPOOpportunityRecord(UTIL_Constants.OPP_NAME,UTIL_Constants.STAGE,clientName.id,clientGeoArea.id,operatingGroup.id,UTIL_Constants.RISK_LEVEL,true,UTIL_Constants.REPORTING_STATUS);
            oppRec.Complex_Cost_Architect_New__c = revUser1.id;
            Database.insert(oppRec, false);
            
            oppRec.Stage__c = STAGE_VALUE;
            oppRec.Complex_Cost_Architect_New__c = revUser.id;
            Database.update(oppRec, false);
        }       
        test.stoptest();
        List<Opportunity_TGP__c> oppRecList = [select Name ,Stage__c ,id from Opportunity_TGP__c where id = : oppRec.id limit 50];
        System.assertEquals(oppRecList[0].Stage__c,STAGE_VALUE);
     }
     
     /*
    *   @Method : testOpportunityTriggerControllerForDelete
    *   @ Description : This method will delete Opportunity record.
    */
     static testMethod void testOpportunityTriggerControllerForDelete(){
    
        setupData();
        test.starttest();
        System.runAs(u)
        {
            oppRec = UTIL_DataCreationForTestClass.getBPOOpportunityRecord(UTIL_Constants.OPP_NAME,UTIL_Constants.STAGE,clientName.id,clientGeoArea.id,operatingGroup.id,UTIL_Constants.RISK_LEVEL,true,UTIL_Constants.REPORTING_STATUS);
            Database.insert(oppRec, false);
            
            delete oppRec;
            
        }      
        test.stoptest();
        List<Opportunity_TGP__c> oppRecList = [select Name ,Stage__c ,id from Opportunity_TGP__c where id = : oppRec.id limit 50];
        System.assertEquals(oppRecList.size(),0);
     }
}