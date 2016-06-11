@isTest

private class Wave_DealUserAssignedControllerTest{

    static Deal_Location__c dealLoc;
    static Wave_Plan_Version__c wavPlanVer;
    static Wave_Planning__c wavPlanning;
    static Deal_TGP__c deal;
    
    public static void setupData(){

    deal = new Deal_TGP__c();
    insert deal;
    wavPlanVer = new Wave_Plan_Version__c(Deal__c=deal.Id);
    insert wavPlanVer;
    dealLoc = new Deal_Location__c(Wave_Plan_Version__c=wavPlanVer.Id);
    insert dealLoc;
    date myDate = date.today();
    wavPlanning = new Wave_Planning__c(Deal_Location__c=dealLoc.Id, GO_Live_Date_del__c=myDate, Wave_Label__c ='testLabel'); 
    insert wavPlanning;


   }
    
    
    static testMethod void testdata(){
        
        test.starttest();
        
        setupData();
        ApexPages.currentPage().getParameters().put('Id', deal.Id);
        ApexPages.StandardController controller=new ApexPages.standardController(deal);
        Wave_DealUserAssignedController Wave=new Wave_DealUserAssignedController(controller);     
        Wave.LoadData();
        Wave.edit();
        Wave.refreshPage();
        Wave.cancel();
        Wave.save();
        
        test.stoptest(); 
   }
    
 }