/**
    @Author     : 
    @name       : UTIL_UtilizationDataManagerNew
    @CreateDate : 3 January 2015 
    @Description: Utility code for managing Utilization data.
    @Version    : 1.0 
*/
public without sharing class UTIL_UtilizationDataManagerNew {
    /**
     * @Description : This method is used to insert Utilization record for dummy opportunities
     * @name : insertUtilizationRecordsforDummyOpp
     * @param: List<User_Master__c>
     * @return parameter : void
     * @throws exception: NA
     */
    public void insertUtilizationRecordsforDummyOpp(List < User_Master__c > scope) {
        try {
            List < Opportunity > dummyOppList = new List < Opportunity > ();
            dummyOppList = [select Id FROM Opportunity 
                           WHERE Name IN(:UtilConstants.OPP_NAME_LIST_0, :UtilConstants.OPP_NAME_LIST_1, :UtilConstants.OPP_NAME_LIST_2) LIMIT 5000];
            List < Utilizations__c > utilizationListToInsert = new List < Utilizations__c > ();
            Utilizations__c utilizationObjectOther;
            if (dummyOppList.size() == 3) {
                for (User_Master__c user: scope) {
                    for (Opportunity opp: dummyOppList) {
                        utilizationObjectOther = new Utilizations__c();
                        utilizationObjectOther.Opportunity__c = opp.Id;
                        utilizationObjectOther.User__c = user.Id;
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
        } catch(DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
            //System.debug('E==='+e);
        }
    }
}