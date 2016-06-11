/******************************
   @Author       : 
   @Class name   : UtilUser_Test
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
@isTest
private class UtilUser_Test{
     /******************************
     * Method Name: UtilUserTest
     * Description: test data setup for util user functionality testing
     * Paramenters: 
     * Return Value: 
     *******************************/
    private static testMethod void UtilUserTest(){
        Id I = UserInfo.getUserId();
        List<User_Master__c> UserMaster = new List<User_Master__c>();
        List<String> Str1 =new List<String>();

        User useObj = UtilNovaUnitTest.getUser();

        User_Master__c userObj = new User_Master__c(Name = 'TestUser',User__c = useObj.id);
        Database.insert(userObj);  

        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        User_Master__c um =new User_Master__c();
        Map<ID,ID> m1=new Map<ID,ID>(); 
        um.OwnerId=I;
        um.user__c=I;
        um.email__c='vc12@testorg.com';
        UserMaster.add(um);

        insert UserMaster;

        m1.put(userObj.id,UserMaster[0].Id);
        Map<ID,ID> m2=new Map<ID,ID>(); 
        m2.put(ogm.id, userObj.id);//passing invalid id in map for covering catch block
        Test.startTest();  
        set<ID> lstID = new set<ID>();
        UtilUser newUtiuser= new UtilUser();
        string str = String.valueOf(UserMaster[0].Id);
        UtilUser.utilUser(str);
        UtilUser.getUserEmail(str);
        UtilUser.utilUserMap(m1);

        // UtilUser.utilUser('XYz');
        //UtilUser.getUserEmail('XYZ');
        //UtilUser.utilUserMap(m2);

        Test.stopTest();
    }
}