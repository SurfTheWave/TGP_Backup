@isTest
/*
@name : UtilEmail_Test
@Description : 
@Version : 
*/
private class  UtilEmail_Test{
/*
@name : myUnitTest
@Description : 
@Version : 
*/
static testMethod void myUnitTest() {
Test.startTest();  
 String s=UtilEmail.emailid();
String s1=UtilEmail.emailidForIO('BPO');
String s2=UtilEmail.emailidForIO('IC');
String s3=UtilEmail.emailidForIO('IO');
 Test.stopTest();
 }
}