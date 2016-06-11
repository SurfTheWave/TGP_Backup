/*
@Author and Created Date : System ,  2/10/2015 9:37 AM
@name : VFC_Utilizations 
@Description : 
@Version : 
*/
public with sharing class VFC_Utilizations {

    public Id userId;
    public String Email;
    public String sheetThrowingException = UtilConstants.EMPTY_STRING;
    public List < User_Master__c > reviewUserMasterRecordList {
        get;
        set;
    }
    public List < Utilizations__c > utilizationList {
        get;
        set;
    }
    public list<utilizations__c> utilizationList1 {set;get;}
    public Utilizations__c uRec {
        get;
        set;
    }
    public List < aggregateVal > AggregateValues {
        get;
        set;
    }
    public List < aggregateVal1 > AggregateValues1 {
        get;
        set;
    }

    public String MondayDate {
        get;
        set;
    }
    public String MondayDate1 {
        get;
        set;
    }
    public String MondayDate2 {
        get;
        set;
    }
    public String MondayDate3 {
        get;
        set;
    }
    public String MondayDate4 {
        get;
        set;
    }
    public String MondayDate5 {
        get;
        set;
    }
    public Date mondayDateOfUser {
        get;
        set;
    }
    public Date mondayDateOfUser1 {
        get;
        set;
    }
    public Date mondayDateOfUser2 {
        get;
        set;
    }
    public Date mondayDateOfUser3 {
        get;
        set;
    }
    public Date mondayDateOfUser4 {
        get;
        set;
    }
    public Date mondayDateOfUser5 {
        get;
        set;
    }
    
    public Map<Integer,String> MapMonthList = new Map<Integer,String>();
 

    public Integer currentWeekTotal = UtilConstants.IntZERO;
    public Integer currentWeek1Total = UtilConstants.IntZERO;
    public Integer currentWeek2Total = UtilConstants.IntZERO;
    public Integer currentWeek3Total = UtilConstants.IntZERO;
    public Integer currentWeek4Total = UtilConstants.IntZERO;


    public Decimal currentWeekTotalPercent = UtilConstants.IntZERO;
    public Decimal currentWeek1TotalPercent = UtilConstants.IntZERO;
    public Decimal currentWeek2TotalPercent = UtilConstants.IntZERO;
    public Decimal currentWeek3TotalPercent = UtilConstants.IntZERO;
    public Decimal currentWeek4TotalPercent = UtilConstants.IntZERO;

    public String DATEFORMAT = UtilConstants.FORMAT_DATE_MNTH;
    public String MONDAYDATECS = UtilConstants.MONDATE;
    public String MONDAYDATE1CS = UtilConstants.MONDATE1;
    public String MONDAYDATE2CS = UtilConstants.MONDATE2;
    public String MONDAYDATE3CS = UtilConstants.MONDATE3;
    public String MONDAYDATE4CS = UtilConstants.MONDATE4;
    public String TEMPOPP1 = UtilConstants.TOTAL_ALL_TIME;
    public String TEMPOPP2 = UtilConstants.AVAIL_FOR_STAFF;
    public String TEMPOPP3 = UtilConstants.TOTAL_OOF_TIME;
    public String RELATIVEURL = UtilConstants.PAGE_UTILIZATIONS;
    public String TEMPCLIENT = UtilConstants.EMPTY_STRING;

    /******************************
    Method Name: aggregateVal 
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public class aggregateVal {
        public String clientName {
            get;
            set;
        }
        public String opporunityName {
            get;
            set;
        }
        public Integer currentWeek {
            get;
            set;
        }
        public Integer currentWeek1 {
            get;
            set;
        }
        public Integer currentWeek2 {
            get;
            set;
        }
        public Integer currentWeek3 {
            get;
            set;
        }
        public Integer currentWeek4 {
            get;
            set;
        }

    }

    /******************************
    Method Name: aggregateVal1
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public class aggregateVal1 {

        public String clientName {
            get;
            set;
        }
        public String opporunityName {
            get;
            set;
        }
        public Integer currentWeekPercent {
            get;
            set;
        }
        public Integer currentWeek1Percent {
            get;
            set;
        }
        public Integer currentWeek2Percent {
            get;
            set;
        }
        public Integer currentWeek3Percent {
            get;
            set;
        }
        public Integer currentWeek4Percent {
            get;
            set;
        }

    }
    //Id userId;
    //String Email;



    /******************************
    Method Name: VFC_Utilizations 
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public VFC_Utilizations() {
        init();
    }

    /******************************
    Method Name: init
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public void init() {
    
    MapMonthList.put(1,'Jan');
    MapMonthList.put(2,'Feb');
    MapMonthList.put(3,'Mar');
    MapMonthList.put(4,'Apr');
    MapMonthList.put(5,'May');
    MapMonthList.put(6,'Jun');
    MapMonthList.put(7,'Jul');
    MapMonthList.put(8,'Aug');
    MapMonthList.put(9,'Sep');
    MapMonthList.put(10,'Oct');
    MapMonthList.put(11,'Nov');
    MapMonthList.put(12,'Dec');
    
        try {
            AggregateValues = new List < aggregateVal > ();
            AggregateValues1 = new List < aggregateVal1 > ();
            utilizationList = new List < Utilizations__c > ();
            utilizationList1 = new List < Utilizations__c > ();
            uRec = new Utilizations__c();
            userId = ApexPages.currentPage().getParameters().get('Id');
            if(userId == null)
              userId = UserInfo.getUserId();
            Email = [Select Email from User where Id = : userId Limit 1].Email;

            reviewUserMasterRecordList = new List < User_Master__c > ();
            reviewUserMasterRecordList = [select id, name from User_Master__c where user__c = : userId and email__c = : Email limit 1];
           
            if (reviewUserMasterRecordList.size() > 0) {
                utilizationList = [select Opportunity__c, Opportunity__r.Name, User_Role_s__c, Comments__c, Current_Week__c, Current_Week_1__c, 
                                Current_Week_2__c, Current_Week_3__c, Current_Week_4__c, Client_Name__c from Utilizations__c
                                where User__c = : reviewUserMasterRecordList[0].Id AND
                                (Opportunity__r.Reporting_Status__c = : UtilConstants.PIPELINE OR 
                                Opportunity__r.Reporting_Status__c = : UtilConstants.UNQUALIFIED/* OR 
                                Opportunity__r.Name = : UtilConstants.OPP_NAME_LIST_0 OR 
                                Opportunity__r.Name = : UtilConstants.OPP_NAME_LIST_1 OR
                                Opportunity__r.Name = : UtilConstants.OPP_NAME_LIST_2 */) AND Opportunity__r.Accountid !=null AND 
                                Opportunity__r.Accountid !='' AND (Opportunity__r.Name != : UtilConstants.OPP_NAME_LIST )
                                order by LastModifiedDate desc  /*, Opportunity__r.Name Desc*/ limit 10000];
       // system.debug('util list---------->'+utilizationList );
       utilizationList1 =[select Opportunity__c, Opportunity__r.Name, User_Role_s__c, Comments__c, Current_Week__c, Current_Week_1__c, 
                                Current_Week_2__c, Current_Week_3__c, Current_Week_4__c, Client_Name__c from Utilizations__c
                                where User__c = : reviewUserMasterRecordList[0].Id AND
                                (/*Opportunity__r.Reporting_Status__c = : UtilConstants.PIPELINE OR 
                                Opportunity__r.Reporting_Status__c = : UtilConstants.UNQUALIFIED OR */
                                Opportunity__r.Name = : UtilConstants.OPP_NAME_LIST_0 OR 
                                Opportunity__r.Name = : UtilConstants.OPP_NAME_LIST_1 OR 
                                Opportunity__r.Name = : UtilConstants.OPP_NAME_LIST_2 ) order by Opportunity__r.name desc limit 5];
               utilizationList.addAll(utilizationList1);
                uRec = [select Opportunity__c, Opportunity__r.Name, User_Role_s__c, Comments__c,
                        Current_Week__c, Current_Week_1__c, Current_Week_2__c, Current_Week_3__c,
                        Current_Week_4__c, Client_Name__c from Utilizations__c
                        where User__c = : reviewUserMasterRecordList[0].Id AND(Opportunity__r.Name = : UtilConstants.OPP_NAME_LIST ) limit 1];

            }
            Utilization_weekStartDate__c myCS = Utilization_weekStartDate__c.getValues(MONDAYDATECS);
            
            system.debug('myCS 246:'+myCS);
            
            //system.debug('custom settings::::;'+myCS);
            Date dToday = System.Today();           

            mondayDateOfUser= myCS.Referenced_Date__c;

            mondayDateOfUser1 = mondayDateOfUser + 7;

            mondayDateOfUser2 = mondayDateOfUser1 + 7;

            mondayDateOfUser3 = mondayDateOfUser2 + 7;

            mondayDateOfUser4 = mondayDateOfUser3 + 7;

            mondayDateOfUser5 = mondayDateOfUser4 + 7;


            MondayDate = String.valueOf(mondayDateOfUser.day()+'-'+MapMonthList.get(mondayDateOfUser.month()));
            MondayDate1 = String.valueOf(mondayDateOfUser1.day()+'-'+MapMonthList.get(mondayDateOfUser1.month())); //mondayDateOfUser1.format(DATEFORMAT);
            MondayDate2 = String.valueOf(mondayDateOfUser2.day()+'-'+MapMonthList.get(mondayDateOfUser2.month())); //mondayDateOfUser2.format(DATEFORMAT);
            MondayDate3 = String.valueOf(mondayDateOfUser3.day()+'-'+MapMonthList.get(mondayDateOfUser3.month())); //mondayDateOfUser3.format(DATEFORMAT);
            MondayDate4 = String.valueOf(mondayDateOfUser4.day()+'-'+MapMonthList.get(mondayDateOfUser4.month())); //mondayDateOfUser4.format(DATEFORMAT);
            MondayDate5 = String.valueOf(mondayDateOfUser5.day()+'-'+MapMonthList.get(mondayDateOfUser5.month())); //mondayDateOfUser5.format(DATEFORMAT);

            aggregateVal1 aggregateValInstance1 = new aggregateVal1();

           system.debug('-- MondayDate3-290:'+MondayDate3);

            aggregateVal1 aggregatepto = new aggregateVal1();
            aggregatepto.clientName = TEMPCLIENT;
            aggregatepto.opporunityName = TEMPOPP3;
            aggregatepto.currentWeekPercent = Integer.valueOf(uRec.Current_Week__c);
            currentWeekTotalPercent = aggregatepto.currentWeekPercent;
            aggregatepto.currentWeek1Percent = Integer.valueOf(uRec.Current_Week_1__c);
            currentWeek1TotalPercent = aggregatepto.currentWeek1Percent;
            aggregatepto.currentWeek2Percent = Integer.valueOf(uRec.Current_Week_2__c);
            currentWeek2TotalPercent = aggregatepto.currentWeek2Percent;
            aggregatepto.currentWeek3Percent = Integer.valueOf(uRec.Current_Week_3__c);
            currentWeek3TotalPercent = aggregatepto.currentWeek3Percent;
            aggregatepto.currentWeek4Percent = Integer.valueOf(uRec.Current_Week_4__c);
            currentWeek4TotalPercent = aggregatepto.currentWeek4Percent;
            AggregateValues1.add(aggregatepto);

            aggregateVal aggregateValInstance = new aggregateVal();
            for (Utilizations__c ut: utilizationList) {
                currentWeekTotal = Integer.valueOf(currentWeekTotal + (ut.Current_Week__c == null ? 0 : ut.Current_Week__c));
                currentWeek1Total = Integer.valueOf(currentWeek1Total + (ut.Current_Week_1__c == null ? 0 : ut.Current_Week_1__c));
                currentWeek2Total = Integer.valueOf(currentWeek2Total + (ut.Current_Week_2__c == null ? 0 : ut.Current_Week_2__c));
                currentWeek3Total = Integer.valueOf(currentWeek3Total + (ut.Current_Week_3__c == null ? 0 : ut.Current_Week_3__c));
                currentWeek4Total = Integer.valueOf(currentWeek4Total + (ut.Current_Week_4__c == null ? 0 : ut.Current_Week_4__c));

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
            aggregateValInstance.currentWeek = Integer.valueof(100 - (currentWeekTotal + currentWeekTotalPercent) < 0 ? 0 : 100 - (currentWeekTotal + currentWeekTotalPercent));
            aggregateValInstance.currentWeek1 = Integer.valueof(100 - (currentWeek1Total + currentWeek1TotalPercent) < 0 ? 0 : 100 - (currentWeek1Total + currentWeek1TotalPercent));
            aggregateValInstance.currentWeek2 = Integer.valueof(100 - (currentWeek2Total + currentWeek2TotalPercent) < 0 ? 0 : 100 - (currentWeek2Total + currentWeek2TotalPercent));
            aggregateValInstance.currentWeek3 = Integer.valueof(100 - (currentWeek3Total + currentWeek3TotalPercent) < 0 ? 0 : 100 - (currentWeek3Total + currentWeek3TotalPercent));
            aggregateValInstance.currentWeek4 = Integer.valueof(100 - (currentWeek4Total + currentWeek4TotalPercent) < 0 ? 0 : 100 - (currentWeek4Total + currentWeek4TotalPercent));
            //system.debug(AggregateValues.size());
            AggregateValues.add(aggregateValInstance);
            //system.debug(AggregateValues.size());
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstants.NO_UTIL);
            ApexPages.addMessage(myMsg);
        }
    }

    /******************************
    Method Name: doSave
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public pageReference doSave() {
        try {
            ApexPages.Message myMsg;
            for (Utilizations__c ut: utilizationList) {
                if (ut.Current_Week__c == null) ut.Current_Week__c = 0;
                if (ut.Current_Week__c < 0) {
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstantsforSWB.UTILIZATION_ERROR_MSG);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                if (ut.Current_Week_1__c == null) ut.Current_Week_1__c = 0;
                if (ut.Current_Week_1__c < 0) {
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstantsforSWB.UTILIZATION_ERROR_MSG);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                if (ut.Current_Week_2__c == null) ut.Current_Week_2__c = 0;
                if (ut.Current_Week_2__c < 0) {
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstantsforSWB.UTILIZATION_ERROR_MSG);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                if (ut.Current_Week_3__c == null) ut.Current_Week_3__c = 0;
                if (ut.Current_Week_3__c < 0) {
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstantsforSWB.UTILIZATION_ERROR_MSG);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                if (ut.Current_Week_4__c == null) ut.Current_Week_4__c = 0;
                if (ut.Current_Week_4__c < 0) {
                    myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, UtilConstantsforSWB.UTILIZATION_ERROR_MSG);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }
            upsert utilizationList;
            PageReference pageRef = new PageReference(relativeURL);
            pageRef.setRedirect(true);
            return pageRef;
        } Catch(Exception e) {
            UTIL_LoggingService.logHandledException(e, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS, 
                                                   UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
        return null;

    }

    /******************************
    Method Name: doCancel
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public pageReference doCancel() {
        try {
            PageReference pageRef = new PageReference(relativeURL);
            pageRef.setRedirect(true);
            return pageRef;
        } catch (Exception e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            UTIL_LoggingService.logHandledException(e, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS, 
                                                   UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
        return null;
    }

    /******************************
    Method Name: reDirect
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public pageReference reDirect() {
        try {
            ////system.debug('------uRec.id-------'+uRec.id);
            PageReference pageRef = new PageReference(UtilConstants.SLASH_OPRTR + uRec.id);
            pageRef.setRedirect(true);
            return pageRef;
        } catch (Exception e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            UTIL_LoggingService.logHandledException(e, UserInfo.getOrganizationId(), UTIL_ErrorConstants.ERROR_APPLICATION, UTIL_ErrorConstants.EXCEPTION_SEARCH_CLASS, 
                                                   UTIL_ErrorConstants.DELETE_EXCEPTION, null, LoggingLevel.ERROR);
        }
        return null;
    }
}