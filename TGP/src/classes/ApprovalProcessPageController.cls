/*
Author : Mayank Tayal
Story  :   SOL_082
Description :Under View Submitted Meetings Tab under Approval Tab, default list of all the submitted meetings is displayed with button to see the previously scheduled meeting logs.
Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013          Sol UAM-Release 2
Mayank Tayal    SOL_154                    21 May 2013        Change in Flow for Meeting Request & Scheduling Call

*/
public class ApprovalProcessPageController {

    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    public List<Review_Meeting_Request__c> meetingsList{get;set;}
    public List<Review_Meeting_Request__c> scheduledMeetingsList{get;set;}
    public List<Review_Meeting_Request__c> deferredMeetingsList{get;set;}
    public Boolean schMeetingDisplay{get;set;}
    public Boolean defMeetingDisplay{get;set;}
    public Boolean archiveDisplay{get;set;}
    public String meetingID;
    public String selectedTab{get;set;}
    public Boolean showCal{get;set;}
    public String tabValue{get;set;}
    public Boolean addButtonRender{get;set;}
    public Boolean deferredDisplay{get;set;}
    public String calendarId{get;set;}
    public String RunningUser {get; set;}
    public String userProfileName {get;set;}
    public Boolean isAcccessOppCalList{get;set;}
    Set<Id> meetingOppId =new Set<Id>();
    
    /******************************
    Method Name: ApprovalProcessPageController
    Description: Controller for initializing
    Paramenters: NA
    Return Value: void
    *******************************/
    public ApprovalProcessPageController()
    {
        isAcccessOppCalList=false;
        RunningUser=UserInfo.getUserId();
        Set<Id> oppId =new Set<Id>();
        
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        
        if(userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
            addButtonRender=true;
        }
        
        List<Review_Meeting_Request__c> reviewMetLiat=[select id,BPO_Opportunity__c from Review_Meeting_Request__c where Status__c=:'Submitted'];
                           
        for(Review_Meeting_Request__c oppList : reviewMetLiat)
        {
            oppId.add(oppList.BPO_Opportunity__c);
        }
        
        List<Opportunity_Offering__c> offeringList =[select id,name,Opportunity_TGP__c from Opportunity_Offering__c where Opportunity_TGP__c =:oppId and 
                                 (Functional_Architect_Mobilization_New__r.SFDC_User__c=:RunningUser OR
                                 Solution_Lead_New__r.SFDC_User__c=: RunningUser OR 
                                 Offering_Solution_Lead_Secondary_New__r.SFDC_User__c=:RunningUser OR
                                 Solution_Specialist_New__r.SFDC_User__c=: RunningUser OR 
                                 Technical_Architect_New__r.SFDC_User__c=: RunningUser OR
                                 Opportunity_TGP__r.Complex_Cost_Architect_New__r.SFDC_User__c=: RunningUser OR
                                 Opportunity_TGP__r.Enterprise_Solution_Architect_New__r.SFDC_User__c=: RunningUser OR
                                 Opportunity_TGP__r.BSS_Operation_New__r.SFDC_User__c=: RunningUser)];
                                 
        for(Opportunity_Offering__c metOppList : offeringList)
        {
            meetingOppId.add(metOppList.Opportunity_TGP__c);
        }            
        if(userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN)){
            
            isAcccessOppCalList=true;
        }
        
        List<ID_for_Calendar__c> lstIdForCal =[select id, name, Calendar_Id__c from ID_for_Calendar__c];
        if(lstIdForCal.size()>0)
        {
            calendarId=lstIdForCal[0].Calendar_Id__c;
        }
        showMainMsg=false;
        showForm=true;
        initializeSubmittedMeetings();
        archiveDisplay=true;
        deferredDisplay=true;
        schMeetingDisplay=true;
        tabValue=ApexPages.CurrentPage().getParameters().get('tabValue');
        if(tabValue!=null)
            selectedTab=tabValue;
        else
            selectedTab='tab1';
        showCal=true;
        /* UAm SOl RV List<userRole> role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];        
        if(role.size()>0)
        {
            if(role[0].name!=null && role[0].name.equalsIgnoreCase('Operations'))
            {
               addButtonRender=true;                            
            }
        }
        //Hareesh -- CRUD to Workbench SysAdmin
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if(userProfileName.equalsIgnoreCase('Workbench Administrator')) {
            addButtonRender=true;
        }*/
        
    }   
    
    /******************************
    Method Name: getMeetingID
    Description: Getting the Meeting ID value
    Paramenters: NA
    Return Value: void
    *******************************/
    public String getMeetingID(){
        return meetingID;
    }
    
    /******************************
    Method Name: setMeetingID
    Description: Setting the Meeting ID value
    Paramenters: NA
    Return Value: void
    *******************************/
    public void setMeetingID(String meetingID){
        this.meetingID= meetingID;
    }
    
    /******************************
    Method Name: initializeSubmittedMeetings
    Description: Method to get all the Submitted Meeting requests
    Paramenters: NA
    Return Value: PageReference 
    *******************************/
    public void initializeSubmittedMeetings()
    {                    
        if(isAcccessOppCalList ==  true){
            meetingsList=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, Opportunity_ID__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Operating_Group__c, Client_Geo_Unit__c, 
                                Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name,BPO_Opportunity__c from Review_Meeting_Request__c where Status__c=:'Submitted' order by createddate desc]; 
                             
        }else{
            meetingsList=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, Opportunity_ID__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Operating_Group__c, Client_Geo_Unit__c, 
                                Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name,BPO_Opportunity__c from Review_Meeting_Request__c where Status__c=:'Submitted' and BPO_Opportunity__c IN : meetingOppId order by createddate desc];
        }     
        
    }
    
    /******************************
    Method Name: redirectToDownload
    Description: Method to redirect to Page to download Salesforce Outlook Integration Setup
    Paramenters: NA
    Return Value: PageReference 
    *******************************/
    public PageReference redirectToDownload()
    {
        PageReference pg=new PageReference('/setup/crmforoutlook/crmforoutlooksetup.apexp?retURL=%2Fui%2Fsetup%2FSetup%3Fsetupid%3DDesktopIntegration&setupid=OutlookEdition');
        pg.setRedirect(true);
        return pg;
    }
    
    /******************************
    Method Name: scheduledMeetingList
    Description: Method to display scheduled Meeting List
    Paramenters: NA
    Return Value: void
    *******************************/
    public void scheduledMeetingList()
    {
        if(isAcccessOppCalList ==  true){
            scheduledMeetingsList=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                        Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, Opportunity_ID__c, TCV_M__c, Operating_Group__c, Client_Geo_Unit__c, 
                        Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name from Review_Meeting_Request__c where Status__c=:'Scheduled' order by createddate desc];
                             
        }else{
            scheduledMeetingsList=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                        Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, Opportunity_ID__c, TCV_M__c, Operating_Group__c, Client_Geo_Unit__c, 
                        Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name from Review_Meeting_Request__c where Status__c=:'Scheduled' and BPO_Opportunity__c IN : meetingOppId order by createddate desc];
        }   
        schMeetingDisplay=true;
        archiveDisplay=false;
        defMeetingDisplay=false;
        deferredDisplay=true;
    }
    
    /******************************
    Method Name: deferredMeetingList
    Description: Method to display scheduled Meeting List
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deferredMeetingList()
    {
         if(isAcccessOppCalList ==  true){
                deferredMeetingsList=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, Opportunity_ID__c, TCV_M__c, Operating_Group__c, Client_Geo_Unit__c, 
                                Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name from Review_Meeting_Request__c where Status__c=:'Cancelled' order by createddate desc];
                
         }else{
            deferredMeetingsList=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, Opportunity_ID__c, TCV_M__c, Operating_Group__c, Client_Geo_Unit__c, 
                                Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name from Review_Meeting_Request__c where Status__c=:'Cancelled' and BPO_Opportunity__c IN : meetingOppId order by createddate desc];
        }  
        schMeetingDisplay=false;
        archiveDisplay=true;
        defMeetingDisplay=true;
        deferredDisplay=false;
    }
    
    /******************************
    Method Name: hideScheduledList
    Description: Method to hide the display of scheduled Meeting List
    Paramenters: NA
    Return Value: void
    *******************************/
    public void hideScheduledList() {
        schMeetingDisplay=false;
        archiveDisplay=true;
        defMeetingDisplay=false;
        deferredDisplay=true;
    } 
    
    /******************************
    Method Name: hideDeferredList
    Description: Method to hide the display of scheduled Meeting List
    Paramenters: NA
    Return Value: void
    *******************************/
    public void hideDeferredList() {
        schMeetingDisplay=false;
        archiveDisplay=true;
        defMeetingDisplay=false;
        deferredDisplay=true;
    } 
    
    /******************************
    Method Name: scheduleCall
    Description: Method to hide the display of scheduled Meeting List
    Paramenters: NA
    Return Value: void
    *******************************/
    public void scheduleCall() {
        showCal=false;
        selectedTab='tab1';
        schMeetingDisplay=false;
        archiveDisplay=true;
        defMeetingDisplay=false;
        deferredDisplay=true;
    } 
    
    /******************************
    Method Name: deferCall
    Description: Method to hide the display of scheduled Meeting List
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deferCall() {        
        try
        {
            List<Review_Meeting_Request__c> reqMeetList=[select id, name, Status__c from Review_Meeting_Request__c where id=:meetingID];
            if(reqMeetList!=null && reqMeetList.size()>0)
            {
                reqMeetList[0].Status__c = 'Cancelled';
                upsert reqMeetList[0];
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Meeting ID!'));
                return;
            }           
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Requested Meeting Cancelled Successfully!'));
        schMeetingDisplay=false;
        archiveDisplay=true;
        defMeetingDisplay=false;
        deferredDisplay=true;
        initializeSubmittedMeetings();
    }
    
    /******************************
    Method Name: refreshPage
    Description: Method to refresh the list.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static void refreshPageTrigger(List<Opportunity_TGP__c> oppTGPList) {
    	List<Id> oppIDList = new List<Id>();
    	for(Opportunity_TGP__c opp :oppTGPList) {
    		oppIDList.add(opp.Id);
    	}
    	if(!oppIDList.isEmpty()) {
	        List<Review_Meeting_Request__c> lstMeetingReq=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c,
	        												 Status__c, Meeting_Time__c, Meeting_Type__c,Offering__c, id, name, Opportunity_Solution_lead__c, 
	        												 Requester_User__c, Opportunity_ID__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Operating_Group__c,
	        												 Client_Geo_Unit__c, Complex_Cost_Architect__c, Client_Geo_Area__c, 
	        												 Review_Process__r.Review_Stage_Master__r.name,BPO_Opportunity__c, BPO_Opportunity__r.name, 
	        												 BPO_Opportunity__r.SAP_OM_Opportunity__r.name, BPO_Opportunity__r.Client_Name__r.name, 
	                                    				     BPO_Opportunity__r.Operating_Group__r.name, BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.name,
	                                    				     BPO_Opportunity__r.Client_Geo_Unit__r.name, BPO_Opportunity__r.Client_Geo_Area__r.name, 
	                                    					 BPO_Opportunity__r.TCV__c, BPO_Opportunity__r.Estimated_TCV__c, BPO_Opportunity__r.PrimeSDOLeadName__c, 
	                                    					 BPO_Opportunity__r.PrimeSDOLeadName__r.Name, BPO_Opportunity__r.Complex_Cost_Architect_New__r.Name 
	                                    					 from Review_Meeting_Request__c Where  BPO_Opportunity__c IN :oppIDList order by createddate desc];
	     
	        List<Opportunity_Offering__c> offeringNameList=[select id,name, Offering_Master__r.name,  Solution_Specialist_New__c, Opportunity_TGP__c , 
	                                        Solution_Specialist_New__r.name from Opportunity_Offering__c Where Opportunity_TGP__c IN :oppIDList];
	       
	        List<Review_Meeting_Request__c> templstMeetingReq= new List<Review_Meeting_Request__c>();
	        if(lstMeetingReq.size()>0)
	        {
	            for(Review_Meeting_Request__c r : lstMeetingReq)      
	            {
	                r.Opportunity_ID__c=r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name;
	                r.Opportunity_Name__c=r.BPO_Opportunity__r.name;
	                r.Client_Name__c=r.BPO_Opportunity__r.Client_Name__r.name;
	                r.Opportunity_Solution_lead__c=r.BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Name;
	                r.Client_Geo_Area__c=r.BPO_Opportunity__r.Client_Geo_Area__r.name;
	                r.Client_Geo_Unit__c=r.BPO_Opportunity__r.Client_Geo_Unit__r.name;
	                r.TCV_M__c=r.BPO_Opportunity__r.TCV__c;
	                
	                if(r.BPO_Opportunity__r.Estimated_TCV__c != null && r.BPO_Opportunity__r.Estimated_TCV__c != 0)
	                {
	                    r.Estimated_TCV_M__c = r.BPO_Opportunity__r.Estimated_TCV__c;
	                }else
	                {
	                    r.Estimated_TCV_M__c = r.BPO_Opportunity__r.TCV__c;
	                }
	                
	                r.Prime_SDO_Lead_M__c=r.BPO_Opportunity__r.PrimeSDOLeadName__r.Name;
	                r.Operating_Group__c=r.BPO_Opportunity__r.Operating_Group__r.name;
	                r.Complex_Cost_Architect__c=r.BPO_Opportunity__r.Complex_Cost_Architect_New__r.name;
	                String OfferingNames='';
	                String solSpecialistNames='';
	                boolean isExist=false;
	                Set<String> solSpecialistUsers=new Set<String>();
	                if(offeringNameList.size()>0)
	                {
	                    for(Opportunity_Offering__c o : offeringNameList)
	                    {
	                        if(o.Opportunity_TGP__c == r.BPO_Opportunity__c)
	                        {
	                            isExist=true;
	                            OfferingNames=OfferingNames+o.Offering_Master__r.name+' ; ';
	                            if(o.Solution_Specialist_New__c!=null)
	                            {
	                                solSpecialistUsers.add(o.Solution_Specialist_New__r.Name); 
	                            }
	                        }
	                    } 
	                }
	                
	                if(isExist==false)
	                {
	                    OfferingNames='   ';
	                }
	                if(solSpecialistUsers.size()>0)
	                {
	                    for(String s:solSpecialistUsers)
	                        solSpecialistNames=solSpecialistNames + s + ' ; '; 
	                }
	                else
	                {
	                    solSpecialistNames='   ';
	                }
	                if(OfferingNames!=null) 
	               { 
	                   OfferingNames= OfferingNames.substring(0,OfferingNames.length()-2); 
	               }
	               if(solSpecialistNames!=null) 
	               { 
	                   solSpecialistNames= solSpecialistNames.substring(0,solSpecialistNames.length()-2); 
	               }
	                r.Offering__c=OfferingNames;            
	                r.Solution_Specialist__c=solSpecialistNames;
	                templstMeetingReq.add(r);
	                
	            }
	        } 
	        
	        try
	        {
	            upsert templstMeetingReq;            
	        }
	        catch(Exception ex)
	        {
	            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getMessage()));
	            return;
	        }                   
	        return;
	        //}
	       // else
	        //{
	       // List<Opportunity_Offering__c> offeringNameList=[select id,name, Offering_Master__r.name,  Solution_Specialist__c, Opportunity_TGP__c , 
	                                       // Solution_Specialist__r.name from Opportunity_Offering__c limit 1];  
	       // }
	    }   
    }
    /******************************
    Method Name: refreshPage
    Description: Method to refresh the list.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static void refreshPage()
    {
        List<Review_Meeting_Request__c> lstMeetingReq=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                    Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, Opportunity_ID__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Operating_Group__c, Client_Geo_Unit__c, Complex_Cost_Architect__c,
                                    Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name,BPO_Opportunity__c, BPO_Opportunity__r.name, BPO_Opportunity__r.SAP_OM_Opportunity__r.name, BPO_Opportunity__r.Client_Name__r.name, 
                                    BPO_Opportunity__r.Operating_Group__r.name, BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.name, BPO_Opportunity__r.Client_Geo_Unit__r.name, BPO_Opportunity__r.Client_Geo_Area__r.name, 
                                    BPO_Opportunity__r.TCV__c, BPO_Opportunity__r.Estimated_TCV__c, BPO_Opportunity__r.PrimeSDOLeadName__c, BPO_Opportunity__r.PrimeSDOLeadName__r.Name, BPO_Opportunity__r.Complex_Cost_Architect_New__r.Name from Review_Meeting_Request__c order by createddate desc];
        //if(!Test.isRunningTest())
        //{
        List<Opportunity_Offering__c> offeringNameList=[select id,name, Offering_Master__r.name,  Solution_Specialist_New__c, Opportunity_TGP__c , 
                                        Solution_Specialist_New__r.name from Opportunity_Offering__c];
       
        List<Review_Meeting_Request__c> templstMeetingReq= new List<Review_Meeting_Request__c>();
        if(lstMeetingReq.size()>0)
        {
            for(Review_Meeting_Request__c r : lstMeetingReq)      
            {
                r.Opportunity_ID__c=r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name;
                r.Opportunity_Name__c=r.BPO_Opportunity__r.name;
                r.Client_Name__c=r.BPO_Opportunity__r.Client_Name__r.name;
                r.Opportunity_Solution_lead__c=r.BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Name;
                r.Client_Geo_Area__c=r.BPO_Opportunity__r.Client_Geo_Area__r.name;
                r.Client_Geo_Unit__c=r.BPO_Opportunity__r.Client_Geo_Unit__r.name;
                r.TCV_M__c=r.BPO_Opportunity__r.TCV__c;
                
                if(r.BPO_Opportunity__r.Estimated_TCV__c != null && r.BPO_Opportunity__r.Estimated_TCV__c != 0)
                {
                    r.Estimated_TCV_M__c = r.BPO_Opportunity__r.Estimated_TCV__c;
                }else
                {
                    r.Estimated_TCV_M__c = r.BPO_Opportunity__r.TCV__c;
                }
                
                r.Prime_SDO_Lead_M__c=r.BPO_Opportunity__r.PrimeSDOLeadName__r.Name;
                r.Operating_Group__c=r.BPO_Opportunity__r.Operating_Group__r.name;
                r.Complex_Cost_Architect__c=r.BPO_Opportunity__r.Complex_Cost_Architect_New__r.name;
                String OfferingNames='';
                String solSpecialistNames='';
                boolean isExist=false;
                Set<String> solSpecialistUsers=new Set<String>();
                if(offeringNameList.size()>0)
                {
                    for(Opportunity_Offering__c o : offeringNameList)
                    {
                        if(o.Opportunity_TGP__c == r.BPO_Opportunity__c)
                        {
                            isExist=true;
                            OfferingNames=OfferingNames+o.Offering_Master__r.name+' ; ';
                            if(o.Solution_Specialist_New__c!=null)
                            {
                                solSpecialistUsers.add(o.Solution_Specialist_New__r.Name); 
                            }
                        }
                    } 
                }
                
                if(isExist==false)
                {
                    OfferingNames='   ';
                }
                if(solSpecialistUsers.size()>0)
                {
                    for(String s:solSpecialistUsers)
                        solSpecialistNames=solSpecialistNames + s + ' ; '; 
                }
                else
                {
                    solSpecialistNames='   ';
                }
                if(OfferingNames!=null) 
               { 
                   OfferingNames= OfferingNames.substring(0,OfferingNames.length()-2); 
               }
               if(solSpecialistNames!=null) 
               { 
                   solSpecialistNames= solSpecialistNames.substring(0,solSpecialistNames.length()-2); 
               }
                r.Offering__c=OfferingNames;            
                r.Solution_Specialist__c=solSpecialistNames;
                templstMeetingReq.add(r);
                
            }
        } 
        
        try
        {
            upsert templstMeetingReq;            
        }
        catch(Exception ex)
        {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getMessage()));
            return;
        }                   
        return;
        //}
       // else
        //{
       // List<Opportunity_Offering__c> offeringNameList=[select id,name, Offering_Master__r.name,  Solution_Specialist__c, Opportunity_TGP__c , 
                                       // Solution_Specialist__r.name from Opportunity_Offering__c limit 1];  
       // }
    }   
    
}