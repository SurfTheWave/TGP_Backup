/**
 * Name : operationOnGovernanceTriggerController_Test
 * Author : Unit Test Generator
 * Description : Test class used for testing the operationOnGovernanceTriggerController
 * Date :
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest(seeAllData =True)
private class operationOnGovernanceController_Test { 

    /*
      @Author: 
      @Name: operationOnGovernanceTest
      @Created Date: 01 January 2015
      @Description: Creating test data to insert opportunity
      @version: 1.0
    */
    static testMethod void operationOnGovernanceTest(){
        Operating_Groups_Master__c testOpGrpMstr = new Operating_Groups_Master__c(Name = 'India',Active__c = True);
        insert testOpGrpMstr;
        //Opportunity oppObj = UTIL_DataCreationForTestClass.getOpportunity(oppGrpMaster);
        Opportunity opp = new Opportunity();
        opp.OperatingGroup__c= testOpGrpMstr.id;
        opp.name= UtilConstants.TEST_OPP;
        opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
        opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
        opp.StageName= UtilConstants.OA;
        opp.Risk_Level__c= UtilConstants.LOW;
        opp.SAP_OM_Id_Dev__c= UtilConstants.SAPIDDEV;
        opp.SAP_OM_ID__c= UtilConstants.SAPOMID; 
        opp.CloseDate = date.newInstance(2001, 3, 21);
        insert opp;
        //Database.insert(oppObj);
        
        List<SD_Governance_Data__c> lstSDGovData = new List<SD_Governance_Data__c>();
        SD_Governance_Data__c sd_governance_datacTest = new SD_Governance_Data__c(Opportunity__c = opp.id, Name = 'test SD Goverance Data', SD_Gov_Lead_Coach__c = 'test Lead Coach');
        lstSDGovData.add(sd_governance_datacTest);
        insert lstSDGovData;
        Id userID = UserInfo.getUserId();
        List<Task> lstTask = new List<Task>(); 
        Task newTask = new Task();
        newTask.OwnerId = userID;
        newTask.Subject = 'Call';
        newTask.Status = UtilConstants.COMPLETED;
        newTask.Priority = 'High';
        newTask.ActivityDate = Date.newInstance(1960, 2, 17);
        //newTask.IsRecurrence = true;
        //newTask.RecurrenceEndDateOnly = Date.today()+365;
        //newTask.RecurrenceStartDateOnly = Date.today();
        lstTask.add(newTask);        
        insert lstTask;        
        
        Test.startTest();
        operationOnGovernanceTriggerController obj = new operationOnGovernanceTriggerController();
        obj.afterInsertTaskOnGov(lstSDGovData);
        obj.afterUpdateTaskOnGov(lstSDGovData);
        obj.getBPOSalesLead(lstSDGovData);
        Test.stopTest();
    }
}