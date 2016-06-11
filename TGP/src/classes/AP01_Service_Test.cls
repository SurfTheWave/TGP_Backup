/*
@Author and Created Date : a.avdesh.sharma ,  1/17/2015 6:51 AM
@name : AP01_Service_Test
@Description : 
@Version : 
*/
@isTest
private class AP01_Service_Test{


        private static  Opportunity opp ;
        private static Tech_Tool_Master__c tecmaster;
        private static Solution_Scope__c solComp;
        private static Services_Master__c serviceMaster;
        private static Offering_Master__c offProc;
        
        private static  Offering_Name__c customSetting;
        private static Offering_Master__c offMaster;
        private static  final String IN_SCOPE='In Scope';
  //      UtilConstants uc = new UtilConstants();
       
      
        /******************************
    Method Name: AP01_ServiceTestMethod
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
        static testMethod void AP01_ServiceTestMethod(){
        Test.startTest();
        
      
   //     final String IN_SCOPE1='In Scope';
   //     UtilConstants uc1 = new UtilConstants();
        //New test Data setup()
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        database.insert( ogm);
        
        Opportunity opp1 = new Opportunity();
        opp1.Reporting_Status__c = UtilConstants.WON;
        opp1.Geo_Area__c = UtilConstants.EALA;
        opp1.OperatingGroup__c = ogm.id;
        opp1.StageName = UtilConstants.TWO_B;
        opp1.Risk_Level__c = UtilConstants.NORMAL;
        opp1.CloseDate = System.today();
        opp1.Name = UtilConstants.TEST_OPP;
        database.insert( opp1);
        
        Offering_Master__c  offProc1=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        database.insert( offProc1);
        
        Offering_Name__c customSetting1=UTIL_DataCreationForTestClass.getofferingCustom(offProc1.name,offProc1.id);
        database.insert( customSetting1);
        
        Offering_Master__c offMaster1 = new Offering_Master__c(Name = UtilConstants.HR,offering_description__c = UtilConstants.TEST_DESC,
        Service_Group__c=UtilCOnstants.IO,
        flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
        database.insert( offMaster1);
        
        Services_Master__c serviceMaster1 = new Services_Master__c(Name = UtilConstants.HRSERVICE, offering__c = offMaster1.id, active__c = True,
        Solution_Component__c = UtilConstants.DELIVERY);
        database.insert( serviceMaster1);
        
        Solution_Scope__c solComp1 = new Solution_Scope__c(Opportunity__c = opp1.id,Solution_Component__c = UtilConstants.DELIVERY, 
        Offering_Master__c = offMaster1.id, Service_Group__c = 'IO');
        database.insert( solComp1);
        
        List<Service__c> lstService1 = new List<Service__c>();
        lstService1 = [Select id,services__c,Solutionscope__c,Scope_Status__c from Service__c where Solutionscope__c =:solComp1.id Limit 1];
        lstService1[0].Scope_Status__c = IN_SCOPE;
        
        //Service__c serviceRec = new Service__c(Solutionscope__c = solComp1.id, Services__c = serviceMaster1.id);
        //lstService1.add(serviceRec);
        database.update( lstService1);
        
        List<Assumptions_Master__c> assmpMasList = new List<Assumptions_Master__c>();
        Assumptions_Master__c assmpMaster = new Assumptions_Master__c(Name = UtilConstants.TEST_ASSUMPTION,offering__c = offMaster1.id, 
        Service__c=serviceMaster1.id,active__c=true,assumption__c = UtilConstants.TEST_ASSUMPTION,
                                            category__c = UtilConstants.PEOPLE,classification__c = UtilConstants.INTERNAL);
        assmpMasList.add(assmpMaster);
        database.insert( assmpMasList);
        
        List<Opportunity_Assumption__c> oppAssumpList = new List<Opportunity_Assumption__c>();
        Opportunity_Assumption__c oppAssmp = new Opportunity_Assumption__c(Assumption__c = UtilConstants.ASSUMP_DESC,Category__c =UtilConstants.PEOPLE ,
                                            classification__c = UtilConstants.INTERNAL,Edited__c=false,
                                            Link_to_Master_Assumption__c = assmpMasList[0].id,Offering__c = solComp1.id,
                                            Service__c = lstService1[0].id);
        oppAssumpList.add(oppAssmp);
        database.insert( oppAssumpList);
        List<Client_Dependencies_Master__c> clientDepeMasList = new List<Client_Dependencies_Master__c>();
        Client_Dependencies_Master__c clientDepMaster = new Client_Dependencies_Master__c(Name = UtilConstants.CLIENT_DEP,offering__c = offMaster1.id
                                            ,Services_per_Offering__c=serviceMaster1.id, active__c=true, client_depedency__c = UtilConstants.TEST_CLIENT,
                                            category__c = UtilConstants.PEOPLE,classification__c = UtilConstants.INTERNAL);
        clientDepeMasList.add(clientDepMaster);
        database.insert( clientDepeMasList);
        
        Services_Component_Master__c servicesCompMaster = new Services_Component_Master__c(Name = 'test Service Component', service__c = serviceMaster1.Id, 
        active__c = True, service_component_description__c = 'test Service Comp Desc');
        database.insert( servicesCompMaster);
        /*
        List<Opportunity_Risks__c> oppRiskToInsertList = new List<Opportunity_Risks__c>();
        Opportunity_Risks__c oppRiskRec = new Opportunity_Risks__c(Offering__c = solComp1.Id);
        oppRiskToInsertList.add(oppRiskRec);
        insert oppRiskToInsertList;*/
        
       
        
     //   UTIL_ErrorConstants uEC = new UTIL_ErrorConstants();
        //Checking for sample testMetod to run.. test method call on createServiceCompRec..        
        AP01_Service.createServiceCompRec(lstService1); 
        //run on updateService() test..  
        AP01_Service.updateService(lstService1);
        //AP01_Service.createOppRiskRec(lstService1);
        
        AP01_Service.updateDeliverylocOnOpp(lstService1);
        
        AP01_Service.preventDuplicateService(lstService1);
        
        
        
        Test.stopTest();
    }
       
    /******************************
    Method Name: setupdata
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public static void setupdata(){
    try {
        
    Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
          ogm.Name = 'test name ogm';
          database.insert( ogm);
        
        opp = new Opportunity();
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        database.insert( opp);
        
        offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        database.insert( offProc);
        
        customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        database.insert( customSetting);
        
        offMaster = new Offering_Master__c(Name = UtilConstants.HR,offering_description__c = UtilConstants.TEST_DESC,Service_Group__c=UtilCOnstants.IO,
        flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
        database.insert( offMaster);
        
         
         serviceMaster = new Services_Master__c(Name = UtilConstants.HRSERVICE, offering__c = offProc.id, active__c = True,
         Solution_Component__c = UtilConstants.DELIVERY);
        database.insert( serviceMaster);
        
         solComp = new Solution_Scope__c(Opportunity__c = opp.id,Solution_Component__c = UtilConstants.DELIVERY, Offering_Master__c = offProc.id, 
         Service_Group__c = 'BPO');
        database.insert( solComp);
        
         tecmaster= new Tech_Tool_Master__c(Name='Tech1',Services__c=serviceMaster.id); 
        database.insert( tecmaster);
        }
        catch(exception e) {
        
        }
    }
    
     /******************************
    Method Name: AP01_ServiceTestInsert
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
     static testMethod void AP01_ServiceTestInsert(){
     setupdata();
          
        
     Offering_Master__c  offProc2=new Offering_Master__c(Name = 'Insurance',offering_description__c = UtilConstants.TEST_DESC,Service_Group__c=UtilCOnstants.IO,
        flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
        database.insert( offProc2);
         Services_Master__c   serviceMaster2 = new Services_Master__c(Name = 'Pensions - Accounting', offering__c = offProc2.id, active__c = True,
         Solution_Component__c = UtilConstants.DELIVERY);
        database.insert( serviceMaster2);
       
        Offering_Master__c  offProc3=new Offering_Master__c (Name = 'Health Administration' ,offering_description__c = UtilConstants.TEST_DESC,
        Service_Group__c=UtilCOnstants.IO,flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
        database.insert(offProc3);
        Services_Master__c   serviceMaster3 = new Services_Master__c(Name = 'Claims', offering__c = offProc3.id, active__c = True,
        Solution_Component__c = UtilConstants.DELIVERY);
        database.insert(serviceMaster3);
     Solution_Scope__c solComp2 = new Solution_Scope__c(Opportunity__c = opp.id,Solution_Component__c = UtilConstants.DELIVERY, 
     Offering_Master__c = offProc2.id, Service_Group__c = 'IO');
        database.insert(solComp2);
        Solution_Scope__c solComp3 = new Solution_Scope__c(Opportunity__c = opp.id,Solution_Component__c = UtilConstants.DELIVERY, 
        Offering_Master__c = offProc3.id, Service_Group__c = 'IC');
        database.insert(solComp3);
      List<Service__c> lstService=new List<Service__c> ();
        Service__c serviceRec = new Service__c(Solutionscope__c = solComp.id, Services__c = serviceMaster.id);
        Service__c serviceRecOne = new Service__c(Solutionscope__c = solComp2.id, Services__c = serviceMaster2.id);
        Service__c serviceRectwo = new Service__c(Solutionscope__c = solComp3.id, Services__c = serviceMaster3.id);
        lstService.add(serviceRec);
        lstService.add(serviceRecOne);
        lstService.add(serviceRectwo);
        Test.startTest();
        database.insert(lstService);
        Test.stopTest();
     }
     
      /******************************
    Method Name: AP01_ServiceTestDelete
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
      static testMethod void AP01_ServiceTestupdate(){
         setupdata();
        
       
        Service__c serviceRec = new Service__c(Solutionscope__c = solComp.id, Services__c = serviceMaster.id , Delivery_Locations__c='bangalore');
       
      
       
        database.insert(serviceRec);
        Test.startTest();
        serviceRec.Delivery_Locations__c='Pune';
        database.update(serviceRec);
        Test.stopTest();
     }
     
     /******************************
    Method Name: AP01_ServiceTestDelete
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
     static testMethod void AP01_ServiceTestdelete(){
     setupdata();
        List<Service__c> lstService1 = new List<Service__c>();
        Service__c serviceRec = new Service__c(Solutionscope__c = solComp.id, Services__c = serviceMaster.id);
        Service__c serviceRecOne = new Service__c(Solutionscope__c = solComp.id, Services__c = serviceMaster.id);
        lstService1.add(serviceRec);
        lstService1.add(serviceRecOne);
        database.insert(lstService1);
        Test.startTest();        
        database.delete(lstService1);
        Test.stopTest();
     }
      
     
     
     
     
}