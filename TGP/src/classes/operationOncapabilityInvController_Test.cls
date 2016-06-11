/*
  @Author: 
  @Name: operationOncapabilityInvController_Test Test class
  @Created Date: 
  @Description:  
  @version: 1.0  
*/
@isTest
public  class operationOncapabilityInvController_Test{

     private static Opportunity opp;
     private static Opportunity_Roles_Master__c oppRoleMasterOSLP ;
     private static Opportunity_Teams__c oppTeamOSLP;
     private static User stdUser;
     private static user_master__c testUserMaster ;
      private static Capability_Involvement__c capability;
      private static User usr;
      public static void setupUser(){
        
            stdUser = UtilNovaUnitTest.getUser();
            
    }
      public static void setupData(){
        setupUser();
      
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster; 
        
        oppRoleMasterOSLP = new Opportunity_Roles_Master__c(Name = 'Capability Lead',ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLP ;
        opp = new Opportunity();
        opp.OperatingGroup__c = OppGrpMaster.id;
        opp.name= UtilConstants.TEST_OPP;
        opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
        opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
        opp.StageName= UtilConstants.OA;
        opp.Risk_Level__c= UtilConstants.LOW;
        opp.SG_Dev__c = UtilConstants.IO;
        opp.SD_Covered__c = UtilConstants.YES;
        opp.Staffing_Status__c = UtilConstants.ASSIGNED;
        opp.IO_Net_Revenue_Thousands__c = 100;
        opp.CloseDate= date.newInstance(2001, 3, 21);
        opp.Industry_Business_Services__c = 'BNK-CREDIT';
        insert opp;
        
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        offProc.Service_Group__c = 'BPO';
        insert offProc;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
         Solution_Scope__c solCompBPO = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = offProc.id, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
        insert solCompBPO;
        usr = [Select id from User where Id = :UserInfo.getUserId()];
        testUserMaster = new User_Master__c();
        testUserMaster.Name = stdUser.name;
        testUserMaster.user__c = usr.Id;
        insert testUserMaster;
             
        oppTeamOSLP= new Opportunity_Teams__c();
        oppTeamOSLP.Opportunity__c = opp.Id;
        oppTeamOSLP.Role__c = oppRoleMasterOSLP.id;
        oppTeamOSLP.Opportunity_Team_Member__c = testUserMaster.Id;
        oppTeamOSLP.Team_Member_Request_Status__c = 'In Progress';
        oppTeamOSLP.Assigned_Date__c = System.today(); 
        oppTeamOSLP.Requestor__c  = testUserMaster.Id;
        oppTeamOSLP.Offering__c = solCompBPO.Id;
        
        
        System.RunAs(usr)
     {      
        insert oppTeamOSLP;        
     }
        
        
        
        
        
        
            
 }
 
 public static testmethod void testCapablilityLead(){                     
            setupData();
            
            List<Capability_Involvement__c> clist=new List<Capability_Involvement__c>();
            clist.add(capability);
             capability=new Capability_Involvement__c();
         capability.Team_Member_Id_Dev__c=oppTeamOSLP.Id;
         capability.opportunity__c=opp.id;
         capability.name=oppTeamOSLP.name;
              
         
       
            System.RunAs(usr)
            {      
            test.startTest();
            //operationOncapabilityInvController.shareRecordsToCapabilityLead(clist);
            //operationOncapabilityInvController.removePermissionSetAccess(clist); 
            insert capability;
            capability.Team_Member_Id_Dev__c='';
             update  capability;        
            test.stopTest();
          }
 }           

}