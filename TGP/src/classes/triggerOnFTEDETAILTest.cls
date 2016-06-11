/*
Author : Rajdeep Bhuiya
Story  : Release 2.0  
Description : Test Class for triggerOnFTEDETAIL. 
*/

@isTest
/*
  @Author: 
  @Name: triggerOnFTEDETAILTest 
  @Created Date: 01 January 2015
  @Description:This is a test class for trigger on FTEDETAIL.
  @version: 1.0
*/
private class triggerOnFTEDETAILTest { 
/*
  @Author: 
  @Name: testtriggerOnFTEDETAIL
  @Created Date: 01 January 2015
  @Description:This is a test method for trigger on FTEDETAIL.
  @version: 1.0
*/     
    static testMethod  void testtriggerOnFTEDETAIL(){
        
        Operating_Groups_Master__c oppOperatingGrup = UnitTestDatafactory.createOperatingGroup('India');
        
        Opportunity opp= UTIL_DataCreationForTestClass.getOpportunity(oppOperatingGrup);
        insert(opp);
        
        Offering_Master__c offMaster=UTIL_DataCreationForTestClass.getOfferingwithProcurement();
        insert offMaster; 
        
        Offering_Name__c offCustomObj =UTIL_DataCreationForTestClass.getOfferingNamewithProcurement(offMaster);
        insert(offCustomObj);
        
        Solution_Scope__c solComp = UTIL_DataCreationForTestClass.getSolutionComp(opp,offMaster);
        insert(solComp);
        
        Services_Master__c serMaster= UTIL_DataCreationForTestClass.getServiceMasterWithoutALL(offMaster);
        insert(serMaster); 
        
        Service__c servObj = new Service__c(Solutionscope__c = solComp.id,services__c=serMaster.id);
        insert(servObj);
        
        FTE_Details__c fte_detailscTest =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);
        
        insert fte_detailscTest;
        
   }     
}