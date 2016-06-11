public class RestrictEdit{
    public sobject childRecord;
    public fte_details__c fteRecord;
    public other_cost_details__c ocdRecord;
    public payroll__c payroll;
    public Cross_Deal__c crossrec;
    public Volume_Detail__c volRecord;
    public string error{get;set;}
    public RestrictEdit(ApexPages.standardcontroller controller){
        childRecord= (sobject)controller.getRecord();  
    }
   public pageReference RestrictEditAccess(){
        PageReference pg;
        if(childRecord.getsobjectType() == fte_details__c.sobjectType){
            fteRecord=[SELECT Id, Service__c FROM fte_details__c where Id=:(Id)childRecord.Id ];
        }
        else if(childRecord.getsobjectType() == other_cost_details__c.sobjectType){
            ocdRecord=[SELECT Id, Service__c FROM other_cost_details__c where Id=:(Id)childRecord.Id ];
        }
        else if(childRecord.getsobjectType() == payroll__c.sobjectType){
            payroll=[SELECT Id, Service__c FROM payroll__c where Id=:(Id)childRecord.Id ];
        }
        else if(childRecord.getsobjectType() == Cross_Deal__c.sobjectType){
            crossrec=[SELECT Id, Service__c FROM Cross_Deal__c where Id=:(Id)childRecord.Id ];
        }
        else if(childRecord.getsobjectType() == Volume_Detail__c.sobjectType){
            volRecord=[SELECT Id, Service__c FROM Volume_Detail__c where Id=:(Id)childRecord.Id ];
        }
        error='You cannot edit this record.';
        pg=null;
        return pg;
    }
    public PageReference popUpRedirect(){
        PageReference pg;
        if(childRecord.getsobjectType() == fte_details__c.sobjectType){
            pg=new PageReference('/'+fteRecord.Service__c);
        }
        else if(childRecord.getsobjectType() == other_cost_details__c.sobjectType){
            pg=new PageReference('/'+ocdRecord.Service__c);
        }
        else if(childRecord.getsobjectType() == payroll__c.sobjectType){
            pg=new PageReference('/'+payroll.Service__c);
        }
        else if(childRecord.getsobjectType() == Cross_Deal__c.sobjectType){
            pg=new PageReference('/'+crossrec.Service__c);
        }
        else if(childRecord.getsobjectType() == Volume_Detail__c.sobjectType){
            pg=new PageReference('/'+volRecord.Service__c);
        }
         return pg;    
     }
    
    
}