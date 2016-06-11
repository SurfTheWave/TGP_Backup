/*
 * @Author: Reena Thakre
 * @CreatedDate: 22 Jan 2015
 * @Description: This Schedulable class created to Schedulable class to schedule 
                 Batch_SendEmailFor24HoursSchedule batch apex and to send bulk mails. 
 * @Version :            
 */

global class Sch_SendEmailForGovernanceLeadScheduler implements Schedulable {
    /*
     * @Author: Reena Thakre
     * @CreatedDate: 22 Jan 2015
     * @Description: Query string
     * @Version :            
     */
    private static final String Unqualified='Unqualified';
    private static final String Pipeline='Pipeline';
    private static final String QUERY =
        'select id,Opportunity__r.name,SD_Gov_Lead_Coach__c,lastmodifieddate,Opportunity__r.SAP_OM_ID__c, Opportunity__r.Account.name,' +
        ' Offerings_Scope_SWB__c,Opportunity_Solution_Lead__c ' +
        ' from Sd_Governance_Data__c where lastmodifieddate <= N_Days_AGO:7 AND (Opportunity__r.Reporting_Status__c= \''+Unqualified+'\''+
' OR Opportunity__r.Reporting_Status__c=\''+Pipeline+'\''+') AND Opportunity__r.On_Hold__c = false'; //today()'; N_Days_AGO:7'
    //system.debug('QUERY+++++'+QUERY);
    /*
     * @Author: Reena Thakre
     * @CreatedDate: 22 Jan 2015
     * @Description: Initializing the batch process   
     * @Version :            
     */
    global void execute(SchedulableContext sc) {

        system.debug('-----query123---'+QUERY);

        Database.executeBatch(new BatchApexGovernanceLead(QUERY), 10);
    }
}