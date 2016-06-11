/*
    @Author : Rajdeep Bhuiya
    @Created Date : 20/11/2015
    @name : MobilizationTeamController
    @Description : Creating MobilizationTeam records.
    @Version : 1.0
*/
public with sharing class MobilizationTeamController{
    
    public  Mobilization_Team__c mteam{get; set;}
    private ApexPages.StandardController cont;
    public String LocLookUpStr{get;set;}
    public String diplayErrorLoc {get;set;}
    public String diplayErrorRole {get;set;}
    public String diplayErrorPLead {get;set;}
    public String mTeamId {get; set;}
    
    /******************************
    Method Name: Constructor
    Description: This is the constructor for MobilizationTeamController
    Paramenters: NA
    Return Value: NA. 
    *******************************/
    public MobilizationTeamController(ApexPages.StandardController controller) {
            system.debug('controller----- '+controller);
          cont = controller;          
          diplayErrorLoc =UtilConstants.DISPLAY_NONE;
          diplayErrorRole =UtilConstants.DISPLAY_NONE;
          diplayErrorPLead =UtilConstants.DISPLAY_NONE;
          mteamId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
          
          if(mteamId <> null){
              populateMobTeam();
              LocLookUpStr = mteam.Delivery_Location_Master__r.Name;
          }  
          else{
              mteam   = (Mobilization_Team__c)controller.getRecord();
          }  
          system.debug('mteamId controller '+mteamId );
    }
    /******************************
    Method Name: populateMobTeam
    Description: This method will get invoked to populate the mobilization team records
    Paramenters: NA
    Return Value: pageReference. 
    *******************************/
    public void populateMobTeam(){
        mteamId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        mteam = [ SELECT Id, Name, Deal__c, Role__c, Delivery_Location_Master__c, Delivery_Location_Master__r.Name,
                        Primary_Lead__c, Secondary_Lead_1__c, Secondary_Lead_2__c, Wave__c FROM Mobilization_Team__c WHERE Id=:mteamId LIMIT 1 ];
    }
    
    /******************************
    Method Name: saveRecord
    Description: This method will get invoked to insert  mobilization team records
    Paramenters: NA
    Return Value: pageReference. 
    *******************************/
    public pageReference saveRecord(){
        diplayErrorLoc =UtilConstants.DISPLAY_NONE;
        diplayErrorRole =UtilConstants.DISPLAY_NONE;
        diplayErrorPLead =UtilConstants.DISPLAY_NONE;
        boolean errorexist=false; 
        //if((LocLookUpStr <> null && LocLookUpStr <> UTIL_Constants.EMPTY_STRING) && (mteam.Delivery_Location_Master__c == null || String.ValueOf(mteam.Delivery_Location_Master__c )== UTIL_Constants.EMPTY_STRING)){
        
        if(!String.isBlank(LocLookUpStr) && String.isBlank(String.ValueOf(mteam.Delivery_Location_Master__c))){ 
            diplayErrorLoc = UTIL_Constants.DISPLAY_BLOCK;
            errorexist=true;
        }
        if(String.isBlank(mteam.Role__c)){
            diplayErrorRole = UTIL_Constants.DISPLAY_BLOCK;
            errorexist=true;
        }
        if(String.isBlank(mteam.Primary_Lead__c)){
            diplayErrorPLead = UTIL_Constants.DISPLAY_BLOCK;
            errorexist=true;
        }
        if(errorExist){
            return null;
        }else{
            try{
                if(mteam.id<> null){
                    Database.update(mteam, true);
                }else{
                    Database.insert(mteam, true);
                }
                PageReference pgRef= new PageReference(UTIL_Constants.BLANK_URL+mteam.Id );
                pgRef.setRedirect(true);
                return pgRef;
            }catch(DMLException e){
                 ApexPages.Message errMsg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(0));
                  ApexPages.addMessage(errMsg);  
                  return null;
            }
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