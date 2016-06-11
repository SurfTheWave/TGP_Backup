/*
Author : Varsha Chougle
Story  : Story-0296/MOB_156
Description :Budget Reforecast tab.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class Mob_BudgetReforecastController {
    
    public string waveId{get;set;}
    public List<Budget_Solution__c> lstBudgetSolution{get;set;}
    public List<Budget_Reforecast__c> lstBudgetReforecast{get;set;}
    public boolean disableMsg{get;set;}
    public List<String> Months{get;set;}
    public boolean isSubmit{get;set;}
    public String yearName{get;set;}
    public String monthName{get;set;}
    public boolean isShow{get;set;}
    public boolean isDisplayErrorMsg{get;set;}
    public string displayErrorMsg{get;set;}
    public decimal startMonthNumber{get;set;}
    public decimal EndMonthNumber{get;set;}
    public decimal firstMonthNumber{get;set;}
    public decimal lastMonthNumber{get;set;}
    public decimal lastYearNumber{get;set;}
    public boolean showPrevious{get;set;}
    public boolean showNext{get;set;}
    
    /******************************
    Method Name: Mob_BudgetReforecastController
    Description: This is Constructor for the Mob_BudgetReforecastController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public Mob_BudgetReforecastController(ApexPages.StandardController controller)
    {
        //Wave plan version Id
        waveId=ApexPages.CurrentPage().getParameters().get('id');
        
        //List of Budget Solution
        lstBudgetSolution=[Select id, name, Budget__c, CTA_Cost_Model_Estimates__c,EAC__c,Difference__c, Notes_for_Budget_Reforecast__c ,Wave_Plan_Version__c, 
                            number__c, isSubmitted__c,isSubmittedToGovernanceLead__c, Wave_Plan_Version__r.deal__r.Start_Date_of_Transistion__c,summation__c
                              from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
        
        if(lstBudgetSolution.size()>0)
        {
            isSubmit=lstBudgetSolution[0].isSubmittedToGovernanceLead__c;
            if(lstBudgetSolution[0].Wave_Plan_Version__r.deal__r.Start_Date_of_Transistion__c != null)
            {
                if(lstBudgetSolution[0].Wave_Plan_Version__r.deal__r.Start_Date_of_Transistion__c.year() > datetime.now().year())
                {
                    isDisplayErrorMsg=true;
                    DisplayErrorMsg='\'Start Date of Transistion\' in the deal home page must be less than or equal to todays date, to add month in Forecast';  
                }
                else if((lstBudgetSolution[0].Wave_Plan_Version__r.deal__r.Start_Date_of_Transistion__c.year() > datetime.now().year()) &&
 
                        (lstBudgetSolution[0].Wave_Plan_Version__r.deal__r.Start_Date_of_Transistion__c.month() > datetime.now().month()))
                {
                        isDisplayErrorMsg=true;
                        DisplayErrorMsg='\'Start Date of Transistion\' in the deal home page must be less than or equal to todays date, to add month in Forecast'; 
                }
                else
                {
                        yearName=''+ lstBudgetSolution[0].Wave_Plan_Version__r.deal__r.Start_Date_of_Transistion__c.year();
                        isDisplayErrorMsg=false;
                 }
 
                
            }
            else
            {
                isDisplayErrorMsg=true;
                DisplayErrorMsg='Please add \'Start Date of Transistion\' in the deal home page to add month in Forecast';
            }
        }                      
        
        giveFirstAndLastMonth();
        giveStartAndEndMonth();
        
        //List of Budget Reforecast
        lstBudgetReforecast=[Select id, Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,
                             isSubmitted__c,Actuals_Record__c, isActualSubmitted__c,isActualsCopied__c  from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId and Month_Name__c >=: startMonthNumber and Month_Name__c <=: endMonthNumber order by Month_Name__c, Budget_Solution__r.number__c ];
        
        if(lstBudgetReforecast.size()==0)
        {
            isShow=true;
        }
        else
        {
            isShow=false;
            isDisplayErrorMsg=false;
        }
        Months=new List<String>();                    
        if(lstBudgetSolution.size()>0)
        {
            if(lstBudgetSolution[0].isSubmitted__c == false)
            {
                disableMsg=true;
            }
            else
            {
                disableMsg=false;
            }

            giveListOfMonth();
        }
                       
    }
    
    //Class for Budget Reforecast
    public class BudgetReforecast
    {
        public Budget_Reforecast__c newBudgetReforecast{get;set;}
        
        public BudgetReforecast(Budget_Reforecast__c newBudgetReforecast)
        {
            this.newBudgetReforecast=newBudgetReforecast;
        }
    }

    //Class for Budget Solution
    public class BudgetSolution
    {
        public Budget_Solution__c newBudgetSolution{get; set;}
        public String bgColor{get;set;}
        public boolean isDisableInputMonth{get;set;}
        public boolean isDisableOutputMonth{get;set;}
        public List<BudgetReforecast> listBudgetReforecast {get;set;}
        
        //Constructor for BudgetSolution
        public BudgetSolution(Budget_Solution__c newBudgetSolution , String bgColor, List<BudgetReforecast> listBudgetReforecast, boolean isDisableInputMonth, boolean  isDisableOutputMonth)
        {
            this.newBudgetSolution=newBudgetSolution; 
            this.bgColor=bgColor;
            this.listBudgetReforecast=listBudgetReforecast; 
            this.isDisableInputMonth=isDisableInputMonth;
            this.isDisableOutputMonth=isDisableOutputMonth;
        }       
    }
    
    /******************************
    Method Name: getListOfBudgetSolution
    Description: Method to get the list of Budget Solution.  
    Paramenters: NA
    Return Value: List<DealLocation>
    *******************************/ 
    public List<BudgetSolution> getListOfBudgetSolution()
    {
        giveListOfMonth(); 
        lstBudgetReforecast=[Select id, Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,
                             isSubmitted__c,Actuals_Record__c, isActualSubmitted__c, isActualsCopied__c  from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId and Month_Name__c >=: startMonthNumber and Month_Name__c <=: endMonthNumber order by Month_Name__c, Budget_Solution__r.number__c ];
        
        List<BudgetSolution> listOfBudgetSolution=new List<BudgetSolution>();
        if(lstBudgetSolution.size()>0)
        {
            if(lstBudgetSolution.size() == 25) {
                for(Budget_Solution__c b: lstBudgetSolution)
                {
                    String bgColor=null;
                    boolean isDisableInputMonth=null;
                    boolean isDisableOutputMonth=null;
                    List<BudgetReforecast> listBudgetReforecast=new List<BudgetReforecast>(); 
                    if(b.number__c==1 || b.number__c==14 || b.number__c==17)
                    {
                        isDisableInputMonth=false;
                        isDisableOutputMonth=false;
                        bgColor='#4791FF';
                    }
                    else if(b.number__c==13 || b.number__c==16 || b.number__c==22 || b.number__c==23 || b.number__c==25)
                    {
                        isDisableInputMonth=false;
                        isDisableOutputMonth=true;
                        bgColor='#EAEAEB';
                    }
                    else
                    {
                        if(b.isSubmittedToGovernanceLead__c==true)
                        { 
                            isDisableInputMonth=false;
                            isDisableOutputMonth=true;    
                        }
                        else
                        {
                            isDisableInputMonth=true;
                            isDisableOutputMonth=false;
                        }
                    }
                    if(lstBudgetReforecast.size()>0)
                    {
                        for(Budget_Reforecast__c  br : lstBudgetReforecast)
                        {
                            if(b.id== br.Budget_Solution__c)
                            {
                                if(br.forecast__c == null){
                                    br.forecast__c = 0;
                                }
                                if(br.Actuals__c == null) {
                                    br.Actuals__c = 0;
                                }
                                if(b.number__c==1 || b.number__c==14 || b.number__c==17) {
                                    br.forecast__c = null;
                                    br.Actuals__c = null;
                                }
                                listBudgetReforecast.add(new BudgetReforecast(br));
                            }
                        }
                    }
                    
                    listOfBudgetSolution.add(new BudgetSolution(b, bgColor, listBudgetReforecast, isDisableInputMonth, isDisableOutputMonth));
                } 
            }
            else {
                for(Budget_Solution__c b: lstBudgetSolution) {
                    String bgColor=null;
                    boolean isDisableInputMonth=null;
                    boolean isDisableOutputMonth=null;
                    List<BudgetReforecast> listBudgetReforecast=new List<BudgetReforecast>(); 
                    if(b.number__c==1 || b.number__c==6 || b.number__c==12 || b.number__c==19 || b.number__c== 25
                        || b.number__c==31 || b.number__c==37 || b.number__c==40 || b.number__c==50 || b.number__c==53 || b.number__c==56) {
                        isDisableInputMonth=false;
                        isDisableOutputMonth=false;
                        bgColor='#4791FF';
                    }
                    else if(b.number__c==5 || b.number__c==11 || b.number__c==18 || b.number__c==24 || b.number__c== 30 || b.number__c== 36 
                        || b.number__c== 39 || b.number__c== 49 || b.number__c== 52 || b.number__c== 55 || b.number__c== 58 || b.number__c== 59) {
                        isDisableInputMonth=false;
                        isDisableOutputMonth=true;
                        bgColor='#EAEAEB';
                    }
                    else {
                        if(b.isSubmittedToGovernanceLead__c)  { 
                            isDisableInputMonth=false;
                            isDisableOutputMonth=true;    
                        }
                        else {
                            isDisableInputMonth=true;
                            isDisableOutputMonth=false;
                        }
                    }
                    if(lstBudgetReforecast.size()>0) {
                        for(Budget_Reforecast__c  br : lstBudgetReforecast) {
                            if(b.id== br.Budget_Solution__c) {
                                if(br.forecast__c == null){
                                    br.forecast__c = 0;
                                }
                                if(br.Actuals__c == null) {
                                    br.Actuals__c = 0;
                                }
                                if(b.number__c==1 || b.number__c==6 || b.number__c==12 || b.number__c==19 || b.number__c== 25
                                    || b.number__c==31 || b.number__c==37 || b.number__c==40 || b.number__c==50 || b.number__c==53 || b.number__c==56) {
                                    br.forecast__c = null;  
                                    br.Actuals__c = null;
                                }
                                listBudgetReforecast.add(new BudgetReforecast(br));
                            }
                        }
                    }
                    
                    listOfBudgetSolution.add(new BudgetSolution(b, bgColor, listBudgetReforecast, isDisableInputMonth, isDisableOutputMonth));
                } 
            }
        }
        return listOfBudgetSolution;
    }
    
    
    public List<SelectOption> getYearList()
    {
        List<SelectOption> yearList=new List<SelectOption>();
        if(lstBudgetSolution.size()>0)
        {
            Date dt=lstBudgetSolution[0].Wave_Plan_Version__r.deal__r.Start_Date_of_Transistion__c;
            Decimal startYear=dt.year();
            Decimal currentYear=datetime.now().year();
            Decimal i=0;
            for(i=startYear; i<=currentYear; i++)
            {
                yearList.add(new SelectOption(''+i,''+i)); 
            }
        }
        return yearList; 
    }
    
    public List<SelectOption> getMonthList()
    {
        List<SelectOption> monthList=new List<SelectOption>();
        if(lstBudgetSolution.size()>0)
        {
            Date dt=lstBudgetSolution[0].Wave_Plan_Version__r.deal__r.Start_Date_of_Transistion__c;
            Decimal startMonth=dt.month();
            Decimal startYear=dt.year();
            Decimal currentMonth=datetime.now().month();
            Decimal currentYear=datetime.now().year();
            Decimal i=0;
            Decimal startValue, endValue;
            if(!String.isEmpty(yearName))
            {
                if(Decimal.valueOf(yearName)== startYear && Decimal.valueOf(yearName)== currentYear)
                {
                    startValue=startMonth;
                    endValue=currentMonth;
                }
                else
                {
                    if(Decimal.valueOf(yearName) > startYear && Decimal.valueOf(yearName) < currentYear)
                    {
                        startValue=1;
                        endValue=12;
                    }
                    if(Decimal.valueOf(yearName) == startYear)
                    {
                        startValue=startMonth;
                        endValue=12; 
                    }
                    if(Decimal.valueOf(yearName) == currentYear)
                    {
                        startValue=1;
                        endValue=currentMonth;
                    }
               }
            }
            for(i=startValue; i<=endValue; i++)
            {
                if(i==startValue)
                {
                    monthName=convertIntoMonth1(i);
                }
                MonthList.add(new SelectOption(''+i,convertIntoMonth1(i))); 
            }
        }
        return monthList; 
    }
    
    public string convertIntoMonth1(Decimal monthNo)
    {
        List<String> lstMonthName =new String[] {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
        String monthName=null;
        Integer m=Integer.valueOf(monthNo);
        if(m<=12)
        {
            monthName= lstMonthName[m-1];
        }
        else
        {
            m=math.mod(m,12);
            monthName= lstMonthName[m-1];
        }
        return monthName;
    }
    
    /******************************
    Method Name: convertIntoMonth
    Description: Method to convert month number into month name.  
    Paramenters: Decimal 
    Return Value: string
    *******************************/ 
    public string convertIntoMonth(Decimal monthNo, Decimal year)
    {
        List<String> lstMonthName =new String[] {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
        String monthName=null;
        Integer m=Integer.valueOf(monthNo);
        if(m<=12)
        {
            monthName= lstMonthName[m-1];
        }
        else
        {
            m=math.mod(m,12);
            if(m==0)
            {
                m=12;
            }
            monthName= lstMonthName[m-1];
        }
        return monthName+' '+year;
    }

    
    /******************************
    Method Name: giveListOfMonth
    Description: Method to give the list of month exist.  
    Paramenters: NA
    Return Value: Void
    *******************************/
    public void giveListOfMonth()
    {   
        lstBudgetReforecast=[Select id, Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,
                             isSubmitted__c,Actuals_Record__c, isActualSubmitted__c, isActualsCopied__c  from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId and Month_Name__c >=: startMonthNumber and Month_Name__c <=: endMonthNumber order by Month_Name__c, Budget_Solution__r.number__c ];
                          
        Months=new List<String>();
        if(lstBudgetSolution.size()>0)
        {
            if(lstBudgetReforecast.size()>0)
            {
                for(Budget_Reforecast__c budgetRf : lstBudgetReforecast)
                {
                    if(budgetRf.Budget_Solution__c==lstBudgetSolution[0].id)
                    {
                        Months.add(convertIntoMonth(budgetRf.Month_Name__c, budgetRf.year__c));
                    }    
                }
            }
        } 
    }
    
    public void addFirstMonth()
    {
        Decimal currentMonth=Decimal.valueOf(monthName);
        Decimal currentYear;
        if(!String.isEmpty(yearName))
        {
            currentYear=Decimal.valueOf(yearName);
        }
        Budget_Reforecast__c newBudgetReforecast;
        List<Budget_Reforecast__c> lstBudgetReforecast = new List<Budget_Reforecast__c>();
        try
        {
            if(lstBudgetSolution.size()>0)
            {
                for(Budget_Solution__c b : lstBudgetSolution)
                {
                    newBudgetReforecast = new Budget_Reforecast__c();
                    newBudgetReforecast.Budget_Solution__c=b.id;
                    newBudgetReforecast.Month_Name__c=currentMonth;
                    newBudgetReforecast.year__c=currentYear;
                    newBudgetReforecast.forecast__c = 0;
                    newBudgetReforecast.Actuals__c = 0;
                    lstBudgetReforecast.add(newBudgetReforecast); 
                }
                upsert lstBudgetReforecast;
                giveFirstAndLastMonth();
                giveStartAndEndMonth();
                giveListOfMonth();
                isShow=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Month added successfully!'));
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in adding Month!'+ex));
            return;
        }
        return;
    }
    
    /******************************
    Method Name: addMonth
    Description: Method to add Month.  
    Paramenters: NA
    Return Value: Void
    *******************************/ 
    public void addMonth()
    {
        giveFirstAndLastMonth();
        giveStartAndEndMonth();
        Decimal newMonthNumber=null;
        Decimal newYear=null;
        
        
                        newMonthNumber=lastMonthNumber +1;
                        Integer m=Integer.valueOf(newMonthNumber);
                        if(math.mod(m,12)==1)
                        {
                            newYear = lastYearNumber + 1; 
                        }
                        else
                        {
                            newYear = lastYearNumber;
                        }
    
        try
        {
            if(lstBudgetSolution.size()>0)
            {
                Budget_Reforecast__c newBudgetReforecast;
                List<Budget_Reforecast__c> listBudgetReforecast = new List<Budget_Reforecast__c>();
                for(Budget_Solution__c b : lstBudgetSolution)
                {
                    newBudgetReforecast = new Budget_Reforecast__c();
                    newBudgetReforecast.Budget_Solution__c=b.id;
                    newBudgetReforecast.Month_Name__c=newMonthNumber;
                    newBudgetReforecast.year__c=newYear;
                    newBudgetReforecast.forecast__c = 0;
                    newBudgetReforecast.Actuals__c = 0;
                    newBudgetReforecast.Reforecast_Record__c=true;
                    listBudgetReforecast.add(newBudgetReforecast);
                }
                upsert listBudgetReforecast;
                giveFirstAndLastMonth();
                giveStartAndEndMonth();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Month added successfully!'));
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in adding Month!'+ex));
            return;
        }
        return;
    }
    
    /******************************
    Method Name: saveBudgetForecast
    Description: Method to save All the Budget Reforecast Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void saveBudgetForecast()
    {
        try
        {
            if(lstBudgetReforecast.size()>0)
            {
                for(Budget_Reforecast__c br : lstBudgetReforecast)
                {
                    br.Reforecast_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
            sumOfRevisedBaseline();
            upsert lstBudgetSolution;
            calculateVariance();
            calculateEAC();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Forecast saved successfully!'));
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'+ex));
            return;
        }
        return;
    }
    
    /******************************
    Method Name: sumOfRevisedBaseline
    Description: Method to Calculate Revised Baseline.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void sumOfRevisedBaseline()
    {
        lstBudgetReforecast=[Select id, Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,
                             isSubmitted__c,Actuals_Record__c, isActualSubmitted__c, isActualsCopied__c  from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId order by Month_Name__c, Budget_Solution__r.number__c ];
        try
        {
            if(lstBudgetSolution.size()>0)
            {
                List<Budget_Reforecast__c> tempBudgetFor=new List<Budget_Reforecast__c>();
                if(lstBudgetSolution.size() == 25) {
                    
                    for(string m : Months)
                    {
                        Decimal totalPeopleForModelEstimates=0;
                        Decimal totalPeopleExpenseForModelEstimates=0;
                        Decimal totalDNPForModelEstimates=0;
                        Decimal totalMobCostForModelEstimates=0;
                        for(Budget_Reforecast__c b : lstBudgetReforecast)
                        {
                            String currentMonthName=convertIntoMonth(b.Month_Name__c, b.year__c);
                            if(m == currentMonthName)
                            {
                                if(b.forecast__c!=null && (b.Budget_Solution__r.number__c==2 || b.Budget_Solution__r.number__c==3 || b.Budget_Solution__r.number__c==4 || b.Budget_Solution__r.number__c==5 || b.Budget_Solution__r.number__c==6 || b.Budget_Solution__r.number__c==7 || b.Budget_Solution__r.number__c==8 || b.Budget_Solution__r.number__c==9 || b.Budget_Solution__r.number__c==10 || b.Budget_Solution__r.number__c==11 || b.Budget_Solution__r.number__c==12))
                                {
                                    totalPeopleForModelEstimates= totalPeopleForModelEstimates + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c==13)
                                {
                                    b.forecast__c= totalPeopleForModelEstimates;
                                    totalPeopleExpenseForModelEstimates= totalPeopleExpenseForModelEstimates + totalPeopleForModelEstimates;   
                                }
                                if(b.forecast__c!=null && (b.Budget_Solution__r.number__c==15))
                                {
                                    totalPeopleExpenseForModelEstimates = totalPeopleExpenseForModelEstimates + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c==16)
                                {
                                    b.forecast__c= totalPeopleExpenseForModelEstimates;  
                                }
                                if(b.forecast__c!=null && (b.Budget_Solution__r.number__c==18 || b.Budget_Solution__r.number__c==19 || b.Budget_Solution__r.number__c==20 || b.Budget_Solution__r.number__c==21))
                                {
                                    totalDNPForModelEstimates = totalDNPForModelEstimates +  b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c==22)
                                {
                                    b.forecast__c= totalDNPForModelEstimates;  
                                    totalMobCostForModelEstimates= totalMobCostForModelEstimates + totalPeopleExpenseForModelEstimates + totalDNPForModelEstimates;
                                }
                                if(b.Budget_Solution__r.number__c==23)
                                {
                                    b.forecast__c= totalMobCostForModelEstimates;  
                                }
                                if(b.forecast__c!=null && b.Budget_Solution__r.number__c==24)
                                {
                                    totalMobCostForModelEstimates = totalMobCostForModelEstimates +  b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c==25)
                                {
                                    b.forecast__c= totalMobCostForModelEstimates;    
                                }
                                tempBudgetFor.add(b);
                            }
                        }
                    }
                }
                else {
                    for(string m : Months) {
                        Decimal subTotalProgramManagement = 0;
                        Decimal subTotalEnablePeople =0;
                        Decimal subTotalKTCosts = 0;
                        Decimal subTotalBPOTechnology = 0;
                        Decimal subTotalBSS = 0;
                        Decimal subTotalDealPMO = 0;
                        Decimal subTotalPreGoLiveCost = 0;
                        Decimal subTotalClinetSpecificCost = 0;
                        Decimal subTotalTransforamtion = 0;
                        Decimal subTotalOther = 0;
                        Decimal subTotalContingency = 0;
                        Decimal TotalCost = 0;
                        for(Budget_Reforecast__c b : lstBudgetReforecast) {
                            String currentMonthName=convertIntoMonth(b.Month_Name__c, b.year__c);
                            if(m == currentMonthName) {
                                if(b.forecast__c!=null &&  (b.Budget_Solution__r.number__c ==2 || b.Budget_Solution__r.number__c ==3 || b.Budget_Solution__r.number__c ==4)) {
                                    subTotalProgramManagement = subTotalProgramManagement + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c==5 ) {
                                    b.forecast__c = subTotalProgramManagement;
                                    TotalCost = TotalCost + subTotalProgramManagement;
                                }
                                if(b.forecast__c!=null &&  (b.Budget_Solution__r.number__c==7 || b.Budget_Solution__r.number__c==8 || b.Budget_Solution__r.number__c==9 || b.Budget_Solution__r.number__c==10)) {
                                    subTotalEnablePeople = subTotalEnablePeople + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c==11 ) {
                                    b.forecast__c = subTotalEnablePeople;
                                    TotalCost = TotalCost + subTotalEnablePeople;
                                }
                                if(b.forecast__c!=null &&  (b.Budget_Solution__r.number__c==13 || b.Budget_Solution__r.number__c==14 || b.Budget_Solution__r.number__c==15 || b.Budget_Solution__r.number__c==16 || b.Budget_Solution__r.number__c==17)) {
                                    subTotalKTCosts = subTotalKTCosts + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c==18 ) {
                                    b.forecast__c = subTotalKTCosts;
                                    TotalCost = TotalCost + subTotalKTCosts;
                                }
                                if(b.forecast__c!=null &&  (b.Budget_Solution__r.number__c==20 || b.Budget_Solution__r.number__c==21 || b.Budget_Solution__r.number__c==22 || b.Budget_Solution__r.number__c==23)) {
                                    subTotalBPOTechnology = subTotalBPOTechnology + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c==24 ) {
                                    b.forecast__c = subTotalBPOTechnology;
                                    TotalCost = TotalCost + subTotalBPOTechnology;
                                }
                                if(b.forecast__c!=null &&  (b.Budget_Solution__r.number__c==26 || b.Budget_Solution__r.number__c==27 || b.Budget_Solution__r.number__c==28 || b.Budget_Solution__r.number__c==29)) {
                                    subTotalBSS = subTotalBSS + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c== 30) {
                                    b.forecast__c = subTotalBSS;
                                    TotalCost = TotalCost + subTotalBSS;
                                }
                                if(b.forecast__c!=null &&  (b.Budget_Solution__r.number__c==32 || b.Budget_Solution__r.number__c==33 || b.Budget_Solution__r.number__c==34 || b.Budget_Solution__r.number__c==35)) {
                                    subTotalDealPMO = subTotalDealPMO + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c== 36) {
                                    b.forecast__c = subTotalDealPMO;
                                    TotalCost = TotalCost + subTotalDealPMO;
                                }
                                if(b.forecast__c!=null &&  b.Budget_Solution__r.number__c==38) {
                                    subTotalPreGoLiveCost = subTotalPreGoLiveCost + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c== 39) {
                                    b.forecast__c = subTotalPreGoLiveCost;
                                    TotalCost = TotalCost + subTotalPreGoLiveCost;
                                }
                                if(b.forecast__c!=null &&  (b.Budget_Solution__r.number__c== 41 || b.Budget_Solution__r.number__c==42 || b.Budget_Solution__r.number__c==43 || b.Budget_Solution__r.number__c==44 || 
                                        b.Budget_Solution__r.number__c==45 || b.Budget_Solution__r.number__c==46 || b.Budget_Solution__r.number__c==47 || b.Budget_Solution__r.number__c==48)) {
                                    subTotalClinetSpecificCost = subTotalClinetSpecificCost + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c== 49) {
                                    b.forecast__c = subTotalClinetSpecificCost;
                                    TotalCost = TotalCost + subTotalClinetSpecificCost;
                                }
                                if(b.forecast__c!=null &&  b.Budget_Solution__r.number__c==51) {
                                    subTotalTransforamtion = subTotalTransforamtion + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c== 52) {
                                    b.forecast__c = subTotalTransforamtion;
                                    TotalCost = TotalCost + subTotalTransforamtion;
                                }
                                if(b.forecast__c!=null &&  b.Budget_Solution__r.number__c==54) {
                                    subTotalOther = subTotalOther + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c== 55) {
                                    b.forecast__c = subTotalOther;
                                    TotalCost = TotalCost + subTotalOther;
                                }
                                if(b.forecast__c!=null &&  b.Budget_Solution__r.number__c==57) {
                                    subTotalContingency = subTotalContingency + b.forecast__c;
                                }
                                if(b.Budget_Solution__r.number__c== 58) {
                                    b.forecast__c = subTotalContingency;
                                    TotalCost = TotalCost + subTotalContingency;
                                }
                                if(b.Budget_Solution__r.number__c== 59) {
                                    b.forecast__c = TotalCost;
                                }
                                tempBudgetFor.add(b);
                            }
                        }
                    }
                }
                upsert tempBudgetFor;
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
            return;
        }
        return;
    }
    
    /******************************
    Method Name: cancelBudgetForecast
    Description: Method to Cancel All the Budget Forecast Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void cancelBudgetForecast()
    {
        lstBudgetSolution=[Select id, name, Budget__c, CTA_Cost_Model_Estimates__c,EAC__c,Difference__c, Notes_for_Budget_Reforecast__c ,Wave_Plan_Version__c, 
                            number__c, isSubmitted__c,isSubmittedToGovernanceLead__c,summation__c from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
        return;
    }
    
    /******************************
    Method Name: copyActual
    Description: Method to copy Actuals of previous months.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    /*public void copyActual()
    {
        Decimal currentMonth=datetime.now().month();
        Boolean isPreviousMonthExist=false;
        lstBudgetReforecast=[Select id, Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,
                             isSubmitted__c,Actuals_Record__c, isActualSubmitted__c   from Budget_Reforecast__c 
                             where Month_Name__c <: currentMonth and Budget_Solution__r.Wave_Plan_Version__c=: waveId order by Month_Name__c, Budget_Solution__r.number__c ];
                             
        if(lstBudgetReforecast.size()>0)
        {
            for(Budget_Reforecast__c  br : lstBudgetReforecast)
            {               
                isPreviousMonthExist=true;
            }
        }
        try
        {
            if(isPreviousMonthExist == true)
            {
                List<Budget_Reforecast__c> listBudgetReforecast = new List<Budget_Reforecast__c>();
                if(lstBudgetReforecast.size()>0)
                {
                    for(Budget_Reforecast__c br : lstBudgetReforecast)
                    {
                        if(br.Month_Name__c < currentMonth)
                        {
                            br.forecast__c= br.Actuals__c;
                            listBudgetReforecast.add(br);
                        } 
                    }
                }
                upsert listBudgetReforecast;
                calculateVariance();
                calculateEAC();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Actuals copied successfully!'));
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Previous month does not exist!'));
                return;
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in copy actuals!'));
            return;
        }
        return;
    }*/
    
    public void copyActual()
    {
        Decimal currentMonth=datetime.now().month();
        Boolean isPreviousMonthExist=false;
        Boolean isNotSubmittedMonthExist=false;
        /*lstBudgetReforecast=[Select   forecast__c,Actuals__c, Month_Name__c,Budget_Solution__r.number__c, isActualSubmitted__c, isActualsCopied__c   
                                from Budget_Reforecast__c 
                                where Budget_Solution__r.Wave_Plan_Version__c=: waveId order by Month_Name__c, Budget_Solution__r.number__c ];*/
                             
        if(lstBudgetReforecast.size()>0)
        {
            for(Budget_Reforecast__c  br : lstBudgetReforecast)
            {   
                if(br.isActualsCopied__c==false && br.isActualSubmitted__c == true)      
                {      
                    isPreviousMonthExist=true;
                }
                if(br.isActualsCopied__c ==true)
                {
                    isNotSubmittedMonthExist=true;
                }
            }
        }
        try
        {
            if(isPreviousMonthExist == true)
            {
                List<Budget_Reforecast__c> listBudgetReforecast = new List<Budget_Reforecast__c>();
                if(lstBudgetReforecast.size()>0)
                {
                    for(Budget_Reforecast__c br : lstBudgetReforecast)
                    {
                        if(br.isActualSubmitted__c ==true && br.isActualsCopied__c==false)
                        {
                            br.forecast__c= br.Actuals__c;
                            br.isActualsCopied__c=true;
                            listBudgetReforecast.add(br);
                        } 
                    }
                }
                upsert listBudgetReforecast;
                calculateVariance();
                //calculateEAC();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Actuals copied successfully!'));
            }
            else if(isNotSubmittedMonthExist==true)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No new month from Actuals tab is submitted for copying the actuals!'));
                return;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No month from Actuals tab is submitted for copying the actuals!'));
                return;
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in copy actuals!'));
            return;
        }
        return;
    }
    
    
    /******************************
    Method Name: calculateVariance
    Description: Method to calculate Variance.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void calculateVariance()
    {
        transient  List <Budget_Reforecast__c> lstBudgetReforecastTemp =[Select  Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c, isActualsCopied__c 
                              from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId order by Month_Name__c, Budget_Solution__r.number__c ];

        try
        {
             List<Budget_Reforecast__c> listBudgetVarience = new List<Budget_Reforecast__c>();
             if(lstBudgetReforecastTemp.size()>0)
             {
                 for(Budget_Reforecast__c br : lstBudgetReforecastTemp)
                 {
                     if(br.isActualsCopied__c==false)
                     {
                         if(br.forecast__c==null && br.Actuals__c==null)
                         {
                             br.Variance__c=0;
                         }
                         else if(br.forecast__c==null)
                         {
                             br.Variance__c=0 - br.Actuals__c;
                         }
                         else if(br.Actuals__c==null)
                         {
                             br.Variance__c= br.forecast__c;
                         }
                         else
                         {
                             br.Variance__c= br.forecast__c - br.Actuals__c;
                         }                         
                     }
                     listBudgetVarience.add(br);
                }
                upsert listBudgetVarience;
            } 
            
            
            if(listBudgetVarience.size()>0)
            {
                List<Budget_Solution__c> listBudgetSolution = new List<Budget_Solution__c>();
                for(Budget_Solution__c b: lstBudgetSolution)
                {
                    if(listBudgetVarience.size()>0)
                    {
                        Decimal sum=0;
                        for(Budget_Reforecast__c bfc : listBudgetVarience)
                        {
                            if(bfc.Budget_Solution__c == b.id)
                            {
                                if(bfc.Variance__c!= null)
                                {
                                    sum= sum+ bfc.Variance__c;
                                }
                            }
                        }
                        b.summation__c=sum;
                        listBudgetSolution.add(b);
                    }
                } 
                upsert listBudgetSolution;    
            }
            List<Budget_Solution__c> listBudgetSolution = new List<Budget_Solution__c>();
                for(Budget_Solution__c b: lstBudgetSolution)
                {
                    if(lstBudgetReforecastTemp.size()>0)
                    {
                        Decimal EAC=0;
                        for(Budget_Reforecast__c bfc : lstBudgetReforecastTemp)
                        {
                            if(bfc.Budget_Solution__c == b.id)
                            {
                                if(bfc.forecast__c != null)
                                {
                                    EAC = EAC + bfc.forecast__c;
                                }
                            }
                        }
                        b.EAC__c=EAC;
                        if(b.CTA_Cost_Model_Estimates__c !=null)
                        {
                            b.Difference__c=b.CTA_Cost_Model_Estimates__c - EAC; 
                        }
                        else
                        {
                            b.Difference__c= 0 - EAC;
                        }
                        listBudgetSolution.add(b);
                    }
                } 
                upsert listBudgetSolution;
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'+ex));
            return;
        }          
        return;
    }
    
    /******************************
    Method Name: calculateEAC
    Description: Method to calculate EAC.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void calculateEAC()
    {
        List<Budget_Reforecast__c> tempListBudgetReforecast=[Select id, Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,
                             isSubmitted__c,Actuals_Record__c, isActualSubmitted__c, isActualsCopied__c  from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId order by Budget_Solution__r.number__c, Month_Name__c ];
        try
        {
            if(tempListBudgetReforecast.size()>0)
            {
                List<Budget_Solution__c> listBudgetSolution = new List<Budget_Solution__c>();
                for(Budget_Solution__c b: lstBudgetSolution)
                {
                    if(lstBudgetReforecast.size()>0)
                    {
                        Decimal EAC=0;
                        for(Budget_Reforecast__c bfc : tempListBudgetReforecast)
                        {
                            if(bfc.Budget_Solution__c == b.id)
                            {
                                if(bfc.forecast__c != null)
                                {
                                    EAC = EAC + bfc.forecast__c;
                                }
                            }
                        }
                        b.EAC__c=EAC;
                        if(b.CTA_Cost_Model_Estimates__c !=null)
                        {
                            b.Difference__c=b.CTA_Cost_Model_Estimates__c - EAC; 
                        }
                        else
                        {
                            b.Difference__c= 0 - EAC;
                        }
                        listBudgetSolution.add(b);
                    }
                } 
                upsert listBudgetSolution;    
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'+ex));
            return;
        }  
        return;
    }
    
    public void giveFirstAndLastMonth()
    {
        transient List<Budget_Reforecast__c> lstBudgetReforecastForMonth=[Select Month_Name__c,year__c from Budget_Reforecast__c 
                                         where Budget_Solution__r.Wave_Plan_Version__c=: waveId order by Month_Name__c, Budget_Solution__r.number__c ];
        if(lstBudgetReforecastForMonth.size()>0)
        {
            firstMonthNumber=lstBudgetReforecastForMonth[0].Month_Name__c ;
            lastMonthNumber=lstBudgetReforecastForMonth[(lstBudgetReforecastForMonth.size()-1)].Month_Name__c ;
            lastYearNumber=lstBudgetReforecastForMonth[(lstBudgetReforecastForMonth.size()-1)].year__c;
        }  
        return;
    }
    
    public void giveStartAndEndMonth()
    {
        if(firstMonthNumber!= null && lastMonthNumber!=null)
        {
            if(startMonthNumber ==null && endMonthNumber==null)
            {
                startMonthNumber=firstMonthNumber;
                endMonthNumber=startMonthNumber+0;
                if(endMonthNumber > lastMonthNumber)
                {
                    endMonthNumber=lastMonthNumber;
                } 
                if(endMonthNumber < lastMonthNumber)
                {
                    showNext=true;
                }
            }
            else
            {
                if(endMonthNumber == lastMonthNumber-1)
                {
                    if(startMonthNumber+0>endMonthNumber)
                    {
                        endMonthNumber=lastMonthNumber;
                    }
                    else if(startMonthNumber + 0 == endMonthNumber)
                    {
                        showNext=true;
                    }
                    else
                    {
                        showNext=false;
                    }
                }
            }   
        }    
    }

    public void showNextMonths()
    {
        try
        {
            if(lstBudgetReforecast.size()>0)
            {
                for(Budget_Reforecast__c br : lstBudgetReforecast)
                {
                    br.Reforecast_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
            sumOfRevisedBaseline();
            upsert lstBudgetSolution;
            calculateVariance();
            calculateEAC();
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'+ex));
            return;
        }
        startMonthNumber=endMonthNumber+1;
        endMonthNumber=startMonthNumber+0;
        if(endMonthNumber >= lastMonthNumber)
        {
            endMonthNumber=lastMonthNumber;
            showNext=false;
        } 
        showPrevious=true;
        return;
    }
    
    public void showPreviousMonths()
    {
        try
        {
            if(lstBudgetReforecast.size()>0)
            {
                for(Budget_Reforecast__c br : lstBudgetReforecast)
                {
                    br.Reforecast_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
            sumOfRevisedBaseline();
            upsert lstBudgetSolution;
            calculateVariance();
            calculateEAC();
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'+ex));
            return;
        }
        endMonthNumber=startMonthNumber-1;
        startMonthNumber=endMonthNumber-0;
        if(startMonthNumber==firstMonthNumber)
        {
            showPrevious=false;
        }
        showNext=true;
        return;
    }
}