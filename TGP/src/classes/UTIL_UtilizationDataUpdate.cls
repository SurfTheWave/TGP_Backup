public class UTIL_UtilizationDataUpdate{
    
    public void updateData(List<Utilization__c> utilizationList) {
        for(Utilization__c utilizationRecord :utilizationList) {
             utilizationRecord.Current_week__c = utilizationRecord.Current_week_1__c;
             utilizationRecord.Current_week_1__c = utilizationRecord.Current_week_2__c;
             utilizationRecord.Current_week_2__c = utilizationRecord.Current_week_3__c;
             utilizationRecord.Current_week_3__c = utilizationRecord.Current_week_4__c;
             utilizationRecord.Current_week_4__c = 0;   
        }
        upsert utilizationList;
                 
    }
    
    public void updateDateInCustomSetting(List<Utilization_Date__c> utilizationDates) {
        for(Utilization_Date__c utilizationRecord :utilizationDates) {
             utilizationRecord.ReferenceDate__c = utilizationRecord.ReferenceDate__c.addDays(7);  
        }
        update utilizationDates;                 
    }


}