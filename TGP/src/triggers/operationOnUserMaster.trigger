trigger operationOnUserMaster on Review_User_Master__c (after insert) {
     if(trigger.isInsert && trigger.isAfter) {
        List<Utilization__c> utilizationListToInsert = new List<Utilization__c>();
        List<Opportunity_TGP__c> otherOpportunityList = [select Id from Opportunity_TGP__c where Name IN ('PTO','Training','Other Deal Support','Other Unavailable')];
        for(Review_User_Master__c user : Trigger.New) {
            for(Opportunity_TGP__c opportunity :otherOpportunityList) {            
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