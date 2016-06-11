/*   @Author :  Divyashree C K
     @Name   : OppAnalyticCalcQueue 
     @CreateDate :  12th Aug 2015
     @Description  : Queueable Class to calculate Mob Analytics for Opportunity
     @Version : 1.0
  */
public without sharing class OppAnalyticCalcQueue implements Queueable {


    
    public set<Id> oldFteList = new Set<Id>();
    public set<Id> newFTeList = new Set<Id>();
    public set<Id> oldOcdList = new Set<Id>();
    public set<Id> newOcdList = new Set<Id>();
    public Map<String, String> costingData;
    public Id oldBnchId;
    public Id newBnchId;
    public set<Id> oldBnchSumId= new Set<Id>();
    public set<Id> newBnchSumId = new Set<Id>();
    //public static Opportunity newOpp;
    //public static Id Opptyid;
    
    
    
    /******************************
        Method Name: OppAnalyticCalcQueue
        Description: Constructor to populate the Iterable and other parameters
        Paramenters: NA
        Return Value: void. 
        *******************************/
    public OppAnalyticCalcQueue (set<Id> oldFtes, set<Id> newFtes, set<id>oldOcds, set<id> newOcds, map<String, String> jsonCosting, Id oldBnch, Id newBnch, set<Id>oldbnchOpp, set<Id> newBnchOpp){
        //Opptyid= newOpty.Id;
        //newOpp = newOpty;
        oldFteList = oldFtes;
        newFteList = newFtes;
        oldOcdList = oldOcds; 
        newOcdList = newOcds;
        costingData = jsonCosting;
        oldBnchId = oldBnch;
        newBnchid = newBnch;
        oldBnchSumId = oldBnchOpp;
        newBnchSumId = newBnchOpp;
        //System.debug('oldFteList'+oldFteList);
        UtilConstants.allowactivation = true;
        UtilConstants.allowstatusupdation = true;
    }
    
        /******************************
        Method Name: OppAnalyticCalcQueue
        Description: Execute method of queueable interface. Updates Opportunity
        Paramenters: NA
        Return Value: void. 
        *******************************/
    public void execute(QueueableContext context) {
       
        Savepoint sp;
       
       sp = Database.SetSavePoint(); 
       Boolean isSuccess = false;
       Opportunity oppToUpd;
       try{ 
          oppToUpd = OppMobAnalyticCalc.calcAnalyticsOnOpp(newFteList , newOcdList );
          System.debug('oppToUpd ' + oppToUpd);
          /*
          if(oppToUpd <> null){
              Database.update(oppToUpd, true);
          }
          */
          //Moved to Mob Analytics for rollback
          isSuccess = true;
       }
       catch(Exception e){
            Database.rollback(sp);
            System.debug('Exception  : ' + e);
            ExceptionClass.logException('OppAnalyticCalcQueue', 'calcAnalyticsOnOppQueue' , e, UtilConstants.APPLICATION_MWB, 'Mob Analytics');
            costing_request__c cost = new costing_request__c(id=costingData.get( UtilConstants.ID));
            cost.Calculation__c = false;
            cost.sync_failed_at__c = 'Opp Analytics';
            cost.Data_Cleaning_dev__c =true;
            cost.In_Progress_IO__c = costingData.get('In_Progress_PrevState__c'); 
            update cost;
            isSuccess = false;
            sync_status__c syncstat = [select id,error__c, Calculation_failed__c from sync_Status__C where opportunity__c=:oppToUpd.Id limit 1];
            syncstat.error__c ='Sync Was Successful, Calculations Failed';
            syncstat.Calculation_failed__c = true;
            update syncstat;
       }
       finally{
            set<id> datalist = new set<id>();
           if(isSuccess){
                   System.debug('oppToUpd ' + oppToUpd );
                  //ystem.debug('getLimitQueueableJobs' + Limits.getLimitQueueableJobs() + 'getQueueableJobs' + Limits.getQueueableJobs());
                   if(!Test.IsRunningTest()){
                       System.enqueueJob(new MobAnalyticsUtil(oldFteList, newFteList, oldOcdList, newOcdList, costingData, oldBnchId, newBnchId, oldBnchSumId, newBnchSumId, oppToUpd ));
                   }
                   else{
                       update OppToUpd;
                   }    
               }
           else{
                 datalist.addALL(newFteList);
                 datalist.addALL(newOCDList);
                 datalist.add(newBnchId);
                 datalist.addAll(newBnchSumId);
                 database.executeBatch(new deletebatchsync(datalist, oppToUpd.id, 'Rollback',costingData,'BPO' ));
             }    
       }
    }
}
/**********************************************************************************************************

    private class OppAnalyticsWrapper{
        private String opportunityId;
        private Decimal total_Mob_Cost = 0;
     
****************************************************************************************/