/**
   @Author : Jayashree Pradhan
   @name   : AP01_OpportunityDeliveryLocation_TEST
   @CreateDate : 1 January 2015 
   @Description : TriggerHandler test Class for triggers on OpportunityDeliverylocation object
   @Version : 1.0 
  */
@isTest
private class AP01_OpportunityDeliveryLocation_TEST {
    private static Opportunity opp;
    private static Solution_Scope__c solCompBPO;
    private static List<Opportunity_Delivery_Location__c> oppDeliveryList = new List<Opportunity_Delivery_Location__c>();

    /**
   *  @Description : This method is used to create test data
   *  @name : init
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
    private static void init(){
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        insert offProc;
        
        Services_Master__c sm = new Services_Master__c();
        sm.Name = 'Test';
        sm.offering__c = offProc.id;
        sm.active__c = true;
        sm.Solution_Component__c = 'Delivery';
        sm.Is_Offering_Specific_Service__c = true;
        sm.Service_Group__c = 'BPO'; 
        insert sm;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        insert opp; 
        
        solCompBPO = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = offProc.id, 
                                        SAP_Offering_Revenue__c = 20);
        insert solCompBPO; 
        
       Service__c serviceRec =[Select id from Service__c where Solutionscope__c =: solCompBPO.id LIMIT 5000];
       //System.debug('--------serviceRec-------------'+serviceRec);
       
       
        Geo_Region_Master__c geoRegion = new Geo_Region_Master__c(Name = UTIL_Constants.AsiaPacific,Active__c = true);
            insert geoRegion;
            
        Country_Master__c countryMaster = new Country_Master__c(Name = 'India',Geo_Region__c =geoRegion.id,active__c =true);
            insert countryMaster;
            
        Delivery_Location_Masters__c deliveryLocMaster = new Delivery_Location_Masters__c(
                                                            Name = 'Bangalore',country__c = countryMaster.id,
                                                            delivery_location_description__c = 'test desc',
                                                            active__c=true);
        insert deliveryLocMaster;
            
         Opportunity_Delivery_Location__c  oppDeliverylocation = new Opportunity_Delivery_Location__c(Offering_Service__c = serviceRec.id,
                                                                    Delivery_Location__c = deliveryLocMaster.id);
            oppDeliveryList.add(oppDeliverylocation);
            insert oppDeliveryList;
            
       //System.debug('******&&&&&^^^^^^'+oppDeliveryList);
    }
    
    
    /**
   *  @Description : This method is used to test whether deliveryLocation is getting updated in opportunity
                        delivery Location
   *  @name : testOppDeliveryLocUpdate
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
    static testMethod void testOppDeliveryLocUpdate() {
        init();
        test.starttest();
        //AP01_OpportunityDeliveryLocation.updateOppDeliveryLocation(oppDeliveryList);
        test.stopTest();
    }
/**
   *  @Description : This method is used to test whether duplicate deliveryLocation is getting updated in opportunity
                        delivery Location
   *  @name : testpreventDuplicateDeliveryLoc
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
   /* test method to test preventDuplicateDeliveryLoc class */
    static testMethod void testpreventDuplicateDeliveryLoc() {
        List<Opportunity_Delivery_Location__c> deliveryLocList = new List<Opportunity_Delivery_Location__c>();
        Opportunity opp1;
        Solution_Scope__c solCompBPO1;
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        insert offProc;
        
        Services_Master__c sm = new Services_Master__c();
        sm.Name = 'Test';
        sm.offering__c = offProc.id;
        sm.active__c = true;
        sm.Solution_Component__c = 'Delivery';
        sm.Is_Offering_Specific_Service__c = true;
        sm.Service_Group__c = 'BPO'; 
        insert sm;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        opp1 = new Opportunity();
        
        opp1.Reporting_Status__c = UtilConstants.WON;
        opp1.Geo_Area__c = UtilConstants.EALA;
        opp1.OperatingGroup__c = ogm.id;
        opp1.StageName = UtilConstants.TWO_B;
        opp1.Risk_Level__c = UtilConstants.NORMAL;
        opp1.CloseDate = System.today();
        opp1.Name = UtilConstants.TEST_OPP;
        insert opp1; 
        
        solCompBPO1 = new Solution_Scope__c(Active__c = True, Opportunity__c = opp1.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = offProc.id, 
                                        SAP_Offering_Revenue__c = 20);
        insert solCompBPO1; 
        
       Service__c serviceRec =[Select id from Service__c where Solutionscope__c =: solCompBPO1.id LIMIT 5000];
       //System.debug('--------serviceRec-------------'+serviceRec);
       
       
        Geo_Region_Master__c geoRegion = new Geo_Region_Master__c(Name = UTIL_Constants.AsiaPacific,Active__c = true);
            insert geoRegion;
            
        Country_Master__c countryMaster = new Country_Master__c(Name = 'India',Geo_Region__c =geoRegion.id,active__c =true);
            insert countryMaster;
            
        Delivery_Location_Masters__c deliveryLocMaster = new Delivery_Location_Masters__c(
                                                            Name = 'Bangalore',country__c = countryMaster.id,
                                                            delivery_location_description__c = 'test desc',
                                                            active__c=true);
        insert deliveryLocMaster;
            
       Opportunity_Delivery_Location__c oppDeliverylocation = new Opportunity_Delivery_Location__c(Offering_Service__c = serviceRec.id,
                                                                    Delivery_Location__c = deliveryLocMaster.id);
        
        Opportunity_Delivery_Location__c oppDeliverylocationOne = new Opportunity_Delivery_Location__c(Offering_Service__c = serviceRec.id,
                                                                    Delivery_Location__c = deliveryLocMaster.id);
            deliveryLocList.add(oppDeliverylocation);
            deliveryLocList.add(oppDeliverylocationOne);
            
            
            insert deliveryLocList;
        test.starttest();
        AP01_OpportunityDeliveryLocation.validateDeliveryLocation(deliveryLocList);
        test.stopTest();
    }
    
    
     static testMethod void testrestrictDeliveryLocationupdate() {
     init();
     Geo_Region_Master__c geoRegion = new Geo_Region_Master__c(Name = UTIL_Constants.AsiaPacific,Active__c = true);
            insert geoRegion;
            
        Country_Master__c countryMaster = new Country_Master__c(Name = 'India',Geo_Region__c =geoRegion.id,active__c =true);
            insert countryMaster;
      Delivery_Location_Masters__c deliveryLocMaster = new Delivery_Location_Masters__c(
                                                            Name = 'Pune',country__c = countryMaster.id,
                                                            delivery_location_description__c = 'test desc',
                                                            active__c=true);
        insert deliveryLocMaster;
      Opportunity_Delivery_Location__c oppDeliverylocationRec=new  Opportunity_Delivery_Location__c();
     for( Opportunity_Delivery_Location__c del:oppDeliveryList ){
     oppDeliverylocationRec=del;
     oppDeliverylocationRec.Delivery_Location__c=deliveryLocMaster.id;
      }
      test.starttest();
      update oppDeliverylocationRec;
      test.stopTest();
     
     
     }
    
}