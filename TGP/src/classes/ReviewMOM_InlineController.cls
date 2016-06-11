/*
Author : Shridhar Patankar
Story  : Sol_165
Description : Capturing Minutes of Meetings for a review. 



Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013           Sol UAM-Release 2
*/
public with sharing class ReviewMOM_InlineController {
    
    public Boolean addButtonRender {get; set;}
    public Review_MOM__c newProfDetail {get;set;}
    public Review_MOM_Titel__c reviewTitle {get;set;}
    public Review_MOM__c[] listProfileDetailsActual {get;set;}
    public String momID{get;set;}
    public List<Review_MOM_Titel__c> listProfileTitleDetailsActual {get;set;}
    public Boolean saveEditButtonRender {get; set;}
    public string opportunityId{get;set;}
    public Boolean deleteButtonRender {get; set;}
    public String SolUserName{get;set;}
    public String currentUserName{get;set;}
    public String reviewProcessId{get;set;}
    //Added variables for File upload
    public List<DisplayFile> display1;
    public String fileExten {get;set;}
    public Boolean refreshPage {get;set;}
    public Document doc1{get;set;} 
    public String fname{get;set;}
    public String id{get;set;}
    public String cbName{get;set;}
    public String docid{get;set;}
    public Integer cnt{get;set;}
    public List<String> filenames{get;set;}
    public String comments{get;set;}    
    public List<Review_MOM__c> listReviewMOM{get;set;}
    public String fileIdDelete{get;set;} 
    public final Review_Process__c rp;
    public List<Review_Process__c> revProcess{get;set;}
    public Boolean readOnlyMode{get;set;}
    public Boolean pgmsg2{get; set;}
    public Boolean pgmsg3{get; set;}
   
    public class DisplayFile{
        public String fileName{get; set;}
        public String fileID{get; set;}
        public String comments{get;set;}
        public displayFile(String fileName, String fileID, String comments){
            this.fileName=fileName;
            this.fileID=fileID;
            this.comments=comments;
        }
    }
    public List<DisplayFile> getDisplay1() {    
        return display1;
    }
    public String getComments() {    
        return comments;
    }

    /******************************
    Method Name: ReviewMOM_InlineController 
    Description: Constructor for ReviewMOM_InlineController
    Paramenters: stdCon
    Return Value: void
    *******************************/
    
    public ReviewMOM_InlineController(ApexPages.StandardController controller){
        reviewProcessId=ApexPages.CurrentPage().getParameters().get('id');
        newProfDetail= new Review_MOM__c();
        listProfileTitleDetailsActual =[Select id, name, MOM_Rich__c,Review_Process__c  from Review_MOM_Titel__c where Review_Process__c=:reviewProcessId];
        if(listProfileTitleDetailsActual .size()>0)
        {
            reviewTitle=listProfileTitleDetailsActual[0];
        }
        else
        {
            reviewTitle = new Review_MOM_Titel__c();
        }
        addButtonRender = true;
        doc1 = new Document();
        doc1.IsPublic=true;    
        doc1.name ='file';   
        deleteButtonRender=true;
        saveEditButtonRender=true;
        momID=ApexPages.CurrentPage().getParameters().get('id');
        opportunityId=ApexPages.CurrentPage().getParameters().get('oppId');
        initializeDetailRecords();
        this.rp= (Review_Process__c)controller.getRecord();
        fname='File';
        cnt=1;
        filenames=new List<String>();
        display1=new List<DisplayFile>();
        if(reviewProcessId!=null)
        {
            revProcess=[Select id, name from Review_Process__c where id=:reviewProcessId];
            for(Review_Process__c cb:revProcess)
            {
                cbName=cb.name;                 
            }
            initializeDetailRecords();
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Review Process Id not found'));
        }
        //UAM Code--Mayank Tayal-Sol_148
        if(opportunityId!=null)
        {
          /*  List<Opportunity_TGP__c> lstOpp = [select id, name from Opportunity_TGP__c where id = :opportunityId];
            String strOppId = lstOpp.get(0).id;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Review_MOM__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U');
            deleteButtonRender = m.get('D'); */
            addButtonRender =UAMSolMobUtility.addButtonRender_BPOOppTgp;
    	    saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
    	    deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
        }
        
        //SOL_141 Start
         /*UAM SOL RV
         List<userRole> role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];        
             if(role.size()>0)
                {
                    if(role[0].name!=null && role[0].name.equalsIgnoreCase('Operations'))
                         {
                           addButtonRender=false;
                           deleteButtonRender=false;
                           saveEditButtonRender=false;
                         }
                }*/

        if(addButtonRender==false && saveEditButtonRender==false)
        {
            readOnlyMode=true;
        } 
        //SOL_141 End
    }
      /******************************
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public void initializeDetailRecords() 
    {       
        listReviewMOM= new List<Review_MOM__c>();
        //Search for Review MOM
        for(Review_MOM__c cAssess : [Select Name, Picture_ID__c,Comments__c,File_Name__c from Review_MOM__c where Review_Process__c=:reviewProcessId ORDER By CreatedDate DESC]) 
        {
               listReviewMOM.add(cAssess);                
        }
        listProfileTitleDetailsActual = new List<Review_MOM_Titel__c>();
        //Search for Review MOM Title
        for(Review_MOM_Titel__c cRevMOMtitle : [Select Name,id,MOM_Rich__c  from Review_MOM_Titel__c where Review_Process__c=:reviewProcessId ORDER By CreatedDate DESC]) 
        {
               listProfileTitleDetailsActual.add(cRevMOMtitle);                
        }
                 
    }
    //End
   
    /******************************
    Method Name: saveAccProfileDetails
    Description: For saving records in Key Buyer Value.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
   public void saveAccProfileDetails(){
      
        //Review_MOM_Titel__c[] profDetailsToUpsert = new Review_MOM_Titel__c[]{};
       // profDetailsToUpsert.addAll(listProfileTitleDetailsActual);        
        try {
            reviewTitle.Review_Process__c=reviewProcessId;
            upsert reviewTitle;
        }
            
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error on Saving MOM Record'));
            
        }
        
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully'));
         pgmsg3=false;
        pgmsg2=true;    
        initializeDetailRecords();
     
    }
    //End
     /******************************
    Method Name: saveNow
    Description: For saving records in Review_MOM__c .
    Paramenters: NA
    Return Value: null
    *******************************/
    public PageReference saveNow()
      {
        Review_MOM__c[] profDetailsToUpsert = new Review_MOM__c[]{};
        profDetailsToUpsert.addAll(listReviewMOM);        
        try {
            upsert profDetailsToUpsert;
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in saving '));
            return null;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully'));
        pgmsg3=true;
        pgmsg2=false;    
        initializeDetailRecords();
        return null;
       }
     /******************************
    Method Name: upload
    Description: For uploading of files.
    Paramenters: NA
    Return Value: null
    *******************************/
    //Start
    public PageReference upload() 
    {
        doc1.AuthorId = UserInfo.getUserId();
        doc1.FolderId = UserInfo.getUserId();
        if(doc1.body==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Choose document before clicking on upload'));
             pgmsg3=true;
             pgmsg2=false;  
            return null;
        }
        try 
        {
            insert doc1;
            //display1.add(new DisplayFile(doc1.name,doc1.id,client.Comments__c));
            //To fetch records from Document.
            List<Document> doc= [select id,name from Document where id=:doc1.id ORDER By CreatedDate DESC];// name=:document.name];
            newProfDetail=new Review_MOM__c();
            if(reviewProcessId!=null)
            { 
                newProfDetail.Review_Process__c=revProcess[0].id;
                newProfDetail.Picture_ID__c=doc[0].id;
                newProfDetail.File_Name__c=doc[0].name;
                newProfDetail.Comments__c=rp.Comments__c;
                insert newProfDetail;            
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record Added Successfully'));
            }    
        } 
        catch (DMLException e){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in uploading file'));
          return null;
        } 
        finally
        {
              doc1.body = null;
              doc1.name = fname;
              doc1 = new Document();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));   
        pgmsg3=true;
        pgmsg2=false;    
        initializeDetailRecords(); 
        rp.Comments__c=null;          
       
        return null;
    }
    //End

    /******************************
    Method Name: cancelNow
    Description: Added method to cancel.
    Paramenters: NA
    Return Value: null
    *******************************/
    //Start
    public PageReference cancelNow()
    {
        initializeDetailRecords();
        return null; 
    }
    //End
    /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFile()
    {
        
       try{
            for(Document ddoc:[Select name, id from Document where id=:fileIdDelete])
            {            
                //To Override file from document.
                delete ddoc;              
            }
            //Iterate through Offering Scope Image
            for(Review_MOM__c cca: [select id, name,File_Name__c,Comments__c from Review_MOM__c where Review_Process__c=:reviewProcessId and Picture_ID__c=:fileIdDelete])
            {
                //To override file from Offering Scope Image.
                delete cca;           
            }    
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record deleted successfully'));
            pgmsg3=true;
            pgmsg2=false;    
            initializeDetailRecords();        
            return null;
        }
        catch(Exception ex)
        {   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action.')); 
            pgmsg3=true;
            pgmsg2=false;    
            initializeDetailRecords();        
            return null;
        }
    }
    
}