@isTest
private class Maintain_HistoryTest
{
   static User testUser;
    static Deal_TGP__c strDealTGP;
    static Wave_Plan_Version__c strWavePlanVersion;
    static Deal_Location__c strDealLocation;
    static Wave_Planning__c strWavePlanning;
    static SRAT__c strSRAT;
    
    public static void setupData()
    {
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        strDealTGP=new Deal_TGP__c(Name='DealTest123');
        insert strDealTGP;
        
        strWavePlanVersion =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=strDealTGP.id);
        insert strWavePlanVersion;   
        
        strDealLocation=new Deal_Location__c(Wave_Plan_Version__c=strWavePlanVersion .id, Deployment_Lead__c=testUser.id);
        insert strDealLocation;
        
        
        strWavePlanning=new Wave_Planning__c(Wave_Label__c='waveTest', Number_of_Projected_FTEs__c=1,GO_Live_Date_del__c=System.today()+1, Deal_Location__c=strDealLocation.id, Mobilization_Recruitment_Lead_Primary__c=testUser.id, KT_Lead__c=testUser.id,Mobilization_Technology_Lead_Secondary__c=testUser.id, Mobilization_Opex_Lead_Primary__c=testUser.id );
        insert strWavePlanning;
        
        strSRAT=new SRAT__c(Name='TestSrat', Planned_Date__c=System.today()+1, Deal_Location_lk__c=strDealLocation.id, Wave_Plan_lk__c=strWavePlanning.id, 
        Wave_Plan_Version__c=strWavePlanVersion.id, Item__c='SRAT T-90', Completed__c = 'Yes',Actual_Date__c=date.valueof('2013-10-16'),Individual_Plan_RAG_Status__c='Green');
        insert strSRAT;
        
        strSRAT = [select id, Completed__c,Actual_Date__c, Individual_Plan_RAG_Status__c from SRAT__c where Name='TestSrat' and Item__c='SRAT T-90'];
        strSRAT.Completed__c = 'No';
        strSRAT.Actual_Date__c=date.valueof('2013-10-31');
        strSRAT.Individual_Plan_RAG_Status__c='Green';
        update strSRAT;
       
       SRAT__History sratHst = new  SRAT__History(ParentId =strSRAT.Id, Field='Actual_Date__c' );
       insert  sratHst;    
}
    
      static testMethod void testMaintain_History()
    {
        setupData();
        Test.startTest();
        PageReference pageRef= Page.MaintainHistory;
        Test.setCurrentPageReference(pageRef);
        DateTime dateVal=DateTime.now();
        DateTime dateValNew=dateVal+1;
        pageRef.getParameters().put('ObjName', 'SRAT__c');
        pageRef.getParameters().put('ID',strSRAT.id );
        pageRef.getParameters().put('Field1', 'Completed__c');
        pageRef.getParameters().put('Field2', 'Actual_Date__c');
        pageRef.getParameters().put('Field3', 'Individual_Plan_RAG_Status__c');
        pageRef.getParameters().put('Field4', '');
        pageRef.getParameters().put('Field5', '');
        
        try{
            Maintain_History myHistory = new Maintain_History ();
        }catch(Exception ex){
        }
        
        Maintain_History.HistoryInfo hist = new Maintain_History.HistoryInfo('Actual_Date__c',String.valueof(dateVal),String.valueof(dateVal),'System',String.valueof(dateVal));
                
        Test.stopTest();
        
    }
}