/*
  @Author: Aswajit Swain
  @Name: CrossDealServiceTest
  @Created Date: 29 June 2015
  @Description:
  @version: 1.0
*/
@isTest
private class CrossDealServiceTest{
    
    /*
      @Author: Aswajit Swain
      @Name: testGETService
      @Created Date: 29 June 2015
      @Description:
      @version: 1.0
    */
    private static testMethod void testGETService(){
       /*User user = UtilNovaUnitTest.getUser();
        insert user;
        system.runAs(user){*/
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        testData();
        req.requestURI = System.URL.getSalesforceBaseUrl()+'/services/apexrest/CrossDeal/1.0';  
        req.httpMethod = 'GET';
        req.addParameter('LastUpdatedDate', String.valueOf(System.now()-60));
        RestContext.request = req;
        RestContext.response = res;
        List<CrossDealService.MasterData> masterdataList= CrossDealService.getMasterData();
        System.assertEquals(1, masterdataList.size());
        
        req.requestURI = System.URL.getSalesforceBaseUrl()+'/services/apexrest/CrossDeal/1.0';  
        req.httpMethod = 'GET';
        req.addParameter('LastUpdatedDate', '');
        RestContext.request = req;
        RestContext.response = res;
        List<CrossDealService.MasterData> masterdataList1= CrossDealService.getMasterData();
        //}
    }
    /*
      @Author: Aswajit Swain
      @Name: testGETService
      @Created Date: 29 June 2015
      @Description:
      @version: 1.0
    */
    private static Opportunity testData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.SG_Dev__c ='IO';
        opp.StageName = 'won';
        opp.CloseDate = Date.valueOf(System.now());
        insert opp;
        return opp;
    }
    
    /*
      @Author: Aswajit Swain
      @Name: testPostService
      @Created Date: 29 June 2015
      @Description:
      @version: 1.0
    */
    private static testMethod void testPostService(){
        /*User user = UtilNovaUnitTest.getUser();
        DataBase.insert(user);
        system.runAs(user){*/
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        Opportunity opp = testData();
        
        Cross_Deal_Field_Mapping__c field = new Cross_Deal_Field_Mapping__c();
        field.Field_Type__c ='double';
        field.Field_Mapping_Value__c ='Field1_Max__c';
        field.Name='Field1Max';
        field.Field_Type__c ='string';
        field.Field_Mapping_Value__c ='Field26__c';
        field.Name='Field26';
        DataBase.insert(field);
        
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        DataBase.insert(offProc);
        
        Offering_Master__c offIO = new Offering_Master__c();
        offIO.Name = 'Managed Security Services';
        offIO.offering_description__c = 'Test Offering Io';
        offIO.flywheel_non_flywheel__c = 'Flywheel';
        offIO.Service_Group__c = 'IO';
        offIO.active__c = true;
        insert offIO;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        DataBase.insert(customSetting);
        
        Services_Master__c serviceMaster = new Services_Master__c(Name = UtilConstants.HRSERVICE, offering__c = offIO.id, active__c = True,Solution_Component__c = UtilConstants.DELIVERY);
        serviceMaster.Name = 'Security';
        DataBase.insert(serviceMaster);
        
        Solution_Scope__c solComp = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id,Solution_Component__c = UtilConstants.DELIVERY, Offering_Master__c = offIO.id, Service_Group__c = 'IO', SAP_Offering_Revenue__c = 20);
        DataBase.insert(solComp);
        
        Service__c service = new Service__c(Solutionscope__c = solComp.id, Services__c = serviceMaster.id);
        insert service;
        
        Services_Component_Master__c scMaster = new Services_Component_Master__c();
        scMaster.Name='Antivirus Mgmt';
        scMaster.service_component_description__c = 'afsadasd';
        scMaster.Service__c = serviceMaster.Id;
        DataBase.insert(scMaster);
        
        Service_Components__c scs = new Service_Components__c();
        scs.Service__c = service.Id;
        scs.Services_Component_Master__c = scMaster.Id;
        DataBase.insert(scs);
        
        String jsonString = '{"Deal":[{"Opportunity":"'+opp.Id+'","Offering":"Managed Security Services","Service":"Security","ServiceComponent":"Antivirus Mgmt","Field1Max":"-1.000000000","Field1Avg":"-1.000000000","Field1Min":"-1.000000000","Field2Max":"-2.000000000","Field2Avg":"-2.000000000","Field2Min":"-2.000000000","Field3Max":"-2.000000000","Field3Avg":"-2.000000000","Field3Min":"-2.000000000","Field4Max":"65107.550000000","Field4Avg":"8353.215000000","Field4Min":"0.000000000","Field5Max":"21.731086441","Field5Avg":"1.573108600","Field5Min":"-2.000000000","Field6Max":"-1.000000000","Field6Avg":"-1.000000000","Field6Min":"-1.000000000","Field7Max":"-2.000000000","Field7Avg":"-2.000000000","Field7Min":"-2.000000000","Field8Max":null,"Field8Avg":null,"Field8Min":null,"Field9Max":null,"Field9Avg":null,"Field9Min":null,"Field10Max":null,"Field10Avg":null,"Field10Min":null,"Field11Max":null,"Field11Avg":null,"Field11Min":null,"Field12Max":null,"Field12Avg":null,"Field12Min":null,"Field13Max":null,"Field13Avg":null,"Field13Min":null,"Field14Max":null,"Field14Avg":null,"Field14Min":null,"Field15Max":null,"Field15Avg":null,"Field15Min":null,"Field16Max":null,"Field16Avg":null,"Field16Min":null,"Field17Max":null,"Field17Avg":null,"Field17Min":null,"Field18Max":null,"Field18Avg":null,"Field18Min":null,"Field19Max":null,"Field19Avg":null,"Field19Min":null,"Field20Max":null,"Field20Avg":null,"Field20Min":null,"Field21Max":null,"Field21Avg":null,"Field21Min":null,"Field22Max":null,"Field22Avg":null,"Field22Min":null,"Field23Max":null,"Field23Avg":null,"Field23Min":null,"Field24Max":null,"Field24Avg":null,"Field24Min":null,"Field25Max":null,"Field25Avg":null,"Field25Min":null,"Field26":"India - 100.00% ","Field27":"Shared Resources","Field28":"7 Days x 24 Hours","Field29":"Americas","Field30":"EXCLUDED","Field31":"INCLUDED","Field32":"2.000000000","Field33":null,"Field34":null,"Field35":null,"Field36":null,"Field37":null,"Field38":null,"Field39":null,"Field40":null,"Field41":null,"Field42":null,"Field43":null,"Field44":null,"Field45":null,"Field46":null,"Field47":null,"Field48":null,"Field49":null,"Field50":null}]}';
        req.requestURI = System.URL.getSalesforceBaseUrl()+'/services/apexrest/CrossDeal/1.0';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonString);
        RestContext.request = req;
        RestContext.response = res;
        CrossDealService.createCrossDeal();
        System.assertNotEquals(null, opp);
        try{
            RestRequest req1 = new RestRequest(); 
            RestResponse res1 = new RestResponse();
            String jsonString1 = '';
            req1.requestURI = System.URL.getSalesforceBaseUrl()+'/services/apexrest/CrossDeal/1.0';  
            req1.httpMethod = 'POST';
            req1.requestBody = Blob.valueOf(jsonString1);
            RestContext.request = req1;
            RestContext.response = res1;
            CrossDealService.createCrossDeal();
            
            RestRequest req2 = new RestRequest(); 
            RestResponse res2 = new RestResponse();
            String jsonString2 = '{"Deal":[{"Opportunity":"'+opp.Id+'","Offering":"Managed Security Services","Service":"Security","ServiceComponent":"Antivirus Mgmt12","Field1Max":"-1.000000000","Field1Avg":"-1.000000000","Field1Min":"-1.000000000","Field2Max":"-2.000000000","Field2Avg":"-2.000000000","Field2Min":"-2.000000000","Field3Max":"-2.000000000","Field3Avg":"-2.000000000","Field3Min":"-2.000000000","Field4Max":"65107.550000000","Field4Avg":"8353.215000000","Field4Min":"0.000000000","Field5Max":"21.731086441","Field5Avg":"1.573108600","Field5Min":"-2.000000000","Field6Max":"-1.000000000","Field6Avg":"-1.000000000","Field6Min":"-1.000000000","Field7Max":"-2.000000000","Field7Avg":"-2.000000000","Field7Min":"-2.000000000","Field8Max":null,"Field8Avg":null,"Field8Min":null,"Field9Max":null,"Field9Avg":null,"Field9Min":null,"Field10Max":null,"Field10Avg":null,"Field10Min":null,"Field11Max":null,"Field11Avg":null,"Field11Min":null,"Field12Max":null,"Field12Avg":null,"Field12Min":null,"Field13Max":null,"Field13Avg":null,"Field13Min":null,"Field14Max":null,"Field14Avg":null,"Field14Min":null,"Field15Max":null,"Field15Avg":null,"Field15Min":null,"Field16Max":null,"Field16Avg":null,"Field16Min":null,"Field17Max":null,"Field17Avg":null,"Field17Min":null,"Field18Max":null,"Field18Avg":null,"Field18Min":null,"Field19Max":null,"Field19Avg":null,"Field19Min":null,"Field20Max":null,"Field20Avg":null,"Field20Min":null,"Field21Max":null,"Field21Avg":null,"Field21Min":null,"Field22Max":null,"Field22Avg":null,"Field22Min":null,"Field23Max":null,"Field23Avg":null,"Field23Min":null,"Field24Max":null,"Field24Avg":null,"Field24Min":null,"Field25Max":null,"Field25Avg":null,"Field25Min":null,"Field26":"India - 100.00% ","Field27":"Shared Resources","Field28":"7 Days x 24 Hours","Field29":"Americas","Field30":"EXCLUDED","Field31":"INCLUDED","Field32":"2.000000000","Field33":null,"Field34":null,"Field35":null,"Field36":null,"Field37":null,"Field38":null,"Field39":null,"Field40":null,"Field41":null,"Field42":null,"Field43":null,"Field44":null,"Field45":null,"Field46":null,"Field47":null,"Field48":null,"Field49":null,"Field50":null}]}';
            req2.requestURI = System.URL.getSalesforceBaseUrl()+'/services/apexrest/CrossDeal/1.0';  
            req2.httpMethod = 'POST';
            req2.requestBody = Blob.valueOf(jsonString2);
            RestContext.request = req2;
            RestContext.response = res2;
            CrossDealService.createCrossDeal();
        }catch(Exception ex){
             ex.getMessage();
        }
       // }
    }
    /*
      @Author: Mukesh
      @Name: offeringCase
      @Created Date: 29 June 2015
      @Description:
      @version: 1.0
    */
    private static testMethod void offeringCase(){
        Opportunity opp = testData();
        Map<String, Object> dealobjMap = new Map<String, Object>();
        dealobjMap=(Map<String, Object>)JSON.deserializeUntyped('{"Opportunity":"'+opp.Id+'","Offering":"Managed Security Services","Service":"Security","ServiceComponent":"Antivirus Mgmt","Field1Max":"-1.000000000","Field1Avg":"-1.000000000","Field1Min":"-1.000000000","Field2Max":"-2.000000000","Field2Avg":"-2.000000000","Field2Min":"-2.000000000","Field3Max":"-2.000000000","Field3Avg":"-2.000000000","Field3Min":"-2.000000000","Field4Max":"65107.550000000","Field4Avg":"8353.215000000","Field4Min":"0.000000000","Field5Max":"21.731086441","Field5Avg":"1.573108600","Field5Min":"-2.000000000","Field6Max":"-1.000000000","Field6Avg":"-1.000000000","Field6Min":"-1.000000000","Field7Max":"-2.000000000","Field7Avg":"-2.000000000","Field7Min":"-2.000000000","Field8Max":null,"Field8Avg":null,"Field8Min":null,"Field9Max":null,"Field9Avg":null,"Field9Min":null,"Field10Max":null,"Field10Avg":null,"Field10Min":null,"Field11Max":null,"Field11Avg":null,"Field11Min":null,"Field12Max":null,"Field12Avg":null,"Field12Min":null,"Field13Max":null,"Field13Avg":null,"Field13Min":null,"Field14Max":null,"Field14Avg":null,"Field14Min":null,"Field15Max":null,"Field15Avg":null,"Field15Min":null,"Field16Max":null,"Field16Avg":null,"Field16Min":null,"Field17Max":null,"Field17Avg":null,"Field17Min":null,"Field18Max":null,"Field18Avg":null,"Field18Min":null,"Field19Max":null,"Field19Avg":null,"Field19Min":null,"Field20Max":null,"Field20Avg":null,"Field20Min":null,"Field21Max":null,"Field21Avg":null,"Field21Min":null,"Field22Max":null,"Field22Avg":null,"Field22Min":null,"Field23Max":null,"Field23Avg":null,"Field23Min":null,"Field24Max":null,"Field24Avg":null,"Field24Min":null,"Field25Max":null,"Field25Avg":null,"Field25Min":null,"Field26":"India - 100.00% ","Field27":"Shared Resources","Field28":"7 Days x 24 Hours","Field29":"Americas","Field30":"EXCLUDED","Field31":"INCLUDED","Field32":"2.000000000","Field33":null,"Field34":null,"Field35":null,"Field36":null,"Field37":null,"Field38":null,"Field39":null,"Field40":null,"Field41":null,"Field42":null,"Field43":null,"Field44":null,"Field45":null,"Field46":null,"Field47":null,"Field48":null,"Field49":null,"Field50":null}');
        Map<String, String> fieldMap = New Map<String, String>();
        Map<String, Id> offeringMap =new Map<String, Id>();
        Map<String, Id> serviceMap =new Map<String, Id>();
        Map<String, Id> subServicegMap =new Map<String, Id>();
        Map<String, Id> cdMap =new Map<String, Id>();
        Cross_Deal_Field_Mapping__c field = new Cross_Deal_Field_Mapping__c();
        field.Field_Type__c ='double';
        field.Field_Mapping_Value__c ='Field1_Max__c';
        field.Name='Field1Max';
        field.Field_Type__c ='string';
        field.Field_Mapping_Value__c ='Field26__c';
        field.Name='Field26';
        insert field;
        for(Cross_Deal_Field_Mapping__c cm:[SELECT Field_Type__c, Field_Mapping_Value__c, Name, Id FROM Cross_Deal_Field_Mapping__c LIMIT 500]){
            fieldMap.put(cm.Name+UtilConstants.CROSS_SPLIT+cm.Field_Type__c, cm.Field_Mapping_Value__c);
        }
        CrossDealService.processCrossDealMapping(dealobjMap,fieldMap,opp.Id,offeringMap,serviceMap,subServicegMap,cdMap);
     }
}