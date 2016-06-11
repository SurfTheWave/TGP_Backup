public class ExportRiskController {
    public List<Risk__c > listProfileDetailsActual {get;set;}
    public List<Risk__c > lstRisk{get;set;}
    public Risk__c newRisk {get;set;}
    public List<Risk__c > listRisk  {get;set;}
    public String oppOffId{get;set;}
    public List<Opportunity_Offering__c> oppOff {get;set;}
    public List<Opportunity_Offering__c> oppOffName {get;set;}
    public List<Services__c> services {get;set;}
    public List<Risk_Master__c> listRiskMaster {get;set;}
    public Risk_Master__c newRiskMaster {get;set;}
    
    public ExportRiskController(ApexPages.StandardController controller) {
     
    oppOffId = ApexPages.CurrentPage().getParameters().get('id'); 
     if(oppOffId != null && oppOffId!='')
     {
     
       listRisk = [Select Category__c,Risk__c,Applicable_form__c,Editable_form__c,Category_Master__c,Category_Master__r.Name,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                            Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Opportunity_Offering__r.Name,Risk_Impact__c
                                            ,Potential_Impact__c,Mitigation__c,Risk_probability__c,Raised_by__c,Raised_On__c from Risk__c where Opportunity_Offering__c = : oppOffId ];
                                            
      oppOff = new List<Opportunity_Offering__c>();                                      
     
      oppOff = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: oppOffId];
      
      services = new List<Services__c>();
      //services =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:oppOffId];
      services =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
      
      
      listRiskMaster = new List<Risk_Master__c>();
      
      listRiskMaster = [Select Category__c,Category_Master__c,Risks__c,Classification__c ,id,Offering_Master__r.Name,Service_Master__r.Name ,Name,Active_Inactive__c 
                              from Risk_Master__c where Active_Inactive__c= :true 
                              and (Offering_Master__r.Name =:oppOff[0].Offering_Master__r.Name)];
      
      lstRisk = new List<Risk__c>();     
        
       if(listRisk!=null && listRisk.size()<=0)
        {
            
            
            if(listRiskMaster!=null && listRiskMaster.size()>0)
            {
                
                for(Risk_Master__c newAssum: listRiskMaster)
                {
                    Risk__c newAssRec= new Risk__c();
                    newAssRec.Category_Master__c=newAssum.Category_Master__c;
                    newAssRec.Risk__c=newAssum.Risks__c;
                    newAssRec.Services_per_Offering__c=newAssum.Service_Master__r.name;
                    newAssRec.Classification__c=newAssum.Classification__c;                 
                                
                    
                    lstRisk.add(newAssRec);
                    
                }
            }
        }
        else
        {                 
             
             lstRisk = new List<Risk__c>();
             
             for(Risk__c Risk : listRisk)
             {
                
                 lstRisk.add(Risk);
                
             }         
         }    
       }
       else
       {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
         
       }

    }
   
    public String  getFileName()
    {
        
        String FileName = 'Risk';
        return FileName ;
       
    }

}