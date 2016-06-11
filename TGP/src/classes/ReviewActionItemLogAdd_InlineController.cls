/*
Author : Sanjay Kumar Das
Story  : Story-0307/SOL_139  
Description : Create/maintain Action Item Log. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013           Sol UAM-Release 2
Shridhar Patankar    Sol_165               7/06/2013           Email templates for send remainder and to PMO group
*/
public with sharing class ReviewActionItemLogAdd_InlineController {
    public String hiddenNavigator1{get;set;}
    public String hiddenNavigator2{get;set;}
    public String OppId{get;set;}
    public String reviewProcessId{get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean addButtonRender {get; set;}
    public String userProfileName {get;set;}
    public String category{get;set;}
    public Review_Action_Item_Log__c newProfDetail {get;set;}
    public Review_Action_Item_Log__c[] listProfileDetailsActual {get;set;}
    public Boolean keyBuyerMessage{get;set;}
    public String fileIdDelete ;
    public String testurl{get;set;}
    public Boolean variable{get;set;}
    public Document doc{get;set;}
    public Document_for_Request_Review__c newDocumentforRequestReview{get;set;}
    public String ReviewType{get;set;}
    public string opportunityId{get;set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean deleteButtonRender {get; set;}
    public Boolean isEdit{get;set;}
    public Boolean isOutput{get;set;}
    public list<Review_Action_Item_Log__c> newRequestReviewList{get;set;}
    public String SolUserName{get;set;}
    public String currentUserName{get;set;}
    public Boolean isGenerateReportButton{get;set;}
    public String recordId{get;set;}
    public string DocumentrecordIdToDelete {get;set;}
    public string recordIdToDelete{get;set;}
    public Review_Action_Item_Log__c[] oldReviewActionLog {get;set;}
    public static String strUrl{get;set;}
    public Boolean readOnlyMode{get;set;}
    public String fileId{get;set;}
    public String result{get;set;}
    public String reportId{get;set;}
    public List<Opportunity_TGP__c> lstOpp{get;set;}
    public  static List<Opportunity_Offering__c > offeringsForLocation = new List<Opportunity_Offering__c >();
    /******************************
    Method Name: ReviewActionItemLogAdd_InlineController 
    Description: Constructor for ReviewActionItemLogAdd_InlineController
    Paramenters: stdCon
    Return Value: void
    *******************************/
    
    public ReviewActionItemLogAdd_InlineController(ApexPages.StandardController stdCon)
    {
        strUrl = URL.getSalesforceBaseUrl().toExternalForm();
        reviewProcessId= ApexPages.CurrentPage().getParameters().get('id');
       
        opportunityId=ApexPages.CurrentPage().getParameters().get('oppId');
        newProfDetail = new Review_Action_Item_Log__c();
        newDocumentforRequestReview= new Document_for_Request_Review__c();
        doc=new Document ();    
        initializeDetailRecords();        
        //UAM Code--Mayank Tayal-Sol_148
        if(opportunityId!=null)
        {
            lstOpp = [select id, name from Opportunity_TGP__c where id = : opportunityId];
            /*String strOppId = lstOpp.get(0).id;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Review_Action_Item_Log__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U');
            deleteButtonRender = m.get('D'); */
            addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
            saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
            deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
            
         }  
         //SOL_141 Start
        /* UAM Sol RV List<userRole> role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];        
             if(role.size()>0)
                {
                    if(role[0].name!=null && role[0].name.equalsIgnoreCase('Operations'))
                         {
                           addButtonRender=false;
                           saveEditButtonRender=false;
                           deleteButtonRender=false;
                           isEdit=false;
                           isOutput=true;
                           isGenerateReportButton=false;
                         }
                }
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if(userProfileName.equalsIgnoreCase('Workbench Administrator'))
        {
            addButtonRender=true;
            saveEditButtonRender=true;
            deleteButtonRender=true;
        }*/
        
        userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if(userProfileName.equalsIgnoreCase(System.Label.Solution_Admin) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN))
        {
            addButtonRender=true;
            saveEditButtonRender=true;
            deleteButtonRender=true;
        }
        
        if(addButtonRender==false && saveEditButtonRender==false)
        {
            readOnlyMode=true;
        } 
        //SOL_141 End   
        
        List<Action_Item_Log_Report_ID__c> lstIdForReport =[select id, Report_Id__c from Action_Item_Log_Report_ID__c];
        if(lstIdForReport.size()>0)
        {
            reportId=lstIdForReport[0].Report_Id__c+ '?pv0=' +reviewProcessId;
        }
        
        getListOfActionItemLog();
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
        if(ReviewType=='None')
        {
            TypeName.add(new SelectOption('None','--None--'));
            return TypeName;
        }
        List <Review_Type_Master__c > tempReviewType=[select id,name from Review_Type_Master__c where active__c=:true];        
        if(tempReviewType.size()>0)
        {
            for(Review_Type_Master__c r : tempReviewType)
            {
                TypeName.add(new SelectOption(r.id, r.name)); 
            }
        }
        return TypeName;
    }
     
    /******************************
    Method Name: addNewProfDetail
    Description: To add records in Action Item Log
    Paramenters: NA
    Return Value: void
    *******************************/
    public void addNewProfDetail() 
    {
        newProfDetail.Review_Type_Master__c=ReviewType;
        newProfDetail.Review_Process__c=reviewProcessId;
        
         if(newProfDetail.Description__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Description cannot be left blank'));  
            return;  
        } 
        
        //if(newProfDetail.User__c==null) commented to fix 1808D
        if(newProfDetail.Primary_Owner__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Primary Owner cannot be left blank'));  
            return;  
        } 
        if(newProfDetail.Due_date__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Due Date cannot be left blank'));  
            return;  
         }
         if( newProfDetail.Due_date__c<Date.today())
            {
               
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Due Date should be greater than or equal to today\'s date'));
                return;
            }
        try
            {
               if(newProfDetail!=null) 
                {
                     insert newProfDetail;
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully'));
                }
            else
                {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Add Action Item Log'));
                }
        }
        catch(exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'failure in adding record'));
            return;
        }
        finally
        {
            newProfDetail = new Review_Action_Item_Log__c();
        }
        initializeDetailRecords();
        return;
    }
    
    /******************************
    Class Name: fileInfo
    Description: This class hold the information of atttached file name
    *******************************/  
    public class fileInfo
    {
        public string fileName{get;set;}
        public string fileId{get;set;}
        public fileInfo(string fileName, string fileId)
        {
            this.fileName=fileName;
            this.fileId=fileId;
        }
    }
    /******************************
    Class Name: ActionItemLog
    Description: This class hold the information of User
    *******************************/   
    public class ActionItemLog
    {
        public Review_Action_Item_Log__c  newActionItemLog{get; set;}
        public boolean userName1{get;set;}
        public boolean userName2{get;set;}
        public boolean enableDisableFlag{get;set;}
        public list<fileInfo> docList {get;set;}
        //Constructor for ActionItemLog
        public ActionItemLog(Review_Action_Item_Log__c  newActionItemLog,boolean userName1,boolean userName2,list<fileInfo> docList,boolean enableDisableFlag)
        {
            this.newActionItemLog=newActionItemLog;
            this.userName1=userName1; 
            this.userName2=userName2;
            this.docList=docList;
            this.enableDisableFlag =enableDisableFlag;  
        }  
    }
  /******************************
    Method Name: getListOfActionItemLog
    Description: This method get the list of Added Action Item Log
    Paramenters: NA
    Return Value: List<ActionItemLog>
  *******************************/   
    public List<ActionItemLog> getListOfActionItemLog()
    {
        List<ActionItemLog> listOfActionItemLog=new List<ActionItemLog>();
        List<Review_files_attachment__c> attList=[select Document_for_Request_Review__c,Document_for_Request_Review__r.Document_Name__c,Review_Action_Item_Log__c,Document_for_Request_Review__r.Document_id__c from Review_files_attachment__c limit 100];
        
        addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
        saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
        deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
        
        //String userName = UserInfo.getUserName();
       // User activeUser = [Select id,Email From User where Username = : userName limit 1];
        String userId = UserInfo.getUserId(); 
        
        List<Opportunity_Team__c> oppTeam = [select Client_Name__c,Opportunity_Team_Member__c,Opportunity_Solution_Lead__c,Roles__c from Opportunity_Team__c where 
                                                    Opportunity_Team_Member__r.SFDC_User__c =: userId and BPO_Opportunity__c =: opportunityId];
        
       List<Opportunity_Offering__c>  listOffering = [select id,Opportunity_TGP__c,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__c,Technical_Architect_New__c,Domain_Expert_Functional_Architect_New__c,
                                                                Functional_Architect_Mobilization_New__c,Solution_Specialist_New__c from Opportunity_Offering__c 
                                                                where (Solution_Lead_New__r.SFDC_User__c =:userId or
                                                                Offering_Solution_Lead_Secondary_New__r.SFDC_User__c =:userId or
                                                                Technical_Architect_New__r.SFDC_User__c =:userId or
                                                                Domain_Expert_Functional_Architect_New__r.SFDC_User__c =:userId or
                                                                Functional_Architect_Mobilization_New__r.SFDC_User__c =:userId or
                                                                Solution_Specialist_New__r.SFDC_User__c =:userId) and Opportunity_TGP__c =: opportunityId];
       List<Opportunity_TGP__c>  listOpp = [select Enterprise_Solution_Architect_New__r.SFDC_User__c from Opportunity_TGP__c 
                                                                where (Enterprise_Solution_Architect_New__r.SFDC_User__c= :userId) and id =: opportunityId ];                                                               
       if((userProfileName != null && userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN)) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || (userProfileName != null && userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN)) || listOffering.size() > 0 || listOpp.size() > 0 || oppTeam.size() > 0)
        {
            if(listProfileDetailsActual.size()>0)
            {
                System.debug('--------listOffering-----'+listOffering);
                saveEditButtonRender = true;
                addButtonRender = true;
                 for(Review_Action_Item_Log__c l : listProfileDetailsActual )
                {
                    boolean uname1=null;
                    boolean uname2=null;
                    boolean enableDisableFlag = true;
                    
                    list<fileInfo> fileList=new list<fileInfo>();
                    
                    if(l.User__c!=null && l.Primary_Owner__c==null)
                    {
                        uname1=true;
                        uname2=false;    
                    }
                    if(l.User__c==null && l.Primary_Owner__c!=null)
                    {
                        uname1=false; 
                        uname2=true;   
                    }
                    if(attList.size()>0)
                    {
                        for(Review_files_attachment__c a : attList)
                        {
                            if(l.id==a.Review_Action_Item_Log__c)
                            {
                                fileList.add(new fileInfo(a.Document_for_Request_Review__r.Document_Name__c,a.Document_for_Request_Review__r.Document_id__c));             
                            }    
                        }
                    }
                    listOfActionItemLog.add(new ActionItemLog(l,uname1,uname2,fileList,enableDisableFlag));
                } 
            }
        }        
        else if(userProfileName != null && (userProfileName.equalsIgnoreCase(UTIL_Constants.PMO) || userProfileName.equalsIgnoreCase('Workbench User') || userProfileName.equalsIgnoreCase('IS Workbench User')))
        {
            if(listProfileDetailsActual.size()>0)
            {
                for(Review_Action_Item_Log__c l : listProfileDetailsActual )
                {
                    boolean uname1=null;
                    boolean uname2=null;
                    boolean enableDisableFlag = true;
                    
                    list<fileInfo> fileList=new list<fileInfo>();
                    
                    if(l.User__c!=null && l.Primary_Owner__c==null)
                    {
                        uname1=true;
                        uname2=false;    
                    }
                    if(l.User__c==null && l.Primary_Owner__c!=null)
                    {
                        uname1=false; 
                        uname2=true;   
                    }
                    if(attList.size()>0)
                    {
                        for(Review_files_attachment__c a : attList)
                        {
                            if(l.id==a.Review_Action_Item_Log__c)
                            {
                                fileList.add(new fileInfo(a.Document_for_Request_Review__r.Document_Name__c,a.Document_for_Request_Review__r.Document_id__c));             
                            }    
                        }
                    }
                    if(l.Primary_Owner__r.SFDC_User__c != null && l.Primary_Owner__r.SFDC_User__c == userId)
                    {
                        enableDisableFlag = true;
                        readOnlyMode = false;
                            
                        if(!saveEditButtonRender)
                        {
                            saveEditButtonRender = true;                            
                        }else
                        {
                            addButtonRender = true;
                        }
                    }
                    else {
                        
                        enableDisableFlag = false;
                    }
                    
                    listOfActionItemLog.add(new ActionItemLog(l,uname1,uname2,fileList,enableDisableFlag));
                      
                } 
            }
            
        }
        else
        {
            if(listProfileDetailsActual.size()>0)
            {
                for(Review_Action_Item_Log__c l : listProfileDetailsActual )
                {
                    boolean uname1=null;
                    boolean uname2=null;
                    boolean enableDisableFlag = false;
                    
                    list<fileInfo> fileList=new list<fileInfo>();
                    if(l.User__c!=null && l.Primary_Owner__c==null)
                    {
                        uname1=true;
                        uname2=false;    
                    }
                    if(l.User__c==null && l.Primary_Owner__c!=null)
                    {
                        uname1=false; 
                        uname2=true;   
                    }
                    if(attList.size()>0)
                    {
                        for(Review_files_attachment__c a : attList)
                        {
                            if(l.id==a.Review_Action_Item_Log__c)
                            {
                                fileList.add(new fileInfo(a.Document_for_Request_Review__r.Document_Name__c,a.Document_for_Request_Review__r.Document_id__c));             
                            }    
                        }
                    }
                     if(l.Primary_Owner__r.SFDC_User__c != null && l.Primary_Owner__r.SFDC_User__c == userId )
                    {
                        enableDisableFlag = true;
                        readOnlyMode = false;
                        if(!saveEditButtonRender)
                        {
                            saveEditButtonRender = true;
                            
                        }else
                        {
                            addButtonRender = true;
                        }
                    }
                    
                    listOfActionItemLog.add(new ActionItemLog(l,uname1,uname2,fileList,enableDisableFlag));
                } 
            }
        }
        
        return listOfActionItemLog;
    }
    
    /******************************
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
     public void initializeDetailRecords() 
     {
        listProfileDetailsActual = new List<Review_Action_Item_Log__c>();
         doc=new Document();    
        //SOSL for Action Item Log.
        for(Review_Action_Item_Log__c profDet : [Select Review_Process__c,Primary_Owner__r.SFDC_User__c, Review_Process__r.BPO_Opportunity__r.Risk_Level__c,
                                                    Review_Process__r.BPO_Opportunity__r.Service_Delivery_Locations_Unique__c,
                                                    Review_Process__r.BPO_Opportunity__r.Client_Geo_Area__r.name, 
                                                    Review_Process__r.BPO_Opportunity__r.Stage__c, Review_Process__r.BPO_Opportunity__r.Expected_contract_sign_qtr__c, 
                                                    Review_Process__r.BPO_Opportunity__r.Client_Geo_Area_Prior_Value__c, Review_Process__r.BPO_Opportunity__r.TCV__c,  
                                                    Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.Name, Review_Process__r.Review_Stage_Master__r.Name,
                                                     Review_Process__r.BPO_Opportunity__r.Offerings__c , Review_Process__r.BPO_Opportunity__r.Client_Name__r.name, 
                                                     Review_Process__r.BPO_Opportunity__r.Name,id,Review_Type_Master__c,Review_Type_Master__r.name,File_id__c,
                                                     Primary_Owner__r.name,User__c,User__r.name,Action__c,Comments__c,Description__c,Due_date__c, 
                                                     Event_date__c,Issue_Status__c,Primary_Owner__c,Send__c,Attached_File_Name__c,Review_Type__c 
                                                     from Review_Action_Item_Log__c where Review_Process__c=:reviewProcessId order by createddate desc]) 
        {
            listProfileDetailsActual.add(profDet);
        }
        
    }
    /******************************
    Method Name: saveAccProfileDetails
    Description: For saving records in Action Item Log.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveAccProfileDetails()
    {
    
    List<Review_Action_Item_Log__c> oldActionItemLogRecords = [Select id,Review_Type_Master__c,Review_Type_Master__r.name,
                                                                File_id__c,Primary_Owner__r.name,User__c,User__r.name,
                                                                Action__c,Comments__c,Description__c,Due_date__c, 
                                                                Event_date__c,Issue_Status__c,Primary_Owner__c,Send__c,
                                                                Attached_File_Name__c,Review_Type__c from Review_Action_Item_Log__c
                                                                 where Review_Process__c=:reviewProcessId order by createddate desc];
    
    
        if(listProfileDetailsActual.size()>0)
        {
            for(Review_Action_Item_Log__c l : listProfileDetailsActual)
            {
                if(l.Description__c==null)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Description cannot be left blank'));  
                    return;  
                }
                //if(l.User__c==null)
                if(l.Primary_Owner__c==null)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Primary Owner cannot be left blank'));  
                    return;  
                }
                 if(oldActionItemLogRecords.size()>0)
                  {
                    for(Review_Action_Item_Log__c r : oldActionItemLogRecords)
                        {
                             if(l.id==r.id)
                             {
                                if(l.Due_date__c!=r.Due_date__c)
                                  {
                                    if(l.Due_date__c==null)
                                         {
                                             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Due Date cannot be left blank'));  
                                            return;  
                                         }
                                    if(l.Due_date__c<Date.today())
                                      {
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Due Date should be greater than or equal to today\'s date'));  
                                       return;
                                      }
                                    
                                  }
                              }
                         }
                    }
                if(l.Issue_Status__c==null)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Status cannot be left blank'));  
                    return;  
                }    
            }
            Review_Action_Item_Log__c[] profDetailsToUpsert = new Review_Action_Item_Log__c[]{};        
            profDetailsToUpsert.addAll(listProfileDetailsActual);
            try 
            {
                upsert profDetailsToUpsert;
                List<Review_Process__c> tempRP=[Select id from Review_Process__c where id=:reviewProcessId];
                if(tempRP.size()>0)
                {
                    update tempRP[0];
                }
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully'));
            }
            catch(Exception ex) 
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Failure in saving record'));   
                return;  
            }
            initializeDetailRecords();
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add a record'));
        }
        return;
    }
    /******************************
    Method Name: sendRemainder
    Description: This method is used send reminder Email.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void sendRemainder()
    {
        list<Review_User_Master__c> usrtList=new list<Review_User_Master__c>();
        boolean isReviweerSelected=false;
        if(listProfileDetailsActual.size()>0)
        {
            boolean isUserEmpty=false;
            for(Review_Action_Item_Log__c  r : listProfileDetailsActual)
            {
                if(r.Send__c==true)
                {
                    //if(r.User__c == null)
                    if(r.Primary_Owner__c == null)
                    {
                        isUserEmpty=true;
                    }
                }
            }
            if(isUserEmpty==true)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Primary Owner field is missing for some review Stages')); 
                return;    
            }
            for(Review_Action_Item_Log__c  reviewerList : listProfileDetailsActual)
            {
               //review record which is selected to send email
                if(reviewerList.Send__c==true)
                {
                    isReviweerSelected=true;
                    
                    try
                    {
                        //email to be send
                        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        //mail.setSenderDisplayName('BPO Solution Support');
                       OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
                       List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                            if(lstIdForOWA.size()>0)
                            {
                                owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                            } 
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            
                        if ( owea.size() > 0 ) 
                        {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }  
                        mail.setUseSignature(false);
                        usrtList=[select Email_ID_of_the_reviewer__c from Review_User_Master__c where id =:reviewerList.Primary_Owner__c];
                        mail.setToAddresses(new String[] { usrtList[0].Email_ID_of_the_reviewer__c});
                        //mail.replyTo='review_and_approval@h-2dg5s9tfqt9qjow6gx9d60xdufbnzp9o7yupyon4b1h8no2ob4.l-2wgbmay.l.apex.sandbox.salesforce.com';
                       // mail.setSubject('Upload the Document for your Approval');
                       string OfferingNames = checkNullValues(reviewerList.Review_Process__r.BPO_Opportunity__r.Offerings__c);
                    /*   if(OfferingNames!=null) 
           { 
            
                OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                
           } */
                       /* String htmlEmailBody  ='Hi,'+' <br>'
                                                +' '+' <br>'
                                                +'This Email is to make you remind that the Solution Plan is Sent for your Review and Approval.' +'<br>'
                                                //+'<br>'+ 'Please only reply to this email by following the below instructions:' +'<br>'+
                                                //'1. <b><<font color="Blue">Type Approved/Rejected/Pending/Rework here by replacing the Text inbetween brackets</font>></b> '+'<br>'+
                                                //'2. <b>*<font color="Blue">Provide your comments here by replacing Text inbetween asterisks</font>*</b>'+'<br><br>'+ 
                                                //'<b><font color="Red">Note: Please Reply this mail. </font></b>'+'<br>'
                                                +'    '+'<br><br><br>'
                                                //+'<br/><b><font color="Red">Important: Please do not Edit the below Section, it is used internally for Processing.</font></b>'+'<br>'
                                                
                                                +'    '+'<br><br><br>'
                                                +'    '+'<br><br><br>'
                                                +'    '+'<br>This is a system generated message. Please do not reply to this message<br>';
                                                 
                        mail.setHtmlBody(htmlEmailBody);*/
                        if(reviewerList.Review_Process__r.BPO_Opportunity__c != null) {
                            offeringsForLocation = [Select id,Service_Delivery_Location_Unique__c  from Opportunity_Offering__c where Opportunity_TGP__c = :reviewerList.Review_Process__r.BPO_Opportunity__c];                 
                            
                         }
                        
                        //Added New Email Template
                         mail.setSubject('REMINDER! Action item for Opportunity Name:  '+ reviewerList.Review_Process__r.BPO_Opportunity__r.Name + ' - Review Name:  '+ reviewerList.Review_Type__c +'');
                       mail.setHtmlBody('<html>' +
'    <body>' +

'<font face="Calibri (Body)" style="font-size:11pt">' +
'     <p>The below action item is assigned to you.  Please review and provide updated status.</p>' +

'  <table border="1" rules="rows" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"  width="60%" cellpadding="5">' +
'  <tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt" ><b><font face="Calibri(Body)" style="font-size:11pt" >Client Name:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(reviewerList.Review_Process__r.BPO_Opportunity__r.Client_Name__r.name)+'</font>'+''+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt" ><b><font face="Calibri(Body)" style="font-size:11pt" >Opportunity Name:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(reviewerList.Review_Process__r.BPO_Opportunity__r.Name)+'</font>'+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Opportunity ID:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(reviewerList.Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.Name)+'</font>'+'</td>' +
'</tr>' +


'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >BPO Net Revenue (MMS)<br/>(Thousands):</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(reviewerList.Review_Process__r.BPO_Opportunity__r.TCV__c) +'</font>'+'</td>' +
'</tr>' +



'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Client Geo Area:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+' '+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(reviewerList.Review_Process__r.BPO_Opportunity__r.Client_Geo_Area__r.Name) +'</font>'+ '</td>'+ 
'</tr>' +


'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Offerings:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(OfferingNames)+'</font>'+'</td>' +
'</tr>' +



'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Delivery Locations:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"></td>'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(reviewerList.Review_Process__r.BPO_Opportunity__r.Service_Delivery_Locations_Unique__c)+'</font>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Action:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(reviewerList.Issue_Status__c)+'</font>'+''+'</td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Description:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(reviewerList.Description__c)+'</font>'+''+'</td>'+
'</tr>' +

'</table>' +

'<br/>' +
'    <a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+lstOpp[0].id+'&id='+reviewerList.Review_Process__c+'&tabFocus=tab2&isVisible=true'+'"target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
'    <p>This is a system generated message. Please do not reply to this message.</p></font>' +
'</body>' +
'</html>'
); 
                        
                        
                      
                        
                        
                        //New Email Template End
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Reminder reqeust sent successfully'));
                    }
                    catch(Exception ex)
                    {   
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in sending Email')); 
                        return;
                    }                    
                }
            } 
            if(isReviweerSelected==false)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select action item  to continue')); 
                return;
            }
        }
    }
  /******************************
    Method Name: generateReport
    Description: This method is used to generate Report.
    Paramenters: NA
    Return Value: PageReference
    *******************************/ 
     public PageReference generateReport()
        {
        variable=true;
        testurl='/00OL0000000Y7zM';
        return null;
        }
    /******************************
    Method Name: refreshAccProfilePage
    Description: Method to cancel the page.
    Paramenters: NA
    Return Value: void
    *******************************/
    public PageReference refreshAccProfilePage(){
        initializeDetailRecords();
        refreshPage = true;
        return null;
    }
    /******************************
    Method Name: addDocument
    Description: This method is used to add Document.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void addDocument()
    {

        if(result=='true')
        {

        if(fileId == null || fileId.trim().equals(''))
         {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Choose document before clicking on upload'));
            return;
         }
        
        try
        {
           
            //Deleting Old Document Start
             List<Review_Action_Item_Log__c> tempDoclist=[select Attached_File_Name__c, File_id__c from Review_Action_Item_Log__c where id=:recordId];
             List<Document> tempDocument= [select id,name from Document where id=:tempDoclist[0].File_id__c];
             if(tempDocument.size()==1)
                {
                    //delete the file from document object
                    String docName = tempDocument[0].Name;
                    delete tempDocument;
                    tempDocument=null;
                }
                
            //Deleteing Old Document End
            
            
            doc.AuthorId = UserInfo.getUserId();
            doc.FolderId = UserInfo.getUserId();
            doc.IsPublic=true; 
            if(doc.body==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Choose document before clicking on upload'));
                return;
            }
            //insert document in standard Document object
            insert doc;
            //To fetch records from Document.
                List<Document> document= [select id,name from Document where id=:doc.id];
                if(document.size()>0)
                {
                    List<Review_Action_Item_Log__c> log=[Select id from Review_Action_Item_Log__c where id=:recordId];
                    if(log.size()>0)
                    {
                        log[0].File_id__c=document[0].id;  
                        log[0].Attached_File_Name__c=document[0].name; 
                        upsert log[0];
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
                    }
                }
                
        }
        catch(Exception ex)
        {   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in uploading file')); 
            return;
        }
        finally
        {
              doc = new Document();
              newProfDetail = new Review_Action_Item_Log__c();
        }
       
        initializeDetailRecords();
      } 
        if(result=='False')
      {
           doc = new Document();
           newProfDetail = new Review_Action_Item_Log__c();
      }
        return;
    }
     /******************************
    Method Name: deleteDocument
    Description: This method is used to Delete Document.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deleteDocument()
      {

        try
        {
            //List of Document to delete the perticular record
            List<Review_Action_Item_Log__c> tempDoclist=[select Attached_File_Name__c, File_id__c from Review_Action_Item_Log__c where id=:recordId];
                         
            if(tempDoclist.size()==1)
            {
            if(tempDoclist[0].File_id__c==null)
               {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There is no attached file to delete'));
                return;
               }               
               List<Document> tempDocument= [select id,name from Document where id=:tempDoclist[0].File_id__c];
                
                if(tempDocument.size()==1)
                {
                    //delete the file from document object
                    String docName = tempDocument[0].Name;
                    delete tempDocument;
                }
                //delete the selected record
                tempDoclist[0].Attached_File_Name__c=null;
                tempDoclist[0].File_id__c=null;
                upsert tempDoclist;
                initializeDetailRecords();
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File deleted successfully'));
        }
    catch(Exception ex)
        {   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'failure in deleting file')); 
           initializeDetailRecords();
            return;
        }
    return;
   }
     /******************************
    Method Name: deleteRecord
    Description: This method is used to Delete Record.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deleteRecord()
        {
         try
            {
                //List of Action Item Log to delete the perticular record
                List<Review_Action_Item_Log__c> listRequestActionLog=[select id, File_id__c from Review_Action_Item_Log__c where id=:recordIdToDelete];
                if(listRequestActionLog.size()==1)
                {
                    //delete the selected record
                      List<Document> tempDocument= [select id,name from Document where id=:listRequestActionLog[0].File_id__c];
                       if(tempDocument.size()==1)
                        {
                            //delete the file from document object
                            String docName = tempDocument[0].Name;
                            delete tempDocument;
                        }
                    delete listRequestActionLog;
                    initializeDetailRecords();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record deleted successfully'));
                }
            }
            catch(Exception ex)
            {   
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action.')); 
                 initializeDetailRecords();
                return;
            }
            return;
        }
    /******************************
    Method Name: sendMailReview
    Description: This method is used to Send Email to PMO group.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static void sendMailReview(Review_Process__c rprocess)
     {
         if(rprocess!=null)
         {
             List<Review_Process__c > tempRP=[select BPO_Opportunity__r.id,id,Client_Geo_Area__c,Client_Name__c,
                                                 Offering__c,Review_Name__c,Review_Stage_Master__r.Name,BPO_Opportunity__r.Offerings__c,
                                                 BPO_Opportunity__r.Client_Geo_Area_Prior_Value__c,BPO_Opportunity__r.TCV__c,
                                                 BPO_Opportunity__r.Stage__c,BPO_Opportunity__r.SAP_OM_Opportunity__r.Name,BPO_Opportunity__r.Name,
                                                 BPO_Opportunity__r.Client_Name__r.name,BPO_Opportunity__r.Client_Geo_Area__r.name,Review_Type__c,BPO_Opportunity__r.Service_Delivery_Locations_Unique__c 
                                                 from Review_Process__c where id=:rprocess.id];

         /*List<Review_Action_Item_Log__c > tempActionItem=[Select Review_Process__r.BPO_Opportunity__r.Risk_Level__c, 
                                             Review_Process__r.BPO_Opportunity__r.Stage__c, Review_Process__r.BPO_Opportunity__r.Expected_contract_sign_qtr__c, 
                                             Review_Process__r.BPO_Opportunity__r.Client_Geo_Area_Prior_Value__c, Review_Process__r.BPO_Opportunity__r.TCV__c,  
                                             Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.Name, Review_Process__r.Review_Stage_Master__r.Name, 
                                             Review_Process__r.BPO_Opportunity__r.Offerings__c , Review_Process__r.BPO_Opportunity__r.Client_Name__r.name, 
                                             Review_Process__r.BPO_Opportunity__r.Name,id,Review_Type_Master__c,Review_Type_Master__r.name,File_id__c,
                                             Primary_Owner__r.name,User__c,User__r.name,Action__c,Comments__c,Description__c,Due_date__c, Event_date__c,Issue_Status__c,
                                             Primary_Owner__c,Send__c,Attached_File_Name__c,Review_Type__c from Review_Action_Item_Log__c 
                                             where Review_Process__c=:rprocess.id];*/
        if(tempRP.size()==1)
        {
          
            OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
            List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                if(lstIdForOWA.size()>0)
                {
                    owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                } 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) 
            {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            } 
            mail.setToAddresses(getEmailAddresses()); 
            string OfferingNames = tempRP[0].Offering__c;      
   
            
            
                     /*  if(OfferingNames!=null) 
           { 
            
                OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                
           }   */
            
            //Added New Email Template
            mail.setSubject('APPROVED : Opportunity Name:  '+ tempRP[0].BPO_Opportunity__r.Name + ' - Review Name:  '+ tempRP[0].Review_Stage_Master__r.Name+'');
            mail.setHtmlBody('<html>' +
'    <body>' +

'<font face="Calibri (Body)" style="font-size:11pt">' +
'     <p>All the action items for ' + tempRP[0].BPO_Opportunity__r.Name +','+ '&nbsp;' + tempRP[0].Review_Stage_Master__r.Name + ' have been completed and required approvals have been provided.</p>' +

'  <table border="1" rules="rows"  width="60%" cellpadding="5">' +
'  <tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt" ><b><font face="Calibri(Body)" style="font-size:11pt" >Client Name:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+tempRP[0].BPO_Opportunity__r.Client_Name__r.name+'</font>'+''+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt" ><b><font face="Calibri(Body)" style="font-size:11pt" >Opportunity Name:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+tempRP[0].BPO_Opportunity__r.Name+'</font>'+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Opportunity ID:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(tempRP[0].BPO_Opportunity__r.SAP_OM_Opportunity__r.Name)+'</font>'+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Stage:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(tempRP[0].BPO_Opportunity__r.Stage__c)+'</font>'+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >BPO Net Revenue (MMS)<br/>(Thousands):</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(tempRP[0].BPO_Opportunity__r.TCV__c) +'</font>'+'</td>' +
'</tr>' +



'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Client Region:</font></b></td><td width="35%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+' '+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(tempRP[0].BPO_Opportunity__r.Client_Geo_Area__r.Name) +'</font>'+ '</td>'+ 
'</tr>' +


'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Offerings:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(tempRP[0].BPO_Opportunity__r.Offerings__c) +'</font>'+'</td>' +
'</tr>' +



'<tr height="20">  ' +
'<td width="25%" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri(Body)" style="font-size:11pt" >Delivery Locations:</font></b></td><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"></td>'+'<p><font face="Calibri(Body)" style="font-size:11pt">'+(tempRP[0].BPO_Opportunity__r.Service_Delivery_Locations_Unique__c)+'</font>'+
'</tr>' +

'</table>' +

'<br/>' +
'     <a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+tempRP[0].BPO_Opportunity__r.id+'&id='+tempRP[0].id+'&tabFocus=tab2&isVisible=true'+'" target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
'    <p>This is a system generated message. Please do not reply to this message.</p></font>' +
'</body>' +
'</html>'
); 
           
                        //New Email Template End
                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
    }
  }
 /******************************
    Method Name: getEmailAddresses
    Description: To retrieve Email Addresses of user PMO Group
    Paramenters: NA
    Return Value: List<String>
    *******************************/  
     public static List<String> getEmailAddresses()
     {
        List<String> idList = new List<String>();    
        List<String> mailToAddresses = new List<String>();
        //List for PMO Group
        List<String> lstGrpPMO = new List<String>();
        lstGrpPMO.add('PMO Group');  
        List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpPMO]; 
            for(integer i=0;i<g.size();i++ )
            {
                for (GroupMember gm : g[i].groupMembers) {        
                    idList.add(gm.userOrGroupId);
                }    
            }
            User[] usr = [SELECT email FROM user WHERE id IN :idList];    
            for(User u : usr) {        
                mailToAddresses.add(u.email);    
            }
            return mailToAddresses; 
      } 
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