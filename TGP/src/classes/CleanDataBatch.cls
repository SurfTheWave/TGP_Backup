/*****************
@author : Madhusudhan
@description : This class implements Batch class
 It will be deleting records from FTE_Details , Other_cost_details__c,Payroll__c objects for every one hour
                
*******************/
global class CleanDataBatch implements Database.Batchable<sObject>,Database.Stateful{
    global String delquery;
    global String objectName;
    global DateTime dt;
    public CleanDataBatch (String query,String objName,DateTime dt){
        delquery=query;
        objectName=objName; 
        dt=dt;
        system.debug('dfdsfdsf');
    }
     global Database.QueryLocator start(Database.BatchableContext bc){
     system.debug('query locator---'+Database.getQueryLocator(delquery));
        return Database.getQueryLocator(delquery);
    }
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
        system.debug('sObjectList---'+sObjectList);
        List<sObject> deleteorUpdateRecords=new List<sObject>();
        if(objectName.equals('Costing_Request__c')){
            List<Costing_Request__c> costRequestRecords=new List<sObject>();
            List<Costing_Request__c> costReqList = ((list<Costing_Request__c>)sObjectList);
            for(Costing_Request__c obj:costReqList){
                obj.In_Progress__c='0';
                obj.Data_Cleaning_dev__c=false;
                obj.Has_Updated__c=false;
                costRequestRecords.add(obj);
            }
            if(!costRequestRecords.isEmpty()){
                Database.update(costRequestRecords);
                system.debug('updateRecords---'+deleteorUpdateRecords);
            }
        }else{
            for(sObject obj:sObjectList){
                deleteorUpdateRecords.add(obj);
            }
            system.debug('deleteRecords---'+deleteorUpdateRecords);
            if(!deleteorUpdateRecords.isEmpty()){
                Database.delete(deleteorUpdateRecords);
            }
        }
    }
    public void finish(Database.BatchableContext bc) {
        if(objectName.equals('fte_details__c')){
            String delQuery='select id from Other_Cost_Details__c where Is_Transient__c=True and Costing_Request__r.In_Progress__c=\'2\' and Costing_Request__r.Data_Cleaning_dev__c=True and Costing_Request__r.Time_Interval__c<=:dt';
            String objName='Other_cost_details__c';
            DateTime dt=dt;
            Id batchIdrisk=database.executeBatch(new CleanDataBatch(delQuery,objName,dt));
        }else if(objectName.equals('Other_cost_details__c')){
            String delQuery='select id from Payroll__c where Is_Transient__c=True and Costing_Request__r.In_Progress__c=\'2\' and Costing_Request__r.Data_Cleaning_dev__c=True and Costing_Request__r.Time_Interval__c<=:dt';
            String objName='Payroll__c';
            DateTime dt=dt;
            Id batchIdrisk=database.executeBatch(new CleanDataBatch(delQuery,objName,dt));
        }
        else if(objectName.equals('Payroll__c')){
            String delQuery='SELECT In_Progress__c,Data_Cleaning_dev__c,Has_Updated__c from Costing_Request__c where In_Progress__c=\'2\' and Data_Cleaning_dev__c=True and Time_Interval__c<=:dt';
            String objName='Costing_Request__c';
            DateTime dt=dt;
            Id batchIdrisk=database.executeBatch(new CleanDataBatch(delQuery,objName,dt));
        }       
    }
}