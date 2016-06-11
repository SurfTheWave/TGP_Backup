/******************************
   @Author       : 
   @Class name   : UTIL_SendEmailForGovernanceLead_Test
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
@isTest
private class UTIL_SendEmailForGovernanceLead_Test{
      /******************************
     * Method Name: UTIL_SendEmailForGovernanceLeadTest
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/
static testMethod void UTIL_SendEmailForGovernanceLeadTest(){
         Id Id = UserInfo.getUserId();
         
        Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
        String aliasString = 'alig';
        User userObj = new User(Alias =aliasString, 
        email= aliasString+'@accenture.com',
        emailencodingkey='UTF-8',
        lastname='Testing', 
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = sysAdminId,
        timezonesidkey='Europe/London',
        username= aliasString+'@accenture.com');
        
        insert userObj;
        
        User_master__c um = new User_master__c();
        um.Name='Test User Master';
        um.email__c=userObj.email;
        um.user__c=um.id;
        
          insert um;
         
         List<datetime> date1 = new List<datetime>();
         List<String> s1=new List<String>();
         s1.add(um.Name);
         
         //String str1 =[Select Name from User_Master__c limit 1].Name;
         
         List <String>s2=new List<String>();
         s2.add(um.email__c);
         
           //String str2 =[Select email__c from User_Master__c limit 1].email__c ;
         
         String s3;
         String s4;
         
         Map<String,String> mapstring= new Map<String, String>(); 
         
        OrgWideEmailAddress owa = new OrgWideEmailAddress();
        //List<Messaging.SingleEmailMessage> emailMsgList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
        //mail.setOrgWideEmailAddressId(owa.id); 
           
              
        
        Account acc;
            acc = new account();
            acc.name = 'Test Client';
        insert acc;
        
        Operating_Groups_Master__c ogm;
            ogm= new Operating_Groups_Master__c();
            ogm.Name='OGM Test';
        insert ogm;
        
        
        List<Opportunity> Opplist =new List<Opportunity>();
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Testing';
        opp.accountid = acc.id;
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.SAP_OM_ID__c='SAP123TEST';
        opp.Off__c='Test123';
        opp.CloseDate = System.today();
        opp.Active__c = true ;
        Opplist.add(opp);
        
        insert Opplist;
        
        List<SD_Governance_Data__c> sdclist= new List<SD_Governance_Data__c>();
        SD_Governance_Data__c sdc =new SD_Governance_Data__c();
        sdc.Opportunity__c=opp.id;
        sdc.Name='Testing';
        //sdc.Opportunity__c=opp.Name;
        sdc.SD_Gov_Lead_Coach__c='Testing text fields';
        sdclist.add(sdc);
        insert sdclist;
        
        s1.add(sdc.SD_Gov_Lead_Coach__c);
        s2.add(sdc.Opportunity__r.name);
        s3 = sdc.Opportunity__r.SAP_OM_ID__c;
        s4 = sdc.Opportunity__r.Off__c;
        
        DateTime dateref = System.now(); 
        Date DatetimeValue= date.newinstance(dateref.year(), dateref.month(), dateref.day());

        date1.add(DatetimeValue);
        //mapstring.set(str1);
        //mapstring.set(str2);
        
        
        
        //insert mapstring;
        
        Test.startTest();  
        
        UTIL_SendEmailForGovernanceLead usegl=new  UTIL_SendEmailForGovernanceLead();
        usegl.sendEmailTOGovernanceLead(sdclist);
        
        Test.stopTest();  
    }

}