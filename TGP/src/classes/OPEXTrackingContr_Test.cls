@isTest
/**
    *@Author :   
    *@Description:Test Class     
    *@name:OPEXTrackingContr_Test        
    *@param:      
    */ 
public class OPEXTrackingContr_Test {

    
    
    private static Wave__c wav_Obj;
    private static Delivery_Location_Masters__c deliverylocMaster1;
/**
    *@Author : 
    *@Description:method to setup data.     
    *@name:loadData        
    *@param:      
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
    *@Author :     
    *@Description: testmethod for setup data
    *@name:testOpexContrlr        
    *@param:      
    */    
    public  static testMethod void testOpexContrlr(){
        
        loadData();
        OPEX_Tracker__c opex;
        opex= new OPEX_Tracker__c(Wave__c =wav_Obj.Id, name = 'Test Opex',Days_After_Go_Live__c =32 );
        insert opex;
        PageReference opexPage= new Pagereference('/apex/OPEXTrackingItemEdit?id='+ opex.id);
        test.setCurrentPage(opexPage);
        ApexPages.StandardController stdCon= new ApexPages.StandardController(opex);
        OPEXTrackingContr opexCon = new OPEXTrackingContr (stdCon);
        OPEXTrackingContr.getData('Ind');
        opexCon.saveRecord();
        //opexPage.refreshPg();
        
        
        opex= new OPEX_Tracker__c(Wave__c =wav_Obj.Id );
        PageReference opexPageErr= new Pagereference('/apex/OPEXTrackingItemEdit');
        test.setCurrentPage(opexPageErr);
        ApexPages.StandardController stdConErr= new ApexPages.StandardController(opex);
        OPEXTrackingContr opexConErr = new OPEXTrackingContr (stdConErr);
        OPEXTrackingContr.getData('Ind');
        
        opexConErr.saveRecord();
        
        
        opex= new OPEX_Tracker__c(Wave__c =wav_Obj.Id, name = 'Test Opex',Days_After_Go_Live__c =32, Location__c = deliverylocMaster1.id );
        PageReference opexPageSuccess= new Pagereference('/apex/OPEXTrackingItemEdit');
        test.setCurrentPage(opexPageSuccess);
        ApexPages.StandardController stdConSuccess= new ApexPages.StandardController(opex);
        OPEXTrackingContr opexConSuccess = new OPEXTrackingContr (stdConSuccess);
        //OPEXTrackingContr.getData('Ind');
        //opexConErr.opexTracker.Location__c = deliverylocMaster1.id;
        opexConSuccess.saveRecord();
    }
}