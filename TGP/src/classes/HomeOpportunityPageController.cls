/*
Author : Shridhar Patankar
Story  : Story-258/SOL_126  
Description : To search Opportunity based on fields.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public with sharing class HomeOpportunityPageController{
    public List<OpportunityWrapper> ListOpportunity{get;set;}
    public List<OpportunityWrapper> ListOpportunityWrapper{get;set;}
    public Integer pageSize{get;set;}
    public Integer pageNumber{get;set;}
    private integer counter{get;set;}//keeps track of the offset
    private integer list_size{get;set;}//sets the page size or number of rows
    public integer total_size{get;set;} //used to show user the total size of the list
    public String listViewSelected {get; set;}
    public Boolean isExist{get;set;}
    public String RunningUser {get;set;}
    public String RunningUserEmail {get; set;}
    // the soql without the order and limit
    private String soql {get;set;}
    private String soql1 {get;set;}
    // the collection of contacts to display
    public List<Opportunity_Offering__c> opptys  {get;set;}
    public List<Opportunity_Offering__c> opptys1  {get;set;}
    public List<Opportunity_TGP__c> opptgp  {get;set;}
    public List<Opportunity_TGP__c> opptgp1  {get;set;}
    private String soqlnew {get;set;}
    // the current sort direction. defaults to asc
    public String sortDir 
    {
        get  { if (sortDir == null) {  sortDir = UTIL_constants.ASC_ORDER; } return sortDir;  }
        set;
    }
 
   // the current field to sort by. defaults to last name
   public String sortField
   { 
       get  { if (sortField == null) {sortField = 'Activity__c,Client_Name__r.Name'; } return sortField;  } //,Opportunity_TGP__r.Client_Name__r.Name
       set;
   }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + UTIL_constants.ORDER_BY + sortField + ' ' + sortDir; }
    set;
  }

  
 
  // init the controller and display some sample data when the page loads
  public HomeOpportunityPageController() 
    {
        pageSize = 5;
        pageNumber = 1;
        counter=0;
        list_size=9;
        total_size=0;
        opptys = new List<Opportunity_Offering__c>();
        RunningUser =UserInfo.getUserId();   
             
        //opptgp1 =[Select id,Name,Complex_Cost_Architect_New__c,Enterprise_Solution_Architect_New__r.name,SAP_OM_Opportunity__r.Name,Client_Name__r.Name,Activity__c,Comments_Status__c,Staffing_Status__c from Opportunity_TGP__c];   
        
        //soql1='Select id, Name, Complex_Cost_Architect_New__c, Complex_Cost_Architect_New__r.SFDC_User__c, Complex_Cost_Architect_New__r.Name, Enterprise_Solution_Architect_New__r.SFDC_User__c, Enterprise_Solution_Architect_New__r.name,SAP_OM_Opportunity__r.Name,Client_Name__r.Name,Activity__c,Comments_Status__c,Staffing_Status__c from Opportunity_TGP__c';

        
          
        runQuery();
        
        ListOpportunityWrapper =new List<OpportunityWrapper>();
        List<Opportunity_Offering__c> lstOffering = new List<Opportunity_Offering__c> ();
        boolean isExist=false;
        
        
        
        if(opptgp.size()>0)
        {
            for(Opportunity_TGP__c tempOpp : opptgp)
            {
                boolean isAvailable=false;
               // if(tempOpp.Enterprise_Solution_Architect_New__r.SFDC_User__c == RunningUser)
               // {                                        
                    isAvailable=true;                      
               // }      
                lstOffering = new List<Opportunity_Offering__c> ();
                 
                 
                if(opptys1.size()>0)
                {
                    for(Opportunity_Offering__c tempOff : opptys1)
                    {
                        if(tempOpp.id== tempOff.Opportunity_TGP__c)
                        {            
                                lstOffering.add(tempOff);                                                   
                                isAvailable=true;
                               
                        }
                    }
                }
                if(isAvailable== true)
                {
                    total_size = total_size+1;
                    ListOpportunityWrapper.add(new OpportunityWrapper(lstOffering, tempOpp));
                }
            }
        }
        
      giveList(); 
    }
 
 public class OpportunityWrapper
 {
    public List<Opportunity_Offering__c> lstOffering  {get;set;}
    public Opportunity_TGP__c objOpportunity  {get;set;} 
    
    public OpportunityWrapper(List<Opportunity_Offering__c> lstOffering, Opportunity_TGP__c objOpportunity)
    {
        this.lstOffering=lstOffering;
        this.objOpportunity=objOpportunity;
    }
 }
 
    public List<OpportunityWrapper> getListOpportunityWrapper()
    {
        List<OpportunityWrapper> ListOpportunityWrapper =new List<OpportunityWrapper>();
        return ListOpportunityWrapper;
    }
    
    // toggles the sorting of query from asc<-->desc
    public void toggleSort() 
    {
        // simply toggle the direction
        sortDir = sortDir.equals(UTIL_constants.ASC_ORDER) ? UTIL_constants.DESC_ORDER : UTIL_constants.ASC_ORDER;
        // run the query again
        //runQuery();
    }
 
    // runs the actual query
   /* public void runQuery() 
    {
        Integer offset = pageNumber * pageSize;  
        try 
        {
            opptgp =Database.query(soql1);
            opptys1 = Database.query(soql);
        } 
        catch (Exception e) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
        }
        return;
    }*/
    public void runQuery() 
    {
        Integer offset = pageNumber * pageSize; 
        
        set<Id> idList = new set<Id>(); 
        
        soql = 'select Name,Offering_Master__r.Name,Opportunity_TGP__r.Name, Opportunity_TGP__r.Comments_Status__c,'+
        'Opportunity_TGP__r.SAP_OM_Opportunity__r.Name, Opportunity_TGP__r.Client_Name__r.Name,Opportunity_TGP__r.Client_Geo_Area__r.Name,'+
        'Opportunity_TGP__r.Operating_Group__r.Name,Opportunity_TGP__r.Activity__c,Opportunity_TGP__r.Stage__c,Solution_Lead_New__r.Name '+
        'from Opportunity_Offering__c where '+
        ' Opportunity_TGP__c IN (SELECT BPO_Opportunity__c FROM Opportunity_Team__c where Opportunity_Team_Member__r.SFDC_User__c =\''+RunningUser+'\' '+')';
      /*  soql = 'select Name,Offering_Master__r.Name,Opportunity_TGP__r.Name, Opportunity_TGP__r.Comments_Status__c,'+
        'Opportunity_TGP__r.SAP_OM_Opportunity__r.Name,Technical_Architect_New__r.Email_ID_of_the_reviewer__c, Opportunity_TGP__r.Client_Name__r.Name,Opportunity_TGP__r.Client_Geo_Area__r.Name,'+
        'Opportunity_TGP__r.Operating_Group__r.Name,Opportunity_TGP__r.Activity__c,Opportunity_TGP__r.Stage__c,Solution_Lead_New__r.Name '+
        'from Opportunity_Offering__c '; */
        
        try 
        {
            //opptgp =Database.query(soql1);
            opptys1 = Database.query(soql);
            
            for(Opportunity_Offering__c offRec : opptys1)
            {
                idList.add(offRec.Opportunity_TGP__c);
                
            }
            
            opptgp = [Select id, Name, Enterprise_Solution_Architect_New__r.SFDC_User__c, 
                    Enterprise_Solution_Architect_New__r.name,SAP_OM_Opportunity__r.Name,Client_Name__r.Name,Activity__c,
                    Comments_Status__c,Staffing_Status__c from Opportunity_TGP__c where id IN (SELECT BPO_Opportunity__c FROM Opportunity_Team__c where Opportunity_Team_Member__r.SFDC_User__c =:RunningUser)];
        } 
        catch (Exception e) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
        }
        return;
    }
    
    
    public void giveList()
    {
        ListOpportunity=new List<OpportunityWrapper>();
        integer i;
        for(i=counter; i<=list_size && i<ListOpportunityWrapper.size() ; i++)
        {   if(counter >= 0 ){
                if(ListOpportunityWrapper[i]!=null)
                {
                    ListOpportunity.add(ListOpportunityWrapper[i]);
                }
            }
        }

        
    }
  
    
   public PageReference Beginning() 
   { //user clicked beginning
      counter = 0;
      list_size=9;
      pageNumber =1;
      runQuery();
      giveList(); 
      return null;
   }
 
   public PageReference Previous() 
   { //user clicked previous button
        list_size=counter-1;
        counter= list_size-9;
        //counter = counter-4;
        //list_size =list_size-5;
        pageNumber =pageNumber -1;
        
        
        runQuery();
        giveList(); 
        
        return null;
   }
 
   public PageReference Next() 
   { //user clicked next button
      counter= list_size+1;
      list_size=list_size+10;
      pageNumber =pageNumber +1;
            runQuery();
            giveList();
      return null;
   }
 
   public PageReference End() 
   { //user clicked end
      
      list_size=total_size;
      //counter =list_size-4;
      if(math.mod(total_size,10)==0)
      {
          counter = total_size - 10;
      }
      else
      {
          counter = total_size - math.mod(total_size,10);
      }
      pageNumber =getTotalPages();
       
      runQuery();
      giveList(); 
     
      return null;
   }
 
   public Boolean getDisablePrevious() 
   { 
      //this will disable the previous and beginning buttons
      if (pageNumber == 1) return true; 
      else return false;
      
      
   }
 
   public Boolean getDisableNext() 
   { //this will disable the next and end buttons
      if (pageNumber ==getTotalPages()) return true; else return false;
      
   }
 
   /*public Integer getTotal_size() 
   {
      runQuery();
      return total_size;
      
   }*/
 
   public Integer getPageNumber() 
   {
      runQuery();
      giveList(); 
      return counter/list_size;// + 1;
      
   }
 
   public Integer getTotalPages() 
   {
      if(total_size==0)
      {
        return 1;
      }
      else if (math.mod(total_size, 10) >0) 
      {
         //runQuery();
         //giveList(); 
         return ((total_size/10)+1 );
      } 
      else 
      {
         //runQuery();
         //giveList(); 
         return (total_size/10);
      }
     
   }
}