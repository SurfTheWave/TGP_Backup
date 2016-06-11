public class OpportunityDocDetails {
    ApexPages.standardController oppController = null;
    public string SelectedDocId { get; set; }
    public List<opportunity_documents__c> OppDocs { get; set; }
    private final Opportunity_Documents__c oppDocument;
    public String service_group;
    public Attachment lst_Docs {get; set;}
    public boolean isDocuploaded {get; set;}
    public Opportunity BPO_Opp{get; set;}
    public BenchMark__c bechmarkOpp;
    public id benchOppId {get; set;}
    public String sapOm {get; set;}
    public String name {get; set;}
    public String clientName {get; set;}
    List<Opportunity_Documents__c> opportunityDoc;
    List<Opportunity_Documents__c> techOpportunityDoc;
    
    public OpportunityDocDetails(ApexPages.StandardController controller) {
       
      
    this.oppController = controller;
    this.oppDocument = (Opportunity_Documents__c)oppController.getRecord();
    system.debug('oppDocument-->'+this.oppDocument );
    
    }
  
    public String getOpportunityDetails(){
    getOpportunityId();
    List<Opportunity> oppList = new List<Opportunity>();
    if(null != oppDocument.opportunity__c){
    Opportunity opp = [select id, name, sap_om_id__c,account.name from opportunity where id =:oppDocument.opportunity__c];
    sapOm = opp.sap_om_id__c;
          name = opp.name;
          clientName = opp.account.name;
          return 'MMS ID  : &nbsp; &nbsp;'+ '&nbsp;'+'  '  + sapOm + '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '  + 'Client Name' + ' :'+ ' &nbsp;&nbsp;' + clientName + '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+'Opportunity Name'+ ' :'+'&nbsp; &nbsp; &nbsp; ' + name;
         }else    
         {
         return '';
         }
    }
    
    public String getStaticText(){
    getOpportunityId();
    String text = '';
        if(service_group == 'BPO'){
    text = 'Please upload key solution documents to the required documents folder including but not limited to BPO Specific Documents:'+'<br/>'+'<br/>'+
      '  •         Overall Solution Plan Deck'+ '<br/>'+
       ' •         Mobilization Plan Deck'+ '<br/>'+
       ' •         Technology Plan Deck'+ '<br/>'+
       ' •         QEP Plan Summary'+ '<br/>'+
        '•         Risk Qualification Tool' + '<br/>';

    } else if(service_group == 'IC' || service_group == 'IO'){
     text = 'Please upload key solution documents to the required documents folder including but not limited to IS Specific Documents:'+'<br/>'+'<br/>' +
  ' •         Overall Solution Plan Deck'+ '<br/>'+
 '  •         DCSO Document'+ '<br/>' +
  ' •         IO Transition Estimate (STE)'; 

    }else{
    
    text = 'Please upload key solution documents to the required documents folder including but not limited to BPO Specific Documents:'+'<br/>'+
      '  •         Overall Solution Plan Deck'+ '<br/>'+
       ' •         Mobilization Plan Deck'+ '<br/>'+
       ' •         Technology Plan Deck'+ '<br/>'+
       ' •         QEP Plan Summary'+ '<br/>'+
        '•         Risk Qualification Tool' + '<br/>'+'<br/>'+
        'Please upload key solution documents to the required documents folder including but not limited to IS Specific Documents:'+'<br/>'+
  ' •         Overall Solution Plan Deck'+ '<br/>'+
 '  •         DCSO Document'+ '<br/>' +
  ' •         IO Transition Estimate (STE)' + '<br/>';
    }

    return text;
    }
    
    public PageReference getOpportunityId(){
    if(oppDocument.opportunity__c!=null){
        
    }else {
        oppDocument.opportunity__c = ApexPages.currentPage().getParameters().get('oid');
    }
    
    service_group = ApexPages.currentPage().getParameters().get('ServiceGroup');
    system.debug(service_group);
    
    return null;
    }
    
    public Attachment getDocs(){
       getOpportunityId();
        isDocuploaded = false;
        try{
            
           
            bechmarkOpp=[SELECT Id FROM BenchMark__c WHERE Opportunity__c =:oppDocument.opportunity__c limit 1];      
            benchOppId=bechmarkOpp.id;
            lst_Docs = [select id,name,description,createdDate from Attachment where parentId=:benchOppId limit 1];
            
            if(lst_Docs!=null){
                isDocuploaded = true;
            }    
         }catch(Exception e){
             String sre = e.getMessage();
             
         }
         return lst_Docs;
    }
    
    public Pagereference backToOpportunity(){
    Pagereference oppPage = new Pagereference('/'+oppDocument.opportunity__c);
    return oppPage;
    }
    
     public Pagereference pageredir()
    {Pagereference newpage = null;
    newpage = new Pagereference ('/apex/OpportunityDocumentDetailPage?oid='+oppDocument.opportunity__c);
    newPage.setRedirect(false);
    return newpage;
    }
    
    public Pagereference backToPage()
    {
    String userName = UserInfo.getFirstname()+' '+Userinfo.getLastName();
    this.oppDocument.modified_by__c= userName;
    this.oppController.save();
    Pagereference oldPage = new Pagereference('/apex/OpportunityDocumentPage?oid='+oppDocument.opportunity__c);
    oldPage.setRedirect(true);
    return oldPage;
    }
    
    public Pagereference CancelPage()
    {
    this.oppController.cancel();
    Pagereference oldPage = new Pagereference('/apex/OpportunityDocumentPage?oid='+oppDocument.opportunity__c);
   // oldPage.setRedirect(true);
    return oldPage;
    }
    public String getSharePointUrl(){
    if(null!= oppDocument.opportunity__c){
    Opportunity currentOpp = [select id, Link_to_SharePoint_Documents__c from Opportunity where id=:oppDocument.opportunity__c]; 
    
        if(currentOpp.Link_to_SharePoint_Documents__c!=null ||currentOpp.Link_to_SharePoint_Documents__c!= ''){
            return currentOpp.Link_to_SharePoint_Documents__c;
            }else
            {
                return  'There is no such folder present!';
            }
   }
    return 'https://adtkm2amr1.accenture.com/sites/BPOSD/Opportunity%20Documents%20%20Documents/Forms/AllItems.aspx';
    }
    public List<Opportunity_Documents__c> getOpportunityDoumentList(){  
    getOpportunityId();
    opportunityDoc = [select id,modified_date__c,Modified_Onn__c,modified_by__c, Document_Link__c ,opportunity__c from Opportunity_Documents__c  where Opportunity__c=:oppDocument.opportunity__c and IS_Tech_Document__c=false ORDER BY modified_date__c DESC NULLS LAST];
    return opportunityDoc;
    }
    public void DeleteRecord(){
    if (SelectedDocId == null) {               
    return;      
    } 
    OppDocs = [SELECT Id FROM Opportunity_Documents__c WHERE id =: SelectedDocId LIMIT 10];
    Opportunity_Documents__c tobeDeleted = new Opportunity_Documents__c();
         //system.debug('-- SelectedDocId-173:'+SelectedDocId);
    if(OppDocs.size()> 0){
    for(Opportunity_Documents__c odel:OppDocs){
    if (odel.Id == SelectedDocId.subString(0,15)) {          
         tobeDeleted = odel;          
         break;       
        }
     }       
    }     
    if (tobeDeleted != null) {       
        Delete tobeDeleted;     
    }           
    
    }   
    public List<Opportunity_Documents__c> getTechOpportunityDoumentList(){  
    getOpportunityId();
    techOpportunityDoc = [select id,modified_date__c,Modified_Onn__c,modified_by__c, Document_Link__c ,IS_Tech_Document__c,opportunity__c from Opportunity_Documents__c  where Opportunity__c=:oppDocument.opportunity__c and IS_Tech_Document__c=true ORDER BY modified_date__c DESC NULLS LAST];
    return techOpportunityDoc;
    }
}