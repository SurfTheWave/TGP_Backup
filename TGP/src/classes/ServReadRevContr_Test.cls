@isTest
/**
   *  @Description : 
   *  @name : ServReadRevContr_Test
   *  @param : 
   *  @return parameter - void
   *  @throws exception- null
   */    
public class ServReadRevContr_Test {
      private static Wave__c wav_Obj;
    private static Delivery_Location_Masters__c deliverylocMaster1;
/**
   *  @Description : 
   *  @name : loadData
   *  @param : 
   *  @return parameter - void
   *  @throws exception- null
   */       
    public static void loadData(){
        Deal__c strDeal;
        Mobilization_Plan__c strmobplan;
        User testUser; 
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
          
        //OPEX_Master__c om = new OPEX_Master__c(Name= 'Day 7 Assessment', Days_After_Go_Live__c = 5,Active__c = TRUE);
        //insert om;
        
        strDeal  = new Deal__c(Name='DealTest123');
        insert strDeal;
        
        List<Mobilization_Plan__c> bcpMobPlans = new List<Mobilization_Plan__c>();        
        strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, IsTrackingOn__c = False, Service_Group__c = 'BPO' );
        insert strmobplan;
        //bcpMobPlans.add(strmobplan );
        
        wav_Obj=new Wave__c(Name='testWave', Mobilization_Plan__c=strmobplan.id, Active__c=True);
        insert wav_Obj;
        
        
        Geo_Region_Master__c geoApac=new Geo_Region_Master__c(name='APAC',active__c=true);
        insert geoApac;
        Country_Master__c countryApac=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geoApac.id);
        insert countryApac;
        
        deliverylocMaster1 =new Delivery_Location_Masters__c(name='Ind - bangalore',active__c=true,country__c=countryApac.id);
        
        insert deliverylocMaster1;
    }
    
    
/**
   *  @Description : 
   *  @name : testsratContrlr
   *  @param : 
   *  @return parameter - void
   *  @throws exception- null
   */      
    public  static testMethod void testsratContrlr(){
        
        loadData();
        SRAT_Tracker__c srat;
        srat= new SRAT_Tracker__c(Wave__c =wav_Obj.Id, name = 'Test srat',Days_Before_Go_Live__c =32 );
        insert srat;
        PageReference sratPage= new Pagereference('/apex/ServiceReadinessReviewItemEdit?id='+ srat.id);
        test.setCurrentPage(sratPage);
        ApexPages.StandardController stdCon= new ApexPages.StandardController(srat);
        ServReadRevContr sratCon = new ServReadRevContr (stdCon);
        ServReadRevContr.getData('Ind');
        sratCon.saveRecord();
        //opexPage.refreshPg();
        
        
        srat= new SRAT_Tracker__c(Wave__c =wav_Obj.Id );
        PageReference sratPageErr= new Pagereference('/apex/ServiceReadinessReviewItemEdit');
        test.setCurrentPage(sratPageErr);
        ApexPages.StandardController stdConErr= new ApexPages.StandardController(srat);
        ServReadRevContr sratConErr = new ServReadRevContr (stdConErr);
        ServReadRevContr.getData('Ind');
        
        sratConErr.saveRecord();
        
        
        srat= new SRAT_Tracker__c(Wave__c =wav_Obj.Id, name = 'Test srat',Days_Before_Go_Live__c =32, Location__c = deliverylocMaster1.id );
        PageReference sratPageSuccess= new Pagereference('/apex/ServiceReadinessReviewItemEdit');
        test.setCurrentPage(sratPageSuccess);
        ApexPages.StandardController stdConSuccess= new ApexPages.StandardController(srat);
        ServReadRevContr sratConSuccess = new ServReadRevContr (stdConSuccess);
        //OPEXTrackingContr.getData('Ind');
        //opexConErr.opexTracker.Location__c = deliverylocMaster1.id;
        sratConSuccess.saveRecord();
    }
}