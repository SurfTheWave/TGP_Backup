public without sharing class UTIL_UtilizationDataManager{
  
      public void insertUtilizationRecordsforDummyOpp(List<Review_User_Master__c> scope) {
          List<Opportunity_TGP__c> dummyOppList = new List<Opportunity_TGP__c>();
          dummyOppList = [select Id from Opportunity_TGP__c where Name IN ('PTO','Training','Other Deal Support','Other Unavailable')];
          List<Utilization__c> utilizationListToInsert = new List<Utilization__c>();
          if(dummyOppList.size() == 4) {
              for(Review_User_Master__c user : scope) {
                for(Opportunity_TGP__c opportunity :dummyOppList ) {            
                    Utilization__c utilizationObjectOther = new Utilization__c(); 
                    utilizationObjectOther.BPO_Opportunity__c = opportunity.Id;
                    utilizationObjectOther.User_Master__c = user.Id;
                    utilizationObjectOther.Current_week__c = 0;
                    utilizationObjectOther.Current_week_1__c = 0;
                    utilizationObjectOther.Current_week_2__c = 0;
                    utilizationObjectOther.Current_week_3__c = 0;
                    utilizationObjectOther.Current_week_4__c = 0;     
                    utilizationListToInsert.add(utilizationObjectOther);            
                }
              }
              insert utilizationListToInsert;
          }
      }
}