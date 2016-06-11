public class DynamicReportCreation {
public Boolean section0 {get; set;}
public Boolean section1 {get; set;}
public Boolean section2 {get; set;}
public Boolean section3 {get; set;}
public Boolean section4 {get; set;}
public Boolean section5 {get; set;}
public Boolean section6 {get; set;}
public List<Selectoption> someList {get; set;}
public String selectedValue {get; set;}
///////////
public String reportID {get; set;}


 public List<SelectOption> OpportunityList{get;set;}
 public List<SelectOption> SAPOMIDList{get;set;}
 public List<SelectOption> ClientList{get;set;}
 public List<SelectOption> clientGeoUnit{get;set;}
 public List<SelectOption> clientGeoArea{get;set;}
 public List<SelectOption> offList{get;set;}
 public List<SelectOption> opGroupList{get;set;}
 public List<Report> reportData{get;set;}
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
//////////

    public DynamicReportCreation () {
        section0 = false;
        section1 = false; 
        section2 = false;
        section3 = false;
        section4 = false;
        section5 = false;
        section6 = false;
        searchCriteria();      
    }

    public List<SelectOption> getReportList() 
    {    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--')); 
        for(Report data:[Select r.SystemModstamp, r.OwnerId, r.NamespacePrefix, r.Name, r.LastRunDate, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.DeveloperName, r.Description, r.CreatedDate, r.CreatedById From Report r where r.Name in ('Active Stage 2+Opportunities not in SWB','BPO Opportunity Raw Data Report','Deals with CCI% lower than 29.5%','New Demand','Next 15 RFPs Due','Opportunity Report','Top 25 Stage 2 + Active Opportunities')])
        {
          // if(data.DeeloperName.contains(x_reportPrefix))
         //   {         
                options.add(new SelectOption(data.Name,data.Name));
                
               /* if(getReportOptions() == null || getReportOptions() == '')
                {
                    setReportOptions(data.Id);
                }*/
          // }   
        }
        
        return options;
    }
    List<Operating_Group_Master__c> listopGroup= [Select Name, Id From Operating_Group_Master__c where Active__c=true order by Name];
     public void searchCriteria()
    {
      //SAPOMIDList=null;  
     // ClientList=null;
      //OpportunityList= null;
      
      //Load SAP OM ID Start
        List<Opportunity_TGP__c> listSapOm= [Select SAP_OM_Opportunity__r.name, Name, Id From Opportunity_TGP__c where SAP_OM_Opportunity__c!=null order by name];
        List<SelectOption> SAPList= new List<SelectOption>();
        SAPList.add(new SelectOption('','All')); 
        for(Opportunity_TGP__c  tempSAP : listSapOm)
        {
            SAPList.add(new SelectOption(tempSAP.SAP_OM_Opportunity__r.name,tempSAP.SAP_OM_Opportunity__r.name));        
        }        
        SAPOMIDList= SAPList;
        //Load SAP OM ID  End
        
        //Load Client Start
        List<Client_Master__c> listClient= [Select name, Id From Client_Master__c where name!=null order by name];
        List<SelectOption> CLList= new List<SelectOption>();
        CLList.add(new SelectOption('','All')); 
        for(Client_Master__c tempClient : listClient)
        {
            CLList.add(new SelectOption(tempClient.name,tempClient.name));        
        }        
        ClientList= CLList;
        //Load Client End
        
        
      //Load Opportunity  Start
        List<Opportunity_TGP__c> listOpp= [select id,name from Opportunity_TGP__c order by name];
        List<SelectOption> oppSelectList= new List<SelectOption>();
        oppSelectList.add(new SelectOption('','All')); 
        for(Opportunity_TGP__c  tempOpp : listOpp)
        {
            oppSelectList.add(new SelectOption(tempOpp.id,tempOpp.name));        
        }        
        OpportunityList= oppSelectList;
        //Load Opportunity  End
        
        //Load Operating Group Master Start        
        
        List<SelectOption> opGroupSelectList= new List<SelectOption>();
        opGroupSelectList.add(new SelectOption('','All')); 
        for(Operating_Group_Master__c tempOPGroup : listopGroup)
        {
            opGroupSelectList.add(new SelectOption(tempOPGroup.name,tempOPGroup.name));        
        }        
        opGroupList= opGroupSelectList;
        //Load Operating Group Master  End
        
        //Load Client Geo Area Start
        List<Client_Geo_Area_Master__c> listGeoArea= [Select Name, Id From Client_Geo_Area_Master__c where Active__c=true order by Name];
        List<SelectOption> geoAreaSelectList= new List<SelectOption>();
        geoAreaSelectList.add(new SelectOption('','All')); 
        for(Client_Geo_Area_Master__c tempGeoArea : listGeoArea)
        {
            if(!tempGeoArea.name.equals('EALA'))
            {
                geoAreaSelectList.add(new SelectOption(tempGeoArea.name,tempGeoArea.name));     
            }   
        }        
        clientGeoArea= geoAreaSelectList;
        //Load Client Geo Area  End
        
        //Load Client Geo Unit Start
        List<Client_Geo_Unit_Master__c> listGeoUnit= [Select Name, Id From Client_Geo_Unit_Master__c where Active__c=true order by Name];
        List<SelectOption> geoUnitSelectList= new List<SelectOption>();
        geoUnitSelectList.add(new SelectOption('','All')); 
        for(Client_Geo_Unit_Master__c tempGeoUnit : listGeoUnit)
        {
            geoUnitSelectList.add(new SelectOption(tempGeoUnit.name,tempGeoUnit.name));        
        }        
        clientGeoUnit= geoUnitSelectList;
        //Load Client Geo Unit End
        
        //Load Offering Start
        List<Offerings_Master__c> listOff= [Select Name, Id From Offerings_Master__c where Active__c=true order by Name];
        List<SelectOption> offSelectList= new List<SelectOption>();
        offSelectList.add(new SelectOption('','All')); 
        for(Offerings_Master__c tempOff : listOff)
        {
            offSelectList.add(new SelectOption(tempOff.name,tempOff.name));        
        }        
        offList= offSelectList;
        //Load Offering End
        
         //Load SAP OU Desc Start
        //Code Fix to address SWB Ticket-209,Changes from List to Set @Rajdeep
        //List<SAP_OM_Opportunity__c> listSAPOMOUDesc= [Select OU_description__c, Id From SAP_OM_Opportunity__c];        
        
        
        Set<String> setSAPOMOUDesc= new Set<String>(); 
        for (SAP_OM_Opportunity__c itrSapOMOpp : [Select OU_description__c, Id From SAP_OM_Opportunity__c])  {
            setSAPOMOUDesc.add(itrSapOMOpp.OU_description__c);
        }
        //Code Fix to address SWB Ticket-209,Changes from List to Set @Rajdeep

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
        //Code Fix to address SWB Ticket-209,Changes from List to Set @Rajdeep
        for(String itrStr : setSAPOMOUDesc)
        {
            if(itrStr != null)
            sapOMSelectList.add(new SelectOption(itrStr,itrStr));        
        }        
        //Code Fix to address SWB Ticket-209,Changes from List to Set @Rajdeep
        sapOMOUList= sapOMSelectList;
        
        //Load SAP OU Desc End

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
    Get the Stage Vaues using below Code for "Top 25 Opportunities Stage 2 and above1" report.
    **********/
    static Schema.DescribeFieldResult oppStage = Opportunity_TGP__c.Stage__c.getDescribe();
    static List<Schema.PicklistEntry> oppStageList = oppStage.getPicklistValues();
    public List<SelectOption> getoppStage()
    {
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('All','All'));
     
        for(Integer i=0;i<oppStageList.size();i++){
            String temp = oppStageList[i].getValue();
            if(temp !='0A' && temp !='1'){
                options.add(new SelectOption(temp,temp));       
            }
        }
    return options;
    } 
    
    /*********
    Get the Reporting Status Vaues using below Code for "SAP OM Opportunities not in SWB" report.
    **********/
    static Schema.DescribeFieldResult sapOMRStatus = Opportunity_TGP__c.Activity__c.getDescribe();
    static List<Schema.PicklistEntry> sapOMRSList = sapOMRStatus.getPicklistValues();
    public List<SelectOption> getsapOMReportingStatus(){    
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('All','All'));
     
        for(Integer i=0;i<sapOMRSList.size();i++){
            String temp = sapOMRSList[i].getValue();
            if(temp !='Accenture Withdrew' && temp !='Client Withdrew' && temp !='Lost' && temp !='Won'){
                options.add(new SelectOption(temp,temp));       
            }
        }
   
    return options;
    }
    
    /*********
    Get the Reporting Status Vaues using below Code for "Top 25 Opportunities Stage 2 and above1" report.
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
    listopGroupSelected='';
    iframeSource='';  
    if(selectedValue ==null){
        section1 = false;
        section2 = false; 
        section3 = false;
        section4 = false;
        section5 = false;
        section6 = false; 
        return null;
    }
    if(selectedValue !=null){ 
        
       reportData= [Select r.SystemModstamp, r.OwnerId, r.NamespacePrefix, r.Name, r.LastRunDate, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.DeveloperName, r.Description, r.CreatedDate, r.CreatedById From Report r where r.Name=:selectedValue];
       if(reportData.size() > 0){ 
           x_reportOptions =reportData[0].id;
           reportID= x_reportOptions.substring(0, 15);
       }
       
    } 
     if(reportData.size() > 0){  
        if(reportData[0].name == 'Opportunity Report') {
            listopGroupSelected='';
            listGeoAreaSelected='';
            listGeoUnitSelected='';
            listOffSelected='';
            listReportStatusSelected='';
            listStageSelected='';
            listOUSelected='';
            listOppReportStatusSelected='';
            listOppStageSelected='';            
           
            section1 = true;
            section2 = false; 
            section3 = false;
            section4 = false;
            section5 = false;
            section6 = false;
            iframeSource = '/'+reportID+'?isdtp=mn';           
                     
        } else if(reportData[0].name == 'Top 25 Stage 2 + Active Opportunities') {
           
            listopGroupSelected='';
            listGeoAreaSelected='';
            listGeoUnitSelected='';
            listOffSelected='';
            listReportStatusSelected='';
            listStageSelected='';
            listOUSelected='';
            listOppReportStatusSelected='';
            listOppStageSelected='';
            
            section1 = false;
            section2 = true;
            section3 = false;
            section4 = false;
            section5 = false;
            section6 = false;
            iframeSource = '/'+reportID+'?isdtp=mn';
        }else if(reportData[0].name == 'New Demand') {
           
            listopGroupSelected='';
            listGeoAreaSelected='';
            listGeoUnitSelected='';
            listOffSelected='';
            listReportStatusSelected='';
            listStageSelected='';
            listOUSelected='';
            listOppReportStatusSelected='';
            listOppStageSelected='';
            
            section1 = false;
            section2 = false;
            section3 = true;
            section4 = false;
            section5 = false;
            section6 = false;
            iframeSource = '/'+reportID+'?isdtp=mn';
        }else if(reportData[0].name == 'Next 15 RFPs Due') {
           
            listopGroupSelected='';
            listGeoAreaSelected='';
            listGeoUnitSelected='';
            listOffSelected='';
            listReportStatusSelected='';
            listStageSelected='';
            listOUSelected='';
            listOppReportStatusSelected='';
            listOppStageSelected='';
            
            section1 = false;
            section2 = false;
            section3 = false;
            section4 = true;
            section5 = false;
            section6 = false;
            iframeSource = '/'+reportID+'?isdtp=mn';
        }else if(reportData[0].name == 'Active Stage 2+Opportunities not in SWB') {
           
            listopGroupSelected='';
            listGeoAreaSelected='';
            listGeoUnitSelected='';
            listOffSelected='';
            listReportStatusSelected='';
            listStageSelected='';
            listOUSelected='';
            listOppReportStatusSelected='';
            listOppStageSelected='';
            
            section1 = false;
            section2 = false;
            section3 = false;
            section4 = false;
            section5 = true;
            section6 = false;
            iframeSource = '/'+reportID+'?isdtp=mn';
        }else if(reportData[0].name == 'Deals with CCI% lower than 29.5%') {
           
            listopGroupSelected='';
            listGeoAreaSelected='';
            listGeoUnitSelected='';
            listOffSelected='';
            listReportStatusSelected='';
            listStageSelected='';
            listOUSelected='';
            listOppReportStatusSelected='';
            listOppStageSelected='';
            
            section1 = false;
            section2 = false;
            section3 = false;
            section4 = false;
            section5 = false;
            section6 = true;
            iframeSource = '/'+reportID+'?isdtp=mn';
        }else if(reportData[0].name == 'BPO Opportunity Raw Data Report') {
           
            listopGroupSelected='';
            listGeoAreaSelected='';
            listGeoUnitSelected='';
            listOffSelected='';
            listReportStatusSelected='';
            listStageSelected='';
            listOUSelected='';
            listOppReportStatusSelected='';
            listOppStageSelected='';
            
            section1 = false;
            section2 = false;
            section3 = false;
            section4 = false;
            section5 = false;
            section6 = false;
            iframeSource = '/'+reportID+'?isdtp=mn';
        }else{
               section0 = false;
               section1 = false;
               section2 = false;
               section3 = false;
               section4 = false;
               section5 = false;
               section6 = false;
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
        if(listopGroupSelected==null){
            listopGroupSelected='';
        }
        if(listGeoAreaSelected==null){
            listGeoAreaSelected='';
        }
        if(listGeoUnitSelected==null){
            listGeoUnitSelected='';
        }
        if(listOffSelected==null){
            listOffSelected='';
        }
        if(listReportStatusSelected=='All'){
            listReportStatusSelected='';
        }
        if(listStageSelected=='All'){
            listStageSelected='';
        }
        if(listOUSelected=='All' || listOUSelected==null){
            listOUSelected='';
        }
        String reportURL = x_reportOptions 
        + '?pv0=' +listopGroupSelected        
        + '&pv1=' +listGeoAreaSelected
        + '&pv2=' +listGeoUnitSelected
        + '&pv3=' +listReportStatusSelected
        + '&pv4=' +listStageSelected
        + '&pv5=' +listOUSelected
        + '&pv6=' +listOffSelected;     

      //  iframeSource = 'https://na15.salesforce.com/00Oi0000000fKEaEAM?pv0=&pv1=7%2F3%2F2015' ;
       //iframeSource1 = '/01ZL00000008QJ9?isdtp=mn';
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe2() {

        if(listopGroupSelected==null){
            listopGroupSelected='';
        }
        if(listGeoAreaSelected==null){
            listGeoAreaSelected='';
        }
        if(listGeoUnitSelected==null){
            listGeoUnitSelected='';
        }
        if(listOffSelected==null){
            listOffSelected='';
        }
        if(listOppReportStatusSelected =='All'){
            listOppReportStatusSelected ='';
        }
        if(listOppStageSelected=='All'){
            listOppStageSelected='';
        }
        if(listOUSelected=='All' || listOUSelected==null){
            listOUSelected='';
        }
        String reportURL = x_reportOptions 
        
        + '?pv0=' +listOppStageSelected
        + '&pv1=' +listOppReportStatusSelected       
        + '&pv2=' +listopGroupSelected
        + '&pv3=' +listOUSelected
        + '&pv4=' +listGeoAreaSelected
        + '&pv5=' +listGeoUnitSelected
        + '&pv6=' +listOffSelected;
       
        iframeSource = '/'+reportURL+'&isdtp=mn';
        return null;
    }
    
    public PageReference reloadIframe3() {

        if(listopGroupSelected==null){
            listopGroupSelected='';
        }
        if(listGeoAreaSelected==null){
            listGeoAreaSelected='';
        }
        if(listGeoUnitSelected==null){
            listGeoUnitSelected='';
        }
        if(listOffSelected==null){
            listOffSelected='';
        }
        if(listReportStatusSelected=='All'){
           listReportStatusSelected='';            
        }
        if(listStageSelected=='All'){
            listStageSelected='';
        }
        if(listOUSelected=='All' || listOUSelected==null){
            listOUSelected='';
        } 
        String reportURL = x_reportOptions 
        + '?pv0=' +listopGroupSelected
        + '&pv1=' +listOUSelected
        + '&pv2=' +listGeoAreaSelected
        + '&pv3=' +listGeoUnitSelected
        + '&pv4=' +listOffSelected
        + '&pv5=' +listReportStatusSelected
        + '&pv6=' +listStageSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn&rc:LinkTarget=_blank';

        return null;
    }
    
    public PageReference reloadIframe4() {

        if(listopGroupSelected==null){
            listopGroupSelected='';
        }
        if(listGeoAreaSelected==null){
            listGeoAreaSelected='';
        }
        if(listGeoUnitSelected==null){
            listGeoUnitSelected='';
        }
        if(listOffSelected==null){
            listOffSelected='';
        }
        if(listOUSelected=='All' || listOUSelected==null){
            listOUSelected='';
        }
        String reportURL = x_reportOptions 
        + '?pv0=' +
        + '&pv1=' +listopGroupSelected
        + '&pv2=' +listOUSelected
        + '&pv3=' +listGeoAreaSelected
        + '&pv4=' +listGeoUnitSelected
        + '&pv5=' +listOffSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';

        return null;
    }
    
    public PageReference reloadIframe5() {

        if(listopGroupSelected==null){
            listopGroupSelected='';
        }
        if(listGeoAreaSelected==null){
            listGeoAreaSelected='';
        }
        if(listGeoUnitSelected==null){
            listGeoUnitSelected='';
        }
        if(listOffSelected==null){
            listOffSelected='';
        }
        if(listOUSelected=='All' || listOUSelected==null){
            listOUSelected='';
        }
         if(listOppReportStatusSelected =='All'){
            listOppReportStatusSelected ='';
        }
        if(listOppStageSelected=='All'){
            listOppStageSelected='';
        }
        String reportURL = x_reportOptions 
        + '?pv0=' +listopGroupSelected
        + '&pv1=' +listOUSelected
        + '&pv2=' +listGeoAreaSelected
        + '&pv3=' +listGeoUnitSelected
        + '&pv4=' +listOffSelected
        + '&pv5=' +listOppReportStatusSelected
        + '&pv6=' +listOppStageSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';

        return null;
    }
    
    public PageReference reloadIframe6() {

        if(listopGroupSelected==null){
            listopGroupSelected='';
        }
        if(listOUSelected=='All' || listOUSelected==null){
            listOUSelected='';
        }
        if(listGeoAreaSelected==null){
            listGeoAreaSelected='';
        }
        if(listGeoUnitSelected==null){
            listGeoUnitSelected='';
        }
        if(listOffSelected==null){
            listOffSelected='';
        }        
        if(listOppReportStatusSelected =='All'){
            listOppReportStatusSelected ='';
        }
        if(listOppStageSelected=='All'){
            listOppStageSelected='';
        }
        String reportURL = x_reportOptions 
        + '?pv1=' +listopGroupSelected
        + '&pv2=' +listGeoAreaSelected
        + '&pv3=' +listGeoUnitSelected
        + '&pv4=' +listOppReportStatusSelected
        + '&pv5=' +listOppStageSelected
        + '&pv6=' +listOUSelected
        + '&pv7=' +listOffSelected;
        
        iframeSource = '/'+reportURL+'&isdtp=mn';

        return null;
    }
}