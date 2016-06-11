@RestResource(urlMapping='/CrossDeal/1.0/*')
/*
  @Author: Aswajit Swain
  @Name: CrossDealService
  @Created Date: 27 May 2015
  @Description:
  @version: 1.0
*/
global with sharing class CrossDealService {
    /*
      @Author: Aswajit Swain
      @Name: createCrossDeal
      @Created Date: 27 May 2015
      @Parms : Getting JSON Data from Request body 
      @Description: POST Service allow to user to create Cross deal Records
      @version: 1.0
    */
    @HttpPost global static String createCrossDeal(){
        RestRequest req = RestContext.request;
        String crossdealMsg=UtilConstants.CROSS_EMPTY;
        String errorMsg=UtilConstants.CROSS_EMPTY;
        String exMsg = UtilConstants.CROSS_EMPTY;
        String successMsg=UtilConstants.CROSS_EMPTY;
        RestResponse res = RestContext.response;
        Map<String, Object> paramsMap;
        sync_status__c syncstat;
        String oppId ; 
        try{
         
            paramsMap = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
            System.debug('json ----'+req.requestBody.toString());
        }catch(JSONException jx){
            exMsg = UtilConstants.CROSS_DEAL_ERR_MSG;            
        }
        if(!paramsMap.isEmpty()){
            List<Object> dealListObject = (List<Object>)paramsMap.get(UtilConstants.CROSS_DEAL);
            List<Object> oppObj;
            List<Object> dealObj;
            List<Object> serviceObject;
            /* noo need for this list*/
            List<Cross_Deal__c> crossDealList = new List<Cross_Deal__c>();
            Set<Id> oppIds = new Set<Id>();
            if(dealListObject.size() > 0){
                for(Object obj: dealListObject){
                    Map<String, Object> dealobjMap = (Map<String, Object>)obj;
                    oppId = (String)dealobjMap.get(UtilConstants.OPPORTUNITYID); 
                    oppIds.add(oppId); 
                }
                Map<Id, Opportunity> oppIdMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity WHERE ID IN:oppIds ORDER BY LastModifiedDate DESC LIMIT 100]);
                Map<String, Id> offeringMap =new Map<String, Id>();
                Map<String, Id> serviceMap =new Map<String, Id>();
                Map<String, Id> subServicegMap =new Map<String, Id>();
                Map<String, Id> cdMap =new Map<String, Id>();
                
                if(oppIds.size() > 0){
                syncstat = [select id,error__c, Calculation_failed__c from sync_Status__C where opportunity__c=:oppId limit 1];
                    for(Service_Components__c scs :[SELECT Id,Service__r.Solutionscope__r.Opportunity__c, Services_Component_Master__r.Name,Service__c, Service__r.services__r.Name, Service__r.Solutionscope__c, 
                                                    Service__r.Solutionscope__r.Offering_Master__r.Name FROM Service_Components__c 
                                                    WHERE Service__r.Solutionscope__r.Opportunity__c IN:oppIds LIMIT 6000]){
                        String compKey = scs.Service__r.Solutionscope__r.Opportunity__c+scs.Service__r.Solutionscope__r.Offering_Master__r.Name.trim()+scs.Service__r.services__r.Name.trim()+scs.Services_Component_Master__r.Name.trim();
                        system.debug('component key'+compKey);
                        String serviceKey = scs.Service__r.Solutionscope__r.Opportunity__c+scs.Service__r.Solutionscope__r.Offering_Master__r.Name.trim()+scs.Service__r.services__r.Name.trim();
                        system.debug('Service key'+serviceKey);
                        String offeringKey = scs.Service__r.Solutionscope__r.Opportunity__c+scs.Service__r.Solutionscope__r.Offering_Master__r.Name.trim();
                        compKey = compKey.toLowerCase();
                        serviceKey = serviceKey.toLowerCase();
                        offeringKey = offeringKey.toLowerCase();
                        system.debug('offeringKey key'+offeringKey);
                        if(!subServicegMap.containsKey(compKey)){
                            subServicegMap.put(compKey, scs.Id);
                        }
                        if(!serviceMap.containsKey(serviceKey)){                                            
                            serviceMap.put(serviceKey, scs.Service__c);
                        }
                        if(!offeringMap.containsKey(offeringKey)) {                                              
                            offeringMap.put(offeringKey, scs.Service__r.Solutionscope__c);
                        }
                    }
                    system.debug('serice Map'+serviceMap);
                    system.debug('offering Map'+offeringMap);
                    system.debug('serice component Map'+subServicegMap);
                    for(Cross_Deal__c cds:[Select Id,Opportunity__c, Service__r.Services__r.Name, Service_Name__c From Cross_Deal__c Where Opportunity__c IN:oppIds ]){
                        cdMap.put(cds.Opportunity__c+cds.Service__r.Services__r.Name, cds.Id);
                    }
                }
                Map<String, String> fieldMap = New Map<String, String>();
                for(Cross_Deal_Field_Mapping__c cm:[SELECT Field_Type__c, Field_Mapping_Value__c, Name, Id FROM Cross_Deal_Field_Mapping__c LIMIT 500]){
                    fieldMap.put(cm.Name+UtilConstants.CROSS_SPLIT+cm.Field_Type__c, cm.Field_Mapping_Value__c);
                }
                
                for(Object obj: dealListObject){
                    Map<String, Object> dealobjMap = (Map<String, Object>)obj;
                    oppId = (String)dealobjMap.get(UtilConstants.OPPORTUNITYID);
                    try{
                        String compKey = oppId+((String)dealobjMap.get(UtilConstants.CROSS_OFFERING)).trim()+((String)dealobjMap.get(UtilConstants.CROSS_SERVICE)).trim()+((String)dealobjMap.get(UtilConstants.CROSS_SERVICE_COMP)).trim();
                        system.debug('compKey key'+compKey);
                        String serviceKey = oppId+((String)dealobjMap.get(UtilConstants.CROSS_OFFERING)).trim()+((String)dealobjMap.get(UtilConstants.CROSS_SERVICE)).trim();
                        system.debug('serviceKey key'+serviceKey);
                        String offeringKey = oppId+((String)dealobjMap.get(UtilConstants.CROSS_OFFERING)).trim();
                        system.debug('offeringKey key'+offeringKey);
                        compKey = compKey.toLowerCase();
                        serviceKey = serviceKey.toLowerCase();
                        offeringKey = offeringKey.toLowerCase();
                        if(oppIdMap.get(oppId) != null){
                            if(serviceMap != null){
                                System.debug('record in service map'+serviceMap.get(serviceKey));
                                if(serviceMap.get(serviceKey) != null){
                                    if(offeringMap != null && subServicegMap != null){
                                        Boolean bool1= false;
                                        Boolean bool2 = false;
                                        String erMsg = UtilConstants.CROSS_EMPTY;
                                        if(offeringMap.get(offeringKey) != null){
                                            bool1 = true;
                                        }else
                                            erMsg += ((String)dealobjMap.get(UtilConstants.CROSS_OFFERING))+UtilConstants.CROSS_OFF;
                                        if(subServicegMap.get(compKey) != null){
                                            bool2 = true;
                                        }else
                                            erMsg =+ ((String)dealobjMap.get(UtilConstants.CROSS_SERVICE_COMP))+UtilConstants.CROSS_SCS;
                                        if(bool1 && bool2){
                                            crossDealList.add(processCrossDealMapping(dealobjMap,fieldMap, oppId, offeringMap, serviceMap, subServicegMap,cdMap));   
                                        }else
                                            errorMsg += UtilConstants.CROSS_MSG1+oppId+UtilConstants.CROSS_MSG2+erMsg+UtilConstants.CROSS_MSG3;
                                    }
                                }else{
                                    system.debug('else block error');
                                    errorMsg += UtilConstants.CROSS_MSG1+oppId+UtilConstants.CROSS_MSG2+((String)dealobjMap.get(UtilConstants.CROSS_SERVICE))+UtilConstants.CROSS_SRV;
                                }
                            }
                        }else
                            errorMsg += UtilConstants.CROSS_MSG1+oppId+UtilConstants.CROSS_MSG4;
                    }catch(Exception ex){
                        exMsg = ex.getMessage();
                       syncstat.Error_IO__c ='IOCR Data Synced Successfully, CDR Data Sync Failed ' + exMsg;
                       syncstat.Calculation_failed__c = true;
                       update syncstat;
                       
                    } 
                }
            }
            if(crossDealList.size()> 0){
                Savepoint sp = Database.setSavepoint();
                try{
                    Database.upsert(crossDealList, true);
                    successMsg = crossDealList.size()+UtilConstants.CROSS_DEAL_MSG;
                }catch(DMLException de){
                    exMsg = UtilConstants.CROSS_DEAL_INSERTFAILED;
                    Database.rollback(sp);                  
                   syncstat.Error_IO__c ='IOCR Data Synced Successfully, CDR Data Sync Failed ' + exMsg;
                   syncstat.Calculation_failed__c = true;
                   update syncstat;
                    //IOHandleRestRequestAndSendResponse iosync = new IOHandleRestRequestAndSendResponse();
                    //iosync.rollback_data();
                    
                }
            }
        }
        errorMsg = errorMsg != UtilConstants.CROSS_EMPTY ? errorMsg.substring(0, errorMsg.length()- 1) :errorMsg; 
        crossdealMsg = UtilConstants.CROSS_SYNC+errorMsg+UtilConstants.CROSS_ERRSYNC+exMsg+UtilConstants.CROSS_SUCSYNC+successMsg+UtilConstants.CROSS_BRACES;
        ExceptionClass.logError(UtilConstants.CROSS_CLASSNAME,UtilConstants.CROSS_METHOD2,exMsg,crossdealMsg,UtilConstants.CROSS_APP,UtilConstants.CROSS_MODULE);
        Map<String, Object> responseJson = (Map<String, Object>) JSON.deserializeUntyped(crossdealMsg);
        List<Object> a = (List<Object>)responseJson.get('NotSynced');
        if(a.size() >0){
            syncstat.Error_IO__c ='IOCR Data Synced Successfully, CDR Data Sync Failed ' + errorMsg;
            syncstat.Calculation_failed__c = true;
            update syncstat;
        }
        return crossdealMsg;
    }
    
    /*
      @Author: Aswajit Swain
      @Name: processCrossDealMapping
      @Created Date: 10 June 2015
      @Parms :  
      @Description: This is a private method calling inside "createCrossDeal" method
      @version: 1.0
    */
    @TestVisible private static Cross_Deal__c processCrossDealMapping(Map<String, Object> dealobjMap, Map<String, String> fieldMap,String oppId, Map<String, Id> offeringMap, Map<String, Id> serviceMap, Map<String, Id> subServicegMap, Map<String, Id> cdMap){
        Cross_Deal__c cd;
        String compKey = oppId+((String)dealobjMap.get(UtilConstants.CROSS_OFFERING)).trim()+((String)dealobjMap.get(UtilConstants.CROSS_SERVICE)).trim()+((String)dealobjMap.get(UtilConstants.CROSS_SERVICE_COMP)).trim();
        String serviceKey = oppId+((String)dealobjMap.get(UtilConstants.CROSS_OFFERING)).trim()+((String)dealobjMap.get(UtilConstants.CROSS_SERVICE)).trim();
        String offeringKey = oppId+((String)dealobjMap.get(UtilConstants.CROSS_OFFERING)).trim();
        compKey = compKey.toLowerCase();
        serviceKey = serviceKey.toLowerCase();
        offeringKey = offeringKey.toLowerCase();
        if(cdMap.get((String)dealobjMap.get(UtilConstants.CROSS_SERVICE)) != null){
            cd= new Cross_Deal__c(Id=cdMap.get(oppId+(String)dealobjMap.get(UtilConstants.CROSS_SERVICE))) ;
        }else{
            cd= new Cross_Deal__c() ;
            cd.Service__c = serviceMap.get(serviceKey);
        } 
        cd.is_transient__c = true; 
        cd.Opportunity__c = oppId;
        cd.Offering__c = offeringMap.get(offeringKey);
        cd.Service_Component__c = subServicegMap.get(compKey);
        cd.Service_Name__c = (String)dealobjMap.get(UtilConstants.CROSS_SERVICE);
        cd.Offering_Name__c = (String)dealobjMap.get(UtilConstants.CROSS_OFFERING);
        cd.Service_Component_Name__c = (String)dealobjMap.get(UtilConstants.CROSS_SERVICE_COMP);
        for(String key: fieldMap.keyset()){
            String field =key.split(UtilConstants.CROSS_SPLIT)[0];
            if(dealobjMap.containsKey(field)){
                if(key.split(UtilConstants.CROSS_SPLIT)[1] == UtilConstants.CROSS_DT_TYPE){
                    cd.put(fieldMap.get(key), dealobjMap.get(field) != null ? (double.valueOf(dealobjMap.get(field)) < 0 ? 0 : double.valueOf(dealobjMap.get(field))) : 0);
                }else
                    cd.put(fieldMap.get(key), dealobjMap.get(field) != null ? String.valueOf(dealobjMap.get(field)) : dealobjMap.get(field));
            } 
        }
        return cd;
    }
    
    /*
      @Author: Aswajit Swain
      @Name: getMasterData
      @Created Date: 10 June 2015
      @Parms : LastUpdatedDate Datetime
      @Description: when LastUpdatedDate is empty all IO opportunity data will retun
      @version: 1.0
    */
     @HttpGet global static List<MasterData> getMasterData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<MasterData> masterList = new List<MasterData>();
        Datetime lastUpdatedDate;
        try{
            lastUpdatedDate = Datetime.valueOf(req.params.get(UtilConstants.LASTUPDATEDDATE));
        }catch(TypeException te){
           //ExceptionClass.logException(UtilConstants.CROSS_CLASSNAME,UtilConstants.CROSS_METHOD1,te,UtilConstants.CROSS_APP,UtilConstants.CROSS_MODULE);
        }
        List<Opportunity> oppList = null;
        if(lastUpdatedDate != null){
            oppList = [SELECT Id, Name, Account.Name, Master_Client_Name__c, SAP_OM_ID__c, LastModifiedDate FROM Opportunity WHERE IO_Opportunity__c=true AND LastModifiedDate >=: lastUpdatedDate LIMIT 5000];
        }else if(String.isEmpty(req.params.get(UtilConstants.LASTUPDATEDDATE))){
            oppList = [SELECT Id, Name,Account.Name, Master_Client_Name__c, SAP_OM_ID__c, LastModifiedDate FROM Opportunity WHERE IO_Opportunity__c=true LIMIT 6000];
        }else{}
        if(oppList != null){
            for(Opportunity opp : oppList){
                MasterData md = new MasterData();
                md.OpportunityId = opp.Id;
                md.OpportunityName = opp.Name;
                md.SAP_OM_ID = opp.SAP_OM_ID__c;
                md.Master_Client_Name = opp.Account.Name;
                md.LastModifiedDate = String.valueOf(opp.LastModifiedDate);
                masterList.add(md);
            }
        }
        return masterList;
    }
    
    /*
      @Author: Aswajit Swain
      @Name: MasterData
      @Created Date: 10 June 2015
      @Description:
      @version: 1.0
    */
    global with sharing class MasterData{
        private String OpportunityId;
        private String OpportunityName;
        private String SAP_OM_ID;
        private String Master_Client_Name;
        private String LastModifiedDate;
    }
    
}