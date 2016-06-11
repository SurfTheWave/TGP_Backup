/*
Author : Varsha Chougule.
Story  : Story-0093/MOB_052  
Description : Test class for Mob_BudgetActualsController 

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------

*/
@isTest
private class Mob_BudgetActualsControllerTest
{
    static Deal_TGP__c deal;
    static Wave_Plan_Version__c wavePlanVersion;
    static Wave_Plan_Version__c wavePlanVersion1;
    static Budget_Solution__c budgetSolution;
    static Budget_Reforecast__c budgetReforecast;
    static Decimal i,j;
    static List<Budget_Solution__c> lstBudgetSolution;
    static List<Budget_Reforecast__c> lstBudgetReforecast;
    
    public static void setupData()
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
            //budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            
            budgetReforecast=new Budget_Reforecast__c ();
            budgetReforecast.Budget_Solution__c=budgetSolution.id;
            budgetReforecast.Month_Name__c=7;
            if(i==23)
            {
                budgetReforecast.forecast__c=1;
            }
            else if(i==24)
            {
                budgetReforecast.Actuals__c=1;
            }
            else if(i==25)
            {
                budgetReforecast.forecast__c=1;
                budgetReforecast.Actuals__c=1;
            }
            budgetReforecast.isActualSubmitted__c=true;
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
        //deal.Start_Date_of_Transistion__c =system.today()-30;
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        lstBudgetReforecast= new List<Budget_Reforecast__c>();
        for(i=1; i<30; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.isSubmitted__c=true;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution; 
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
        for(i=1; i<30; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.isSubmitted__c=true;
            budgetSolution.isSubmittedToGovernanceLead__c=true;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            insert budgetSolution;
            budgetReforecast=new Budget_Reforecast__c ();
            budgetReforecast.Budget_Solution__c=budgetSolution.id;
            budgetReforecast.Month_Name__c=7;
            if(i==24)
            {
                budgetReforecast.forecast__c=1;
            }
            else if(i==25)
            {
                budgetReforecast.Actuals__c=1;
            }
            else
            {
                budgetReforecast.forecast__c=1;
                budgetReforecast.Actuals__c=1;
            }
            budgetReforecast.isActualSubmitted__c=true;
            budgetReforecast.isActualsCopied__c=true;
            insert budgetReforecast;               
            lstBudgetSolution.add(budgetSolution);
            lstBudgetReforecast.add(budgetReforecast);
        }
    }
    public static void setupData4()
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
        
        //To create a Wave Plan Version
        wavePlanVersion1 =new Wave_Plan_Version__c();
        wavePlanVersion1.Display_tracking_message__c='Test Data';
        wavePlanVersion1.Deal__c=deal.id;
        insert wavePlanVersion1;
        
        //To create a Budget Solution
        lstBudgetSolution= new List<Budget_Solution__c>();
        lstBudgetReforecast= new List<Budget_Reforecast__c>();
        for(i=1; i<30; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            budgetSolution.isSubmitted__c=true;
            budgetSolution.isSubmittedToGovernanceLead__c=true;
            budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion1.id;
            insert budgetSolution;
            budgetReforecast=new Budget_Reforecast__c ();
            budgetReforecast.Budget_Solution__c=budgetSolution.id;
            budgetReforecast.Month_Name__c=7;
            if(i==24)
            {
                budgetReforecast.forecast__c=1;
            }
            else if(i==25)
            {
                budgetReforecast.Actuals__c=1;
            }
            else
            {
                budgetReforecast.forecast__c=1;
                budgetReforecast.Actuals__c=1;
            }
            budgetReforecast.isActualSubmitted__c=true;
            budgetReforecast.isActualsCopied__c=true;
            insert budgetReforecast;               
            lstBudgetSolution.add(budgetSolution);
            lstBudgetReforecast.add(budgetReforecast);
        }
    }

    static testMethod void testMob_BudgetActualsController()
    {
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetActualsController obj1= new Mob_BudgetActualsController(controller);
        Mob_BudgetActualsController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetActualsController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetActualsController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.saveBudgetActual();
        obj1.cancelBudgetActual();
        obj1.checkMonthIsSelected();
        obj1.submitActual();
        obj1.showNextMonths();
        obj1.showPreviousMonths();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetActualsController1()
    {
        test.starttest();
        setupData1();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetActualsController obj1= new Mob_BudgetActualsController(controller);
        Mob_BudgetActualsController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetActualsController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetActualsController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.checkMonthIsSelected();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetActualsController2()
    {
        test.starttest();
        setupData1();
        deal.Start_Date_of_Transistion__c =system.today()+366;
        upsert deal;
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetActualsController obj1= new Mob_BudgetActualsController(controller);
        Mob_BudgetActualsController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetActualsController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetActualsController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetActualsController3()
    {
        test.starttest();
        setupData1();
        deal.Start_Date_of_Transistion__c =system.today()+31;
        upsert deal;
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetActualsController obj1= new Mob_BudgetActualsController(controller);
        Mob_BudgetActualsController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetActualsController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetActualsController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetActualsController4()
    {
        test.starttest();
        setupData3();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetActualsController obj1= new Mob_BudgetActualsController(controller);
        Mob_BudgetActualsController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetActualsController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetActualsController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.saveBudgetActual();
        obj1.cancelBudgetActual();
        //obj1.checkMonthIsSelected();
        obj1.submitActual();
        obj1.showNextMonths();
        obj1.showPreviousMonths();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetActualsController5()
    {
        test.starttest();
        setupData4();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetActualsController obj1= new Mob_BudgetActualsController(controller);
        Mob_BudgetActualsController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetActualsController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetActualsController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        obj1.saveBudgetActual();
        obj1.cancelBudgetActual();
        //obj1.checkMonthIsSelected();
        obj1.submitActual();
        //obj1.showNextMonths();
        //obj1.showPreviousMonths();
        test.stoptest();
    } 

}