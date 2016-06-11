/**
   @Author         : Reena Thakre
   @name           : VFP_UpdateSAPOnVisitController
   @CreateDate     : 23 November 2015
   @Description    : VF Page for selecting and linking an opportunity with client visit request 
   @Version        : 1.0
 **/
  
  
  public class VFC_UpdateSAPOnVisitController{
  
   public String searchTextId {
        get;
        set;
    }
    public String searchTextId1 {
        get;
        set;
    }
    public List <Opportunity> opprecList{
        get;
        set;
    }
   
    public id requestid;
    public String selectedId;
    Client_visit_request__c req=new client_visit_request__C();
    public VFC_UpdateSAPOnVisitController(){
    requestid= Apexpages.currentPage().getParameters().get('visitID');
    }
   
   public set<id>oppids=new set<id>();
   public void getSapOmRecord(){
   if(searchTextId!=null && searchTextId!='' ) {
   system.debug('>>>>searchTextId '+searchTextId );
       opprecList=[select id , name, sap_om_id__c from opportunity where sap_om_id__C=:searchTextId];
       for(opportunity opp:opprecList){   
       system.debug(opp);
       oppids.add(opp.id);
       }
   }
   
   
  if(searchTextId1!=null && searchTextId1!='') {
   system.debug('>>>>searchTextId '+searchTextId1 ); 
   opprecList=[select id , name, sap_om_id__c from opportunity where name=:searchTextId1 or id in  :oppids];
   }
   }
  
  
     public PageReference  callSelect() {        
         String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        selectedId = Apexpages.currentPage().getParameters().get(UtilConstants.SELECTED_ID);
        try{
            system.debug('selectedId '+selectedId );            
            req=[select id,recordtypeid, opportunity__c from client_visit_request__C where id=:requestid];
            system.debug('req'+req);
            req.opportunity__c=selectedId ;
            req.recordtypeid=label.Client_visit_with_Opp_Record_Type;
            update req;
            PageReference pg = new PageReference(baseUrl + UtilConstants.SLASH_OPRTR + requestid);
            return pg;
        }catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstants.PAGE_MSG_4 + ex.getMessage()));
            return null;
        }       
    }  
  }