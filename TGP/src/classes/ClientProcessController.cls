/**
 * @author         Madhusudhan
 * @date          06/05/2015
 * @description   This class is used for insert/ update record in Client Specific proccess object while select the value from custom lookup.
 * @vesion        <1.0>
 */
public with sharing class ClientProcessController {
    public string dealId {get;set;}
    public Client_Specific_Process__c clientSpecificProcess {get;set;}
    public String diplayErrorOffering {get;set;}
    public String diplayErrorService {get;set;}
    public String diplayErrorRole {get;set;}
    public String retUrl;

     /**
     * @description       This method uses the Client_Specific_Process__c standard controller  .
     * @param             Client_Specific_Process__c standard Controller 
     * @return            Client_Specific_Process__c records on the VF_ClientProcess
     * @throws            NA
     */    
    public ClientProcessController(ApexPages.StandardController controller) {
        
        dealId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        retUrl = ApexPages.currentPage().getParameters().get(UtilConstants.RET_URL);
        this.clientSpecificProcess  = (Client_Specific_Process__c )controller.getRecord();
        system.debug('clientSpecificProcess--- '+clientSpecificProcess);
        //if(!dealId.isBlank()){}
        if(dealId != null && dealId != UtilConstants.EMPTY_STRING){
         clientSpecificProcess = [SELECT Id, Deal__c, Deal__r.Name, Process_Offering__c, Process_Offering__r.Name,
                    Process_Service_Component__c, Process_Service_Component__r.name, Process_Services__c, Process_Services__r.name,Process_Comments__c,Name FROM
                    Client_Specific_Process__c where Id=:dealId LIMIT 5000];
                    system.debug('clientSpecificProcess-inside if condition-- '+clientSpecificProcess);
        
        }
        diplayErrorOffering = UtilConstants.DISPLAY_NONE;
        diplayErrorService =UtilConstants.DISPLAY_NONE;
    }
    /**
    * @description       This action function save the Opportunity Teams specific record.
    * @param             Deal, Opportunity Team Member, Solution Scope parametrs are provided through VF_OppTeam UI functionality
    * @return            Null
    * @throws            NA
    */
    public pageReference saveRecord(){
         //System.debug('Total rec--'+oppteam);
         try{

            if(dealId != null && dealId != UtilConstants.EMPTY_STRING){
              //  system.debug('clientSpecificProcess-update-- '+clientSpecificProcess);
                Database.update(clientSpecificProcess, true);
            }else{
             //   system.debug('clientSpecificProcess-insert-- '+clientSpecificProcess);
                Database.insert(clientSpecificProcess, true);
            }
                return new PageReference(UtilConstants.SLASH+retUrl);               
        }catch(DMLexception e){
            //System.debug('error--'+e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            //ApexPages.addMessage(myMsg);                
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            String msg = e.getMessage();
        }
        return null;
    }
    /**
    * @description       This action function refreshes the UI functionality page.
    * @param             Refershes VF_OppTeam UI functionality
    * @return            Null
    * @throws            NA
    */
    public pageReference refreshPg(){
        //System.debug('Refresh Mth--'+oppteam.Opportunity__c);
        return null;
    }
}