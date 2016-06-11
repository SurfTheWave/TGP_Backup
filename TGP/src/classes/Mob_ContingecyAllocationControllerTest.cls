/*
Author : Varsha Chougule.
Story  : Story-0093/MOB_052  
Description : Test class for Mob_ContingecyAllocationController 

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------

*/
@isTest(SeeAlldata= true)
private class Mob_ContingecyAllocationControllerTest
{
    static Deal_TGP__c deal;
    static User testUser; 
    static Task Task1;
    static Task task2;
    static Wave_Plan_Version__c wavePlanVersion;
    static Budget_Solution__c budgetSolution;
    static Budget_Reforecast__c budgetReforecast;
    static Decimal i,j;
        
    public static void setupData()
    {
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        deal.Start_Date_of_Transistion__c =system.today()-30;
        insert deal;
       
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
		testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      	insert testUser;
        
        task1= new Task();        
        task1.OwnerId =  testUser.id;                                        
        task1.Subject = 'test for contingency Allocation';                                
        task1.Status = 'Not Started';                            
        task1.Description = 'test';                    
        insert task1;
        
        task2= new Task();
        task2.OwnerId =  testUser.id;                                       
        task2.Subject = 'test for contingency Allocation';                                
        task2.Status = 'Not Started';                            
        task2.Description = 'test1';                    
        insert task2;

        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Contingency_Amount__c=100;
        wavePlanVersion.Change_Order__c=90;
        wavePlanVersion.Cost_Overrun__c=90;
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        //To create a Budget Solution
        for(i=1; i<26; i++)
        {
            budgetSolution=new Budget_Solution__c();
            budgetSolution.Name='test';
            budgetSolution.Number__c=i;
            //budgetSolution.CTA_Cost_Model_Estimates__c=10;
            budgetSolution.Wave_Plan_Version__c=wavePlanVersion.id;
            budgetSolution.GovernanceLeadPrimaryTaskId__c=task1.id;
            budgetSolution.GovernanceLeadSecondaryTaskId__c=task2.id;
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
        wavePlanVersion.Contingency_Amount__c=100;
        wavePlanVersion.Change_Order__c=100;
        wavePlanVersion.Cost_Overrun__c=100;
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        //To create a Budget Solution
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
        wavePlanVersion.Contingency_Amount__c=1000000;
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        //To create a Budget Solution
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
            
        }
    }

    static testMethod void testMob_ContingecyAllocationController()
    {
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_ContingecyAllocationController obj1= new Mob_ContingecyAllocationController (controller);
        obj1.Option='Allocate to Contingency Partially';
        obj1.getItems();
        obj1.PartialFunc();
        obj1.NoPartialFunc();
        obj1.submitData();
        test.stoptest();    
    } 
    static testMethod void testMob_ContingecyAllocationController1()
    {
        test.starttest();
        setupData1();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_ContingecyAllocationController obj1= new Mob_ContingecyAllocationController (controller);
        obj1.Option='Allocate to Contingency Partially';
        obj1.getItems();
        obj1.PartialFunc();
        obj1.NoPartialFunc();
        obj1.submitData();
        test.stoptest();    
    } 
    static testMethod void testMob_ContingecyAllocationController2()
    {
        test.starttest();
        setupData2();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_ContingecyAllocationController obj1= new Mob_ContingecyAllocationController (controller);
        obj1.getItems();
        obj1.PartialFunc();
        obj1.NoPartialFunc();
        obj1.submitData();
        test.stoptest();    
    } 
    static testMethod void testMob_ContingecyAllocationController3()
    {
        test.starttest();
        setupData3();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef= Page.Mob_BudgetSolution;
        pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
        Test.setCurrentPageReference(pageRef);
        Mob_ContingecyAllocationController obj1= new Mob_ContingecyAllocationController (controller);
        obj1.Option='Allocate to Contingency 100%';
        obj1.getItems();
        obj1.PartialFunc();
        obj1.NoPartialFunc();
        obj1.submitData();
        test.stoptest();    
    } 


}