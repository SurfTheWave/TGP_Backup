public class ScratchpadValidation {
    public static void validateDates(list<Scratchpad_Opportunity__c> costnewrecs){
        date dummyEnddate;
        integer days_toremove ;
        for(Scratchpad_Opportunity__c cost : costnewrecs){
            if(cost.Contract_Start__c != null){
                days_toremove = cost.Contract_Start__c.day();
                dummyEnddate = cost.Contract_Start__c.addMonths(120);
                
                system.debug('end date should be'+dummyEnddate);
                if(Date.isLeapYear(cost.Contract_Start__c.year()) && dummyEnddate.month()==2 && 
                !Date.isLeapYear(cost.Contract_End__c.year())){
                    dummyEnddate = dummyEnddate.addDays(-days_toremove);
                    if(cost.Contract_Start__c.day() == 29){
                        dummyEnddate = dummyEnddate.addDays(1);
                    }
                }
                else{
                    dummyEnddate = dummyEnddate.addDays(-days_toremove);
                }
                //dummyEnddate = dummyEnddate.addDays(1);
                if(dummyEnddate < cost.Contract_End__c){
                    cost.addError('Contract duration can not be greater than 120 months.');
                }
            }
        }
    }
}