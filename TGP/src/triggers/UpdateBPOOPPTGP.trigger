/*------------------------------------------
Author-Shridhar Patankar

Description:- To update records on BPO Opportunity when SAP OM Opportunity record is changed.

Date:- 08/07/2013
Updated:- 12/07/2013 Author-Shridhar Patankar Description-For updation in Primary Offering
--------------------------------------------*/
trigger UpdateBPOOPPTGP on SAP_OM_Opportunity__c(after update, after insert) {
  List<SAP_OM_Opportunity__c> lstNewSAPOMMaster= Trigger.new;
  List<Offerings_Master__c> lstNewOfferingMaster= new List<Offerings_Master__c>();
  List<Opportunity_TGP__c> listUpdateBPOOpportunities = new List<Opportunity_TGP__c>();
  List<Opportunity_Team_SAP__c> listUpdateOppTeamSAP = new List<Opportunity_Team_SAP__c>();
  List<Opportunity_Commerical_Data__c> listUpdateCommercialRec = new List<Opportunity_Commerical_Data__c>();
  
  /*String PrimaryOffering;
  String PrimaryOffering1;
  String PrimaryOffering2;
  String PrimaryOffering3;
  String PrimaryOffering4;
  String PrimaryOffering5;
  String PrimaryOffering6;
  String PrimaryOffering7;
  String PrimaryOffering8;
  String PrimaryOffering9;
  String PrimaryOffering10;
  String PrimaryOffering11;
  String PrimaryOffering12;
  String PrimaryOffering13;
  String PrimaryOffering14;
  String PrimaryOffering15;
  String PrimaryOffering16;
  String PrimaryOffering17;*/
  
  set<id> lstId = new set<id>();
  
  List<Client_Geo_Area_Master__c> lstClientGeoAreaMaster = [select id,name from Client_Geo_Area_Master__c where Active__c=true order by name];
  Map<String,Id> mapClientGeoAreaMaster = new Map<String,Id>();
    if(lstClientGeoAreaMaster.size() > 0)
    {
        for(Client_Geo_Area_Master__c cgaMasterObj:lstClientGeoAreaMaster)
        {
            mapClientGeoAreaMaster.put(cgaMasterObj.name,cgaMasterObj.id);
        }
    }
  
  if(Trigger.isUpdate)
    {
       if(!SapOMOpportunityUpdateHelper.hasAlreadyTriggerExecuted()){
       
       for(SAP_OM_Opportunity__c tmpsapOmMaster : lstNewSAPOMMaster)
       {
           lstId.add(tmpsapOmMaster.id);
       }
       //List<Client_Geo_Area_Master__c> lstClientGeoAreaMaster = [select id,name from Client_Geo_Area_Master__c where Active__c=true order by name];
       List<Opportunity_TGP__c> lstoppTGP = [select id,Offering_Master__c,Primary_offerings__c,TCV__c,IS_Net_Revenue_SAP__c,SAP_OM_Opportunity__r.name,Client_Geo_Area__c,Client_Geo_Unit__c,Complex_Cost_Architect__r.name,Client_Name__c,Operating_Group__c,Activity__c,Expected_contract_sign_qtr__c,NAme,SAP_OM_Opportunity__c from  Opportunity_TGP__c where SAP_OM_Opportunity__c in :lstId];
       List<Opportunity_Team_SAP__c> lstSapTeam =[Select BPO_Opp__c,Client_Account_Lead__c,Client_QA_Director__c,Delivery_Lead_BPO__c,Global_Client_Account_Lead__c,Managing_Director_MC__c,Mobilization_Lead__c,Opportunity_Contact__c,Opportunity_QA_Director__c,
                                                         Sales_Origination__c,Sales_Capture_Opp_Director__c,Sales_Capture_OSL__c,Sales_Capture_Other__c,Solution_Arch_BPO__c,Technology_Account_Lead__c from Opportunity_Team_SAP__c where BPO_Opp__c IN : lstoppTGP];
       List<Opportunity_Commerical_Data__c> lstCommercial =[Select c.Value_Outcome_Based_Components__c, c.True_up_period__c, c.True_up_period_Comments__c, c.Transition_Plan_Approver__c, 
                                            c.Transition_Fees_at_Risk__c, c.Transition_Fees_at_Risk_Comments__c, c.Transition_Billing_Terms__c, 
                                            c.Total_Current_Net_Revenue__c, c.Third_Party_Advisor__c, c.Targeted_Go_Live__c, c.SystemModstamp, c.Step_in_Rights__c, 
                                            c.Step_in_Rights_Comments__c, c.Spend_Analysis_WBApprover_APS_Only__c, c.Sourcing_Total_Avail_Spend__c, 
                                            c.Sourcing_Total_Addressable_Spend__c, c.Sourcing_Comments__c, c.Sourcing_Anticipated_Savings__c, c.Solution_Review_Approver__c, 
                                            c.Solution_Comments__c, c.Service_Levels__c, c.Seat_Utilization__c, c.SLA_Pool__c, c.SLA_Pool_Comments__c, c.SLA_Fees_at_Risk__c, 
                                            c.SLA_Fees_at_Risk_Comments__c, c.ROI__c, c.Proposal_Submission_Date__c, c.Productivity__c, c.Pricing_Structure__c, 
                                            c.Pricing_Structure_Comments__c, c.Peak_Capital_Balance__c, c.PMO_of_Deal_Costs_Comments__c, c.Orals_Date__c, c.Opportunity_TGP__c, 
                                            c.Opportunity_QA_Approver__c, c.OI__c, c.OADM_Level_Location_FTE_Comments__c, c.Number_of_Yellow_1370_Terms__c, 
                                            c.Number_of_Total_SLAs__c, c.Number_of_Total_SLAs_Comments__c, c.Number_of_Red_1370_Terms__c, c.Negotiation_Start_Date__c, 
                                            c.Name, c.Mobilization_of_TCC_Comments__c, c.Max_SLA_Risk_Allocation__c, c.Max_SLA_Risk_Allocation_Comments__c, 
                                            c.Limits_of_Liability_Cap__c, c.Limits_of_Liability_Cap_Comments__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, 
                                            c.Invoicing_Terms__c, c.Id, c.IP_Ownership__c, c.IP_Ownership_Comments__c, c.FX__c, c.Dragnet_Sweeps_Clause__c, 
                                            c.Dragnet_Sweeps_Clause_Comments__c, c.Downselect_Status_Date__c, c.Disputed_Payments_Months_Fees__c, 
                                            c.Disputed_Payments_Comments__c, c.Dedicated_Personnel__c, c.Dedicated_Personnel_Comments__c, c.Deal_Total_CCI__c, 
                                            c.Deal_Overview__c, c.Current_FY_CCI__c, c.Critical_Milestones_on_Transitions__c, c.Critical_Milestones_on_Transitions_Comme__c, 
                                            c.CreatedDate, c.CreatedById, c.Contract_Term__c, c.Contract_Signature__c, c.Contingency__c, c.Consents__c, c.Consents_Comments__c, 
                                            c.Compliance_with_Laws__c, c.Compliance_with_Laws_Comments__c, c.Compliance_Regulatory_Approver__c, c.Competitor__c, 
                                            c.Comments_on_CCI__c, c.Client_Termination_Rights__c,c.Comment_on_revenue__c,  c.Client_Term_Notice_Period__c, 
                                            c.Client_Term_Notice_Period_Comments__c, c.Client_Term_Fees__c, c.Client_Term_Fees_Comments__c, c.CPR_Transition__c, 
                                            c.CPR_RUN__c, c.COLA__c, c.CDP_Workbook_Submitted_Y_N__c, c.Benchmarking__c, c.Benchmarking_Comments__c, c.BPO_Total_CCI__c, 
                                            c.BPO_Net_Revenue_SD_Estimate__c, c.BPO_Net_Revenue_SAP_OM__c,c.BPO_Margin_Diff__c, c.Award_Date__c,
                                            c.Automatic_Continuous_Improvement_Y_N__c, c.Automatic_Continuous_Improvement_Comment__c, c.Accenture_Term_Rights__c, 
                                            c.Accenture_Term_Rights_Comments__c, c.ACN_Transition_Price_FTE__c, c.ACNRUN_Price_FTE__c 
                                            From Opportunity_Commerical_Data__c c where Opportunity_TGP__c IN : lstoppTGP];
       //SOL-170.For updation of Primary offerings. Start
       lstNewSAPOMMaster = [Select id,Max_Offering_Name__c,Service_Group__c,BPO_Opportunity_Dev__c,IS_Opportunity_Dev__c,Client_Name__c,Expected_contract_sign_Quarter__c,TCV__c,IS_Net_Revenue__c,Stage__c,
                            Client_Geo_Unit__c,Client_Geo_Area__c,Geography__c,Activity__c,Operating_Group__c,Opportunity_Name__c,Primary_offerings_New__c,
                            Name,Capital_Project_Mgmt_Total_Net_Rev_perc__c,Care_Management_Total_Net_Rev_perc__c,Customer_Contact_Total_Net_Rev_perc__c,
                            Emerging_Cross_Industry_Total_Net_Rev_pe__c,Emerging_Industry_Specific_TotNet_Rev_pe__c,Finance_Accounting_Total_Net_Rev_perc__c,
                            Health_Administration_Total_Net_Rev_perc__c,Human_Resources_Total_Net_Revenue_perc__c,Insurance_Total_Net_Revenue_perc__c,
                            Learning_Total_Net_Revenue_perc__c,Marketing_Total_Net_Revenue_perc__c,Credit_Services_Total_Net_Revenue_perc__c,Third_Party_Advisors__c,
                            Network_Services_Total_Net_Revenue_perc__c,Pharmaceuticals_Total_Net_Revenue_perc__c,Procurement_Total_Net_Revenue_perc__c,
                            Supply_Chain_Total_Net_Revenue_perc__c,Competitor__c,Pricing_Type__c,Win_Probability__c,Utilities_Total_Net_Revenue_perc__c,
                            Client_Account_Lead__c,Client_QA_Director__c,Delivery_Lead_BPO__c,Global_Client_Account_Lead__c,Managing_Director_MC__c,
                            Mobilization_Lead__c,Opportunity_Contact__c,Opportunity_QA_Director__c,Sales_Capture_Opp_Director__c,Sales_Capture_OSL__c,Sales_Capture_Other__c,
                            Sales_Origination__c,Solution_Arch_BPO__c,Technology_Account_Lead__c,SAP_Create_Date__c,CSG__c,Delivery_Centers__c,Expected_Contract_Signing_Date__c,
                            Function_Business_Services__c,Industry_Business_Services__c,Master_Client_Name__c,Mergers_Acquisitions__c,Pipeline_Entry_Date__c,
                            Primary_Work_Location__c,Proposal_Submission_Date__c,Restricted__c,RSD_Quarter__c,Stage_Update_Date__c,Sub_CSG__c,
                            Total_Solution_Contingency__c,Total_Solution_Contingency_Amount__c,Total_Current_Net_Revenue__c,SAP_OM_ID_External_ID__c, Competitive_Sole_Source__c,BPO_Margin_Diff__c
                            from SAP_OM_Opportunity__c where id in :lstId ];  
       lstNewOfferingMaster =[Select id,name,Category__c from Offerings_Master__c];
       
       /*Map<String,Id> mapClientGeoAreaMaster = new Map<String,Id>();
       if(lstClientGeoAreaMaster.size() > 0)
       {
           for(Client_Geo_Area_Master__c cgaMasterObj:lstClientGeoAreaMaster)
           {
               mapClientGeoAreaMaster.put(cgaMasterObj.name,cgaMasterObj.id);
           }
       } */      
       
       //Sol-170. End
          for(integer i=0;i<lstNewSAPOMMaster.size();i++)
          {
          /*// The below commented code is of no use as we are updating the primary offering field using formula field.
               //SOL-170.For updation of Primary offerings. Start
               if(lstNewSAPOMMaster[i].Capital_Project_Mgmt_Total_Net_Rev_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Capital_Project_Mgmt_Total_Net_Rev_perc__c>0)
                 {
                 PrimaryOffering1 ='Capital Project Mgmt'+'('+lstNewSAPOMMaster[0].Capital_Project_Mgmt_Total_Net_Rev_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering1 = ' ';
               }
               if(lstNewSAPOMMaster[i].Care_Management_Total_Net_Rev_perc__c !=null)
               {
                 if(lstNewSAPOMMaster[0].Care_Management_Total_Net_Rev_perc__c>0)
                 {
                 PrimaryOffering2 ='Care Management'+'('+lstNewSAPOMMaster[0].Care_Management_Total_Net_Rev_perc__c +' %)';
                 }
                 else
                 PrimaryOffering2 = ' ';
               }
               if(lstNewSAPOMMaster[i].Customer_Contact_Total_Net_Rev_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Customer_Contact_Total_Net_Rev_perc__c>0)
                 {
                 PrimaryOffering3 ='Customer Contact'+'('+lstNewSAPOMMaster[0].Customer_Contact_Total_Net_Rev_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering3= '';               
               }
               if(lstNewSAPOMMaster[i].Emerging_Cross_Industry_Total_Net_Rev_pe__c !=null)
               {
                if(lstNewSAPOMMaster[0].Emerging_Cross_Industry_Total_Net_Rev_pe__c>0)
                {
                PrimaryOffering4 ='Emerging - Cross Industry'+'('+lstNewSAPOMMaster[0].Emerging_Cross_Industry_Total_Net_Rev_pe__c +' %)'; 
                }
                else
                PrimaryOffering4 = ' ';
               }
               if(lstNewSAPOMMaster[i].Emerging_Industry_Specific_TotNet_Rev_pe__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Emerging_Industry_Specific_TotNet_Rev_pe__c>0)
                 {
                 PrimaryOffering5 ='Emerging - Industry Specific'+'('+lstNewSAPOMMaster[0].Emerging_Industry_Specific_TotNet_Rev_pe__c+' %)'; 
                 }
                 else
                 PrimaryOffering5 = ' ';
               }
               if(lstNewSAPOMMaster[i].Finance_Accounting_Total_Net_Rev_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Finance_Accounting_Total_Net_Rev_perc__c>0)
                {
                PrimaryOffering6 ='Finance and Accounting'+'('+lstNewSAPOMMaster[0].Finance_Accounting_Total_Net_Rev_perc__c +' %)'; 
                }
                else
                PrimaryOffering6 = ' ';
               }
               if(lstNewSAPOMMaster[i].Health_Administration_Total_Net_Rev_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Health_Administration_Total_Net_Rev_perc__c>0)
                 {
                 PrimaryOffering7 ='Health Administration'+'('+lstNewSAPOMMaster[0].Health_Administration_Total_Net_Rev_perc__c+' %)';
                 }
                 else
                 PrimaryOffering7 = ' ';
               }
               if(lstNewSAPOMMaster[i].Human_Resources_Total_Net_Revenue_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Human_Resources_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering8 ='Human Resources'+'('+lstNewSAPOMMaster[0].Human_Resources_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering8 = ' ';
               }
               if(lstNewSAPOMMaster[i].Insurance_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Insurance_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering9 ='Insurance'+'('+lstNewSAPOMMaster[0].Insurance_Total_Net_Revenue_perc__c+' %)';
                 }
                 else
                 PrimaryOffering9 = ' ';             
               }
               if(lstNewSAPOMMaster[i].Learning_Total_Net_Revenue_perc__c !=null)
               {
                 if(lstNewSAPOMMaster[0].Learning_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering10 ='Learning'+'('+lstNewSAPOMMaster[0].Learning_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering10= ' ';
               }
               if(lstNewSAPOMMaster[i].Marketing_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Marketing_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering11 ='Marketing'+'('+lstNewSAPOMMaster[0].Marketing_Total_Net_Revenue_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering11 = ' ';
               }
               if(lstNewSAPOMMaster[i].Credit_Services_Total_Net_Revenue_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Credit_Services_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering12 ='Credit Services'+'('+lstNewSAPOMMaster[0].Credit_Services_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering12= ' ';
               }
               if(lstNewSAPOMMaster[i].Network_Services_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Network_Services_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering13 ='Network Services'+'('+lstNewSAPOMMaster[0].Network_Services_Total_Net_Revenue_perc__c+' %)';
                 }
                 else
                 PrimaryOffering13= ' ';                 
               }
               if(lstNewSAPOMMaster[i].Pharmaceuticals_Total_Net_Revenue_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Pharmaceuticals_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering14 ='Pharmaceuticals'+'('+lstNewSAPOMMaster[0].Pharmaceuticals_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering14= ' ';
               }
               if(lstNewSAPOMMaster[i].Procurement_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Procurement_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering15 ='Procurement'+'('+lstNewSAPOMMaster[0].Procurement_Total_Net_Revenue_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering15= ' ';
               }
               if(lstNewSAPOMMaster[i].Supply_Chain_Total_Net_Revenue_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Supply_Chain_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering16 ='Supply Chain'+'('+lstNewSAPOMMaster[0].Supply_Chain_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering16= ' ';
               }
               if(lstNewSAPOMMaster[i].Utilities_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Utilities_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering17 ='Utilities'+'('+lstNewSAPOMMaster[0].Utilities_Total_Net_Revenue_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering17= ' ';
               }
               
               PrimaryOffering=PrimaryOffering1 + ' ' +PrimaryOffering2 + ' ' +PrimaryOffering3 + ' ' +PrimaryOffering4 + ' ' +PrimaryOffering5 + ' ' +PrimaryOffering6 + ' ' +PrimaryOffering7 + ' ' +PrimaryOffering8 + ' ' +PrimaryOffering9 + ' ' +PrimaryOffering10 + ' ' +PrimaryOffering11 + ' ' +PrimaryOffering12 + ' ' +PrimaryOffering13 + ' ' +PrimaryOffering14 + ' ' +PrimaryOffering15 + ' ' +PrimaryOffering16 + ' ' +PrimaryOffering17;
               lstNewSAPOMMaster[i].Primary_offerings__c=PrimaryOffering;
               
               */
               //Sol-170. End
               
               if(!mapClientGeoAreaMaster.isEmpty() && lstNewSAPOMMaster[i].Geography__c != null)
               {
                    if(mapClientGeoAreaMaster.get(lstNewSAPOMMaster[i].Geography__c) != null)
                        {
                            //tmpOpptgp.Client_Geo_Area__c = mapClientGeoAreaMaster.get(lstNewSAPOMMaster[i].Geography__c);
                            lstNewSAPOMMaster[i].Client_Geo_Area__c = mapClientGeoAreaMaster.get(lstNewSAPOMMaster[i].Geography__c);
                        }                           
               }
               
                for(Opportunity_TGP__c bpoOpportunity: lstoppTGP)
                {
                    if(bpoOpportunity.SAP_OM_Opportunity__c==lstNewSAPOMMaster[i].id)
                    {  
                       Opportunity_TGP__c tmpOpptgp = new Opportunity_TGP__c();
                       tmpOpptgp.Id = bpoOpportunity.Id;
                       tmpOpptgp.Client_Name__c=lstNewSAPOMMaster[i].Client_Name__c;
                       tmpOpptgp.Name=lstNewSAPOMMaster[i].Opportunity_Name__c;
                       tmpOpptgp.Operating_Group__c=lstNewSAPOMMaster[i].Operating_Group__c;
                       tmpOpptgp.Activity__c=lstNewSAPOMMaster[i].Activity__c;
                       //tmpOpptgp.Client_Geo_Area__c=lstNewSAPOMMaster[i].Client_Geo_Area__c;
                       if(!mapClientGeoAreaMaster.isEmpty() && lstNewSAPOMMaster[i].Geography__c != null)
                       {
                           if(mapClientGeoAreaMaster.get(lstNewSAPOMMaster[i].Geography__c) != null)
                           {
                               tmpOpptgp.Client_Geo_Area__c = mapClientGeoAreaMaster.get(lstNewSAPOMMaster[i].Geography__c);
                               //lstNewSAPOMMaster[i].Client_Geo_Area__c = mapClientGeoAreaMaster.get(lstNewSAPOMMaster[i].Geography__c);
                           }                           
                       }
                       
                       tmpOpptgp.Client_Geo_Unit__c=lstNewSAPOMMaster[i].Client_Geo_Unit__c;
                       tmpOpptgp.Stage__c=lstNewSAPOMMaster[i].Stage__c;
                       tmpOpptgp.TCV__c=lstNewSAPOMMaster[i].TCV__c;
                       tmpOpptgp.Estimated_TCV__c=lstNewSAPOMMaster[i].TCV__c;
                       tmpOpptgp.IS_Net_Revenue_SAP__c=lstNewSAPOMMaster[i].IS_Net_Revenue__c;
                       tmpOpptgp.IS_Net_Revenue_SD_Estimate__c=lstNewSAPOMMaster[i].IS_Net_Revenue__c;
                       tmpOpptgp.Expected_contract_sign_qtr__c=lstNewSAPOMMaster[i].Expected_contract_sign_Quarter__c;
                       tmpOpptgp.Primary_offerings__c=lstNewSAPOMMaster[i].Primary_offerings_New__c;
                       tmpOpptgp.Win_Probability__c=lstNewSAPOMMaster[i].Win_Probability__c;
                       tmpOpptgp.Competitors__c=lstNewSAPOMMaster[i].Competitor__c;
                       tmpOpptgp.Pricing_Type__c=lstNewSAPOMMaster[i].Pricing_Type__c;
                       tmpOpptgp.Third_party_Advisors__c=lstNewSAPOMMaster[i].Third_Party_Advisors__c;
                       tmpOpptgp.SAP_Create_Date__c=lstNewSAPOMMaster[i].SAP_Create_Date__c;
                       tmpOpptgp.CSG__c=lstNewSAPOMMaster[i].CSG__c;
                       tmpOpptgp.Delivery_Centers__c=lstNewSAPOMMaster[i].Delivery_Centers__c;
                       tmpOpptgp.Expected_Contract_Signing_Date__c=lstNewSAPOMMaster[i].Expected_Contract_Signing_Date__c;
                       tmpOpptgp.Function_Business_Services__c=lstNewSAPOMMaster[i].Function_Business_Services__c;
                       tmpOpptgp.Industry_Business_Services__c=lstNewSAPOMMaster[i].Industry_Business_Services__c;
                       tmpOpptgp.Master_Client_Name__c=lstNewSAPOMMaster[i].Master_Client_Name__c;
                       tmpOpptgp.Mergers_Acquisitions__c=lstNewSAPOMMaster[i].Mergers_Acquisitions__c;
                       tmpOpptgp.Pipeline_Entry_Date__c=lstNewSAPOMMaster[i].Pipeline_Entry_Date__c;
                       tmpOpptgp.Primary_Work_Location__c=lstNewSAPOMMaster[i].Primary_Work_Location__c;
                       tmpOpptgp.Proposal_Submission_Date__c=lstNewSAPOMMaster[i].Proposal_Submission_Date__c;
                       tmpOpptgp.Restricted__c=lstNewSAPOMMaster[i].Restricted__c;
                       tmpOpptgp.RSD_Quarter__c=lstNewSAPOMMaster[i].RSD_Quarter__c;
                       tmpOpptgp.Stage_Update_Date__c=lstNewSAPOMMaster[i].Stage_Update_Date__c;
                       tmpOpptgp.Sub_CSG__c=lstNewSAPOMMaster[i].Sub_CSG__c;
                       tmpOpptgp.Total_Solution_Contingency__c=lstNewSAPOMMaster[i].Total_Solution_Contingency__c;
                       tmpOpptgp.Total_Solution_Contingency_Amount__c=lstNewSAPOMMaster[i].Total_Solution_Contingency_Amount__c;
                       tmpOpptgp.Total_Current_Net_Revenue__c=lstNewSAPOMMaster[i].Total_Current_Net_Revenue__c; 
                       tmpOpptgp.SAP_OM_ID__c=lstNewSAPOMMaster[i].SAP_OM_ID_External_ID__c;
                       //tmpOpptgp.SOURCING_PROCUREMENT__c=lstNewSAPOMMaster[i].SOURCING_PROCUREMENT__c;
                       tmpOpptgp.Competitive_Sole_Source__c = lstNewSAPOMMaster[i].Competitive_Sole_Source__c;
                       tmpOpptgp.BPO_Margin_Diff__c=lstNewSAPOMMaster[i].BPO_Margin_Diff__c;
                       tmpOpptgp.Service_Group__c=lstNewSAPOMMaster[i].Service_Group__c;//Komal Change
                       
                       Opportunity_Team_SAP__c tempOppSap;
                       
                       for(Opportunity_Team_SAP__c tempSapTeam : lstSapTeam) {
                       if(tempSapTeam.BPO_Opp__c == bpoOpportunity.Id) {
                       tempOppSap = new Opportunity_Team_SAP__c();
                       tempOppSap.Id = tempSapTeam.Id;
                       tempOppSap.Client_Account_Lead__c =  lstNewSAPOMMaster[i].Client_Account_Lead__c;
                       tempOppSap.Client_QA_Director__c =  lstNewSAPOMMaster[i].Client_QA_Director__c;
                       tempOppSap.Delivery_Lead_BPO__c =  lstNewSAPOMMaster[i].Delivery_Lead_BPO__c;
                       //tempOppSap.Due_Diligence_Lead__c =  lstNewSAPOMMaster[i].Due_Diligence_Lead__c;
                       tempOppSap.Global_Client_Account_Lead__c =  lstNewSAPOMMaster[i].Global_Client_Account_Lead__c;
                       tempOppSap.Managing_Director_MC__c =  lstNewSAPOMMaster[i].Managing_Director_MC__c;
                       tempOppSap.Mobilization_Lead__c =  lstNewSAPOMMaster[i].Mobilization_Lead__c;
                       tempOppSap.Opportunity_Contact__c =  lstNewSAPOMMaster[i].Opportunity_Contact__c;
                       tempOppSap.Opportunity_QA_Director__c =  lstNewSAPOMMaster[i].Opportunity_QA_Director__c;
                       tempOppSap.Sales_Origination__c =  lstNewSAPOMMaster[i].Sales_Origination__c;
                       tempOppSap.Sales_Capture_Opp_Director__c =  lstNewSAPOMMaster[i].Sales_Capture_Opp_Director__c;
                       tempOppSap.Sales_Capture_OSL__c =  lstNewSAPOMMaster[i].Sales_Capture_OSL__c;
                       tempOppSap.Sales_Capture_Other__c =  lstNewSAPOMMaster[i].Sales_Capture_Other__c;
                       tempOppSap.Solution_Arch_BPO__c =  lstNewSAPOMMaster[i].Solution_Arch_BPO__c;
                       tempOppSap.Technology_Account_Lead__c =  lstNewSAPOMMaster[i].Technology_Account_Lead__c;
                       
                       listUpdateOppTeamSAP.add(tempOppSap); 
                       }
                       }
                       
                      Opportunity_Commerical_Data__c tempCommercial;
                       
                       for(Opportunity_Commerical_Data__c c : lstCommercial) {
                        if(c.Opportunity_TGP__c == bpoOpportunity.Id) {
                           tempCommercial = new Opportunity_Commerical_Data__c();
                           tempCommercial.Id = c.Id;
                           listUpdateCommercialRec.add(tempCommercial); 
                        }
                       }  
                       
                       //Added for updating Offering Master id
                       if(lstNewOfferingMaster.size()>0)
                       {
                           for(Offerings_Master__c offMaster : lstNewOfferingMaster)
                           {
                                if(lstNewSAPOMMaster[i].Max_Offering_Name__c==offMaster.name)
                                {
                                    tmpOpptgp.Offering_Master__c=offMaster.id;
                                }
                           }
                       }
                      listUpdateBPOOpportunities.add(tmpOpptgp); 
                    }
                }             
          }
          SapOMOpportunityUpdateHelper.setHasAlreadyExecuted();
          if(!listUpdateOppTeamSAP.isEmpty()){
            update listUpdateOppTeamSAP;
          }
          update listUpdateBPOOpportunities; 
          update lstNewSAPOMMaster;
            
          if(!listUpdateCommercialRec.isEmpty()){
            //update listUpdateCommercialRec;
          } 
          }      
     }
    //Added as part of Dot Release to handle Dash board filter 
    if(Trigger.isInsert)
    {
        if(!SapOMOpportunityUpdateHelper.hasAlreadyTriggerExecuted())
        {
           for(SAP_OM_Opportunity__c tmpsapOmMaster : lstNewSAPOMMaster)
           {
               lstId.add(tmpsapOmMaster.id);
           }
           //List<Opportunity_TGP__c> lstoppTGP = [select id,Offering_Master__c,Primary_offerings__c,TCV__c,SAP_OM_Opportunity__r.name,Client_Geo_Area__c,Client_Geo_Unit__c,Complex_Cost_Architect__r.name,Client_Name__c,Operating_Group__c,Activity__c,Expected_contract_sign_qtr__c,NAme,SAP_OM_Opportunity__c from  Opportunity_TGP__c where SAP_OM_Opportunity__c in :lstId];
           //SOL-170.For updation of Primary offerings. Start
           lstNewSAPOMMaster = [Select id,Max_Offering_Name__c,Client_Name__c,Expected_contract_sign_Quarter__c,TCV__c,Stage__c,
                            Client_Geo_Unit__c,Geography__c,Client_Geo_Area__c,Activity__c,Operating_Group__c,Opportunity_Name__c,
                            Name,Capital_Project_Mgmt_Total_Net_Rev_perc__c,Care_Management_Total_Net_Rev_perc__c,Customer_Contact_Total_Net_Rev_perc__c,
                            Emerging_Cross_Industry_Total_Net_Rev_pe__c,Emerging_Industry_Specific_TotNet_Rev_pe__c,Finance_Accounting_Total_Net_Rev_perc__c,
                            Health_Administration_Total_Net_Rev_perc__c,Human_Resources_Total_Net_Revenue_perc__c,Insurance_Total_Net_Revenue_perc__c,
                            Learning_Total_Net_Revenue_perc__c,Marketing_Total_Net_Revenue_perc__c,Credit_Services_Total_Net_Revenue_perc__c,
                            Network_Services_Total_Net_Revenue_perc__c,Pharmaceuticals_Total_Net_Revenue_perc__c,Procurement_Total_Net_Revenue_perc__c,
                            Supply_Chain_Total_Net_Revenue_perc__c,Utilities_Total_Net_Revenue_perc__c
                            from SAP_OM_Opportunity__c where id in :lstId ];  
           //lstNewOfferingMaster =[Select id,name,Category__c from Offerings_Master__c];
           //Sol-170. End
           for(integer i=0;i<lstNewSAPOMMaster.size();i++)
           {
                if(!mapClientGeoAreaMaster.isEmpty() && lstNewSAPOMMaster[i].Geography__c != null)
                {
                    if(mapClientGeoAreaMaster.get(lstNewSAPOMMaster[i].Geography__c) != null)
                    {
                        lstNewSAPOMMaster[i].Client_Geo_Area__c = mapClientGeoAreaMaster.get(lstNewSAPOMMaster[i].Geography__c);
                    }                           
               }
           }      
           SapOMOpportunityUpdateHelper.setHasAlreadyExecuted();
           update lstNewSAPOMMaster;      
        }
    }
     
 /* //We don't need this code as for updating primary offering field we are using formula field, in complete insert event we are only updatig
      primary offering field.     
     
     if(Trigger.isInsert)
    {
       system.debug('%%%%%%%%%%%111%%%%%%%%%');
       for(SAP_OM_Opportunity__c tmpsapOmMaster : lstNewSAPOMMaster)
       {
           lstId.add(tmpsapOmMaster.id);
       }
       List<Opportunity_TGP__c> lstoppTGP = [select id,Offering_Master__c,Primary_offerings__c,TCV__c,SAP_OM_Opportunity__r.name,Client_Geo_Area__c,Client_Geo_Unit__c,Complex_Cost_Architect__r.name,Client_Name__c,Operating_Group__c,Activity__c,Expected_contract_sign_qtr__c,NAme,SAP_OM_Opportunity__c from  Opportunity_TGP__c where SAP_OM_Opportunity__c in :lstId];
       //SOL-170.For updation of Primary offerings. Start
       lstNewSAPOMMaster = [Select id,Max_Offering_Name__c,Client_Name__c,Expected_contract_sign_Quarter__c,TCV__c,Stage__c,
                            Client_Geo_Unit__c,Client_Geo_Area__c,Activity__c,Operating_Group__c,Opportunity_Name__c,Primary_offerings__c,
                            Name,Capital_Project_Mgmt_Total_Net_Rev_perc__c,Care_Management_Total_Net_Rev_perc__c,Customer_Contact_Total_Net_Rev_perc__c,
                            Emerging_Cross_Industry_Total_Net_Rev_pe__c,Emerging_Industry_Specific_TotNet_Rev_pe__c,Finance_Accounting_Total_Net_Rev_perc__c,
                            Health_Administration_Total_Net_Rev_perc__c,Human_Resources_Total_Net_Revenue_perc__c,Insurance_Total_Net_Revenue_perc__c,
                            Learning_Total_Net_Revenue_perc__c,Marketing_Total_Net_Revenue_perc__c,Credit_Services_Total_Net_Revenue_perc__c,
                            Network_Services_Total_Net_Revenue_perc__c,Pharmaceuticals_Total_Net_Revenue_perc__c,Procurement_Total_Net_Revenue_perc__c,
                            Supply_Chain_Total_Net_Revenue_perc__c,Utilities_Total_Net_Revenue_perc__c
                            from SAP_OM_Opportunity__c where id in :lstId ];  
       lstNewOfferingMaster =[Select id,name,Category__c from Offerings_Master__c];
       //Sol-170. End
          for(integer i=0;i<lstNewSAPOMMaster.size();i++)
          {
               //SOL-170.For updation of Primary offerings. Start
               if(lstNewSAPOMMaster[i].Capital_Project_Mgmt_Total_Net_Rev_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Capital_Project_Mgmt_Total_Net_Rev_perc__c>0)
                 {
                 PrimaryOffering1 ='Capital Project Mgmt'+'('+lstNewSAPOMMaster[0].Capital_Project_Mgmt_Total_Net_Rev_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering1 = ' ';
               }
               if(lstNewSAPOMMaster[i].Care_Management_Total_Net_Rev_perc__c !=null)
               {
                 if(lstNewSAPOMMaster[0].Care_Management_Total_Net_Rev_perc__c>0)
                 {
                 PrimaryOffering2 ='Care Management'+'('+lstNewSAPOMMaster[0].Care_Management_Total_Net_Rev_perc__c +' %)';
                 }
                 else
                 PrimaryOffering2 = ' ';
               }
               if(lstNewSAPOMMaster[i].Customer_Contact_Total_Net_Rev_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Customer_Contact_Total_Net_Rev_perc__c>0)
                 {
                 PrimaryOffering3 ='Customer Contact'+'('+lstNewSAPOMMaster[0].Customer_Contact_Total_Net_Rev_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering3= '';               
               }
               if(lstNewSAPOMMaster[i].Emerging_Cross_Industry_Total_Net_Rev_pe__c !=null)
               {
                if(lstNewSAPOMMaster[0].Emerging_Cross_Industry_Total_Net_Rev_pe__c>0)
                {
                PrimaryOffering4 ='Emerging - Cross Industry'+'('+lstNewSAPOMMaster[0].Emerging_Cross_Industry_Total_Net_Rev_pe__c +' %)'; 
                }
                else
                PrimaryOffering4 = ' ';
               }
               if(lstNewSAPOMMaster[i].Emerging_Industry_Specific_TotNet_Rev_pe__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Emerging_Industry_Specific_TotNet_Rev_pe__c>0)
                 {
                 PrimaryOffering5 ='Emerging - Industry Specific'+'('+lstNewSAPOMMaster[0].Emerging_Industry_Specific_TotNet_Rev_pe__c+' %)'; 
                 }
                 else
                 PrimaryOffering5 = ' ';
               }
               if(lstNewSAPOMMaster[i].Finance_Accounting_Total_Net_Rev_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Finance_Accounting_Total_Net_Rev_perc__c>0)
                {
                PrimaryOffering6 ='Finance and Accounting'+'('+lstNewSAPOMMaster[0].Finance_Accounting_Total_Net_Rev_perc__c +' %)'; 
                }
                else
                PrimaryOffering6 = ' ';
               }
               if(lstNewSAPOMMaster[i].Health_Administration_Total_Net_Rev_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Health_Administration_Total_Net_Rev_perc__c>0)
                 {
                 PrimaryOffering7 ='Health Administration'+'('+lstNewSAPOMMaster[0].Health_Administration_Total_Net_Rev_perc__c+' %)';
                 }
                 else
                 PrimaryOffering7 = ' ';
               }
               if(lstNewSAPOMMaster[i].Human_Resources_Total_Net_Revenue_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Human_Resources_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering8 ='Human Resources'+'('+lstNewSAPOMMaster[0].Human_Resources_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering8 = ' ';
               }
               if(lstNewSAPOMMaster[i].Insurance_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Insurance_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering9 ='Insurance'+'('+lstNewSAPOMMaster[0].Insurance_Total_Net_Revenue_perc__c+' %)';
                 }
                 else
                 PrimaryOffering9 = ' ';             
               }
               if(lstNewSAPOMMaster[i].Learning_Total_Net_Revenue_perc__c !=null)
               {
                 if(lstNewSAPOMMaster[0].Learning_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering10 ='Learning'+'('+lstNewSAPOMMaster[0].Learning_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering10= ' ';
               }
               if(lstNewSAPOMMaster[i].Marketing_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Marketing_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering11 ='Marketing'+'('+lstNewSAPOMMaster[0].Marketing_Total_Net_Revenue_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering11 = ' ';
               }
               if(lstNewSAPOMMaster[i].Credit_Services_Total_Net_Revenue_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Credit_Services_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering12 ='Credit Services'+'('+lstNewSAPOMMaster[0].Credit_Services_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering12= ' ';
               }
               if(lstNewSAPOMMaster[i].Network_Services_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Network_Services_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering13 ='Network Services'+'('+lstNewSAPOMMaster[0].Network_Services_Total_Net_Revenue_perc__c+' %)';
                 }
                 else
                 PrimaryOffering13= ' ';                 
               }
               if(lstNewSAPOMMaster[i].Pharmaceuticals_Total_Net_Revenue_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Pharmaceuticals_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering14 ='Pharmaceuticals'+'('+lstNewSAPOMMaster[0].Pharmaceuticals_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering14= ' ';
               }
               if(lstNewSAPOMMaster[i].Procurement_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Procurement_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering15 ='Procurement'+'('+lstNewSAPOMMaster[0].Procurement_Total_Net_Revenue_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering15= ' ';
               }
               if(lstNewSAPOMMaster[i].Supply_Chain_Total_Net_Revenue_perc__c !=null)
               {
                if(lstNewSAPOMMaster[0].Supply_Chain_Total_Net_Revenue_perc__c>0)
                 {
                PrimaryOffering16 ='Supply Chain'+'('+lstNewSAPOMMaster[0].Supply_Chain_Total_Net_Revenue_perc__c +' %)'; 
                }
                else
                PrimaryOffering16= ' ';
               }
               if(lstNewSAPOMMaster[i].Utilities_Total_Net_Revenue_perc__c!=null)
               {
                 if(lstNewSAPOMMaster[0].Utilities_Total_Net_Revenue_perc__c>0)
                 {
                 PrimaryOffering17 ='Utilities'+'('+lstNewSAPOMMaster[0].Utilities_Total_Net_Revenue_perc__c+' %)'; 
                 }
                 else
                 PrimaryOffering17= ' ';
               }
               
               PrimaryOffering=PrimaryOffering1 + ' ' +PrimaryOffering2 + ' ' +PrimaryOffering3 + ' ' +PrimaryOffering4 + ' ' +PrimaryOffering5 + ' ' +PrimaryOffering6 + ' ' +PrimaryOffering7 + ' ' +PrimaryOffering8 + ' ' +PrimaryOffering9 + ' ' +PrimaryOffering10 + ' ' +PrimaryOffering11 + ' ' +PrimaryOffering12 + ' ' +PrimaryOffering13 + ' ' +PrimaryOffering14 + ' ' +PrimaryOffering15 + ' ' +PrimaryOffering16 + ' ' +PrimaryOffering17;
               lstNewSAPOMMaster[i].Primary_offerings__c=PrimaryOffering;
               system.debug('%%%%%%%%%%%%%'+PrimaryOffering);
               
          }
          update lstNewSAPOMMaster;
          
          system.debug('%%%%%12%3%%%%%%%'+lstoppTGP);
          
     }
*/     

}