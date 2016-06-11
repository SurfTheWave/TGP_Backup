/*
Author : Mayank tayal
Story  : Story-0167/SOL_070  
Description : Controller for scopeImageUpload page. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Shridhar Patankar Story-0167/SOL_070       28/02/2013      Added code to rendered docExist,delButton to enable Download link and delete button.

*/
public with sharing class UploadOfferImageController {
    public List<Offering_Scope_Image__c> optOffer;
    public Boolean docExist {get;set;}
    public Boolean delButton {get;set;}
    public Boolean addButtonRender {get; set;}
    public Boolean refreshPage {get;set;}
    public List<Document> docList;
    public String fileExten {get;set;}
    public String fileName {get;set;}
    public String pageid{get;set;}
    public String imgid{get;set;}
    public String imgUrl{get;set;}
    public String scopeName{get;set;}
    public String imageName{get;set;}    
    public String name{get;set;}
    public String id{get;set;}
    /******************************
    Method Name: UploadOfferImageController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public UploadOfferImageController(ApexPages.StandardController controller) {
        docList = new List<Document>();
        document = new Document();
        document.IsPublic=true;    
        document.name ='file';
        addButtonRender = true;
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;//Get users with Profile Name
         //Logic to not show add button for Sol Admin and Sol Leadership profile.
            List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
            solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
                for(Sol_UAM_Access_Setting__c solUam : solUamAccess){
                    if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c)){
                        addButtonRender = false ;
                        delButton = false;
          }
       }
        docExist = false;//By default Download link will not present.
        delButton =false;//By default Delete button will not present.
        pageid=ApexPages.CurrentPage().getParameters().get('id');
        if(pageid!=null && pageid!=''){
        sc=new Offering_Scope_Image__c();
        //To fetch Offering Scope Image records.
        optOffer=[Select id, name, File_Name__c, Picture_ID__c from Offering_Scope_Image__c where Opportunity_Offering__c=:pageid]; 
        if(optOffer.Size()>0){  
        //Iterate through optOffer  
        for(Offering_Scope_Image__c sc1: optOffer)
        {
            if(sc1.Picture_ID__c != null)
            {
                imgid=sc1.Picture_ID__c;
                fileName=sc1.File_Name__c;                                         
            }
            scopeName=sc1.Picture_ID__c ;//sc1.name;
            fileName=sc1.File_Name__c;  
              
        }
        List<Document> ddoc=[Select name, id from Document where id=:scopeName];
        if(ddoc.size()>0)
        {
          
            docExist = true;
            //Logic for not displaying del button for Sol admin profile.
            if(addButtonRender == true){
            delButton =true;
            }
        }
       } 
       
     }
     else{
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
     }
    }
   
  public Document document{get;set;}      
  
  public Offering_Scope_Image__c sc{get;set;}
  /******************************
    Method Name: upload
    Description: Upload file
    Paramenters: NA
    Return Value: NA
    *******************************/   
  public PageReference upload() { 
   
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId();
   
    if(document.body==null)
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select the file!'));
        return null;
    } 
    try {
        //Iterate through Document
        for(Document ddoc:[Select name, id from Document where name=:scopeName])
        {            
            //To Override file from document.
            delete ddoc;              
        }
        //Iterate through Offering Scope Image
        for(Offering_Scope_Image__c os: [select id, name,File_Name__c from Offering_Scope_Image__c where Opportunity_Offering__c=:pageid])
        {
            //To override file from Offering Scope Image.
            delete os;           
        }    
       insert document;
        docExist = true;
        delButton =true;
       
       //To fetch records from Document.
       List<Document> doc= [select id,name from Document where id=:document.id];// name=:document.name];
       sc.Picture_ID__c=doc[0].id;
       sc.Opportunity_Offering__c=pageid;
       sc.File_Name__c=doc[0].name;
       fileName=doc[0].name;
       imgid=doc[0].id;
     
       insert sc; 
      
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file!'));
      return null;
    } finally {
      document.body = null;
      document.name = fileName;
      document = new Document();
      sc=new Offering_Scope_Image__c();
    }
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully!'));
   
    return null;
  }
  /******************************
    Method Name: del
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
   public PageReference del(){
    docExist = false;
    //Iterate through Document
        for(Document ddoc:[Select name, id from Document where name=:scopeName])
        {            
            //To Override file from document.
            delete ddoc;              
        }
        //Iterate through Offering Scope Image
        for(Offering_Scope_Image__c os: [select id, name,File_Name__c from Offering_Scope_Image__c where Opportunity_Offering__c=:pageid])
        {
            //To override file from Offering Scope Image.
            delete os;           
        }    

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File deleted successfully!'));
    delButton =false;
    return null;
  }
 
}