/**
@isBest
@Author IO Developer
@name IOCostModelUpload
@CreateDate 01/04/2015
@Description This is the with sharing class for IOCostModelUpload.
@Version <1.0>
@reference 
*/
public with sharing class IOCostModelUpload {
    // to stop Triggers:
    public static boolean stopTriggerExecution = false;
    public Transient Blob fileBody {get; set;}
    public Transient String fileFullData{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public Transient String Description{get;set;}
    public Transient List<String> allLines = new List<String>();
    public Transient String allLines_Pyramid_SWB {get;set;}
    public Transient List<String> split_Pyramid_SWB = new List<String>();
    public Transient String allLines_Payroll_SWB{get;set;}
    public Transient List<String> split_Payroll_SWB= new List<String>();
    public Transient String allLines_Other_Cost_SWB{get;set;}
    public Transient List<String> split_Other_Cost_SWB= new List<String>();
    public Transient String allLines_Volume_SWB {get;set;}
    public Transient List<String> split_Volume_SWB = new List<String>();
    public Id OppId {get; set;}
    public boolean iserror = false;
    public boolean isUploadable =true;
    public List<FTE_Details__c> listPyramidSWB;
// For Lookups & MD Ids
    public Transient String BillCodeMasterName;
    public Transient String CareerLevelMasterName;
    public Transient String CareerTrackMasterName;
    public Transient String CountryMasterName;
    public Transient String EconomicProfileMasterName;
    public Transient String LoadTypeMasterName;
    public Transient String RateTypeMasterName;
    public Transient String ResourceGroupMasterName;
    public Transient String RoleMasterName;
    public Transient String ServiceName;
    public Transient String ServiceComponentName;
    public Transient String SolutionScopeName;
    
    public MAP<String,ID> BillCodeMasterID;
    public MAP<String,ID> CareerLevelMasterID;
    public MAP<String,ID> CareerTrackMasterID;
    public MAP<String,ID> CountryMasterID;
    public MAP<String,ID> EconomicProfileMasterID;
    public MAP<String,ID> LoadTypeMasterID;
    public MAP<String,ID> RateTypeMasterID;
    public MAP<String,ID> ResourceGroupMasterID;
    public MAP<String,ID> RoleMasterID;
    public MAP<String,ID> ServiceID;
    public MAP<String,ID> ServiceComponentID;
    public MAP<String,ID> SolutionScopeID;
    public MAP<String,ID> deliveryLocID; 
    
    public SET<String> countryNames = new SET<String>();
    
    // List of Objects to insert
    public List<FTE_Details__c> listPyramid_SWB = new List<FTE_Details__c>();
    public FTE_Details__c Pyramid_SWB;
    
    public List<Payroll__c> listPayroll_SWB = new List<Payroll__c>();
    public Payroll__c Payroll_SWB;
    
    public List<Other_Cost_Details__c> listOther_Cost_SWB = new List<Other_Cost_Details__c>();
    public Other_Cost_Details__c Other_Cost_SWB;
    
    public List<Volume_Detail__c> listVolume_SWB = new List<Volume_Detail__c>();
    public Volume_Detail__c Volume_SWB;
    
    public List<Opportunity_Delivery_Location__c> oppDevLocList = new List<Opportunity_Delivery_Location__c>();
    public Opportunity_Delivery_Location__c oppDevLoc;
    
    //Lists To Delete
    public List<FTE_Details__c> listPyramid_Del = new List<FTE_Details__c>();
    public List<Payroll__c> listPayroll_Del = new List<Payroll__c>();
    public List<Other_Cost_Details__c> listOther_Cost_Del = new List<Other_Cost_Details__c>();
    public List<Volume_Detail__c> listVolume_Del = new List<Volume_Detail__c>();
    public List<Opportunity_Delivery_Location__c> listIOdelLocs_del = new List<Opportunity_Delivery_Location__c>();
    //Field Maps
    public Map<integer,string> PyramidfieldMap;
    public Map<integer,string> PayrollfieldMap;
    public Map<integer,string> OtherCostfieldMap;
    public Map<integer,string> VolumefieldMap;
    
    //attachment
    public attachment IOexcel {get; set;}
    public attachment IOexcel_disp {get; set;}
    public List<attachment> listIOsheets {get; set;}
    public List<attachment> listIOsheets_del {get; set;}
    
    // for Opportunity Details
    public Opportunity opp_details {get; set;}
    
    //
    public boolean isPyramidUploadable = false;
    public boolean isPayrollUploadable = false;
    public boolean isOtherCostUploadable = false;
    public boolean isVolumeUploadable = false;    
    /**
    @Author IO Developer
    @name IOCostModelUpload
    @CreateDate 01/04/2015
    @Description This is the constructor for IOCostModelUpload class.
    @Version <1.0>
    @reference     
    */
    public IOCostModelUpload(ApexPages.StandardController controller) {
    Apexpages.currentPage().getHeaders().put(UtilConstants.X_COMPAT, UtilConstants.IE_EDGE);
    OppId=ApexPages.currentPage().getParameters().get(UtilConstants.id_par);
    try{
        opp_details =[select name,FTE_Off_IO__c,FTE_Ons_IO__c,account.name from opportunity where id=:OppId limit 1];
        getDocs();
    }
    catch(Exception w){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.INVALID_ID);
                    ApexPages.addMessage(myMsg);
    }
    }
    /**
    @Author IO Developer
    @name getDocs
    @CreateDate 01/04/2015
    @Description This is the void type method for getting the Documents.
    @Version <1.0>
    @reference 
    */
    public void getDocs(){
    try{
        listIOsheets = new List<attachment>();
        listIOsheets = [select id, name, description,createdDate from attachment where parentId=:OppId limit 1];
        
        if(listIOsheets.size()==1){
            IOexcel_disp=listIOsheets[0];
            }
          }
          Catch(Exception e)
          {
              //String str = e.getMessage();
          /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
            if(!Test.isRunningTest()){
              throw(e);
            }
          }
    }
    
    /**
    @Author IO Developer
    @name uploadField
    @CreateDate 01/04/2015
    @Description This is the PageReference type method for uploading a File.
    @Version <1.0>
    @reference 
    */
    public PageReference uploadFile() {
    
    try{
        UtilConstants.stopTriggersForIO =false;
        stopTriggerExecution = true;
        SWBBPOSEIntegrationConstants.runservTrigger = false;
        if(allLines_Pyramid_SWB!=null){
            split_Pyramid_SWB = allLines_Pyramid_SWB.split(UtilConstants.NEW_LINE);
            split_Payroll_SWB = allLines_Payroll_SWB.split(UtilConstants.NEW_LINE);
            split_Other_Cost_SWB = allLines_Other_Cost_SWB.split(UtilConstants.NEW_LINE);
            split_Volume_SWB = allLines_Volume_SWB.split(UtilConstants.NEW_LINE);
            System.debug(split_Pyramid_SWB.size());

            if(split_Pyramid_SWB.size() <= 3)
                {             
                    //File with no data in Pyramid - SWB Tab
                    iserror = true;
                    isUploadable = false;
                    ////System.debug('pyramid isUploadable'+isUploadable);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_5);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }
        if(allLines_Payroll_SWB!=null){        
            if(split_Payroll_SWB.size() <= 3)
                {             
                    //File with no data in Pyramid - SWB Tab
                    iserror = true;
                    isUploadable = false;
                    ////System.debug('payroll isUploadable'+isUploadable);
                    System.debug(split_Payroll_SWB.size());
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_5);
                    ApexPages.addMessage(myMsg);
                    return null;
                }  
            }
       if(allLines_Other_Cost_SWB!=null){     
            if(split_Other_Cost_SWB.size() <= 3)
                {             
                    //File with no data in Pyramid - SWB Tab
                    iserror = true;
                    isUploadable = false;
                    ////System.debug('Other isUploadable'+isUploadable);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_5);
                    ApexPages.addMessage(myMsg);
                    return null;
                }  
           }
       if(allLines_Volume_SWB!=null){          
           if(split_Volume_SWB.size() <= 2)
                {             
                    //File with no data in Pyramid - SWB Tab
                    iserror = true;
                    isUploadable = false;
                    ////System.debug('volume isUploadable'+isUploadable);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_5);
                    ApexPages.addMessage(myMsg);
                    return null;
                }   
        }
        
        
        if(!iserror)
            {
                //prepare field map
                prepareFieldMap();
                billcodeFieldMap();
                careerlevelMap();
                careertrackMap();
                countryMap();
                economicMap();
                loadMap();
                rateMap();
                resourceMap();
                roleMap();
                serviceMap();
                servicecompMap();
                solscopeMap();
                deliveryLocMap();
                //call upload methods
                System.debug('value of isUploadable '+isUploadable);
                if(isUploadable){
                insertPyramidSWB();
                insertPayrollSWB();
                insertOtherCostSWB();
                insertVolumeSWB();
                insertAttachment();
                insertDeliveryLoc();
                System.debug('About to insert');
                System.debug('isPyramidUploadable '+isPyramidUploadable+'isPayrollUploadable '+isPayrollUploadable +'isOtherCostUploadable '+isOtherCostUploadable +'isVolumeUploadable'+isVolumeUploadable);
                if(isPyramidUploadable && isPayrollUploadable && isOtherCostUploadable && isVolumeUploadable){
                    if(listPyramid_SWB.size()>0 && listPayroll_SWB.size()>0 && listOther_Cost_SWB.size()>0){
                        System.debug('Almost there');
                        database.insert(listPyramid_SWB);
                        database.insert(listPayroll_SWB);
                        database.insert(listOther_Cost_SWB);
                        database.insert(listVolume_SWB);
                        database.insert(IOexcel);
                        if(listIOdelLocs_del.size()>0){
                            database.delete(listIOdelLocs_del);
                        }
                        database.insert(oppDevLocList);
                        system.debug('y this kolaveri kolaveri kolaveri di');
                        // Clearing the stuff out to prevent View State!
                        IOexcel = null;
                        fileBody=null;
                        dropFileName = null;
                        // Clearing the stuff out to prevent View State!
                        
                        
                    }
                    
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, UtilConstants.PAGE_MSG_6);
                     ApexPages.addMessage(myMsg);
                     deletePreviousRecords();
                     IOCostModelFuture.calcOppFte(oppId);
                     IOCostModelFuture.calcOtherCost(oppId);
                     IOCostModelFuture.calcPayroll(oppId);
                     IOCostModelFuture.activateSubComps(countryNames,Serviceid,SolutionScopeID);
                }
                stopTriggerExecution = false;
                getDocs();
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, UtilCOnstants.PAGE_MSG_7);
                    ApexPages.addMessage(myMsg);
                }
            }
        }
        catch(Exception w){System.debug('ye hai exception'+w.getLineNumber());
        stopTriggerExecution = false;}
        finally{
        IOexcel = null;
            fileBody=null;
            dropFileName = null;
        }
        return null;
    }
    
    
    
    /**
    @Author IO Developer
    @name billcodeFieldMap
    @CreateDate 01/04/2015
    @Description This is the void type method for bill coding the Field Map.
    @Version <1.0>
    @reference 
    */
    public void billcodeFieldMap(){
        
        try{    
        BillCodeMasterID = new MAP<String,ID>();
        //////////System.debug('billcodeFieldMap');
            // Fetch Bill Code Master
            for(Bill_Code_Master__c billcodeMaster : [select id,name from Bill_Code_Master__c limit 500]){
                BillCodeMasterID.put(billcodeMaster.name,billcodeMaster.id);
            }
            if(BillCodeMasterID.size()==0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_7);
                    ApexPages.addMessage(myMsg);
                isUploadable = false;
                ////System.debug('Bill isUploadable'+isUploadable);
                
            }
            //////////System.debug('~~~'+BillCodeMasterID);
           }
           catch(exception e) {
               //String str = e.getMessage();
          /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
            if(!Test.isRunningTest()){
                throw(e);
              }
         }
    }    
    /**
    @Author IO Developer
    @name careerlevelMap
    @CreateDate 01/04/2015
    @Description This is the void type method for career level Map.
    @Version <1.0>
    @reference 
    */
    public void careerlevelMap(){
        try{    
        CareerLevelMasterID = new MAP<String,ID>();
        //////////System.debug('careerlevelMap');
            // Fetch Bill Code Master
            for(Career_Level__c careerlevelMaster : [select id,name from Career_Level__c limit 500]){
                CareerLevelMasterID.put(careerlevelMaster.name,careerlevelMaster.id);
            }
            if(CareerLevelMasterID.size()==0){
                isUploadable = false;
                ////System.debug('clevel isUploadable'+isUploadable);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_9);
                    ApexPages.addMessage(myMsg);
            }

            //////////System.debug('~~~'+CareerLevelMasterID);
           }
           catch(exception e) {
               //String str = e.getMessage();
          /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
              if(!Test.isRunningTest()){
                throw(e);
              }
           }
    }    
    /**
    @Author IO Developer
    @name careertrackMap
    @CreateDate 01/04/2015
    @Description This is the void type method for career tracking of Map.
    @Version <1.0>
    @reference 
    */
    public void careertrackMap(){
        CareerTrackMasterID = new MAP<String,ID>();
        ////////System.debug('careertrackMap');
            // Fetch Bill Code Master
            for(Career_Track_Master__c careertrackMaster : [select id,name from Career_Track_Master__c limit 500]){
                CareerTrackMasterID.put(careertrackMaster.name,careertrackMaster.id);
            }
            if(CareerTrackMasterID.size()==0){
                isUploadable = false;
                ////System.debug('ctrack isUploadable'+isUploadable);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_10);
                    ApexPages.addMessage(myMsg);
            }

            ////////System.debug('~~~'+CareerTrackMasterID);
           
    }    
    /**
    @Author IO Developer
    @name countryMap
    @CreateDate 01/04/2015
    @Description This is the void type method for countryMap.
    @Version <1.0>
    @reference 
    */
    public void countryMap(){
        CountryMasterID = new MAP<String,ID>();
        ////////System.debug('Preparing Field Map');
            // Fetch Bill Code Master
            for(Country_Master__c countryMaster : [select id,name from Country_Master__c limit 5000]){
                CountryMasterID.put(countryMaster.name,countryMaster.id);
            }
             if(CountryMasterID.size()==0){
                isUploadable = false;
                ////System.debug('country isUploadable'+isUploadable);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_11);
                    ApexPages.addMessage(myMsg);
            }
            ////////System.debug('~~~'+CountryMasterID);
           
    }
    
     /**
    @Author IO Developer
    @name solscopeMap
    @CreateDate 01/04/2015
    @Description This is the method for solution scope Map.
    @Version <1.0>
    @reference 
    */    
    public void deliveryLocMap(){
        deliveryLocID = new MAP<String,ID> ();
        for(Delivery_Location_Masters__c delocMaster: [select id,country__r.Name,Is_IO_Location__c 
                                                      from Delivery_Location_Masters__c where Is_IO_Location__c =: true]){
            deliveryLocID .put(delocMaster.country__r.Name,delocMaster.id);
        }
        if(deliveryLocID.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_17);
               ApexPages.addMessage(myMsg);
               isUploadable = false;
               ////System.debug('deliveryloc isUploadable'+isUploadable);
        }
           
    }     
    
    /**
    @Author IO Developer
    @name addNewCountryMaster
    @CreateDate 01/04/2015
    @Description This is the string type method for adding new country master.
    @Version <1.0>
    @reference 
    */    
    public String addNewCountryMaster(String countryName){
        Country_Master__c newCountrymaster = new Country_Master__c();
        newCountrymaster.name=countryName;
        newCountrymaster.active__c=true;
        database.insert(newCountrymaster);
        CountryMasterName = newCountrymaster.id;
        return CountryMasterName;
        
    }
    /**
    @Author IO Developer
    @name economicMap
    @CreateDate 01/04/2015
    @Description This is the method for economic Map.
    @Version <1.0>
    @reference 
    */    
    public void economicMap(){
        EconomicProfileMasterID = new MAP<String,ID>();
        ////////System.debug('economicMap');
            // Fetch Bill Code Master
            for(EconomicProfile_Master__c economicprofileMaster: [select id,name from EconomicProfile_Master__c limit 5000]){
                EconomicProfileMasterID.put(economicprofileMaster.name,economicprofileMaster.id);
            }
            if(EconomicProfileMasterID.size()==0){
                isUploadable = false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_12);
                    ApexPages.addMessage(myMsg);
            }
            //////////System.debug('~~~'+EconomicProfileMasterID);
           
    }
    
    /**
    @Author IO Developer
    @name loadMap
    @CreateDate 01/04/2014
    @Description This is the method for loading Map.
    @Version <1.0>
    @reference 
    */    
    public void loadMap(){
        LoadTypeMasterID = new MAP<String,ID>();
        ////////System.debug('loadMap');
            // Fetch Bill Code Master
            for(Load_Type_Master__c loadtypeMaster: [select id,name from Load_Type_Master__c limit 5000]){
                LoadTypeMasterID.put(loadtypeMaster.name,loadtypeMaster.id);
            }
            if(LoadTypeMasterID.size()==0){
                isUploadable = false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_13);
                    ApexPages.addMessage(myMsg);
            }
            //////////System.debug('~~~'+LoadTypeMasterID);
           
    }
    /**
    @Author IO Developer
    @name rateMap
    @CreateDate 01/04/2015
    @Description This is the mehtod for rating Map.
    @Version <1.0>
    @reference 
    */    
    public void rateMap(){
        RateTypeMasterID = new MAP<String,ID>();
      for(Rate__c rateMaster: [select id,name from Rate__c limit 5000]){
          RateTypeMasterID.put(rateMaster.name,rateMaster.id);
        }
        if(RateTypeMasterID.size()==0){
            isUploadable = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_14);
                ApexPages.addMessage(myMsg);
        }
           
    }
    /**
    @Author IO Developer
    @name resourceMap
    @CreateDate 01/04/2015
    @Description This is the method for resourceMap.
    @Version <1.0>
    @reference 
    */    
    public void resourceMap(){
        ResourceGroupMasterID = new MAP<String,ID>();
        // Fetch Bill Code Master
        for(Resource_Group_Master__c resourceMaster: [select id,name from Resource_Group_Master__c limit 5000]){
            ResourceGroupMasterID.put(resourceMaster.name,resourceMaster.id);
        }
        if(ResourceGroupMasterID.size()==0){
            isUploadable = false;
        }
           
    }       
    /**
    @Author IO Developer
    @name roleMap
    @CreateDate 01/04/2015
    @Description This is the method for role Map.
    @Version <1.0>
    @reference 
    */
    public void roleMap(){
        RoleMasterID = new MAP<String,ID>();
        // Fetch Bill Code Master
        for(Role_Master__c roleMaster: [select id,name from Role_Master__c limit 5000]){
            RoleMasterID.put(roleMaster.name,roleMaster.id);
        }
        if(RoleMasterID.size()==0){
            isUploadable = false;
        }
           
    }     
    /**
    @Author IO Developer
    @name serviceMap
    @CreateDate 01/04/2015
    @Description This is the method for service map
    @Version <1.0>
    @reference 
    */
    public void serviceMap(){
       ServiceID = new MAP<String,ID>();
        for(Service__c serviceMaster: [select id,services__r.name,services__r.offering__r.name from Service__c 
                                      where Solutionscope__r.Opportunity__c =:OppId and 
                                      Solutionscope__r.Service_Group__c = 'IO' limit 5000]){
            ////System.debug('***'+serviceMaster.services__r.offering__r.name+';'+serviceMaster.services__r.name);                          
            ServiceID.put(serviceMaster.services__r.offering__r.name+';'+serviceMaster.services__r.name,serviceMaster.id);
        }
        ////System.debug('-------'+ServiceID.size());
        
        if(ServiceID.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_15);
                ApexPages.addMessage(myMsg);
            isUploadable = false;
        }
    } 
    /**
    @Author IO Developer
    @name servicecomMap
    @CreateDate 01/04/2015
    @Description This is the mehtod for service comMap.
    @Version <1.0>
    @reference 
    */
    public void servicecompMap(){
        ServiceComponentID = new MAP<String,ID>();
        for(Service_Components__c solcompMaster: [select id,Services_Component_Master__r.name from Service_Components__c 
            where Service__r.Solutionscope__r.Opportunity__c =:OppId limit 5000]){
            ServiceComponentID.put(solcompMaster.Services_Component_Master__r.name,solcompMaster.id);
        }
        if(ServiceComponentID.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_16);
                ApexPages.addMessage(myMsg);
            isUploadable = false;
        }
            
    }     
    /**
    @Author IO Developer
    @name solscopeMap
    @CreateDate 01/04/2015
    @Description This is the method for solution scope Map.
    @Version <1.0>
    @reference 
    */    
    public void solscopeMap(){
        SolutionScopeID = new MAP<String,ID> ();
        for(Solution_Scope__c solscopeMaster: [select id,Offering_Master__r.name from Solution_Scope__c
                                              where Opportunity__c =:OppId and Service_Group__c = 'IO' limit 5000]){
            SolutionScopeID.put(solscopeMaster.Offering_Master__r.name,solscopeMaster.id);
        }
        if(SolutionScopeID.size()==0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_17);
               ApexPages.addMessage(myMsg);
               isUploadable = false;
        }
           
    }  
    
       
    /**
    @Author IO Developer
    @name prepareFieldMap
    @CreateDate 01/04/2015
    @Description This is the mehtod for preparing field map for IOCostModelUpload class.
    @Version <1.0>
    @reference 
    */    
    public void prepareFieldMap(){
        PyramidfieldMap = new Map<integer,string>();
            for(pyramid_swb_field_map__c pyMap: [SELECT Name,Order__c FROM pyramid_swb_field_map__c limit 150]){
                PyramidfieldMap.put(integer.valueOf(pyMap.order__c),pyMap.name);
            }
            
            PayrollfieldMap = new Map<integer,string>();
            for(payroll_swb_field_map__c payMap: [SELECT Name,Order__c FROM payroll_swb_field_map__c limit 150]){
                PayrollfieldMap.put(integer.valueOf(payMap.order__c),payMap.name);
            }
            
            OtherCostfieldMap = new Map<integer,string>();
            for(Other_Cost_SWB_field_map__c costMap: [SELECT Name,Order__c FROM Other_Cost_SWB_field_map__c limit 150]){
                OtherCostfieldMap.put(integer.valueOf(costMap.order__c),costMap.name);
            }

            VolumefieldMap = new Map<integer,string>();
            for(Volume_SWB_field_map__c volMap: [SELECT Name,Order__c FROM Volume_SWB_field_map__c limit 150]){
                VolumefieldMap.put(integer.valueOf(volMap.order__c),volMap.name);
            }
            
    }            
    /**
    @Author IO Developer
    @name insertPrymidSWD
    @CreateDate 01/04/2015
    @Description This is the method for inserting PyramidSWB
    @Version <1.0>
    @reference 
    */
    public void insertPyramidSWB(){
        ////////System.debug('in Insert method');
        try{
            isPyramidUploadable = true;
            ApexPages.Message myMsg;
            Map<String, Schema.SObjectField> pyramidFields = Schema.SObjectType.FTE_Details__c.fields.getMap();
            
            String key1;
            for(integer i=3; i<split_Pyramid_SWB.size() && isPyramidUploadable; i++){
            
                String[] inputvalues = new String[]{};
                //////////System.debug('hohoho'+split_Pyramid_SWB[i].trim());
                if(split_Pyramid_SWB[i].trim()!=UtilConstants.EMPTY_STRING){
                
                inputvalues = split_Pyramid_SWB[i].split('»');
                Pyramid_SWB = new FTE_Details__c();
                if(inputvalues.size() != 0)
                {
                    integer numberofcolumns = inputvalues.size();
                    if(numberofcolumns >= 15){
                        ////////System.debug('loop1'+i);
                    
            
            if((inputvalues[4]!=null && inputvalues[4].trim()!=UtilConstants.EMPTY_STRING && null!=SolutionScopeID.get(inputvalues[4].trim())) && (inputvalues[5]!=null && inputvalues[5].trim()!=UtilConstants.EMPTY_STRING))
            {
            key1 = inputvalues[4]+';'+inputvalues[5];
            }
            ////System.debug('key1'+'-------'+key1);
                
                        if(inputvalues[1]!=null && inputvalues[1].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('1');
                            Pyramid_SWB.Activity_Description__c = inputvalues[1];
                        }
                        
                        if(inputvalues[2]!=null && inputvalues[2].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('2');
                            Pyramid_SWB.Phase__c = inputvalues[2];
                        }
                        
                        if(inputvalues[3]!=null && inputvalues[3].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('3'+i);
                            Pyramid_SWB.Service_Group__c = inputvalues[3];
                        }
                        
                        if(inputvalues[4]!=null && inputvalues[4].trim()!=UtilConstants.EMPTY_STRING && null!=SolutionScopeID.get(inputvalues[4].trim())){
                        ////////System.debug('4'+i);
                            Pyramid_SWB.Sub_Service_Group__c = SolutionScopeID.get(inputvalues[4].trim());
                            
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilCOnstants.PAGE_MSG_18);
                            ApexPages.addMessage(myMsg);
                            ////System.debug('Solution Scope');
                            isPyramidUploadable = false;
                        }
                        
                        if(inputvalues[5]!=null && inputvalues[5].trim()!=UtilConstants.EMPTY_STRING && ServiceID.get(key1)!=null){
                        ////////System.debug('5'+i);

                            Pyramid_SWB.Service__c = ServiceID.get(key1);
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_19);
                            ApexPages.addMessage(myMsg);
                            ////System.debug('Service:::'+ServiceID.get(key1));
                            isPyramidUploadable = false;
                        }
                        if(inputvalues[6]!=null && inputvalues[6].trim()!=UtilConstants.EMPTY_STRING  && ServiceComponentID.get(inputvalues[6].trim())!=null){
                        ////////System.debug('6'+i);
                            Pyramid_SWB.Service_Component__c = ServiceComponentID.get(inputvalues[6].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_20);
                            ApexPages.addMessage(myMsg);
                            ////System.debug('Service Component');
                            isPyramidUploadable = false;
                        }
                        if(inputvalues[7]!=null && inputvalues[7].trim()!=UtilConstants.EMPTY_STRING && ResourceGroupMasterID.get(inputvalues[7].trim())!=null){
                        ////////System.debug('7'+i);
                            Pyramid_SWB.Resource_Group__c = ResourceGroupMasterID.get(inputvalues[7].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_21);
                            ApexPages.addMessage(myMsg);
                            isPyramidUploadable = false;
                        }
                        if(inputvalues[8]!=null && inputvalues[8].trim()!=UtilConstants.EMPTY_STRING){
                            if(CountryMasterID.get(inputvalues[8].trim())!=null){
                                countryNames.add(inputvalues[4].trim()+';'+inputvalues[5].trim()+';'+inputvalues[8].trim());
                                ///////System.debug('8'+i);
                                ////System.debug('------'+inputvalues[8]);
                                Pyramid_SWB.Country__c = CountryMasterID.get(inputvalues[8].trim());
                            }
                            else{
                                Pyramid_SWB.Country__c = addNewCountryMaster(inputvalues[8].trim());
                            }
                        }
                        
                        // Add country to Masters
                        if(inputvalues[9]!=null && inputvalues[9].trim()!=UtilConstants.EMPTY_STRING && CareerTrackMasterID.get(inputvalues[9].trim())!=null){
                        ////////System.debug('9'+i);
                            Pyramid_SWB.Career_Track__c = CareerTrackMasterID.get(inputvalues[9].trim());
                        }
                        else{
                           myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, inputvalues[9]+UtilConstants.PAGE_MSG_22+CareerTrackMasterID.get(inputvalues[9].trim()));
                            ApexPages.addMessage(myMsg);
                            isPyramidUploadable = false;
                        }
                        
                        if(inputvalues[10]!=null && inputvalues[10].trim()!=UtilConstants.EMPTY_STRING && EconomicProfileMasterID.get(inputvalues[10].trim())!=null){
                        ////////System.debug('10'+i);
                            Pyramid_SWB.Economic_Profile__c = EconomicProfileMasterID.get(inputvalues[10].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_23 );
                            ApexPages.addMessage(myMsg);
                            isPyramidUploadable = false;
                        }
                        if(inputvalues[11]!=null && inputvalues[11].trim()!=UtilConstants.EMPTY_STRING && RateTypeMasterID.get(inputvalues[11].trim())!=null){
                        ////////System.debug('11'+i);
                            Pyramid_SWB.Rate_Type__c = RateTypeMasterID.get(inputvalues[11].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_24 );
                            ApexPages.addMessage(myMsg);
                            isPyramidUploadable = false;
                        }
                        
                        if(inputvalues[12]!=null && inputvalues[12].trim()!=UtilConstants.EMPTY_STRING && LoadTypeMasterID.get(inputvalues[12].trim())!=null){
                        ////////System.debug('12'+i);
                            Pyramid_SWB.Load_Type__c = LoadTypeMasterID.get(inputvalues[12].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_25 );
                            ApexPages.addMessage(myMsg);
                            isPyramidUploadable = false;
                        }
                        
                        if(inputvalues[13]!=null && inputvalues[13].trim()!=UtilConstants.EMPTY_STRING && RoleMasterID.get(inputvalues[13].trim())!=null){
                        ////////System.debug('13'+i);
                            Pyramid_SWB.Role_Master__c = RoleMasterID.get(inputvalues[13].trim());
                        }
                        /**
                        else{
                            
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_26 );
                            ApexPages.addMessage(myMsg);
                            isPyramidUploadable = false;
                        }
                        **/
                        if(inputvalues[14]!=null && inputvalues[14].trim()!=UtilConstants.EMPTY_STRING && CareerLevelMasterID.get(inputvalues[14].trim())!=null){
                        ////////System.debug('14'+i);
                            Pyramid_SWB.Career_Level__c= CareerLevelMasterID.get(inputvalues[14].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_27 );
                            ApexPages.addMessage(myMsg);
                            isPyramidUploadable = false;
                        }
                        
                        if(inputvalues[15]!=null && inputvalues[15].trim()!=UtilConstants.EMPTY_STRING && BillCodeMasterID.get(inputvalues[15].trim())!=null){
                        ////////System.debug('15'+i);
                            Pyramid_SWB.Bill_Code__c= BillCodeMasterID.get(inputvalues[15].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_28);
                            ApexPages.addMessage(myMsg);
                            isPyramidUploadable = false;
                        }
                        
                    }
                    Pyramid_SWB.Opportunity__c=OppId;
                    ////////System.debug(PyramidfieldMap);
                    for(integer key : PyramidfieldMap.KeySet()){
                        if(inputValues.size()>key && inputValues[key].trim() != UtilConstants.EMPTY_STRING){
                        inputValues[key] = inputValues[key].replace(UtilConstants.COMMA,UtilConstants.EMPTY_STRING);
                        Schema.SObjectField field = pyramidFields.get(PyramidfieldMap.get(key));
                        Pyramid_SWB.put(PyramidfieldMap.get(key),decimal.valueOf(inputValues[key].trim()));
                    }
                }
                
                ////////System.debug('service - offering - sub service - phase '+Pyramid_SWB.Service__c +' '+Pyramid_SWB.Service_Group__c+' '+Pyramid_SWB.Sub_Service_Group__c+' '+Pyramid_SWB.phase__c);
                if(Pyramid_SWB.Service__c !=null && Pyramid_SWB.Service_Group__c !=null && Pyramid_SWB.Sub_Service_Group__c !=null && Pyramid_SWB.phase__c !=null && isPyramidUploadable){
                listPyramid_SWB.add(Pyramid_SWB);
                }
            }
                
                }
                
        }
        listPyramid_Del = [select id from FTE_Details__c where Opportunity__c=:OppId Limit 5000];
        ////////System.debug('before insert'+listPyramid_SWB);
        /*if(listPyramid_SWB.size()>0){
        
            database.insert(listPyramid_SWB);
        }*/
        ////////System.debug('after insert'+listPyramid_SWB);
        }
        catch(Exception e){
        isPyramidUploadable = false;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,UtilConstants.PAGE_MSG_29+e);//Same old drama 
        ApexPages.addMessage(myMsg);
        ////////System.debug('Exception '+e);
        }
    }        
    /*
    *Method: Insert Payroll Details
    */
    public void insertPayrollSWB(){
        System.debug('in Insert Payroll method');
        
ApexPages.Message myMsg;
        try{
        isPayrollUploadable=true;
        String key2;
            Map<String, Schema.SObjectField> payrollFields = Schema.SObjectType.Payroll__c.fields.getMap();
            for(integer i=3; i<split_Payroll_SWB.size() && isPayrollUploadable; i++){
                String[] inputvalues = new String[]{};
                
                if(split_Payroll_SWB[i].trim()!=UtilConstants.EMPTY_STRING){
                
                inputvalues = split_Payroll_SWB[i].split('»');
                Payroll_SWB = new Payroll__c();
                if(inputvalues.size() != 0)
                {
                    integer numberofcolumns = inputvalues.size();
                    if(numberofcolumns >= 15){
          if((inputvalues[4]!=null && inputvalues[4].trim()!=UtilConstants.EMPTY_STRING) && (inputvalues[5]!=null && inputvalues[5].trim()!=UtilConstants.EMPTY_STRING))
            {
            key2 = inputvalues[4]+';'+inputvalues[5];
            }
            
                        System.debug('loop1'+i);
                        Payroll_SWB.opportunity__c=OppId;
                        if(inputvalues[1]!=null && inputvalues[1].trim()!=UtilConstants.EMPTY_STRING){
                        System.debug('1');
                            Payroll_SWB.Activity_Description__c = inputvalues[1];
                        }
                        
                        if(inputvalues[2]!=null && inputvalues[2].trim()!=UtilConstants.EMPTY_STRING){
                        System.debug('2');
                            Payroll_SWB.Phase__c = inputvalues[2];
                        }
                        
                        if(inputvalues[3]!=null && inputvalues[3].trim()!=UtilConstants.EMPTY_STRING){
                        System.debug('3'+i);
                            Payroll_SWB.Service_Group__c = inputvalues[3];
                        }
                        
                        if(inputvalues[4]!=null && inputvalues[4].trim()!=UtilConstants.EMPTY_STRING && null!=SolutionScopeID.get(inputvalues[4].trim())){
                        System.debug('4'+i);
                            Payroll_SWB.Sub_Service_Group__c = SolutionScopeID.get(inputvalues[4].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilCOnstants.PAGE_MSG_30);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        if(inputvalues[5]!=null && inputvalues[5].trim()!=UtilConstants.EMPTY_STRING){
                        System.debug('5'+i);
                            Payroll_SWB.Service__c = ServiceID.get(key2);
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilCOnstants.PAGE_MSG_31);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        if(inputvalues[6]!=null && inputvalues[6].trim()!=UtilConstants.EMPTY_STRING  && ServiceComponentID.get(inputvalues[6].trim())!=null){
                        System.debug('6'+i);
                            Payroll_SWB.Service_Component__c = ServiceComponentID.get(inputvalues[6].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_32);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        if(inputvalues[7]!=null && inputvalues[7].trim()!=UtilConstants.EMPTY_STRING && ResourceGroupMasterID.get(inputvalues[7].trim())!=null){
                        System.debug('7'+i);
                            Payroll_SWB.Resource_Group__c = ResourceGroupMasterID.get(inputvalues[7].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_33);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        if(inputvalues[8]!=null && inputvalues[8].trim()!=UtilConstants.EMPTY_STRING){
                            if(CountryMasterID.get(inputvalues[8].trim())!=null){
                                System.debug('8'+i);
                                countryNames.add(inputvalues[4].trim()+';'+inputvalues[5].trim()+';'+inputvalues[8].trim());
                                Payroll_SWB.Country_Master__c= CountryMasterID.get(inputvalues[8].trim());
                            }
                            else{
                                Payroll_SWB.Country_Master__c= addNewCountryMaster(inputvalues[8].trim());
                            }
                        }
                        
                        if(inputvalues[9]!=null && inputvalues[9].trim()!=UtilConstants.EMPTY_STRING && CareerTrackMasterID.get(inputvalues[9].trim())!=null){
                        System.debug('9'+i);
                            Payroll_SWB.Career_Track__c = CareerTrackMasterID.get(inputvalues[9].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, inputvalues[9]+UtilConstants.PAGE_MSG_34+CareerTrackMasterID.get(inputvalues[9].trim()));
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        if(inputvalues[10]!=null && inputvalues[10].trim()!=UtilConstants.EMPTY_STRING && EconomicProfileMasterID.get(inputvalues[10].trim())!=null){
                        System.debug('10'+i);
                            Payroll_SWB.Economic_Profile__c = EconomicProfileMasterID.get(inputvalues[10].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_35);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        if(inputvalues[11]!=null && inputvalues[11].trim()!=UtilConstants.EMPTY_STRING && RateTypeMasterID.get(inputvalues[11].trim())!=null){
                        System.debug('11'+i);
                            Payroll_SWB.Rate_Type__c = RateTypeMasterID.get(inputvalues[11].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_36);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        
                        if(inputvalues[12]!=null && inputvalues[12].trim()!=UtilConstants.EMPTY_STRING && LoadTypeMasterID.get(inputvalues[12].trim())!=null){
                        System.debug('12'+i);
                            Payroll_SWB.Load_Type__c = LoadTypeMasterID.get(inputvalues[12].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_37);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        if(inputvalues[13]!=null && inputvalues[13].trim()!=UtilConstants.EMPTY_STRING && RoleMasterID.get(inputvalues[13].trim())!=null){
                        System.debug('13'+i);
                            Payroll_SWB.Role__c = RoleMasterID.get(inputvalues[13].trim());
                        }
                        /**
                        else{
                            
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_38 );
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        **/
                        if(inputvalues[14]!=null && inputvalues[14].trim()!=UtilConstants.EMPTY_STRING && CareerLevelMasterID.get(inputvalues[14].trim())!=null){
                        System.debug('14'+i);
                            Payroll_SWB.Career_Level__c= CareerLevelMasterID.get(inputvalues[14].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_39);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                        if(inputvalues[15]!=null && inputvalues[15].trim()!=UtilConstants.EMPTY_STRING && BillCodeMasterID.get(inputvalues[15].trim())!=null){
                        System.debug('15'+i);
                            Payroll_SWB.Bill_Code__c= BillCodeMasterID.get(inputvalues[15].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_40);
                            ApexPages.addMessage(myMsg);
                            isPayrollUploadable = false;
                        }
                    }
                    ////////System.debug(PayrollfieldMap);
                    for(integer key : PayrollfieldMap.KeySet()){
                        if(inputValues.size()>key && inputValues[key].trim() != UtilConstants.EMPTY_STRING){
                        inputValues[key] = inputValues[key].replace(UtilConstants.COMMA,UtilConstants.EMPTY_STRING);
                        Schema.SObjectField field = payrollFields.get(PayrollfieldMap.get(key));
                        Payroll_SWB.put(PayrollfieldMap.get(key),decimal.valueOf(inputValues[key].trim()));
                    }
                }
                System.debug('Payroll_SWB.Service__c '+Payroll_SWB.Service__c);
                System.debug('Payroll_SWB.Service_Group__c'+Payroll_SWB.Service_Group__c);
                System.debug('Payroll_SWB.Sub_Service_Group__c '+Payroll_SWB.Sub_Service_Group__c);
                System.debug('Payroll_SWB.Phases__c '+Payroll_SWB.Phase__c );
                System.debug('isOtherCostUploadable '+isPayrollUploadable);
                System.debug('mai kya karu???'+Payroll_SWB.id);
                if(Payroll_SWB.Service__c !=null && Payroll_SWB.Service_Group__c !=null && Payroll_SWB.Sub_Service_Group__c !=null && Payroll_SWB.phase__c !=null && isPayrollUploadable){
                listPayroll_SWB.add(Payroll_SWB);
                //isPayrollUploadable = false;
            }
                
                }
                
        }
        //listPayroll_Del = [select id from Payroll__c where Opportunity__c=:OppId Limit 5000];
        listPayroll_Del = MasterQueries.queryPayroll(OppId);
        ////////System.debug('listPayroll_SWB~~~~'+listPayroll_SWB);
        ////////System.debug('listPayroll_SWB~~~~'+listPayroll_SWB.size());
        
        
        }
        /*if(listPayroll_SWB.size()>0){
            database.insert(listPayroll_SWB);
            
            }*/
        }
        catch(Exception e){
        isPayrollUploadable = false;
        myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,UtilConstants.PAGE_MSG_41+e);//Same old drama 
        ApexPages.addMessage(myMsg);
        ////////System.debug('Exception '+e);
        }
    }
    
    
    /*
    *Method: Insert Other Cost Details
    */
     public void insertOtherCostSWB(){
        ////////System.debug('in Insert Other Cost method');
        ApexPages.Message myMsg;
        try{
            isOtherCostUploadable = true;
            String key3;
            Map<String, Schema.SObjectField> othercostFields = Schema.SObjectType.Other_Cost_Details__c.fields.getMap();
            for(integer i=3; i<split_Other_Cost_SWB.size() && isOtherCostUploadable; i++){
                String[] inputvalues = new String[]{};
                
                if(split_Other_Cost_SWB[i].trim()!=UtilConstants.EMPTY_STRING){
                
                inputvalues = split_Other_Cost_SWB[i].split('»');
                Other_Cost_SWB = new Other_Cost_Details__c();
                if(inputvalues.size() != 0)
                {
                    integer numberofcolumns = inputvalues.size();
                    if(numberofcolumns >= 15){
                    
                    if((inputvalues[3]!=null && inputvalues[3].trim()!=UtilConstants.EMPTY_STRING) && (inputvalues[4]!=null && inputvalues[4].trim()!=UtilConstants.EMPTY_STRING))
            {
            key3 = inputvalues[3]+';'+inputvalues[4];
            }
                        ////////System.debug('loop1'+i);
                        Other_Cost_SWB.opportunity__c=OppId;
                        if(inputvalues[0]!=null && inputvalues[0].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('0');
                            Other_Cost_SWB.name = inputvalues[0];
                        }
                        
                        if(inputvalues[1]!=null && inputvalues[1].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('2');
                            Other_Cost_SWB.Phases__c = inputvalues[1];
                        }
                        
                        if(inputvalues[2]!=null && inputvalues[2].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('2'+i);
                            Other_Cost_SWB.Service_Group__c = inputvalues[2];
                            
                        }
                        ////System.debug('Ye lo '+inputvalues[0]+ ' !!! ' +inputvalues[1]+ ' !!! ' +inputvalues[2]+ ' !!! '+inputvalues[3]+' !!! '+SolutionScopeID.get(inputvalues[3].trim()));
                        if(inputvalues[3]!=null && inputvalues[3].trim()!=UtilConstants.EMPTY_STRING && null!=SolutionScopeID.get(inputvalues[3].trim())){
                            Other_Cost_SWB.Sub_Service_Group__c = SolutionScopeID.get(inputvalues[3].trim());
                            Other_Cost_SWB.Is_IO_Other_Cost__c = true;
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,UtilConstants.PAGE_MSG_42 );
                            ApexPages.addMessage(myMsg);
                            isOtherCostUploadable = false;
                        }
                        if(inputvalues[4]!=null && inputvalues[4].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('4'+i);
                            Other_Cost_SWB.Service__c = ServiceID.get(key3);
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_43);
                            ApexPages.addMessage(myMsg);
                            isOtherCostUploadable = false;
                        }
                        if(inputvalues[5]!=null && inputvalues[5].trim()!=UtilConstants.EMPTY_STRING  && ServiceComponentID.get(inputvalues[5].trim())!=null){
                        ////////System.debug('5'+i);
                            Other_Cost_SWB.Service_Component__c = ServiceComponentID.get(inputvalues[5].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_44);
                            ApexPages.addMessage(myMsg);
                            isOtherCostUploadable = false;
                        }
                        if(inputvalues[6]!=null && inputvalues[6].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('6'+i);
                            Other_Cost_SWB.ActivityDescription__c = inputvalues[6];
                        }
                        
                        if(inputvalues[7]!=null && inputvalues[7].trim()!=UtilConstants.EMPTY_STRING  && ResourceGroupMasterID.get(inputvalues[7].trim())!=null){
                        ////////System.debug('kya bhai koi is if me aa gaya kya!'+i);
                            Other_Cost_SWB.ResourceGroup__c = ResourceGroupMasterID.get(inputvalues[7].trim());

                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_45);
                            ApexPages.addMessage(myMsg);
                            isOtherCostUploadable = false;
                        }
                        if(inputvalues[8]!=null && inputvalues[8].trim()!=UtilConstants.EMPTY_STRING){
                            if(CountryMasterID.get(inputvalues[8].trim())!=null){
                                countryNames.add(inputvalues[3].trim()+';'+inputvalues[4].trim()+';'+inputvalues[8].trim());
                                ////////System.debug('8'+i);
                                Other_Cost_SWB.Country__c = CountryMasterID.get(inputvalues[8].trim());
                            }
                            else{
                                Other_Cost_SWB.Country__c = addNewCountryMaster(inputvalues[8].trim());
                            }
                        }
                        
                        if(inputvalues[9]!=null && inputvalues[9].trim()!=UtilConstants.EMPTY_STRING&& CareerTrackMasterID.get(inputvalues[9].trim())!=null){
                       ////////System.debug('kya bhai koi is if me aa gaya kya!'+i);
                            Other_Cost_SWB.CareerTrack__c = CareerTrackMasterID.get(inputvalues[9].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, inputvalues[9]+UtilConstants.PAGE_MSG_46+CareerTrackMasterID.get(inputvalues[9].trim()));
                            ApexPages.addMessage(myMsg);
                            isOtherCostUploadable = false;
                        }
                        if(inputvalues[10]!=null && inputvalues[10].trim()!=UtilConstants.EMPTY_STRING && EconomicProfileMasterID.get(inputvalues[10].trim())!=null){
                        ////////System.debug('10'+i);
                            Other_Cost_SWB.EconomicProfile__c = EconomicProfileMasterID.get(inputvalues[10].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_47);
                            ApexPages.addMessage(myMsg);
                            isOtherCostUploadable = false;
                        }
                        
                        if(inputvalues[11]!=null && inputvalues[11].trim()!=UtilConstants.EMPTY_STRING && RateTypeMasterID.get(inputvalues[11].trim())!=null){
                        ////////System.debug('11'+i);
                            Other_Cost_SWB.RateType__c = RateTypeMasterID.get(inputvalues[11].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_48);
                            ApexPages.addMessage(myMsg);
                            isOtherCostUploadable = false;
                        }
                        if(inputvalues[12]!=null && inputvalues[12].trim()!=UtilConstants.EMPTY_STRING && LoadTypeMasterID.get(inputvalues[12].trim())!=null){
                        ////////System.debug('12'+i);
                            Other_Cost_SWB.LoadType__c = LoadTypeMasterID.get(inputvalues[12].trim());

                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_49);
                            ApexPages.addMessage(myMsg);
                            isOtherCostUploadable = false;
                        }
                        if(inputvalues[13]!=null && inputvalues[13].trim()!=UtilConstants.EMPTY_STRING && CareerLevelMasterID.get(inputvalues[13].trim())!=null){
                        ////////System.debug('13'+i);
                            Other_Cost_SWB.Career_Level__c= CareerLevelMasterID.get(inputvalues[13].trim());
                        }

                    }
                    
                    for(integer key : OtherCostfieldMap.KeySet()){
                        if(inputValues.size()>key && inputValues[key].trim() != UtilConstants.EMPTY_STRING){
                        inputValues[key] = inputValues[key].replace(UtilConstants.COMMA,UtilConstants.EMPTY_STRING);
                        Schema.SObjectField field = othercostFields.get(OtherCostfieldMap.get(key));
                        Other_Cost_SWB.put(OtherCostfieldMap.get(key),decimal.valueOf(inputValues[key].trim()));
                    }
                }
                ////////System.debug('Other_Cost_SWB.Service__c '+Other_Cost_SWB.Service__c);
                ////////System.debug('Other_Cost_SWB.Service_Group__c'+Other_Cost_SWB.Service_Group__c);
                ////////System.debug('Other_Cost_SWB.Sub_Service_Group__c '+Other_Cost_SWB.Sub_Service_Group__c);
                ////////System.debug('Other_Cost_SWB.Phases__c '+Other_Cost_SWB.Phases__c );
                ////////System.debug('isOtherCostUploadable '+isOtherCostUploadable );
                if(Other_Cost_SWB.Service__c !=null && Other_Cost_SWB.Service_Group__c !=null && Other_Cost_SWB.Sub_Service_Group__c !=null && Other_Cost_SWB.Phases__c !=null && isOtherCostUploadable!=false){
                    listOther_Cost_SWB.add(Other_Cost_SWB);
                }
            }
                
                }
                
        }
        listOther_Cost_Del = [select id from Other_Cost_Details__c where Opportunity__c =:OppId Limit 5000];
        /*if(listOther_Cost_SWB.size()>0){
            database.insert(listOther_Cost_SWB);
        }*/
        

        }
        catch(Exception e){
            isOtherCostUploadable = false;
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,UtilConstants.PAGE_MSG_50+e);//Same old drama 
            ApexPages.addMessage(myMsg);
            ////////System.debug('Exception '+e);
        }
    }
    
    
    
    /*
    *Method: Insert Volume Details
    */
    public void insertVolumeSWB(){
        ////System.debug('in Insert Volume method'+ServiceID);
        ApexPages.Message myMsg;
        try{
        isVolumeUploadable= true;
        String key4;
            Map<String, Schema.SObjectField> volumeFields = Schema.SObjectType.Volume_Detail__c.fields.getMap();
            for(integer i=3; i<split_Volume_SWB.size() && isVolumeUploadable; i++){
                String[] inputvalues = new String[]{};
                
                if(split_Volume_SWB[i].trim()!=UtilConstants.EMPTY_STRING){
                
                inputvalues = split_Volume_SWB[i].split('»');
                Volume_SWB = new Volume_Detail__c();
                if(inputvalues.size() != 0)
                {
                    integer numberofcolumns = inputvalues.size();
                    if(numberofcolumns >= 6){
                    
                    if((inputvalues[2]!=null && inputvalues[2].trim()!=UtilConstants.EMPTY_STRING) && (inputvalues[3]!=null && inputvalues[3].trim()!=UtilConstants.EMPTY_STRING))
            {
            key4 = inputvalues[2]+';'+inputvalues[3];
            }
                        ////////System.debug('loop1'+i);
                        Volume_SWB.opportunity__c=OppId;
                        if(inputvalues[0]!=null && inputvalues[0].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('0');
                            Volume_SWB.Phase__c = inputvalues[0];
                        }
                        
                        if(inputvalues[1]!=null && inputvalues[1].trim()!=UtilConstants.EMPTY_STRING){
                        ////////System.debug('2');
                            Volume_SWB.Service_Group__c = inputvalues[1];
                            
                        }

                        if(inputvalues[2]!=null && inputvalues[2].trim()!=UtilConstants.EMPTY_STRING && null!=SolutionScopeID.get(inputvalues[2].trim())){

                            Volume_SWB.Sub_Service_Group__c = SolutionScopeID.get(inputvalues[2].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_51);
                            ApexPages.addMessage(myMsg);
                            isVolumeUploadable = false;
                            ////System.debug('isVolumeUploadable scope'+isVolumeUploadable);
                        }
                        ////System.debug('isVolumeUploadable service'+inputvalues[3]);
                        ////System.debug('key4'+key4);
                        if(inputvalues[3]!=null && inputvalues[3].trim()!=UtilConstants.EMPTY_STRING){// && null!=ServiceID.get(key4)
                            
                            Volume_SWB.Service__c = ServiceID.get(key4);
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_52);
                            ApexPages.addMessage(myMsg);
                            isVolumeUploadable = false;
                            ////System.debug('isVolumeUploadable service'+isVolumeUploadable);
                        }
                        
                        if(inputvalues[4]!=null && inputvalues[4].trim()!=UtilConstants.EMPTY_STRING && ServiceComponentID.get(inputvalues[4].trim())!=null){
                        
                            Volume_SWB.Service_Component__c = ServiceComponentID.get(inputvalues[4].trim());
                        }
                        else{
                            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_53);
                            ApexPages.addMessage(myMsg);
                            isVolumeUploadable = false;
                            ////System.debug('isVolumeUploadable comp'+isVolumeUploadable);
                        }
                        if(inputvalues[5]!=null && inputvalues[5].trim()!=UtilConstants.EMPTY_STRING  && ServiceComponentID.get(inputvalues[5].trim())!=null){
                        ////////System.debug('5'+i);
                            //Volume_SWB.description = ServiceComponentID.get(inputvalues[5].trim());
                        }
                        
                    }
                    
                    for(integer key : VolumefieldMap.KeySet()){
                        if(inputValues.size()>key && inputValues[key].trim() != UtilConstants.EMPTY_STRING){
                        inputValues[key] = inputValues[key].replace(UtilConstants.COMMA,UtilConstants.EMPTY_STRING);
                        Schema.SObjectField field = volumeFields.get(VolumefieldMap.get(key));
                        Volume_SWB.put(VolumefieldMap.get(key),decimal.valueOf(inputValues[key].trim()));
                    }
                }
                ////////System.debug('Volume_SWB.Sub_Service_Group__c '+i+': '+Volume_SWB.Sub_Service_Group__c);
                ////////System.debug(' Volume_SWB.Service__c '+i+': '+ Volume_SWB.Service__c);
                ////////System.debug('Volume_SWB.Service_Group__c '+i+': '+Volume_SWB.Service_Group__c);
                ////////System.debug('Volume_SWB.phase__c '+i+': '+Volume_SWB.phase__c);
                if(Volume_SWB.Sub_Service_Group__c!=null && Volume_SWB.Service__c !=null && Volume_SWB.Service_Group__c!=null && Volume_SWB.phase__c!=null && isVolumeUploadable){
                    listVolume_SWB.add(Volume_SWB);
                }
            }
                
                }
                
        }
        listVolume_Del = [select id from Volume_Detail__c where Opportunity__c=:OppId Limit 5000];
        ////////System.debug('listVolume_SWB o|o'+listVolume_SWB);
        /*if(listVolume_SWB.size()>0){
            database.insert(listVolume_SWB);
        }*/
        ////////System.debug('after insertlistVolume_SWB o|o'+listVolume_SWB);
        }
        catch(Exception e){
            isVolumeUploadable = false;
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,UtilConstants.PAGE_MSG_54+e);//Same old drama 
            ApexPages.addMessage(myMsg);
            ////////System.debug('Exception '+e);
        }
    }
    /**
    @Author IO Developer
    @name insertAttachment
    @CreateDate 01/04/2015
    @Description This is the method for inserting Attachment for class IOCostModelUpload.
    @Version <1.0>
    @reference 
    */
    public void insertAttachment()
    {
        try{
            IOexcel = new attachment();
            IOexcel.name = dropFileName;
            IOexcel.body = fileBody;
            IOexcel.Description = Description;
            IOexcel.parentId=Oppid;

            listIOsheets_del = new List<attachment>();
            listIOsheets_del = [select id from attachment where parentId=:OppId Limit 5000];
            //database.insert(IOexcel);
            //IOexcel = null;
            //fileBody=null;
            //dropFileName = null;
        }
        catch(exception e){
            e.getmessage();
        }
    
    }
    /**
    @Author IO Developer
    @name deletePreviousRecords
    @CreateDate 01/04/2015
    @Description This is the method for deleting the previous records for the class IOCostModelUpload
    @Version <1.0>
    @reference 
    */
    public void deletePreviousRecords(){
        try{
            database.delete(listPyramid_Del);
            database.delete(listPayroll_Del);
            database.delete(listOther_Cost_Del);
            database.delete(listVolume_Del);
            database.delete(listIOsheets_del);
             
        }
        catch(Exception w){
            w.getmessage();
        }
    }
    /**
    @Author IO Developer
    @name toOpportunity
    @CreateDate 01/04/2015
    @Description This is the Page Reference method for IOCostModelUpload class.
    @Version <1.0>
    @reference 
    */
    public PageReference toOpportunity(){
    try{
        Pagereference mypage= new PageReference(UtilConstants.SLASH+OppId);
        mypage.setRedirect(true);
        return mypage;
       }
       Catch(Exception e)
       {
          //////System.debug('E==='+e);
          e.getmessage();
       }
       return null;
    }
    
   
     /**
    @Author Jayashree
    @name insertDeliveryLoc
    @CreateDate 21/10/2015
    @Description This is to insert Delivery Location
    @Version <1.0>
    @reference 
    */
    
    public void insertDeliveryLoc(){
        try{
            ////System.debug('******'+countryNames);
            for(String count : countryNames){
                String[] results = count.split(';');
                ////System.debug('******'+results[0].trim()+';'+results[1].trim());
                oppDevLoc = new Opportunity_Delivery_Location__c();
                oppDevLoc.Offering_Service__c = ServiceID.get(results[0].trim()+';'+results[1].trim());
                oppDevLoc.Delivery_Location__c = deliveryLocID.get(results[2].trim());
                oppDevLocList.add(oppDevLoc);
            }
            listIOdelLocs_del = [select id from Opportunity_Delivery_Location__c 
                               where Offering_Service__r.Solutionscope__r.Opportunity__c=:OppId 
                               and Offering_Service__r.Solutionscope__r.Service_Group__c =: UtilConstants.IO Limit 5000]; 
        }
        catch(Exception e){
            ////System.debug('Exception'+'*******'+e.getLineNumber());
        }                         
    }
    
  
 }