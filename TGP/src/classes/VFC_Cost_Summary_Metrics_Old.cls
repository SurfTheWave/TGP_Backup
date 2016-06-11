/*
Author : Shashank Shastri
Story  :   
Description :BPOSE Excel Sheet Upload.
Updated by          Story no.                Update Date        Update details
------------      -----------------        --------------    -------------------------------------------------------------
Shashank Shastri                               5/15/2013          Release 1.6
        
*/
public class VFC_Cost_Summary_Metrics_Old {
    //Summary Getter and Setters
    public static boolean isIncludeInBenchmark = false;
    public String costContingMob {get; set;}
    public String costContingYesr1 {get; set;}
    public String costContingYesr2 {get; set;}
    public String costContingYesr3 {get; set;}
    public String costContingYesr4 {get; set;}
    public String costContingYesr5 {get; set;}
    public String costContingYesr6 {get; set;}
    public String costContingYesr7 {get; set;}
    public String costContingYesr8 {get; set;}
    public String costContingYesr9 {get; set;}
    public String costContingYesr10 {get; set;}
    public String costContingYesrTot {get; set;}
    

    public String plusColaMob {get; set;}
    public String plusColaYear1 {get; set;}
    public String plusColaYear2 {get; set;}
    public String plusColaYear3 {get; set;}
    public String plusColaYear4 {get; set;}
    public String plusColaYear5 {get; set;}
    public String plusColaYear6 {get; set;}
    public String plusColaYear7 {get; set;}
    public String plusColaYear8 {get; set;}
    public String plusColaYear9 {get; set;}
    public String plusColaYear10 {get; set;}
    public String plusColaYearTot {get; set;}
     
    public String plusFxContgMob {get; set;}
    public String plusFxContgYear1 {get; set;}
    public String plusFxContgYear2 {get; set;}
    public String plusFxContgYear3 {get; set;}
    public String plusFxContgYear4 {get; set;}
    public String plusFxContgYear5 {get; set;}
    public String plusFxContgYear6 {get; set;}
    public String plusFxContgYear7 {get; set;}
    public String plusFxContgYear8 {get; set;}
    public String plusFxContgYear9 {get; set;}
    public String plusFxContgYear10 {get; set;}
    public String plusFxContgYearTot {get; set;}
    
    public String capitalMob {get; set;}
    public String capitalYear1 {get; set;}
    public String capitalYear2 {get; set;}
    public String capitalYear3 {get; set;}
    public String capitalYear4 {get; set;}
    public String capitalYear5 {get; set;}
    public String capitalYear6 {get; set;}
    public String capitalYear7 {get; set;}
    public String capitalYear8 {get; set;}
    public String capitalYear9 {get; set;}
    public String capitalYear10 {get; set;}
    public String capitalYearTot {get; set;}
    
    public String indicativeMob {get; set;}
    public String indicativeYear1 {get; set;}
    public String indicativeYear2 {get; set;}
    public String indicativeYear3 {get; set;}
    public String indicativeYear4 {get; set;}
    public String indicativeYear5 {get; set;}
    public String indicativeYear6 {get; set;}
    public String indicativeYear7 {get; set;}
    public String indicativeYear8 {get; set;}
    public String indicativeYear9 {get; set;}
    public String indicativeYear10 {get; set;}
    public String indicativeYearTot {get; set;}          
    
    public String totalCost1 {get; set;}
    public String totalCost2 {get; set;}
    public String totalCost3 {get; set;}
    public String totalCost4 {get; set;}
    public String totalCost5 {get; set;}
    public String totalCost6 {get; set;}
    public String totalCost7 {get; set;}
    public String totalCost8 {get; set;}
    public String totalCost9 {get; set;}
    public String totalCost10 {get; set;}
    public String totalCost11 {get; set;}
    public String totalCost12 {get; set;}
    public String totalCost13 {get; set;}
    public String totalCost14 {get; set;}
    public String totalCost15 {get; set;}
    public String totalCost16 {get; set;}
    public String totalCost17{get; set;}
    public String totalCost18 {get; set;}
    public String totalCost19 {get; set;}
    public String totalCost20{get; set;}
    public String totalCost21 {get; set;}
    public String totalCost22 {get; set;}
    public String totalCost23 {get; set;}
    public String totalCost24{get; set;}
    public String totalCost25 {get; set;}
    public String totalCost26 {get; set;}
    public String totalCost27 {get; set;}
    public String totalCost28{get; set;}
    public String totalCost29 {get; set;}
    public String totalCost30 {get; set;}
    public String totalCost31 {get; set;}
    public String totalCost32{get; set;}
    public String totalCost33 {get; set;}
    public String totalCost34 {get; set;}
    public String totalCost35 {get; set;}
    public String sheetThrowingException= '';
    public decimal Sum_Total_Cost = 0;
    public decimal Sum_Total_FTE = 0;
    public decimal sum_Lang = 0;
    public integer Count_Loc = 0;
    public decimal for_FTE_RANGE = 0;
    //public decimal sumPrimaryFTE = 0;
    //public decimal sumPrimaryFTEOff = 0;
    public decimal sumRebadged = 0;
    public integer sum_Onshore= 0;
    public integer sum_Nearshore= 0;
    public integer sum_Offshore= 0;
    public integer sum_Multiple= 0;
    
    
    
    public integer Count_Lang = 0;
    //public decimal sumPrimaryFTETotal = 0;
    public decimal sumYr1 = 0;
    public decimal sumYr2 = 0;
    public decimal sumYr3 = 0;
    public decimal sumYr4 = 0;
    public decimal sumYr5 = 0;
    public decimal sumYr6 = 0;
    public decimal sumYr7 = 0;
    public decimal sumYr8 = 0;
    public decimal sumYr9 = 0;
    public decimal sumYr10 = 0;
    public decimal sumLastYr = 0;
    
        
    public String comments {get; set;}
    public Opportunity_Assumed_Contigency__c assrdContg {get; set;}
    public List<Opportunity_BenchMark_Summary__c> opprBeancMarkSummaryList{get; set;}
    public boolean showSummary{get; set;}
    public boolean includeinBenchmark{get; set;}
    public Transient Blob fileBody {get; set;}
    Transient Savepoint sp;
    //Summary Getter and Setters
    
    public id OppId {get; set;}
    public id benchOppId {get; set;}
    public List<attachment> doc_Upload {get; set;}
    public Opportunity_TGP__c BPO_Opp{get; set;}
    public Opportunity_Cost_Summary_Document__c ocs_Docs {get; set;}
    public Opportunity_Cost_Summary_Document__c lst_Docs {get; set;}
    public List<Opportunity_Cost_Summary_Document__c> lst_DocstoDel {get; set;}
    public boolean isDocuploaded {get; set;}
    public Transient String fileFullData{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public Transient String dropFileName{get;set;}
    public boolean isDone{get;set;}
    public boolean iserror{get; set;}
    private Integer inputCharacterMax { get { return 100000; } set; }
    List<String> allLines = new List<String>();
    List<String> allLines_Opp = new List<String>();
    List<String> allLines_Off = new List<String>();
    List<String> allLines_ppm = new List<String>();
    List<String> allLines_swbOADM = new List<String>();
    List<String> allLines_SWBsum = new List<String>();
    List<String> allLines_Py_rich = new List<String>();
    public String allLines_Opportunity {get;set;}
    public String allLines_Offering {get;set;}
    public String allLines_Summary {get;set;}
    public String allLines_PriceParameter {get;set;}
    public String allLines_OADM {get;set;}
    public String allLines_PyramidRichness {get;set;}
    public Opportunity_BenchMark_Data__c bechmarkOpp;
    public List<Opportunity_Offering_BenchMark_Data__c> lstbenchOff {get; set;}
    public Opportunity_Offering_BenchMark_Data__c bechmarkOff;
    public Opportunity_Cost_Summary_Document__c benchOff {get; set;}
    public Opportunity_Assumed_Contigency__c Opp_Cont;
    public List<Opportunity_Assumed_Contigency__c> lstOppCont = new List<Opportunity_Assumed_Contigency__c>();
    public Opportunity_OADM_FTE__c Opp_OADM;
    public List<Opportunity_OADM_FTE__c> lstOADM = new List<Opportunity_OADM_FTE__c>();
    public Opportunity_BenchMark_Summary__c bechmarkSummary;
    public List<Opportunity_BenchMark_Summary__c> lstSummary =new List<Opportunity_BenchMark_Summary__c>();
    public Opportunity_Level_Wise_FTE__c pyramidRichness;
    public List<Opportunity_Level_Wise_FTE__c> lstPyRichness =new List<Opportunity_Level_Wise_FTE__c>();
    List<Opportunity_BenchMark_Data__c> toDelOpprBenchMarkData =new List<Opportunity_BenchMark_Data__c>();
    List<Opportunity_Offering_BenchMark_Data__c> toDelOpprBenchMarkoff = new List<Opportunity_Offering_BenchMark_Data__c>();
    List<Opportunity_BenchMark_Summary__c> toDelSumm = new List<Opportunity_BenchMark_Summary__c>();
    List<Opportunity_Assumed_Contigency__c> toDelOppCont = new List<Opportunity_Assumed_Contigency__c>();
    List<Opportunity_OADM_FTE__c> toDelOADM = new List<Opportunity_OADM_FTE__c>();
    List<Opportunity_Level_Wise_FTE__c> toDelPyramid = new List<Opportunity_Level_Wise_FTE__c>();
    List<BenchMark_Offering__c> toDelBenchMarkoff = new List<BenchMark_Offering__c>();
    //public Opportunity_Cost_Summary_Document__c docUpload;
    public attachment a1;
    public boolean isValidate {get; set;}
    public Set<String> OfferingMaster = new Set<String>();
    public String OfferingNameList='';
    


/******************************
    Method Name: VFC_Cost_Summary_Metrics
    Description: 
    Paramenters: NA
    Return Value: NA
****************************** 
*/ 

    public VFC_Cost_Summary_Metrics_Old(ApexPages.StandardController controller) {
       
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        OppId=ApexPages.currentPage().getParameters().get('id');
        getDocs();
        benchOff = new Opportunity_Cost_Summary_Document__c();
        assrdContg=new Opportunity_Assumed_Contigency__c();//new Summary Code
        opprBeancMarkSummaryList=new List<Opportunity_BenchMark_Summary__c>();//new Summary Code
        initializeData();
        ocs_Docs = new Opportunity_Cost_Summary_Document__c();
        
    }
    public Opportunity_TGP__c initializeData(){
    
    isDocuploaded = false;
    
    try{
    
    BPO_Opp = [select id, name,SAP_OM_ID__c,Client_Name__r.name,Client_Name__c,TCV__c,Estimated_TCV__c from Opportunity_TGP__c where id=: OppId limit 1];
    
   

    bechmarkOpp=[SELECT Id FROM Opportunity_BenchMark_Data__c WHERE Opportunity__c =:OppId limit 1];      
    benchOppId=bechmarkOpp.id;
    system.debug('Do you even Bench:'+bechmarkOpp);    
    }
    catch(Exception e){system.debug(e);}
    return BPO_Opp;
    } 
    public Opportunity_Cost_Summary_Document__c getDocs()
    {
        try{
            lst_Docs = [select id,name,Document_Name__c,fileLink__c,Date_Uploaded__c,Comments__c from Opportunity_Cost_Summary_Document__c where opportunity__c=:oppId limit 1];
            if(lst_Docs!=null)
            {isDocuploaded = true;}    
            }
            catch(Exception e){}
            return lst_Docs;
    }     
/******************************
    Method Name: UploadFile
    Description: 
    Paramenters: NA
    Return Value: NA
****************************** 
*/ 
    public Pagereference UploadFile(){
        boolean isInserted=false;
        isValidate = false;
        iserror = false;
            sp = Database.setSavepoint();
            try{
                bechmarkOpp = new Opportunity_BenchMark_Data__c();
                lstbenchOff = new List<Opportunity_Offering_BenchMark_Data__c>();
                
                if(allLines_Opportunity != null)
                        {   
                            allLines_Opp = allLines_Opportunity.trim().split('\n');
                            
                            
                            if(allLines_Opp.size() <= 3)
                            {
                             
                                //File with no data in Opportunity Tab
                            iserror = true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Upload Failed! Due to Partial Data in Sheet: SWB-Benchmark-Opportunity');
                            ApexPages.addMessage(myMsg);
                            return null;
                            }
                        }
                        
                      
                        if(allLines_Offering != null)
                        {    system.debug('Validation 2');
                            allLines_Off = allLines_Offering.trim().split('\n');
                            system.debug('~~~~~'+allLines_Off.size());
                            if(allLines_Off.size() <= 3)
                            {
                            system.debug('allLines_Off.size()'+allLines_Off.size());
                            iserror = true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Upload Failed! Due to Partial Data in Sheet: SWB-Benchmark-Offering');
                            ApexPages.addMessage(myMsg);
                            return null;
                            }
                        } 
                        


                        if(allLines_Summary != null)
                        {    system.debug('Validation 3');
                            allLines_SWBsum = allLines_Summary.trim().split('\n');
                            if(allLines_SWBsum.size() <= 3)
                            {
                            system.debug('allLines_SWBsum.size()'+allLines_SWBsum.size());
                            iserror = true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Upload Failed! Due to Partial Data in Sheet: SWB-BPOSE-Summary');
                            ApexPages.addMessage(myMsg);
                            return null;
                            }
                            
                        } 
                        

                        if(allLines_PriceParameter != null)
                        {    system.debug('Validation 4');
                            allLines_ppm = allLines_PriceParameter.trim().split('\n');
                            system.debug('~~~~~'+allLines_ppm.size());
                            if(allLines_ppm.size() <= 4)
                            {
                            system.debug('allLines_ppm.size()'+allLines_ppm.size());
                            iserror = true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Upload Failed! Due to Partial Data in Sheet: SWB-Price Parameters');
                            ApexPages.addMessage(myMsg);
                            return null;
                            }
                        }
                        

                        if(allLines_OADM != null)
                        {    system.debug('Validation 5');
                            allLines_swbOADM = allLines_OADM.trim().split('\n');
                            system.debug('~~~~~'+allLines_swbOADM.size());
                            if(allLines_swbOADM.size() <= 3)
                            {
                            system.debug('allLines_swbOADM.size()'+allLines_swbOADM.size());
                            iserror = true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Upload Failed! Due to Partial Data in Sheet: SWB-OADM');
                            ApexPages.addMessage(myMsg);
                            return null;
                            }
                        }
                        
                        if(allLines_PyramidRichness != null)
                        {    system.debug('Validation 6');
                            allLines_Py_rich = allLines_PyramidRichness.trim().split('\n');
                            system.debug('~~~~~'+allLines_Py_rich.size());
                            if(allLines_Py_rich.size() <= 3)
                            {
                            system.debug('allLines_Py_rich.size()'+allLines_Py_rich.size());
                            iserror = true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Upload Failed! Due to Partial Data in Sheet: SWB-Pyramid Richness');
                            ApexPages.addMessage(myMsg);
                            return null;
                            }
                        } 
                        
                    
                    system.debug('ISERRORCHECK:'+iserror);
                    if(iserror != true){       
                        allLines_Opp = allLines_Opportunity.split('\n');
                        for(integer i = 3;i<allLines_Opp.size();i++){    
                            String[] inputvalues = new String[]{};
                            if(allLines_Opp[i].trim()!=''){
                                inputvalues = allLines_Opp[i].split('»');
                                if(inputvalues[0]!=''){
                                    if(inputvalues[0]==BPO_Opp.SAP_OM_ID__c){
                                    system.debug('in SAP OM Condition Satisfied');
                                    isValidate = true;
                                    }
                                    else{
                                        system.debug('Condition not Satisfied');
                                        isValidate = false;
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, 'Upload failed due to validation failures: SAP OM ID did NOT match!');
                                        ApexPages.addMessage(myMsg);
                                        return null;
                                    }
                                }
                                else if((BPO_Opp.Client_Name__r.name==inputvalues[1])&&(BPO_Opp.name ==inputvalues[2])){
                                    system.debug('Condition Satisfied');
                                    isValidate = true;
                                }else{
                                    system.debug('Condition not Satisfied');
                                    isValidate = false;
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, 'Upload failed due to validation failures: Client Name or Opportunity Name do NOT match!');
                                    ApexPages.addMessage(myMsg);
                                    return null;
                                }    
                            }
                        }
                    } 
                    /*if(iserror != true){       
                                allLines_Opp = allLines_Opportunity.split('\n');
                                for(integer i = 3;i<allLines_Opp.size();i++){    
                                String[] inputvalues = new String[]{};
                                if(allLines_Opp[i].trim()!='') 
                                {
                                    inputvalues = allLines_Opp[i].split('»');
                                    system.debug('checking condition:'+BPO_Opp.Client_Name__r.name+'==='+inputvalues[1]+'and'+BPO_Opp.name+'==='+inputvalues[2]);
                                    if((BPO_Opp.Client_Name__r.name==inputvalues[1])&&(BPO_Opp.name ==inputvalues[2]))
                                    {
                                        system.debug('Condition Satisfied');
                                        isValidate = true;
                                    }
                                    else
                                    {
                                        system.debug('Condition not Satisfied');
                                        isValidate = false;
                                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, 'Upload failed due to validation failures: Client Name or Opportunity Name do NOT match!');
                                        ApexPages.addMessage(myMsg);
                                        return null;
                                    }    
                                }
                              }
                          } */
                            if(isValidate == true){
                                insertOpp();
                                system.debug('Bhai Offering ko call kar le::');
                                insertOffering();
                                insertSummary();
                                insertPriceParam();
                                insertOADM();
                                insertPyramidRichness();
                                insertDocument();
                                //call delete
                                deleteData();
                                
                            }  
                      a1= null;
                      fileBody=null;                               
                      }// try end 
            catch(DMLException de){
            Database.rollback(sp);
            System.debug('Rollbacking:'+de.getMessage());
            // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, de.getMessage());
            // ApexPages.addMessage(myMsg);
                a1= null;
              fileBody=null;
            return null;
            }           
            catch(Exception e){
                        Database.rollback(sp);
                        String ErrorMessageToDisplay = 'Please verify data in Sheet: ' + sheetThrowingException ;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, ErrorMessageToDisplay );
                        ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
                        ApexPages.addMessage(myMsg);
                        ApexPages.addMessage(myMsg2);
                        
                        System.debug('File Upload Exception:'+e.getMessage());
                        a1= null;
                        fileBody=null;
                        return null;
            }
            
          //beanchMarkSummaryHome();  
          
        
         PageReference pageRef = new PageReference('/apex/BPO_Opportunity_tab?id='+oppId+'&tabfocus=tab15');
         pageRef.setRedirect(true); 
         return pageRef; 
          
          
     
    }
     
/*
*****************************
    Method Name: beanchMarkSummaryHome
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/      
    public Pagereference beanchMarkSummaryHome(){
    beanchmarkSummary();
    getDocs();
    //PageReference pageRef = new PageReference('/apex/fileUpload?id='+oppId);
     //pageRef.setRedirect(true); 
   // return pageRef;
   return null;
    }

    
/*
*****************************
    Method Name: insertOpp
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/    
private void insertOpp()
    {    try{
        system.debug('in InsertOpp:'+allLines_Opp);
        for(integer i = 3;i<allLines_Opp.size();i++){    
        String[] inputvalues = new String[]{};
        if(allLines_Opp[i].trim()!=''){
        inputvalues = allLines_Opp[i].split('»');
        system.debug('checking condition:'+BPO_Opp.Client_Name__r.name+'==='+inputvalues[1]+'and'+BPO_Opp.name+'==='+inputvalues[2]);
        if((BPO_Opp.Client_Name__r.name==inputvalues[1])||(BPO_Opp.name ==inputvalues[2])){
        system.debug('Condition Satisfied');
        iserror = false;
        }
        else{
        system.debug('Condition Not Satisfied::::: Display Error!!!');
        iserror = true;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Upload Failed Due to Validation Failures!');
        ApexPages.addMessage(myMsg);
        
        }
        bechmarkOpp = new Opportunity_BenchMark_Data__c();
        system.debug('size of input:::::'+inputvalues.size());
        if(inputvalues.size() != 0)
        {
        integer temp=inputvalues.size();
        
        if(temp>=53)
        {    
        if(inputvalues[0] !=null && inputvalues[0].trim() !=UTIL_Constants.EMPTY_STRING)
        {     
        bechmarkOpp.SAP_OM_ID__c = inputvalues[0];
        }
        if(inputvalues[3] !=null && inputvalues[3].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Scenario__c = inputvalues[3];
        }
        if(inputvalues[4] !=null && inputvalues[4].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Version__c = inputvalues[4];
        }
        if(inputvalues[5] !=null && inputvalues[5].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Contract_Start_Date__c = date.parse(inputvalues[5].trim());
        }
        if(inputvalues[6] !=null && inputvalues[6].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Initial_Go_Live__c = date.parse(inputvalues[6].trim());
        }
        if(inputvalues[7] !=null && inputvalues[7].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Contract_End_Date__c = date.parse(inputvalues[7].trim());
        }
        if(inputvalues[8] !=null && inputvalues[8].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.SSM_Version__c = inputvalues[8];
        }
        /*if(inputvalues[9] !=null && inputvalues[9].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.No_of_offerings_in_scope__c = CleanseDecimal(inputvalues[9]);
        }
        if(inputvalues[9] !=null && inputvalues[9].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.No_of_offerings_in_scope__c = CleanseDecimal(inputvalues[9]);
        }*/
        if(inputvalues[10] !=null && inputvalues[10].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
            if(inputvalues[10].equalsIgnoreCase('MULTI')){
            bechmarkOpp.Multi_Single_Offering__c = 'Multiple';    
            }
            else{bechmarkOpp.Multi_Single_Offering__c = inputvalues[10];}
        }
        if(inputvalues[11] !=null && inputvalues[11].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.TOTAL_Baseline_SDO_FTEs__c = CleanseDecimal(inputvalues[11]);
        }
        if(inputvalues[12] !=null && inputvalues[12].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Onshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[12]);
        }
        if(inputvalues[13] !=null && inputvalues[13].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Nearshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[13]);
        }
        if(inputvalues[14] !=null && inputvalues[14].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Offshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[14]);
        }
        if(inputvalues[15] !=null && inputvalues[15].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Grand_Total_Cost__c = CleanseDecimal(inputvalues[15]);
        }
        if(inputvalues[16] !=null && inputvalues[16].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.SDO_Total_Cost__c = CleanseDecimal(inputvalues[16]);
        }
        if(inputvalues[17] !=null && inputvalues[17].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.BSS_Total_Cost__c = CleanseDecimal(inputvalues[17]);
        }
        if(inputvalues[18] !=null && inputvalues[18].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Service_Management_Total_Cost__c = CleanseDecimal(inputvalues[18]);
        }
        if(inputvalues[19] !=null && inputvalues[19].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Support_Center_Total_Cost__c = CleanseDecimal(inputvalues[19]);
        }
        if(inputvalues[20] !=null && inputvalues[20].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Electronic_Doc_Management_Total_Cost__c = CleanseDecimal(inputvalues[20]);
        }
        if(inputvalues[21] !=null && inputvalues[21].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Command_Center_Total_Cost__c = CleanseDecimal(inputvalues[21]);
        }
        if(inputvalues[22] !=null && inputvalues[22].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Technology_Total_Cost__c = CleanseDecimal(inputvalues[22]);
        }
        if(inputvalues[23] !=null && inputvalues[23].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Technology_Tools_Total_Cost__c = CleanseDecimal(inputvalues[23]);
        
        }
        if(inputvalues[24] !=null && inputvalues[24].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Voice_and_Data_Total_Cost__c = CleanseDecimal(inputvalues[24]);
        }
        if(inputvalues[25] !=null && inputvalues[25].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Mobilization_Total_Cost__c = CleanseInt(inputvalues[25]);
        }
        if(inputvalues[26] !=null && inputvalues[26].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.PMO_Total_Cost__c = CleanseInt(inputvalues[26]);
        }
        if(inputvalues[27] !=null && inputvalues[27].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.OADM_Total_Cost__c = CleanseInt(inputvalues[27]);
        }
        if(inputvalues[28] !=null && inputvalues[28].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.CFM_Total_Cost__c = CleanseInt(inputvalues[28]);
        }
        if(inputvalues[29] !=null && inputvalues[29].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.CM_Total_Cost__c = CleanseInt(inputvalues[29]);
        }
        if(inputvalues[30] !=null && inputvalues[30].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.QAD_Total_Cost__c = CleanseInt(inputvalues[30]);
        }
        if(inputvalues[47] !=null && inputvalues[47].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Mobilization_Contingency__c = CleanseDecimal(inputvalues[47]);
        }
        if(inputvalues[48] !=null && inputvalues[48].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Average_Run_Contingency__c = CleanseDecimal(inputvalues[48]);
        }
        if(inputvalues[49] !=null && inputvalues[49].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.CI__c = CleanseDecimal(inputvalues[49]);
        }
        if(inputvalues[50] !=null && inputvalues[50].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Transformation_Costs_consulting__c = CleanseInt(inputvalues[50]);
        }
        if(inputvalues[51] !=null && inputvalues[51].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Deal_Unlocked__c = boolean.valueof(inputvalues[51].trim());
        }
        if(inputvalues[52] !=null && inputvalues[52].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Deal_Data_Tables_Updated__c = boolean.valueof(inputvalues[52].trim());
        }
        if(inputvalues[53] !=null && inputvalues[53].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Pyramid_Richness_Year1__c = CleanseDecimal(inputvalues[53]);
        }
        if(inputvalues[54] !=null && inputvalues[54].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Delivery_Locations__c = inputvalues[54].trim();
        Count_Loc = inputvalues[54].trim().split(',').size();
        bechmarkOpp.No_of_Locations__c = Count_Loc;
        }
        if(inputvalues[55] !=null && inputvalues[55].trim() !=UTIL_Constants.EMPTY_STRING)
        { 
        bechmarkOpp.Languages__c = inputvalues[55].trim();
        Count_Lang = inputvalues[55].trim().split(',').size();
        if(Count_Lang ==1)
            {
            bechmarkOpp.no_of_languages__c = '1';
            }
            else if(Count_Lang ==2)
            {
                bechmarkOpp.no_of_languages__c = '2';
            }
            else if(Count_Lang >2)
            {
                bechmarkOpp.no_of_languages__c = '3+';
            }

        }
    //Field Mapping For Data On Benchmark Search Page- START
        integer day=0;
        if(bechmarkOpp.Contract_End_Date__c.day() >= bechmarkOpp.Contract_Start_Date__c.day()){
        day=1;
        }
        /*bechmarkOpp.BPO_Net_Revenue__c=(BPO_Opp.Estimated_TCV__c!=null? BPO_Opp.Estimated_TCV__c:BPO_Opp.TCV__c);
        if(bechmarkOpp.BPO_Net_Revenue__c != null)
        {   decimal ref = bechmarkOpp.BPO_Net_Revenue__c*1000;
            if(ref <= 1000000)
            {
            bechmarkOpp.BPO_Net_Revenue_Range__c = 'X Small (0-1M)';
            
            }
       else if(ref <= 9000000)
            {
            bechmarkOpp.BPO_Net_Revenue_Range__c = 'Small (1-9M)';
            
            }
           else if(ref <= 39000000)
            {
            bechmarkOpp.BPO_Net_Revenue_Range__c = 'Medium (10-39M)';
            
            }
            else if(ref <= 99000000)
            {
            bechmarkOpp.BPO_Net_Revenue_Range__c = 'Large (40-99M)';
            
            }
            else
            {
            bechmarkOpp.BPO_Net_Revenue_Range__c = 'Mega (100M+)';
            
            }
        } */
        if(bechmarkOpp.Onshore_Baseline_FTEs__c==null){
            bechmarkOpp.Onshore_Baseline_FTEs__c=0.0;
        }
        if(bechmarkOpp.Nearshore_Baseline_FTEs__c==null){
            bechmarkOpp.Nearshore_Baseline_FTEs__c=0.0;
        }
        
        //bechmarkOpp.Contract_duration_MOB_RUN__c = (bechmarkOpp.Contract_End_Date__c.year()- bechmarkOpp.Contract_Start_Date__c.year())*12 + (bechmarkOpp.Contract_End_Date__c.month()- bechmarkOpp.Contract_Start_Date__c.month())+day;
        if(bechmarkOpp.Initial_Go_Live__c.day() >= bechmarkOpp.Contract_Start_Date__c.day()){
        day=1;
        }
        //bechmarkOpp.Contract_duration_MOB_DURATION__c = (bechmarkOpp.Initial_Go_Live__c.year()- bechmarkOpp.Contract_Start_Date__c.year())*12 + (bechmarkOpp.Initial_Go_Live__c.month()- bechmarkOpp.Contract_Start_Date__c.month())+day; 
    
    //Field Mapping For Data On Benchmark Search Page- END
    bechmarkOpp.Opportunity__c=BPO_Opp.id;
    bechmarkOpp.Client__c=BPO_Opp.Client_Name__c;
    system.debug('End of Bench Opp assignment');
    }
    }
    }

    }
    
    if(BPO_Opp != null && BPO_Opp.id != null){
    system.debug(toDelOpprBenchMarkData.size());
    toDelOpprBenchMarkData = [select id,Include_in_BenchMark_Report__c from Opportunity_BenchMark_Data__c where Opportunity__c=:BPO_Opp.id];
    if(toDelOpprBenchMarkData.size() >0)
    {
    isIncludeInBenchmark = toDelOpprBenchMarkData[0].Include_in_BenchMark_Report__c;
    bechmarkOpp.Include_in_BenchMark_Report__c = isIncludeInBenchmark;
    }
    }
    //}
    
    system.debug('BPO Opp.id'+BPO_Opp.id);
    system.debug('Ye bhi lo::'+bechmarkOpp);
    database.insert(bechmarkOpp);
    benchOppId=bechmarkOpp.id;
    system.debug('Ye le:'+benchOppId);
    }
    catch(DMLException de){
    system.debug('insertopp DML EX:'+de);
    throw(de);
    }
    catch(exception e){
    sheetThrowingException = 'SWB-Benchmark-Opportunity';
    system.debug('insertOpp'+e);
    throw(e);
    }
}

/*
*****************************
    Method Name: insertOffering
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/    

private void insertOffering(){
                    system.debug('Offering me aaapka swagat hai::');
                    try{
                        for(integer i = 3;i<allLines_Off.size();i++)
                        {   system.debug('for me:'+i);
                            String[] inputvalues = new String[]{};
                            inputvalues = allLines_Off[i].split('»');
                            bechmarkOff = new Opportunity_Offering_BenchMark_Data__c();
                            
                            if(inputvalues.size() != 0)
                            {
                                integer temp=inputvalues.size();
                                system.debug('temp'+i+'.|.'+temp);
                                if(temp>=10)
                                {    
                                    if(inputvalues.size()>0 && inputvalues[0] !=null && inputvalues[0].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Costing_Type__c = inputvalues[0];
                                    }
                                    if(inputvalues.size()>1 && inputvalues[1] !=null && inputvalues[1].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Sub_Service_Offering__c = inputvalues[1];
                                        OfferingMaster.add(bechmarkOff.Sub_Service_Offering__c);
                                    }
                                    if(inputvalues.size()>2 && inputvalues[2] !=null && inputvalues[2].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Service__c = inputvalues[2];
                                    }
                                    if(inputvalues.size()>3 && inputvalues[3] !=null && inputvalues[3].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Sum_of_Total_Cost__c = CleanseDecimal(inputvalues[3]);
                                    }
                                    if(inputvalues.size()>4 && inputvalues[4] !=null && inputvalues[4].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Sum_of_Average_FTEs__c = CleanseDecimal(inputvalues[4]);
                                    }
                                    if(inputvalues.size()>5 && inputvalues[5] !=null && inputvalues[5].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        system.debug('bechmarkOff.Average_of_Location_Definition__c' + inputvalues[5]);
                                        bechmarkOff.Average_of_Location_Definition__c = CleanseDecimal(inputvalues[5]);
                                        if(bechmarkOff.Average_of_Location_Definition__c == 1)
                                        {
                                            sum_Onshore = sum_Nearshore+1;
                                        }
                                       else if(bechmarkOff.Average_of_Location_Definition__c == 2)
                                        {
                                            sum_Nearshore = sum_Nearshore+1;
                                        }
                                        else if(bechmarkOff.Average_of_Location_Definition__c == 3)
                                        {
                                            sum_Offshore = sum_Offshore+1;
                                        }
                                        else If(bechmarkOff.Average_of_Location_Definition__c == 0)
                                        {
                                            
                                        }
                                        else {
                                            sum_Multiple = sum_Multiple+1;
                                        }
                                    }
                                    if(inputvalues.size()>6 &&  inputvalues[6] !=null && inputvalues[6].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Count_of_Language__c = CleanseInt(inputvalues[6]);
                                        
                                    }
                                    if(inputvalues.size()>7 && inputvalues[7] !=null && inputvalues[7].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Average_of_FTE_Type__c = CleanseDecimal(inputvalues[7]);
                                    }
                                    if(inputvalues.size()>8 && inputvalues[8] !=null && inputvalues[8].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Sum_of_Baseline_FTEs__c = CleanseDecimal(inputvalues[8]);
                                        if(bechmarkOff.Costing_Type__c == 'SDO'){
                                        //sumPrimaryFTETotal = sumPrimaryFTETotal + bechmarkOff.Sum_of_Baseline_FTEs__c;
                                        for_FTE_RANGE = for_FTE_RANGE + bechmarkOff.Sum_of_Baseline_FTEs__c;
                                        }
                                    }
                                    if(inputvalues.size()>9 && inputvalues[9] !=null && inputvalues[9].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Average_of_Pyramid_Richness_Year_1__c = CleanseDecimal(inputvalues[9]);
                                    }
                                    if(inputvalues.size()>10 && inputvalues[10] !=null && inputvalues[10].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Sum_of_Final_Month_FTE__c = CleanseDecimal(inputvalues[10]);
                                    }
                                    if(inputvalues.size()>11 && inputvalues[11] !=null && inputvalues[11].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.No_of_Employees__c = CleanseDecimal(inputvalues[11]);
                                    }  
                                    if(inputvalues.size()>12 && inputvalues[12] !=null && inputvalues[12].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.No_of_Contractors__c = CleanseDecimal(inputvalues[12]);
                                    }             
                                    if(inputvalues.size()>13 && inputvalues[13] !=null && inputvalues[13].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.No_of_Headcounts__c = CleanseDecimal(inputvalues[13]);
                                    }
                                    if(inputvalues.size()>=14 && inputvalues[14] !=null && inputvalues[14].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Onshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[14]);
                                    }
                                    if(inputvalues.size()>=15 && inputvalues[15] !=null && inputvalues[15].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Offshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[15]);
                                    }
                                    if(inputvalues.size()>=16 && inputvalues[16] !=null && inputvalues[16].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkOff.Nearshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[16]);
                                    }
                                    bechmarkOff.Opportunity_BenchMark_Data__c=benchOppId;
                                    lstbenchOff.add(bechmarkOff);
                                }
                                }
                                }
                                
                            
                            //if(sum_Onshore == 0 && sum_Nearshore == 0 && sum_Offshore == 0 && sum_Multiple == 0) {
                              //  bechmarkOpp.Delivery_Location__c = null;
                            //}
                            //else if((sum_Onshore > 0 && sum_Nearshore==0 && sum_Offshore ==0 && sum_Multiple == 0))
                            //{
                                //bechmarkOpp.Delivery_Location__c = 'Onshore';
                            //}
                            //else if((sum_Onshore ==0 && sum_Nearshore > 0 && sum_Offshore ==0 && sum_Multiple == 0))
                            //{
                            //    bechmarkOpp.Delivery_Location__c = 'Nearshore';
                            //}
                            //else if((sum_Onshore == 0 && sum_Nearshore==0 && sum_Offshore >0 && sum_Multiple == 0))
                            //{
                                //bechmarkOpp.Delivery_Location__c = 'Offshore';
                            //} 
                            //else {
                               // bechmarkOpp.Delivery_Location__c = 'Multiple';
                           // }
                            
                            
                            
                                
                                if(bechmarkOpp.Multi_Single_Offering__c=='Multiple')   
                                {
                                    for_FTE_RANGE = bechmarkOpp.TOTAL_Baseline_SDO_FTEs__c;
                                } 
                                //if(for_FTE_RANGE<50)
                                //{
                                  //  bechmarkOpp.FTE_Range__c = '<50';
                                //}
                                //else if(for_FTE_RANGE<200)
                                //{
                                  //  bechmarkOpp.FTE_Range__c = '50 - 200';
                                //}
                                //else if(for_FTE_RANGE<400)
                                //{
                                  //  bechmarkOpp.FTE_Range__c = '200 - 400';
                                //}
                                //else
                                //{
                                  //  bechmarkOpp.FTE_Range__c = '>400';
                                //}
                                toDelOpprBenchMarkoff = [select id from Opportunity_Offering_BenchMark_Data__c where Opportunity_BenchMark_Data__c =:benchOppId];
                                //database.delete(toDelOpprBenchMarkoff);
                                
                                //New Code Added
                                toDelBenchMarkoff = [select id from BenchMark_Offering__c where Opportunity_BenchMark_Data__c =:benchOppId];
                                List<Benchmark_Offering__c> benchmarkOffExServiceList=populateOfferingExService(lstbenchOff);
                                database.Insert(benchmarkOffExServiceList);
                                lstbenchOff = rePopulateOffering(benchmarkOffExServiceList,lstbenchOff);
                                //New Code Added
                                database.Insert(lstbenchOff);
                                system.debug('offering inserted'+lstbenchOff);
                                
                                lstbenchOff = [select id,Sub_Service_Offering__c from Opportunity_Offering_BenchMark_Data__c where Opportunity_BenchMark_Data__c =:benchOppId];
                                Set<String> offeringName = new Set<String>();
                                    for(Opportunity_Offering_BenchMark_Data__c off: lstbenchOff )
                                    {    system.debug(off);
                                        offeringName.add(off.Sub_Service_Offering__c);
                                    }
                                    for(String s:OfferingMaster){
                                       OfferingNameList=OfferingNameList+';'+s+';';
                                    }
                                   bechmarkOpp.Offering_List__c=populateofferingList(OfferingNameList);
                                 database.update(bechmarkOpp);
                                 system.debug('Offering me aaapka swagat hai2::');   
                                 }
                                 catch(DMLException de){
                                    system.debug('insertoff DML EX:'+de);
                                    throw(de);
                                    }
                                    catch(exception e){
                                        sheetThrowingException = 'SWB-Benchmark-Offering';
                                        system.debug('insertOpp'+e);
                                        throw(e);
                                    }                             
}

/*
*****************************
    Method Name: insertSummary
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/    

                private void insertSummary(){
                     try{
                      for(integer i = 3;i<allLines_SWBsum.size();i++)
                      {
                            String[] inputvalues = new String[]{};
                            inputvalues = allLines_SWBsum[i].split('»');
                            bechmarkSummary = new Opportunity_BenchMark_Summary__c();
                            if(inputvalues.size() != 0)
                            {
                               integer temp=inputvalues.size();
                               if(temp>=37)
                               {
                                   if(inputvalues[0] !=null && inputvalues[0].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Pivot_Level__c = inputvalues[0];
                                        
                                    }
                                    if(inputvalues[1] !=null && inputvalues[1].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sub_Service_Offering__c = inputvalues[1];
                                        
                                    }
                                    if(inputvalues[2] !=null && inputvalues[2].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Service__c = inputvalues[2];
                                        
                                    }
                                    if(inputvalues[3] !=null && inputvalues[3].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_Mob_cost__c = CleanseDecimal(inputvalues[3]);
                                    }
                                    if(inputvalues[4] !=null && inputvalues[4].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year1__c= CleanseDecimal(inputvalues[4]);
                                    }
                                    if(inputvalues[5] !=null && inputvalues[5].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year2__c = CleanseDecimal(inputvalues[5]);
                                    }
                                    if(inputvalues[6] !=null && inputvalues[6].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year3__c = CleanseDecimal(inputvalues[6]);
                                    }
                                    if(inputvalues[7] !=null && inputvalues[7].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year4__c = CleanseDecimal(inputvalues[7]);
                                    }
                                    if(inputvalues[8] !=null && inputvalues[8].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year5__c = CleanseDecimal(inputvalues[8]);
                                    }
                                    if(inputvalues[9] !=null && inputvalues[9].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year6__c = CleanseDecimal(inputvalues[9]);
                                    }
                                    if(inputvalues[10] !=null && inputvalues[10].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year7__c = CleanseDecimal(inputvalues[10]);
                                    }
                                    if(inputvalues[11] !=null && inputvalues[11].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year8__c = CleanseDecimal(inputvalues[11]);
                                    }
                                    if(inputvalues[12] !=null && inputvalues[12].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year9__c = CleanseDecimal(inputvalues[12]);
                                    }
                                    if(inputvalues[13] !=null && inputvalues[13].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_RUN_Year10__c = CleanseDecimal(inputvalues[13]);
                                    }
                                    if(inputvalues[14] !=null && inputvalues[14].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_Total_Cost__c = CleanseDecimal(inputvalues[14]);
                                        Sum_Total_Cost = Sum_Total_Cost + bechmarkSummary.Sum_of_Total_Cost__c;
                                    }
                                    
                                    if(inputvalues[15] !=null && inputvalues[15].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR1__c = CleanseDecimal(inputvalues[15]);
                                        sumYr1 = sumYr1 + bechmarkSummary.Sum_of_FTE_YR1__c;
                                    }
                                    if(inputvalues[16] !=null && inputvalues[16].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR2__c = CleanseDecimal(inputvalues[16]);
                                        sumYr2 = sumYr2 + bechmarkSummary.Sum_of_FTE_YR2__c;
                                    }
                                    if(inputvalues[17] !=null && inputvalues[17].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR3__c = CleanseDecimal(inputvalues[17]);
                                        sumYr3 = sumYr3 + bechmarkSummary.Sum_of_FTE_YR3__c;
                                    }
                                    if(inputvalues[18] !=null && inputvalues[18].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR4__c = CleanseDecimal(inputvalues[18]);
                                        sumYr4 = sumYr4 + bechmarkSummary.Sum_of_FTE_YR4__c;
                                    }
                                    if(inputvalues[19] !=null && inputvalues[19].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR5__c = CleanseDecimal(inputvalues[19]);
                                        sumYr5 = sumYr5 + bechmarkSummary.Sum_of_FTE_YR5__c;
                                    }
                                    if(inputvalues[20] !=null && inputvalues[20].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR6__c = CleanseDecimal(inputvalues[20]);
                                        sumYr6 = sumYr6 + bechmarkSummary.Sum_of_FTE_YR6__c;
                                    }
                                    if(inputvalues[21] !=null && inputvalues[21].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR7__c = CleanseDecimal(inputvalues[21]);
                                        sumYr7 = sumYr7 + bechmarkSummary.Sum_of_FTE_YR7__c;
                                    }
                                    if(inputvalues[22] !=null && inputvalues[22].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR8__c = CleanseDecimal(inputvalues[22]);
                                        sumYr8 = sumYr8 + bechmarkSummary.Sum_of_FTE_YR8__c;
                                    }
                                    if(inputvalues[23] !=null && inputvalues[23].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR9__c = CleanseDecimal(inputvalues[23]);
                                        sumYr9 = sumYr9 + bechmarkSummary.Sum_of_FTE_YR9__c;
                                    }
                                    if(inputvalues[24] !=null && inputvalues[24].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Sum_of_FTE_YR10__c = CleanseDecimal(inputvalues[24]);
                                        sumYr10 = sumYr10 + bechmarkSummary.Sum_of_FTE_YR10__c;
                                    }
                                    if(inputvalues[25] !=null && inputvalues[25].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Total_FTE_all_years__c = CleanseDecimal(inputvalues[25]);
                                        Sum_Total_FTE = Sum_Total_FTE + bechmarkSummary.Total_FTE_all_years__c;
                                    }
                                    if(inputvalues[26] !=null && inputvalues[26].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.percent_of_costs__c = CleanseDecimal(inputvalues[26]);
                                    }
                                    if(inputvalues[27] !=null && inputvalues[27].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_Full_deal__c = CleanseDecimal(inputvalues[27]);
                                    }
                                    if(inputvalues[28] !=null && inputvalues[28].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_1_Mob__c = CleanseDecimal(inputvalues[28]);
                                    }
                                    if(inputvalues[29] !=null && inputvalues[29].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_2__c = CleanseDecimal(inputvalues[29]);
                                    }
                                    if(inputvalues[30] !=null && inputvalues[30].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_3__c = CleanseDecimal(inputvalues[30]);
                                    }
                                    if(inputvalues[31] !=null && inputvalues[31].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_4__c = CleanseDecimal(inputvalues[31]);
                                    }
                                    if(inputvalues[32] !=null && inputvalues[32].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_5__c = CleanseDecimal(inputvalues[32]);
                                    }
                                    if(inputvalues[33] !=null && inputvalues[33].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_6__c = CleanseDecimal(inputvalues[33]);
                                    }
                                    if(inputvalues[34] !=null && inputvalues[34].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_7__c = CleanseDecimal(inputvalues[34]);
                                    }
                                    if(inputvalues[35] !=null && inputvalues[35].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_8__c = CleanseDecimal(inputvalues[35]);
                                    }
                                    if(inputvalues[36] !=null && inputvalues[36].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_9__c = CleanseDecimal(inputvalues[36]);
                                    }
                                    if(inputvalues[37] !=null && inputvalues[37].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        bechmarkSummary.Average_cost_FTE_YR_10__c = CleanseDecimal(inputvalues[37]);
                                    }
                                    
                                    bechmarkSummary.Opportunity_BenchMark_Data__c=benchOppId;
                                    if((bechmarkSummary.Pivot_Level__c!=null) || (bechmarkSummary.Sub_Service_Offering__c!=null) ||(bechmarkSummary.Service__c!=null))
                                        lstSummary.add(bechmarkSummary);
                               } 
                            }
                      }            
                                
                                toDelSumm = [select id from Opportunity_BenchMark_Summary__c where Opportunity_BenchMark_Data__c=:benchOppId];
                                //database.delete(toDelSumm);
                                system.debug('Check1');
                                database.Insert(lstSummary);
                                system.debug('Check2');
                                
                                
                    }
                
                catch(DMLException de){
                    system.debug('insertsumm DML EX:'+de);
                    throw(de);
                    }
                    catch(exception e){
                                        sheetThrowingException = 'SWB-BPOSE-Summary';
                                        system.debug('insertOpp'+e);
                                        throw(e);
                                    } 
                }
/*
*****************************
    Method Name: insertPriceParam
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/
                    private void insertPriceParam(){
                        try{
                        for(integer i = 4;i<allLines_ppm.size();i++)
                        {
                            String[] inputvalues = new String[]{};
                            inputvalues = allLines_ppm[i].split('»');
                            Opp_Cont= new Opportunity_Assumed_Contigency__c();
                            
                            if(inputvalues.size() != 0)
                            {
                                integer temp=inputvalues.size();
                                
                                if(temp>=10)
                                {   
                                    if(inputvalues[0] !=null && inputvalues[0].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.name = inputvalues[0];
                                        
                                    }
                                    if(inputvalues[1] !=null && inputvalues[1].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Mob_All_years__c = integer.valueOf(inputvalues[1].split('%')[0].trim());
                                        
                                    }
                                    if(inputvalues[2] !=null && inputvalues[2].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_1__c = integer.valueOf(inputvalues[2].split('%')[0].trim());
                                        
                                    }
                                    if(inputvalues[3] !=null && inputvalues[3].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_2__c = integer.valueOf(inputvalues[3].split('%')[0].trim());
                                    }
                                    if(inputvalues[4] !=null && inputvalues[4].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_3__c = integer.valueOf(inputvalues[4].split('%')[0].trim());
                                    }
                                    if(inputvalues[5] !=null && inputvalues[5].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_4__c = integer.valueOf(inputvalues[5].split('%')[0].trim());
                                    }
                                    if(inputvalues[6] !=null && inputvalues[6].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_5__c = integer.valueOf(inputvalues[6].split('%')[0].trim());
                                    }
                                    if(inputvalues[7] !=null && inputvalues[7].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_6__c = integer.valueOf(inputvalues[7].split('%')[0].trim());
                                    }
                                    if(inputvalues[8] !=null && inputvalues[8].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_7__c = integer.valueOf(inputvalues[8].split('%')[0].trim());
                                    }
                                    if(inputvalues[9] !=null && inputvalues[9].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_8__c = integer.valueOf(inputvalues[9].split('%')[0].trim());
                                    }
                                    if(inputvalues[10] !=null && inputvalues[10].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_9__c = integer.valueOf(inputvalues[10].split('%')[0].trim());
                                    }
                                    if(inputvalues[11] !=null && inputvalues[11].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_Cont.Run_Year_10__c = integer.valueOf(inputvalues[11].split('%')[0].trim());
                                    }
                                    
                                    Opp_Cont.Opportunity__c=BPO_Opp.id;
                                    lstOppCont.add(Opp_Cont);
                                    
                                }
                                }
                                }
                                
                                toDelOppCont = [select id from Opportunity_Assumed_Contigency__c where Opportunity__c =:BPO_Opp.id];
                                //database.delete(toDelOppCont);
                                
                                
                                database.Insert(lstOppCont);
                                system.debug('Price parameter inserted'+lstoppcont);
                                }
                                catch(DMLException de){
                                    system.debug('insertoppcont DML EX:'+de);
                                    throw(de);
                                    }
                                    catch(exception e){
                                        sheetThrowingException = 'SWB-Price Parameters';
                                        system.debug('insertOpp'+e);
                                        throw(e);
                                    }
                                }
//End
/*
*****************************
    Method Name: insertOADM
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/               
                private void insertOADM(){ 
                try{
                   for(integer i = 3;i<allLines_swbOADM.size();i++)
                        {   
                            boolean insertRecord=false;
                            String[] inputvalues = new String[]{};
                            inputvalues = allLines_swbOADM[i].split('»');
                            Opp_OADM= new Opportunity_OADM_FTE__c();
                            if(inputvalues.size() != 0)
                            {
                                integer temp=inputvalues.size();
                                
                                if(temp>=4)
                                {   
                                    if(inputvalues[0] !=null && inputvalues[0].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_OADM.Costing_Type__c = inputvalues[0];
                                        insertRecord=true;
                                    }
                                    if(inputvalues[1] !=null && inputvalues[1].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                       Opp_OADM.Service__c = inputvalues[1];
                                        
                                    }
                                    if(inputvalues[2] !=null && inputvalues[2].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_OADM.Country__c = inputvalues[2];
                                        
                                    }
                                    if(inputvalues[3] !=null && inputvalues[3].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_OADM.Career_Level__c = inputvalues[3];
                                    }
                                    if(inputvalues[4] !=null && inputvalues[4].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        Opp_OADM.OADM_FTEs__c = CleanseDecimal(inputvalues[4]);
                                    }
                                    if(insertRecord==true){
                                    Opp_OADM.Opportunity__c = BPO_Opp.id;
                                    Opp_OADM.Opportunity_BenchMark_Data__c=benchOppId;
                                    lstOADM.add(Opp_OADM);
                                    
                                }
                                }
                                }
                                }
                                toDelOADM = [select id from Opportunity_OADM_FTE__c where Opportunity_BenchMark_Data__c=:benchOppId];
                                //database.delete(toDelOADM);
                                
                                database.Insert(lstOADM );
                                }
                               catch(DMLException de){
                                system.debug('insertOADM DML EX:'+de);
                                throw(de);
                                }
                                catch(exception e){
                                        sheetThrowingException = 'SWB-OADM';
                                        system.debug('insertOpp'+e);
                                        throw(e);
                                    }
                            }
 /*
*****************************
    Method Name: insertPyramidRichness
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/    
                        private void insertPyramidRichness()
                        {
                        try{
                        for(integer i = 3;i<allLines_Py_rich.size()-1;i++)
                        {
                            String[] inputvalues = new String[]{};
                            inputvalues = allLines_Py_rich[i].split('»');
                            pyramidRichness = new Opportunity_Level_Wise_FTE__c();
                            if(inputvalues.size() != 0)
                            {
                                integer temp=inputvalues.size();
                                
                                if(temp>=2)
                                {    
                                    if(inputvalues[0] !=null && inputvalues[0].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        pyramidRichness.Calculation_for_PR__c = CleanseDecimal(inputvalues[0]);
                                        
                                    }
                                    if(inputvalues[1] !=null && inputvalues[1].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        pyramidRichness.Levels__c = inputvalues[1];
                                        
                                    }
                                    if(inputvalues[2] !=null && inputvalues[2].trim() !=UTIL_Constants.EMPTY_STRING)
                                    { 
                                        pyramidRichness.FTEs__c= CleanseDecimal(inputvalues[2]);
                                        
                                    }
                                    pyramidRichness.Opportunity__c = BPO_Opp.id;
                                    pyramidRichness.Opportunity_BenchMark_Data__c=benchOppId;
                                    lstPyRichness.add(pyramidRichness);
                                    
                                }
                                }
                                }
                                
                                toDelPyramid = [select id from Opportunity_Level_Wise_FTE__c where Opportunity_BenchMark_Data__c=:benchOppId];
                                //database.delete(toDelPyramid);
                                
                                database.Insert(lstPyRichness);
                                }
                                catch(DMLException de){
                                system.debug('insertPyRich DML EX:'+de);
                                throw(de);
                                }
                                catch(exception e){
                                        sheetThrowingException = 'SWB-Pyramid Richness';
                                        system.debug('insertOpp'+e);
                                        throw(e);
                                    }
                                
                                } 
 /*
*****************************
    Method Name: insertDocument
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/                      
                    private void insertDocument(){
                    //attachment a1;
                    try{
                    doc_Upload = new List<attachment>();
                        doc_Upload = [select id,name,body,parentId from attachment where parentId =:benchoppId limit 1 ];
                        system.debug('hello'+doc_Upload);
                        if(doc_Upload.size() >0)
                        {
                        a1 =  new attachment();
                        system.debug('hello'+uploadFileAtt);
                        a1.Id=doc_Upload[0].id;
                        if(doc_Upload[0].name.length()>=79)
                            a1.name=doc_Upload[0].name.substring(0,75);
                        else
                            a1.name=doc_Upload[0].name;
                        //doc_Upload.body=blob.valueOf(uploadFileAtt);
                        system.debug(uploadFileAtt);
                        //a1.body=EncodingUtil.base64Decode(uploadFileAtt);
                        a1.body=fileBody;
                        a1.parentId=benchoppId;    
                        database.upsert(a1);
                        system.debug('hello'+doc_Upload);
                        }
                        else{
                        system.debug('Mai Else me hun');
                        a1 =  new attachment();
                        a1.name=dropFileName;
                        //a1.body=blob.valueOf(fileFullData);
                        a1.body=fileBody;
                        a1.parentId=benchoppId;    
                        database.insert(a1);
                        system.debug('hello'+a1);
                        }
                       // a1= null;
                        fileBody=null;
                        lst_DocstoDel = [select id from Opportunity_Cost_Summary_Document__c where Opportunity__c =:Bpo_Opp.id ];
                        //database.delete(lst_DocstoDel);
                        Opportunity_Cost_Summary_Document__c ocsDocsDB = new Opportunity_Cost_Summary_Document__c();
                        system.debug('filename:::::'+dropFileName);
                        
                        if(dropFileName.length()>=79)
                            ocsDocsDB.name=dropFileName.substring(0,75);
                        else
                            ocsDocsDB.name=dropFileName;
                        
                        //ocsDocsDB.name=dropFileName.substring(0,75);
                        ocsDocsDB.Document_Name__c=dropFileName;
                        ocsDocsDB.Date_Uploaded__c=System.Today();
                        ocsDocsDB.fileId__c=a1.id;
                        ocsDocsDB.Opportunity_BenchMark_Data__c=benchoppId;
                        ocsDocsDB.Opportunity__c=oppId;
                        ocsDocsDB.Comments__c=benchOff.comments__c;
                        system.debug('Comments:'+comments);
                        //ocsDocsDB.Comments__c=comments;
                        system.debug('before insert docs');
                        insert ocsDocsDB;
                        system.debug('after insert docs');
                        benchOff.comments__c= '';
                        a1=null;
                        }
                        catch(DMLException de){
                        system.debug('insertdox DML EX:'+de);
                        throw(de);
                        }
                        catch(exception e){
                        system.debug('insertOpp'+e);
                        throw(e);
                        }
                        finally{
                        a1=null;
                        fileBody=null;
                        }
                        }
     /*
*****************************
    Method Name: beanchmarkSummary
    Description: 
    Paramenters: NA
    Return Value: NA
******************************
*/ 
    public void beanchmarkSummary(){
        opprBeancMarkSummaryList = [select Pivot_Level__c,Service__c,Sub_Service_Offering__c,Sum_of_Mob_cost__c,Sum_of_RUN_Year1__c,Sum_of_RUN_Year2__c,Sum_of_RUN_Year3__c,Sum_of_RUN_Year4__c,Sum_of_RUN_Year5__c,Sum_of_RUN_Year6__c,Sum_of_RUN_Year7__c,Sum_of_RUN_Year8__c,Sum_of_RUN_Year9__c,Sum_of_RUN_Year10__c,Sum_of_Total_Cost__c,Sum_of_FTE_YR1__c,Sum_of_FTE_YR2__c,Sum_of_FTE_YR3__c,Sum_of_FTE_YR4__c,Sum_of_FTE_YR5__c,Sum_of_FTE_YR6__c,Sum_of_FTE_YR7__c,Sum_of_FTE_YR8__c,Sum_of_FTE_YR9__c,Sum_of_FTE_YR10__c,Total_FTE_all_years__c,percent_of_costs__c,Average_cost_FTE_Full_deal__c,Average_cost_FTE_YR_1_Mob__c,Average_cost_FTE_YR_2__c,Average_cost_FTE_YR_3__c,Average_cost_FTE_YR_4__c,Average_cost_FTE_YR_5__c,Average_cost_FTE_YR_6__c,Average_cost_FTE_YR_7__c,Average_cost_FTE_YR_8__c,Average_cost_FTE_YR_9__c,Average_cost_FTE_YR_10__c FROM Opportunity_BenchMark_Summary__c WHERE Opportunity_BenchMark_Data__c =:benchOppId ];
        
        Decimal decTotCost1=0;                    
        Decimal decTotCost2=0;
        Decimal decTotCost3=0;
        Decimal decTotCost4=0;
        Decimal decTotCost5=0;
        Decimal decTotCost6=0;
        Decimal decTotCost7=0;
        Decimal decTotCost8=0;
        Decimal decTotCost9=0;
        Decimal decTotCost10=0;
        Decimal decTotCost11=0;
        Decimal decTotCost12=0;
        
        Decimal decTotCost13=0;                    
        Decimal decTotCost14=0;
        Decimal decTotCost15=0;
        Decimal decTotCost16=0;
        Decimal decTotCost17=0;
        Decimal decTotCost18=0;
        Decimal decTotCost19=0;
        Decimal decTotCost20=0;
        Decimal decTotCost21=0;
        Decimal decTotCost22=0;
        Decimal decTotCost23=0;
        Decimal decTotCost24=0;
        Decimal decTotCost25=0;
        Decimal decTotCost26=0;
        Decimal decTotCost27=0;
        Decimal decTotCost28=0;
        Decimal decTotCost29=0;
        Decimal decTotCost30=0;
        Decimal decTotCost31=0;
        Decimal decTotCost32=0;
        Decimal decTotCost33=0;
        Decimal decTotCost34=0;
        Decimal decTotCost35=0;
        
        Decimal DecCostContMob=0;
        Decimal DecCostContYr1=0;
        Decimal DecCostContYr2=0;
        Decimal DecCostContYr3=0;
        Decimal DecCostContYr4=0;
        Decimal DecCostContYr5=0;
        Decimal DecCostContYr6=0;
        Decimal DecCostContYr7=0;
        Decimal DecCostContYr8=0;
        Decimal DecCostContYr9=0;
        Decimal DecCostContYr10=0;
        
        Decimal DecColaMob=0;
        Decimal DecColaYr1=0;
        Decimal DecColaYr2=0;
        Decimal DecColaYr3=0;
        Decimal DecColaYr4=0;
        Decimal DecColaYr5=0;
        Decimal DecColaYr6=0;
        Decimal DecColaYr7=0;
        Decimal DecColaYr8=0;
        Decimal DecColaYr9=0;
        Decimal DecColaYr10=0;
        
        Decimal DecFXMob=0;
        Decimal DecFXYr1=0;
        Decimal DecFXYr2=0;
        Decimal DecFXYr3=0;
        Decimal DecFXYr4=0;
        Decimal DecFXYr5=0;
        Decimal DecFXYr6=0;
        Decimal DecFXYr7=0;
        Decimal DecFXYr8=0;
        Decimal DecFXYr9=0;
        Decimal DecFXYr10=0;
        
        Decimal DecCapitalMob=0;
        Decimal DecCapitalYr1=0;
        Decimal DecCapitalYr2=0;
        Decimal DecCapitalYr3=0;
        Decimal DecCapitalYr4=0;
        Decimal DecCapitalYr5=0;
        Decimal DecCapitalYr6=0;
        Decimal DecCapitalYr7=0;
        Decimal DecCapitalYr8=0;
        Decimal DecCapitalYr9=0;
        Decimal DecCapitalYr10=0;
        
        Decimal DecIndicativeMob=0;
        Decimal DecIndicativeYr1=0;
        Decimal DecIndicativeYr2=0;
        Decimal DecIndicativeYr3=0;
        Decimal DecIndicativeYr4=0;
        Decimal DecIndicativeYr5=0;
        Decimal DecIndicativeYr6=0;
        Decimal DecIndicativeYr7=0;
        Decimal DecIndicativeYr8=0;
        Decimal DecIndicativeYr9=0;
        Decimal DecIndicativeYr10=0;
                    
        if(opprBeancMarkSummaryList.size()>0){
            showSummary=true;
        }
        for(Opportunity_BenchMark_Summary__c tempObj:opprBeancMarkSummaryList){
            decTotCost1+=tempObj.Sum_of_Mob_cost__c;
            
            decTotCost2+=tempObj.Sum_of_RUN_Year1__c;
            decTotCost3+=tempObj.Sum_of_RUN_Year2__c;
            decTotCost4+=tempObj.Sum_of_RUN_Year3__c;
            decTotCost5+=tempObj.Sum_of_RUN_Year4__c;
            decTotCost6+=tempObj.Sum_of_RUN_Year5__c;
            decTotCost7+=tempObj.Sum_of_RUN_Year6__c;
            decTotCost8+=tempObj.Sum_of_RUN_Year7__c;
            decTotCost9+=tempObj.Sum_of_RUN_Year8__c;
            decTotCost10+=tempObj.Sum_of_RUN_Year9__c;
            decTotCost11+=tempObj.Sum_of_RUN_Year10__c;
            
            decTotCost12+=tempObj.Sum_of_Total_Cost__c;
            System.debug('decTotCost12 -- '+decTotCost12);
            System.debug('tempObj.Sum_of_Total_Cost__c -- '+tempObj.Sum_of_Total_Cost__c);
            System.debug('decTotCost13 -- '+decTotCost13);
            System.debug('tempObj.percent_of_costs__c-->' +tempObj.percent_of_costs__c);
            if(tempObj.percent_of_costs__c != NULL){
                tempObj.percent_of_costs__c=(tempObj.percent_of_costs__c*100).setScale(2)+0.00;
                decTotCost13+=tempObj.percent_of_costs__c;
            }
            else{ 
                decTotCost13 = 0.0;
            }
            decTotCost14+=tempObj.Sum_of_FTE_YR1__c;
            decTotCost15+=tempObj.Sum_of_FTE_YR2__c;
            decTotCost16+=tempObj.Sum_of_FTE_YR3__c;
            decTotCost17+=tempObj.Sum_of_FTE_YR4__c;
            decTotCost18+=tempObj.Sum_of_FTE_YR5__c;
            decTotCost19+=tempObj.Sum_of_FTE_YR6__c;
            decTotCost20+=tempObj.Sum_of_FTE_YR7__c;
            decTotCost21+=tempObj.Sum_of_FTE_YR8__c;
            decTotCost22+=tempObj.Sum_of_FTE_YR9__c;
            decTotCost23+=tempObj.Sum_of_FTE_YR10__c;

            if(tempObj.Total_FTE_all_years__c != NULL){
            decTotCost24+=tempObj.Total_FTE_all_years__c;}
            else 
                decTotCost24 = 0.0;
            
           // decTotCost24+=tempObj.Total_FTE_all_years__c;
            
           // decTotCost25+=tempObj.Average_cost_FTE_Full_deal__c;
            
            decTotCost26+=tempObj.Average_cost_FTE_YR_1_Mob__c;
            decTotCost27+=tempObj.Average_cost_FTE_YR_2__c;
            decTotCost28+=tempObj.Average_cost_FTE_YR_3__c;
            decTotCost29+=tempObj.Average_cost_FTE_YR_4__c;
            decTotCost30+=tempObj.Average_cost_FTE_YR_5__c;
            decTotCost31+=tempObj.Average_cost_FTE_YR_6__c;
            decTotCost32+=tempObj.Average_cost_FTE_YR_7__c;
            decTotCost33+=tempObj.Average_cost_FTE_YR_8__c;
            decTotCost34+=tempObj.Average_cost_FTE_YR_9__c;
            decTotCost35+=tempObj.Average_cost_FTE_YR_10__c;
        }
        totalCost1=formatCurrency(decTotCost1);
        totalCost2=formatCurrency(decTotCost2);
        totalCost3=formatCurrency(decTotCost3);
        totalCost4=formatCurrency(decTotCost4);                    
        totalCost5=formatCurrency(decTotCost5);
        totalCost6=formatCurrency(decTotCost6);
        totalCost7=formatCurrency(decTotCost7);
        totalCost8=formatCurrency(decTotCost8);
        totalCost9=formatCurrency(decTotCost9);
        totalCost10=formatCurrency(decTotCost10);
        totalCost11=formatCurrency(decTotCost11);
        totalCost12=formatCurrency(decTotCost12);
        
        totalCost13=String.valueOf(decTotCost13.setScale(2));
        totalCost14=String.valueOf(decTotCost14.setScale(2));
        totalCost15=String.valueOf(decTotCost15.setScale(2));                    
        totalCost16=String.valueOf(decTotCost16.setScale(2));
        totalCost17=String.valueOf(decTotCost17.setScale(2));
        totalCost18=String.valueOf(decTotCost18.setScale(2));
        totalCost19=String.valueOf(decTotCost19.setScale(2));
        totalCost20=String.valueOf(decTotCost20.setScale(2));
        totalCost21=String.valueOf(decTotCost21.setScale(2));
        totalCost22=String.valueOf(decTotCost22.setScale(2));
        totalCost23=String.valueOf(decTotCost23.setScale(2));
        totalCost24=String.valueOf(decTotCost24.setScale(2));
        
        totalCost25=formatCurrency(decTotCost25);                    
        totalCost26=formatCurrency(decTotCost26);
        totalCost27=formatCurrency(decTotCost27);
        totalCost28=formatCurrency(decTotCost28);
        totalCost29=formatCurrency(decTotCost29);
        totalCost30=formatCurrency(decTotCost30);
        totalCost31=formatCurrency(decTotCost31);
        totalCost32=formatCurrency(decTotCost32);
        totalCost33=formatCurrency(decTotCost33);
        totalCost34=formatCurrency(decTotCost34);
        totalCost35=formatCurrency(decTotCost35);
        
        
        List<Opportunity_Assumed_Contigency__c> assrdContgList = [select Mob_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c FROM Opportunity_Assumed_Contigency__c WHERE Opportunity__c =:OppId and Name='Assumed Contingency %'];
        if (assrdContgList.size() > 0) {
            for (Opportunity_Assumed_Contigency__c opprassrdCont : assrdContgList) {
                    assrdContg=opprassrdCont;
            }
            
            DecCostContMob=decTotCost1+(decTotCost1*assrdContg.Mob_All_years__c)/100;
            
            DecCostContYr1=decTotCost2+ (decTotCost2*assrdContg.Run_Year_1__c)/100;
            DecCostContYr2=decTotCost3+(decTotCost3*assrdContg.Run_Year_2__c)/100;
            DecCostContYr3=decTotCost4+(decTotCost4*assrdContg.Run_Year_3__c)/100;
            DecCostContYr4=decTotCost5+(decTotCost5*assrdContg.Run_Year_4__c)/100;
            DecCostContYr5=decTotCost6+(decTotCost6*assrdContg.Run_Year_5__c)/100;
            DecCostContYr6=decTotCost7+(decTotCost7*assrdContg.Run_Year_6__c)/100;
            DecCostContYr7=decTotCost8+(decTotCost8*assrdContg.Run_Year_7__c)/100;
            DecCostContYr8=decTotCost9+(decTotCost9*assrdContg.Run_Year_8__c)/100;
            DecCostContYr9=decTotCost10+(decTotCost10*assrdContg.Run_Year_9__c)/100;
            DecCostContYr10=decTotCost11+(decTotCost11*assrdContg.Run_Year_10__c)/100;

                    
            costContingMob=formatCurrency(DecCostContMob);                   
                    
            costContingYesr1=formatCurrency(DecCostContYr1);
            costContingYesr2=formatCurrency(DecCostContYr2);
            costContingYesr3=formatCurrency(DecCostContYr3);
            costContingYesr4=formatCurrency(DecCostContYr4);
            costContingYesr5=formatCurrency(DecCostContYr5);
            costContingYesr6=formatCurrency(DecCostContYr6);
            costContingYesr7=formatCurrency(DecCostContYr7);                    
            costContingYesr8=formatCurrency(DecCostContYr8);                    
            costContingYesr9=formatCurrency(DecCostContYr9);                    
            costContingYesr10=formatCurrency(DecCostContYr10);
                    
            costContingYesrTot=formatCurrency( DecCostContMob+DecCostContYr1+DecCostContYr2+DecCostContYr3+DecCostContYr4+DecCostContYr5
                                           +DecCostContYr6+DecCostContYr7+DecCostContYr8+DecCostContYr9+DecCostContYr10);
        }
        
        List<Opportunity_Assumed_Contigency__c> assrdColaList = [select Mob_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c FROM Opportunity_Assumed_Contigency__c WHERE Opportunity__c =:OppId and Name='Assumed Cola %'];
        
        if (assrdColaList.size() > 0) {
            Opportunity_Assumed_Contigency__c assrdCola=null;         
            for (Opportunity_Assumed_Contigency__c opprassrdCola : assrdColaList) {
                    assrdCola=opprassrdCola;
            }
            
            DecColaMob=DecCostContMob+(DecCostContMob*assrdCola.Mob_All_years__c)/100;
            
            DecColaYr1=DecCostContYr1+ (DecCostContYr1*assrdCola.Run_Year_1__c)/100;
            DecColaYr2=DecCostContYr2+(DecCostContYr2*assrdCola.Run_Year_2__c)/100;
            DecColaYr3=DecCostContYr3+(DecCostContYr3*assrdCola.Run_Year_3__c)/100;
            DecColaYr4=DecCostContYr4+(DecCostContYr4*assrdCola.Run_Year_4__c)/100;
            DecColaYr5=DecCostContYr5+(DecCostContYr5*assrdCola.Run_Year_5__c)/100;
            DecColaYr6=DecCostContYr6+(DecCostContYr6*assrdCola.Run_Year_6__c)/100;
            DecColaYr7=DecCostContYr7+(DecCostContYr7*assrdCola.Run_Year_7__c)/100;
            DecColaYr8=DecCostContYr8+(DecCostContYr8*assrdCola.Run_Year_8__c)/100;
            DecColaYr9=DecCostContYr9+(DecCostContYr9*assrdCola.Run_Year_9__c)/100;
            DecColaYr10=DecCostContYr10+(DecCostContYr10*assrdCola.Run_Year_10__c)/100;

                    
            plusColaMob=formatCurrency(DecColaMob);                   
                    
            plusColaYear1=formatCurrency(DecColaYr1);
            plusColaYear2=formatCurrency(DecColaYr2);
            plusColaYear3=formatCurrency(DecColaYr3);
            plusColaYear4=formatCurrency(DecColaYr4);
            plusColaYear5=formatCurrency(DecColaYr5);
            plusColaYear6=formatCurrency(DecColaYr6);
            plusColaYear7=formatCurrency(DecColaYr7);                    
            plusColaYear8=formatCurrency(DecColaYr8);                    
            plusColaYear9=formatCurrency(DecColaYr9);                    
            plusColaYear10=formatCurrency(DecColaYr10);
                    
            plusColaYearTot=formatCurrency( DecColaMob+DecColaYr1+DecColaYr2+DecColaYr3+DecColaYr4+DecColaYr5
                                                        +DecColaYr6+DecColaYr7+DecColaYr8+DecColaYr9+DecColaYr10);
            
         }        
        
        List<Opportunity_Assumed_Contigency__c> assrdFXList = [select Mob_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c FROM Opportunity_Assumed_Contigency__c WHERE Opportunity__c =:OppId and Name='Assumed FX Contingency %'];
        
        if (assrdFXList.size() > 0) {
            Opportunity_Assumed_Contigency__c assrdFX=null;         
            for (Opportunity_Assumed_Contigency__c listObj : assrdFXList) {
                    assrdFX=listObj;
            }
            
            DecFXMob=DecColaMob+(DecColaMob*assrdFX.Mob_All_years__c)/100;
              
            DecFXYr1=DecColaYr1+ (DecColaYr1*assrdFX.Run_Year_1__c)/100;
            DecFXYr2=DecColaYr2+(DecColaYr2*assrdFX.Run_Year_2__c)/100;
            DecFXYr3=DecColaYr3+(DecColaYr3*assrdFX.Run_Year_3__c)/100;
            DecFXYr4=DecColaYr4+(DecColaYr4*assrdFX.Run_Year_4__c)/100;
            DecFXYr5=DecColaYr5+(DecColaYr5*assrdFX.Run_Year_5__c)/100;
            DecFXYr6=DecColaYr6+(DecColaYr6*assrdFX.Run_Year_6__c)/100;
            DecFXYr7=DecColaYr7+(DecColaYr7*assrdFX.Run_Year_7__c)/100;
            DecFXYr8=DecColaYr8+(DecColaYr8*assrdFX.Run_Year_8__c)/100;
            DecFXYr9=DecColaYr9+(DecColaYr9*assrdFX.Run_Year_9__c)/100;
            DecFXYr10=DecColaYr10+(DecColaYr10*assrdFX.Run_Year_10__c)/100;

                    
            plusFxContgMob=formatCurrency(DecFXMob);                   
                    
            plusFxContgYear1=formatCurrency(DecFXYr1);
            plusFxContgYear2=formatCurrency(DecFXYr2);
            plusFxContgYear3=formatCurrency(DecFXYr3);
            plusFxContgYear4=formatCurrency(DecFXYr4);
            plusFxContgYear5=formatCurrency(DecFXYr5);
            plusFxContgYear6=formatCurrency(DecFXYr6);
            plusFxContgYear7=formatCurrency(DecFXYr7);                    
            plusFxContgYear8=formatCurrency(DecFXYr8);                    
            plusFxContgYear9=formatCurrency(DecFXYr9);                    
            plusFxContgYear10=formatCurrency(DecFXYr10);
                    
            plusFxContgYearTot=formatCurrency( DecFXMob+DecFXYr1+DecFXYr2+DecFXYr3+DecFXYr4+DecFXYr5
                                                        +DecFXYr6+DecFXYr7+DecFXYr8+DecFXYr9+DecFXYr10);
            
         }   
          
         List<Opportunity_Assumed_Contigency__c> capitalList = [select Mob_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c FROM Opportunity_Assumed_Contigency__c WHERE Opportunity__c =:OppId and Name='Assumed Capital Charges %'];
        
        if (capitalList.size() > 0) {
            Opportunity_Assumed_Contigency__c capital=null;         
            for (Opportunity_Assumed_Contigency__c listObj : capitalList) {
                    capital=listObj;
            }
            DecCapitalMob=(DecFXMob*capital.Mob_All_years__c)/100;
                                
            DecCapitalYr1=(DecFXYr1*capital.Run_Year_1__c)/100;
            DecCapitalYr2=(DecFXYr2*capital.Run_Year_2__c)/100;
            DecCapitalYr3=(DecFXYr3*capital.Run_Year_3__c)/100;
            DecCapitalYr4=(DecFXYr4*capital.Run_Year_4__c)/100;
            DecCapitalYr5=(DecFXYr5*capital.Run_Year_5__c)/100;
            DecCapitalYr6=(DecFXYr6*capital.Run_Year_6__c)/100;
            DecCapitalYr7=(DecFXYr7*capital.Run_Year_7__c)/100;
            DecCapitalYr8=(DecFXYr8*capital.Run_Year_8__c)/100;
            DecCapitalYr9=(DecFXYr9*capital.Run_Year_9__c)/100;
            DecCapitalYr10=(DecFXYr10*capital.Run_Year_10__c)/100;

                    
            capitalMob=formatCurrency(DecCapitalMob);                   
                    
            capitalYear1=formatCurrency(DecCapitalYr1);
            capitalYear2=formatCurrency(DecCapitalYr2);
            capitalYear3=formatCurrency(DecCapitalYr3);
            capitalYear4=formatCurrency(DecCapitalYr4);
            capitalYear5=formatCurrency(DecCapitalYr5);
            capitalYear6=formatCurrency(DecCapitalYr6);
            capitalYear7=formatCurrency(DecCapitalYr7);                    
            capitalYear8=formatCurrency(DecCapitalYr8);                    
            capitalYear9=formatCurrency(DecCapitalYr9);                    
            capitalYear10=formatCurrency(DecCapitalYr10);
                    
            capitalYearTot=formatCurrency( DecCapitalMob+DecCapitalYr1+DecCapitalYr2+DecCapitalYr3+DecCapitalYr4+DecCapitalYr5
                                                        +DecCapitalYr6+DecCapitalYr7+DecCapitalYr8+DecCapitalYr9+DecCapitalYr10);
            
         } 
          
         List<Opportunity_Assumed_Contigency__c> indicativeList = [select Mob_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c FROM Opportunity_Assumed_Contigency__c WHERE Opportunity__c =:OppId and Name='Assumed Margin %'];
        
         if (indicativeList.size() > 0) {
            Opportunity_Assumed_Contigency__c indicative=null;         
            for (Opportunity_Assumed_Contigency__c listObj : indicativeList) {
                    indicative=listObj;
            }
            DecIndicativeMob=(DecFXMob*100)/(100-indicative.Mob_All_years__c);
                                
            DecIndicativeYr1=(DecFXYr1*100)/(100-indicative.Run_Year_1__c);
            DecIndicativeYr2=(DecFXYr2*100)/(100-indicative.Run_Year_2__c);
            DecIndicativeYr3=(DecFXYr3*100)/(100-indicative.Run_Year_3__c);
            DecIndicativeYr4=(DecFXYr4*100)/(100-indicative.Run_Year_4__c);
            DecIndicativeYr5=(DecFXYr5*100)/(100-indicative.Run_Year_5__c);
            DecIndicativeYr6=(DecFXYr6*100)/(100-indicative.Run_Year_6__c);
            DecIndicativeYr7=(DecFXYr7*100)/(100-indicative.Run_Year_7__c);
            DecIndicativeYr8=(DecFXYr8*100)/(100-indicative.Run_Year_8__c);
            DecIndicativeYr9=(DecFXYr9*100)/(100-indicative.Run_Year_9__c);
            DecIndicativeYr10=(DecFXYr10*100)/(100-indicative.Run_Year_10__c);

                    
            indicativeMob=formatCurrency(DecIndicativeMob);                   
                    
            indicativeYear1=formatCurrency(DecIndicativeYr1);
            indicativeYear2=formatCurrency(DecIndicativeYr2);
            indicativeYear3=formatCurrency(DecIndicativeYr3);
            indicativeYear4=formatCurrency(DecIndicativeYr4);
            indicativeYear5=formatCurrency(DecIndicativeYr5);
            indicativeYear6=formatCurrency(DecIndicativeYr6);
            indicativeYear7=formatCurrency(DecIndicativeYr7);                    
            indicativeYear8=formatCurrency(DecIndicativeYr8);                    
            indicativeYear9=formatCurrency(DecIndicativeYr9);                    
            indicativeYear10=formatCurrency(DecIndicativeYr10);
                    
            indicativeYearTot=formatCurrency( DecIndicativeMob+DecIndicativeYr1+DecIndicativeYr2+DecIndicativeYr3+DecIndicativeYr4+DecIndicativeYr5
                                                        +DecIndicativeYr6+DecIndicativeYr7+DecIndicativeYr8+DecIndicativeYr9+DecIndicativeYr10);
            
         }    

    }
    private String formatCurrency(Decimal d) {
        d= Math.round(d);
        List<String> args = new String[]{'0','number','#,###,###'};
        String s = String.format(d.format(), args);
        return +s;
    }
   public void deleteData()
   {
       try{
       database.delete(toDelOpprBenchMarkData);
       database.delete(toDelBenchMarkoff);
       database.delete(toDelOpprBenchMarkoff);
       database.delete(toDelSumm);
       database.delete(toDelOppCont);
       database.delete(toDelOADM);
       database.delete(toDelPyramid);
       database.delete(lst_DocstoDel);
       }
       catch(exception e){
       system.debug('deleteData:'+e);
       throw(e);
       }
       
       }
       private decimal CleanseDecimal(String theWord){
        theWord=theWord.replaceAll(',','');
        theWord=theWord.replace('$','');
        theWord=theWord.replaceAll(' ','');
        theWord=theWord.replaceAll('%','');
        decimal num = decimal.valueOf(theWord.trim());
        return num;
        }
        private integer CleanseInt(String theWord){
        theWord=theWord.replaceAll(',','');
        theWord=theWord.replaceAll('$','');
        theWord=theWord.replaceAll(' ','');
        theWord=theWord.replaceAll('%','');
        integer num = integer.valueOf(theWord.trim());
        return num;
        }
        
        private List<Benchmark_Offering__c> populateOfferingExService(List<Opportunity_Offering_BenchMark_Data__c> lstbenchOff){
            List<Benchmark_Offering__c> benchmarkOffExServiceList=new List<Benchmark_Offering__c>();  
            for(Opportunity_Offering_BenchMark_Data__c OppOffBenchMark:lstbenchOff){
                boolean present=false; 
                for(Benchmark_Offering__c benchmarkOff:benchmarkOffExServiceList){
                    if(OppOffBenchMark.Sub_Service_Offering__c==benchmarkOff.Name){
                        present=true;
                    }   
                }
                if(!present){
                    Benchmark_Offering__c objToBeinsert=new Benchmark_Offering__c();
                    objToBeinsert.Opportunity_BenchMark_Data__c=benchOppId;
                    objToBeinsert.Name=OppOffBenchMark.Sub_Service_Offering__c;  
                    benchmarkOffExServiceList.add(objToBeinsert);
                }

            }
            return benchmarkOffExServiceList;
        } 
        
        private List<Opportunity_Offering_BenchMark_Data__c> rePopulateOffering(List<Benchmark_Offering__c> benchmarkOffExServiceList,List<Opportunity_Offering_BenchMark_Data__c> lstbenchOff){
            for(Benchmark_Offering__c benchmarkOff:benchmarkOffExServiceList){
                for(Opportunity_Offering_BenchMark_Data__c  OppOffBenchMark:lstbenchOff){
                    if(OppOffBenchMark.Sub_Service_Offering__c == benchmarkOff.Name){
                        OppOffBenchMark.Benchmark_Offering__c=benchmarkOff.Id;
                    }
                }
            }
            return lstbenchOff;
        }
        
         
        private String populateofferingList(String orgInScopeOff) {
            String newInScopeOff=''; 
            if (orgInScopeOff!= null && orgInScopeOff.trim()!=''){
                 String[] arrStr=orgInScopeOff.split(';');
                 for(String s:arrStr){
                     if(newInScopeOff!=''){
                        if(s!= null && s.trim()!=''){
                            newInScopeOff=newInScopeOff+';'+s; 
                        }
                     }else{
                         if(s!= null && s.trim()!=''){
                             newInScopeOff=s;
                         }
                     }    
                 }
                newInScopeOff=newInScopeOff;             
            }
            return newInScopeOff;         
        } 
}