@istest
private class RequestReviewTriggerControllerTest {
	
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
    static Request_Review__c objRequestReview1;
    static Request_Review__c objRequestReview2;
    static Request_Review__c objRequestReview3;
    static Request_Review__c objRequestReview4;
    static User testUser3;
    static User testUser4;
    static User testUser2;
    static User testUserPMO;
    static Document_for_Request_Review__c objDoc;
    static String User_Name2='vc7@testorg.com';
    static String User_Name1='vc71@testorg.com';
    static String User_NamePMO='vc711@testorg.com';
    static Review_User_Master__c revUser;
    static List<Request_Review__c> objRequestReviewList =  new List<Request_Review__c>();
    static List<Request_Review__c> objRequestReviewListOld =  new List<Request_Review__c>();
    static Decimal testDecimal = 100;
    static String testString = 'testString';
    

	
    public static void setupData()
    {  
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name1);
        Database.insert(testUser2, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser4 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name2);
        Database.insert(testUser4, false);

        system.runas(testUser2)
        {
            clientName = new Client_Master__c (Name = 'Testv1',Active__c = true);
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
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
            insert oppTGP;
    
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;
            
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
            insert oppOffering;
            
            //To create a record of Review Process
            rProcess=new Review_Process__c();
            rProcess.BPO_Opportunity__c=oppTGP.id;
            insert rProcess;  
            
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c = testUser4.Email;
            objReviewUser.Name='reviewUaser2';
            insert objReviewUser;
            
            objReviewTypeMaster=new Review_Type_Master__c();
            List<Review_Type_Master__c> lstRTN=[select id, name from Review_Type_Master__c where name='Final Approval'];
            if(lstRTN.size()>0)
            {
                objReviewTypeMaster=lstRTN[0];
            }
            else
            {
                objReviewTypeMaster.Name='Final Approval';
                objReviewTypeMaster.Active__c=true;
                insert objReviewTypeMaster;
            }
            
            objRequestReview=new Request_Review__c ();
            objRequestReview.Review_Process__c=rProcess.id;
            objRequestReview.Status__c='Pending';
            objRequestReview.Select_reviewer__c=true; 
            objRequestReview.Send_reminder__c=true; 
            objRequestReview.Review_User_Master__c=objReviewUser.id;
            objRequestReview.Review_Type_Master__c=objReviewTypeMaster.id;
            insert objRequestReview;
            objRequestReviewList.add(objRequestReview);
            objRequestReviewListOld.add(objRequestReview);
            
            objRequestReview1=new Request_Review__c ();
            objRequestReview1.Review_Process__c=rProcess.id;
            objRequestReview1.Status__c='Approved';
            objRequestReview1.Review_User_Master__c=objReviewUser.id;
            objRequestReview1.Review_Type_Master__c=objReviewTypeMaster.id;
            insert objRequestReview1;
            objRequestReviewList.add(objRequestReview1);
            objRequestReviewListOld.add(objRequestReview1);
            
            objRequestReview2=new Request_Review__c ();
            objRequestReview2.Review_Process__c=rProcess.id;
            objRequestReview2.Status__c='Reject';
            objRequestReview2.Select_reviewer__c=true; 
            objRequestReview2.Send_reminder__c=true; 
            objRequestReview2.Review_User_Master__c=objReviewUser.id;
            objRequestReview2.Review_Type_Master__c=objReviewTypeMaster.id;
            insert objRequestReview2;
            objRequestReviewList.add(objRequestReview2);
            objRequestReviewListOld.add(objRequestReview2);
            
            objRequestReview3=new Request_Review__c ();
            objRequestReview3.Review_Process__c=rProcess.id;
            objRequestReview3.Status__c='Rework';
            objRequestReview3.Select_reviewer__c=true; 
            objRequestReview3.Send_reminder__c=true; 
            objRequestReview3.Review_User_Master__c=objReviewUser.id;
            objRequestReview3.Review_Type_Master__c=objReviewTypeMaster.id;
            insert objRequestReview3;
            objRequestReviewList.add(objRequestReview3);
            objRequestReview3.Status__c='Pending';
            //update objRequestReview3;
            //objRequestReviewListold.add(objRequestReview3);
            
            objRequestReview4=new Request_Review__c ();
            objRequestReview4.Review_Process__c=rProcess.id;
            objRequestReview4.Status__c='Not Sent';
            objRequestReview4.Select_reviewer__c=true; 
            objRequestReview4.Send_reminder__c=true; 
            objRequestReview4.Review_User_Master__c=objReviewUser.id;
            objRequestReview4.Review_Type_Master__c=objReviewTypeMaster.id;
            insert objRequestReview4;
            objRequestReviewList.add(objRequestReview4);
            objRequestReviewListOld.add(objRequestReview4);

          }  
    }
    
    
	
	
	static testMethod void testDynamicReportCreation()
    {
        test.starttest();
        SetupData();
        //RequestReviewTriggerController obj = new RequestReviewTriggerController ();
        System.currentPageReference().getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, oppTGP.Id);
        RequestReviewTriggerController.updateReviewStage(objRequestReviewList);  
        RequestReviewTriggerController.DeleteReview(objRequestReviewList);  
        RequestReviewTriggerController.sendApprovalResponseMail(objRequestReviewList,objRequestReviewListold );
        String D = RequestReviewTriggerController.checkNullValuesDeciamlTCV(testDecimal);
        String D1 = RequestReviewTriggerController.checkNullValuesDeciamlTCV(null);
        String s = RequestReviewTriggerController.checkNullValues(testString);   
        RequestReviewTriggerController.sendAlertToFinalApprover(objRequestReviewList,objRequestReviewListOld);    
        test.stoptest();         
    }

}