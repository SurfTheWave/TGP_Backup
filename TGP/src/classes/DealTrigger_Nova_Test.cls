/**
 * Name : DealTrigger_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the DealTrigger
 * Date : 3/20/15 5:35 PM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class DealTrigger_Nova_Test { 

Private static Offering_Master__c offeringMaster;
Private static Offering_Master__c  offeringMasterBpo;
private static Deal__c dealcTest;
/*
  @Author: 
  @Name: testDealTrigger
  @Created Date: 01 January 2015
  @Description:This is a test method testDealTrigger for insertion and deletion dealcTest.
  @version: 1.0
*/
     static testMethod  void testDealTrigger(){
        dealcTest =  new Deal__c();
        insert dealcTest;
        delete dealcTest;
        
    }
    
    /*
  @Author: 
  @Name: testDealClass
  @Created Date: 01 January 2015
  @Description: This is a test method testDealClass for insert user detail and all.
  @version: 1.0
*/
     static testmethod void testDealClass(){
        Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c(Name = 'testName',Active__c = true);
        Database.insert(OppGrpMaster); 
        
        Deal__c dealtoOpp=new Deal__C();
        insert dealtoOpp;
        /*
        Opportunity opp = new Opportunity();
         opp.OperatingGroup__c=OppGrpMaster.id;
         opp.name=UtilConstants.TEST_OPP;
         opp.Geo_Area__c=UTIL_Constants.AsiaPacific;
         opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
         opp.StageName=UtilConstants.OA;
         opp.Risk_Level__c=UtilConstants.LOW;
         opp.CloseDate= date.newInstance(2001, 3, 21);
         
         Database.insert(opp);
         
         Opportunity opp2 = new Opportunity();
         opp2.OperatingGroup__c=OppGrpMaster.id;
         opp2.name=UtilConstants.TEST_OPP;
         opp2.Geo_Area__c=UTIL_Constants.AsiaPacific;
         opp2.Reporting_Status__c=UtilConstants.UNQUALIFIED;
         opp2.StageName=UtilConstants.OA;
         opp2.Risk_Level__c=UtilConstants.LOW;
         opp2.CloseDate= date.newInstance(2001, 3, 21);
         opp.Deal__C=dealtoOpp.id;
         Database.insert(opp2);
         */
         
        offeringMaster= new Offering_Master__c(Name = UtilConstants.HR, offering_description__c = UtilConstants.TEST_DESC, 
                                                                flywheel_non_flywheel__c = UtilConstants.FLYWHEEL, Service_Group__c=UtilCOnstants.IO);
         insert offeringMaster;
         
          offeringMasterBpo= new Offering_Master__c(Name = UtilConstants.HR, offering_description__c = UtilConstants.TEST_DESC, 
                                                                flywheel_non_flywheel__c = UtilConstants.FLYWHEEL, Service_Group__c=UtilCOnstants.BPO);
         insert offeringMasterBpo;
         
         Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offeringMaster.name,offeringMaster.id);
         insert customSetting;
                                    
                                                               
         List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',2);
            Solution_Scope__c solComp = new Solution_Scope__c();
            solComp.Offering_Master__c = offeringMaster.id;
            solComp.Opportunity__c = oppList[0].Id;
            insert solComp;
            
            Solution_Scope__c solCompBpo = new Solution_Scope__c();
            solComp.Offering_Master__c = offeringMasterBpo.id;
            solComp.Opportunity__c = oppList[0].Id;
            insert solCompBpo;
            
            Opportunity opp = new Opportunity(id= oppList[0].Id);
            Opportunity opp2 = new Opportunity(id= oppList[1].Id);
         //Set<Id> opplist = new Set<Id>();
         
        dealcTest =  new Deal__c(Name = 'Test',Opportunity__c = opp.id);
        Database.insert(dealcTest);
        
        dealcTest.Opportunity__c =opp2.id;
        Database.update(dealcTest);
        
        Deal__c dealTestTwo=new Deal__C(Name='Test',opportunity__c=opp.id);
        Database.insert(dealTestTwo);
        
        Deal__C dealUpdate=[select id,Approval_Status__C,Approver__C from Deal__C where id=:dealTestTwo.id Limit 5000];
        dealUpdate.Approval_Status__C='Pending';
        Database.update(dealUpdate);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' Limit 5000]; 
        User u2 = new User(Alias = 'newUser', Email='newuser2222@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser2222@testorg.com');
       test.startTest();
        insert u2;
        test.stopTest();
        dealCtest.approver__c=u2.id;
        
        User_Master__c userMaster=new User_Master__c(user__c=u2.id);
        insert userMaster;
        dealUpdate.Approval_Status__c='Approved';
        dealUpdate.Approver__C=u2.id;
        Database.update(dealUpdate);
        List<Deal__c> dealList = new List<Deal__c>();
        dealList.add(dealcTest);
        //opplist.add(dealcTest.Opportunity__c);
        Deal.updateOpportunity(dealList,true);
        Deal.createTask(dealList);
        Deal.shareDealRecord(dealList);
     }
/*
  @Author: 
  @Name: testCSP
  @Created Date: 01 January 2015
  @Description:This is a test method testCSP for testing client_specific_process method.
  @version: 1.0
*/     
      static testMethod void testCSP(){

        
         Services_Master__c service = new Services_Master__c(name= UtilConstants.HR,offering__c=offeringMaster.id);
         insert service;
         
         Services_Master__c serviceBpo = new Services_Master__c(name= UtilConstants.HR,offering__c=offeringMasterBpo.id);
         insert service;
         
         Deal__c deal=new Deal__c(name='test');
         insert deal;
        
         Client_Specific_Process__c clientProcess=new Client_Specific_Process__c(Process_Offering__c=offeringMasterBpo.id, Process_Services__c=serviceBpo.id, Deal__c=dealcTest.id);
         insert clientProcess;
         
         Infrastructure_Service__c infrastructureSP=new Infrastructure_Service__c(ServiceOffering__c=offeringMaster.id,SubService__c=service.id,
                                                Deal__c=dealcTest.id );
        insert infrastructureSP;
         
     }
}