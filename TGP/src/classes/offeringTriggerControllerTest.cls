/*  
 *  Test class for After Insert, After update, before delete, before insert, before update trigger for Opportunity_Offering__c . 
 *  
 * 
 *  @author - Accenture Team 
 *  @date create - 25/2/2014
 *  @version - 0.1 
 */


@isTest
private class offeringTriggerControllerTest{

    private static List<Opportunity_Offering__c> offList = new List<Opportunity_Offering__c>();
    private static List<Opportunity_Offering__c> newOffList = new List<Opportunity_Offering__c>();
    private static Client_Master__c clientName;
    private static Client_Geo_Area_Master__c clientGeoArea;
    private static Operating_Group_Master__c operatingGroup;
    private static Opportunity_Offering__c offRec;
    private static Opportunity_Offering__c offRec1;
    private static Opportunity_TGP__c oppRec;
    private static Opportunity_Offering__c newOffRec;
    private static User u;
    private static User u1;
    private static Profile p;
    private static Profile p1;
    private static Offerings_Master__c offMaster;
    private static string USER_NAME = 'vc12@testorg.com';
    private static string USER_NAME_NEW = 'vc13@testorg.com';
    private static final string OFF_NAME = 'test';
    static Review_User_Master__c revUser;
    static Review_User_Master__c revUser1;
    
     /*
    *   @Method : setupData
    *   @ Description : This method will create test data
    */
     public static void setupData(){
     
        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        
        p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        
        u =UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
        Database.insert(u, false);
        
        u1 =UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_NAME_NEW);
        Database.insert(u1, false);
        
        revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('abc@accenture.com','sophia prem kumar');
      revUser.SFDC_User__c = u.id;
      revUser.Is_Active__c = true;
      insert revUser ;
      
      revUser1 = UTIL_DataCreationForTestClass.getReviewUserMaster('abc123@accenture.com','sophia');
      revUser1.SFDC_User__c = u1.id;
      revUser1.Is_Active__c = true;
      insert revUser1 ;

        clientName = UTIL_DataCreationForTestClass.getClientMaster(UTIL_Constants.CLIENT_MASTER);
        Database.insert(clientName, false);
        
        clientGeoArea = UTIL_DataCreationForTestClass.getClientGEOAreaMaster(UTIL_Constants.AsiaPacific);
        Database.insert(clientGeoArea, false);
        
        operatingGroup = UTIL_DataCreationForTestClass.getOperatingGroupMaster(UTIL_Constants.OPERATING_GRP_MASTER_NAME,true);
        Database.insert(operatingGroup, false);
        
        oppRec = UTIL_DataCreationForTestClass.getBPOOpportunityRecord(UTIL_Constants.OPP_NAME,UTIL_Constants.STAGE,clientName.id,clientGeoArea.id,operatingGroup.id,UTIL_Constants.RISK_LEVEL,true,UTIL_Constants.REPORTING_STATUS);
        Database.insert(oppRec, false);
        
        
         
     }
     
    /*
    *   @Method : testofferingTriggerControllerForInsert
    *   @ Description : This method will insert offering record.
    */
    static testMethod void testofferingTriggerControllerForInsert(){
        
        offeringTriggerController classObj=new offeringTriggerController();
        setupData();
        test.starttest();
        System.runAs(u1)
        {
        
            offRec = UTIL_DataCreationForTestClass.getOfferingRecord(UTIL_Constants.OFFERING_NAME,oppRec.id);
            Database.insert(offRec, false);
            
        }
        Test.stopTest();
    }
    
    /*
    *   @Method : testofferingTriggerControllerForUpdate
    *   @ Description : This method will update offering record.
    */
    static testMethod void testofferingTriggerControllerForUpdate(){
        setupData();
        test.starttest();
        //System.runAs(u1)
        //{ 
       
            offRec = UTIL_DataCreationForTestClass.getOfferingRecord(UTIL_Constants.OFFERING_NAME,oppRec.id);
            offRec.Solution_Specialist_New__c = revUser.id;
            insert offRec;  
            
            Solution_User_Assignment__c solRec = new Solution_User_Assignment__c(BPO_Opportunity__c = oppRec.id,Offering_Id__c = offRec.id);
            solRec.Resource_Assigned_User_New__c = revUser.id;
            solRec.Role__c = UTIL_Constants.MOBILIZATION_ARCHITECT ;
            insert solRec;
            
            
            
             
            
            Solution_User_Assignment__c solRec1 = new Solution_User_Assignment__c(BPO_Opportunity__c = oppRec.id,Offering_Id__c = offRec.id);
            solRec1.Resource_Assigned_User_New__c = revUser.id;
            solRec1.Role__c = UTIL_Constants.TECHNICAL_ARCHITECT ;
            insert solRec1;
            
                                           
            offRec.Offering_Text_Name__c = OFF_NAME;
            offRec.Solution_Specialist_New__c = revUser1.id;
            update offRec;
            
            
            

            
        //}
        Test.stopTest();

    }
    
    /*
    *   @Method : testofferingTriggerControllerForDelete
    *   @ Description : This method will delete offering record.
    */
    static testMethod void testofferingTriggerControllerForDelete(){ 
    setupData();
        test.starttest();
        //System.runAs(u)
        //{ 
      
            offRec = UTIL_DataCreationForTestClass.getOfferingRecord(UTIL_Constants.OFFERING_NAME,oppRec.id);
            insert offRec;
            
            delete offRec;

        
       // }  
      Test.stopTest();

        
       }     
        
    
}