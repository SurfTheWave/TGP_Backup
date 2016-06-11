/*
Author : Mayank Tayal
Story  :   SOL_077
Description :As a PMO, I should be able to schedule approval meeting on a shared calendar 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public class deleteEventController {
    
    public String meetingId{get;set;}
    public String calendarEventId{get;set;}
    public String strUrl{get;set;}
    public Boolean chkOperationUser{get;set;}
    public Boolean showFormMsg{get;set;}
    public Boolean showForm{get;set;}
    
    /******************************
    Method Name: CreateNewCalendarEventPageController
    Description: Controller for initializing
    Paramenters: NA
    Return Value: void
    *******************************/
    public deleteEventController(ApexPages.StandardController controller) {
        strUrl = URL.getSalesforceBaseUrl().toExternalForm();
        calendarEventId=ApexPages.CurrentPage().getParameters().get('id');
        if(calendarEventId!=null)
        {
            List<Event> eventExist=[select id, Meeting_Record_ID__c, Meeting_ID__c from Event where id=:calendarEventId];
            if(eventExist!=null && eventExist.size()>0)
            {
                meetingId=eventExist[0].Meeting_Record_ID__c;
            }
        } 
        //showFormMsg=true;      
    }
    
    /******************************
    Method Name: checkOperations
    Description: Method to check the Operations Role of User
    Paramenters: NA
    Return Value: void
    *******************************/
    public void checkOperations()
    {
        //UAM Code--Mayank Tayal-Sol_148        
       /* UAM Sol RV List<userRole> role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if((role[0].name!=null && (!role[0].name.equalsIgnoreCase('Operations'))) && (!userProfileName.equalsIgnoreCase('Workbench Administrator')))
        {
            showFormMsg=true;
            showForm=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have the level of access necessary to perform the operation you requested. '));             
            chkOperationUser= false;            
        }
        else
        {
            showFormMsg=false;
            showForm=true;
            chkOperationUser= true;
        } */     
        
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if(!userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) && !userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN))
        {
            showFormMsg=true;
            showForm=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have the level of access necessary to perform the operation you requested. '));             
            chkOperationUser= false;            
        }
        else
        {
            showFormMsg=false;
            showForm=true;
            chkOperationUser= true;
        } 
    }
    
    /******************************
    Method Name: deleteEvent
    Description: Method to delete the events
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deleteEvent()
    {       
        try
        {
            List<Calendar_Event__c> calEvent=[select id, name from Calendar_Event__c where Review_Meeting_Request__c=:meetingId];
            if(calEvent!=null && calEvent.size()>0)
            {
                for(Calendar_Event__c cal: calEvent)
                {
                    delete cal;
                }
            }
            List<Event> eventLst=[select id, Meeting_Record_ID__c from Event where Meeting_Record_ID__c=:meetingId];
            if(eventLst!=null && eventLst.size()>0)
            {
                for(Event eve: eventLst)
                {
                    delete eve;
                }
            }
            List<Review_Meeting_Request__c> reqMeetingList=[select id,name, Status__c, Review_Process__c from Review_Meeting_Request__c where id=:meetingId];
            if(reqMeetingList!=null && reqMeetingList.size()>0)
            {
                reqMeetingList[0].Status__c='Cancelled';
                upsert reqMeetingList[0];
                List<Review_Process__c> revProcList=[select id, name, Review_Date__c from Review_Process__c where id=:reqMeetingList[0].Review_Process__c];
                if(revProcList!=null && revProcList.size()>0)
                {
                    List<Review_Meeting_Request__c> meetLists=[select id,name, Status__c, Review_Process__c from Review_Meeting_Request__c where Review_Process__c=:revProcList[0].id and Status__c=:'Scheduled' order by LastModifiedDate desc];
                    if(meetLists!=null && meetLists.size()>0)
                    {
                        List<Calendar_Event__c> calEventLst=[select id, name, Review_Meeting_Request__c, Start_Date__c from Calendar_Event__c where Review_Meeting_Request__c=:meetLists[0].id];
                        if(calEventLst!=null && calEventLst.size()>0)
                            revProcList[0].Review_Date__c=calEventLst[0].Start_Date__c;
                    }
                    else
                    {
                        revProcList[0].Review_Date__c=null;
                    }
                    upsert revProcList[0];
                }
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error in Deleting!'));      
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Event Deleted Successfully!'));        
    }
    
    /******************************
    Method Name: refreshMsg
    Description: Method to Refresh the Page
    Paramenters: NA
    Return Value: void
    *******************************/
    public void refreshMsg()
    {
        showFormMsg=true;
        showForm=false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have the level of access necessary to perform the operation you requested. '));         
    }
}