/*
Author : Varsha Chougle
Story  : Story-0299/MOB_159
Description :Contingency Management tab.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class Mob_ContingencyManagementController {

    public string waveId{get;set;}
    public List<Budget_Solution__c> lstBudgetSolution{get;set;}
    public List<MOB_User_Role_Assignment__c> lstUserRoleAssign{get; set;}
    public List<Budget_Reforecast__c> lstBudgetReforecast{get;set;}
    public boolean disableMsg{get;set;}
    public String msg{get;set;}
    public List<String> Months{get;set;}
    public boolean isSubmit{get;set;}
    public boolean showSubmitButton{get;set;}
    public boolean submitToGovLead{get;set;}
    public boolean isFinalSubmit{get;set;}
    public boolean isError{get;set;}
    public boolean isAvailable{get;set;}
    public List<BudgetSolution> listOfBudgetSolution1{get;set;}
    public decimal startMonthNumber{get;set;}
    public decimal EndMonthNumber{get;set;}
    public decimal firstMonthNumber{get;set;}
    public decimal lastMonthNumber{get;set;}
    public decimal lastYearNumber{get;set;}
    public boolean showPrevious{get;set;}
    public boolean showNext{get;set;}
    
    /******************************
    Method Name: Mob_ContingencyManagementController
    Description: This is Constructor for the Mob_ContingencyManagementController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public Mob_ContingencyManagementController(ApexPages.StandardController controller) 
    {
        //Wave plan version Id
        waveId=ApexPages.CurrentPage().getParameters().get('id');
        
        //List of Budget Solution
        lstBudgetSolution=[Select id, name, CTA_Cost_Model_Estimates__c,EAC__c,Difference__c, Wave_Plan_Version__c, 
                            number__c, isSubmitted__c, Comments_for_Change_Orders__c, Comments_for_Cost_Overruns__c, isSubmittedToGovernanceLead__c,
                            Submitted_by_Governance_Lead__c,Wave_Plan_Version__r.Deal__c , Wave_Plan_Version__r.Deal__r.name
                            from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
        
        if(lstBudgetSolution.size()>0)
        {
            lstUserRoleAssign = [select Deal__c,Role_Name__c,User_Assigned_New__c,User_Assigned_Secondary_New__c,
            						User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c ,User_Assigned_New__r.SFDC_User__r.IsActive,
            						User_Assigned_Secondary_New__r.SFDC_User__r.IsActive
                                    from MOB_User_Role_Assignment__c where Deal__c = :lstBudgetSolution[0].Wave_Plan_Version__r.Deal__c];
            if(lstBudgetSolution[0].isSubmittedToGovernanceLead__c== true)
            {
                if(lstUserRoleAssign.size()>0)
                {
                    isAvailable=false;
                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                    {
                        if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && (mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()))
                        {
                            isAvailable=true;
                            if(lstBudgetSolution[0].Submitted_by_Governance_Lead__c==true)
                            {
                                isSubmit=true;
                                showSubmitButton=true;
                            }
                            else
                            {
                                isSubmit=false;
                                showSubmitButton=true;
                            }
                        }
                    }
                    if(isAvailable==false)
                    {
                        isSubmit=lstBudgetSolution[0].isSubmittedToGovernanceLead__c;
                        showSubmitButton=lstBudgetSolution[0].isSubmittedToGovernanceLead__c;
                    }
                }
                String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;                    
                if(userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN))
                {
                    if(lstBudgetSolution[0].Submitted_by_Governance_Lead__c==true)
                    {
                        isSubmit=true;
                        showSubmitButton=true;
                    }
                    else
                    {
                        isSubmit=false;
                        showSubmitButton=true;
                    }
                }     
            }
            else
            {
                isSubmit=lstBudgetSolution[0].isSubmittedToGovernanceLead__c;
                showSubmitButton=lstBudgetSolution[0].isSubmittedToGovernanceLead__c;
            }
            
            isError=false;
        } 
        
        giveFirstAndLastMonth();
        giveStartAndEndMonth();
        
        //List of Budget Reforecast
        lstBudgetReforecast=[Select  Budget_Solution__c, forecast__c,Actuals__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Variance__c ,
                             isSubmitted__c,Actuals_Record__c,Reforecast_Record__c,  Change_Orders_per_Month__c,Cost_Overruns_per_Month__c  from Budget_Reforecast__c
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
 
    //class for Budget Contingency
    public class BudgetContingency
    {
        public Budget_Reforecast__c newBudgetContingency{get;set;}
        
        public BudgetContingency(Budget_Reforecast__c newBudgetContingency)
        {
            this.newBudgetContingency=newBudgetContingency;
        }
    }
    
    //Class for Budget Solution
    public class BudgetSolution
    {
        public Budget_Solution__c newBudgetSolution{get; set;}
        public String bgColor{get;set;}
        public boolean isDisableInputMonth{get;set;}
        public boolean isDisableOutputMonth{get;set;}
        public List<BudgetContingency> listBudgetContingency {get;set;}
        
        //Constructor for BudgetSolution
        public BudgetSolution(Budget_Solution__c newBudgetSolution , String bgColor, List<BudgetContingency> listBudgetContingency, boolean isDisableInputMonth, boolean  isDisableOutputMonth)
        {
            this.newBudgetSolution=newBudgetSolution; 
            this.bgColor=bgColor;
            this.listBudgetContingency=listBudgetContingency; 
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
        if(isError!=true)
        {
        listOfBudgetSolution1=new List<BudgetSolution>();
        giveListOfMonth();
        lstBudgetReforecast=[Select Budget_Solution__c, forecast__c,Actuals__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Variance__c ,
                             isSubmitted__c,Actuals_Record__c,Reforecast_Record__c,  Change_Orders_per_Month__c,Cost_Overruns_per_Month__c from Budget_Reforecast__c 
                             where Budget_Solution__r.Wave_Plan_Version__c=: waveId and Month_Name__c >=: startMonthNumber and Month_Name__c <=: endMonthNumber order by Month_Name__c, Budget_Solution__r.number__c ];
		
        if(lstBudgetSolution.size()>0)
        {
        	Boolean isOldData = false;
        	if(lstBudgetSolution.size() == 25) {
        		isOldData = true;
        	}
            for(Budget_Solution__c b: lstBudgetSolution)
            {
                String bgColor=null;
                boolean isDisableInputMonth=null;
                boolean isDisableOutputMonth=null;
                List<BudgetContingency> listBudgetContingency=new List<BudgetContingency>();  
                if( isOldData && (b.number__c==1 || b.number__c==14 || b.number__c==17))
                {
                    isDisableInputMonth=false;
                    isDisableOutputMonth=false;
                    bgColor='#4791FF';
                }
                else if( isOldData && (b.number__c==13 || b.number__c==16 || b.number__c==22 || b.number__c==23 || b.number__c==25))
                {
                    isDisableInputMonth=false;
                    isDisableOutputMonth=true;
                    bgColor='#EAEAEB';
                }
                else if (!isOldData && (b.number__c==1 || b.number__c==6 || b.number__c==12 || b.number__c==19 || b.number__c== 25
                	 	|| b.number__c==31 || b.number__c==37 || b.number__c==40 || b.number__c==50 || b.number__c==53 || b.number__c==56)) {
            	 	isDisableInputMonth=false;
                	isDisableOutputMonth=false;
                    bgColor='#4791FF';	
        	 	}
        	 	else if (!isOldData && (b.number__c==5 || b.number__c==11 || b.number__c==18 || b.number__c==24 || b.number__c== 30 || b.number__c== 36 
                			|| b.number__c== 39 || b.number__c== 49 || b.number__c== 52 || b.number__c== 55 || b.number__c== 58 || b.number__c== 59)) {
        	 		isDisableInputMonth=false;
                    isDisableOutputMonth=true;
                    bgColor='#EAEAEB';
        	 	}
                else
                {
                    if(b.isSubmittedToGovernanceLead__c==true)
                    { 
                        boolean isAvailable=false;
                        for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                        {
                            if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && (mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()))
                            {
                                isAvailable=true;
                                if(b.Submitted_by_Governance_Lead__c==true)
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
                        }
                        if(isAvailable==false)
                        {
                            isDisableInputMonth=false;
                            isDisableOutputMonth=true;
                        } 
                        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;                    
                        if(userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN))
                        {
                            if(b.Submitted_by_Governance_Lead__c==true)
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
                    }
                    else
                    {
                        isDisableInputMonth=true;
                        isDisableOutputMonth=false;
                    }
                }
                if(lstBudgetReforecast.size()>0)
                {
                    for(Budget_Reforecast__c  bc : lstBudgetReforecast)
                    {
                        if(b.id== bc.Budget_Solution__c)
                        {
                            listBudgetContingency.add(new BudgetContingency(bc));
                        }
                    }
                }
                
                listOfBudgetSolution1.add(new BudgetSolution(b, bgColor, listBudgetContingency, isDisableInputMonth, isDisableOutputMonth));
            } 
        }
        }
        return listOfBudgetSolution1;
        
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
       lstBudgetReforecast=[Select Budget_Solution__c, forecast__c,Actuals__c, Month_Name__c,Budget_Solution__r.number__c,year__c,Variance__c ,
                             isSubmitted__c,Actuals_Record__c,Reforecast_Record__c,  Change_Orders_per_Month__c,Cost_Overruns_per_Month__c from Budget_Reforecast__c 
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
    
    /******************************
    Method Name: saveContingencyManagement
    Description: Method to save Contingency Management.  
    Paramenters: NA
    Return Value: Void
    *******************************/ 
    public void saveContingencyManagement()
    {
        isError=false;
        try
        {
            if(lstBudgetSolution.size()>0)
            {
                if(lstBudgetSolution.size() == 25) {
	                for(Budget_Solution__c b: lstBudgetSolution)
	                {
	                    if(lstBudgetReforecast.size()>0 && b.number__c!=13 && b.number__c!=16 && b.number__c!=22 && b.number__c!=23 && b.number__c!=25)
	                    {
	                        Decimal totalAmountAllocation=0;
	                        boolean isValueExist=false;
	                        for(Budget_Reforecast__c bfc : lstBudgetReforecast)
	                        {
	                            if(bfc.Budget_Solution__c == b.id)
	                            {
	                                if(bfc.Change_Orders_per_Month__c ==null && bfc.Cost_Overruns_per_Month__c==null)
	                                {
	                                    totalAmountAllocation = totalAmountAllocation;
	                                }
	                                else if(bfc.Change_Orders_per_Month__c ==null)
	                                {
	                                    totalAmountAllocation = totalAmountAllocation + bfc.Cost_Overruns_per_Month__c;
	                                    isValueExist=true;
	                                }
	                                else if(bfc.Cost_Overruns_per_Month__c==null)
	                                {
	                                    totalAmountAllocation = totalAmountAllocation + bfc.Change_Orders_per_Month__c ;
	                                    isValueExist=true;
	                                }
	                                else
	                                {
	                                    totalAmountAllocation = totalAmountAllocation + bfc.Change_Orders_per_Month__c + bfc.Cost_Overruns_per_Month__c;
	                                    isValueExist=true;
	                                }
	                            }
	                        }
	                        if(totalAmountAllocation > b.Difference__c && isValueExist==true) {
	                            isError=true;
	                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The total amount of allocation should be less than or equal to Difference amount, for '+b.name+' !'));         
	                            return;
	                        }
	                    }
	                    
	                } 
                }
                else {
                	for(Budget_Solution__c b: lstBudgetSolution)
	                {
	                    if(lstBudgetReforecast.size()>0 && b.number__c!=5 && b.number__c!=11 && b.number__c!=18 && b.number__c!=24 && b.number__c!=30 && b.number__c!= 36 && b.number__c!= 39 && b.number__c!= 49 && b.number__c!= 52 && b.number__c!= 58 && b.number__c!= 55 && b.number__c!= 59)
	                    {
	                        Decimal totalAmountAllocation=0;
	                        boolean isValueExist=false;
	                        for(Budget_Reforecast__c bfc : lstBudgetReforecast)
	                        {
	                            if(bfc.Budget_Solution__c == b.id)
	                            {
	                                if(bfc.Change_Orders_per_Month__c ==null && bfc.Cost_Overruns_per_Month__c==null)
	                                {
	                                    totalAmountAllocation = totalAmountAllocation;
	                                }
	                                else if(bfc.Change_Orders_per_Month__c ==null)
	                                {
	                                    totalAmountAllocation = totalAmountAllocation + bfc.Cost_Overruns_per_Month__c;
	                                    isValueExist=true;
	                                }
	                                else if(bfc.Cost_Overruns_per_Month__c==null)
	                                {
	                                    totalAmountAllocation = totalAmountAllocation + bfc.Change_Orders_per_Month__c ;
	                                    isValueExist=true;
	                                }
	                                else
	                                {
	                                    totalAmountAllocation = totalAmountAllocation + bfc.Change_Orders_per_Month__c + bfc.Cost_Overruns_per_Month__c;
	                                    isValueExist=true;
	                                }
	                            }
	                        }
	                        if(totalAmountAllocation > b.Difference__c && isValueExist==true) {
	                            isError=true;
	                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The total amount of allocation should be less than or equal to Difference amount, for '+b.name+' !'));         
	                            return;
	                        }
	                    }
	                    
	                }
                }
                //
                upsert lstBudgetReforecast;
                upsert lstBudgetSolution;
                sumOfContingencyManagementforChangeOrder();
                sumOfContingencyManagementforCostOverruns();
                totalBudget();
                if(submitToGovLead !=true)
                {
                    isError=false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Contingency Management saved successfully!'));  
                } 
            }
        }
        catch(Exception ex) 
        {
            if(submitToGovLead !=true)
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'+ex));
            return;
        }  
        return;
    }
    
    /******************************
    Method Name: cancelContingencyManagement
    Description: Method to Cancel All the Contingency Management Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void cancelContingencyManagement()
    {
        lstBudgetSolution=[Select  name,  CTA_Cost_Model_Estimates__c,EAC__c,Difference__c, Wave_Plan_Version__c, 
                            number__c, isSubmitted__c, Comments_for_Change_Orders__c, Comments_for_Cost_Overruns__c, isSubmittedToGovernanceLead__c,
                            Submitted_by_Governance_Lead__c,Wave_Plan_Version__r.Deal__c , Wave_Plan_Version__r.Deal__r.name
                            from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
        return;
    }
    
    /******************************
    Method Name: SubmitContingencyManagement
    Description: Method to Submit Contingency Management to Governance Lead.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void SubmitContingencyManagement()
    {
        submitToGovLead=true;
        saveContingencyManagement();
        if(isError!=true)
        {
            try
            {
                if(lstBudgetReforecast.size()>0)
                {
                    for(Budget_Reforecast__c ba : lstBudgetReforecast)
                    {
                        ba.isSubmitted__c=true;
                    }
                }
                upsert lstBudgetReforecast;
                sumOfContingencyManagementforChangeOrder();
                sumOfContingencyManagementforCostOverruns();
    
                if(lstBudgetSolution.size()>0)
                {
                    for(Budget_Solution__c b: lstBudgetSolution)
                    {
                        b.isSubmittedToGovernanceLead__c=true;
                    }
                    isSubmit=true;
                    showSubmitButton=true;
                }
                upsert lstBudgetSolution;
                Task newTask= new Task();
                Task newTask1= new Task();
                
                if(lstUserRoleAssign.size()>0)
                {
                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                    {
                        if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && mobUser.User_Assigned_New__c != null)
                        {
                        	if(mobUser.User_Assigned_New__r.SFDC_User__r.IsActive) {
	                            newTask.OwnerId = mobUser.User_Assigned_New__r.SFDC_User__c;
	                            newTask.Subject = 'Please submit Budget tracker for deal:'+lstBudgetSolution[0].Wave_Plan_Version__r.Deal__r.name;
	                            newTask.Status = 'Not Started';
	                            newTask.Description = '';
	                            insert newTask;
                        	}
                        }
                    }
                }
                if(lstUserRoleAssign.size()>0)
                {
                    for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                    {
                        if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && mobUser.User_Assigned_Secondary_New__c != null)
                        {
                        	if(mobUser.User_Assigned_Secondary_New__r.SFDC_User__r.IsActive) {
	                            newTask1.OwnerId = mobUser.User_Assigned_Secondary_New__c;
	                            newTask1.Subject = 'Please submit Budget tracker for deal:'+lstBudgetSolution[0].Wave_Plan_Version__r.Deal__r.name;
	                            newTask1.Status = 'Not Started';
	                            newTask1.Description = '';
	                            insert newTask1;
                        	}
                        }
                    }
                }
                
                if(lstBudgetSolution.size()>0)
                {
                    for(Budget_Solution__c b: lstBudgetSolution)
                    {
                        b.GovernanceLeadPrimaryTaskId__c=newTask.id;
                        b.GovernanceLeadSecondaryTaskId__c=newTask1.id;
                    }
                }
                upsert lstBudgetSolution;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Contingency Management submitted successfully!'));
            }
            catch(Exception ex) 
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in submitting!'+ex));
                return;
            }
        }
        return;
    }
    
    /******************************
    Method Name: totalBudget
    Description: Method to calculate total Budget.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void totalBudget()
    {
        List<Wave_Plan_Version__c> lstWavePlanVersion=[select name, Change_Order__c, Cost_Overrun__c, Total_Cost_Above_Budget__c
        													from Wave_Plan_Version__c where id=:waveId];
        try
        {
            if(lstBudgetReforecast.size()>0)
            {
                Decimal sumOfChangeOrder=0; 
                Decimal sumOfCostOverrun=0;
                Decimal totalCostAboveBudget=0;
                for(Budget_Reforecast__c br : lstBudgetReforecast)
                {
                    if(br.Change_Orders_per_Month__c != null && br.Budget_Solution__r.number__c==25)
                    {
                        sumOfChangeOrder= sumOfChangeOrder + br.Change_Orders_per_Month__c;  
                    } 
                    if(br.Cost_Overruns_per_Month__c != null && br.Budget_Solution__r.number__c==25)
                    {
                        sumOfCostOverrun= sumOfCostOverrun + br.Cost_Overruns_per_Month__c;  
                    }        
                }
                if(lstWavePlanVersion.size()==1)
                {
                    totalCostAboveBudget = sumOfChangeOrder + sumOfCostOverrun;
                    lstWavePlanVersion[0].Change_Order__c=sumOfChangeOrder;
                    lstWavePlanVersion[0].Cost_Overrun__c=sumOfCostOverrun;
                    lstWavePlanVersion[0].Total_Cost_Above_Budget__c=totalCostAboveBudget;
                    upsert lstWavePlanVersion;
                }
                
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
    Method Name: sumOfContingencyManagementforChangeOrder
    Description: Method to Calculate Contingency Management change order.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void sumOfContingencyManagementforChangeOrder()
    {
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
	                            if(b.Change_Orders_per_Month__c!=null && (b.Budget_Solution__r.number__c==2 || b.Budget_Solution__r.number__c==3 || b.Budget_Solution__r.number__c==4 || b.Budget_Solution__r.number__c==5 || b.Budget_Solution__r.number__c==6 || b.Budget_Solution__r.number__c==7 || b.Budget_Solution__r.number__c==8 || b.Budget_Solution__r.number__c==9 || b.Budget_Solution__r.number__c==10 || b.Budget_Solution__r.number__c==11 || b.Budget_Solution__r.number__c==12))
	                            {
	                                totalPeopleForModelEstimates= totalPeopleForModelEstimates + b.Change_Orders_per_Month__c;
	                            }
	                            if(b.Budget_Solution__r.number__c==13)
	                            {
	                                b.Change_Orders_per_Month__c= totalPeopleForModelEstimates;
	                                totalPeopleExpenseForModelEstimates= totalPeopleExpenseForModelEstimates + totalPeopleForModelEstimates;   
	                            }
	                            if(b.Change_Orders_per_Month__c!=null && (b.Budget_Solution__r.number__c==15))
	                            {
	                                totalPeopleExpenseForModelEstimates = totalPeopleExpenseForModelEstimates + b.Change_Orders_per_Month__c;
	                            }
	                            if(b.Budget_Solution__r.number__c==16)
	                            {
	                                b.Change_Orders_per_Month__c= totalPeopleExpenseForModelEstimates;  
	                            }
	                            if(b.Change_Orders_per_Month__c!=null && (b.Budget_Solution__r.number__c==18 || b.Budget_Solution__r.number__c==19 || b.Budget_Solution__r.number__c==20 || b.Budget_Solution__r.number__c==21))
	                            {
	                                totalDNPForModelEstimates = totalDNPForModelEstimates +  b.Change_Orders_per_Month__c;
	                            }
	                            if(b.Budget_Solution__r.number__c==22)
	                            {
	                                b.Change_Orders_per_Month__c= totalDNPForModelEstimates;  
	                                totalMobCostForModelEstimates= totalMobCostForModelEstimates + totalPeopleExpenseForModelEstimates + totalDNPForModelEstimates;
	                            }
	                            if(b.Budget_Solution__r.number__c==23)
	                            {
	                                b.Change_Orders_per_Month__c= totalMobCostForModelEstimates;  
	                            }
	                            if(b.Change_Orders_per_Month__c!=null && b.Budget_Solution__r.number__c==24)
	                            {
	                                totalMobCostForModelEstimates = totalMobCostForModelEstimates +  b.Change_Orders_per_Month__c;
	                            }
	                            if(b.Budget_Solution__r.number__c==25)
	                            {
	                                b.Change_Orders_per_Month__c= totalMobCostForModelEstimates;    
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
	            				if(b.Change_Orders_per_Month__c!=null &&  (b.Budget_Solution__r.number__c ==2 || b.Budget_Solution__r.number__c ==3 || b.Budget_Solution__r.number__c ==4)) {
            		 				subTotalProgramManagement = subTotalProgramManagement + b.Change_Orders_per_Month__c;
	        		 			}
		            		 	if(b.Budget_Solution__r.number__c==5 ) {
		            		 		b.Change_Orders_per_Month__c = subTotalProgramManagement;
		            		 		TotalCost = TotalCost + subTotalProgramManagement;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==7 || b.Budget_Solution__r.number__c==8 || b.Budget_Solution__r.number__c==9 || b.Budget_Solution__r.number__c==10)) {
		            		 		subTotalEnablePeople = subTotalEnablePeople + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c==11 ) {
		            		 		b.Change_Orders_per_Month__c = subTotalEnablePeople;
		            		 		TotalCost = TotalCost + subTotalEnablePeople;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==13 || b.Budget_Solution__r.number__c==14 || b.Budget_Solution__r.number__c==15 || b.Budget_Solution__r.number__c==16 || b.Budget_Solution__r.number__c==17)) {
		            		 		subTotalKTCosts = subTotalKTCosts + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c==18 ) {
		            		 		b.Change_Orders_per_Month__c = subTotalKTCosts;
		            		 		TotalCost = TotalCost + subTotalKTCosts;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==20 || b.Budget_Solution__r.number__c==21 || b.Budget_Solution__r.number__c==22 || b.Budget_Solution__r.number__c==23)) {
		            		 		subTotalBPOTechnology = subTotalBPOTechnology + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c==24 ) {
		            		 		b.Change_Orders_per_Month__c = subTotalBPOTechnology;
		            		 		TotalCost = TotalCost + subTotalBPOTechnology;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==26 || b.Budget_Solution__r.number__c==27 || b.Budget_Solution__r.number__c==28 || b.Budget_Solution__r.number__c==29)) {
		            		 		subTotalBSS = subTotalBSS + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 30) {
		            		 		b.Change_Orders_per_Month__c = subTotalBSS;
		            		 		TotalCost = TotalCost + subTotalBSS;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==32 || b.Budget_Solution__r.number__c==33 || b.Budget_Solution__r.number__c==34 || b.Budget_Solution__r.number__c==35)) {
		            		 		subTotalDealPMO = subTotalDealPMO + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 36) {
		            		 		b.Change_Orders_per_Month__c = subTotalDealPMO;
		            		 		TotalCost = TotalCost + subTotalDealPMO;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  b.Budget_Solution__r.number__c==38) {
		            		 		subTotalPreGoLiveCost = subTotalPreGoLiveCost + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 39) {
		            		 		b.Change_Orders_per_Month__c = subTotalPreGoLiveCost;
		            		 		TotalCost = TotalCost + subTotalPreGoLiveCost;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  (b.Budget_Solution__r.number__c== 41 || b.Budget_Solution__r.number__c==42 || b.Budget_Solution__r.number__c==43 || b.Budget_Solution__r.number__c==44 || 
		            		 	 		b.Budget_Solution__r.number__c==45 || b.Budget_Solution__r.number__c==46 || b.Budget_Solution__r.number__c==47 || b.Budget_Solution__r.number__c==48)) {
		            		 		subTotalClinetSpecificCost = subTotalClinetSpecificCost + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 49) {
		            		 		b.Change_Orders_per_Month__c = subTotalClinetSpecificCost;
		            		 		TotalCost = TotalCost + subTotalClinetSpecificCost;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  b.Budget_Solution__r.number__c==51) {
		            		 		subTotalTransforamtion = subTotalTransforamtion + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 52) {
		            		 		b.Change_Orders_per_Month__c = subTotalTransforamtion;
		            		 		TotalCost = TotalCost + subTotalTransforamtion;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  b.Budget_Solution__r.number__c==54) {
		            		 		subTotalOther = subTotalOther + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 55) {
		            		 		b.Change_Orders_per_Month__c = subTotalOther;
		            		 		TotalCost = TotalCost + subTotalOther;
		            		 	}
		            		 	if(b.Change_Orders_per_Month__c!=null &&  b.Budget_Solution__r.number__c==57) {
		            		 		subTotalContingency = subTotalContingency + b.Change_Orders_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 58) {
		            		 		b.Change_Orders_per_Month__c = subTotalContingency;
		            		 		TotalCost = TotalCost + subTotalContingency;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 59) {
		            		 		b.Change_Orders_per_Month__c = TotalCost;
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
    Method Name: sumOfContingencyManagementforCostOverruns
    Description: Method to Calculate Contingency Management Cost overrun.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void sumOfContingencyManagementforCostOverruns()
    {
        try
        {
            if(lstBudgetSolution.size()>0)
            {
                List<Budget_Reforecast__c> tempBudgetFor=new List<Budget_Reforecast__c>();
                if(lstBudgetSolution.size() == 25) {
	                for(string m : Months) {
	                    Decimal totalPeopleForModelEstimates=0;
	                    Decimal totalPeopleExpenseForModelEstimates=0;
	                    Decimal totalDNPForModelEstimates=0;
	                    Decimal totalMobCostForModelEstimates=0;
	                    for(Budget_Reforecast__c b : lstBudgetReforecast) {
	                        String currentMonthName=convertIntoMonth(b.Month_Name__c, b.year__c);
	                        if(m == currentMonthName)
	                        {
	                            if(b.Cost_Overruns_per_Month__c!=null && (b.Budget_Solution__r.number__c==2 || b.Budget_Solution__r.number__c==3 || b.Budget_Solution__r.number__c==4 || b.Budget_Solution__r.number__c==5 || b.Budget_Solution__r.number__c==6 || b.Budget_Solution__r.number__c==7 || b.Budget_Solution__r.number__c==8 || b.Budget_Solution__r.number__c==9 || b.Budget_Solution__r.number__c==10 || b.Budget_Solution__r.number__c==11 || b.Budget_Solution__r.number__c==12))
	                            {
	                                totalPeopleForModelEstimates= totalPeopleForModelEstimates + b.Cost_Overruns_per_Month__c;
	                            }
	                            if(b.Budget_Solution__r.number__c==13)
	                            {
	                                b.Cost_Overruns_per_Month__c= totalPeopleForModelEstimates;
	                                totalPeopleExpenseForModelEstimates= totalPeopleExpenseForModelEstimates + totalPeopleForModelEstimates;   
	                            }
	                            if(b.Cost_Overruns_per_Month__c!=null && (b.Budget_Solution__r.number__c==15))
	                            {
	                                totalPeopleExpenseForModelEstimates = totalPeopleExpenseForModelEstimates + b.Cost_Overruns_per_Month__c;
	                            }
	                            if(b.Budget_Solution__r.number__c==16)
	                            {
	                                b.Cost_Overruns_per_Month__c= totalPeopleExpenseForModelEstimates;  
	                            }
	                            if(b.Cost_Overruns_per_Month__c!=null && (b.Budget_Solution__r.number__c==18 || b.Budget_Solution__r.number__c==19 || b.Budget_Solution__r.number__c==20 || b.Budget_Solution__r.number__c==21))
	                            {
	                                totalDNPForModelEstimates = totalDNPForModelEstimates +  b.Cost_Overruns_per_Month__c;
	                            }
	                            if(b.Budget_Solution__r.number__c==22)
	                            {
	                                b.Cost_Overruns_per_Month__c= totalDNPForModelEstimates;  
	                                totalMobCostForModelEstimates= totalMobCostForModelEstimates + totalPeopleExpenseForModelEstimates + totalDNPForModelEstimates;
	                            }
	                            if(b.Budget_Solution__r.number__c==23)
	                            {
	                                b.Cost_Overruns_per_Month__c= totalDNPForModelEstimates;
	                            }
	                            if(b.Cost_Overruns_per_Month__c!=null && b.Budget_Solution__r.number__c==24)
	                            {
	                                totalMobCostForModelEstimates = totalMobCostForModelEstimates +  b.Cost_Overruns_per_Month__c;
	                            }
	                            if(b.Budget_Solution__r.number__c==25)
	                            {
	                                b.Cost_Overruns_per_Month__c= totalMobCostForModelEstimates;    
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
	                        	if(b.Cost_Overruns_per_Month__c!=null &&  (b.Budget_Solution__r.number__c ==2 || b.Budget_Solution__r.number__c ==3 || b.Budget_Solution__r.number__c ==4)) {
            		 				subTotalProgramManagement = subTotalProgramManagement + b.Cost_Overruns_per_Month__c;
	        		 			}
		            		 	if(b.Budget_Solution__r.number__c==5 ) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalProgramManagement;
		            		 		TotalCost = TotalCost + subTotalProgramManagement;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==7 || b.Budget_Solution__r.number__c==8 || b.Budget_Solution__r.number__c==9 || b.Budget_Solution__r.number__c==10)) {
		            		 		subTotalEnablePeople = subTotalEnablePeople + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c==11 ) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalEnablePeople;
		            		 		TotalCost = TotalCost + subTotalEnablePeople;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==13 || b.Budget_Solution__r.number__c==14 || b.Budget_Solution__r.number__c==15 || b.Budget_Solution__r.number__c==16 || b.Budget_Solution__r.number__c==17)) {
		            		 		subTotalKTCosts = subTotalKTCosts + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c==18 ) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalKTCosts;
		            		 		TotalCost = TotalCost + subTotalKTCosts;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==20 || b.Budget_Solution__r.number__c==21 || b.Budget_Solution__r.number__c==22 || b.Budget_Solution__r.number__c==23)) {
		            		 		subTotalBPOTechnology = subTotalBPOTechnology + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c==24 ) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalBPOTechnology;
		            		 		TotalCost = TotalCost + subTotalBPOTechnology;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==26 || b.Budget_Solution__r.number__c==27 || b.Budget_Solution__r.number__c==28 || b.Budget_Solution__r.number__c==29)) {
		            		 		subTotalBSS = subTotalBSS + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 30) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalBSS;
		            		 		TotalCost = TotalCost + subTotalBSS;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  (b.Budget_Solution__r.number__c==32 || b.Budget_Solution__r.number__c==33 || b.Budget_Solution__r.number__c==34 || b.Budget_Solution__r.number__c==35)) {
		            		 		subTotalDealPMO = subTotalDealPMO + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 36) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalDealPMO;
		            		 		TotalCost = TotalCost + subTotalDealPMO;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  b.Budget_Solution__r.number__c==38) {
		            		 		subTotalPreGoLiveCost = subTotalPreGoLiveCost + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 39) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalPreGoLiveCost;
		            		 		TotalCost = TotalCost + subTotalPreGoLiveCost;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  (b.Budget_Solution__r.number__c== 41 || b.Budget_Solution__r.number__c==42 || b.Budget_Solution__r.number__c==43 || b.Budget_Solution__r.number__c==44 || 
		            		 	 		b.Budget_Solution__r.number__c==45 || b.Budget_Solution__r.number__c==46 || b.Budget_Solution__r.number__c==47 || b.Budget_Solution__r.number__c==48)) {
		            		 		subTotalClinetSpecificCost = subTotalClinetSpecificCost + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 49) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalClinetSpecificCost;
		            		 		TotalCost = TotalCost + subTotalClinetSpecificCost;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  b.Budget_Solution__r.number__c==51) {
		            		 		subTotalTransforamtion = subTotalTransforamtion + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 52) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalTransforamtion;
		            		 		TotalCost = TotalCost + subTotalTransforamtion;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  b.Budget_Solution__r.number__c==54) {
		            		 		subTotalOther = subTotalOther + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 55) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalOther;
		            		 		TotalCost = TotalCost + subTotalOther;
		            		 	}
		            		 	if(b.Cost_Overruns_per_Month__c!=null &&  b.Budget_Solution__r.number__c==57) {
		            		 		subTotalContingency = subTotalContingency + b.Cost_Overruns_per_Month__c;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 58) {
		            		 		b.Cost_Overruns_per_Month__c = subTotalContingency;
		            		 		TotalCost = TotalCost + subTotalContingency;
		            		 	}
		            		 	if(b.Budget_Solution__r.number__c== 59) {
		            		 		b.Cost_Overruns_per_Month__c = TotalCost;
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
    
    public void refreshPage()
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
                endMonthNumber=startMonthNumber+5;
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
                    if(startMonthNumber+5>endMonthNumber)
                    {
                        endMonthNumber=lastMonthNumber;
                    }
                    else if(startMonthNumber + 5 == endMonthNumber)
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
        submitToGovLead =true;
        saveContingencyManagement();
        submitToGovLead =false;
        startMonthNumber=endMonthNumber+1;
        endMonthNumber=startMonthNumber+5;
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
        submitToGovLead =true;
        saveContingencyManagement();
        submitToGovLead =false;
        endMonthNumber=startMonthNumber-1;
        startMonthNumber=endMonthNumber-5;
        if(startMonthNumber==firstMonthNumber)
        {
            showPrevious=false;
        }
        showNext=true;
        return;
    }
}