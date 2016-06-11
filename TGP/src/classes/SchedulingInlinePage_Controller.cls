public without sharing class SchedulingInlinePage_Controller {

    public String oppId{get;set;}
    public Boolean addButtonRender{get;set;}
    public Boolean nonAdminUser{get; set;}
    Date d;
    public boolean isEdit{get; set;}
    public String mondayDate{get; set;}
    public String nextMondayDate{get; set;}
    public String nextMondayDate1{get; set;}
    public String nextMondayDate2{get; set;}
    public List<Scheduling__c> lstSc{get; set;}
    public List<Scheduling__c> schRecordList;
    public Scheduling__c schRecord{get;set;}
    public SchedulingInlinePage_Controller(ApexPages.StandardController controller){
    
         oppId = ApexPages.CurrentPage().getParameters().get('id');
         
          nonAdminUser = true;
          isEdit = false;
        
         String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if(userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
            addButtonRender=true;
            isEdit = true;
            nonAdminUser = false;
        }
        addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
        
        /*d = System.today();
         
        Date mondayDate1 = d.toStartofWeek();
        DateTime mondayDate2; 
        DateTime mondayDateTime = datetime.newInstance(mondayDate1.year(), mondayDate1.month(),mondayDate1.day());  
        datetime myDate = datetime.newInstance(d.year(), d.month(),d.day());  
        String DayOfWeek = myDate.format('EEEE');                            
        if(DayOfWeek.equalsignorecase('Sunday')) {
            mondayDate2 = mondayDateTime - 6;
        }
        else {
            mondayDate2 = mondayDateTime + 1;
        }
        //DateTime mondayDate2 = mondayDate1 + 1;
        DateTime mondayDate3 = mondayDate2 + 7;
        DateTime mondayDate4 = mondayDate3 + 7;
        DateTime mondayDate5 = mondayDate4 + 7;
        
        mondayDate = mondayDate2.format('dd-MMM'); 
        nextMondayDate = mondayDate3.format('dd-MMM');
        nextMondayDate1 = mondayDate4.format('dd-MMM');
        nextMondayDate2 = mondayDate5.format('dd-MMM');*/
        
        initializeRecords();
        
    }
    public void initializeRecords(){
        
            lstSc = [SELECT Role_Name__c,User_Master__c,User_Master__r.name,Key_Field__c,First_Date__c,User_SFDC_Id__c,Current_week__c ,Current_week_1__c ,Current_week_2__c ,Current_week_3__c ,Ongoing__c ,User_Id__c,offerings__c FROM Scheduling__c WHERE BPO_Opportunity_MD__c=: oppId AND isDateActive__c != true];
            schRecordList = [SELECT Role_Name__c,MondayDate__c ,MondayDate_1__c,MondayDate_2__c,MondayDate_3__c,First_Date__c,User_SFDC_Id__c,Current_week__c ,Current_week_1__c ,Current_week_2__c ,Current_week_3__c ,Ongoing__c ,User_Id__c,offerings__c FROM Scheduling__c WHERE BPO_Opportunity_MD__c=: oppId AND isDateActive__c =: true limit 1];
            
            
            System.debug('------------schRecordList----------'+schRecordList);
            
            if(schRecordList != null && schRecordList.size()>0){
            
                schRecord = schRecordList[0];
                 mondayDate = schRecord.MondayDate__c.format('dd-MMM','GMT');
                nextMondayDate = schRecord.MondayDate_1__c.format('dd-MMM','GMT'); 
                nextMondayDate1 = schRecord.MondayDate_2__c.format('dd-MMM','GMT'); 
                nextMondayDate2 = schRecord.MondayDate_3__c.format('dd-MMM','GMT');
            }
            
            System.debug('--------mondayDate ------------------'+mondayDate );
            System.debug('--------nextMondayDate ------------------'+nextMondayDate );
            System.debug('--------nextMondayDate1 ------------------'+nextMondayDate1 );
            System.debug('--------nextMondayDate2 ------------------'+nextMondayDate2 );
            
             
        System.debug('-------------list before save'+lstSc);
    }
    
    public void doSave()
    {
     Boolean regexTestResult;
     Integer count = 0;
    for(Scheduling__c validateDate : lstSc)
    {
         regexTestResult = checkNumberFormat(validateDate.Current_week__c,validateDate.Current_week_1__c,validateDate.Current_week_2__c,validateDate.Current_week_3__c,validateDate.Ongoing__c); 
         
         if(validateDate.Current_week__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in current week.'));
         }
         else if(validateDate.Current_week_1__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in current week+1.'));
         }
         else if(validateDate.Current_week_2__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in current week+2.'));
         }
         else if(validateDate.Current_week_3__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in current week+3.'));
         }
         else if(validateDate.Ongoing__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in Ongoing Field.'));
         }
         else if(regexTestResult == true)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'please enter non negative numeric value'));    
         }
    
    }
    if(count == 0)
    {
        try
        {
            System.debug('-------------list before save'+lstSc);
             upsert lstSc;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully!'));  
        }
        catch(Exception e)
        {
            System.debug('-------------in catch-------');
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
          return;
        }
     }   
 }
     public pagereference doCancel()
     {
           initializeRecords();
           return null;
           
     }
     public Boolean checkNumberFormat(Decimal currentWeek,Decimal currentWeek1,Decimal currentWeek2,Decimal currentWeek3,Decimal onGoing) 
    {
        Boolean returnValue = true;
        Boolean falseReturnValue = false;
        Boolean result = true;
        Boolean result1 = true;
        Boolean result2 = true;
        Boolean result3 = true;
        Boolean resultOnGoing = true;
        String numberRegex= '^([0-9][0-9]*)$';
        Pattern MyPattern = Pattern.compile(numberRegex);
        
        if(currentWeek != null)
        {
            String currentWeekValue = String.valueof(currentWeek);
            Matcher MyMatcher = MyPattern.matcher(currentWeekValue);
            result = MyMatcher.matches();
        }
        if(currentWeek1 != null)
        {
            String currentWeekValue1 = String.valueof(currentWeek1);
            Matcher MyMatcher = MyPattern.matcher(currentWeekValue1);
            result1 = MyMatcher.matches();
        }
        if(currentWeek2 != null)
        {
            String currentWeekValue2 = String.valueof(currentWeek2);
            Matcher MyMatcher = MyPattern.matcher(currentWeekValue2);
            result2 = MyMatcher.matches();
        }
        if(currentWeek3 != null)
        {
            String currentWeekValue3 = String.valueof(currentWeek3);
            Matcher MyMatcher = MyPattern.matcher(currentWeekValue3);
            result3 = MyMatcher.matches();
        }
        if(onGoing != null)
        {
            String ongoingText = String.valueof(onGoing);
            Matcher MyMatcher = MyPattern.matcher(ongoingText);
            resultOnGoing = MyMatcher.matches();
        }
        if(result && result1 && result2 && result3 && resultOnGoing)
        {
            return false;    
        }
        else
        {
            return true;
        }
        
    }
}