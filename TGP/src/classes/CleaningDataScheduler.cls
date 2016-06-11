/*****************
@author : Madhusudhan
@description : This class implements scheduleble class
 It will be running every one hour to delete FTE_Details , Other_cost_details__c,Payroll__c object records
                
*******************/
global class CleaningDataScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc) {
        DateTime dt = System.now().addMinutes(-60);
        String FteQuery='select id from fte_details__c where Is_Transient__c=True and Costing_Request__r.In_Progress__c=\'2\' and Costing_Request__r.Data_Cleaning_dev__c=True and Costing_Request__r.Time_Interval__c<=:dt';
        string obj='fte_details__c';
        CleanDataBatch cleanBatch = new CleanDataBatch(FteQuery,obj,dt);
        ID batchprocessid = Database.executeBatch(cleanBatch,200);         
    }
}