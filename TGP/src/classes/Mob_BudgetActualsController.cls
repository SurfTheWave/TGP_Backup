/*
Author : Varsha Chougle
Story  : Story-0297/MOB_157
Description :Budget Actuals tab.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class Mob_BudgetActualsController {

    public string waveId{get;set;}
    public List<Budget_Solution__c> lstBudgetSolution{get;set;}
    public List<Budget_Reforecast__c> lstBudgetReforecast{get;set;}
    public boolean disableMsg{get;set;}
    public String msg{get;set;}
    public List<String> Months{get;set;}
    public boolean isSubmit{get;set;}
    public decimal startMonthNumber{get;set;}
    public decimal EndMonthNumber{get;set;}
    public decimal firstMonthNumber{get;set;}
    public decimal lastMonthNumber{get;set;}
    public decimal lastYearNumber{get;set;}
    public boolean showPrevious{get;set;}
    public boolean showNext{get;set;}
    public List<MonthHeader> listMonthHeader{get;set;}
    public boolean isMonthSelected{get;set;}
    
    
    /******************************
    Method Name: Mob_BudgetActualsController 
    Description: This is Constructor for the Mob_BudgetReforecastController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public Mob_BudgetActualsController(ApexPages.StandardController controller)
    {
        //Wave plan version Id
        waveId=ApexPages.CurrentPage().getParameters().get('id');
        
        //List of Budget Solution
        lstBudgetSolution=[Select  name, Budget__c, CTA_Cost_Model_Estimates__c, Notes_for_Budget_Actuals__c ,Wave_Plan_Version__c, number__c, isSubmitted__c, 
                           isSubmittedToGovernanceLead__c from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
        
        if(lstBudgetSolution.size()>0)
        {
            isSubmit=lstBudgetSolution[0].isSubmittedToGovernanceLead__c;
        }  
        
        giveFirstAndLastMonth();
        giveStartAndEndMonth();
        
        //List of Budget Reforecast
        lstBudgetReforecast=[Select  Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Comments_for_Variance__c,
                             isSubmitted__c,Actuals_Record__c, Reforecast_Record__c, isActualSubmitted__c, isActualsCopied__c from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId and Month_Name__c >=: startMonthNumber and Month_Name__c <=: endMonthNumber order by Month_Name__c, Budget_Solution__r.number__c ];              
        
        Months=new List<String>(); 
        listMonthHeader=new List<MonthHeader>();                   
        if(lstBudgetSolution.size()>0)
        {
            if(lstBudgetSolution[0].isSubmitted__c == false)
            {
                msg='Budget Solution is not Submitted!';
                disableMsg=true;
            }
            else
            {
             
                if(lstBudgetReforecast.size()>0)
                {
                    if(lstBudgetReforecast[0].Reforecast_Record__c== false)
                    {
                        msg='Forecast is not saved!';
                        disableMsg=true;
                    }
                    else
                    {
                        disableMsg=false;
                        giveListOfMonth();
                    }    
                }
                else
                {
                    msg='Forecast is not saved!';
                    disableMsg=true;
                }
            }
        }
    }
    
    //Class for month name and checkBox value
    public class MonthHeader
    {
        public string monthName{get;set;}
        public decimal monthNumber{get;set;}
        public boolean isSelected{get;set;}
        
        //Constructor for MonthHeader
        public MonthHeader(string monthName, decimal monthNumber, boolean isSelected)
        {
            this.monthName=monthName;
            this.monthNumber=monthNumber;
            this.isSelected=isSelected;
        }
    }
    
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
        lstBudgetReforecast=[Select Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Comments_for_Variance__c,
                             isSubmitted__c,Actuals_Record__c, Reforecast_Record__c, isActualSubmitted__c, isActualsCopied__c from Budget_Reforecast__c 
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
                                listBudgetReforecast.add(new BudgetReforecast(br));
                            }
                        }
                    }
    
                    listOfBudgetSolution.add(new BudgetSolution(b, bgColor, listBudgetReforecast, isDisableInputMonth, isDisableOutputMonth));
                }
            } 
            else {
                for(Budget_Solution__c b: lstBudgetSolution)
                {
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
        lstBudgetReforecast=[Select Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Comments_for_Variance__c,
                             isSubmitted__c,Actuals_Record__c, Reforecast_Record__c, isActualSubmitted__c, isActualsCopied__c from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId and Month_Name__c >=: startMonthNumber and Month_Name__c <=: endMonthNumber order by Month_Name__c, Budget_Solution__r.number__c ];
                             
        Decimal currentMonth=datetime.now().month(); 
        Decimal currentYear=datetime.now().year();                    
        Months=new List<String>();
        listMonthHeader=new List<MonthHeader>();            
        if(lstBudgetSolution.size()>0)
        {
            if(lstBudgetReforecast.size()>0)
            {
                for(Budget_Reforecast__c budgetRf : lstBudgetReforecast)
                {
                    if(budgetRf.Budget_Solution__c==lstBudgetSolution[0].id)
                    {
                        Months.add(convertIntoMonth(budgetRf.Month_Name__c, budgetRf.year__c));
                        if(budgetRf.Month_Name__c < currentMonth && budgetRf.year__c <= currentYear) {
                            listMonthHeader.add(new MonthHeader(convertIntoMonth(budgetRf.Month_Name__c, budgetRf.year__c) ,budgetRf.Month_Name__c, budgetRf.isActualSubmitted__c ));
                        } 
                        else {
                            listMonthHeader.add(new MonthHeader(convertIntoMonth(budgetRf.Month_Name__c, budgetRf.year__c) ,budgetRf.Month_Name__c, true ));
                        }   
                    }    
                }
            }
        } 
    }
    
    /******************************
    Method Name: saveBudgetActual
    Description: Method to save All the Budget Actuals Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void saveBudgetActual()
    {
        try
        {
            if(lstBudgetReforecast.size()>0)
            {
                for(Budget_Reforecast__c ba : lstBudgetReforecast)
                {
                    ba.Actuals_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
            sumOfActuals();
            upsert lstBudgetSolution;
            calculateVariance();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Actuals saved successfully!'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Enter comments in Variance Analysis tab for any positive or negative variance'));
            
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
            return;
        }
        return;
    }
    
    /******************************
    Method Name: sumOfActuals
    Description: Method to Calculate Budget Actuals.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void sumOfActuals()
    {
        try
        {
            if(lstBudgetSolution.size()>0) {
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
                                if(b.Actuals__c!=null && (b.Budget_Solution__r.number__c==2 || b.Budget_Solution__r.number__c==3 || b.Budget_Solution__r.number__c==4 || b.Budget_Solution__r.number__c==5 || b.Budget_Solution__r.number__c==6 || b.Budget_Solution__r.number__c==7 || b.Budget_Solution__r.number__c==8 || b.Budget_Solution__r.number__c==9 || b.Budget_Solution__r.number__c==10 || b.Budget_Solution__r.number__c==11 || b.Budget_Solution__r.number__c==12))
                                {
                                    totalPeopleForModelEstimates= totalPeopleForModelEstimates + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c==13)
                                {
                                    b.Actuals__c= totalPeopleForModelEstimates;
                                    totalPeopleExpenseForModelEstimates= totalPeopleExpenseForModelEstimates + totalPeopleForModelEstimates;   
                                }
                                if(b.Actuals__c!=null && (b.Budget_Solution__r.number__c==15))
                                {
                                    totalPeopleExpenseForModelEstimates = totalPeopleExpenseForModelEstimates + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c==16)
                                {
                                    b.Actuals__c= totalPeopleExpenseForModelEstimates;  
                                }
                                if(b.Actuals__c!=null && (b.Budget_Solution__r.number__c==18 || b.Budget_Solution__r.number__c==19 || b.Budget_Solution__r.number__c==20 || b.Budget_Solution__r.number__c==21))
                                {
                                    totalDNPForModelEstimates = totalDNPForModelEstimates +  b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c==22)
                                {
                                    b.Actuals__c= totalDNPForModelEstimates;  
                                    totalMobCostForModelEstimates= totalMobCostForModelEstimates + totalPeopleExpenseForModelEstimates + totalDNPForModelEstimates;
                                }
                                if(b.Budget_Solution__r.number__c==23)
                                {
                                    b.Actuals__c= totalMobCostForModelEstimates;  
                                }
                                if(b.Actuals__c!=null && b.Budget_Solution__r.number__c==24)
                                {
                                    totalMobCostForModelEstimates = totalMobCostForModelEstimates +  b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c==25)
                                {
                                    b.Actuals__c= totalMobCostForModelEstimates;    
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
                                if(b.Actuals__c!=null &&  (b.Budget_Solution__r.number__c ==2 || b.Budget_Solution__r.number__c ==3 || b.Budget_Solution__r.number__c ==4)) {
                                        subTotalProgramManagement = subTotalProgramManagement + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c==5 ) {
                                    b.Actuals__c = subTotalProgramManagement;
                                    TotalCost = TotalCost + subTotalProgramManagement;
                                }
                                if(b.Actuals__c!=null &&  (b.Budget_Solution__r.number__c==7 || b.Budget_Solution__r.number__c==8 || b.Budget_Solution__r.number__c==9 || b.Budget_Solution__r.number__c==10)) {
                                    subTotalEnablePeople = subTotalEnablePeople + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c==11 ) {
                                    b.Actuals__c = subTotalEnablePeople;
                                    TotalCost = TotalCost + subTotalEnablePeople;
                                }
                                if(b.Actuals__c!=null &&  (b.Budget_Solution__r.number__c==13 || b.Budget_Solution__r.number__c==14 || b.Budget_Solution__r.number__c==15 || b.Budget_Solution__r.number__c==16 || b.Budget_Solution__r.number__c==17)) {
                                    subTotalKTCosts = subTotalKTCosts + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c==18 ) {
                                    b.Actuals__c = subTotalKTCosts;
                                    TotalCost = TotalCost + subTotalKTCosts;
                                }
                                if(b.Actuals__c!=null &&  (b.Budget_Solution__r.number__c==20 || b.Budget_Solution__r.number__c==21 || b.Budget_Solution__r.number__c==22 || b.Budget_Solution__r.number__c==23)) {
                                    subTotalBPOTechnology = subTotalBPOTechnology + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c==24 ) {
                                    b.Actuals__c = subTotalBPOTechnology;
                                    TotalCost = TotalCost + subTotalBPOTechnology;
                                }
                                if(b.Actuals__c!=null &&  (b.Budget_Solution__r.number__c==26 || b.Budget_Solution__r.number__c==27 || b.Budget_Solution__r.number__c==28 || b.Budget_Solution__r.number__c==29)) {
                                    subTotalBSS = subTotalBSS + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c== 30) {
                                    b.Actuals__c = subTotalBSS;
                                    TotalCost = TotalCost + subTotalBSS;
                                }
                                if(b.Actuals__c!=null &&  (b.Budget_Solution__r.number__c==32 || b.Budget_Solution__r.number__c==33 || b.Budget_Solution__r.number__c==34 || b.Budget_Solution__r.number__c==35)) {
                                    subTotalDealPMO = subTotalDealPMO + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c== 36) {
                                    b.Actuals__c = subTotalDealPMO;
                                    TotalCost = TotalCost + subTotalDealPMO;
                                }
                                if(b.Actuals__c!=null &&  b.Budget_Solution__r.number__c==38) {
                                    subTotalPreGoLiveCost = subTotalPreGoLiveCost + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c== 39) {
                                    b.Actuals__c = subTotalPreGoLiveCost;
                                    TotalCost = TotalCost + subTotalPreGoLiveCost;
                                }
                                if(b.Actuals__c!=null &&  (b.Budget_Solution__r.number__c== 41 || b.Budget_Solution__r.number__c==42 || b.Budget_Solution__r.number__c==43 || b.Budget_Solution__r.number__c==44 || 
                                        b.Budget_Solution__r.number__c==45 || b.Budget_Solution__r.number__c==46 || b.Budget_Solution__r.number__c==47 || b.Budget_Solution__r.number__c==48)) {
                                    subTotalClinetSpecificCost = subTotalClinetSpecificCost + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c== 49) {
                                    b.Actuals__c = subTotalClinetSpecificCost;
                                    TotalCost = TotalCost + subTotalClinetSpecificCost;
                                }
                                if(b.Actuals__c!=null &&  b.Budget_Solution__r.number__c==51) {
                                    subTotalTransforamtion = subTotalTransforamtion + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c== 52) {
                                    b.Actuals__c = subTotalTransforamtion;
                                    TotalCost = TotalCost + subTotalTransforamtion;
                                }
                                if(b.Actuals__c!=null &&  b.Budget_Solution__r.number__c==54) {
                                    subTotalOther = subTotalOther + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c== 55) {
                                    b.Actuals__c = subTotalOther;
                                    TotalCost = TotalCost + subTotalOther;
                                }
                                if(b.Actuals__c!=null &&  b.Budget_Solution__r.number__c==57) {
                                    subTotalContingency = subTotalContingency + b.Actuals__c;
                                }
                                if(b.Budget_Solution__r.number__c== 58) {
                                    b.Actuals__c = subTotalContingency;
                                    TotalCost = TotalCost + subTotalContingency;
                                }
                                if(b.Budget_Solution__r.number__c== 59) {
                                    b.Actuals__c = TotalCost;
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
    Method Name: cancelBudgetActual
    Description: Method to Cancel All the Budget Actual Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void cancelBudgetActual()
    {
        lstBudgetSolution=[Select id, name, Budget__c, CTA_Cost_Model_Estimates__c, Notes_for_Budget_Actuals__c ,Wave_Plan_Version__c, number__c, isSubmitted__c, 
                           isSubmittedToGovernanceLead__c,summation__c  from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
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
        lstBudgetReforecast=[Select id, Budget_Solution__c, forecast__c,Actuals__c,Variance__c, Month_Name__c,Budget_Solution__r.number__c,year__c,
                             isSubmitted__c,Actuals_Record__c, isActualSubmitted__c, isActualsCopied__c from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId order by Month_Name__c, Budget_Solution__r.number__c ];

        try
        {
             List<Budget_Reforecast__c> listBudgetVarience = new List<Budget_Reforecast__c>();
             if(lstBudgetReforecast.size()>0)
             {
                 for(Budget_Reforecast__c br : lstBudgetReforecast)
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
                    if(startMonthNumber+1>endMonthNumber)
                    {
                        endMonthNumber=lastMonthNumber;
                    }
                    else if(startMonthNumber + 1 == endMonthNumber)
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
                for(Budget_Reforecast__c ba : lstBudgetReforecast)
                {
                    ba.Actuals_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
            sumOfActuals();
            upsert lstBudgetSolution;
            calculateVariance();
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
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
                for(Budget_Reforecast__c ba : lstBudgetReforecast)
                {
                    ba.Actuals_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
            sumOfActuals();
            upsert lstBudgetSolution;
            calculateVariance();
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
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
    
    /******************************
    Method Name: checkMonthIsSelected
    Description: Method to check Month is selected for submission or not
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void checkMonthIsSelected()
    {
        if(listMonthHeader.size()>0)
        {
            isMonthSelected=false;
            boolean isMonthExistForSubmittion=false;
            for(MonthHeader m : listMonthHeader)
            {
                if(lstBudgetReforecast.size()>0)
                {
                    for(Budget_Reforecast__c b : lstBudgetReforecast)
                    {
                        if(m.monthNumber == b.Month_Name__c)
                        {
                            if(b.isActualSubmitted__c ==false)
                            {
                                isMonthExistForSubmittion=true;
                            }
                            if(m.isSelected==true && b.isActualSubmitted__c ==false)
                            {
                                isMonthSelected=true;
                            }
                        }
                    }
                }
            }
            if(isMonthSelected==false)
            {
                if(isMonthExistForSubmittion==false)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No month is there for submission!'));
                    return;
                }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the month for submission!'));
                return;    
            }
        }
        return;
    }
    
    public void submitActual() {
        try {
            if(listMonthHeader.size()>0)
            {
                List<Budget_Reforecast__c> tempBudgetFor=new List<Budget_Reforecast__c>();
                if(lstBudgetSolution.size() > 0  && lstBudgetSolution.size() == 25) {
                    for(MonthHeader m : listMonthHeader)
                    {
                        if(m.isSelected==true)
                        {
                            if(lstBudgetReforecast.size()>0)
                            {
                                for(Budget_Reforecast__c b : lstBudgetReforecast)
                                {
                                    if(m.monthNumber == b.Month_Name__c)
                                    {
                                        if(b.Comments_for_Variance__c == null && b.Variance__c != 0.0 && !(b.Budget_Solution__r.number__c ==1 || b.Budget_Solution__r.number__c ==14 || b.Budget_Solution__r.number__c ==17 || b.Budget_Solution__r.number__c==13 || b.Budget_Solution__r.number__c==16 || b.Budget_Solution__r.number__c ==22 || b.Budget_Solution__r.number__c ==23 || b.Budget_Solution__r.number__c==25)) {
                                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add comments for all positive and negative variances in the Variance Analysis tab'));
                                            return;
                                        }
                                        else {
                                            b.isActualSubmitted__c =true;
                                            tempBudgetFor.add(b);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    for(MonthHeader m : listMonthHeader)
                    {
                        if(m.isSelected==true)
                        {
                            if(lstBudgetReforecast.size()>0)
                            {
                                for(Budget_Reforecast__c b : lstBudgetReforecast)
                                {
                                    if(m.monthNumber == b.Month_Name__c)
                                    {
                                        if(b.Comments_for_Variance__c == null && b.Variance__c != 0.0  && !(b.Budget_Solution__r.number__c==1 || b.Budget_Solution__r.number__c==6 || 
                                            b.Budget_Solution__r.number__c==12 || b.Budget_Solution__r.number__c==19 || b.Budget_Solution__r.number__c == 25 || 
                                            b.Budget_Solution__r.number__c ==31 || b.Budget_Solution__r.number__c ==37 || b.Budget_Solution__r.number__c ==40 || 
                                            b.Budget_Solution__r.number__c ==50 || b.Budget_Solution__r.number__c==53 ||b.Budget_Solution__r.number__c ==56 || 
                                            b.Budget_Solution__r.number__c ==5  || b.Budget_Solution__r.number__c ==11 || b.Budget_Solution__r.number__c ==18 || 
                                            b.Budget_Solution__r.number__c ==24 || b.Budget_Solution__r.number__c == 30  || b.Budget_Solution__r.number__c == 36 || 
                                            b.Budget_Solution__r.number__c == 39 || b.Budget_Solution__r.number__c == 49 || b.Budget_Solution__r.number__c == 52 || 
                                            b.Budget_Solution__r.number__c== 55 || b.Budget_Solution__r.number__c == 58 || b.Budget_Solution__r.number__c == 59)) {
                                            
                                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please add comments for all positive and negative variances in the Variance Analysis tab'));
                                            return;
                                        }
                                        else {
                                            b.isActualSubmitted__c =true;
                                            tempBudgetFor.add(b);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                upsert tempBudgetFor;
                sumOfActuals();
                upsert lstBudgetSolution;
                calculateVariance();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Actuals submitted successfully!'));
                
            }
         }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Submitting!'));
            return;
        }
        return;
    }
}