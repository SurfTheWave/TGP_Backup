/*
Author : Varsha Chougle
Story  : Story-0298/MOB_158
Description :Budget Variance tab. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class Mob_VarianceAnalysisController {

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
    
    /******************************
    Method Name: Mob_VarianceAnalysisController
    Description: This is Constructor for the Mob_VarianceAnalysisController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public Mob_VarianceAnalysisController(ApexPages.StandardController controller) {
        //Wave plan version Id
        waveId=ApexPages.CurrentPage().getParameters().get('id');
        
        //List of Budget Solution
        lstBudgetSolution=[Select name, Wave_Plan_Version__c, number__c, isSubmitted__c, isSubmittedToGovernanceLead__c,
                            summation__c from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c ];
        
        if(lstBudgetSolution.size()>0)
        {
            isSubmit=lstBudgetSolution[0].isSubmittedToGovernanceLead__c;
        } 
        
        giveFirstAndLastMonth();
        giveStartAndEndMonth();
        
        //List of Budget Reforecast
        lstBudgetReforecast=[Select  Budget_Solution__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Variance__c,
                             isSubmitted__c,Actuals_Record__c,Reforecast_Record__c,Varience_Record__c, Comments_for_Variance__c  from Budget_Reforecast__c
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId and Month_Name__c >=: startMonthNumber and Month_Name__c <=: endMonthNumber order by Month_Name__c, Budget_Solution__r.number__c ]; 
                             
        Months=new List<String>();                    
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
                        if(lstBudgetReforecast.size()>0)
                        {
                            if(lstBudgetReforecast[0].Actuals_Record__c== false)
                            {
                                msg='Actuals are not saved!';
                                disableMsg=true;
                            }
                            else
                            {
                                disableMsg=false;
                                giveListOfMonth();
                            }    
                        }
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
    
    //Class for Budget Varience 
    public class BudgetVarience
    {
        public Budget_Reforecast__c newBudgetVarience{get;set;}
        
        public BudgetVarience(Budget_Reforecast__c newBudgetVarience)
        {
            this.newBudgetVarience=newBudgetVarience;
        }
    }

    //Class for Budget Solution
    public class BudgetSolution
    {
        public Budget_Solution__c newBudgetSolution{get; set;}
        public String bgColor{get;set;}
        public boolean isDisableInputMonth{get;set;}
        public boolean isDisableOutputMonth{get;set;}
        public List<BudgetVarience> listBudgetVarience {get;set;}
        
        //Constructor for BudgetSolution
        public BudgetSolution(Budget_Solution__c newBudgetSolution , String bgColor, List<BudgetVarience> listBudgetVarience, boolean isDisableInputMonth, boolean  isDisableOutputMonth)
        {
            this.newBudgetSolution=newBudgetSolution; 
            this.bgColor=bgColor;
            this.listBudgetVarience=listBudgetVarience; 
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
        lstBudgetReforecast=[Select  Budget_Solution__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Variance__c,
                             isSubmitted__c,Actuals_Record__c,Reforecast_Record__c,Varience_Record__c, Comments_for_Variance__c  from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId and Month_Name__c >=: startMonthNumber and Month_Name__c <=: endMonthNumber order by Month_Name__c, Budget_Solution__r.number__c ];
        
        List<BudgetSolution> listOfBudgetSolution=new List<BudgetSolution>();
        if(lstBudgetSolution.size()>0) {
            if(lstBudgetSolution.size() == 25) {
                for(Budget_Solution__c b: lstBudgetSolution) {
                    String bgColor=null;
                    boolean isDisableInputMonth=null;
                    boolean isDisableOutputMonth=null;
                    List<BudgetVarience> listBudgetVarience=new List<BudgetVarience>();  
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
                    if(lstBudgetReforecast.size()>0) {
                        for(Budget_Reforecast__c  bv : lstBudgetReforecast)
                        {
                            if(b.id== bv.Budget_Solution__c)
                            {
                                listBudgetVarience.add(new BudgetVarience(bv));
                            }
                        }
                    }
                    
                    listOfBudgetSolution.add(new BudgetSolution(b, bgColor, listBudgetVarience, isDisableInputMonth, isDisableOutputMonth));
                }
            } 
            else {
                for(Budget_Solution__c b: lstBudgetSolution) {
                    String bgColor=null;
                    boolean isDisableInputMonth=null;
                    boolean isDisableOutputMonth=null;
                    List<BudgetVarience> listBudgetVarience=new List<BudgetVarience>();  
                    if(b.number__c==1 || b.number__c==6 || b.number__c==12 || b.number__c==19 || b.number__c== 25
                     || b.number__c==31 || b.number__c==37 || b.number__c==40 || b.number__c==50 || b.number__c==53 || b.number__c==56) {
                        isDisableInputMonth=false;
                        isDisableOutputMonth=false;
                        bgColor='#4791FF';
                    }
                    else if(b.number__c==5 || b.number__c==11 || b.number__c==18 || b.number__c==24 || b.number__c== 30 || b.number__c== 36 
                            || b.number__c== 39 || b.number__c== 49 || b.number__c== 52 || b.number__c== 55 || b.number__c== 58 || b.number__c== 59)
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
                    if(lstBudgetReforecast.size()>0) {
                        for(Budget_Reforecast__c  bv : lstBudgetReforecast)
                        {
                            if(b.id== bv.Budget_Solution__c)
                            {
                                listBudgetVarience.add(new BudgetVarience(bv));
                            }
                        }
                    }
                    
                    listOfBudgetSolution.add(new BudgetSolution(b, bgColor, listBudgetVarience, isDisableInputMonth, isDisableOutputMonth));
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
        lstBudgetReforecast=[Select  Budget_Solution__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Variance__c,
                             isSubmitted__c,Actuals_Record__c,Reforecast_Record__c,Varience_Record__c, Comments_for_Variance__c  from Budget_Reforecast__c 
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
                        Months.add(convertIntoMonth(budgetRf.Month_Name__c, budgetRf.year__c) + '(in $ ‘000)');
                        Months.add('Comments');
                    }    
                }
            }
        } 
    }
    
    /******************************
    Method Name: saveBudgetVariance
    Description: Method to save All the Budget Variance Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void  saveBudgetVariance()
    {
        try
        {
            if(lstBudgetReforecast.size()>0)
            {
                for(Budget_Reforecast__c ba : lstBudgetReforecast)
                {
                    ba.Varience_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Variance Analysis saved successfully!'));
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
            return ;
        }
        return;
      /*  PageReference pr=new PageReference('/apex/BudgetTracker?id='+waveId+'&tab=tab4');
        pr.setRedirect(false);
        return pr; */
    }
    
    /******************************
    Method Name: cancelBudgetVariance
    Description: Method to Cancel All the Budget Variance Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void cancelBudgetVariance()
    {
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
                    if(startMonthNumber+2>endMonthNumber)
                    {
                        endMonthNumber=lastMonthNumber;
                    }
                    else if(startMonthNumber + 2 == endMonthNumber)
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
                    ba.Varience_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
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
                    ba.Varience_Record__c=true;
                }
            }
            upsert lstBudgetReforecast;
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
}