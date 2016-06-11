/*
Author : Varsha Chougule.
Story  :  MOB_129 
Description :  Display the list of deals whose 'tracking' is on  with Wave Plan version number. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Varsha Chougule. MOB_129                  

*/
public with sharing class TrackingDealontroller {
    
    public List<Wave_Plan_Version__c> strWavePlanVersionList{get;set;}
    public List<Deal_Track__c> strTrackDealList {get;set;}
    /******************************
    Method Name: TrackingDealontroller
    Description: This is Constructor for the TrackingDealontroller class  
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public TrackingDealontroller()
    {
            //List of Wave Plan versions whose Tracking is on.
            strWavePlanVersionList=[Select Deal__c,Name,id,Initiate_Tracking__c from Wave_Plan_Version__c where Display_tracking_message__c=:'Tracking is On' order by createddate desc];
            strTrackDealList = [Select Wave_Plan_Version__r.Deal__c, Wave_Plan_Version__r.Name,Wave_Plan_Version__c,Wave_Plan_Version__r.Initiate_Tracking__c
            					from Deal_Track__c Where Wave_Plan_Version__r.Display_tracking_message__c=:'Tracking is On' order by createddate desc];        
    }
}