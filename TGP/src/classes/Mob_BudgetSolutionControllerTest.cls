/*
Author : Varsha Chougule.
Story  : Story-0093/MOB_052  
Description : Test class for Mob_BudgetSolutionController

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------

*/
@isTest
private class Mob_BudgetSolutionControllerTest
{
    static Deal_TGP__c deal;
    static Wave_Plan_Version__c wavePlanVersion;
    static Budget_Solution__c budgetSolution;
    static Decimal i;
    static List<Budget_Solution__c> lstBudgetSolution;
    
    public static void setupData()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        Mob_User_Roles_Master__c userMaster=new Mob_User_Roles_Master__c ();
        userMaster.Access_Level__c='read';
        userMaster.Role_Name__c='Test User Role';
        insert userMaster;
        MOB_User_Role_Assignment__c userObj=new MOB_User_Role_Assignment__c();
        userObj.Role_Name__c='Commercial Lead';
        userObj.Deal__c=deal.id;
        userObj.Access_Level__c='read';
        //userObj.User_Assigned__c=testUser1.id;
        userObj.Mob_User_Roles_Master__c=userMaster.id;
        insert userObj;
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        for(i=1; i<26; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            lstBudgetSolution.add(budgetSolution);
        }
    }
    
    public static void setupData1()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        Mob_User_Roles_Master__c userMaster=new Mob_User_Roles_Master__c ();
        userMaster.Access_Level__c='read';
        userMaster.Role_Name__c='Test User Role1';
        insert userMaster;
        MOB_User_Role_Assignment__c userObj=new MOB_User_Role_Assignment__c();
        userObj.Role_Name__c='Commercial Lead';
        userObj.Deal__c=deal.id;
        userObj.Access_Level__c='read';
        //userObj.User_Assigned__c=testUser1.id;
        userObj.Mob_User_Roles_Master__c=userMaster.id;
        insert userObj;
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        for(i=1; i<20; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.isSubmitted__c=true;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            lstBudgetSolution.add(budgetSolution);
        }
    }
    
    public static void setupData2()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        Mob_User_Roles_Master__c userMaster=new Mob_User_Roles_Master__c ();
        userMaster.Access_Level__c='read';
        userMaster.Role_Name__c='Test User Role2';
        insert userMaster;
        MOB_User_Role_Assignment__c userObj=new MOB_User_Role_Assignment__c();
        userObj.Role_Name__c='Commercial Lead';
        userObj.Deal__c=deal.id;
        userObj.Access_Level__c='read';
        //userObj.User_Assigned__c=testUser1.id;
        userObj.Mob_User_Roles_Master__c=userMaster.id;
        insert userObj;
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        for(i=1; i<20; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.isSubmitted__c=true;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            lstBudgetSolution.add(budgetSolution);
        }
    }
    
    static testMethod void testMob_BudgetSolutionController()
    {
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetSolutionController obj1= new Mob_BudgetSolutionController(controller);
        Mob_BudgetSolutionController.BudgetSolution ObjBudgetSolution= new Mob_BudgetSolutionController.BudgetSolution(budgetSolution,'white', false,false,false);
        List<Mob_BudgetSolutionController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.saveBudgetSolution();
        obj1.CancelBudgetSolution();
        obj1.sumOfModelEstimates();
        obj1.submitBudgetSolution();
        lstBudgetSolution= new List<Budget_Solution__c>();
        for(Budget_Solution__c b : obj1.lstBudgetSolution)
        {
            lstBudgetSolution.add(b);
        }
        for(Budget_Solution__c b : lstBudgetSolution)
        {
            obj1.lstBudgetSolution.add(b);
        }
        obj1.saveBudgetSolution();
        obj1.sumOfModelEstimates();
        obj1.submitBudgetSolution();
        
        setupData1();
        Mob_BudgetSolutionController obj2= new Mob_BudgetSolutionController(controller);
        Mob_BudgetSolutionController.BudgetSolution ObjBudgetSolution1= new Mob_BudgetSolutionController.BudgetSolution(budgetSolution,'white', false,false,false);
        List<Mob_BudgetSolutionController.BudgetSolution> BudgetSolutionList1=obj2.getListOfBudgetSolution();
        
       // setupData2();
        
        test.stoptest();
    }  
}