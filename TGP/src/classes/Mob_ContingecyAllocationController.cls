/*
Author : Varsha Chougle
Story  : Story-0299/MOB_159
Description :Contingency Management tab.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class Mob_ContingecyAllocationController {

    public string waveId{get;set;}
    public List<Budget_Solution__c> lstBudgetSolution{get;set;}
    public List<Wave_Plan_Version__c> lstWavePlanVersion{get;set;}
    public Wave_Plan_Version__c strWavePlanVersion{get;set;}
    public Decimal sumOfChangeOrder{get;set;}
    public Decimal sumOfCostOverrun{get;set;}
    public Decimal totalCostAboveBudge{get;set;}
    public String Option{get;set;}
    public boolean isDisplay{get;set;}
    public boolean isFinalSubmit{get;set;}
    
    /******************************
    Method Name: Mob_ContingecyAllocationController
    Description: This is Constructor for the Mob_ContingecyAllocationController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public Mob_ContingecyAllocationController(ApexPages.StandardController controller) 
    {

        strWavePlanVersion=new Wave_Plan_Version__c ();
        //Wave plan version Id
        waveId=ApexPages.CurrentPage().getParameters().get('id');
        
        //List of Budget Solution
        lstBudgetSolution=[select isSubmittedToGovernanceLead__c , GovernanceLeadSecondaryTaskId__c, Submitted_by_Governance_Lead__c
                             from Budget_Solution__c where Wave_Plan_Version__c=: waveId order by Number__c];
                            
        if(lstBudgetSolution.size()>0)
        {
            isFinalSubmit=lstBudgetSolution[0].Submitted_by_Governance_Lead__c;
        }                 
        
        //List of wave plan varsion                     
        lstWavePlanVersion=[select Change_Order__c, Cost_Overrun__c, Total_Cost_Above_Budget__c, Contingency_Amount__c,Contingency_status__c from Wave_Plan_Version__c where id=:waveId];
        if(lstWavePlanVersion.size()==1)
        {
            strWavePlanVersion=lstWavePlanVersion[0];
            sumOfChangeOrder=lstWavePlanVersion[0].Change_Order__c;
            sumOfCostOverrun=lstWavePlanVersion[0].Cost_Overrun__c; 
            totalCostAboveBudge=lstWavePlanVersion[0].Total_Cost_Above_Budget__c;
            option= lstWavePlanVersion[0].Contingency_status__c; 
            if(option=='Allocate to Contingency Partially')
            {
                PartialFunc();
            }
        }
    }
    
    /******************************
    Method Name: getItems
    Description: This method is used to set radio buttons values 
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Allocate to Contingency 100%','Allocate to Contingency 100%')); 
        options.add(new SelectOption('Allocate to Contingency Partially','Allocate to Contingency Partially')); 
        return options; 
    }
    
    /******************************
    Method Name: PartialFunc
    Description: when  'Allocate to Contingency Partially' is selected
    Paramenters: NA
    Return Value: void
    *******************************/
    public void PartialFunc()
    {
        isDisplay=true;
    }
    
    /******************************
    Method Name: NoPartialFunc
    Description: when  ' Allocate to Contingency 100%' is selected
    Paramenters: NA
    Return Value: void
    *******************************/
    public void NoPartialFunc()
    {
        isDisplay=false;
    }

    /******************************
    Method Name: submitData
    Description: Method to submit Contingecy Allocation
    Paramenters: NA
    Return Value: void
    *******************************/
    public void submitData()
    {
        try
        {
            if(option==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select one Option!'));
                return;
            }
            if(option=='Allocate to Contingency Partially')
            {
                if(strWavePlanVersion.Contingency_Amount__c == null)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please insert Contingency Amount!'));
                    return;
                }
                if(strWavePlanVersion.Contingency_Amount__c >= sumOfCostOverrun)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contingency Amount must be less than cost overrun!'));
                    return;
                }
            }
            if(lstBudgetSolution.size()>0)
            {
                List<Budget_Solution__c> listBudgetSolution =new List<Budget_Solution__c>();
                for(Budget_Solution__c b: lstBudgetSolution)
                {
                    b.Submitted_by_Governance_Lead__c=true;
                    listBudgetSolution.add(b);
                }
                upsert listBudgetSolution;
                List<String> lstOfId= new List<String>();
                for(Budget_Solution__c b: lstBudgetSolution)
                {
                    if(b.GovernanceLeadPrimaryTaskId__c != null)
                    lstOfId.add(b.GovernanceLeadPrimaryTaskId__c);
                    if(b.GovernanceLeadSecondaryTaskId__c!= null)
                    lstOfId.add(b.GovernanceLeadSecondaryTaskId__c);
                }
                List<Task> lstTask=[select id from Task where id IN : lstOfId];
                if(lstTask.size()>0)
                {
                    delete lstTask;
                }
            }
            strWavePlanVersion.Contingency_status__c=option;
            if(option=='Allocate to Contingency 100%')
            {
                strWavePlanVersion.Contingency_Amount__c=0;
            }
            upsert strWavePlanVersion;
            isFinalSubmit=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Contingency Management submitted successfully!'));
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in submitting!'+ex));
            return;
        }
        return;
    }
}