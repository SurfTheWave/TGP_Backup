/*   @Author :  Divyashree C K
     @Name   : OppMobAnalyticCalc
     @CreateDate :  12th Aug 2015
     @Description  : Class to calculate Mob Analytics for Opportunity
     @Version : 1.0
  */
public without sharing class OppMobAnalyticCalc{
 /******************************
        Class Name: OppAnalyticsWrapper
        Description: Wrapper Class for storing Mob Analytcis metrics.
    *******************************/
    private  without sharing class OppAnalyticsWrapper{
        private String opportunityId;
        private Decimal total_Mob_Cost = 0;
        private Decimal total_SDO_FTE = 0;
        private Decimal total_Mob_PM_Cost = 0;
        private Decimal total_of_PM_Cost_HCL = 0;
        private Decimal total_of_PM_Cost_LCL = 0;
        private Decimal pM_DNP_Cost = 0;
        private Decimal total_EP_Cost = 0;
        private Decimal total_EP_JB_NB_RC_Cost = 0;
        private Decimal total_EP_Induction_Cost = 0;
        private Decimal total_EP_Recruitment_Cost = 0;
        private Decimal total_EP_Rebadging_Cost = 0;
        private Decimal total_KT_Cost = 0;
        private Decimal total_KT_mob_payroll_HCL_Cost = 0;
        private Decimal total_KT_mob_payroll_LCL_Cost = 0;
        private Decimal total_KT_training_rooms_and_epiplex_cost = 0;
        private Decimal total_KT_travel_cost = 0;
        private Decimal preGo_Live_Costs = 0;
        private Decimal total_BPO_Tech_Cost = 0;
        private Decimal total_BPO_Tech_HCL_cost = 0;
        private Decimal total_BPO_Tech_LCL_Cost = 0;
        private Decimal total_BPO_Tech_DNP_Cost = 0;
        private Decimal total_BPO_Tech_VND_Cost = 0;
        private Decimal total_BPO_Tech_standard_tools_and_asets_Cost = 0;
        private Decimal total_BSS_Cost = 0;
        private Decimal total_BSS_Service_Mgmt_Cost = 0;
        private Decimal total_BSS_EDM_Cost = 0;
        private Decimal total_BSS_SC_Cost = 0;
        private Decimal total_BSS_CC_Cost  = 0;
        private Decimal total_BSS_Tools_Cost = 0;
        private Decimal total_Deal_PMO_Cost = 0;
        private Decimal total_Deal_PMO_CM_Cost = 0;
        private Decimal total_Deal_PMO_CFM_Cost = 0;
        private Decimal total_Deal_PMO_QAD_Cost = 0;
        private Decimal total_Deal_PMO_OADM_Cost = 0;
        private Decimal total_Deal_PMO_OTHER_Cost =0;
        private Decimal total_CSC = 0;
        private Decimal total_CSC_Additional_Background_Checks_Cost = 0;
        private Decimal total_CSC_Capability_Specific_Tools_Assets_Cost = 0;
        private Decimal total_CSC_Seat_Lockdown_Requirements_Cost = 0;
        private Decimal total_CSC_Communication_Journey_Management_Cost = 0;
        private Decimal solution_Validation_Cost = 0;
        private Decimal total_Unit_Setup_Cost = 0;
        private Decimal total_Unit_Set_up_Enclosed_Bay_Cost = 0;
        private Decimal total_Unit_Set_up_DCN_Set_up_Costs = 0;
        private Decimal total_Transformation_Cost  = 0;
    }

    
     /******************************
        Method Name: calcAnalyticsOnOpp
        Description: method called from execute of Queueable
        Parameters: NA
        Return Value: Opportunity 
        *******************************/
    public static Opportunity calcAnalyticsOnOpp( set<Id> newFtes, set<id> newOcds){
        
        Set<Id> newFteList =new Set<id>( newFtes);
        Set<Id> newOcdList  =new Set <Id>( newOcds);
        
        //system.debug('newFteList '+newFteList );
        //system.debug('newOcdList '+newOcdList );
        
        oppAnalyticsWrapper wrapInst= new oppAnalyticsWrapper();
        //wrapInst.OpportunityId = oppId;
        
        wrapInst = populateFromFTE(wrapInst.OpportunityId, wrapInst, newFteList );
        
        System.debug('After FTE ' + wrapInst);
        wrapInst = populatefromCCS(wrapInst.OpportunityId, wrapInst, newOcdList  );
        
        System.debug('After CCS ' + wrapInst);
        Opportunity opp = new Opportunity(Id = wrapInst.OpportunityId);


        opp.Pre_Go_Live_Costs__c = (wrapInst.PreGo_Live_Costs).setScale(4);
        opp.total_Mob_Cost__c = (wrapInst.total_Mob_Cost).setScale(4);
        opp.total_SDO_FTE__c = (wrapInst.total_SDO_FTE).setScale(4);

        
            opp.PM_Cost_per_FTE__c = (wrapInst.total_SDO_FTE > 0 )? 
                                       (wrapInst.total_Mob_PM_Cost/wrapInst.total_SDO_FTE).setScale(4) : 0;
            opp.Enbl_Ppl_Cost_per_FTE__c =(wrapInst.total_SDO_FTE > 0 )? 
                                        (wrapInst.total_EP_Cost/wrapInst.total_SDO_FTE).setScale(4): 0;
            opp.KT_Cost_per_FTE__c= (wrapInst.total_SDO_FTE > 0 )? 
                                        (wrapInst.total_KT_Cost/wrapInst.total_SDO_FTE).setScale(4): 0;
            opp.BSS_Cost_per_FTE__c = (wrapInst.total_SDO_FTE > 0 )? 
                                        (wrapInst.total_BSS_Cost/wrapInst.total_SDO_FTE).setScale(4): 0;
            opp.Deal_PMO_Cost_per_FTE__c =(wrapInst.total_SDO_FTE > 0 )?  
                                        (wrapInst.total_Deal_PMO_Cost/wrapInst.total_SDO_FTE).setScale(4): 0;
            opp.CS_Costs_per_FTE__c = (wrapInst.total_SDO_FTE > 0 )? 
                                        (wrapInst.total_CSC/wrapInst.total_SDO_FTE).setScale(4): 0;
            opp.Transformation_Cost_per_FTE__c =(wrapInst.total_SDO_FTE > 0 )? 
                                            (wrapInst.total_Transformation_Cost/wrapInst.total_SDO_FTE).setScale(4): 0;
            opp.Solution_Validation_Cost_per_FTE__c =(wrapInst.total_SDO_FTE > 0 )? 
                                                    (wrapInst.Solution_Validation_Cost/wrapInst.total_SDO_FTE).setScale(4) : 0;
            opp.BPO_Technology_Costs_per_FTE__c = (wrapInst.total_SDO_FTE > 0 )? 
                                                (wrapInst.total_BPO_Tech_Cost/wrapInst.total_SDO_FTE).setScale(4): 0;
            opp.Pre_Go_Live_Costs_as_of_TtlMobCost__c  =(wrapInst.total_Mob_Cost > 0 )? 
                                                        (wrapInst.PreGo_Live_Costs*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.PM_Pyrl_LCost_Loc_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                                                    (wrapInst.total_of_PM_Cost_LCL*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.PM_Pyroll_HCost_Loc_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                                                        (wrapInst.total_of_PM_Cost_HCL*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.PM_DNP_Cost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                                                    (wrapInst.PM_DNP_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Enbl_Ppl_InductionCost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                                                    (wrapInst.total_EP_Induction_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC__c= (wrapInst.total_Mob_Cost > 0 )? 
                                        (wrapInst.total_EP_JB_NB_RC_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Enbl_Ppl_RebadgingCost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                        (wrapInst.total_EP_Rebadging_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Enbl_Ppl_RecruitCost_as_of_TtlMobCost__c  = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_EP_Recruitment_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.KT_MobPyrl_HCost_LocCost_as_of_TMC__c = (wrapInst.total_Mob_Cost > 0 )? 
                                ( wrapInst.total_KT_mob_payroll_HCL_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.KT_MobPyrl_LCost_LocCost_as_of_TMC__c = (wrapInst.total_Mob_Cost > 0 )?
                        (wrapInst.total_KT_mob_payroll_LCL_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.KT_Rooms_EpiplexCost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                        (wrapInst.total_KT_training_rooms_and_epiplex_cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.KT_Travel_Costs_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                        (wrapInst.total_KT_travel_cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BPOTech_DNP_Cost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_BPO_Tech_DNP_Cost*100/wrapInst.total_Mob_Cost).setScale(4): 0;
            opp.BPOTech_Pyrl_HCost_LocCost_as_of_TMC__c = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_BPO_Tech_HCL_cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BPOTech_Pyrl_LCost_LocCost_as_of_TMC__c = (wrapInst.total_Mob_Cost > 0 )? 
                        (wrapInst.total_BPO_Tech_LCL_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BPOTech_Tools_Assets_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )?
            (wrapInst.total_BPO_Tech_standard_tools_and_asets_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BPOTechVoice_Data_DNP_Cost_as_of_tota__c = (wrapInst.total_Mob_Cost > 0 ) ?
                                        (wrapInst.total_BPO_Tech_VND_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BSS_EDM_Cost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_BSS_EDM_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BSS_SC_Cost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_BSS_SC_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BSS_SM_Cost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_BSS_Service_Mgmt_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BSS_Tools_Cost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_BSS_Tools_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.BSS_CCCostas_ofTotal__c = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_BSS_CC_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Deal_PMO_CFM_Cost_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_Deal_PMO_CFM_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Deal_PMO_CM_Cost_as_of_TtlMobCost__c = (wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_Deal_PMO_CM_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Deal_PMO_OADM_Cost_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? (wrapInst.total_Deal_PMO_OADM_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? (wrapInst.total_Deal_PMO_QAD_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Deal_PMO_Other_Cst_as_of_Total_Mob_Cost__c=(wrapInst.total_Mob_Cost > 0 )? (wrapInst.total_Deal_PMO_OTHER_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.CS_Costs_BG_CheckCost_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? 
                        (wrapInst.total_CSC_Additional_Background_Checks_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.CS_Costs_Com_JrnyCost_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? 
                            (wrapInst.total_CSC_Communication_Journey_Management_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.CS_Costs_Seat_ReqCost_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? (wrapInst.total_CSC_Seat_Lockdown_Requirements_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.CS_Costs_Tools_Assets_Cost_as_of_TtlMob__c =(wrapInst.total_Mob_Cost > 0 )? (wrapInst.total_CSC_Capability_Specific_Tools_Assets_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.Solution_Validation_Cost_as_of_TMC__c =(wrapInst.total_Mob_Cost > 0 )? (wrapInst.Solution_Validation_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.UnitSetup_BayCost_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? (wrapInst.total_Unit_Set_up_Enclosed_Bay_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
            opp.UnitSetup_DCN_Costs_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? (wrapInst.total_Unit_Set_up_DCN_Set_up_Costs*100/wrapInst.total_Mob_Cost).setScale(4): 0;
            opp.Transformation_Cost_as_of_TtlMobCost__c =(wrapInst.total_Mob_Cost > 0 )? (wrapInst.total_Transformation_Cost*100/wrapInst.total_Mob_Cost).setScale(4) : 0;
     
        /*
        try{
            Database.update( opp);
        }
        catch(Exception e ){
             Database.rollback(sp);
            ExceptionClass.logException('OppAnalyticCalcQueue', 'calcAnalyticsOnOppQueue' , e, UtilConstants.APPLICATION_MWB, 'Mob Analytics');
            System.debug('Errro!!!' + e );
           
            //updateCostingRequestOnSyncComplete cstreq = new updateCostingRequestOnSyncComplete(oppId);
            //cstreq.updateCostingRequestRecordOnFailure();
            //ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.updateScope,e,UtilConstants.SWB,UtilConstants.BPOSE);
        }
        
        finally{
        }
        
        {
            //System.enqueueJob(new MobAnalyticsUtil(oldFteList, newFteList, oldOcdList, newOcdList, costingData, oldBnchId, newBnchId, oldBnchSumId,newBnchSumId, opp));
        }
        */
        return opp;
        
    }
    
    /******************************
        Method Name: populateFromFTE
        Description: Method to calculate metric from FTE Details
        Parameters: NA
        Return Value: OpportunityWrapper
        *******************************/
    private static oppAnalyticsWrapper  populateFromFTE(Id OpportunityId, oppAnalyticsWrapper oppWrap , Set<Id> newFteList){
        
        
        List<FTE_Details__c> inputFTEDetail = new List<FTE_Details__c> ();
        
        inputFTEDetail =  [SELECT Mob_Category__c, Mob_Category1__c, Mob_Sub_Category__c, Mob_Sub_Category1__c,  
                            Costing_Type__c,Total_SDO_FTE__c,
                                Opportunity__c,Mob_Totals__c FROM FTE_Details__c where ID IN :newFteList LIMIT 10000];
        //System.debug('inputFTEDetail ' + inputFTEDetail.size());
                                
        if(inputFTEDEtail <> null &&  inputFTEDEtail.size() > 0){
            for(FTE_Details__c fte : inputFTEDEtail  ){
                oppWrap.opportunityId = fte.Opportunity__c;
                if(fte.Costing_Type__c <> null && (UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c)) ){
                    oppWrap.total_Mob_Cost += fte.Mob_Totals__c;
                    
                    if(fte.Mob_Category1__c<> null && (UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(fte.Mob_Category1__c)) ){
                        oppWrap.total_Mob_PM_Cost += fte.Mob_Totals__c;
                        
                        if(fte.Mob_Sub_Category1__c<> null &&  (UtilConstants.PM_HCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c) ) ){
                            oppWrap.total_of_PM_Cost_HCL  += fte.Mob_Totals__c;    
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.PM_LCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c) ) ){
                            oppWrap.total_of_PM_Cost_LCL  += fte.Mob_Totals__c;
                        }
                        else{
                        }
                    }// PM Ends here
                    
                    else if(fte.Mob_Category1__c<> null && (UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c)) ){
                        oppWrap.total_EP_Cost += fte.Mob_Totals__c;
                        
                        if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.JB_NB_RC.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_EP_JB_NB_RC_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.INDUCTION.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_EP_Induction_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.RECRUITMENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_EP_Recruitment_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.REBADGING.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_EP_Rebadging_Cost += fte.Mob_Totals__c;
                        }
                        else{
                        }
                         
                    }// Enable People Ends here
                    
                   else if(fte.Mob_Category1__c<> null && (UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)) ){
                       oppWrap.total_KT_Cost += fte.Mob_Totals__c;
                       
                       if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.Mob_KT_Cost_HCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_KT_mob_payroll_HCL_Cost += fte.Mob_Totals__c;    
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.Mob_KT_Cost_LCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_KT_mob_payroll_LCL_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.TRAINING_ROOM_EPIPLEX_CHARGES.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_KT_training_rooms_and_epiplex_cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.KT_TRAVEL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_KT_travel_cost += fte.Mob_Totals__c;
                        }
                        else{
                            
                        }
                   }// KT ends here 
                   
                   else if(fte.Mob_Category1__c<> null && ( UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)) ){
                       oppWrap.total_CSC += fte.Mob_Totals__c;
                       
                           if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.OTHERS_ADDITIONAL_BACKGROUND_CHECKS_BGC.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                                oppWrap.total_CSC_Additional_Background_Checks_Cost += fte.Mob_Totals__c;    
                                }
                           else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.OTHERS_CAPABILITY_SPECIFIC_TOOLS_AND_ASSETS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                                oppWrap.total_CSC_Capability_Specific_Tools_Assets_Cost += fte.Mob_Totals__c;    
                                }
                           else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.OTHERS_SEAT_LOCKDOWN_REQUIREMENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                                oppWrap.total_CSC_Seat_Lockdown_Requirements_Cost += fte.Mob_Totals__c;    
                            }
                            else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.COMMUNICATIONS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                                oppWrap.total_CSC_Communication_Journey_Management_Cost += fte.Mob_Totals__c;    
                            }
                           else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.SOLUTION_VALIDATION_TRAVEL_VISA_CHARGES.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                                oppWrap.Solution_Validation_Cost += fte.Mob_Totals__c;    
                            }
                            else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                                oppWrap.total_Unit_Set_up_Enclosed_Bay_Cost += fte.Mob_Totals__c;    
                            }
                            else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                                oppWrap.total_Unit_Set_up_DCN_Set_up_Costs += fte.Mob_Totals__c;    
                            }
                            else{
                                
                            }
                   }
                   
                   else if(fte.Mob_Category1__c<> null && ( UtilConstants.TRANSFORMATION_COST.equalsIgnoreCase(fte.Mob_Category1__c)) ){
                       oppWrap.total_Transformation_Cost  += fte.Mob_Totals__c;
                   }
                   
                   else{
                       
                   }
                   
                }// Category = Mob Ends here
                
                else if(fte.Costing_Type__c <> null && (UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)) ){
                    oppWrap.total_Mob_Cost += fte.Mob_Totals__c;
                    oppWrap.PreGo_Live_Costs += fte.Mob_Totals__c;
                    oppWrap.total_SDO_FTE += fte.Total_SDO_FTE__c;
                    //fte.M1__c;
                }
                
                else if(fte.Costing_Type__c <> null && (UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c)) ){
                    oppWrap.total_Mob_Cost += fte.Mob_Totals__c;
                    oppWrap.total_BPO_Tech_Cost += fte.Mob_Totals__c;
                    
                    if(fte.Mob_Category1__c<> null && (UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c)) ){
                     
                        if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.TECH_HCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_BPO_Tech_HCL_cost += fte.Mob_Totals__c;    
                         }
                        else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.TECH_LCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_BPO_Tech_LCL_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.TECH_TOOLS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_BPO_Tech_standard_tools_and_asets_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && (UtilConstants.VD_DNP.equalsIgnoreCase(fte.Mob_Sub_Category1__c) ) ){
                            oppWrap.total_BPO_Tech_VND_Cost+= fte.Mob_Totals__c;
                        }
                        else{
                            
                        }
                    }
                }
                
                else if(fte.Costing_Type__c <> null && (UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c)) ){
                    oppWrap.total_Mob_Cost += fte.Mob_Totals__c;
                    oppWrap.total_BSS_Cost += fte.Mob_Totals__c;
                    
                    if(fte.Mob_Category1__c<> null && (UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c)) ){
                        //oppWrap.total_Mob_PM_Cost += fte.Mob_Totals__c;
                        
                        if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.SERVICE_MANAGEMENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c) ) ){
                            oppWrap.total_BSS_Service_Mgmt_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.EDM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_BSS_EDM_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.SUPPORT_CENTER.equalsIgnoreCase(fte.Mob_Sub_Category1__c) ) ){
                            oppWrap.total_BSS_SC_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.BSS_CC.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_BSS_CC_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.TOOLS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_BSS_Tools_Cost += fte.Mob_Totals__c;
                        }
                        else{
                            
                        }
                        
                    }    
                    
                }// BSS ends here
                
                
                else if(fte.Costing_Type__c <> null && (UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c)) ){
                    oppWrap.total_Mob_Cost += fte.Mob_Totals__c;
                    oppWrap.total_Deal_PMO_Cost += fte.Mob_Totals__c;
                    
                    if(fte.Mob_Category1__c<> null && (UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c)) ){
                        
                        if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.CM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_Deal_PMO_CM_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.CFM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_Deal_PMO_CFM_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.QAD.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_Deal_PMO_QAD_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.OADM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_Deal_PMO_OADM_Cost += fte.Mob_Totals__c;
                        }
                        else if(fte.Mob_Sub_Category1__c<> null && ( UtilConstants.OTHER.equalsIgnoreCase(fte.Mob_Sub_Category1__c)) ){
                            oppWrap.total_Deal_PMO_OTHER_Cost += fte.Mob_Totals__c;
                        }
                        else{
                            
                        }
                        
                    }
                } //PMO ends here
                
                else{
                    
                }
                
            }
        }
        
      return oppWrap;                          
    }
 
     /******************************
        Method Name: populateFromCCS
        Description: Method to calculate metrics from Other Cost Details
        Parameters: NA
        Return Value: OpportunityWrapper
        *******************************/   
    private static oppAnalyticsWrapper populatefromCCS(Id OpportunityId, oppAnalyticsWrapper oppWrapCCS, Set<Id>newOcdList ){
            
            List<Other_Cost_Details__c> inputOtherCost = [SELECT  Id, Mob_Category__c, Opportunity__c, Mob_Category1__c, Mob_Sub_Category__c, Mob_Sub_Category1__c, Cost_Type__c , Name,Service__r.Services__r.name, 
                                                          Service__c,Costing_Type__c, Mob_Cost__c,Mob_Totals__c
                                                            FROM Other_Cost_Details__c WHERE ID IN: newOcdList LIMIT 10000];
           System.debug('inputOtherCost ' + inputOtherCost.size());
            if(inputOtherCost <> null ){
                for(Other_Cost_Details__c ccs : inputOtherCost ){
                    oppWrapCCS.opportunityId= ccs.Opportunity__c;
                    System.debug('ccs OPp ' + ccs.Opportunity__c);
                    if(ccs.Costing_Type__c <> null && (UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ccs.Costing_Type__c)) ){
                        oppWrapCCS.total_Mob_Cost += ccs.Mob_Totals__c;
                        
                        
                        if(ccs.Mob_Category1__c<> null &&(UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ccs.Mob_Category1__c)) ){
                            oppWrapCCS.total_Mob_PM_Cost += ccs.Mob_Totals__c;
                            
                            if(ccs.Cost_Type__c <> null && (UtilConstants.DNP_COST.equalsIgnoreCase(ccs.Cost_Type__c) ) ){
                                oppWrapCCS.PM_DNP_Cost += ccs.Mob_Totals__c;
                            }
                            
                            if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.PM_HCL.equalsIgnoreCase(ccs.Mob_Sub_Category1__c) ) 
                                && ccs.Cost_Type__c <> null && (UtilConstants.PAYROLL_COST.equalsIgnoreCase(ccs.Cost_Type__c) ) ){
                                oppWrapCCS.total_of_PM_Cost_HCL  += ccs.Mob_Totals__c;    
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.PM_LCL.equalsIgnoreCase(ccs.Mob_Sub_Category1__c) ) 
                                && ccs.Cost_Type__c <> null && (UtilConstants.PAYROLL_COST.equalsIgnoreCase(ccs.Cost_Type__c) ) ){
                                oppWrapCCS.total_of_PM_Cost_LCL  += ccs.Mob_Totals__c;
                            }
                            else{
                                
                            }
                        }// PM Ends here
                        
                        else if(ccs.Mob_Category1__c<> null &&  (UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ccs.Mob_Category1__c)) ){
                            oppWrapCCS.total_EP_Cost += ccs.Mob_Totals__c;
                            
                            if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.JB_NB_RC.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_EP_JB_NB_RC_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.INDUCTION.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_EP_Induction_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.RECRUITMENT.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_EP_Recruitment_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.REBADGING.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_EP_Rebadging_Cost += ccs.Mob_Totals__c;
                            }
                            else{
                                
                            }
                             
                        }// Enable People Ends here
                        
                       else if(ccs.Mob_Category1__c<> null && (UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ccs.Mob_Category1__c)) ){
                           oppWrapCCS.total_KT_Cost += ccs.Mob_Totals__c;
                           
                           if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.Mob_KT_Cost_HCL.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) 
                               && (UtilConstants.Payroll.equalsIgnoreCase(ccs.Cost_Type__c)) ){
                                oppWrapCCS.total_KT_mob_payroll_HCL_Cost += ccs.Mob_Totals__c;    
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.Mob_KT_Cost_LCL.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) 
                                && (UtilConstants.Payroll.equalsIgnoreCase(ccs.Cost_Type__c)) ){
                                oppWrapCCS.total_KT_mob_payroll_LCL_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && 
                                (UtilConstants.TRAINING_ROOM_EPIPLEX_CHARGES.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_KT_training_rooms_and_epiplex_cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.KT_TRAVEL.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_KT_travel_cost += ccs.Mob_Totals__c;
                            }
                            else{
                                
                            }
                       }// KT ends here 
                       
                       else if(ccs.Mob_Category1__c<> null && ( UtilConstants.CSC.equalsIgnoreCase(ccs.Mob_Category1__c)) ){
                           oppWrapCCS.total_CSC += ccs.Mob_Totals__c;
                           
                               if(ccs.Mob_Sub_Category1__c<> null && 
                               (UtilConstants.OTHERS_ADDITIONAL_BACKGROUND_CHECKS_BGC.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                    oppWrapCCS.total_CSC_Additional_Background_Checks_Cost += ccs.Mob_Totals__c;    
                                    }
                               else if(ccs.Mob_Sub_Category1__c<> null && 
                               (UtilConstants.OTHERS_CAPABILITY_SPECIFIC_TOOLS_AND_ASSETS.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                    oppWrapCCS.total_CSC_Capability_Specific_Tools_Assets_Cost += ccs.Mob_Totals__c;    
                                    }
                               else if(ccs.Mob_Sub_Category1__c<> null && 
                               (UtilConstants.OTHERS_SEAT_LOCKDOWN_REQUIREMENT.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                    oppWrapCCS.total_CSC_Seat_Lockdown_Requirements_Cost += ccs.Mob_Totals__c;    
                                }
                                else if(ccs.Mob_Sub_Category1__c<> null && 
                                (UtilConstants.COMMUNICATIONS.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                    oppWrapCCS.total_CSC_Communication_Journey_Management_Cost += ccs.Mob_Totals__c;    
                                }
                               else if(ccs.Mob_Sub_Category1__c<> null && 
                               (UtilConstants.SOLUTION_VALIDATION_TRAVEL_VISA_CHARGES.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                    oppWrapCCS.Solution_Validation_Cost += ccs.Mob_Totals__c;    
                                }
                                else if(ccs.Mob_Sub_Category1__c<> null && 
                                (UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                    oppWrapCCS.total_Unit_Set_up_Enclosed_Bay_Cost += ccs.Mob_Totals__c;    
                                }
                                else if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                    oppWrapCCS.total_Unit_Set_up_DCN_Set_up_Costs += ccs.Mob_Totals__c;    
                                }
                                else{
                                    
                                }
                       }
                       
                       else if(ccs.Mob_Category1__c<> null && ( UtilConstants.TRANSFORMATION_COST.equalsIgnoreCase(ccs.Mob_Category1__c)) ){
                           oppWrapCCS.total_Transformation_Cost  += ccs.Mob_Totals__c;
                       }
                       
                       else{
                           
                       }
                       
                    }// Category = Mob Ends here
                    
                    else if(ccs.Costing_Type__c <> null && (UtilConstants.SDO.equalsIgnoreCase(ccs.Costing_Type__c)) ){
                        oppWrapCCS.total_Mob_Cost += ccs.Mob_Totals__c;
                        oppWrapCCS.PreGo_Live_Costs += ccs.Mob_Totals__c;
                        //oppWrapCCS.total_SDO_FTE += ccs.M1__c;
                        
                    }
                    
                    else if(ccs.Costing_Type__c <> null && (UtilConstants.TECHNOLOGY.equalsIgnoreCase(ccs.Costing_Type__c)) ){
                        oppWrapCCS.total_Mob_Cost += ccs.Mob_Totals__c;
                        oppWrapCCS.total_BPO_Tech_Cost += ccs.Mob_Totals__c;
                        
                       
                        if(ccs.Mob_Category1__c<> null && (UtilConstants.TECHNOLOGY.equalsIgnoreCase(ccs.Mob_Category1__c)) ){
                         
                            if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.TECH_HCL.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_BPO_Tech_HCL_cost += ccs.Mob_Totals__c;    
                             }
                            else if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.TECH_LCL.equalsIgnoreCase(ccs.Mob_Sub_Category1__c))  ){
                                oppWrapCCS.total_BPO_Tech_LCL_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.TECH_TOOLS.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_BPO_Tech_standard_tools_and_asets_Cost += ccs.Mob_Totals__c;   
                            }
                            else if(ccs.Mob_Sub_Category1__c <> null && (UtilConstants.TECH_DNP.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_BPO_Tech_DNP_Cost += ccs.Mob_Totals__c;  
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && (UtilConstants.VD_DNP.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_BPO_Tech_VND_Cost+= ccs.Mob_Totals__c;
                            }
                            else{
                                
                            }
                        }
                    }
                    
                    else if(ccs.Costing_Type__c <> null && (UtilConstants.BSS.equalsIgnoreCase(ccs.Costing_Type__c)) ){
                        oppWrapCCS.total_Mob_Cost += ccs.Mob_Totals__c;
                        oppWrapCCS.total_BSS_Cost += ccs.Mob_Totals__c;
                        
                        if(ccs.Mob_Category1__c<> null && (UtilConstants.BSS.equalsIgnoreCase(ccs.Mob_Category1__c)) ){
                            //oppWrapCCS.total_Mob_PM_Cost += ccs.Mob_Totals__c;
                            
                            if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.SERVICE_MANAGEMENT.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_BSS_Service_Mgmt_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.EDM.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_BSS_EDM_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && 
                                ( UtilConstants.SUPPORT_CENTER.equalsIgnoreCase(ccs.Mob_Sub_Category1__c) ) ){
                                oppWrapCCS.total_BSS_SC_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.TOOLS.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_BSS_Tools_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.BSS_CC.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_BSS_CC_Cost += ccs.Mob_Totals__c;
                            }
                            else{
                                
                            }
                            
                        }    
                        
                    }// BSS ends here
                    
                    
                    else if(ccs.Costing_Type__c <> null && (UtilConstants.PMO.equalsIgnoreCase(ccs.Costing_Type__c)) ){
                        oppWrapCCS.total_Mob_Cost += ccs.Mob_Totals__c;
                        oppWrapCCS.total_Deal_PMO_Cost += ccs.Mob_Totals__c;
                        
                        if(ccs.Mob_Category1__c<> null && (UtilConstants.PMO.equalsIgnoreCase(ccs.Mob_Category1__c)) ){
                            
                            if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.CM.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_Deal_PMO_CM_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.CFM.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_Deal_PMO_CFM_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.QAD.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_Deal_PMO_QAD_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.OADM.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_Deal_PMO_OADM_Cost += ccs.Mob_Totals__c;
                            }
                            else if(ccs.Mob_Sub_Category1__c<> null && ( UtilConstants.OTHER.equalsIgnoreCase(ccs.Mob_Sub_Category1__c)) ){
                                oppWrapCCS.total_Deal_PMO_OTHER_Cost+= ccs.Mob_Totals__c;
                            }
                            else{
                                
                            }
                            
                        }
                    } //PMO ends here
                    
                    else{
                        
                    }
                    
                }
            }
           
         return oppWrapCCS;  
           
    }//Method Ends here  
}