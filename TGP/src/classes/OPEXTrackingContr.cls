/*
    @Author : Rajdeep Bhuiya
    @Created Date : 20/11/2015
    @name : OPEXTrackingContr
    @Description : Creating OPEX_TRACKER records.
    @Version : 1.0
*/
public with sharing class OPEXTrackingContr {
    public string opexTrackerId {get;set;}
    public OPEX_Tracker__c opexTracker {get;set;}
    public boolean checkTrackingOn{get;set;}
    private String retUrl;
    public String LocLookUpStr{get;set;}
    public String diplayErrorLocLookUpStr{get;set;}
    public String diplayErrorItemStr{get;set;}
    public String diplayDaysAfGoLvStr{get;set;}
    public boolean editWave{get;set;}
    public boolean checkSubmitChecklist{get;set;}
    
    
    /**
    * @description       This is the Constructor of OPEXTrackingContr class.
    * @param             ApexPages.StandardController 
    * @return            NA
    * @throws            NA
    */ 
    public OPEXTrackingContr (ApexPages.StandardController controller) {
        opexTrackerId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        retUrl = ApexPages.currentPage().getParameters().get(UtilConstants.RET_URL);
        if(opexTrackerId != null && opexTrackerId != UtilConstants.EMPTY_STRING){
            populateOPEXTracker();
            LocLookUpStr=opexTracker .Location__r.name;
            editWave=true;

        }else{
            opexTracker = (OPEX_Tracker__c )controller.getRecord();
            editWave=false;
        }
        String waveid=(opexTracker .Wave__c);
        Wave__c wave=null;
        checkTrackingOn=false;
        if(!string.isBlank(waveid)){
            wave=populateWave(waveid.trim());
        }
        checkTrackingOn = wave.Mobilization_Plan__r.IsTrackingOn__c;
        
        checkSubmitChecklist=opexTracker.Submit_Checklist__c;
        
        diplayErrorLocLookUpStr=UtilConstants.DISPLAY_NONE;
        diplayErrorItemStr=UtilConstants.DISPLAY_NONE;
        diplayDaysAfGoLvStr=UtilConstants.DISPLAY_NONE;
    }
    /**
    * @description       This method used to populate the OPEX_Tracker__c object.
    * @param             NA 
    * @return            NA
    * @throws            NA
    */
    private void populateOPEXTracker(){
        opexTracker = [SELECT   Id, Name,Item_Order__c,Location__c,Location__r.name,Wave__c,
                                Mobilization_Plan__c,Days_After_Go_Live__c,Active__c,Submit_Checklist__c,
                                Comments__c,Milestone__c,Assessment_Scheduled__c,Completed__c,Checklist_Status__c,
                                Actual_Date__c,Tracking_Comments__c,Stability__c,Overall_Score__c
                                FROM
                                OPEX_Tracker__c where Id=:opexTrackerId LIMIT 5000];
    }
    /**
    * @description       This method used to populate the Wave__c object.
    * @param             String 
    * @return            Wave__c
    * @throws            NA
    */
    private Wave__c populateWave(String waveid){
        Wave__c wave=[select Mobilization_Plan__r.IsTrackingOn__c  from Wave__c where id=:waveid.trim() limit 1];
        return wave;
    }
    /**
    * @description       This method used to save the OPEX_Tracker__c value  .
    * @param             NA 
    * @return            pageReference
    * @throws            NA
    */ 
    public pageReference saveRecord(){
             diplayErrorLocLookUpStr = UtilConstants.DISPLAY_NONE;
             diplayErrorItemStr=UtilConstants.DISPLAY_NONE;
             diplayDaysAfGoLvStr=UtilConstants.DISPLAY_NONE;
             
             LocLookUpStr=ApexPages.currentPage().getParameters().get(UTIL_Constants.LOC_LOOKUPSTR);
             try{
                boolean errorexist=false; 
                if(String.isBlank(opexTracker.Location__c)){
                    diplayErrorLocLookUpStr=UTIL_Constants.DISPLAY_BLOCK;
                    errorexist=true;
                }
                if(String.isBlank(opexTracker.Name)){
                    diplayErrorItemStr=UTIL_Constants.DISPLAY_BLOCK;
                    errorexist=true;
                }
                
                
                if(opexTracker.Days_After_Go_Live__c==0){
                    diplayDaysAfGoLvStr=UTIL_Constants.DISPLAY_BLOCK;
                    opexTracker.Days_After_Go_Live__c=null;
                    errorexist=true;
                }
                if(errorexist){
                    return null;
                }else{
                    if(opexTrackerId != null && opexTrackerId != UtilConstants.EMPTY_STRING){
                        Database.update(opexTracker , true);
                    }else{
                        Database.insert(opexTracker , true);
                    }
                    return new PageReference('/' + opexTracker.id);
                    //return new PageReference(UtilConstants.SLASH+retUrl);
                }
            }catch(DMLException e){
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