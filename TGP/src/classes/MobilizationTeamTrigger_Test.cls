/*      
@name : MobilizationTeamTrigger_Test        
@Description :      
@Version :      
*/
@isTest(SeeAllData=false)
private class MobilizationTeamTrigger_Test{
    /*      
    @name : test1       
    @Description :      
    @Version :      
    */
    static testMethod void test1(){
        test.starttest();
        
        List<User_Master__c> MasterList= new List<User_Master__c>();
        
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        MasterList.add(UserMasterRef0);
        User_Master__c UserMasterRef1= new User_Master__c();
        UserMasterRef1.Name = 'UserMasterTest1';
        MasterList.add(UserMasterRef1);
        User_Master__c UserMasterRef2= new User_Master__c();
        UserMasterRef2.Name = 'UserMasterTest2';
        MasterList.add(UserMasterRef2);
       // User_Master__c UserMasterRef3= new User_Master__c();
       // UserMasterRef3.Name = 'UserMasterTest3';
      //  MasterList.add(UserMasterRef3);
        
        Insert MasterList;
        
          Deal__c strDeal = new Deal__c(Name='DealTest123', Approval_Status__c = 'Approved');
        insert strDeal;
        
        Deal__c dealTwo=new Deal__C(Name='DealTwo',Approval_Status__C='Pending');
        insert dealtwo;
        //inserting New Plan under Deal.
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id);
        //Database.Insert(strmobplan,false);
        insert strmobplan;
                        
        //Inserting new Wave        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today());
        insert strWave;
        
        Geo_Region_Master__c geoRegion = new Geo_Region_Master__c(Name = UTIL_Constants.AsiaPacific,Active__c = true);
        insert geoRegion;
        
        Country_Master__c countryMaster = new Country_Master__c(Name='IN', Geo_Region__c = geoRegion.Id);
        insert countryMaster;
        
         Delivery_Location_Masters__c deliveryLocMaster = new Delivery_Location_Masters__c(Name = UtilConstants.BANGALORE,country__c = countryMaster.id,
                                                                                        delivery_location_description__c = UtilConstants.TEST_DESC,
                                                                                        active__c=true);
        insert deliveryLocMaster;
        
        Mobilization_Team__c MTeamRef = new Mobilization_Team__c();
        MTeamRef.Role__c = '';
        MTeamRef.Primary_Lead__c = MasterList[0].Id ;
        MTeamRef.Active__c = true;
        MTeamRef.Wave__c = strWave.Id;
        
        MTeamRef.Secondary_Lead_1__c = MasterList[1].Id ;
        MTeamRef.Secondary_Lead_2__c = MasterList[2].Id ;
       
        Insert MTeamRef ;
        MTeamRef.Deal__c = strDeal.Id;
        MTeamRef.Role__c = 'Technology Lead';
        Update MTeamRef;
        
        MTeamRef.Secondary_Lead_2__c = MasterList[1].Id ;
        MTeamRef.Secondary_Lead_1__c = MasterList[0].Id ;
        MTeamRef.Primary_Lead__c = MasterList[2].Id ;
        Update MTeamRef;
        
        
        Delete MTeamRef ;
        
        Mobilization_Team__c MobTeam = new Mobilization_Team__c();
        MTeamRef.Primary_Lead__c = MasterList[2].Id ;
        MobTeam.Role__c = 'Global Transition Lead';
        MobTeam.Deal__c=strDeal.Id;
        
        Mobilization_Team__c MobTeamOne = new Mobilization_Team__c();
        MTeamRef.Primary_Lead__c = MasterList[2].Id ;
        MobTeamOne.Role__c = 'Commercial Lead';
        MobTeamOne.Deal__c=strDeal.Id;
        
        
        test.stoptest();
    }
    
}