trigger OppKeybuyerTrigger on Opportunity_Key_Buyer__c (Before insert,Before Update) {
    
    List<Opportunity_Key_Buyer__c> finalOpkyList = new List<Opportunity_Key_Buyer__c>();
    List<Opportunity_Key_Buyer__c> insertListe=new List<Opportunity_Key_Buyer__c>();
    if(Trigger.IsBefore && Trigger.IsInsert){
        for(Opportunity_Key_Buyer__c opp:trigger.new){
            if(!opp.Key_Buyer_Flag__c){
              insertListe.add(opp);  
            }
        }
        if(!insertListe.isEmpty()){
            KeyBuyerValueShare.shareKeyBuyer(insertListe);
        }
        
    }
    
    
    if(Trigger.IsBefore && Trigger.IsUpdate){
        for(opportunity_key_buyer__c op: Trigger.new){
            opportunity_key_buyer__c oppk = trigger.oldmap.get(op.ID);
            if(oppk.Opportunity__c!=null){
                if(!((oppk.Opportunity__c).equals(op.Opportunity__c))){
                    if(!op.Key_Buyer_Flag__c){
                        finalOpkyList.add(op);
                    }
                    
                    
                }
            }
        }
        if(!finalOpkyList.isEmpty()){
            KeyBuyerValueShare.shareKeyBuyer(finalOpkyList);    
        }
        
    }
    

}