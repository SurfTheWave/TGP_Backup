public class ExportAssumptionController {
    public List<Assumption__c > listProfileDetailsActual {get;set;}
    public List<Assumption__c > lstAssume{get;set;}
    public Assumption__c newAssumption {get;set;}
    public List<Assumption__c > listAssumption  {get;set;}
    public String oppOffId{get;set;}
    public List<Opportunity_Offering__c> oppOff {get;set;}
    public List<Opportunity_Offering__c> oppOffName {get;set;}
    public List<Services__c> services {get;set;}
    public List<Assumption_Master__c> listAssumptionMaster {get;set;}
    public Assumption_Master__c newAssumptionMaster {get;set;}
    
    public ExportAssumptionController(ApexPages.StandardController controller) {
     
    oppOffId = ApexPages.CurrentPage().getParameters().get('id'); 
     if(oppOffId != null && oppOffId!='')
     {
     
       listAssumption = [Select Category__c,Assumption__c,Applicable_form__c,Editable_form__c,Category_Master__c,Category_Master__r.Name,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                            Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,
                                            Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c = : oppOffId ];
                                            
      oppOff = new List<Opportunity_Offering__c>();                                      
     
      oppOff = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: oppOffId];
      
      services = new List<Services__c>();
      //services =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:oppOffId];
      services =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
      
      listAssumptionMaster = new List<Assumption_Master__c>();
      
      listAssumptionMaster = [Select Category__c,Category_Master__c, Assumption__c,Classification__c ,id,Offering__r.Name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                              from Assumption_Master__c where Active_Inactive__c= :true 
                              and (Offering__r.Name =:oppOff[0].Offering_Master__r.Name)];
      
      lstAssume = new List<Assumption__c>();     
        
       if(listAssumption!=null && listAssumption.size()<=0)
        {
            
            
            if(listAssumptionMaster!=null && listAssumptionMaster.size()>0)
            {
                
                for(Assumption_Master__c newAssum: listAssumptionMaster)
                {
                    Assumption__c newAssRec= new Assumption__c();
                    newAssRec.Category_Master__c=newAssum.Category_Master__c;
                    newAssRec.Assumption__c=newAssum.Assumption__c;
                    newAssRec.Services_per_Offering__c=newAssum.Services_per_Offering__r.name;
                    newAssRec.Classification__c=newAssum.Classification__c;                 
                                  
                    
                    lstAssume.add(newAssRec);
                    
                }
            }
        }
        else
        {                 
             
             lstAssume = new List<Assumption__c>();
             
             for(Assumption__c assumption : listAssumption)
             {
                
                 lstAssume.add(assumption);
                
             }         
         }    
       }
       else
       {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
         
       }

    }
   
   /* public String  getFileName()
    {
        
        String FileName = oppOff[0].Name + ''+'Assumptions';
        return FileName ;
       
    }*/

}