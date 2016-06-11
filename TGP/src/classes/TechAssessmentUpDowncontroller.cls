/*
Author : Sushmanth Hasti
Story  :  
Description : 

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

public with sharing class TechAssessmentUpDowncontroller {

    public boolean disableDownload{get;set;}
    public boolean disableUpload{get;set;}
    public string waveId{get;set;}
    public string fileId{get;set;}
    public string fileName{get;set;}
    public string fileType{get;set;}
    public string displayfileName{get;set;}
    public Wave_Planning__c strDealWave{get;set;}
    public List<Tracking_Tech_Assessment__c> trackTech{get;set;}
    public List<Document> doc{get;set;}
    public Document document{get;set;}
    public String  UserName{get;set;}
    public String fileData{get;set;}
    public String  downLoaderUserName{get;set;}
    public Boolean refreshPage {get; set;}
    public integer count{get;set;}
    public boolean flagImage{get;set;}
    public boolean fileDownloadedConfirm{get;set;}
    public boolean isVisibleDownload {get;set;}
  
    List<String> allLines = new List<String>();     
    private Integer inputCharacterMax { get { return 100000; } set; } // this is a somewhat arbitrary character limit
    String[] filelinesLeft = new String[]{};
    String[] filelinesRight = new String[]{};
    List<Tech_Tracker__c> tTracker ;
    
    public Transient String fileFullData{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public boolean isDone{get;set;}
    
    /******************************
    Method Name: TechAssessmentUpDowncontroller
    Description: This is Constructor for the TechAssessmentUpDowncontroller class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/ 
    public TechAssessmentUpDowncontroller (ApexPages.StandardController controller)
    {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        isDone=false;
        count=0;
        refreshPage = false;       
        waveId=ApexPages.CurrentPage().getParameters().get('id');
        
        //Take File name for this location from Tracking_Recruitment__c object
        trackTech=[select id,File_Name__c,isDownload__c,clickOnDownLoad__c,File_Downloader_User_Name__c from Tracking_Tech_Assessment__c where Deal_Wave__c=:waveId];
        if(trackTech.size()==1)
        {
            downLoaderUserName=trackTech[0].File_Downloader_User_Name__c;
            disableDownload=trackTech[0].isDownload__c;
            UserName=UserInfo.getName();
            
            //If file is allready downloaded
            if(disableDownload==true)
            {
                //if file is downloaded by current user
                if(downLoaderUserName!= null && downLoaderUserName.equals(UserName))
                {
                    isVisibleDownload=true;
                    fileDownloadedConfirm=false;
                    disableDownload=true;
                    disableUpload=false;
                }
                //if file is not downloaded by current user
                else
                {
                    isVisibleDownload=true;
                    fileDownloadedConfirm=false;
                    disableDownload=true;
                    disableUpload=true;
                }
            }
            //If file is not downloaded by anyone
            else
            {
                //If file is downloaded but confirmation is not done
                if(trackTech[0].clickOnDownLoad__c==true)
                {
                    //If file is downloaded by current user but confirmation is not done
                    if(downLoaderUserName!= null && downLoaderUserName.equals(UserName))
                    {
                        isVisibleDownload=false;
                        fileDownloadedConfirm=true;
                        disableDownload=false;
                        disableUpload=true;    
                    }
                    //If file is not downloaded by current user but confirmation is not done
                    else
                    {
                        isVisibleDownload=true; 
                        fileDownloadedConfirm=false;
                        disableDownload=false;
                        disableUpload=true;
                    }
                }
                //If file is not downloaded by anyone
                else
                {
                    isVisibleDownload=true;
                    fileDownloadedConfirm=false;
                    disableDownload=false;
                    disableUpload=true;    
                }
            }
           
            //File stored in Document for perticular location
            doc=[Select name, id, Description,Type, IsPublic, FolderId, AuthorId from Document where name=:trackTech[0].File_Name__c];   
            if(doc.size()>0)
            {
                fileId=doc[0].id; 
                fileType=doc[0].type;
                displayfileName=doc[0].name+'.'+doc[0].type; 
            }
        }
        strDealWave=new Wave_Planning__c();
        
        //Location for which we have to stored the file
         List<Wave_Planning__c> DealWaveList=[Select id,Wave_Label__c, Deal_Location__r.Wave_Plan_Version__r.deal__c, Deal_Location__r.Wave_Plan_Version__c,
         										Location_Name__c,Deal_Location__r.id,Deal_Location__r.Wave_Plan_Version__r.deal__r.name,
         										Deal_Location__r.Wave_Plan_Version__r.name, Deal_Location__r.Deployment_Lead_New__c,
         										Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c,Deal_Location__r.Location_Mobilization_Lead_Secondary_New__c,
                                                Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Mobilization_Technology_Lead_Primary_New__c,
                                                Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c,Mob_Technology_Lead_Secondary_New__c,
                                                Mob_Technology_Lead_Secondary_New__r.SFDC_User__c from Wave_Planning__c where id=: waveId limit 1]; 
        if(DealWaveList.size()>0)
        {                       
            strDealWave=DealWaveList[0]; 
            //fileName='Technology & Work Enablement Tracker_'+DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name+'_'+DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.name+'_'+DealWaveList[0].Location_Name__c+'_'+DealWaveList[0].Wave_Label__c;    
            String dealName =UTIL_Constants.EMPTY_STRING;
            String locationName=UTIL_Constants.EMPTY_STRING;
            String waveName=UTIL_Constants.EMPTY_STRING;
     
              if(DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name.length() > 41){
                  dealName= DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name.substring(0, 40);
              }else{
                  dealName= DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name;     
              }
              
              if(DealWaveList[0].Location_Name__c.length() > 31){
                  locationName= DealWaveList[0].Location_Name__c.substring(0, 30);
              }else{
                  locationName= DealWaveList[0].Location_Name__c;
              }
              
              if(DealWaveList[0].Wave_Label__c.length() > 21){
                  waveName= DealWaveList[0].Wave_Label__c.substring(0, 20); 
              }else{
                  waveName= DealWaveList[0].Wave_Label__c;
              }
             String systemTime= DateTime.now().format('MM-dd-yyyy hh-mm-ss');
             fileName='TWE_'+dealName+'_'+locationName+'_'+waveName+'_'+systemTime;   
        }
        
    }
    
    /******************************
    Method Name: DownloadFile
    Description: This method is used to download the file  
    Paramenters: NA
    Return Value: void
    *******************************/
    public void DownloadFile()
    {
        try
        {
            UserName=UserInfo.getName();  
            
            //Record for current Location-file pair from Tracking_Recruitment__c object
            trackTech =[select id,File_Name__c,isDownload__c,clickOnDownLoad__c,File_Downloader_User_Name__c from Tracking_Tech_Assessment__c where Deal_Wave__c=:waveId];
            if(trackTech.size()==1)
            {
                //Change the name of file in the document
                doc=[Select name, id, Description,Type, IsPublic, FolderId, AuthorId from Document where name=:trackTech[0].File_Name__c];   
                if(doc.size()>0)
                {
                   // doc[0].name=fileName+'_'+System.now().format('EEEE, MMMM d, yyyy - hh-mm-ss');
                    doc[0].name=fileName;
                    upsert doc[0];
                    fileId=doc[0].id; 
                    fileDownloadedConfirm=true;   
                    trackTech[0].File_Name__c=doc[0].name;     
                }
                trackTech[0].isDownload__c=false;
                trackTech[0].clickOnDownLoad__c=true;
                trackTech[0].File_Downloader_User_Name__c=UserName;
                upsert trackTech[0];
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.EMPTY_STRING+e));  
            return;
        }
        return;    
    }
    
    /******************************
    Method Name: actionYes
    Description: This method confirms that file is successfuly downloaded by user  
    Paramenters: NA
    Return Value: void
    *******************************/
    public pagereference actionYes()
    {
        try
        {
            UserName=UserInfo.getName();    
            //Record for current Location-file pair from Tracking_Recruitment__c object
            trackTech =[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_Tech_Assessment__c where Deal_Wave__c=:waveId];
            if(trackTech.size()==1)
            {   
                trackTech[0].isDownload__c=true;
                trackTech[0].clickOnDownLoad__c=false;
                upsert trackTech[0];
                disableDownload=true;           
                disableUpload=false;
                fileDownloadedConfirm=false;  
                isVisibleDownload=true;
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.EMPTY_STRING+e));  
            return null;
        }
        pagereference pr=new PageReference('/apex/TechAssessmentUpDown?id='+waveId);
        pr.setRedirect(true);
        return pr;       
    }
    
    /******************************
    Method Name: actionNo
    Description: This method confirms that file is not successfuly downloaded by user  
    Paramenters: NA
    Return Value: void
    *******************************/
    public pagereference actionNo()
    {
        try
        {
            UserName=UserInfo.getName(); 
            //Record for current Location-file pair from Tracking_Recruitment__c object
            trackTech=[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_Tech_Assessment__c where Deal_Wave__c=:waveId];
            if(trackTech.size()==1)
            {   
                trackTech[0].isDownload__c=false;
                trackTech[0].clickOnDownLoad__c=false;
                upsert trackTech[0];
                fileDownloadedConfirm=false;  
                isVisibleDownload=true;
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.EMPTY_STRING+e));  
            return null;
        }
        pagereference pr=new PageReference('/apex/TechAssessmentUpDown?id='+waveId);
        pr.setRedirect(true);
        return pr;        
    }
    
     /******************************
    Method Name: UploadFile
    Description: This method is used to upload the file  
    Paramenters: NA
    Return Value: void
    *******************************/
    public void UploadFile()
    {
        count=count+1;                    
        //Record for current Location-file pair from Tracking_Recruitment__c object
        trackTech =[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_Tech_Assessment__c where Deal_Wave__c=:waveId];
        if(trackTech.size()==1)
        {
            String name=trackTech[0].File_Name__c+'.xlsx';
            if(dropFileName!=name && count==1)
            {
                count=0;
                fileFullData = UTIL_Constants.EMPTY_STRING ;
                uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                dropFileName = UTIL_Constants.EMPTY_STRING;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can not upload different file'));  
                return;    
            }
        } 
        if(fileFullData != null && fileFullData != UTIL_Constants.EMPTY_STRING && uploadFileAtt !=null && uploadFileAtt!=UTIL_Constants.EMPTY_STRING && dropFileName!=null && dropFileName!=UTIL_Constants.EMPTY_STRING){
            boolean isInserted=false;       
            //flagImage=true;
            Savepoint sp = Database.setSavepoint();
            if(fileFullData != uploadFileAtt)
            {     
                try
                {
                    tTracker = new List<Tech_Tracker__c>();
                    Integer pivot = fileFullData.indexOf( '\r', Integer.valueOf(Math.floor(fileFullData.length() / 2)) );
                    if ( pivot > inputCharacterMax ) 
                    {
                        divideString(fileFullData);
                    }
                    else 
                    {
                        allLines = fileFullData.split('\n');
                    }
                    if(allLines.size() != 0)
                    {

                        if(allLines.size() == 5){                       
                             count=0;
                             fileFullData = UTIL_Constants.EMPTY_STRING ;
                             uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                             dropFileName = UTIL_Constants.EMPTY_STRING;
                             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot upload the empty sheet(without data)'));
                             //flagImage=false;
                             return;
                        }
                             
                        for (Integer i=5;i<allLines.size();i++) {
                            String[] inputvalues = new String[]{};
                            inputvalues = allLines[i].split(',');
                            Tech_Tracker__c tt = new Tech_Tracker__c();
                
                            if(inputvalues.size() != 0)
                            {                                
                                integer temp=inputvalues.size();
                                if(temp>=1)
                                {
                                    if(inputvalues[0] !=null && inputvalues[0] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.User_Name__c = inputvalues[0];
                                    }
                                }
                                if(temp>=2)
                                {
                                    if(inputvalues[1] !=null && inputvalues[1] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        tt.Application_Name__c = inputvalues[1];
                                    }
                                }
                                if(temp>=3)
                                {
                                    if(inputvalues[2] !=null && inputvalues[2] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.Request_Date__c  = date.parse(inputvalues[2]);
                                    }
                                }
                                if(temp>=4)
                                {
                                    if(inputvalues[3] !=null && inputvalues[3] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                       tt.Access_due_Date__c = date.parse(inputvalues[3]);
                                    }
                                }
                                if(temp>=5)
                                {
                                    if(inputvalues[4] !=null && inputvalues[4] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                       tt.Actual_date__c= date.parse(inputvalues[4]);
                                    }
                                }
                                
                                if(temp>=6)
                                {
                                    if(inputvalues[5] !=null && inputvalues[5] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.URL__c = inputvalues[5];
                                    }
                                }
                                if(temp>=7)
                                {
                                    if(inputvalues[6] !=null && inputvalues[6] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.Who_supports_this_Application_Server__c = inputvalues[6];
                                    }
                                }
                                if(temp>=8)
                                {
                                    if(inputvalues[7] !=null && inputvalues[7] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.Internet__c= inputvalues[7];
                                    }
                                }
                                 if(temp>=9)
                                {
                                    if(inputvalues[8] !=null && inputvalues[8] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.VPN__c= inputvalues[8];
                                    }
                                }
                                if(temp>=10)
                                {
                                    if(inputvalues[9] !=null && inputvalues[9] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.Otheres__c = inputvalues[9];
                                    }
                                }
                                 if(temp>=11)
                                {
                                    if(inputvalues[10] !=null && inputvalues[10] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.Status__c = inputvalues[10];
                                    }
                                }
                                if(temp>=12)
                                {
                                    if(inputvalues[11] !=null && inputvalues[11] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        tt.Comments__c = inputvalues[11];
                                    }
                                }
                                                            
                                tt.Deal_Wave__c = waveId;
                                tTracker.add(tt);
                                isInserted=true;
                            }
                   
                        }
                        /* Delete the Object Data */ 
                        if(isInserted) {
                            /* Delete the Object Data */
                            if(fileFullData != uploadFileAtt) {
                                list<Tech_Tracker__c> DeleteList = [select Id from Tech_Tracker__c where Deal_Wave__c =:waveId limit 5000]; 
                                if(DeleteList.size()>0)
                                {
                                    delete DeleteList;
                                }                           
                            }
                             insert tTracker;    
                            isDone=true; 
                        }
                        
                        if(isDone==true)
                        {
                            try 
                            { 
                                if(trackTech.size()==1)
                                {
                                    List<Document> docForDelete=[Select name,Body,type,id from Document where name=:trackTech[0].File_Name__c];
                                    if(docForDelete.size()>0)
                                    {
                                        //flagImage=false;
                                        //docForDelete[0].Name = fileName+'_'+System.now().format('EEEE, MMMM d, yyyy - hh-mm-ss');
                                        docForDelete[0].Name = fileName;
                                        docForDelete[0].Body = EncodingUtil.base64Decode(uploadFileAtt);
                                        upsert docForDelete[0];
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));                     
                                        displayfileName=docForDelete[0].name+'.'+docForDelete[0].type; 
                                        fileId=docForDelete[0].id;
                                    }
                                    trackTech[0].File_Name__c=docForDelete[0].name;
                                    trackTech[0].isDownload__c=false;
                                    trackTech[0].clickOnDownLoad__c=false;
                                    upsert(trackTech[0]);
                                    count=0;
                                    isDone=false;
                                }
                            }  
                            catch (DMLException e) 
                            {              
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e)); 
                                fileFullData = UTIL_Constants.EMPTY_STRING ;
                                uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                                dropFileName = UTIL_Constants.EMPTY_STRING;
                                return;
                            } 
                            disableUpload=true;
                            disableDownload=false;
                            return;  
                        }
                    }
                }
                catch (Exception e)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e));
                    Database.rollback(sp);
                    fileFullData = UTIL_Constants.EMPTY_STRING ;
                    uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                    dropFileName = UTIL_Constants.EMPTY_STRING;
                    return;
                }
            }//flagImage=false;
        }else{    
            count=0;
            fileFullData = UTIL_Constants.EMPTY_STRING ;
            uploadFileAtt = UTIL_Constants.EMPTY_STRING;
            dropFileName = UTIL_Constants.EMPTY_STRING;
            return;
        }
    }
    
    /******************************
    Method Name: divideString
    Description: This method is used to divide the input string  
    Paramenters: String
    Return Value: void
    *******************************/
    public void divideString(String input) 
    {
        Integer pivot = input.indexOf( '\r', Integer.valueOf(Math.floor(input.length() / 2)) ); 
        String left = input.substring(0,pivot);
        String right = input.substring(pivot); 

        if ( pivot < inputCharacterMax ) 
        {
            // split left and right chunks, add to allLines
            filelinesLeft = left.split('\n');
            filelinesRight = right.split('\n');

            allLines.addAll(filelinesLeft);
            allLines.addAll(filelinesRight);
        }
        else
        {
            // divide and conquer!
            divideString(left);
            divideString(right);
        } 
    }
}