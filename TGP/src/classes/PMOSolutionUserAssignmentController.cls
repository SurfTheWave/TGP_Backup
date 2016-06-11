public without sharing class PMOSolutionUserAssignmentController {

 public List<Solution_User_Assignment__c> listSolutionUser{get;set;}
 public Solution_User_Assignment__c[] listProfileDetailsActual {get;set;}
 public List<SelectOption> strOfferingsList{get;set;}
 public List<SelectOption> strRoleRequestList{get;set;}
 public List<SelectOption> OpportunityList{get;set;}
 public List<SelectOption> SAPOMIDList{get;set;}
 public List<SelectOption> ClientList{get;set;}
 public List<SelectOption> OpportunityAddList{get;set;}
 public String strOffering{get; set;}
 public String strOppList{get; set;}
 public String strRoleRequested{get; set;} 
 public String strSAPOMID{get; set;} 
 public String strClient{get; set;} 
 public String strComment{get; set;}
 public String strDateNeededBy{get; set;}
 public String listOppSelected {get; set;}
 public String listSAPOMSelected {get; set;}
 public String listClientSelected {get; set;}
 public String oppSelect{get;set;}


public String strOppLookupValue {get;set;}
public String strClientName {get; set;}
public String strSAPOMIDName {get; set;}
public String OppId {get; set;}

public integer columnNos{get; set;}
public String runningUser {get; set;}
public String strUrl{get;set;}
public integer numberOfSeparateEmails{get;set;}
public List<Solution_User_Assignment__c> solUserAssignPageSize {get;set;}
public String submitRequestIds {get; set;}
public String dateNeeded {get;set;}public String dateRequested {get;set;}
public Set<ID> oppOffListId {get;set;}
  
  public Set<Id> oppListIDs {get;set;}
 List<Opportunity_TGP__c> oppListData {get;set;}
// the soql without the order and limit
  private String soql {get;set;}
  // the collection of Solution_User_Assignment__c to display
  public List<Solution_User_Assignment__c> solUserAssign {get;set;}

  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'CreatedDate'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir; }
    set;
  }
 
 
  // init the controller and display some sample data when the page loads
public PMOSolutionUserAssignmentController(ApexPages.StandardController controller) {

    //total_size = [select count() from Solution_User_Assignment__c ]; //set the total size in the constructor
    columnNos = 8;
    strUrl = URL.getSalesforceBaseUrl().toExternalForm();
    runningUser=UserInfo.getUserId();
    oppListIDs = new Set<Id>();
     oppListData= [select id from Opportunity_TGP__c order by createddate,id desc limit 50];
     for(Opportunity_TGP__c oppId : oppListData){
        oppListIDs.add(oppId.id);
     }       
 
    soql = 'Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Requester_Name__r.name from Solution_User_Assignment__c where Role__c != null and BPO_Opportunity__c IN : oppListIDs ';
    runQuery();
    searchCriteria();
  }
  
  public PMOSolutionUserAssignmentController() {
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    //runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
    try {
      //solUserAssign = Database.query(soql + ' order by ' + sortField + ' ' + sortDir);
      solUserAssign = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' LIMIT '+list_size +' OFFSET '+ counter );
      solUserAssignPageSize = Database.query(soql); 
      total_size =solUserAssignPageSize.size();
      //total_size = [select count() from Solution_User_Assignment__c ];
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String role = Apexpages.currentPage().getParameters().get('role');
    String status= Apexpages.currentPage().getParameters().get('status');
    String SAPSelect= Apexpages.currentPage().getParameters().get('SAPSelect');
    String clSelect= Apexpages.currentPage().getParameters().get('clSelect');
    String oppSelect= Apexpages.currentPage().getParameters().get('oppSelect');
 
    soql = 'Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c, Requester_Name__c,Requester_Name__r.name  from Solution_User_Assignment__c where Role__c != null';
  
    if (!role.equals('') && !role.equals('All')){
          soql += ' and Role__c =\''+role+'\'';
      }
    
    if (!status.equals('') && !status.equals('All')){
          soql += ' and Status__c =\''+status+'\'';
      }
    
    if (!oppSelect.equals(''))
    {
      soql += ' and BPO_Opportunity__r.name LIKE \''+String.escapeSingleQuotes(oppSelect)+'%\'';
    }  
     
    if (!SAPSelect.equals(''))
    {
      soql += ' and SAP_OM_ID__c LIKE \''+String.escapeSingleQuotes(SAPSelect)+'%\'';
    }
    
    if (!clSelect.equals(''))
    {
      soql += ' and ClientName__c LIKE \''+String.escapeSingleQuotes(clSelect)+'%\'';
    } 
     if(role.equals('All') && status.equals('All') && oppSelect.equals('') && SAPSelect.equals('') && clSelect.equals('')){
        soql += ' and BPO_Opportunity__c IN : oppListIDs ';
    } 
    // run the query again
    runQuery();
    Beginning();
 
    return null;
  }
 
  
  // use apex describe to build the role picklist values
  public List<String> role{
    get {
      if (role== null) {
 
        role= new List<String>();
        Schema.DescribeFieldResult field = Solution_User_Assignment__c.Role_Requested__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          role.add(f.getLabel());
 
      }
      return role;          
    }
    set;
  }
  
    public List<String> status{
    get {
      if (status== null) {
 
        status= new List<String>();
        Schema.DescribeFieldResult field = Solution_User_Assignment__c.PMOStatus__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          status.add(f.getLabel());
 
      }
      return status;          
    }
    set;
  }
  

  /******************************
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public void initializeDetailRecords() {    
    listProfileDetailsActual = new Solution_User_Assignment__c[]{};
    List<Solution_User_Assignment__c> soliUserAssignmentList = [Select id,Name,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,ClientName__c,SAP_OM_ID__c,User__c,Requester_Name__c,Requester_Name__r.name  from Solution_User_Assignment__c order by createddate desc];
        if(soliUserAssignmentList .Size()>0){
            for(Solution_User_Assignment__c solAssign: soliUserAssignmentList ){
                listProfileDetailsActual.add(solAssign);                
            } 
        }                 
    } 
    //End
  /*  
    /******************************
    Method Name: getOfferings
    Description: Add method to get Offerings only related to Offerings master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
 /*   public void LoadData()
    {
       
        strRoleRequestList = null;
        OpportunityAddList=null;
        
            
   
       List<Opportunity_TGP__c> lstAddOpp= [select id,name from Opportunity_TGP__c order by name];
            List<SelectOption> OppList= new List<SelectOption>();
            OppList.add(new SelectOption('','--None--')); 
            for(Opportunity_TGP__c tempAddOpp : lstAddOpp )
            {
                OppList.add(new SelectOption(tempAddOpp.id,tempAddOpp.name));        
            }        
            OpportunityAddList= OppList;    
    } */
        
   public void searchCriteria()
    {
     Set<ID> oppListId= new Set<ID>();
     Set<ID> oppClientId= new Set<ID>();
     Set<ID> sapOMId= new Set<ID>();     
     Set<ID> bpoOpp = new Set<ID>();
     
      SAPOMIDList=null;  
      ClientList=null;
      OpportunityList= null;
      
        List<Solution_User_Assignment__c> listSol=[Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.SFDC_User__c,Requester_Name__c,Requester_Name__r.name  from Solution_User_Assignment__c]; 
        for(Solution_User_Assignment__c solUser : listSol){
            
            bpoOpp.add(solUser.BPO_Opportunity__c);
            
        }
        List<Opportunity_TGP__c> listOpp= [select id,name,Client_Name__c,SAP_OM_Opportunity__c from Opportunity_TGP__c where id IN : bpoOpp order by Name];
        
      
            for(Opportunity_TGP__c  tempOpp : listOpp)
            {
                
                    oppListId.add(tempOpp.id);
                    oppClientId.add(tempOpp.Client_Name__c);
                    sapOMId.add(tempOpp.SAP_OM_Opportunity__c);      
                                
                
            }

        
     //Load Opportunity  Start
        List<Opportunity_TGP__c> tgpOppList= [select id,name,Client_Name__c,SAP_OM_Opportunity__c from Opportunity_TGP__c where id in : oppListId order by CreatedDate Desc LIMIT 999];
        List<SelectOption> oppSelectList= new List<SelectOption>();
        oppSelectList.add(new SelectOption('','All')); 
        for(Opportunity_TGP__c  tempOppList : tgpOppList)
        {
            oppSelectList.add(new SelectOption(tempOppList.name,tempOppList.name));        
        }        
        OpportunityList= oppSelectList;
        //Load Opportunity  End

         
        //Load Client Start
        //List<Client_Master__c> listClient= [Select name, Id From Client_Master__c where name!=null order by name];
        List<Client_Master__c> listClient= [Select name, Id From Client_Master__c where Id in : oppClientId order by name];
        List<SelectOption> CLList= new List<SelectOption>();
        CLList.add(new SelectOption('','All')); 
        for(Client_Master__c tempClient : listClient)
        {
            CLList.add(new SelectOption(tempClient.name,tempClient.name));        
        }        
        ClientList= CLList;
        //Load Client End
        
         //Load SAP OM ID Start
        //List<Opportunity_TGP__c> listSapOm= [Select SAP_OM_Opportunity__r.name, Name, Id From Opportunity_TGP__c where SAP_OM_Opportunity__c!=null order by name];
        List<SAP_OM_Opportunity__c> listSapOm= [Select id,name From SAP_OM_Opportunity__c where Id in : sapOMId order by createddate desc limit 999];
        List<SelectOption> SAPList= new List<SelectOption>();
        SAPList.add(new SelectOption('','All')); 
        for(SAP_OM_Opportunity__c  tempSAP : listSapOm)
        {
            SAPList.add(new SelectOption(tempSAP.name,tempSAP.name));        
        }        
        SAPOMIDList= SAPList;
        //Load SAP OM ID  End
    }      
       
    public void refreshOppValues()
    {
    // strOfferingsList = null;
     List<Opportunity_TGP__c> OppDetails = [Select SAP_OM_Opportunity__r.Name, Name, Id, Client_Name__r.Name From Opportunity_TGP__c  where Name=:strOppLookupValue];
     
     if(OppDetails.size() > 0){
         strClientName=OppDetails[0].Client_Name__r.Name;
         strSAPOMIDName=OppDetails[0].SAP_OM_Opportunity__r.Name;
         OppId=OppDetails[0].Id;
     }
                    
        List<Opportunity_Offering__c> lstOfferings= [Select Id,Opportunity_TGP__c, Opportunity_ID__c, Offering_Master__r.id,Offering_Master__r.name From Opportunity_Offering__c where Opportunity_TGP__c=:OppId];
            List<SelectOption> options = new List<SelectOption>();
            //options.add(new SelectOption('','--None--')); 
            for(Opportunity_Offering__c  tempOffer : lstOfferings )
            {
                options.add(new SelectOption(tempOffer.Offering_Master__r.id,tempOffer.Offering_Master__r.name));        
            }        
            strOfferingsList = options;
    }
    

     public void clearFilter()
     {
        soql = 'Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.SFDC_User__c,Requester_Name__r.name from Solution_User_Assignment__c where Role__c != null and BPO_Opportunity__c IN : oppListIDs';
        runQuery();
        Beginning();
        
     }
  
 public void assignRecords(){
 
 Map<Id, Id> reviewUsermasterId = new Map<Id, Id>();
     for(Review_User_Master__c userMaster: [select Id, Sfdc_User__c from Review_User_Master__c limit 5000]) {
         reviewUsermasterId.put(userMaster.Id, userMaster.Sfdc_User__c);
     }
  if(submitRequestIds !=null && submitRequestIds !=''){ 
        
        List<Solution_User_Assignment__c>  pmoAssingReq = new List<Solution_User_Assignment__c>();
        
        List<Opportunity_Offering__c>  offeringRoleUpdateList = new List<Opportunity_Offering__c>();
        list<string> strsubmitRequestId = submitRequestIds.split('\\,');
        List<Solution_User_Assignment__c> lstPMOReq = [Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Requester_Name__c,Resource_Assigned_User_New__c, Resource_Assigned_User_New__r.SFDC_User__c from Solution_User_Assignment__c where id in :strsubmitRequestId];
        
        
        for(Solution_User_Assignment__c pmoReq : lstPMOReq ){
            for(Solution_User_Assignment__c oldSolUser: solUserAssign ){
                if(oldSolUser.id==pmoReq.id){
                    if(oldSolUser.Resource_Assigned_User_New__c ==null){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Resource before clicking on the assign button'));
                       runQuery();  
                       return;
                    }
                    if(oldSolUser.Status__c == 'Assigned'){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected record status is already “Assigned”.'));
                       runQuery();  
                       return;
                    }
                }
            }
        }
       
        
        
        
        for(Solution_User_Assignment__c pmoReq : lstPMOReq ){
            for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
              if(oldSolUser.id==pmoReq.id){
                  if(oldSolUser.Resource_Assigned_User_New__c !=null){
                                       
                      pmoReq.Status__c ='Assigned';
                      pmoReq.Resource_Assigned_User_New__c =oldSolUser.Resource_Assigned_User_New__c;
                      //pmoReq.Technical_Architect_Approval_User__c = oldSolUser.Technical_Architect_Approval_User__c; 
                      pmoReq.Requester_Name__c =oldSolUser.Requester_Name__c;
                      pmoReq.Comments__c=oldSolUser.Comments__c;
                      pmoReq.Date_Assigned__c=system.today();
                     
                  }else{
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Resource before clicking on the assign button'));
                       runQuery();  
                       return;
                  }                  
              }

           }
           pmoAssingReq.add(pmoReq);            
           
        }
        if(pmoAssingReq.size()>0){
             try
                {
                    upsert pmoAssingReq;
                    

                    List<ID> bpoID = new List<ID>();
                    List<ID> offerID = new List<ID>();
                    for(Solution_User_Assignment__c  pmoassign : pmoAssingReq){
                        bpoID.add(pmoassign.BPO_Opportunity__c);
                        if(pmoassign.Offering_Master__c != null){
                            offerID.add(pmoassign.Offering_Master__c); 
                        }

                    }
                        System.debug('++++1');
                     //List<Opportunity_TGP__c >  oppRoleUpdateList = new List<Opportunity_TGP__c >();
                     List<Opportunity_Team__c> oppTeamUpdateList = new List<Opportunity_Team__c>();
                     Map<String, Id> oppRoleMasterMappedToId = new Map<String, Id>();
                     for(Opportunity_Role_master__c oppMaster: [select Id, Name from Opportunity_Role_master__c limit 100]) {
                        oppRoleMasterMappedToId.put(oppMaster.Name, oppMaster.Id);
                     }

                     //List<Opportunity_Team__c> lstOppTeam = [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c where  BPO_Opportunity__c In : bpoID limit 5000]; 
                     //List<Opportunity_Offering__c>  offerRoleUpdateList = new List<Opportunity_Offering__c>();
                     //List<Opportunity_TGP__c> lstOpp = [select id, Complex_Cost_Architect_New__c from Opportunity_TGP__c where id in : bpoID];
                     //List<Opportunity_Offering__c> lstOfferingRole= [Select Id,Opportunity_TGP__c, Offering_Master__c, Technical_Architect_New__c, Functional_Architect_Mobilization_New__c, Solution_Specialist_New__c  From Opportunity_Offering__c where Opportunity_TGP__c in : bpoID and Offering_Master__c in :offerID];

                     
                     //for(Opportunity_Team__c pmoass : lstOppTeam ){
                         for(Solution_User_Assignment__c oldSolUser : pmoAssingReq){
                         System.debug('++++4');
                             Opportunity_Team__c pmoass = new Opportunity_Team__c();
                             //if(pmoass.BPO_Opportunity__c == oldSolUser.BPO_Opportunity__c){
                                 if(oldSolUser.Role__c == 'Complex Cost Architect'){ 
                                      System.debug('++++2');
                                      pmoass.BPO_Opportunity__c = oldSolUser.BPO_Opportunity__c;
                                      pmoass.Opportunity_Team_Member__c = oldSolUser.Resource_Assigned_User_New__c;
                                      pmoass.Roles__c = oppRoleMasterMappedToId.get(oldSolUser.Role__c);
                                      pmoass.Offering__c = null; 
                                      
                                      oppTeamUpdateList.add(pmoass); 
                                                                        
                                  }
                                  if(oldSolUser.Role__c == 'Mobilization Architect' || oldSolUser.Role__c == 'Solution Specialist' || oldSolUser.Role__c == 'Technical Architect'){ 
                                      System.debug('++++3');
                                      pmoass.BPO_Opportunity__c = oldSolUser.BPO_Opportunity__c;
                                      pmoass.Opportunity_Team_Member__c = oldSolUser.Resource_Assigned_User_New__c;
                                      pmoass.Roles__c = oppRoleMasterMappedToId.get(oldSolUser.Role__c);
                                      pmoass.Offering__c = oldSolUser.Offering_Master__c;
                                      
                                      oppTeamUpdateList.add(pmoass);                                                                          
                                  }
                                  
                             //}    
                         }
                      
                    //}

                         if(oppTeamUpdateList.size()>0){
                             try
                                {
                                    upsert oppTeamUpdateList;
                                }
                                catch(Exception ex)
                                {
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                                    return;
                                }
                         }       

                    
                        /*for(Opportunity_Offering__c pmoOffer: lstOfferingRole){
                            for(Solution_User_Assignment__c oldSolUser : pmoAssingReq){  
                                if(oldSolUser.Role__c != 'Complex Cost Architect'){      
                                    if(pmoOffer.Opportunity_TGP__c==oldSolUser.BPO_Opportunity__c && pmoOffer.Offering_Master__c==oldSolUser.Offering_Master__c){
                                     
                                              if(oldSolUser.Role__c == 'Technical Architect'){
                                                   pmoOffer.Technical_Architect_New__c = oldSolUser.Resource_Assigned_User_New__c;
                                              }
                                              if(oldSolUser.Role__c == 'Mobilization Architect'){
                                                   // pmoOffer.id=oldSolUser.Offering_Id__c;
                                                    pmoOffer.Functional_Architect_Mobilization_New__c = oldSolUser.Resource_Assigned_User_New__c;
                                              }
                                              if(oldSolUser.Role__c == 'Solution Specialist'){
                                                   // pmoOffer.id=oldSolUser.Offering_Id__c;
                                                    pmoOffer.Solution_Specialist_New__c = oldSolUser.Resource_Assigned_User_New__c;
                                              } 
                                    }
                                }      
                            }
                        offerRoleUpdateList.add(pmoOffer);
                        }
                        upsert offerRoleUpdateList;*/

                   
                   numberOfSeparateEmails=pmoAssingReq.size();
                   
                    for(Solution_User_Assignment__c solUserAssignEmail : pmoAssingReq){
                        String oppId=solUserAssignEmail.BPO_Opportunity__c;
                        String roleName=solUserAssignEmail.Role__c;
                        String comment=solUserAssignEmail.Comments__c;
                        String toAddressId=reviewUsermasterId.get(solUserAssignEmail.Resource_Assigned_User_New__c);
                        String resourceRequest=solUserAssignEmail.Requester_Name__c;
                        if(solUserAssignEmail.Date_Needed_by__c != null){
                            DateTime dtValue = DateTime.newInstance(solUserAssignEmail.Date_Needed_by__c.year(), solUserAssignEmail.Date_Needed_by__c.month(), solUserAssignEmail.Date_Needed_by__c.day());                                    
                            dateNeeded= dtValue.format('MM-dd-yyyy');                        
                        }
                        if(solUserAssignEmail.Date_Requested__c != null){
                            DateTime dtValue1 = DateTime.newInstance(solUserAssignEmail.Date_Requested__c.year(), solUserAssignEmail.Date_Requested__c.month(), solUserAssignEmail.Date_Requested__c.day());                                    
                            dateRequested= dtValue1.format('MM-dd-yyyy');
                        }
                        //sendEmailAlertToAssignedUser(oppId, roleName, dateNeeded, dateRequested, comment, resourceAssigne, toAddressId);
                        sendEmailAlertToAssignedUser(oppId, roleName, dateNeeded, dateRequested, comment, resourceRequest, toAddressId);
                    } 
                    
                     
                     
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Resource Assigned successfully.'));
                    runQuery();  
                    return;
                }
                catch(Exception ex)
                {
                    if(Test.isRunningTest() == false){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                        return;
                    }
                }
             }
  }else{
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one record before assigning the request'));
      runQuery();
      return;
  }   
    

   }

public void onHoldRecords(){
  if(submitRequestIds !=null && submitRequestIds !=''){
      List<Solution_User_Assignment__c>  onHoldReqList = new List<Solution_User_Assignment__c>();
      List<Opportunity_TGP__c >  onHoldRoleUpdateList = new List<Opportunity_TGP__c >();
      Solution_User_Assignment__c onHoldObj = new Solution_User_Assignment__c();
      list<string> stronHoldRequestId = submitRequestIds.split('\\,');
      List<Solution_User_Assignment__c> lstOnHoldReq = [Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Requester_Name__c,Resource_Assigned_User_New__c  from Solution_User_Assignment__c where id in :stronHoldRequestId];
      
      for(Solution_User_Assignment__c onHoldReq : lstOnHoldReq ){ 
          for(Solution_User_Assignment__c oldSolUser: solUserAssign ){
              if(oldSolUser.id==onHoldReq.id){
                  if(oldSolUser.Resource_Assigned_User_New__c !=null){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Status cannot be “On Hold” if the resource is assigned.'));
                       runQuery();  
                       return;
                   }
                   if(oldSolUser.Status__c == 'On Hold'){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected record status is already “On Hold”.'));
                       runQuery();  
                       return;
                    }
               }     
           }  
       }
      
        for(Solution_User_Assignment__c onHoldReq : lstOnHoldReq ){ 
            for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
                if(oldSolUser.id==onHoldReq.id){
                  if(oldSolUser.Resource_Assigned_User_New__c ==null){
                      onHoldReq.Status__c='On Hold';
                      onHoldReq.Resource_Assigned_User_New__c =oldSolUser.Resource_Assigned_User_New__c ;
                      onHoldReq.Requester_Name__c =oldSolUser.Requester_Name__c;
                      onHoldReq.Comments__c=oldSolUser.Comments__c;
                      onHoldReq.Date_Assigned__c=null;                       
                  }else{
                      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Status cannot be “On Hold” if the resource is assigned.'));
                      runQuery();  
                      return;
                  }  
                
                }            
            }
            onHoldReqList.add(onHoldReq);        
        }
        if(onHoldReqList.size()>0){
         try
            {
                upsert onHoldReqList;
                
                List<ID> bpoID = new List<ID>();
                    List<ID> offerID = new List<ID>();
                    for(Solution_User_Assignment__c  pmoassign : onHoldReqList){
                        bpoID.add(pmoassign.BPO_Opportunity__c);
                        if(pmoassign.Offering_Master__c != null){
                            offerID.add(pmoassign.Offering_Master__c); 
                        }

                    }

                     //List<Opportunity_TGP__c >  oppRoleUpdateList = new List<Opportunity_TGP__c >();
                     List<Opportunity_Team__c> oppTeamUpdateList = new List<Opportunity_Team__c>();
                     Map<String, Id> oppRoleMasterMappedToId = new Map<String, Id>();
                     for(Opportunity_Role_master__c oppMaster: [select Id, Name from Opportunity_Role_master__c limit 100]) {
                        oppRoleMasterMappedToId.put(oppMaster.Name, oppMaster.Id);
                     }

                     //List<Opportunity_Team__c> lstOppTeam = [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c where  BPO_Opportunity__c In : bpoID limit 5000]; 
                     //List<Opportunity_Offering__c>  offerRoleUpdateList = new List<Opportunity_Offering__c>();
                     //List<Opportunity_TGP__c> lstOpp = [select id, Complex_Cost_Architect_New__c from Opportunity_TGP__c where id in : bpoID];
                     //List<Opportunity_Offering__c> lstOfferingRole= [Select Id,Opportunity_TGP__c, Offering_Master__c, Technical_Architect_New__c, Functional_Architect_Mobilization_New__c, Solution_Specialist_New__c  From Opportunity_Offering__c where Opportunity_TGP__c in : bpoID and Offering_Master__c in :offerID];

                     
                     //for(Opportunity_Team__c pmoass : lstOppTeam ){
                         for(Solution_User_Assignment__c oldSolUser : onHoldReqList){
                         System.debug('++++4');
                             Opportunity_Team__c pmoass = new Opportunity_Team__c();
                             //if(pmoass.BPO_Opportunity__c == oldSolUser.BPO_Opportunity__c){
                                 if(oldSolUser.Role__c == 'Complex Cost Architect'){ 
                                      System.debug('++++2');
                                      pmoass.BPO_Opportunity__c = oldSolUser.BPO_Opportunity__c;
                                      pmoass.Opportunity_Team_Member__c = oldSolUser.Resource_Assigned_User_New__c;
                                      pmoass.Roles__c = oppRoleMasterMappedToId.get(oldSolUser.Role__c);
                                      pmoass.Offering__c = null; 
                                      
                                      oppTeamUpdateList.add(pmoass); 
                                                                        
                                  }
                                  if(oldSolUser.Role__c == 'Mobilization Architect' || oldSolUser.Role__c == 'Solution Specialist' || oldSolUser.Role__c == 'Technical Architect'){ 
                                      System.debug('++++3');
                                      pmoass.BPO_Opportunity__c = oldSolUser.BPO_Opportunity__c;
                                      pmoass.Opportunity_Team_Member__c = oldSolUser.Resource_Assigned_User_New__c;
                                      pmoass.Roles__c = oppRoleMasterMappedToId.get(oldSolUser.Role__c);
                                      pmoass.Offering__c = oldSolUser.Offering_Master__c;
                                      
                                      oppTeamUpdateList.add(pmoass);                                                                          
                                  }
                                  
                             //}    
                         }
                      
                    //}

                         if(oppTeamUpdateList.size()>0){
                             try
                                {
                                    upsert oppTeamUpdateList;
                                }
                                catch(Exception ex)
                                {
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                                    return;
                                }
                         }       

                    
                       /* for(Opportunity_Offering__c pmoOffer: lstOfferingRole){
                            for(Solution_User_Assignment__c oldSolUser : onHoldReqList){  
                                if(oldSolUser.Role__c != 'Complex Cost Architect'){      
                                    if(pmoOffer.Opportunity_TGP__c==oldSolUser.BPO_Opportunity__c && pmoOffer.Offering_Master__c==oldSolUser.Offering_Master__c){
                                     
                                              if(oldSolUser.Role__c == 'Technical Architect'){
                                                    pmoOffer.Technical_Architect_New__c = oldSolUser.Resource_Assigned_User_New__c;
                                              }
                                              if(oldSolUser.Role__c == 'Mobilization Architect'){
                                                   // pmoOffer.id=oldSolUser.Offering_Id__c;
                                                    pmoOffer.Functional_Architect_Mobilization_New__c = oldSolUser.Resource_Assigned_User_New__c;
                                              }
                                              if(oldSolUser.Role__c == 'Solution Specialist'){
                                                   // pmoOffer.id=oldSolUser.Offering_Id__c;
                                                    pmoOffer.Solution_Specialist_New__c = oldSolUser.Resource_Assigned_User_New__c;
                                              } 
                                    }
                                }      
                            }
                        offerRoleUpdateList.add(pmoOffer);
                        }
                        upsert offerRoleUpdateList;*/
                        
                        for(Solution_User_Assignment__c solUserAssignEmail : onHoldReqList){

                        String oppId=solUserAssignEmail.BPO_Opportunity__c;
                        String roleName=solUserAssignEmail.Role__c;
                        //Date dateNeeded=solUserAssignEmail.Date_Needed_by__c;
                        //Date dateRequested=solUserAssignEmail.Date_Requested__c;                        
                        if(solUserAssignEmail.Date_Needed_by__c != null){
                            DateTime dtValue = DateTime.newInstance(solUserAssignEmail.Date_Needed_by__c.year(), solUserAssignEmail.Date_Needed_by__c.month(), solUserAssignEmail.Date_Needed_by__c.day());                                    
                            dateNeeded= dtValue.format('MM-dd-yyyy');                        
                        }
                        if(solUserAssignEmail.Date_Requested__c != null){
                            DateTime dtValue1 = DateTime.newInstance(solUserAssignEmail.Date_Requested__c.year(), solUserAssignEmail.Date_Requested__c.month(), solUserAssignEmail.Date_Requested__c.day());                                    
                            dateRequested= dtValue1.format('MM-dd-yyyy');
                        }
                        
                        String comment=solUserAssignEmail.Comments__c;
                        String resourceRequest=solUserAssignEmail.Requester_Name__c;
                        sendEmailAlertToOnHoldUser(oppId, roleName, dateNeeded, dateRequested, comment, resourceRequest);
                    } 
                        
                        
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Status Changed to “On Hold” successfully.'));
               runQuery();  
               return;         
            } 

            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                return;
            }
         }
  }else{
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one record before assigning the request'));
      runQuery();
      return;
  }   
    

}

public void notFilledRecords(){
  if(submitRequestIds !=null && submitRequestIds !=''){
       List<Solution_User_Assignment__c>  ontFilledReqList = new List<Solution_User_Assignment__c>();
       list<string> stronHoldRequestId = submitRequestIds.split('\\,');
       List<Solution_User_Assignment__c> lstNotFilledReq = [Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c, Requester_Name__c,Requester_Name__r.name from Solution_User_Assignment__c where id in :stronHoldRequestId];
      
       for(Solution_User_Assignment__c ontFillReq : lstNotFilledReq ){
           for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
               if(oldSolUser.id==ontFillReq.id){
                   if(oldSolUser.Resource_Assigned_User_New__c !=null){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Status cannot be “Not Filled” if the resource is assigned.'));
                       runQuery();  
                       return;
                   }
                   if(oldSolUser.Status__c == 'Not Filled'){
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected record status is already “Not Filled”.'));
                       runQuery();  
                       return;
                    }
               }
            }           
        }
        
        for(Solution_User_Assignment__c ontFillReq : lstNotFilledReq ){ 
            for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
                if(oldSolUser.id==ontFillReq.id){
                  if(oldSolUser.Resource_Assigned_User_New__c ==null){
                      ontFillReq.Status__c='Not filled';
                      ontFillReq.Resource_Assigned_User_New__c =oldSolUser.Resource_Assigned_User_New__c ;
                      ontFillReq.Comments__c=oldSolUser.Comments__c;
                      ontFillReq.Date_Assigned__c=null; 
                      
                  }else{
                      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Status cannot be “Not Filled” if the resource is assigned.'));
                      runQuery();  
                      return;
                  }                  
                }        
            }
            ontFilledReqList.add(ontFillReq);        
        }
        if(ontFilledReqList.size()>0){
         try
            {
                upsert ontFilledReqList;
                
                List<ID> bpoID = new List<ID>();
                    List<ID> offerID = new List<ID>();
                    for(Solution_User_Assignment__c  pmoassign : ontFilledReqList){
                        bpoID.add(pmoassign.BPO_Opportunity__c);
                        if(pmoassign.Offering_Master__c != null){
                            offerID.add(pmoassign.Offering_Master__c); 
                        }

                    }

                     //List<Opportunity_TGP__c >  oppRoleUpdateList = new List<Opportunity_TGP__c >();
                     List<Opportunity_Team__c> oppTeamUpdateList = new List<Opportunity_Team__c>();
                     Map<String, Id> oppRoleMasterMappedToId = new Map<String, Id>();
                     for(Opportunity_Role_master__c oppMaster: [select Id, Name from Opportunity_Role_master__c limit 100]) {
                        oppRoleMasterMappedToId.put(oppMaster.Name, oppMaster.Id);
                     }

                     //List<Opportunity_Team__c> lstOppTeam = [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c where  BPO_Opportunity__c In : bpoID limit 5000]; 
                     //List<Opportunity_Offering__c>  offerRoleUpdateList = new List<Opportunity_Offering__c>();
                     //List<Opportunity_TGP__c> lstOpp = [select id, Complex_Cost_Architect_New__c from Opportunity_TGP__c where id in : bpoID];
                     //List<Opportunity_Offering__c> lstOfferingRole= [Select Id,Opportunity_TGP__c, Offering_Master__c, Technical_Architect_New__c, Functional_Architect_Mobilization_New__c, Solution_Specialist_New__c  From Opportunity_Offering__c where Opportunity_TGP__c in : bpoID and Offering_Master__c in :offerID];

                     
                     //for(Opportunity_Team__c pmoass : lstOppTeam ){
                         for(Solution_User_Assignment__c oldSolUser : ontFilledReqList){
                         System.debug('++++4');
                             Opportunity_Team__c pmoass = new Opportunity_Team__c();
                             //if(pmoass.BPO_Opportunity__c == oldSolUser.BPO_Opportunity__c){
                                 if(oldSolUser.Role__c == 'Complex Cost Architect'){ 
                                      System.debug('++++2');
                                      pmoass.BPO_Opportunity__c = oldSolUser.BPO_Opportunity__c;
                                      pmoass.Opportunity_Team_Member__c = oldSolUser.Resource_Assigned_User_New__c;
                                      pmoass.Roles__c = oppRoleMasterMappedToId.get(oldSolUser.Role__c);
                                      pmoass.Offering__c = null; 
                                      
                                      oppTeamUpdateList.add(pmoass); 
                                                                        
                                  }
                                  if(oldSolUser.Role__c == 'Mobilization Architect' || oldSolUser.Role__c == 'Solution Specialist' || oldSolUser.Role__c == 'Technical Architect'){ 
                                      System.debug('++++3');
                                      pmoass.BPO_Opportunity__c = oldSolUser.BPO_Opportunity__c;
                                      pmoass.Opportunity_Team_Member__c = oldSolUser.Resource_Assigned_User_New__c;
                                      pmoass.Roles__c = oppRoleMasterMappedToId.get(oldSolUser.Role__c);
                                      pmoass.Offering__c = oldSolUser.Offering_Master__c;
                                      
                                      oppTeamUpdateList.add(pmoass);                                                                          
                                  }
                                  
                             //}    
                         }
                      
                    //}

                         if(oppTeamUpdateList.size()>0){
                             try
                                {
                                    upsert oppTeamUpdateList;
                                }
                                catch(Exception ex)
                                {
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                                    return;
                                }
                         }       

                    
                      /*  for(Opportunity_Offering__c pmoOffer: lstOfferingRole){
                            for(Solution_User_Assignment__c oldSolUser : ontFilledReqList){  
                                if(oldSolUser.Role__c != 'Complex Cost Architect'){      
                                    if(pmoOffer.Opportunity_TGP__c==oldSolUser.BPO_Opportunity__c && pmoOffer.Offering_Master__c==oldSolUser.Offering_Master__c){
                                     
                                              if(oldSolUser.Role__c == 'Technical Architect'){
                                                    pmoOffer.Technical_Architect_New__c = oldSolUser.Resource_Assigned_User_New__c ;
                                                    
                                              }
                                              if(oldSolUser.Role__c == 'Mobilization Architect'){
                                                   // pmoOffer.id=oldSolUser.Offering_Id__c;
                                                    pmoOffer.Functional_Architect_Mobilization_New__c = oldSolUser.Resource_Assigned_User_New__c;
                                              }
                                              if(oldSolUser.Role__c == 'Solution Specialist'){
                                                   // pmoOffer.id=oldSolUser.Offering_Id__c;
                                                    pmoOffer.Solution_Specialist_New__c = oldSolUser.Resource_Assigned_User_New__c;
                                              } 
                                    }
                                }      
                            }
                        offerRoleUpdateList.add(pmoOffer);
                        }
                        upsert offerRoleUpdateList;*/
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Status Changed to “Not Filled” successfully.'));
                runQuery();  
                return;
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                return;
            }
         }
  }else{
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one record before assigning the request'));
      runQuery();
      return;
  }  
}

/******************************
Method Name: getUserEmailAddress
Description: To retrieve Email Addresses of Assigned User
Paramenters: NA
Return Value: List<String>
*******************************/  
public static List<String> getUserEmailAddress(String userName)
{
    List<String> emailAddress=new List<String>();
    String id; 
    User[] usr = [SELECT email FROM user WHERE id=:userName];
    if(usr.size()>0) {  
        emailAddress.add(usr[0].email);   
    } 
    return emailAddress; 
}
            
/******************************
Method Name: sendEmailAlertToAssignedUser
Description: Method for sending the email Alerts-assigned the message object
Paramenters: NA
Return Value: void
*******************************/
public void sendEmailAlertToAssignedUser(String oppId, String roleName, String dateNeeded, String  dateRequested, String comment, String resourceId, String toAddressId)
{
    List<Opportunity_TGP__c> opportunityList=[select id, name, Offerings__c, Service_Delivery_Locations_Unique__c, Activity__c,TCV__c, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, Client_Name__r.name, Comments__c,
                                                        Expected_contract_sign_qtr__c, Operating_Group__r.name, Enterprise_Solution_Architect_New__r.Name, Risk_Level__c,
                                                        SAP_OM_ID__c, Stage__c, SAP_OM_Opportunity__r.name from Opportunity_TGP__c where id=:oppId]; 
    List<User> usrName = new List<User>();
    usrName = [SELECT name FROM user WHERE id=:toAddressId];
    if(usrName.size()>0) {
    try
        {       
             
                String userName ='';
                userName = checkNullValues(usrName[0].name);
                OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
                List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                if(lstIdForOWA.size()>0)
                {
                    owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                } 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if ( owea.size() > 0 ) 
                {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                List<String> listOfEmailAddress = getUserEmailAddress(toAddressId);
                mail.setToAddresses(ListOfEmailAddress); 
                mail.setCcAddresses(getUserEmailAddress(resourceId)) ;    
                String subject='NOTIFICATION:  '+ userName +' '+'assigned as a '+checkNullValues(roleName)+' - Client Name: '+checkNullValues(opportunityList[0].Client_Name__r.name)+' - Opportunity Name: '+checkNullValues(opportunityList[0].name);
                mail.setSubject(subject);    
           
            mail.setHtmlBody
            (
                '<html>' +
                '    <body>' +
                '   <STYLE type="text/css">' +
                
                '</STYLE>' +
                '<font face="Calibri (Body)" style="font-size:11pt" >'+ '</br>' +
                'You have been assigned as a '+ checkNullValues(roleName) +' to the following Opportunity: </p>' +
                 '</font>'+
                '<hr/>' +
                '<table border="1" rules="rows" width="60%" cellpadding="5">' +
               // '<tr height="20">  ' +
               //  '<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity ID:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(Opportunity_ID__c)+'</font>'+''+'</td>' +
                // '</tr>' +
                 '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Client_Name__r.name)+'</font>'+''+'</td>' + 
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].name)+'</font>'+''+'</td>' + 
               
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity ID:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].SAP_OM_Opportunity__r.name)+'</font>'+''+'</td>' + 
                
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Lead Solution Architect – BPO:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Enterprise_Solution_Architect_New__r.Name)+'</font>'+''+'</td>' + 
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Stage:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Stage__c)+'</font>'+''+'</td>' + 
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Expected Contract Sign (Qtr):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Expected_contract_sign_qtr__c)+'</font>'+''+'</td>' + 
               
                '</tr>' +
        
        
                '<tr height="20">  ' +
                 '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">BPO Net Revenue (SAP OM)<br/>(Thousands):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(opportunityList[0].TCV__c)+'</font>'+''+'</td>' + 
                
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Area:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Client_Geo_Area__r.name)+'</font>'+''+'</td>' + 
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Unit:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Client_Geo_Unit__r.name)+'</font>'+''+'</td>' + 
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Operating_Group__r.name)+'</font>'+''+'</td>' + 
               
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Offerings:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Offerings__c)+'</font>'+''+'</td>' + 
               
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Delivery Location:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Service_Delivery_Locations_Unique__c)+'</font>'+''+'</td>' + 
               
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Risk Level:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Risk_Level__c)+'</font>'+''+'</td>' + 
                
                '</tr>' +
                
                 '<tr height="20">  ' +
                '<td width="25%" style="borde:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Date Requested By:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(dateRequested)+'</font>'+''+'</td>' + 
              
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Date Needed By:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(dateNeeded)+'</font>'+''+'</td>' + 
               
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Comments:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(comment)+'</font>'+''+'</td>' + 
                
                '</tr>' +
                
               // '<tr height="20">  ' +
               // '<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Requestor:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+offeringRecord.Solution_Lead__r.name+'</font>'+''+'</td>' +
               // '</tr>' +
                
                '</table>' +
        
                '<hr/>' +
                 '<font face="Calibri (Body)" style="font-size:11pt" >'+
                '<br/>' +
                '     <a href ="'+strUrl+'/apex/SolutionUserAssignment" target="_parent">Login to BPO Solution Workbench </a>' + '<i> (option for those who have a workbench license)</i>' +
                '    <p>For more information please contact Lead Solution Architect – BPO.</p>' +
                '    <p>This is a system generated message. Please do not reply to this message.</p>' +
                '</font>'+
                '</body>' +
                '</html>'
            );
            mail.saveAsActivity=false;  
            //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            //singleEmails.add(mail);
        }
    
        catch(System.EmailException ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending mail!'));
            return;
        }
    }

}

/******************************
Method Name: sendEmailAlertToAssignedUser
Description: Method for sending the email Alerts-assigned the message object
Paramenters: NA
Return Value: void
*******************************/
public void sendEmailAlertToOnHoldUser(String oppId, String roleName, String dateNeeded, String dateRequested, String comment, String resourceId)
{
    List<Opportunity_TGP__c> opportunityList=[select id, name, Activity__c,TCV__c, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, Client_Name__r.name, Comments__c,
                                                        Expected_contract_sign_qtr__c, Operating_Group__r.name, Enterprise_Solution_Architect_New__r.Name, Risk_Level__c,
                                                        SAP_OM_ID__c, Stage__c, SAP_OM_Opportunity__r.name from Opportunity_TGP__c where id=:oppId]; 
    User[] usrName = [SELECT name FROM user WHERE id=:resourceId];   

   
                                             
    try
    {       
         
            OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
            List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
            if(lstIdForOWA.size()>0)
            {
                owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
            } 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) 
            {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
        mail.setToAddresses(getUserEmailAddress(resourceId));      
        String subject='NOTIFICATION: New Request for  '+checkNullValues(roleName)+' '+'has been put On Hold '+' - Client Name: '+checkNullValues(opportunityList[0].Client_Name__r.name)+' - Opportunity Name: '+checkNullValues(opportunityList[0].name);
        mail.setSubject(subject);    
    
        mail.setHtmlBody
        (
            '<html>' +
            '    <body>' +
            '   <STYLE type="text/css">' +
            
            '</STYLE>' +
            '<font face="Calibri (Body)" style="font-size:11pt" >'+
            'Below request for '+ checkNullValues(roleName) +' with following details has been put on hold:  </p>' +
             '</font>'+
            '<hr/>' +
            '<table border="1" rules="rows" width="60%" cellpadding="5">' +
           // '<tr height="20">  ' +
           //  '<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity ID:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(Opportunity_ID__c)+'</font>'+''+'</td>' +
            // '</tr>' +
             '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Client_Name__r.name)+'</font>'+''+'</td>' + 
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].name)+'</font>'+''+'</td>' + 
           
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity ID:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].SAP_OM_Opportunity__r.name)+'</font>'+''+'</td>' + 
            
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Stage:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Stage__c)+'</font>'+''+'</td>' + 
            
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Expected Contract Sign (Qtr):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Expected_contract_sign_qtr__c)+'</font>'+''+'</td>' + 
           
            '</tr>' +
    
    
            '<tr height="20">  ' +
             '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">BPO Net Revenue (SAP OM)<br/>(Thousands):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(opportunityList[0].TCV__c)+'</font>'+''+'</td>' + 
            
            
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Area:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Client_Geo_Area__r.name)+'</font>'+''+'</td>' + 
            
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Unit:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Client_Geo_Unit__r.name)+'</font>'+''+'</td>' + 
            
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Operating_Group__r.name)+'</font>'+''+'</td>' + 
           
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Risk Level:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Risk_Level__c)+'</font>'+''+'</td>' + 
            
            '</tr>' +
            
             '<tr height="20">  ' +
            '<td width="25%" style="borde:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Date Requested By:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(dateRequested)+'</font>'+''+'</td>' + 
          
            '</tr>' +
            
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Date Needed By:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(dateNeeded)+'</font>'+''+'</td>' + 
           
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Comments:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(comment)+'</font>'+''+'</td>' + 
            
            '</tr>' +
            
           // '<tr height="20">  ' +
           // '<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Requestor:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+offeringRecord.Solution_Lead__r.name+'</font>'+''+'</td>' +
           // '</tr>' +
            
            '</table>' +
    
            '<hr/>' +
             '<font face="Calibri (Body)" style="font-size:11pt" >'+
            '<br/>' +
            '     <a href ="'+strUrl+'/apex/SolutionUserAssignment" target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
            '    <p>This is a system generated message. Please do not reply to this message.</p>' +
            '</font>'+
            '</body>' +
            '</html>'
        );
        mail.saveAsActivity=false;  
        //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //singleEmails.add(mail);
    }
    catch(System.EmailException ex)
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending mail!'));
        return;
    }

}

           
 /* Pagination Code Start */
    
   private integer counter=0;  //keeps track of the offset   
   private integer list_size=5; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list

   
   public PageReference Beginning() { //user clicked beginning
      counter = 0;
      runQuery();
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      runQuery();
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size;
      runQuery();
      return null;
   }
 
   public PageReference End() { //user clicked end
      if(math.mod(total_size, list_size) == 0){
          counter = (total_size - math.mod(total_size, list_size))-5;
      }else{
      counter = total_size - math.mod(total_size, list_size);
      }    
      runQuery();
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0)
      
       return false; else return true;
      // runQuery();
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) 
      
      return false; else return true;
     // runQuery();
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
   
 /*  public Integer getPageNumber() {
   if( math.mod(total_size, list_size)>=0 ){
      return counter/list_size;
   }else{
      return counter/list_size + 1;
      }
   }*/
 
   public Integer getTotalPages() {
     if(total_size <=5){
          return  1;
      }else{ 
          if (math.mod(total_size, list_size) > 0) {
             return (total_size/list_size) + 1;
          } else {
             return (total_size/list_size);
          }
      }
   }
    /* Pagination Code End*/

 /******************************
    Method Name: findUserName
    Description: Method to get the username for user ID.
    Paramenters: NA
    Return Value: void
    *******************************/
    public String checkNullValues(String value)
    {
        if(value==null)
            return '  ';
        else
            return value;
        
    }
    /******************************
    Method Name: checkNullValuesDecimalTCV
    Description: Method to check null and return empty string.
    Paramenters: String
    Return Value: String 
    *******************************/
    public Static String checkNullValuesDeciamlTCV(Decimal value)
    {
        if(value==null)
            return '  ';
        else
            return ''+ '$' +String.ValueOf(value.setScale(0).format());// Code added by Ayush for D - 1791 A
        
    } 
    
     public Static String checkDateNullValues(Date value)
    {
        if(value==null)
            return '  ';
        else
            return ''+value;
        
    }
        
////////////////////
   Public string propPickValSelected { get; set; }
    public List<SelectOption> getPickLstValue()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Solution_User_Assignment__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        {
            if(f.getValue() != 'New' && f.getValue() != 'Cancelled' && f.getValue() != 'In Progress' )
            {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        } 
        return options;           
    }
}