/*
Author : Varsha Chougule.
Story  : Story-0093/MOB_052  
Description : Test class for Mob_BudgetSolutionController

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------

*/
@isTest
private class Mob_BudgetReforecastControllerTest
{
    static Deal_TGP__c deal;
    static Wave_Plan_Version__c wavePlanVersion;
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

    static testMethod void testMob_BudgetReforecastController()
    {
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetReforecastController obj1= new Mob_BudgetReforecastController(controller);
        Mob_BudgetReforecastController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetReforecastController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetReforecastController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        List<SelectOption> listOfYear=obj1.getYearList();
        List<SelectOption> listOfMonth=obj1.getMonthList();
        obj1.monthName='6';
        obj1.addFirstMonth();
        obj1.addMonth();
        obj1.saveBudgetForecast();
        obj1.cancelBudgetForecast();
        obj1.copyActual();
        obj1.showNextMonths();
        obj1.showPreviousMonths();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetReforecastController1()
    {
        test.starttest();
        setupData1();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetReforecastController obj1= new Mob_BudgetReforecastController(controller);
        Mob_BudgetReforecastController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetReforecastController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetReforecastController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetReforecastController2()
    {
        test.starttest();
        setupData1();
        deal.Start_Date_of_Transistion__c =system.today()+366;
        upsert deal;
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetReforecastController obj1= new Mob_BudgetReforecastController(controller);
        Mob_BudgetReforecastController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetReforecastController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetReforecastController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetReforecastController3()
    {
        test.starttest();
        setupData1();
        deal.Start_Date_of_Transistion__c =system.today()+31;
        upsert deal;
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetReforecastController obj1= new Mob_BudgetReforecastController(controller);
        Mob_BudgetReforecastController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetReforecastController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetReforecastController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        test.stoptest();
    } 
    static testMethod void testMob_BudgetReforecastController4()
    {
        test.starttest();
        setupData3();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_BudgetReforecastController obj1= new Mob_BudgetReforecastController(controller);
        Mob_BudgetReforecastController.BudgetReforecast ObjBudgetReforecast= new Mob_BudgetReforecastController.BudgetReforecast(budgetReforecast);
        List<Mob_BudgetReforecastController.BudgetSolution> BudgetSolutionList=obj1.getListOfBudgetSolution();
        List<SelectOption> listOfYear=obj1.getYearList();
        List<SelectOption> listOfMonth=obj1.getMonthList();
        obj1.monthName=string.valueOf(system.today().month());
        obj1.yearName=string.valueOf(system.today().year());
        obj1.addFirstMonth();
        obj1.addMonth();
        obj1.saveBudgetForecast();
        obj1.cancelBudgetForecast();
        obj1.copyActual();
        obj1.showNextMonths();
        obj1.showPreviousMonths();
        
        obj1.firstMonthNumber=1;
        obj1.lastMonthNumber=12;
        obj1.endMonthNumber =null;
        obj1.startMonthNumber=null;
        obj1.giveStartAndEndMonth();
        obj1.firstMonthNumber=1;
        obj1.lastMonthNumber=12;
        obj1.endMonthNumber =11;
        obj1.startMonthNumber=7;
        obj1.giveStartAndEndMonth();
        obj1.firstMonthNumber=1;
        obj1.lastMonthNumber=12;
        obj1.endMonthNumber =11;
        obj1.startMonthNumber=6;
        obj1.giveStartAndEndMonth();
        obj1.firstMonthNumber=1;
        obj1.lastMonthNumber=12;
        obj1.endMonthNumber =11;
        obj1.startMonthNumber=5;
        obj1.giveStartAndEndMonth();
         obj1.startMonthNumber=10;
        obj1.firstMonthNumber=4;
        obj1.showPreviousMonths();
        obj1.convertIntoMonth1(13);
        obj1.convertIntoMonth(24,2013);
        test.stoptest();
    } 


}