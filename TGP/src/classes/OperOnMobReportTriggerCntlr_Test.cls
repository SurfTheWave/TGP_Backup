/******************************
   @Author       : 
   @Class name   : OperOnMobReportTriggerCntlr_Test
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
@isTest
private class OperOnMobReportTriggerCntlr_Test{
     
     /******************************
     * Method Name: testAfterInsert
     * Description: test data setup for Operation on Mobilization report trigger functionality testing
     * Paramenters: 
     * Return Value: 
     *******************************/ 
    public static testMethod void testAfterInsert(){
           
         Offering_Master__c off1 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Human Resources',offering_description__c='test desc',flywheel_non_flywheel__c='test F');
         insert off1;
         String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + off1.Id;
         Report_Master__c repMaster = new Report_Master__c(Active__c=true,Report_Description__c='test report master description',Report_ID__c=off1.Id,Report_URL__c=fullRecordURL );
         insert repMaster;
         Account acc = new Account(name='test Account');
         insert acc;
         UnitTestDatafactory.createOpportunityRecord('Test Opp');  
         Opportunity opp = [Select id from Opportunity where name='Test Opp' Limit 500];
         FlagCheck__c flgCheck = new FlagCheck__c(name='test',FieldOne__c=true);
         insert flgCheck;
         Deal__c deal = new Deal__c(name='test deal',Client__c=acc.Id,Opportunity__c=opp.Id);
         insert deal;
         Geo_Region_Master__c geoRegionMaster = new Geo_Region_Master__c(name='Geo Region Master',Active__c=true);
         insert geoREgionMaster;
         Country_Master__c countryMaster = new Country_Master__c(active__c = true,name='test country master',Geo_Region__c = geoREgionMaster.Id);
         insert countryMaster;
         Delivery_Location_Masters__c delLocMaster = new Delivery_Location_Masters__c(name='test del Location',active__c=true,country__c=countryMaster.Id,delivery_location_description__c='test desc');
         insert delLocMaster;
        Mob_Reports__c mobReport = new Mob_Reports__c( name= 'test Sol Report',Deal__c=deal.Id,Report_Master__c= repMaster.ID);
        test.startTest();
        insert mobReport;
        test.stopTest();
    }
    
    
    }