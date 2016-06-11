/*
Author : Varsha Chougle
Story  : Story-0093/MOB_052  
Description :initiate Budget Tracker. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class BudgetTrackerController {

    String wavePlanVersionId{get;set;}
    public List<Budget_Solution__c> lstBudgetSolution{get;set;}
    public List<MOB_User_Role_Assignment__c> lstUserRoleAssign{get; set;}
    public boolean isSubmit{get;set;}
    public String selectedTab1{get;set;}
    public boolean disableMsg {get;set;}
    public String msg{get;set;}
    public boolean isAvailable{get;set;}
    
    /******************************
    Method Name: BudgetTrackerController
    Description: This is Constructor for the BudgetTrackerController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public BudgetTrackerController(ApexPages.StandardController controller) 
    {
        
        wavePlanVersionId=ApexPages.CurrentPage().getParameters().get('id');
        selectedTab1=ApexPages.CurrentPage().getParameters().get('tab');
        if(selectedTab1==null)
        {
            selectedTab1='tab1';
        }
        //List of Budget Solution
        lstBudgetSolution=[select Wave_Plan_Version__r.Deal__c,isSubmittedToGovernanceLead__c from Budget_Solution__c where Wave_Plan_Version__c=: wavePlanVersionId and isSubmittedToGovernanceLead__c=:true order by Number__c ];
                 
        
        if(lstBudgetSolution.size()>0)
        {
            lstUserRoleAssign = [select id,Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,User_Assigned_New__c,User_Assigned_Secondary_New__c,User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c
                                        from MOB_User_Role_Assignment__c where Deal__c = :lstBudgetSolution[0].Wave_Plan_Version__r.Deal__c];
            
            isAvailable=false;
            if(lstUserRoleAssign.size()>0)
            {
                for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                {
                    if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && (mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                    {
                        isAvailable=true;
                        isSubmit=true;
                    }
                }
            } 
            if(isAvailable==false)
            {
                isSubmit=false;
            }
            String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;                    
             if(lstBudgetSolution[0].isSubmittedToGovernanceLead__c== true && (userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN)))
             {
                 isSubmit=true;
             }         
        }                       
    }
    public PageReference functionF1()
    {
        PageReference pr=new PageReference('/apex/BudgetTracker?id='+wavePlanVersionId+'&tab=tab1');
        pr.setRedirect(true);
        return pr; 
    }
    public PageReference functionF2()
    {
        PageReference pr=new PageReference('/apex/BudgetTracker?id='+wavePlanVersionId+'&tab=tab2');
        pr.setRedirect(true);
        return pr; 
    }
    public PageReference functionF3()
    {
        PageReference pr=new PageReference('/apex/BudgetTracker?id='+wavePlanVersionId+'&tab=tab3');
        pr.setRedirect(true);
        return pr; 
    }
    public PageReference functionF4()
    {
        PageReference pr=new PageReference('/apex/BudgetTracker?id='+wavePlanVersionId+'&tab=tab4');
        pr.setRedirect(true);
        return pr; 
    }
    public PageReference functionF5()
    {
        PageReference pr=new PageReference('/apex/BudgetTracker?id='+wavePlanVersionId+'&tab=tab5');
        pr.setRedirect(true);
        return pr; 
    }
    public PageReference functionF6()
    {
        PageReference pr=new PageReference('/apex/BudgetTracker?id='+wavePlanVersionId+'&tab=tab6');
        pr.setRedirect(true);
        return pr; 
    }
}