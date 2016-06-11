/******************
 * @class name : BudgetCostExport
  
 * @Description : 
******************/
public class BudgetCostExport{

Mobilization_Plan__c mPlan ;
/***************
 * @method :BudgetCostExport
 * @description : Initilization taking place 
***************/  
    public BudgetCostExport(ApexPages.StandardController controller) {
            mPlan = (Mobilization_Plan__c )controller.getRecord();
    }

/***************
 * @method :getExcel
 * @returntype : pageReference
***************/
 public  pageReference getExcel() {
     String mobPlanId = ApexPages.currentPage().getParameters().get(UtilConstants.id_par);
     List<Attachment> atchBdgt = new List<Attachment>();
     atchBdgt = [SELECT Id, Name, parentId FROM Attachment WHERE parentId =:mPlan.Id LIMIT 1];
     if(atchBdgt.size() > 0){
         PageReference ReturnPage = new PageReference(UtilConstants.VFP_SERVLET_URL+atchBdgt[0].id );
         //System.debug('Pagee ' + returnPage);
         ReturnPage.setRedirect(true);
         return ReturnPage; 
     }
     else {
     
     PageReference ReturnPage = new PageReference(UtilConstants.SLASH+mPlan.Id);
     //System.debug('Pagee ' + returnPage);
     ReturnPage.setRedirect(true);
     return ReturnPage; 
     }
 }

}