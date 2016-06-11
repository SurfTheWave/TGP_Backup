trigger updateUserOnDealWave on Deal_Location__c (after update) 
{
    //if(Test.isRunningTest()==false)
    //{
        List<Deal_Location__c > lstNewDealLoc = Trigger.new;
        List<Deal_Location__c > lstOldDealLoc = Trigger.old;
        if(lstNewDealLoc.get(0).Mobilization_Recruitment_Lead_Primary__c != lstOldDealLoc.get(0).Mobilization_Recruitment_Lead_Primary__c ||
        lstNewDealLoc.get(0).Mobilization_Recruitment_Lead_Secondary__c != lstOldDealLoc.get(0).Mobilization_Recruitment_Lead_Secondary__c )
        {
            List<Wave_Planning__c> lstDealWave = [select id,Mobilization_Recruitment_Lead_Primary__c,Mobilization_Recruitment_Lead_Secondary__c
                                                   from  Wave_Planning__c where Deal_Location__c =: lstNewDealLoc.get(0).id ];
            for(Wave_Planning__c tmp : lstDealWave ) 
            {
                tmp.Mobilization_Recruitment_Lead_Primary__c = lstNewDealLoc.get(0).Mobilization_Recruitment_Lead_Primary__c; 
                tmp.Mobilization_Recruitment_Lead_Secondary__c = lstNewDealLoc.get(0).Mobilization_Recruitment_Lead_Secondary__c ; 
            }
            update lstDealWave;                                          
        }
    //}    
}