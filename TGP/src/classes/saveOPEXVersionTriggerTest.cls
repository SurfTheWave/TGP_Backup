@isTest
private class saveOPEXVersionTriggerTest{

    static OPEX__c opex;
    static Wave_Plan_Version__c wave;
    static Deal_TGP__c dealTGP;
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c delivery;
    static Client_Geo_Area_Master__c clientGeo;
    static Deal_Location__c deal;
    static Wave_Planning__c waveplan;

    static testMethod void test1(){
    
        clientGeo = new Client_Geo_Area_Master__c();
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
    
        dealTGP =new Deal_TGP__c();
        dealTGP.Name='Test Data';
        insert dealTGP;
    
        wave =new Wave_Plan_Version__c();
        wave.Display_tracking_message__c='Tracking is On';
        wave.active__c=true;
        wave.Deal__c=dealTGP.id;
        insert wave;
        
        delivery =new Delievery_Location_Master__c();
        delivery.Delivery_Location_Description__c='testdata';
        delivery.Name='TestData';
        delivery.Client_Geo_Area_Master__c=clientGeo.id;
        insert delivery; 
        
        dealHome =new Deal_Home_Location__c(); 
        dealHome.Delivery_Location_Master__c=delivery.id;
        dealHome.Deal__c= dealTGP.id;
        insert dealHome;
        
        deal= new Deal_Location__c();
        deal.Location__c='test Data';
        deal.Deal_Home_Location__c=dealHome.id;
        deal.Wave_Plan_Version__c=wave.id;
        insert deal;
        
        waveplan =new Wave_Planning__c();
        waveplan.Wave_Comment__c='test data';
        waveplan.Wave_Label__c='TestData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Deal_Location__c=deal.id;
        waveplan.Number_of_Projected_FTEs__c=1;
        insert waveplan; 
    
        opex =new OPEX__c();
        opex.Deal_Location_lk__c=deal.id;
        opex.Wave_Plan_lk__c=waveplan.id;
        opex.Item__c='Day 30 Assessment';
        opex.Active__c=true;
        opex.Planned_Date__c=date.today();
        opex.Deal_Location__c='India';
        //opex.Deal_Location_lk__c=deal.id;
        opex.Wave_Plan_Version__c=wave.id;
        opex.Is_Submitted__c = false;
        insert opex;
       
        OPEX_Version__c obj = new OPEX_Version__c(isActive__c=true);
        insert obj;
        
        
        OPEX_Version__c objNew = new OPEX_Version__c(isActive__c=true);
        insert objNew;
        
        obj.isActive__c=false;
        update obj;
        
        OPEX_User_Section_Question__c obj1 = new OPEX_User_Section_Question__c(OPEX_Version__c = objNew.id,OPEX__c= opex.id);
        insert obj1;
    }


}