@isTest

public Class ClientVisitFeedback_Test{
      
      Static  Client_visit_request__c req1;
      Static  Client_visit_feedback__c feedback1;
      Static List<Client_visit_feedback__c> feedList=new List<Client_visit_feedback__c>();
    private static Account acc;
    Static List<Client_visit_request__c> reqList=new List<Client_visit_request__c>();
    
    public static void setupdata(){
    
    
    acc=new Account(name='AccTest');
    insert acc;
    
       Email_Template__c emailTemplateRec = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_TEMPLATE,ID__c='00XE0000001CHQj');     
       insert emailTemplateRec;

       Email_Template__c emailTemplateRec2 = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_FEEDBACK_TEMPLATE,ID__c='00XE0000001CHQk');     
       insert emailTemplateRec2;
        
      Email_Template__c emailTemplateRec3 = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_FEEDBACK_UPDATE_TEMPLATE,ID__c='00XE0000001CHQl');          
      insert emailTemplateRec3;
     
       req1=new Client_visit_request__c();
       req1.Parent_Company__c=acc.id;
       req1.Support_Group__c='Pittsburgh';
       req1.Primary_Contact__c='Reena Thakre';
       req1.Visit_Category__c='Sales - Charge-back DC';
       req1.Feedback_Receipients__c='Reena Thakre';
       req1.WBS_Element_for_Showcase__c='123456';
       req1.Centre_to_be_visited__c='Bangalore';
      req1.Visit_Date_From__c=system.today();
      req1.Visit_Date_To__c=system.today();
       insert req1;
    
            }
       
    
 static testMethod void clientVisitfeedbackTest() {
    setupdata();
    ClientVisitfeedback fb=new ClientVisitfeedback();
    feedback1=new Client_visit_feedback__c();
    feedback1.Client_Visit_Request__c=req1.id;
       
    Test.startTest();  
    insert feedback1;
    Test.stopTest();
}
}