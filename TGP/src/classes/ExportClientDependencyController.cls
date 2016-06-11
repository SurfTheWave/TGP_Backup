public class ExportClientDependencyController {
    public List<Client_Dependency__c > listProfileDetailsActual {get;set;}
    public List<Client_Dependency__c > lstClientDependency{get;set;}
    public Client_Dependency__c newClientDependency {get;set;}
    public List<Client_Dependency__c > listClientDependency  {get;set;}
    public String oppOffId{get;set;}
    public List<Opportunity_Offering__c> oppOff {get;set;}
    public List<Opportunity_Offering__c> oppOffName {get;set;}
    public List<Services__c> services {get;set;}
    public List<Client_Dependency_Master__c> listClientDependencyMaster {get;set;}
    public Client_Dependency_Master__c newClientDependencyMaster {get;set;}
    
    public ExportClientDependencyController(ApexPages.StandardController controller) {
     
    oppOffId = ApexPages.CurrentPage().getParameters().get('id'); 
     if(oppOffId != null && oppOffId!='')
     {
     
       listClientDependency = [Select Category__c,Applicable_form__c,Editable_form__c,Client_Dependency__c,Category_Master__c,Category_Master__r.Name ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                            Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Opportunity_Offering__r.Name from Client_Dependency__c where Opportunity_Offering__c = : oppOffId ];
                                            
      oppOff = new List<Opportunity_Offering__c>();                                      
     
      oppOff = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: oppOffId];
      
      services = new List<Services__c>();
      //services =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:oppOffId];
      services =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
      
      listClientDependencyMaster = new List<Client_Dependency_Master__c>();
      
      listClientDependencyMaster = [Select Category__c,Category_Master__c,Client_Dependency__c ,id,Offering__r.Name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                              from Client_Dependency_Master__c where Active_Inactive__c= :true 
                              and (Offering__r.Name =:oppOff[0].Offering_Master__r.Name)];
      
      lstClientDependency = new List<Client_Dependency__c>();     
        
       if(listClientDependency!=null && listClientDependency.size()<=0)
        {
            
            
            if(listClientDependencyMaster!=null && listClientDependencyMaster.size()>0)
            {
                
                for(Client_Dependency_Master__c newAssum: listClientDependencyMaster)
                {
                    Client_Dependency__c newAssRec= new Client_Dependency__c();
                    newAssRec.Category_Master__c=newAssum.Category_Master__c;
                    newAssRec.Client_Dependency__c=newAssum.Client_Dependency__c;
                    newAssRec.Services_per_Offering__c=newAssum.Services_per_Offering__r.name;
                                   
                                
                    
                    lstClientDependency.add(newAssRec);
                    
                }
            }
        }
        else
        {                 
             
             lstClientDependency = new List<Client_Dependency__c>();
             
             for(Client_Dependency__c ClientDependency : listClientDependency)
             {
                
                 lstClientDependency.add(ClientDependency);
                
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
        
        String FileName = 'ClientDependency';
        return FileName ;
       
    }

}