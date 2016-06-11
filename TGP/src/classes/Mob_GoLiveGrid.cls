public class Mob_GoLiveGrid
{
    
    public static void addLocation(List<Deal_Home_Location__c> OrgDealHomeLocation)
    {
        List<Deal_Location__c> lstJourney = new List<Deal_Location__c>();
        String dealName ;
        List<Deal_Home_Location__c> dealHomeLocation = new List<Deal_Home_Location__c>();
        List<Deal_Home_Location__c> lstDealHomeLocation = new List<Deal_Home_Location__c>();
        
        
        if(OrgDealHomeLocation.size()>0)
        {
          dealName= OrgDealHomeLocation[0].Deal__c;
        }
        
        List<wave_plan_version__c> lstDeal = [select deal__c,Cloned_From__c,Active__c from wave_plan_version__c where Active__c =: true AND deal__c =: dealName];
        if(lstDeal.size()>0) 
        { 
            Wave_Plan_Version__c wavePlanVersion = lstDeal.get(0);
            List<Deal_Location__c> lstJourney1 = [Select Deal_Home_Location__c,NewActive__c from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersion.Id];
            lstDealHomeLocation = [select id,name,Active__c from Deal_Home_Location__c where Deal__c=:dealName AND Active__c =: true AND Id NOT IN (Select Deal_Home_Location__c from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersion.Id)];
            dealHomeLocation = [select id,name,Active__c from Deal_Home_Location__c where Deal__c=:dealName AND Id IN (Select Deal_Home_Location__c from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersion.Id)];
                                   
            Deal_Location__c journey;
                                                                                                       
                    if(wavePlanVersion.active__c==true)
                    {                                                  
                         if(lstDealHomeLocation.size()>0 )
                         {
                             for( Deal_Home_Location__c tempDeal : lstDealHomeLocation)
                             {                                              
                                 journey = new Deal_Location__c();
                                     journey.Wave_Plan_Version__c=wavePlanVersion.Id;
                                     journey.Deal_Home_Location__c=tempDeal.id;
                                 lstJourney.add(journey);
                             }
                             upsert lstJourney;
                         }   
                                                                                                            
                         if(dealHomeLocation.size()>0 && lstDealHomeLocation.size() ==0)
                         {
                            for(Deal_Home_Location__c tempHome : dealHomeLocation)
                            {
                                for (Deal_Location__c tempLoc : lstJourney1)
                                {
                                    if(tempLoc.Deal_Home_Location__c == tempHome.id && tempLoc.NewActive__c == true && tempHome.Active__c == false)
                                    {
                                        tempLoc.NewActive__c = false;
                                    }
                                    else if(tempLoc.Deal_Home_Location__c == tempHome.id && tempLoc.NewActive__c == false && tempHome.Active__c == true)
                                    {
                                        tempLoc.NewActive__c = true;
                                    }
                                }
                            }
                            upsert lstJourney1;
                           disableHighLevelPlans(wavePlanVersion.Id);
                           enableHighLevelPlans(wavePlanVersion.Id);
                        }
                    }
        }
    }
    
    public static void disableHighLevelPlans(String wpvId)
    {
        List<Deal_Location__c> lstJourney1 = [Select Deal_Home_Location__c,NewActive__c from Deal_Location__c where Wave_Plan_Version__c=:wpvId AND NewActive__c =: false];
        List<Wave_Planning__c> lstWavePlan = [Select Wave_Label__c,GO_Live_Date_del__c,Number_of_Projected_FTEs__c,Active__c,NewActive__c,Deal_Location__c,isEditVisible__c from Wave_Planning__c where Deal_Location__c IN (Select Id from Deal_Location__c where Wave_Plan_Version__c=: wpvId AND NewActive__c =: false)];
        
        for(Wave_Planning__c temp : lstWavePlan)
        {
            if(lstWavePlan.size() > 0)
            {
                temp.NewActive__c = false;
                temp.isEditVisible__c = false;
            }
        }
        upsert lstWavePlan;
        
        List<SRAT__c> templstSrat=new list<SRAT__c>();
        List<OPEX__c> templstOpex=new List<OPEX__c>();
        List <KT_Planning__c> templstKtPlanning= new List <KT_Planning__c>();
        List<Recruitment_Tracking__c> templstRecruitment=new List<Recruitment_Tracking__c>();
        List<Contract_Legal_Infosec__c> templstContract=new List<Contract_Legal_Infosec__c>();
        List<Tech_Assessment__c> templstTech=new List<Tech_Assessment__c>();
        
        List<SRAT__c> lstSrat=[Select id,Active__c,Item__c,Wave_Plan_lk__c,isEditVisible__c,Milestone__c  from SRAT__c where 
                                        Wave_Plan_Version__c=:wpvId order by createddate desc];
                                    
        List<OPEX__c> lstOpex=[Select id,Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c  from OPEX__c where 
                                        Wave_Plan_Version__c=:wpvId order by createddate desc];                    
                
        List <KT_Planning__c> lstKtPlanning=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c  from KT_Planning__c where 
                                                        Wave_Plan_Version__c=:wpvId order by createddate desc]; 
            
        List<Recruitment_Tracking__c> lstRecruitmentTracking=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c from Recruitment_Tracking__c where 
                                                                    Wave_Plan_Version__c=:wpvId order by createddate desc];
            
        List<Contract_Legal_Infosec__c> lstContractLegalInfosec =[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c  from Contract_Legal_Infosec__c where 
                                                                        Wave_Plan_Version__c=:wpvId order by createddate desc];    
            
        List<Tech_Assessment__c> lstTechAssessment=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c  from Tech_Assessment__c where 
                                                            Wave_Plan_Version__c=:wpvId order by createddate desc];
                                                            
                    
        
        for(Wave_Planning__c temp1 : lstWavePlan)
        {
                if((lstWavePlan.size() > 0))
                {
                    if(temp1.NewActive__c==false && temp1.isEditVisible__c==false)
                        {
                            if(lstSrat.size()>0)
                            {
                                for(SRAT__c s : lstSrat)
                                {
                                    if(s.Wave_Plan_lk__c== temp1.id)
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
                                    if(o.Wave_Plan_lk__c== temp1.id)
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
                                    if(k.Wave_Plan_lk__c== temp1.id)
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
                                    if(r.Wave_Plan_lk__c== temp1.id)
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
                                    if(con.Wave_Plan_lk__c== temp1.id)
                                    {
                                        con.Active__c=false;
                                        con.isEditVisible__c=false;
                                        //con.Milestone__c=false;
                                        templstContract.add(con);
                                    }
                                }
                            }
                            
                            if(lstTechAssessment.size()>0)
                            {
                                for(Tech_Assessment__c t : lstTechAssessment)
                                {
                                    if(t.Wave_Plan_lk__c== temp1.id)
                                    {
                                        t.Active__c=false;
                                        t.Milestone__c=false;
                                        t.isEditVisible__c=false;
                                        templstTech.add(t);
                                    }
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
        
        public static void enableHighLevelPlans(String wpvId)
        {
        List<Deal_Location__c> lstJourney1 = [Select Deal_Home_Location__c,NewActive__c from Deal_Location__c where Wave_Plan_Version__c=:wpvId AND NewActive__c =: true];
        List<Wave_Planning__c> lstWavePlan = [Select Wave_Label__c,GO_Live_Date_del__c,Number_of_Projected_FTEs__c,Active__c,NewActive__c,Deal_Location__c,isEditVisible__c from Wave_Planning__c where Deal_Location__c IN (Select Id from Deal_Location__c where Wave_Plan_Version__c=: wpvId AND NewActive__c =: true)];
        
        for(Wave_Planning__c temp : lstWavePlan)
        {
            if(lstWavePlan.size() > 0)
            {
                temp.NewActive__c = true;
                temp.isEditVisible__c = true;
            }
        }
        upsert lstWavePlan;
        
        List<SRAT__c> templstSrat=new list<SRAT__c>();
        List<OPEX__c> templstOpex=new List<OPEX__c>();
        List <KT_Planning__c> templstKtPlanning= new List <KT_Planning__c>();
        List<Recruitment_Tracking__c> templstRecruitment=new List<Recruitment_Tracking__c>();
        List<Contract_Legal_Infosec__c> templstContract=new List<Contract_Legal_Infosec__c>();
        List<Tech_Assessment__c> templstTech=new List<Tech_Assessment__c>();
        
        List<SRAT__c> lstSrat=[Select id,Active__c,Item__c,Wave_Plan_lk__c,isEditVisible__c,Milestone__c from SRAT__c where 
                                        Wave_Plan_Version__c=:wpvId order by createddate desc];
                                    
        List<OPEX__c> lstOpex=[Select id,Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from OPEX__c where 
                                        Wave_Plan_Version__c=:wpvId order by createddate desc];                    
                
        List <KT_Planning__c> lstKtPlanning=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from KT_Planning__c where 
                                                        Wave_Plan_Version__c=:wpvId order by createddate desc]; 
            
        List<Recruitment_Tracking__c> lstRecruitmentTracking=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from Recruitment_Tracking__c where 
                                                                    Wave_Plan_Version__c=:wpvId order by createddate desc];
            
        List<Contract_Legal_Infosec__c> lstContractLegalInfosec =[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from Contract_Legal_Infosec__c where 
                                                                        Wave_Plan_Version__c=:wpvId order by createddate desc];    
            
        List<Tech_Assessment__c> lstTechAssessment=[Select id, Active__c, Wave_Plan_lk__c,isEditVisible__c,Milestone__c from Tech_Assessment__c where 
                                                            Wave_Plan_Version__c=:wpvId order by createddate desc];
        
        for(Wave_Planning__c temp1 : lstWavePlan)
        {                                                                   
                if((lstWavePlan.size() > 0))
                {
                    if(temp1.NewActive__c==true && temp1.isEditVisible__c==true)
                        {
                            if(lstSrat.size()>0)
                            {
                                for(SRAT__c s : lstSrat)
                                {
                                    if(s.Wave_Plan_lk__c== temp1.id)
                                    {
                                        s.isEditVisible__c=true;
                                        s.active__c=true;
                                        s.Milestone__c=true;
                                        templstSrat.add(s);
                                    }
                                }
                            }
                            
                            if(lstOpex.size()>0)
                            {
                                for(OPEX__c o : lstOpex)
                                {
                                    if(o.Wave_Plan_lk__c== temp1.id)
                                    {
                                        o.isEditVisible__c=true;
                                        o.active__c=true;
                                        o.Milestone__c=true;
                                        templstOpex.add(o);
                                    }
                                }
                            }
                            
                            if(lstKtPlanning.size()>0)
                            {
                                for(KT_Planning__c k : lstKtPlanning)
                                {
                                    if(k.Wave_Plan_lk__c== temp1.id)
                                    {
                                        k.isEditVisible__c=true;
                                        k.active__c=true;
                                        k.Milestone__c=true;
                                        templstKtPlanning.add(k);
                                    }
                                }
                            }
                            
                            if(lstRecruitmentTracking.size()>0)
                            {
                                for(Recruitment_Tracking__c r : lstRecruitmentTracking)
                                {
                                    if(r.Wave_Plan_lk__c== temp1.id)
                                    {
                                        r.isEditVisible__c=true;
                                        r.active__c=true;
                                        r.Milestone__c=true;
                                        templstRecruitment.add(r);
                                    }
                                }
                            }
                            
                            if(lstContractLegalInfosec.size()>0)
                            {
                                for(Contract_Legal_Infosec__c con : lstContractLegalInfosec )
                                {
                                    if(con.Wave_Plan_lk__c== temp1.id)
                                    {
                                        con.Active__c=true;
                                        //con.Milestone__c=true;
                                        con.isEditVisible__c=true;
                                        templstContract.add(con);
                                    }
                                }
                            }
                            
                            if(lstTechAssessment.size()>0)
                            {
                                for(Tech_Assessment__c t : lstTechAssessment)
                                {
                                    if(t.Wave_Plan_lk__c== temp1.id)
                                    {
                                        t.Active__c=true;
                                        t.Milestone__c=true;
                                        t.isEditVisible__c=true;
                                        templstTech.add(t);
                                    }
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