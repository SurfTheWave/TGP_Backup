@isTest
private class MilestoneReportPageControllerTest{

     static Wave_Plan_Version__c wavePlanVersion;
     static Deal_TGP__c deal;
     static Business_Continuity_Planning__c bcpRec;
     static SRAT__c srat;
     static SRAT_VERSION__c sratversion;
     static Wave_Planning__c waveplan;
     static Deal_Location__c dealLoc;
     static OPEX__c opex;
     static Service_Management__c serMgmt;
     static KT_Planning__c kTPlan;
     static Recruitment_Tracking__c RecruitmentTracking;
     static Commercial_Planning__c comPlan;
     static Contract_Legal_Infosec__c strTechAssessment;
     static Tech_Assessment__c techAsess;
     static Journey_Management_Planning__c jourPlan;
     
     
     static void setupData()
     {
       
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        // To create a BCP record
        bcpRec=new Business_Continuity_Planning__c ();
        bcpRec.Wave_Plan_Version__c=wavePlanVersion.id;
        bcpRec.Active__c=true;
        bcpRec.Comments__c='test';
        bcpRec.Section_Number__c='2';
        bcpRec.Section_Name__c='test';
        bcpRec.Task_Name__c='test';
        bcpRec.Task_Number__c=3;
        bcpRec.Planned_End_Date__c=date.today()+7;
        bcpRec.Planned_Start_Date__c=date.today();
        bcpRec.Milestone__c = true;
        insert bcpRec;
        
        // To create a Deal Location
        dealLoc= new Deal_Location__c();
        dealLoc.Location__c='test Data';
        //dealLoc.Deal_Home_Location__c=dealHome.id;
        dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
        //dealLoc.Deployment_Lead__c=testUser.id;
        //dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
        //dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
        insert dealLoc;
        
        //To create a Wave Plan
        waveplan =new Wave_Planning__c();
        waveplan.Wave_Label__c='TestData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        //waveplan.KT_Lead__c=testUser.id;
        waveplan.Number_of_Projected_FTEs__c=1;
        waveplan.Deal_Location__c=dealLoc.id;
        insert waveplan;
        
        //To create SRAT Version

        sratversion=new SRAT_Version__c();
        sratversion.isActive__c=true;
        insert sratversion;
        
        //To create SRAT

        srat=new SRAT__c();
        srat.Wave_Plan_Version__c=wavePlanVersion.id;
        srat.SRAT_Version__c=sratversion.id;
        srat.name='Test Data';
        srat.Planned_Date__c=date.today();
        srat.Deal_Location_lk__c=dealLoc.id;
        srat.Wave_Plan_lk__c=waveplan.id;
        srat.Milestone__c = true;
        insert srat;
        
        opex =new OPEX__c();
        opex.Deal_Location_lk__c=deal.id;
        opex.Wave_Plan_lk__c=waveplan.id;
        opex.Item__c='Day 30 Assessment';
        opex.Active__c=true;
        opex.Planned_Date__c=date.today();
        opex.Deal_Location__c='India';
        opex.Deal_Location_lk__c=dealLoc.id;
        opex.Wave_Plan_Version__c=wavePlanVersion.id;
        opex.Milestone__c = true;
        insert opex; 
        
        // To create Service Management

        serMgmt=new Service_Management__c();
        serMgmt.Name='TestData';
        serMgmt.Activity__c='TestData';
        serMgmt.Planned_Start_Date__c=date.today();
        serMgmt.Planned_End_Date__c=date.today()+7;
        serMgmt.Wave_Plan_lk__c=waveplan.id;
        serMgmt.Phase_Name__c='Test';
        serMgmt.Phase_Number__c=19;
        serMgmt.Task_Name__c='Test';
        serMgmt.Task_Number__c=19;
        serMgmt.Milestone__c = true;
        serMgmt.Wave_Plan_Version__c = wavePlanVersion.id;
        insert serMgmt; 
        
        //To create a Contract Legal Infosec record
      
        kTPlan=new KT_Planning__c();
        
        kTPlan.Activity__c='TestData';
        kTPlan.Planned_Start_Date__c=date.today();
        kTPlan.Planned_End_Date__c=date.today()+7;
        kTPlan.Wave_Plan_lk__c=waveplan.id;
        kTPlan.Deal_Location_lk__c=dealLoc.id;
        kTPlan.Comments__c=null;
        kTPlan.Wave_Plan_Version__c = wavePlanVersion.id;
        kTPlan.Milestone__c = true;
        insert kTPlan;
        
        //To create a Recruitment tracking Plan record
      
        RecruitmentTracking=new Recruitment_Tracking__c();
        RecruitmentTracking.Name='TestRecruitmentData';
        RecruitmentTracking.Activity__c='TestActData';
        RecruitmentTracking.Planned_Start_Date__c=date.today();
        RecruitmentTracking.Planned_End_Date__c=date.today()+7;
        RecruitmentTracking.Wave_Plan_lk__c=waveplan.id;
        RecruitmentTracking.Deal_Location_lk__c=dealLoc.id;
        RecruitmentTracking.FTE_Number__c=11;
        RecruitmentTracking.Wave_Plan_Version__c=wavePlanVersion.id;
        RecruitmentTracking.Milestone__c = true;
        insert RecruitmentTracking;
        
        // To Create Commercial Planning
        comPlan = new Commercial_Planning__c();
        comPlan.Name='TestData';
        comPlan.Activity__c='TestData';
        //comPlan.Delivery_Location__c=deliveryLocMa.id;
        comPlan.Planned_Start_Date__c=date.today();
        comPlan.Planned_End_Date__c=date.today()+7;
        comPlan.Wave_Plan_Version__c=wavePlanVersion.id;
        comPlan.Milestone__c = true;
        insert comPlan;
        
        // To create a tech assessment plan
        strTechAssessment=new Contract_Legal_Infosec__c(Name='TestKT', Planed_Start_Date__c=System.today()+1, Planned_End_Date__c=System.today()+2, 
        Deal_Location_lk__c=dealLoc.id, Wave_Plan_lk__c=waveplan.id,Milestone__c = true,Active__c=true, Activity__c='TestActivity', Wave_Plan_Version__c=WavePlanVersion.id);
        insert strTechAssessment;
        
        //To create a Tech Asessment record
        techAsess=new Tech_Assessment__c();
        techAsess.Name='TestData';
        techAsess.Activity__c='TestData';
        techAsess.Planned_Start_Date__c=date.today();
        techAsess.Planned_End_Date__c=date.today()+7;
        techAsess.Wave_Plan_lk__c=waveplan.id;
        techAsess.Deal_Location_lk__c=dealLoc.id;
        techAsess.comments__c ='test';
        techAsess.Wave_Plan_Version__c=wavePlanVersion.id;
        techAsess.Milestone__c = true;
        insert techAsess; 
        
        // record creation for journey management plan 
         jourPlan = new Journey_Management_Planning__c();
         jourPlan.Active__c=true;
         jourPlan.Comments__c='test comment';
         jourPlan.Planned_End_Date__c=date.today()+7;
         jourPlan.Planned_Start_Date__c=date.today();
         jourPlan.Responsibility__c='client';
         jourPlan.Wave_Plan_Version__c=wavePlanVersion.id;
         jourPlan.Section_Number__c='2';
         jourPlan.Section_Name__c='test';
         jourPlan.Milestone__c = true;
         //jourPlan.Journey_Management_Deliverable_Id__c=joumandel.id; 
         insert jourPlan;
        
    }
        
        

    static testMethod void testMilestoneReportPageController() 
    {
            setupData();
            ApexPages.StandardController sc = new ApexPages.StandardController(wavePlanVersion);
            apexpages.currentpage().getparameters().put(UTIL_Constants.URL_PARAMETER_ID ,wavePlanVersion.id); 
            MilestoneReportPageController obj = new MilestoneReportPageController(sc);
            //obj.exporttoExcel();
            
    }
}