/*
Author : Sushmant Hasthi
Description : TO Add Waves to a particular Deal Locations
Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Nilesh Adkar    Story-0030/MOB_016        04-Mar-13        Disabling add / edit functionality for old wave version and its 
                                                           children after cloning and creating new wave plan vesrion.
              
*/
public class WavePlanAdd_InlineController {
    public String dealLocationId{get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean is_WavePlanVersionActive{get; set;}
    public Boolean is_WavePlanVersionActived{get; set;}
    public Wave_Planning__c newWavePlan {get;set;}
    public List<Wave_Planning__c> addingnewWavePlan{get;set;}
    public List<Wave_Planning__c> wavePlan {get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    public Boolean showForm2{get;set;}
    public Boolean isAddVisible{get;set;}
    public boolean isRecordDeactivated{get;set;}
    public integer isRecordDeactivate{get;set;}
    public boolean isNA{get; set;}
    public String  daytoday{get;set;}
    public String  Tempday{get;set;}
    public Datetime dt{get;set;}
    public Datetime dt1{get;set;}
    public Boolean isweekend{get;set;}
    public boolean isEditable{get;set;}
    public Date d{get;set;}

    //Controller for class Initializing records
    public WavePlanAdd_InlineController(ApexPages.StandardController stdCon) 
    {
        isNA=true;      
         // d=date.parse('12/30/1930');
         d =System.today();
         dt1 = (DateTime)d+1;
         Tempday= dt1.format(UTIL_Constants.EEEE);
    if(Tempday.equalsIgnoreCase(UTIL_Constants.SATURDAY))
    {
        d=d+4;
    }    
    if(Tempday.equalsIgnoreCase(UTIL_Constants.SUNDAY))
    {
        d=d+3;
    }          
        newWavePlan = new Wave_Planning__c();
        //getting ID of Deal Location record
        dealLocationId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        if(dealLocationId!=null)
        {
            showMainMsg=false;
            showForm=true;
            showForm2=true;
            initializeDetailRecords();
            refreshPage = false;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.INVALID_DEAL_LOCATION_ID));
            showMainMsg=true;
            showForm=false;
            showForm2=false;            
        } 
        /* if(CheckProfile.isMobLeadershipProfile())
            isAddVisible = false;
        else
            isAddVisible = true; */
            
        // For UAM     
            List<Deal_Location__c> lstDealLoc = [select wave_plan_version__r.deal__c,
                                                wave_plan_version__r.Display_tracking_message__c,wave_plan_version__r.active__c
                                                from Deal_Location__c where id = : dealLocationId limit 1];
                                                
           /* if(lstDealLoc.size()>0 && lstDealLoc[0].wave_plan_version__r.Display_tracking_message__c==null
                && lstDealLoc[0].wave_plan_version__r.active__c==true) 
            {     */                                
                String strDealId = lstDealLoc.get(0).wave_plan_version__r.deal__c;
                
                /*UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Wave_Planning__c');
                isAddVisible = m.get('C');
                is_WavePlanVersionActive = m.get('U');
                if(m.get('NA'))
                {
                    isNA=false;
                    showMainMsg=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                }*/ 
                is_WavePlanVersionActived=lstDealLoc[0].wave_plan_version__r.active__c;
                isAddVisible = UAMSolMobUtility.isAddVisible_WavePlan;
                is_WavePlanVersionActive = UAMSolMobUtility.is_WavePlanVersionActive_WavePlan;
                if(UAMSolMobUtility.isNA_WavePlan)
                {
                    isNA=false;
                    showMainMsg=true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.NO_PRIVILEGE_PLEASE_CONTACT_YOUR_ADMINISTRATOR));
                }
         //  }
         if(lstDealLoc.size()>0 && lstDealLoc[0].wave_plan_version__r.Display_tracking_message__c==UTIL_Constants.TRACKING_IS_ON)
         {
             is_WavePlanVersionActive =false;
             isAddVisible=false;
             isEditable = false;
         }
         if(lstDealLoc.size()>0 && !lstDealLoc[0].wave_plan_version__r.active__c)
         {
             is_WavePlanVersionActive =false;
             isAddVisible=false;
         }
     }
     /**
    * @Description: check week end upadates  
    * @MethodName:checkweekendupdate
    * @parameters:N/A
    * @
    */ 

    public void checkweekendupdate()
    {
    //Date d = newWavePlan.GO_Live_Date_del__c;  
     List<Wave_Planning__c> wavePlantoUpsert = new List<Wave_Planning__c>();
     for(Wave_Planning__c sm:[Select Wave_Label__c, GO_Live_Date_del__c, Wave_RAG_Status__c, Wave_Completion_Status__c,Deal_Location__c, Number_of_Projected_FTEs__c, Wave_Comment__c,Active__c,NewActive__c,Hyperlink__c From Wave_Planning__c where Deal_Location__c=:DealLocationId limit 1 ])
                {
                    if(addingnewWavePlan.size()>0)
                    {
                        for(Wave_Planning__c lst : addingnewWavePlan)
                        {
                            if(sm.id==lst.id)
                            {
                                if(sm.GO_Live_Date_del__c !=lst.GO_Live_Date_del__c)
                                {
                                   d = lst.GO_Live_Date_del__c;  
                                }
                            }
                        }                       
                    }
                }       
    dt = (DateTime)d+1;
    daytoday= dt.format(UTIL_Constants.EEEE);
    if(daytoday.equalsIgnoreCase(UTIL_Constants.SATURDAY)||daytoday.equalsIgnoreCase(UTIL_Constants.SUNDAY))
    {
        isweekend=true;
        d =System.today();
         dt1 = (DateTime)d;
         Tempday= dt1.format(UTIL_Constants.EEEE);
    if(Tempday.equalsIgnoreCase(UTIL_Constants.SATURDAY))
    {
        d=d+4;
    }    
    if(Tempday.equalsIgnoreCase(UTIL_Constants.SUNDAY))
    {
        d=d+3;
    }     
    }
    else
    {
        isweekend=false;
         d =System.today();
         dt1 = (DateTime)d;
         Tempday= dt1.format(UTIL_Constants.EEEE);
    if(Tempday.equalsIgnoreCase(UTIL_Constants.SATURDAY))
    {
        d=d+4;
    }    
    if(Tempday.equalsIgnoreCase(UTIL_Constants.SUNDAY))
    {
        d=d+3;
    }     
    }
    }
      /**
    * @Description: check week end add 
    * @MethodName:checkweekendadd
    * @parameters:N/A
    * @
    */ 

    public void checkweekendadd()
    {
    Date d1= newWavePlan.GO_Live_Date_del__c;
    dt = (DateTime)d1;
    daytoday= dt.format(UTIL_Constants.EEEE);
    if(daytoday.equalsIgnoreCase(UTIL_Constants.SATURDAY)||daytoday.equalsIgnoreCase(UTIL_Constants.SUNDAY))
    {
        isweekend=true;
    }
    else
    {
        isweekend=false;
    }
     
    }
    
    //Method to add New Wave Plan 
    public void addNewWavePlan() 
    {    
        try
        {
            List<Wave_Planning__c> lstWavePlan= [Select Wave_Label__c, GO_Live_Date_del__c,Number_of_Projected_FTEs__c,Active__c,NewActive__c,Deal_Location__c from Wave_Planning__c where Deal_Location__c=:dealLocationId and Wave_Label__c=:newWavePlan.Wave_Label__c limit 5000];
            //To check duplicacy of Wave Plan Name
            if(lstWavePlan.size()>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.WAVE_NAME_ALREADY_EXITS));
                initializeDetailRecords();
                return;
            }
            /*if(newWavePlan.GO_Live_Date_del__c <=system.today())
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Go Live Date should be greater than today\'s Date.'));
                initializeDetailRecords();
                return;
            }*/
            newWavePlan.Deal_Location__c=dealLocationId;
            //To insert record in Wave Plan Object 
             Database.insert(newWavePlan);
        }
        catch(exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
            initializeDetailRecords();
            return;
        } 
        newWavePlan = new Wave_Planning__c();         
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.RECORD_ADDED_SUCCESFULLY));
        initializeDetailRecords();   
        refreshPage = true;                   
    }
  
    //Method to initialize records in Wave Plan Object
    public void initializeDetailRecords() 
    {
     try{
        //Getting list of all existing records
            addingnewWavePlan= [Select Wave_Label__c, GO_Live_Date_del__c, Wave_RAG_Status__c,Deal_Location__c, Wave_Completion_Status__c, Number_of_Projected_FTEs__c, Wave_Comment__c,Active__c,NewActive__c,Hyperlink__c,isEditVisible__c,Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name from Wave_Planning__c where Deal_Location__c=:DealLocationId order by createddate desc limit 2000];   
            List<Deal_Location__c> lstWavePlanVersion = [Select id,Wave_Plan_Version__r.active__c,Wave_Plan_Version__r.Display_tracking_message__c from Deal_Location__c where id =:dealLocationId];
            if(lstWavePlanVersion.size()>0)
            {
                is_WavePlanVersionActive = lstWavePlanVersion.get(0).Wave_Plan_Version__r.active__c;
                if(lstWavePlanVersion.get(0).Wave_Plan_Version__r.Display_tracking_message__c==UTIL_Constants.TRACKING_IS_ON)
                {
                    is_WavePlanVersionActive =false;  
                }
            }        
        } 
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME,UTIL_Constants.WAVE_PLAN_ADD_INLINE_CONTROLLER, UTIL_Constants.IN_DETAIL_RECORDS, 
                   null, System.Logginglevel.ERROR);
        } 
    } 
    
    //Method to Update records in Wave Plan Object    
    public void saveWavePlan()
    {
        List<Wave_Planning__c> lstDealHomeLoc= [Select Wave_Label__c, GO_Live_Date_del__c,revised_go_live__c ,Wave_RAG_Status__c, Wave_Completion_Status__c,Deal_Location__c, Number_of_Projected_FTEs__c, Wave_Comment__c,Active__c,NewActive__c,Hyperlink__c From Wave_Planning__c where Deal_Location__c=:DealLocationId ];
        List<Wave_Planning__c> wavePlantoUpsert = new List<Wave_Planning__c>();
        if(lstDealHomeLoc.Size()>0)
        {            
            if(lstDealHomeLoc.size()>0)
            {               
                for(Wave_Planning__c sm:lstDealHomeLoc)
                {
                    Integer count=0;
                    if(addingnewWavePlan.size()>0)
                    {
                        for(Wave_Planning__c lst : addingnewWavePlan)
                        {
                            if(sm.id!=lst.id)
                            {
                                if(lst.Deal_Location__c== sm.Deal_Location__c && lst.Wave_Label__c==sm.Wave_Label__c)
                                {
                                    count++;
                                    if(count==2)
                                    {
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.DUPLICATE_RECORDS_NOT_ALLOWED));
                                        initializeDetailRecords();
                                        return;
                                    }
                                }
                            }
                            /*else
                            {
                                if(sm.GO_Live_Date_del__c !=lst.GO_Live_Date_del__c && lst.GO_Live_Date_del__c<=system.today())
                                {
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Go Live Date should be greater than today\'s Date.'));
                                    initializeDetailRecords();
                                    return;
                                }
                            }*/
                        }                       
                    }
                }
                for(Wave_Planning__c s1 : addingnewWavePlan)
                {
                    if(s1.Wave_Comment__c==null && s1.NewActive__c==false)
                     {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.COMMENTS_MADATORY_IF_RECORD_IS_INACTIVE));
                        return;
                     }
                     if(lstDealHomeLoc.size()>0)
                    {               
                        for(Wave_Planning__c sm:lstDealHomeLoc)
                        {
                            if(s1.id==sm.id && (!s1.NewActive__c) && sm.NewActive__c)
                            {
                                s1.isEditVisible__c = false;
                            }
                        }
                    }
                     /*if(s1.NewActive__c==false)
                     {
                         s1.isEditVisible__c = false;
                     }*/
                    for(Wave_Planning__c s2 : addingnewWavePlan)
                    if(s1.id!= s2.id)
                    {
                        //Checking for duplication for Wave Names Editing at the same time to same name
                        if(s1.Deal_Location__c == s2.Deal_Location__c && s1.Wave_Label__c==s2.Wave_Label__c)
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.DUPLICATE_RECORDS_NOT_ALLOWED));
                            initializeDetailRecords();
                            return;
                        } 
                    }
                }
            }            
            List<Wave_Planning__c> oldWPList= [Select Wave_Label__c, GO_Live_Date_del__c,revised_go_live__c ,Wave_RAG_Status__c,Deal_Location__c, Wave_Completion_Status__c, Number_of_Projected_FTEs__c, Wave_Comment__c,Active__c,NewActive__c,Hyperlink__c,isEditVisible__c,Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name from Wave_Planning__c where Deal_Location__c=:DealLocationId order by createddate desc limit 2000];
             Set<ID> wplId = new Set<ID>();           
                
                for(Wave_Planning__c oldlst:oldWPList){
                    for(Wave_Planning__c newlst:AddingnewWavePlan){
                    system.debug('~~~'+newWavePlan);
                    if(newlst.id == oldlst.id && oldlst.go_live_date_del__c != newlst.go_live_date_del__c && oldlst.revised_go_live__c!=null)
                    {
                        newlst.revised_go_live__c=newlst.go_live_date_del__c;
                    }
                    if(newlst.id == oldlst.id && (newlst.NewActive__c != oldlst.NewActive__c)){
                        wplId.add(newlst.id);
                    }
                    
                }
            }
            WavePlanToUpsert.addAll(AddingnewWavePlan);        
            try 
            {
                //Updating records of Wave Plan
                upsert WavePlanToUpsert;
                deactivateHighLevelPlans(wplId);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.RECORD_SAVED_SUCCESSFULLY));                
            }
            catch(Exception ex) 
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
                initializeDetailRecords();
                return;
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.INSERT_RECORD));
        }
        initializeDetailRecords();
    }
    
    //Page refresh after adding record
    public void refreshWavePlanPage()
    {        
        initializeDetailRecords();
    }  
    
    /******************************
    Method Name: checkRecordDeactivated
    Description: This method is used to check the record is deactivated.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void checkRecordDeactivated()
    {
        checkweekendupdate();
        isRecordDeactivate=0;
        boolean iscomment=true;
        boolean isInactive=false;
        List<Wave_Planning__c > tempWavePlan= [Select Wave_Label__c, GO_Live_Date_del__c, Wave_RAG_Status__c,Deal_Location__c, Wave_Completion_Status__c, 
                                                Number_of_Projected_FTEs__c, Wave_Comment__c,Active__c,NewActive__c,Hyperlink__c from Wave_Planning__c 
                                                where Deal_Location__c=:DealLocationId order by createddate desc limit 5000];   
        
        if(tempWavePlan.size()>0)
        { 
            for(Wave_Planning__c oldList : tempWavePlan)
            {
                if(addingnewWavePlan.size()>0)
                {
                    for(Wave_Planning__c newList : addingnewWavePlan)
                    {
                        if(newList.Wave_Comment__c==null && !newList.NewActive__c)
                        {
                            isComment=false;
                        }
                        if(oldList.id==newList.id && oldList.NewActive__c && !newList.NewActive__c)
                        {
                            isInactive=true;
                        }
                    }
                }
            }
        } 
        if(!isComment) 
        {
            isRecordDeactivate=2;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.COMMENTS_MADATORY_IF_RECORD_IS_INACTIVE));
            initializeDetailRecords();
            return;
        }  
        if(isInactive==true) 
        {
            isRecordDeactivate=1;
        }                                  
    }
    /******************************
    Method Name: deactivateHighLevelPlans
    Description: DeActive the High level mobilization plan
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deactivateHighLevelPlans(set<id> waveIdList)
    {
        set<Id> dealLocationId = new set<Id>();
            List<Wave_Planning__c> wpLocList= [Select Wave_Label__c, GO_Live_Date_del__c, Wave_RAG_Status__c,Deal_Location__c, Wave_Completion_Status__c, Number_of_Projected_FTEs__c, Wave_Comment__c,Active__c,NewActive__c,Hyperlink__c,isEditVisible__c,Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name from Wave_Planning__c where id in : waveIdList limit 2000];
             for(Wave_Planning__c wp :wpLocList ) {
                 dealLocationId.add(wp.Deal_Location__c);
             }           
        list<Deal_Location__c> lstDealLocation=[select id,Wave_Plan_Version__c from Deal_Location__c where id in :dealLocationId limit 1];
        if(lstDealLocation.size()==1)
        {
            try
            {
                list<SRAT__c> lstSrat=[Select id,Active__c,Item__c,Wave_Plan_lk__c,isEditVisible__c,Milestone__c  from SRAT__c where 
                                        Wave_Plan_Version__c=:lstDealLocation[0].Wave_Plan_Version__c order by createddate desc limit 5000];
                                    
                List<OPEX__c> lstOpex=[Select id,Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c,Wave_Process__c  from OPEX__c where 
                                        Wave_Plan_Version__c=:lstDealLocation[0].Wave_Plan_Version__c order by createddate desc limit 5000];                    
                
                List <KT_Planning__c> lstKtPlanning=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from KT_Planning__c where 
                                                        Wave_Plan_Version__c=:lstDealLocation[0].Wave_Plan_Version__c order by createddate desc]; 
            
                List<Recruitment_Tracking__c> lstRecruitmentTracking=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from Recruitment_Tracking__c where 
                                                                    Wave_Plan_Version__c=:lstDealLocation[0].Wave_Plan_Version__c order by createddate desc];
            
                List<Contract_Legal_Infosec__c> lstContractLegalInfosec =[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from Contract_Legal_Infosec__c where 
                                                                        Wave_Plan_Version__c=:lstDealLocation[0].Wave_Plan_Version__c order by createddate desc];    
            
                List<Tech_Assessment__c> lstTechAssessment=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from Tech_Assessment__c where 
                                                            Wave_Plan_Version__c=:lstDealLocation[0].Wave_Plan_Version__c order by createddate desc];
           
                List<Wave_Process__c> lstWaveProcess=[Select  id,Wave_Planning__C,Wave_Planning__r.Deal_Location__c,Active__c from Wave_Process__c where Wave_Planning__r.Deal_Location__c =: dealLocationId];
                if(wpLocList.size()>0)
                {
                    list<SRAT__c> templstSrat=new list<SRAT__c>();
                    List<OPEX__c> templstOpex=new List<OPEX__c>();
                    List <KT_Planning__c> templstKtPlanning= new List <KT_Planning__c>();
                    List<Recruitment_Tracking__c> templstRecruitment=new List<Recruitment_Tracking__c>();
                    List<Contract_Legal_Infosec__c> templstContract=new List<Contract_Legal_Infosec__c>();
                    List<Tech_Assessment__c> templstTech=new List<Tech_Assessment__c>();
                    for(Wave_Planning__c newList : wpLocList)
                    {

                        if(!newList.NewActive__c && !newList.isEditVisible__c)
                        {
                            if(lstSrat.size()>0)
                            {
                                for(SRAT__c s : lstSrat)
                                {
                                    if(s.Wave_Plan_lk__c== newList.id)
                                    {
                                        s.isEditVisible__c=false;
                                        s.active__c=false;
                                        s.Milestone__c=false;
                                        templstSrat.add(s);
                                    }
                                }
                            }
                            
                            if(lstOpex.size()>0)
                            {
                                for(OPEX__c o : lstOpex)
                                {
                                    if(o.Wave_Plan_lk__c== newList.id)
                                    {
                                        o.isEditVisible__c=false;
                                        o.active__c=false;
                                        o.Milestone__c=false;
                                        templstOpex.add(o);
                                    }
                                }
                            }
                            
                            if(lstKtPlanning.size()>0)
                            {
                                for(KT_Planning__c k : lstKtPlanning)
                                {
                                    if(k.Wave_Plan_lk__c== newList.id)
                                    {
                                        k.isEditVisible__c=false;
                                        k.active__c=false;
                                        k.Milestone__c=false;
                                        templstKtPlanning.add(k);
                                    }
                                }
                            }
                            
                            if(lstRecruitmentTracking.size()>0)
                            {
                                for(Recruitment_Tracking__c r : lstRecruitmentTracking)
                                {
                                    if(r.Wave_Plan_lk__c== newList.id)
                                    {
                                        r.isEditVisible__c=false;
                                        r.active__c=false;
                                        r.Milestone__c=false;
                                        templstRecruitment.add(r);
                                    }
                                }
                            }
                            
                            if(lstContractLegalInfosec.size()>0)
                            {
                                for(Contract_Legal_Infosec__c con : lstContractLegalInfosec )
                                {
                                    if(con.Wave_Plan_lk__c== newList.id)
                                    {
                                        con.Active__c=false;
                                        //con.Milestone__c=false;
                                        con.isEditVisible__c=false;
                                        templstContract.add(con);
                                    }
                                }
                            }
                            
                            if(lstTechAssessment.size()>0)
                            {
                                for(Tech_Assessment__c t : lstTechAssessment)
                                {
                                    if(t.Wave_Plan_lk__c== newList.id)
                                    {
                                        t.Active__c=false;
                                        t.Milestone__c=false;
                                        t.isEditVisible__c=false;
                                        templstTech.add(t);
                                    }
                                }
                            }
                        }
                        // Below Code added by Ayush For Defect D-1670

                        else
                        {
                            if(lstSrat.size()>0)
                            {
                                for(SRAT__c s : lstSrat)
                                {
                                    if(s.Wave_Plan_lk__c== newList.id)
                                    {
                                        s.isEditVisible__c=true;
                                        s.Active__c=true;
                                        s.Milestone__c=false;
                                        templstSrat.add(s);
                                    }
                                }
                            }
                            
                            if(lstOpex.size()>0)
                            {    

                                for(OPEX__c o : lstOpex) {
                                 if(o.Wave_Plan_lk__c== newList.id)
                                    {  
                                        for(Wave_Process__c wp :lstWaveProcess ) {
                                            if(o.Wave_Plan_lk__c== newList.id && o.Wave_Process__c == wp.id)
                                            {
                                                o.isEditVisible__c= wp.Active__c;
                                                o.active__c= wp.Active__c;
                                                o.Milestone__c=false;
                                                templstOpex.add(o);
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if(lstKtPlanning.size()>0)
                            {
                                for(KT_Planning__c k : lstKtPlanning)
                                {
                                    if(k.Wave_Plan_lk__c== newList.id)
                                    {
                                        k.Active__c=true;
                                        k.isEditVisible__c=true;
                                        k.Milestone__c=false;
                                        templstKtPlanning.add(k);
                                    }
                                }
                            }
                            
                            if(lstRecruitmentTracking.size()>0)
                            {
                                for(Recruitment_Tracking__c r : lstRecruitmentTracking)
                                {
                                    if(r.Wave_Plan_lk__c== newList.id)
                                    {
                                        r.Active__c=true;
                                        r.isEditVisible__c=true;
                                        r.Milestone__c=false;
                                        templstRecruitment.add(r);
                                    }
                                }
                            }
                            
                            if(lstContractLegalInfosec.size()>0)
                            {
                                for(Contract_Legal_Infosec__c con : lstContractLegalInfosec )
                                {
                                    if(con.Wave_Plan_lk__c== newList.id)
                                    {
                                        con.Active__c=true;
                                        con.Milestone__c=false;
                                        con.isEditVisible__c=true;
                                        templstContract.add(con);
                                    }
                                }
                            }
                            
                            if(lstTechAssessment.size()>0)
                            {
                                for(Tech_Assessment__c t : lstTechAssessment)
                                {
                                    if(t.Wave_Plan_lk__c== newList.id)
                                    {
                                        t.Active__c=true;
                                        t.Milestone__c=false;
                                        t.isEditVisible__c=true;
                                        templstTech.add(t);
                                    }
                                }
                            }
                        }
                    }
                    if(templstSrat.size()>0)
                        upsert templstSrat;
                    
                    if(templstOpex.size()>0)
                        upsert templstOpex;
                    
                    if(templstKtPlanning.size()>0)
                        upsert templstKtPlanning;
                    
                    if(templstRecruitment.size()>0)
                        upsert templstRecruitment;
                    
                    if(templstContract.size()>0)
                        upsert templstContract;
                    
                    if(templstTech.size()>0)
                        upsert templstTech;
                }
            }
            catch(Exception ex) 
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));
                initializeDetailRecords();
                return;
            }
        }
        return;
    }
}