/*
Author : Sanjay Kumar Das   
Story  :  Story-0020 / MOB_005 
Description : As a Mobilization Lead, I should be able to view Wave planning home page (which has summary of waves)

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public with sharing class SummaryController {
    public String newid{get;set;}
    public List<ANodes> hierarchy;
    public List<Allrows> allRowLst;
  //  public Boolean flagSave{get;set;}
  //  public Boolean flagEdit{get;set;}
    public Boolean isWaveVersionActive{get; set;}

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
    Inner class Name: Allrows
    Description: The Innner class which display the information about High Level Mobilization Plans rowwise
    Paramenters: NA
    Return Value: NA
    *******************************/
    public class Allrows
    {
        public String highLevelMobPlan {get;set;}
        public Deal_Location__c dealLoc {get; set;}
        public Wave_Planning__c wavePlanning{get; set;}
        public Date goLiveDate{get; set;}
        public Date revisedGoLive{get; set;}
        public String proc{get; set;}
        public Decimal noOfFTE {get; set;}
    } 
    
    /******************************
    Method Name: getAllRowLst
    Description: Getter Method for all rows which will return back for view in Inline page
    Paramenters: NA
    Return Value: List<Allrows> 
    *******************************/
    public List<Allrows> getAllRowLst ()
        {
            return allRowLst ;
        } 
    /******************************
    Method Name: SummaryController
    Description: Constructor for Initialization
    Paramenters: controller
    Return Value: NA
    *******************************/
    
    public SummaryController(ApexPages.StandardController controller) {
        newid=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        hierarchy = new List<ANodes>();
        allRowLst = new List<Allrows>();
  //      flagSave = false;             
  //      flagEdit = true;
        List<Wave_Plan_Version__c> dtlist =[Select Id,Name,Display_tracking_message__c,Active__c from Wave_Plan_Version__c where id=:newid];   
        
        if(dtlist != null){
        if(dtlist[0].Display_tracking_message__c=='Tracking is On' || dtlist[0].Active__c==false){
            isWaveVersionActive=false;    
          }else{
            isWaveVersionActive=true;
          }
       }   
    }
 
   /******************************
    Method Name: getHierarchy
    Description: Getter Method for Whole Heirarchy which will return back for view in Inline page
    Paramenters: NA
    Return Value: List<ANodes> 
    *******************************/
    public List<ANodes> getHierarchy ()
    {
        return hierarchy ;
    } 

   /**********************************************
    Method Name: getMainNodes
    Description: This method is used to create the tree structure for the deal summary. 
    Paramenters: NA
    Return Value:  List<ANodes>
    ***********************************************/    
    Public List<ANodes> getMainNodes()
    {
        List<Wave_Plan_Version__c> dtlist =[Select Id,Name,Display_tracking_message__c from Wave_Plan_Version__c where id=:newid];   
        
        List<Deal_Location__c> locNodelist=new List<Deal_Location__c>();
        locNodelist=[Select Wave_Plan_Version__r.Id,  Name,Deal_Home_Location__r.Delivery_Location_Master__r.Name,Wave_Plan_Version__c,NewActive__c from Deal_Location__c where Wave_Plan_Version__c =:newid];
       
        List<Wave_Planning__c> waveNodelist=new List<Wave_Planning__c>();
        waveNodelist=[Select Deal_Location__r.Id, Name,Wave_Label__c,GO_Live_Date_del__c,Revised_Go_Live__c, Deal_Location__c,NewActive__c from Wave_Planning__c where Deal_Location__c =:locNodelist];
               
        List<Wave_Process__c> processList=new List<Wave_Process__c>();
        processList=[Select Wave_Planning__r.Id, Name,Go_Live_Date__c, Client_Specific_Process_Mapping__r.Name, Wave_Planning__c,Active__c,Number_of_Projected_FTEs__c from Wave_Process__c where  Wave_Planning__c =:waveNodelist]; 
         
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
                    hierarchy.add(an);
                }
        return hierarchy;
        
    }  
    
    /**********************************************
    Method Name: getAllRows
    Description: This method is used to create the tree structure for the deal summary. 
    Paramenters: List<ANodes>
    Return Value:  NA
    ***********************************************/ 
    public List<Allrows> getAllRows()
    {
        Set<String> aNodeSet = new Set<String>();
        Set<String> bNodeSet = new Set<String>();
        Set<String> cNodeSet = new Set<String>();
        Set<String> dNodeSet = new Set<String>();
        
        allRowLst = new List<Allrows>();
        
        List<ANodes> finalRecordsToDisplay = getMainNodes();
        Allrows allrowsObject = new Allrows();
        Allrows allrowsObject1 = new Allrows();
        
        for(ANodes a : finalRecordsToDisplay) {
            
            for(BNodes b: A.BNodes) {
                
                for(cnodes c: b.CNodes) {

                    if(c.Dnodes.size()>0){
                    
                    for(Wave_Process__c wp : c.Dnodes) {
                    
                        allrowsObject = new Allrows();
                        String aNodeString = a.deal.Name != null ? String.valueOf(a.deal.Name) : null;
                        if (!aNodeSet.contains(aNodeString)) {
                            allrowsObject.highLevelMobPlan = a.deal.Name;                            
                            aNodeSet.add(aNodeString);
                        } else {
                            allrowsObject.highLevelMobPlan = null;
                        }
                        
                        String bNodeString = b.deal.Deal_Home_Location__r.Delivery_Location_Master__r.Name != null ? String.valueOf(b.deal.Deal_Home_Location__r.Delivery_Location_Master__r.Name) : null;
                        bNodeString = aNodeString + bNodeString;
                        if (!bNodeSet.contains(bNodeString)) {
                            allrowsObject.dealLoc = b.deal;
                            
                            bNodeSet.add(bNodeString);
                        } else {
                            allrowsObject.dealLoc = null;
                        }
                        
                        String cNodeString = c.DealLocation.wave_Label__c != null && c.DealLocation.GO_Live_Date_del__c != null ? String.valueOf(c.DealLocation.wave_Label__c) + String.valueOf(c.DealLocation.GO_Live_Date_del__c) : null ;
                        cNodeString = bNodeString + cNodeString;
                        if (!cNodeSet.contains(cNodeString)) {
                            allrowsObject.wavePlanning = c.DealLocation;
                            allrowsObject.goLiveDate = c.DealLocation.GO_Live_Date_del__c;
                            allrowsObject.revisedGoLive = c.DealLocation.Revised_Go_Live__c;                                                 
                            cNodeSet.add(cNodeString);
                        } else {
                            allrowsObject.wavePlanning = null;
                            allrowsObject.goLiveDate = null; 
                            allrowsObject.revisedGoLive = null; 
                        }
                        
                        String dString1 = wp.Number_of_Projected_FTEs__c != null ? String.valueOf(wp.Number_of_Projected_FTEs__c) : null;
                        String dString2 = wp.Client_Specific_Process_Mapping__r.Name != null ? String.valueOf(wp.Client_Specific_Process_Mapping__r.Name) : null;
                        String dNodeString = String.valueOf(dString2);
                        dNodeString = cNodeString + dNodeString;
                        if (!dNodeSet.contains(dNodeString)) {
                            allrowsObject.proc =wp.Client_Specific_Process_Mapping__r.Name;
                            allrowsObject.noOfFTE = wp.Number_of_Projected_FTEs__c;

                            dNodeSet.add(dNodeString);
                        } else {
                            allrowsObject.proc =null;
                            allrowsObject.noOfFTE = null;
                        }
                       if(!(allrowsObject.dealLoc == null && allrowsObject.goLiveDate == null && allrowsObject.highLevelMobPlan ==null && allrowsObject.noOfFTE ==null && allrowsObject.proc ==null && allrowsObject.wavePlanning ==null)){
                                allRowLst.add(allrowsObject);
                          }
                    }
                   }
                   
                  else{
                        allrowsObject1 = new Allrows();
                        String aNodeString = a.deal.Name != null ? String.valueOf(a.deal.Name) : null;
                        if (!aNodeSet.contains(aNodeString)) {
                            allrowsObject1.highLevelMobPlan = a.deal.Name;                            
                            aNodeSet.add(aNodeString);
                        } else {
                            allrowsObject1.highLevelMobPlan = null;
                        }
                        
                        String bNodeString = b.deal.Deal_Home_Location__r.Delivery_Location_Master__r.Name != null ? String.valueOf(b.deal.Deal_Home_Location__r.Delivery_Location_Master__r.Name) : null;
                        bNodeString = aNodeString + bNodeString;
                        if (!bNodeSet.contains(bNodeString)) {
                            allrowsObject1.dealLoc = b.deal;
                            bNodeSet.add(bNodeString);
                        } else {
                            allrowsObject1.dealLoc = null;
                        }
                        
                        String cNodeString = c.DealLocation.wave_Label__c != null && c.DealLocation.GO_Live_Date_del__c != null ? String.valueOf(c.DealLocation.wave_Label__c) + String.valueOf(c.DealLocation.GO_Live_Date_del__c) : null ;
                        cNodeString = bNodeString + cNodeString;
                        if (!cNodeSet.contains(cNodeString)) {
                            allrowsObject1.wavePlanning = c.DealLocation;
                            allrowsObject1.goLiveDate = c.DealLocation.GO_Live_Date_del__c;   
                            allrowsObject1.revisedGoLive = c.DealLocation.Revised_Go_Live__c;                                              
                            cNodeSet.add(cNodeString);
                        } else {
                            allrowsObject1.wavePlanning = null;
                            allrowsObject1.goLiveDate = null;
                            allrowsObject1.revisedGoLive = null;  
                        }
                        
                        if(!(allrowsObject1.dealLoc == null && allrowsObject1.goLiveDate == null && allrowsObject1.highLevelMobPlan ==null && allrowsObject1.wavePlanning ==null)){
                            allRowLst.add(allrowsObject1);
                        }
                        System.debug('allRowLst1::'+allRowLst);
                    }
                }
            }
        }
        return allRowLst;
    }
    
   /* public pagereference save(){
        system.debug('before save allRowLst::'+allRowLst);
        // Go Live Date
        List<Allrows> allRowRecs = new List<Allrows>();
        List<Wave_Planning__c> wavePlanningListToUpdate = new List<Wave_Planning__c>();
        Map<String,Wave_Planning__c> WavePlanningMap = new Map<String,Wave_Planning__c>();
        List<Wave_Planning__c> wavePlanninglist=[Select Deal_Location__r.Id, Name,Wave_Label__c,GO_Live_Date_del__c, 
                                            Deal_Location__c from Wave_Planning__c];
        for(Wave_Planning__c wpRec : wavePlanninglist){
            WavePlanningMap.put(wpRec.id , wpRec);
        }
        for(Allrows a : allRowLst){
            //List<Wave_Planning__c> wavePlanninglist=[Select Deal_Location__r.Id, Name,Wave_Label__c,GO_Live_Date_del__c, 
                                            //Deal_Location__c from Wave_Planning__c where id =: a.wavePlanning.Id];
            Wave_Planning__c wavePlanningRec = WavePlanningMap.get(a.wavePlanning.Id);  
            wavePlanningRec.GO_Live_Date_del__c = a.goLiveDate;
            wavePlanningListToUpdate.add(wavePlanningRec);
            system.debug('wavePlanningRec::'+wavePlanningRec);
        }
        
        // Process
        List<Wave_Process__c> waveProcessListToUpdate=new List<Wave_Process__c>();
        Map<String,Wave_Process__c> WaveProcessMap = new Map<String,Wave_Process__c>();
        List<Wave_Process__c> waveProcesslist=[Select Wave_Planning__r.Id, Name,Go_Live_Date__c, Client_Specific_Process_Mapping__r.Name, Wave_Planning__c,Active__c,
                    Number_of_Projected_FTEs__c from Wave_Process__c]; 
        for(Wave_Process__c wpRec : waveProcesslist){
            //WaveProcessMap.put(wpRec.id , wpRec);
            WaveProcessMap.put(wpRec.Client_Specific_Process_Mapping__r.Name + wpRec.Wave_Planning__r.Id, wpRec);
            system.debug('WaveProcessMap::'+WaveProcessMap);
        }
        for(Allrows a : allRowLst){
            Wave_Process__c waveProcessRec = WaveProcessMap.get(a.proc + a.wavePlanning.Id);    
            system.debug('waveProcessRec::'+waveProcessRec);
            if(waveProcessRec != null){
            waveProcessRec.Number_of_Projected_FTEs__c = a.noOfFTE;
            waveProcessListToUpdate.add(waveProcessRec);
            }
        }
        
       try{
       update wavePlanningListToUpdate;
       update waveProcessListToUpdate;
       system.debug('after save allRowLst::'+allRowLst);
        }catch(Exception e){
            system.debug('upsert error::'+e.getMessage());
        }
        flagSave = false;
        flagEdit = true;
       // return null;
       PageReference pageref=new PageReference('/'+newid);
       pageref.setRedirect(true);
       return pageref;
    }
    
    public void edit(){
        flagSave = true;             
        flagEdit = false;
    }
    
    public void cancel(){
        flagEdit = true; 
        flagSave = false;
    }*/
}