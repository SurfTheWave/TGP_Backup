@isTest(SeeAlldata= false)
private class UserAccessUtilityTest{

    static MOB_User_Role_Assignment__c strMoURA;
    static Mob_User_Roles_Master__c strMoURM;
    static Deal_TGP__c deal;
    static List<Deal_TGP__c> dealList;
    static List<MOB_User_Role_Assignment__c> lstUserRoleAssign;
    static User testUser; 
    static User testUser1;
    static UAM_Roles_Permissions__c rolePerec;
     static UAM_Roles_Permissions__c rolePerec1;
     static Deal_Location__c dealLoc;
     static List<Deal_Location__c> dealLocList;
      static  Deal_Home_Location__c dealHome ;
      static Wave_Plan_Version__c wavePlanVersion3;
      static  Delievery_Location_Master__c deliveryLocMa ;
      static Client_Geo_Area_Master__c clientGeo;
      static  Wave_Planning__c waveplan ;
      static  List<Wave_Planning__c> waveplanList;
      static Opportunity_TGP__c oppTGP;
      static List<Opportunity_TGP__c> oppTGPList;
      static Opportunity_Offering__c oppOffering;
      static List<Opportunity_Offering__c> oppOfferingList;
      static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   public static final string USER_NAME = 'vc123@testorg.com';
   static Set<Id> setId = new Set<Id>();
   static Review_User_Master__c objReviewUser;
   static Review_User_Master__c objReviewUser1;
   static Review_Process__c rProcess;
   static Request_Review__c objRequestReview;
   static List<Request_Review__c> objRequestReviewList = new List<Request_Review__c>();
   static Review_Type_Master__c  objReviewTypeMaster;
   static Review_Action_Item_Log__c rAIL;
   static Review_Action_Item_Log__c rAIL1;
   static List<Review_Action_Item_Log__c> rAILList =  new List<Review_Action_Item_Log__c>();
   static Document doc;
   static Deal_Track__c dealTrackObj;
    static List<Deal_Track__c> dealTrackList;
    static Opportunity_Team__c oppTeamObj;
    static List<Opportunity_Team__c> oppTeamList;
     
     public static void setupData(){
     
         dealList = new List<Deal_TGP__c>();
         dealLocList = new List<Deal_Location__c>();
         oppTGPList = new List<Opportunity_TGP__c>();
         lstUserRoleAssign =  new List<MOB_User_Role_Assignment__c>();
         dealTrackList =  new List<Deal_Track__c>();
         
         
         Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
          Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
         testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
         Database.insert(testUser, false);
         
         testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_NAME);
         Database.insert(testUser1, false);
     
          clientName = new Client_Master__c (Name = 'TestObject1');
        insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
      insert clientGeoUnit;
     
         //oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Risk_Level__c='Low', Expected_contract_sign_qtr__c='FY12-Q4' ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id , Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',Link_to_Additional_Documents__c='http://google.com');

        //insert oppTGP;
        
         oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser1.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
        insert oppTGP;
        oppTGPList.add(oppTGP);
        
        rProcess=new Review_Process__c();
        rProcess.BPO_Opportunity__c=oppTGP.id;
        insert rProcess;            
        
        objReviewUser= new Review_User_Master__c();
        objReviewUser.Email_ID_of_the_reviewer__c = testUser1.Email;
        objReviewUser.Name='reviewUaser2';
        objReviewUser.SFDC_User__c = testUser1.Id;
        insert objReviewUser;
        
     objReviewUser1= new Review_User_Master__c();
        objReviewUser1.Email_ID_of_the_reviewer__c = testUser1.Email;
        objReviewUser1.Name='reviewUaser2';
        objReviewUser1.SFDC_User__c = testUser.id;
        objReviewUser.Is_Active__c = true;
        insert objReviewUser1;
        
        objReviewUser= new Review_User_Master__c();
        objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;
        objReviewUser.Name='reviewUaser';
        objReviewUser.SFDC_User__c = testUser1.Id;
        objReviewUser.Is_Active__c = true;
        insert objReviewUser;
       
        objReviewTypeMaster=new Review_Type_Master__c(Name= 'Final Approval');
        insert objReviewTypeMaster;
        
        objRequestReview=new Request_Review__c ();
        objRequestReview.Review_Process__c=rProcess.id;
        objRequestReview.Status__c='Pending';
        objRequestReview.Select_reviewer__c=true; 
        objRequestReview.Send_reminder__c=true; 
        objRequestReview.Review_User_Master__c=objReviewUser.id;
        objRequestReview.Review_Type_Master__c=objReviewTypeMaster.id;
        insert objRequestReview;
        objRequestReviewList.add(objRequestReview);
     
         oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_1__c=testUser1.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
          insert oppOffering;
          
          oppOfferingList = new List<Opportunity_Offering__c>();
          oppOfferingList.add(oppOffering);
          
          List<UAM_Roles_Permissions__c> roleList=new List<UAM_Roles_Permissions__c>();
          
         rolePerec = new UAM_Roles_Permissions__c(Name = 'Test',Object_Name__c = 'Deal_TGP__c',Roles__c = 'Governance Lead1',Permissions__c = 'CRUD');       
         roleList.add(rolePerec);
         rolePerec1 = new UAM_Roles_Permissions__c(Name = 'Test1',Object_Name__c = 'Deal_TGP__c',Roles__c = 'Governance Lead1',Permissions__c = 'r');       
                  roleList.add(rolePerec1);
                  
                  insert roleList;
         
          deal=new Deal_TGP__c(Name='DealTest123_1', Governance_Lead_Name_New__c = objReviewUser.Id, Solution_Architect_New__c = objReviewUser1.id);
          insert deal;
          
          dealList.add(deal);
          setId.add(deal.Id);
          wavePlanVersion3 =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=deal.id, Version__c=1, Active__c=true);
            insert wavePlanVersion3; 
          
          strMoURM=new Mob_User_Roles_Master__c(Access_Level__c='Edit',Role_Name__c='Governance Lead1');
          insert strMoURM;
          
          strMoURA=new MOB_User_Role_Assignment__c(Access_Level__c='Edit',Deal__c=deal.id,User_Assigned_New__c=objReviewUser.Id,User_Assigned_Secondary_New__c =objReviewUser1.Id,Role_Name__c='Governance Lead1',Mob_User_Roles_Master__c=strMoURM.id);
          insert strMoURA;
          
          lstUserRoleAssign.add(strMoURA);

          
           clientGeo = new Client_Geo_Area_Master__c();
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
          
           // To create a Delivery Location Master
        deliveryLocMa =new Delievery_Location_Master__c();
        deliveryLocMa.Delivery_Location_Description__c='testdata';
        deliveryLocMa.Name='TestData';
        deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
         insert deliveryLocMa;
        
           // To create a Deal Home Location
            dealHome =new Deal_Home_Location__c(); 
            dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
            dealHome.Deal__c= deal.id;
            insert dealHome;
            
          // To create a Deal Location
            dealLoc= new Deal_Location__c();
            dealLoc.Location__c='test Data';
            dealLoc.Deal_Home_Location__c=dealHome.id;
            dealLoc.Wave_Plan_Version__c=wavePlanVersion3.id;
            dealloc.Deployment_Lead_New__c = objReviewUser.Id;
            insert dealLoc;
            
            dealLocList.add(dealLoc);
            
              //To create a Wave Plan
        waveplan =new Wave_Planning__c();
        //waveplan.Wave_Label__c='TestData1';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Number_of_Projected_FTEs__c=1;
        waveplan.Deal_Location__c=dealLoc.id;
        waveplan.KT_Lead_New__c = objReviewUser.Id;
        waveplan.Wave_Label__c = 'test';
        insert waveplan;
        
        waveplanList = new List<Wave_Planning__c>();
        waveplanList.add(waveplan);
        
        
        String strFolderId= [select id from folder where name = 'Solution Document'].id;
        doc = new Document();
        doc.name='Doc1';
        doc.folderId=strFolderId;
        insert doc;
        //to create a review rqeasrt log
        
        List<Review_Action_Item_Log__c> reviewList=new List<Review_Action_Item_Log__c>();
        
        rAIL=new Review_Action_Item_Log__c();
        rAIL.name='test';
        rAIL.Due_date__c=date.today();
        rAIL.File_id__c=doc.id;
        rAIL.Send__c=true;
        rAIL.User__c =testUser.Id;
        rAIL.Attached_File_Name__c='test';
        rAIL.Review_Process__c=rProcess.id;
        rAIL.Primary_Owner__r = objReviewUser;
        rAIL.Description__c='test';
        reviewList.add(rAIL);
        
        rAIL1=new Review_Action_Item_Log__c();
        rAIL1.name='test';
        rAIL1.Due_date__c=null;
        rAIL.Primary_Owner__r = objReviewUser1;
        /*rAIL.File_id__c=doc.id;
        rAIL.Send__c=true;
        rAIL.User__c =testUser.Id;
        rAIL.Attached_File_Name__c='test';
        rAIL.Review_Process__c=rProcess.id;
        rAIL.Description__c='test';*/
                reviewList.add(rAIL1);
        
         rAILList.add(rAIL);
         rAILList.add(rAIL1);
         
         insert reviewList;
     }

     static testMethod void testUserAccessUtility() {
         setupData();
         UserAccessUtility obj = new UserAccessUtility();
         //obj.CheckIdInSet();
         Boolean booleanValue = Obj.CheckIdInSet(deal.Id,setId);
         Boolean booleanValue1 = Obj.CheckIdInSet(waveplan.Id,setId);
         
         obj.CheckAccessDeal(deal.id,lstUserRoleAssign);
         //obj.CheckAccessDeal(dealList);
         //obj.CheckAccessDealDelete(deal.id,lstUserRoleAssign);
         //obj.CheckAccessDealDelete(dealList);
         //obj.CheckAccessDealLocation(dealLocList);
         
     }
     
     static testMethod void testUserAccessUtilityold() {
         setupData();
         UserAccessUtility obj = new UserAccessUtility();
         //obj.CheckIdInSet();
         Boolean booleanValue = Obj.CheckIdInSet(deal.Id,setId);
         Boolean booleanValue1 = Obj.CheckIdInSet(waveplan.Id,setId);
         
         //obj.CheckAccessDeal(deal.id,lstUserRoleAssign);
         //obj.CheckAccessDeal(dealList);
         //obj.CheckAccessDealDelete(deal.id,lstUserRoleAssign);
         //obj.CheckAccessDealDelete(dealList);
         obj.CheckAccessDealLocation(dealLocList);
         
     }
     
      static testMethod void testUserAccessUtilityNew1() {
         setupData();
         UserAccessUtility obj = new UserAccessUtility();
         //obj.CheckIdInSet();
        
         //obj.CheckAccessDealDelete(deal.id,lstUserRoleAssign);
         //obj.CheckAccessDealDelete(dealList);
         //obj.CheckAccessDealLocation(dealLocList);
         
     }
     
     
     
     static testMethod void testUserAccessUtility1() {
         setupData();
         UserAccessUtility obj = new UserAccessUtility();
         //obj.CheckIdInSet();
         obj.CheckAccessDealLocationDelete(dealLocList);
         //obj.CheckAccessDealWave(waveplanList);
         //obj.CheckAccessDealWaveDelete(waveplanList);
         //obj.CheckAccessOpportunity(oppTGPList);
         //obj.CheckAccessOpportunityDelete(oppTGPList);
         //obj.CheckAccessOffering(oppOfferingList);
                         
     }
     static testMethod void testUserAccessUtility1Delete() {
         setupData();
         UserAccessUtility obj = new UserAccessUtility();
         //obj.CheckIdInSet();
         //obj.CheckAccessDealLocationDelete(dealLocList);
         //obj.CheckAccessDealWave(waveplanList);
         obj.CheckAccessDealWaveDelete(waveplanList);
         //obj.CheckAccessOpportunity(oppTGPList);
         //obj.CheckAccessOpportunityDelete(oppTGPList);
         //obj.CheckAccessOffering(oppOfferingList);
                         
     }
     /*static testMethod void testUserAccessUtilityNew() {
         setupData();
         
          dealTrackObj = new Deal_Track__c(Name = 'test',Wave_Plan_Version__c = wavePlanVersion3.id, Deal__c = deal.id);
          insert dealTrackObj;
          
          dealTrackList.add(dealTrackObj);
          
         UserAccessUtility obj = new UserAccessUtility();
         obj.CheckAccessOpportunity(oppTGPList);
         obj.CheckAccessOfDealTrack(dealTrackList);
         
         //obj.CheckAccessOffering(oppOfferingList);
                         
     }*/
     static testMethod void testUserAccessUtilityForoppTeam() {
         setupData();
         
          oppTeamObj = new Opportunity_Team__c(BPO_Opportunity__c = oppTGP.id, Opportunity_Team_Member__c = objReviewUser.Id);
          insert oppTeamObj;
          
          oppTeamList = new List<Opportunity_Team__c>();
          oppTeamList.add(oppTeamObj);
          
          
          
         UserAccessUtility obj = new UserAccessUtility();
         obj.CheckAccessOpportunity(oppTGPList);
         obj.CheckAccessOpportunityTeamDelete(oppTeamList);
         //obj.CheckAccessOffering(oppOfferingList);
                         
     }
     static testMethod void testUserAccessUtility123() {
         setupData();
         UserAccessUtility obj = new UserAccessUtility();
         obj.CheckAccessOpportunityDelete(oppTGPList);
        // obj.CheckAccessOffering(oppOfferingList);
       
     }
     
     /*static testMethod void testUserAccessUtility12() {
         setupData();
         UserAccessUtility obj = new UserAccessUtility();
         //obj.CheckIdInSet();
         
        // obj.CheckAccessOfferingDelete(oppOfferingList);
         obj.CheckAccessReviewRequest(objRequestReviewList);
         obj.CheckAccessReviewRequestDelete(objRequestReviewList);
         
         
     }*
     
      /*static testMethod void testUserAccessUtility2() {
         setupData();
         UserAccessUtility obj = new UserAccessUtility();
         //obj.CheckIdInSet();
         obj.CheckAccessReviewRequestLog(rAILList);
         obj.CheckAccessReviewRequestLogDelete(rAILList);
         
      } */   
    
    
}