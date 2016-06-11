/*
Author : Mayank Agarwal
Story  : Story-0143/SOL_060  
Description : To search Opportunity based on fields.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public with sharing class OpportunitySearchController {
 
    public String listViewSelected {get; set;}
    public Boolean listSelectComplexCostArch {get; set;}
    public Boolean listSelectInactive {get; set;}
    public Boolean viewColRender {get; set;}
    public String testurl{get;set;}
    public Boolean variable{get;set;}
    public String allStagePicklistDefault{get;set;}
    public String allActivityPicklistDefault{get;set;}
    
    public String allServiceGrpPicklistDefault{get;set;}
    //SOL 167 Start
    public Opportunity_TGP__c oppTgp{get;set;}
    public String strOffering{get; set;}
    public List<SelectOption> strOfferingsList{get;set;}
    
    public List<SelectOption> serviceGroupList{get;set;}
    public List<SelectOption> optionsServiceGrp{get;set;}
    
    
    public String strOperatingGroup{get; set;}
    public List<SelectOption> strOperatingGroupList{get;set;}
    public String strClientGeoArea{get; set;}
    public List<SelectOption> strClientGroAreaList{get;set;}
    public List<SelectOption> optionsOffering{get;set;}
    public string pipelineUnqualified{get;set;}
    public String sapOMId{get;set;}
    public String clientName{get;set;}
    public String opportunityName{get;set;}
    public String offeringName{get;set;}
    public String geoArea{get;set;}
    public String opGroup{get;set;}
    public String stage{get;set;}
    public String activity{get;set;}
    public String serviceGrp{get;set;}
    public String solOppLead{get;set;}
    public List<SelectOption> optionsOperatingGroup{get;set;}
    private static boolean isItFirstTime = true;
    public List<Opportunity_TGP__c> countOpportunity;
    public string RunningUser{get;set;}
    public String userProfileName {get;set;}
    public static List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
    
    
    
    //Variables for Pagination
    private integer totalRecs = 0;     
    private integer index = 0;
    private integer blockSize = 50; 
    //Methods for Pagination
    
    private integer totalRecsSearch = 0;     
    private integer indexSearch = 0;
    private integer blockSizeSearch = 5;
    public boolean isSearchPage{get; set;}
    public boolean isStartOfSearch = false; 
    public boolean getprevSearchVar{get; set;} 
    public boolean getnextSearchVar{get; set;} 

    //Methods for Pagination
   
    //SOL 167 End
  // the soql without the order and limit
  private String soql {get;set;}
  private String savedSoqlForSearchPagination;
  // the collection of contacts to display
  public List<Opportunity_TGP__c> opptysBeforeSorting ;
  public List<Opportunity_TGP__c> opptys  {get;set;}
  public List<Opportunity_TGP__c> opptysearched {get; set;}
  public List<Opportunity_TGP__c> countOfAllSearchedOpportunity; 
  public list<String> oppfinalList;
  public  List<String> oppOfffinalList;
  public  Set<Id> oppIdList;
  public  Set<Id> offOppIdList;
  public List<Opportunity_TGP__c> oppDealRadarList;
  List<Opportunity_Offering__c> offeringList;
 // Method for Search Pagination
    public void beginningSearch()
    {
     try{       
        indexSearch = 0;
        runQueriesForPagination();
       }
        catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e.getMessage()));}
    }
// Search Previous Page Records
    public void previousSearch()
    {
     try{
        indexSearch = indexSearch - blockSizeSearch;
        runQueriesForPagination();
        }
        catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e.getMessage()));}
        
    }
// Search Next Page Records    
    public void nextSearch()
    {
        try{    
        indexSearch = indexSearch + blockSizeSearch;
        runQueriesForPagination();
        }
    catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e.getMessage()));}
}
// End Search
    public void endSearch()
    {
    try{    
        if(math.mod(totalRecsSearch,blockSizeSearch) == 0){
          indexSearch = (totalrecsSearch - math.mod(totalRecsSearch,blockSizeSearch))-10;
        }else{
          indexSearch = totalrecsSearch - math.mod(totalRecsSearch,blockSizeSearch);
        } 
        runQueriesForPagination();
        }
        catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e.getMessage()));}
    }        
// Previous Page    
    public boolean getprevSearch()
    {
        try{    
        if(indexSearch == 0){
         getprevSearchVar= true;
        }         
        else{
        getprevSearchVar= false;
        }
        }
       catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e.getMessage()));}
        return getprevSearchVar;
                
   } 
// Next Page
    public boolean getnxtSearch()
    {
        try{    
        if((indexSearch + blockSizeSearch) > totalRecsSearch){
        getnextSearchVar = true;
        }
        else {
            getnextSearchVar = false;
        }
    }
     catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e.getMessage()));}
        return getnextSearchVar;
    } 
// Get Page Number    
    public Integer getPageNumberSearch() {
      return indexSearch/blockSizeSearch + 1;
   }
// Get Total number of  Pages   
    public Integer getTotalPagesSearch() {

     if(totalRecsSearch <= 10){
          return  1;
      }else{ 
          if (math.mod(totalRecsSearch, blockSizeSearch) > 0) {
             return (totalRecsSearch/blockSizeSearch) + 1;
          } else {
             return (totalRecsSearch/blockSizeSearch);
          }
      }
       }
// Method runSearchWrapper
   
   public void runSearchWrapper() {
       totalRecsSearch = 0;     
       indexSearch = 0;
       blockSizeSearch = 50;
       isSearchPage = true;
       isStartOfSearch = true;
   runSearch();
   }
     
 //Methods for Pagination
     
    public void beginning()
    {
        index = 0;
        runQuery();
    }
 //Method to Query Previous page records    
    public void previous()
    {
        index = index - blockSize;
        runQuery();
    }
 //Method to query next page records    
    public void next()
    {
        index = index + blockSize;
        runQuery();
    }
 //Methods to mark end of Pagination
    public void end()
    {
        if(math.mod(totalRecs,blockSize) == 0){
          index = (totalrecs - math.mod(totalRecs,blockSize))-10;
        }else{
          index = totalrecs - math.mod(totalRecs,blockSize);
        } 
        runQuery();
    }        
    
    public boolean getprev()
    {
     
        if(index == 0)
        return true;
        else
        return false;
    }  
    
    public boolean getnxt()
    {
        if((index + blockSize) > totalRecs)
        return true;
        else
        return false;
    } 
    
    public Integer getPageNumber() {
      return index/blockSize + 1;
   }
   
    public Integer getTotalPages() {
     if(totalRecs <= 10){
          return  1;
      }else{ 
          if (math.mod(totalRecs, blockSize) > 0) {
             return (totalRecs/blockSize) + 1;
          } else {
             return (totalRecs/blockSize);
          }
      }
   }
   
   
 // Sorting Logic based On the field and object and order
 
  public static List<Sobject> sortObjectList(List<Sobject> items, String fieldtToSortOn, String order){
  
        List<Sobject> resultList = new List<Sobject>();
        List<Sobject> resultSortedList = new List<Sobject>();
        String relationshipObjectName;
        String relationshipFieldName;
        sObject reltnshpObject;
        if (fieldtToSortOn.contains('__r') || fieldtToSortOn.contains('__R')){
            relationshipObjectName = fieldtToSortOn.substringBefore('.');
            relationshipFieldName = fieldtToSortOn.substringAfter('.');
        }
   
        //Create a map that can be used for sorting 
       Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();  
       for(Sobject ob : items){
                
                if (fieldtToSortOn.contains('__r') || fieldtToSortOn.contains('__R')) {
                    
                    reltnshpObject = ob.getsObject(relationshipObjectName);
                    
                    if (reltnshpObject != null) {
                        if(objectMap.get(reltnshpObject.get(relationshipFieldName)).isEmpty()){  // For non Sobject use obj.ProperyName
                            objectMap.put(reltnshpObject.get(relationshipFieldName), new List<Sobject>());
                        } 
                        objectMap.get(reltnshpObject.get(relationshipFieldName)).add(ob);
                   }
                    else {
                        if(objectMap.get('').isEmpty()){  
                            objectMap.put('', new List<Sobject>());
                        } 
                        objectMap.get('').add(ob); 
                   }  
               } 
                else {
                    if(objectMap.get(ob.get(fieldtToSortOn)).isEmpty()){  
                        objectMap.put(ob.get(fieldtToSortOn), new List<Sobject>());
                    } 
                    objectMap.get(ob.get(fieldtToSortOn)).add(ob);
                }
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
       
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
       
        //Apply the sorted values to the source list
        if(order.toLowerCase().equalsIgnoreCase('desc')){
            for(integer i = resultList.size()-1; i >= 0; i--){
                resultSortedList.add(resultList[i]);  
            }
        }
        return resultSortedList;
    }
    
    
  // the current sort direction.
  public String sortDir {
    get  { if (String.isBlank(sortDir)) {  sortDir = 'desc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
   get  { if (String.isBlank(sortField )) {sortField = 'Created_Date__c'; } return sortField;  }
    set;
  }
  // init the controller and display some sample data when the page loads
  public OpportunitySearchController() {
  //Start SOL 167
    oppTgp= new Opportunity_TGP__c();
 //End SOL 167  
    allStagePicklistDefault = 'All';
    allActivityPicklistDefault = 'All';
    allServiceGrpPicklistDefault = 'All';
    pipelineUnqualified = 'Unqualified/Pipeline';
    listSelectComplexCostArch = false;
    listSelectInactive = false;
    viewColRender = false;
    variable = true;
    RunningUser=UserInfo.getUserId();  
    //    Load offering picklist Start
        strOfferingsList = null;
        List<Offerings_Master__c> lstOfferings= [Select id,Name From Offerings_Master__c where active__c=:true order by name];
         optionsOffering = new List<SelectOption>();
        optionsOffering.add(new SelectOption('','All')); 
        for(Offerings_Master__c tempOffer : lstOfferings )
        {
            optionsOffering.add(new SelectOption(tempOffer.name,tempOffer.name));        
        }        
        strOfferingsList = optionsOffering;
    //Offering Loading End  
    
    //Load Service Group
    
        /*serviceGroupList = null;
        List<Offerings_Master__c> lstOfferings= [Select id,Name From Offerings_Master__c where active__c=:true order by name];
         optionsOffering = new List<SelectOption>();
        optionsOffering.add(new SelectOption('','All')); 
        for(Offerings_Master__c tempOffer : lstOfferings )
        {
            optionsOffering.add(new SelectOption(tempOffer.name,tempOffer.name));        
        }        
        strOfferingsList = optionsOffering;*/
    
    //Service Group load end
    //Load operating group  Start
      strOperatingGroupList = null;
        List<Operating_Group_Master__c> lstOperating= [Select id,Name From Operating_Group_Master__c where active__c=:true order by name];
        optionsOperatingGroup = new List<SelectOption>();
        optionsOperatingGroup.add(new SelectOption('','All')); 
        for(Operating_Group_Master__c tempOffer : lstOperating )
        {
            optionsOperatingGroup.add(new SelectOption(tempOffer.name,tempOffer.name));        
        }        
        strOperatingGroupList = optionsOperatingGroup;
    //operating group End
    
    //Load Client Geo Area  Start
      strClientGroAreaList = null;
        List<Client_Geo_Area_Master__c> listClientGeo= [Select id,Name From Client_Geo_Area_Master__c where active__c=:true order by name];
        List<SelectOption> optionsClientGeoArea = new List<SelectOption>();
        optionsClientGeoArea.add(new SelectOption('','All')); 
        for(Client_Geo_Area_Master__c tempOffer : listClientGeo )
        {
            if(!tempOffer.name.equals('EALA'))
            {
                optionsClientGeoArea.add(new SelectOption(tempOffer.name,tempOffer.name));        
            }
        }        
        strClientGroAreaList = optionsClientGeoArea;
   soql = 'select Name,Offerings__c,service_group__c,Staffing_Status__c,Offering_Solution_Leads__c,Offering_Solution_Specialists__c,LastModifiedDate,CreatedDate,Risk_Level__c,SAP_OM_Opportunity__r.Name, Expected_contract_sign_qtr__c, Client_Name__r.Name, Client_Geo_Area__r.Name, Client_Geo_Unit__r.Name, Operating_Group__r.Name, Activity__c,Stage__c,Enterprise_Solution_Architect_New__c,Created_Date__c  from Opportunity_TGP__c where Client_Name__c != null AND Name NOT IN(\'PTO\', \'Training\', \'Other Deal Support\', \'Other Unavailable\')';
   runQuery();
    
  }

  // runs the actual query
  public void runQuery() {
 
    try {
        if (isItFirstTime) {
            String[] soqlToCount = soql.split(' from ');
            totalRecs = Database.countQuery('select count() from ' + soqlToCount[1]); 
            isItFirstTime = false;
        }
     
       opptysBeforeSorting = Database.query(soql  + ' order by ' + sortField + ' ' + sortDir + ' LIMIT '+ blockSize +' OFFSET '+ index );   
       opptys = opptysBeforeSorting ;
      
    } catch (Exception e) {
      //if(opptys.Size()>0)
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e.getMessage()));
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
   
    opportunityName = Apexpages.currentPage().getParameters().get('opportunityName');
    offeringName = Apexpages.currentPage().getParameters().get('offeringName');
    sapOMId = Apexpages.currentPage().getParameters().get('sapOMId');
    clientName = Apexpages.currentPage().getParameters().get('clientName');
    geoArea = Apexpages.currentPage().getParameters().get('geoArea');
    opGroup = Apexpages.currentPage().getParameters().get('opGroup');
    stage = Apexpages.currentPage().getParameters().get('stage');
    activity = Apexpages.currentPage().getParameters().get('activity');
    serviceGrp = Apexpages.currentPage().getParameters().get('serviceGrp');
    //String technology = Apexpages.currentPage().getParameters().get('technology');
    solOppLead =Apexpages.currentPage().getParameters().get('oppSolLead');
    if(opportunityName.equals('') && offeringName.equals('') && sapOMId.equals('') && clientName.equals('') && geoArea.equals('') 
        && opGroup.equals('') && activity.equals('All') && serviceGrp.equals('All') && stage.equals('All') && solOppLead.equals('')) {
            IsSearchPage = false;
            soql = 'select Name,Offerings__c,Staffing_Status__c,Offering_Solution_Leads__c,service_group__c,Offering_Solution_Specialists__c,LastModifiedDate,CreatedDate,Risk_Level__c,SAP_OM_Opportunity__r.Name, Expected_contract_sign_qtr__c, Client_Name__r.Name, Client_Geo_Area__r.Name, Client_Geo_Unit__r.Name, Operating_Group__r.Name, Activity__c,Stage__c,Enterprise_Solution_Architect_New__c,Created_Date__c  from Opportunity_TGP__c where Client_Name__c != null AND Name NOT IN(\'PTO\', \'Training\', \'Other Deal Support\', \'Other Unavailable\')'; //order by CreatedDate;
            runQuery();
    }
    else {
    
          soql = 'select Id, Name,Created_Date__c,Offerings__c,Staffing_Status__c,service_group__c,Offering_Solution_Leads__c,Offering_Solution_Specialists__c,LastModifiedDate,CreatedDate,Risk_Level__c,SAP_OM_Opportunity__r.Name, Expected_contract_sign_qtr__c, Client_Name__r.Name, Client_Geo_Area__r.Name, Client_Geo_Unit__r.Name, Operating_Group__r.Name, Activity__c,Stage__c,Enterprise_Solution_Architect_New__c from Opportunity_TGP__c where Client_Name__c != null AND Name NOT IN(\'PTO\', \'Training\', \'Other Deal Support\', \'Other Unavailable\')';
         
        if (!opportunityName.equals(''))
          soql += ' and Name LIKE \''+String.escapeSingleQuotes(opportunityName)+'%\'';
        if (!offeringName.equals(''))
          soql += ' and Offerings__c LIKE \''+'%'+String.escapeSingleQuotes(offeringName)+'%\'';
        if (!sapOMId.equals(''))
          soql += ' and SAP_OM_Opportunity__r.Name LIKE \''+String.escapeSingleQuotes(sapOMId)+'%\'';
        if (!clientName.equals(''))
          soql += ' and Client_Name__r.Name LIKE \''+String.escapeSingleQuotes(clientName)+'%\'';
        if (!geoArea.equals(''))
        {
          soql += ' and Client_Geo_Area__r.Name LIKE \''+String.escapeSingleQuotes(geoArea)+'%\'';
        }
        if (!opGroup.equals(''))
          soql += ' and Operating_Group__r.Name LIKE \''+String.escapeSingleQuotes(opGroup)+'%\'';
          
        if (!serviceGrp.equals('All'))
          soql += ' and service_group__c = \''+String.escapeSingleQuotes(serviceGrp)+'\'';  
        if (!activity.equals('All'))
          {
          
           if(activity.equalsIgnoreCase('Unqualified/Pipeline'))
           {
              soql += ' and (Activity__c =\'Pipeline\' OR  Activity__c =\'Unqualified\')';
           }
           else
           {
            soql += ' and Activity__c = \''+String.escapeSingleQuotes(activity)+'\'';
            }
          }
        if (!stage.equals('All'))
          soql += ' and Stage__c = \''+String.escapeSingleQuotes(stage)+'\'';
          //SOL 167 Start
          
          if (!solOppLead.equals('')&& solOppLead!=null) {
              soql += ' and Enterprise_Solution_Architect_New__c = \''+String.escapeSingleQuotes(solOppLead)+'\'';
          }
          
          //SOL 167 End
                if (listSelectInactive){
          soql += ' and LastModifiedDate < LAST_N_DAYS:30 ';
          listSelectInactive=false;
        }  
        system.debug('-------soql---soql------'+soql);
         // run the query again
        if(isStartOfSearch) {
            savedSoqlForSearchPagination = soql  + ' order by ' + sortField + ' ' + sortDir ;
            String[] soqlToCount = soql.split(' from ');
            totalRecsSearch = Database.countQuery('select count() from ' + soqlToCount[1]); 
            
        }
           opptysBeforeSorting = Database.query(soql  + ' order by ' + sortField + ' ' + sortDir + ' LIMIT '+ blockSizeSearch +' OFFSET '+ indexSearch );   
           opptysearched = opptysBeforeSorting ;
    //runQuery();
   } 
    return null;
  }
  
  
  
  public PageReference runQueriesForPagination() {
      opptysBeforeSorting = Database.query(savedSoqlForSearchPagination + ' LIMIT '+ blockSizeSearch +' OFFSET '+ indexSearch );   
      opptysearched = opptysBeforeSorting ;
      return null;
  }
 
  // use apex describe to build the picklist values
  public List<String> stages {
    get {
      if (stages== null){
 
        stages = new List<String>();
        Schema.DescribeFieldResult field = Opportunity_TGP__c.Stage__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
            { 
                 stages.add(f.getLabel());
            }
 
      }
      return stages;          
    }
    set;
  }
  
  // use apex describe to build the picklist values
  public List<String> activities {
    get {
      if (activities == null) {
 
        activities = new List<String>();
        Schema.DescribeFieldResult field = Opportunity_TGP__c.Activity__c.getDescribe();
      
        for (Schema.PicklistEntry f : field.getPicklistValues())
        {
            
                activities.add(f.getLabel());
           
        }
        activities.add(pipelineUnqualified);
        activities.sort();
      }
      return activities;          
    }
    set;
  }
  
  // use apex describe to build the picklist values
  public List<String> serviceGrpValues {
    get {
      if (serviceGrpValues == null) {
 
        serviceGrpValues = new List<String>();
        Schema.DescribeFieldResult field = Opportunity_TGP__c.Service_group__c.getDescribe();
      
        for (Schema.PicklistEntry f : field.getPicklistValues())
        {
            
                serviceGrpValues.add(f.getLabel());
           
        }
        //activities.add(pipelineUnqualified);
        serviceGrpValues.sort();
      }
      return serviceGrpValues;          
    }
    set;
  }
  
  
  // runs the search with parameters passed via Javascript
  public PageReference runListSearch() {
     
     String listViews = Apexpages.currentPage().getParameters().get('listViews');
     
     if(listViewSelected != 'All Deals' && listViewSelected != null){
     viewColRender = true;
     if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_APAC)){
         ApexPages.currentPage().getParameters().put('geoArea', 'APAC');
         ApexPages.currentPage().getParameters().put('activity', 'Pipeline');
         runSearchWrapper();
     }  
     else if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_EMEA)){
         ApexPages.currentPage().getParameters().put('geoArea', 'EMEA');
         ApexPages.currentPage().getParameters().put('activity', 'Pipeline');
         runSearchWrapper();
     }
     else if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_FA)){
         ApexPages.currentPage().getParameters().put('offeringName', 'Finance and Accounting');
         ApexPages.currentPage().getParameters().put('activity', 'Pipeline');
         runSearchWrapper();
     }
     else if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_LA)){
         ApexPages.currentPage().getParameters().put('geoArea', 'Latin America');
         ApexPages.currentPage().getParameters().put('activity', 'Pipeline');
         runSearchWrapper();
     }
     else if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_NA)){
         ApexPages.currentPage().getParameters().put('geoArea', 'North America');
         ApexPages.currentPage().getParameters().put('activity', 'Pipeline');
         runSearchWrapper();
     }
    
     else if(listViewSelected.equalsIgnoreCase(UTIL_Constants.THIRD_PARTY_VENDOR)){
        
     }
     else if(listViewSelected.equalsIgnoreCase(UTIL_Constants.BSS)){
         
     }
     else if(listViewSelected.equalsIgnoreCase('Inactive deals > 30 days')){
        listSelectInactive = true;
        runSearchWrapper(); 
     }
     }
     else{
         listSelectComplexCostArch = false;
         listSelectInactive = false;
         viewColRender = false;
         runSearchWrapper();
     }
    
    return null;
  }
   
   public List<SelectOption> getListViewsOptions() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('All Deals','All Deals'));
            options.add(new SelectOption(UTIL_Constants.ACT_DEAL_APAC,UTIL_Constants.ACT_DEAL_APAC));
            options.add(new SelectOption(UTIL_Constants.ACT_DEAL_EMEA,UTIL_Constants.ACT_DEAL_EMEA));
            options.add(new SelectOption(UTIL_Constants.ACT_DEAL_FA,UTIL_Constants.ACT_DEAL_FA));
            options.add(new SelectOption(UTIL_Constants.ACT_DEAL_LA,UTIL_Constants.ACT_DEAL_LA));
            options.add(new SelectOption(UTIL_Constants.ACT_DEAL_NA,UTIL_Constants.ACT_DEAL_NA));
            options.add(new SelectOption('Inactive deals > 30 days','Inactive deals > 30 days'));

            return options;
}

    public PageReference generateReport() {
        
            variable = true;   
        
        if(listViewSelected != null){
        variable = true;
        if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_APAC))
        {
            List<Deal_Radar_Reports_ID__c> lstIdForReport =[select id, report_id__c from Deal_Radar_Reports_ID__c where name=:'Active Deals'];
            if(lstIdForReport.size()>0)
            {
                testurl='/'+lstIdForReport[0].report_id__c+'?pv0=APAC&pv1=Pipeline&pv2=Unqualified';
                variable = true;
            }
        }     
        if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_EMEA))
        {
            List<Deal_Radar_Reports_ID__c> lstIdForReport =[select id, report_id__c from Deal_Radar_Reports_ID__c where name=:'Active Deals'];
            if(lstIdForReport.size()>0)
            {
                testurl='/'+lstIdForReport[0].report_id__c+'?pv0=EMEA&pv1=Pipeline&pv2=Unqualified';
            }
        }
        if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_LA))
         {
            List<Deal_Radar_Reports_ID__c> lstIdForReport =[select id, report_id__c from Deal_Radar_Reports_ID__c where name=:'Active Deals'];
            if(lstIdForReport.size()>0)
            {
                testurl='/'+lstIdForReport[0].report_id__c+'?pv0=Latin America&pv1=Pipeline&pv2=Unqualified';
            }
         }
        if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_NA))
         {
            List<Deal_Radar_Reports_ID__c> lstIdForReport =[select id, report_id__c from Deal_Radar_Reports_ID__c where name=:'Active Deals'];
            if(lstIdForReport.size()>0)
            {
                testurl='/'+lstIdForReport[0].report_id__c+'?pv0=North America&pv1=Pipeline&pv2=Unqualified';
            }
         }
        if(listViewSelected.equalsIgnoreCase(UTIL_Constants.ACT_DEAL_FA))
         {
            List<Deal_Radar_Reports_ID__c> lstIdForReport =[select id, report_id__c from Deal_Radar_Reports_ID__c where name=:UTIL_Constants.ACT_DEAL_FA];
            if(lstIdForReport.size()>0)
            {
                testurl='/'+lstIdForReport[0].report_id__c+'?pv0=Finance and Accounting&pv1=Pipeline&pv2=Unqualified';
            }
         }
        
        if(listViewSelected.equalsIgnoreCase(UTIL_Constants.THIRD_PARTY_VENDOR))
        {
            List<Deal_Radar_Reports_ID__c> lstIdForReport =[select id, report_id__c from Deal_Radar_Reports_ID__c where name=:'3rd Party Vendors'];
            if(lstIdForReport.size()>0)
            {
                testurl='/'+lstIdForReport[0].report_id__c;
            }
        }
        if(listViewSelected.equalsIgnoreCase('Inactive deals > 30 days'))
        {
            List<Deal_Radar_Reports_ID__c> lstIdForReport =[select id, report_id__c from Deal_Radar_Reports_ID__c where name=:'Inactive deals'];
            if(lstIdForReport.size()>0)
            {
                testurl='/'+lstIdForReport[0].report_id__c;
            }
        }
        if(listViewSelected.equalsIgnoreCase('All Deals'))
        {
            List<Deal_Radar_Reports_ID__c> lstIdForReport =[select id, report_id__c from Deal_Radar_Reports_ID__c where name=:'All Deals'];
            if(lstIdForReport.size()>0)
            {
                testurl='/'+lstIdForReport[0].report_id__c;
            }
        }
        }
        
        return null;
    }
    public void clearFilter()
     {
        soql = 'select Name,Offerings__c,service_group__c,Staffing_Status__c,Created_Date__c,Offering_Solution_Leads__c,Offering_Solution_Specialists__c,LastModifiedDate,CreatedDate,Risk_Level__c,SAP_OM_Opportunity__r.Name, Expected_contract_sign_qtr__c, Client_Name__r.Name, Client_Geo_Area__r.Name, Client_Geo_Unit__r.Name, Operating_Group__r.Name, Activity__c,Stage__c,Enterprise_Solution_Architect_New__c from Opportunity_TGP__c where Client_Name__c != null AND Name NOT IN(\'PTO\', \'Training\', \'Other Deal Support\', \'Other Unavailable\')';//order by Activity__c,Client_Name__r.Name,Name';
              IsSearchPage=False;
        runQuery();
     
     
     }
 
}