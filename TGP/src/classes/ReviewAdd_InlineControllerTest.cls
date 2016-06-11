/*
Author : Varsha Chougule.
Story  : 
Description : Test class for Mob_BudgetSolutionController

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------

*/
@isTest
private class ReviewAdd_InlineControllerTest
{   
    static User testUser;
    static User testUser1;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    static Offerings_Master__c offeringMaster;
    static Opportunity_Offering__c oppOffering;
    static Review_Process__c rProcess;
    static Review_User_Master__c objReviewUser;
    static Review_Type_Master__c objReviewTypeMaster;
    static Request_Review__c objRequestReview;
    static Review_Stage_Master__c RevStagMas;
    static String USER_Name = 'vc7@testorg.com';
    
    public static void setupData()
    {
           Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
          testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);
    
    profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
          testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name);
          Database.insert(testUser1, false);

system.runas(testUser1)
  {  
        clientName = new Client_Master__c (Name = 'ouuTestv1',Active__c = true);
            insert clientName;
            
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
            insert clientGeoArea;
            
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
            
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
            }
            system.runas(testUser)
  {


            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
            insert oppTGP;
    
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;
            
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Lead__c=testUser.id,Solution_Specialist__c=testUser.id);
            insert oppOffering;
            
            RevStagMas=new Review_Stage_Master__c ();
            RevStagMas.Name='test';
            RevStagMas.Active__c=true;
            insert RevStagMas;

            
            //To create a record of Review Process
            rProcess=new Review_Process__c();
            rProcess.BPO_Opportunity__c=oppTGP.id;
            rProcess.Review_Stage_Master__c=RevStagMas.id;
            insert rProcess;  
            
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c ='v1@testorg.com';
            objReviewUser.Name='reviewUaser2';
            insert objReviewUser;
            
            RevStagMas=new Review_Stage_Master__c ();
            RevStagMas.Name='test';
            RevStagMas.Active__c=true;
            insert RevStagMas;

            }
                        
                }
        static testMethod void testReviewAdd_InlineController()
        {
            test.starttest();
            setupData();
         {
            ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
            PageReference pageRef= Page.ReviewAdd_Inline;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
            Test.setCurrentPageReference(pageRef);
            ReviewAdd_InlineController obj1= new ReviewAdd_InlineController(controller);
            obj1.getReviewList();
            obj1.addReview();
            obj1.ReviewStage=RevStagMas.id;
            obj1.addReview();
            
            obj1.getReviewStages();
            //obj1.getReviewList();
            obj1.saveReviewList();
            obj1.cancelReviewList();
            //obj1.deleteReview();
            obj1.determineUserAccess();
            obj1.objOpportunity = oppTGP;
            obj1.SaveLink();
            obj1.ClickHere();
            obj1.reviewIdToDelete=rProcess.id;
            obj1.deleteReview();
                   }
        test.stopTest();
    }
}