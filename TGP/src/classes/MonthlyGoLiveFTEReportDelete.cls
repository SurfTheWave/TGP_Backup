Global class MonthlyGoLiveFTEReportDelete implements Database.Batchable <sObject> {
	global MonthlyGoLiveFTEReportDelete() {}
    global database.QueryLocator start(Database.BatchableContext BC) {
        String query;
        query = 'SELECT Id, CreatedDate FROM Monthly_Go_Live_FTE_Report__c where CreatedDate!= today';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Monthly_Go_Live_FTE_Report__c> MGLFTEDetail) {
        try {
                Delete MGLFTEDetail;
        }
        catch(Exception E) {
            System.debug('Exception:  '+E);
        }
    }
    global void finish(Database.BatchableContext BC) {}
}