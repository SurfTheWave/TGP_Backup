/************
@author : ezdhan hussain
@test class for batch_utilizationNew_test
**************/
@istest
private class Batch_utilizationNew_test {

    static testMethod void check_positive(){
        User useObj1 = UtilNovaUnitTest.getUser1();
		insert useObj1;
        User_Master__c userObj1 = new User_Master__c(Name = 'SolTestUser',User__c = useObj1.id,email__c=useObj1.email);
    	insert userObj1;
        Opportunity opp =UTIL_TestDataCreationForMobClasses.getOpportunity();
        utilizations__c util = new utilizations__c();
        util.Name = Opp.name+userObj1.name;
        util.Opportunity__c = opp.id;
        util.User__c = userObj1.id;
        util.Active__c = true;
        insert util;
        Test.startTest();
    	String q = 'SELECT Id, Name, User__c, Opportunity__c, User_Role_s__c, Current_Week__c, Current_Week_1__c, '+
        'Current_Week_2__c, Current_Week_3__c, Current_Week_4__c, Comments__c,'+
        ' Client_Name__c, Active__c FROM Utilizations__c where id=\''+util.id+'\'';
    Batch_UtilizationNew CheckBatch = new Batch_UtilizationNew(q);
    ID batchprocessid = Database.executeBatch(CheckBatch);
    }
}