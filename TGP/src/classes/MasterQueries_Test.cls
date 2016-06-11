@isTest
private class MasterQueries_Test{
    static testMethod void MasterQueriesTestMethod(){
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm; 
        Set<ID> OppId=new Set<ID>();
        Opportunity opp = new Opportunity();
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        OppId.add(opp.ID);
        insert opp;
        
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        insert offProc;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
        Services_Master__c serviceMaster = new Services_Master__c(Name = UtilConstants.HRSERVICE, offering__c = offProc.id, active__c = True,Solution_Component__c = UtilConstants.DELIVERY);
        insert serviceMaster;
        Geo_Region_Master__c georegion = new Geo_Region_Master__c ();
        georegion.name = 'North America';
        georegion.active__C=True;
        insert georegion;
        Country_Master__c country = new Country_Master__c();
        country.name ='Test Country';
        country.Geo_Region__c = georegion.id;
        insert country;
        Delivery_Location_Masters__c delloc = new Delivery_Location_Masters__c();
        delloc.name = 'Test delivery location';
        delloc.country__c=country.id;
        insert delloc;
        
        test.startTest();
        MasterQueries.findAllActiveOffMasters();
        MasterQueries.findAllServiceMasters_Delivery();
        MasterQueries.findallOppFromSolscope(OppId);
        MasterQueries.findallOppFromService(OppId);
        MasterQueries.findallActiveSerMasters();
        MasterQueries.oppsAftInstTrig(OppId);
        MasterQueries.queryoppdeliveryloc(OppId);
        MasterQueries.querydeliverylocs(OppId);
        MasterQueries.oppsAftUpdTrig(OppId);
        MasterQueries.findallGeoRegionMasters();
        MasterQueries.querycountrymasters();
        MasterQueries.querydeliverymasters();
        test.stopTest();
        }
}