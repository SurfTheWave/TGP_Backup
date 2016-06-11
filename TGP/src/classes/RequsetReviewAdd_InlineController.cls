/*
Author :  Varsha Chougule
Story  :  Story-0304/SOL_0136 
Description : Request for reviews for an opportunity.


Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
 

public class RequsetReviewAdd_InlineController {

    public string opportunityId{get;set;}
    public string reviewProcessId{get;set;}
    public Request_Review__c newRequestReview{get;set;}
    public list<Request_Review__c> newRequestReviewList{get;set;}
    //public list<Request_Review__c> newReqrevLst{get;set;}
    public List<Opportunity_TGP__c> opportunityList{get;set;} 
    public List<Opportunity_Offering__c> offeringNameList{get;set;}
    public Review_Process__c newReviewProcess{get;set;} 
    public List<Review_Process__c> reviewProcessList{get;set;}
    public string recordIdToDelete{get;set;}
    public Document_for_Request_Review__c newDocumentforRequestReview{get;set;}
    public list<Document_for_Request_Review__c> listDocumentforRequestReview{get;set;}
    public list<Opportunity_Document__c> listOpportunityDocument;
    public Document doc{get;set;}
    public String fileName {get;set;}
    public string DocumentrecordIdToDelete {get;set;}
    public String ReviewType{get;set;}
    public String strFinalReviewId{get;set;}
    
    //Added For UAM
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean deleteButtonRender {get; set;}
    public  List<userRole> role {get;set;}
     public String profileName {get;set;}
    public List<User>  userList{get;set;}
    //public String strFinalReviewId{get;set;}
    public Boolean isTaskCreated {get;set;}
    public String SolUserName{get;set;}
    public String currentUserName{get;set;}
    public String roleName{get;set;}
    public Boolean readOnlyMode{get;set;}
    public Boolean showButton{get;set;}
   // public String showHideButton;
    public String show= '1234';
    public String version{get;set;}
    public Opportunity_TGP__c opportunityRecord{get;set;}
    public Boolean revDateRender{get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean showSection{get;set;}
    public Boolean showSaveButton{get;set;}
    public String showButton1;
    public Boolean loginUserStatus{get;set;}
    public Boolean isWorkbenchUser{get;set;}
    public List<Opportunity_TGP__c> bpoOppList = new List<Opportunity_TGP__c>();
    public List<Opportunity_Offering__c> listOffering = new List<Opportunity_Offering__c>();
    public Boolean oppAndOffRecord{get;set;}
    public List<Opportunity_TGP__c> bpoOppListOwner=new List<Opportunity_TGP__c>();
    public Id oppOwnerId;  
    public integer Isfinalapprover=0;
    public Boolean IsAssociated {get; set;}
    public Boolean isDocumentEdit {get;set;}
    //Added for UAM End

    /******************************
    Method Name: RequsetReviewAdd_InlineController
    Description: Constructor for RequsetReviewAdd_InlineController
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public RequsetReviewAdd_InlineController(ApexPages.StandardController controller) 
    {
        isWorkbenchUser=true;
        profileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        //if(userProfileName.equalsIgnoreCase('System Administrator')) {
            showButton = true;
        //}
        
        opportunityId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_OPPID);
        system.debug('--------opportunityId-----------'+opportunityId);
        showButton1 = ApexPages.CurrentPage().getParameters().get(UTIL_Constants.VAR);
        reviewProcessId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        
        if(showButton1 != null)
        {
            showButton = showButton1.equals(UTIL_Constants.TRUE_VALUE);
            showSection =showButton1.equals(UTIL_Constants.FALSE_VALUE);            
        }
       
        newRequestReview=new Request_Review__c ();
        newRequestReviewList=new list<Request_Review__c>();
        
        getDetailSection();
        
        newDocumentforRequestReview= new Document_for_Request_Review__c();
        listDocumentforRequestReview= new list<Document_for_Request_Review__c>();
        doc=new Document ();
        

            
            addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
            saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
            deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
            
            

        //checkUsersAccessbity();
        if(addButtonRender==false && saveEditButtonRender==false)
        {
            readOnlyMode=true;
        }       
        //SOL_141 End
        getRequestReviewList();   
    }
    
    /******************************
    Method Name: getDetailSection
    Description: This method is used to get top section which display opportunity id,opp name,client name,offerings,review name,review version and review date.  
    Paramenters: NA
    Return Value: void
    *******************************/ 
    
   public void getDetailSection(){
    opportunityList=[select id, name, Client_Name__r.name, SAP_OM_Opportunity__r.name,  Enterprise_Solution_Architect_New__c, 
                            Enterprise_Solution_Architect_New__r.name,Complex_Cost_Architect_New__r.name, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, 
                                Operating_Group__r.name, TCV__c from Opportunity_TGP__c where id=:opportunityId];
        reviewProcessList=[select Version__c,Review_Type__c, Review_Date__c, Review_Stage_Master__c, Client_Name__c, Comments__c, Opportunity_Name__c, 
                              Solution_Specialist__c, Preferred_Meeting_Date_del__c, Meeting_Time__c, Meeting_Type__c,Complex_Cost_Architect__c,Status__c,
                                Offering__c, id, Client_Geo_Unit__c, Client_Geo_Area__c, TCV_M__c, name, Has_Request_Raised__c, Opportunity_Solution_lead__c, 
                                    Title__c, Requester_User__c, Review_Stage_Master__r.name, Opportunity_ID__c, Review_Name__c  from Review_Process__c where id=:reviewProcessId];                                    
        if(reviewProcessList.size()>0)
        {
            newReviewProcess = reviewProcessList[0];
            revDateRender=true; 
            if(newReviewProcess.Review_Date__c==null)
            {
                revDateRender=false;
            }   
            version='V'+ reviewProcessList[0].version__c; 
            if(opportunityList.size()>0)
            {
                showMainMsg=false;
                opportunityRecord=opportunityList[0];
                newReviewProcess.Client_Name__c=opportunityRecord.Client_Name__r.name;
                newReviewProcess.Complex_Cost_Architect__c=opportunityRecord.Complex_Cost_Architect_New__r.name;
                newReviewProcess.Opportunity_ID__c=opportunityRecord.SAP_OM_Opportunity__r.name;
                newReviewProcess.Opportunity_Name__c=opportunityRecord.name;
                newReviewProcess.Opportunity_Solution_lead__c=opportunityRecord.Enterprise_Solution_Architect_New__r.name;
                List<Opportunity_Offering__c> offeringNameList=[select id,name, Solution_Lead_New__c, Offering_Master__r.name, Offering_Solution_Lead_Secondary_New__c, 
                                        Solution_Specialist_New__c,Technical_Architect_New__c, Functional_Architect_Mobilization_New__c, Domain_Expert_Functional_Architect_New__c,
                                        Solution_Specialist_New__r.Name from Opportunity_Offering__c where Opportunity_TGP__c=:opportunityRecord.id];
                String OfferingNames='';
                String solSpecialistNames='';
                Set<String> solSpecialistUsers=new Set<String>();
                if(offeringNameList.size()>0)
                {
                    for(Opportunity_Offering__c off : offeringNameList)
                    {
                        OfferingNames=OfferingNames+off.Offering_Master__r.name+' ; ';
                       
                        if(off.Solution_Specialist_New__c!=null)
                            solSpecialistUsers.add(off.Solution_Specialist_New__r.Name);                                                   
                    }
                    OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1);                    
                }
                else
                    OfferingNames='   ';
                if(solSpecialistUsers.size()>0)
                {
                    for(String s:solSpecialistUsers)
                        solSpecialistNames=solSpecialistNames + s + ' ; ';
                        
                }
                if(solSpecialistNames.length()>0) 
                   { 
                    
                        solSpecialistNames= solSpecialistNames.substring(0,solSpecialistNames.length()-1); 
                        
                   }
             

}
}
}
    
    /******************************
    Method Name: getReviewTypeNames
    Description: This method is used to get list of Review types from master.  
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/ 
    public List<SelectOption> getReviewTypes()
    {  
        List<SelectOption> TypeName=new List<SelectOption>();
        if(ReviewType==UTIL_constants.NONE)
        {
            TypeName.add(new SelectOption(UTIL_constants.NONE,UTIL_constants.NONE_FOR_PICKLIST));
            return TypeName;
        }
        List <Review_Type_Master__c > tempReviewType=[select id,name from Review_Type_Master__c where active__c=:true];        
        if(tempReviewType.size()>0)
        {
            for(Review_Type_Master__c r : tempReviewType)
            {
            if(r.name ==UTIL_constants.FINAL_APROVAL)
                {
                    strFinalReviewId=r.id;
                }
                TypeName.add(new SelectOption(r.id, r.name)); 
            }
        }
        return TypeName;
    }
    
    /******************************
    Method Name: addRequestReview               
    Description: This method is used to add request review records.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void addRequestReview()
    {
        try
        {
            if(ReviewType==UTIL_constants.NONE || ReviewType==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_select_Review_Type));  
                return;  
            }
            newRequestReview.Review_Type_Master__c=ReviewType;
            if(newRequestReview.Review_User_Master__c==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_select_Reviewer_s_to_continue));  
                return;  
            }
            newRequestReview.version__c=1;
            newRequestReview.Review_Process__c=reviewProcessId;
            newRequestReview.Status__c=UTIL_constants.NOT_SENT;

            //add new review record
            Database.upsert(newRequestReview);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Record_Added_Successfully));
        }
        catch(Exception ex)
        {   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Failure_in_saving_record)); 
            return;
        }
        newRequestReview=new Request_Review__c ();
        return;
    }
    
    //Class of RequestReview
    public class RequestReview
    {
        public Request_Review__c newRequestReview{get; set;}
        public boolean isDesableReview{get;set;}
        public boolean isDesableSendReminder{get;set;}
        public boolean isDesableSelectReviewer{get;set;}
        public boolean isDesableStatus{get;set;}
        public boolean isDelete{get;set;}
        public list<String> DocList{get;set;}
        
        //Constructor for RequestReview
        public RequestReview(Request_Review__c newRequestReview, boolean isDesableReview, boolean isDesableSendReminder, boolean isDesableSelectReviewer,boolean isDesableStatus,  boolean isDelete, list<String> DocList)
        {
            this.newRequestReview=newRequestReview;
            this.isDesableReview=isDesableReview;
            this.isDesableSendReminder=isDesableSendReminder;
            this.isDesableSelectReviewer=isDesableSelectReviewer;
            this.isDesableStatus=isDesableStatus;
            this.isDelete=isDelete;
            this.DocList=DocList;
        }       
    }
    
    /******************************
    Method Name: resetUAMFields
    Description: This method is to reset UAM Fields.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void resetUAMFields()
    {
        addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
        saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
        deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;        
    }
     /******************************
    Method Name: getRequestReviewList
    Description: This method is get all request review records for perticular review.
    Paramenters: NA
    Return Value: list<RequestReview>
    *******************************/
      public List<RequestReview> getRequestReviewList() {
        boolean isOwner=false;
        IsAssociated=false;
        boolean isDesableReview=false;
        boolean isDesableSendReminder=true;
        boolean isDesableSelectReviewer=false;
        boolean isDesableStatus=false;
        boolean isDelete=false;
        List<RequestReview> listOfRequestReview = new List<RequestReview>();
        newRequestReviewList = [select Review_Type_Master__c,Document_Name__c,Review_Type_Master__r.name,id,Review_type__c,Review_User_Master__c,Comments_by_SA__c,
                                    Comments_by_approver__c,Approval_email_sent_on__c, Response_received_on__c,Send_reminder__c,Select_reviewer__c,Status__c,
                                    Review_Process__c,Version__c,Review_User_Master__r.SFDC_User__c,Review_User_Master__r.SFDC_User__r.IsActive,Review_Process__r.Review_Stage_Master__r.name, 
                                    Review_User_Master__r.Email_ID_of_the_reviewer__c,Response_From__c,Review_Process__r.BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Email_ID_of_the_reviewer__c  
                                    from Request_Review__c where Review_Process__c=:reviewProcessId order by createddate desc]; 
        //String userName = UserInfo.getUserName();
        //User activeUser = [Select Email From User where Username = : userName limit 1];
        //userId = activeUser.id;  
        List<Opportunity_Team__c> bpoOppRecList = new List<Opportunity_Team__c>();
        //List<Opportunity_Offering__c> listOfferingRec = new List<Opportunity_Offering__c>();
        bpoOppListOwner = [select id,OwnerId,Enterprise_Solution_Architect_New__c/*,Complex_Cost_Architect_New__c,BSS_Operation_New__c */
                            from Opportunity_TGP__c where id =: opportunityId];
        Id userId = UserInfo.getUserId();               
        bpoOppRecList = [Select BPO_Opportunity__c,BPO_Opportunity__r.Enterprise_Solution_Architect_New__c,Offering__c,Opportunity_Team_Member__c,Roles__c from Opportunity_Team__c where BPO_Opportunity__c =: opportunityId AND Opportunity_Team_Member__r.SFDC_User__c =: userId];
                 
        if(bpoOppListOwner.size()>0){
            if(userId == bpoOppListOwner[0].OwnerId) {
                IsAssociated=true; // Added by Hareesh true for owner
                isDocumentEdit = true;
            }
        } 
        if((bpoOppRecList != null && bpoOppRecList.Size() >0) /*|| (listOfferingRec != null && listOfferingRec.Size() >0)*/) {
             IsAssociated=true; 
             isDocumentEdit = true;
        } 
        else {
                IsAssociated=false;
        }                       
        if((profileName!=null && profileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN)) || profileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || (profileName!=null && profileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN)))
        {
            isDocumentEdit = true;
            deleteButtonRender = true;   
            if(newRequestReviewList.size()>0) {
                for(Request_Review__c r: newRequestReviewList) {
                    isDesableReview=false;
                    isDesableSendReminder=true;
                    isDesableSelectReviewer=false;
                    isDesableStatus=false;
                    isDelete=false;
                    if(r.status__c == 'Approved' || r.status__c == 'Ready For Review' || r.status__c == 'Rework' || r.status__c == 'Reject')  {
                        isDesableReview=true;
                        isDesableSendReminder=true;
                        isDesableSelectReviewer=true;
                        isDelete=true;
                        isDesableStatus = false; // Hareesh
                    }
                    else if(r.status__c == 'Pending' )  {
                        isDesableSelectReviewer=true;
                        isDesableSendReminder=false;
                        isDesableStatus=true;
                        isDelete=false; 
                        isDesableReview = false;
                    }
                    else if(r.status__c == 'Not Sent') {
                       isDesableStatus=false;
                       isDelete=false;
                       isDesableSelectReviewer=false;
                       isDesableReview = false;
                       isDesableSendReminder = true;
                    }
                    List<String> s=null;
                    if(r.Document_Name__c!=null)
                    s=r.Document_Name__c.split('\\;'); 
                    listOfRequestReview.add(new RequestReview(r, isDesableReview, isDesableSendReminder, isDesableSelectReviewer, isDesableStatus,isDelete, s));
                }
            }
        }        
        //PMO profile
        else if(profileName!=null && profileName.equalsIgnoreCase(UTIL_Constants.PMO)) { 
            if(newRequestReviewList.size()>0) {   
                deleteButtonRender = true;//change made by muthu
                isDesableReview=false;
                isDesableSendReminder=true;
                isDesableSelectReviewer=false;
                isDesableStatus=false;
                isDelete=false;
                showButton = false;
                for(Request_Review__c r: newRequestReviewList) {      
                    if(r.status__c == 'Approved' || r.status__c == 'Ready For Review' ||  r.status__c == 'Rework' || r.status__c == 'Reject') {    
                        isDesableReview=true;
                        isDesableSendReminder=true;
                        isDesableSelectReviewer=true;
                        isDelete=true;
                        isDesableStatus = false;
                     }
                     else if( r.status__c == 'Pending' ) {
                        if(r.Review_User_Master__r.SFDC_User__c == userId && IsAssociated) {
                            isDesableStatus = true;
                            isDelete=false;
                            isDesableReview = false;
                            isDesableSendReminder = false;
                            isDesableSelectReviewer = true;
                        }
                        else if(r.Review_User_Master__r.SFDC_User__c != userId && IsAssociated) {
                            isDesableStatus = false;
                            isDesableReview = false;
                            isDesableSendReminder = false;
                            isDelete=false;
                            isDesableSelectReviewer=true;
                        }
                        else if(r.Review_User_Master__r.SFDC_User__c == userId && !IsAssociated) {
                            isDesableStatus = true;
                            isDesableReview = true;
                            isDesableSendReminder = true;
                            isDelete=true;
                            isDesableSelectReviewer=true;           
                        }
                        else if(r.Review_User_Master__r.SFDC_User__c != userId && !IsAssociated){
                            isDesableReview=true;
                            isDesableSendReminder=true;
                            isDesableSelectReviewer=true;
                            isDelete=true;
                            isDesableStatus = false;
                        } 
                    }
                    else if( r.status__c == 'Not Sent' ) {
                        if(IsAssociated) {
                            isDesableReview=false;
                            isDesableSendReminder=true;
                            isDesableSelectReviewer=false;
                            isDelete=false;
                            isDesableStatus = false;
                         }
                         else if(!IsAssociated) {
                            isDesableReview=true;
                            isDesableSendReminder=true;
                            isDesableSelectReviewer=true;
                            isDelete=true;
                            isDesableStatus = false;
                         }
                    }
                    //Not check the below code later Hareesh
                    
                    if(r.Review_User_Master__r.SFDC_User__c != null && r.Review_User_Master__r.SFDC_User__c == userId) {
                         readOnlyMode = false;
                         isDesableReview=true;
                         isDesableSendReminder=true;
                         isDesableSelectReviewer=true;
                         //isDesableStatus=true;
                         resetUAMFields();
                         deleteButtonRender = true;//change made by muthu
                         //isDelete=true;
                         //isDelete=false;
                         if(!saveEditButtonRender){
                            saveEditButtonRender = true;
                            isWorkbenchUser=false;
                            //readOnlyMode = false;
                         }
                         else{
                            saveEditButtonRender = true;
                            isWorkbenchUser=true;
                            //readOnlyMode = true;
                            addButtonRender=true;
                            //showButton=true; // to edit comments on document details
                         }
                    }  
                    isWorkbenchUser=true;    
                    List<String> s=null;
                    if(r.Document_Name__c!=null)
                    s=r.Document_Name__c.split('\\;');      
                    listOfRequestReview.add(new RequestReview(r, isDesableReview, isDesableSendReminder, isDesableSelectReviewer, isDesableStatus,isDelete,s));
                }
            }
        }
        //Till Here 
        else  {   
            if(newRequestReviewList.size()>0) {    
                deleteButtonRender = true;
                deleteButtonRender = true;//change made by muthu
                isDesableReview=false;
                isDesableSendReminder=true;
                isDesableSelectReviewer=false;
                isDesableStatus=false;
                isDelete=false;
                showButton = false;
                for(Request_Review__c r: newRequestReviewList) {      
                    if(r.status__c == 'Approved' || r.status__c == 'Ready For Review' ||  r.status__c == 'Rework' || r.status__c == 'Reject') {    
                        isDesableReview=true;
                        isDesableSendReminder=true;
                        isDesableSelectReviewer=true;
                        isDelete=true;
                        isDesableStatus = false;
                     }
                     else if( r.status__c == 'Pending' ) {
                        if(r.Review_User_Master__r.SFDC_User__c == userId && IsAssociated) {
                            isDesableStatus = true;
                            isDelete=false;
                            isDesableReview = false;
                            isDesableSendReminder = false;
                            isDesableSelectReviewer = true;
                        }
                        else if(r.Review_User_Master__r.SFDC_User__c != userId && IsAssociated) {
                            isDesableStatus = false;
                            isDesableReview = false;
                            isDesableSendReminder = false;
                            isDelete=false;
                            isDesableSelectReviewer=true;
                        }
                        else if(r.Review_User_Master__r.SFDC_User__c == userId && !IsAssociated) {
                            isDesableStatus = true;
                            isDesableReview = true;
                            isDesableSendReminder = true;
                            isDelete=true;
                            isDesableSelectReviewer=true;           
                        }
                        else if(r.Review_User_Master__r.SFDC_User__c != userId && !IsAssociated){
                            isDesableReview=true;
                            isDesableSendReminder=true;
                            isDesableSelectReviewer=true;
                            isDelete=true;
                            isDesableStatus = false;
                        } 
                    }
                    else if( r.status__c == UTIL_constants.NOT_SENT ) {
                        if(IsAssociated) {
                            isDesableReview=false;
                            isDesableSendReminder=true;
                            isDesableSelectReviewer=false;
                            isDelete=false;
                            isDesableStatus = false;
                         }
                         else if(!IsAssociated) {
                            isDesableReview=true;
                            isDesableSendReminder=true;
                            isDesableSelectReviewer=true;
                            isDelete=true;
                            isDesableStatus = false;
                         }
                    }
                    
                    if(r.Review_User_Master__r.SFDC_User__c != null && r.Review_User_Master__r.SFDC_User__c == userId )
                    {
                         readOnlyMode = false;
                         //isDesableSendReminder=true;
                         //isDesableReview=true;
                        // isDesableSelectReviewer=true;
                         //isDesableStatus=true;
                         resetUAMFields();
                         deleteButtonRender = true;//change made by muthu
                         if(saveEditButtonRender)
                         {
                            isWorkbenchUser=true;
                            addButtonRender=true;
                         }else
                         {
                            saveEditButtonRender = true;
                            isWorkbenchUser=false;
                         }
                    } 
                    isWorkbenchUser=true;
                    List<String> s=null;
                    if(r.Document_Name__c!=null)
                    s=r.Document_Name__c.split('\\;');            
                    listOfRequestReview.add(new RequestReview(r, isDesableReview, isDesableSendReminder, isDesableSelectReviewer, isDesableStatus,isDelete,s));

                }
                
            }
        }                
        return listOfRequestReview;
    }
    
    /******************************
    Method Name: getRequestReviewList
    Description: This method is get all request review records for perticular review.
    Paramenters: NA
    Return Value: list<Request_Review__c>
    *******************************/
    /*public list<Request_Review__c> getRequestReviewList()
    {
        list<Request_Review__c> tempRequestReviewList=new list<Request_Review__c>();
        
        //List of request review records for perticular review
        newRequestReviewList=[select id,Review_type__c,Review_User_Master__c,Comments_by_SA__c,Comments_by_approver__c,Approval_email_sent_on__c,
                             Response_received_on__c,Send_reminder__c,Select_reviewer__c,Status__c,Review_Process__c 
                             from Request_Review__c where Review_Process__c=:reviewProcessId];
        if(newRequestReviewList.size()>0)
        {
            for(Request_Review__c reviewList : newRequestReviewList)
            {
                tempRequestReviewList.add(reviewList);  
            }  
        }   
        return tempRequestReviewList; 
    }*/
    
    /******************************
    Method Name: saveRequestReviewList
    Description: This method is used to save request review records.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveRequestReviewList()
    {
          String emailID=null;
          List<User> userEmailList=[SELECT Email FROM User where id=:UserInfo.getUserId() limit 1];
        if(newRequestReviewList.size()>0)
        {
            try
            {
                //update the requset review records
                //Add by Vinay Chada for Defect ID:D-1275
                if(newRequestReviewList.size()>0)
                {
                    for(Request_Review__c reqList : newRequestReviewList)
                    {               
                        if(reqList.Review_Type_Master__r.name==UTIL_constants.FINAL_APROVAL)
                        {
                            //String emailID=null;
                            //List<User> userEmailList=[SELECT Email FROM User where id=:UserInfo.getUserId()];
                            if(userEmailList.size()==1)
                            {
                                emailID=userEmailList[0].Email;
                                if(emailID == reqList.Review_User_Master__r.Email_ID_of_the_reviewer__c && reqList.status__c==null)
                                {
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Status_value_cannot_be_None_Please_select_another_value));
                                    return; 
                                }
                            }
                        }
                    }  
                }
                for(Request_Review__c finalRivewList : newRequestReviewList)
                {                                              
                    if(finalRivewList.Review_Type_Master__r.name == UTIL_constants.FINAL_APROVAL && finalRivewList.status__c==UTIL_constants.PENDING)
                    {
                        finalRivewList.Select_reviewer__c=false;
                    }
                }
                List<Request_Review__c> oldReqList=[select Review_Type_Master__c,Review_Type_Master__r.name,id,Review_type__c,Review_User_Master__c,Comments_by_SA__c,Comments_by_approver__c,Approval_email_sent_on__c,
                             Response_received_on__c,Response_From__c,Send_reminder__c,Select_reviewer__c,Status__c,Review_Process__c,Version__c,Review_User_Master__r.Email_ID_of_the_reviewer__c,Review_Process__r.Review_Stage_Master__r.name,Review_Process__r.Review_Stage_Master__r.id 
                             from Request_Review__c where Review_Process__c=:reviewProcessId order by createddate desc];  
                                
               for(Request_Review__c reqrevrec : newRequestReviewList){
               	
               		if(reqrevrec.Response_From__c == null && reqrevrec.Status__c == 'Approved'){
               			
               			reqrevrec.Response_From__c = userEmailList[0].Email.substring(0,userEmailList[0].Email.indexOf('@')); 
               		}
               	
               }
               Database.upsert(newRequestReviewList);
               
               List<Request_Review__c> newResponseList = new List<Request_Review__c>();               
            
               for(Request_Review__c rivewList : newRequestReviewList)
                {   
                 for(Request_Review__c oldRList: oldReqList)
                    {
                    if (oldRList.id == rivewList.id){
                         // if(rivewList.Review_Type_Master__r.name == UTIL_constants.FINAL_APROVAL && rivewList.status__c != oldRList.status__c)
                          if(rivewList.status__c != oldRList.status__c)
                            {                                           
                                rivewList.id=oldRList.id;
                                String responseFrom = userEmailList[0].Email.substring(0,userEmailList[0].Email.indexOf('@')); 
                                rivewList.Response_From__c = responseFrom;       
                                rivewList.Response_received_on__c=system.today();                               
                                newResponseList.add(rivewList);
                            }
                    }
                    }
                  
                }
                if(newResponseList.size() > 0){
                    Database.upsert(newResponseList);
                }
                
                 /*
                List<Task> newTaskList = new List<Task>();
                for(Request_Review__c reviewTaskList : newRequestReviewList)
                {
                    if(reviewTaskList.status__c == UTIL_constants.APPROVED && reviewTaskList.Review_Type_Master__r.name ==UTIL_constants.FINAL_APROVAL )
                    {
                        List<Task> tk2=[Select t.WhatId,t.WhoId,t.subject,t.Title__c, t.TCV__c, t.Status__c, t.Solution_Specialist__c, 
                        t.Send_Email__c, t.Reviewer_Id__c, t.Review_Type__c, t.Requester__c, t.Request_Review_Id__c, t.Region__c, 
                        t.OwnerId, t.Opportunity_Solution_Lead__c, t.Opportunity_Name__c, t.Opportunity_ID__c, t.Opportunities_Rivew_And_Approval__c, 
                        t.Operating_Group__c, t.Offering__c, t.Meeting_Type__c, t.Meeting_Record_ID__c, t.Meeting_ID__c, t.IsClosed, t.Id, 
                        t.Client_Name__c, t.Approval_Status__c,t.Email_ID_of_the_reviewer__c From Task t];
                                            
                        List<Task> tk=[Select t.Id, t.Approval_Status__c From Task t where t.Request_Review_Id__c=:reviewTaskList.id];                 
                        if(tk.size()>0)
                        {
                            for(Task taskList : tk)
                            {
                                if(taskList.Approval_Status__c==UTIL_constants.PENDING)
                                {
                                    taskList.Approval_Status__c=UTIL_constants.APPROVED;
                                    newTaskList.add(taskList);
                                }
                            
                            }
                        }
                    }
                } */
                /*List<Task> newTaskList = new List<Task>();
                for(Request_Review__c reviewTaskList : newRequestReviewList)
                {
                //if(reviewTaskList.Review_Type_Master__r.name ==UTIL_constants.FINAL_APROVAL )
                //{
                    List<Task> tk=[Select t.Id, t.Approval_Status__c From Task t where t.Request_Review_Id__c=:reviewTaskList.id];
                    if(tk.size()>0)
                    {   
                        for(Task taskList : tk)
                        {   
                            taskList.Approval_Status__c=reviewTaskList.status__c;
                            newTaskList.add(taskList);
                        }
                    }
                //}
                }*/
                List<Task> newTaskList = new List<Task>();
                Set<Id> reviewListSet = new Set<Id>();
                for(Request_Review__c reviewTaskList : newRequestReviewList) {
                    reviewListSet.add(reviewTaskList.Id);
                }
                List<Task> tsk=[Select Id, Request_Review_Id__c,Approval_Status__c From Task where Request_Review_Id__c IN :reviewListSet];
                for(Request_Review__c reviewTaskList : newRequestReviewList){
                  if(tsk.size()>0){
                      for(Task temp:tsk){
                         if(reviewTaskList.id==temp.Request_Review_Id__c){
                            temp.Approval_Status__c=reviewTaskList.status__c;
                            newTaskList.add(temp);
                          }
                      }  
                   }
                }
                database.upsert(newTaskList);  
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Record_Updated_Successfully));
            }
            catch(Exception ex)
            {   
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Failure_in_saving_record)); 
                getRequestReviewList();
                return;
            }
        }
        return;
    }
    
    /******************************
    Method Name: cancelRequestReviewList
    Description: This method is used to cancel the chenges.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void cancelRequestReviewList()
    {
        getRequestReviewList();
        return;
    }
    
    /******************************
    Method Name: deleteRequestReview
    Description: This method is used to delete request review record.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deleteRequestReview()
    {
        try
        {
            //List of request review to delete the perticular record
            List<Request_Review__c> listRequestReview=[select id from Request_Review__c where id=:recordIdToDelete];
            if(listRequestReview.size()==1)
            {
                //delete the selected record
                Database.delete(listRequestReview);
            }
            /* Add by Vinay Chada */
            List<Task> tkDelete=[Select t.Id From Task t where t.Request_Review_Id__c=:recordIdToDelete];
             if(tkDelete.size()==1)
            {
                //delete the selected Task record
                Database.delete(tkDelete);
            }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Record_deleted_successfully));
        }
        catch(Exception ex)
        {   
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Failure_in_deleting_record)); 
            getRequestReviewList();
            return;
        }
        return;
    }
    
    /******************************
    Method Name: addDocument
    Description: This method is used to add Document.
    Paramenters: NA
    Return Value: void
    *******************************/
    /*public void addDocument()
    {
        try
        {
            doc.AuthorId = UserInfo.getUserId();
            doc.FolderId = UserInfo.getUserId();
            doc.IsPublic=true;   
            if(doc.body==null)
            {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Choose_document_before_clicking_on_upload));
                return;
            }
            //insert document in standard Document object
            database.insert(doc);
            //To fetch records from Document.
            List<Document> document= [select id,name from Document where id=:doc.id];
            if(document.size()>0)
            {
                newDocumentforRequestReview.Document_id__c=document[0].id;  
                newDocumentforRequestReview.Document_Name__c=document[0].name;  
            }
            newDocumentforRequestReview.Review_Process__c=reviewProcessId;
            newDocumentforRequestReview.Date_uploaded__c=system.today();
            //add new document record
            database.insert(newDocumentforRequestReview);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Record_Added_Successfully));
            //newDocumentforRequestReview.clear();    
        }
        catch(Exception ex)
        {   
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Failure_in_saving_record)); 
            return;
        }
        finally
        {
              doc = new Document();
        }
        newDocumentforRequestReview=new Document_for_Request_Review__c ();
        return;
    }*/
    
    /******************************
    Method Name: getDocumentforRequestReviewList
    Description: This method is get all Documents records for perticular review.
    Paramenters: NA
    Return Value: list<Document_for_Request_Review__c>
    *******************************/
    public list<Document_for_Request_Review__c> getDocumentforRequestReviewList()
    {
        
        //List of documents records for perticular review
        listDocumentforRequestReview=[select id,Document_Name__c,Document_id__c,Comments__c,Review_Process__c,Date_uploaded__c,
                                     Select_document__c from Document_for_Request_Review__c where Review_Process__c=:reviewProcessId order by createddate desc];
         
        return listDocumentforRequestReview; 
    }
    
    /******************************
    Method Name: getDocumentforRequestReviewList
    Description: This method is get all Documents records for perticular review.
    Paramenters: NA
    Return Value: list<Document_for_Request_Review__c>
    *******************************/
    public list<Opportunity_Document__c> getlistOpportunityDocument()
    {
       
        listOpportunityDocument = [select id, Name, Document_Link__c, Modified_Date__c, Modified_By__c, IsDeleted__c, Comments__c, Select_document__c FROM Opportunity_Document__c where BPO_Opportunity__c =: opportunityId];
        
        return listOpportunityDocument; 
    }
    
    /******************************
    Method Name: saveDocumentList
    Description: This method is used to save document records.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveDocumentList()
    {
        if(listOpportunityDocument.size()>0){
            try
            {
                //update the document records
                Database.upsert(listOpportunityDocument);
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Record_Updated_Successfully));
            }
            catch(Exception ex)
            {   
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Failure_in_saving_record)); 
                getDocumentforRequestReviewList();
                return;
            }
        }
        return;
    }
    
    /******************************
    Method Name: cancelDocumentList
    Description: This method is used to cancel the chenges.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void cancelDocumentList()
    {
        getlistOpportunityDocument();
        return;
    }
    
    /******************************
    Method Name: deleteDocument
    Description: This method is used to delete document record.
    Paramenters: NA
    Return Value: void
    *******************************/
   /* public void deleteDocument()
    {
        try
        {
            //List of Document to delete the perticular record
            List<Document_for_Request_Review__c > tempDoclist=[select id,Document_id__c from Document_for_Request_Review__c where id=:DocumentrecordIdToDelete];
            if(tempDoclist.size()==1)
            {
                List<Document> tempDocument= [select id,name from Document where id=:tempDoclist[0].Document_id__c];
                if(tempDocument.size()==1)
                {
                    //delete the file from document object
                    Database.delete(tempDocument);
                }
                //delete the selected record
                Database.delete(tempDoclist);
            }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Record_deleted_successfully));
        }
        catch(Exception ex)
        {   
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Failure_in_deleting_record)); 
            getRequestReviewList();
            return;
        }
        return;
    }*/
    
    /******************************
    Method Name: sendEmailForApproval
    Description: This method is used send Approval Email.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void sendEmailForApproval()
    {
        String documentUrlList = '';
        list<string> listOfDocId =new list<string>();
        list<Document> docList =new list<Document>();
        list<Review_User_Master__c> usrtList=new list<Review_User_Master__c>();
        
        List<Task> myTaskListToUpdate = new List<Task>();
        List<Task> myTaskListToUpdate1 = new List<Task>();
        
        list<Request_Review__c> reqRevList = new list<Request_Review__c>();
        
        list<Review_User_Master__c> revUserMasterList=new list<Review_User_Master__c>();
        
        list<Opportunity_Document__c> reviewDoc=new list<Opportunity_Document__c>();
        boolean isReviweerSelected=false;
        boolean isStatusNull=false;
        boolean isDocumentSelected =false;
        
        List<User> userEmailList=[SELECT Email FROM User where id=:UserInfo.getUserId()];
        
        List<Opportunity_TGP__c> listEmailOpp = [Select o.TCV__c,o.Service_Delivery_Locations_Unique__c,o.Stage__c, o.SAP_OM_Opportunity__r.name, o.Operating_Group__r.name, o.Offerings__c, o.Name, o.Id, o.Client_Name__r.name,o.Client_Geo_Area__r.name,o.Client_Geo_Unit__r.name From Opportunity_TGP__c o where o.Id = : opportunityId];
        
        List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
        
        usrtList=[select id,Email_ID_of_the_reviewer__c from Review_User_Master__c ];
        
        Map<id,List<Review_User_Master__c>> reviewUserMasterMap = new Map<id,List<Review_User_Master__c>>();
        
        for(Review_User_Master__c reviewUserMasterrec : usrtList){
            
            List<Review_User_Master__c> reviewUserMasterList = new List<Review_User_Master__c>{reviewUserMasterrec};
            
            reviewUserMasterMap.put(reviewUserMasterrec.id,reviewUserMasterList);
        }
        
        //List<Task> myTask = new List<Task>();
        
        List<Task> myTaskList=[Select id, Request_Review_Id__c,Approval_Status__c from Task ];
        
        //List<Task> myTask=[Select id, Approval_Status__c from Task where Request_Review_Id__c=:reviewerList.id];
        
        Map<String,List<Task>> myTaskMap = new Map<String,List<Task>>();
        
        for(Task myTaskRec : myTaskList){
            
            List<Task> myTaskRecList = new List<Task>{myTaskRec};
            
            myTaskMap.put(myTaskRec.Request_Review_Id__c,myTaskRecList);
        }
        
        //owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
        
        List<OrgWideEmailAddress> owearec = [select Id,Address from OrgWideEmailAddress];
        
        Map<String, List<OrgWideEmailAddress>> oweaRecMap = new Map<String, List<OrgWideEmailAddress>>();
        
        for(OrgWideEmailAddress myowearec : owearec){
            
            List<OrgWideEmailAddress> myOweaRecList = new List<OrgWideEmailAddress>{myowearec};
            
            oweaRecMap.put(myowearec.id,myOweaRecList);
        }
        
        List<Opportunity_Document__c> docReqReview = new List<Opportunity_Document__c>();
        
        if(listOpportunityDocument.size()>0)
        {
                Database.upsert(listOpportunityDocument);
                system.debug('++++++'+listOpportunityDocument);
                system.debug('++++++'+listOpportunityDocument.size());
            for(Opportunity_Document__c doc1List : listOpportunityDocument)
            {
                //document which is selected to send with email
                if(doc1List.Select_document__c==true)
                {
                    //list of ids of documents to be send with mail
                    //listOfDocId.add(doc1List.Document_id__c); 
                    reviewDoc.add(doc1List);   
                            doc1List.Select_document__c=false;
                            docReqReview.add(doc1List);
                            
                            isDocumentSelected=true;  
                }
            }
        }
        Database.upsert(docReqReview);
        
        /*if(listOfDocId.size()>0)
        {
            //list of documents to be attached with mail
            docList=[select id, name, body, contenttype, developername, type from Document where id IN :listOfDocId];
        }*/
        if(newRequestReviewList.size()>0)
        {
            for(Request_Review__c reviewerList : newRequestReviewList)
            {
                if(reviewerList.status__c==null || reviewerList.status__c=='' || reviewerList.status__c==UTIL_constants.REWORK || reviewerList.status__c==UTIL_constants.REJECT){
                    isStatusNull=true;
                }
                //review record which is selected to send email
                if(reviewerList.Select_reviewer__c==true && reviewerList.status__c!=UTIL_constants.APPROVED)
                {
                    isReviweerSelected=true;
                   // Messaging.EmailFileAttachment [] attachList=new Messaging.EmailFileAttachment[]{};      
                    //Messaging.EmailFileAttachment attach ;
                             if(isDocumentSelected==false)
                                  {
                                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_select_Document_s_to_continue)); 
                                   return;
                                  }
                            if(reviewDoc.size()>0)
                            {
                                reviewerList.Document_Name__c=null;
                                Integer i = 1;
                                for(Opportunity_Document__c tempDoc : reviewDoc)
                                {
                                    //attachement
                                   // attach = new Messaging.EmailFileAttachment(); 
                                    //attach.setContentType(tempDoc.contentType);
                                   // attach.setFileName(tempDoc.name);//+'.'+tempDoc.type); //added by Vinay Chada for defect no : D-1111
                                   // attach.setInline(false);
                                    //attach.Body = tempDoc.Body;   
                                   // attachList.add(attach);
                                    if(reviewDoc.size() == i) {
                                        documentUrlList += '<a href="' + tempDoc.Document_Link__c + '">'+ tempDoc.Name +'</a>';
                                    }
                                    else {
                                       documentUrlList += '<a href="' + tempDoc.Document_Link__c + '">'+ tempDoc.Name +'</a>' + ' , ';
                                       i = 1 + 1; 
                                    }
                                    if(reviewerList.Document_Name__c!=null)
                                    {
                                        reviewerList.Document_Name__c=reviewerList.Document_Name__c+';'+tempDoc.name;
                                    }
                                    else
                                    {
                                        reviewerList.Document_Name__c=tempDoc.name;
                                    }
                                }  
                                     
                            }
                            try
                            {
                                //email to be send
                                OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
                               // List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                               
                                if(lstIdForOWA.size()>0)
                                {
                                    //owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                                    owea = oweaRecMap.get(lstIdForOWA[0].OWA_id__c);
                                } 
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                if (owea != null &&  owea.size() > 0 ) 
                                {
                                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                }       
                                //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                //mail.setSenderDisplayName('BPO Solution Support');   
                                mail.setUseSignature(false);
                                
                                //usrtList=[select id,Email_ID_of_the_reviewer__c from Review_User_Master__c where id =:reviewerList.Review_User_Master__c];
                                
                                usrtList = reviewUserMasterMap.get(reviewerList.Review_User_Master__c);
                                
                                //List<Opportunity_TGP__c> listEmailOpp = [Select o.TCV__c,o.Service_Delivery_Locations_Unique__c,o.Stage__c, o.SAP_OM_Opportunity__r.name, o.Operating_Group__r.name, o.Offerings__c, o.Name, o.Id, o.Client_Name__r.name,o.Client_Geo_Area__r.name,o.Client_Geo_Unit__r.name From Opportunity_TGP__c o where o.Id = : opportunityId];
                                
                                mail.setToAddresses(new String[] { usrtList[0].Email_ID_of_the_reviewer__c });
                                String ccemailID='';
                                
                                //List<User> userEmailList=[SELECT Email FROM User where id=:UserInfo.getUserId()];
                                
                                if(userEmailList.size()==1)
                                {
                                    ccemailID=userEmailList[0].Email;
                                }
                                mail.setCcAddresses(new String[] { ccemailID, reviewerList.Review_Process__r.BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Email_ID_of_the_reviewer__c });
                                
                                // below reply To is belongs to NewDev.
                                mail.replyTo='review_and_approval@o-dz89711ud9sktmryerheqszw1fkacuyinqcpv3dqs4ixhwxr9.c-3tbhqea2.cs14.apex.sandbox.salesforce.com';
                                
                                // below reply To is belongs to Config.
                                //mail.replyTo='review_and_approval@2-348wjargrqaxb4uskei6x6g31ai986z1jh1zd8jiozpsco727.l-273cjmaa.l.apex.sandbox.salesforce.com';
                                
                                // below reply To is belongs to UAT.                                
                                //mail.replyTo='review_and_approval@p-t0xvn0ra7b50k2hgzgxaldthajiu2zt55wuw6pk7w2plkht7p.c-1kjexeaw.cl.apex.sandbox.salesforce.com';
                                
                                // below reply To is belongs to Prod.                                
                                //mail.replyTo='review_and_approval@e-v85ak3924wj12u9mti4uxf5unx07t62yw09up1lw3um7piux2.e-zi3zmac.e.apex.salesforce.com';
                                
                                //mail.setSubject('Upload the Document for your Approval');
                                 string OfferingNames =checkNullValues(listEmailOpp[0].Offerings__c);
                              /*  if(OfferingNames!=null) 
                                   { 
                
                                                    OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                    
                                    } */
                                mail.setSubject('ACTION REQUIRED! Approve Final Review Solution - Client Name: '+' '+listEmailOpp[0].Client_Name__r.name+'  '+'-'+' '+'Opportunity Name:  '+listEmailOpp[0].Name);
                                /*String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">Hi,</span>'+' <br>'
                                                        +' '+' <br>'
                                                        +'<span style="font-size:11pt; font-family:Calibri">This Email is to make you inform that the Solution Plan is Sent for your Review and Approval.</span>' +'<br>'
                                                        +'<br>'+ '<span style="font-size:11pt; font-family:Calibri">Please only reply to this email by following the below instructions:</span>' +'<br>'+
                                                        '<span style="font-size:11pt; font-family:Calibri">1. <b><<font color="Blue">Type Approved/Rejected/Rework here by replacing the Text in between brackets</font>></b> </span>'+'<br>'+
                                                        '<span style="font-size:11pt; font-family:Calibri">2. <b>*<font color="Blue">Provide your comments here by replacing Text in between asterisks</font>*</b></span>'+'<br><br>'+ 
                                                        '<span style="font-size:11pt; font-family:Calibri"><b><font color="Red">Note: Please Reply this mail. </font></b></span>'+'<br>'
                                                        +'    '+'<br><br><br>'
                                                        +'<br/><span style="font-size:11pt; font-family:Calibri"><b><font color="Red">Important: Please do not Edit the below Section, it is used internally for Processing.</font></b></span>'+'<br>'
                                                        +'<span style="font-size:11pt; font-family:Calibri">Record Id :#'+reviewerList.id+'#</span>'
                                                        +'    '+'<br><br><br>'
                                                        +'    '+'<br><br><br>'
                                                        +'    '+'<br><span style="font-size:11pt; font-family:Calibri">This is a system generated message.</span><br>';*/
                                String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                    +'The BPO Solution Plan below is ready for your review and approval. Please respond within 3 business days.'+'<br>'
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Comments by Solution Architect (SA): '+checkNullValues(reviewerList.Comments_by_SA__c)+
                                                    +'<br/>'
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'SAP OM ID: '+checkNullValues(listEmailOpp[0].SAP_OM_Opportunity__r.name)
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Client Name: '+listEmailOpp[0].Client_Name__r.name
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Opportunity Name:  '+' '+listEmailOpp[0].Name                                                 
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'BPO Net Revenue (SAP OM)(Thousands): '+checkNullValuesDeciamlTCV(listEmailOpp[0].TCV__c)
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Client Geo Area: '+listEmailOpp[0].Client_Geo_Area__r.name
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Operating Group: '+listEmailOpp[0].Operating_Group__r.name
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Offerings: '+OfferingNames
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Delivery Locations: '+checkNullValues(listEmailOpp[0].Service_Delivery_Locations_Unique__c)
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Approval Stage: '+reviewerList.Review_Process__r.Review_Stage_Master__r.name+
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp' +'Approval Type: '+reviewerList.Review_Type_Master__r.name +
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'SharePoint Link for Approval Documents: '+documentUrlList+
                                                    +'    '+'<br><br>'
                                                    +'<br>'+'<b><font color="Red">Action Required:</b></font><br>'
                                                        +'<br>'+'After reviewing the attached Solution Plan documentation please respond to this approval request either via email by selecting one of the buttons below:'+'<br>'

                                                        
                                                        // Section Start For Approve Button
                                                        +'<br><Table><tr><td width="29"></td><td><table cellspacing="0" cellpadding="0"> <tr> <td align="center" width="100" height="40" bgcolor="#C0C0C0" style="-webkit-border-radius: 5px; -moz-border-radius: 5px;' +'border-radius: 5px; color: #ffffff; display: block;">'
                                                        +'<a href="mailTo:'+System.Label.Review_and_Approval_Email+'?subject=Approved Final Review Solution - Client Name: ' +listEmailOpp[0].Client_Name__r.name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' - Opportunity Name: '+listEmailOpp[0].Name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' &body=The Solution Plan for this BPO opportunity is Approved.%0D%0A%0D%0A *Provide your comments here by replacing text in between asterisks* %0D%0A%0D%0A ===IMPORTANT Please do not edit the below section %2C it is used internally for processing.=== %0D%0A%0D%0A < Approved > %0D%0A%0D%0A Record Id :#'+reviewerList.id+'#">Approve</a>'
                                                        +'</td> </tr> </table></td><td></td>'
                                                        // Section End For Approve Button
                                                        
                                                        // Section Start For Ready For Review
                                                        +'<td><table cellspacing="0" cellpadding="0"> <tr> <td align="center" width="200" height="40" bgcolor="#C0C0C0" style="-webkit-border-radius: 5px; -moz-border-radius: 5px;' +'border-radius: 5px; color: #ffffff; display: block;">'
                                                        +'<a href="mailTo:'+System.Label.Review_and_Approval_Email+'?subject=Ready For Review Final Review Solution - Client Name: ' +listEmailOpp[0].Client_Name__r.name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29') +' - Opportunity Name: '+listEmailOpp[0].Name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' &body=The Solution Plan for this BPO opportunity is Ready For Review . See comments below.%0D%0A%0D%0A *Provide your comments here by replacing text in between asterisks* %0D%0A%0D%0A ===IMPORTANT Please do not edit the below section %2C it is used internally for processing.=== %0D%0A%0D%0A < Ready For Review > %0D%0A%0D%0A Record Id :#'+reviewerList.id+'#">Ready For Review </a>'
                                                        +'</td> </tr> </table></td>'
                                                        // Section End For Ready For Review                                                       
                                                        
                                                        
                                                        // Section Start For Reject Button
                                                        +'<td><table cellspacing="0" cellpadding="0"> <tr> <td align="center" width="100" height="40" bgcolor="#C0C0C0" style="-webkit-border-radius: 5px; -moz-border-radius: 5px;' +'border-radius: 5px; color: #ffffff; display: block;">'
                                                        +'<a href="mailTo:'+System.Label.Review_and_Approval_Email+'?subject=Rejected Final Review Solution - Client Name: ' +listEmailOpp[0].Client_Name__r.name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29') +' - Opportunity Name: '+listEmailOpp[0].Name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' &body=The Solution Plan for this BPO opportunity is Rejected. See comments below.%0D%0A%0D%0A *Provide your comments here by replacing text in between asterisks* %0D%0A%0D%0A ===IMPORTANT Please do not edit the below section %2C it is used internally for processing.=== %0D%0A%0D%0A < Rejected > %0D%0A%0D%0A Record Id :#'+reviewerList.id+'#">Reject</a>'
                                                        +'</td> </tr> </table></td><td></td>'
                                                        // Section End For Reject Button
                                                        
                                                        // Section Start For Rework Button
                                                        +'<td><table cellspacing="0" cellpadding="0"> <tr> <td align="center" width="100" height="40" bgcolor="#C0C0C0" style="-webkit-border-radius: 5px; -moz-border-radius: 5px;' +'border-radius: 5px; color: #ffffff; display: block;">'
                                                        +'<a href="mailTo:'+System.Label.Review_and_Approval_Email+'?subject=Rework Final Review Solution - Client Name: ' +listEmailOpp[0].Client_Name__r.name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29') +' - Opportunity Name: '+listEmailOpp[0].Name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' &body=The Solution Plan for this BPO opportunity requires Rework. See comments below.%0D%0A%0D%0A *Provide your comments here by replacing text in between asterisks* %0D%0A%0D%0A ===IMPORTANT Please do not edit the below section %2C it is used internally for processing.=== %0D%0A%0D%0A < Rework > %0D%0A%0D%0A Record Id :#'+reviewerList.id+'#">Rework</a>'
                                                        +'</td> </tr> </table></td><td></td></tr></table>'
                                                        // Section End For Rework Button 
                                                                                                           
                                                        
                                                        
                                                    +'<br>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'<b>Approve = </b>'+'Solution Plan documentation is accurate'
                                                    +'<br>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'<b>Ready for Review = </b>'+'One or more open items need to be discussed and closed during Approval Call (describe in comments)</b>'                                                    
                                                    +'<br>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'<b>Reject = </b>'+'You do not approve the Solution Plan documentation</b>' 
                                                    +'<br>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'<b>Rework = </b>'+'Solution Plan documentation needs to be updated before it can be approved</b>'+'<br>'                                                 
                                                    +'    '+'<br>'   
                                                    +'Or via the Solution Workbench <i>(option for those who have a workbench license)</i>'  
                                                    +'<br><br>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Link to' + '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+opportunityId+'&id='+reviewProcessId+'" target="_parent"> Opportunity Approval tab </a>'                                           
                                                    +'    '+'<br>'
                                                    +'<br>'+'Review the '+'<a href ="https://kxsites.accenture.com/groups/BPOSA/Adverts/BPO%20Solution_Workbench%20Training%20-%20Approvers.pptx">job aid</a>'+' for more information on Reviewing and Approving BPO Opportunities.'+'<br><br>'                                            
                                                    +'<br/><b><font color="Red">IMPORTANT Please do not edit the below section, it is used internally for processing.</font></b>'+'<br>'
                                                    +'Record Id :#'+reviewerList.id+'#'
                                                    +'    '+'<br><br>'
                                                    +'    '+'<br>This is a system generated message.<br></span>';                                                                        
                                mail.setHtmlBody(htmlEmailBody);
                                //mail.setFileAttachments(attachList); 
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 

                                
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.label.Approval_request_sent_to_Reviewer_s_successfully));
                                //insert approval email sent on field
                                reviewerList.Approval_email_sent_on__c=system.today();
                                //change the version
                                if(reviewerList.status__c!=null)
                                {
                                    reviewerList.version__c = reviewerList.version__c + 1;
                                }
                                //change the status as pending
                                reviewerList.status__c=UTIL_constants.PENDING;
                                reviewerList.Approval_Requestor__c= UserInfo.getUserId();
                                reviewerList.Select_reviewer__c=false;
                                
                                reqRevList.add(reviewerList);
                                
                                //Database.upsert(reviewerList);
                                
                                
                                
                                /*Review_Action_Item_Log__c newActionLog=new Review_Action_Item_Log__c ();
                                newActionLog.Event_date__c=reviewerList.Approval_email_sent_on__c;
                                newActionLog.User__c=UserInfo.getUserId();
                                newActionLog.Request_Review__c=reviewerList.id;
                                newActionLog.Review_Process__c=reviewerList.Review_Process__c;
                                newActionLog.Issue_Status__c='In Progress';
                                upsert newActionLog;
                                if(reviewDoc.size()>0)
                                {
                                    for(Document_for_Request_Review__c d : reviewDoc)
                                    {
                                        Review_files_attachment__c newReviewFile=new Review_files_attachment__c();
                                        newReviewFile.Document_for_Request_Review__c = d.id;
                                        newReviewFile.Request_Review__c=reviewerList.id;
                                        newReviewFile.Review_Action_Item_Log__c=newActionLog.id;
                                        upsert newReviewFile;
                                    }
                                }*/
                                ////--Task Creation Code----
                               
                                   //  if(reviewerList.Review_Type_Master__r.name ==UTIL_constants.FINAL_APROVAL)
                                    // {
                                        
                                         //List<Task> myTask1=[Select id, Approval_Status__c from Task where Request_Review_Id__c=:reviewerList.id];
                                        
                                        List<Task> myTask = myTaskMap.get(reviewerList.id);
                                        
                                         
                                         if(myTask != null && myTask.size()>0)
                                         {
                                            
                                             myTask[0].Approval_Status__c = UTIL_constants.PENDING;
                                             myTask[0].Approval_email_sent_on__c=reviewerList.Approval_email_sent_on__c; 
                                             //Database.upsert(myTask[0]);    
                                             myTaskListToUpdate.add(myTask[0]);
                                         }
                                         else
                                         {
                                             if(reviewerList.Review_User_Master__r.SFDC_User__r.IsActive) {
                                                 Task objTask= new Task();
                                                 
                                                 objTask.Request_Review_Id__c=reviewerList.id;
                                                 objTask.Subject = UTIL_constants.REVIEW_AND_APPROVAL;
                                                 objTask.Approval_Status__c = UTIL_constants.PENDING;
                                                 //objTask.ownerId = UserInfo.getUserId();
                                                 objTask.ownerId = reviewerList.Review_User_Master__r.SFDC_User__c;
                                                 objTask.Status = UTIL_constants.CLOSED;
                                                 objTask.Approval_email_sent_on__c=reviewerList.Approval_email_sent_on__c;
                                                 
                                                 objTask.Reviewer_Id__c=reviewerList.Review_User_Master__c;     
                                                 objTask.Review_Process_Id__c=reviewerList.Review_Process__c; //add by vinay chada
                                                 objTask.Email_ID_of_the_reviewer__c=usrtList[0].Email_ID_of_the_reviewer__c;  
        
                                                // List<Opportunity_TGP__c> oppList=[select Client_Name__c,name from Opportunity_TGP__c where id=:opportunityId];                                
                                                 objTask.Opportunity_Name__c=listEmailOpp[0].Name;
                                                 objTask.Client_Name__c=listEmailOpp[0].Client_Name__r.name;
                                                 objTask.Review_Type__c=reviewerList.Review_Type_Master__r.name;
                                                 objTask.Opportunities_Rivew_And_Approval__c=URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RequsetReviewAdd_Inline?oppid='+opportunityId+'&id='+reviewProcessId+'&var='+'false';
                                                 
                                                 //Database.upsert(objTask);
                                                 myTaskListToUpdate1.add(objTask);
                                             }
                                         }
                                         //List<Task> TaskID=[Select id, Approval_Status__c from Task where Request_Review_Id__c=:reviewerList.id];
                                    /*     if(TaskID.size()>0)
                                         {
                                                reviewerList.Task_ID__c = TaskID[0].id;
                                                
                                                upsert reviewerList;    
                                         } */
                                         
                                         isTaskCreated=true;
                                   //  }
                            }
                            catch(Exception ex)
                            {   
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Failure_in_sending_Email+ex)); 
                                return;
                            }                   
                        }
                    } 
                    
                    
                    Database.upsert(reqRevList);
                    Database.upsert(myTaskListToUpdate);
                    Database.upsert(myTaskListToUpdate1);
                    
                   if(isReviweerSelected==false)
                    {    //add by vinay Chada
                        if(isStatusNull==true){ 
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_select_Reviewer_s_to_continue)); 
                            return;
                        }else{
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.No_Records_are_there_for_sending_the_Approval_mail)); 
                            return;
                        }
                    }
                   
                    
                }
                
            }
            
            
            /******************************
            Method Name: sendEmailForReminder
            Description: This method is used send reminder Email.
            Paramenters: NA
            Return Value: void
            *******************************/
            public void sendEmailForReminder()
            {
                String documentUrlList = '';
                list<string> listOfDocId =new list<string>();
                list<Document> docList =new list<Document>();
                list<Review_User_Master__c> usrtList=new list<Review_User_Master__c>();
                list<Opportunity_Document__c> reviewDoc=new list<Opportunity_Document__c>();
                list<Request_Review__c> reqRevList = new list<Request_Review__c>();
                boolean isReviweerSelected=false;
                boolean isStatusPending=false;
                List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                List<Opportunity_TGP__c> listEmailOpp = [Select o.TCV__c,o.Service_Delivery_Locations_Unique__c, o.SAP_OM_Opportunity__r.name, o.SAP_OM_ID__c, o.Operating_Group__r.name, o.Offerings__c, o.Name, o.Id, o.Client_Name__r.name,o.Client_Geo_Area__r.name,o.Stage__c,o.Client_Geo_Unit__r.name From Opportunity_TGP__c o where o.Id = : opportunityId];
                
                list<Review_User_Master__c> revUserList=[select id,Email_ID_of_the_reviewer__c from Review_User_Master__c ];
        
                Map<id,List<Review_User_Master__c>> reviewUserMasterMap = new Map<id,List<Review_User_Master__c>>();
                
                for(Review_User_Master__c reviewUserMasterrec : revUserList){
                    
                    List<Review_User_Master__c> reviewUserMasterList = new List<Review_User_Master__c>{reviewUserMasterrec};
                    
                    reviewUserMasterMap.put(reviewUserMasterrec.id,reviewUserMasterList);
                }
                //select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c 
                List<OrgWideEmailAddress> owearec = [select Id,Address from OrgWideEmailAddress];
        
                Map<id, List<OrgWideEmailAddress>> oweaRecMap = new Map<id, List<OrgWideEmailAddress>>();
                
                for(OrgWideEmailAddress myowearec : owearec){
                    
                    List<OrgWideEmailAddress> myOweaRecList = new List<OrgWideEmailAddress>{myowearec};
                    
                    oweaRecMap.put(myowearec.id,myOweaRecList);
                }
                
                if(listOpportunityDocument.size()>0)
                {
                    for(Opportunity_Document__c doc1List : listOpportunityDocument)
                    {
                        //document which is selected to send with email
                        if(doc1List.Select_document__c==true)
                        {
                            //list of ids of documents to be send with mail
                            //listOfDocId.add(doc1List.Document_id__c); 
                            reviewDoc.add(doc1List);   
                        }
                    }
                }
                /*if(listOfDocId.size()>0)
                {
                    //list of documents to be attached with mail
                    docList=[select id, name, body, contenttype, developername, type from Document where id IN :listOfDocId];
                }*/
                if(newRequestReviewList.size()>0)
                {
                    for(Request_Review__c reviewerList : newRequestReviewList)
                    {
                        if(reviewerList.status__c==UTIL_constants.PENDING)
                        {
                            isStatusPending=true;
                        }
                        //review record which is selected to send email
                        if(reviewerList.Send_reminder__c==true && reviewerList.status__c==UTIL_constants.PENDING)
                        {
                            isReviweerSelected=true;
                          //  Messaging.EmailFileAttachment [] attachList=new Messaging.EmailFileAttachment[]{};      
                          //  Messaging.EmailFileAttachment attach ;
                            if(reviewDoc.size()>0)
                            {
                                reviewerList.Document_Name__c=null;
                                Integer i = 1;
                                for(Opportunity_Document__c tempDoc : reviewDoc)
                                {
                                    //attachement
                                   // attach = new Messaging.EmailFileAttachment(); 
                                  //  attach.setContentType(tempDoc.contentType);
                                  //   attach.setFileName(tempDoc.name);//+'.'+tempDoc.type); //added by Vinay Chada for defect no : D-1111
                                 //   attach.setInline(false);
                                 //   attach.Body = tempDoc.Body;   
                                 //   attachList.add(attach);
                                    if(reviewDoc.size() == i) {
                                        documentUrlList += '<a href="' + tempDoc.Document_Link__c + '">'+ tempDoc.Name +'</a>';
                                    }
                                    else {
                                       documentUrlList += '<a href="' + tempDoc.Document_Link__c + '">'+ tempDoc.Name +'</a>' + ' , ';
                                       i = 1 + 1; 
                                    }
                                    if(reviewerList.Document_Name__c!=null)
                                    {
                                        reviewerList.Document_Name__c=reviewerList.Document_Name__c+';'+tempDoc.name;
                                    }
                                    else
                                    {
                                        reviewerList.Document_Name__c=tempDoc.name;
                                    }
                                }       
                            }
                            try
                            {
                                //Database.upsert(reviewerList);
                                reqRevList.add(reviewerList);
                                //email to be send
                                OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
                                //List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                                if(lstIdForOWA.size()>0)
                                {
                                    //owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                                    
                                    if(oweaRecMap.containsKey(lstIdForOWA[0].OWA_id__c)){
                                        owea = oweaRecMap.get(lstIdForOWA[0].OWA_id__c);
                                    }
                                }
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                if ( owea.size() > 0 ) 
                                {
                                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                }    
                                //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                //mail.setSenderDisplayName('BPO Solution Support');  
                                mail.setUseSignature(false);
                                
                                //usrtList=[select id,Email_ID_of_the_reviewer__c from Review_User_Master__c where id =:reviewerList.Review_User_Master__c];
                                usrtList = reviewUserMasterMap.get(reviewerList.Review_User_Master__c);
                                //List<Opportunity_TGP__c> listEmailOpp = [Select o.TCV__c,o.Service_Delivery_Locations_Unique__c, o.SAP_OM_Opportunity__r.name, o.SAP_OM_ID__c, o.Operating_Group__r.name, o.Offerings__c, o.Name, o.Id, o.Client_Name__r.name,o.Client_Geo_Area__r.name,o.Stage__c,o.Client_Geo_Unit__r.name From Opportunity_TGP__c o where o.Id = : opportunityId];
                                mail.setToAddresses(new String[] { usrtList[0].Email_ID_of_the_reviewer__c });
                                
                                // below reply To is belongs to New Dev.
                                 mail.replyTo='review_and_approval@o-dz89711ud9sktmryerheqszw1fkacuyinqcpv3dqs4ixhwxr9.c-3tbhqea2.cs14.apex.sandbox.salesforce.com';
                                
                                // below reply To is belongs to UAT.                                
                                    //mail.replyTo='review_and_approval@p-t0xvn0ra7b50k2hgzgxaldthajiu2zt55wuw6pk7w2plkht7p.c-1kjexeaw.cl.apex.sandbox.salesforce.com';
                                
                                // below reply To is belongs to Prod.                                
                                //mail.replyTo='review_and_approval@e-v85ak3924wj12u9mti4uxf5unx07t62yw09up1lw3um7piux2.e-zi3zmac.e.apex.salesforce.com';
                                
                                
                               // mail.setSubject('Upload the Document for your Approval');
                                string OfferingNames =checkNullValues(listEmailOpp[0].Offerings__c);
                             /*   if(OfferingNames!=null) 
                                   { 
                
                                                    OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                    
                                    } */
                                mail.setSubject('REMINDER! Approve Final Review Solution - Client Name: '+' '+listEmailOpp[0].Client_Name__r.name+' - Opportunity Name:  '+listEmailOpp[0].Name);
                                /*String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri"></span>'+' <br>'
                                                        +' '+' <br>'
                                                        +'<span style="font-size:11pt; font-family:Calibri">This Email is to remind you that your approval is pending.</span>' +'<br>'
                                                        +'<br>'+ '<span style="font-size:11pt; font-family:Calibri">Please only reply to this email by following the below instructions:</span>' +'<br>'+
                                                        '<span style="font-size:11pt; font-family:Calibri">1. <b><<font color="Blue">Type Approved/Rejected/Rework here by replacing the Text in between brackets</font>></b> </span>'+'<br>'+
                                                        '<span style="font-size:11pt; font-family:Calibri">2. <b>*<font color="Blue">Provide your comments here by replacing Text in between asterisks</font>*</b></span>'+'<br><br>'+ 
                                                        
                                                        '    '+'<br><br><br>'
                                                        +'<br/><span style="font-size:11pt; font-family:Calibri"><b><font color="Red">Important: Please do not Edit the below Section, it is used internally for Processing.</font></b></span>'+'<br>'
                                                        +'<span style="font-size:11pt; font-family:Calibri">Record Id :#'+reviewerList.id+'#</span>'
                                                        +'    '+'<br><br><br>'
                                                        +'    '+'<br><br><br>'
                                                        +'    '+'<br><span style="font-size:11pt; font-family:Calibri">This is a system generated message. Please do not reply to this message<br></span>';*/
                                                        
                                String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                    +'This is a reminder that a Solution Plan for a BPO opportunity is ready for your review and approval. Review the information below to complete the required action within 3 business days.'+'<br>'                                  
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Comments by Solution Architect (SA): '+checkNullValues(reviewerList.Comments_by_SA__c)+
                                                    +'<br/>'
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'SAP OM ID: '+checkNullValues(listEmailOpp[0].SAP_OM_Opportunity__r.name)
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Client Name: '+listEmailOpp[0].Client_Name__r.name
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Opportunity Name:  '+' '+listEmailOpp[0].Name   
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'BPO Net Revenue (SAP OM)(Thousands): '+checkNullValuesDeciamlTCV(listEmailOpp[0].TCV__c)
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Client Geo Area: '+listEmailOpp[0].Client_Geo_Area__r.name
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Operating Group: '+listEmailOpp[0].Operating_Group__r.name
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Offerings: '+OfferingNames
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Delivery Locations: '+checkNullValues(listEmailOpp[0].Service_Delivery_Locations_Unique__c)
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Approval Stage: '+reviewerList.Review_Process__r.Review_Stage_Master__r.name+
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Approval Type: '+reviewerList.Review_Type_Master__r.name+
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'SharePoint Link for Approval Documents: '+documentUrlList+
                                                    +'    '+'<br><br>'
                                                    +'<br>'+'<b><font color="Red">Action Required:</b></font><br>'
                                                        +'<br>'+'After reviewing the attached Solution Plan documentation please respond to this approval request either via email by selecting one of the buttons below:'+'<br>'                                                        
                                                        
                                                        
                                                         // Section Start For Approve Button
                                                        +'<br><Table><tr><td width="29"></td><td><table cellspacing="0" cellpadding="0"> <tr> <td align="center" width="100" height="40" bgcolor="#C0C0C0" style="-webkit-border-radius: 5px; -moz-border-radius: 5px;' +'border-radius: 5px; color: #ffffff; display: block;">'
                                                        +'<a href="mailTo:'+System.Label.Review_and_Approval_Email+'?subject=Approved Final Review Solution - Client Name: ' +listEmailOpp[0].Client_Name__r.name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29') +' - Opportunity Name: '+listEmailOpp[0].Name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' &body=The Solution Plan for this BPO opportunity is Approved.%0D%0A%0D%0A *Provide your comments here by replacing text in between asterisks* %0D%0A%0D%0A ===IMPORTANT Please do not edit the below section %2C it is used internally for processing.=== %0D%0A%0D%0A < Approved > %0D%0A%0D%0A Record Id :#'+reviewerList.id+'#">Approve</a>'
                                                        +'</td> </tr> </table></td><td></td>'
                                                        // Section End For Approve Button
                                                        
                                                        // Section Start For Ready For Review
                                                        +'<td><table cellspacing="0" cellpadding="0"> <tr> <td align="center" width="200" height="40" bgcolor="#C0C0C0" style="-webkit-border-radius: 5px; -moz-border-radius: 5px;' +'border-radius: 5px; color: #ffffff; display: block;">'
                                                        +'<a href="mailTo:'+System.Label.Review_and_Approval_Email+'?subject=Ready For Review Final Review Solution - Client Name: ' +listEmailOpp[0].Client_Name__r.name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29') +' - Opportunity Name: '+listEmailOpp[0].Name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' &body=The Solution Plan for this BPO opportunity is Ready For Review. See comments below.%0D%0A%0D%0A *Provide your comments here by replacing text in between asterisks* %0D%0A%0D%0A ===IMPORTANT Please do not edit the below section %2C it is used internally for processing.=== %0D%0A%0D%0A < Ready For Review > %0D%0A%0D%0A Record Id :#'+reviewerList.id+'#">Ready For Review </a>'
                                                        +'</td> </tr> </table></td>'
                                                        // Section End For Ready For Review
                                                        
                                                        // Section Start For Reject Button
                                                        +'<td><table cellspacing="0" cellpadding="0"> <tr> <td align="center" width="100" height="40" bgcolor="#C0C0C0" style="-webkit-border-radius: 5px; -moz-border-radius: 5px;' +'border-radius: 5px; color: #ffffff; display: block;">'
                                                        +'<a href="mailTo:'+System.Label.Review_and_Approval_Email+'?subject=Rejected Final Review Solution - Client Name: ' +listEmailOpp[0].Client_Name__r.name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29') +' - Opportunity Name: '+listEmailOpp[0].Name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' &body=The Solution Plan for this BPO opportunity is Rejected. See comments below.%0D%0A%0D%0A *Provide your comments here by replacing text in between asterisks* %0D%0A%0D%0A ===IMPORTANT Please do not edit the below section %2C it is used internally for processing.=== %0D%0A%0D%0A < Rejected > %0D%0A%0D%0A Record Id :#'+reviewerList.id+'#">Reject</a>'
                                                        +'</td> </tr> </table></td><td></td>'
                                                        // Section End For Reject Button
                                                        
                                                        // Section Start For Rework Button
                                                        +'<td><table cellspacing="0" cellpadding="0"> <tr> <td align="center" width="100" height="40" bgcolor="#C0C0C0" style="-webkit-border-radius: 5px; -moz-border-radius: 5px;' +'border-radius: 5px; color: #ffffff; display: block;">'
                                                        +'<a href="mailTo:'+System.Label.Review_and_Approval_Email+'?subject=Rework Final Review Solution - Client Name: ' +listEmailOpp[0].Client_Name__r.name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' - Opportunity Name: '+listEmailOpp[0].Name.replace('&','%26').replace(',','%2C').replace('(','%28').replace(')','%29')+' &body=The Solution Plan for this BPO opportunity requires Rework. See comments below.%0D%0A%0D%0A *Provide your comments here by replacing text in between asterisks* %0D%0A%0D%0A ===IMPORTANT Please do not edit the below section %2C it is used internally for processing.=== %0D%0A%0D%0A < Rework > %0D%0A%0D%0A Record Id :#'+reviewerList.id+'#">Rework</a>'
                                                        +'</td> </tr> </table></td><td></td></tr></table>'
                                                        // Section End For Rework Button 
                                                                                                           
                                                        
                                                        
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'<b>Approve = </b>'+'Solution Plan documentation is accurate'
                                                     +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'<b>Ready for Review = </b>'+'One or more open items need to be discussed and closed during Approval Call (describe in comments)</b>'
                                                      +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'<b>Reject = </b>'+'You do not approve the Solution Plan documentation</b>'
                                                    +'<br> &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'<b>Rework = </b>'+'Solution Plan documentation needs to be updated before it can be approved</b>'+'<br>'                                                                                                     
                                                     +'    '+'<br>'   
                                                    +'Or via the Solution Workbench <i>(option for those who have a workbench license)</i>'  
                                                    +'<br><br>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp'+'Link to' + '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+opportunityId+'&id='+reviewProcessId+'" target="_parent"> Opportunity Approval tab </a>'                                           
                                                    +'    '+'<br>'
                                                    +'<br>'+'Review the '+'<a href ="https://kxsites.accenture.com/groups/BPOSA/Adverts/BPO%20Solution_Workbench%20Training%20-%20Approvers.pptx">job aid</a>'+' for more information on Reviewing and Approving BPO Opportunities.'+'<br><br>'                                       
                                                    +'<br/><b><font color="Red">IMPORTANT Please do not edit the below section, it is used internally for processing.</font></b>'+'<br>'
                                                    +'Record Id :#'+reviewerList.id+'#'
                                                    +'    '+'<br><br>'
                                                    +'    '+'<br>This is a system generated message.<br></span>';                           
                                mail.setHtmlBody(htmlEmailBody);
                                //mail.setFileAttachments(attachList); 
                                System.debug('-----mail------------->>>>>>>>>>'+mail);
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Reminder request sent to Reviewer(s) successfully'));
        
                                /*Review_Action_Item_Log__c newActionLog=new Review_Action_Item_Log__c ();
                                newActionLog.Event_date__c=system.today();
                                newActionLog.User__c=UserInfo.getUserId();
                                newActionLog.Request_Review__c=reviewerList.id;
                                newActionLog.Review_Process__c=reviewerList.Review_Process__c;
                                newActionLog.Issue_Status__c='In Progress';
                                upsert newActionLog;
                                if(reviewDoc.size()>0)
                                {
                                    for(Document_for_Request_Review__c d : reviewDoc)
                                    {
                                        Review_files_attachment__c newReviewFile=new Review_files_attachment__c();
                                        newReviewFile.Document_for_Request_Review__c = d.id;
                                        newReviewFile.Request_Review__c=reviewerList.id;
                                        newReviewFile.Review_Action_Item_Log__c=newActionLog.id;
                                        upsert newReviewFile;
                                    }
                                }*/
                                
                                
                            }
                            catch(Exception ex)
                            {   
                                system.debug('-------ex------'+ex);
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Failure_in_sending_Email)); 
                                return;
                            }                    
                        }
                    } 
                    Database.upsert(reqRevList);
                    
                    if(isReviweerSelected==false)
                    {
                        if(isStatusPending==true){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.Please_select_Reviewer_s_to_continue)); 
                            return;
                        }else{
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.No_Records_are_there_for_sending_the_reminder_mail)); 
                            return;
                        }
                    }
                }
            }
            //SOL_141 Start
        
        
    /*    public void checkUsersAccessbity() {
            currentUserName=UserInfo.getName();
            profileName=null;
            userList = new List<User>();
            userList=[SELECT Email,Profile.Name FROM User where id=:UserInfo.getUserId()];  
            if(userList.size()>0) {
                profileName=userList[0].Profile.Name;   
                if(profileName!=null && profileName == 'Solution Leadership') {
                    deleteButtonRender=true;
                    saveEditButtonRender=true;
                    addButtonRender=false;
                }
            }            
        } */
        
        
        
        //SOL_141 End
         /******************************
        Method Name: checkNullValues
        Description: Method to check null and return empty string.
        Paramenters: String
        Return Value: String 
        *******************************/
        public Static String checkNullValues(String value)
        {
            if(value==null)
                return '  ';
            else
                return value;
            
        } 
         /******************************
        Method Name: checkNullValuesDecimalTCV
        Description: Method to check null and return empty string.
        Paramenters: String
        Return Value: String 
        *******************************/
        public Static String checkNullValuesDeciamlTCV(Decimal value)
        {
            if(value==null)
                return '  ';
            else
                 return ''+ '$' +String.ValueOf(value.setScale(0).format());// Code added by Ayush for D - 1791 A
            
        } 
        }