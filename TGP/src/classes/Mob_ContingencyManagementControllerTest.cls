/*
Author : Varsha Chougule.
Story  : Story-0093/MOB_052  
Description : Test class for Mob_VarianceAnalysisController

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------

*/
@isTest
private class Mob_ContingencyManagementControllerTest
{
    static Deal_TGP__c deal;
    static Wave_Plan_Version__c wavePlanVersion;
    static Budget_Solution__c budgetSolution;
    static Budget_Reforecast__c budgetReforecast;
    static Decimal i;
    static List<Budget_Solution__c> lstBudgetSolution;
    static List<Budget_Reforecast__c> lstBudgetReforecast;
    static MOB_User_Role_Assignment__c objMobUser;
    static Mob_User_Roles_Master__c objMobUserMaster;
    
    public static void setupData()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        deal.Start_Date_of_Transistion__c =system.today()-30;
        insert deal;
       
        List<Mob_User_Roles_Master__c> lstMobUserMaster =[select id, Role_Name__c, Access_Level__c from Mob_User_Roles_Master__c where Role_Name__c=:'Governance Lead'];
        if(lstMobUserMaster.size()>0)
        {
            objMobUserMaster=lstMobUserMaster[0];
        }
        else
        {
            objMobUserMaster= new Mob_User_Roles_Master__c();
            objMobUserMaster.Role_Name__c='Governance Lead';
            objMobUserMaster.Access_Level__c='edit';
            insert objMobUserMaster;
        }
        
        objMobUser=new MOB_User_Role_Assignment__c ();
        objMobUser.Deal__c=deal.id;
        objMobUser.Access_Level__c='edit';
        objMobUser.Role_Name__c='Governance Lead';
        //objMobUser.User_Assigned__c=UserInfo.getUserId();
        objMobUser.Mob_User_Roles_Master__c=objMobUserMaster.id;
        insert objMobUser;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        lstBudgetReforecast= new List<Budget_Reforecast__c>();
        for(i=1; i<26; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.isSubmitted__c =true;
            budgetSolution.isSubmittedToGovernanceLead__c=true;
            budgetSolution.Submitted_by_Governance_Lead__c=true;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            
            budgetReforecast=new Budget_Reforecast__c ();
            budgetReforecast.Budget_Solution__c=budgetSolution.id;
            budgetReforecast.Month_Name__c=7;
            budgetReforecast.Change_Orders_per_Month__c =10;
            budgetReforecast.Cost_Overruns_per_Month__c=10;
            budgetReforecast.Actuals_Record__c=true;
            budgetReforecast.Reforecast_Record__c=true;
            insert budgetReforecast;
            
            lstBudgetSolution.add(budgetSolution);
            lstBudgetReforecast.add(budgetReforecast);
        }
    }
    public static void setupData1()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        deal.Start_Date_of_Transistion__c =system.today()-30;
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        lstBudgetReforecast= new List<Budget_Reforecast__c>();
        for(i=1; i<22; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            
            budgetReforecast=new Budget_Reforecast__c ();
            budgetReforecast.Budget_Solution__c=budgetSolution.id;
            budgetReforecast.Month_Name__c=7;
            insert budgetReforecast;
            
            lstBudgetSolution.add(budgetSolution);
            lstBudgetReforecast.add(budgetReforecast);
        }
    }
    public static void setupData2()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        deal.Start_Date_of_Transistion__c =system.today()-30;
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        lstBudgetReforecast= new List<Budget_Reforecast__c>();
        for(i=1; i<26; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.isSubmitted__c =true;
            budgetSolution.isSubmittedToGovernanceLead__c=true;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            
            budgetReforecast=new Budget_Reforecast__c ();
            budgetReforecast.Budget_Solution__c=budgetSolution.id;
            budgetReforecast.Month_Name__c=7;
            budgetReforecast.Change_Orders_per_Month__c =10;
            insert budgetReforecast;
            
            lstBudgetSolution.add(budgetSolution);
            lstBudgetReforecast.add(budgetReforecast);
        }
    }
    public static void setupData3()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        deal.Start_Date_of_Transistion__c =system.today()-30;
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        lstBudgetReforecast= new List<Budget_Reforecast__c>();
        for(i=1; i<26; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.isSubmitted__c =true;
            budgetSolution.isSubmittedToGovernanceLead__c=true;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            
            budgetReforecast=new Budget_Reforecast__c ();
            budgetReforecast.Budget_Solution__c=budgetSolution.id;
            budgetReforecast.Month_Name__c=7;
            budgetReforecast.Cost_Overruns_per_Month__c=10;
            budgetReforecast.Reforecast_Record__c=true;
            insert budgetReforecast;
            
            lstBudgetSolution.add(budgetSolution);
            lstBudgetReforecast.add(budgetReforecast);
        }
    }
     static testMethod void testMob_ContingencyManagementController()
    {
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_ContingencyManagementController obj1= new Mob_ContingencyManagementController(controller);
        Mob_ContingencyManagementController.BudgetContingency ObjBudgetReforecast= new Mob_ContingencyManagementController.BudgetContingency(budgetReforecast);
        List<Mob_ContingencyManagementController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.saveContingencyManagement();
        obj1.cancelContingencyManagement();
        obj1.SubmitContingencyManagement();
        obj1.showNextMonths();
        obj1.showPreviousMonths();
        setupData1();
        ApexPages.StandardController controller1= new ApexPages.StandardController(wavePlanVersion);
        Mob_ContingencyManagementController obj2= new Mob_ContingencyManagementController(controller1);
        List<Mob_ContingencyManagementController.BudgetSolution> BudgetSolutionList1=obj2.getListOfBudgetSolution();
        obj2.saveContingencyManagement();
        obj2.cancelContingencyManagement();
        test.stoptest();
    }  
    static testMethod void testMob_ContingencyManagementController1()
    {
        test.starttest();
        setupData1();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_ContingencyManagementController obj1= new Mob_ContingencyManagementController(controller);
        Mob_ContingencyManagementController.BudgetContingency ObjBudgetReforecast= new Mob_ContingencyManagementController.BudgetContingency(budgetReforecast);
        List<Mob_ContingencyManagementController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.saveContingencyManagement();
        obj1.cancelContingencyManagement();
        obj1.SubmitContingencyManagement();
        obj1.showNextMonths();
        obj1.showPreviousMonths();
        test.stoptest();
    }  
    static testMethod void testMob_ContingencyManagementController2()
    {
        test.starttest();
        setupData2();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_ContingencyManagementController obj1= new Mob_ContingencyManagementController(controller);
        Mob_ContingencyManagementController.BudgetContingency ObjBudgetReforecast= new Mob_ContingencyManagementController.BudgetContingency(budgetReforecast);
        List<Mob_ContingencyManagementController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.saveContingencyManagement();
        obj1.cancelContingencyManagement();
        obj1.SubmitContingencyManagement();
        obj1.showNextMonths();
        obj1.showPreviousMonths();
        test.stoptest();
    }  
    static testMethod void testMob_ContingencyManagementController3()
    {
        test.starttest();
        setupData3();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_ContingencyManagementController obj1= new Mob_ContingencyManagementController(controller);
        Mob_ContingencyManagementController.BudgetContingency ObjBudgetReforecast= new Mob_ContingencyManagementController.BudgetContingency(budgetReforecast);
        List<Mob_ContingencyManagementController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.saveContingencyManagement();
        obj1.cancelContingencyManagement();
        obj1.SubmitContingencyManagement();
        obj1.showNextMonths();
        obj1.showPreviousMonths();
        test.stoptest();
    }  
}