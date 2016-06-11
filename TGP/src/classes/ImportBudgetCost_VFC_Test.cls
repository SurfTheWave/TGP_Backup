@isTest
/*
  @Author: 
  @Name: ImportBudgetCost_VFC_Test
  @Created Date: 01 January 2015
  @Description: This is a test class for importing budgeting cost for VFC
  @version: 1.0
*/
private class ImportBudgetCost_VFC_Test{
/*
  @Author: 
  @Name: setupdata
  @Created Date: 01 January 2015
  @Description: This is a Mobilization_Plan__c type mehod for data setup.
  @version: 1.0
*/    
    public static  Mobilization_Plan__c setupdata(){
        
        //inserting BudgetCost 
        BudgetCost_field_map__c bdgtcost =new BudgetCost_field_map__c(Name='Name',Column_Order__c= 0);
        insert bdgtcost;
        //Inserting New Deal
        Deal__c strDeal = new Deal__c(Name='DealTest123');
        insert strDeal;
        
        //inserting New Plan under Deal
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, Active__c =True);
        //insert strmobplan;
        return strmobplan;
    }
/*
  @Author: 
  @Name: test
  @Created Date: 01 January 2015
  @Description: This is a test method test.
  @version: 1.0
*/    
    static testMethod void test(){
        Mobilization_Plan__c plantest= setupdata();
        insert plantest;
        
        //inserting budget cost summary
        Budget_Cost_Summary__c bdgetsummary = new Budget_Cost_Summary__c(Actuals_Cost_000__c=40,EAC_Cost_000__c=50,Serial_Number__c=02);
        insert bdgetsummary;
        
        //inserting Attachment
        Attachment attchment1=new Attachment();
        attchment1.parentId=plantest.Id;
        attchment1.Name='Test1';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attchment1.body=bodyBlob1;
    insert attchment1;
        
        
        //setupdata();
        Test.starttest();
            
      ApexPages.StandardController sc = new ApexPages.StandardController(plantest);
        
        ImportBudgetCost_VFC import_VFC = new ImportBudgetCost_VFC(sc);
        import_VFC.allLines_Cost_Summary_MWB = 'allLines_Cost_Summary_MWB,Cost Summary - MWB\n\nName»ODE Cost ($000)»Actuals Cost ($000)»Forecasts Cost ($000)»EAC Cost ($000)»ODE Variance Cost ($000)\n Total Program Management»40.00»40.00»40.00»40.00»40.00\n Total Enable People»40.00»40.00»40.00»40.00»40.00\n';
        import_VFC.fileBody =Blob.valueOf('Unit Test Attachment Body123456'); 
        import_VFC.Description ='testdescription'; 
        import_VFC.hlmpid =plantest.id; 
            
        //inserting Attachment.
        Attachment attchment=new Attachment();
        attchment.parentId=plantest.Id;
        attchment.Name='Test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attchment.body=bodyBlob;
    insert attchment;
  
        
        import_VFC.UploadFile();
        import_VFC.generateReport();
        
        Test.stoptest();
  }

/*
  @Author: 
  @Name: test1
  @Created Date: 01 January 2015
  @Description: This is a test mehtod test1
  @version: 1.0
*/    
    static testMethod void test1(){
        Mobilization_Plan__c plantest= setupdata();
        insert plantest;
        
        //inserting budget cost summary
        Budget_Cost_Summary__c bdgetsummary1 = new Budget_Cost_Summary__c(Actuals_Cost_000__c=40,EAC_Cost_000__c=50,Serial_Number__c=02);
        insert bdgetsummary1;
        
        //inserting Attachment
        Attachment attchment21=new Attachment();
        attchment21.parentId=plantest.Id;
        attchment21.Name='Test1';
        Blob bodyBlob21=Blob.valueOf('Unit Test Attachment Body');
        attchment21.body=bodyBlob21;
    insert attchment21;
        
        
        //setupdata();
        Test.starttest();
            
      ApexPages.StandardController sc = new ApexPages.StandardController(plantest);
        
        ImportBudgetCost_VFC import_VFC = new ImportBudgetCost_VFC(sc);
        import_VFC.allLines_Cost_Summary_MWB = 'Cost Summary - MWB\n\nName»ODE Cost ($000)»Actuals Cost ($000)»Forecasts Cost ($000)»EAC Cost ($000)»ODE Variance Cost ($000)\n Total Program Management»40.00»40.00»40.00»40.00»40.00\n Total Enable People»40.00»40.00»40.00»40.00»40.00\n';
        //import_VFC.fileBody =Blob.valueOf('Unit Test Attachment Body123456'); 
        //import_VFC.Description ='testdescription'; 
        //import_VFC.hlmpid =plantest.id; 
            
        //inserting Attachment.
        /*Attachment attchment=new Attachment();
        attchment.parentId=plantest.Id;
        attchment.Name='Test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attchment.body=bodyBlob;
    insert attchment; */
  
        
        import_VFC.UploadFile();
        import_VFC.generateReport();
        
        Test.stoptest();
  }

}