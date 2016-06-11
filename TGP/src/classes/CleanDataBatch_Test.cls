/* Author     : madhusudhan
 * Date       :11-Nov-2015
 * version    : 1
 * Class Name :CleanDataBatch_Test
*/
@IsTest
public class CleanDataBatch_Test {
    static testmethod void test1() {
        Test.startTest();
         //Test Data for Batch
        Operating_Groups_Master__c oppOperatingGrup = UnitTestDatafactory.createOperatingGroup('India');
        Opportunity opp= UTIL_DataCreationForTestClass.getOpportunity(oppOperatingGrup);
        insert(opp);
        Offering_Master__c offMaster=UTIL_DataCreationForTestClass.getOfferingwithProcurement();
        insert offMaster;
        Offering_Name__c offCustomObj =UTIL_DataCreationForTestClass.getOfferingNamewithProcurement(offMaster);
        insert(offCustomObj);
        Solution_Scope__c solComp = UTIL_DataCreationForTestClass.getSolutionComp(opp,offMaster);
        insert(solComp);
        Services_Master__c serMaster= UTIL_DataCreationForTestClass.getServiceMasterWithoutALL(offMaster);
        insert(serMaster); 
        Service__c servObj = new Service__c(Solutionscope__c = solComp.id,services__c=serMaster.id);
        insert(servObj);
        Costing_Request__c costReq=new Costing_Request__c(Opportunity__c=opp.id,In_Progress__c='2',Data_Cleaning_dev__c=True);
        insert costReq;
        fte_details__c fte=new fte_details__c(name='test fte',Is_Transient__c=True,Costing_Request__c=costReq.id,Service__c=servObj.id);
        insert fte;
        Other_Cost_Details__c otherCost=new Other_Cost_Details__c(name='test fte',Is_Transient__c=True,Costing_Request__c=costReq.id,Service__c=servObj.id);
        insert otherCost;
        Payroll__c payRoll=new Payroll__c(name='Test payroll',Is_Transient__c=True,Costing_Request__c=costReq.id,Service__c=servObj.id);
        
        DateTime dt = System.now().addMinutes(-60);
        String FteQuery='select id from fte_details__c where Is_Transient__c=True and Costing_Request__r.In_Progress__c=\'2\' and Costing_Request__r.Data_Cleaning_dev__c=True and Costing_Request__r.Time_Interval__c<=:dt';
        string obj='fte_details__c';
        CleanDataBatch cleanBatch=new CleanDataBatch(FteQuery,obj,dt);
        //cleanBatch.cleanBatch(FteQuery,obj,dt);
        ID batchprocessid = Database.executeBatch(cleanBatch,200);     
        
        Test.stopTest();
        }
        static testmethod void testCleaningDataScheduler() {
         Test.startTest();  
            String hour = String.valueOf(Datetime.now().hour());
            String min = String.valueOf(Datetime.now().minute()+1); 
            String ss = String.valueOf(Datetime.now().second());
            //parse to cron expression
            String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
            CleaningDataScheduler s = new CleaningDataScheduler(); 
            System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s); 
        Test.stopTest();    
        }
    }