public class fetchApprovalMatrix {
    private ApexPages.StandardSetController approvalMatrix;
    public ApexPages.StandardSetController approvalMatrix11{
        get{
            if(approvalMatrix11 == null) {
                approvalMatrix11 = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT name, TCV_Range__c, Region__c, Approver_Mail_ID__c, Comments__c, IS_SFDC_User__c, LastModifiedDate FROM Approver_Master__c ORDER By LastModifiedDate Desc LIMIT 5 ]));
            }
            return approvalMatrix11;
        }
        set;
    }
    public fetchApprovalMatrix(ApexPages.StandardSetController stdController){
        this.approvalMatrix = stdController;
    }
    public List<Approver_Master__c> getApprovalMatrixRecord(){
        //approvalMatrix = [SELECT name, TCV_Range__c, Region__c, Approver_Mail_ID__c, Comments__c, IS_SFDC_User__c, LastModifiedDate FROM Approver_Master__c ORDER By LastModifiedDate Desc LIMIT 5 ];
        return (List<Approver_Master__c>)approvalMatrix11.getRecords();
    }
}