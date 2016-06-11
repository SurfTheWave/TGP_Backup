/*
@Author : Reena 
@name : clientVisitRequestTrigger
@Description :  
@Version : 
*/
trigger ClientVisitRequestTrigger on Client_Visit_Request__c (before update,before insert,after insert,after delete,after update) {

    clientVisitRequest visit=new clientVisitRequest();
    Boolean flag;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].ClientVisit__c; 
        system.debug('>>>>>>>flag>>'+flag);
    }
    
    
    if(trigger.isBefore){
        if(trigger.isInsert){
        boolean isUpdate=false;
             visit.assignOppRelatedFields(trigger.new,isUpdate);
        }
    
    
    }
    
    if(trigger.isBefore){
      
        if(trigger.isUpdate){
            List<Client_Visit_Request__c> clist=new List<Client_Visit_Request__c>();
                for(integer i=0;i<trigger.new.size();i++){
                    if(trigger.old[i].opportunity__C!=trigger.new[i].opportunity__c){
                    
                    clist.add(trigger.new[i]);
                       }
                       
                       
                   } 
                   
                   if(clist.size()>0){
                       
                        visit.assignOppRelatedFields(trigger.new,true);
                       }
                }
          }      
    
    
    if(trigger.isAfter){
        if(trigger.isInsert){
                
                visit.createClientVisitEvents(trigger.new);
                if(flag){
                 clientVisitRequest.sendEmailonCreate(trigger.new);
                 }
        }
        if(trigger.isDelete){
                visit.deleteClientVisitEvents(trigger.old);
        }
        
        if(trigger.isUpdate){
        List<Client_Visit_Request__c> clist=new List<Client_Visit_Request__c>();
                
                for(integer i=0;i<trigger.new.size();i++){
                
                    if(trigger.old[i].Visit_Date_To__c!=trigger.new[i].Visit_Date_To__c||trigger.old[i].Visit_Date_From__c!=trigger.new[i].Visit_Date_From__c){
                    visit.deleteClientVisitEvents(trigger.old);
                    visit.createClientVisitEvents(trigger.new);
                    
                    }else{
                    visit.updateClientVisitEvents(trigger.new);
                    
                    
                    }
                    if(trigger.old[i].Request_Status__c!=trigger.new[i].Request_Status__c && trigger.new[i].Request_Status__c=='Completed'){
                    clist.add(trigger.new[i]);
                       } 
                       
               }
               
               if(clist.size()>0 && flag==true){
                       clientVisitRequest.sendEmailonCreate(clist);
                       }
               
               
               
        }
    }

}