public without sharing class UTIL_SchedulingToUtilizationDataManager{
  
      public void insertUtilizationRecordsforSchedulingRecords(List<Opportunity_TGP__c> scope) {      
          List<Utilization__c> utilizationListToUpdate= new List<Utilization__c>();
          Utilization__c utlizationRecordToUpdate = new Utilization__c(); 
                             
          AggregateResult[] schedulingListGroupedByUser = new AggregateResult[]{};
          schedulingListGroupedByUser = [select User_Master__c umID, SUM(Ongoing__c) OG, SUM(Current_week__c) CW, SUM(Current_week_1__c) CW1, SUM(Current_week_2__c) CW2, SUM(Current_week_3__c) CW3 from Scheduling__c where BPO_Opportunity_MD__c =:scope[0].Id Group By User_Master__c limit 200];                
          
          for(AggregateResult result : schedulingListGroupedByUser)      {
              for(Utilization__c utRecord: [select Id from Utilization__c where BPO_Opportunity__c =:scope[0].Id And User_Master__c  =:(Id)result.get('umID')]) {
                  utlizationRecordToUpdate = new Utilization__c(); 
                  utlizationRecordToUpdate.Id = utRecord.Id;
                  utlizationRecordToUpdate.Current_week__c = (Decimal)result.get('CW');
                  utlizationRecordToUpdate.Current_week_1__c = (Decimal)result.get('CW1');
                  utlizationRecordToUpdate.Current_week_2__c = (Decimal)result.get('CW2');
                  utlizationRecordToUpdate.Current_week_3__c = (Decimal)result.get('CW3');
                  utlizationRecordToUpdate.Current_week_4__c = (Decimal)result.get('OG');     
                  utilizationListToUpdate.add(utlizationRecordToUpdate);           
              }
          }
          update utilizationListToUpdate;  
      }
}