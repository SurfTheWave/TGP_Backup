@isTest

private class Location_DealUserAssignedControllerTest{

    static Deal_Location__c dealLoc;
    static Wave_Plan_Version__c wavPlanVer;
    static Deal_TGP__c deal;
    
    public static void setupData(){

    deal = new Deal_TGP__c();
    insert deal;
    wavPlanVer = new Wave_Plan_Version__c(Deal__c=deal.Id);
    insert wavPlanVer;
    dealLoc = new Deal_Location__c(Wave_Plan_Version__c=wavPlanVer.Id);
    insert dealLoc;
   }
    
    
    static testMethod void testdata(){
        
        test.starttest();
        
        setupData();
        ApexPages.currentPage().getParameters().put('Id', deal.Id);
        ApexPages.StandardController controller=new ApexPages.standardController(deal);
        Location_DealUserAssignedController Location=new Location_DealUserAssignedController(controller);     
        Location.LoadData();
        Location.edit();
        Location.refreshPage();
        Location.cancel();
        Location.save();
        
        test.stoptest(); 
   }
    
 }