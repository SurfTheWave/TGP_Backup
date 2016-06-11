/*
Author : Harshit Shah
Story  :   SOL_082
Description :Test Class for the Opp_Team_Controller Controller.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class opportunityTeamTriggerController_Test{
    static User testUser; 
    static Review_User_Master__c reviewUserMaster;
  //   static List<Review_User_Master__c> reivewlist = new List<Review_User_Master__c>();
    static Client_Master__c  clientName ;
    static Opportunity_Team__c oppTeamRecord = new Opportunity_Team__c();
     static Opportunity_Team__c oppTeamRecord2 = new Opportunity_Team__c();
     static Opportunity_Team__c oppTeamRecord3 = new Opportunity_Team__c();
    static Opportunity_Team__c oppTeamRecord1 = new Opportunity_Team__c();
    static List<Opportunity_Team__c> oppTeamRecord1List = new List<Opportunity_Team__c>();
    static Offerings_Master__c offeringMaster;
    static Opportunity_TGP__c oppTGP;
    static Opportunity_Role_master__c oppRole;
    static Opportunity_Role_master__c oppRole1;
    static Opportunity_Offering__c oppOffering;  
    
    public static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        reviewUserMaster = UTIL_DataCreationForTestClass.getReviewUserMaster('abc@xyz.com',UTIL_Constants.USER_NAME);
        reviewUserMaster.SFDC_User__c = testUser.Id;
        reviewUserMaster.Is_Active__c = true;
        Database.insert(reviewUserMaster, false);
        clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
        insert clientName;
        
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Activity__c='1-Active',Enterprise_Solution_Architect_New__c=reviewUserMaster.Id,
                  Oppotunity_QA__c='ShridharTest');
        insert oppTGP;
        
        oppRole = new Opportunity_Role_master__c(Name = 'Mobilization Architect',Is_Offering_Based__c = false);
        insert oppRole;
        
        oppRole1 = new Opportunity_Role_master__c(Name = 'Complex Cost Architect',Is_Offering_Based__c = false);
        insert oppRole1;
        
        offeringMaster = new Offerings_Master__c (Name = 'Capital Project Management',Active__c = true);
        insert offeringMaster;
        
        oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.Id);
        insert oppOffering;
        
        oppTeamRecord.BPO_Opportunity__c = oppTGP.Id;
        oppTeamRecord.Offering__c = null;
        oppTeamRecord.Roles__c = oppRole1.Id;
        oppTeamRecord.Opportunity_Team_Member__c = reviewUserMaster.Id;        
       
        oppTeamRecord2 = new Opportunity_Team__c();
        oppTeamRecord2 .BPO_Opportunity__c = oppTGP.Id;
        oppTeamRecord2 .Offering__c = offeringMaster .Id;
        oppTeamRecord2 .Roles__c = oppRole1.Id;
        oppTeamRecord2 .Opportunity_Team_Member__c = reviewUserMaster.Id; 
        oppTeamRecord1List.add(oppTeamRecord2);
        
        oppTeamRecord3 = new Opportunity_Team__c();
        oppTeamRecord3 .BPO_Opportunity__c = oppTGP.Id;
        oppTeamRecord3 .Offering__c = offeringMaster .Id;
        oppTeamRecord3 .Roles__c = oppRole1.Id;
        oppTeamRecord3 .Opportunity_Team_Member__c = reviewUserMaster.Id; 
        oppTeamRecord1List.add(oppTeamRecord3);
        
        insert oppTeamRecord1List;
        insert oppTeamRecord;
        
        Governance_Data__c govRec = new Governance_Data__c ();
        govRec.Opportunity_TGP__c = oppTGP.id;
        
        insert govRec;
                
     oppTeamRecord.Roles__c = oppRole1.Id;
        
      update oppTeamRecord;
    }
    public static void setupData1(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        reviewUserMaster = UTIL_DataCreationForTestClass.getReviewUserMaster('abc@xyz.com',UTIL_Constants.USER_NAME);
        reviewUserMaster.SFDC_User__c = testUser.Id;
        reviewUserMaster.Is_Active__c = true;
        Database.insert(reviewUserMaster, false);
        clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
        insert clientName;
        
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Activity__c='1-Active',Enterprise_Solution_Architect_New__c=reviewUserMaster.Id,
                  Oppotunity_QA__c='ShridharTest');
        insert oppTGP;
        
        oppRole = new Opportunity_Role_master__c(Name = 'Test Role',Is_Offering_Based__c = false);
        insert oppRole;
        
        oppRole1 = new Opportunity_Role_master__c(Name = 'Complex Cost Architect',Is_Offering_Based__c = false);
        insert oppRole1;
        
        offeringMaster = new Offerings_Master__c (Name = 'Capital Project Management',Active__c = true);
        insert offeringMaster;
        
        oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.Id);
        insert oppOffering;
        
        oppTeamRecord1.BPO_Opportunity__c = oppTGP.Id;
        oppTeamRecord1.Offering__c = offeringMaster.id;
        oppTeamRecord1.Roles__c = oppRole.Id;
        oppTeamRecord1.Opportunity_Team_Member__c = reviewUserMaster.Id;
        
        insert oppTeamRecord1;
                
     oppTeamRecord1.Roles__c = oppRole1.Id;
        
      update oppTeamRecord1;
    }

    
    static testMethod void testOpportunityTeamTriggerController(){   
       
       setupData();
       Test.starttest();
       PageReference pageRef= Page.insertNewopportunity;
       pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
       Test.setCurrentPageReference(pageRef);
       ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
       System.runAs(testUser) {
           Opp_Team_Controller Opp_Team_ControllerInstance = new Opp_Team_Controller(controller);
           Pagereference p1;
           Pagereference p2;
           Pagereference p3;
           
           Opp_Team_ControllerInstance.getOfferings();
           Opp_Team_ControllerInstance.getRoles();
           Opp_Team_ControllerInstance.getlocations();
           Opp_Team_ControllerInstance.edit();
                     
          // Opp_Team_ControllerInstance.oppTeam.BPO_Opportunity__c = oppTGP.Id;
           Opp_Team_ControllerInstance.oppTeam.Offering__c = oppOffering.Id;
           Opp_Team_ControllerInstance.oppTeam.Roles__c = oppRole1.Id;
           Opp_Team_ControllerInstance.oppTeam.Opportunity_Team_Member__c = reviewUserMaster.Id;
           
           p1 = Opp_Team_ControllerInstance.addOppTeam();
           
           String temp = oppTeamRecord.Id;
           Opp_Team_ControllerInstance.setFileIdDelete(temp);
           Opp_Team_ControllerInstance.getFileIdDelete();
           p2 = Opp_Team_ControllerInstance.pagerefresh();
           p3 = Opp_Team_ControllerInstance.deleteFile();
           Opp_Team_ControllerInstance.saverecordForOppTeam();
           
       }
       Test.stoptest();
    }  
    static testMethod void Method1(){   
      
       setupData1();
        Test.starttest();
       PageReference pageRef= Page.insertNewopportunity;
       pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
       Test.setCurrentPageReference(pageRef);
       ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
       System.runAs(testUser) {
           Opp_Team_Controller Opp_Team_ControllerInstance = new Opp_Team_Controller(controller);
           Pagereference p1;
           Pagereference p2;
           Pagereference p3;
           
           Opp_Team_ControllerInstance.getOfferings();
           Opp_Team_ControllerInstance.getRoles();
           Opp_Team_ControllerInstance.getlocations();
           Opp_Team_ControllerInstance.edit();
                     
          // Opp_Team_ControllerInstance.oppTeam.BPO_Opportunity__c = oppTGP.Id;
           Opp_Team_ControllerInstance.oppTeam.Offering__c = oppOffering.Id;
           Opp_Team_ControllerInstance.oppTeam.Roles__c = oppRole1.Id;
           Opp_Team_ControllerInstance.oppTeam.Opportunity_Team_Member__c = reviewUserMaster.Id;
           
           p1 = Opp_Team_ControllerInstance.addOppTeam();
           
           String temp = oppTeamRecord.Id;
           Opp_Team_ControllerInstance.setFileIdDelete(temp);
           Opp_Team_ControllerInstance.getFileIdDelete();
           p2 = Opp_Team_ControllerInstance.pagerefresh();
           p3 = Opp_Team_ControllerInstance.deleteFile();
           Opp_Team_ControllerInstance.saverecordForOppTeam();
           
       }
       Test.stoptest();
    }  
    
}