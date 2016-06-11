/*
Author : Harshit Shah
Story  :   
Description :Benchmark view and filter criterion logics.
Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Harshit Shah                               5/15/2013          Release 1.6
        
*/

public with sharing class VFC_Benchmark_Old {
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
    public List<Opportunity_BenchMark_Data__c> searchResultsList{get;set;}
    public List<BenchMark_offering__c> searchResultsListOffering{get;set;}
    public List<Opportunity_BenchMark_Data__c> benchmarkListToExport{get;set;}
    public List<BenchMark_offering__c> benchmarkOfferingListToExport{get;set;}
    public List<averageBnechmarkRecordWrapper> BenchmarkRecordWrapperListToExport{get; set;}    
    public Opportunity_BenchMark_Data__c benchmarkRecord{get;set;}
    public BenchMark_offering__c benchmarkRecordoffering{get;set;}
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
    public List<Benchmark_Offering__c> resultSet=null; 
    /* Pagination Code */
    private integer totalRecs = 0;     
    private integer index = 0;
    private integer blockSize = 7;
    private boolean showAllRecords=false;
    public String whereClause = '';    
    public Map<id,decimal> OfferingCountMap {get; set;}
    /******************************
    Constructor Name: VFC_Benchmark
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    /* ------------------------------------------------------------------- -- */ 
    public VFC_Benchmark_Old() {
        benchmarkRecord = new Opportunity_BenchMark_Data__c();
        isSearchVisible = false;
        isAdvanceSearchVisible = true;
        //showAllRecords=false;
    }
    
    /*-- ------------------------------------------------------------------> */
    private integer counter=0;  //keeps track of the offset
    private integer list_size=7; //sets the page size or number of rows
    public integer total_size; 
    
    
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
      counter = total_size - math.mod(total_size, list_size);
      runQuery();
      return null;
    }
    
    public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
    }
    
    public Boolean getDisableNext() { 
        //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
    }
    
    public Integer getTotal_size() {
      return total_size;
    }
    
    public Integer getPageNumber() {
      return counter/list_size + 1;
    }
    
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
        clientNameOptions.add(new SelectOption('None', '--None--'));
        for(Opportunity_BenchMark_Data__c  opportunityBenchmarkData: [SELECT Client__c, Client__r.Name FROM Opportunity_BenchMark_Data__c where Client__c != null ORDER BY Client__r.Name ASC LIMIT 1000 ]) {
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
    Method Name: resetPage
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public pagereference resetPage() {
       return new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/VFP_benchmark'); 
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
        opportunityNameOptions.add(new SelectOption('None', '--None--'));
        for(Opportunity_BenchMark_Data__c  opportunityBenchmarkData: [SELECT Opportunity__c, Opportunity__r.Name,Offerring_Count__c FROM Opportunity_BenchMark_Data__c where Client__c =: clientIdHiddenValue ORDER BY Opportunity__r.Name ASC LIMIT 1000 ]) {
            opportunityNameOptions.add(new SelectOption(opportunityBenchmarkData.Opportunity__c,opportunityBenchmarkData.Opportunity__r.Name));
            OfferingCountMap.put(opportunityBenchmarkData.Opportunity__c,opportunityBenchmarkData.Offerring_Count__c);
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
            if(selectedClientName =='None'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please select client and opportunity!');
            ApexPages.addMessage(myMsg);
            showError = true;
            }
            else if(selectedOpportunity == 'None'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please select opportunity!');
            ApexPages.addMessage(myMsg);
            showError = true;
            }
            if(selectedOpportunity == 'None'  || selectedClientName =='None') {
                benchmarkRecordWrapperListToDisplay = new List<averageBnechmarkRecordWrapper>();
                benchmarkRecord = new Opportunity_BenchMark_Data__c();    
                selectedGeoRegion = 'None';
                selectedOperatingGroup = 'None';
                selectedFteRange = 'None';
                selectedReportingStatus = 'None';
                selectedDeliveryLocation = 'None';
                selectedBPONetRevenueRange = 'None';
                selectedMultiSingleOffering = 'None';
                selectedNoOfLanguage = 'None';
                selectedOffering = 'None';  
                isAdvanceSearchVisible = true;
                isSearchVisible = false;   
            } 
            else {
                isAdvanceSearchVisible = true;
                isSearchVisible = true;
            }      
            
            List<Opportunity_BenchMark_Data__c> opportuintyRecord = new  List<Opportunity_BenchMark_Data__c>(); 
            List<BenchMark_offering__c> BenchofferingRecord = new  List<BenchMark_offering__c>(); 
            
            if(selectedOpportunity!='None'){
                if(OfferingCountMap.containsKey(selectedOpportunity)){
                    decimal countofoffering = OfferingCountMap.get(selectedOpportunity);
                    system.debug('countofoffering'+countofoffering);
                    if(countofoffering==1){
                        system.debug('To Show Offering Data');
                        populateOfferingDataOnLoad();
                    }else{
                        system.debug('To Show Opportunity Data');
                        populateOpportunityDataOnLoad();
                    }
                }
                searchAdvanceResult();
            }
         }
         catch(Exception exp) {
         system.debug('Samasya'+exp);
           UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, 'VFC_Benchmark', 'searchResults Method', 'VFC_Benchmark', 
                                                    System.Logginglevel.ERROR);
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
        GeoRegionOptions.add(new SelectOption('None', '--None--'));
        for(Client_Geo_Area_Master__c clientGeoArea : [Select Name, Id from Client_Geo_Area_Master__c where Name != 'EALA'order by Name limit 100]) {
            GeoRegionOptions.add(new selectOption(clientGeoArea.Id, clientGeoArea.Name));
        }
        return GeoRegionOptions ; 
    }
    
    /******************************
    Method Name: getListOfOffering
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<selectOption> getListOfOffering() {
        List<selectOption> offeringOptions = new List<selectOption>();
        offeringOptions.add(new SelectOption('None', '--None--'));
        offeringOptions.add(new SelectOption('None1', 'All'));
        for(Offerings_Master__c offering: [Select Name, Id from Offerings_Master__c order by Name limit 100]) {
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
        operatingGroupOptions.add(new SelectOption('None', '--None--'));
        for(Operating_Group_Master__c operatingGroup : [Select Name, Id from Operating_Group_Master__c  order by Name limit 100]) {
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
        fteRangeOptions.add(new SelectOption('None', '--None--'));
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
        reportingStatusOptions.add(new SelectOption('None', '--None--'));
        Schema.DescribeFieldResult reportingStatus = Opportunity_TGP__c.Activity__c.getDescribe();
        List<Schema.PicklistEntry> reportingStatusValues = reportingStatus.getPicklistValues();
        for (Schema.PicklistEntry a : reportingStatusValues) { 
            reportingStatusOptions.add(new SelectOption(a.getLabel(), a.getValue())); 
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
        deliveryLocationOptions.add(new SelectOption('None', '--None--'));
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
        multiSingleOfferingOptions.add(new SelectOption('None', '--None--'));
        Schema.DescribeFieldResult multiSingleOffering = Opportunity_BenchMark_Data__c.Multi_Single_Offering__c.getDescribe();
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
        bpoNetRevenueRangeOptions.add(new SelectOption('None', '--None--'));
        
        List<BPO_Net_Revenue_Range_List__c> BPONetRevList=new List<BPO_Net_Revenue_Range_List__c>();
        
        BPONetRevList=[select BPONetRevnueList__c from BPO_Net_Revenue_Range_List__c order by OrderNumber__c];
        
        for(BPO_Net_Revenue_Range_List__c itrObj:BPONetRevList){
        
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
        noOfLanguageeOptions.add(new SelectOption('None', '--None--'));
        Schema.DescribeFieldResult noOfLanguage = Opportunity_BenchMark_Data__c.no_of_languages__c.getDescribe();
        List<Schema.PicklistEntry> noOfLanguageValues = noOfLanguage.getPicklistValues();
        for (Schema.PicklistEntry a : noOfLanguageValues ) { 
            noOfLanguageeOptions.add(new SelectOption(a.getLabel(), a.getValue())); 
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
        if(selectedOpportunity!='None'){
            if(OfferingCountMap.containsKey(selectedOpportunity)){
                decimal countofoffering = OfferingCountMap.get(selectedOpportunity);
                if(countofoffering>0){
                    if (!selectedOffering.equals('None') && !selectedOffering.equals('None1')){
                        system.debug('populateOfferingQuery');
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
            benchmarkListToExport = new List<Opportunity_BenchMark_Data__c>();
            benchmarkOfferingListToExport = new List<BenchMark_offering__c>();
            
            if (!selectedOffering.equals('None') && !selectedOffering.equals('None1')){
                soql=offeringLevelQuery();
                benchmarkOfferingListToExport  = Database.Query(soql);
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
            
            if(selectedOpportunity!='None'){
                if(OfferingCountMap.containsKey(selectedOpportunity)){
                    decimal countofoffering = OfferingCountMap.get(selectedOpportunity);
                    if (!selectedOffering.equals('None') && !selectedOffering.equals('None1') && countofoffering>0){
                        system.debug('MapOfferingData');
                        
                        averagebenchmarkRecordWrapperInstance1= MapOfferingData(averagebenchmarkRecordWrapperInstance1,benchmarkRecordoffering,'Your Deal');
                    }else{
                        if(countofoffering==1){
                            system.debug('MapOfferingData');
                            averagebenchmarkRecordWrapperInstance1= MapOfferingData(averagebenchmarkRecordWrapperInstance1,benchmarkRecordoffering,'Your Deal');
                        }else{
                            system.debug('MapOpportunityData');
                            averagebenchmarkRecordWrapperInstance1= MapOpportunityData(averagebenchmarkRecordWrapperInstance1,benchmarkRecord, 'Your Deal');
                        }
                    }
                }
                averageBenchmarkRecordWrapperList.add(averagebenchmarkRecordWrapperInstance1); 
            }
            Decimal defaultVal=0.0;
            
            averagebenchmarkRecordWrapperInstance2 =  new averageBnechmarkRecordWrapper(); 
            averagebenchmarkRecordWrapperInstance2.Name = 'Average';
            
            List<averageBnechmarkRecordWrapper> BenchmarkRecordWrapperListWithDealandCompareDealAll = new List<averageBnechmarkRecordWrapper>();
            BenchmarkRecordWrapperListWithDealandCompareDealAll.addall(averageBenchmarkRecordWrapperList);
            
            List<averageBnechmarkRecordWrapper> BenchmarkRecordWrapperListWithCompareDealAll = new List<averageBnechmarkRecordWrapper>();
            
            BenchmarkRecordWrapperListToExport = new List<averageBnechmarkRecordWrapper>();
            
            if (!selectedOffering.equals('None') && !selectedOffering.equals('None1')){
                for(BenchMark_offering__c benchmarkReportrecordOffering: benchmarkOfferingListToExport) {
                    averagebenchmarkRecordWrapperInstance =  new averageBnechmarkRecordWrapper();
                    averagebenchmarkRecordWrapperInstance= MapOfferingData(averagebenchmarkRecordWrapperInstance,benchmarkReportrecordOffering, 'Comparison Deal ' + recordCount);
                    BenchmarkRecordWrapperListWithDealandCompareDealAll.add(averagebenchmarkRecordWrapperInstance);
                    BenchmarkRecordWrapperListWithCompareDealAll.add(averagebenchmarkRecordWrapperInstance);
                    recordCount = recordCount +1;
                }
            }else{
                for(Opportunity_BenchMark_Data__c benchmarkReportrecord: benchmarkListToExport ) {
                    averagebenchmarkRecordWrapperInstance =  new averageBnechmarkRecordWrapper();
                    averagebenchmarkRecordWrapperInstance= MapOpportunityData(averagebenchmarkRecordWrapperInstance,benchmarkReportrecord, 'Comparison Deal ' + recordCount);
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
            if(selectedOpportunity!='None'){
                averagebenchmarkRecordWrapperInstance3 =  new averageBnechmarkRecordWrapper();        
                averagebenchmarkRecordWrapperInstance3.Name = 'Your Deal Compare to Average' ;  
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
               } else if(seqRecord.Name == 'Your Deal' || seqRecord.Name == 'Your Deal Compare to Average'){
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
           system.debug(exp.getMessage()); 
           UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, 'VFC_Benchmark', 'prepareQuery Method', 'VFC_Benchmark', 
                                                    System.Logginglevel.ERROR);
        }     
            
    }
    
    public Pagereference exportAll(){
      return new Pagereference('/apex/VFP_BenchmarkExport_Old');
    }
    
    /******************************
    Method Name: runQuery
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    private void runQuery() {
        try{
            if (!selectedOffering.equals('None') && !selectedOffering.equals('None1')){
                searchResultsListOffering = Database.query(soql + ' LIMIT '+ list_size+' OFFSET '+ counter);
            }else{
                searchResultsList = Database.query(soql + ' LIMIT '+ list_size+' OFFSET '+ counter);
            }
            Integer dealNumber = 1;        
            benchmarkRecordWrapperListToDisplay = new List<averageBnechmarkRecordWrapper>();
            benchmarkRecordWrapperListToDisplay.addAll(averageBenchmarkRecordWrapperList);
            
            if (!selectedOffering.equals('None') && !selectedOffering.equals('None1')){
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
            if (!selectedOffering.equals('None') && !selectedOffering.equals('None1')){
                for(BenchMark_offering__c obenchmarkRecordOffering: searchResultsListOffering) {
                    averagebenchmarkRecordWrapperInstanceRecord =  new averageBnechmarkRecordWrapper();
                    averagebenchmarkRecordWrapperInstanceRecord= MapOfferingData(averagebenchmarkRecordWrapperInstanceRecord,obenchmarkRecordOffering, 'Comparison Deal ' + dealNumber);
                    benchmarkRecordWrapperListToDisplay.add(averagebenchmarkRecordWrapperInstanceRecord);
                    dealNumber  = dealNumber +1;
                }
            }else{
                for(Opportunity_BenchMark_Data__c obenchmarkRecord : searchResultsList ) {
                    averagebenchmarkRecordWrapperInstanceRecord =  new averageBnechmarkRecordWrapper();
                    averagebenchmarkRecordWrapperInstanceRecord= MapOpportunityData(averagebenchmarkRecordWrapperInstanceRecord,obenchmarkRecord, 'Comparison Deal ' + dealNumber);
                    benchmarkRecordWrapperListToDisplay.add(averagebenchmarkRecordWrapperInstanceRecord);
                    dealNumber  = dealNumber +1;
               } 
            }
            dealNumber=1;
            //benchmarkRecordWrapperListToDisplay.sort();
        }
        catch(Exception exp) {
        system.debug('Samasya'+exp);
           UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, 'VFC_Benchmark', 'runQuery Method', 'VFC_Benchmark', 
                                                    System.Logginglevel.ERROR);
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
        if (!selectedOffering.equals('None') && !selectedOffering.equals('None1')){
             return selectedOffering;            
        }else if(selectedOffering.equals('None1')){
            return 'All';
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
             String[] arrStr=orgInScopeOff.split(';');
             for(String s:arrStr){
                 if(newInScopeOff!=''){
                    if(s!= null && s.trim()!=''){
                        newInScopeOff=newInScopeOff+';'+s; 
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
        system.debug('Inside populateOfferingDataOnLoad');
        List<BenchMark_offering__c> offeringRecord = new  List<BenchMark_offering__c>();
        
        offeringRecord = [select FTE_Range__c,Location_Definition__c,Opportunity_benchmark_data__r.Client__c,Opportunity_benchmark_data__r.Client__r.Name, Opportunity_benchmark_data__r.BPO_Net_Revenue__c, Opportunity_benchmark_data__r.Opportunity__r.Pricing_Type__c, Opportunity_benchmark_data__r.Mobilization_Contingency__c, Opportunity_benchmark_data__r.Average_Run_Contingency__c, Opportunity_benchmark_data__r.Transformation_Costs_consulting__c, Opportunity_benchmark_data__r.Contract_duration_MOB_DURATION__c,Opportunity_benchmark_data__r.No_of_Locations__c,Opportunity_benchmark_data__r.Overall_Productivity_Improvement_new__c, Opportunity_benchmark_data__r.Average_total_payroll_costs_off_shore__c, Opportunity_benchmark_data__r.Average_total_payroll_costs_ons_nearshor__c, Opportunity_benchmark_data__r.no_of_languages__c, Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__c, Opportunity_benchmark_data__r.Opportunity__r.Enterprise_Solution_Architect_New__r.Name, Opportunity_benchmark_data__r.Opportunity__r.Enterprise_Solution_Architect_New__c, Opportunity_benchmark_data__r.Opportunity__r.Name, Opportunity_benchmark_data__r.CI__c, Opportunity_benchmark_data__r.Contract_duration_MOB_RUN__c, Opportunity_benchmark_data__r.TOTAL_Baseline_SDO_FTEs__c, Opportunity_benchmark_data__r.Onshore_Nearshore_Baseline_SDO_FTEs__c, Opportunity_benchmark_data__r.Grand_Total_Cost__c, Opportunity_benchmark_data__r.SDO_Total_Cost__c, Opportunity_benchmark_data__r.Technology_Tools_Total_Cost__c, Opportunity_benchmark_data__r.Voice_and_Data_Total_Cost__c, Opportunity_benchmark_data__r.Mobilization_Total_Cost__c, Opportunity_benchmark_data__r.Service_Management_Total_Cost__c, Opportunity_benchmark_data__r.Support_Center_Total_Cost__c, Opportunity_benchmark_data__r.Electronic_Doc_Management_Total_Cost__c, Opportunity_benchmark_data__r.Command_Center_Total_Cost__c, Opportunity_benchmark_data__r.OADM_Total_Cost__c, Opportunity_benchmark_data__r.CFM_Total_Cost__c, Opportunity_benchmark_data__r.CM_Total_Cost__c, Opportunity_benchmark_data__r.QAD_Total_Cost__c,Opportunity_benchmark_data__r.Pyramid_Richness_Year1__c, Opportunity_benchmark_data__r.FTE_Range_new__c, Opportunity_benchmark_data__r.Location_Definition__c, Opportunity_benchmark_data__r.Languages__c , Opportunity_benchmark_data__r.Onshore_Baseline_FTEs__c, Opportunity_benchmark_data__r.Offshore_Baseline_FTEs__c,Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__r.Name, Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__c, Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__r.name, Opportunity_benchmark_data__r.Opportunity__r.Activity__c, Opportunity_benchmark_data__r.BPO_Net_Revenue_Range_new__c, Opportunity_benchmark_data__r.Multi_Single_Offering__c,Opportunity_benchmark_data__r.Offering_List__c,Opportunity_benchmark_data__r.Number_of_rebadged_resources_from_client__c,Opportunity_benchmark_data__r.Final_Month_FTEs__c,  Language_in_scope__c, Average_of_Pyramid_Richness_Year_1__c,No_of_Headcounts__c,Offshore_Baseline_FTEs__c,Sum_of_Baseline_FTEs__c,Onshore_Nearshore_Baseline_SDO_FTEs__c,Average_total_payroll_costs_FTE__c,Average_total_payroll_costs_off_shore__c,Average_total_payroll_costs_Onshore__c,Overall_Productivity_Improvement__c  FROM Benchmark_Offering__c where Opportunity_benchmark_data__r.Opportunity__c =:selectedOpportunity AND Opportunity_benchmark_data__r.Client__c =:selectedClientName LIMIT 1];
            if(offeringRecord.size() > 0) {
                benchmarkRecordoffering = offeringRecord[0];//benchmarkRecordoffering.Opportunity_benchmark_data__r
                selectedGeoRegion = (benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__c ;
                selectedOperatingGroup = (benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__c;
                selectedReportingStatus = (benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Activity__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Activity__c;
                selectedBPONetRevenueRange = (benchmarkRecordoffering.Opportunity_benchmark_data__r.BPO_Net_Revenue_Range_new__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.BPO_Net_Revenue_Range_new__c;
                selectedMultiSingleOffering = (benchmarkRecordoffering.Opportunity_benchmark_data__r.Multi_Single_Offering__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.Multi_Single_Offering__c; 
                
                String allOffering=populateInScopeOff(benchmarkRecordoffering.Opportunity_benchmark_data__r.Offering_List__c);                
                selectedOffering = (allOffering.contains(';') || benchmarkRecordoffering.Opportunity_benchmark_data__r.Multi_Single_Offering__c == 'Multiple')? 'None1':allOffering;
                
                selectedFteRange =  (benchmarkRecordoffering.FTE_Range__c == null)? 'None':benchmarkRecordoffering.FTE_Range__c;    
                selectedNoOfLanguage = (benchmarkRecordoffering.language_in_scope__c == null)? 'None':benchmarkRecordoffering.language_in_scope__c;
                selectedDeliveryLocation = (benchmarkRecordoffering.Location_Definition__c == null)? 'None':benchmarkRecordoffering.Location_Definition__c;
                
                
                opportunityDataWrapperDisplay= new OpportunityDataWrapperDisplay();
        
                opportunityDataWrapperDisplay.clientGeoAreaName = (benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__r.name ;
                opportunityDataWrapperDisplay.OperatingGroupName = (benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__r.name;
                opportunityDataWrapperDisplay.reportingStatus = (benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Activity__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Activity__c;
                opportunityDataWrapperDisplay.BPONetRevenue=(benchmarkRecordoffering.Opportunity_benchmark_data__r.BPO_Net_Revenue_Range_new__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.BPO_Net_Revenue_Range_new__c;
                opportunityDataWrapperDisplay.MultipleSingleOffering= (benchmarkRecordoffering.Opportunity_benchmark_data__r.Multi_Single_Offering__c == null)? 'None':benchmarkRecordoffering.Opportunity_benchmark_data__r.Multi_Single_Offering__c;
        
                if(benchmarkRecordoffering.Opportunity_benchmark_data__r.Multi_Single_Offering__c == 'Multiple'){
                    opportunityDataWrapperDisplay.Offerings='  All';
                }else{
                    opportunityDataWrapperDisplay.Offerings=allOffering;
                }
                opportunityDataWrapperDisplay.FTE=  (benchmarkRecordoffering.FTE_Range__c == null)? 'None':benchmarkRecordoffering.FTE_Range__c; 
                opportunityDataWrapperDisplay.DeliveryLocation= (benchmarkRecordoffering.Location_Definition__c == null)? 'None':benchmarkRecordoffering.Location_Definition__c;
                opportunityDataWrapperDisplay.Languages= (benchmarkRecordoffering.language_in_scope__c == null)? 'None':benchmarkRecordoffering.language_in_scope__c;
                
                   
            }
    }
    /******************************
    Method Name: populateOfferingDataOnLoad
    Description: 
    Paramenters: 
    Return Value: 
    *******************************/ 
    private void populateOfferingQuery() {
        List<BenchMark_offering__c> offeringRecord = new  List<BenchMark_offering__c>();
        String newOffSOQL = 'select FTE_Range__c,Location_Definition__c,Opportunity_benchmark_data__r.Client__c,Opportunity_benchmark_data__r.Client__r.Name, Opportunity_benchmark_data__r.BPO_Net_Revenue__c, Opportunity_benchmark_data__r.Opportunity__r.Pricing_Type__c, Opportunity_benchmark_data__r.Mobilization_Contingency__c, Opportunity_benchmark_data__r.Average_Run_Contingency__c, Opportunity_benchmark_data__r.Transformation_Costs_consulting__c, Opportunity_benchmark_data__r.Contract_duration_MOB_DURATION__c,Opportunity_benchmark_data__r.No_of_Locations__c, Opportunity_benchmark_data__r.Overall_Productivity_Improvement_new__c, Opportunity_benchmark_data__r.Average_total_payroll_costs_off_shore__c, Opportunity_benchmark_data__r.Average_total_payroll_costs_ons_nearshor__c, Opportunity_benchmark_data__r.no_of_languages__c, Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__c, Opportunity_benchmark_data__r.Opportunity__r.Enterprise_Solution_Architect_New__r.Name, Opportunity_benchmark_data__r.Opportunity__r.Enterprise_Solution_Architect_New__c, Opportunity_benchmark_data__r.Opportunity__r.Name, Opportunity_benchmark_data__r.CI__c, Opportunity_benchmark_data__r.Contract_duration_MOB_RUN__c, Opportunity_benchmark_data__r.TOTAL_Baseline_SDO_FTEs__c, Opportunity_benchmark_data__r.Onshore_Nearshore_Baseline_SDO_FTEs__c, Opportunity_benchmark_data__r.Grand_Total_Cost__c, Opportunity_benchmark_data__r.SDO_Total_Cost__c, Opportunity_benchmark_data__r.Technology_Tools_Total_Cost__c, Opportunity_benchmark_data__r.Voice_and_Data_Total_Cost__c, Opportunity_benchmark_data__r.Mobilization_Total_Cost__c, Opportunity_benchmark_data__r.Service_Management_Total_Cost__c, Opportunity_benchmark_data__r.Support_Center_Total_Cost__c, Opportunity_benchmark_data__r.Electronic_Doc_Management_Total_Cost__c, Opportunity_benchmark_data__r.Command_Center_Total_Cost__c, Opportunity_benchmark_data__r.OADM_Total_Cost__c, Opportunity_benchmark_data__r.CFM_Total_Cost__c, Opportunity_benchmark_data__r.CM_Total_Cost__c, Opportunity_benchmark_data__r.QAD_Total_Cost__c,Opportunity_benchmark_data__r.Pyramid_Richness_Year1__c, Opportunity_benchmark_data__r.FTE_Range_new__c, Opportunity_benchmark_data__r.Location_Definition__c, Opportunity_benchmark_data__r.Languages__c , Opportunity_benchmark_data__r.Onshore_Baseline_FTEs__c, Opportunity_benchmark_data__r.Offshore_Baseline_FTEs__c,Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__r.Name, Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__c, Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__r.name, Opportunity_benchmark_data__r.Opportunity__r.Activity__c, Opportunity_benchmark_data__r.BPO_Net_Revenue_Range_new__c, Opportunity_benchmark_data__r.Multi_Single_Offering__c,Opportunity_benchmark_data__r.Offering_List__c,Opportunity_benchmark_data__r.Number_of_rebadged_resources_from_client__c,Opportunity_benchmark_data__r.Final_Month_FTEs__c,  Language_in_scope__c, Average_of_Pyramid_Richness_Year_1__c,No_of_Headcounts__c,Offshore_Baseline_FTEs__c,Sum_of_Baseline_FTEs__c,Onshore_Nearshore_Baseline_SDO_FTEs__c,Average_total_payroll_costs_FTE__c,Average_total_payroll_costs_off_shore__c,Average_total_payroll_costs_Onshore__c,Overall_Productivity_Improvement__c    FROM Benchmark_Offering__c where Opportunity_benchmark_data__r.Opportunity__c =:selectedOpportunity AND Opportunity_benchmark_data__r.Client__c =:selectedClientName'+' And Name LIKE \''+'%'+String.escapeSingleQuotes(selectedOffering)+'%\'' +' LIMIT 1';
        
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
    private averageBnechmarkRecordWrapper MapOfferingData(averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstance,BenchMark_offering__c benchmarkRecordoffering,String DealName) {
            averagebenchmarkRecordWrapperInstance.Name = DealName; //'Your Deal'
            if(benchmarkRecordoffering!=null){
                averagebenchmarkRecordWrapperInstance.clientNameId = benchmarkRecordoffering.Opportunity_benchmark_data__r.Client__c;
                averagebenchmarkRecordWrapperInstance.clientName = benchmarkRecordoffering.Opportunity_benchmark_data__r.Client__r.Name;        
                averagebenchmarkRecordWrapperInstance.opportunityId = benchmarkRecordoffering.Opportunity_benchmark_data__r.opportunity__c;
                averagebenchmarkRecordWrapperInstance.opportunityName = benchmarkRecordoffering.Opportunity_benchmark_data__r.opportunity__r.Name;        
                averagebenchmarkRecordWrapperInstance.OSLId = benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Enterprise_Solution_Architect_New__c;
                averagebenchmarkRecordWrapperInstance.OSLName = benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Enterprise_Solution_Architect_New__r.Name;        
                            
                averagebenchmarkRecordWrapperInstance.clientGeoArea = benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__r.Name;
                averagebenchmarkRecordWrapperInstance.operatingGroup = benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Operating_Group__r.Name;
                averagebenchmarkRecordWrapperInstance.Activity = benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Activity__c;
                averagebenchmarkRecordWrapperInstance.pricingType = benchmarkRecordoffering.Opportunity_benchmark_data__r.Opportunity__r.Pricing_Type__c;
                averagebenchmarkRecordWrapperInstance.TCV = benchmarkRecordoffering.Opportunity_benchmark_data__r.BPO_Net_Revenue__c;
                averagebenchmarkRecordWrapperInstance.MobContigency = benchmarkRecordoffering.Opportunity_benchmark_data__r.Mobilization_Contingency__c;
                averagebenchmarkRecordWrapperInstance.avgRunContigency = benchmarkRecordoffering.Opportunity_benchmark_data__r.Average_Run_Contingency__c;
                averagebenchmarkRecordWrapperInstance.transCostContigency = benchmarkRecordoffering.Opportunity_benchmark_data__r.Transformation_Costs_consulting__c;  
                averagebenchmarkRecordWrapperInstance.ciPercentage = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.CI__c;
                averagebenchmarkRecordWrapperInstance.contractDurationMob = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Contract_duration_MOB_DURATION__c;
                averagebenchmarkRecordWrapperInstance.contractDuration = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Contract_duration_MOB_RUN__c ;
                averagebenchmarkRecordWrapperInstance.NoOfLocation = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.No_of_Locations__c;
                averagebenchmarkRecordWrapperInstance.totalBaselineSDOFTEs = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.TOTAL_Baseline_SDO_FTEs__c;
                averagebenchmarkRecordWrapperInstance.onshoreNearshoreBaselineSDOFTE = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Onshore_Nearshore_Baseline_SDO_FTEs__c;            
                averagebenchmarkRecordWrapperInstance.offshoreBaselineSDOFTE = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Offshore_Baseline_FTEs__c;            
                averagebenchmarkRecordWrapperInstance.InScopeOfferings = populateInScopeOff(benchmarkRecordoffering.Opportunity_benchmark_data__r.Offering_List__c);
                averagebenchmarkRecordWrapperInstance.offLevelData =populateOffLevelData(selectedOffering);///////////             
                averagebenchmarkRecordWrapperInstance.TotalCostWithoutContingency = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Grand_Total_Cost__c ;
                averagebenchmarkRecordWrapperInstance.sdoTotalCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.SDO_Total_Cost__c;
                
                averagebenchmarkRecordWrapperInstance.TotalTechToolCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Technology_Tools_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalVDCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Voice_and_Data_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalMOBCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Mobilization_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalSerManagCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Service_Management_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalSupCentreCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Support_Center_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalEDMCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Electronic_Doc_Management_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalComCentreCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.Command_Center_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalQADMCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.OADM_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalCFMCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.CFM_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalCMCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.CM_Total_Cost__c;
                averagebenchmarkRecordWrapperInstance.TotalQADCost = (Decimal)benchmarkRecordoffering.Opportunity_benchmark_data__r.QAD_Total_Cost__c;   
                
                Decimal defaultVal=0.0;
                if(benchmarkRecordoffering.Average_total_payroll_costs_FTE__c!=null)
                    averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsFTE = (Decimal)benchmarkRecordoffering.Average_total_payroll_costs_FTE__c;
                else
                    averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsFTE=defaultVal;
                if(benchmarkRecordoffering.Average_total_payroll_costs_off_shore__c!=null)
                    averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsOffshoreFTE = (Decimal)benchmarkRecordoffering.Average_total_payroll_costs_off_shore__c;
                else
                    averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsOffshoreFTE=defaultVal;
                
                if(benchmarkRecordoffering.Average_total_payroll_costs_Onshore__c!=null)
                    averagebenchmarkRecordWrapperInstance.averageTotalPayrollCostsOnshoreNearshoreFTE = (Decimal)benchmarkRecordoffering.Average_total_payroll_costs_Onshore__c;
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
                 
                if(benchmarkRecordoffering.Language_in_scope__c!=null)
                    averagebenchmarkRecordWrapperInstance.LanguagesInScope =benchmarkRecordoffering.Language_in_scope__c;
                 
                if(benchmarkRecordoffering.Sum_of_Baseline_FTEs__c!=null)
                    averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOffering = ((Decimal)benchmarkRecordoffering.Sum_of_Baseline_FTEs__c).setScale(2);
                else
                    averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOffering = defaultVal;
                
                if(benchmarkRecordoffering.Onshore_Nearshore_Baseline_SDO_FTEs__c !=null)
                    averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOfferingOnNearshore = (Decimal)benchmarkRecordoffering.Onshore_Nearshore_Baseline_SDO_FTEs__c;  
                else
                    averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOfferingOnNearshore=defaultVal;
                
                if(benchmarkRecordoffering.Offshore_Baseline_FTEs__c!=null)
                    averagebenchmarkRecordWrapperInstance.baselineFTEPrimaryOfferingOffshore = ((Decimal)benchmarkRecordoffering.Offshore_Baseline_FTEs__c).setScale(2);
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
        system.debug('Inside populateOpportunityDataOnLoad');
        List<Opportunity_BenchMark_Data__c> opportuintyRecord = new  List<Opportunity_BenchMark_Data__c>();
        opportuintyRecord = [select Client__c,Client__r.Name,BPO_Net_Revenue__c, Opportunity__r.Pricing_Type__c, Mobilization_Contingency__c, Average_Run_Contingency__c, Transformation_Costs_consulting__c, Contract_duration_MOB_DURATION__c,No_of_Locations__c,Overall_Productivity_Improvement_new__c, Average_total_payroll_costs_FTE__c, Average_total_payroll_costs_off_shore__c, Average_total_payroll_costs_ons_nearshor__c, no_of_languages__c, Opportunity__r.Client_Geo_Area__c, Opportunity__r.Enterprise_Solution_Architect_New__r.Name, Opportunity__r.Enterprise_Solution_Architect_New__c, Opportunity__r.Name, CI__c, Contract_duration_MOB_RUN__c, TOTAL_Baseline_SDO_FTEs__c, Onshore_Nearshore_Baseline_SDO_FTEs__c, Offshore_Baseline_FTEs__c, Grand_Total_Cost__c, SDO_Total_Cost__c, Technology_Tools_Total_Cost__c, Voice_and_Data_Total_Cost__c, Mobilization_Total_Cost__c, Service_Management_Total_Cost__c, Support_Center_Total_Cost__c, Electronic_Doc_Management_Total_Cost__c, Command_Center_Total_Cost__c, OADM_Total_Cost__c, CFM_Total_Cost__c, CM_Total_Cost__c, QAD_Total_Cost__c,Pyramid_Richness_Year1__c, FTE_Range_new__c, Location_Definition__c, Languages__c , Onshore_Baseline_FTEs__c, Opportunity__r.Client_Geo_Area__r.Name, Opportunity__r.Operating_Group__c, Opportunity__r.Operating_Group__r.name, Opportunity__r.Activity__c, BPO_Net_Revenue_Range_new__c, Multi_Single_Offering__c,Offering_List__c,Number_of_rebadged_resources_from_client__c,Final_Month_FTEs__c FROM Opportunity_BenchMark_Data__c where Opportunity__c =:selectedOpportunity AND Client__c =:selectedClientName LIMIT 1];
        if(opportuintyRecord.size() > 0) {
            benchmarkRecord = opportuintyRecord[0];
            selectedGeoRegion = (benchmarkRecord.Opportunity__r.Client_Geo_Area__c == null)? 'None':benchmarkRecord.Opportunity__r.Client_Geo_Area__c ;
            selectedOperatingGroup = (benchmarkRecord.Opportunity__r.Operating_Group__c == null)? 'None':benchmarkRecord.Opportunity__r.Operating_Group__c;
            selectedReportingStatus = (benchmarkRecord.Opportunity__r.Activity__c == null)? 'None':benchmarkRecord.Opportunity__r.Activity__c;
            selectedBPONetRevenueRange = (benchmarkRecord.BPO_Net_Revenue_Range_new__c == null)? 'None':benchmarkRecord.BPO_Net_Revenue_Range_new__c;
            selectedMultiSingleOffering = (benchmarkRecord.Multi_Single_Offering__c == null)? 'None':benchmarkRecord.Multi_Single_Offering__c; 
            
            String allOffering=populateInScopeOff(benchmarkRecord.Offering_List__c);                
            selectedOffering = (allOffering.contains(';') || benchmarkRecord.Multi_Single_Offering__c == 'Multiple')? 'None1':allOffering;
            
            
            selectedFteRange =  (benchmarkRecord.FTE_Range_new__c == null)? 'None':benchmarkRecord.FTE_Range_new__c;
            selectedNoOfLanguage = (benchmarkRecord.no_of_languages__c == null)? 'None':benchmarkRecord.no_of_languages__c;
            selectedDeliveryLocation = (benchmarkRecord.Location_Definition__c == null)? 'None':benchmarkRecord.Location_Definition__c;
            
            opportunityDataWrapperDisplay= new OpportunityDataWrapperDisplay();
            
            opportunityDataWrapperDisplay.clientGeoAreaName = (benchmarkRecord.Opportunity__r.Client_Geo_Area__c == null)? 'None':benchmarkRecord.Opportunity__r.Client_Geo_Area__r.name ;
            opportunityDataWrapperDisplay.OperatingGroupName = (benchmarkRecord.Opportunity__r.Operating_Group__c == null)? 'None':benchmarkRecord.Opportunity__r.Operating_Group__r.name;
            opportunityDataWrapperDisplay.reportingStatus = (benchmarkRecord.Opportunity__r.Activity__c == null)? 'None':benchmarkRecord.Opportunity__r.Activity__c;
            opportunityDataWrapperDisplay.BPONetRevenue=(benchmarkRecord.BPO_Net_Revenue_Range_new__c == null)? 'None':benchmarkRecord.BPO_Net_Revenue_Range_new__c;
            opportunityDataWrapperDisplay.MultipleSingleOffering= (benchmarkRecord.Multi_Single_Offering__c == null)? 'None':benchmarkRecord.Multi_Single_Offering__c;
            
            if(benchmarkRecord.Multi_Single_Offering__c == 'Multiple'){
                opportunityDataWrapperDisplay.Offerings='  All';
            }else{
                opportunityDataWrapperDisplay.Offerings=allOffering;
            }
            opportunityDataWrapperDisplay.FTE=  (benchmarkRecord.FTE_Range_new__c == null)? 'None':benchmarkRecord.FTE_Range_new__c;
            opportunityDataWrapperDisplay.DeliveryLocation= (benchmarkRecord.Location_Definition__c == null)? 'None':benchmarkRecord.Location_Definition__c;
            opportunityDataWrapperDisplay.Languages= (benchmarkRecord.no_of_languages__c == null)? 'None':benchmarkRecord.no_of_languages__c;
        }
    }
    /******************************
    Method Name: populateOpportunityOnLoad
    Description: 
    Paramenters: 
    Return Value: 
    *******************************/ 
    private averageBnechmarkRecordWrapper MapOpportunityData(averageBnechmarkRecordWrapper averagebenchmarkRecordWrapperInstance1,Opportunity_benchmark_data__c benchmarkRecord, String YourDeal){       
        Decimal defaultVal=0.0;
        averagebenchmarkRecordWrapperInstance1.Name = YourDeal;
        
        if(benchmarkRecord!=null){ 
            averagebenchmarkRecordWrapperInstance1.clientNameId = benchmarkRecord.Client__c;
            averagebenchmarkRecordWrapperInstance1.clientName = benchmarkRecord.Client__r.Name;        
            averagebenchmarkRecordWrapperInstance1.opportunityId = benchmarkRecord.opportunity__c;
            averagebenchmarkRecordWrapperInstance1.opportunityName = benchmarkRecord.opportunity__r.Name;        
            averagebenchmarkRecordWrapperInstance1.OSLId = benchmarkRecord.Opportunity__r.Enterprise_Solution_Architect_New__c;
            averagebenchmarkRecordWrapperInstance1.OSLName = benchmarkRecord.Opportunity__r.Enterprise_Solution_Architect_New__r.Name;        
                        
            averagebenchmarkRecordWrapperInstance1.clientGeoArea = benchmarkRecord.Opportunity__r.Client_Geo_Area__r.Name;
            averagebenchmarkRecordWrapperInstance1.operatingGroup = benchmarkRecord.Opportunity__r.Operating_Group__r.Name;
            averagebenchmarkRecordWrapperInstance1.Activity = benchmarkRecord.Opportunity__r.Activity__c;
            averagebenchmarkRecordWrapperInstance1.pricingType = benchmarkRecord.Opportunity__r.Pricing_Type__c;
            averagebenchmarkRecordWrapperInstance1.TCV = benchmarkRecord.BPO_Net_Revenue__c;
            averagebenchmarkRecordWrapperInstance1.MobContigency = benchmarkRecord.Mobilization_Contingency__c;
            averagebenchmarkRecordWrapperInstance1.avgRunContigency = benchmarkRecord.Average_Run_Contingency__c;
            averagebenchmarkRecordWrapperInstance1.transCostContigency = benchmarkRecord.Transformation_Costs_consulting__c;  
            averagebenchmarkRecordWrapperInstance1.ciPercentage = (Decimal)benchmarkRecord.CI__c;
            averagebenchmarkRecordWrapperInstance1.contractDurationMob = (Decimal)benchmarkRecord.Contract_duration_MOB_DURATION__c;
            averagebenchmarkRecordWrapperInstance1.contractDuration = (Decimal)benchmarkRecord.Contract_duration_MOB_RUN__c ;
            averagebenchmarkRecordWrapperInstance1.NoOfLocation = (Decimal)benchmarkRecord.No_of_Locations__c;
            averagebenchmarkRecordWrapperInstance1.totalBaselineSDOFTEs = (Decimal)benchmarkRecord.TOTAL_Baseline_SDO_FTEs__c;
            averagebenchmarkRecordWrapperInstance1.onshoreNearshoreBaselineSDOFTE = (Decimal)benchmarkRecord.Onshore_Nearshore_Baseline_SDO_FTEs__c;            
            averagebenchmarkRecordWrapperInstance1.offshoreBaselineSDOFTE = (Decimal)benchmarkRecord.Offshore_Baseline_FTEs__c;            
            averagebenchmarkRecordWrapperInstance1.InScopeOfferings = populateInScopeOff(benchmarkRecord.Offering_List__c);
            averagebenchmarkRecordWrapperInstance1.offLevelData =populateOffLevelData(selectedOffering);             
            averagebenchmarkRecordWrapperInstance1.TotalCostWithoutContingency = (Decimal)benchmarkRecord.Grand_Total_Cost__c ;
            averagebenchmarkRecordWrapperInstance1.sdoTotalCost = (Decimal)benchmarkRecord.SDO_Total_Cost__c;
            
            averagebenchmarkRecordWrapperInstance1.TotalTechToolCost = (Decimal)benchmarkRecord.Technology_Tools_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalVDCost = (Decimal)benchmarkRecord.Voice_and_Data_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalMOBCost = (Decimal)benchmarkRecord.Mobilization_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalSerManagCost = (Decimal)benchmarkRecord.Service_Management_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalSupCentreCost = (Decimal)benchmarkRecord.Support_Center_Total_Cost__c;
            averagebenchmarkRecordWrapperInstance1.TotalEDMCost = (Decimal)benchmarkRecord.Electronic_Doc_Management_Total_Cost__c;
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
                
            if(benchmarkRecord.Average_total_payroll_costs_ons_nearshor__c!=null )
                averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOnshoreNearshoreFTE = (Decimal)benchmarkRecord.Average_total_payroll_costs_ons_nearshor__c;
            else
                averagebenchmarkRecordWrapperInstance1.averageTotalPayrollCostsOnshoreNearshoreFTE = defaultVal;
                
            if(benchmarkRecord.Pyramid_Richness_Year1__c!=null)
                averagebenchmarkRecordWrapperInstance1.pyramidRichnessYear1 = (Decimal)benchmarkRecord.Pyramid_Richness_Year1__c;
            else
                averagebenchmarkRecordWrapperInstance1.pyramidRichnessYear1 = defaultVal;
            
            if(benchmarkRecord.Overall_Productivity_Improvement_new__c!=null)
                averagebenchmarkRecordWrapperInstance1.overallProductivityImprovementPercentage = (Decimal)benchmarkRecord.Overall_Productivity_Improvement_new__c;
            else
                averagebenchmarkRecordWrapperInstance1.overallProductivityImprovementPercentage = defaultVal;
                
            if(benchmarkRecord.no_of_languages__c!=null)
                averagebenchmarkRecordWrapperInstance1.LanguagesInScope = benchmarkRecord.no_of_languages__c;        
                
            if(benchmarkRecord.TOTAL_Baseline_SDO_FTEs__c!=null)
                averagebenchmarkRecordWrapperInstance1.baselineFTEPrimaryOffering = (Decimal)benchmarkRecord.TOTAL_Baseline_SDO_FTEs__c;
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
          soql = 'select Id, Name, opportunity_benchmark_data__r.Client__c,Opportunity_benchmark_data__r.Offshore_Baseline_FTEs__c, opportunity_benchmark_data__r.Client__r.Name, opportunity_benchmark_data__r.Opportunity__r.Client_Geo_Area__r.Name, opportunity_benchmark_data__r.Opportunity__r.Operating_Group__r.Name, opportunity_benchmark_data__r.Opportunity__r.Activity__c, opportunity_benchmark_data__r.BPO_Net_Revenue__c, opportunity_benchmark_data__r.Transformation_Costs_consulting__c, opportunity_benchmark_data__r.Average_Run_Contingency__c, opportunity_benchmark_data__r.Mobilization_Contingency__c, opportunity_benchmark_data__r.opportunity__r.Name, opportunity_benchmark_data__r.Opportunity__r.Enterprise_Solution_Architect_New__r.Name, opportunity_benchmark_data__r.opportunity__c, opportunity_benchmark_data__r.Opportunity__r.Pricing_Type__c, opportunity_benchmark_data__r.Opportunity__r.Enterprise_Solution_Architect_New__c, opportunity_benchmark_data__r.CI__c, opportunity_benchmark_data__r.Contract_duration_MOB_DURATION__c, opportunity_benchmark_data__r.No_of_Locations__c, opportunity_benchmark_data__r.Offering_List__c, opportunity_benchmark_data__r.Contract_duration_MOB_RUN__c, opportunity_benchmark_data__r.TOTAL_Baseline_SDO_FTEs__c, opportunity_benchmark_data__r.Onshore_Nearshore_Baseline_SDO_FTEs__c, opportunity_benchmark_data__r.Grand_Total_Cost__c, opportunity_benchmark_data__r.SDO_Total_Cost__c, opportunity_benchmark_data__r.Technology_Tools_Total_Cost__c, opportunity_benchmark_data__r.Voice_and_Data_Total_Cost__c, opportunity_benchmark_data__r.Mobilization_Total_Cost__c, opportunity_benchmark_data__r.Service_Management_Total_Cost__c, opportunity_benchmark_data__r.Support_Center_Total_Cost__c, opportunity_benchmark_data__r.Electronic_Doc_Management_Total_Cost__c, opportunity_benchmark_data__r.Command_Center_Total_Cost__c, opportunity_benchmark_data__r.OADM_Total_Cost__c, opportunity_benchmark_data__r.CFM_Total_Cost__c, opportunity_benchmark_data__r.CM_Total_Cost__c, opportunity_benchmark_data__r.QAD_Total_Cost__c, opportunity_benchmark_data__r.Overall_Productivity_Improvement_new__c, Language_in_scope__c, Average_of_Pyramid_Richness_Year_1__c, No_of_Headcounts__c, Offshore_Baseline_FTEs__c, Sum_of_Baseline_FTEs__c, Onshore_Nearshore_Baseline_SDO_FTEs__c, Average_total_payroll_costs_FTE__c, Average_total_payroll_costs_off_shore__c, Average_total_payroll_costs_Onshore__c, Overall_Productivity_Improvement__c from BenchMark_offering__c where Id != null And opportunity_benchmark_data__r.Include_in_BenchMark_Report__c = True And opportunity_benchmark_data__r.Opportunity__c != :selectedOpportunity '+'And Name LIKE \''+'%'+String.escapeSingleQuotes(selectedOffering)+'%\'';         
            system.debug('In Offering Query Block');
            if (!selectedGeoRegion.equals('None'))
              soql += ' and Opportunity_BenchMark_Data__r.Opportunity__r.Client_Geo_Area__c = \''+String.escapeSingleQuotes(selectedGeoRegion)+'\'';
            if (!selectedOperatingGroup.equals('None'))
              soql += ' and Opportunity_BenchMark_Data__r.Opportunity__r.Operating_Group__c = \''+String.escapeSingleQuotes(selectedOperatingGroup)+'\'';
            if (!selectedBPONetRevenueRange.equals('None'))
              soql += ' and Opportunity_BenchMark_Data__r.BPO_Net_Revenue_Range_new__c = \''+String.escapeSingleQuotes(selectedBPONetRevenueRange)+'\'';
            if (!selectedMultiSingleOffering.equals('None'))
              soql += ' and Opportunity_BenchMark_Data__r.Multi_Single_Offering__c = \''+String.escapeSingleQuotes(selectedMultiSingleOffering)+'\'';
            if (!selectedReportingStatus.equals('None'))
              soql += ' and Opportunity_BenchMark_Data__r.Opportunity__r.Activity__c = \''+String.escapeSingleQuotes(selectedReportingStatus)+'\'';
            if (!selectedFteRange.equals('None'))
              soql += ' and FTE_Range__c = \''+String.escapeSingleQuotes(selectedFteRange)+'\'';
            if (!selectedDeliveryLocation.equals('None'))
              soql += ' and Location_Definition__c = \''+String.escapeSingleQuotes(selectedDeliveryLocation)+'\'';
            if (!selectedNoOfLanguage.equals('None'))
              soql += ' and Language_in_scope__c = \''+String.escapeSingleQuotes(selectedNoOfLanguage)+'\'';         
              
             soql =soql+ ' '+ whereClause +' ORDER BY name DESC';
            system.debug('SOQL' + soql); 
            return soql; 
    }
    /******************************
        Method Name: opportunityLevelQuery
        Description: 
        Paramenters: 
        Return Value: 
        *******************************/
    private String opportunityLevelQuery(){       
           soql = 'select Id, Name, Client__c, Client__r.Name,Opportunity__r.Client_Geo_Area__r.Name, Opportunity__r.Operating_Group__r.Name, Opportunity__r.Activity__c, BPO_Net_Revenue__c, Transformation_Costs_consulting__c, Average_Run_Contingency__c, Mobilization_Contingency__c, opportunity__r.Name, Opportunity__r.Enterprise_Solution_Architect_New__r.Name, opportunity__c, Opportunity__r.Pricing_Type__c, Opportunity__r.Enterprise_Solution_Architect_New__c, CI__c, Contract_duration_MOB_DURATION__c, No_of_Locations__c,Offering_List__c, Contract_duration_MOB_RUN__c, Onshore_Nearshore_Baseline_SDO_FTEs__c, Grand_Total_Cost__c, SDO_Total_Cost__c, Technology_Tools_Total_Cost__c, Voice_and_Data_Total_Cost__c, Mobilization_Total_Cost__c, Service_Management_Total_Cost__c, Support_Center_Total_Cost__c, Electronic_Doc_Management_Total_Cost__c, Command_Center_Total_Cost__c, OADM_Total_Cost__c, CFM_Total_Cost__c, CM_Total_Cost__c, QAD_Total_Cost__c,    Overall_Productivity_Improvement_new__c, Pyramid_Richness_Year1__c, Average_total_payroll_costs_FTE__c, Offshore_Baseline_FTEs__c, Average_total_payroll_costs_off_shore__c, Average_total_payroll_costs_ons_nearshor__c, no_of_languages__c, TOTAL_Baseline_SDO_FTEs__c, Onshore_Baseline_FTEs__c, Number_of_rebadged_resources_from_client__c,Final_Month_FTEs__c from Opportunity_BenchMark_Data__c where Id != null And Include_in_BenchMark_Report__c = True And Opportunity__c != :selectedOpportunity ';         
            system.debug('In Opportunity Query Block');
            if (!selectedGeoRegion.equals('None')){
              whereClause += ' and Opportunity__r.Client_Geo_Area__c = \''+String.escapeSingleQuotes(selectedGeoRegion)+'\'';
              //soql += ' and Opportunity__r.Client_Geo_Area__c = \''+String.escapeSingleQuotes(selectedGeoRegion)+'\'';
              }
            if (!selectedOffering.equals('None') && !selectedOffering.equals('None1'))
              {
              whereClause += ' and Offering_List__c LIKE \''+'%'+String.escapeSingleQuotes(selectedOffering)+'%\''; }
            if (!selectedOperatingGroup.equals('None'))
              whereClause += ' and Opportunity__r.Operating_Group__c = \''+String.escapeSingleQuotes(selectedOperatingGroup)+'\'';
            if (!selectedFteRange.equals('None'))
              whereClause += ' and FTE_Range_new__c = \''+String.escapeSingleQuotes(selectedFteRange)+'\'';
            if (!selectedReportingStatus.equals('None'))
              whereClause += ' and Opportunity__r.Activity__c = \''+String.escapeSingleQuotes(selectedReportingStatus)+'\'';
            if (!selectedDeliveryLocation.equals('None'))
              whereClause += ' and Location_Definition__c = \''+String.escapeSingleQuotes(selectedDeliveryLocation)+'\'';
            if (!selectedBPONetRevenueRange.equals('None'))
              whereClause += ' and BPO_Net_Revenue_Range_new__c = \''+String.escapeSingleQuotes(selectedBPONetRevenueRange)+'\'';
            if (!selectedMultiSingleOffering.equals('None'))
              whereClause += ' and Multi_Single_Offering__c = \''+String.escapeSingleQuotes(selectedMultiSingleOffering)+'\'';
            if (!selectedNoOfLanguage.equals('None'))
              whereClause += ' and no_of_languages__c = \''+String.escapeSingleQuotes(selectedNoOfLanguage)+'\'';
              
             soql =soql+ ' '+ whereClause +' ORDER BY name DESC';
            system.debug('SOQL' + soql);
            return soql;  
    }

}