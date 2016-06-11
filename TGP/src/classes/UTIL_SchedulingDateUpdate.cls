public class UTIL_SchedulingDateUpdate
{
    List<Scheduling__c> listToUpdate = new List<Scheduling__c>();
    
    Date d ;
    DateTime mondayDate2;
    
    public void getDateAndTime(){
        Scheduling_Date__c myCS2 = Scheduling_Date__c.getInstance('Execution Date');
        Date executionDate = myCS2.Execution_Date__c;
        
        if(executionDate == null || executionDate < System.today()) {
            d = System.today();
        }
        else {
            d = executionDate;
        } 
        
        system.debug('------D------'+d);
        Date mondayDate1 = d.toStartofWeek();
        //DateTime mondayDate2; 
        DateTime mondayDateTime = datetime.newInstance(mondayDate1.year(), mondayDate1.month(),mondayDate1.day());  
        datetime myDate = datetime.newInstance(d.year(), d.month(),d.day());  
        String DayOfWeek = myDate.format('EEEE');                            
        if(DayOfWeek.equalsignorecase('Sunday')) {
            mondayDate2 = mondayDateTime - 6;
        }
        else {
            mondayDate2 = mondayDateTime + 1;
        }
        
        System.debug('------mondayDate2 -----------'+mondayDate2);
    }
    public void updateDate(List<Scheduling__c> schedulingObjRecList)
    {
        getDateAndTime();
        System.debug('------mondayDate2 -----------'+mondayDate2);
        Date currentWeeksDate = mondayDate2.date();
    
        for(Scheduling__c schRec : schedulingObjRecList)
        {   
        
        if(mondayDate2 != schRec.First_Date__c) {
        
            date firstDate = schRec.First_Date__c.date();
            System.debug('------currentWeeksDate-----------'+currentWeeksDate);
            System.debug('------firstDate-----------'+firstDate);
            
            Decimal decimalDateValue = firstDate.daysBetween(currentWeeksDate);
            
            System.debug('--------decimalDateValue------------------'+decimalDateValue);
            
            Integer integerDateValue = firstDate.daysBetween(currentWeeksDate);
            
            System.debug('--------integerDateValue------------------'+integerDateValue);
            
            Decimal decimalDateValue1 = (firstDate.daysBetween(currentWeeksDate))/7;
            
            System.debug('--------decimalDateValue1------------------'+decimalDateValue1);
            
            Integer A = (firstDate.daysBetween(currentWeeksDate))/7;
            
            system.debug('--A---'+ A);
            
            if(schRec.isDateActive__c == true){


                        system.debug('--MondayDate__c Upper---'+ schRec.MondayDate__c );
                        system.debug('--MondayDate_1_c Upper---'+ schRec.MondayDate_1__c );
                        system.debug('--MondayDate__c 2 Upper---'+ schRec.MondayDate_2__c );
                        system.debug('--MondayDate__c  3 Upper---'+ schRec.MondayDate_3__c );
                        system.debug('--First_Date__c Upper---'+ schRec.First_Date__c);
                        
                        schRec.MondayDate__c = mondayDate2;
                        schRec.MondayDate_1__c = schRec.MondayDate__c + 7;
                        schRec.MondayDate_2__c = schRec.MondayDate_1__c + 7;
                        schRec.MondayDate_3__c = schRec.MondayDate_2__c + 7;
                        schRec.First_Date__c = mondayDate2;
                        
                        /*schRec.MondayDate__c = schRec.MondayDate__c + (7*A);
                        schRec.MondayDate_1__c = schRec.MondayDate_1__c + (7*A);
                        schRec.MondayDate_2__c = schRec.MondayDate_2__c + (7*A);
                        schRec.MondayDate_3__c = schRec.MondayDate_3__c + (7*A);
                        schRec.First_Date__c = schRec.First_Date__c + (7*A); */ 
                        
                        system.debug('--MondayDate__c ---'+ schRec.MondayDate__c );
                        system.debug('--MondayDate_1_c ---'+ schRec.MondayDate_1__c );
                        system.debug('--MondayDate__c 2---'+ schRec.MondayDate_2__c );
                        system.debug('--MondayDate__c  3---'+ schRec.MondayDate_3__c );
                        system.debug('--First_Date__c---'+ schRec.First_Date__c);
                        
            //MondayDate = MondayDate+(7*A);
            //MondayDate_1 = MondayDate+(7*A)+7;
            //MondayDate_2 = MondayDate+(7*A)+14;
            //MondayDate_3 = MondayDate+(7*A)+28;
        }
        else
        { 
        if(A == 0) {
        
            schRec.Current_week__c = schRec.Current_week__c;
            schRec.Current_week_1__c = schRec.Current_week_1__c;
            schRec.Current_week_2__c = schRec.Current_week_2__c;
            schRec.Current_week_3__c = schRec.Current_week_3__c ;
            schRec.First_Date__c = schRec.First_Date__c ; 
        
            
        }
        else if(A == 1) {

             schRec.Current_week__c = schRec.Current_week_1__c;
                     schRec.Current_week_1__c = schRec.Current_week_2__c;
                     schRec.Current_week_2__c = schRec.Current_week_3__c;
                     schRec.Current_week_3__c = 0;
                     schRec.First_Date__c = schRec.First_Date__c + (7*A); 
                     
                     system.debug('--Current_week_1__c ---'+ schRec.Current_week_1__c );
                        system.debug('--Current_week_2__c ---'+ schRec.Current_week_2__c );
                        system.debug('--Current_week_3__c 2---'+ schRec.Current_week_3__c );
                        system.debug('--Current_week__c ---'+ schRec.Current_week__c );
                        system.debug('--First_Date__c---'+ schRec.First_Date__c);  

        /*curr= curr1;
        curr1= curr2;
        curr2= curr3;
        curr3= curr4;
        curr4= 0;*/
        }
        else if(A == 2) {
        
             schRec.Current_week__c = schRec.Current_week_2__c ;
                     schRec.Current_week_1__c = schRec.Current_week_3__c;
                     schRec.Current_week_2__c = 0;
                     schRec.Current_week_3__c = 0;
                     schRec.First_Date__c = schRec.First_Date__c + (7*A);
                     
                     system.debug('--Current_week_1__c ---'+ schRec.Current_week_1__c );
                        system.debug('--Current_week_2__c ---'+ schRec.Current_week_2__c );
                        system.debug('--Current_week_3__c 2---'+ schRec.Current_week_3__c );
                        system.debug('--Current_week__c ---'+ schRec.Current_week__c );
                        system.debug('--First_Date__c---'+ schRec.First_Date__c); 

        /*curr= curr2;
        curr1= curr3;
        curr2= curr4
        curr3= 0;
        curr4= 0;*/
        }
        else if(A == 3) {

            schRec.Current_week__c = schRec.Current_week_3__c ;
                        schRec.Current_week_1__c = 0;
                        schRec.Current_week_2__c = 0;
                        schRec.Current_week_3__c = 0;
                        schRec.First_Date__c = schRec.First_Date__c + (7*A);
                        
                        system.debug('--Current_week_1__c ---'+ schRec.Current_week_1__c );
                        system.debug('--Current_week_2__c ---'+ schRec.Current_week_2__c );
                        system.debug('--Current_week_3__c 2---'+ schRec.Current_week_3__c );
                        system.debug('--Current_week__c ---'+ schRec.Current_week__c );
                        system.debug('--First_Date__c---'+ schRec.First_Date__c); 

        /*curr= curr3;
        curr1= curr4;
        curr2= 0
        curr3= 0;
        curr4= 0;*/
            }
        
        else{
                        schRec.Current_week__c = 0;
                        schRec.Current_week_1__c = 0;
                        schRec.Current_week_2__c = 0;
                        schRec.Current_week_3__c = 0;
                        schRec.First_Date__c = schRec.First_Date__c + (7*A);
                        
                        system.debug('--Current_week_1__c ---'+ schRec.Current_week_1__c );
                        system.debug('--Current_week_2__c ---'+ schRec.Current_week_2__c );
                        system.debug('--Current_week_3__c 2---'+ schRec.Current_week_3__c );
                        system.debug('--Current_week__c ---'+ schRec.Current_week__c );
                        system.debug('--First_Date__c---'+ schRec.First_Date__c); 
        }
    }


                 /*if(schRec.isDateActive__c == true){
                 
                     schRec.MondayDate__c = schRec.MondayDate_1__c ;
                     schRec.MondayDate_1__c = schRec.MondayDate_2__c ;
                     schRec.MondayDate_2__c = schRec.MondayDate_3__c ;
                     schRec.MondayDate_3__c = schRec.MondayDate_3__c + 7;
                     schRec.First_Date__c = schRec.First_Date__c + 7;
                 }
                 else{          
                     schRec.Current_week__c = schRec.Current_week_1__c;
                     schRec.Current_week_1__c = schRec.Current_week_2__c;
                     schRec.Current_week_2__c = schRec.Current_week_3__c;
                     schRec.Current_week_3__c = 0;
                     schRec.First_Date__c = schRec.First_Date__c + 7;
                 }*/
                 listToUpdate.add(schRec);
             }
             
        }
        
        System.debug('--------listToUpdate-----------'+listToUpdate);
        
        try{
            
            update listToUpdate;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
        }
    }
}