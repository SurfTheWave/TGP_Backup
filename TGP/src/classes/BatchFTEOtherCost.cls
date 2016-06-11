/**   @Author Vishal Tulsiyan
   @name   BatchFTEOtherCost
   @CreateDate 26 Augest 2015
   @Description BatchFTEOtherCost
   @Version
  */
public class BatchFTEOtherCost implements Database.Batchable<list<sobject>>{
    List<list<sobject>> datalist;
    id OpportunityID;
    

    /**
   *  @name : BatchFTEOtherCost
   *  @Description : constructor
   *  @param : opportunity ID
   *  @return parameter - NA
   *  @throws exception- NA
   */
    public BatchFTEOtherCost(ID oppid,string srvGrp){
    OpportunityID=oppid;
    List<FTE_Details__c >ftedetails= new list<FTE_Details__c>();
      
    List<Other_Cost_Details__c> ocddetails = new List<Other_Cost_Details__c>();
    
    list<payroll__c> oldpayroll = new list<payroll__c>();
    if(srvGrp.equalsignorecase(SWBBPOSEIntegrationConstants.BPO)){
        ftedetails = [SELECT id FROM FTE_Details__c where opportunity__c =:OpportunityID AND Service_Group__c=:srvGrp LIMIT 5000];
        ocddetails = [SELECT id FROM Other_Cost_Details__c where opportunity__c=:OpportunityID AND Service_Group__c=:srvGrp LIMIT 5000];
        oldpayroll = [select id from payroll__c where opportunity__c=:oppid AND Service_Group__c=:srvGrp limit 5000];
    }
    else{
        ftedetails = [SELECT id FROM FTE_Details__c where opportunity__c =:OpportunityID AND 
                    (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC) LIMIT 5000];
        ocddetails = [SELECT id FROM Other_Cost_Details__c where opportunity__c=:OpportunityID AND
                    (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC) LIMIT 5000];
        oldpayroll = [select id from payroll__c where opportunity__c=:oppid AND
                    (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC) limit 5000];
    }
    if(!oldpayroll.isempty()){
        try{
          database.delete(oldpayroll,true);
        }
        catch(exception e){
            
        }
    }
        datalist= new List<list<sobject>>();
         if(ftedetails.size() >0){
             datalist.add((list<sobject>) ftedetails);
         }
         if(srvGrp.equalsignorecase(SWBBPOSEIntegrationConstants.BPO)){
             if(ocddetails.size() > 0){
                 datalist.add((list<sobject>) ocddetails);
             }
         }
         system.debug('dataliet---->'+datalist);
    }
    

    /**
   *  @name : start
   *  @Description : start method
   *  @param : BatchableContext
   *  @return parameter - datalist
   *  @throws exception- NA
   */
    public Iterable<list<sobject>> start(Database.BatchableContext bc){
        return datalist;    
    }
    

    /**
   *  @name : execute
   *  @Description : execute method
   *  @param : BatchableContext, scope
   *  @return parameter - NA
   *  @throws exception- NA
   */    

    public void execute(Database.BatchableContext bc, List<list<sobject>> scope){
        list<fte_details__c> ftelist = new list<fte_details__c>();
        list<other_cost_details__c> ocdlist = new list<other_cost_details__c>();
        system.debug('combined list-->'+scope);
        try{
        if(scope[0].size()>0 ){
            if(scope[0] instanceof list<fte_details__c>){
                ftelist  = ((list<fte_details__c>)scope[0]);
            }
            if(scope[0] instanceof list<Other_cost_details__c>){
                ocdlist = ((list<Other_cost_details__c>)scope[0]);
            }
        }
        if(scope.size()>0){
            if(scope[1].size()>0 ){
                if(scope[1] instanceof list<fte_details__c>){
                    ftelist  = ((list<fte_details__c>)scope[1]);
                }
                if(scope[1] instanceof list<Other_cost_details__c>){
                    ocdlist = ((list<Other_cost_details__c>)scope[1]);
                }
            }
        }
        }
        catch(exception e){
            
        }
        finally{
        if(!ftelist.isEmpty()){
                FTEDetailsTriggerOperations.populatePayrollData(ftelist);
        }
        if(!ocdlist.isEmpty()){
                OtherCostTriggerOperation.populatePayrollData(ocdlist);
        }
        }
    }
    /**
   *  @name : finish
   *  @Description : finish method
   *  @param : BatchableContext
   *  @return parameter - NA
   *  @throws exception- NA
   */ 
    public void finish(Database.BatchableContext bc){
    }    
}