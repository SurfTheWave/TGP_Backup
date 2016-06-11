/**
    @Author Yasin
    @name ExportHiringStatus_VFP 
    @CreateDate 02/1/2016
    @Description Upload and Update Hiring status excel sheet.
    @Version <3.5>
    @reference Visualforce page: ExportHiringStatus_VFP
*/

public class ExportHiringStatus{

Wave__c wave ;
/***************
 * @method :ExportHiringStatus
 * @description : Initilization taking place 
***************/  
    public ExportHiringStatus(ApexPages.StandardController controller) {
            wave = (Wave__c )controller.getRecord();
    }

/***************
 * @method :getExcel
 * @returntype : pageReference
***************/
 public  pageReference getExcel() {
     String mobPlanId = ApexPages.currentPage().getParameters().get(UtilConstants.id_par);
     List<Attachment> atchBdgt = new List<Attachment>();
     atchBdgt = [SELECT Id, Name, parentId,createdDate FROM Attachment WHERE parentId =:wave.Id AND name = 'HiringStatus_File.xls.xlsm' order by createdDate desc LIMIT 1];
     if(atchBdgt.size() > 0){
         PageReference ReturnPage = new PageReference(UtilConstants.VFP_SERVLET_URL+atchBdgt[0].id );
         ReturnPage.setRedirect(true);
         return ReturnPage; 
     }
     else {  
     PageReference ReturnPage = new PageReference(UtilConstants.SLASH+wave.Id);
     ReturnPage.setRedirect(true);
     return ReturnPage; 
     }
 }
}