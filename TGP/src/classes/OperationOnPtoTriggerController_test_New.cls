/******************************
   @Author       : 
   @Class name   : OperationOnPtoTriggerController_test_New
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
@isTest
private class OperationOnPtoTriggerController_test_New{

     /******************************
     * Method Name: testPositivepto
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
    static testMethod void testPositivepto(){
    
        date myDate = date.today();
        date weekStart = myDate.toStartofWeek();
        
         
         Opportunity opp = new Opportunity();
            Operating_Groups_Master__c oppOperatingGrup = UnitTestDatafactory.createOperatingGroup(UtilConstants.INDIA);
            opp.OperatingGroup__c = oppOperatingGrup.id;
            opp.name = UtilConstants.OUT_OF_OFFICE;
            opp.Geo_Area__c = UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c = UtilConstants.UNQUALIFIED;
            opp.StageName = UtilConstants.OA;
            opp.Risk_Level__c = UtilConstants.LOW;
            opp.SAP_OM_Id_Dev__c = UtilConstants.SAPIDDEV;
            opp.SAP_OM_ID__c = UtilConstants.SAPOMID;
            opp.CloseDate = date.newInstance(2001, 3, 21);
            insert opp;
            
        //system.debug('week start date----------->'+weekStart);
        
        Utilization_weekStartDate__c utilcustomsettings = new Utilization_weekStartDate__c();
        utilcustomsettings.name = UtilConstants.MONDATE;
        utilcustomsettings.Referenced_Date__c = weekStart;
        insert utilcustomsettings;
        user_master__c us = new user_master__c(name='test user master',user__c=userinfo.getUserId(),email__c=userinfo.getUserEmail());
        insert us;
        utilizations__c utils = new utilizations__c();
        utils.Name = 'test utilization';
        utils.User__c = us.id;
        utils.opportunity__c = opp.id;
        insert utils;
        
        pto__c pt_rec = new pto__c();
        pt_rec.name = 'test pto';
        pt_rec.PTO_Start__c=system.today();
        pt_rec.PTO_End__c = system.today()+30;
        pt_rec.user__c=us.id;
        pt_rec.Utilization__c = utils.id;
        test.startTest();
        insert pt_rec;      
        test.stopTest();
    }    
}