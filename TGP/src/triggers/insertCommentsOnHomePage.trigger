trigger insertCommentsOnHomePage on Comments_on_Opportunity__c(after insert, after update, after delete) {

    List<Comments_on_Opportunity__c> commentList = Trigger.new;
    //List<Comments_on_Opportunity__c> commentList = [select Comments__c,BPO_Opportunity__c from Comments_on_Opportunity__c where ID IN : Trigger.new order by Created_Date__c DESC];
    List<Comments_on_Opportunity__c> oldCommentList = trigger.old;
    List<Opportunity_TGP__c> oppList = new List<Opportunity_TGP__c>();   
    
    
    if(trigger.isInsert){
        
        for(Comments_on_Opportunity__c commRec : commentList)
        {
            
            //commRec.BPO_Opportunity__c
            Opportunity_TGP__c oppToUpdate = new Opportunity_TGP__c();
            oppToUpdate.ID = commRec.BPO_Opportunity__c;
            oppToUpdate.Comments_Status__c  =  commRec.Comments__c;
            oppList.add(oppToUpdate);
        }
        update oppList;
    } 
    else if(Trigger.isupdate)
    {
        set<Opportunity_TGP__c> oppSet = new set<Opportunity_TGP__c>();
        for(Comments_on_Opportunity__c commRec : commentList)
        {
            Comments_on_Opportunity__c commRecList = [select id,Comments__c from Comments_on_Opportunity__c where BPO_Opportunity__c = : commRec.BPO_Opportunity__c order by createdDate desc limit 1];

            Opportunity_TGP__c oppToUpdate = new Opportunity_TGP__c();            
            oppToUpdate.Comments_Status__c  =  commRecList.Comments__c;
            oppToUpdate.ID = commRec.BPO_Opportunity__c;
            oppSet.add(oppToUpdate);
        }
        List<Opportunity_TGP__c> oppListToUpdate = new List<Opportunity_TGP__c>(oppSet);
        update oppListToUpdate;
    }
    else if(Trigger.isdelete)
    {
        
            for(Comments_on_Opportunity__c commRec : oldCommentList)
            {
                
                List<Comments_on_Opportunity__c> commRecList = new List<Comments_on_Opportunity__c>();
                
                id opId = commRec.BPO_Opportunity__c;
                //Comments_on_Opportunity__c comRecord1 = new Comments_on_Opportunity__c();
                //comRecord1 = [select id,CreatedDate,Comments__c from Comments_on_Opportunity__c where BPO_Opportunity__c = : opId limit 1];
                //system.debug('comRecord1' + comRecord1);
                
                //Comments_on_Opportunity__c comRecord2 = new Comments_on_Opportunity__c();     
                //comRecord2 = [select id,CreatedDate,Comments__c from Comments_on_Opportunity__c where BPO_Opportunity__c = : opId order by createdDate desc limit 1];
                //system.debug('comRecord2'+comRecord2);
                
                
                commRecList = [select id,CreatedDate,Comments__c from Comments_on_Opportunity__c where BPO_Opportunity__c = : commRec.BPO_Opportunity__c order by createdDate desc limit 1];
                if(commRecList != null && commRecList.size() > 0)
                {
                    //List<Comments_on_Opportunity__c> commRecList1 = [select id,Comments__c,CreatedDate from Comments_on_Opportunity__c where BPO_Opportunity__c = : commRec.BPO_Opportunity__c order by CreatedDate desc];          
                    Opportunity_TGP__c oppToUpdate = new Opportunity_TGP__c();
                    oppToUpdate.ID = commRec.BPO_Opportunity__c;
                    oppToUpdate.Comments_Status__c  =  commRecList[0].Comments__c;
                    oppList.add(oppToUpdate);
                }
                else
                {
                    Opportunity_TGP__c oppToUpdate = new Opportunity_TGP__c();
                    oppToUpdate.ID = commRec.BPO_Opportunity__c;
                    oppToUpdate.Comments_Status__c  =  null;
                    oppList.add(oppToUpdate);
                }
            }
         
         /*else
         {
             for(Comments_on_Opportunity__c commRec : oldCommentList)
            {
                Opportunity_TGP__c oppToUpdate = new Opportunity_TGP__c();
                oppToUpdate.ID = commRec.BPO_Opportunity__c;
                oppToUpdate.Comments_Status__c  =  null;
                oppList.add(oppToUpdate);
            }
         }*/
        update oppList;
    }

}