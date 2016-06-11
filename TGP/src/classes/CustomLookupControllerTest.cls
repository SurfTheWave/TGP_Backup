/*
@name : CustomLookupControllerTest
@Description : 
@Version : 
*/ 
@isTest
private class CustomLookupControllerTest {
        private static User testUser;
        private static Opportunity opp;
        private static Profile p;
        /*    
            @name :         setupData
            @description :  set up test data for Custom lookup controller functionality testing
        */    
        public static void setupData(){    
         p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        //Operating_Groups_Master__c oppGrpMaster=UTIL_DataCreationForTestClass.getOperatingGroupMasterRec('TestOpperatingGroup',true);      
        //insert oppGrpMaster;
        //Opportunity opp=UTIL_DataCreationForTestClass.getOpportunity(oppGrpMaster);     
        opp=new Opportunity(Name='test opp',CloseDate=system.today()+10,StageName='test stage'); 
        insert opp;
        
        Opportunity_Roles_Master__c oppRoleMaster= new Opportunity_Roles_Master__c(name='Test user',IO_Role__c=True,IC_Role__c=True,BPO_Role__c=True,Active__c=True);
        insert oppRoleMaster;
        
        Offering_Master__c offAll = new Offering_Master__c();
        offAll.Name = 'All';
        offAll.offering_description__c = 'Test Offering';
         offAll.flywheel_non_flywheel__c = UtilConstants.FLYWHEEL;
            offAll.Service_Group__c = UtilConstants.BPO;
        offAll.active__c = true;
        insert offAll;
            
        Solution_Scope__c scope=new Solution_Scope__c(Active__c = true,Opportunity__c=opp.id,Service_Group__c='BPO',Solution_Component__c='Delivery',Offering_Master__c=offAll.id);
        //insert scope;
         
        Opportunity_Teams__c oppTeamNew1=new Opportunity_Teams__c(Opportunity__c=opp.Id);
        insert oppTeamNew1;
        }
/*
@name : customLookUPTestMethod
@Description : 
@Version : 
*/      
        static testMethod void customLookUPTestMethod(){
            
        test.starttest();
        setupData();
        system.runAs(testUser){
                   
            PageReference tpageRef = Page.CustomLookupPopup;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put(UtilConstants.OPPID, opp.id);
                ApexPages.currentPage().getParameters().put( UtilConstants.OBJECT_NAME, UtilConstants.usermasterobject);  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
            //exportTracker.CustomLookupController();
            CustomLookupController exportTracker = new CustomLookupController(); 
            exportTracker.baseQueryTeamMember();
            exportTracker.baseQueryScope();
            exportTracker.baseQueryRole();
            }
         test.stopTest();
        }
 /*
@name : customLookUPTestMethod2
@Description : 
@Version : 
*/
    static testMethod void customLookUPTestMethod2(){
            
        test.starttest();
        setupData();
        system.runAs(testUser){
                   
            PageReference tpageRef = Page.CustomLookupPopup;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put(UtilConstants.OPPID, opp.id);
                ApexPages.currentPage().getParameters().put(UtilConstants.OBJECT_NAME, UtilConstants.SOL_SCOPE);  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
            //exportTracker.CustomLookupController();
            CustomLookupController exportTracker = new CustomLookupController(); 
            exportTracker.baseQueryTeamMember();
            exportTracker.baseQueryScope();
            exportTracker.baseQueryRole();
            }
         test.stopTest();
        }
 /*    
            @name :         customLookUPTestMethod3
            @description :  Test for customLookUPTest in CustomLookupController 
        */
        static testMethod void customLookUPTestMethod3(){
            
        test.starttest();
        setupData();
        system.runAs(testUser){
                   
            PageReference tpageRef = Page.CustomLookupPopup;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put(UtilConstants.OPPID, opp.id);
            ApexPages.currentPage().getParameters().put(UtilConstants.OBJECT_NAME, UtilConstants.opproleobjectname );  
            ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD); 
            //exportTracker.CustomLookupController();
            CustomLookupController exportTracker = new CustomLookupController(); 
            exportTracker.baseQueryTeamMember();
            exportTracker.baseQueryScope();
            exportTracker.baseQueryRole();
            }
         test.stopTest();
        }
   }