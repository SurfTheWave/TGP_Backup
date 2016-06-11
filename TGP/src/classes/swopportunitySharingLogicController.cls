/*
Author : Mayank Agarwal
Story :  Story-0149/SOL_036
Description : Create/maintain roles/users.User access management.Controller class for trigger.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public without sharing  class swopportunitySharingLogicController{
    
    /******************************
    Method Name: insertOppty 
    Description: Method called when records are inserted in opportunity
    Paramenters: opptyListPassed
    Return Value: void
    *******************************/
    //Start
    public static void insertOppty(Opportunity_TGP__c[] opptyListPassed){
    List<Opportunity_TGP__Share> opptyShare = new List<Opportunity_TGP__Share>();
    for(Opportunity_TGP__c oppty : opptyListPassed){
         if(oppty.Complex_Cost_Architect_New__c !=null && oppty.Complex_Cost_Architect_New__r.SFDC_User__c !=null){        
             Opportunity_TGP__Share complexCostArch = new Opportunity_TGP__Share();
             complexCostArch.ParentId = oppty.Id;
             complexCostArch.UserOrGroupId = oppty.Complex_Cost_Architect_New__r.SFDC_User__c;
             complexCostArch.AccessLevel = 'read';
             complexCostArch.RowCause = 'Manual';
             opptyShare.add(complexCostArch);
         }
         Opportunity_TGP__Share enterpriseSolArch = new Opportunity_TGP__Share();
         if(oppty.Enterprise_Solution_Architect_New__c !=null && oppty.Enterprise_Solution_Architect_New__r.SFDC_User__c !=null){ 
             enterpriseSolArch.ParentId = oppty.Id;
             enterpriseSolArch.UserOrGroupId = oppty.Enterprise_Solution_Architect_New__r.SFDC_User__c;
             enterpriseSolArch.AccessLevel = 'edit';
             enterpriseSolArch.RowCause = 'Manual';
             opptyShare.add(enterpriseSolArch);
         }
         /* utilityClass utilityClassInstace = new utilityClass();
          Id analyticsUserId = utilityClassInstace.getSFDCSolutionUserIDfromApprovalUserMasterId(oppty.Analytics_Solution_Lead__c);
          if(analyticsUserId != null) {*/
          if(oppty.Analytics_Solution_Lead__c !=null && oppty.Analytics_Solution_Lead__r.SFDC_User__c !=null){
             Opportunity_TGP__Share analyticSolLead = new Opportunity_TGP__Share();
             analyticSolLead.ParentId = oppty.Id;
             analyticSolLead.UserOrGroupId = oppty.Analytics_Solution_Lead__r.SFDC_User__c ;
             analyticSolLead.AccessLevel = 'edit';
             analyticSolLead.RowCause = 'Manual';
             opptyShare.add(analyticSolLead);
          }
        }
    Database.SaveResult[] opptyInsertResult = Database.insert(opptyShare,false);
    }
    //End
    
    /******************************
    Method Name: updateOppty 
    Description: Method called when records are updated in opportunity
    Paramenters: opptyListPassed,opptyListOldPassed
    Return Value: void
    *******************************/
    //Start
    public static void updateOppty(Opportunity_TGP__c[] opptyListPassed,Opportunity_TGP__c opptyListOldPassed){
        List<Opportunity_TGP__c> opptyList = new List<Opportunity_TGP__c>();
        List<Opportunity_TGP__c> opptyOldList = new List<Opportunity_TGP__c>();
        List<Opportunity_Offering__c> opptyOffExist = new List<Opportunity_Offering__c>();
        opptyOffExist = [Select Domain_Expert_Functional_Architect_New__c,Functional_Architect_Mobilization_New__c,Solution_Lead_New__c,Solution_Specialist_New__c from Opportunity_Offering__c where Opportunity_TGP__c =: opptyListOldPassed.Id];
        Set<Id> oppOffRoleId = new Set<Id>();
        if(opptyOffExist != null && opptyOffExist.size()>0){
            for(Opportunity_Offering__c oppOff : opptyOffExist){
                oppOffRoleId.add(oppOff.Domain_Expert_Functional_Architect_New__c);
                oppOffRoleId.add(oppOff.Functional_Architect_Mobilization_New__c);
                oppOffRoleId.add(oppOff.Solution_Lead_New__c);
                oppOffRoleId.add(oppOff.Solution_Specialist_New__c);
            }
        }
        for(Opportunity_TGP__c oppty : opptyListPassed){
            Opportunity_TGP__c opptyOld = opptyListOldPassed;
            if((opptyOld.Enterprise_Solution_Architect_New__c != oppty.Enterprise_Solution_Architect_New__c) || (opptyOld.Complex_Cost_Architect_New__c != oppty.Complex_Cost_Architect_New__c) || (opptyOld.Analytics_Solution_Lead__r.SFDC_User__c != oppty.Analytics_Solution_Lead__r.SFDC_User__c)){
                opptyList.add(oppty);
                opptyOldList.add(opptyOld);
            }
        }
        if(opptyOldList != null && opptyOldList.size()>0){    
            Set<Id> parentId = new Set<Id>();
            List<String> enterSolArch = new List<String>();
            List<String> complexCostArch = new List<String>();
            List<String> analyticSolutionLead = new List<String>();
            for(Opportunity_TGP__c opptyOld : opptyOldList) {
                parentId.add(opptyOld.Id);
                enterSolArch.add(opptyOld.Enterprise_Solution_Architect_New__c);
                complexCostArch.add(opptyOld.Complex_Cost_Architect_New__c);
                //utilityClass utilityClassInstace = new utilityClass();
                //Id analyticsUserId = utilityClassInstace.getSFDCSolutionUserIDfromApprovalUserMasterId(opptyOld.Analytics_Solution_Lead__c);
                if(opptyOld.Analytics_Solution_Lead__r.SFDC_User__c!=null) {//analyticsUserId != null
                    analyticSolutionLead.add(String.valueOf(opptyOld.Analytics_Solution_Lead__r.SFDC_User__c)); 
                }
            }   
            List<Opportunity_TGP__Share> opptyShare = new List<Opportunity_TGP__Share>();
            
            if(opptyOffExist != null && opptyOffExist.size()>0 && oppOffRoleId != null){
            opptyShare = [select ParentId,UserOrGroupId,RowCause from Opportunity_TGP__Share where (ParentId IN: parentId AND (UserOrGroupId IN:enterSolArch OR UserOrGroupId IN:complexCostArch OR UserOrGroupId IN:analyticSolutionLead) AND (UserOrGroupId NOT IN:oppOffRoleId) AND RowCause =: 'Manual') ];
            }
            else{
            opptyShare = [select ParentId,UserOrGroupId,RowCause from Opportunity_TGP__Share where (ParentId IN: parentId AND (UserOrGroupId IN:enterSolArch OR UserOrGroupId IN:complexCostArch OR UserOrGroupId IN:analyticSolutionLead) AND RowCause =: 'Manual') ];
            }
            if(opptyShare != null && opptyShare.size()>0){
                delete opptyShare;
            }
            
        }
        if(opptyList != null && opptyList.size()>0){        
           List<Opportunity_TGP__Share> opptyShare = new List<Opportunity_TGP__Share>();
            for(Opportunity_TGP__c oppty : opptyList){
                if(oppty.Complex_Cost_Architect_New__r !=null && oppty.Complex_Cost_Architect_New__r.SFDC_User__c !=null){
                    Opportunity_TGP__Share complexCostArch = new Opportunity_TGP__Share();
                    complexCostArch.ParentId = oppty.Id;
                    complexCostArch.UserOrGroupId = oppty.Complex_Cost_Architect_New__r.SFDC_User__c;
                    complexCostArch.AccessLevel = 'read';
                    complexCostArch.RowCause = 'Manual';
                    opptyShare.add(complexCostArch);
                }
                
                Opportunity_TGP__Share enterpriseSolArch = new Opportunity_TGP__Share();
                if(oppty.Enterprise_Solution_Architect_New__r !=null && oppty.Enterprise_Solution_Architect_New__r.SFDC_User__c !=null){
                    enterpriseSolArch.ParentId = oppty.Id;
                    enterpriseSolArch.UserOrGroupId = oppty.Enterprise_Solution_Architect_New__r.SFDC_User__c;
                    enterpriseSolArch.AccessLevel = 'edit';
                    enterpriseSolArch.RowCause = 'Manual';
                    opptyShare.add(enterpriseSolArch);
                }
                
                
                     Opportunity_TGP__Share analyticSolLead = new Opportunity_TGP__Share();
                     if(oppty.Analytics_Solution_Lead__r !=null && oppty.Analytics_Solution_Lead__r.SFDC_User__c !=null){
                         analyticSolLead.ParentId = oppty.Id;
                         analyticSolLead.UserOrGroupId = oppty.Analytics_Solution_Lead__r.SFDC_User__c;
                         analyticSolLead.AccessLevel = 'edit';
                         analyticSolLead.RowCause = 'Manual';
                         opptyShare.add(analyticSolLead);
                     }
                
            }
          Database.SaveResult[] opptyInsertResult = Database.insert(opptyShare,false);
        }
      
    }
    //End
}