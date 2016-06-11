/***************************************************************************************************************************
Author : Vinay Kumar Chada
Story :    
Description :  Display logic for Solution User Assignment.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

****************************************************************************************************************************/
public without sharing class SolutionUserAssignmentController {
 
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
 public String sectionTitle{get;set;}
 public integer columnNos{get; set;}
 public String strButtonName{get; set;}
 public String listOppSelected {get; set;}
 public String listSAPOMSelected {get; set;}
 public String listClientSelected {get; set;}
 public String oppSelect{get;set;}


public String strOppLookupValue {get;set;}
public String strClientName {get; set;}
public String strSAPOMIDName {get; set;}
public String OppId {get; set;}
public List<ID> oppListID {get;set;}
public List<ID> oppSearchID {get;set;}
public List<ID> oppClearID {get;set;}

public String RunningUser {get; set;}
public String RunningUserMailId {get; set;}
public String submitRequestIds {get; set;}
public String userProfileName {get;set;}
 
private String soql {get;set;}
public String solUserSoql {get;set;}
public List<Solution_User_Assignment__c> solUserAssign {get;set;}
public List<Solution_User_Assignment__c> solUserAllList {get;set;}
public List<Solution_User_Assignment__c> solUserAllSearchList {get;set;}
public List<Solution_User_Assignment__c> solUserSubmitRequest{get; set;}
public List<Solution_User_Assignment__c> solUserAssignPageSize {get;set;}
public static List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
public String strUrl{get;set;}
public boolean isPMOuser{get;set;}
public String dateNeeded {get;set;}
public String dateRequested {get;set;}
private String workbenchSoql {get;set;}
public boolean isAggregateResult{get;set;}

  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'CreatedDate'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return solUserSoql + ' order by ' + sortField + ' ' + sortDir; }
    set;
  }
  
  public Set<ID> oppOffListId {get;set;}
  public Set<ID> oppNewListId {get;set;}
  public Set<ID> oppClientName {get;set;}
  public Set<String> sapOMId {get;set;}
  public Set<Id> oppListIDs {get;set;}
 List<Opportunity_TGP__c> oppListData {get;set;}
 
  // init the controller and display some sample data when the page loads
 public SolutionUserAssignmentController(ApexPages.StandardController controller) {
strUrl = URL.getSalesforceBaseUrl().toExternalForm();

RunningUser=UserInfo.getUserId();
RunningUserMailId = UserInfo.getUserEmail();
 columnNos = 8;
 sectionTitle='Request Solution Support';
 strButtonName = 'Add to Submit Request';
 oppListIDs = new Set<Id>();
 oppListData= [select id from Opportunity_TGP__c order by createddate,id desc limit 50];
 for(Opportunity_TGP__c oppId : oppListData){
    oppListIDs.add(oppId.id);
 }       
// permissionSetList= [Select AssigneeId from PermissionSetAssignment Where PermissionSetId in (Select Id From PermissionSet where name = 'SolutionLeadership_with_WorkbenchUser') and AssigneeId = : RunningUser]; 
 userProfileName = [select u.Profile.Name from User u where u.id = :RunningUser].Profile.Name;
 if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.PMO) || userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)){
    soql = 'Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c where '+
           ' Role__c != null and BPO_Opportunity__c IN : oppListIDs ';     
 }else{
 soql = 'Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c where '+
           ' BPO_Opportunity__c IN (SELECT BPO_Opportunity__c FROM Opportunity_Team__c where Opportunity_Team_Member__r.SFDC_User__c =\''+RunningUser+'\' '+')';
           
     workbenchSoql =soql;    
     system.debug('--------------soql-in constructor------'+soql);  
 } 
  /*  solUserAllList = Database.query(soql);
    oppListID= new List<ID>();
    for(Solution_User_Assignment__c  solUser: solUserAllList ){
        oppListID.add(solUser.BPO_Opportunity__c);        
    }
     solUserSoql  = 'Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Solutions__r.Opportunity_TGP__r.Complex_Cost_Architect_New__c,Solutions__r.Technical_Architect_New__r.Email_ID_of_the_reviewer__c, Solutions__r.Solution_Specialist_New__c,Solutions__r.Functional_Architect_Mobilization_New__c,Solutions__r.Solution_Lead_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c  where Role__c != null and BPO_Opportunity__c in :oppListID';            
   */ 
    solUserSoql  = soql;
    isAggregateResult =true;
    runQuery();    
    //getsolUserList();
    searchCriteria();
    searchCriteria1();
    searchCriteria2();    
    searchCriteria3();
    
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
        System.debug('---------runQuery method-----------'+solUserSoql);
        system.debug('-----------database.query(solUserSoql)-------'+database.query(solUserSoql));
     solUserAssign = Database.query(solUserSoql  + ' order by ' + sortField + ' ' + sortDir + ' LIMIT '+list_size +' OFFSET '+ counter );
     system.debug('---------solUserAssign-----------'+solUserAssign);
      /*String soqlSize = 'Select count(id) total From Solution_User_Assignment__c';
     if(isAggregateResult == true){
          List<AggregateResult> result= Database.query(soqlSize); 
          total_size =(Integer)result[0].get('total');
      }*/
      solUserAssignPageSize = Database.query(solUserSoql);
      total_size =solUserAssignPageSize.size();
    } catch (Exception e) {
      system.debug('~~~exp1~~~'+e);
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No opportunity related to logged in user!'+e));
    }

  }

  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
  isAggregateResult = false;
    userProfileName = [select u.Profile.Name from User u where u.id = :RunningUser].Profile.Name;
    String role = Apexpages.currentPage().getParameters().get('role');
    String status= Apexpages.currentPage().getParameters().get('status');
    String SAPSelect= Apexpages.currentPage().getParameters().get('SAPSelect');
    String clSelect= Apexpages.currentPage().getParameters().get('clSelect');
    String oppSelect= Apexpages.currentPage().getParameters().get('oppSelect');
     System.debug('---role-------'+role+'------oppSelect--'+oppSelect);
     if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.PMO) || userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)){
            soql = 'Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c where '+
           ' Role__c != null';     
     }else{
         soql = 'Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c where '+
           ' BPO_Opportunity__c IN (SELECT BPO_Opportunity__c FROM Opportunity_Team__c where Opportunity_Team_Member__r.SFDC_User__c =\''+RunningUser+'\' '+')';
        workbenchSoql =soql; 
        system.debug('-------------------SQL___'+soql);
        } 
  /*  solUserAllSearchList = Database.query(soql);
    
    oppSearchID = new List<ID>();
    for(Solution_User_Assignment__c  solUserSearch: solUserAllSearchList ){
        oppSearchID.add(solUserSearch.BPO_Opportunity__c);         
    } 
    solUserSoql  = 'Select id,Name,BPO_Opportunity__c,BPO_Opportunity__r.id,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Solutions__r.Opportunity_TGP__r.Complex_Cost_Architect_New__c,Solutions__r.Technical_Architect_New__c, Solutions__r.Solution_Specialist_New__c,Solutions__r.Functional_Architect_Mobilization_New__c,Solutions__r.Solution_Lead_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c  from Solution_User_Assignment__c where Role__c != null and BPO_Opportunity__c in :oppSearchID'; 
   */
   solUserSoql  =soql;
    if (!role.equals('') && !role.equals('All')){
          solUserSoql  += ' and Role__c =\''+role+'\'';
      }
    
    if (!status.equals('') && !status.equals('All')){
          solUserSoql  += ' and Status__c =\''+status+'\'';
      }
    
    if (!oppSelect.equals(''))
    {
      solUserSoql  += ' and BPO_Opportunity__c= \''+oppSelect+'\'';
    }  
     
    if (!SAPSelect.equals(''))
    {
      solUserSoql  += ' and SAP_OM_ID__c LIKE \''+String.escapeSingleQuotes(SAPSelect)+'%\'';
    }
    
    if (!clSelect.equals(''))
    {
      solUserSoql  += ' and ClientName__c LIKE \''+String.escapeSingleQuotes(clSelect)+'%\'';
    }
    if(role.equals('All') && status.equals('All') && oppSelect.equals('') && SAPSelect.equals('') && clSelect.equals('')){
        solUserSoql  += ' and BPO_Opportunity__c IN : oppListIDs ';
    } 
    // run the query again
   /* if(isPMOuser == false){
       solUserAssignPageSize = Database.query(solUserSoql);       
       total_size =solUserAssignPageSize.size();
      }*/
      system.debug('---------------solUserSoql--------'+solUserSoql);
    runQuery();
    Beginning();
    //getsolUserList();
 
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
        Schema.DescribeFieldResult field = Solution_User_Assignment__c.Status__c.getDescribe();
          
        for (Schema.PicklistEntry f : field.getPicklistValues())
          status.add(f.getLabel());
 
      }
      return status;          
    }
    set;
  }
 public void searchCriteria()
    {
     oppOffListId= new Set<ID>();
     oppNewListId= new Set<ID>();
     oppClientName= new Set<ID>();
     sapOMId= new Set<String>();
      SAPOMIDList=null;  
      ClientList=null;
      OpportunityList= null; 
      List<Opportunity_TGP__c> listOpp = new List<Opportunity_TGP__c>();
      List<Solution_User_Assignment__c > listSolOpp = new List<Solution_User_Assignment__c >();
    
      if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.PMO) || userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)){
        listOpp = [select id,name,Client_Name__c,SAP_OM_Opportunity__c,SAP_OM_Opportunity__r.name from Opportunity_TGP__c order by CreatedDate Desc LIMIT 999];
       //listSolOpp= [Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Solutions__r.Opportunity_TGP__r.Complex_Cost_Architect_New__c,Solutions__r.Technical_Architect_New__c, Solutions__r.Solution_Specialist_New__c,Solutions__r.Functional_Architect_Mobilization_New__c,Solutions__r.Solution_Lead_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c  where Role__c != null];
      }else{ 
           List<Solution_User_Assignment__c> solWorkbench= Database.query(workbenchSoql);
           system.debug('--solWorkbench------------'+solWorkbench);
            oppListID= new List<ID>();
            for(Solution_User_Assignment__c  solUser: solWorkbench){
                oppListID.add(solUser.BPO_Opportunity__c);    
                      system.debug('--  inside side loop oppListID ------------'+oppListID);    
            }
         system.debug('--  out side loop oppListID ------------'+oppListID);
        listOpp = [select id,name,Client_Name__c,SAP_OM_Opportunity__c,SAP_OM_Opportunity__r.name from Opportunity_TGP__c where id in : oppListID order by name];
        //listSolOpp= [Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Solutions__r.Opportunity_TGP__r.Complex_Cost_Architect_New__c,Solutions__r.Technical_Architect_New__c, Solutions__r.Solution_Specialist_New__c,Solutions__r.Functional_Architect_Mobilization_New__c,Solutions__r.Solution_Lead_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c  where Role__c != null and BPO_Opportunity__c in :oppListID];                 
      }                         
       for(Opportunity_TGP__c tempSolOpp : listOpp)
       {
           oppNewListId.add(tempSolOpp.id);
           oppClientName.add(tempSolOpp.Client_Name__c);  
           if(tempSolOpp.SAP_OM_Opportunity__c!= null)
            sapOMId.add(tempSolOpp.SAP_OM_Opportunity__r.name);
        } 
    }
    public void searchCriteria1()
    {    
        //Load Opportunity  Start
        List<Opportunity_TGP__c> tgpOppList= [select id,name,Client_Name__c,SAP_OM_Opportunity__c from Opportunity_TGP__c where id in : oppNewListId order by CreatedDate Desc LIMIT 999];
        List<SelectOption> oppSelectList= new List<SelectOption>();
        oppSelectList.add(new SelectOption('','All'));  
        for(Opportunity_TGP__c  tempOppList : tgpOppList)
        {
            oppSelectList.add(new SelectOption(tempOppList.id,tempOppList.name));        
        }        
        OpportunityList= oppSelectList;
        //Load Opportunity  End
    }
    public void searchCriteria2()
    {        
        //Load Client Start
        //List<Client_Master__c> listClient= [Select name, Id From Client_Master__c where name!=null order by name];
        List<Client_Master__c> listClient= [Select name, Id From Client_Master__c where id in : oppClientName order by name];
        List<SelectOption> CLList= new List<SelectOption>();
        CLList.add(new SelectOption('','All')); 
        for(Client_Master__c tempClient : listClient)
        {
            CLList.add(new SelectOption(tempClient.name,tempClient.name));        
        }        
        ClientList= CLList;
        //Load Client End
    }
    public void searchCriteria3()
    {   
        //Load SAP OM ID Start
        //List<Opportunity_TGP__c> listSapOm= [Select SAP_OM_Opportunity__r.name, Name, Id From Opportunity_TGP__c where SAP_OM_Opportunity__c!=null order by name];
       // List<SAP_OM_Opportunity__c> listSapOm= [Select id,name From SAP_OM_Opportunity__c where Id in : sapOMId order by name];
        Set<string>dupSAPId= new set<string>();
        List<Solution_User_Assignment__c> listSapOm=[Select SAP_OM_ID__c  from Solution_User_Assignment__c where SAP_OM_ID__c in : sapOMId order by SAP_OM_ID__c asc]; 
        List<SelectOption> SAPList= new List<SelectOption>();
        SAPList.add(new SelectOption('','All')); 
        for(Solution_User_Assignment__c  tempSAP : listSapOm)
        {

                if(dupSAPId.contains(tempSAP.SAP_OM_ID__c))
                {
                     // dont add duplicate, do nothing
                }   
                else { 
                     dupSAPId.add(tempSAP.SAP_OM_ID__c);
                     SAPList.add(new SelectOption(tempSAP.SAP_OM_ID__c,tempSAP.SAP_OM_ID__c));
                } 
                       
        }  
        List<Integer> lsitSAPOMIDs = new List<Integer>();
        for(SelectOption s : SAPList){
            String s1 = s.getValue();
            if(s1 != '' && s1 != 'All') {
                lsitSAPOMIDs.add(Integer.valueOf(s1));
            }
        }
        lsitSAPOMIDs.sort();
        SAPOMIDList = new List<SelectOption>();
        SAPOMIDList.add(new SelectOption('','All'));
        for(Integer s: lsitSAPOMIDs){
            SAPOMIDList.add(new SelectOption(String.valueOf(s),String.valueOf(s)));
        }
        
        //SAPOMIDList.sort();
        //Load SAP OM ID  End
    }       

 
/******************************
Method Name: getEmailAddresses
Description: To retrieve Email Addresses of user
Paramenters: NA
Return Value: List<String>
*******************************/  
    public  List<String> getEmailAddresses()
    {
        List<String> idList = new List<String>();    
        List<String> mailToAddresses = new List<String>();
        List<String> lstGrpPMO = new List<String>();
        
        lstGrpPMO.add('PMO group');
       // Boolean isPMOuser;        
        List<Group> pmog = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpPMO];        
        for(integer i=0;i<pmog.size();i++ )
        {
            for (GroupMember gm : pmog[i].groupMembers) {     
                
                
               if(UserInfo.getUserId()==gm.userOrGroupId)
                {
                 isPMOuser=true;
                
                }           
                idList.add(gm.userOrGroupId);   
            }    
        }
        User[] usr = [SELECT email FROM user WHERE id IN :idList];    
        for(User u : usr) {        
            mailToAddresses.add(u.email);    
        }
        return mailToAddresses; 
    }
/******************************
Method Name: getOSLEmailAddresses
Description: To retrieve Email Addresses of Oportunity Solution Lead Group
Paramenters: NA
Return Value: List<String>
*******************************/  
public  List<String> getOSLEmailAddresses()
{
    List<String> idList = new List<String>();    
    List<String> ccaMailToAddresses = new List<String>();
    List<String> lstCCAGrpPMO = new List<String>();
    lstCCAGrpPMO.add('Lead Solution Architect – BPO PMO Group');
   // Boolean isPMOuser;
    List<Group> ccaGroup = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstCCAGrpPMO];         
    for(integer i=0;i<ccaGroup.size();i++ )
    {
        for (GroupMember gm : ccaGroup[i].groupMembers) {     
            
            
           if(UserInfo.getUserId()==gm.userOrGroupId)
            {
             isPMOuser=true;
            
            }           
            idList.add(gm.userOrGroupId);   
        }    
    }
    User[] usr = [SELECT email FROM user WHERE id IN :idList];    
    for(User u : usr) {        
        ccaMailToAddresses.add(u.email);    
    }
    return ccaMailToAddresses; 
}

/******************************
Method Name: getCCAEmailAddresses
Description: To retrieve Email Addresses of Complex Cost Architect user
Paramenters: NA
Return Value: List<String>
*******************************/  
public  List<String> getCCAEmailAddresses()
{
    List<String> idList = new List<String>();    
    List<String> ccaMailToAddresses = new List<String>();
    List<String> lstCCAGrpPMO = new List<String>();
    lstCCAGrpPMO.add('Complex Cost Architect PMO Group');
   // Boolean isPMOuser;
    List<Group> ccaGroup = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstCCAGrpPMO];         
    for(integer i=0;i<ccaGroup.size();i++ )
    {
        for (GroupMember gm : ccaGroup[i].groupMembers) {     
            
            
           if(UserInfo.getUserId()==gm.userOrGroupId)
            {
             isPMOuser=true;
            
            }           
            idList.add(gm.userOrGroupId);   
        }    
    }
    User[] usr = [SELECT email FROM user WHERE id IN :idList];    
    for(User u : usr) {        
        ccaMailToAddresses.add(u.email);    
    }
    return ccaMailToAddresses; 
}

/******************************
Method Name: getTAEmailAddresses
Description: To retrieve Email Addresses of Technical Architect user
Paramenters: NA
Return Value: List<String>
*******************************/    
public  List<String> getTAEmailAddresses()
{
    List<String> idList = new List<String>();    
    List<String> taMailToAddresses = new List<String>();
    List<String> lstTAGrpPMO = new List<String>();
    lstTAGrpPMO.add('Technical Architect PMO Group');
   // Boolean isPMOuser;
    List<Group> taGroup = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstTAGrpPMO];       
    for(integer i=0;i<taGroup.size();i++ )
    {
        for (GroupMember gm : taGroup[i].groupMembers) {     
            
            
           if(UserInfo.getUserId()==gm.userOrGroupId)
            {
             isPMOuser=true;
            
            }           
            idList.add(gm.userOrGroupId);   
        }    
    }
    User[] usr = [SELECT email FROM user WHERE id IN :idList];    
    for(User u : usr) {        
        taMailToAddresses.add(u.email);    
    }
    return taMailToAddresses; 
}

/******************************
Method Name: getSSEmailAddresses
Description: To retrieve Email Addresses of Solution Specialist user
Paramenters: NA
Return Value: List<String>
*******************************/    
public  List<String> getSSEmailAddresses()
{
    List<String> idList = new List<String>();    
    List<String> ssMailToAddresses = new List<String>();
    List<String> lstSSGrpPMO = new List<String>();
    lstSSGrpPMO.add('Solution Specialist PMO Group');
   // Boolean isPMOuser;
    List<Group> ssGroup = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstSSGrpPMO];       
    for(integer i=0;i<ssGroup.size();i++ )
    {
        for (GroupMember gm : ssGroup[i].groupMembers) {     
            
            
           if(UserInfo.getUserId()==gm.userOrGroupId)
            {
             isPMOuser=true;
            
            }           
            idList.add(gm.userOrGroupId);   
        }    
    }
    User[] usr = [SELECT email FROM user WHERE id IN :idList];    
    for(User u : usr) {        
        ssMailToAddresses.add(u.email);    
    }
    return ssMailToAddresses; 
}

/******************************
Method Name: getMAEmailAddresses
Description: To retrieve Email Addresses of Mobilization Architect user
Paramenters: NA
Return Value: List<String>
*******************************/    
public  List<String> getMAEmailAddresses()
{
    List<String> idList = new List<String>();    
    List<String> maMailToAddresses = new List<String>();
    List<String> lstMAGrpPMO = new List<String>();
    lstMAGrpPMO.add('Mobilization Architect PMO Group');
   // Boolean isPMOuser;
    List<Group> maGroup = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstMAGrpPMO];       
    for(integer i=0;i<maGroup.size();i++ )
    {
        for (GroupMember gm : maGroup[i].groupMembers) {     
            
            
           if(UserInfo.getUserId()==gm.userOrGroupId)
            {
             isPMOuser=true;
            
            }           
            idList.add(gm.userOrGroupId);   
        }    
    }
    User[] usr = [SELECT email FROM user WHERE id IN :idList];    
    for(User u : usr) {        
        maMailToAddresses.add(u.email);    
    }
    return maMailToAddresses; 
}


              
 public void submitRequestRecords()    
    {
    if(submitRequestIds !=null && submitRequestIds !=''){       
        List<Solution_User_Assignment__c>  SolUserSubReq = new List<Solution_User_Assignment__c>();
        list<string> strsubmitRequestId = submitRequestIds.split('\\,');

        List<Solution_User_Assignment__c> lstSubmitReq = [Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Offering_Master__c,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c, Resource_Assigned_User_New__r.Name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c  from Solution_User_Assignment__c where id in :strsubmitRequestId];
        
        for(Solution_User_Assignment__c subReq : lstSubmitReq){
          if(subReq.Status__c != 'New' && subReq.Status__c != 'Cancelled'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more of the records you are trying to submit have already been submitted. Please check and resubmit the request'));
            runQuery();
            return ;  
           }
           
        }
        
         for(Solution_User_Assignment__c subReq : lstSubmitReq){
          if(subReq.Status__c == 'New' || subReq.Status__c =='Cancelled'){
              if(subReq.Status__c == 'New'){
                  for(Solution_User_Assignment__c oldSolUser: solUserAssign ){                  
                      if(oldSolUser.id==subReq.id){
                          if(oldSolUser.Date_Needed_by__c < date.today())
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' You cannot select Past Date!'));
                                runQuery();
                                return ;
                            }
                            if(oldSolUser.Date_Needed_by__c !=null){
                                subReq.Date_Needed_by__c=oldSolUser.Date_Needed_by__c;
                            }
                            subReq.Comments__c=oldSolUser.Comments__c;
                            subReq.Status__c='In Progress';
                            subReq.Date_Requested__c=system.today();
                            subReq.Requester_Name__c=runningUser;
                           
                          }
                      }
                   
              }
            Solution_User_Assignment__c suSubReqObj;
            if(subReq.Status__c == 'Cancelled'){
                  for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
                      if(oldSolUser.id==subReq.id){
                          suSubReqObj= new Solution_User_Assignment__c();
                          suSubReqObj.Role__c  =oldSolUser.Role__c;
                          suSubReqObj.BPO_Opportunity__c=oldSolUser.BPO_Opportunity__c;
                          suSubReqObj.SAP_OM_ID__c=oldSolUser.SAP_OM_ID__c;
                          suSubReqObj.ClientName__c=oldSolUser.ClientName__c;
                          suSubReqObj.Offering_Master__c=oldSolUser.Offering_Master__c;
                          suSubReqObj.Status__c='In Progress';
                          suSubReqObj.Requester_Name__c=runningUser;
                          SolUserSubReq.add(suSubReqObj);
                      }
                  
               }
                  
                  
            }
           /*
            if(subReq.Status__c == 'Cancelled'){
                  for(Solution_User_Assignment__c oldSolUser: solUserAssign ){                  
                      if(oldSolUser.id==subReq.id){
                      
                      
                        
                          subReq.Role__c  =oldSolUser.Role__c;                          
                          subReq.BPO_Opportunity__c=oldSolUser.BPO_Opportunity__r.id;
                          subReq.SAP_OM_ID__c=oldSolUser.SAP_OM_ID__c;
                          subReq.ClientName__c=oldSolUser.ClientName__c;
                          subReq.Offering_Master__c=oldSolUser.Offering_Master__c;
                          subReq.Status__c='In Progress';
                          subReq.Requester_Name__c=runningUser;
                           
                          }
                      }
                   
              }*/
            
        if(subReq.Status__c == 'Cancelled'){
              for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
                  if(oldSolUser.id==subReq.id){  
                       oldSolUser.CancelleCheckBox__c=true;
                       subReq.CancelleCheckBox__c=true;
                      upsert oldSolUser;                            
                  }
                             
           }
        }

           }else{
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more of the records you are trying to submit have already been submitted. Please check and resubmit the request'));
               runQuery();
               return ;
           }           
  
          SolUserSubReq.add(subReq);   
         }

         try
            {
                //upsert SolUserCanReq;
                upsert SolUserSubReq;
                 for(Solution_User_Assignment__c solUserSubEmail : SolUserSubReq){                    
                    String oppId=solUserSubEmail.BPO_Opportunity__c;
                    String roleName=solUserSubEmail.Role__c;
                   // Date dateNeeded=solUserSubEmail.Date_Needed_by__c;
                   // Date dateRequested=solUserSubEmail.Date_Requested__c;
                    String comment=solUserSubEmail.Comments__c;
                    String request ='Submit Request';
                    if(solUserSubEmail.Date_Needed_by__c != null){
                        DateTime dtValue = DateTime.newInstance(solUserSubEmail.Date_Needed_by__c.year(), solUserSubEmail.Date_Needed_by__c.month(), solUserSubEmail.Date_Needed_by__c.day());                                
                        dateNeeded= dtValue.format('MM-dd-yyyy');                    
                    }
                    if(solUserSubEmail.Date_Requested__c != null){
                        DateTime dtValue1 = DateTime.newInstance(solUserSubEmail.Date_Requested__c.year(), solUserSubEmail.Date_Requested__c.month(), solUserSubEmail.Date_Requested__c.day());                                
                        dateRequested= dtValue1.format('MM-dd-yyyy');                
                    }
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Request submitted successfully')); 
                    sendEmailAlertToPmo(oppId, roleName, dateNeeded, dateRequested, comment, request);
                }                
                //PageReference  pr=new PageReference('/apex/SolutionUserAssignment'); 
                //pr.setRedirect(true); 
                //return pr;
                runQuery(); 
               
                
            }
            catch(Exception ex)
            {    system.debug('~~~exp2~~~'+ex);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                return ;
            }   
        //runQuery();
        return ;
    }else{
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one record before submitting the request'));          
      return ;
    }       
    }
    
   public void modifyRequestRecords()    
    {
    if(submitRequestIds !=null && submitRequestIds !=''){       
        List<Solution_User_Assignment__c>  SolUserModReq = new List<Solution_User_Assignment__c>();
        Solution_User_Assignment__c suModReqObj = new Solution_User_Assignment__c();
    
            list<string> strsubmitRequestId = submitRequestIds.split('\\,');
            List<Solution_User_Assignment__c> lstMobReq = [Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c, Resource_Assigned_User_New__r.Name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c  from Solution_User_Assignment__c where id in :strsubmitRequestId];
            
             for(Solution_User_Assignment__c mobReq : lstMobReq ){
                if(mobReq.Status__c != 'New' && mobReq.Status__c !='Cancelled' && mobReq.Status__c !='In Progress'){
    
                  for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
                      if(oldSolUser.id==mobReq.id){
                      if(oldSolUser.Date_Needed_by__c < date.today())
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' You cannot select Past Date!'));
                                runQuery();
                                return ;
                            }
                      if(oldSolUser.Date_Needed_by__c !=null){      
                          mobReq.Date_Needed_by__c=oldSolUser.Date_Needed_by__c;
                      }
                      mobReq.Comments__c=oldSolUser.Comments__c;
                      mobReq.Date_Requested__c=system.today();
                      mobReq.Status__c='In Progress';
                      mobReq.Requester_Name__c=runningUser;
                      }                    
                      
                  }
               }else{
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more of the records you are trying to modify have not been assigned yet.'));
                   runQuery();
                   return ;
               }    
              SolUserModReq.add(mobReq);   
             }
             if(SolUserModReq.size()>0){
             try
                {
                    upsert SolUserModReq;
                    
                     for(Solution_User_Assignment__c solUserSubEmail : SolUserModReq){
                        String oppId=solUserSubEmail.BPO_Opportunity__c;
                        String roleName=solUserSubEmail.Role__c;
                        //Date dateNeeded=solUserSubEmail.Date_Needed_by__c;
                        //Date dateRequested=solUserSubEmail.Date_Requested__c;
                        String comment=solUserSubEmail.Comments__c;
                        String request ='Modify Request';
                        if(solUserSubEmail.Date_Needed_by__c != null){
                            DateTime dtValue = DateTime.newInstance(solUserSubEmail.Date_Needed_by__c.year(), solUserSubEmail.Date_Needed_by__c.month(), solUserSubEmail.Date_Needed_by__c.day());                                
                            dateNeeded= dtValue.format('MM-dd-yyyy'); 
                        }                   
                        DateTime dtValue1 = DateTime.newInstance(solUserSubEmail.Date_Requested__c.year(), solUserSubEmail.Date_Requested__c.month(), solUserSubEmail.Date_Requested__c.day());                                
                        dateRequested= dtValue1.format('MM-dd-yyyy');                        
                        sendEmailAlertToPmo(oppId, roleName, dateNeeded, dateRequested, comment, request);
                     }  
                    
                   //PageReference  pr=new PageReference('/apex/SolutionUserAssignment'); 
                   // pr.setRedirect(true); 
                    //return pr;
                    runQuery();
                }
                catch(Exception ex)
                {    system.debug('~~~exp3~~~'+ex);
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                    return;
                }
             }      
            
            return ;
     }else{
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one record before modify the request'));
          return ;
    }       
    }
 public void cancelRequestRecords()    
    {
    if(submitRequestIds !=null && submitRequestIds !=''){       
        List<Solution_User_Assignment__c>  SolUserCanReq = new List<Solution_User_Assignment__c>();
        Solution_User_Assignment__c suCanReqObj = new Solution_User_Assignment__c();
    
            list<string> strsubmitRequestId = submitRequestIds.split('\\,');
            List<Solution_User_Assignment__c> lstCanReq = [Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c, Resource_Assigned_User_New__r.Name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c  from Solution_User_Assignment__c where id in :strsubmitRequestId];
            
             for(Solution_User_Assignment__c canReq : lstCanReq ){
                if(canReq.Status__c != 'New' && canReq.Status__c !='Cancelled'){
                
                for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
                      if(oldSolUser.id==canReq.id){ 
                      if(oldSolUser.Date_Needed_by__c < date.today())
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' You cannot select Past Date!'));
                                runQuery();
                                return ;
                            }                     
                      canReq.Status__c='Cancelled';
                      canReq.Requester_Name__c=runningUser;                      
                      canReq.Date_Needed_by__c=oldSolUser.Date_Needed_by__c;
                      canReq.Comments__c=oldSolUser.Comments__c;
                      }

                  }
                   //canReq.Status__c='Cancelled';
                      //canReq.Requester_Name__c=runningUser;
               }else{
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more of the records you are trying to cancel have not been submitted. Please submit the request before Cancelling'));
                   return ;
               }    
              SolUserCanReq.add(canReq);   
             }
             if(SolUserCanReq.size()>0){
             try
                {
                    upsert SolUserCanReq;
                    
                     for(Solution_User_Assignment__c solUserSubEmail : SolUserCanReq){
                        String oppId=solUserSubEmail.BPO_Opportunity__c;
                        String roleName=solUserSubEmail.Role__c;
                        //Date dateNeeded=solUserSubEmail.Date_Needed_by__c;
                        //Date dateRequested=solUserSubEmail.Date_Requested__c;
                        String comment=solUserSubEmail.Comments__c;
                        String request ='Cancel Request';
                        if(solUserSubEmail.Date_Needed_by__c != null){
                            DateTime dtValue = DateTime.newInstance(solUserSubEmail.Date_Needed_by__c.year(), solUserSubEmail.Date_Needed_by__c.month(), solUserSubEmail.Date_Needed_by__c.day());                                
                            dateNeeded= dtValue.format('MM-dd-yyyy');                    
                        }
                        if(solUserSubEmail.Date_Requested__c != null){
                            DateTime dtValue1 = DateTime.newInstance(solUserSubEmail.Date_Requested__c.year(), solUserSubEmail.Date_Requested__c.month(), solUserSubEmail.Date_Requested__c.day());                                
                            dateRequested= dtValue1.format('MM-dd-yyyy');                    
                        }                      
                        sendEmailAlertToPmo(oppId, roleName, dateNeeded, dateRequested, comment, request);
                     }                    
                    
                   // PageReference  pr=new PageReference('/apex/SolutionUserAssignment'); 
                   // pr.setRedirect(true); 
                   // return pr;
                   runQuery();
                    
                }
                catch(Exception ex)
                {    system.debug('~~~exp4~~~'+ex);
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                    return ;
                }
             }      
            //runQuery();
            return ;
     }else{
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one record before cancel the request'));
          return ;
    }       
    }

/******************************
Method Name: sendEmailAlertToPmo
Description: Method for sending the email Alerts-Form the message object
Paramenters: NA
Return Value: void
*******************************/

public void sendEmailAlertToPmo(String oppId, String roleName, String dateNeeded, String  dateRequested, String comment, String request)
{
    List<Opportunity_TGP__c> opportunityList=[select id, name, Activity__c,TCV__c, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, Client_Name__r.name, Comments__c,Offerings__c,
                                                        Expected_contract_sign_qtr__c, Operating_Group__r.name, Enterprise_Solution_Architect_New__r.name, Risk_Level__c,Service_Delivery_Locations_Unique__c,
                                                        SAP_OM_ID__c, Stage__c, SAP_OM_Opportunity__r.name from Opportunity_TGP__c where id=:oppId];    
    
   
   
   List<User> userNameList=[SELECT Name FROM User where id=:UserInfo.getUserId()];
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
       // Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       if(roleName=='Mobilization Architect'){
            mail.setToAddresses(getMAEmailAddresses());
       }
       if(roleName=='Solution Specialist'){
            mail.setToAddresses(getSSEmailAddresses());
       }
       if(roleName=='Technical Architect'){
             mail.setToAddresses(getTAEmailAddresses());
       }
       if(roleName=='Complex Cost Architect'){
            mail.setToAddresses(getCCAEmailAddresses());
       }
       if(roleName=='Lead Solution Architect – BPO'){
            mail.setToAddresses(getOSLEmailAddresses());
       }
        //mail.setSenderDisplayName('BPO Solution Support');    
       // String subject='New Request for '+checkNullValues(userName)+', Client Name: '+checkNullValues(opportunityRecord.Client_Name__r.name)+'  Opportunity Name: '+checkNullValues(opportunityRecord.name);
        String subject='';
        String strBody='';
        if(request =='Submit Request'){
            subject='NOTIFICATION:  New Request for '+ roleName +' '+'Submitted - Client Name: '+(opportunityList[0].Client_Name__r.name)+' - Opportunity Name: '+(opportunityList[0].name);
            strBody='A new request for '+ roleName +' has been submitted with the following details:'; 
        
        }
        if(request =='Modify Request'){
            subject= 'NOTIFICATION:  Request for '+ roleName +' '+'Modified - Client Name: '+(opportunityList[0].Client_Name__r.name)+' - Opportunity Name: '+(opportunityList[0].name);
            strBody='Below request for '+ roleName +' has been modified with the following details:';
        }
        if(request =='Cancel Request'){
            subject= 'NOTIFICATION:  Request for '+ roleName +' '+'Cancelled - Client Name: '+(opportunityList[0].Client_Name__r.name)+' - Opportunity Name: '+(opportunityList[0].name);
            strBody='Below request for '+ roleName +' with following details has been cancelled:'; 
        }
        
               

       mail.setSubject(subject);    
    
        mail.setHtmlBody
        (
            '<html>' +
            '    <body>' +
            '   <STYLE type="text/css">' +
           
            '</STYLE>' +
            '<font face="Calibri (Body)" style="font-size:11pt" >'+
            strBody+
            '</font>'+
    '<hr/>' +
            '<table border="1" rules="rows" width="60%" cellpadding="5">' +
            // '<tr height="20">  ' +
            // '<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity ID:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(Opportunity_ID__c)+'</font>'+''+'</td>' +
           //  '</tr>' +
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
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Expected Contract Sign (Qtr):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Expected_contract_sign_qtr__c)+'</font>'+''+'</td>' + 
           
            '</tr>' +
    
    
            '<tr height="20">  ' +
             '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">BPO Net Revenue (SAP OM)<br/>(Thousands):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(opportunityList[0].TCV__c)+'</font>'+''+'</td>' + 
            
            
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Area:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Client_Geo_Area__r.name)+'</font>'+''+'</td>' + 
            
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Unit:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Client_Geo_Unit__r.name)+'</font>'+''+'</td>' + 
            
            '</tr>' +
    
            '<tr height="20">  ' +
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(opportunityList[0].Operating_Group__r.name)+'</font>'+''+'</td>' + 
           
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
            '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Requestor:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(userNameList[0].name)+'</font>'+''+'</td>' + 
            
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
           
           
            '</table>' +
    
            '<hr/>' +
             '<font face="Calibri (Body)" style="font-size:11pt" >'+
            '<br/>' +
            '     <a href ="'+strUrl+'/apex/PMOSolutionUserAssignment" target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
            '    <p>This is a system generated message. Please do not reply to this message.</p>' +
            '</font>'+
            '</body>' +
            '</html>'
        );
        mail.saveAsActivity=false;  
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    catch(System.EmailException ex)
    {    system.debug('~~~exp5~~~'+ex);
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending mail!'));
        return;
    }
}

 public void savingCustomerRecord(){
        if(submitRequestIds !=null && submitRequestIds !=''){       
        
        list<string> strsubmitRequestId = submitRequestIds.split('\\,');
        List<Solution_User_Assignment__c> lstSaveReq = [Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Offering_Master__c,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c  from Solution_User_Assignment__c where id in :strsubmitRequestId];
       
        for(Solution_User_Assignment__c oldSolUser: solUserAssign ){ 
            for(Solution_User_Assignment__c savReq : lstSaveReq){
              if(oldSolUser.Date_Needed_by__c != savReq.Date_Needed_by__c && oldSolUser.Id == savReq.Id){             
                if(oldSolUser.Date_Needed_by__c < date.today())
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' You cannot select Past Date!'));
                    runQuery();
                    return;
                }  
             }               
           }
        }

 
     if(solUserAssign.size()>0){ 

         upsert solUserAssign;

         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved successfully.'));
         runQuery();
     }
            //return null;
    }
   }
   public void clearFilter()
    {
    isAggregateResult = true;
       // soql = 'Select id,Name,BPO_Opportunity__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User__c,Resource_Assigned_User__r.name,Technical_Architect_Approval_User__c, Technical_Architect_Approval_User__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c  from Solution_User_Assignment__c where Role__c != null';
    if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.PMO) || userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)){
            soql = 'Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c where '+
           ' Role__c != null and BPO_Opportunity__c IN : oppListIDs ';     
     }else{
          soql = 'Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c where '+
           ' BPO_Opportunity__c IN (SELECT BPO_Opportunity__c FROM Opportunity_Team__c where Opportunity_Team_Member__r.SFDC_User__c =\''+RunningUser+'\' '+')';
       workbenchSoql =soql; 
        }         
  /*  solUserAllList = Database.query(soql);
    oppClearID= new List<ID>();
    for(Solution_User_Assignment__c  solUser: solUserAllList ){
        oppClearID.add(solUser.BPO_Opportunity__c);         
    }
     solUserSoql  = 'Select id,Name,BPO_Opportunity__c,Solutions__r.Opportunity_TGP__r.Enterprise_Solution_Architect_New__c,Solutions__r.Opportunity_TGP__r.Complex_Cost_Architect_New__c,Solutions__r.Technical_Architect_New__c,Solutions__r.Technical_Architect_New__c,Solutions__r.Solution_Specialist_New__c,Solutions__r.Functional_Architect_Mobilization_New__c,Solutions__r.Solution_Lead_New__c,Comments__c,Date_Assigned__c,Date_Needed_by__c,Date_Requested__c,Status__c,Offering_Master__r.Name,Role_Requested__c,ClientName__c,SAP_OM_ID__c,User__c,User__r.name,Role__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.name, Requester_Name__c,Requester_Name__r.name,CancelleCheckBox__c from Solution_User_Assignment__c  where Role__c != null and BPO_Opportunity__c in :oppClearID';            
    */ 
    solUserSoql  =soql;     
        runQuery();
        Beginning();
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
      //counter = total_size - math.mod(total_size, list_size);  
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

   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) 
      
      return false; else return true;

   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      //return counter/list_size + 1;
      return counter/list_size + 1;
   }

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
    
}