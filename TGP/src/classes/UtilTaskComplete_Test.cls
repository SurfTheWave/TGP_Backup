@isTest
/*
  @Author: 
  @Name: UtilTaskComplete_Test
  @Created Date: 
  @Description: 
  @version: 1.0
*/
private class UtilTaskComplete_Test{
    /*
      @Author: 
      @Name: UtilTaskCompleteTest
      @Created Date: 
      @Description: 
      @version: 1.0
    */
    static testMethod void UtilTaskCompleteTest(){
        List<Task> lstTask = new List<Task>();
       Opportunity opp;
       
       
       User useObj = UtilNovaUnitTest.getUser();

     User_Master__c userObj = new User_Master__c(Name = 'TestUser',User__c = useObj.id);
     Database.insert(userObj);
//     String reviewer=userObj.id;
     
     Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        database.insert( ogm);
        
        opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        database.insert( opp);
        
        
             
    //    UtilConstantsforSWB ucSWB = new UtilConstantsforSWB();
                
        Id I = UserInfo.getUserId();
         
        Task lstTask1 = new Task();        
        lstTask1.OwnerId = I;
        lstTask1.Subject = 'Call';
        lstTask1.Status = UtilConstantsforSWB.COMPLETED;
        lstTask1.Priority = 'High';
        lstTask1.ActivityDate = Date.newInstance(1960, 2, 17);
        lstTask1.whatid=opp.id;

        lstTask.add(lstTask1);
   
        database.insert( lstTask);
        
        
        Test.startTest();
       
        set<ID> lstID = new set<ID>();
        UtilTaskComplete newUtilTask = new UtilTaskComplete();
        
        string str = String.valueOf(opp.Id);
        UtilTaskComplete.taskComplete(opp.id);
        
        UtilTaskComplete.taskCompleteList(lstID);
        
        Test.stopTest();
        
                
    }
    
    /*
      @Author: 
      @Name: taskCompleteTest
      @Created Date: 
      @Description: 
      @version: 1.0
    */
    static testMethod void taskCompleteTest(){
        
        Test.startTest();
        set<ID> lstID = new set<ID>();
        List<Task> lstTask = new List<Task>();
       
    //    UtilConstantsforSWB ucSWB = new UtilConstantsforSWB();
        
        
        Id I = UserInfo.getUserId();
         
        Task lstTask1 = new Task();        
        
        lstTask1.OwnerId = I;
        lstTask1.Subject = 'Call';
        lstTask1.Status = 'In Progress';
        lstTask1.Priority = 'High';
        lstTask1.IsRecurrence=true;
        
        lstTask1.RecurrenceStartDateOnly = System.Today();
        lstTask1.RecurrenceEndDateOnly = System.Today() +1;
        lstTask1.RecurrenceType = 'RecursDaily';
        lstTask1.RecurrenceInterval = 1;
        lstTask.add(lstTask1);

        database.insert( lstTask);
        database.delete( lstTask);
        

        
        UtilTaskComplete newUtilTask = new UtilTaskComplete();
        
        string str = String.valueOf(lstTask[0].Id);
        UtilTaskComplete.taskComplete(str);
        
        UtilTaskComplete.taskCompleteList(lstID);

        Test.stopTest();

    } 
}