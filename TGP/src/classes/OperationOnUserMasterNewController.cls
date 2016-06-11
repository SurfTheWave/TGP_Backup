/*
  @Author:           Shashank
  @Name:             OperationOnUserMasterNewController 
  @Created Date:     01 January 2015
  @Description:      This class is used to perform Operation on User Master services
  @version:          1.0
*/
public without sharing class OperationOnUserMasterNewController {
    /**
     * @Description : This method is used to generate dummy records for Utilization 
     * @Name        : createdummyRec
     * @param       : List<User_Master__c> userMasterNewList 
     * @return parameter : void 
     * @throws exception: NA
     */
    public static void createdummyRec(List<User_Master__c> userMasterNewList){
        List<Utilizations__c> utilizationListToInsert = new List<Utilizations__c>();
        List<User_Master__c> userMasterQueried = new List<User_Master__c>();
        userMasterQueried = [Select Id,First_Name__c from User_Master__c where Id IN : userMasterNewList LIMIT 500];
        List<Opportunity> otherOpportunityList = [select Id, Name 
                FROM Opportunity where Name IN (:UtilConstants.OPP_NAME_LIST, :UtilConstants.OPP_NAME_LIST_1,:UtilConstants.OPP_NAME_LIST_2) LIMIT 5000];
        for(User_Master__c user : userMasterQueried) {
            for(Opportunity opportunity :otherOpportunityList) {            
                Utilizations__c utilizationObjectOther = new Utilizations__c(); 
                utilizationObjectOther.Opportunity__c = opportunity.Id;
                utilizationObjectOther.User__c = user.Id;
                utilizationObjectOther.name = user.First_Name__c+' '+opportunity.Name;
                utilizationObjectOther.Current_week__c = 0;
                utilizationObjectOther.Current_week_1__c = 0;
                utilizationObjectOther.Current_week_2__c = 0;
                utilizationObjectOther.Current_week_3__c = 0;
                utilizationObjectOther.Current_week_4__c = 0;     
                utilizationListToInsert.add(utilizationObjectOther);            
            }
        }
        //System.debug('----------------'+utilizationListToInsert.size());
        if(utilizationListToInsert.size()>0){
             Database.insert(utilizationListToInsert);
        }
    }    
}