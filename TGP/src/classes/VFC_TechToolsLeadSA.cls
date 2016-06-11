/*
  @Author: Rishab
  @Name: VFC_TechToolsController
  @Created Date: 
  @Description:
  @version: 1.0
*/
public class VFC_TechToolsLeadSA{

    public VFC_TechToolsLeadSA() {

    }

    public List<Tech_tools__C> techTool{get;set;}
    public List<Tech_Tool_Comments__c> techToolComment{get;set;}  
    Public Opportunity OppRecord{get;set;}
    public List<TectToolsWrapper> techToolResultsList {get;set;}
     public  VFC_TechToolsLeadSA(ApexPages.StandardController controller){
       
     }
   
    Public void CallFirst(){
    
        OppRecord=[Select SAP_OM_Item_Id__c,Client_Name__c,Name,StageName,Account.Name,BPO_Reporting_Status__c,
                   Opportunity_Solution_Lead__c,Geo_Region__c,Geo_Unit__c,OperatingGroup__c,Service_Grp__c,
                   BPO_Net_Rev_Thousands__c,ECSD_Quarter__c from opportunity 
                   where  id = :ApexPages.currentPage().getParameters().get('id') ];
        techTool = [SELECT Id, Name,Custom_Tool_Name__c,Service__c,Service__r.services__c,Approval_For_Out_of_Scope_Tool__c,
                    Service__r.Solutionscope__r.Offering_Master__c,LastModifiedDate,Tech_Tool_Type__c,Comments__c,
                    LastModifiedBy.Name,Tech_Tool__c,Scope_Status__c,Out_Of_Scope_Reason__c,Out_Of_Scope_Reason_Description__c 
                    FROM Tech_tools__C
                    WHERE Scope_Status__c=:UtillContstant_Novasuite.OUT_OF_SCOPE AND Tech_Tool__r.Mandatory__C= TRUE 
                    AND Service__r.Solutionscope__r.Opportunity__r.Id =:ApexPages.currentPage().getParameters().get('id') ];                 
        if(!techTool.isEmpty()){
            techToolResultsList=new List<TectToolsWrapper>();
            for(Tech_tools__C techRec : techTool){                           
                TectToolsWrapper tech =new TectToolsWrapper(techRec);               
                techToolResultsList.add(tech);                          
            }
         }
    }
    
    
   
   /* static{
    TechToolTriggerHandler.isRecursive = false;
    }*/
    
    /*
      @Author: Rishab
      @Name: save
      @Created Date: 
      @Description:
      @version: 1.0
    */
    public PageReference save() {
    
        id OppID = ApexPages.currentPage().getParameters().get('id');        
        List<Tech_tools__c> techListToUpdate = new List<Tech_tools__C>();
        Id techId;
        for(TectToolsWrapper tech: techToolResultsList){            
            if(tech.checked){                             
                techListToUpdate.add(tech.techTool);      
                techId= tech.techTool.Id;         
                }              
            }        
                 
        if(techListToUpdate.size() > 0){
            
            update techListToUpdate;           
        }
        
        List<Id> userIds = new List<Id>();
        for(GroupMember gm:[SELECT Id, UserOrGroupId, GroupId FROM GroupMember WHERE GroupId='00G56000000T3lR']){
            userIds.add(gm.UserOrGroupId);
        }
        
        List<String> emailList = new List<String>();
        for(User us:[SELECT Email From User WHERE Id IN:userIds]){
            emailList.add(us.Email);
           
        }
        // system.debug('emailList--'+emailList);
        String tempId = [SELECT Id FROM EmailTemplate WHERE DeveloperName=:UtillContstant_Novasuite.TECH_TOOL_IS_OUT_OF_SCOPE_CAPABILITY LIMIT 1].id;
        //system.debug('tempId--'+tempId );
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(userIds[0]) ;
        mail.setTemplateId(tempId);
       // List<String> ccTo = new List<String>{'rishabh.b.agrawal@accenture.com','aswajit.swain@accenture.com'};
       // mail.setCcAddresses(ccTo); 
        mail.setToAddresses(emailList);          
        mail.saveAsActivity=false;
        mail.setWhatId(techId);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
              
        PageReference pg=new PageReference('/'+OppID);
        return pg;
        
        
    }
    
    /*
      @Author: Rishab
      @Name: doCancel
      @Created Date: 
      @Description:
      @version: 1.0
    */
    public PageReference doCancel() {
        PageReference pg=new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        return pg;
    }
}