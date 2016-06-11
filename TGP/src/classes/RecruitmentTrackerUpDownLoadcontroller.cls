/*
Author : Sushmanth Hasti
Story  :  
Description : 

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

public with sharing class RecruitmentTrackerUpDownLoadcontroller {

    public boolean disableDownload{get;set;}
    public boolean disableUpload{get;set;}
    public string locationId{get;set;}
    public string fileId{get;set;}
    public string fileName{get;set;}
    public string fileType{get;set;}
    public string displayfileName{get;set;}
    public Deal_Location__c strDealLocation{get;set;}
    public List<Tracking_Recruitment__c> trackRec{get;set;}
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
    List<Recruitment_Tracker__c > reqTracker ;
    
    public Transient String fileFullData{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public boolean isDone{get;set;}
    
    /******************************
    Method Name: RecruitmentTrackerUpDownController_final
    Description: This is Constructor for the RecruitmentTrackerUpDownController_final class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/ 
    public RecruitmentTrackerUpDownLoadcontroller (ApexPages.StandardController controller)
    {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        isDone=false;
        count=0;
        refreshPage = false;       
        locationId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        
        //Take File name for this location from Tracking_Recruitment__c object
        trackRec =[select id,File_Name__c,isDownload__c,clickOnDownLoad__c,File_Downloader_User_Name__c from Tracking_Recruitment__c where Deal_Location__c=:locationId];
        if(trackRec.size()==1)
        {
            downLoaderUserName=trackRec[0].File_Downloader_User_Name__c;
            disableDownload=trackRec[0].isDownload__c;
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
                if(trackRec[0].clickOnDownLoad__c==true)
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
            doc=[Select name, id, Description,Type, IsPublic, FolderId, AuthorId from Document where name=:trackRec[0].File_Name__c];   
            if(doc.size()>0)
            {
                fileId=doc[0].id; 
                fileType=doc[0].type;
                displayfileName=doc[0].name+'.'+doc[0].type; 
            }
        }
        strDealLocation=new Deal_Location__c();
        
        //Location for which we have to stored the file
        List<Deal_Location__c> DealLocationList=[Select id, Wave_Plan_Version__r.deal__c, Wave_Plan_Version__c,Location_Name__c, Deployment_Lead_New__c, 
                                                Location__c,Wave_Plan_Version__r.deal__r.name,Wave_Plan_Version__r.name,Mob_Recruitment_Lead_Primary_New__c,Mob_Recruitment_Lead_Secondary_New__c,
                                                Location_Mobilization_Lead_Secondary_New__c from Deal_Location__c where id=: locationId];        
        if(DealLocationList.size()>0)
        {                       
            strDealLocation=DealLocationList[0]; 
           // fileName='Recruitment Tracker_'+DealLocationList[0].Wave_Plan_Version__r.deal__r.name+'_'+DealLocationList[0].Wave_Plan_Version__r.name+'_'+DealLocationList[0].Location_Name__c;    
            String dealName =UTIL_Constants.EMPTY_STRING;
            String locationName=UTIL_Constants.EMPTY_STRING;
            String wavePlanVersion=UTIL_Constants.EMPTY_STRING;
            
            if(DealLocationList[0].Wave_Plan_Version__r.deal__r.name.length() > 41){
              dealName= DealLocationList[0].Wave_Plan_Version__r.deal__r.name.substring(0, 40);             
            }else{
              dealName= DealLocationList[0].Wave_Plan_Version__r.deal__r.name;    
            }
            
            if(DealLocationList[0].Wave_Plan_Version__r.name.length() > 31){
              wavePlanVersion= DealLocationList[0].Wave_Plan_Version__r.name.substring(0, 30); 
            }else{
              wavePlanVersion= DealLocationList[0].Wave_Plan_Version__r.name;
            }
            
            if(DealLocationList[0].Location_Name__c.length() > 21){
              locationName= DealLocationList[0].Location_Name__c.substring(0, 20);
            }else{
              locationName= DealLocationList[0].Location_Name__c;
            }
                        
            String systemTime= DateTime.now().format('MM-dd-yyyy hh-mm-ss');
            fileName='RT_'+dealName+'_'+wavePlanVersion+'_'+locationName+'_'+systemTime;   
 
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
            trackRec =[select id,File_Name__c,isDownload__c,clickOnDownLoad__c,File_Downloader_User_Name__c from Tracking_Recruitment__c where Deal_Location__c=:locationId];
            if(trackRec.size()==1)
            {
                //Change the name of file in the document
                doc=[Select name, id, Description,Type, IsPublic, FolderId, AuthorId from Document where name=:trackRec[0].File_Name__c];   
                if(doc.size()>0)
                {
                    //doc[0].name=fileName+'_'+System.now().format('EEEE, MMMM d, yyyy - hh-mm-ss');
                    doc[0].name=fileName;
                    upsert doc[0];
                    fileId=doc[0].id; 
                    fileDownloadedConfirm=true;   
                    trackRec[0].File_Name__c=doc[0].name;     
                }
                trackRec[0].isDownload__c=false;
                trackRec[0].clickOnDownLoad__c=true;
                trackRec[0].File_Downloader_User_Name__c=UserName;
                upsert trackRec[0];
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
            trackRec =[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_Recruitment__c where Deal_Location__c=:locationId];
            if(trackRec.size()==1)
            {   
                trackRec[0].isDownload__c=true;
                trackRec[0].clickOnDownLoad__c=false;
                upsert trackRec[0];
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
        pagereference pr=new PageReference('/apex/RecruitmentTrackerUpDownLoad?id='+locationId);
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
            trackRec =[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_Recruitment__c where Deal_Location__c=:locationId];
            if(trackRec.size()==1)
            {   
                trackRec[0].isDownload__c=false;
                trackRec[0].clickOnDownLoad__c=false;
                upsert trackRec[0];
                fileDownloadedConfirm=false;  
                isVisibleDownload=true;
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.EMPTY_STRING+e));  
            return null;
        }
        pagereference pr=new PageReference('/apex/RecruitmentTrackerUpDownLoad?id='+locationId);
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
        trackRec =[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_Recruitment__c where Deal_Location__c=:locationId];
        if(trackRec.size()==1)
        {
            String name=trackRec[0].File_Name__c+'.xlsx';
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

        if(fileFullData != null && fileFullData != UTIL_Constants.EMPTY_STRING && uploadFileAtt != null && uploadFileAtt != UTIL_Constants.EMPTY_STRING && dropFileName != null && dropFileName != UTIL_Constants.EMPTY_STRING){
            boolean isInserted=false;
            Savepoint sp = Database.setSavepoint();
            if(fileFullData != uploadFileAtt)
            {
            try
                {
                    reqTracker = new List<Recruitment_Tracker__c>();
                    Integer pivot = fileFullData.indexOf( UTIL_Constants.BACK_R, Integer.valueOf(Math.floor(fileFullData.length() / 2)) );
                    if ( pivot > inputCharacterMax ) 
                    {
                        divideString(fileFullData);
                    }
                    else 
                    {
                        allLines = fileFullData.split(UTIL_Constants.BACK_N);
                    }
                    if(allLines.size() > 0)
                    {
                        if(allLines.size() == 4){
                            count=0;
                            fileFullData = UTIL_Constants.EMPTY_STRING ;
                            uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                            dropFileName = UTIL_Constants.EMPTY_STRING;                           
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot upload empty sheet(without data)'));
                            flagImage=false;                                                          
                            return;
                        }
                        for (Integer i=4;i<allLines.size();i++)
                        {  
                            String[] inputvalues = new String[]{};
                            inputvalues = allLines[i].split(',');
                            Recruitment_Tracker__c rt = new Recruitment_Tracker__c();
                            
                            if(inputvalues.size() != 0)
                            {
                                integer temp=inputvalues.size();
                                if(temp>=1)
                                {
                                    if(inputvalues[0] !=null && inputvalues[0] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.SR_No_RRD_No__c = inputvalues[0];
                                    }
                                }
                                if(temp>=2)
                                {
                                    if(inputvalues[1] !=null && inputvalues[1] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.SLL_Name__c = inputvalues[1];
                                    }
                                }
                                if(temp>=3)
                                {
                                    if(inputvalues[2] !=null && inputvalues[2] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                       rt.Hiring_Type_Voice_or_Data__c = inputvalues[2];
                                    }
                                }
                                if(temp>=4)
                                {
                                    if(inputvalues[3] !=null && inputvalues[3] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Role_Position_Name__c = inputvalues[3];
                                    }
                                }
                                if(temp>=5)
                                {
                                    if(inputvalues[4] !=null && inputvalues[4] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Level__c = inputvalues[4];
                                    }
                                }
                                if(temp>=6)
                                {
                                    if(inputvalues[5] !=null && inputvalues[5] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Services_Tower__c = inputvalues[5];
                                    }
                                }
                                if(temp>=7)
                                {
                                    if(inputvalues[6] !=null && inputvalues[6] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Sub_Process__c = inputvalues[6];
                                    }
                                }
                                if(temp>=8)
                                {
                                    if(inputvalues[7] !=null && inputvalues[7] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Wave_Name__c = inputvalues[7];                 
                                    }
                                }
                                if(temp>=9)
                                {
                                    if(inputvalues[8] !=null && inputvalues[8] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Business_Required_Date_of_Onboarding__c = date.parse(inputvalues[8]); 
                                    }
                                }
                                if(temp>=10)
                                {                           
                                    if(inputvalues[9] !=null && inputvalues[9] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Onboarding_month__c = inputvalues[9];
                                    }
                                }
                                if(temp>=11)
                                {                           
                                    if(inputvalues[10] !=null && inputvalues[10] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Hiring_Status__c = inputvalues[10];
                                    }
                                }
                                if(temp>=12)
                                {
                                    if(inputvalues[11] !=null && inputvalues[11] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.RAG_Status__c = inputvalues[11];
                                    }
                                }
                                if(temp>=13)
                                {
                                    if(inputvalues[12] !=null && inputvalues[12] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Tentative_Onboard_Date__c = date.parse(inputvalues[12]);
                                    }
                                }
                                if(temp>=14)
                                {                           
                                    if(inputvalues[13] !=null && inputvalues[13] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Target_On_board_Date__c = date.parse(inputvalues[13]);
                                    }
                                }
                                if(temp>=15)
                                {
                                    if(inputvalues[14] !=null && inputvalues[14] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Actual_Onboarding_Date__c = date.parse(inputvalues[14]);
                                    }
                                }
                                if(temp>=16)
                                {                           
                                    if(inputvalues[15] !=null && inputvalues[15] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Gender__c = inputvalues[15];
                                    }
                                }
                                if(temp>=17)
                                {                           
                                    if(inputvalues[16] !=null && inputvalues[16] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.First_Name__c = inputvalues[16];
                                    }
                                }
                                if(temp>=18)
                                {
                                    if(inputvalues[17] !=null && inputvalues[17] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Last_Name__c = inputvalues[17];
                                    }
                                }
                                if(temp>=19)
                                {
                                    if(inputvalues[18] !=null && inputvalues[18] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Birth_Date__c = date.parse(inputvalues[18]);
                                    }
                                }
                                if(temp>=20)
                                {                           
                                    if(inputvalues[19] !=null && inputvalues[19] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Contact_Number__c = decimal.valueOf(inputvalues[19]);
                                    }
                                }
                                if(temp>=21)
                                {                           
                                if(inputvalues[20] !=null && inputvalues[20] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Emp_ID__c = inputvalues[20];
                                    }
                                }
                                if(temp>=22)
                                {
                                    if(inputvalues[21] !=null && inputvalues[21] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Enterprise_ID__c = inputvalues[21];
                                    }
                                }
                                if(temp>=23)
                                {
                                    if(inputvalues[22] !=null && inputvalues[22] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.NJO_Induction_Status__c = inputvalues[22];
                                    }
                                }
                                if(temp>=24)
                                {
                                    if(inputvalues[23] !=null && inputvalues[23] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Passport_Number__c = inputvalues[23];
                                    }
                                }
                                if(temp>=25)
                                {
                                    if(inputvalues[24] !=null && inputvalues[24] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Passport_Validity_Date__c = date.parse(inputvalues[24]);
                                    }
                                }
                                if(temp>=26)
                                {
                                    if(inputvalues[25] !=null && inputvalues[25] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Visa_Type__c = inputvalues[25];
                                    }
                                }
                                if(temp>=27)
                                {
                                    if(inputvalues[26] !=null && inputvalues[26] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Visa_Status__c = inputvalues[26];
                                    }
                                }
                                if(temp>=28)
                                {
                                    if(inputvalues[27] !=null && inputvalues[27] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Visa_End_Date__c = date.parse(inputvalues[27]);
                                    }
                                }
                                if(temp>=29)
                                {
                                    if(inputvalues[28] !=null && inputvalues[28] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Visa_Required_by__c = inputvalues[28];
                                    }
                                }
                                if(temp>=30)
                                {
                                    if(inputvalues[29] !=null && inputvalues[29] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.BGC_DB_First_Report_Stats__c = inputvalues[29];
                                    }
                                }
                                if(temp>=31)
                                {
                                    if(inputvalues[30] !=null && inputvalues[30] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.BGC_Status_Final__c = inputvalues[30];
                                    }
                                }
                                if(temp>=32)
                                {
                                    if(inputvalues[31] !=null && inputvalues[31] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Client_Location_KT_City_Country__c = inputvalues[31];
                                    }
                                }
                                if(temp>=33)
                                {
                                    if(inputvalues[32] !=null && inputvalues[32] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.Service_Agreement_Signed__c = inputvalues[32];
                                    }
                                }
                                if(temp>=34)
                                {                           
                                    if(inputvalues[33] !=null && inputvalues[33] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.KT_Location__c = inputvalues[33];
                                    }
                                }
                                if(temp>=35)
                                {
                                    if(inputvalues[34] !=null && inputvalues[34] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.KT_Travel__c = inputvalues[34];
                                    }
                                }
                                if(temp>=36)
                                {
                                    if(inputvalues[35] !=null && inputvalues[35] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.KT_Accomodation__c = inputvalues[35];
                                    }
                                }
                                if(temp>=37)
                                {
                                    if(inputvalues[36] !=null && inputvalues[36] !=UTIL_Constants.EMPTY_STRING)
                                    {
                                        rt.American_Express_Card__c = inputvalues[36];
                                    }
                                }
                                if(temp>=38)
                                {                            
                                    if(inputvalues[37] !=null && inputvalues[37] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Travel_Date__c = date.parse(inputvalues[37]);
                                    }
                                }
                                if(temp>=39)
                                {
                                    if(inputvalues[38] !=null && inputvalues[38] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Return_Date__c = date.parse(inputvalues[38]);
                                    }
                                }
                                if(temp>=40)
                                {
                                    if(inputvalues[39] !=null && inputvalues[39] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Replacement_needed_because_of__c = inputvalues[39];
                                    }
                                }
                                if(temp>=41)
                                {
                                    if(inputvalues[40] !=null && inputvalues[40] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Medical_Clearance__c = inputvalues[40];
                                    }
                                }
                                if(temp>=42)
                                {
                                    if(inputvalues[41] !=null && inputvalues[41] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Medical_Exam_Results__c = inputvalues[41];
                                    }
                                }
                                if(temp>=43)
                                {
                                    if(inputvalues[42] !=null && inputvalues[42] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Epiplex_installed_and_tested__c = inputvalues[42];
                                    }
                                }
                                if(temp>=44)
                                {
                                    if(inputvalues[43] !=null && inputvalues[43] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.USB_Enabled__c = inputvalues[43];
                                    }
                                }
                                if(temp>=45)
                                {
                                    if(inputvalues[44] !=null && inputvalues[44] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Admin_Rights_enabled__c = inputvalues[44];
                                    }
                                }
                                if(temp>=46)
                                {
                                    if(inputvalues[45] !=null && inputvalues[45] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Wifi_Enabled__c = inputvalues[45];
                                    }
                                }
                                if(temp>=47)
                                {
                                    if(inputvalues[46] !=null && inputvalues[46] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Laptop_Ready__c = inputvalues[46];
                                    }
                                }
                                if(temp>=48)
                                {
                                    if(inputvalues[47] !=null && inputvalues[47] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.X3G_Dongle_Required__c = inputvalues[47];
                                    }
                                }
                                if(temp>=49)
                                {
                                    if(inputvalues[48] !=null && inputvalues[48] !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        rt.Iron_Key_Procured__c = inputvalues[48];
                                    }
                                }
                        
                                rt.Deal_Location__c = locationId;
                                reqTracker.add(rt);
                                isInserted=true;
                            }
                   
                        }
                        /* Delete the Object Data */ 
                        if(isInserted==true)      
                        {         
                            /* Delete the Object Data */
                            if(fileFullData != uploadFileAtt)
                            {
                                list<Recruitment_Tracker__c> DeleteList = [select Id from Recruitment_Tracker__c where Deal_Location__c =:locationId limit 5000]; 
                                if(DeleteList.size()>0)
                                {
                                    delete DeleteList;
                                }                           
                            }
                            insert reqTracker;    
                            isDone=true; 
                        }
                        if(isDone==true)
                            {
                                List<Document> docForDelete = new List<Document>();
                                try 
                                { 
                                    if(trackRec.size()==1)
                                    {
                                        docForDelete =[Select name,Body,type,id from Document where name=:trackRec[0].File_Name__c];
                                        if(docForDelete.size()>0)
                                        {
                                        flagImage=false;
                                            //docForDelete[0].Name = fileName+'_'+System.now().format('EEEE, MMMM d, yyyy - hh-mm-ss');
                                            docForDelete[0].Name = fileName;
                                            docForDelete[0].Body = EncodingUtil.base64Decode(uploadFileAtt);
                                            upsert docForDelete[0];
                                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));                                            
                                            //displayfileName=docForDelete[0].name+'.'+docForDelete[0].type; 
                                            //fileId=docForDelete[0].id;
                                        }
                                            trackRec[0].File_Name__c=docForDelete[0].name;
                                            trackRec[0].isDownload__c=false;
                                            trackRec[0].clickOnDownLoad__c=false;
                                            upsert(trackRec[0]);                                                
                                            count=0;
                                            isDone=false;
                                    }
                                    
                                }  
                                catch (DMLException e) 
                                {  
                                    fileFullData = UTIL_Constants.EMPTY_STRING ;
                                     uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                                     dropFileName = UTIL_Constants.EMPTY_STRING;             
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e)); 
                                   // flagImage=false;
                                    return;
                                }
                                finally {  
                                    docForDelete[0].body = null; // clears the viewstate  
                                   // flagImage=false;
                                    //docForDelete[0]= new Document();      
                                 }   
                                disableUpload=true;
                                disableDownload=false;
                                //flagImage=false;
                                return;
                            }//flagImage=false;
                        
                    }//flagImage=false;
                                                                            
                }   
                catch (DMLException e) 
                {  
                    fileFullData = UTIL_Constants.EMPTY_STRING ;
                    uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                    dropFileName = UTIL_Constants.EMPTY_STRING;             
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e)); 
                    //flagImage=false;
                    return;
                }
            }else{
                count=0;
                fileFullData = UTIL_Constants.EMPTY_STRING ;
                uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                dropFileName = UTIL_Constants.EMPTY_STRING;
                //flagImage=false;
                return;
            }
            //flagImage=false;
        }else{
            count=0;
            fileFullData = UTIL_Constants.EMPTY_STRING ;
            uploadFileAtt = UTIL_Constants.EMPTY_STRING;
            dropFileName = UTIL_Constants.EMPTY_STRING;
           // flagImage=false;
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
        Integer pivot = input.indexOf( UTIL_Constants.BACK_R, Integer.valueOf(Math.floor(input.length() / 2)) ); 
        String left = input.substring(0,pivot);
        String right = input.substring(pivot); 

        if ( pivot < inputCharacterMax ) 
        {
            // split left and right chunks, add to allLines
            filelinesLeft = left.split(UTIL_Constants.BACK_N);
            filelinesRight = right.split(UTIL_Constants.BACK_N);

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