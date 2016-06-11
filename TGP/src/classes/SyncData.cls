/*
@Author:Apoorva Sharma
@Description: This class interacts with the BPOSE System when  syncig is done    
*/
@RESTResource(URLMapping='/SyncDataWithBPOSE/*')
global without sharing class SyncData {
    
    public String method;
    public String jsonRequestObject;
    
    @HttpPost
    global static string parseJson() {
        RESTRequest req = RESTContext.Request;
        RESTResponse res = RESTContext.Response;
        string json = req.requestBody.tostring();
        string response;
        system.debug('json received------>'+json);
        //system.debug('CPU time before Parsing first JSON---> '+Limits.getLimitCpuTime()); 
        SyncData sync =(SyncData) System.JSON.deserialize(json, SyncData.class);
        json = SWBBPOSEIntegrationConstants.emptystring ;
        //system.debug('json parsed------>'+sync); 
        //system.debug('CPU time after Parsing first JSON---> '+Limits.getLimitCpuTime());
        response = sync(sync.method,sync.jsonRequestObject);
        sync.jsonRequestObject = SWBBPOSEIntegrationConstants.emptystring;
        system.debug('json response sending------>'+response); 
        //system.debug('CPU time Final Before response---> '+Limits.getLimitCpuTime());  
        return response; 
    }
    
    public static string sync(String method,String json){
       string responsetosend = SWBBPOSEIntegrationConstants.emptystring; 
       HandleRestRequestAndSendResponse handler = new HandleRestRequestAndSendResponse();
        if(method.equalsignorecase(UtilConstants.SyncBPOSEDatatoSWB)){
            SyncDataRequest syncdata = (SyncDataRequest) System.JSON.deserialize(json, SyncDataRequest.class);
            json = SWBBPOSEIntegrationConstants.emptystring;
            //system.debug('CPU time after Parsing into handle class---> '+Limits.getLimitCpuTime());
            //system.debug('json parsed------>'+syncdata);
            responsetosend =  handler.syncData(syncdata);
        }
        else if(method.equalsignorecase(UtilConstants.GetOpportunityDataForUser)){
            GetOpportunityDataForUserRequest getoppdataforuserrequest =
                     (GetOpportunityDataForUserRequest) System.JSON.deserialize(json, GetOpportunityDataForUserRequest.class);
             responsetosend =  handler.getOppdetailsonUserRequest(getoppdataforuserrequest);
        }
        else if(method.equalsignorecase(UtilConstants.GetOpportunityTeamDetails)){
            GetOpportunityTeamDetailsRequest getoppsataforTeamDetail =
                     (GetOpportunityTeamDetailsRequest) System.JSON.deserialize(json, GetOpportunityTeamDetailsRequest.class);
             responsetosend =  handler.getOpportunityTeamDetails(getoppsataforTeamDetail);
        }
        else if(method.equalsignorecase(UtilConstants.AutoSyncDateForOpportunity)){
            AutoSyncDateForOpportunityRequest autosyncoppdata =
                     (AutoSyncDateForOpportunityRequest) System.JSON.deserialize(json, AutoSyncDateForOpportunityRequest.class);
             responsetosend =  handler.autoSyncData(autosyncoppdata);
        }
        else if(method.equalsignorecase(UtilConstants.SendBDLData)){
            SendBDLDataRequest sendBDLData =
                     (SendBDLDataRequest) System.JSON.deserialize(json, SendBDLDataRequest.class);
             responsetosend =  handler.sendBDData(sendBDLData);
        }
        else if(method.equalsignorecase(UtilConstants.SyncCompleted)){
            FinalizeTransaction finalisetrans =  
                    (FinalizeTransaction) System.JSON.deserialize(json, FinalizeTransaction.class);
                    json = SWBBPOSEIntegrationConstants.emptystring;
            responsetosend =  handler.finaliseTran(finalisetrans);
        }
      return responsetosend;  
    }
}