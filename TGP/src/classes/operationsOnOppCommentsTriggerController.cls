/**
   @Author         : Komal Priya
   @name           : operationsOnOppCommentsTriggerController
   @CreateDate     : 22 December 2014
   @Description    : TriggerHandler Class for triggers on Opportunity Comment object
   @Version        : 1.0
  */

public with sharing class operationsOnOppCommentsTriggerController{
    
    /**
   *  @Description        : This method is used to update Latest Comment field of opportunity record when any comment is added or updated
   *  @name               : updateOpportunityRecords
   *  @param              : List<Opportunity_Comments__c> commentsNewList
   *  @return parameter   : void
   *  @throws exception   : DML Exception
   */

    public static void updateOpportunityRecords(List<Opportunity_Comments__c> commentsNewList){
        
        set<ID> oppIds = new set<ID>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        
        for(Opportunity_Comments__c oppCoomentsRec : commentsNewList){
        
                oppIds.add(oppCoomentsRec.opportunity__c);
        }
        for(Opportunity oppRec : [select name,id,Latest_Comment__c,(select CreatedDate,comments__c,opportunity__c from Opportunity_Comments__r order by CreatedDate desc limit 1),Latest_Comment_Date__c from opportunity where id IN : oppIds]){
            
            if(oppRec.Opportunity_Comments__r.size() > 0){
                    Opportunity_Comments__c oppObj = oppRec.Opportunity_Comments__r;
                        oppRec.Latest_Comment__c = oppObj.comments__c;
                        
                        oppListToUpdate.add(oppRec);
                
            }
            
        }
        
       try{ 
            update oppListToUpdate;
       }
       catch(Exception ex){
        
            system.debug('-------ex-----'+ex);
        
       }
        
    
    } 
    /**
   *  @Description         :This method is used to update Latest Comment field of opportunity record when any comment is deleted
   *  @name                : deleteCommentsRecords
   *  @param               : List<Opportunity_Comments__c> commentsOldList
   *  @return <parameter>  : void
   *  @throws exception-   : DML Exception
   */
   
    public static void deleteCommentsRecords(List<Opportunity_Comments__c> commentsOldList){
        
        set<ID> oppIds = new set<ID>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        
        for(Opportunity_Comments__c oppCoomentsRec : commentsOldList){
        
                oppIds.add(oppCoomentsRec.opportunity__c);
        }
        for(Opportunity oppRec : [select name,id,Latest_Comment__c,(select CreatedDate,comments__c,opportunity__c from Opportunity_Comments__r order by CreatedDate desc limit 1),Latest_Comment_Date__c from opportunity where id IN : oppIds]){
            
            if(oppRec.Opportunity_Comments__r.size() > 0){
                
                        Opportunity_Comments__c oppObj = oppRec.Opportunity_Comments__r;
                        oppRec.Latest_Comment__c = oppObj.comments__c;
                        
                        oppListToUpdate.add(oppRec);
                
            }
            
        }
        
        try{ 
            update oppListToUpdate;
        }
        catch(Exception ex){
        
            system.debug('-------ex-----'+ex);
        
        }
    }

}