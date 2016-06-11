/*
@Author : 
@name : VFC_Cost_Summary_Metrics 
@CreateDate : 
@Description : 
@Version : 
*/
public without sharing class VFC_Cost_Summary_Metrics {
     /**
     * @description       Constructor to initialize the Class variables.  
     * @param             NA
     * @return            void
     * @throws            NA
     */
    public VFC_Cost_Summary_Metrics(ApexPages.StandardController controller) {
        Apexpages.currentPage().getHeaders().put(UtilConstants.X_UA_COMPATIBLE, UtilConstants.IE_EDGE);
        benchOppId=ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        assrdContg=new Benchmark_Price_Parameter__c();//new Summary Code
        opprBeancMarkSummaryList=new List<BenchMark_Summary__c>();//new Summary Code
        
        
        
    }

    private String EMPTY_STRING= UtilConstants.EMPTY_STRING;
    //Summary Getter and Setters
    public static String isIncludeInBenchmark;
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
    
    public String totalCost0 {get; set;}
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
    public String sheetThrowingException= UtilConstants.EMPTY_STRING;
    public decimal Sum_Total_Cost = UtilConstants.DecZERO;
    public decimal Sum_Total_FTE = UtilConstants.DecZERO;
    public decimal sum_Lang = UtilConstants.DecZERO;
    public integer Count_Loc = UtilConstants.IntZERO;
    public decimal for_FTE_RANGE = UtilConstants.DecZERO;
    //public decimal sumPrimaryFTE = 0;
    //public decimal sumPrimaryFTEOff = 0;
    public decimal sumRebadged = UtilConstants.DecZERO;
    public integer sum_Onshore= UtilConstants.IntZERO;
    public integer sum_Nearshore= UtilConstants.IntZERO;
    public integer sum_Offshore= UtilConstants.IntZERO;
    public integer sum_Multiple= UtilConstants.IntZERO;
       
    
    public integer Count_Lang = UtilConstants.IntZERO;
    //public decimal sumPrimaryFTETotal = 0;
    public decimal sumYr1 = UtilConstants.DecZERO;
    public decimal sumYr2 = UtilConstants.DecZERO;
    public decimal sumYr3 = UtilConstants.DecZERO;
    public decimal sumYr4 = UtilConstants.DecZERO;
    public decimal sumYr5 = UtilConstants.DecZERO;
    public decimal sumYr6 = UtilConstants.DecZERO;
    public decimal sumYr7 = UtilConstants.DecZERO;
    public decimal sumYr8 = UtilConstants.DecZERO;
    public decimal sumYr9 = UtilConstants.DecZERO;
    public decimal sumYr10 = UtilConstants.DecZERO;
    public decimal sumLastYr = UtilConstants.DecZERO;    
        
    public String comments {get; set;}
    public Benchmark_Price_Parameter__c assrdContg {get; set;}//Code Commented
    public List<BenchMark_Summary__c> opprBeancMarkSummaryList{get; set;}//on Summary page
    
    public boolean showSummary{get; set;}
    public boolean includeinBenchmark{get; set;}
    public Transient Blob fileBody {get; set;}
    Transient Savepoint sp;
    
    //BenchMark Summary Location
    public List<BenchMark_Service_Location__c> lstServLocations{get; set;}
    //Summary Getter and Setters
        
    public id OppId {get; set;}
    public id benchOppId {get; set;}
    public List<attachment> doc_Upload {get; set;}
    public Opportunity BPO_Opp{get; set;}
    public Attachment lst_Docs {get; set;}//Code Commented
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
    List<String> allLines_Ser_Loc = new List<String>();
    public String allLines_Opportunity {get;set;}
    public String allLines_Offering {get;set;}
    public String allLines_Summary {get;set;}
    public String allLines_PriceParameter {get;set;}
    public String allLines_OADM {get;set;}
    public String allLines_PyramidRichness {get;set;}
    public String allLines_ServLocation {get;set;}
    public BenchMark__c bechmarkOpp;//Obj API Changes
    public List<BenchMark_Offering_Service__c> lstbenchOff {get; set;}//Obj API Changes
    public BenchMark_Offering_Service__c bechmarkOff;//Obj API Changes
    public Transient String Description{get;set;}
    public Benchmark_Price_Parameter__c Opp_Cont;//Obj API Changes
    public List<Benchmark_Price_Parameter__c> lstOppCont = new List<Benchmark_Price_Parameter__c>();//Code Commented
    public BenchMark_OADM_FTE__c Opp_OADM;
    public List<BenchMark_OADM_FTE__c> lstOADM = new List<BenchMark_OADM_FTE__c>();//API Changes
    public BenchMark_Summary__c bechmarkSummary;//Code Commneted
    public List<BenchMark_Summary__c> lstSummary =new List<BenchMark_Summary__c>();//Code Commneted
    public BenchMark_Level_Wise_FTE__c pyramidRichness;//Code Commented
    public List<BenchMark_Level_Wise_FTE__c> lstPyRichness =new List<BenchMark_Level_Wise_FTE__c>();//Code Commented
    //public List<BenchMark_Service_Location__c> lstServLocations =new List<BenchMark_Service_Location__c>();//Code Commented
    List<BenchMark__c> toDelOpprBenchMarkData =new List<BenchMark__c>();//Obj API Changes
    List<BenchMark_Service_Location__c> toDelBenchServLocData =new List<BenchMark_Service_Location__c>();//Obj API Changes
    List<Attachment>lst_DocstoDel=new List<Attachment>();
    List<opportunity_documents__c> lstOppDoc=new List<opportunity_documents__c>();
    
    public Map<String, Id> servSubServMap;
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
    public VFC_Cost_Summary_Metrics() {
       
        Apexpages.currentPage().getHeaders().put(UtilConstants.X_UA_COMPATIBLE, UtilConstants.IE_EDGE);
        OppId=ApexPages.currentPage().getParameters().get(UtilConstants.id_par);
        initializeData();
        getDocs();
        
        assrdContg=new Benchmark_Price_Parameter__c();//new Summary Code
        opprBeancMarkSummaryList=new List<BenchMark_Summary__c>();//new Summary Code
        lstServLocations = new List<BenchMark_Service_Location__c>();
    }
    
    /******************************
    Method Name: initializeData
    Description: 
    Paramenters: NA
    Return Value: NA
    ******************************
    */ 
    private Opportunity initializeData(){
        isDocuploaded = false;
        try{
            //BPO_Opp = [select TCV__c,Estimated_TCV__c from Opportunity where id=: OppId limit 1];
            BPO_Opp = [select id, name,SAP_OM_ID__c,Account.name,AccountId FROM Opportunity where id=: OppId limit 1];
            bechmarkOpp=[SELECT Id FROM BenchMark__c WHERE Opportunity__c =:OppId limit 1];      
            benchOppId=bechmarkOpp.id;
                
        }
        catch(Exception e){
            
        }
        return BPO_Opp;
    } 
    
     /******************************
    Method Name: getDocs()
    Description: 
    Paramenters: NA
    Return Value: NA
    ******************************
    */ 
    public Attachment getDocs(){
        try{
            lst_Docs = [select id,name,description,createdDate from Attachment where parentId=:benchoppId limit 1];
            if(lst_Docs!=null){
                isDocuploaded = true;
            }    
         }catch(Exception e){
             String sre = e.getMessage();
             
         }
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
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String proflieName = PROFILE[0].Name;
        if(proflieName.equals(UtilConstants.WORKBENCH_USER)  || proflieName.equals(UtilConstants.WORKBENCH_OPERATOR)|| proflieName.equals(UtilConstants.SYS_ADMIN)){
            //Do Nothing
        }else{
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You do not have sufficient Access');
            //ApexPages.addMessage(myMsg);
            return null;
        }
            
        boolean isInserted=false;
        isValidate = false;
        iserror = false;
            sp = Database.setSavepoint();
            try{
                bechmarkOpp = new BenchMark__c();//Obj API Changes
                lstbenchOff = new List<BenchMark_Offering_Service__c>();//Obj API Changes
                if(allLines_Opportunity != null){   
                    allLines_Opp = allLines_Opportunity.trim().split('\n');
                    if(allLines_Opp.size() <= 3){
                        //File with no data in Opportunity Tab
                        iserror = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_55);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                }
                if(allLines_Offering != null){    
                    
                    allLines_Off = allLines_Offering.trim().split(UtilConstants.NEW_LINE);
                    
                    if(allLines_Off.size() <= 3){
                        iserror = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_56);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                } 
                if(allLines_Summary != null){    
                    allLines_SWBsum = allLines_Summary.trim().split(UtilConstants.NEW_LINE);
                    if(allLines_SWBsum.size() <= 3){
                        iserror = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_57);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                } 
                if(allLines_PriceParameter != null){    
                    allLines_ppm = allLines_PriceParameter.trim().split(UtilConstants.NEW_LINE);
                    if(allLines_ppm.size() <= 4){
                        iserror = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_58);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                }
                if(allLines_OADM != null){    
                    allLines_swbOADM = allLines_OADM.trim().split(UtilConstants.NEW_LINE);
                    if(allLines_swbOADM.size() <= 3){
                        iserror = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_59);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                }
                if(allLines_PyramidRichness != null){    
                    allLines_Py_rich = allLines_PyramidRichness.trim().split(UtilConstants.NEW_LINE);
                    if(allLines_Py_rich.size() <= 3){
                        iserror = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_60);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                } 
                /////////////Rajdeep
                if(allLines_ServLocation != null){    
                    allLines_Ser_Loc = allLines_ServLocation.trim().split(UtilConstants.NEW_LINE);
                    if(allLines_Ser_Loc.size() <= 3){
                        iserror = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_61);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                }
                
                if(iserror != true){       
                    allLines_Opp = allLines_Opportunity.split(UtilConstants.NEW_LINE);
                    for(integer i = 3;i<allLines_Opp.size();i++){    
                        String[] inputvalues = new String[]{};
                        if(allLines_Opp[i].trim()!=''){
                            inputvalues = allLines_Opp[i].split('»');
                            if(inputvalues[0]!=''){
                                if(inputvalues[0].equals(BPO_Opp.SAP_OM_ID__c)){
                                    isValidate = true;
                                }
                                else{
                                    isValidate = false;
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, UtilConstants.PAGE_MSG_62);
                                    ApexPages.addMessage(myMsg);
                                    return null;
                                }
                            }
                            else if((BPO_Opp.Account.name.equals(inputvalues[1]))&&(BPO_Opp.name.equals(inputvalues[2]))){
                                isValidate = true;
                            }else{
                                isValidate = false;
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, UtilConstants.PAGE_MSG_63);
                                ApexPages.addMessage(myMsg);
                                return null;
                            }    
                        }
                    }
                } 
                if(isValidate == true){
                    insertOpp();
                    insertOffering();//Code Commented
                    insertSummary();//Code Commented
                    insertPriceParam();//Code Commented
                    insertOADM();//Code Commented
                    insertPyramidRichness();//Code Commented
                    insertServiceLocation();
                    insertDocument();//Code Commented
                    //call delete
                    deleteData();//Code Commented
                }  
                a1= null;
                fileBody=null;                               
            }catch(DMLException de){
                Database.rollback(sp);
                // ApexPages.addMessage(myMsg);
                a1= null;
                fileBody=null;
                return null;
            }catch(Exception e){
                Database.rollback(sp);
                String ErrorMessageToDisplay = UtilConstants.PAGE_MSG_64 + sheetThrowingException ;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, ErrorMessageToDisplay );
                ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
                ApexPages.addMessage(myMsg);
                ApexPages.addMessage(myMsg2);
                
                //System.debug('File Upload Exception:'+e.getMessage());
                a1= null;
                fileBody=null;
                return null;
            }
            
        //beanchMarkSummaryHome(); //Code Commented 
        getDocs();
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, UtilConstants.FILE_UPLOADED_SUCCESSFULLY);
        ApexPages.addMessage(myMsg); 
        return null; 
    }
    
    /******************************
    Method Name: insertOpp
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/    
    private void insertOpp(){    
        try{
            for(integer i = 3;i<allLines_Opp.size();i++){    
                String[] inputvalues = new String[]{};
                if(allLines_Opp[i].trim()!=UtilConstants.EMPTY_STRING){
                    inputvalues = allLines_Opp[i].split('»');
                    if((BPO_Opp.Account.name.equals(inputvalues[1]))||(BPO_Opp.name.equals(inputvalues[2]))){
                        iserror = false;
                    }else{
                        iserror = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, UtilConstants.PAGE_MSG_65);
                        ApexPages.addMessage(myMsg);
                    }
                    bechmarkOpp = new BenchMark__c();
                    if(inputvalues.size() != 0){
                        integer temp=inputvalues.size();
                        if(temp>=53){    
                            bechmarkOpp.Name=BPO_Opp.name+ UtilConstants.VFP_BENCHMARK_DATA;
                            if(inputvalues[0] !=null && inputvalues[0].trim() !=EMPTY_STRING){     
                                bechmarkOpp.SAP_OM_ID__c = inputvalues[0];
                            }
                            if(inputvalues[3] !=null && inputvalues[3].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Scenario__c = inputvalues[3];
                            }
                            if(inputvalues[4] !=null && inputvalues[4].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Version__c = inputvalues[4];
                            }
                            if(inputvalues[5] !=null && inputvalues[5].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Contract_Start_Date__c = date.parse(inputvalues[5].trim());
                            }
                            if(inputvalues[6] !=null && inputvalues[6].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Initial_Go_Live__c = date.parse(inputvalues[6].trim());
                            }
                            if(inputvalues[7] !=null && inputvalues[7].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Contract_End_Date__c = date.parse(inputvalues[7].trim());
                            }
                            if(inputvalues[8] !=null && inputvalues[8].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.SSM_Version__c = inputvalues[8];
                            }
                            if(inputvalues[10] !=null && inputvalues[10].trim() !=EMPTY_STRING){ 
                                if(inputvalues[10].equalsIgnoreCase('MULTI')){
                                    bechmarkOpp.Multi_Single_Offering__c = UtilConstants.MULTIPLE;    
                                }
                                else{
                                    bechmarkOpp.Multi_Single_Offering__c = inputvalues[10];
                                }
                            }
                            if(inputvalues[11] !=null && inputvalues[11].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Baseline_FTEs__c = CleanseDecimal(inputvalues[11]);//Need to Check later
                            }
                            if(inputvalues[12] !=null && inputvalues[12].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Onshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[12]);
                            }
                            if(inputvalues[13] !=null && inputvalues[13].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Nearshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[13]);
                            }
                            if(inputvalues[14] !=null && inputvalues[14].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Offshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[14]);
                            }
                            if(inputvalues[15] !=null && inputvalues[15].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Grand_Total_Cost__c = CleanseDecimal(inputvalues[15]);
                            }
                            if(inputvalues[16] !=null && inputvalues[16].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.SDO_Total_Cost__c = CleanseDecimal(inputvalues[16]);
                            }
                            if(inputvalues[17] !=null && inputvalues[17].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.BSS_Total_Cost__c = CleanseDecimal(inputvalues[17]);
                            }
                            if(inputvalues[18] !=null && inputvalues[18].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Service_Management_Total_Cost__c = CleanseDecimal(inputvalues[18]);
                            }
                            if(inputvalues[19] !=null && inputvalues[19].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Support_Center_Total_Cost__c = CleanseDecimal(inputvalues[19]);
                            }
                            if(inputvalues[20] !=null && inputvalues[20].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Electronic_Documentation_Mgmy_Total__c = CleanseDecimal(inputvalues[20]);//Need to Check Later
                            }
                            if(inputvalues[21] !=null && inputvalues[21].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Command_Center_Total_Cost__c = CleanseDecimal(inputvalues[21]);
                            }
                            if(inputvalues[22] !=null && inputvalues[22].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Technology_Total_Cost__c = CleanseDecimal(inputvalues[22]);
                            }
                            if(inputvalues[23] !=null && inputvalues[23].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Technology_Tools_Total_Cost__c = CleanseDecimal(inputvalues[23]);
                            }
                            if(inputvalues[24] !=null && inputvalues[24].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Voice_and_Data_Total_Cost__c = CleanseDecimal(inputvalues[24]);
                            }
                            if(inputvalues[25] !=null && inputvalues[25].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Mobilization_Total_Cost__c = CleanseInt(inputvalues[25]);
                            }
                            if(inputvalues[26] !=null && inputvalues[26].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.PMO_Total_Cost__c = CleanseInt(inputvalues[26]);
                            }
                            if(inputvalues[27] !=null && inputvalues[27].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.OADM_Total_Cost__c = CleanseInt(inputvalues[27]);
                            }
                            if(inputvalues[28] !=null && inputvalues[28].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.CFM_Total_Cost__c = CleanseInt(inputvalues[28]);
                            }
                            if(inputvalues[29] !=null && inputvalues[29].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.CM_Total_Cost__c = CleanseInt(inputvalues[29]);
                            }
                            if(inputvalues[30] !=null && inputvalues[30].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.QAD_Total_Cost__c = CleanseInt(inputvalues[30]);
                            }
                            if(inputvalues[47] !=null && inputvalues[47].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Mobilization_Contingency__c = CleanseDecimal(inputvalues[47]);
                            }
                            if(inputvalues[48] !=null && inputvalues[48].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Average_Run_Contingency__c = CleanseDecimal(inputvalues[48]);
                            }
                            if(inputvalues[49] !=null && inputvalues[49].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.CI__c = CleanseDecimal(inputvalues[49]);
                            }
                            if(inputvalues[50] !=null && inputvalues[50].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Transformation_Costs_consulting__c = CleanseInt(inputvalues[50]);
                            }
                            if(inputvalues[51] !=null && inputvalues[51].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Deal_Unlocked__c = boolean.valueof(inputvalues[51].trim());
                            }
                            if(inputvalues[52] !=null && inputvalues[52].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Deal_Data_Tables_Updated__c = boolean.valueof(inputvalues[52].trim());
                            }
                            if(inputvalues[53] !=null && inputvalues[53].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Pyramid_Richness_Year1__c = CleanseDecimal(inputvalues[53]);
                            }
                            if(inputvalues[54] !=null && inputvalues[54].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.BenchMark_Delivery_Location__c = inputvalues[54].trim();//Need to Check Later
                                Count_Loc = inputvalues[54].trim().split(UtilConstants.COMMA_STRING).size();
                                bechmarkOpp.Number_of_locations_where_scope_is_deliv__c  = Count_Loc;//Need to Check Later
                            }
                            if(inputvalues[55] !=null && inputvalues[55].trim() !=EMPTY_STRING){ 
                                bechmarkOpp.Languages__c = inputvalues[55].trim();
                                Count_Lang = inputvalues[55].trim().split(UtilConstants.COMMA_STRING).size();
                                if(Count_Lang == 1){
                                    bechmarkOpp.Count_of_Language__c = '1';//Need to Check Later
                                }
                                else if(Count_Lang == 2){
                                    bechmarkOpp.Count_of_Language__c = '2';//Need to Check Later
                                }
                                else if(Count_Lang >2){
                                    bechmarkOpp.Count_of_Language__c = '3+';//Need to Check Later
                                }else{
                                }
                            }
                            //Field Mapping For Data On Benchmark Search Page- START
                            integer day=UtilConstants.IntZERO;
                            if(bechmarkOpp.Contract_End_Date__c.day() >= bechmarkOpp.Contract_Start_Date__c.day()){
                                day=1;
                            }
                            if(bechmarkOpp.Onshore_Baseline_FTEs__c == null){
                                bechmarkOpp.Onshore_Baseline_FTEs__c=0.0;
                            }
                            if(bechmarkOpp.Nearshore_Baseline_FTEs__c == null){
                                bechmarkOpp.Nearshore_Baseline_FTEs__c=0.0;
                            }
                            if(bechmarkOpp.Initial_Go_Live__c.day() >= bechmarkOpp.Contract_Start_Date__c.day()){
                                day=1;
                            }
                            //Field Mapping For Data On Benchmark Search Page- END
                            bechmarkOpp.Opportunity__c=BPO_Opp.id;
                            bechmarkOpp.Client__c=BPO_Opp.AccountId;
                            
                        }
                    }
                }
            }
            if(BPO_Opp != null && BPO_Opp.id != null){
                toDelOpprBenchMarkData = [select id,Inc_in_BM_Report__c from BenchMark__c where Opportunity__c=:BPO_Opp.id];
                toDelBenchServLocData = [select id from BenchMark_Service_Location__c where BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__c=:benchOppId Limit 1];
                if(toDelOpprBenchMarkData.size() >0){
                    isIncludeInBenchmark = toDelOpprBenchMarkData[0].Inc_in_BM_Report__c;
                    bechmarkOpp.Inc_in_BM_Report__c = isIncludeInBenchmark;
                }
            }
            database.insert(bechmarkOpp);
            benchOppId=bechmarkOpp.id;
            
        }catch(DMLException de){
            throw(de);
        }
        catch(exception e){
            sheetThrowingException = UtilConstants.THROW_EXCEPTION;
            throw(e);
        }
    }
    
    /******************************
    Method Name: insertOffering
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/    
    
    private void insertOffering(){
        try{
            for(integer i = 3;i<allLines_Off.size();i++){   
                String[] inputvalues = new String[]{};
                inputvalues = allLines_Off[i].split('»');
                bechmarkOff = new BenchMark_Offering_Service__c();
                if(inputvalues.size() != 0){
                    integer temp=inputvalues.size();
                    if(temp>=10){    
                        if(inputvalues.size()>0 && inputvalues[0] !=null && inputvalues[0].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Costing_Type__c = inputvalues[0];
                        }
                        if(inputvalues.size()>1 && inputvalues[1] !=null && inputvalues[1].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Opportunity_Offering__c = inputvalues[1];
                            OfferingMaster.add(bechmarkOff.Opportunity_Offering__c);
                        }
                        if(inputvalues.size()>2 && inputvalues[2] !=null && inputvalues[2].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Name = inputvalues[2];
                        }
                        if(inputvalues.size()>3 && inputvalues[3] !=null && inputvalues[3].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Sum_of_Total_Cost__c = CleanseDecimal(inputvalues[3]);
                        }
                        if(inputvalues.size()>4 && inputvalues[4] !=null && inputvalues[4].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Sum_of_Average_FTEs__c = CleanseDecimal(inputvalues[4]);
                        }
                        if(inputvalues.size()>5 && inputvalues[5] !=null && inputvalues[5].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Average_of_Location_Definition__c = CleanseDecimal(inputvalues[5]);
                            if(bechmarkOff.Average_of_Location_Definition__c == 1){
                                sum_Onshore = sum_Nearshore+1;
                            }
                            else if(bechmarkOff.Average_of_Location_Definition__c == 2){
                                sum_Nearshore = sum_Nearshore+1;
                            }
                            else if(bechmarkOff.Average_of_Location_Definition__c == 3){
                                sum_Offshore = sum_Offshore+1;
                            }
                            else If(bechmarkOff.Average_of_Location_Definition__c == 0){
                                
                            }
                            else {
                                sum_Multiple = sum_Multiple+1;
                            }
                        }
                        if(inputvalues.size()>6 &&  inputvalues[6] !=null && inputvalues[6].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Count_of_Language__c = CleanseInt(inputvalues[6]);
                        }
                        if(inputvalues.size()>7 && inputvalues[7] !=null && inputvalues[7].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Average_of_FTE_Type__c = CleanseDecimal(inputvalues[7]);
                        }
                        if(inputvalues.size()>8 && inputvalues[8] !=null && inputvalues[8].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Sum_of_Baseline_FTEs__c = CleanseDecimal(inputvalues[8]);
                            if(bechmarkOff.Costing_Type__c.equals(UtilConstants.SDO)){
                                for_FTE_RANGE = for_FTE_RANGE + bechmarkOff.Sum_of_Baseline_FTEs__c;
                            }
                        }
                        if(inputvalues.size()>9 && inputvalues[9] !=null && inputvalues[9].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Average_of_Pyramid_Richness_Year_1__c = CleanseDecimal(inputvalues[9]);
                        }
                        if(inputvalues.size()>10 && inputvalues[10] !=null && inputvalues[10].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Sum_of_Final_Month_FTE__c = CleanseDecimal(inputvalues[10]);
                        }
                        if(inputvalues.size()>11 && inputvalues[11] !=null && inputvalues[11].trim() !=EMPTY_STRING){ 
                            bechmarkOff.No_of_Employees__c = CleanseDecimal(inputvalues[11]);
                        }  
                        if(inputvalues.size()>12 && inputvalues[12] !=null && inputvalues[12].trim() !=EMPTY_STRING){ 
                            bechmarkOff.No_of_Contractors__c = CleanseDecimal(inputvalues[12]);
                        }             
                        if(inputvalues.size()>13 && inputvalues[13] !=null && inputvalues[13].trim() !=EMPTY_STRING){ 
                            bechmarkOff.of_Headcount_Transferred_from_client__c = CleanseDecimal(inputvalues[13]);
                        }
                        if(inputvalues.size()>=14 && inputvalues[14] !=null && inputvalues[14].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Onshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[14]);
                        }
                        if(inputvalues.size()>=15 && inputvalues[15] !=null && inputvalues[15].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Offshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[15]);
                        }
                        if(inputvalues.size()>=16 && inputvalues[16] !=null && inputvalues[16].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Nearshore_Baseline_FTEs__c = CleanseDecimal(inputvalues[16]);
                        }
                        /*if(inputvalues.size()>17 && inputvalues[17] !=null && inputvalues[17].trim() !=EMPTY_STRING){ 
                            if(inputvalues[17].trim().equalsIgnoreCase('true')){
                                bechmarkOff.Language_Premium__c = true;    
                            }
                        }
                        if(inputvalues.size()>18 && inputvalues[18] !=null && inputvalues[18].trim() !=EMPTY_STRING){ 
                            bechmarkOff.DCN_Location__c = inputvalues[18];
                        }*/
                        if(inputvalues.size()>17 && inputvalues[17] !=null && inputvalues[17].trim() !=EMPTY_STRING){ 
                            bechmarkOff.Tech_Tool__c = inputvalues[17];
                        }
            
                        //bechmarkOff.Opportunity_BenchMark_Data__c=benchOppId;//Code is placed in between intermediate object
                        lstbenchOff.add(bechmarkOff);
                    }
                }
            }
            if(bechmarkOpp.Multi_Single_Offering__c.equals(UtilConstants.MULTIPLE)){
                for_FTE_RANGE = bechmarkOpp.Baseline_FTEs__c;
            } 
            
            //New Code Added
            List<Benchmark_Offerings__c> benchmarkOffExServiceList=populateOfferingExService(lstbenchOff);
            database.Insert(benchmarkOffExServiceList);
            lstbenchOff = rePopulateOffering(benchmarkOffExServiceList,lstbenchOff);
            //New Code Added
            
            database.Insert(lstbenchOff);
            ////System.debug('offering inserted'+lstbenchOff);
            
            lstbenchOff = [select id, Name, Opportunity_Offering__c from BenchMark_Offering_Service__c where BenchMark_Offering__r.BenchMark__c =:benchOppId Limit 1];
            Set<String> offeringName = new Set<String>();
            servSubServMap= new Map<String,Id>();
            for(BenchMark_Offering_Service__c off: lstbenchOff ){
                ////System.debug(off);
                offeringName.add(off.Opportunity_Offering__c);
                servSubServMap.put(off.Opportunity_Offering__c+'(+)'+off.Name,off.Id);
            }
            for(String s:OfferingMaster){
                OfferingNameList=OfferingNameList+UtilConstants.SEMICOLON_STRING+s+UtilConstants.SEMICOLON_STRING;
            }
            bechmarkOpp.Offerings__c=populateofferingList(OfferingNameList);
            database.update(bechmarkOpp);
            //('Offering me aaapka swagat hai2::');   
        }catch(DMLException de){
            //System.debug('insertoff DML EX:'+de);
            throw(de);
        }catch(exception e){
            sheetThrowingException = UtilConstants.PAGE_MSG_56;
            ////System.debug('insertOpp'+e);
            throw(e);
        }                             
    }
    
    /******************************
    Method Name: insertSummary
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/    

    private void insertSummary(){
        try{
            for(integer i = 3;i<allLines_SWBsum.size();i++){
                String[] inputvalues = new String[]{};
                inputvalues = allLines_SWBsum[i].split('»');
                bechmarkSummary = new BenchMark_Summary__c();
                if(inputvalues.size() != 0){
                   integer temp=inputvalues.size();
                   if(temp>=37){
                       if(inputvalues[0] !=null && inputvalues[0].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Costing_Type__c= inputvalues[0];//Field is Missing
                        }
                        if(inputvalues[1] !=null && inputvalues[1].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Offering__c = inputvalues[1];
                        }
                        if(inputvalues[2] !=null && inputvalues[2].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Service__c = inputvalues[2];
                        }
                        if(inputvalues[3] !=null && inputvalues[3].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_Transition_cost__c = CleanseDecimal(inputvalues[3]);//Field is Missing
                        }
                        if(inputvalues[4] !=null && inputvalues[4].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year1__c= CleanseDecimal(inputvalues[4]);
                        }
                        if(inputvalues[5] !=null && inputvalues[5].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year2__c = CleanseDecimal(inputvalues[5]);
                        }
                        if(inputvalues[6] !=null && inputvalues[6].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year3__c = CleanseDecimal(inputvalues[6]);
                        }
                        if(inputvalues[7] !=null && inputvalues[7].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year4__c = CleanseDecimal(inputvalues[7]);
                        }
                        if(inputvalues[8] !=null && inputvalues[8].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year5__c = CleanseDecimal(inputvalues[8]);
                        }
                        if(inputvalues[9] !=null && inputvalues[9].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year6__c = CleanseDecimal(inputvalues[9]);
                        }
                        if(inputvalues[10] !=null && inputvalues[10].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year7__c = CleanseDecimal(inputvalues[10]);
                        }
                        if(inputvalues[11] !=null && inputvalues[11].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year8__c = CleanseDecimal(inputvalues[11]);
                        }
                        if(inputvalues[12] !=null && inputvalues[12].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year9__c = CleanseDecimal(inputvalues[12]);
                        }
                        if(inputvalues[13] !=null && inputvalues[13].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_RUN_Year10__c = CleanseDecimal(inputvalues[13]);
                        }
                        if(inputvalues[14] !=null && inputvalues[14].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_Total_Cost__c = CleanseDecimal(inputvalues[14]);
                            Sum_Total_Cost = Sum_Total_Cost + bechmarkSummary.Sum_of_Total_Cost__c;
                        }
                        if(inputvalues[15] !=null && inputvalues[15].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR1__c = CleanseDecimal(inputvalues[15]);
                            sumYr1 = sumYr1 + bechmarkSummary.Sum_of_FTE_YR1__c;
                        }
                        if(inputvalues[16] !=null && inputvalues[16].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR2__c = CleanseDecimal(inputvalues[16]);
                            sumYr2 = sumYr2 + bechmarkSummary.Sum_of_FTE_YR2__c;
                        }
                        if(inputvalues[17] !=null && inputvalues[17].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR3__c = CleanseDecimal(inputvalues[17]);
                            sumYr3 = sumYr3 + bechmarkSummary.Sum_of_FTE_YR3__c;
                        }
                        if(inputvalues[18] !=null && inputvalues[18].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR4__c = CleanseDecimal(inputvalues[18]);
                            sumYr4 = sumYr4 + bechmarkSummary.Sum_of_FTE_YR4__c;
                        }
                        if(inputvalues[19] !=null && inputvalues[19].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR5__c = CleanseDecimal(inputvalues[19]);
                            sumYr5 = sumYr5 + bechmarkSummary.Sum_of_FTE_YR5__c;
                        }
                        if(inputvalues[20] !=null && inputvalues[20].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR6__c = CleanseDecimal(inputvalues[20]);
                            sumYr6 = sumYr6 + bechmarkSummary.Sum_of_FTE_YR6__c;
                        }
                        if(inputvalues[21] !=null && inputvalues[21].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR7__c = CleanseDecimal(inputvalues[21]);
                            sumYr7 = sumYr7 + bechmarkSummary.Sum_of_FTE_YR7__c;
                        }
                        if(inputvalues[22] !=null && inputvalues[22].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR8__c = CleanseDecimal(inputvalues[22]);
                            sumYr8 = sumYr8 + bechmarkSummary.Sum_of_FTE_YR8__c;
                        }
                        if(inputvalues[23] !=null && inputvalues[23].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR9__c = CleanseDecimal(inputvalues[23]);
                            sumYr9 = sumYr9 + bechmarkSummary.Sum_of_FTE_YR9__c;
                        }
                        if(inputvalues[24] !=null && inputvalues[24].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Sum_of_FTE_YR10__c = CleanseDecimal(inputvalues[24]);
                            sumYr10 = sumYr10 + bechmarkSummary.Sum_of_FTE_YR10__c;
                        }
                        if(inputvalues[25] !=null && inputvalues[25].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Total_FTE_all_years__c = CleanseDecimal(inputvalues[25]);
                            Sum_Total_FTE = Sum_Total_FTE + bechmarkSummary.Total_FTE_all_years__c;
                        }
                        if(inputvalues[26] !=null && inputvalues[26].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.percent_of_costs__c = CleanseDecimal(inputvalues[26]);
                        }
                        if(inputvalues[27] !=null && inputvalues[27].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_Full_deal__c = CleanseDecimal(inputvalues[27]);
                        }
                        if(inputvalues[28] !=null && inputvalues[28].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_1_Mob__c = CleanseDecimal(inputvalues[28]);
                        }
                        if(inputvalues[29] !=null && inputvalues[29].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_2__c = CleanseDecimal(inputvalues[29]);
                        }
                        if(inputvalues[30] !=null && inputvalues[30].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_3__c = CleanseDecimal(inputvalues[30]);
                        }
                        if(inputvalues[31] !=null && inputvalues[31].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_4__c = CleanseDecimal(inputvalues[31]);
                        }
                        if(inputvalues[32] !=null && inputvalues[32].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_5__c = CleanseDecimal(inputvalues[32]);
                        }
                        if(inputvalues[33] !=null && inputvalues[33].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_6__c = CleanseDecimal(inputvalues[33]);
                        }
                        if(inputvalues[34] !=null && inputvalues[34].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_7__c = CleanseDecimal(inputvalues[34]);
                        }
                        if(inputvalues[35] !=null && inputvalues[35].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_8__c = CleanseDecimal(inputvalues[35]);
                        }
                        if(inputvalues[36] !=null && inputvalues[36].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_9__c = CleanseDecimal(inputvalues[36]);
                        }
                        if(inputvalues[37] !=null && inputvalues[37].trim() !=EMPTY_STRING){ 
                            bechmarkSummary.Average_cost_FTE_YR_10__c = CleanseDecimal(inputvalues[37]);
                        }
                        bechmarkSummary.BenchMark__c=benchOppId;
                        if((bechmarkSummary.Costing_Type__c!=null) || (bechmarkSummary.Offering__c!=null) ||(bechmarkSummary.Service__c!=null))//To be checked later
                        lstSummary.add(bechmarkSummary);
                    } 
                }
            }            
            
            //System.debug('Check1');
            database.Insert(lstSummary);
            //System.debug('Check2');
        }catch(DMLException de){
            //System.debug('insertsumm DML EX:'+de);
            throw(de);
        }catch(exception e){
            sheetThrowingException = UtilConstants.PAGE_MSG_57;
            //System.debug('insertOpp'+e);
            throw(e);
        } 
    }
    
    /******************************
    Method Name: insertPriceParam
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    private void insertPriceParam(){
        try{
            for(integer i = 4;i<allLines_ppm.size();i++){
                String[] inputvalues = new String[]{};
                inputvalues = allLines_ppm[i].split('»');
                Opp_Cont= new Benchmark_Price_Parameter__c();
                
                if(inputvalues.size() != 0){
                    integer temp=inputvalues.size();
                    if(temp>=10){   
                        if(inputvalues[0] !=null && inputvalues[0].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Contignecy_Type__c = inputvalues[0].split(UtilConstants.AMPERSAND_OPRTR)[0].trim();
                        }
                        if(inputvalues[1] !=null && inputvalues[1].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Transition_All_years__c = integer.valueOf(inputvalues[1].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[2] !=null && inputvalues[2].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_1__c = integer.valueOf(inputvalues[2].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[3] !=null && inputvalues[3].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_2__c = integer.valueOf(inputvalues[3].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[4] !=null && inputvalues[4].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_3__c = integer.valueOf(inputvalues[4].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[5] !=null && inputvalues[5].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_4__c = integer.valueOf(inputvalues[5].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[6] !=null && inputvalues[6].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_5__c = integer.valueOf(inputvalues[6].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[7] !=null && inputvalues[7].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_6__c = integer.valueOf(inputvalues[7].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[8] !=null && inputvalues[8].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_7__c = integer.valueOf(inputvalues[8].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[9] !=null && inputvalues[9].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_8__c = integer.valueOf(inputvalues[9].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[10] !=null && inputvalues[10].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_9__c = integer.valueOf(inputvalues[10].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        if(inputvalues[11] !=null && inputvalues[11].trim() !=EMPTY_STRING){ 
                            Opp_Cont.Run_Year_10__c = integer.valueOf(inputvalues[11].split(UtilConstants.AMPERSAND_OPRTR)[0].trim());
                        }
                        
                        Opp_Cont.Opportunity__c=BPO_Opp.id;
                        Opp_Cont.BenchMark__c=benchOppId;
                        lstOppCont.add(Opp_Cont);
                    }
                }
            }
            database.Insert(lstOppCont);
            //System.debug('Price parameter inserted'+lstoppcont);
        }catch(DMLException de){
            //System.debug('insertoppcont DML EX:'+de);
            throw(de);
        }catch(exception e){
            sheetThrowingException = UtilConstants.PAGE_MSG_58;
            //System.debug('insertOpp'+e);
            throw(e);
        }
    }
    /******************************
    Method Name: insertOADM
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/               
    private void insertOADM(){ 
        try{
            for(integer i = 3;i<allLines_swbOADM.size();i++){   
                boolean insertRecord=false;
                String[] inputvalues = new String[]{};
                inputvalues = allLines_swbOADM[i].split('»');
                Opp_OADM= new BenchMark_OADM_FTE__c();
                if(inputvalues.size() != 0){
                    integer temp=inputvalues.size();
                    if(temp>=4){   
                        if(inputvalues.size()>0 && inputvalues[0] !=null && inputvalues[0].trim() !=EMPTY_STRING){ 
                            Opp_OADM.OADM_Costing_Type__c= inputvalues[0].trim();
                            insertRecord=true;
                        }
                        if(inputvalues.size()>1 && inputvalues[1] !=null && inputvalues[1].trim() !=EMPTY_STRING){ 
                           Opp_OADM.OADM_Service__c= inputvalues[1];
                        }
                        if(inputvalues.size()>2 && inputvalues[2] !=null && inputvalues[2].trim() !=EMPTY_STRING){ 
                            Opp_OADM.OADM_FTE_Location__c= inputvalues[2];
                        }
                        if(inputvalues.size()>3 && inputvalues[3] !=null && inputvalues[3].trim() !=EMPTY_STRING){ 
                            Opp_OADM.OADM_FTE_Level__c= inputvalues[3]; // Career Level Or FTE Level
                        }
                        if(inputvalues.size()>4 && inputvalues[4] !=null && inputvalues[4].trim() !=EMPTY_STRING){ 
                            Opp_OADM.OADM_FTEs__c= CleanseDecimal(inputvalues[4]);
                        }
                        if(insertRecord==true){
                            Opp_OADM.Opportunity__c = BPO_Opp.id;
                            Opp_OADM.BenchMark__c=benchOppId;
                            lstOADM.add(Opp_OADM);
                        }
                    }
                }
            }
            database.Insert(lstOADM);
        }catch(DMLException de){
            //System.debug('insertOADM DML EX:'+de);
            throw(de);
        }catch(exception e){
            sheetThrowingException = UtilConstants.PAGE_MSG_59;
            //System.debug('insertOpp'+e);
            throw(e);
        }
    }
                    
    /******************************
    Method Name: insertPyramidRichness
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/    
    private void insertPyramidRichness(){
        try{
            for(integer i = 3;i<allLines_Py_rich.size()-1;i++){
                String[] inputvalues = new String[]{};
                inputvalues = allLines_Py_rich[i].split('»');
                pyramidRichness = new BenchMark_Level_Wise_FTE__c();
                if(inputvalues.size() != 0){
                    integer temp=inputvalues.size();
                    if(temp>=2){    
                        if(inputvalues[0] !=null && inputvalues[0].trim() !=EMPTY_STRING){ 
                            pyramidRichness.PR_Value__c= CleanseDecimal(inputvalues[0]);
                        }
                        if(inputvalues[1] !=null && inputvalues[1].trim() !=EMPTY_STRING){ 
                            pyramidRichness.Level__c= inputvalues[1];
                        }
                        if(inputvalues[2] !=null && inputvalues[2].trim() !=EMPTY_STRING){ 
                            pyramidRichness.FTEs__c= CleanseDecimal(inputvalues[2]);
                        }
                        pyramidRichness.Opportunity__c = BPO_Opp.id;
                        pyramidRichness.BenchMark__c=benchOppId;
                        lstPyRichness.add(pyramidRichness);
                    }
                }
            }
            database.Insert(lstPyRichness);
        }catch(DMLException de){
            //System.debug('insertPyRich DML EX:'+de);
            throw(de);
        }catch(exception e){
            sheetThrowingException = UtilConstants.PAGE_MSG_60;
            //System.debug('insertOpp'+e);
            throw(e);
        }
    } 
    
    /******************************
    Method Name: insertServiceLocation
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/    
    private void insertServiceLocation(){
         try{
            List<CPR_Master__c> allCPRMstr=[select Active__c,CPR__c,DCN_Location__c,FTE_Maximum__c,FTE_Minimum__c,  Offering_Name__c,Service_Name__c from CPR_Master__c limit 999]; 
            Map<String,BenchMark_Offerings__c> offrMap=new Map<String,BenchMark_Offerings__c>();
            for(BenchMark_Offerings__c off:[Select id,Name,Baseline_FTE_Non_SDO__c,Baseline_FTE_SDO__c,Total_Offering_FTEs__c from BenchMark_Offerings__c where BenchMark__c =: benchOppId Limit 1]){
                offrMap.put(off.Name,off);
            }                    
            for(integer i = 3;i<allLines_Ser_Loc.size();i++){
                String[] inputvalues = new String[]{};
                inputvalues = allLines_Ser_Loc[i].split('»');
                BenchMark_Service_Location__c bnchServLoc = new BenchMark_Service_Location__c();
                if(inputvalues.size() != 0){
                    integer temp=inputvalues.size();
                    if(temp>=2){
                        
                        String servSubServ='';    
                        if(inputvalues[0] !=null && inputvalues[0].trim() !=EMPTY_STRING && inputvalues[1] !=null && inputvalues[1].trim() !=EMPTY_STRING ){ 
                            servSubServ=inputvalues[0]+'(+)'+inputvalues[1];
                            bnchServLoc.BenchMark_Offering_Service__c = servSubServMap.get(servSubServ);
                            
                            //System.debug('offrMap::::::'+offrMap);
                            BenchMark_Offerings__c off= offrMap.get(inputvalues[0]);
                            //System.debug('off::::::'+off);
                            if(off!=null){
                                for(CPR_Master__c cprMstr:allCPRMstr){
                                    if(cprMstr.Active__c==true){
                                        //System.debug('Inside1');
                                        if(cprMstr.Offering_Name__c ==inputvalues[0]){
                                            //System.debug('Inside2');
                                            if(cprMstr.Service_Name__c == inputvalues[1]){
                                                //System.debug('Inside3');
                                                if(cprMstr.DCN_Location__c ==inputvalues[2]){
                                                    //System.debug('Inside4');
                                                    if(cprMstr.FTE_Maximum__c >= off.Total_Offering_FTEs__c){
                                                        //System.debug('Inside5');
                                                        if(off.Total_Offering_FTEs__c >=cprMstr.FTE_Minimum__c){
                                                            //System.debug('Inside6');
                                                            bnchServLoc.CPR__c=cprMstr.CPR__c;
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } 
                                }/////
                            }
                            
                        }
                        if(inputvalues[2] !=null && inputvalues[2].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Name= inputvalues[2];
                        }
                        if(inputvalues[3] !=null && inputvalues[3].trim() !=EMPTY_STRING){ 
                            bnchServLoc.DCN_Location__c= inputvalues[3];
                        }
                        if(inputvalues[4] !=null && inputvalues[4].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Language_Premium__c= inputvalues[4];
                        }
                        
                        if(inputvalues[5] !=null && inputvalues[5].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Sum_of_Total_Cost__c=CleanseDecimal(inputvalues[5]);
                        }
                        
                        if(inputvalues[6] !=null && inputvalues[6].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Sum_of_Mob_cost__c=CleanseDecimal(inputvalues[6]);
                        }
                        if(inputvalues[7] !=null && inputvalues[7].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Sum_of_Total_FTE_Year__c= CleanseDecimal(inputvalues[7]);
                        }
                        if(inputvalues[8] !=null && inputvalues[8].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Sum_of_Total_SDO_RUN_Cost_FTE_Custom__c=CleanseDecimal(inputvalues[8]);
                        }
                        if(inputvalues[9] !=null && inputvalues[9].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Sum_of_Total_SDO_MOB_Cost_FTE_Custom__c=CleanseDecimal(inputvalues[9]);
                        }
                        if(inputvalues[10] !=null && inputvalues[10].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Total_SDO_Cost_less_Mob__c=CleanseDecimal(inputvalues[10]);
                        }
                        if(inputvalues[11] !=null && inputvalues[11].trim() !=EMPTY_STRING){ 
                            bnchServLoc.SDO_Cost_Per_FTE__c=CleanseDecimal(inputvalues[11]);
                        }
                        
                        if(inputvalues[12] !=null && inputvalues[12].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Tools_Cost_Per_FTE__c= CleanseDecimal(inputvalues[13]);
                        }
                        if(inputvalues[13] !=null && inputvalues[13].trim() !=EMPTY_STRING){ 
                            bnchServLoc.DVE_Cost_Per_FTE__c= CleanseDecimal(inputvalues[13]);
                        }
                        if(inputvalues[14] !=null && inputvalues[14].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Support_Center_Cost_Per_FTE__c= CleanseDecimal(inputvalues[14]);
                        }
                        if(inputvalues[15] !=null && inputvalues[15].trim() !=EMPTY_STRING){ 
                            bnchServLoc.SM_Cost_Per_FTE__c= CleanseDecimal(inputvalues[15]);
                        }
                        if(inputvalues[16] !=null && inputvalues[16].trim() !=EMPTY_STRING){ 
                            bnchServLoc.EDM_Cost_Per_FTE__c= CleanseDecimal(inputvalues[16]);
                        }
                        if(inputvalues[17] !=null && inputvalues[17].trim() !=EMPTY_STRING){ 
                            bnchServLoc.CC_Cost_Per_FTE__c= CleanseDecimal(inputvalues[17]);
                        }
                        if(inputvalues[18] !=null && inputvalues[18].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Mob_Cost_Per_FTE__c= CleanseDecimal(inputvalues[18]);
                        }
                        if(inputvalues[19] !=null && inputvalues[19].trim() !=EMPTY_STRING){ 
                            bnchServLoc.PMO_Cost_Per_FTE__c= CleanseDecimal(inputvalues[19]);
                        }
                        if(inputvalues[20] !=null && inputvalues[20].trim() !=EMPTY_STRING){ 
                            bnchServLoc.Total_Cost_per_FTE__c= CleanseDecimal(inputvalues[20]);
                        } 
                        
                        bnchServLoc.Active__c= true;                       
                        
                        lstServLocations.add(bnchServLoc);
                    }
                }
            }
            database.Insert(lstServLocations);
            
            /*for(BenchMark_Service_Location__c servLoc:lstServLocations){
                
                BenchMark_Offering_Service__c offServ = offServMap.get(servLoc.BenchMark_Offering_Service__c);
                //System.debug('offServ::::::'+offServ);
                //System.debug('offServ.BenchMark_Offering__c::::::'+offServ.BenchMark_Offering__c);
                //System.debug('offServ.BenchMark_Offering__r.Id::::::'+offServ.BenchMark_Offering__r.Id);
                BenchMark_Offerings__c off= offrMap.get(offServ.BenchMark_Offering__r.Id);
                for(CPR_Master__c cprMstr:allCPRMstr){
                    if(cprMstr.Active__c==true && cprMstr.Offering_Name__c ==off.Name && cprMstr.Service_Name__c == offServ.Name && cprMstr.DCN_Location__c ==servLoc.Name && cprMstr.FTE_Maximum__c >= off.Total_Offering_FTEs__c && off.Total_Offering_FTEs__c >=cprMstr.FTE_Minimum__c){
                        servLoc.CPR__c=cprMstr.CPR__c;
                        break;
                    }
                }
            }
            database.update(lstServLocations);*/
            
        }catch(DMLException de){
            //System.debug('insertPyRich DML EX:'+de);
            throw(de);
        }catch(exception e){
            sheetThrowingException = UtilConstants.PAGE_MSG_64;
            //System.debug('insertOpp'+e);
            throw(e);
        }   
    } 
    
    /******************************
    Method Name: insertDocument
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/                      
    private void insertDocument(){
        try{
            lst_DocstoDel = [select id from attachment where parentId =:benchoppId];
            lstOppDoc=[select id from opportunity_documents__c where opportunity__c=:BPO_Opp.id and type__c=: UtilConstants.BPO_TYPE LIMIT 1];
            a1 =  new attachment();
            if(dropFileName.length()>=79){
                a1.name=dropFileName.substring(0,75);
            }else{
                a1.name=dropFileName;
            }
            a1.body=fileBody;
            a1.parentId=benchoppId;    
            a1.description=Description;
            database.insert(a1);
            
            opportunity_documents__c oppDoc=new opportunity_documents__c();
            oppDoc.comments__c=Description;
            oppDoc.document__c=a1.name;
            oppDoc.Service_Group__c= UtilConstants.BPO;
            oppDoc.opportunity__c=BPO_Opp.id;
            oppDoc.modified_date__c=system.today();
            oppDoc.modified_by__c=UserInfo.getName();
            oppDoc.type__c= UtilConstants.BPO_TYPE;
            oppDoc.IsUserAddedDocument__c=true;
            oppDoc.link__c=System.URL.getSalesforceBaseUrl().toExternalForm()+ UtilConstants.VFP_SERVLET_URL +a1.Id;
            oppDoc.Client__c=BPO_Opp.Account.Id;
            database.insert(oppDoc);
            
            
            Cost_Summary_Document__c costSmryDoc=new Cost_Summary_Document__c();
            costSmryDoc.BenchMark__c=benchoppId;
            costSmryDoc.Comments__c=Description;
            costSmryDoc.Document_Name__c=a1.name;
            costSmryDoc.Opportunity_Documents__c=oppDoc.Id;
            costSmryDoc.Uploaded_On__c=system.today();
            
            database.insert(costSmryDoc);

            a1= null;
            fileBody=null;
            Description=null;
        }catch(DMLException de){
            //System.debug('insertdox DML EX:'+de);
            throw(de);
        }catch(exception e){
            //System.debug('insertOpp'+e);
            throw(e);
        }finally{
            a1=null;
            fileBody=null;
        }
    }
    /******************************
    Method Name: deleteData
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    private void deleteData(){
       try{
           database.delete(toDelBenchServLocData);
           database.delete(toDelOpprBenchMarkData);
           database.delete(lst_DocstoDel);
           database.delete(lstOppDoc);
       }catch(exception e){
           //System.debug('deleteData:'+e);
           throw(e);
       }
    }
    
    /******************************
    Method Name: CleanseDecimal
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    
    private decimal CleanseDecimal(String theWord){
        theWord=theWord.replaceAll(UtilConstants.COMMA_STRING, UtilConstants.EMPTY_STRING);
        theWord=theWord.replace(UtilConstants.DOLLOR, UtilConstants.EMPTY_STRING);
        theWord=theWord.replaceAll(UtilConstants.EMPTY_STRING,UtilConstants.EMPTY_STRING);
        theWord=theWord.replaceAll(UtilConstants.AMPERSAND_OPRTR,UtilConstants.EMPTY_STRING);
        decimal num = decimal.valueOf(theWord.trim());
        return num;
    }
    
    /******************************
    Method Name: CleanseInt
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    
    private integer CleanseInt(String theWord){
        theWord=theWord.replaceAll(',','');
        theWord=theWord.replaceAll('$','');
        theWord=theWord.replaceAll(' ','');
        theWord=theWord.replaceAll('%','');
        integer num = integer.valueOf(theWord.trim());
        return num;
    }
    
    /******************************
    Method Name: populateOfferingExService
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    
    private List<Benchmark_Offerings__c> populateOfferingExService(List<BenchMark_Offering_Service__c> lstbenchOff){
        List<Benchmark_Offerings__c> benchmarkOffExServiceList=new List<Benchmark_Offerings__c>();  
        for(BenchMark_Offering_Service__c OppOffBenchMark:lstbenchOff){
            boolean present=false; 
            for(Benchmark_Offerings__c benchmarkOff:benchmarkOffExServiceList){
                if(OppOffBenchMark.Opportunity_Offering__c.equals(benchmarkOff.Name)){
                    present=true;
                    
                    if(benchmarkOff.SDO_Services__c.trim().equals(UtilConstants.EMPTY_STRING))
                        benchmarkOff.SDO_Services__c=OppOffBenchMark.Name;
                    else
                        benchmarkOff.SDO_Services__c+=UtilConstants.SEMICOLON_STRING+OppOffBenchMark.Name;    
                    
                    if(OppOffBenchMark.Costing_Type__c.equals(UtilConstants.BSS)){
                        if(benchmarkOff.BSS_Services__c.trim().equals(UtilConstants.EMPTY_STRING))
                            benchmarkOff.BSS_Services__c=OppOffBenchMark.Name;
                        else
                            benchmarkOff.BSS_Services__c+=UtilConstants.SEMICOLON_STRING+OppOffBenchMark.Name;    
                    }
                    else if(OppOffBenchMark.Costing_Type__c.equals(UtilConstants.TECH)){
                       if(benchmarkOff.Technology_Tools__c!=null){
                        if(benchmarkOff.Technology_Tools__c.trim().equals(UtilConstants.EMPTY_STRING))
                            benchmarkOff.Technology_Tools__c=OppOffBenchMark.Tech_Tool__c;
                        else
                            benchmarkOff.Technology_Tools__c+=UtilConstants.SEMICOLON_STRING +OppOffBenchMark.Tech_Tool__c;    
                       }
                    }
                    
                }   
            }
            if(!present){
                Benchmark_Offerings__c objToBeinsert=new Benchmark_Offerings__c();
                objToBeinsert.BenchMark__c=benchOppId;
                objToBeinsert.Name=OppOffBenchMark.Opportunity_Offering__c;  
                
                objToBeinsert.BSS_Services__c= UtilConstants.EMPTY_STRING;
                objToBeinsert.SDO_Services__c= UtilConstants.EMPTY_STRING;
                objToBeinsert.Technology_Tools__c= UtilConstants.EMPTY_STRING;
                
                objToBeinsert.SDO_Services__c=OppOffBenchMark.Name;
                
                if(OppOffBenchMark.Costing_Type__c.equals(UtilConstants.BSS)){
                    objToBeinsert.BSS_Services__c=OppOffBenchMark.Name;
                }
                else if(OppOffBenchMark.Costing_Type__c.equals(UtilConstants.TECH)){
                    objToBeinsert.Technology_Tools__c=OppOffBenchMark.Tech_Tool__c;     
                }else{
                }
                benchmarkOffExServiceList.add(objToBeinsert);
            }

        }
        return benchmarkOffExServiceList;
    } 
    
    /******************************
    Method Name: rePopulateOffering
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
     
    private List<BenchMark_Offering_Service__c> rePopulateOffering(List<Benchmark_Offerings__c> benchmarkOffExServiceList,List<BenchMark_Offering_Service__c> lstbenchOff){
        for(Benchmark_Offerings__c benchmarkOff:benchmarkOffExServiceList){
            for(BenchMark_Offering_Service__c  OppOffBenchMark:lstbenchOff){
                if(OppOffBenchMark.Opportunity_Offering__c.equals(benchmarkOff.Name)){
                    OppOffBenchMark.Benchmark_Offering__c=benchmarkOff.Id;
                }
            }
        }
        return lstbenchOff;
    }
    
    /******************************
    Method Name: populateofferingList
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    
    private String populateofferingList(String orgInScopeOff) {
        String newInScopeOff=UtilConstants.EMPTY_STRING; 
        if (orgInScopeOff!= null && orgInScopeOff.trim()!=UtilConstants.EMPTY_STRING){
             String[] arrStr=orgInScopeOff.split(';');
             for(String s:arrStr){
                 if(newInScopeOff!=UtilConstants.EMPTY_STRING){
                    if(s!= null && s.trim()!=UtilConstants.EMPTY_STRING){
                        newInScopeOff=newInScopeOff+';'+s; 
                    }
                 }else{
                     if(s!= null && s.trim()!=UtilConstants.EMPTY_STRING){
                         newInScopeOff=s;
                     }
                 }    
             }
            newInScopeOff=newInScopeOff;             
        }
        return newInScopeOff;         
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
        opprBeancMarkSummaryList = [select Costing_Type__c,Service__c,Offering__c,Sum_of_Transition_cost__c,Sum_of_Transformation_Cost__c, Sum_of_RUN_Year1__c,Sum_of_RUN_Year2__c,
                                Sum_of_RUN_Year3__c,Sum_of_RUN_Year4__c,Sum_of_RUN_Year5__c,Sum_of_RUN_Year6__c,Sum_of_RUN_Year7__c,Sum_of_RUN_Year8__c,
                                Sum_of_RUN_Year9__c,Sum_of_RUN_Year10__c,Sum_of_Total_Cost__c,Sum_of_FTE_YR1__c,Sum_of_FTE_YR2__c,Sum_of_FTE_YR3__c,
                                Sum_of_FTE_YR4__c,Sum_of_FTE_YR5__c,Sum_of_FTE_YR6__c,Sum_of_FTE_YR7__c,Sum_of_FTE_YR8__c,Sum_of_FTE_YR9__c,Sum_of_FTE_YR10__c,
                                Total_FTE_all_years__c,percent_of_costs__c,Average_cost_FTE_Full_deal__c,Average_cost_FTE_YR_1_Mob__c,Average_cost_FTE_YR_2__c,
                                Average_cost_FTE_YR_3__c,Average_cost_FTE_YR_4__c,Average_cost_FTE_YR_5__c,Average_cost_FTE_YR_6__c,Average_cost_FTE_YR_7__c,
                                Average_cost_FTE_YR_8__c,Average_cost_FTE_YR_9__c,Average_cost_FTE_YR_10__c 
                                FROM BenchMark_Summary__c WHERE BenchMark__c =:benchOppId ORDER BY Costing_Type__c, Offering__c, Service__c ASC LIMIT 100 ];
        //System.debug('~~~~~~~'+opprBeancMarkSummaryList);
        
        Decimal decTotCost0= UtilConstants.DecZERO;
        Decimal decTotCost1= UtilConstants.DecZERO;                    
        Decimal decTotCost2= UtilConstants.DecZERO;
        Decimal decTotCost3= UtilConstants.DecZERO;
        Decimal decTotCost4= UtilConstants.DecZERO;
        Decimal decTotCost5= UtilConstants.DecZERO;
        Decimal decTotCost6= UtilConstants.DecZERO;
        Decimal decTotCost7= UtilConstants.DecZERO;
        Decimal decTotCost8= UtilConstants.DecZERO;
        Decimal decTotCost9= UtilConstants.DecZERO;
        Decimal decTotCost10= UtilConstants.DecZERO;
        Decimal decTotCost11= UtilConstants.DecZERO;
        Decimal decTotCost12= UtilConstants.DecZERO;
        
        Decimal decTotCost13= UtilConstants.DecZERO;                    
        Decimal decTotCost14= UtilConstants.DecZERO;
        Decimal decTotCost15= UtilConstants.DecZERO;
        Decimal decTotCost16= UtilConstants.DecZERO;
        Decimal decTotCost17= UtilConstants.DecZERO;
        Decimal decTotCost18= UtilConstants.DecZERO;
        Decimal decTotCost19= UtilConstants.DecZERO;
        Decimal decTotCost20= UtilConstants.DecZERO;
        Decimal decTotCost21= UtilConstants.DecZERO;
        Decimal decTotCost22= UtilConstants.DecZERO;
        Decimal decTotCost23= UtilConstants.DecZERO;
        Decimal decTotCost24= UtilConstants.DecZERO;
        Decimal decTotCost25= UtilConstants.DecZERO;
        Decimal decTotCost26= UtilConstants.DecZERO;
        Decimal decTotCost27= UtilConstants.DecZERO;
        Decimal decTotCost28= UtilConstants.DecZERO;
        Decimal decTotCost29= UtilConstants.DecZERO;
        Decimal decTotCost30= UtilConstants.DecZERO;
        Decimal decTotCost31= UtilConstants.DecZERO;
        Decimal decTotCost32= UtilConstants.DecZERO;
        Decimal decTotCost33= UtilConstants.DecZERO;
        Decimal decTotCost34= UtilConstants.DecZERO;
        Decimal decTotCost35= UtilConstants.DecZERO;
        
        Decimal DecCostContMob= UtilConstants.DecZERO;
        Decimal DecCostContYr1= UtilConstants.DecZERO;
        Decimal DecCostContYr2= UtilConstants.DecZERO;
        Decimal DecCostContYr3= UtilConstants.DecZERO;
        Decimal DecCostContYr4= UtilConstants.DecZERO;
        Decimal DecCostContYr5= UtilConstants.DecZERO;
        Decimal DecCostContYr6= UtilConstants.DecZERO;
        Decimal DecCostContYr7= UtilConstants.DecZERO;
        Decimal DecCostContYr8= UtilConstants.DecZERO;
        Decimal DecCostContYr9= UtilConstants.DecZERO;
        Decimal DecCostContYr10= UtilConstants.DecZERO;
        
        Decimal DecColaMob= UtilConstants.DecZERO;
        Decimal DecColaYr1= UtilConstants.DecZERO;
        Decimal DecColaYr2= UtilConstants.DecZERO;
        Decimal DecColaYr3= UtilConstants.DecZERO;
        Decimal DecColaYr4= UtilConstants.DecZERO;
        Decimal DecColaYr5= UtilConstants.DecZERO;
        Decimal DecColaYr6= UtilConstants.DecZERO;
        Decimal DecColaYr7= UtilConstants.DecZERO;
        Decimal DecColaYr8= UtilConstants.DecZERO;
        Decimal DecColaYr9= UtilConstants.DecZERO;
        Decimal DecColaYr10= UtilConstants.DecZERO;
        
        Decimal DecFXMob= UtilConstants.DecZERO;
        Decimal DecFXYr1= UtilConstants.DecZERO;
        Decimal DecFXYr2= UtilConstants.DecZERO;
        Decimal DecFXYr3= UtilConstants.DecZERO;
        Decimal DecFXYr4= UtilConstants.DecZERO;
        Decimal DecFXYr5= UtilConstants.DecZERO;
        Decimal DecFXYr6= UtilConstants.DecZERO;
        Decimal DecFXYr7= UtilConstants.DecZERO;
        Decimal DecFXYr8= UtilConstants.DecZERO;
        Decimal DecFXYr9= UtilConstants.DecZERO;
        Decimal DecFXYr10= UtilConstants.DecZERO;
        
        Decimal DecCapitalMob= UtilConstants.DecZERO;
        Decimal DecCapitalYr1= UtilConstants.DecZERO;
        Decimal DecCapitalYr2= UtilConstants.DecZERO;
        Decimal DecCapitalYr3= UtilConstants.DecZERO;
        Decimal DecCapitalYr4= UtilConstants.DecZERO;
        Decimal DecCapitalYr5= UtilConstants.DecZERO;
        Decimal DecCapitalYr6= UtilConstants.DecZERO;
        Decimal DecCapitalYr7= UtilConstants.DecZERO;
        Decimal DecCapitalYr8= UtilConstants.DecZERO;
        Decimal DecCapitalYr9= UtilConstants.DecZERO;
        Decimal DecCapitalYr10= UtilConstants.DecZERO;
        
        Decimal DecIndicativeMob= UtilConstants.DecZERO;
        Decimal DecIndicativeYr1= UtilConstants.DecZERO;
        Decimal DecIndicativeYr2= UtilConstants.DecZERO;
        Decimal DecIndicativeYr3= UtilConstants.DecZERO;
        Decimal DecIndicativeYr4= UtilConstants.DecZERO;
        Decimal DecIndicativeYr5= UtilConstants.DecZERO;
        Decimal DecIndicativeYr6= UtilConstants.DecZERO;
        Decimal DecIndicativeYr7= UtilConstants.DecZERO;
        Decimal DecIndicativeYr8= UtilConstants.DecZERO;
        Decimal DecIndicativeYr9= UtilConstants.DecZERO;
        Decimal DecIndicativeYr10= UtilConstants.DecZERO;
                    
        if(opprBeancMarkSummaryList.size()>0){
            showSummary=true;
        }
        for(BenchMark_Summary__c tempObj:opprBeancMarkSummaryList){
            decTotCost0+=tempObj.Sum_of_Transformation_Cost__c;
            decTotCost1+=tempObj.Sum_of_Transition_cost__c;
            
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
            //System.debug('decTotCost12 -- '+decTotCost12);
            //System.debug('tempObj.Sum_of_Total_Cost__c -- '+tempObj.Sum_of_Total_Cost__c);
            //System.debug('decTotCost13 -- '+decTotCost13);
            //System.debug('tempObj.percent_of_costs__c-->' +tempObj.percent_of_costs__c);
            if(tempObj.percent_of_costs__c != NULL){
                //tempObj.percent_of_costs__c=(tempObj.percent_of_costs__c*100).setScale(2)+0.00;
                tempObj.percent_of_costs__c=(tempObj.percent_of_costs__c).setScale(2)+0.00;
                decTotCost13+=tempObj.percent_of_costs__c;
            }
            else{ 
                decTotCost13 = 0.0;
            }
            if(tempObj.Costing_Type__c=='SDO'){ //added as part of SWB Ticket-563
                
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
            }

            if(tempObj.Total_FTE_all_years__c != NULL){
            decTotCost24+=tempObj.Total_FTE_all_years__c;}
            else 
                decTotCost24 = 0.0;
            
           //decTotCost24+=tempObj.Total_FTE_all_years__c;
            
           //decTotCost25+=tempObj.Average_cost_FTE_Full_deal__c;
            
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
        
        System.debug('decTotCost35 ->  ' + decTotCost1);
        
        
        totalCost0=formatCurrency(decTotCost0);
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
        
        System.debug('dtotalsTotCost35 -> '  + totalCost1);
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
        
        
        List<Benchmark_Price_Parameter__c> assrdContgList = [select Transition_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,
                                                    Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c 
                                                    FROM Benchmark_Price_Parameter__c 
                                                    WHERE Benchmark__c =:benchOppId and (Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE8 OR Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE9) LIMIT 1];
        if (assrdContgList.size() > 0) {
            for (Benchmark_Price_Parameter__c opprassrdCont : assrdContgList) {
                    assrdContg=opprassrdCont;
            }            
            DecCostContMob=decTotCost1+(decTotCost1*assrdContg.Transition_All_years__c)/100;
            
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
        
        List<Benchmark_Price_Parameter__c> assrdColaList = [select Transition_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,
                                                        Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c 
                                                        FROM Benchmark_Price_Parameter__c 
                                                        WHERE benchmark__c =:benchOppId and (Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE6 OR Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE7)];
        
        if (assrdColaList.size() > 0) {
            Benchmark_Price_Parameter__c assrdCola=null;         
            for (Benchmark_Price_Parameter__c opprassrdCola : assrdColaList) {
                    assrdCola=opprassrdCola;
            }
            
            DecColaMob=DecCostContMob+(DecCostContMob*assrdCola.Transition_All_years__c)/100;
            
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
        
        List<Benchmark_Price_Parameter__c> assrdFXList = [select Transition_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,Run_Year_4__c,
                                                        Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c 
                                                        FROM Benchmark_Price_Parameter__c 
                                                        WHERE benchmark__c =:benchOppId and (Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE4 OR Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE5)];
        
        if (assrdFXList.size() > 0) {
            Benchmark_Price_Parameter__c assrdFX=null;         
            for (Benchmark_Price_Parameter__c listObj : assrdFXList) {
                    assrdFX=listObj;
            }
            
            DecFXMob=DecColaMob+(DecColaMob*assrdFX.Transition_All_years__c)/100;
              
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
          
         List<Benchmark_Price_Parameter__c> capitalList = [select Transition_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,
                                                         Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c 
                                                         FROM Benchmark_Price_Parameter__c 
                                                         WHERE benchmark__c=:benchOppId and (Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE2 OR Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE3)];
        
        if (capitalList.size() > 0) {
            Benchmark_Price_Parameter__c capital=null;         
            for (Benchmark_Price_Parameter__c listObj : capitalList) {
                    capital=listObj;
            }
            DecCapitalMob=(DecFXMob*capital.Transition_All_years__c)/100;
                                
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
          
         List<Benchmark_Price_Parameter__c> indicativeList = [select Transition_All_years__c,Run_Year_1__c,Run_Year_2__c,Run_Year_3__c,
                                                             Run_Year_4__c,Run_Year_5__c,Run_Year_6__c,Run_Year_7__c,Run_Year_8__c,Run_Year_9__c,Run_Year_10__c 
                                                             FROM Benchmark_Price_Parameter__c 
                                                             WHERE benchmark__c =:benchOppId and (Contignecy_Type__c =: UtilConstants.CONTIGENCY_TYPE0  OR Contignecy_Type__c=: UtilConstants.CONTIGENCY_TYPE1)];
        
         if (indicativeList.size() > 0) {
            Benchmark_Price_Parameter__c indicative=null;         
            for (Benchmark_Price_Parameter__c listObj : indicativeList) {
                    indicative=listObj;
            }
            DecIndicativeMob=(DecFXMob*100)/(100-indicative.Transition_All_years__c);
                                
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
         
         
         lstServLocations = [SELECT Active__c,BenchMark_Offering_Service__r.Name, CC_Cost_Per_FTE__c,CPR__c,CreatedDate,DCN_Location__c,
                         DVE_Cost_Per_FTE__c,EDM_Cost_Per_FTE__c,Id,IsDeleted,Language_Premium__c,LastModifiedById,LastModifiedDate,
                         Mob_Cost_Per_FTE__c,Custom_Location__c,Name,OwnerId,PMO_Cost_Per_FTE__c,SDO_Cost_Per_FTE__c,
                         SM_Cost_Per_FTE__c,Sum_of_Total_FTE_Year__c,Support_Center_Cost_Per_FTE__c,SystemModstamp,Tools_Cost_Per_FTE__c,
                         Total_Cost_per_FTE__c,BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__r.SAP_OM_ID__c,
                         BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__r.Account.name,
                         BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__r.name,BenchMark_Offering_Service__r.Costing_Type__c 
                         FROM BenchMark_Service_Location__c where BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.id =:benchOppId ORDER BY BenchMark_Offering_Service__r.Name ASC]; 
        if(lstServLocations.size()>0){
            showSummary=true;
        } 
    }
    /******************************
    Method Name: formatCurrency
    Description: 
    Paramenters: Decimal d
    Return Value: String
    *******************************/
    private String formatCurrency(Decimal d) {
        d= d.round();
        List<String> args = new String[]{UtilConstants.ZERO,'number','###,###,###,###'};
        String s = String.format(d.format(), args);
        return +s;
    }
     /******************************
    Method Name: goToOpportunity
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public PageReference goToOpportunity()
    {
        Pagereference goToOpp = new Pagereference(UtilConstants.SLASH+OppId);
        goToOpp.setRedirect(true);
        return(goToOpp);
    
    }
    /******************************
    Method Name: goToBenchmark
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/
    public PageReference goToBenchmark()
    {
        if(benchOppId!=NULL){
            Pagereference goToBench = new Pagereference(UtilConstants.SLASH+benchOppId);
            goToBench.setRedirect(true);
            return(goToBench);
         }else{
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, UtilConstants.PAGE_MSG_66);
             ApexPages.addMessage(myMsg);
             return null;
         }
    }
}