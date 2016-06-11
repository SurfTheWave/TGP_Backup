/*
Author : Malkeet Singh
Story  : Mob_004 
Description :  This is used to add associate opportunities with Deal. and is further used in approval process

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public class DealOpportunity_InlineController {
    //public String wavePlanVersionId{get;set;}
    public String dealRecId {get;set;}
    public String userId{get;set;}
    public String locationName{get;set;}
    public Boolean refreshPage {get; set;}
    public Deal_Opportunity__c dealLocation {get;set;}
    public Deal_Opportunity__c[] listOfLoactionDetailsActual {get;set;}
    public Deal_Opportunity__c[] tempList {get;set;}
    public boolean updated{get;set;}
    public boolean isVisible{get;set;}
    public boolean isRejected{get;set;}
    public boolean isAddVisible{get; set;}
    public boolean isNA {get;set;}
    public boolean isSaveVisible{get; set;}
    
    /******************************
    Method Name: DealOpportunity_InlineController
    Description: Constructor of DealOpportunity_InlineController class
    Paramenters: StandardController
    Return Value: NA
    *******************************/  
    public DealOpportunity_InlineController(ApexPages.StandardController stdCon) {
        isNA=true;          
        dealLocation = new Deal_Opportunity__c();
        Schema.DescribeSObjectResult r = Deal_Opportunity__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        
        // id of custom object on which this inline page is placed.
        dealRecId=ApexPages.CurrentPage().getParameters().get('id');
        if(dealRecId==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Invalid Deal ID!'));
            isVisible=false;
        }
        else
        {
            isVisible=true;
            userId= UserInfo.getuserId();
            initializeDetailRecords();
            refreshPage = false;
            List<Deal_tgp__c>lstDeal = [select Opportunity_Name__c,Client_GEO_Area__c, Client_GEO_Unit__c,Client_Name__c,Risk_Level__c,Stage__c,Operating_Group__c,Deal_Rejected__c from Deal_TGP__c where id= :dealRecId ];    
            isRejected=lstDeal[0].Deal_Rejected__c;
        }
        
        /*List<Wave_Plan_Version__c> newWavePlanVersion=[Select id, name from Wave_Plan_Version__c where Deal__c=:dealRecId];
        if(newWavePlanVersion.size()>0)
        {
            isVisible=true;
        }
        else
        {
            isVisible=false;    
        }*/
        // check mob leadership profile
        /*if(CheckProfile.isMobLeadershipProfile())
            isAddVisible = false;
        else
            isAddVisible = true;
          */  
        // For UAM
         isAddVisible = UAMSolMobUtility.isAddVisible_DealOpp;
         isSaveVisible = UAMSolMobUtility.isSaveVisible_DealOpp;
         
         if(UAMSolMobUtility.isNA_DealOpp)
         {
            isNA=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
            return;
         }
         
 /*       UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
        Map<String,Boolean> m = uam.CheckUserRole(dealRecId,'Deal_Opportunity__c');
        isAddVisible = m.get('C');
        isSaveVisible = m.get('U');
        if(m.get('NA')==true)
        {
            isNA=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
            return;
        }     */
              
    }
    
    /******************************
    Method Name: getLocationNames
    Description: Method to get list of Opportunities.
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/
    public List<SelectOption> getLocationNames()
    {
        List<SelectOption> locName=new List<SelectOption>();
        List<Opportunity_TGP__c> opportunityTGP =[select id,SAP_OM_ID__c,SAP_OM_Opportunity__r.Name, name, Client_Name__r.Name from Opportunity_TGP__c where Activity__c !='lost' AND Activity__c != 'Accenture Withdrew' AND Activity__c != 'Client Withdrew' AND (NOT Name In('PTO','Training','Other Deal Support','Other Unavailable')) order by LastModifiedDate Desc LIMIT 999];
        if(opportunityTGP.size()>0)
        {
            for(Opportunity_TGP__c c:opportunityTGP)
            { 
                STring displayText = '';
                if(c.Client_Name__r.Name != null) {
                    displayText = c.Client_Name__r.Name + '_';
                }
                if(c.Name != null) {
                    displayText = displayText  + c.Name ;
                }
                if(c.SAP_OM_Opportunity__r.Name != null) {
                    displayText = displayText+ '_' + c.SAP_OM_Opportunity__r.Name ;
                }
                locName.add(new SelectOption(c.id,displayText));              
            }
        }
        return locName;
    }
    
    /******************************
    Method Name: getLocationNames
    Description: Method to get list of Opportunities.
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/
    public List<SelectOption> getLocationNamesWithoutClientName()
    {
        List<SelectOption> locName=new List<SelectOption>();
        List<Opportunity_TGP__c> opportunityTGP =[select id,SAP_OM_ID__c,SAP_OM_Opportunity__r.Name, name, Client_Name__r.Name from Opportunity_TGP__c where Activity__c != 'lost' AND Activity__c != 'Accenture Withdrew' AND Activity__c != 'Client Withdrew' order by LastModifiedDate Desc LIMIT 999];
        if(opportunityTGP.size()>0)
        {
            for(Opportunity_TGP__c c:opportunityTGP)
            { 
                locName.add(new SelectOption(c.id,c.Name));              
            }
        }
        return locName;
    }
    
    /******************************
    Method Name: addLocationDetail
    Description: Method to get list of Opportunities.
    Paramenters: NA
    Return Value: void
    *******************************/        
    public void addLocationDetail() 
    {
        List <ProcessInstanceWorkitem> lt=[SELECT ActorId , ProcessInstance.Status FROM ProcessInstanceWorkitem WHERE 
        ProcessInstance.TargetObject.Type = 'Deal_TGP__c'  AND ProcessInstance.TargetObjectId =: dealRecId];
        
        if(lt.size()>0)
        {
            for(ProcessInstanceWorkitem parser:lt)
            {
            
                if(parser.ActorId !=userId && parser.ProcessInstance.Status == 'Pending' )
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot Add/Update Deal Opportunity as the Deal is submitted for Approval'));
                    return;
                }
                
            }
        }
        
        else if(isRejected)
        {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot Add/Update Deal Opportunity as the Deal is already Rejected'));
                    return;
        }
        
        
        dealLocation.Deal_TGP__c=dealRecId;
        dealLocation.Opportunity_TGP__c=locationName;
        try
        {
            List<Deal_Opportunity__c> dhl= [Select id,name,Associate_to_Deal__c,SAP_OM_ID__c,Opportunity_TGP__c,Deal_TGP__c  from Deal_Opportunity__c where Opportunity_TGP__c = : dealLocation.Opportunity_TGP__c and Deal_TGP__c=:dealRecId limit 1];
            if(dhl.size()==1)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists.'));
                initializeDetailRecords();
                return;
            } 
            insert dealLocation;     
        } 
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
            initializeDetailRecords();
            return;
        }
        finally
        {
            dealLocation = new Deal_Opportunity__c();
        }
        initializeDetailRecords();
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully.'));
        return;
    }
    
    /******************************
    Method Name: initializeDetailRecords
    Description: Method to load list of Opportunities associated with deal.
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void initializeDetailRecords() 
    {
        listOfLoactionDetailsActual = new Deal_Opportunity__c[]{};
        List<Deal_Opportunity__c> opp=[Select id,name,Associate_to_Deal__c,SAP_OM_ID__c,Opportunity_TGP__c,Opportunity_TGP__r.Client_Name__r.Name, Deal_TGP__c  from Deal_Opportunity__c where Deal_TGP__c=:dealRecId order by createddate desc];
        if(opp.size()>0)
        {
            for(Deal_Opportunity__c profDet : opp) 
            {
               
                listOfLoactionDetailsActual.add(profDet);
            }
        }
    }
    
    /******************************
    Method Name: saveLocationDetails
    Description: Method to save the Deal Opportunities.
    Paramenters: NA
    Return Value:void
    *******************************/  
    public void saveLocationDetails()
    {
        List <ProcessInstanceWorkitem> lt=[SELECT ActorId , ProcessInstance.Status FROM ProcessInstanceWorkitem WHERE 
        ProcessInstance.TargetObject.Type = 'Deal_TGP__c'  AND ProcessInstance.TargetObjectId =: dealRecId];
        
        
        
        
        if(lt.size()>0)
        {
          for(ProcessInstanceWorkitem parser:lt)
            {
               
            
              if(parser.ActorId !=userId && parser.ProcessInstance.Status == 'Pending' )
                   {
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot Add/Update Deal Opportunity as the Deal is submitted for Approval'));
                       initializeDetailRecords();
                       return;
                   }  
            
             }
        }
        else if(isRejected)
        {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot Add/Update Deal Opportunity as the Deal is already Rejected'));
                    return;
        }

        updated=false;
        List<Deal_Home_Location__c> MainDealHomeLocation =[Select Delivery_Location_Master__c from Deal_Home_Location__c where Deal__c=:dealRecId];
        List<Deal_Opportunity__c> DealOpportunity= new  List<Deal_Opportunity__c>();
        DealOpportunity=[Select id,name,Associate_to_Deal__c,SAP_OM_ID__c,Opportunity_TGP__c,Deal_TGP__c  from Deal_Opportunity__c where Deal_TGP__c=:dealRecId];
        if(DealOpportunity.Size()==0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please insert a record!'));
            return;
        }
        if(DealOpportunity.size()>0)
        {
            for(Deal_Opportunity__c  sm:DealOpportunity)
            {
                Integer count=0;
                if(listOfLoactionDetailsActual.size()>0)
                {
                    for(Deal_Opportunity__c lst : listOfLoactionDetailsActual)
                    {
                        if(lst.Opportunity_TGP__c == sm.Opportunity_TGP__c)
                        {
                            count++;
                            if(count==2)
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists!'));
                                initializeDetailRecords();
                                 return;
                            }
                        }
                    }                       
                }
            }
            for(Deal_Opportunity__c s1:listOfLoactionDetailsActual)
            {
                for(Deal_Opportunity__c s2:listOfLoactionDetailsActual)
                if(s1.id!= s2.id)
                {
                   if(s1.Opportunity_TGP__c== s2.Opportunity_TGP__c && s1.Deal_TGP__c==dealRecId && s2.Deal_TGP__c==dealRecId )
                   {
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplication is not Allowed'));
                        initializeDetailRecords();
                        return;
                   } 
                }
            }
        }
        Integer count1=0;
        if(listOfLoactionDetailsActual.size()>0)
        {
            for(Deal_Opportunity__c tempDealOpportunity : listOfLoactionDetailsActual)
            {
                if(tempDealOpportunity.Associate_to_Deal__c==true)
                {
                    count1++;
                }   
            }
        }
        if(count1>=2)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot associate multiple Opportunities!'));
            initializeDetailRecords();
            return;    
        }
        Deal_Opportunity__c[] waveDetailsToUpsert = new Deal_Opportunity__c[]{};
        boolean isChanged=false;
        List<Opportunity_TGP__c> lstOppTgp = [select id,Name,Client_GEO_Area__c,Client_GEO_Unit__c,Client_Name__c,Risk_Level__c,Operating_Group__c,Stage__c,SAP_OM_ID__c,SAP_OM_Opportunity__c,Enterprise_Solution_Architect_New__c,OU_description__c from Opportunity_TGP__c];
        List<Deal_tgp__c>lstDeal = [select Opportunity_Name__c,Client_GEO_Area__c, Client_GEO_Unit__c,Client_Name__c,Risk_Level__c,Stage__c,Operating_Group__c,Solution_Architect_New__c,Operating_Unit__c from Deal_TGP__c where id= :dealRecId ];
        List<SAP_OM_Opportunity__c>SAPOMOpportunity=[Select name from SAP_OM_Opportunity__c];
        List<Opportunity_Offering__c> opportunityOfferingList=[Select id,Opportunity_TGP__c from Opportunity_Offering__c];
        List<Delivery_Location__c> LocationList=[Select Delivery_Location_Master__c,Service_Delivery_Location__c,Service_Delivery_Location__r.Opportunity_Offering__c from Delivery_Location__c];
        tempList = new Deal_Opportunity__c[]{};
        tempList = [Select id,name,Associate_to_Deal__c,SAP_OM_ID__c,Opportunity_TGP__c  from Deal_Opportunity__c where Deal_TGP__c=:dealRecId];
        
        for(Deal_Opportunity__c oldtemp : tempList)
        {
            for(Deal_Opportunity__c newtemp : listOfLoactionDetailsActual)
            {
                if(oldtemp.id==newtemp.id)
                {
                    if(oldtemp.Associate_to_Deal__c==false && newtemp.Associate_to_Deal__c==true)
                    {
                        isChanged= true;
                        for(Deal_Opportunity__c newTemp2 : listOfLoactionDetailsActual)
                        {
                            newTemp2.Associate_to_Deal__c = false;
                        }
                        //update listOfLoactionDetailsActual;
                        newtemp.Associate_to_Deal__c=true;
                        update newtemp;
                        if(lstOppTgp .size()>0)
                        {
                            for(Opportunity_TGP__c lstOpp:lstOppTgp)
                            {
                                if(lstOpp.id == newtemp.Opportunity_TGP__c)
                                {
                                    //Add the Opportunity data on the deal page
                                    if(lstDeal.size()==1)
                                    {
                                        lstDeal.get(0).Opportunity_Name__c = lstOpp.Name;
                                        lstDeal.get(0).Client_GEO_Area__c = lstOpp.Client_GEO_Area__c;
                                        lstDeal.get(0).Client_GEO_Unit__c = lstOpp.Client_GEO_Unit__c;
                                        lstDeal.get(0).Client_Name__c = lstOpp.Client_Name__c;
                                        lstDeal.get(0).Risk_Level__c = lstOpp.Risk_Level__c;
                                        lstDeal.get(0).Stage__c = lstOpp.Stage__c;
                                        lstDeal.get(0).Opportunity_ID__c = lstOpp.id;
                                        lstDeal.get(0).Solution_Architect_New__c = lstOpp.Enterprise_Solution_Architect_New__c;
                                        lstDeal.get(0).Operating_Unit__c = lstOpp.OU_description__c;
                                        
                                        //If SAP OM ID is present in that Opportunity
                                        if(lstOpp.SAP_OM_Opportunity__c !=null)
                                        {
                                            //List<SAP_OM_Opportunity__c>SAPOMOpportunity=[Select name from SAP_OM_Opportunity__c where id=:lstOpp.SAP_OM_Opportunity__c];
                                            //To insert SAP OM ID value in the deal page
                                            if(SAPOMOpportunity.size()>0)
                                            {
                                                for(SAP_OM_Opportunity__c sapOpp : SAPOMOpportunity)
                                                {
                                                    if(sapOpp.id==lstOpp.SAP_OM_Opportunity__c) 
                                                    {   
                                                        lstDeal.get(0).SAP_OM_ID__c= sapOpp.name;
                                                    }
                                                }
                                            }
                                        }
                                        else  //If SAP OM ID is not present in that Opportunity
                                        {
                                            lstDeal.get(0).SAP_OM_ID__c=null;
                                        }
                                        lstDeal.get(0).Operating_Group__c = lstOpp.Operating_Group__c;
                                        update lstDeal[0];
                                        updated=true;   
                                           
                                        //To insert Locations from opportunity on Deal page
                                        List<Deal_Home_Location__c> ListOfLocationName=new List<Deal_Home_Location__c>();
                                        boolean flag=false;
                                        boolean flag1=false;
                                        if(opportunityOfferingList.size()>0)
                                        {
                                            //List of Offering in the Perticular Opportunity
                                            for(Opportunity_Offering__c Offring: opportunityOfferingList)
                                            {
                                                if(Offring.Opportunity_TGP__c==lstOpp.id)
                                                {
                                                    //List<Delivery_Location__c> LocationList=[Select Delivery_Location_Master__c,Offering_Name__c from Delivery_Location__c where Offering_Name__c=:Offring.id];
                                                    if(LocationList.size()>0)
                                                    {
                                                        for(Delivery_Location__c location:LocationList)
                                                        {   
                                                            //if(location.Offering_Name__c == Offring.id)
                                                            if(location.Service_Delivery_Location__r.Opportunity_Offering__c == Offring.id)
                                                            {
                                                                flag=false;
                                                                flag1=false;
                                                                //To avoid the duplicate locations from Offerings
                                                                if(ListOfLocationName.size()>0)
                                                                {
                                                                    for(Deal_Home_Location__c loc:ListOfLocationName)
                                                                    {
                                                                        if(loc.Delivery_Location_Master__c==location.Delivery_Location_Master__c)
                                                                        {
                                                                            flag=true;
                                                                        }
                                                                    }
                                                                }
                                                                //To avoid the locations which are allready present in the Deal Location
                                                                if(MainDealHomeLocation.size()>0)
                                                                {
                                                                    for(Deal_Home_Location__c tempDealHomeLocation:MainDealHomeLocation)
                                                                    {
                                                                        if(tempDealHomeLocation.Delivery_Location_Master__c == location.Delivery_Location_Master__c)  
                                                                        {
                                                                            flag1=true;
                                                                        } 
                                                                    } 
                                                                }
                                                                //create the list of new locations for adding into Deal Locations
                                                                if(flag==false && flag1==false)
                                                                {
                                                                    Deal_Home_Location__c NewDealHomeLocation=new  Deal_Home_Location__c(); 
                                                                    NewDealHomeLocation.Deal__c=lstDeal.get(0).id;
                                                                    NewDealHomeLocation.Opportunity_ID__c=lstOpp.id;
                                                                    NewDealHomeLocation.Delivery_Location_Master__c=location.Delivery_Location_Master__c;
                                                                    ListOfLocationName.add(NewDealHomeLocation); 
                                                                }
                                                            }
                                                        }
                                                    }    
                                                }
                                            }
                                        }
                                        
                                        //List<Opportunity_Offering__c> OfferingList=[Select id,Opportunity_TGP__c from Opportunity_Offering__c where Opportunity_TGP__c=:lstOpp.id];
                                        //if(OfferingList.size()>0)
                                        //{
                                           // for(Opportunity_Offering__c Offring:OfferingList)
                                            //{
                                                
                                           // }
                                        //}
                                        //Insert the list of locations into the Deal home Location
                                        if(ListOfLocationName.size()>0)
                                        { 
                                            insert ListOfLocationName;
                                        }    
                                    }
                                }
                            }
                        }
                        //List<Opportunity_TGP__c> lstOpp = [select id,Name,Client_GEO_Area__c,Client_GEO_Unit__c,Client_Name__c,Risk_Level__c,Operating_Group__c,Stage__c,SAP_OM_ID__c,SAP_OM_Opportunity__c from Opportunity_TGP__c where id= :newtemp.Opportunity_TGP__c];
                        //List<Deal_tgp__c>lstDeal = [select Opportunity_Name__c,Client_GEO_Area__c, Client_GEO_Unit__c,Client_Name__c,Risk_Level__c,Stage__c,Operating_Group__c from Deal_TGP__c where id= :dealRecId ];
                        
                    }
                    //When there is no Opportunity associated to deal
                    if(oldtemp.Associate_to_Deal__c==true && newtemp.Associate_to_Deal__c==false && updated==false)
                    {
                        //List<Deal_TGP__c>lstDeal1 = [select id,Opportunity_Name__c,Client_Name__c,Risk_Level__c,Stage__c,Operating_Group__c,SAP_OM_ID__c from Deal_TGP__c where id= :dealRecId ];  
                        if(lstDeal.size()==1)
                        {
                            lstDeal[0].Opportunity_Name__c=null;
                            lstDeal[0].Client_Name__c=null;
                            lstDeal[0].SAP_OM_ID__c=null;
                            lstDeal.get(0).Client_GEO_Area__c = null;
                            lstDeal.get(0).Client_GEO_Unit__c = null;
                            lstDeal.get(0).Client_Name__c = null;
                            lstDeal.get(0).Risk_Level__c = null;
                            lstDeal.get(0).Stage__c = null;
                            lstDeal.get(0).Operating_Group__c = null;
                            lstDeal.get(0).Opportunity_ID__c = null;
                            lstDeal.get(0).Solution_Architect_New__c = null;
                            lstDeal.get(0).Operating_Unit__c = null;
                            update lstDeal[0];
                        }      
                    }
                    if(oldtemp.Associate_to_Deal__c==true && newtemp.Associate_to_Deal__c==true)
                    {
                                    
                        
                        update newtemp;
                        if(lstOppTgp .size()>0)
                        {
                            for(Opportunity_TGP__c lstOpp:lstOppTgp)
                            {
                                if(lstOpp.id == newtemp.Opportunity_TGP__c)
                                {
                                    //Add the Opportunity data on the deal page
                                    if(lstDeal.size()==1)
                                    {
                                        lstDeal.get(0).Opportunity_Name__c = lstOpp.Name;
                                        lstDeal.get(0).Client_GEO_Area__c = lstOpp.Client_GEO_Area__c;
                                        lstDeal.get(0).Client_GEO_Unit__c = lstOpp.Client_GEO_Unit__c;
                                        lstDeal.get(0).Client_Name__c = lstOpp.Client_Name__c;
                                        lstDeal.get(0).Risk_Level__c = lstOpp.Risk_Level__c;
                                        lstDeal.get(0).Stage__c = lstOpp.Stage__c;
                                        lstDeal.get(0).Opportunity_ID__c= lstOpp.id;
                                        lstDeal.get(0).Solution_Architect_New__c = lstOpp.Enterprise_Solution_Architect_New__c;
                                        lstDeal.get(0).Operating_Unit__c = lstOpp.OU_description__c;
                                        
                                        //If SAP OM ID is present in that Opportunity
                                        if(lstOpp.SAP_OM_Opportunity__c !=null)
                                        {
                                            //List<SAP_OM_Opportunity__c>SAPOMOpportunity=[Select name from SAP_OM_Opportunity__c where id=:lstOpp.SAP_OM_Opportunity__c];
                                            //To insert SAP OM ID value in the deal page
                                            if(SAPOMOpportunity.size()>0)
                                            {
                                                for(SAP_OM_Opportunity__c sapOpp : SAPOMOpportunity)
                                                {
                                                    if(sapOpp.id==lstOpp.SAP_OM_Opportunity__c) 
                                                    {   
                                                        lstDeal.get(0).SAP_OM_ID__c= sapOpp.name;
                                                    }
                                                }
                                            }
                                        }
                                        else  //If SAP OM ID is not present in that Opportunity
                                        {
                                            lstDeal.get(0).SAP_OM_ID__c=null;
                                        }
                                        lstDeal.get(0).Operating_Group__c = lstOpp.Operating_Group__c;
                                        update lstDeal[0];
                                        updated=true;   
                                           
                                        //To insert Locations from opportunity on Deal page
                                        List<Deal_Home_Location__c> ListOfLocationName=new List<Deal_Home_Location__c>();
                                        boolean flag=false;
                                        boolean flag1=false;
                                        if(opportunityOfferingList.size()>0)
                                        {
                                            //List of Offering in the Perticular Opportunity
                                            for(Opportunity_Offering__c Offring: opportunityOfferingList)
                                            {
                                                if(Offring.Opportunity_TGP__c==lstOpp.id)
                                                {
                                                    //List<Delivery_Location__c> LocationList=[Select Delivery_Location_Master__c,Offering_Name__c from Delivery_Location__c where Offering_Name__c=:Offring.id];
                                                    if(LocationList.size()>0)
                                                    {
                                                        for(Delivery_Location__c location:LocationList)
                                                        {   
                                                            //if(location.Offering_Name__c == Offring.id)
                                                            if(location.Service_Delivery_Location__r.Opportunity_Offering__c == Offring.id)
                                                            {
                                                                flag=false;
                                                                flag1=false;
                                                                //To avoid the duplicate locations from Offerings
                                                                if(ListOfLocationName.size()>0)
                                                                {
                                                                    for(Deal_Home_Location__c loc:ListOfLocationName)
                                                                    {
                                                                        if(loc.Delivery_Location_Master__c==location.Delivery_Location_Master__c)
                                                                        {
                                                                            flag=true;
                                                                        }
                                                                    }
                                                                }
                                                                //To avoid the locations which are allready present in the Deal Location
                                                                if(MainDealHomeLocation.size()>0)
                                                                {
                                                                    for(Deal_Home_Location__c tempDealHomeLocation:MainDealHomeLocation)
                                                                    {
                                                                        if(tempDealHomeLocation.Delivery_Location_Master__c == location.Delivery_Location_Master__c)  
                                                                        {
                                                                            flag1=true;
                                                                        } 
                                                                    } 
                                                                }
                                                                //create the list of new locations for adding into Deal Locations
                                                                if(flag==false && flag1==false)
                                                                {
                                                                    Deal_Home_Location__c NewDealHomeLocation=new  Deal_Home_Location__c(); 
                                                                    NewDealHomeLocation.Deal__c=lstDeal.get(0).id;
                                                                    NewDealHomeLocation.Opportunity_ID__c=lstOpp.id;
                                                                    NewDealHomeLocation.Delivery_Location_Master__c=location.Delivery_Location_Master__c;
                                                                    ListOfLocationName.add(NewDealHomeLocation); 
                                                                }
                                                            }
                                                        }
                                                    }    
                                                }
                                            }
                                        }
                                        
                                        //List<Opportunity_Offering__c> OfferingList=[Select id,Opportunity_TGP__c from Opportunity_Offering__c where Opportunity_TGP__c=:lstOpp.id];
                                        //if(OfferingList.size()>0)
                                        //{
                                           // for(Opportunity_Offering__c Offring:OfferingList)
                                            //{
                                                
                                           // }
                                        //}
                                        //Insert the list of locations into the Deal home Location
                                        if(ListOfLocationName.size()>0)
                                        { 
                                            insert ListOfLocationName;
                                        }    
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        waveDetailsToUpsert.addAll(listOfLoactionDetailsActual);
        try
        {
            upsert waveDetailsToUpsert;
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
            initializeDetailRecords();
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully.'));
        initializeDetailRecords();
        refreshPage = true;
        return;
    }

    /******************************
    Method Name: refreshLocationPage
    Description: Method to refresh the page.
    Paramenters: NA
    Return Value:void
    *******************************/ 
    public void refreshLocationPage()
    {
        initializeDetailRecords();
        refreshPage = true;
    }  
}