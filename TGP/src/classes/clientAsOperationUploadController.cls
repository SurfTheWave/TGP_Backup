/*
Author : Mayank Tayal
Story  : Story-0166/SOL_069  
Description : Controller for assessmentUpload page.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013        Sol UAM-Release 2

*/
public class clientAsOperationUploadController 
{
    public String pageid{get;set;}
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean deleteButtonRender {get; set;}
    public final Opportunity_Offering__c client;
    public List<Opportunity_Offering__c> assesment{get;set;}
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
    public Offering_Scope_Image__c ccca{get;set;}
    public String comments{get;set;}    
    public List<Offering_Scope_Image__c> listAssessmentDetailsActual{get;set;}
    public String fileIdDelete ;
    public Boolean readOnlyMode{get;set;}
    
    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
   
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
   
   /* public Document doc1 
    {      
      get {
          if (doc1 == null)
            doc1 = new Document();
           
          doc1.IsPublic=true;
          doc1.name= fileExten;
          return doc1;      
      }    
      set;
    }*/
  

    /******************************
    Method Name: clientAsOperationUploadController 
    Description: Constructor for clientAsOperationUploadController 
    Paramenters: controller
    Return Value: NA
    *******************************/
    //Start
    public clientAsOperationUploadController(ApexPages.StandardController controller) 
    {
        pageid=ApexPages.CurrentPage().getParameters().get('id');//Get current page ID.
        addButtonRender = true;
        doc1 = new Document();
        doc1.IsPublic=true;    
        doc1.name ='file';
        /*String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;//Get users with Profile Name
        //Logic to not show add button for Sol Admin and Sol Leadership profile.
        List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
        solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
        for(Sol_UAM_Access_Setting__c solUam : solUamAccess)
        {
            if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c))
            {
                addButtonRender = false ;                
            }
        }*/
        this.client= (Opportunity_Offering__c)controller.getRecord();
        fname='File';
        cnt=1;
        filenames=new List<String>();
        display1=new List<DisplayFile>();
        if(pageid!=null)
        {
            assesment=[Select id, name from Opportunity_Offering__c where id=:pageid];
            for(Opportunity_Offering__c cb:assesment)
            {
                cbName=cb.name;                 
            }
            initializeDetailRecords();
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found '));
        }
        //UAM Code--Mayank Tayal-Sol_148
        if(pageid!=null)
        {
            /*List<Opportunity_Offering__c> lstOffering = [select id, name, Opportunity_TGP__c from Opportunity_Offering__c where id = : pageid];
            String strOppId = lstOffering.get(0).Opportunity_TGP__c;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Offering_Scope_Image__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U');
            deleteButtonRender  = m.get('D');
            */
            addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
            saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
            deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;            
        }
        if(addButtonRender==false && saveEditButtonRender==false)
        {
            readOnlyMode=true;
        } 
    }
    //End

    /******************************
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public void initializeDetailRecords() 
    {       
        listAssessmentDetailsActual = new List<Offering_Scope_Image__c>();
        //Search for Current Client Capability Assessment
        for(Offering_Scope_Image__c cAssess : [Select Name, Picture_ID__c,Comments__c,File_Name__c from Offering_Scope_Image__c where Opportunity_Offering__c=:pageid ORDER By CreatedDate DESC]) 
        {
               listAssessmentDetailsActual.add(cAssess);                
        }        
    }
    //End
    
    /******************************
    Method Name: saveNow
    Description: For saving records in Current Client Capability Assessment.
    Paramenters: NA
    Return Value: null
    *******************************/
    //Start
    public PageReference saveNow()
    {
        Offering_Scope_Image__c[] profDetailsToUpsert = new Offering_Scope_Image__c[]{};
        profDetailsToUpsert.addAll(listAssessmentDetailsActual);        
        try {
            upsert profDetailsToUpsert;
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error : '+ex));
            return null;
        }
        //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        //pageRef.setRedirect(true);
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File details modified successfully!'));
        initializeDetailRecords();
        return null;
    }
    //End

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
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select the File!!'));
            return null;
        }
        try 
        {
            insert doc1;
            //display1.add(new DisplayFile(doc1.name,doc1.id,client.Comments__c));
            //To fetch records from Document.
            List<Document> doc= [select id,name from Document where id=:doc1.id ORDER By CreatedDate DESC];// name=:document.name];
            ccca=new Offering_Scope_Image__c();
            if(pageid!=null)
            { 
                ccca.Opportunity_Offering__c=assesment[0].id;
                ccca.Picture_ID__c=doc[0].id;
                ccca.File_Name__c=doc[0].name;
                ccca.Comments__c=client.Comments__c;
                insert ccca;            
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity Id not found '));
            }    
        } 
        catch (DMLException e){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
          return null;
        } 
        finally
        {
              doc1.body = null;
              doc1.name = fname;
              doc1 = new Document();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File added successfully!'));       
        initializeDetailRecords(); 
        client.Comments__c=null;          
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
        for(Document ddoc:[Select name, id from Document where id=:fileIdDelete])
        {            
            //To Override file from document.
            delete ddoc;              
        }
        //Iterate through Offering Scope Image
        for(Offering_Scope_Image__c cca: [select id, name,File_Name__c,Comments__c from Offering_Scope_Image__c where Opportunity_Offering__c=:pageid and Picture_ID__c=:fileIdDelete])
        {
            //To override file from Offering Scope Image.
            delete cca;           
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File deleted successfully!'));
        initializeDetailRecords();        
        return null;
    }
}