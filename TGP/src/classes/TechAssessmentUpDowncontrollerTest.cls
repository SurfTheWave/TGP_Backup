/**
Author : Vinay Kumar Chada
Story  : 
Description : Test Class for TechAssessmentUpDowncontrollerTest. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class TechAssessmentUpDowncontrollerTest{
static Tracking_Tech_Assessment__c techTracking;
static Document doc;

static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
static Offerings_Master__c offering;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;
static Wave_Planning__c waveplan;
static Wave_Process__c WaveProcess;
static Deal_Location__c dealLoc;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;



public static void setupData1(){
                            
clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

// To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
insert deliveryLocMa;

// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;

// To create a offering
offering =new Offerings_Master__c();
offering.Name='Test Data';
insert offering;

//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
insert dealHome;


// To create a Deal Location
dealLoc= new Deal_Location__c();
dealLoc.Location__c='test Data';
dealLoc.Deal_Home_Location__c=dealHome.id;
dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
insert dealLoc;

// To Create Client Specific Process Mapping

clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping.Name='TestData';
clientSpecificProcessMapping.Deal__c=deal.id;
clientSpecificProcessMapping.Offering__c=offering.id;
insert clientSpecificProcessMapping;

//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test data';
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

// To create a Wave Process

WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
insert WaveProcess;


techTracking = new Tracking_Tech_Assessment__c();
techTracking.File_Name__c='TechAssessment Tracker';
techTracking.isDownload__c=true;
techTracking.clickOnDownLoad__c=true;
techTracking.File_Downloader_User_Name__c='Vinay Chada';
techTracking.Deal_Wave__c=waveplan.id;
insert techTracking;

doc = new Document();
doc.name='TechAssessment Tracker';
doc.Body = Blob.valueOf('AAC0811EST022916_Quotation.xlsx');
doc.type='xlsx';
doc.AuthorId = UserInfo.getUserId();
 LIST<FOLDER> fol = [SELECT ID,NAME FROM FOLDER WHERE NAME = 'Shared Documents' and type = 'document'];
if(fol.size() > 0)
doc.FolderId = fol[0].id;
else
doc.FolderId = UserInfo.getUserId();
doc.IsPublic = true;
insert doc;

}


public static void setupData2(){

clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

// To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
insert deliveryLocMa;

// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;

// To create a offering
offering =new Offerings_Master__c();
offering.Name='Test Data';
insert offering;

//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
insert dealHome;


// To create a Deal Location
dealLoc= new Deal_Location__c();
dealLoc.Location__c='test Data';
dealLoc.Deal_Home_Location__c=dealHome.id;
dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
insert dealLoc;

// To Create Client Specific Process Mapping

clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping.Name='TestData';
clientSpecificProcessMapping.Deal__c=deal.id;
clientSpecificProcessMapping.Offering__c=offering.id;
insert clientSpecificProcessMapping;

//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test data';
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

// To create a Wave Process

WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
insert WaveProcess;


techTracking = new Tracking_Tech_Assessment__c();
techTracking.File_Name__c='TechAssessment Tracker';
techTracking.isDownload__c=false;
techTracking.clickOnDownLoad__c=false;
techTracking.File_Downloader_User_Name__c='Vinay Chada';
techTracking.Deal_Wave__c=waveplan.id;
insert techTracking;

doc = new Document();
doc.name='TechAssessment Tracker';
doc.Body = Blob.valueOf('AAC0811EST022916_Quotation.xlsx');
doc.type='xlsx';
doc.AuthorId = UserInfo.getUserId();
 LIST<FOLDER> fol = [SELECT ID,NAME FROM FOLDER WHERE NAME = 'Shared Documents' and type = 'document'];
if(fol.size() > 0)
doc.FolderId = fol[0].id;
else
doc.FolderId = UserInfo.getUserId();
doc.IsPublic = true;
insert doc;

}
static testMethod void test1(){ 
    test.starttest();
    
    setupData1();
    
    ApexPages.StandardController controller;
   
    apexpages.currentpage().getparameters().put('Id' ,waveplan.id); 
    TechAssessmentUpDowncontroller tTracker = new TechAssessmentUpDowncontroller(controller);

    tTracker.DownloadFile();
    tTracker.actionYes();
    tTracker.actionNo();
    tTracker.UploadFile(); 

        
    test.stoptest();
    }
    
    static testMethod void test2(){ 
    test.starttest();
    
    //setupData1();
    setupData2();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,waveplan.id); 
    TechAssessmentUpDowncontroller tTracker = new TechAssessmentUpDowncontroller( controller);

    tTracker.count=1;   
    tTracker.fileFullData='SHEET: Application Resource List'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'test 1,test 2,06/06/13,06/06/78,06/06/78,google.com,vinay,Yes,Yes,Others,Access Granted,Commens';
    tTracker.uploadFileAtt='test';
    tTracker.dropFileName='TechAssessment Tracker.xlsx';

    tTracker.DownloadFile();
    tTracker.actionYes();
    tTracker.actionNo();
    tTracker.UploadFile();
    
    test.stoptest();
    }
    
    /*static testMethod void test3(){ 
    test.starttest();
    
    setupData1();
    setupData2();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,waveplan.id); 
    TechAssessmentUpDowncontroller tTracker = new TechAssessmentUpDowncontroller( controller);
  
    tTracker.fileFullData='SHEET: Application Resource List'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'test 1,test 2,06/06/13,06/06/78,06/06/78,google.com,vinay,Yes,Yes,Others,Access Granted,Commens';
    tTracker.uploadFileAtt='test';
    tTracker.dropFileName='TechAssessment Tracker.xlsx';

    tTracker.DownloadFile();

    
    test.stoptest();
    }
    static testMethod void test4(){ 
    test.starttest();
    
    setupData1();
    setupData2();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,waveplan.id);  
    TechAssessmentUpDowncontroller tTracker = new TechAssessmentUpDowncontroller( controller);
  
    tTracker.fileFullData='SHEET: Application Resource List'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'Test Data'+'\n'
                            +'test 1,test 2,06/06/13,06/06/78,06/06/78,google.com,vinay,Yes,Yes,Others,Access Granted,Commens';
    tTracker.uploadFileAtt='test';
    tTracker.dropFileName='TechAssessment Tracker.xlsx';

    tTracker.actionYes();
    tTracker.actionNo();    
    test.stoptest();
    }*/
}