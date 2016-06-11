/*
@Author and Created Date : System ,  2/3/2015 1:37 AM
@name : VFC_Benchmark 
@Description : 
@Version : 
*/
public with sharing class VFC_Benchmark {
    public boolean isSearchVisible{get;set;}
    public boolean showError{get;set;}
    public boolean isAdvanceSearchVisible{get;set;}
    public String selectedClientName{get;set;}
    public String selectedOpportunity{get;set;}
    public String clientNameId;
    public String selectedGeoRegion{get;set;}
    public String selectedOperatingGroup{get;set;}
    public String selectedFteRange{get;set;} 
    public String selectedReportingStatus{get;set;}
    public String selectedDeliveryLocation{get;set;}
    public String selectedBPONetRevenueRange{get;set;}
    public String selectedMultiSingleOffering{get;set;}
    public String selectedNoOfLanguage{get;set;}
    public String selectedOffering{get;set;}    
    public String clientIdHidden {get;set;}
    public String clientIdHiddenValue{get;set;}
    public List<BenchMark__c> searchResultsList{get;set;}
    public List<BenchMark_Offerings__c> searchResultsListOffering{get;set;}
    public List<BenchMark__c> benchmarkListToExport{get;set;}
    public List<BenchMark_Offerings__c> benchmarkOfferingListToExport{get;set;}
    public List<averageBnechmarkRecordWrapper> BenchmarkRecordWrapperListToExport{get; set;}  
    public List<BenchMark_Service_Location__c> bnchServLocToExport{get;set;}  
    public BenchMark__c benchmarkRecord{get;set;}
    public BenchMark_Offerings__c benchmarkRecordoffering{get;set;}
    public OpportunityDataWrapperDisplay opportunityDataWrapperDisplay{get;set;} 
   
    public List<averageBnechmarkRecordWrapper> benchmarkRecordWrapperListToDisplay {get;set;}
    public List<averageBnechmarkRecordWrapper> averageBenchmarkRecordWrapperList{get; set;}
    public String soql = '';
    public Integer recordCount = 1;    
    public averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstanceRecord; 
    public averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstance; 
    public averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstance1;
    public averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstance2;
    public averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstance3;  
    public Boolean disableOffering{get;set;}  
    public List<BenchMark_Offerings__c> resultSet=null; 
    
    public SelectOption[] OffServiceArr{get;set;}
    public SelectOption[] OffBSSArr{get;set;}
    public SelectOption[] OffTechToolArr{get;set;}
    
    public SelectOption[] OffServiceArrSel{get;set;}
    public SelectOption[] OffBSSArrSel{get;set;}
    public SelectOption[] OffTechToolArrSel{get;set;}
    
    public String[] selServices;
    public String[] selBSS;
    public String[] selTechTools;
    
    public String bssString= UtilConstants.BSS;
    public String techString= UtilConstants.TECH;
    public String SDOString= UtilConstants.SDO ;
    public String YES= UtilConstants.YES;
    
    
    /* Pagination Code */
    private integer totalRecs = 0;     
    private integer index = 0;
    private integer blockSize = 7;
    private integer counter=0;  //keeps track of the offset
    private integer list_size=7; //sets the page size or number of rows
    public integer total_size;
    
    private boolean showAllRecords=false;
    public String whereClause = '';    
    public Map<id,decimal> OfferingCountMap {get; set;}
    
    public Boolean disabSerSearchFlds{get;set;}
     
    /******************************
    Constructor Name: VFC_Benchmark
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public VFC_Benchmark() {
        benchmarkRecord = new BenchMark__c();
        isSearchVisible = false;
        isAdvanceSearchVisible = true;
        
        OffServiceArr=new List<SelectOption>(); 
        OffBSSArr=new List<SelectOption>();
        OffTechToolArr=new List<SelectOption>();
        
        OffServiceArrSel=new List<SelectOption>(); 
        OffBSSArrSel=new List<SelectOption>();
        OffTechToolArrSel=new List<SelectOption>();
        
        
        searchOffering();
        disabSerSearchFlds=true;
        //showAllRecords=false;
    }
    
    /******************************
    Method Name: All PAgination Methods
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      runQuery();
      return null;
    }
     
    /******************************
    Method Name: Previous
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      runQuery();
      return null;
    }
    /******************************
    Method Name: Next
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public PageReference Next() { //user clicked next button
      counter += list_size;
      runQuery();
      return null;
    }
    /******************************
    Method Name: End
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      runQuery();
      return null;
    }
    /******************************
    Method Name: getDisablePrevious
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Boolean getDisablePrevious() { 
        //this will disable the previous and beginning buttons
        if (counter>0){ 
          return false;
        }else{ 
          return true;
        }
    }
    /******************************
    Method Name: getDisableNext
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Boolean getDisableNext() { 
        //this will disable the next and end buttons
        if (counter + list_size < total_size){ 
            return false; 
        }else{ 
            return true;
        }
    }
    /******************************
    Method Name: getTotal_size
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Integer getTotal_size() {
      return total_size;
    }
    /******************************
    Method Name: getPageNumber
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Integer getPageNumber() {
      return counter/list_size + 1;
    }
    /******************************
    Method Name: getTotalPages
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
    }
    /******************************
    Inner Class  Name: OpportunityDataWrapperDisplay
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    /* ------------------------------------------------------------------- -- */
    public class OpportunityDataWrapperDisplay{
          public String clientGeoAreaName{get;set;}
          public String OperatingGroupName{get;set;}
          public String reportingStatus{get;set;}
          public String BPONetRevenue{get;set;}
          public String MultipleSingleOffering{get;set;}
          public String Offerings{get;set;}
          public String FTE{get;set;}
          public String DeliveryLocation{get;set;}
          public String Languages{get;set;}
    }   
    /******************************
    Inner Class  Name: averageBnechmarkRecordWrapper
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    /* ------------------------------------------------------------------- -- */
    public class averageBnechmarkRecordWrapper{
        public Id clientNameId{get;set;}
        public Id opportunityId{get;set;}
        public Id OSLId{get;set;}
        public String clientName{get;set;}
        public String opportunityName{get;set;}
        public String OSLName{get;set;}
        public String Name{get;set;}
        public String clientGeoArea{get;set;}
        public String operatingGroup{get;set;}
        public String Activity{get;set;}
        public String pricingType{get;set;} 
        public Decimal TCV{get;set;}
        public Decimal MobContigency{get;set;}
        public Decimal avgRunContigency{get;set;}
        public Decimal transCostContigency{get;set;}        
        public Decimal ciPercentage{get;set;}
        public Decimal contractDurationMob{get;set;}
        public Decimal contractDuration{get;set;} 
        public Decimal NoOfLocation{get;set;}
        public Decimal totalBaselineSDOFTEs{get;set;}
        public Decimal onshoreNearshoreBaselineSDOFTE{get;set;}
        public Decimal offshoreBaselineSDOFTE{get;set;}
        public Decimal TotalCostWithoutContingency{get;set;}
        public Decimal sdoTotalCost{get;set;}
        public Decimal averageTotalPayrollCostsFTE{get;set;}
        public Decimal averageTotalPayrollCostsOffshoreFTE{get;set;}
        public Decimal averageTotalPayrollCostsOnshoreNearshoreFTE{get;set;}
        public Decimal pyramidRichnessYear1{get;set;}
        public Decimal overallProductivityImprovementPercentage{get;set;}
        public String InScopeOfferings{get;set;}
        public String offLevelData{get;set;}
        public String LanguagesInScope{get;set;}           
        public Decimal TotalTechToolCost{get;set;}
        public Decimal TotalVDCost{get;set;}
        public Decimal TotalMOBCost{get;set;}
        public Decimal TotalSerManagCost{get;set;}
        public Decimal TotalSupCentreCost{get;set;}
        public Decimal TotalEDMCost{get;set;}
        public Decimal TotalComCentreCost{get;set;}
        public Decimal TotalQADMCost{get;set;}
        public Decimal TotalCFMCost{get;set;}
        public Decimal TotalCMCost{get;set;}
        public Decimal TotalQADCost{get;set;}
        public Decimal baselineFTEPrimaryOffering{get;set;}
        public Decimal baselineFTEPrimaryOfferingOnNearshore{get;set;}
        public Decimal baselineFTEPrimaryOfferingOffshore{get;set;}
        public Decimal noOfRebadgedResources{get;set;} 
        public String inScopeService{get;set;}
    }
    
    /******************************
    Method Name: getFirstBunchOfClientNames
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getFirstBunchOfClientNames() {
        List<selectOption> clientNameOptions = new List<selectOption>();
        Set<Id> idsSet = new Set<Id>();
        clientNameOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG));
        for(BenchMark__c  opportunityBenchmarkData: [SELECT Client__c, Client__r.Name FROM BenchMark__c where Service_Group__C = : UtilConstants.BPO AND Client__c != null ORDER BY Client__r.Name ASC LIMIT 1000 ]) {
            if(!idsSet.contains(opportunityBenchmarkData.Client__c)) {
                clientNameOptions.add(new SelectOption(opportunityBenchmarkData.Client__c,opportunityBenchmarkData.Client__r.Name));
                idsSet.add(opportunityBenchmarkData.Client__c);
            }
        }
        return clientNameOptions;
     }
    
    
    /******************************
    Method Name: searchOpportunities
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void searchOpportunities() {
       //clientNameId = Apexpages.currentPage().getParameters().get('clientLookupId');
       //showAllRecords=true; 
    }
     /******************************
    Method Name: searchOffering
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void searchOffering(){
        //system.debug('selectedOffering---'+selectedOffering);
        OffServiceArr=new List<SelectOption>(); 
        OffBSSArr=new List<SelectOption>();
        OffTechToolArr=new List<SelectOption>();
        
        for(Services_Master__c itrObj:[select Name from Services_Master__c where Solution_Component__c=:UtilConstants.BSS order by Name]){
            if(itrObj.name!=null){
                if(itrObj.name.trim()!=''){
                    OffBSSArr.add(new selectOption(itrObj.name,itrObj.name));
                }
            }
        }
        List<String> soqlOffArr=new List<String>();
        soqlOffArr.add(UtilConstants.All);
        soqlOffArr.add(selectedOffering); 
        for(Tech_Tool_Master__c itrObj:[select Name from Tech_Tool_Master__c where services__r.offering__r.name=:soqlOffArr  and services__r.Solution_Component__c=:UtilConstants.TECH order by Name]){
            if(itrObj.name!=null){
                if(itrObj.name.trim()!=''){
                    OffTechToolArr.add(new selectOption(itrObj.name,itrObj.name));
                }
            }
        }
        
        OffServiceArrSel=new List<SelectOption>(); 
        OffBSSArrSel=new List<SelectOption>();
        OffTechToolArrSel=new List<SelectOption>();
        
        if(selectedOffering ==UtilConstants.MSG_1219 || selectedOffering ==UtilConstants.NONE_NEW){
            disabSerSearchFlds=true;
        }else{
            disabSerSearchFlds=false;
            for(Services_Master__c itrObj:[select Name from Services_Master__c where Offering__r.name=:soqlOffArr and Solution_Component__c=:UtilConstants.SOLCOMP_DELIVERY order by Name]){
              if(itrObj.name!=null){
                  String tempService = itrObj.name;
                  if(tempService.trim()!=''){
                      OffServiceArr.add(new selectOption(tempService,tempService));
                  }
               }
            }    
            
            //OffTechToolArr.add(new selectOption('Tool1','Tool1'));
            //OffTechToolArr.add(new selectOption('Tool2','Tool2'));
        }
    }
    
    /******************************
    Method Name: resetPage
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public pagereference resetPage() {
       return new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + UtilConstants.VFP_BENCHMARK_URL); 
    }
    
    /******************************
    Method Name: getListOfOpportunities
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfOpportunities() {        
        List<selectOption> opportunityNameOptions = new List<selectOption>();
        OfferingCountMap = new Map<id,decimal>();
        opportunityNameOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG));
        for(BenchMark__c  opportunityBenchmarkData: [SELECT Opportunity__c, Opportunity__r.Name,of_offerings_in_scope__c FROM BenchMark__c where Service_Group__c = :UtilConstants.BPO AND Client__c =: clientIdHiddenValue ORDER BY Opportunity__r.Name ASC LIMIT 1000 ]) {
            opportunityNameOptions.add(new SelectOption(opportunityBenchmarkData.Opportunity__c,opportunityBenchmarkData.Opportunity__r.Name));
            OfferingCountMap.put(opportunityBenchmarkData.Opportunity__c,opportunityBenchmarkData.of_offerings_in_scope__c);
        }  
        return opportunityNameOptions; 
    }
    
    /******************************
    Method Name: searchResults
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void searchResults() {
        showError = false;
        showAllRecords=true;
        try{
            if(selectedClientName ==UtilConstants.MSG_1219){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please select client and opportunity!');
                ApexPages.addMessage(myMsg);
                showError = true;
            }
            else if(selectedOpportunity == UtilConstants.MSG_1219){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please select opportunity!');
                    ApexPages.addMessage(myMsg);
                    showError = true;
            }
            if(selectedOpportunity == UtilConstants.MSG_1219  || selectedClientName ==UtilConstants.MSG_1219) {
                benchmarkRecordWrapperListToDisplay = new List<averageBnechmarkRecordWrapper>();
                benchmarkRecord = new BenchMark__c();    
                selectedGeoRegion = UtilConstants.MSG_1219;
                selectedOperatingGroup = UtilConstants.MSG_1219;
                selectedFteRange = UtilConstants.MSG_1219;
                selectedReportingStatus = UtilConstants.MSG_1219;
                selectedDeliveryLocation = UtilConstants.MSG_1219;
                selectedBPONetRevenueRange = UtilConstants.MSG_1219;
                selectedMultiSingleOffering = UtilConstants.MSG_1219;
                selectedNoOfLanguage = UtilConstants.MSG_1219;
                selectedOffering = UtilConstants.MSG_1219;  
                isAdvanceSearchVisible = true;
                isSearchVisible = false;   
            } 
            else {
                isAdvanceSearchVisible = true;
                isSearchVisible = true;
            }      
            
            List<BenchMark__c> opportuintyRecord = new  List<BenchMark__c>(); 
            List<BenchMark_Offerings__c> BenchofferingRecord = new  List<BenchMark_Offerings__c>(); 
            
            if(selectedOpportunity!=UtilConstants.MSG_1219){
                if(OfferingCountMap.containsKey(selectedOpportunity)){
                    decimal countofoffering = OfferingCountMap.get(selectedOpportunity);
                    //system.debug('countofoffering'+countofoffering);
                    if(countofoffering==1){
                        //system.debug('To Show Offering Data');
                        populateOfferingDataOnLoad();
                    }else{
                        //system.debug('To Show Opportunity Data');
                        populateOpportunityDataOnLoad();
                    }
                }
                searchAdvanceResult();
            }
         }
         catch(Exception exp) {
             //system.debug('Samasya'+exp);
             //Need to Check Later
             //UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, 'VFC_Benchmark', 'searchResults Method', 'VFC_Benchmark', System.Logginglevel.ERROR);
         }      
    }
    
    /******************************
    Method Name: getListOfGeoRegion
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/    
    public List<selectOption> getListOfGeoRegion() {
        List<selectOption> GeoRegionOptions = new List<selectOption>();
        GeoRegionOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG));
        for(Geo_Region_Range_List__c itrObj:[select GeoRegionList__c from Geo_Region_Range_List__c order by OrderNumber__c Limit 5000]){
        
            GeoRegionOptions.add(new SelectOption(itrObj.GeoRegionList__c, itrObj.GeoRegionList__c));
        }
        return GeoRegionOptions; 
    }
    
    /******************************
    Method Name: getListOfOffering
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfOffering() {
        List<selectOption> offeringOptions = new List<selectOption>();
        //offeringOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG));
        offeringOptions.add(new SelectOption(UtilConstants.NONE_NEW , UtilConstants.ALL));
        //In below Query UtilConstants.ALL is replaced for 'all' , If case sensitive please revert 
        for(Offering_Master__c offering: [Select Name, Id from Offering_Master__c where Name!=:UtilConstants.ALL and Service_Group__c=:UtilConstants.BPO order by Name limit 100]) {
            offeringOptions.add(new selectOption(offering.Name, offering.Name));
        }
        return offeringOptions ; 
    }
    
    /******************************
    Method Name: getListOfOperatingGroup
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfOperatingGroup() {
        List<selectOption> operatingGroupOptions = new List<selectOption>();
        operatingGroupOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG ));
        for(Operating_Groups_Master__c operatingGroup : [Select Name, Id from Operating_Groups_Master__c  order by Name limit 100]) {
            operatingGroupOptions.add(new selectOption(operatingGroup.Id, operatingGroup.Name));
        }         
        return operatingGroupOptions ; 
    }
    
    /******************************
    Method Name: getListOfFTERange
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
     public List<selectOption> getListOfFTERange() {
        List<selectOption> fteRangeOptions = new List<selectOption>();        
        fteRangeOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG ));
        List<FTE_Range_List__c> FTEList=new List<FTE_Range_List__c>();
        FTEList=[select FTEList__c from FTE_Range_List__c order by OrderNumber__c];
        for(FTE_Range_List__c itrObj:FTEList){
            fteRangeOptions.add(new SelectOption(itrObj.FTEList__c, itrObj.FTEList__c));
        }
        
        return fteRangeOptions ;
    }
    
    /******************************
    Method Name: getListOfReportingStatus
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfReportingStatus() {
        List<selectOption> reportingStatusOptions = new List<selectOption>();
        reportingStatusOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG ));
        for(Reporting_Status_Range_List__c itrObj:[select ReportingStatusList__c from Reporting_Status_Range_List__c order by OrderNumber__c Limit 5000]){
        
            reportingStatusOptions.add(new SelectOption(itrObj.ReportingStatusList__c, itrObj.ReportingStatusList__c));
        }
        return reportingStatusOptions; 
    }
    
    /******************************
    Method Name: getListOfDeliveryLocation
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfDeliveryLocation() {        
        List<selectOption> deliveryLocationOptions = new List<selectOption>();
        deliveryLocationOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG ));
        List<Location_Def_List__c> LocationDefList=new List<Location_Def_List__c>();
        LocationDefList=[select LocationDefList__c from Location_Def_List__c order by OrderNumber__c];
        for(Location_Def_List__c itrObj:LocationDefList){
            deliveryLocationOptions.add(new SelectOption(itrObj.LocationDefList__c, itrObj.LocationDefList__c));
        }
        return deliveryLocationOptions ; 
    }
    
    /******************************
    Method Name: getListOfMultiSingleOffering
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfMultiSingleOffering() {
        List<selectOption> multiSingleOfferingOptions = new List<selectOption>();
        multiSingleOfferingOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG ));
        Schema.DescribeFieldResult multiSingleOffering = BenchMark__c.Multi_Single_Offering__c.getDescribe();
        List<Schema.PicklistEntry> multiSingleOfferingValues = multiSingleOffering.getPicklistValues();
        for (Schema.PicklistEntry a : multiSingleOfferingValues) { 
            multiSingleOfferingOptions.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return multiSingleOfferingOptions; 
    }
    
    /******************************
    Method Name: getListOfBPONetRevenueRange
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfBPONetRevenueRange() {        
        List<selectOption> bpoNetRevenueRangeOptions = new List<selectOption>();
        bpoNetRevenueRangeOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG));
        

        
        for(BPO_Net_Revenue_Range_List__c itrObj:[select BPONetRevnueList__c from BPO_Net_Revenue_Range_List__c order by OrderNumber__c]){
        
            bpoNetRevenueRangeOptions.add(new SelectOption(itrObj.BPONetRevnueList__c, itrObj.BPONetRevnueList__c));
        }
        return bpoNetRevenueRangeOptions; 
    }
    
    /******************************
    Method Name: getListOfNoOfLanguages
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfNoOfLanguages() {        
        List<selectOption> noOfLanguageeOptions = new List<selectOption>();
        noOfLanguageeOptions.add(new SelectOption(UtilConstants.MSG_1219, UtilConstants.NONE_MSG));
        
        List<Count_Of_Lang_Range_List__c> langList=new List<Count_Of_Lang_Range_List__c>();
        
        langList=[select CntOfLangList__c from Count_Of_Lang_Range_List__c order by OrderNumber__c];
        
        for(Count_Of_Lang_Range_List__c itrObj:langList){
        
            noOfLanguageeOptions .add(new SelectOption(itrObj.CntOfLangList__c, itrObj.CntOfLangList__c));
        }
        return noOfLanguageeOptions; 
    }
    
    /******************************
    Method Name: searchAdvanceResult
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void searchAdvanceResult() { 
        system.debug('Opportunity = '+selectedOpportunity +'   Option=  '+UtilConstants.NONE_MSG);
        if(selectedOpportunity!=UtilConstants.MSG_1219){
            if(OfferingCountMap.containsKey(selectedOpportunity)){
                decimal countofoffering = OfferingCountMap.get(selectedOpportunity);
                if(countofoffering>0){
                    if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW)){
                        //system.debug('populateOfferingQuery');
                        populateOfferingQuery();
                    }
                }
            }
        }
        prepareQuery();
        runQuery();
    }
    
    /******************************
    Method Name: prepareQuery
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    private void prepareQuery() {
       try{
            counter=0;
            soql = '';
            whereClause = '';
            benchmarkListToExport = new List<BenchMark__c>();
            benchmarkOfferingListToExport = new List<BenchMark_Offerings__c>();
            
            if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW)){
                soql=offeringLevelQuery();
                system.debug('Offering Level Query :::'+soql);
                benchmarkOfferingListToExport  = Database.Query(soql);
                system.debug('benchmarkOfferingListToExport:::'+benchmarkOfferingListToExport);
            }else{
                soql=opportunityLevelQuery();
                benchmarkListToExport  = Database.Query(soql);
            }
            
            String[] soqlToCount = soql.split(' from ');
            if(benchmarkOfferingListToExport.size()!=0){
                total_size=benchmarkOfferingListToExport.size();
            }else{
                total_size=benchmarkListToExport.size();
            }
                 
            averageBenchmarkRecordWrapperList = new List<averageBnechmarkRecordWrapper>();        
            averagebenchmarkRecordWrapperInstance1 =  new averageBnechmarkRecordWrapper(); 
            
            if(selectedOpportunity!=UtilConstants.MSG_1219){
                if(OfferingCountMap.containsKey(selectedOpportunity)){
                    decimal countofoffering = OfferingCountMap.get(selectedOpportunity);
                    if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW) && countofoffering>0){
                        //system.debug('MapOfferingData');
                        
                        averagebenchmarkRecordWrapperInstance1= MapOfferingData(averagebenchmarkRecordWrapperInstance1,benchmarkRecordoffering,UtilConstants.YourDeal);
                    }else{
                        if(countofoffering==1){
                            //system.debug('MapOfferingData');
                            averagebenchmarkRecordWrapperInstance1= MapOfferingData(averagebenchmarkRecordWrapperInstance1,benchmarkRecordoffering,UtilConstants.YourDeal);
                        }else{
                            //system.debug('MapOpportunityData');
                            averagebenchmarkRecordWrapperInstance1= MapOpportunityData(averagebenchmarkRecordWrapperInstance1,benchmarkRecord, UtilConstants.YourDeal);
                        }
                    }
                }
                averageBenchmarkRecordWrapperList.add(averagebenchmarkRecordWrapperInstance1); 
            }
            Decimal defaultVal=0.0;
            
            averagebenchmarkRecordWrapperInstance2 =  new averageBnechmarkRecordWrapper(); 
            averagebenchmarkRecordWrapperInstance2.Name = UtilConstants.Average;
            
            List<averageBnechmarkRecordWrapper> BenchmarkRecordWrapperListWithDealandCompareDealAll = new List<averageBnechmarkRecordWrapper>();
            BenchmarkRecordWrapperListWithDealandCompareDealAll.addall(averageBenchmarkRecordWrapperList);
            
            List<averageBnechmarkRecordWrapper> BenchmarkRecordWrapperListWithCompareDealAll = new List<averageBnechmarkRecordWrapper>();
            
            BenchmarkRecordWrapperListToExport = new List<averageBnechmarkRecordWrapper>();
            
            if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW)){
                for(BenchMark_Offerings__c benchmarkReportrecordOffering: benchmarkOfferingListToExport) {
                    averagebenchmarkRecordWrapperInstance =  new averageBnechmarkRecordWrapper();
                    averagebenchmarkRecordWrapperInstance= MapOfferingData(averagebenchmarkRecordWrapperInstance,benchmarkReportrecordOffering, UtilConstants.ComparisonDeal + recordCount);
                    BenchmarkRecordWrapperListWithDealandCompareDealAll.add(averagebenchmarkRecordWrapperInstance);
                    BenchmarkRecordWrapperListWithCompareDealAll.add(averagebenchmarkRecordWrapperInstance);
                    recordCount = recordCount +1;
                }
            }else{
                for(BenchMark__c benchmarkReportrecord: benchmarkListToExport ) {
                    averagebenchmarkRecordWrapperInstance =  new averageBnechmarkRecordWrapper();
                    averagebenchmarkRecordWrapperInstance= MapOpportunityData(averagebenchmarkRecordWrapperInstance,benchmarkReportrecord, UtilConstants.ComparisonDeal + recordCount);
                    BenchmarkRecordWrapperListWithDealandCompareDealAll.add(averagebenchmarkRecordWrapperInstance);
                    BenchmarkRecordWrapperListWithCompareDealAll.add(averagebenchmarkRecordWrapperInstance);
                    recordCount = recordCount +1;
               } 
            }
            recordCount = 1;
            
            //Recalculate Avarage
            if(BenchmarkRecordWrapperListWithCompareDealAll.size()>0){
                if(showAllRecords){
                    averagebenchmarkRecordWrapperInstance2=populateAvgOffBenchData(BenchmarkRecordWrapperListWithDealandCompareDealAll,averagebenchmarkRecordWrapperInstance2);
                }else{
                    averagebenchmarkRecordWrapperInstance2=populateAvgOffBenchData(BenchmarkRecordWrapperListWithCompareDealAll,averagebenchmarkRecordWrapperInstance2);
                }
            }
            
            //Calculate Your Deal Compare to Avarage
            if(selectedOpportunity!=UtilConstants.MSG_1219){
                averagebenchmarkRecordWrapperInstance3 =  new averageBnechmarkRecordWrapper();        
                averagebenchmarkRecordWrapperInstance3.Name = UtilConstants.UrDealComToAvg ;  
                if(averagebenchmarkRecordWrapperInstance1.TCV != null && averagebenchmarkRecordWrapperInstance2.TCV != null && Math.round(averagebenchmarkRecordWrapperInstance2.TCV) != 0)
                    averagebenchmarkRecordWrapperInstance3.TCV = (((averagebenchmarkRecordWrapperInstance1.TCV - averagebenchmarkRecordWrapperInstance2.TCV)/averagebenchmarkRecordWrapperInstance2.TCV)*100).SetScale(2);          
                if(averagebenchmarkRecordWrapperInstance1.MobContigency != null && averagebenchmarkRecordWrapperInstance2.MobContigency != null && averagebenchmarkRecordWrapperInstance2.MobContigency != 0)
                    averagebenchmarkRecordWrapperInstance3.MobContigency = (((averagebenchmarkRecordWrapperInstance1.MobContigency - averagebenchmarkRecordWrapperInstance2.MobContigency )/averagebenchmarkRecordWrapperInstance2.MobContigency )*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.avgRunContigency != null && averagebenchmarkRecordWrapperInstance2.avgRunContigency != null  && averagebenchmarkRecordWrapperInstance2.avgRunContigency != 0)
                    averagebenchmarkRecordWrapperInstance3.avgRunContigency = (((averagebenchmarkRecordWrapperInstance1.avgRunContigency - averagebenchmarkRecordWrapperInstance2.avgRunContigency )/averagebenchmarkRecordWrapperInstance2.avgRunContigency )*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.transCostContigency != null && averagebenchmarkRecordWrapperInstance2.transCostContigency != null && averagebenchmarkRecordWrapperInstance2.transCostContigency != 0)
                    averagebenchmarkRecordWrapperInstance3.transCostContigency = (((averagebenchmarkRecordWrapperInstance1.transCostContigency - averagebenchmarkRecordWrapperInstance2.transCostContigency )/averagebenchmarkRecordWrapperInstance2.transCostContigency )*100).SetScale(2) ;       
                if(averagebenchmarkRecordWrapperInstance1.contractDurationMob != null && averagebenchmarkRecordWrapperInstance2.contractDurationMob != null && averagebenchmarkRecordWrapperInstance2.contractDurationMob != 0)
                    averagebenchmarkRecordWrapperInstance3.contractDurationMob = (((averagebenchmarkRecordWrapperInstance1.contractDurationMob - averagebenchmarkRecordWrapperInstance2.contractDurationMob )/averagebenchmarkRecordWrapperInstance2.contractDurationMob )*100).SetScale(2) ;   
                if(averagebenchmarkRecordWrapperInstance1.ciPercentage != null && averagebenchmarkRecordWrapperInstance2.ciPercentage != null && averagebenchmarkRecordWrapperInstance2.ciPercentage != 0)
                    averagebenchmarkRecordWrapperInstance3.ciPercentage = (((averagebenchmarkRecordWrapperInstance1.ciPercentage - averagebenchmarkRecordWrapperInstance2.ciPercentage)/averagebenchmarkRecordWrapperInstance2.ciPercentage)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.contractDuration != null && averagebenchmarkRecordWrapperInstance2.contractDuration != null && averagebenchmarkRecordWrapperInstance2.contractDuration != 0)
                    averagebenchmarkRecordWrapperInstance3.contractDuration = (((averagebenchmarkRecordWrapperInstance1.contractDuration - averagebenchmarkRecordWrapperInstance2.contractDuration)/averagebenchmarkRecordWrapperInstance2.contractDuration)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.NoOfLocation != null && averagebenchmarkRecordWrapperInstance2.NoOfLocation != null && averagebenchmarkRecordWrapperInstance2.NoOfLocation != 0)
                    averagebenchmarkRecordWrapperInstance3.NoOfLocation = (((averagebenchmarkRecordWrapperInstance1.NoOfLocation - averagebenchmarkRecordWrapperInstance2.NoOfLocation )/averagebenchmarkRecordWrapperInstance2.NoOfLocation )*100).SetScale(2) ;    
                if(averagebenchmarkRecordWrapperInstance1.totalBaselineSDOFTEs != null && averagebenchmarkRecordWrapperInstance2.totalBaselineSDOFTEs != null && averagebenchmarkRecordWrapperInstance2.totalBaselineSDOFTEs != 0)
                    averagebenchmarkRecordWrapperInstance3.totalBaselineSDOFTEs = (((averagebenchmarkRecordWrapperInstance1.totalBaselineSDOFTEs - averagebenchmarkRecordWrapperInstance2.totalBaselineSDOFTEs)/averagebenchmarkRecordWrapperInstance2.totalBaselineSDOFTEs)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.onshoreNearshoreBaselineSDOFTE != null && averagebenchmarkRecordWrapperInstance2.onshoreNearshoreBaselineSDOFTE != null && averagebenchmarkRecordWrapperInstance2.onshoreNearshoreBaselineSDOFTE != 0)
                    averagebenchmarkRecordWrapperInstance3.onshoreNearshoreBaselineSDOFTE = (((averagebenchmarkRecordWrapperInstance1.onshoreNearshoreBaselineSDOFTE - averagebenchmarkRecordWrapperInstance2.onshoreNearshoreBaselineSDOFTE )/averagebenchmarkRecordWrapperInstance2.onshoreNearshoreBaselineSDOFTE )*100).SetScale(2) ;                
                if(averagebenchmarkRecordWrapperInstance1.offshoreBaselineSDOFTE != null && averagebenchmarkRecordWrapperInstance2.offshoreBaselineSDOFTE != null && averagebenchmarkRecordWrapperInstance2.offshoreBaselineSDOFTE != 0)
                    averagebenchmarkRecordWrapperInstance3.offshoreBaselineSDOFTE = (((averagebenchmarkRecordWrapperInstance1.offshoreBaselineSDOFTE - averagebenchmarkRecordWrapperInstance2.offshoreBaselineSDOFTE )/averagebenchmarkRecordWrapperInstance2.offshoreBaselineSDOFTE )*100).SetScale(2) ;                                
                if(averagebenchmarkRecordWrapperInstance1.TotalCostWithoutContingency != null && averagebenchmarkRecordWrapperInstance2.TotalCostWithoutContingency != null && averagebenchmarkRecordWrapperInstance2.TotalCostWithoutContingency != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalCostWithoutContingency = (((averagebenchmarkRecordWrapperInstance1.TotalCostWithoutContingency - averagebenchmarkRecordWrapperInstance2.TotalCostWithoutContingency)/averagebenchmarkRecordWrapperInstance2.TotalCostWithoutContingency)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.sdoTotalCost != null && averagebenchmarkRecordWrapperInstance2.sdoTotalCost != null && averagebenchmarkRecordWrapperInstance2.sdoTotalCost != 0)
                    averagebenchmarkRecordWrapperInstance3.sdoTotalCost = (((averagebenchmarkRecordWrapperInstance1.sdoTotalCost - averagebenchmarkRecordWrapperInstance2.sdoTotalCost )/averagebenchmarkRecordWrapperInstance2.sdoTotalCost )*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsFTE != null && averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsFTE != null && averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsFTE != 0)
                    averagebenchmarkRecordWrapperInstance3.averageTotalPayrollCostsFTE = (((averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsFTE - averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsFTE)/averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsFTE)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOffshoreFTE != null && averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsOffshoreFTE != null && averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsOffshoreFTE != 0)
                    averagebenchmarkRecordWrapperInstance3.averageTotalPayrollCostsOffshoreFTE = (((averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOffshoreFTE - averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsOffshoreFTE )/averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsOffshoreFTE )*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOnshoreNearshoreFTE != null && averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsOnshoreNearshoreFTE != null && averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsOnshoreNearshoreFTE != 0)
                    averagebenchmarkRecordWrapperInstance3.averageTotalPayrollCostsOnshoreNearshoreFTE = (((averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOnshoreNearshoreFTE - averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsOnshoreNearshoreFTE )/averagebenchmarkRecordWrapperInstance2.averageTotalPayrollCostsOnshoreNearshoreFTE )*100).SetScale(2) ;                
                if(averagebenchmarkRecordWrapperInstance1.pyramidRichnessYear1 != null && averagebenchmarkRecordWrapperInstance2.pyramidRichnessYear1 != null && averagebenchmarkRecordWrapperInstance2.pyramidRichnessYear1 != 0)
                    averagebenchmarkRecordWrapperInstance3.pyramidRichnessYear1 = (((averagebenchmarkRecordWrapperInstance1.pyramidRichnessYear1 - averagebenchmarkRecordWrapperInstance2.pyramidRichnessYear1)/averagebenchmarkRecordWrapperInstance2.pyramidRichnessYear1)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.overallProductivityImprovementPercentage != null && averagebenchmarkRecordWrapperInstance2.overallProductivityImprovementPercentage != null && averagebenchmarkRecordWrapperInstance2.overallProductivityImprovementPercentage != 0)
                    averagebenchmarkRecordWrapperInstance3.overallProductivityImprovementPercentage = (((averagebenchmarkRecordWrapperInstance1.overallProductivityImprovementPercentage - averagebenchmarkRecordWrapperInstance2.overallProductivityImprovementPercentage)/averagebenchmarkRecordWrapperInstance2.overallProductivityImprovementPercentage)*100).SetScale(2) ;                
                if(averagebenchmarkRecordWrapperInstance1.TotalTechToolCost != null && averagebenchmarkRecordWrapperInstance2.TotalTechToolCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalTechToolCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalTechToolCost = (((averagebenchmarkRecordWrapperInstance1.TotalTechToolCost - averagebenchmarkRecordWrapperInstance2.TotalTechToolCost)/averagebenchmarkRecordWrapperInstance2.TotalTechToolCost)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.TotalVDCost!= null && averagebenchmarkRecordWrapperInstance2.TotalVDCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalVDCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalVDCost= (((averagebenchmarkRecordWrapperInstance1.TotalVDCost - averagebenchmarkRecordWrapperInstance2.TotalVDCost)/averagebenchmarkRecordWrapperInstance2.TotalVDCost)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.TotalMOBCost != null && averagebenchmarkRecordWrapperInstance2.TotalMOBCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalMOBCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalMOBCost = (((averagebenchmarkRecordWrapperInstance1.TotalMOBCost - averagebenchmarkRecordWrapperInstance2.TotalMOBCost)/averagebenchmarkRecordWrapperInstance2.TotalMOBCost)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.TotalSerManagCost!= null && averagebenchmarkRecordWrapperInstance2.TotalSerManagCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalSerManagCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalSerManagCost= (((averagebenchmarkRecordWrapperInstance1.TotalSerManagCost - averagebenchmarkRecordWrapperInstance2.TotalSerManagCost)/averagebenchmarkRecordWrapperInstance2.TotalSerManagCost)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.TotalSupCentreCost != null && averagebenchmarkRecordWrapperInstance2.TotalSupCentreCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalSupCentreCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalSupCentreCost = (((averagebenchmarkRecordWrapperInstance1.TotalSupCentreCost - averagebenchmarkRecordWrapperInstance2.TotalSupCentreCost)/averagebenchmarkRecordWrapperInstance2.TotalSupCentreCost)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.TotalEDMCost != null && averagebenchmarkRecordWrapperInstance2.TotalEDMCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalEDMCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalEDMCost = (((averagebenchmarkRecordWrapperInstance1.TotalEDMCost - averagebenchmarkRecordWrapperInstance2.TotalEDMCost)/averagebenchmarkRecordWrapperInstance2.TotalEDMCost)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.TotalComCentreCost != null && averagebenchmarkRecordWrapperInstance2.TotalComCentreCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalComCentreCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalComCentreCost = (((averagebenchmarkRecordWrapperInstance1.TotalComCentreCost - averagebenchmarkRecordWrapperInstance2.TotalComCentreCost)/averagebenchmarkRecordWrapperInstance2.TotalComCentreCost)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.TotalQADMCost != null && averagebenchmarkRecordWrapperInstance2.TotalQADMCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalQADMCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalQADMCost = (((averagebenchmarkRecordWrapperInstance1.TotalQADMCost - averagebenchmarkRecordWrapperInstance2.TotalQADMCost)/averagebenchmarkRecordWrapperInstance2.TotalQADMCost)*100).SetScale(2) ;
                if(averagebenchmarkRecordWrapperInstance1.TotalCFMCost != null && averagebenchmarkRecordWrapperInstance2.TotalCFMCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalCFMCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalCFMCost = (((averagebenchmarkRecordWrapperInstance1.TotalCFMCost - averagebenchmarkRecordWrapperInstance2.TotalCFMCost)/averagebenchmarkRecordWrapperInstance2.TotalCFMCost)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.TotalCMCost != null && averagebenchmarkRecordWrapperInstance2.TotalCMCost != null && Math.round(averagebenchmarkRecordWrapperInstance2.TotalCMCost) != 0)
                    averagebenchmarkRecordWrapperInstance3.TotalCMCost = (((averagebenchmarkRecordWrapperInstance1.TotalCMCost - averagebenchmarkRecordWrapperInstance2.TotalCMCost)/averagebenchmarkRecordWrapperInstance2.TotalCMCost)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.TotalQADCost != null && averagebenchmarkRecordWrapperInstance2.TotalQADCost!= null  && Math.round(averagebenchmarkRecordWrapperInstance2.TotalQADCost)!= 0)
                    averagebenchmarkRecordWrapperInstance3.TotalQADCost = (((averagebenchmarkRecordWrapperInstance1.TotalQADCost- averagebenchmarkRecordWrapperInstance2.TotalQADCost)/averagebenchmarkRecordWrapperInstance2.TotalQADCost)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOffering != null && averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOffering!= null && averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOffering!= 0)
                    averagebenchmarkRecordWrapperInstance3.baselineFTEPrimaryOffering = (((averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOffering- averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOffering)/averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOffering)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOfferingOnNearshore != null && averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOfferingOnNearshore!= null && averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOfferingOnNearshore!= 0)
                    averagebenchmarkRecordWrapperInstance3.baselineFTEPrimaryOfferingOnNearshore = (((averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOfferingOnNearshore- averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOfferingOnNearshore)/averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOfferingOnNearshore)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOfferingOffshore != null && averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOfferingOffshore!= null && averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOfferingOffshore!= 0)
                    averagebenchmarkRecordWrapperInstance3.baselineFTEPrimaryOfferingOffshore = (((averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOfferingOffshore- averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOfferingOffshore)/averagebenchmarkRecordWrapperInstance2.baselineFTEPrimaryOfferingOffshore)*100).SetScale(2);
                if(averagebenchmarkRecordWrapperInstance1.noOfRebadgedResources != null && averagebenchmarkRecordWrapperInstance2.noOfRebadgedResources!= null && averagebenchmarkRecordWrapperInstance2.noOfRebadgedResources!= 0)
                    averagebenchmarkRecordWrapperInstance3.noOfRebadgedResources  = (((averagebenchmarkRecordWrapperInstance1.noOfRebadgedResources- averagebenchmarkRecordWrapperInstance2.noOfRebadgedResources)/averagebenchmarkRecordWrapperInstance2.noOfRebadgedResources)*100).SetScale(2);    
                    
                averageBenchmarkRecordWrapperList.add(averagebenchmarkRecordWrapperInstance3);
            }
            averageBenchmarkRecordWrapperList.add(averagebenchmarkRecordWrapperInstance2);
            
            List<averageBnechmarkRecordWrapper> newRefinedList=new List<averageBnechmarkRecordWrapper>();
            for( averageBnechmarkRecordWrapper seqRecord:averageBenchmarkRecordWrapperList){
               if(showAllRecords){
                   newRefinedList.add(seqRecord);
               } else if(seqRecord.Name == UtilConstants.YourDeal || seqRecord.Name == UtilConstants.UrDealComToAvg){
                   //Do Nothing
               }else{
                   newRefinedList.add(seqRecord);
               }
            
            }
            averageBenchmarkRecordWrapperList=newRefinedList;
            
            BenchmarkRecordWrapperListToExport.addall(averageBenchmarkRecordWrapperList);
            BenchmarkRecordWrapperListToExport.addall(BenchmarkRecordWrapperListWithCompareDealAll);
            
            //BenchmarkRecordWrapperListToExport.sort();
        }  
        catch(Exception exp) {
           //system.debug(exp.getMessage()); 
           //Need To Check Later
           //UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, 'VFC_Benchmark', 'prepareQuery Method', 'VFC_Benchmark', System.Logginglevel.ERROR);
        }     
            
    }
     /******************************
    Method Name: exportAll
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public Pagereference exportAll(){
      return new Pagereference(UtilConstants.VFP_BENCHMARK_EXPORT_URL);
    }
     /******************************
    Method Name: exportLocation
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public PageReference exportLocation(){
       String[] opportunityArr=new List<String>();
       if(BenchmarkRecordWrapperListToExport!=null){
           for(averageBnechmarkRecordWrapper avgBenchRecWrapper:BenchmarkRecordWrapperListToExport){
               if(avgBenchRecWrapper.Name!=UtilConstants.Average && avgBenchRecWrapper.Name!= UtilConstants.UrDealComToAvg){
                   opportunityArr.add((String)avgBenchRecWrapper.opportunityId);
               }
           } 
           //system.debug('opportunityArr::::::'+opportunityArr);
           bnchServLocToExport=[select Id,BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__r.SAP_OM_ID__c,BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__r.Name,BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__r.Account.Name,BenchMark_Offering_Service__r.BenchMark_Offering__r.Name,BenchMark_Offering_Service__r.Name,CC_Cost_Per_FTE__c,CPR__c,DCN_Location__c,DVE_Cost_Per_FTE__c,EDM_Cost_Per_FTE__c,Language_Premium__c,Mob_Cost_Per_FTE__c,SDO_Cost_Per_FTE__c,PMO_Cost_Per_FTE__c,SM_Cost_Per_FTE__c,Sum_of_Total_FTE_Year__c,Support_Center_Cost_Per_FTE__c,Tools_Cost_Per_FTE__c,Total_Cost_per_FTE__c,Total_SDO_Cost_less_Mob__c from BenchMark_Service_Location__c where BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__c in :opportunityArr order by BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__r.Name];
       }
       return new Pagereference(UtilConstants.VFP_BENCHMARK_LOCEXP_URL);
    }
    /******************************
    Method Name: runQuery
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    private void runQuery() {
        try{
            if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW)){
                searchResultsListOffering = Database.query(soql + UtilConstants.LIMITCONDITION+ list_size+ UtilConstants.OFFSET + counter);
            }else{
                searchResultsList = Database.query(soql + UtilConstants.LIMITCONDITION + list_size+ UtilConstants.OFFSET + counter);
            }
            Integer dealNumber = 1;        
            benchmarkRecordWrapperListToDisplay = new List<averageBnechmarkRecordWrapper>();
            benchmarkRecordWrapperListToDisplay.addAll(averageBenchmarkRecordWrapperList);
            
            if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW)){
                if(searchResultsListOffering.size() == 0) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There is no comparison deal');
                    ApexPages.addMessage(myMsg);
                }
            }else{
                if(searchResultsList.size() == 0) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There is no comparison deal');
                    ApexPages.addMessage(myMsg);
                }
            }
            if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW)){
                for(BenchMark_Offerings__c obenchmarkRecordOffering: searchResultsListOffering) {
                    averagebenchmarkRecordWrapperInstanceRecord =  new averageBnechmarkRecordWrapper();
                    averagebenchmarkRecordWrapperInstanceRecord= MapOfferingData(averagebenchmarkRecordWrapperInstanceRecord,obenchmarkRecordOffering, UtilConstants.ComparisonDeal + dealNumber);
                    benchmarkRecordWrapperListToDisplay.add(averagebenchmarkRecordWrapperInstanceRecord);
                    dealNumber  = dealNumber +1;
                }
            }else{
                for(BenchMark__c obenchmarkRecord : searchResultsList ) {
                    averagebenchmarkRecordWrapperInstanceRecord =  new averageBnechmarkRecordWrapper();
                    averagebenchmarkRecordWrapperInstanceRecord= MapOpportunityData(averagebenchmarkRecordWrapperInstanceRecord,obenchmarkRecord, UtilConstants.ComparisonDeal + dealNumber);
                    benchmarkRecordWrapperListToDisplay.add(averagebenchmarkRecordWrapperInstanceRecord);
                    dealNumber  = dealNumber +1;
               } 
            }
            dealNumber=1;
            //benchmarkRecordWrapperListToDisplay.sort();
        }
        catch(Exception exp) {
            //system.debug('Samasya'+exp);
            //Need To check later
            //UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, 'VFC_Benchmark', 'runQuery Method', 'VFC_Benchmark', System.Logginglevel.ERROR);
        }
     }
      
    /******************************
    Method Name: populateAvgOffBenchData
    Description: This method will populate the Average wrapper obj with the Avg offering beanchmark data
    Paramenters: List<AggregateResult> resultSet,averageBnechmarkRecordWrapper
    Return Value: averageBnechmarkRecordWrapper
    *******************************/ 
    private averageBnechmarkRecordWrapper populateAvgOffBenchData(List<averageBnechmarkRecordWrapper> resultSet,averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstanceRecord) {
        
         Decimal TCV=0.0;
         Decimal MobContigency=0.0;
         Decimal avgRunContigency=0.0;
         Decimal transCostContigency=0.0;        
         Decimal ciPercentage=0.0;
         Decimal contractDurationMob=0.0;
         Decimal contractDuration=0.0; 
         Decimal NoOfLocation=0.0;
         Decimal totalBaselineSDOFTEs=0.0;
         Decimal onshoreNearshoreBaselineSDOFTE=0.0;
         Decimal offshoreBaselineSDOFTE=0.0;
         Decimal TotalCostWithoutContingency=0.0;
         Decimal sdoTotalCost=0.0;
         Decimal TotalTechToolCost=0.0;
         Decimal TotalVDCost=0.0;
         Decimal TotalMOBCost=0.0;
         Decimal TotalSerManagCost=0.0;
         Decimal TotalSupCentreCost=0.0;
         Decimal TotalEDMCost=0.0;
         Decimal TotalComCentreCost=0.0;
         Decimal TotalQADMCost=0.0;
         Decimal TotalCFMCost=0.0;
         Decimal TotalCMCost=0.0;
         Decimal TotalQADCost=0.0;
      
        
        Decimal averageTotalPayrollCostsFTE=0.0;
        Decimal averageTotalPayrollCostsOffshoreFTE =0.0;   
        Decimal averageTotalPayrollCostsOnshoreNearshoreFTE =0.0;
        Decimal pyramidRichnessYear1 =0.0;
        Decimal overallProductivityImprovementPercentage=0.0;
        Decimal baselineFTEPrimaryOffering=0.0;
        Decimal baselineFTEPrimaryOfferingOnNearshore=0.0;
        Decimal baselineFTEPrimaryOfferingOffshore=0.0;
        Decimal noOfRebadgedResources=0.0;
            
        for(averageBnechmarkRecordWrapper sobj:resultSet){
        
            if(sobj.TCV!=null)
                TCV += sobj.TCV;
            
            if(sobj.MobContigency!=null)
                MobContigency += sobj.MobContigency;
            if(sobj.avgRunContigency!=null)
                 avgRunContigency+= sobj.avgRunContigency;   
            if(sobj.transCostContigency!=null)
                 transCostContigency+= sobj.transCostContigency;
            if(sobj.ciPercentage!=null)
                ciPercentage += sobj.ciPercentage;
                 
            if(sobj.contractDurationMob!=null)
                contractDurationMob += sobj.contractDurationMob;     
            if(sobj.contractDuration!=null)
                 contractDuration+= sobj.contractDuration;   
            if(sobj.NoOfLocation!=null)
                 NoOfLocation+= sobj.NoOfLocation;

            if(sobj.totalBaselineSDOFTEs!=null)
                totalBaselineSDOFTEs += sobj.totalBaselineSDOFTEs;
            if(sobj.onshoreNearshoreBaselineSDOFTE!=null)
                onshoreNearshoreBaselineSDOFTE += sobj.onshoreNearshoreBaselineSDOFTE;
            if(sobj.offshoreBaselineSDOFTE!=null)
                 offshoreBaselineSDOFTE+= sobj.offshoreBaselineSDOFTE;   
                 
                 
            if(sobj.TotalCostWithoutContingency!=null)
                 TotalCostWithoutContingency+= sobj.TotalCostWithoutContingency;    
            if(sobj.sdoTotalCost!=null)
                 sdoTotalCost+= sobj.sdoTotalCost;      
            if(sobj.TotalTechToolCost!=null)
                TotalTechToolCost += sobj.TotalTechToolCost;
            if(sobj.TotalVDCost!=null)
                TotalVDCost += sobj.TotalVDCost;
            if(sobj.TotalMOBCost!=null)
                TotalMOBCost += sobj.TotalMOBCost;
            if(sobj.TotalSerManagCost!=null)
                TotalSerManagCost += sobj.TotalSerManagCost;
            if(sobj.TotalSupCentreCost!=null)
                TotalSupCentreCost += sobj.TotalSupCentreCost;
            if(sobj.TotalEDMCost!=null)
                TotalEDMCost += sobj.TotalEDMCost;
            if(sobj.TotalComCentreCost!=null)
                TotalComCentreCost += sobj.TotalComCentreCost;
            if(sobj.TotalQADMCost!=null)
                 TotalQADMCost+= sobj.TotalQADMCost;
            if(sobj.TotalCFMCost!=null)
                TotalCFMCost += sobj.TotalCFMCost;   
            if(sobj.TotalCMCost!=null)
                TotalCMCost += sobj.TotalCMCost;
            if(sobj.TotalQADCost!=null)
                TotalQADCost += sobj.TotalQADCost;   
            
            if(sobj.averageTotalPayrollCostsFTE!=null)
                averageTotalPayrollCostsFTE += sobj.averageTotalPayrollCostsFTE;
            if(sobj.averageTotalPayrollCostsOffshoreFTE!=null)
                averageTotalPayrollCostsOffshoreFTE+=sobj.averageTotalPayrollCostsOffshoreFTE;
            if(sobj.averageTotalPayrollCostsOnshoreNearshoreFTE!=null)
                averageTotalPayrollCostsOnshoreNearshoreFTE += sobj.averageTotalPayrollCostsOnshoreNearshoreFTE ;
            if(sobj.pyramidRichnessYear1!=null)
                pyramidRichnessYear1 += ((Decimal)sobj.pyramidRichnessYear1).setScale(2);
            if(sobj.overallProductivityImprovementPercentage!=null)
                overallProductivityImprovementPercentage += ((Decimal)sobj.overallProductivityImprovementPercentage).setScale(2);
            if(sobj.baselineFTEPrimaryOffering!=null)
                baselineFTEPrimaryOffering += ((Decimal)sobj.baselineFTEPrimaryOffering).setScale(2);
            if(sobj.baselineFTEPrimaryOfferingOnNearshore!=null)
                baselineFTEPrimaryOfferingOnNearshore += ((Decimal)sobj.baselineFTEPrimaryOfferingOnNearshore).setScale(2);
            if(sobj.baselineFTEPrimaryOfferingOffshore!=null)
                baselineFTEPrimaryOfferingOffshore += ((Decimal)sobj.baselineFTEPrimaryOfferingOffshore).setScale(2);    
            if(sobj.noOfRebadgedResources!=null)
                noOfRebadgedResources += ((Decimal)sobj.noOfRebadgedResources).setScale(2);
       }
       averagebenchmarkRecordWrapperInstanceRecord.TCV=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.MobContigency=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.avgRunContigency=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.transCostContigency=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.ciPercentage=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.contractDurationMob=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.contractDuration=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.NoOfLocation=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.totalBaselineSDOFTEs=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.onshoreNearshoreBaselineSDOFTE=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.offshoreBaselineSDOFTE=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalCostWithoutContingency=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.sdoTotalCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalTechToolCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalVDCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalMOBCost=0.0;           
       averagebenchmarkRecordWrapperInstanceRecord.TotalSerManagCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalSupCentreCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalEDMCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalComCentreCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalQADMCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalCFMCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalCMCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.TotalQADCost=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.averageTotalPayrollCostsFTE=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.averageTotalPayrollCostsOffshoreFTE= 0.0; 
       averagebenchmarkRecordWrapperInstanceRecord.averageTotalPayrollCostsOnshoreNearshoreFTE= 0.0; 
       averagebenchmarkRecordWrapperInstanceRecord.pyramidRichnessYear1= 0.0; 
       averagebenchmarkRecordWrapperInstanceRecord.overallProductivityImprovementPercentage=0.0;
            
       averagebenchmarkRecordWrapperInstanceRecord.LanguagesInScope='';
            
       averagebenchmarkRecordWrapperInstanceRecord.baselineFTEPrimaryOffering=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.baselineFTEPrimaryOfferingOnNearshore=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.baselineFTEPrimaryOfferingOffshore=0.0;
       averagebenchmarkRecordWrapperInstanceRecord.noOfRebadgedResources=0.0;
       if(resultSet.size()>0){
           averagebenchmarkRecordWrapperInstanceRecord.averageTotalPayrollCostsFTE=averageTotalPayrollCostsFTE/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.averageTotalPayrollCostsOffshoreFTE= averageTotalPayrollCostsOffshoreFTE/resultSet.size(); 
           averagebenchmarkRecordWrapperInstanceRecord.averageTotalPayrollCostsOnshoreNearshoreFTE= averageTotalPayrollCostsOnshoreNearshoreFTE/resultSet.size(); 
           averagebenchmarkRecordWrapperInstanceRecord.pyramidRichnessYear1= pyramidRichnessYear1/resultSet.size(); 
           averagebenchmarkRecordWrapperInstanceRecord.overallProductivityImprovementPercentage=overallProductivityImprovementPercentage/resultSet.size();
                
           averagebenchmarkRecordWrapperInstanceRecord.LanguagesInScope='';
                
           averagebenchmarkRecordWrapperInstanceRecord.baselineFTEPrimaryOffering=baselineFTEPrimaryOffering/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.baselineFTEPrimaryOfferingOnNearshore=baselineFTEPrimaryOfferingOnNearshore/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.baselineFTEPrimaryOfferingOffshore=baselineFTEPrimaryOfferingOffshore/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.noOfRebadgedResources=noOfRebadgedResources/resultSet.size();
           
           averagebenchmarkRecordWrapperInstanceRecord.TCV=TCV/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.MobContigency=MobContigency/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.avgRunContigency=avgRunContigency/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.transCostContigency=transCostContigency/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.ciPercentage=ciPercentage/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.contractDurationMob=contractDurationMob/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.contractDuration=contractDuration/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.NoOfLocation=NoOfLocation/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.totalBaselineSDOFTEs=totalBaselineSDOFTEs/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.onshoreNearshoreBaselineSDOFTE=onshoreNearshoreBaselineSDOFTE/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.offshoreBaselineSDOFTE=offshoreBaselineSDOFTE/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalCostWithoutContingency=TotalCostWithoutContingency/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.sdoTotalCost=sdoTotalCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalTechToolCost=TotalTechToolCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalVDCost=TotalVDCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalMOBCost=TotalMOBCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalSerManagCost=TotalSerManagCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalSupCentreCost=TotalSupCentreCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalEDMCost=TotalEDMCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalComCentreCost=TotalComCentreCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalQADMCost=TotalQADMCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalCFMCost=TotalCFMCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalCMCost=TotalCMCost/resultSet.size();
           averagebenchmarkRecordWrapperInstanceRecord.TotalQADCost=TotalQADCost/resultSet.size();
           
       } 
       return averagebenchmarkRecordWrapperInstanceRecord;
    }
    
    
    /******************************
    Method Name: populateOffLevelData
    Description: This method will populate the Offering Level Data
    Paramenters: String selectedOffering
    Return Value: String
    *******************************/
    private String populateOffLevelData(String selectedOffering) {
        if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW)){
             return selectedOffering;            
        }else if(selectedOffering.equals(UtilConstants.NONE_NEW)){
            return UtilConstants.All;
        }else{
            return '';
        }
    } 
    /******************************
    Method Name: populateInScopeOff
    Description: This method will populate the new InScopeOff String elimination extra ';'
    Paramenters: String orgInScopeOff
    Return Value: String
    *******************************/  
    private String populateInScopeOff(String orgInScopeOff) {
        String newInScopeOff=''; 
        if (orgInScopeOff!= null && orgInScopeOff.trim()!=''){
             String[] arrStr=orgInScopeOff.split(UtilConstants.DELIMITER);
             for(String s:arrStr){
                 if(newInScopeOff!=''){
                    if(s!= null && s.trim()!=''){
                        newInScopeOff=newInScopeOff+UtilConstants.DELIMITER+s; 
                    }
                 }else{
                     if(s!= null && s.trim()!=''){
                         newInScopeOff=s;
                     }
                 }    
             }
            newInScopeOff=newInScopeOff;             
        }
        return newInScopeOff;         
    }
    /******************************
    Method Name: populateOfferingDataOnLoad
    Description: 
    Paramenters: 
    Return Value: 
    *******************************/ 
    private void populateOfferingDataOnLoad() {
        //system.debug('Inside populateOfferingDataOnLoad');
        List<BenchMark_Offerings__c> offeringRecord = new  List<BenchMark_Offerings__c>();
        
        offeringRecord = [select FTE_Range__c,Location_Definition__c,benchmark__r.Client__c,benchmark__r.Client__r.Name, benchmark__r.BPO_Net_Revenue__c, benchmark__r.Opportunity__r.Pricing_Structure__c, benchmark__r.Mobilization_Contingency__c, benchmark__r.Average_Run_Contingency__c, benchmark__r.Transformation_Costs_consulting__c, benchmark__r.Contract_duration_MOB_DURATION__c,benchmark__r.Number_of_locations_where_scope_is_deliv__c,benchmark__r.Overall_Productivity_Improvement__c, benchmark__r.Average_total_payroll_costs_off_shore__c, benchmark__r.Average_total_payroll_costs_onshore_ne__c, benchmark__r.Count_of_Language__c,benchmark__r.Opportunity__r.Opportunity_Solution_Lead__r.Name, benchmark__r.Opportunity__r.Opportunity_Solution_Lead__c, benchmark__r.Opportunity__r.Name, benchmark__r.CI__c, benchmark__r.Contract_duration_MOB_RUN__c, benchmark__r.Baseline_FTEs__c, benchmark__r.Onshore_Nearshore_Baseline_SDO_FTEs__c, benchmark__r.Grand_Total_Cost__c, benchmark__r.SDO_Total_Cost__c, benchmark__r.Technology_Tools_Total_Cost__c, benchmark__r.Voice_and_Data_Total_Cost__c, benchmark__r.Mobilization_Total_Cost__c, benchmark__r.Service_Management_Total_Cost__c, benchmark__r.Support_Center_Total_Cost__c, benchmark__r.Electronic_Documentation_Mgmy_Total__c, benchmark__r.Command_Center_Total_Cost__c, benchmark__r.OADM_Total_Cost__c, benchmark__r.CFM_Total_Cost__c, benchmark__r.CM_Total_Cost__c, benchmark__r.QAD_Total_Cost__c,benchmark__r.Pyramid_Richness_Year1__c, benchmark__r.FTE_Range__c, benchmark__r.Location_Definition__c, benchmark__r.Languages__c , benchmark__r.Onshore_Baseline_FTEs__c, benchmark__r.Offshore_Baseline_FTEs__c,benchmark__r.Opportunity__r.Geo_Region__r.Name, benchmark__r.Opportunity__r.OperatingGroup__c, benchmark__r.Opportunity__r.OperatingGroup__r.name, benchmark__r.Opportunity__r.Reporting_Status__c, benchmark__r.BPO_Net_Revenue_Range__c, benchmark__r.Multi_Single_Offering__c,benchmark__r.Offerings__c,benchmark__r.Number_of_rebadged_resources_from_client__c,benchmark__r.Final_Month_FTEs_c__c,  Count_of_Languages_del__c, Average_of_Pyramid_Richness_Year_1__c,No_of_Headcounts__c,Baseline_FTE_Offshore_SDO__c,Baseline_FTE_SDO__c,Onshore_Nearshore_Baseline_SDO_FTEs__c,Average_total_payroll_costs_FTE__c,Average_total_payroll_costs_off_shore__c,Avg_total_payrol_costs_Onshr_NearShr__c,Overall_Productivity_Improvement__c  FROM BenchMark_Offerings__c where benchmark__r.Opportunity__c =:selectedOpportunity AND benchmark__r.Client__c =:selectedClientName LIMIT 1];
            if(offeringRecord.size() > 0) {
                benchmarkRecordoffering = offeringRecord[0];//benchmarkRecordoffering.benchmark__r
                selectedGeoRegion = (benchmarkRecordoffering.benchmark__r.Opportunity__r.Geo_Region__r.Name == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.Opportunity__r.Geo_Region__r.Name ;
                selectedOperatingGroup = (benchmarkRecordoffering.benchmark__r.Opportunity__r.OperatingGroup__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.Opportunity__r.OperatingGroup__c;
                selectedReportingStatus = (benchmarkRecordoffering.benchmark__r.Opportunity__r.Reporting_Status__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.Opportunity__r.Reporting_Status__c;
                selectedBPONetRevenueRange = (benchmarkRecordoffering.benchmark__r.BPO_Net_Revenue_Range__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.BPO_Net_Revenue_Range__c;
                selectedMultiSingleOffering = (benchmarkRecordoffering.benchmark__r.Multi_Single_Offering__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.Multi_Single_Offering__c; 
                
                String allOffering=populateInScopeOff(benchmarkRecordoffering.benchmark__r.Offerings__c);                
                selectedOffering = (allOffering.contains(UtilConstants.DELIMITER) || benchmarkRecordoffering.benchmark__r.Multi_Single_Offering__c == UtilConstants.MULTIPLE)? UtilConstants.NONE_NEW:allOffering;
                
                searchOffering();
                
                selectedFteRange =  (benchmarkRecordoffering.FTE_Range__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.FTE_Range__c;    
                
                selectedNoOfLanguage = (benchmarkRecordoffering.Count_of_Languages_del__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.Count_of_Languages_del__c;
                selectedDeliveryLocation = (benchmarkRecordoffering.Location_Definition__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.Location_Definition__c;
                
                
                opportunityDataWrapperDisplay= new OpportunityDataWrapperDisplay();
        
                opportunityDataWrapperDisplay.clientGeoAreaName = (benchmarkRecordoffering.benchmark__r.Opportunity__r.Geo_Region__r.Name == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.Opportunity__r.Geo_Region__r.Name ;
                opportunityDataWrapperDisplay.OperatingGroupName = (benchmarkRecordoffering.benchmark__r.Opportunity__r.OperatingGroup__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.Opportunity__r.OperatingGroup__r.name;
                opportunityDataWrapperDisplay.reportingStatus = (benchmarkRecordoffering.benchmark__r.Opportunity__r.Reporting_Status__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.Opportunity__r.Reporting_Status__c;
                opportunityDataWrapperDisplay.BPONetRevenue=(benchmarkRecordoffering.benchmark__r.BPO_Net_Revenue_Range__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.BPO_Net_Revenue_Range__c;
                opportunityDataWrapperDisplay.MultipleSingleOffering= (benchmarkRecordoffering.benchmark__r.Multi_Single_Offering__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.benchmark__r.Multi_Single_Offering__c;
        
                if(benchmarkRecordoffering.benchmark__r.Multi_Single_Offering__c == UtilConstants.MULTIPLE){
                    opportunityDataWrapperDisplay.Offerings= UtilConstants.All;
                }else{
                    opportunityDataWrapperDisplay.Offerings=allOffering;
                }
                opportunityDataWrapperDisplay.FTE=  (benchmarkRecordoffering.FTE_Range__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.FTE_Range__c; 
                opportunityDataWrapperDisplay.DeliveryLocation= (benchmarkRecordoffering.Location_Definition__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.Location_Definition__c;
                opportunityDataWrapperDisplay.Languages= (benchmarkRecordoffering.Count_of_Languages_del__c == null)? UtilConstants.MSG_1219:benchmarkRecordoffering.Count_of_Languages_del__c;
                
            }
    }
    /******************************
    Method Name: populateOfferingDataOnLoad
    Description: 
    Paramenters: 
    Return Value: 
    *******************************/ 
    private void populateOfferingQuery() {
        List<BenchMark_Offerings__c> offeringRecord = new  List<BenchMark_Offerings__c>();
        String newOffSOQL = UtilConstants.QUERY_NEW_1 +String.escapeSingleQuotes(selectedOffering)+UtilConstants.PATTERN_2 + UtilConstants.SOQL2 ;
        //String newOffSOQL = 'select FTE_Range__c,Location_Definition__c,benchmark__r.Client__c,benchmark__r.Client__r.Name, benchmark__r.BPO_Net_Revenue__c, benchmark__r.Opportunity__r.Pricing_Structure__c, benchmark__r.Mobilization_Contingency__c, benchmark__r.Average_Run_Contingency__c, benchmark__r.Transformation_Costs_consulting__c, benchmark__r.Contract_duration_MOB_DURATION__c,benchmark__r.Number_of_locations_where_scope_is_deliv__c, benchmark__r.Overall_Productivity_Improvement__c, benchmark__r.Average_total_payroll_costs_off_shore__c, benchmark__r.Average_total_payroll_costs_onshore_ne__c, benchmark__r.Count_of_Language__c, benchmark__r.Opportunity__r.Geo_Region__r.Name, benchmark__r.Opportunity__r.Opportunity_Solution_Lead__r.Name, benchmark__r.Opportunity__r.Opportunity_Solution_Lead__c, benchmark__r.Opportunity__r.Name, benchmark__r.CI__c, benchmark__r.Contract_duration_MOB_RUN__c, benchmark__r.Baseline_FTEs__c, benchmark__r.Onshore_Nearshore_Baseline_SDO_FTEs__c, benchmark__r.Grand_Total_Cost__c, benchmark__r.SDO_Total_Cost__c, benchmark__r.Technology_Tools_Total_Cost__c, benchmark__r.Voice_and_Data_Total_Cost__c, benchmark__r.Mobilization_Total_Cost__c, benchmark__r.Service_Management_Total_Cost__c, benchmark__r.Support_Center_Total_Cost__c, benchmark__r.Electronic_Documentation_Mgmy_Total__c, benchmark__r.Command_Center_Total_Cost__c, benchmark__r.OADM_Total_Cost__c, benchmark__r.CFM_Total_Cost__c, benchmark__r.CM_Total_Cost__c, benchmark__r.QAD_Total_Cost__c,benchmark__r.Pyramid_Richness_Year1__c, benchmark__r.FTE_Range__c, benchmark__r.Location_Definition__c, benchmark__r.Languages__c , benchmark__r.Onshore_Baseline_FTEs__c, benchmark__r.Offshore_Baseline_FTEs__c,benchmark__r.Opportunity__r.OperatingGroup__c, benchmark__r.Opportunity__r.OperatingGroup__r.name, benchmark__r.Opportunity__r.Reporting_Status__c, benchmark__r.BPO_Net_Revenue_Range__c, benchmark__r.Multi_Single_Offering__c,benchmark__r.Offerings__c,benchmark__r.Number_of_rebadged_resources_from_client__c,benchmark__r.Final_Month_FTEs_c__c,  Count_of_Languages_del__c, Average_of_Pyramid_Richness_Year_1__c,No_of_Headcounts__c,Baseline_FTE_Offshore_SDO__c,Baseline_FTE_SDO__c,Onshore_Nearshore_Baseline_SDO_FTEs__c,Average_total_payroll_costs_FTE__c,Average_total_payroll_costs_off_shore__c,Avg_total_payrol_costs_Onshr_NearShr__c,Overall_Productivity_Improvement__c,SDO_Services__c FROM BenchMark_Offerings__c where benchmark__r.Opportunity__c =:selectedOpportunity AND benchmark__r.Client__c =:selectedClientName'+' And Name LIKE \''+'%'+String.escapeSingleQuotes(selectedOffering)+'%\'' +' LIMIT 1';
        
        offeringRecord=Database.query(newOffSOQL);
        if(offeringRecord.size() > 0) {
            benchmarkRecordoffering=offeringRecord[0];
        }
        else
        {
            benchmarkRecordoffering = null;
        }
    }
    
    /******************************
    Method Name: MapOfferingData
    Description: 
    Paramenters: 
    Return Value: 
    *******************************/ 
    private averageBnechmarkRecordWrapper MapOfferingData(averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstance,BenchMark_Offerings__c benchmarkRecordoffering,String DealName) {
        averagebenchmarkRecordWrapperInstance.Name = DealName; //'Your Deal'
        if(benchmarkRecordoffering!=null){
            averagebenchmarkRecordWrapperInstance.clientNameId = benchmarkRecordoffering.benchmark__r.Client__c;
            averagebenchmarkRecordWrapperInstance.clientName = benchmarkRecordoffering.benchmark__r.Client__r.Name;        
            averagebenchmarkRecordWrapperInstance.opportunityId = benchmarkRecordoffering.benchmark__r.opportunity__c;
            averagebenchmarkRecordWrapperInstance.opportunityName = benchmarkRecordoffering.benchmark__r.opportunity__r.Name;        
            averagebenchmarkRecordWrapperInstance.OSLId = benchmarkRecordoffering.benchmark__r.Opportunity__r.Opportunity_Solution_Lead__c;
            averagebenchmarkRecordWrapperInstance.OSLName = benchmarkRecordoffering.benchmark__r.Opportunity__r.Opportunity_Solution_Lead__r.Name;        
                        
            averagebenchmarkRecordWrapperInstance.clientGeoArea = benchmarkRecordoffering.benchmark__r.Opportunity__r.Geo_Region__r.Name;
            averagebenchmarkRecordWrapperInstance.operatingGroup = benchmarkRecordoffering.benchmark__r.Opportunity__r.OperatingGroup__r.Name;
            averagebenchmarkRecordWrapperInstance.Activity = benchmarkRecordoffering.benchmark__r.Opportunity__r.Reporting_Status__c;
            averagebenchmarkRecordWrapperInstance.pricingType = benchmarkRecordoffering.benchmark__r.Opportunity__r.Pricing_Structure__c;
            averagebenchmarkRecordWrapperInstance.TCV = benchmarkRecordoffering.benchmark__r.BPO_Net_Revenue__c;
            averagebenchmarkRecordWrapperInstance.MobContigency = benchmarkRecordoffering.benchmark__r.Mobilization_Contingency__c;
            averagebenchmarkRecordWrapperInstance.avgRunContigency = benchmarkRecordoffering.benchmark__r.Average_Run_Contingency__c;
            averagebenchmarkRecordWrapperInstance.transCostContigency = benchmarkRecordoffering.benchmark__r.Transformation_Costs_consulting__c;  
            averagebenchmarkRecordWrapperInstance.ciPercentage = (Decimal)benchmarkRecordoffering.benchmark__r.CI__c;
            averagebenchmarkRecordWrapperInstance.contractDurationMob = (Decimal)benchmarkRecordoffering.benchmark__r.Contract_duration_MOB_DURATION__c;
            averagebenchmarkRecordWrapperInstance.contractDuration = (Decimal)benchmarkRecordoffering.benchmark__r.Contract_duration_MOB_RUN__c ;
            averagebenchmarkRecordWrapperInstance.NoOfLocation = (Decimal)benchmarkRecordoffering.benchmark__r.Number_of_locations_where_scope_is_deliv__c;
            averagebenchmarkRecordWrapperInstance.totalBaselineSDOFTEs = (Decimal)benchmarkRecordoffering.benchmark__r.Baseline_FTEs__c;
            averagebenchmarkRecordWrapperInstance.onshoreNearshoreBaselineSDOFTE = (Decimal)benchmarkRecordoffering.benchmark__r.Onshore_Nearshore_Baseline_SDO_FTEs__c;            
            averagebenchmarkRecordWrapperInstance.offshoreBaselineSDOFTE = (Decimal)benchmarkRecordoffering.benchmark__r.Offshore_Baseline_FTEs__c;            
            averagebenchmarkRecordWrapperInstance.InScopeOfferings = populateInScopeOff(benchmarkRecordoffering.benchmark__r.Offerings__c);
            averagebenchmarkRecordWrapperInstance.offLevelData =populateOffLevelData(selectedOffering);///////////             
            averagebenchmarkRecordWrapperInstance.TotalCostWithoutContingency = (Decimal)benchmarkRecordoffering.benchmark__r.Grand_Total_Cost__c ;
            averagebenchmarkRecordWrapperInstance.sdoTotalCost = (Decimal)benchmarkRecordoffering.benchmark__r.SDO_Total_Cost__c;
            
            averagebenchmarkRecordWrapperInstance.TotalTechToolCost = (Decimal)benchmarkRecordoffering.benchmark__r.Technology_Tools_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalVDCost = (Decimal)benchmarkRecordoffering.benchmark__r.Voice_and_Data_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalMOBCost = (Decimal)benchmarkRecordoffering.benchmark__r.Mobilization_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalSerManagCost = (Decimal)benchmarkRecordoffering.benchmark__r.Service_Management_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalSupCentreCost = (Decimal)benchmarkRecordoffering.benchmark__r.Support_Center_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalEDMCost = (Decimal)benchmarkRecordoffering.benchmark__r.Electronic_Documentation_Mgmy_Total__c;
            averagebenchmarkRecordWrapperInstance.TotalComCentreCost = (Decimal)benchmarkRecordoffering.benchmark__r.Command_Center_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalQADMCost = (Decimal)benchmarkRecordoffering.benchmark__r.OADM_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalCFMCost = (Decimal)benchmarkRecordoffering.benchmark__r.CFM_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalCMCost = (Decimal)benchmarkRecordoffering.benchmark__r.CM_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance.TotalQADCost = (Decimal)benchmarkRecordoffering.benchmark__r.QAD_Total_Cost__c;   
            
            averagebenchmarkRecordWrapperInstance.inScopeService = benchmarkRecordoffering.SDO_Services__c;
            
            Decimal defaultVal=0.0;
            if(benchmarkRecordoffering.Average_total_payroll_costs_FTE__c!=null)
                averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsFTE = (Decimal)benchmarkRecordoffering.Average_total_payroll_costs_FTE__c;
            else
                averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsFTE=defaultVal;
            if(benchmarkRecordoffering.Average_total_payroll_costs_off_shore__c!=null)
                averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsOffshoreFTE = (Decimal)benchmarkRecordoffering.Average_total_payroll_costs_off_shore__c;
            else
                averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsOffshoreFTE=defaultVal;
            
            if(benchmarkRecordoffering.Avg_total_payrol_costs_Onshr_NearShr__c!=null)
                averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsOnshoreNearshoreFTE = (Decimal)benchmarkRecordoffering.Avg_total_payrol_costs_Onshr_NearShr__c;
            else
                averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsOnshoreNearshoreFTE = defaultVal;    
            
            if(benchmarkRecordoffering.Average_of_Pyramid_Richness_Year_1__c!=null)
                averagebenchmarkRecordWrapperInstance.pyramidRichnessYear1 = (Decimal)benchmarkRecordoffering.Average_of_Pyramid_Richness_Year_1__c;
            else
                averagebenchmarkRecordWrapperInstance.pyramidRichnessYear1 = defaultVal;     
            
            if(benchmarkRecordoffering.Overall_Productivity_Improvement__c !=null)
                averagebenchmarkRecordWrapperInstance.overallProductivityImprovementPercentage = (Decimal)benchmarkRecordoffering.Overall_Productivity_Improvement__c;
            else
                averagebenchmarkRecordWrapperInstance.overallProductivityImprovementPercentage = defaultVal;
             
            if(benchmarkRecordoffering.Count_of_Languages_del__c!=null)
                averagebenchmarkRecordWrapperInstance.LanguagesInScope =benchmarkRecordoffering.Count_of_Languages_del__c;
             
            if(benchmarkRecordoffering.Baseline_FTE_SDO__c!=null)
                averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOffering = ((Decimal)benchmarkRecordoffering.Baseline_FTE_SDO__c).setScale(2);
            else
                averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOffering = defaultVal;
            
            if(benchmarkRecordoffering.Onshore_Nearshore_Baseline_SDO_FTEs__c !=null)
                averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOfferingOnNearshore = (Decimal)benchmarkRecordoffering.Onshore_Nearshore_Baseline_SDO_FTEs__c;  
            else
                averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOfferingOnNearshore=defaultVal;
            
            if(benchmarkRecordoffering.Baseline_FTE_Offshore_SDO__c!=null)
                averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOfferingOffshore = ((Decimal)benchmarkRecordoffering.Baseline_FTE_Offshore_SDO__c).setScale(2);
            else
                averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOfferingOffshore = defaultVal;
            
            if(benchmarkRecordoffering.No_of_Headcounts__c!=null)
                averagebenchmarkRecordWrapperInstance.noOfRebadgedResources= (Decimal)benchmarkRecordoffering.No_of_Headcounts__c;
            else
                averagebenchmarkRecordWrapperInstance.noOfRebadgedResources= defaultVal;
        }
        return   averagebenchmarkRecordWrapperInstance;
    } 
    
    /******************************
    Method Name: populateOpportunityDataOnLoad
    Description: 
    Paramenters: 
    Return Value: 
    *******************************/ 
   private void populateOpportunityDataOnLoad (){
        //system.debug('Inside populateOpportunityDataOnLoad');
        List<BenchMark__c> opportuintyRecord = new  List<BenchMark__c>();
        opportuintyRecord = [select Client__c,Client__r.Name,BPO_Net_Revenue__c, Opportunity__r.Pricing_Structure__c, Mobilization_Contingency__c, 
        Average_Run_Contingency__c, Transformation_Costs_consulting__c, Contract_duration_MOB_DURATION__c,Number_of_locations_where_scope_is_deliv__c,
        Overall_Productivity_Improvement__c, Average_total_payroll_costs_FTE__c, Average_total_payroll_costs_off_shore__c, Average_total_payroll_costs_onshore_ne__c, 
        Count_of_Language__c,Opportunity__r.Opportunity_Solution_Lead__c,Opportunity__r.Opportunity_Solution_Lead__r.name, Opportunity__r.Name, CI__c, 
        Contract_duration_MOB_RUN__c, Baseline_FTEs__c, Onshore_Nearshore_Baseline_SDO_FTEs__c, Offshore_Baseline_FTEs__c, Grand_Total_Cost__c, SDO_Total_Cost__c, 
        Technology_Tools_Total_Cost__c, Voice_and_Data_Total_Cost__c, Mobilization_Total_Cost__c, Service_Management_Total_Cost__c, Support_Center_Total_Cost__c, 
        Electronic_Documentation_Mgmy_Total__c, Command_Center_Total_Cost__c, OADM_Total_Cost__c, CFM_Total_Cost__c, CM_Total_Cost__c, QAD_Total_Cost__c,
        Pyramid_Richness_Year1__c, FTE_Range__c, Location_Definition__c, Languages__c , Onshore_Baseline_FTEs__c, Opportunity__r.Geo_Region__r.Name, 
        Opportunity__r.OperatingGroup__c, Opportunity__r.OperatingGroup__r.name, Opportunity__r.Reporting_Status__c, BPO_Net_Revenue_Range__c, 
        Multi_Single_Offering__c,Offerings__c,Number_of_rebadged_resources_from_client__c,Final_Month_FTEs_c__c 
        FROM BenchMark__c WHERE Service_Group__C =:UtilConstants.BPO AND Opportunity__c =:selectedOpportunity AND Client__c =:selectedClientName LIMIT 1];
        if(opportuintyRecord.size() > 0) {
            benchmarkRecord = opportuintyRecord[0];
            selectedGeoRegion = (benchmarkRecord.Opportunity__r.Geo_Region__r.Name == null)? UtilConstants.MSG_1219:benchmarkRecord.Opportunity__r.Geo_Region__r.Name ;
            selectedOperatingGroup = (benchmarkRecord.Opportunity__r.OperatingGroup__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Opportunity__r.OperatingGroup__c;
            selectedReportingStatus = (benchmarkRecord.Opportunity__r.Reporting_Status__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Opportunity__r.Reporting_Status__c;
            selectedBPONetRevenueRange = (benchmarkRecord.BPO_Net_Revenue_Range__c == null)? UtilConstants.MSG_1219:benchmarkRecord.BPO_Net_Revenue_Range__c;
            selectedMultiSingleOffering = (benchmarkRecord.Multi_Single_Offering__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Multi_Single_Offering__c; 
            
            String allOffering=populateInScopeOff(benchmarkRecord.Offerings__c);                
            selectedOffering = (allOffering.contains(UtilConstants.DELIMITER) || benchmarkRecord.Multi_Single_Offering__c == UtilConstants.MULTIPLE)? UtilConstants.NONE_NEW:allOffering;
            
            
            selectedFteRange =  (benchmarkRecord.FTE_Range__c == null)? UtilConstants.MSG_1219:benchmarkRecord.FTE_Range__c;
            selectedNoOfLanguage = (benchmarkRecord.Count_of_Language__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Count_of_Language__c;
            selectedDeliveryLocation = (benchmarkRecord.Location_Definition__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Location_Definition__c;
            
            opportunityDataWrapperDisplay= new OpportunityDataWrapperDisplay();
            
            opportunityDataWrapperDisplay.clientGeoAreaName = (benchmarkRecord.Opportunity__r.Geo_Region__r.Name == null)? UtilConstants.MSG_1219:benchmarkRecord.Opportunity__r.Geo_Region__r.Name ;
            opportunityDataWrapperDisplay.OperatingGroupName = (benchmarkRecord.Opportunity__r.OperatingGroup__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Opportunity__r.OperatingGroup__r.name;
            opportunityDataWrapperDisplay.reportingStatus = (benchmarkRecord.Opportunity__r.Reporting_Status__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Opportunity__r.Reporting_Status__c;
            opportunityDataWrapperDisplay.BPONetRevenue=(benchmarkRecord.BPO_Net_Revenue_Range__c == null)? UtilConstants.MSG_1219:benchmarkRecord.BPO_Net_Revenue_Range__c;
            opportunityDataWrapperDisplay.MultipleSingleOffering= (benchmarkRecord.Multi_Single_Offering__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Multi_Single_Offering__c;
            
            if(benchmarkRecord.Multi_Single_Offering__c == UtilConstants.MULTIPLE){
                opportunityDataWrapperDisplay.Offerings= UtilConstants.All;
            }else{
                opportunityDataWrapperDisplay.Offerings=allOffering;
            }
            opportunityDataWrapperDisplay.FTE=  (benchmarkRecord.FTE_Range__c == null)? UtilConstants.MSG_1219:benchmarkRecord.FTE_Range__c;
            opportunityDataWrapperDisplay.DeliveryLocation= (benchmarkRecord.Location_Definition__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Location_Definition__c;
            opportunityDataWrapperDisplay.Languages= (benchmarkRecord.Count_of_Language__c == null)? UtilConstants.MSG_1219:benchmarkRecord.Count_of_Language__c;
        }
    }
    /******************************
    Method Name: populateOpportunityOnLoad
    Description: 
    Paramenters: 
    Return Value: 
    *******************************/ 
    private averageBnechmarkRecordWrapper MapOpportunityData(averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstance1,BenchMark__c benchmarkRecord, String YourDeal){       
        Decimal defaultVal=0.0;
        averagebenchmarkRecordWrapperInstance1.Name = YourDeal;
        
        if(benchmarkRecord!=null){ 
            averagebenchmarkRecordWrapperInstance1.clientNameId = benchmarkRecord.Client__c;
            averagebenchmarkRecordWrapperInstance1.clientName = benchmarkRecord.Client__r.Name;        
            averagebenchmarkRecordWrapperInstance1.opportunityId = benchmarkRecord.opportunity__c;
            averagebenchmarkRecordWrapperInstance1.opportunityName = benchmarkRecord.opportunity__r.Name;        
            averagebenchmarkRecordWrapperInstance1.OSLId = benchmarkRecord.Opportunity__r.Opportunity_Solution_Lead__c;
            averagebenchmarkRecordWrapperInstance1.OSLName = benchmarkRecord.Opportunity__r.Opportunity_Solution_Lead__r.Name;        
                        
            averagebenchmarkRecordWrapperInstance1.clientGeoArea = benchmarkRecord.Opportunity__r.Geo_Region__r.Name;
            averagebenchmarkRecordWrapperInstance1.operatingGroup = benchmarkRecord.Opportunity__r.OperatingGroup__r.Name;
            averagebenchmarkRecordWrapperInstance1.Activity = benchmarkRecord.Opportunity__r.Reporting_Status__c;
            averagebenchmarkRecordWrapperInstance1.pricingType = benchmarkRecord.Opportunity__r.Pricing_Structure__c;
            averagebenchmarkRecordWrapperInstance1.TCV = benchmarkRecord.BPO_Net_Revenue__c;
            averagebenchmarkRecordWrapperInstance1.MobContigency = benchmarkRecord.Mobilization_Contingency__c;
            averagebenchmarkRecordWrapperInstance1.avgRunContigency = benchmarkRecord.Average_Run_Contingency__c;
            averagebenchmarkRecordWrapperInstance1.transCostContigency = benchmarkRecord.Transformation_Costs_consulting__c;  
            averagebenchmarkRecordWrapperInstance1.ciPercentage = (Decimal)benchmarkRecord.CI__c;
            averagebenchmarkRecordWrapperInstance1.contractDurationMob = (Decimal)benchmarkRecord.Contract_duration_MOB_DURATION__c;
            averagebenchmarkRecordWrapperInstance1.contractDuration = (Decimal)benchmarkRecord.Contract_duration_MOB_RUN__c ;
            averagebenchmarkRecordWrapperInstance1.NoOfLocation = (Decimal)benchmarkRecord.Number_of_locations_where_scope_is_deliv__c;
            averagebenchmarkRecordWrapperInstance1.totalBaselineSDOFTEs = (Decimal)benchmarkRecord.Baseline_FTEs__c;
            averagebenchmarkRecordWrapperInstance1.onshoreNearshoreBaselineSDOFTE = (Decimal)benchmarkRecord.Onshore_Nearshore_Baseline_SDO_FTEs__c;            
            averagebenchmarkRecordWrapperInstance1.offshoreBaselineSDOFTE = (Decimal)benchmarkRecord.Offshore_Baseline_FTEs__c;            
            averagebenchmarkRecordWrapperInstance1.InScopeOfferings = populateInScopeOff(benchmarkRecord.Offerings__c);
            averagebenchmarkRecordWrapperInstance1.offLevelData =populateOffLevelData(selectedOffering);             
            averagebenchmarkRecordWrapperInstance1.TotalCostWithoutContingency = (Decimal)benchmarkRecord.Grand_Total_Cost__c ;
            averagebenchmarkRecordWrapperInstance1.sdoTotalCost = (Decimal)benchmarkRecord.SDO_Total_Cost__c;
            
            averagebenchmarkRecordWrapperInstance1.TotalTechToolCost = (Decimal)benchmarkRecord.Technology_Tools_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalVDCost = (Decimal)benchmarkRecord.Voice_and_Data_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalMOBCost = (Decimal)benchmarkRecord.Mobilization_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalSerManagCost = (Decimal)benchmarkRecord.Service_Management_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalSupCentreCost = (Decimal)benchmarkRecord.Support_Center_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalEDMCost = (Decimal)benchmarkRecord.Electronic_Documentation_Mgmy_Total__c;
            averagebenchmarkRecordWrapperInstance1.TotalComCentreCost = (Decimal)benchmarkRecord.Command_Center_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalQADMCost = (Decimal)benchmarkRecord.OADM_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalCFMCost = (Decimal)benchmarkRecord.CFM_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalCMCost = (Decimal)benchmarkRecord.CM_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalQADCost = (Decimal)benchmarkRecord.QAD_Total_Cost__c;   
            
            if(benchmarkRecord.Average_total_payroll_costs_FTE__c!=null)
                averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsFTE = (Decimal)benchmarkRecord.Average_total_payroll_costs_FTE__c;
            else
                averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsFTE=defaultVal;
                
            if(benchmarkRecord.Average_total_payroll_costs_off_shore__c!=null)
                averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOffshoreFTE = (Decimal)benchmarkRecord.Average_total_payroll_costs_off_shore__c;
            else
                averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOffshoreFTE=defaultVal;
                
            if(benchmarkRecord.Average_total_payroll_costs_onshore_ne__c!=null )
                averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOnshoreNearshoreFTE = (Decimal)benchmarkRecord.Average_total_payroll_costs_onshore_ne__c;
            else
                averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOnshoreNearshoreFTE = defaultVal;
                
            if(benchmarkRecord.Pyramid_Richness_Year1__c!=null)
                averagebenchmarkRecordWrapperInstance1.pyramidRichnessYear1 = (Decimal)benchmarkRecord.Pyramid_Richness_Year1__c;
            else
                averagebenchmarkRecordWrapperInstance1.pyramidRichnessYear1 = defaultVal;
            
            if(benchmarkRecord.Overall_Productivity_Improvement__c!=null)
                averagebenchmarkRecordWrapperInstance1.overallProductivityImprovementPercentage = (Decimal)benchmarkRecord.Overall_Productivity_Improvement__c;
            else
                averagebenchmarkRecordWrapperInstance1.overallProductivityImprovementPercentage = defaultVal;
                
            if(benchmarkRecord.Count_of_Language__c!=null)
                averagebenchmarkRecordWrapperInstance1.LanguagesInScope = benchmarkRecord.Count_of_Language__c;        
                
            if(benchmarkRecord.Baseline_FTEs__c!=null)
                averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOffering = (Decimal)benchmarkRecord.Baseline_FTEs__c;
            else
                averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOffering = defaultVal;
                
            if(benchmarkRecord.Onshore_Nearshore_Baseline_SDO_FTEs__c!=null)
                averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOfferingOnNearshore = (Decimal)benchmarkRecord.Onshore_Nearshore_Baseline_SDO_FTEs__c;  
            else
                averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOfferingOnNearshore=defaultVal; 
            
            if(benchmarkRecord.Offshore_Baseline_FTEs__c!=null)
                averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOfferingOffshore = (Decimal)benchmarkRecord.Offshore_Baseline_FTEs__c;
            else
                averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOfferingOffshore = defaultVal;
             
            if(benchmarkRecord.Number_of_rebadged_resources_from_client__c!=null)
                averagebenchmarkRecordWrapperInstance1.noOfRebadgedResources= (Decimal)benchmarkRecord.Number_of_rebadged_resources_from_client__c;
            else
                averagebenchmarkRecordWrapperInstance1.noOfRebadgedResources= defaultVal; 
        } 
        return averagebenchmarkRecordWrapperInstance1;
    }

    /******************************
        Method Name: populateOpportunityOnLoad
        Description: 
        Paramenters: 
        Return Value: 
        *******************************/ 
    private String offeringLevelQuery(){       
        soql = UtilConstants.QUERY_NEW +String.escapeSingleQuotes(selectedOffering)+UtilConstants.PATTERN_2;                  
        //system.debug('In Offering Query Block');
        if (!selectedGeoRegion.equals(UtilConstants.MSG_1219))
          soql += UtilConstants.QUERY_OLD +String.escapeSingleQuotes(selectedGeoRegion)+UtilConstants.PATTERN_NEW_ONE;
        if (!selectedOperatingGroup.equals(UtilConstants.MSG_1219))
          soql += UtilConstants.QUERY_OLD_1 +String.escapeSingleQuotes(selectedOperatingGroup)+UtilConstants.PATTERN_NEW_ONE;
        if (!selectedBPONetRevenueRange.equals(UtilConstants.MSG_1219))
          soql += UtilConstants.QUERY_OLD_2 +String.escapeSingleQuotes(selectedBPONetRevenueRange)+UtilConstants.PATTERN_NEW_ONE;
        if (!selectedMultiSingleOffering.equals(UtilConstants.MSG_1219))
          soql += UtilConstants.QUERY_OLD_3 +String.escapeSingleQuotes(selectedMultiSingleOffering)+UtilConstants.PATTERN_NEW_ONE;
        if (!selectedReportingStatus.equals(UtilConstants.MSG_1219))
          soql += UtilConstants.QUERY_OLD_4 +String.escapeSingleQuotes(selectedReportingStatus)+UtilConstants.PATTERN_NEW_ONE;
        if (!selectedFteRange.equals(UtilConstants.MSG_1219))
          soql += UtilConstants.QUERY_OLD_5 +String.escapeSingleQuotes(selectedFteRange)+UtilConstants.PATTERN_NEW_ONE;
        if (!selectedDeliveryLocation.equals(UtilConstants.MSG_1219))
          soql += UtilConstants.MSG_1214 +String.escapeSingleQuotes(selectedDeliveryLocation)+UtilConstants.PATTERN_NEW_ONE;
        if (!selectedNoOfLanguage.equals(UtilConstants.MSG_1219))
          soql += UtilConstants.SENTENCE_1 +String.escapeSingleQuotes(selectedNoOfLanguage)+UtilConstants.PATTERN_NEW_ONE;  
        
        if (OffServiceArrSel!=null && OffServiceArrSel.size()>0){
            /*String serviceSOQL='';
            for(SelectOption itrObj:OffServiceArrSel){
                //serviceSOQL+= UtilConstants.SOQL_Q1  +UtilConstants.PATTERN_1+itrObj.getValue()+UtilConstants.PATTERN_2;
                serviceSOQL+=  ' OR SDO_Services_Picklist__c Like '  +UtilConstants.PATTERN_1+itrObj.getValue()+UtilConstants.PATTERN_2;
            }
            serviceSOQL=serviceSOQL.trim().removeStart(UtilConstants.ORCONDITION);
            soql +=' AND ( '+serviceSOQL+' ) ';*/
            String servAll='';
            for(SelectOption itrObj:OffServiceArrSel){
                String str=itrObj.getValue();
                if(str.length()>=40){
                    str=str.substring(0,40);
                }
                if(servAll.equals('')){
                    servAll += '\''+str+'\'';
                }else{
                    servAll += ',\''+str+'\'';
                }
            }
            
           String serviceSOQL=  'SDO_Services_Picklist__c includes ('+servAll+')';
           soql +=' AND ( '+serviceSOQL+' ) ';
        }
        if (OffBSSArrSel!=null && OffBSSArrSel.size()>0){
            String bssSOQL='';
            for(SelectOption itrObj:OffBSSArrSel){
                bssSOQL+= UtilConstants.BSS_SERVICE  +UtilConstants.PATTERN_1+itrObj.getValue()+UtilConstants.PATTERN_2;
            }
            bssSOQL=bssSOQL.trim().removeStart(UtilConstants.ORCONDITION);
            soql +=' AND ( '+bssSOQL+' ) ';
        }  
        if (OffTechToolArrSel!=null && OffTechToolArrSel.size()>0){
            String techSOQL='';
            for(SelectOption itrObj:OffTechToolArrSel){
                techSOQL+= UtilConstants.TECH_TOOL  +UtilConstants.PATTERN_1+itrObj.getValue()+UtilConstants.PATTERN_2;
            }
            techSOQL=techSOQL.trim().removeStart(UtilConstants.ORCONDITION);
            soql +=' AND ( '+techSOQL+' ) ';
        }        
        soql =soql+ ' '+ whereClause + UtilConstants.MSG_1221;
        system.debug('SOQL Offering' + soql); 
        return soql; 
    }
    
    /******************************
        Method Name: opportunityLevelQuery
        Description: 
        Paramenters: 
        Return Value: 
        *******************************/
    private String opportunityLevelQuery(){       
            soql = UtilConstants.SOQL_QUERY ;                  
            //system.debug('In Opportunity Query Block');
            if (!selectedGeoRegion.equals(UtilConstants.MSG_1219)){
              whereClause += UtilConstants.MSG_1220 +String.escapeSingleQuotes(selectedGeoRegion)+UtilConstants.PATTERN_NEW_ONE;
              //soql += ' and Opportunity__r.Geo_Region__r.Name = \''+String.escapeSingleQuotes(selectedGeoRegion)+UtilConstants.PATTERN_NEW_ONE;
              }
            if (!selectedOffering.equals(UtilConstants.MSG_1219) && !selectedOffering.equals(UtilConstants.NONE_NEW))
              {
              whereClause += UtilConstants.MSG_1218 +UtilConstants.AMPERSAND_OPRTR+String.escapeSingleQuotes(selectedOffering)+UtilConstants.PATTERN_2; }
            if (!selectedOperatingGroup.equals(UtilConstants.MSG_1219))
              whereClause +=  UtilConstants.MSG_1217 +String.escapeSingleQuotes(selectedOperatingGroup)+UtilConstants.PATTERN_NEW_ONE;
            if (!selectedFteRange.equals(UtilConstants.MSG_1219))
              whereClause += UtilConstants.MSG_1216 +String.escapeSingleQuotes(selectedFteRange)+UtilConstants.PATTERN_NEW_ONE;
            if (!selectedReportingStatus.equals(UtilConstants.MSG_1219))
              whereClause += UtilConstants.MSG_1215 +String.escapeSingleQuotes(selectedReportingStatus)+UtilConstants.PATTERN_NEW_ONE;
            if (!selectedDeliveryLocation.equals(UtilConstants.MSG_1219))
              whereClause +=  UtilConstants.MSG_1214 +String.escapeSingleQuotes(selectedDeliveryLocation)+UtilConstants.PATTERN_NEW_ONE;
            if (!selectedBPONetRevenueRange.equals(UtilConstants.MSG_1219))
              whereClause +=  UtilConstants.MSG_1213 +String.escapeSingleQuotes(selectedBPONetRevenueRange)+UtilConstants.PATTERN_NEW_ONE;
            if (!selectedMultiSingleOffering.equals(UtilConstants.MSG_1219))
              whereClause += UtilConstants.MSG_1212 +String.escapeSingleQuotes(selectedMultiSingleOffering)+UtilConstants.PATTERN_NEW_ONE;
            if (!selectedNoOfLanguage.equals(UtilConstants.MSG_1219))
              whereClause += UtilConstants.MSG_1211 +String.escapeSingleQuotes(selectedNoOfLanguage)+UtilConstants.PATTERN_NEW_ONE;
              
             soql =soql+ ' '+ whereClause + UtilConstants.MSG_1221 ;
            //system.debug('SOQL' + soql);
            return soql;  
    }

}