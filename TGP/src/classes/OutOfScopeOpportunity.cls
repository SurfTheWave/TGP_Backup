/*
  @Author: Rishab
  @Name: OutOfScopeOpportunity 
  @Created Date: 
  @Description:
  @version: 1.0
*/
public with sharing class OutOfScopeOpportunity {
    Public List<Opportunity> oppRecordToDisplay{get;set;}
    /*
  @Author: Rishab
  @Name: OutOfScopeOpportunity
  @Created Date: 
  @Description:
  @version: 1.0
*/
    Public OutOfScopeOpportunity(){
        Set<id> oppID = new Set<id>(); 
        try{
            List<Tech_Tools__c> techRecords=[SELECT Id,Scope_Status__c, Service__r.Solutionscope__r.Opportunity__r.id FROM Tech_Tools__c 
            where Scope_Status__c=: UtillContstant_Novasuite.OUT_OF_SCOPE limit 50000];
            if(!techRecords.isEmpty()){
                for(Tech_Tools__c tech:techRecords){             
                      if(oppID != null){
                          if(!oppID.contains(tech.Service__r.Solutionscope__r.Opportunity__r.id)){
                              oppID.add(tech.Service__r.Solutionscope__r.Opportunity__r.id);      
                          }
                      }else{
                         oppID.add(tech.Service__r.Solutionscope__r.Opportunity__r.id);
                     }  
                }
            }
            oppRecordToDisplay = [Select id,SAP_OM_Item_Id__c,Name,StageName,Account.Name,Opportunity_Solution_Lead__c,Geo_Region__c,Geo_Unit__c,OperatingGroup__c,Service_Grp__c from opportunity where id IN:oppID limit 50000];
        }catch(Exception ex){
            System.debug('ex ---'+ ex.getMessage());
        }
               
    }    

}