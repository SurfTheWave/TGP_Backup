/**
Author : Vinay Kumar Chada
Story  : 
Description : Test Class for Mob_KTTrackingcontrollerTest. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class RecruitmentTrackerUpDownControllerTest{
static Deal_TGP__c strDealTGP;
static Wave_Plan_Version__c strWavePlanVersion;
static Deal_Location__c dealLoc;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;
static Tracking_Recruitment__c trackingRecrutment;
static Document doc;

public static void setupData(){

clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

// To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
insert deliveryLocMa;

strDealTGP=new Deal_TGP__c(Name='DealTest123');
insert strDealTGP;

dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= strDealTGP.id;
insert dealHome;

strWavePlanVersion =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=strDealTGP.id);
insert strWavePlanVersion; 

dealLoc= new Deal_Location__c();
dealLoc.Location__c='test Data';
dealLoc.Deal_Home_Location__c=dealHome.id;
dealLoc.Wave_Plan_Version__c=strWavePlanVersion .id;
insert dealLoc;

trackingRecrutment = new Tracking_Recruitment__c();
trackingRecrutment.File_Name__c='Recruitment Tracker';
trackingRecrutment.isDownload__c=true;
trackingRecrutment.clickOnDownLoad__c=true;
trackingRecrutment.Deal_Location__c =dealLoc.id;
trackingRecrutment.File_Downloader_User_Name__c='Vinay Chada';
insert trackingRecrutment;

}

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

strDealTGP=new Deal_TGP__c(Name='DealTest123');
insert strDealTGP;

dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= strDealTGP.id;
insert dealHome;

strWavePlanVersion =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=strDealTGP.id);
insert strWavePlanVersion; 

dealLoc= new Deal_Location__c();
dealLoc.Location__c='test Data';
dealLoc.Deal_Home_Location__c=dealHome.id;
dealLoc.Wave_Plan_Version__c=strWavePlanVersion .id;
insert dealLoc;
trackingRecrutment = new Tracking_Recruitment__c();
trackingRecrutment.File_Name__c='Recruitment Tracker';
trackingRecrutment.isDownload__c=false;
trackingRecrutment.clickOnDownLoad__c=true;
trackingRecrutment.File_Downloader_User_Name__c='Vinay Chada';
trackingRecrutment.Deal_Location__c =dealLoc.id;

insert trackingRecrutment;

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

strDealTGP=new Deal_TGP__c(Name='DealTest123');
insert strDealTGP;

dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= strDealTGP.id;
insert dealHome;

strWavePlanVersion =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=strDealTGP.id);
insert strWavePlanVersion; 

dealLoc= new Deal_Location__c();
dealLoc.Location__c='test Data';
dealLoc.Deal_Home_Location__c=dealHome.id;
dealLoc.Wave_Plan_Version__c=strWavePlanVersion .id;
insert dealLoc;

doc = new Document();
doc.name='Recruitment Tracker';
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

trackingRecrutment = new Tracking_Recruitment__c();
trackingRecrutment.File_Name__c='Recruitment Tracker';
trackingRecrutment.isDownload__c=true;
trackingRecrutment.clickOnDownLoad__c=true;
trackingRecrutment.Deal_Location__c =dealLoc.id;
trackingRecrutment.File_Downloader_User_Name__c='Vinay Chada';
insert trackingRecrutment;


}
static testMethod void test1(){ 
    test.starttest();
    setupData();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,dealLoc.id); 
    RecruitmentTrackerUpDownLoadcontroller rTracker = new RecruitmentTrackerUpDownLoadcontroller( controller);

    rTracker.DownloadFile();
    rTracker.actionYes();
    rTracker.actionNo();
    rTracker.UploadFile();
    test.stoptest();
    }
    
    static testMethod void test2(){ 
    test.starttest();
    setupData2();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,dealLoc.id); 
    RecruitmentTrackerUpDownLoadcontroller rTracker = new RecruitmentTrackerUpDownLoadcontroller( controller);

    rTracker.count=1;   
    rTracker.fileFullData='SHEET: Sheet1'+'\n'
    +'Test data'+'\n'
    +',,* - Mandatory fields,,,,,,,Date format should be MM/DD/YY,,,,Date format should be MM/DD/YY,Date format should be MM/DD/YY,Date format should be MM/DD/YY,,,,Date format should be MM/DD/YY,,,,,,Date format should be MM/DD/YY,,,Date format should be MM/DD/YY,,,,,,,,,,Date format should be MM/DD/YY,Date format should be MM/DD/YY,,,,,,,,,,'+'\n'
    +'SR No / RRD No.   *,SLL Name,DCN Location *,Hiring Type (Voice or Data)   *,Role/Position Name,Level   *,Services/Tower   *,Sub-Process   *,Wave Name   *,Business Required Date of Onboarding   *,Onboarding month   *,Hiring Status   *,RAG Status   *,Tentative Onboard Date,Target On-board Date   *,Actual Onboarding Date,Gender,First Name   *,Last Name   *,Birth Date,Contact Number,Emp ID,Enterprise ID,NJO Induction Status   *,Passport Number   *,Passport Validity Date   *,Visa Type    *,Visa Status   *,Visa End Date   *,Visa Required by   *,BGC DB/First Report Stats   *,BGC Status Final - Cleared / Not cleared   *,Client Location(KT City/Country)   *,Service Agreement Signed ,KT Location   *,KT Travel   *,KT Accomodation   *,American Express Card   *,Travel Date   *,Return Date   *,Replacement needed because of,Medical Clearance   *,Medical Exam Results,Epiplex installed and tested,USB Enabled   *,Admin Rights enabled   *,Wifi Enabled   *,Laptop Ready   *,3G Dongle Required   *,Iron Key Procured   *'+'\n'
    +'1,1,oice,External: Permanent Hire,Level A,Client SP1, Sub Process 1,W1,05/05/13,February,Offer Accepted,On Track,05/05/05,05/05/05,05/05/05,Male,vinay,kumar,05/05/05,,1234,vinay,Completed,1000,05/05/05,B1,Complete,05/05/05,vinay chada,Clear,Yes,Bangalore,B1,India,Yes,Apartment Required,Yes,05/05/05,05/05/05,Attrited,Yes,Test Data,Yes,Yes,Yes,No,Yes,Yes,Yes';
    rTracker.uploadFileAtt='test';
    rTracker.dropFileName='Recruitment Tracker.xlsx';

    rTracker.DownloadFile();
    rTracker.actionYes();
    rTracker.actionNo();
    rTracker.UploadFile();
    test.stoptest();
    }
}