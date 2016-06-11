/*
Author : Sanjay Kumar Das   
Story  :  Story-0020 / MOB_005 
Description : As a Mobilization Lead, I should be able to view Wave planning home page (which has summary of waves)

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public with sharing class Mob_DealRoleSummaryController {
    public String newid{get;set;}
    public List<DealNodes> hierarchy;
    public List<MOB_User_Role_Assignment__c> userList{get;set;}

    /******************************
    Inner class Name: Cnodes
    Description: The Inner class which hold the information aboutWave Plan 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public class Cnodes
    {
        public Wave_Planning__c DealLocation {get; set;}
        public List<Wave_Process__c> Dnodes{get;set;}
            
    }
     /******************************
    Inner class Name: BNodes
    Description: The Innner class which hold the information about Deal Location
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public class BNodes
    {
        Public Deal_Location__c deal {get;set;}
        public List<Cnodes> cnodes{get; set;}
        
    }                              
    
    /******************************
    Inner class Name: ANodes
    Description: The Innner class which hold the information about Wave Plan Version
    Paramenters: NA
    Return Value: NA
    *******************************/
    public class ANodes
    {
        Public Wave_Plan_Version__c deal {get;set;}
        public List<BNodes> Bnodes{get; set;}
        
    } 
     /******************************
    Inner class Name: ANodes
    Description: The Innner class which hold the information about Wave Plan Version
    Paramenters: NA
    Return Value: NA
    *******************************/
    public class DealNodes
    {
        Public Deal_TGP__c deal {get;set;}
        public List<ANodes> ANodes{get; set;}
        
    } 

    /******************************
    Method Name: Mob_DealRoleSummaryController
    Description: Constructor for Initialization
    Paramenters: controller
    Return Value: NA
    *******************************/
    
    public Mob_DealRoleSummaryController(ApexPages.StandardController controller) {
        newid=ApexPages.CurrentPage().getParameters().get('id');
        hierarchy  = new List<DealNodes>();
        userList=new List<MOB_User_Role_Assignment__c>();
    }
 
   /******************************
    Method Name: getHierarchy
    Description: Getter Method for Whole Heirarchy which will return back for view in Inline page
    Paramenters: NA
    Return Value: List<ANodes> 
    *******************************/
    public List<DealNodes> getHierarchy ()  {
        return hierarchy ;
    } 
    /**********************************************
    Method Name: getMainNodes
    Description: This method is used to create the tree structure for the deal summary. 
    Paramenters: NA
    Return Value:  List<ANodes>
    ***********************************************/    
   
    Public List<DealNodes> getMainNodes()
    {
        List<Deal_TGP__c> dealList = [Select Id,Name from Deal_TGP__c where id=:newid];
        //Added to retreve the user from Deal       
        userList = [Select  Name,Role_Name__c,User_Assigned_New__r.SFDC_User__r.name, User_Assigned_Secondary_New__r.SFDC_User__r.Name, User_Assigned_Secondary_Lead__r.SFDC_User__r.Name  
                    from MOB_User_Role_Assignment__c where Deal__c=: newid order by Mob_User_Roles_Master__r.OrderByName__c];           
        List<Wave_Plan_Version__c> dtlist=new List<Wave_Plan_Version__c>();
        dtlist =[Select Name,Active__c from Wave_Plan_Version__c where Deal__c=:dealList and Active__c=:true];   
        List<Deal_Location__c> locNodelist=new List<Deal_Location__c>();
        locNodelist=[Select Wave_Plan_Version__r.Id,  Name,Deal_Home_Location__r.Delivery_Location_Master__r.Name,Wave_Plan_Version__c, 
                    Deployment_Lead_New__r.SFDC_User__r.Name, Location_Mobilization_Lead_Secondary_New__r.SFDC_User__r.Name,Location_Mobilization_Lead_Secondary_2__r.SFDC_User__r.Name, 
                    Mob_Recruitment_Lead_Primary_New__r.SFDC_User__r.Name, Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__r.Name, Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__r.Name, 
                    NewActive__c  from Deal_Location__c where Wave_Plan_Version__c =:dtlist];
        List<Wave_Planning__c> waveNodelist=new List<Wave_Planning__c>();
        waveNodelist=[Select Deal_Location__r.Id, Name, Wave_Label__c,GO_Live_Date_del__c, Deal_Location__c, KT_Lead_New__r.SFDC_User__r.Name, 
                        Mobilization_KT_Lead_Secondary_New__r.SFDC_User__r.Name,Mobilization_KT_Lead_Secondary_2__r.SFDC_User__r.Name,
                        Mobilization_Opex_Lead_Primary_New__r.SFDC_User__r.Name,Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__r.Name, Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__r.Name,
                        Mobilization_Technology_Lead_Primary_New__r.SFDC_User__r.Name,Mob_Technology_Lead_Secondary_New__r.SFDC_User__r.Name,Mob_Technology_Lead_Secondary_2__r.SFDC_User__r.Name, 
                        NewActive__c  from Wave_Planning__c where Deal_Location__c =:locNodelist];
               
        List<Wave_Process__c> processList=new List<Wave_Process__c>();
        processList=[Select Wave_Planning__r.Id, Name,Go_Live_Date__c, Client_Specific_Process_Mapping__r.Name, Wave_Planning__c, Active__c  
                        from Wave_Process__c where  Wave_Planning__c =:waveNodelist]; 
         
           for(Deal_TGP__c deal :dealList )
            {
                 DealNodes dn =  new DealNodes();
                 dn.deal = deal;
                 dn.ANodes = new List<ANodes>();
                 
              for(Wave_Plan_Version__c dt: dtlist)
                {
                    ANodes an =  new ANodes();
                    an.deal = dt;
                    an.Bnodes = new List<Bnodes>();
                    
                    for(Deal_Location__c loc: locNodelist)
                        {
                            BNodes bn =  new BNodes();
                            bn.deal = loc;
                            bn.Cnodes = new List<Cnodes>();
                            
                            for(Wave_Planning__c wave: waveNodelist)
                                {
                                    if(wave.Deal_Location__c == loc.id)
                                        {
                                            CNodes cn =  new CNodes();
                                            cn.DealLocation = wave;
                                            cn.Dnodes = new List<Wave_Process__c>();
                                        
                                             for(Wave_Process__c process: processList)
                                                {
                                                    if( process.Wave_Planning__c == wave.id)
                                                        {
                                                            cn.DNodes.add(process);
                                                        }
                                                }
                                             bn.cnodes.add(cn);
                                        }
                                }
                            an.Bnodes.add(bn);
                        }
                         dn.ANodes.add(an);
                     }   
                    hierarchy.add(dn);
            }   
       return hierarchy;
    }   
}