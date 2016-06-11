public class OppOverviewTabController {
    public Boolean flag {get;set;}
    public Boolean flagEdit{get;set;}
    public String pageid{get;set;}
    public Boolean addButtonRender {get; set;}
    public Opportunity_TGP__c opportunity1;
    public List<Opportunity_TGP__c> listopportunity1;
    public OppOverviewTabController(ApexPages.StandardController controller) {
         pageid=ApexPages.CurrentPage().getParameters().get('id');
       opportunity1=(Opportunity_TGP__c)controller.getRecord();
        addButtonRender = true;
        flag = true;
        flagEdit = false;
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;//Get users with Profile Name
        //Logic to not show add button for Sol Admin and Sol Leadership profile.
        List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
        solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
        for(Sol_UAM_Access_Setting__c solUam : solUamAccess){
            if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c)){
                    addButtonRender = false ;
            }
        }
    }
    /******************************
    Method Name: saverecord
    Description: To save Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecord()
    {         
        
        //Check for null
        if(opportunity1.Enterprise_Solution_Architect_New__c==null)
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field is missing: [Enterprise Solution Architect]'));
             return;
        }
       
        try
            {
                
                    upsert opportunity1;      
            }
            catch(Exception ex)
            {
               if(ex.getMessage().contains('Update failed')){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access rights: Cannot be Updated'));
                   return;
               }
            
            }  
            flag =true;
            flagEdit = false;
   }
    /******************************
    Method Name: Edit
    Description: To Edit Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void edit()
    {
        flag = false;
        flagEdit = true;
    }
     /******************************
    Method Name: cancelRecord
    Description: To cancel RecordOpportunity records.
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void cancelRecord()
    {
    listopportunity1= new List<Opportunity_TGP__c>();
             listopportunity1=[Select Id,Enterprise_Solution_Architect_New__c,RFI_Received__c,RFI_response_due__c,RFP_Received__c,Solution_Workshop__c,RFP_response_due__c,RFP_Down_Select__c,
                            Presentations_Orals__c,Reference_Checks_and_Site_Visits__c,Negotiations__c,Contract__c,Ramp_up_and_Service_Delivery__c,
                            Client_Overview__c,Link_to_client_website__c,TCV__c,X3rd_Party_Vendors_in_scope__c,
                            Third_party_Advisors__c,
                            Third_Party_Advisors_Comments__c,Transaction_or_volume_based__c,TBD__c,Fixed__c,FTE__c,Existing_Accenture_client__c,
                            Existing_BPO_Client__c
                            from Opportunity_TGP__c where Id = :pageid];
             if(listopportunity1.Size()>0){
            flag =true;
            flagEdit = false;
            }
         
    }

}