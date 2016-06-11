/*
    @Author : Rajdeep Bhuiya
    @Created Date : 20/11/2015
    @name : ServReadRevContr
    @Description : Creating SRAT_TRACKER records.
    @Version : 1.0
*/
public with sharing class ServReadRevContr {
    public string sratTrackerId {get;set;}
    public SRAT_Tracker__c sratTracker {get;set;}
    public boolean checkTrackingOn{get;set;}
    private String retUrl;
    public String LocLookUpStr{get;set;}
    public String diplayErrorLocLookUpStr{get;set;}
    public String diplayErrorItemStr{get;set;}
    public String diplayDaysBfGoLvStr{get;set;}
    public boolean editWave{get;set;}
    public boolean makeReadOnly{get;set;}
        
    /**
    * @description       This is the Constructor of OPEXTrackingContr class.
    * @param             ApexPages.StandardController 
    * @return            NA
    * @throws            NA
   * */    
    public ServReadRevContr(ApexPages.StandardController controller) {
        try{
            sratTrackerId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
            retUrl = ApexPages.currentPage().getParameters().get(UtilConstants.RET_URL);
        }
        catch(Exception e){
          string exceptionCaught = string.valueof(e);
        }
        if(sratTrackerId!= null && sratTrackerId!= UtilConstants.EMPTY_STRING){
            populateSRATTracker();
            LocLookUpStr=sratTracker.Location__r.name;
            editWave=true;
        }else{
            sratTracker  = (SRAT_Tracker__c)controller.getRecord();
            editWave=false;
        }
        
        
        String waveid=(sratTracker.Wave__c);
        Wave__c wave=null;
        checkTrackingOn=false;
        if(!string.isBlank(waveid)){
            wave=[select Mobilization_Plan__r.IsTrackingOn__c  from Wave__c where id=:waveid.trim() limit 1];
        }
        checkTrackingOn = wave.Mobilization_Plan__r.IsTrackingOn__c;
        
        if(sratTracker.Send_Checklist_for_Review__c && sratTracker.Checklist_Reviewed__c){
            makeReadOnly=true;    
        }else if(sratTracker.Send_Checklist_for_Review__c){
            if(UserInfo.getUserId().equals(sratTracker.Checklist_Reviewer__r.Primary_Lead__r.User__c)){
                makeReadOnly=false;    
            }else{
                makeReadOnly=true;    
            } 
        }else{
            makeReadOnly=false;
        }
            
        diplayErrorLocLookUpStr=UtilConstants.DISPLAY_NONE;
        diplayErrorItemStr=UtilConstants.DISPLAY_NONE;
        diplayDaysBfGoLvStr=UtilConstants.DISPLAY_NONE;
    }
    

    /**
         * @description       This method uses the SRAT_Tracker__c value.
         * @param             NA 
         * @return            NA
         * @throws            NA
    */
    private void populateSRATTracker(){
            sratTracker = [SELECT   Id, Name,Location__c,Location__r.name,Wave__c,Item_Order__c,Days_Before_Go_Live__c,
                                    Active__c,Milestone__c,Send_Checklist_for_Review__c,Checklist_Reviewed__c,
                                    Comments__c,Checklist_Reviewer__c,Actual_Date__c,RAG_Status__c,Tracking_Comments__c,
                                    Completed__c,Checklist_Status__c,Checklist_Reviewer__r.Primary_Lead__r.User__c
                                    FROM  SRAT_Tracker__c where Id=:sratTrackerId LIMIT 5000];
        
    }
        /**
        * @description       This action function save the wave process specific record.
        * @param             NA
        * @return            Null
        * @throws            NA
        */
        public pageReference saveRecord(){
            System.debug('>> ' + sratTracker.Days_Before_Go_Live__c);
             diplayErrorLocLookUpStr = UtilConstants.DISPLAY_NONE;
             diplayErrorItemStr=UtilConstants.DISPLAY_NONE;
             diplayDaysBfGoLvStr=UtilConstants.DISPLAY_NONE;
             
             LocLookUpStr=ApexPages.currentPage().getParameters().get(UTIL_Constants.LOC_LOOKUPSTR);
             
             try{
                boolean errorexist=false; 
                if(String.isBlank(sratTracker.Location__c)){
                    diplayErrorLocLookUpStr=UTIL_Constants.DISPLAY_BLOCK;
                    errorexist=true;
                }
                if(String.isBlank(sratTracker.Name)){
                    diplayErrorItemStr=UTIL_Constants.DISPLAY_BLOCK;
                    errorexist=true;
                }
                if(sratTracker.Days_Before_Go_Live__c ==null || sratTracker.Days_Before_Go_Live__c==0){
                    diplayDaysBfGoLvStr=UTIL_Constants.DISPLAY_BLOCK;
                    sratTracker.Days_Before_Go_Live__c=null;
                    errorexist=true;
                }
                
                if(errorexist){
                    return null;
                }else{
                    if(sratTrackerId != null && sratTrackerId != UtilConstants.EMPTY_STRING){
                        Database.update(sratTracker, true);
                    }else{
                        Database.insert(sratTracker, true);
                    }
                    return new PageReference(UtilConstants.SLASH+retUrl);
                }
            }catch(DMLException e){
                if(String.isBLANK(sratTracker.Location__c)){
                    diplayErrorLocLookUpStr=UTIL_Constants.DISPLAY_BLOCK;
                }
                ApexPages.Message errMsg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(0));
                ApexPages.addMessage(errMsg);  
            }
            catch(Exception e){
            string exceptionCaught = string.valueof(e);
}
            return null;
        }
        /******************************
        Method Name: getData
        Description: This method will get invoked to get the Delivery Location Values Asynchronously
        Paramenters: NA
        Return Value: List<SObject>. 
        *******************************/
        @RemoteAction
        public static List<SObject> getData(String param){
            try{
                String recdParam = String.escapeSingleQuotes(param);
                return Database.query(UTIL_Constants.mobTeamStrSQL1+recdParam+UTIL_Constants.mobTeamStrSQL2);  
            }catch(Exception ex){
                ExceptionClass.logException(UTIL_Constants.MOB_TEAM_CONTROLLER,UTIL_Constants.GET_DATA,ex,UTIL_Constants.MWB,UTIL_Constants.MWB);
                return null;
            }
        }

}