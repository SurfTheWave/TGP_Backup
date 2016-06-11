/*
  @Author: 
  @Name: operationOnAddTeam_Test
  @Created Date: 01 January 2015
  @Description: Contains code to test following batch classes
  @version: 1.0
*/
@isTest
private class operationOnAddTeam_Test{

    /*
    @name : operationOnAddTeamTest
    @Description : 
    @Version : 
    */
    static testMethod void operationOnAddTeamTest(){
        UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
        User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');
        System.runAs(testUser){
            Test.startTest();
            Map<Id,Boolean> approverRequsetUserMap;
            Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
            insert oppGrpMaster;  
            Additional_Team__c addTeamCS = new Additional_Team__c( name='BPO_Sales_Lead__c',Role_Name__c='BPO Sales Lead' );
            insert addTeamCS;
            Opportunity opp=new Opportunity();
            opp.OperatingGroup__c=OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            //opp.SAP_OM_ID__c = 'SAP4567891qwertasdfg';        
            //Opportunity opp=UTIL_DataCreationForTestClass.getOpportunity(oppGrpMaster);
            insert opp;
            Opportunity_Additional_Role_Master__c oppMaster = new Opportunity_Additional_Role_Master__c(Name = 'BPO Sales Lead', description__c = 'test Desc', ShouldBePopulatedFromSAP__c = False, active__c = True, BPO_Role__c = True, IC_Role__c = True);
            insert oppMaster;
            Opportunity_Additional_Role_Master__c oppMasterNew = new Opportunity_Additional_Role_Master__c(Name = 'Test', description__c = 'test Desc', ShouldBePopulatedFromSAP__c = False, active__c = True, BPO_Role__c = True, IC_Role__c = True);
            insert oppMasterNew;
            List<Opportunity_Additional_Team__c> approvalRequestList = new List<Opportunity_Additional_Team__c>();
            Opportunity_Additional_Team__c oppAdditonal = new Opportunity_Additional_Team__c(Additional_Opportunity_Role__c = oppMaster.Id, Opportunity__c = opp.Id, Additional_Opportunity_Team_Member__c = 'test Team Member', isChecked__c = True);
            Opportunity_Additional_Team__c oppAdditonalNew = new Opportunity_Additional_Team__c(Additional_Opportunity_Role__c = oppMasterNew.Id, Opportunity__c = opp.Id, Additional_Opportunity_Team_Member__c = 'test Team Member', isChecked__c = True);
            approvalRequestList.add(oppAdditonal);
            approvalRequestList.add(oppAdditonalNew);
            insert approvalRequestList;
            Set<id> totalOpp = new Set<id>();
            //totalOpp.add(approvalRequestList.Id);
            totalOpp.add(opp.Id);
            sd_governance_data__c sdGovData = new sd_governance_data__c(Name = 'test Goverance Data', Opportunity__c = opp.Id);
            insert sdGovData;            
            
            operationOnAddTeam.getApproverRequsetUserMap(approvalRequestList);
            operationOnAddTeam.getApproverRequsetUserMap1(approvalRequestList);
            operationOnAddTeam.getOpportunityRole(approvalRequestList);
            operationOnAddTeam.getoppTeammapIsChecked(approvalRequestList);
            operationOnAddTeam.getLatestRole(approvalRequestList);
            
            delete oppAdditonalNew;
            Test.stopTest();
        }
    }
}