/*
* @Description : DealGeneralInfo_Controller is used for some operations on DealGeneralInfo session page
*
* @Author : Accenture
* */
public with sharing class DealGeneralInfo_Controller {
    private static final string CLASS_NAME=UTIL_Constants.DEAL_GENEAL_INFO_CONTROLLER;
    private static final string METHOD_NAME_CLIENT_GEOUNIT=UTIL_Constants.CLIENT_GEOUNIT;
    private static final string METHOD_NAME_CANCEL_RECORD=UTIL_Constants.CANCEL_RECORD;
    private static final string METHOD_NAME_EDIT1=UTIL_Constants.EDIT1;
    private static final string METHOD_NAME_OPERATING_GROUP=UTIL_Constants.OPERATING_GROUP;
    private static final string METHOD_NAME_CLIENT_GEO_AREA=UTIL_Constants.CLIENT_GEO_AREA;
    private static final string METHOD_NAME_RETRIVE_DEAL=UTIL_Constants.RETRIVE_DEAL;
    public  Deal_TGP__c deal1{get; set;}
    public String dealId{get; set;}
    private List<Deal_TGP__c> dealList;
    //List<Client_Geo_Area_Master__c> clientGeoAreaMaster{get; set;}
    private List<Client_Geo_Area_Master__c> clientGeoAreaMasterList;
    public String clientGeoAreaMaster{get;set;}
    public String operatingGroupMaster{get;set;}
    public String OperatingUnitValue{get;set;}
    public String clientGeoUnitMaster{get;set;}
    public Boolean saveEditButtonRender{get; set;}
    public Boolean flagEdit{get; set;}
    private ApexPages.StandardController dealObj = null;
    public Boolean flagDetail{get; set;}
     /**
    * @Description:DealGeneralInfo_Controller constractor
    * @MethodName :DealGeneralInfo_Controller
    * @parameter  :ApexPages.StandardController
    */
    public DealGeneralInfo_Controller(ApexPages.StandardController controller) 
    {
        dealObj = controller;
        deal1 = new Deal_TGP__c();
        try{
            deal1=(Deal_TGP__c)controller.getRecord();
            dealId = ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
            flagDetail = true;
            
           /* deal1 = [select Client_Name__c,name,Client_Geo_Area__c,X3rd_Party_Vendor_dependency_Comment__c,Client_Geo_Unit__c,X3rd_Party_Vendor_dependency__c,
                        Risk_Level__c,Watch_List__c,Operating_Group__c,Total_Contract_Value__c,Deal_Category__c,Pricing_Type__c,Stage__c,
                        Start_Date_of_Transistion__c, CommentForDealTracking__c from Deal_TGP__c where id =: deal1.id]; 
            */
            retriveDeal();
            clientGeoAreaMasterList = [select Client_Geo_Area_Name__c from Client_Geo_Area_Master__c limit 2000];
            if(dealId!=null)
            {
                List<Deal_TGP__c> lstDeal = [select id, name from Deal_TGP__c where id = : dealId limit 1];
                String strDealId = lstDeal.get(0).id;
                
                /* UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                 Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Deal_TGP__c');           
                //addButtonRender = m.get('C');
                saveEditButtonRender = m.get('U');
                
                */
                saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_DealInfo;
    
             }
          }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME,CLASS_NAME, CLASS_NAME, 
                   null, System.Logginglevel.ERROR);
        }
    }  
    /******************************
    Method Name: retriveDeal
    Description: Retrive information from Deal
    Paramenters: NA
    Return Value: void
    *******************************/
    public void retriveDeal() {
        try{
            deal1 = [select Client_Name__c,name,Client_Geo_Area__c,X3rd_Party_Vendor_dependency_Comment__c,Client_Geo_Unit__c,X3rd_Party_Vendor_dependency__c,
                        Risk_Level__c,Watch_List__c,Operating_Group__c,Total_Contract_Value__c,Deal_Category__c,Pricing_Type__c,Stage__c,
                        Start_Date_of_Transistion__c
                        , CommentForDealTracking__c,Total_No_Of_Projected_FTEs__c,Operating_Unit__c 
                        from Deal_TGP__c where id =: deal1.id limit 1]; 
          }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME,CLASS_NAME,
             METHOD_NAME_RETRIVE_DEAL, null, System.Logginglevel.ERROR);
        }
    }
    /******************************
    Method Name: getclientGeoArea
    Description: Add method to get category only related to Client Geo Area master
    Paramenters: NA
    Return Value: void
    *******************************/
    public List<SelectOption> getclientGeoArea(){
       List<SelectOption> clientGeoArea=new List<SelectOption>();
       try{
           List<Client_Geo_Area_Master__c> cgam=[select id,name,Active__c  from Client_Geo_Area_Master__c where Active__c = true order by name limit 5000];
           if(cgam.Size()>0){
              for(Client_Geo_Area_Master__c c : cgam){
                clientGeoArea.add(new SelectOption(c.id, c.name)); 
              }
           }
            return clientGeoArea;
          }
      catch(Exception exp) {
           UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME,CLASS_NAME, METHOD_NAME_CLIENT_GEO_AREA, 
                   null, System.Logginglevel.ERROR);
           return null;
       }
       
    } 
     /******************************
    Method Name: getclientGeoArea
    Description: Add method to get category only related to Client Geo Area master
    Paramenters: NA
    Return Value: void
    *******************************/
    public List<SelectOption> getOperatingUnit(){
       List<SelectOption> OperatingUnit=new List<SelectOption>();
       try{
           List<Operating_Unit_Master__c> cgam=[select id,name,isActive__c  from Operating_Unit_Master__c where isActive__c = true order by name limit 5000];
           		OperatingUnit.add(new SelectOption('--None--','--None--'));
                if(cgam.Size()>0){
                	
              		for(Operating_Unit_Master__c c : cgam){
                	
                		OperatingUnit.add(new SelectOption(c.name, c.name)); 
              }
           }
          
            return OperatingUnit;
          }
      catch(Exception exp) {
           UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME,CLASS_NAME, METHOD_NAME_CLIENT_GEO_AREA, 
                   null, System.Logginglevel.ERROR);
           return null;
       }
       
    }  
    
    /******************************
    Method Name: getoperatingGroup
    Description: Add method to get category only related to Category master
    Paramenters: NA
    Return Value: void
    *******************************/   
    public List<SelectOption> getoperatingGroup(){
       List<SelectOption> operatingGroup=new List<SelectOption>();
       try{
           List<Operating_Group_Master__c> ogm=[select id,name,Active__c  from Operating_Group_Master__c where Active__c = true order by name limit 5000];
           if(ogm.Size()>0){
              for(Operating_Group_Master__c c : ogm){
                operatingGroup.add(new SelectOption(c.id, c.name)); 
              }
           }
            return operatingGroup;
       }
       catch(Exception exp) {
           UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME,CLASS_NAME, METHOD_NAME_OPERATING_GROUP, 
                   null, System.Logginglevel.ERROR);
           return null;
       }
    }          
    /******************************
    Method Name: edit1
    Description: To Edit Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void edit1()
    {
        flagDetail = false;
        //deal1.Client_Geo_Area__c=clientGeoAreaMaster;
        OperatingUnitValue = deal1.Operating_Unit__c;
        clientGeoAreaMaster=deal1.Client_Geo_Area__c; 
        if(clientGeoUnitMaster==UTIL_Constants.NONE)
            {  
            deal1.Client_Geo_Unit__c =null;  
            }
            else
            {
                //deal1.Client_Geo_Unit__c =clientGeoUnitMaster;
                clientGeoUnitMaster=deal1.Client_Geo_Unit__c; 
            }   
        
        //deal1.Operating_Group__c=operatingGroupMaster;
        operatingGroupMaster=deal1.Operating_Group__c;  
       // flag = false;
        flagEdit = true;
        saveEditButtonRender = false;

    }  
    
    /******************************
    Method Name: saverecord
    Description: To save Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public PageReference saverecord()
    {
        if(deal1.Name==null)
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PLEASE_ENTER_DEAL_NAME));
             return null;
        }
        deal1.Client_Geo_Area__c=clientGeoAreaMaster;
        deal1.Operating_Unit__c=OperatingUnitValue;
        if(clientGeoUnitMaster==UTIL_Constants.NONE)
        {  
            deal1.Client_Geo_Unit__c =null;  
        }
        else
        {
            deal1.Client_Geo_Unit__c =clientGeoUnitMaster; 
        }
        deal1.Operating_Group__c=operatingGroupMaster;
        try
            {
                if(dealId!=null)
                {                          
                    update deal1;
                }
                else
                {                    
                    insert deal1;      
                }
            }
             catch(Exception ex)
            {
                
               if(ex.getMessage().contains(UTIL_Constants.UPDATE_FAILED)){
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.NO_PERMISSION_TO_PERFORM_THIS_ACTION));
                   return null;
               }
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_ErrorConstants.GENERIC_ERROR_MESSAGE));
                return null;
            }
        /* PageReference pr;  
        if(deal1.id!=null)
        {      
            pr=new PageReference('/'+deal1.id);
            pr.setRedirect(true);
            return pr; 
       }*/
       flagDetail = true;
       saveEditButtonRender = true;
       flagEdit = false;
       
       return null;
    }
     /******************************
    Method Name: cancelRecord
    Description: To cancel RecordOpportunity records.
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void cancelRecord()
    {
            flagDetail = true;
            flagEdit = false;
            saveEditButtonRender = true;
            try{
                //flagEdit = true;
                //flag =true;
                /*flagEdit = false;
                saveEditButtonRender = true;
                PageReference pr;  
                pr=new PageReference('/'+deal1.id);
                pr.setRedirect(true);*/
                //return dealObj.cancel();
               retriveDeal();
            }
            catch(Exception exp) {
                UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME,CLASS_NAME, METHOD_NAME_CANCEL_RECORD, 
                       null, System.Logginglevel.ERROR);
            }
         
    } 
    /******************************
    Method Name: getclientGeoUnit
    Description: Add method to get category only related to Category Geo Unit master.
    Paramenters: NA
    Return Value: void
    *******************************/
    public List<SelectOption> getclientGeoUnit(){
       List<SelectOption> clientGeoUnit=new List<SelectOption>();
       try{
           List<Client_Geo_Unit_Master__c> cgum=[select id,name,Active__c  from Client_Geo_Unit_Master__c where Active__c = true order by name limit 5000];
           clientGeoUnit.add(new SelectOption(UTIL_Constants.NONE,UTIL_Constants.NONE_FOR_PICKLIST)); 
           if(cgum.Size()>0){
              for(Client_Geo_Unit_Master__c c : cgum){
                clientGeoUnit.add(new SelectOption(c.id, c.name)); 
              }
           }
            return clientGeoUnit;
       }
       catch(Exception exp) {
           UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME,CLASS_NAME,
           METHOD_NAME_CLIENT_GEOUNIT, null, System.Logginglevel.ERROR);
           return null;
       }
    }     
}