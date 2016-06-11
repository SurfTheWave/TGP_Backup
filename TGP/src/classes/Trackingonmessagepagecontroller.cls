public with sharing class Trackingonmessagepagecontroller {

   

    
    public List<Wave_Plan_Version__c> waveplanlist{get;set;}
    public Boolean messageDisplay{get;set;}
    public String wavePlanVersionId{get;set;}
     
    
       public Trackingonmessagepagecontroller(ApexPages.StandardController controller) 

      {
           wavePlanVersionId=ApexPages.CurrentPage().getParameters().get('id');
           
           waveplanlist=[select id,Display_tracking_message__c from Wave_Plan_Version__c where id=:wavePlanVersionId];
           
           if(waveplanlist[0].Display_tracking_message__c == 'Tracking is On')
           {
              messageDisplay=true; 
           }
           
      }
}