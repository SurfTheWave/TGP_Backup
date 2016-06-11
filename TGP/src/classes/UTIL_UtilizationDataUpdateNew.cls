/*
@Author and Created Date : System ,  2/6/2015 7:37 AM
@name : UTIL_UtilizationDataUpdateNew
@Description : 
@Version : 
*/
public without sharing class UTIL_UtilizationDataUpdateNew{
  /******************************
    Method Name: updateData
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void updateData(List<Utilizations__c> utilizationList) {
    try{
        for(Utilizations__c utilizationRecord :utilizationList) {
             utilizationRecord.Current_week__c = utilizationRecord.Current_week_1__c;
             utilizationRecord.Current_week_1__c = utilizationRecord.Current_week_2__c;
             utilizationRecord.Current_week_2__c = utilizationRecord.Current_week_3__c;
             utilizationRecord.Current_week_3__c = utilizationRecord.Current_week_4__c;
             utilizationRecord.Current_week_4__c = 0;   
        }
        upsert utilizationList;
        }
        Catch(DMLException e)
        {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
           //system.debug('E==='+e);
        }         
    }
    /******************************
    Method Name: updateDateInCustomSetting
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void updateDateInCustomSetting(List<Utilization_weekStartDate__c> utilizationDates) {
    try{
        for(Utilization_weekStartDate__c utilizationRecord :utilizationDates) {
             utilizationRecord.Referenced_Date__c = utilizationRecord.Referenced_Date__c.addDays(7);  
        }
        update utilizationDates;                 
       }
       Catch(DMLException e)
       {
           String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //system.debug('E==='+e);
       } 
    }


}