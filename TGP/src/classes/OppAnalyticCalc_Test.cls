@IsTest(seeAllData = false)
public class OppAnalyticCalc_Test{
    
    public static Id getData(){
        
        Operating_Groups_Master__c oppOperatingGrup = UnitTestDatafactory.createOperatingGroup('India');
        Opportunity opp= UTIL_DataCreationForTestClass.getOpportunity(oppOperatingGrup);
        insert(opp);
        
        UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
        Offering_Master__c offMaster=UTIL_DataCreationForTestClass.getOfferingwithProcurement();
        offMaster.Service_Group__c = 'BPO';
        insert offMaster; 
        
        Offering_Name__c offCustomObj =UTIL_DataCreationForTestClass.getOfferingNamewithProcurement(offMaster);
        insert(offCustomObj);
        
        Solution_Scope__c solComp = UTIL_DataCreationForTestClass.getSolutionComp(opp,offMaster);
        solComp.Service_Group__c = 'BPO';
        insert(solComp);
        
        Services_Master__c serMaster= UTIL_DataCreationForTestClass.getServiceMasterWithoutALL(offMaster);
        insert(serMaster); 
        
        Service__c servObj = new Service__c(Solutionscope__c = solComp.id,services__c=serMaster.id);
        insert(servObj);
        
        System.debug('>>>>> ' + [SELECT ID, Service_Group__c FROM Solution_Scope__c WHERE Opportunity__c = :opp.id]);
        List<FTE_Details__c> fteList = new List<FTE_Details__c>();
        FTE_Details__c fteRec1;
        
        
        
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);            
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c = UtilConstants.PROGRAM_MANAGEMENT;
            fteRec1.Mob_Sub_Category__c = UtilConstants.PM_HCL;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c = UtilConstants.PROGRAM_MANAGEMENT;
            fteRec1.Mob_Sub_Category__c = UtilConstants.PM_LCL;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj); 
            fteRec1.Opportunity__c = solComp.Opportunity__c;   
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c = UtilConstants.ENABLE_PEOPLE;
            fteRec1.Mob_Sub_Category__c =UtilConstants.JB_NB_RC;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c = UtilConstants.ENABLE_PEOPLE;
            fteRec1.Mob_Sub_Category__c =UtilConstants.INDUCTION;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);   
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c = UtilConstants.ENABLE_PEOPLE;
            fteRec1.Mob_Sub_Category__c =UtilConstants.RECRUITMENT;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c = UtilConstants.ENABLE_PEOPLE;
            fteRec1.Mob_Sub_Category__c =UtilConstants.REBADGING;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);

            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj); 
            fteRec1.Opportunity__c = solComp.Opportunity__c;   
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.KNOWLEDGE_TRANSFER;
            fteRec1.Mob_Sub_Category__c =UtilConstants.Mob_KT_Cost_HCL;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);   
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.KNOWLEDGE_TRANSFER;
            fteRec1.Mob_Sub_Category__c =UtilConstants.Mob_KT_Cost_LCL;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.KNOWLEDGE_TRANSFER;
            fteRec1.Mob_Sub_Category__c =UtilConstants.TRAINING_ROOM_EPIPLEX_CHARGES;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            fteRec1.Opportunity__c = solComp.Opportunity__c;  
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.KNOWLEDGE_TRANSFER;
            fteRec1.Mob_Sub_Category__c =UtilConstants.KT_TRAVEL;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.CSC;
            fteRec1.Mob_Sub_Category__c =UtilConstants.OTHERS_ADDITIONAL_BACKGROUND_CHECKS_BGC;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.CSC;
            fteRec1.Mob_Sub_Category__c =UtilConstants.OTHERS_CAPABILITY_SPECIFIC_TOOLS_AND_ASSETS;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            fteRec1.Opportunity__c = solComp.Opportunity__c;  
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.CSC;
            fteRec1.Mob_Sub_Category__c =UtilConstants.OTHERS_SEAT_LOCKDOWN_REQUIREMENT;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj); 
            fteRec1.Opportunity__c = solComp.Opportunity__c;   
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.CSC;
            fteRec1.Mob_Sub_Category__c =UtilConstants.COMMUNICATIONS;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.CSC;
            fteRec1.Mob_Sub_Category__c =UtilConstants.SOLUTION_VALIDATION_TRAVEL_VISA_CHARGES;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.CSC;
            fteRec1.Mob_Sub_Category__c =UtilConstants.UNIT_SET_UP_ENCLOSED_BAY;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);   
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.CSC;
            fteRec1.Mob_Sub_Category__c = UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            fteRec1.Mob_Category__c =UtilConstants.TRANSFORMATION_COST;
            fteRec1.Mob_Sub_Category__c = UtilConstants.TRANSFORMATION_COST;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.SDO;
            //fteRec1.Mob_Category__c =UtilConstants.SDO;
            //fteRec1.Mob_Sub_Category__c = UtilConstants.TRANSFORMATION_COST;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);   
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.TECHNOLOGY;
            fteRec1.Service_Dev__c = UtilConstants.TECH_TOOLS ;
            fteRec1.Location_typeCode__c = '1';
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.TECHNOLOGY;
            fteRec1.Service_Dev__c = UtilConstants.TECH_TOOLS ;
            fteRec1.Location_typeCode__c = '3';
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.TECHNOLOGY;
            fteRec1.Service_Dev__c = UtilConstants.VOICE_DATA;
            fteRec1.Location_typeCode__c = '3';
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.BSS ;
            fteRec1.Mob_Category__c =UtilConstants.BSS;
            fteRec1.Service_Dev__c = UtilConstants.EDM;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);   
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.BSS ;
            fteRec1.Mob_Category__c =UtilConstants.BSS;
            fteRec1.Service_Dev__c = UtilConstants.SUPPORT_CENTER;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.BSS ;
            fteRec1.Mob_Category__c =UtilConstants.BSS;
            fteRec1.Service_Dev__c = UtilConstants.TOOLS;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);   
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.BSS ;
            fteRec1.Mob_Category__c =UtilConstants.BSS;
            fteRec1.Service_Dev__c = UtilConstants.BSS_CC;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.PMO ;
            fteRec1.Mob_Category__c =UtilConstants.PMO;
            fteRec1.Service_Dev__c= UtilConstants.CM;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            fteRec1.Opportunity__c = solComp.Opportunity__c;  
            fteRec1.Costing_Type__c = UtilConstants.PMO ;
            fteRec1.Mob_Category__c =UtilConstants.PMO;
            fteRec1.Service_Dev__c= UtilConstants.CFM;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);   
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.PMO ;
            fteRec1.Mob_Category__c =UtilConstants.PMO;
            fteRec1.Service_Dev__c= UtilConstants.OADM;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);   
            fteRec1.Opportunity__c = solComp.Opportunity__c; 
            fteRec1.Costing_Type__c = UtilConstants.PMO ;
            fteRec1.Mob_Category__c =UtilConstants.PMO;
            fteRec1.Service_Dev__c= UtilConstants.QAD;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            fteRec1 = new FTE_Details__c();
            fteRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);    
            fteRec1.Opportunity__c = solComp.Opportunity__c;
            fteRec1.Costing_Type__c = UtilConstants.PMO ;
            fteRec1.Mob_Category__c =UtilConstants.PMO;
            fteRec1.Service_Dev__c= UtilConstants.OTHER;
            fteRec1.M1__c =10;
            fteRec1.Mob_Totals__c = 90.0;
            fteList.add(fteRec1);
            
            
            
            /////////////////////////
            List<Other_Cost_details__c> ocdList = new List<Other_Cost_details__c>();
            
            Other_Cost_details__c ocdRec1;
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);          
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c = UtilConstants.PROGRAM_MANAGEMENT;
            ocdRec1.Mob_Sub_Category__c = UtilConstants.PM_HCL;
            ocdRec1.Cost_Type__c = UtilConstants.PAYROLL_COST;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c = UtilConstants.PROGRAM_MANAGEMENT;
            ocdRec1.Mob_Sub_Category__c = UtilConstants.PM_LCL;
            ocdRec1.Cost_Type__c = UtilConstants.PAYROLL_COST;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c = UtilConstants.PROGRAM_MANAGEMENT;
            //ocdRec1.Mob_Sub_Category__c = UtilConstants.PM_LCL;
            ocdRec1.Cost_Type__c = UtilConstants.DNP_COST;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c = UtilConstants.ENABLE_PEOPLE;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.JB_NB_RC;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c = UtilConstants.ENABLE_PEOPLE;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.INDUCTION;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c = UtilConstants.ENABLE_PEOPLE;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.RECRUITMENT;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c = UtilConstants.ENABLE_PEOPLE;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.REBADGING;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);

            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.KNOWLEDGE_TRANSFER;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.Mob_KT_Cost_HCL;
            ocdRec1.Cost_Type__c = UtilConstants.PAYROLL_COST;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.KNOWLEDGE_TRANSFER;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.Mob_KT_Cost_LCL;
            ocdRec1.Cost_Type__c = UtilConstants.PAYROLL_COST;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.KNOWLEDGE_TRANSFER;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.TRAINING_ROOM_EPIPLEX_CHARGES;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.KNOWLEDGE_TRANSFER;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.KT_TRAVEL;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.CSC;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.OTHERS_ADDITIONAL_BACKGROUND_CHECKS_BGC;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.CSC;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.OTHERS_CAPABILITY_SPECIFIC_TOOLS_AND_ASSETS;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.CSC;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.OTHERS_SEAT_LOCKDOWN_REQUIREMENT;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.CSC;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.COMMUNICATIONS;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.CSC;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.SOLUTION_VALIDATION_TRAVEL_VISA_CHARGES;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.CSC;
            ocdRec1.Mob_Sub_Category__c =UtilConstants.UNIT_SET_UP_ENCLOSED_BAY;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.CSC;
            ocdRec1.Mob_Sub_Category__c = UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.APPLICATION_MWB;
            ocdRec1.Mob_Category__c =UtilConstants.TRANSFORMATION_COST;
            ocdRec1.Mob_Sub_Category__c = UtilConstants.TRANSFORMATION_COST;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.SDO;
            //ocdRec1.Mob_Category__c =UtilConstants.SDO;
            //ocdRec1.Mob_Sub_Category__c = UtilConstants.TRANSFORMATION_COST;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.TECHNOLOGY;
            ocdRec1.Service_Dev__c = UtilConstants.TECH_TOOLS ;
            ocdRec1.cost_Type__c = UtilConstants.PAYROLL_COST;
            ocdRec1.Location_typeCode__c = '1';
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.TECHNOLOGY;
            ocdRec1.Service_Dev__c = UtilConstants.TECH_TOOLS ;
            ocdRec1.cost_Type__c = UtilConstants.PAYROLL_COST;
            ocdRec1.Location_typeCode__c = '3';
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.TECHNOLOGY;
            ocdRec1.Service_Dev__c = UtilConstants.TECH_TOOLS ;
            ocdRec1.cost_Type__c = UtilConstants.DNP_COST;
            ocdRec1.Location_typeCode__c = '3';
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.TECHNOLOGY;
            ocdRec1.Service_Dev__c = UtilConstants.VOICE_DATA;
            ocdRec1.cost_Type__c = UtilConstants.DNP_COST;
            ocdRec1.Location_typeCode__c = '3';
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.BSS ;
            ocdRec1.Mob_Category__c =UtilConstants.BSS;
            ocdRec1.Service_Dev__c = UtilConstants.SERVICE_MANAGEMENT;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.BSS ;
            ocdRec1.Mob_Category__c =UtilConstants.BSS;
            ocdRec1.Service_Dev__c = UtilConstants.EDM;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.BSS ;
            ocdRec1.Mob_Category__c =UtilConstants.BSS;
            ocdRec1.Service_Dev__c = UtilConstants.SUPPORT_CENTER;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.BSS ;
            ocdRec1.Mob_Category__c =UtilConstants.BSS;
            ocdRec1.Service_Dev__c = UtilConstants.TOOLS;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.BSS ;
            ocdRec1.Mob_Category__c =UtilConstants.BSS;
            ocdRec1.Service_Dev__c = UtilConstants.BSS_CC;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.PMO ;
            ocdRec1.Mob_Category__c =UtilConstants.PMO;
            ocdRec1.Service_Dev__c = UtilConstants.CM;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.PMO ;
            ocdRec1.Mob_Category__c =UtilConstants.PMO;
            ocdRec1.Service_Dev__c = UtilConstants.CFM;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.PMO ;
            ocdRec1.Mob_Category__c =UtilConstants.PMO;
            ocdRec1.Service_Dev__c = UtilConstants.OADM;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.PMO ;
            ocdRec1.Mob_Category__c =UtilConstants.PMO;
            ocdRec1.Service_Dev__c = UtilConstants.QAD;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);
            
            ocdRec1 = new Other_Cost_details__c(Opportunity__c = solComp.Opportunity__c,Service__c = servObj.Id, Sub_Service_Group__c  = solComp.Id);
            //ocdRec1 =  UTIL_DataCreationForTestClass.getFTEDetails(solComp,servObj);  
            ocdRec1.Costing_Type__c = UtilConstants.PMO ;
            ocdRec1.Mob_Category__c =UtilConstants.PMO;
            ocdRec1.Service_Dev__c = UtilConstants.OTHER;
            ocdRec1.M1__c =10;
            ocdRec1.Mob_Totals__c = 90.0;
            ocdList.add(ocdRec1);   
            
            
            UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
            
            insert ocdList;
            
            insert fteList;
            
            
            return opp.Id;
     }
     
     
     static testMethod void test(){
         Set<id> newFtes =new set<Id>() ;
         Set<Id> newOcds =new set<Id>() ;
         
            Id OppId =  getData();

            
            
            for(FTe_details__C fte :[SELECT Id, NAme FROM FTE_Details__C])
                newFtes.add(fte.id);
                
            for(Other_Cost_details__c  ocd :[SELECT Id, Name  FROM Other_Cost_details__c ] )    
                newOcds.add(ocd.Id);
                
            
            Test.startTest();
            //Id BnchId;
            //Set<Id> bnchSumId;
            
            UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
            System.debug('getLimitQueueableJobs' + Limits.getLimitQueueableJobs());
            System.enqueueJob(new OppAnalyticCalcQueue (newFtes ,newFtes , newOcds ,newOcds , null, null, null, null, null));
            //System.enqueueJob(new OppAnalyticCalcQueue (newFtes ,newFtes , newOcds ,newOcds , new Map<String, String>(), BnchId, BnchId, bnchSumId, bnchSumId));
            Opportunity Oppty  =[SELECT Id, Name FROM Opportunity WHERE ID = :oppId LIMIT 1];
            System.enqueueJob(new MobAnalyticsUtil(newFtes ,newFtes , newOcds ,newOcds , null, null, null, null, null,  Oppty  ));
            
            Test.StopTest();
         
         Opportunity oppUPd = [SELECT Id, PM_Cost_per_FTE__c, total_Mob_Cost__c   FROM Opportunity WHERE ID = :oppId  LIMIT 1];
         
          System.assertEquals(5850.0000, oppUpd.total_Mob_Cost__c);
          
          
             List<Service__c> svcList = [SELECT Id, Solutionscope__c,Solutionscope__r.Opportunity__c,
                 BPOTech_DNP_Cost_as_of_TtlMobCost__c, BPOTech_Pyrl_HCost_LocCost_as_of_TMC__c, BPOTech_Pyrl_LCost_LocCost_as_of_TMC__c, 
                 BPO_Tech_Costs_as_of_TtlMobCost__c, BPO_Technology_Costs_per_FTE__c, BSS_Cost_as_of_TtlMobCost__c, BSS_Cost_per_FTE__c, BSS_EDM_Cost_as_of_TtlMobCost__c, 
                 BSS_SC_Cost_as_of_TtlMobCost__c, BSS_SM_Cost_as_of_TtlMobCost__c, BSS_Tools_Cost_as_of_TtlMobCost__c, CS_Costs_BG_CheckCost_as_of_TtlMobCost__c, 
                 CS_Costs_Com_JrnyCost_as_of_TtlMobCost__c, CS_Costs_Seat_ReqCost_as_of_TtlMobCost__c, CS_Costs_Tools_Assets_Cost_as_of_TtlMob__c, CS_Costs_as_of_TtlMobCost__c, 
                 CS_Costs_per_FTE__c, Deal_PMO_CFM_Cost_as_of_TtlMobCost__c, Deal_PMO_CM_Cost_as_of_TtlMobCost__c, Deal_PMO_Cost_as_of_TtlMobCost__c, Deal_PMO_Cost_per_FTE__c,
                  Deal_PMO_OADM_Cost_as_of_TtlMobCost__c, Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost__c, Enbl_Ppl_Cost_as_of_TtlMobCost__c, Enbl_Ppl_Cost_per_FTE__c, 
                  Enbl_Ppl_InductionCost_as_of_TtlMobCost__c, Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC__c, Enbl_Ppl_RebadgingCost_as_of_TtlMobCost__c, 
                  Enbl_Ppl_RecruitCost_as_of_TtlMobCost__c, KT_Cost_as_of_TtlMobCost__c, KT_Cost_per_FTE__c, KT_MobPyrl_HCost_LocCost_as_of_TMC__c,
                   KT_MobPyrl_LCost_LocCost_as_of_TMC__c, KT_Rooms_EpiplexCost_as_of_TtlMobCost__c, KT_Travel_Costs_as_of_TtlMobCost__c, BPOTech_Tools_Assets_as_of_TtlMobCost__c, 
                   PM_Cost_as_of_TtlMobCost__c, PM_Cost_per_FTE__c, PM_DNP_Cost_as_of_TtlMobCost__c, PM_Pyrl_LCost_Loc_as_of_TtlMobCost__c, PM_Pyroll_HCost_Loc_as_of_TtlMobCost__c, 
                   Pre_Go_Live_Costs__c, Pre_Go_Live_Costs_as_of_TtlMobCost__c, Solution_Validation_Cost_as_of_TMC__c, Solution_Validation_Cost_per_FTE__c, Total_Mob_Cost_per_FTE__c, 
                   Transformation_Cost_as_of_TtlMobCost__c, Transformation_Cost_per_FTE__c, UnitSetup_BayCost_as_of_TtlMobCost__c, UnitSetup_DCN_Costs_as_of_TtlMobCost__c, 
                   Unit_Set_up_Cost_as_of_TtlMobCost__c, Unit_Set_up_Cost_per_FTE__c, FTE_Revenue__c, Other_Cost_Revenue__c, Payroll_Revenue_c__c, 
                   Deal_PMO_Other_Cst_as_of_Total_Mob_Cost__c, BSS_CCCostasBSS_CCCostas_ofTotal_MobCost__c, BPOTechVoice_Data_DNP_Cost_as_of_tota__c 
                  FROM Service__c WHERE Solutionscope__r.Opportunity__c = : OppId AND Solutionscope__r.Service_Group__c = 'BPO'  ];       
            System.assertEquals(18.0000, svcList[0].Solution_Validation_Cost_per_FTE__c);
           // System.debug('svcList  : '  +svcList)  ;
         
     }
    
}