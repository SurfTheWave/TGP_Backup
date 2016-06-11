/*
Author : Malkeet Singh
Story  :   
Description : Test Class for Mob_CloneMECVersionAndQns. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class Mob_CloneMECVersionAndQnsTest{
static MEC_Post_Contract_Version__c  mec;
static MEC_Post_Contract_Questionnaire_Master__c mcq;

public static void setupData(){

///To create a MEC_Post_Contract_Version__c

 mec = new MEC_Post_Contract_Version__c ();

 mec.Version_Name__c= 'test';
 mec.Active__c = true;
 insert mec;
 
 //////To create a MEC_Post_Contract_Questionnaire_Master__c
 mcq= new MEC_Post_Contract_Questionnaire_Master__c();
 mcq.MEC_Post_Contract_Version__c=mec.id;
 mcq.Category_Name__c='test';
 mcq.Criteria__c='test';
 mcq.Is_Mandatory__c=false;
 insert mcq;
}
 
 
static testMethod void test()
{
test.starttest();
setupData();
Mob_CloneMECVersionAndQns.cloneMECVersionAndQns(mec.id);
test.stoptest();
  
}
}