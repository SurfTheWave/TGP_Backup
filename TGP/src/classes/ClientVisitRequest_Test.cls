@IsTest

public class ClientVisitRequest_Test {
    Static  Client_visit_request__c req1;
    private static Account acc;
    Static List<Client_visit_request__c> reqList=new List<Client_visit_request__c>();
    public static void setupdata(){
    
    
    acc=new Account(name='AccTest');
    insert acc;
    
       Email_Template__c emailTemplateRec = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_TEMPLATE,ID__c='00XE0000001CHQj');     
       insert emailTemplateRec;

       Email_Template__c emailTemplateRec2 = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_FEEDBACK_TEMPLATE,ID__c='00XE0000001CHQk');     
       insert emailTemplateRec2;
        
        //reqList.add(req1);
            }
     static testMethod void clientVisitRequestTest() {  
    setupdata();
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
    req1.Request_status__C='Completed' ;
    
    //ClientVisitRequest req=new ClientVisitRequest();
    Test.startTest();  
    //req.createClientVisitEvents(reqList);
    //req.updateClientVisitEvents(reqList);
    //req.deleteClientVisitEvents(reqList);
    insert req1;
    req1.Centre_to_be_visited__c='Mumbai';
    update req1;
    delete req1;
    Test.stopTest(); 
    
    
    
 }  
    static testMethod void clientVisitRequestTest1() {  
    setupdata();
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
    req1.Request_status__C='Completed' ;
    insert req1;
    //ClientVisitRequest req=new ClientVisitRequest();
    Test.startTest();  
    //req.createClientVisitEvents(reqList);
    //req.updateClientVisitEvents(reqList);
    //req.deleteClientVisitEvents(reqList);
    
    req1.Centre_to_be_visited__c='Mumbai';
    req1.Request_status__C='Open' ;
    update req1;
    delete req1;
    Test.stopTest(); 
    
    
    
 }

}