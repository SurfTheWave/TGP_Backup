/*
Author : Varsha Chougle
Story  : Story-0093/MOB_052  
Description :initiate Budget Tracker. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

public with sharing class Mob_BudgetSolutionController {

    public string waveId{get;set;}
    public List<Budget_Solution__c> lstBudgetSolution{get;set;}
    public boolean isSubmit{get;set;}
    public Wave_Plan_Version__c wpv {get;set;}
    public MOB_User_Role_Assignment__c mobUserAssignment {get;set;}
    
    /******************************
    Method Name: Mob_BudgetSolutionController
    Description: This is Constructor for the Mob_BudgetSolutionController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public Mob_BudgetSolutionController(ApexPages.StandardController controller) {
        //Wave plan version Id
        waveId=ApexPages.CurrentPage().getParameters().get('id');
        wpv = [Select Deal__c From Wave_Plan_Version__c Where Id =: waveId limit 1];
        mobUserAssignment = [Select Role_Name__c,User_Assigned_FF__c From MOB_User_Role_Assignment__c Where Role_Name__c =: 'Commercial Lead' and Deal__c =: wpv.Deal__c];
        //List of Budget Solution
        lstBudgetSolution=[Select id, name, Budget__c, CTA_Cost_Model_Estimates__c, Notes__c,Wave_Plan_Version__c, number__c, isSubmitted__c 
                            from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
        if(lstBudgetSolution.size()>0)
        {
            isSubmit=lstBudgetSolution[0].isSubmitted__c;
        }  
                        
    }
    
    //Class for Budget Solution
    public class BudgetSolution
    {
        public Budget_Solution__c newBudgetSolution{get; set;}
        public String bgColor{get;set;}
        public boolean isDisable{get;set;}
        public boolean isDisableInput{get;set;}
        public boolean isDisableOutput{get;set;}
        
        //Constructor for BudgetSolution
        public BudgetSolution(Budget_Solution__c newBudgetSolution , String bgColor, boolean isDisable, boolean isDisableInput, boolean isDisableOutput)
        {
            this.newBudgetSolution=newBudgetSolution; 
            this.bgColor=bgColor;
            this.isDisable=isDisable;
            this.isDisableInput=isDisableInput;
            this.isDisableOutput=isDisableOutput;   
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
        List<BudgetSolution> listOfBudgetSolution=new List<BudgetSolution>();
        // For Old budget Tracker elements
        if(lstBudgetSolution.size()>0 && lstBudgetSolution.size() == 25) {
            for(Budget_Solution__c b: lstBudgetSolution) {	
                String bgColor=null;
                boolean isDisable=null;
                boolean isDisableInput=null;
                boolean isDisableOutput=null;
                if(b.Budget__c == null) {
                	b.Budget__c = mobUserAssignment.User_Assigned_FF__c;
                }
                if(b.CTA_Cost_Model_Estimates__c == null) {
                	b.CTA_Cost_Model_Estimates__c = 0;
                }
                if(b.number__c==1 || b.number__c==14 || b.number__c==17) {
                    isDisableInput=false;
                    isDisableOutput=false;
                    bgColor='#4791FF';
                    b.CTA_Cost_Model_Estimates__c = null;
                    b.Budget__c  = null;
                }
                else if(b.number__c==13 || b.number__c==16 || b.number__c==22 || b.number__c==23 || b.number__c==25) {
                	b.Budget__c = null;
                    isDisableInput=false;
                    isDisableOutput=true;
                    bgColor='#EAEAEB';
                    b.Budget__c  = null;
                }
                else {
                    if(b.isSubmitted__c) { 
                        isDisableInput=false;
                        isDisableOutput=true;    
                    }
                    else {
                        isDisableInput=true;
                        isDisableOutput=false;
                    }
                }
                
                listOfBudgetSolution.add(new BudgetSolution(b, bgColor, isDisable, isDisableInput, isDisableOutput));
            } 
        }
        //For New Budget Tracker elements
        else if(lstBudgetSolution.size()>0) {
        	for(Budget_Solution__c b: lstBudgetSolution) {	
                String bgColor=null;
                boolean isDisable=null;
                boolean isDisableInput=null;
                boolean isDisableOutput=null;
                if(b.Budget__c == null) {
                	b.Budget__c = mobUserAssignment.User_Assigned_FF__c;
                }
                if(b.CTA_Cost_Model_Estimates__c  == null) {
                	b.CTA_Cost_Model_Estimates__c = 0;
                }
                if(b.number__c==1 || b.number__c==6 || b.number__c==12 || b.number__c==19 || b.number__c== 25
                	 || b.number__c==31 || b.number__c==37 || b.number__c==40 || b.number__c==50 || b.number__c==53 || b.number__c==56) {
                    isDisableInput=false;
                    isDisableOutput=false;
                    bgColor='#4791FF';
                    b.CTA_Cost_Model_Estimates__c = null;
                    b.Budget__c  = null;
                }
                else if(b.number__c==5 || b.number__c==11 || b.number__c==18 || b.number__c==24 || b.number__c== 30 || b.number__c== 36 
                		|| b.number__c== 39 || b.number__c== 49 || b.number__c== 52 || b.number__c== 55 || b.number__c== 58 || b.number__c== 59) {
                    b.Budget__c = null;
                    isDisableInput=false;
                    isDisableOutput=true;
                    bgColor='#EAEAEB';
                    b.Budget__c  = null;
                }
                else {
                    if(b.isSubmitted__c) { 
                        isDisableInput=false;
                        isDisableOutput=true;    
                    }
                    else {
                        isDisableInput=true;
                        isDisableOutput=false;
                    }
                }
                
                listOfBudgetSolution.add(new BudgetSolution(b, bgColor, isDisable, isDisableInput, isDisableOutput));
            } 
        }
        return listOfBudgetSolution;
    }
    
    /******************************
    Method Name: saveBudgetSolution
    Description: Method to save All the Budget Solution Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void saveBudgetSolution()
    {
        try
        {
            upsert lstBudgetSolution;
            sumOfModelEstimates();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Budget Solution saved successfully!'));
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
            return;
        }
        return;
    }
    
    
    /******************************
    Method Name: CancelBudgetSolution
    Description: Method to Cancel All the Budget Solution Records.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void CancelBudgetSolution()
    {
        lstBudgetSolution=[Select id, name, Budget__c, CTA_Cost_Model_Estimates__c, Notes__c,Wave_Plan_Version__c, number__c, isSubmitted__c 
                            from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
        return;
    }

    /******************************
    Method Name: sumOfModelEstimates
    Description: Method to Calculate Model Estimates.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void sumOfModelEstimates()
    {
        try
        {
            if(lstBudgetSolution.size()>0)
            {
            	List<Budget_Solution__c> tempBudgetSol=new List<Budget_Solution__c>();
            	if(lstBudgetSolution.size() == 25) {
	                Decimal totalPeopleCost=0;
	                Decimal totalPeopleExpense=0;
	                Decimal totalDNP=0;
	                Decimal totalMobCost=0;
	                
	                Decimal totalPeopleForModelEstimates=0;
	                Decimal totalPeopleExpenseForModelEstimates=0;
	                Decimal totalDNPForModelEstimates=0;
	                Decimal totalMobCostForModelEstimates=0;
	                
	                for(Budget_Solution__c b: lstBudgetSolution)
	                {
	                    if(b.CTA_Cost_Model_Estimates__c!=null && (b.number__c==2 || b.number__c==3 || b.number__c==4 || b.number__c==5 || b.number__c==6 || b.number__c==7 || b.number__c==8 || b.number__c==9 || b.number__c==10 || b.number__c==11 || b.number__c==12))
	                    {
	                        totalPeopleForModelEstimates= totalPeopleForModelEstimates + b.CTA_Cost_Model_Estimates__c;
	                    }
	                    if(b.number__c==13)
	                    {
	                        b.CTA_Cost_Model_Estimates__c= totalPeopleForModelEstimates;
	                        totalPeopleExpenseForModelEstimates= totalPeopleExpenseForModelEstimates + totalPeopleForModelEstimates;   
	                    }
	                    if(b.CTA_Cost_Model_Estimates__c!=null && (b.number__c==15))
	                    {
	                        totalPeopleExpenseForModelEstimates = totalPeopleExpenseForModelEstimates + b.CTA_Cost_Model_Estimates__c;
	                    }
	                    if(b.number__c==16)
	                    {
	                        b.CTA_Cost_Model_Estimates__c= totalPeopleExpenseForModelEstimates;  
	                    }
	                    if(b.CTA_Cost_Model_Estimates__c!=null && (b.number__c==18 || b.number__c==19 || b.number__c==20 || b.number__c==21))
	                    {
	                        totalDNPForModelEstimates = totalDNPForModelEstimates +  b.CTA_Cost_Model_Estimates__c;
	                    }
	                    if(b.number__c==22)
	                    {
	                        b.CTA_Cost_Model_Estimates__c= totalDNPForModelEstimates;   
	                        totalMobCostForModelEstimates = totalMobCostForModelEstimates + totalPeopleExpenseForModelEstimates + totalDNPForModelEstimates;
	                    }
	                    if(b.number__c==23)
	                    {
	                        b.CTA_Cost_Model_Estimates__c= totalMobCostForModelEstimates;   
	                    }
	                    if(b.CTA_Cost_Model_Estimates__c!=null && b.number__c==24)
	                    {
	                        totalMobCostForModelEstimates = totalMobCostForModelEstimates +  b.CTA_Cost_Model_Estimates__c;
	                    }
	                    if(b.number__c==25)
	                    {
	                        b.CTA_Cost_Model_Estimates__c= totalMobCostForModelEstimates;    
	                    }
	                    tempBudgetSol.add(b);
	                }
            	}
            	else {
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
            		 for(Budget_Solution__c b: lstBudgetSolution) {
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  (b.number__c==2 || b.number__c==3 || b.number__c==4)) {
            		 		subTotalProgramManagement = subTotalProgramManagement + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c==5 ) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalProgramManagement;
            		 		TotalCost = TotalCost + subTotalProgramManagement;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  (b.number__c==7 || b.number__c==8 || b.number__c==9 || b.number__c==10)) {
            		 		subTotalEnablePeople = subTotalEnablePeople + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c==11 ) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalEnablePeople;
            		 		TotalCost = TotalCost + subTotalEnablePeople;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  (b.number__c==13 || b.number__c==14 || b.number__c==15 || b.number__c==16 || b.number__c==17)) {
            		 		subTotalKTCosts = subTotalKTCosts + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c==18 ) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalKTCosts;
            		 		TotalCost = TotalCost + subTotalKTCosts;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  (b.number__c==20 || b.number__c==21 || b.number__c==22 || b.number__c==23)) {
            		 		subTotalBPOTechnology = subTotalBPOTechnology + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c==24 ) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalBPOTechnology;
            		 		TotalCost = TotalCost + subTotalBPOTechnology;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  (b.number__c==26 || b.number__c==27 || b.number__c==28 || b.number__c==29)) {
            		 		subTotalBSS = subTotalBSS + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c== 30) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalBSS;
            		 		TotalCost = TotalCost + subTotalBSS;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  (b.number__c==32 || b.number__c==33 || b.number__c==34 || b.number__c==35)) {
            		 		subTotalDealPMO = subTotalDealPMO + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c== 36) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalDealPMO;
            		 		TotalCost = TotalCost + subTotalDealPMO;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  b.number__c==38) {
            		 		subTotalPreGoLiveCost = subTotalPreGoLiveCost + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c== 39) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalPreGoLiveCost;
            		 		TotalCost = TotalCost + subTotalPreGoLiveCost;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  (b.number__c== 41 || b.number__c==42 || b.number__c==43 || b.number__c==44 || 
            		 	 		b.number__c==45 || b.number__c==46 || b.number__c==47 || b.number__c==48)) {
            		 		subTotalClinetSpecificCost = subTotalClinetSpecificCost + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c== 49) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalClinetSpecificCost;
            		 		TotalCost = TotalCost + subTotalClinetSpecificCost;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  b.number__c==51) {
            		 		subTotalTransforamtion = subTotalTransforamtion + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c== 52) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalTransforamtion;
            		 		TotalCost = TotalCost + subTotalTransforamtion;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  b.number__c==54) {
            		 		subTotalOther = subTotalOther + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c== 55) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalOther;
            		 		TotalCost = TotalCost + subTotalOther;
            		 	}
            		 	if(b.CTA_Cost_Model_Estimates__c!=null &&  b.number__c==57) {
            		 		subTotalContingency = subTotalContingency + b.CTA_Cost_Model_Estimates__c;
            		 	}
            		 	if(b.number__c== 58) {
            		 		b.CTA_Cost_Model_Estimates__c = subTotalContingency;
            		 		TotalCost = TotalCost + subTotalContingency;
            		 	}
            		 	if(b.number__c== 59) {
            		 		b.CTA_Cost_Model_Estimates__c = TotalCost;
            		 	}
            		 }
            		
            	}
                upsert tempBudgetSol;
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
    Method Name: submitBudgetSolution
    Description: Method to submit the Budget Solution.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void submitBudgetSolution()
    {
        try
        {
            upsert lstBudgetSolution;
            sumOfModelEstimates();
            if(lstBudgetSolution.size()>0)
            {
                List<Budget_Solution__c> tempBudgetSol=new List<Budget_Solution__c>();
                for(Budget_Solution__c b: lstBudgetSolution)
                {
                    b.isSubmitted__c=true;
                    tempBudgetSol.add(b);
                }
                upsert tempBudgetSol;
                /*Decimal currentMonth=datetime.now().month();
                Decimal currentYear=datetime.now().year();
                Budget_Reforecast__c newBudgetReforecast;
                List<Budget_Reforecast__c> lstBudgetReforecast = new List<Budget_Reforecast__c>();
                for(Budget_Solution__c b : lstBudgetSolution)
                {
                    newBudgetReforecast = new Budget_Reforecast__c();
                    newBudgetReforecast.Budget_Solution__c=b.id;
                    newBudgetReforecast.Month_Name__c=currentMonth;
                    newBudgetReforecast.year__c=currentYear;
                    lstBudgetReforecast.add(newBudgetReforecast); 
                }
                upsert lstBudgetReforecast;*/
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Budget Solution submitted successfully!'));
                isSubmit=true;
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in submitting!'+ex));
            return;
        }
        return;
    }
}