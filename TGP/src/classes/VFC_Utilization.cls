public with sharing class VFC_Utilization {


    public List<Utilization__c> utilizationList{get; set;}
    public List<aggregateVal> AggregateValues{get; set;}
    public String MondayDate{get; set;}
    public String MondayDate1{get; set;}
    public String MondayDate2{get; set;}
    public String MondayDate3{get; set;}
    public String MondayDate4{get; set;}
    public DateTime mondayDateOfUser{get; set;}
    public DateTime mondayDateOfUser1{get; set;}
    public DateTime mondayDateOfUser2{get; set;}
    public DateTime mondayDateOfUser3{get; set;}
    public DateTime mondayDateOfUser4{get; set;} 
    public Integer currentWeekTotal = 0;
    public Integer currentWeek1Total = 0;
    public Integer currentWeek2Total = 0;
    public Integer currentWeek3Total = 0;
    public Integer currentWeek4Total = 0;
    public String DATEFORMAT = 'dd-MMM';
    public String MONDAYDATECS = 'MondayDate';
    public String MONDAYDATE1CS = 'MondayDate+1';
    public String MONDAYDATE2CS = 'MondayDate+2';
    public String MONDAYDATE3CS = 'MondayDate+3';
    public String MONDAYDATE4CS = 'MondayDate+4';
    public String TEMPOPP1 = 'Total Allocated Time';
    public String TEMPOPP2 = 'Available For Staffing';
    public String RELATIVEURL = '/apex/VFP_Utilization';
    public String TEMPCLIENT = '.';
    
    public class aggregateVal {
        public String clientName{get;set;}
        public String opporunityName{get;set;}
        public Integer currentWeek{get;set;}
        public Integer currentWeek1{get;set;}
        public Integer currentWeek2{get;set;}
        public Integer currentWeek3{get;set;}
        public Integer currentWeek4{get;set;}     
    }
    
    public VFC_Utilization (){
        AggregateValues = new List<aggregateVal>();
        utilizationList = new List<Utilization__c>();
        Id userId = UserInfo.getUserId();
        List<Review_User_Master__c> reviewUserMasterRecordList = new List<Review_User_Master__c>();
        reviewUserMasterRecordList = [select id from Review_User_Master__c  where SFDC_User__c = :userId limit 1] ;
        if(reviewUserMasterRecordList.size() > 0) {
            utilizationList = [select BPO_Opportunity__c,BPO_Opportunity__r.Name,  Comments__c, Current_Week__c, Current_Week_1__c, Current_Week_2__c, Current_Week_3__c, Current_Week_4__c, Client_Name__c from Utilization__c where User_Master__c =:reviewUserMasterRecordList[0].Id AND (BPO_Opportunity__r.Activity__c = 'Pipeline' OR BPO_Opportunity__r.Activity__c = 'Unqualified' OR BPO_Opportunity__r.Name = 'PTO' OR BPO_Opportunity__r.Name = 'Training' OR BPO_Opportunity__r.Name = 'Other Deal Support' OR BPO_Opportunity__r.Name = 'Other Unavailable') order by Client_Name__c Desc ,BPO_Opportunity__r.Name Desc limit 10000];           
        }
        
        Utilization_Date__c myCS = Utilization_Date__c.getValues(MONDAYDATECS);
        Date dToday = System.Today();
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
        String todaysDay = dt.format('EEEE'); 
        if (myCS != null) {
              
            String DayOfWeek = myCS.ReferenceDate__c.format('EEEE');                            
            if(DayOfWeek.equalsignorecase('Sunday') && todaysDay.equalsignorecase('Sunday')) {
                mondayDateOfUser = myCS.ReferenceDate__c - 6;
            }
            else if(DayOfWeek.equalsignorecase('Sunday')){
                mondayDateOfUser = myCS.ReferenceDate__c + 1;
            }
            else {
                mondayDateOfUser = myCS.ReferenceDate__c;
            }
        }
        mondayDateOfUser1 = mondayDateOfUser +7;
        mondayDateOfUser2 = mondayDateOfUser1 +7;
        mondayDateOfUser3 = mondayDateOfUser2 +7;
        mondayDateOfUser4 = mondayDateOfUser3 +7;
        
        MondayDate = mondayDateOfUser.format(DATEFORMAT);                
        MondayDate1 = mondayDateOfUser1.format(DATEFORMAT);
        MondayDate2 = mondayDateOfUser2.format(DATEFORMAT);
        MondayDate3 = mondayDateOfUser3.format(DATEFORMAT);
        MondayDate4 = mondayDateOfUser4.format(DATEFORMAT);
        
        aggregateVal aggregateValInstance = new aggregateVal();        
        for(Utilization__c ut :utilizationList) {
            currentWeekTotal = Integer.valueOf(currentWeekTotal + (ut.Current_Week__c == null? 0:ut.Current_Week__c));
            currentWeek1Total = Integer.valueOf(currentWeek1Total + (ut.Current_Week_1__c == null? 0:ut.Current_Week_1__c));
            currentWeek2Total = Integer.valueOf(currentWeek2Total + (ut.Current_Week_2__c == null? 0:ut.Current_Week_2__c));
            currentWeek3Total = Integer.valueOf(currentWeek3Total + (ut.Current_Week_3__c == null? 0:ut.Current_Week_3__c));
            currentWeek4Total = Integer.valueOf(currentWeek4Total + (ut.Current_Week_4__c == null? 0:ut.Current_Week_4__c));
        }
        
        aggregateValInstance.clientName = TEMPCLIENT;
        aggregateValInstance.opporunityName = TEMPOPP1;
        aggregateValInstance.currentWeek = currentWeekTotal;
        aggregateValInstance.currentWeek1 = currentWeek1Total;
        aggregateValInstance.currentWeek2 = currentWeek2Total;
        aggregateValInstance.currentWeek3 = currentWeek3Total;
        aggregateValInstance.currentWeek4 = currentWeek4Total;
        AggregateValues.add(aggregateValInstance);
        
        aggregateValInstance = new aggregateVal();        
        aggregateValInstance.clientName = TEMPCLIENT;
        aggregateValInstance.opporunityName = TEMPOPP2;
        aggregateValInstance.currentWeek = (100 - currentWeekTotal < 0? 0:100-currentWeekTotal);
        aggregateValInstance.currentWeek1 = (100 - currentWeek1Total < 0? 0:100-currentWeek1Total);
        aggregateValInstance.currentWeek2 = (100 - currentWeek2Total < 0? 0:100-currentWeek2Total);
        aggregateValInstance.currentWeek3 = (100 - currentWeek3Total < 0? 0:100-currentWeek3Total);
        aggregateValInstance.currentWeek4 = (100 - currentWeek4Total < 0? 0:100-currentWeek4Total); 
        AggregateValues.add(aggregateValInstance);
        
    }
    
    public pageReference doSave() {
        for(Utilization__c ut :utilizationList) {
            if(ut.Current_Week__c == null)
                ut.Current_Week__c = 0;
            if(ut.Current_Week_1__c == null)
                ut.Current_Week_1__c = 0; 
            if(ut.Current_Week_2__c == null)
                ut.Current_Week_2__c = 0; 
            if(ut.Current_Week_3__c == null)
                ut.Current_Week_3__c = 0; 
            if(ut.Current_Week_4__c == null)
                ut.Current_Week_4__c = 0;         
        }          
        upsert utilizationList;  
        PageReference pageRef = new PageReference(relativeURL);
        pageRef.setRedirect(true);       
        return pageRef;
        
    }
    
    public pageReference doCancel() {
        PageReference pageRef = new PageReference(relativeURL);
        pageRef.setRedirect(true);
        return pageRef;
    }





}