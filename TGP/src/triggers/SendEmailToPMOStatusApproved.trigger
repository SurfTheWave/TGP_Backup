trigger SendEmailToPMOStatusApproved on Review_Process__c (after update) {
List<Review_Action_Item_Log__c> lstreviewActItmLog  = new List<Review_Action_Item_Log__c>();
public Boolean isAllRecordStatusCompleted=false;
public Boolean isPresent=false;
lstreviewActItmLog =[Select Issue_Status__c,id,name,Review_Process__c from Review_Action_Item_Log__c];
    
     if(trigger.isUpdate)
     {
       for(Review_Process__c rp :Trigger.new)
       {
          if(rp.NewStatus__c=='Approved')
          {
              isAllRecordStatusCompleted=true;
              isPresent=false;
              if(lstreviewActItmLog.size()>0)
              {
                    for(Review_Action_Item_Log__c rail :lstreviewActItmLog)
                    {
                        if(rail.Review_Process__c == rp.id)
                         {
                             isPresent=true;
                              if(rail.Issue_Status__c!='Completed')
                              {
                                isAllRecordStatusCompleted=false;
                              }
                         }
                    }
              }
              else
              {
                  isAllRecordStatusCompleted=false;
              }
              
              if(isAllRecordStatusCompleted==true && isPresent==true)
               {
                 //ReviewActionItemLogAdd_InlineController railaic = new ReviewActionItemLogAdd_InlineController(new ApexPages.StandardController(new Review_Process__c ()));
                 ReviewActionItemLogAdd_InlineController.sendMailReview(rp);
               }
              
          }
       }
       
     }

}