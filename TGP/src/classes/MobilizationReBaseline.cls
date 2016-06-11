/*
  @Author: Shivraj.Gangabyraiah
  @Name: Mobilization Rebaseline
  @Created Date: 01 January 2015
  @Description: This class is called from Onlick of Custom Button from Mobilization page and when IsTrackingOn checkbox is activated 
                from Mobiliuzation plan and a baseline of record has not happened before. This class contains all methods to do a baseline
                (snapshot) of mobilization plan and all trackers. If there is any exception in any block of code then whole set of data created is
                rolled back with standard salesforce save point to avoid junk data.
  @version: 1.0 
*/
global class MobilizationReBaseline {
    
    /*@Author: Shivraj.gangabyraiah
     *@Name: baselineMobilizationPlan
     *@Created date: 01 January 2015
     *@Description: This method create a baseline copy of main mobilization plan
    */  
    webservice static String baselineMobilizationPlan(String mobilizationPlanID, Boolean checkForTracking){
        
        List<ReBaseline_Query_Fields__c> queryFields = ReBaseline_Query_Fields__c.getAll().values();
        
        String mobQuery = (String)queryFields[0].Mobilization_Plan_Fields__c;
        
        Mobilization_Plan__c mobilizationPlan = new Mobilization_Plan__c(); 
                    
        Baseline_Mobilization_Plan__c baseLineMobilizationPlan = new Baseline_Mobilization_Plan__c();
        
        //Baseline_Mobilization_Plan__c baselineMobPlanNew = new Baseline_Mobilization_Plan__c();
        
        SavePoint baselineSavePoint = Database.setSavePoint();
        
        try{
                    mobilizationPlan = Database.query(mobquery);
                    
                    baseLineMobilizationPlan.Name = utilCOnstants.BASELINE +mobilizationPlan.Name;
                    baseLineMobilizationPlan.deal__C = mobilizationPlan.deal__c;
                    baseLineMobilizationPlan.Mobilization_Plan__c = mobilizationPlanID;
                    baseLineMobilizationPlan.BCP_Type__c = mobilizationPlan.BCP_Type__c;
                    baseLineMobilizationPlan.Contract_Legal_In_Scope__c = mobilizationPlan.Contract_Legal_In_Scope__c;
                    baseLineMobilizationPlan.Service_Management_In_Scope__c = mobilizationPlan.Service_Management_In_Scope__c;
                    baseLineMobilizationPlan.Journey_Management_In_Scope__c = mobilizationPlan.Journey_Management_In_Scope__c;
                    baseLineMobilizationPlan.Version__c = mobilizationPlan.Version__c;
                    baseLineMobilizationPlan.Service_Group__c= mobilizationPlan.Service_Group__c;
                    baseLineMobilizationPlan.IsTrackingOn__c = mobilizationPlan.IsTrackingOn__c;
                    
                    List<Baseline_Mobilization_Plan__c> baselineMobPlanWithMainPlan = [SELECT Baseline_Version__c FROM Baseline_Mobilization_Plan__c WHERE Mobilization_Plan__c = :mobilizationPlanID  ORDER BY Baseline_Version__c DESC LIMIT 1];
                    
                        if((baselineMobPlanWithMainPlan.isEmpty())){
                            baseLineMobilizationPlan.Baseline_Version__c =  1;  
                        }
                        else{
                            baseLineMobilizationPlan.Baseline_Version__c = baselineMobPlanWithMainPlan[0].Baseline_Version__c + 1;  
                        }
                    
                    Database.SaveResult saveRe = Database.insert(baseLineMobilizationPlan);
                    
                    mobilizationPlan.Baseline_Mobilization_Plan__c = saveRe.id;
                    if(checkForTracking){
                        mobilizationPlan.IsTrackingOn__c = true;
                    }
                if(!checkForTracking){
                    Database.upsert(mobilizationPlan);
                }   
                
               
               
               String baselinedMobId = saveRe.id;
               
               
               String message = MobilizationReBaseline.baselineWavePlan(mobilizationPlanID,baselinedMobId,queryFields,checkForTracking);
               
               String commonMessage  = UtilConstants.SUCCESS_MESSAGE + baselinedMobId;
               
               if((UtilConstants.SUCCESS_MESSAGE).equals(message)){
                    if(checkForTracking){
                        return baselinedMobId;
                    }else{
                        return UtilConstants.SUCCESS_MESSAGE;   
                    }
                    
               }else{
                    Database.rollback(baselineSavePoint);
                    return UtilConstants.FAILURE_MESSAGE;
               }
               
        }catch(Exception e){
            Database.rollback(baselineSavePoint);
            return UtilConstants.FAILURE_MESSAGE;
        }
    }
    
    /*@Author: Shivraj.gangabyraiah
     *@Name: baselineWavePlan
     *@Created date: 01 January 2015
     *@Description: This method create a baseline copy of wave after baseline mobilization plan is create
    */  
    public static String baselineWavePlan(String oldMobilizationID,String baselinedMobilizationId,List<ReBaseline_Query_Fields__c> queryFields,Boolean checkForTracking){
        try{
            
            String waveQuery = (String)queryFields[0].Wave_Fields__c;
            List<Wave__c> oldWaveList = Database.Query(waveQuery);
            List<Wave__c> inactiveWaveList = new List<Wave__c>();
            
            Map<Id,Wave__c> waveMap=new Map<Id,wave__c>();
            for(wave__c wave:oldWaveList){
                if(checkForTracking){
                    wave.isTrackingOn__c = true;
                    if(!wave.Active__c){
                        inactiveWaveList.add(wave);
                    }
                }
                    waveMap.put(wave.id,wave);
            }
            
            List<Wave__c> waveNewList = new List<Wave__c>();
            List<Baseline_Wave__c> baselineWaveList = new List<Baseline_Wave__c>();
            
            set<Id> oldWaveId = new set<Id>();
            set<Id> baselineWaveId = new set<Id>();
            set<Id> clonedWaveId = new set<Id>();
            Baseline_Wave__c baselineWave=null;
            if(!oldWaveList.isEmpty()){
                for(Wave__c wave:oldWaveList){
                    if(wave.Active__c){
                        baselineWave = new Baseline_Wave__c();
                    
                        baselineWave.Name = wave.Name;
                    
                        baselineWave.Baseline_Mobilization_Plan__c = baselinedMobilizationId;
                        baselineWave.Wave__c = wave.id;
                        baselineWave.Go_Live_Date__c = wave.Planned_Go_Live_Date__c;
                    
                        
                        baselineWaveList.add(baselineWave);
                    }
                    oldWaveId.add(wave.id);
                }
            }
            
            Database.insert(baselineWaveList);
            
            for(Baseline_Wave__c baselineWaveAfterInsert:[select id,Wave__c from Baseline_Wave__c where Baseline_Mobilization_Plan__c=:baselinedMobilizationId LIMIT 2000]){
                wave__c waveLatest=waveMap.get(baselineWaveAfterInsert.wave__c);
                waveLatest.Baseline_Wave__c=baselineWaveAfterInsert.id;
                /* if(checkForTracking){
                   waveLatest.IsTrackingOn__c =true;
                 } */
                waveNewList.add(waveLatest);
                
                baselineWaveId.add(baselineWaveAfterInsert.id);
            }
            
            waveNewList.addAll(inactiveWaveList);
            Database.upsert(waveNewList);
            
            
            String message = MobilizationReBaseline.baselineWaveProcess(oldMobilizationID,baselinedMobilizationId,oldWaveId,baselineWaveId,queryFields,checkForTracking);
            String ktTrackermessage = MobilizationReBaseline.baselineKtTracker(oldMobilizationID,baselinedMobilizationId,oldWaveId,baselineWaveId,queryFields,checkForTracking);
            
            //system.debug(' exception message from' +message);
            //system.debug('exception message from KT' +ktTrackermessage);
            if((UtilConstants.SUCCESS_MESSAGE).equals(message) && (UtilConstants.SUCCESS_MESSAGE).equals(ktTrackermessage)){
                return UtilConstants.SUCCESS_MESSAGE;
            }else{
                return UtilConstants.FAILURE_MESSAGE;
            }
            
            
        }catch(Exception e){
            return UtilConstants.FAILURE_MESSAGE;
        }
    }
    
    /*@Author: Shivraj.gangabyraiah
     *@Name: baselineWaveProcess
     *@Created date: 01 January 2015
     *@Description: This method create a baseline copy of wave after baseline mobilization plan and baselinew wave is created
    */  
    public static String baselineWaveProcess(String oldMobilizationID, String baselineMobId, set<Id> oldWaveId,set<Id> baselineWaveId,List<ReBaseline_Query_Fields__c> queryFields,Boolean checkForTracking){
        
        
        try{
            //system.debug('Set of Id is:: oldWave Id' +oldWaveId + 'Basline ID' +baselineWaveId );
            
            // String waveProcessQuery = (String)queryFields[0].Wave_Process_Fields__c;
            
            //String waveProcessQuery = UtilConstants.SOQL_STRING3;
            String waveProcessQuery = 'SELECT  Id,Active__c,Wave__r.Active__c,Name,Wave__c,Sending_Location__c, Wave_Infrastructure_Service__c, Wave_Process_Location__c,Mobilization_Plan__c,IsTrackingOn__c,Wave_Client_Specific_Process__c,Number_of_Projected_FTEs__c,Baseline_Wave_Process__c FROM Wave_Proc__c    WHERE Mobilization_Plan__c = :oldMobilizationID AND Wave__c IN : oldWaveId AND Wave__r.Active__c=TRUE AND Active__c=TRUE';
            List<Wave_Proc__c> oldWaveProcess = Database.query(waveProcessQuery);
            List<Wave_Proc__c> inactiveWavePrcs = new List<Wave_Proc__c> ();
            Map<Id,Wave_Proc__c> waveProcessMap=new Map<Id,Wave_Proc__c>();
            Map<Id,Baseline_Wave__c> waveProcessWithBaselineWaveMap=new Map<Id,Baseline_Wave__c>();
            for(Wave_Proc__c waveProc:oldWaveProcess){
                if(checkForTracking){
                    waveProc.isTrackingOn__c = true;
                    if(!waveProc.Active__c || !waveProc.wave__r.Active__c){
                        inactiveWavePrcs.add(waveProc);
                    }
                }
                               
                waveProcessMap.put(waveProc.Id,waveProc);
                //waveProcessWithBaselineWaveMap.put(waveProc.wave__c,waveProc);
            }
            
            for(Baseline_Wave__c baseline:[select id,name,Wave__c,Baseline_Mobilization_Plan__c from Baseline_Wave__c where id IN :baselineWaveId LIMIT 2000]){
                 waveProcessWithBaselineWaveMap.put(baseline.wave__c,baseline);
            }           
            List<Baseline_Wave_Process__c> baselineWaveProcess = new List<Baseline_Wave_Process__c>();
            Baseline_Wave_Process__c baseWaveProcess=null;
            if(!oldWaveProcess.isEmpty()){
                for(Wave_Proc__c waveProcess:oldWaveProcess ){
                   if(waveProcess.Active__c && waveProcess.wave__r.Active__c){
                       Baseline_Wave__c baseline=waveProcessWithBaselineWaveMap.get(waveProcess.Wave__c);
                    
                        baseWaveProcess = new Baseline_Wave_Process__c();
                        baseWaveProcess.Name = waveProcess.Name;
                        baseWaveProcess.Baseline_Mobilization_Plan__c = baseline.Baseline_Mobilization_Plan__c;
                        baseWaveProcess.Baseline_Wave__c = baseline.id;
                        baseWaveProcess.Wave_Process__c = waveProcess.id;
                        baseWaveProcess.Wave_Process_Location__c = waveProcess.Wave_Process_Location__c;
                        baseWaveProcess.Wave_Client_Process__c = waveProcess.Wave_Client_Specific_Process__c;
                        baseWaveProcess.Wave_Infrastructure_Service__c = waveProcess.Wave_Infrastructure_Service__c;
                        baseWaveProcess.Sending_Location__c= waveProcess.Sending_Location__c;
                        baseWaveProcess.Number_of_Projected_FTEs__c = waveProcess.Number_of_Projected_FTEs__c;
                                
                        baselineWaveProcess.add(baseWaveProcess);
                                        
                    }    
                }
            }
            
            
            Database.insert(baselineWaveProcess);
            
            List<Wave_Proc__c> wavePNew = new List<Wave_Proc__c>();
            
            for(Baseline_Wave_Process__c bndWaveProcess:[select id,Baseline_Wave__c,Wave_Process__c from Baseline_Wave_Process__c where Baseline_Wave__c IN :baselineWaveId LIMIT 2000]){
                
                Wave_Proc__c wprocess=waveProcessMap.get(bndWaveProcess.Wave_Process__c);
                wprocess.Baseline_Wave_Process__c = bndWaveProcess.id;
                /*
                if(checkForTracking){
                     wprocess.IsTrackingOn__c = true;
                }      
                */                     
                wavePNew.add(wprocess);
            }
            
            wavePNew.addAll(inactiveWavePrcs);
            Database.upsert(wavePNew);
            
            return UtilConstants.SUCCESS_MESSAGE;
            
        }
            
        catch(Exception e){
            return UtilConstants.FAILURE_MESSAGE;
        }
    }
    
    /*@Author: Shivraj.gangabyraiah
     *@Name: baselineKtTracker
     *@Created date: 01 January 2015
     *@Description: This method creates a baseline copy of wave trackers and mobilization plan trackers after baseline mobilization plan and baseline wave is created
    */ 
    public static String baselineKtTracker(String oldMobilizationID, String baselineMobId, set<Id> oldWaveId,set<Id> baselineWaveId,List<ReBaseline_Query_Fields__c> queryFields,Boolean checkForTracking){
        
        try{
            
            List<KT_Trac__c> oldKtTrackerList = new List<KT_Trac__c>();
            List<KT_Trac__c> inactiveKtList = new List<KT_Trac__c>();
            List<Baseline_KT_Tracker__c> baselinedKtTrackerList = new List<Baseline_KT_Tracker__c>();
            
            List<Baseline_KT_Tracker__c> baselineNewKtTrackerList = new List<Baseline_KT_Tracker__c>();
            
            //String ktTrackerQuery = (String)queryFields[0].KT_Tracker__c;
            
            String ktTrackerQuery=UtilConstants.KT_QUERY;
            
            oldKtTrackerList = Database.query(ktTrackerQuery);
            
            Map<Id,KT_Trac__c> ktTrackerMap=new Map<Id,KT_Trac__c>();
            for(KT_Trac__c kttrac:oldKtTrackerList){
                if(checkForTracking){
                    kttrac.isTrackingOn__c = true;
                    if(!kttrac.Wave__r.Active__c || !kttrac.Active__c){
                        inactiveKtList.add(kttrac);
                    }
                }
                ktTrackerMap.put(kttrac.id,kttrac);
            }
            
            List<Baseline_Wave__c> baselinedWaves = new List<Baseline_Wave__c>();
            Map<Id,Baseline_Wave__c> baselinedMap=new Map<Id,Baseline_Wave__c>();
            
            for(Baseline_Wave__c baselineWave:[select id,name,Wave__c,Baseline_Mobilization_Plan__c from Baseline_Wave__c where id IN :baselineWaveId LIMIT 2000]){
                baselinedMap.put(baselineWave.Wave__c,baselineWave);
            }
            
            /*
             * Code block to baseline KT tracker startr, this block requires id's of mobilization,wave and respective basleine records
             * the records ard cloned based on tagging between Mobilization plan and Wave.
            */
            Baseline_KT_Tracker__c baseKtTracker=null;
            if(!(oldKtTrackerList.isEmpty())){
                for(KT_Trac__c ktTracker:oldKtTrackerList){
                    if(ktTracker.Active__c && ktTracker.Wave__r.Active__c){
                        Baseline_Wave__c baselineWave=baselinedMap.get(ktTracker.Wave__c);
                    
                        baseKtTracker = new Baseline_KT_Tracker__c();
                        baseKtTracker.Name = ktTracker.Name;
                        baseKtTracker.Active__c = ktTracker.Active__c;
                        baseKtTracker.KT_Tracker__c = ktTracker.id;
                        baseKtTracker.Baseline_Wave__c = baselineWave.id;
                        baseKtTracker.Baseline_Mobilization_Plan__c = baselineWave.Baseline_Mobilization_Plan__c;
                        baseKtTracker.Milestone__c = ktTracker.Milestone__c;
                        baseKtTracker.Start_Date__c = ktTracker.Planned_Start_Date__c;
                        baseKtTracker.End_Date__c = ktTracker.Planned_End_Date__c;
                            
                        baselinedKtTrackerList.add(baseKtTracker);
                    }
                }
            }
            
            Database.insert(baselinedKtTrackerList);
            
            List<KT_Trac__c> KtTrackerNewList = new List<KT_Trac__c>();
            for(Baseline_KT_Tracker__c baselineKtTracker:[select id,Baseline_Wave__c,KT_Tracker__c from Baseline_KT_Tracker__c where Baseline_Wave__c IN : baselineWaveId LIMIT 2000]){
                
                KT_Trac__c ktTracker=ktTrackerMap.get(baselineKtTracker.KT_Tracker__c);
                
                ktTracker.Baseline_KT_Tracker__c = baselineKtTracker.id;
                /*
                if(checkForTracking){
                   ktTracker.IsTrackingOn__c = true;
                }*/
                
                KtTrackerNewList.add(ktTracker);
                
            }
            
            KtTrackerNewList.addAll(inactiveKtList);
            Database.upsert(KtTrackerNewList);
            
            /*
             * Method to clone Kt Tracker ends here
            */
            
            /*
             * Code block to baseline Recruitment tracker starts, this block requires id's of mobilization,wave and respective basleine records
             * the records ard cloned based on tagging between Mobilization plan and Wave.
            */
            
            
            List<Recruit_Tracker__c> oldRecruitmentTrackerList = new List<Recruit_Tracker__c>();
            List<Recruit_Tracker__c> inactiveRecrList = new List<Recruit_Tracker__c>();
            List<Baseline_Recruitment_Tracker__c> baselineRecruitementTrackerList = new List<Baseline_Recruitment_Tracker__c>();
            
            //String recruitmentQuery = (String)queryFields[0].Recruitment_Tracker_Fields__c;
            
            String recruitmentQuery=UtilConstants.RECRUITMENT_QUERY;
            oldRecruitmentTrackerList = Database.query(recruitmentQuery);
            Map<Id,Recruit_Tracker__c> recruitMap=new Map<Id,Recruit_Tracker__c>();
            for(Recruit_Tracker__c recruit:oldRecruitmentTrackerList){
                if(checkForTracking){
                    recruit.isTrackingOn__c = true;
                        if(!recruit.Active__c|| !recruit.Wave__r.Active__c){
                            inactiveRecrList.add(recruit);
                        }
                }
                recruitMap.put(recruit.id,recruit);
            }
            Baseline_Recruitment_Tracker__c baselineRecruitTracker=null;
            if(!(oldRecruitmentTrackerList.isEmpty())){
                for(Recruit_Tracker__c recruitmentTracker:oldRecruitmentTrackerList){
                    if(recruitmentTracker.Active__c && recruitmentTracker.Wave__r.Active__c){
                        Baseline_Wave__c baseWave=baselinedMap.get(recruitmentTracker.Wave__c);
                        baselineRecruitTracker = new Baseline_Recruitment_Tracker__c();
                                
                        baselineRecruitTracker.Recruitment_Tracker__c = recruitmentTracker.id;
                        baselineRecruitTracker.Baseline_Mobilization_Plan__c = baseWave.Baseline_Mobilization_Plan__c;
                        baselineRecruitTracker.Baseline_Wave__c = baseWave.id;
                        baselineRecruitTracker.Name = recruitmentTracker.Name;
                        baselineRecruitTracker.Active__c = recruitmentTracker.Active__c;
                        baselineRecruitTracker.Milestone__c = recruitmentTracker.Milestone__c;
                        baselineRecruitTracker.Start_Date__c = recruitmentTracker.Planned_Start_Date__c;
                        baselineRecruitTracker.End_Date__c = recruitmentTracker.Planned_End_Date__c;
                                
                        baselineRecruitementTrackerList.add(baselineRecruitTracker);
                   }   
                }
                
            }
            
            Database.insert(baselineRecruitementTrackerList);
            
            
            List<Recruit_Tracker__c> recruitmentNewList = new List<Recruit_Tracker__c>();
            for(Baseline_Recruitment_Tracker__c basRctmtTracker:[select id,name,Baseline_Wave__c,Recruitment_Tracker__c FROM Baseline_Recruitment_Tracker__c WHERE Baseline_Wave__c IN :baselineWaveId LIMIT 2000]){
                
                Recruit_Tracker__c oldRcmtTracker=recruitMap.get(basRctmtTracker.Recruitment_Tracker__c);
                oldRcmtTracker.Baseline_Recruitment_Tracker__c = basRctmtTracker.id;
                /*
                if(checkForTracking){
                    oldRcmtTracker.IsTrackingOn__c =true;
                }
                */
                recruitmentNewList.add(oldRcmtTracker);
            }
            
            recruitmentNewList.addAll(inactiveRecrList);
            Database.upsert(recruitmentNewList);
            
            /*
             * Recruitment Tracker Method ends here
            */
            
            /*
             * Tech & WE Tracker method starte here
            */
            
            List<Tech_WE_Tracker__c> oldTechWETrackerList = new List<Tech_WE_Tracker__c>();
            List<Tech_WE_Tracker__c> inactiveTechWEList = new List<Tech_WE_Tracker__c>();
            List<Baseline_Tech_WE_Tracker__c> baselineTechWETrackerList = new List<Baseline_Tech_WE_Tracker__c>();
            
            //String techWeQuery = (String)queryFields[0].Tech_And_WE__c;
            
            String techWeQuery=UtilConstants.TECH_QUERY;
            
            oldTechWETrackerList = Database.Query(techWeQuery);
            Map<Id,Tech_WE_Tracker__c> tecnAndWEMap=new Map<Id,Tech_WE_Tracker__c>();
            for(Tech_WE_Tracker__c tech:oldTechWETrackerList){
                if(checkForTracking){
                    tech.isTrackingOn__c = true;
                    if(!tech.Active__c || !tech.Wave__r.Active__c){
                        inactiveTechWEList.add(tech);
                    }
                }
               tecnAndWEMap.put(tech.id,tech);
            }
            Baseline_Tech_WE_Tracker__c baselineTechTracker=null;
            if(!(oldTechWETrackerList.isEmpty())){
                
                for(Tech_WE_Tracker__c techAndWETracker:oldTechWETrackerList){
                    if(techAndWETracker.Active__c && techAndWETracker.Wave__r.Active__c){
                        Baseline_Wave__c baseWave=baselinedMap.get(techAndWETracker.Wave__c);
                        baselineTechTracker = new Baseline_Tech_WE_Tracker__c();
                            
                        baselineTechTracker.Name = techAndWETracker.Name;
                        baselineTechTracker.Tech_WE_Tracker__c = techAndWETracker.id;
                        baselineTechTracker.Baseline_Wave__c = baseWave.id;
                        baselineTechTracker.Baseline_Mobilization_Plan__c = baseWave.Baseline_Mobilization_Plan__c;
                        baselineTechTracker.Active__c = techAndWETracker.Active__c;
                        baselineTechTracker.Milestone_del__c = techAndWETracker.Milestone__c;
                        baselineTechTracker.Start_Date__c = techAndWETracker.Planned_Start_Date__c;
                        baselineTechTracker.End_Date__c = techAndWETracker.Planned_End_Date__c;
                                
                        baselineTechWETrackerList.add(baselineTechTracker);
                    }    
                }
                
            }
            
            Database.insert(baselineTechWETrackerList);
            
            List<Tech_WE_Tracker__c> techAndWeNewList = new List<Tech_WE_Tracker__c>();
            
            
            for(Baseline_Tech_WE_Tracker__c baselineTechWETracker:[select id,name,Tech_WE_Tracker__c,Baseline_Wave__c FROM Baseline_Tech_WE_Tracker__c where Baseline_Wave__c IN :baselineWaveId LIMIT 2000]){
                
                Tech_WE_Tracker__c techAndWETracker=tecnAndWEMap.get(baselineTechWETracker.Tech_WE_Tracker__c);
                techAndWETracker.Baseline_Tech_WE_Tracker__c = baselineTechWETracker.id;
                /*        
                if(checkForTracking){
                    techAndWETracker.IsTrackingOn__c =true;
                }
                */
                techAndWeNewList.add(techAndWETracker);
            }
            
            techAndWeNewList.addAll(inactiveTechWEList);
            Database.upsert(techAndWeNewList);
            /*
             * Tech and WE Trcker clone method code completed here
            */
            
            /*
             * SRAT Tracker cloning begins
            */
            
            List<SRAT_Tracker__c> oldSRATTrackerList = new List<SRAT_Tracker__c>();
            List<SRAT_Tracker__c> inactiveSRATList = new List<SRAT_Tracker__c>();
            List<Baseline_SRAT_Tracker__c> baselineSRATTrackerList = new List<Baseline_SRAT_Tracker__c>();
            
            //String sratQuery = (String)queryFields[0].SRAT_Tracker_Fields__c;
            
           
            
            oldSRATTrackerList = [SELECT ID,Name,Wave__r.Active__c,IsTrackingOn__c,Days_Before_Go_Live__c,Baseline_SRAT_Tracker__c,Wave__c,Milestone__c,Mobilization_Plan__c,Active__c FROM SRAT_Tracker__c WHERE Mobilization_Plan__c = :oldMobilizationID AND Wave__c IN : oldWaveId LIMIT 2000];
            Map<Id,SRAT_Tracker__c> sratMap=new Map<Id,SRAT_Tracker__c>();
            for(SRAT_Tracker__c srat:oldSRATTrackerList){
                if(checkForTracking){
                    srat.isTrackingOn__c = true;
                    if(!srat.Active__c || !srat.Wave__r.Active__c){
                        inactiveSRATList.add(srat);
                    }
                }
                sratMap.put(srat.id,srat);
            }
            Baseline_SRAT_Tracker__c baselineSRAT=null;
            if(!(oldSRATTrackerList.isEmpty())){
                for(SRAT_Tracker__c SRATTrcker:oldSRATTrackerList){
                    if(SRATTrcker.Active__c && SRATTrcker.Wave__r.Active__c){
                        Baseline_Wave__c baseWave=baselinedMap.get(SRATTrcker.Wave__c);
                    
                        baselineSRAT = new Baseline_SRAT_Tracker__c();
                        baselineSRAT.Name = SRATTrcker.Name;
                        baselineSRAT.SRAT_Tracker__c = SRATTrcker.id;
                        baselineSRAT.Active__c = SRATTrcker.Active__c;
                        baselineSRAT.Milestone__c = SRATTrcker.Milestone__c;
                        baselineSRAT.Baseline_Wave__c = baseWave.id;
                        baselineSRAT.Baseline_Mobilization_Plan__c = baseWave.Baseline_Mobilization_Plan__c;
                        baselineSRAT.Days_Before_Go_Live__c = SRATTrcker.Days_Before_Go_Live__c ;
                        baselineSRATTrackerList.add(baselineSRAT);
                    }
                }   
            }
            
            Database.insert(baselineSRATTrackerList);
            
            List<SRAT_Tracker__c> sratTrackerNewList = new List<SRAT_Tracker__c>();
            for(Baseline_SRAT_Tracker__c baselineSRATTracker:[select id,name,Baseline_Wave__c,SRAT_Tracker__c from Baseline_SRAT_Tracker__c WHERE Baseline_Wave__c IN :baselineWaveId LIMIT 2000]){
                SRAT_Tracker__c sratTracker=sratMap.get(baselineSRATTracker.SRAT_Tracker__c);
                sratTracker.Baseline_SRAT_Tracker__c = baselineSRATTracker.id;
                /*
                if(checkForTracking){
                     sratTracker.IsTrackingOn__c =true;
                }
                */
                sratTrackerNewList.add(sratTracker);
                
            }
            
            sratTrackerNewList.addAll(inactiveSRATList);
            Database.upsert(sratTrackerNewList);
            
            /*
             * SRAT code block completed
            */
            
            /*
             * Opex Tracker code block started
            */
            
            List<OPEX_Tracker__c> oldOpexTrackkerList = new List<OPEX_Tracker__c>();
            List<OPEX_Tracker__c> inactiveOpexList = new List<OPEX_Tracker__c>();
            List<Baseline_OPEX_Tracker__c> baselinedOpexTrackerList = new List<Baseline_OPEX_Tracker__c>();
            
            //String opexQuery = (String)queryFields[0].Opex_Tracker_Fields__c;
            
            String opexQuery = UtilConstants.OPEX_QUERY; 
            
            oldOpexTrackkerList = Database.Query(opexQuery);
            
            Map<Id,OPEX_Tracker__c> opexMap=new Map<Id,OPEX_Tracker__c>();
            for(OPEX_Tracker__c opex:oldOpexTrackkerList){
                if(checkForTracking){
                    opex.isTrackingOn__c = true;
                    if(!opex.Active__c || !opex.Wave__r.Active__c){
                        inactiveOpexList.add(opex);
                    }
                }
                opexMap.put(opex.id,opex);
            }
            Baseline_OPEX_Tracker__c baselineOpexTracker=null;
            if(!(oldOpexTrackkerList.isEmpty())){
                                
                for(OPEX_Tracker__c opexTracker:oldOpexTrackkerList){
                    if(opexTracker.Active__c && opexTracker.Wave__r.Active__c){
                        Baseline_Wave__c baseWave=baselinedMap.get(opexTracker.Wave__c);    
                    
                        baselineOpexTracker = new Baseline_OPEX_Tracker__c();
                        baselineOpexTracker.Name = opexTracker.Name;
                        baselineOpexTracker.Active__c = opexTracker.Active__c;
                        baselineOpexTracker.Baseline_Wave__c = baseWave.id;
                        baselineOpexTracker.Baseline_Mobilization_Plan__c = baseWave.Baseline_Mobilization_Plan__c;
                        baselineOpexTracker.OPEX_Tracker__c = opexTracker.id;
                        baselineOpexTracker.Milestone__c = opexTracker.Milestone__c;
                        baselineOpexTracker.Checklist_Status__c = opexTracker.Checklist_Status__c;
                        baselineOpexTracker.Days_After_Go_Live__c = opexTracker.Days_After_Go_Live__c;
                        baselinedOpexTrackerList.add(baselineOpexTracker);
                    }
                }
            }
            
            Database.insert(baselinedOpexTrackerList);
            
            List<OPEX_Tracker__c> opexTrackerNewList = new List<OPEX_Tracker__c>();
            
            for(Baseline_OPEX_Tracker__c baslineOpTracker:[select id,name,Baseline_Wave__c,OPEX_Tracker__c FROM Baseline_OPEX_Tracker__c WHERE Baseline_Wave__c IN :baselineWaveId LIMIT 2000]){
               
                OPEX_Tracker__c opxTracker=opexMap.get(baslineOpTracker.OPEX_Tracker__c);
                opxTracker.Baseline_OPEX_Tracker__c = baslineOpTracker.id;
                /*
                if(checkForTracking){
                      opxTracker.IsTrackingOn__c =true;
                }
                */
                 opexTrackerNewList.add(opxTracker);
            }
            
            opexTrackerNewList.addAll(inactiveOpexList);
            Database.upsert(opexTrackerNewList);
            /*
             * Opex tracker baseline code ends here
            */
            
            /*
             * Method to clone BCP Tracker begins here
            */
            
            List<BCP_Tracker__c> oldBCPTrackerList = new List<BCP_Tracker__c>();
            List<BCP_Tracker__c> inactiveBCPList = new List<BCP_Tracker__c>();
            List<Baseline_BCP_Tracker__c> baselineBCPTrackerList = new List<Baseline_BCP_Tracker__c>();
            
            String bcpTrackerQuery=queryFields[0].BCP_Tracker_Fields__c;
            
            oldBCPTrackerList = Database.Query(bcpTrackerQuery);
            
            Map<Id,BCP_Tracker__c> bcpMap=new Map<Id,BCP_Tracker__c>();
            for(BCP_Tracker__c bcp:oldBCPTrackerList){
               if(checkForTracking){
                   bcp.isTrackingOn__c = true;
                   if(!bcp.Active__c){
                       inactiveBCPList.add(bcp);
                   }
               }
               bcpMap.put(bcp.id,bcp); 
            }
            Baseline_BCP_Tracker__c baselineBCPTracker=null;
            if(!oldBCPTrackerList.isEmpty()){
                for(BCP_Tracker__c bcpTracker:oldBCPTrackerList){
                    if(bcpTracker.Active__c){
                        baselineBCPTracker = new Baseline_BCP_Tracker__c();
                        
                        baselineBCPTracker.Name = bcpTracker.Name;
                        baselineBCPTracker.BCP_Tracker__c = bcpTracker.id;
                        baselineBCPTracker.Active__c = bcpTracker.Active__c;
                        baselineBCPTracker.Milestone__c = bcpTracker.Milestone__c;
                        baselineBCPTracker.Baseline_Mobilization_Plan__c = baselineMobId;
                        baselineBCPTracker.Section__c = bcpTracker.Section__c; 
                        baselineBCPTracker.Resource_Name__c = bcpTracker.Resource_Name__c;
                        baselineBCPTracker.Start_Date__c = bcpTracker.Planned_Start_Date__c;
                        baselineBCPTracker.End_Date__c = bcpTracker.Planned_End_Date__c;
                    
                        baselineBCPTrackerList.add(baselineBCPTracker);
                    }
                }
            }
            
            Database.insert(baselineBCPTrackerList);
    
            List<BCP_Tracker__c> bcpTrackerList = new List<BCP_Tracker__c>();
    
            for(Baseline_BCP_Tracker__c baselineTracker:[select id,BCP_Tracker__c,Baseline_Mobilization_Plan__c FROM Baseline_BCP_Tracker__c WHERE Baseline_Mobilization_Plan__c = :baselineMobId LIMIT 2000]){
                
                BCP_Tracker__c bcpTracker=bcpMap.get(baselineTracker.BCP_Tracker__c);
                bcpTracker.Baseline_BCP_Tracker__c = baselineTracker.id;
                /*
                if(checkForTracking){
                   bcpTracker.IsTrackingOn__c =true;
                }
                */
                bcpTrackerList.add(bcpTracker);
            }
            
            bcpTrackerList.addAll(inactiveBCPList);
            Database.upsert(bcpTrackerList);
            
            /*
             * BCP Tracker cloning method completed
            */
            
            /*
             * Budget Tracker method starts
            */
            
            List<Budget_Trac__c> oldBudgetTrackerList = new List<Budget_Trac__c>();
            List<Budget_Trac__c> inactiveBudgetList = new List<Budget_Trac__c>();
            List<Baseline_Budget_Tracker__c> baselineBudgetTrackerList = new List<Baseline_Budget_Tracker__c>();
            
            String budgetQuery=(String)queryFields[0].Budget_Tracker_Fields__c;
            
            oldBudgetTrackerList = Database.Query(budgetQuery);
            Map<Id,Budget_Trac__c> budgetMap=new Map<Id,Budget_Trac__c>();
            for(Budget_Trac__c budget:oldBudgetTrackerList){
                if(checkForTracking){
                    budget.isTrackingOn__c = true;
                    if(!budget.Active__c){
                        inactiveBudgetList.add(budget);
                    }
                }
                budgetMap.put(budget.id,budget);
            }
            
            Baseline_Budget_Tracker__c baselineBudgetTracker=null;
            if(!(oldBudgetTrackerList.isEmpty())){
                for(Budget_Trac__c budgetTracker:oldBudgetTrackerList){
                    if(budgetTracker.Active__c){
                        baselineBudgetTracker = new Baseline_Budget_Tracker__c();
                    
                        baselineBudgetTracker.Budget_Tracker__c = budgetTracker.id;
                        baselineBudgetTracker.Name = budgetTracker.Name;
                        baselineBudgetTracker.Baseline_Mobilization_Plan__c = baselineMobId;
                        baselineBudgetTracker.Milestone__c = budgetTracker.Milestone__c;
                        baselineBudgetTracker.Start_Date__c = budgetTracker.Planned_Start_Date__c;
                        baselineBudgetTracker.End_Date__c = budgetTracker.Planned_End_Date__c;
                        
                        baselineBudgetTrackerList.add(baselineBudgetTracker);
                    }
                }
            }
            
            Database.insert(baselineBudgetTrackerList);
            
            
            
            List<Budget_Trac__c> budgetTrackerList = new List<Budget_Trac__c>();
            
            for(Baseline_Budget_Tracker__c baselineBdgeTracker:[select id,Name,Baseline_Mobilization_Plan__c,Budget_Tracker__c FROM Baseline_Budget_Tracker__c WHERE Baseline_Mobilization_Plan__c = :baselineMobId LIMIT 2000]){
                
                Budget_Trac__c oldBudgetTr=budgetMap.get(baselineBdgeTracker.Budget_Tracker__c);
                oldBudgetTr.Baseline_Budget_Tracker__c = baselineBdgeTracker.id;
                /*
                if(checkForTracking){
                   oldBudgetTr.IsTrackingOn__c =true;
                }
                */
                budgetTrackerList.add(oldBudgetTr);
            }
            
            //system.debug('Not Sync with server');
            budgetTrackerList.addAll(inactiveBudgetList);
            Database.upsert(budgetTrackerList);
            
            
            /*
             *Budget Tracker method ends
            */
            
            /*
             * Contarct And Legal Tracker Code Starts here
            */
            
            List<Contract_Legal_Tracker__c> oldContarctTrackerList = new List<Contract_Legal_Tracker__c>();
            List<Contract_Legal_Tracker__c> inactiveContractList = new List<Contract_Legal_Tracker__c>();
            List<Baseline_Contract_Legal_Tracker__c> baselineContractTrackerList = new List<Baseline_Contract_Legal_Tracker__c>();
            
            String contractQuery=(String)queryFields[0].Contract_And_Legal_Tracker_Fields__c;
            
            oldContarctTrackerList = Database.query(contractQuery);
            Map<Id,Contract_Legal_Tracker__c> contractMap=new Map<Id,Contract_Legal_Tracker__c>();
            for(Contract_Legal_Tracker__c contract:oldContarctTrackerList){
                if(checkForTracking){
                    contract.isTrackingOn__c = true;
                    if(!contract.Active__c){
                        inactiveContractList.add(contract);
                    }
                }
                contractMap.put(contract.id,contract);
            }
            
            Baseline_Contract_Legal_Tracker__c baselineContractTracker=null;
            if(!(oldContarctTrackerList.isEmpty())){
                for(Contract_Legal_Tracker__c contractTracker:oldContarctTrackerList){
                    if(contractTracker.Active__c){
                        baselineContractTracker = new Baseline_Contract_Legal_Tracker__c();
                    
                        baselineContractTracker.Name = contractTracker.name;
                        baselineContractTracker.Milestone__c = contractTracker.Milestone__c;
                        baselineContractTracker.Section__c = contractTracker.Section__c;
                        baselineContractTracker.Resource_Name__c = contractTracker.Resource_Name__c;
                        baselineContractTracker.Baseline_Mobilization_Plan__c = baselineMobId;
                        baselineContractTracker.Contract_Legal_Tracker__c = contractTracker.id;
                        baselineContractTracker.Start_Date__c = contractTracker.Planned_Start_Date__c;
                        baselineContractTracker.End_Date__c = contractTracker.Planned_End_Date__c;
                        baselineContractTracker.Status__c = contractTracker.Status__c;
                        baselineContractTrackerList.add(baselineContractTracker);
                   }
                }
            }
            
            Database.insert(baselineContractTrackerList);
            
            List<Contract_Legal_Tracker__c>  contractTrackerList = new List<Contract_Legal_Tracker__c>();
            
            for(Baseline_Contract_Legal_Tracker__c baselineContractTracker1: [select id,name,Baseline_Mobilization_Plan__c,Contract_Legal_Tracker__c FROM Baseline_Contract_Legal_Tracker__c WHERE Baseline_Mobilization_Plan__c = :baselineMobId LIMIT 2000]){
                
                Contract_Legal_Tracker__c oldContractTracker=contractMap.get(baselineContractTracker1.Contract_Legal_Tracker__c);
                oldContractTracker.Baseline_Contract_Tracker__c = baselineContractTracker1.id;
                /*
                if(checkForTracking){
                    oldContractTracker.IsTrackingOn__c =true;
                }
                */
                contractTrackerList.add(oldContractTracker);
            }
            
            contractTrackerList.addAll(inactiveContractList);
            Database.upsert(contractTrackerList);
            
            /*
             * Contract and Legal Tracker code ends here
            */
            
            /*
             * Service management tracker code starts here
            */
            
            List<Service_Management_Tracker__c> oldServiceMgmtTrackerList = new List<Service_Management_Tracker__c>();
            List<Service_Management_Tracker__c> inactiveServiceList = new List<Service_Management_Tracker__c>();
            List<Baseline_Service_Management_Tracker__c> baselineServiceMgmtTrackerList = new List<Baseline_Service_Management_Tracker__c>();
            
            String serviceQuery=(String)queryFields[0].Service_Management_Tracker_Fields__c;
            
            oldServiceMgmtTrackerList = Database.query(serviceQuery);
            Map<Id,Service_Management_Tracker__c> serviceMap=new Map<Id,Service_Management_Tracker__c>();
            for(Service_Management_Tracker__c service:oldServiceMgmtTrackerList){
                if(checkForTracking){
                    service.isTrackingOn__c = true;
                    if(!service.Active__c){
                        inactiveServiceList.add(service);
                    }
                }
                serviceMap.put(service.id,service);
            }
            
            Baseline_Service_Management_Tracker__c baselineServiceTracker=null;
            if(!(oldServiceMgmtTrackerList.isEmpty())){
                for(Service_Management_Tracker__c serviceTracker:oldServiceMgmtTrackerList){
                    if(serviceTracker.Active__c){
                        baselineServiceTracker = new Baseline_Service_Management_Tracker__c();
                        baselineServiceTracker.Name = serviceTracker.Name;
                        baselineServiceTracker.Service_Management_Tracker__c = serviceTracker.id;
                        baselineServiceTracker.Milestone__c = serviceTracker.Milestone__c;
                        baselineServiceTracker.Section__c = serviceTracker.Section__c;
                        baselineServiceTracker.Resource_Name__c = serviceTracker.Resource_Name__c;
                        baselineServiceTracker.Baseline_Mobilization_Plan__c = baselineMobId;
                        baselineServiceTracker.Start_Date__c = serviceTracker.Planned_Start_Date__c;
                        baselineServiceTracker.End_Date__c = serviceTracker.Planned_End_Date__c;
                    
                        baselineServiceMgmtTrackerList.add(baselineServiceTracker);
                    }   
                }
            }
            
            Database.insert(baselineServiceMgmtTrackerList);
            
            List<Service_Management_Tracker__c> serviceList = new List<Service_Management_Tracker__c>();
            
            for(Baseline_Service_Management_Tracker__c baselineServiceTracker1:[select id,name,Baseline_Mobilization_Plan__c,Service_Management_Tracker__c FROM Baseline_Service_Management_Tracker__c WHERE Baseline_Mobilization_Plan__c = :baselineMobId LIMIT 2000]){
                
                Service_Management_Tracker__c serviceMgmTracker=serviceMap.get(baselineServiceTracker1.Service_Management_Tracker__c);
                serviceMgmTracker.Baseline_Service_Management_Tracker__c = baselineServiceTracker1.id;
                /*
                if(checkForTracking){
                    serviceMgmTracker.IsTrackingOn__c =true;
                }
                */
                serviceList.add(serviceMgmTracker);
            }
            
            serviceList.addAll(inactiveServiceList);
            Database.upsert(serviceList);
            
            /*
             * Service Management Tracker code ends here
            */
            
            /*
             * Journey Management Tracker code starts here
            */
            
            List<Journey_Management_Tracker__c> oldJourneyMgmtTrackerList = new List<Journey_Management_Tracker__c>();
            List<Journey_Management_Tracker__c> inactiveJrnyList = new List<Journey_Management_Tracker__c>();
            List<Baseline_Journey_Management_Tracker__c> baselineJourneyMgmtList =  new List<Baseline_Journey_Management_Tracker__c>();
            
            String journeyQuery=(String)queryFields[0].Journey_Management_Tracker_Fields__c;
            
            oldJourneyMgmtTrackerList = Database.query(journeyQuery);
            Map<Id,Journey_Management_Tracker__c> journeyMap=new Map<Id,Journey_Management_Tracker__c>();
            for(Journey_Management_Tracker__c journey:oldJourneyMgmtTrackerList){
                if(checkForTracking){
                    journey.isTrackingOn__c = true;
                    if(!journey.Active__c){
                        inactiveJrnyList.add(journey);
                    }
                }
                journeyMap.put(journey.id,journey);
            }
            
            Baseline_Journey_Management_Tracker__c baselineJourneyTracker=null;
            if(!(oldJourneyMgmtTrackerList.isEmpty())){
                for(Journey_Management_Tracker__c journeyTracker:oldJourneyMgmtTrackerList){
                    if(journeyTracker.Active__c){
                        baselineJourneyTracker = new Baseline_Journey_Management_Tracker__c();
                        baselineJourneyTracker.Name = journeyTracker.Name;
                        baselineJourneyTracker.Section__c = journeyTracker.Section__c;
                        baselineJourneyTracker.Responsibility__c = journeyTracker.Responsibility__c;
                        baselineJourneyTracker.Milestone__c = journeyTracker.Milestone__c;
                        baselineJourneyTracker.Baseline_Mobilization_Plan__c = baselineMobId;
                        baselineJourneyTracker.Journey_Management_Tracker__c = journeyTracker.id;
                        baselineJourneyTracker.Start_Date__c = journeyTracker.Planned_End_Date__c;
                        baselineJourneyTracker.End_Date__c = journeyTracker.Planned_Start_Date__c;
                    
                        baselineJourneyMgmtList.add(baselineJourneyTracker); 
                    }    
                }
            }
            
            Database.insert(baselineJourneyMgmtList);
            
            List<Journey_Management_Tracker__c> journeyList = new List<Journey_Management_Tracker__c>();
            
            for(Baseline_Journey_Management_Tracker__c baselineJneyTracker:[select id,name,Baseline_Mobilization_Plan__c,Journey_Management_Tracker__c FROM Baseline_Journey_Management_Tracker__c WHERE Baseline_Mobilization_Plan__c = :baselineMobId LIMIT 2000]){
                
                Journey_Management_Tracker__c jmyTracker=journeyMap.get(baselineJneyTracker.Journey_Management_Tracker__c);
                jmyTracker.Baseline_Journey_Management_Tracker__c = baselineJneyTracker.id;
                /*
                if(checkForTracking){
                  jmyTracker.IsTrackingOn__c =true;
                }
                */
                journeyList.add(jmyTracker);
            }
            
            journeyList.addAll(inactiveJrnyList);
            Database.upsert(journeyList);
            
            return UtilConstants.SUCCESS_MESSAGE;
            
        }catch(Exception e){
            return UtilConstants.FAILURE_MESSAGE;
        }
        
    }
    
 
}