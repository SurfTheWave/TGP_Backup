/**
   @Author Mobilization Workbench
   @name InfrastructureServiceController
   @CreateDate 08/12/2015
   @Description This is a MWB class
   @Version <1.0>
   @reference 
  */
public with sharing class InfrastructureServiceController {
    public string InfrastructId {get;set;}
    public Infrastructure_Service__c infrastructureService {get;set;}
    public String diplayErrorOffering {get;set;}
    public String diplayErrorService {get;set;}
    //public String diplayErrorServiceComponent {get;set;}
    public String retUrl;

     /**
     * @description       This method uses the Infrastructure_Service__c standard controller  .
     * @param             Infrastructure_Service__c standard Controller 
     * @return            Infrastructure_Service__c records on the VF_ClientProcess
     * @throws            NA
     */    
    public InfrastructureServiceController(ApexPages.StandardController controller) {
        
        InfrastructId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        retUrl = ApexPages.currentPage().getParameters().get(UtilConstants.RET_URL);
        this.infrastructureService  = (Infrastructure_Service__c )controller.getRecord();
        if(InfrastructId != null && InfrastructId != UtilConstants.EMPTY_STRING){
         infrastructureService = [SELECT Id, Deal__c, Deal__r.Name, ServiceOffering__c, ServiceOffering__r.Name,
                    ServiceComponent__c, ServiceComponent__r.name, SubService__c, SubService__r.name,ServiceComments__c,Name FROM
                    Infrastructure_Service__c where ID=:InfrastructId LIMIT 1];
        }
        diplayErrorOffering = UtilConstants.DISPLAY_NONE;
        diplayErrorService =UtilConstants.DISPLAY_NONE;
    }
    /**
    * @description       This action function save the Infrastructure_Service__c specific record.
    * @param             Deal, Infrastructure Service parametrs are provided through VF_OppTeam UI functionality
    * @return            Null
    * @throws            NA
    */
    public pageReference saveRecord(){
         try{

            if(InfrastructId != null && InfrastructId != UtilConstants.EMPTY_STRING){
                Database.update(infrastructureService, true);
            }else{
                Database.insert(infrastructureService, true);
            }
                return new PageReference(UtilConstants.SLASH+retUrl);               
         }catch(DMLException e){
                ApexPages.Message errMsg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(0));
                ApexPages.addMessage(errMsg);  
                return null;
        }catch(exception e){
            String msg = e.getMessage();
            return null;
        }

    }
    /**
    * @description       This action function refreshes the UI functionality page.
    * @param             Refershes VF_OppTeam UI functionality
    * @return            Null
    * @throws            NA
    */
    public pageReference refreshPg(){
        return null;
    }
}