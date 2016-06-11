public class DealSpecificReportCreation {
public Boolean section0 {get; set;}
public Boolean section1 {get; set;}
public Boolean section2 {get; set;}
public Boolean section3 {get; set;}
public Boolean section4 {get; set;}
public Boolean section5 {get; set;}
public Boolean section6 {get; set;}
public Boolean section7 {get; set;}
public Boolean section8 {get; set;}
public Boolean section9 {get; set;}
public Boolean section10 {get; set;}
public Boolean section11 {get; set;}
public Boolean section12 {get;set;}
public Boolean section13 {get;set;}

public List<Selectoption> someList {get; set;}
public String selectedValue {get; set;}
///////////

 public List<SelectOption> OpportunityList{get;set;}
 public List<SelectOption> SAPOMIDList{get;set;}
 public List<SelectOption> ClientList{get;set;}
 public List<SelectOption> clientGeoUnit{get;set;}
 public List<SelectOption> clientGeoArea{get;set;}
 public List<SelectOption> offList{get;set;}
 public List<SelectOption> opGroupList{get;set;}
 public List<Report> reportData{get;set;}
 public List<Dashboard> dashboardData{get;set;}
 public List<SelectOption> sapOMOUList{get;set;}
 public String listOppSelected {get; set;}
 public String listSAPOMSelected {get; set;}
 public String listClientSelected {get; set;}
 public String listopGroupSelected {get; set;}
 public String listOUSelected {get; set;}
 public String listGeoAreaSelected {get; set;}
 public String listGeoUnitSelected {get; set;}
 public String listOffSelected {get; set;}
 public String listReportStatusSelected {get; set;}
 public String listOppReportStatusSelected {get; set;}
 public String listStageSelected {get; set;}
 public String listOppStageSelected {get; set;}
 private String x_reportOptions;
 public String iframeSource { get; set; }
 public String iframeSource1 { get; set; }
 public String listDeliveryLocSelected{ get; set; }
 public List<SelectOption> DeliveryLocations{get;set;}
//////////
 public List<SelectOption> dealList{get;set;}
 public String listDealSelected {get; set;}
////////

    public DealSpecificReportCreation () {
        section0 = false;
        section1 = false;
        section2 = false; 
        
        searchCriteria();      
    }

    public List<SelectOption> getReportList() 
    {    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--')); 
        
        for(Report data:[Select r.SystemModstamp, r.OwnerId, r.NamespacePrefix, r.Name, r.LastRunDate, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.DeveloperName, r.Description, r.CreatedDate, r.CreatedById From Report r where r.Name in ('My Program Milestones','My Wave Status','My Transition Summary','Governance Report-GoLive Detail','My SRAT','My OPEX') ORDER BY r.Name])
        {
            options.add(new SelectOption(data.Name,data.Name));
        }
       // options.add(new SelectOption('My SRAT','My SRAT'));
        return options;
    }
    List<Operating_Group_Master__c> listopGroup= [Select Name, Id From Operating_Group_Master__c where Active__c=true order by Name];
    
    public void searchCriteria()
    {
      //SAPOMIDList=null;  
     // ClientList=null;
      //OpportunityList= null;
      
        //Load SAP OM ID Start
        //Code Commented as not used and causing view state error
        /*List<Opportunity_TGP__c> listSapOm= [Select SAP_OM_Opportunity__r.name, Name, Id From Opportunity_TGP__c where SAP_OM_Opportunity__c!=null order by name];
        List<SelectOption> SAPList= new List<SelectOption>();
        SAPList.add(new SelectOption('','All')); 
        for(Opportunity_TGP__c  tempSAP : listSapOm)
        {
            SAPList.add(new SelectOption(tempSAP.SAP_OM_Opportunity__r.name,tempSAP.SAP_OM_Opportunity__r.name));        
        }        
        SAPOMIDList= SAPList;*/
        //Load SAP OM ID  End
        
        //Load Client Start
        //Code Commented as not used and causing view state error
        /*List<Client_Master__c> listClient= [Select name, Id From Client_Master__c where name!=null order by name];
        List<SelectOption> CLList= new List<SelectOption>();
        CLList.add(new SelectOption('','All')); 
        for(Client_Master__c tempClient : listClient)
        {
            CLList.add(new SelectOption(tempClient.name,tempClient.name));        
        }        
        ClientList= CLList;*/
        //Load Client End
        
        
        //Load Opportunity  Start
        //Code Commented as not used and causing view state error
        /*List<Opportunity_TGP__c> listOpp= [select id,name from Opportunity_TGP__c order by name];
        List<SelectOption> oppSelectList= new List<SelectOption>();
        oppSelectList.add(new SelectOption('','All')); 
        for(Opportunity_TGP__c  tempOpp : listOpp)
        {
            oppSelectList.add(new SelectOption(tempOpp.id,tempOpp.name));        
        }        
        OpportunityList= oppSelectList;*/
        //Load Opportunity  End
        
        //Load Operating Group Master Start
        //Code Commented as not used and causing view state error        
        /*List<SelectOption> opGroupSelectList= new List<SelectOption>();
        opGroupSelectList.add(new SelectOption('','All')); 
        for(Operating_Group_Master__c tempOPGroup : listopGroup)
        {
            opGroupSelectList.add(new SelectOption(tempOPGroup.name,tempOPGroup.name));        
        }        
        opGroupList= opGroupSelectList;*/
        //Load Operating Group Master  End
        
        //Load Client Geo Area Start
        //Code Commented as not used and causing view state error
        /*List<Client_Geo_Area_Master__c> listGeoArea= [Select Name, Id From Client_Geo_Area_Master__c where Active__c=true order by Name];
        List<SelectOption> geoAreaSelectList= new List<SelectOption>();
        geoAreaSelectList.add(new SelectOption('','All')); 
        for(Client_Geo_Area_Master__c tempGeoArea : listGeoArea)
        {
            geoAreaSelectList.add(new SelectOption(tempGeoArea.name,tempGeoArea.name));        
        }        
        clientGeoArea= geoAreaSelectList;*/
        //Load Client Geo Area  End
        
        //Load Client Geo Unit Start
        //Code Commented as not used and causing view state error
        /*List<Client_Geo_Unit_Master__c> listGeoUnit= [Select Name, Id From Client_Geo_Unit_Master__c where Active__c=true order by Name];
        List<SelectOption> geoUnitSelectList= new List<SelectOption>();
        geoUnitSelectList.add(new SelectOption('','All')); 
        for(Client_Geo_Unit_Master__c tempGeoUnit : listGeoUnit)
        {
            geoUnitSelectList.add(new SelectOption(tempGeoUnit.name,tempGeoUnit.name));        
        }        
        clientGeoUnit= geoUnitSelectList;*/
        //Load Client Geo Unit End
        
        
        //Load delivery Location Start
        List<Delievery_Location_Master__c> listDeliveryLoc= [Select Name, Id From Delievery_Location_Master__c where Active__c=true order by Name];
        List<SelectOption> DeliveryLocSelectList= new List<SelectOption>();
        DeliveryLocSelectList.add(new SelectOption('','All')); 
        for(Delievery_Location_Master__c tempDeliveryLoc : listDeliveryLoc)
        {
            DeliveryLocSelectList.add(new SelectOption(tempDeliveryLoc.name,tempDeliveryLoc.name));        
        }        
        DeliveryLocations= DeliveryLocSelectList;
        //Load delivery Location Start
        
        //Load Offering Start
        //Code Commented as not used and causing view state error
        /*List<Offerings_Master__c> listOff= [Select Name, Id From Offerings_Master__c where Active__c=true order by Name];
        List<SelectOption> offSelectList= new List<SelectOption>();
        offSelectList.add(new SelectOption('','All')); 
        for(Offerings_Master__c tempOff : listOff)
        {
            offSelectList.add(new SelectOption(tempOff.name,tempOff.name));        
        }        
        offList= offSelectList;*/
        //Load Offering End
        
        //Load SAP OU Desc Start
        //Code Commented as not used and causing view state error
        /*List<SAP_OM_Opportunity__c> listSAPOMOUDesc= [Select OU_description__c, Id From SAP_OM_Opportunity__c];        
        List<SelectOption> sapOMSelectList= new List<SelectOption>();        
        sapOMSelectList.add(new SelectOption('','All'));         
        sapOMSelectList.add(new SelectOption('CMT EALA OU','CMT EALA OU')); 
        sapOMSelectList.add(new SelectOption('CMT NORTH AMERICA OU','CMT NORTH AMERICA OU')); 
        sapOMSelectList.add(new SelectOption('CMT APAC OU','CMT APAC OU')); 
        sapOMSelectList.add(new SelectOption('PRD EALA OU','PRD EALA OU')); 
        sapOMSelectList.add(new SelectOption('PRD NORTH AMERICA OU','PRD NORTH AMERICA OU')); 
        sapOMSelectList.add(new SelectOption('PRD APAC OU','PRD APAC OU')); 
        sapOMSelectList.add(new SelectOption('FS EALA OU','FS EALA OU')); 
        sapOMSelectList.add(new SelectOption('FS NORTH AMERICA OU','FS NORTH AMERICA OU')); 
        sapOMSelectList.add(new SelectOption('FS APAC OU','FS APAC OU')); 
        sapOMSelectList.add(new SelectOption('RES EALA OU','RES EALA OU')); 
        sapOMSelectList.add(new SelectOption('RES NORTH AMERICA OU','RES NORTH AMERICA OU')); 
        sapOMSelectList.add(new SelectOption('RES APAC OU','RES APAC OU')); 
        sapOMSelectList.add(new SelectOption('HPS EALA OU','HPS EALA OU')); 
        sapOMSelectList.add(new SelectOption('HPS NORTH AMERICA OU','HPS NORTH AMERICA OU')); 
        sapOMSelectList.add(new SelectOption('HPS APAC OU','HPS APAC OU'));
        for(SAP_OM_Opportunity__c tempSAPOM : listSAPOMOUDesc)
        {
            if(tempSAPOM.OU_description__c != null)
            sapOMSelectList.add(new SelectOption(tempSAPOM.OU_description__c,tempSAPOM.OU_description__c));        
        }        
        sapOMOUList= sapOMSelectList;*/
        
        //Load SAP OU Desc End
        
        //Load Deal  Start
        List<Deal_TGP__c> listdeal= [select id,name from Deal_TGP__c order by name];
        List<SelectOption> dealSelectList= new List<SelectOption>();
        dealSelectList.add(new SelectOption('','All')); 
        for(Deal_TGP__c  tempDeal : listdeal)
        {
            dealSelectList.add(new SelectOption(tempDeal.name,tempDeal.name));        
        }        
        dealList= dealSelectList;
        //Load Deal  End
    }
    /*********
    Get the Reporting Status Vaues using below Code
    **********/
    static Schema.DescribeFieldResult F = Opportunity_TGP__c.Activity__c.getDescribe();
    static List<Schema.PicklistEntry> peList = F.getPicklistValues();
    public List<SelectOption> getReportingStatus(){    
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('All','All'));
     
        for(Integer i=0;i<peList.size();i++){
            String temp = peList[i].getValue();
            options.add(new SelectOption(temp,temp));       
        
        }
   
    return options;
    } 
   
   /*********
    Get the Stage Vaues using below Code
    **********/
    static Schema.DescribeFieldResult status = Opportunity_TGP__c.Stage__c.getDescribe();
    static List<Schema.PicklistEntry> statusList = status.getPicklistValues();
    public List<SelectOption> getStatus()
    {
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('All','All'));
     
        for(Integer i=0;i<statusList.size();i++){
            String temp = statusList[i].getValue();
            options.add(new SelectOption(temp,temp));       
        
        }
    
    return options;
    } 
    
    /*********
    Get the Stage Vaues using below Code for "Top 25 Opportunitie Stage 2 and above1" report.
    **********/
    static Schema.DescribeFieldResult oppStage = Opportunity_TGP__c.Stage__c.getDescribe();
    static List<Schema.PicklistEntry> oppStageList = oppStage.getPicklistValues();
    public List<SelectOption> getoppStage()
    {
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('All','All'));
     
        for(Integer i=0;i<oppStageList.size();i++){
            String temp = oppStageList[i].getValue();
            if(temp !='Stage 0' && temp !='Stage 1'){
                options.add(new SelectOption(temp,temp));       
            }
        }
    return options;
    } 
    
     /*********
    Get the Reporting Status Vaues using below Code for "Top 25 Opportunitie Stage 2 and above1" report.
    **********/
    static Schema.DescribeFieldResult oppRStatus = Opportunity_TGP__c.Activity__c.getDescribe();
    static List<Schema.PicklistEntry> oppRSList = oppRStatus.getPicklistValues();
    public List<SelectOption> getOppReportingStatus(){    
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('All','All'));
     
        for(Integer i=0;i<oppRSList.size();i++){
            String temp = oppRSList[i].getValue();
            if(temp !='Accenture Withdrew' && temp !='Client Withdrew' && temp !='Lost' && temp !='Won'){
                options.add(new SelectOption(temp,temp));       
            }
        }
   
    return options;
    }
    
    public Pagereference updateData() {
        iframeSource=''; 
        if(selectedValue ==null){
            section1 = false;
            section2 = false;
            section3 = false;
            section4 = false;
            section5 = false;
            section6 = false;
            section7 = false;
            section8 = false;
            section9 = false;
            section10 = false; 
            section11 = false;
            section12 = false;
            section13 = false; 
            return null;
        } 
        if(selectedValue !=null){ 
        
           if(selectedValue == 'My SRAT1'){
               dashboardData= [Select d.Type, d.TitleSize, d.TitleColor, d.Title, d.TextColor, d.SystemModstamp, d.RunningUserId, d.RightSize, d.NamespacePrefix, d.MiddleSize, d.LeftSize, d.LastModifiedDate, d.LastModifiedById, d.IsDeleted, d.Id, d.FolderId, d.DeveloperName, d.Description, d.CreatedDate, d.CreatedById, d.BackgroundStart, d.BackgroundEnd, d.BackgroundDirection From Dashboard d where d.Title =:selectedValue];
                x_reportOptions =dashboardData[0].id;
                if(dashboardData[0].Title == 'My SRAT') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = true;
            }
               
           }else{
           
               reportData= [Select r.SystemModstamp, r.OwnerId, r.NamespacePrefix, r.Name, r.LastRunDate, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.DeveloperName, r.Description, r.CreatedDate, r.CreatedById From Report r where r.Name=:selectedValue];
                x_reportOptions =reportData[0].id;
      
                if(reportData[0].name == 'In Flight - Transition Status Summary') {
                listDealSelected ='';      
               
                section1 = true;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;     
                         
            } else if(reportData[0].name == 'My Program Milestones') {
                listDealSelected ='';
                
                section1 = false;
                section2 = true;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;
                
            }else if(reportData[0].name == 'Governance Report-GoLive Detail') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = true;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;
            }else if(reportData[0].name == 'GoLive Detail_SRAT') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = true;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;
            }else if(reportData[0].name == 'Governance Report-GoLive Detail_OPEX') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = true;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;
            }else if(reportData[0].name == 'Mob - Go Lives - Forward Looking View') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = true;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;
            }else if(reportData[0].name == 'Watch List Summary') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = true;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;
            }else if(reportData[0].name == 'My Wave Status') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = true;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;
            }else if(reportData[0].name == 'In Flight – Transition Status – 30 day') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = true;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = false;
            }else if(reportData[0].name == 'My Transition Summary') {
                listDealSelected ='';
                listDeliveryLocSelected='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = true;
                section11 = false;
                section12 = false;
                section13 = false;
            }
            else if(reportData[0].name == 'My SRAT') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = true;
                section13 = false;
        }   
            else if(reportData[0].name == 'My OPEX') {
                listDealSelected ='';
                
                section1 = false;
                section2 = false;
                section3 = false;
                section4 = false;
                section5 = false;
                section6 = false;
                section7 = false;
                section8 = false;
                section9 = false;
                section10 = false;
                section11 = false;
                section12 = false;
                section13 = true;
        }
     }       
          
    }
     return null;
    }
    
   //submitRequestIds.split('\\,');
    
    public PageReference reloadIframe1() {

        //String opGroupId= listopGroupSelected.substring(0, 15);
        /*String reportURL = x_reportOptions + '?pv0=' +listopGroupSelected
        + '&pv1=' +listGeoAreaSelected
        + '&pv2=' +listGeoUnitSelected;*/
       
        /*String val='';
        if(listopGroupSelected==null)
        {
 
            for(integer x =0;x<listopGroup.size();x++){
               if(x>0) val+=',';  
                   val+= listopGroup[x].name;
            } 
        }*/
        if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv2=' +listDealSelected;
        
      //  iframeSource = 'https://na15.salesforce.com/00Oi0000000fKEaEAM?pv0=&pv1=7%2F3%2F2015' ;
       //iframeSource1 = '/01ZL00000008QJ9?isdtp=mn';
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe2() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv4=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';

        return null;
    }
    
    public PageReference reloadIframe3() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv4=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe4() {

        if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv6=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe5() {

        if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv7=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe6() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv4=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe7() {

        if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv2=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe8() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv4=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe9() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv4=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe10() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
        if(listDeliveryLocSelected==null){
            listDeliveryLocSelected='';
        }
        String reportURL = x_reportOptions 
        + '?pv3=' +listDealSelected
        + '&pv7=' +listDeliveryLocSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    public PageReference reloadIframe11() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv1=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    public PageReference reloadIframe12() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv5=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    public PageReference reloadIframe13() {

         if(listDealSelected ==null){
            listDealSelected ='';
        }
       
        String reportURL = x_reportOptions 
        + '?pv6=' +listDealSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    
}