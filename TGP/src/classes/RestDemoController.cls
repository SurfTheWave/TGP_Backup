public class RestDemoController {
   public string bodytosend;
   final static string usersession='00D560000008nH1!AQ4AQMRtZ_fhWQvtExOWNcEO94AJEK0zDrslxy0yuijnI_pf1duGDqqmuHpUzwPkM4d7nrZwakLbf7.4nIm1idxmZbnQoSBv';
   public string response{set;get;}
    public void sendSyncData(){
       RestDemoController.serializeclass handler = new RestDemoController.serializeclass();
       handler.method = 'SyncBPOSEDatatoSWB';
handler.jsonRequestObject = '{"FTEData":[{"LanguageNm":"","UpdateUserId":"a.avdesh.sharma","CreateUserid":"manas.k.maity","CreateDttm":"2015-10-21T12:05:03.023","UpdateDttm":"2015-10-21T12:05:03.023","CountryNm":"Argentina","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"7-Manager","BillCodeCd":"999","RateTypeCd":"BPO&#124;Finance and Accounting_Day_Std&#124;BA","LoadTypeCd":"Accenture BPO Delivery Center Dedicated","MobilizationStartDt":"8/22/2015","GoLiveDt":"9/19/2015","Description":"Description","SubServiceOfferingNm":"Finance and Accounting","RecruitingCostPCT":"1.0000","CostingTypeCd":"SDO","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"freetext 7","Generic1":"","Generic2":"","Generic3":"","ToolName":"","ToolType":"","Offering3":"","DeliveryLocationNm":"Buenos Aires","DCNFTEType":"DCN","FTEType":"Employee","BaselineFTE":"100","PyramidRichness":"","ServiceComponent":"","LanguagePremium":"N","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Order to Cash","CrossSolutioning":"","MobCategory":"","MobSubCategory":"","Month1":32.2581,"Month2":100.0000,"Month3":100.0000,"Month4":100.0000,"Month5":0.0000,"Month6":0.0000,"Month7":0.0000,"Month8":0.0000,"Month9":0.0000,"Month10":0.0000,"Month11":0.0000,"Month12":0.0000,"Month13":0.0000,"Month14":0.0000,"Month15":0.0000,"Month16":0.0000,"Month17":0.0000,"Month18":0.0000,"Month19":0.0000,"Month20":0.0000,"Month21":0.0000,"Month22":0.0000,"Month23":0.0000,"Month24":0.0000,"Month25":0.0000,"Month26":0.0000,"Month27":0.0000,"Month28":0.0000,"Month29":0.0000,"Month30":0.0000,"Month31":0.0000,"Month32":0.0000,"Month33":0.0000,"Month34":0.0000,"Month35":0.0000,"Month36":0.0000,"Month37":0.0000,"Month38":0.0000,"Month39":0.0000,"Month40":0.0000,"Month41":0.0000,"Month42":0.0000,"Month43":0.0000,"Month44":0.0000,"Month45":0.0000,"Month46":0.0000,"Month47":0.0000,"Month48":0.0000,"Month49":0.0000,"Month50":0.0000,"Month51":0.0000,"Month52":0.0000,"Month53":0.0000,"Month54":0.0000,"Month55":0.0000,"Month56":0.0000,"Month57":0.0000,"Month58":0.0000,"Month59":0.0000,"Month60":0.0000,"Month61":0.0000,"Month62":0.0000,"Month63":0.0000,"Month64":0.0000,"Month65":0.0000,"Month66":0.0000,"Month67":0.0000,"Month68":0.0000,"Month69":0.0000,"Month70":0.0000,"Month71":0.0000,"Month72":0.0000,"Month73":0.0000,"Month74":0.0000,"Month75":0.0000,"Month76":0.0000,"Month77":0.0000,"Month78":0.0000,"Month79":0.0000,"Month80":0.0000,"Month81":0.0000,"Month82":0.0000,"Month83":0.0000,"Month84":0.0000,"Month85":0.0000,"Month86":0.0000,"Month87":0.0000,"Month88":0.0000,"Month89":0.0000,"Month90":0.0000,"Month91":0.0000,"Month92":0.0000,"Month93":0.0000,"Month94":0.0000,"Month95":0.0000,"Month96":0.0000,"Month97":0.0000,"Month98":0.0000,"Month99":0.0000,"Month100":0.0000,"Month101":0.0000,"Month102":0.0000,"Month103":0.0000,"Month104":0.0000,"Month105":0.0000,"Month106":0.0000,"Month107":0.0000,"Month108":0.0000,"Month109":0.0000,"Month110":0.0000,"Month111":0.0000,"Month112":0.0000,"Month113":0.0000,"Month114":0.0000,"Month115":0.0000,"Month116":0.0000,"Month117":0.0000,"Month118":0.0000,"Month119":0.0000,"Month120":0.0000,"MobTotals":1000096.8654,"RunYr1":2601650.5870,"RunYr2":0.0000,"RunYr3":0.0000,"RunYr4":0.0000,"RunYr5":0.0000,"RunYr6":0.0000,"RunYr7":0.0000,"RunYr8":0.0000,"RunYr9":0.0000,"RunYr10":0.0000,"GroupName":"SDO and PMO","NONDCNLocation":"Buenos Aires","CostRate":53.4712,"TotalLoads":0.4550,"HoursAppliedToContract":1672.0000,"FTEMobTotals":0.0,"FTEYr1":20.0000,"FTEYr2":0.0000,"FTEYr3":0.0000,"FTEYr4":0.0000,"FTEYr5":0.0000,"FTEYr6":0.0000,"FTEYr7":0.0000,"FTEYr8":0.0000,"FTEYr9":0.0000,"FTEYr10":0.0000,"FinalMonthFTE":100.0000,"LocationTypeCode":1,"LocationTypeName":"ACN Onshore"}],"CCData":[{"UpdateUserId":"manas.k.maity","CreateUserid":"manas.k.maity","CreateDttm":"2015-10-21T12:05:03.077","UpdateDttm":"2015-10-21T12:05:03.077","Description":"RECRUITMENT(DNP)","CountryNm":"Argentina","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP Cost","RunTypeCd":"","ServiceOfferingNm":"Technology Tools","MobCategory":"","MobSubCategory":"","RateTypeCd":"BPO&#124;Finance and Accounting_Day_Std&#124;BA","LoadTypeCd":null,"MobilizationStartDt":"8/22/2015","GoLiveDt":"10/27/2015","SubServiceOfferingNm":"Finance and Accounting","CostingTypeCd":"SDO","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","ToolName":"ABCD","ToolType":"Custom","Offering3":"","Month1":139216.7885,"Month2":0.0000,"Month3":0.0000,"Month4":0.0000,"Month5":0.0000,"Month6":0.0000,"Month7":0.0000,"Month8":0.0000,"Month9":0.0000,"Month10":0.0000,"Month11":0.0000,"Month12":0.0000,"Month13":0.0000,"Month14":0.0000,"Month15":0.0000,"Month16":0.0000,"Month17":0.0000,"Month18":0.0000,"Month19":0.0000,"Month20":0.0000,"Month21":0.0000,"Month22":0.0000,"Month23":0.0000,"Month24":0.0000,"Month25":0.0000,"Month26":0.0000,"Month27":0.0000,"Month28":0.0000,"Month29":0.0000,"Month30":0.0000,"Month31":0.0000,"Month32":0.0000,"Month33":0.0000,"Month34":0.0000,"Month35":0.0000,"Month36":0.0000,"Month37":0.0000,"Month38":0.0000,"Month39":0.0000,"Month40":0.0000,"Month41":0.0000,"Month42":0.0000,"Month43":0.0000,"Month44":0.0000,"Month45":0.0000,"Month46":0.0000,"Month47":0.0000,"Month48":0.0000,"Month49":0.0000,"Month50":0.0000,"Month51":0.0000,"Month52":0.0000,"Month53":0.0000,"Month54":0.0000,"Month55":0.0000,"Month56":0.0000,"Month57":0.0000,"Month58":0.0000,"Month59":0.0000,"Month60":0.0000,"Month61":0.0000,"Month62":0.0000,"Month63":0.0000,"Month64":0.0000,"Month65":0.0000,"Month66":0.0000,"Month67":0.0000,"Month68":0.0000,"Month69":0.0000,"Month70":0.0000,"Month71":0.0000,"Month72":0.0000,"Month73":0.0000,"Month74":0.0000,"Month75":0.0000,"Month76":0.0000,"Month77":0.0000,"Month78":0.0000,"Month79":0.0000,"Month80":0.0000,"Month81":0.0000,"Month82":0.0000,"Month83":0.0000,"Month84":0.0000,"Month85":0.0000,"Month86":0.0000,"Month87":0.0000,"Month88":0.0000,"Month89":0.0000,"Month90":0.0000,"Month91":0.0000,"Month92":0.0000,"Month93":0.0000,"Month94":0.0000,"Month95":0.0000,"Month96":0.0000,"Month97":0.0000,"Month98":0.0000,"Month99":0.0000,"Month100":0.0000,"Month101":0.0000,"Month102":0.0000,"Month103":0.0000,"Month104":0.0000,"Month105":0.0000,"Month106":0.0000,"Month107":0.0000,"Month108":0.0000,"Month109":0.0000,"Month110":0.0000,"Month111":0.0000,"Month112":0.0000,"Month113":0.0000,"Month114":0.0000,"Month115":0.0000,"Month116":0.0000,"Month117":0.0000,"Month118":0.0000,"Month119":0.0000,"Month120":0.0000,"MobTotals":139216.7885,"RunYr1":0.0000,"RunYr2":0.0000,"RunYr3":0.0000,"RunYr4":0.0000,"RunYr5":0.0000,"RunYr6":0.0000,"RunYr7":0.0000,"RunYr8":0.0000,"RunYr9":0.0000,"RunYr10":0.0000,"LocationTypeCode":1,"LocationTypeName":"ACN Onshore","ServiceComponent":"","DCNType":"DCN","DCNLocation":"Buenos Aires","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","GroupName":"SDO and PMO"}],"OpportunityId":"00656000002IOOT","isFirstChunk":true}';        bodytosend = json.serialize(handler);
       auth_Success(usersession,bodytosend);
    }
    public void sendOppdetails(){
      RestDemoController.serializeclass handler = new RestDemoController.serializeclass();
      handler.method = 'GetOpportunityDataForUser';
      handler.jsonRequestObject ='{"opportunityid":"00656000002IOOT", "enterpriseid" : "a.avdesh.sharma"}' ;
      bodytosend = json.serialize(handler);
      // sendRequest(bodytosend);
      auth_Success(usersession,bodytosend);
      
       
    }
    public void synccomplete(){
       RestDemoController.serializeclass handler = new RestDemoController.serializeclass();
       handler.method = 'SyncCompleted';
        handler.jsonRequestObject ='{"Opportunityid":"00656000002IOOT","isTransactionSuccessful":true,"RowCount":2,"enterpriseid":"a.avdesh.sharma","SSMVersion":"V39","ScenarioNm":"Master Scope","ScenarioContractStartDate":"8/22/2015","ScenarioContractEndDate":"11/28/2015","ScenarioGoLiveDate":"9/19/2015","VersionNm":"Version 1","MRDBDate":"8/15/2015","MRDBVersion":"101","VersionID":"7360","BPOSETemplateVersion":"3","BDLGeneratedUTCDateTime":"1900-01-01T00:00:00","LstBDLGeneratedUserNm":null,"LstBDLGeneratedVrNm":null,"LstBDLGeneratedScNm":null,"HasMasterDataBeenCustomizedForDeal":false}';
       bodytosend = json.serialize(handler);
      // sendRequest(bodytosend);
      auth_Success(usersession,bodytosend);
      
       
    }
    public void sendOppteamdetails(){
       RestDemoController.serializeclass handler = new RestDemoController.serializeclass();
       handler.method = 'GetOpportunityTeamDetails';
       handler.jsonRequestObject ='{"opportunityid":"00656000002IOOT"}';
       bodytosend = json.serialize(handler);
       //sendRequest(bodytosend);
      auth_Success(usersession,bodytosend);
       
    }
    public void autoSyncData(){
        
      RestDemoController.serializeclass handler = new RestDemoController.serializeclass();
       handler.method = 'AutoSyncDateForOpportunity';
       handler.jsonRequestObject ='{"opportunityid":"00656000002IOOT", "ContractStartDate" : "2015-06-01T07:44:08.537","ContractEndDate" :"2016-06-01T07:44:08.537","GoLiveDate" : "2015-06-01T07:44:08.537"}';
       bodytosend = json.serialize(handler);
       //sendRequest(bodytosend);
       auth_Success(usersession,bodytosend);
   
    }
    
    public void sendBDL(){
        
      RestDemoController.serializeclass handler = new RestDemoController.serializeclass();
       handler.method = 'SendBDLData';
        handler.jsonRequestObject ='{"opportunityid":"00656000002IOOT","LstBDLGeneratedScNm":"NewScenario", "LstBDLGeneratedVrNm" : "Version1"," LstBDLGeneratedUserNm" :"m.salabath.khan","BDLGeneratedUTCDateTime" : "1900-01-01T16:46:00.000Z"}';       bodytosend = json.serialize(handler);
       //sendRequest(bodytosend);
       auth_Success(usersession,bodytosend);
   
    }
     public void sendRequest(string jsonBody){
        string Accessbody = 'grant_type=password&client_id=3MVG9MHOv_bskkhRqceWisfTm8xpSwT82JtTIjVGZPAgQTMyaIM6CMdjrvCgxEqj5X1qvFFrMW5UWMSJx_hwe'+
                                '&client_secret=3939497384196559364&username=a.avdesh.sharma@accenture.comdev25&password=apoorva0128';
        http h = new http();
        httpRequest hreq = new httpRequest();
        hreq.setBody(Accessbody);
        hreq.setEndpoint('https://test.salesforce.com/services/oauth2/token');
        hreq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        hreq.setTimeout(120000 );
        hreq.setMethod('POST');
        //hreq.setCompressed(true);
        httpResponse res = h.send(hreq);
        System.debug('request code:::::'+hreq);
        System.debug('response code:::::'+res.getStatusCode());
        System.debug('response body:::::'+res.getBody());  
        if(res.getStatusCode() == 200){
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class); 
        auth_Success(objAuthenticationInfo.access_token,jsonBody);
        }
        else{
       
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Authorization Failed.. Error Code:'+' '+res.getStatusCode()));
        }
   
    }
    public void auth_Success(string auth_token,string jsonBody){
    string access_token = auth_token;
    //string data_body = JSON.serialize(jsonBody);
   // System.debug('JSON output::::::::'+data_body);
       http data_http = new http();
       HttpRequest req1 = new HttpRequest();                    
       req1.setHeader('Authorization','Bearer '+access_token);
       req1.setHeader('Content-Type','application/json; charset=UTF-8'); 
       req1.setHeader('Accept','application/json');
       req1.setBody(jsonBody);
       req1.setTimeout(60000);  
       req1.setMethod('POST');
       req1.setEndpoint('https://accentureopsworkbench--r3qa.cs42.my.salesforce.com/services/apexrest/SyncDataWithBPOSE');       
       HttpResponse res1 = data_http.send(req1);
        System.debug('Returned response from ORD2;;;;'+res1);
         System.debug('Returned response body;;;;'+res1.getBody());
        response = res1.getBody().replace('"','');
      
    }

    
      public class OAuth2{
         public String id{get;set;}
         public String issued_at{get;set;}
         public String instance_url{get;set;}
         public String signature{get;set;}
         public String access_token{get;set;}    
    }
    public class serializeclass{
        public string method;
        public string jsonRequestObject;
    }
}